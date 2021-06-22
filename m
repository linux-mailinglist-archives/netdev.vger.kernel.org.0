Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFC13B0FF8
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFVWUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:20:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhFVWUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624400286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVjhLDtJhsrPmwpZ576YLQgGs/VGWOCyo3tFRjK1wVc=;
        b=SpKp68FwvHgq4oKkmBfShZA21cQpztV0vv4HckONeY28jsdxfH3Ax08ibqLEzFBq1331on
        XfxkNUcAVknmxEqMK5wkoFChSbv1FMKektXh3ayUCGrecGhi9aD9yhuPM/P5UZme5n+iZB
        vUE0dUwPX6WQahoLwRazQDlbOq7QcRI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-zvJK15AYPq68qw2NE-5lkg-1; Tue, 22 Jun 2021 18:18:05 -0400
X-MC-Unique: zvJK15AYPq68qw2NE-5lkg-1
Received: by mail-wr1-f69.google.com with SMTP id u16-20020a5d51500000b029011a6a17cf62so146960wrt.13
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 15:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=uVjhLDtJhsrPmwpZ576YLQgGs/VGWOCyo3tFRjK1wVc=;
        b=g8GqJVX6+rGk++vfpILb+dn+x8y0JGVEui4sRaGBpM2Hv3BY6fbqVTlfpEXFveILyJ
         kX7YCdqvaOJY1lEgAQjjsn2j1lht8tJcUqd3HIeRcrtswJXrOkVcIzlBeC9YmG9ae7qE
         2faJpuWFQQIMQuZ/n6ep0T4bTET449LzVW8n0TKZMz1vHk155aJUZ8zVydUQ5GoJNmw8
         1xHLb1gkK7B9sQmoWNXbJPtRpIM58Ebm9+BXmRKJLC9pCLVKvObx838a+MMXgCKfd57R
         qrDdLGU8kD8lsMDBsuoaJvG086mT4itnHV3N+Hkk8GZmHgot2gEGdqSzi8aQ+AVCr21j
         erag==
X-Gm-Message-State: AOAM533da2uRQ/B3msBHYxLktfydVcbtl6JCJW1gYSMAdHngsLcAiFfS
        wEFKM4bJa2uWuNmkBUzSMyO/RrtzG5Gb/hnSV/C11qQLMAnueVzvEPPrgt91NfQ6aS26sojTfyV
        Tilwh53RuiSs21I5y
X-Received: by 2002:a17:907:62a5:: with SMTP id nd37mr6232985ejc.148.1624398507924;
        Tue, 22 Jun 2021 14:48:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJYc4EPMTh0Uqt1cLxNZiku3xd51dHPTQpEsvO1j5WnZ7aApODp+VBuPPzksxLysFyRy9DeA==
X-Received: by 2002:a17:907:62a5:: with SMTP id nd37mr6232977ejc.148.1624398507771;
        Tue, 22 Jun 2021 14:48:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e6sm12947248edk.63.2021.06.22.14.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:48:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BCF71180730; Tue, 22 Jun 2021 23:48:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     paulmck@kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
In-Reply-To: <20210622202604.GH4397@paulmck-ThinkPad-P17-Gen-1>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
 <87zgvirj6g.fsf@toke.dk> <87r1guovg2.fsf@toke.dk>
 <20210622202604.GH4397@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Jun 2021 23:48:26 +0200
Message-ID: <874kdppo45.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Tue, Jun 22, 2021 at 03:55:25PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>>=20
>> >> It would also be great if this scenario in general could be placed
>> >> under the Documentation/RCU/whatisRCU.rst as an example, so we could
>> >> refer to the official doc on this, too, if Paul is good with this.
>> >
>> > I'll take a look and see if I can find a way to fit it in there...
>>=20
>> OK, I poked around in Documentation/RCU and decided that the most
>> natural place to put this was in checklist.rst which already talks about
>> local_bh_disable(), but a bit differently. Fixing that up to correspond
>> to what we've been discussing in this thread, and adding a mention of
>> XDP as a usage example, results in the patch below.
>>=20
>> Paul, WDYT?
>
> I think that my original paragraph needed to have been updated back
> when v4.20 came out.  And again when RCU Tasks Trace came out.  ;-)
>
> So I did that updating, then approximated your patch on top of it,
> as shown below.  Does this work for you?

Yup, LGTM, thanks! Shall I just fold that version into the next version
of my series, or do you want to take it through your tree (I suppose
it's independent of the rest, so either way is fine by me)?

-Toke

