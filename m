Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD793B1847
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 12:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFWK6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 06:58:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230071AbhFWK6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 06:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624445763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l0rnZYZLTgGGB4O4LME1I6ADl2UwNN76Ezwf4qF0mCI=;
        b=DsyzBKNJ2sP5nTVrHtCsesMh18YkG/3Q4T71ltZQEUpnRmZSWDgZbKskWgKled4Is4ZrVw
        1guLcqWBcNyYZzpzpE2BQmEoLS6TXcvFTbRLrKvWqm3oHK/iNJHbQs26r7A0PmwCIKP+j+
        q4R1UZLQ4/0sZCCAk63LnJTU/Ui1H+8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-3CH_IGYvMOSb4VqsM5pcOA-1; Wed, 23 Jun 2021 06:55:59 -0400
X-MC-Unique: 3CH_IGYvMOSb4VqsM5pcOA-1
Received: by mail-ej1-f69.google.com with SMTP id jw19-20020a17090776b3b0290481592f1fc4so842296ejc.2
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 03:55:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=l0rnZYZLTgGGB4O4LME1I6ADl2UwNN76Ezwf4qF0mCI=;
        b=A+Coc9kgSE7Fc+EOHRvqaDaHMMfQZlQXq+ymNGluN9xWEKCE2E/AoeCr2Nm7sSBq4i
         cJIhl1+S5bbUiHjvIGI2Kh7Cq9CLbA09kx9Kj4KJ9semFvScHyAMRcOVxxmbK1DBQv8i
         zD9KuFCcUFhmGAjb1l/qLde9qsav+lEQAWbcwEk0T9oSQ+tRhFFxJfgYbraNDUFWLO0P
         vdZpVeOFYBIWaaUr9l8ucLAEfTA1/CcVYziTjSMajrJRidKEhl2+/6jNXBS6QczITyQF
         LEwqj18CvwPeaipUVZxYSiAxBsTZ4aDvoTlSJVFSK9kfM4riPJBjhgzKOU7XIkCEi26k
         ixKw==
X-Gm-Message-State: AOAM531LRd42FJvm4OsphmSXurwUhwbIWtQOsEghwIcEGlbtn19e5p/Q
        ZEFXC5w0lqBewyX3sS53n0XFnklsJ/jtvSZebyt847gkI2wjilpNoeePz98VrP7UrRuVXpoKiBV
        iCVTWVoDd51+bcEl4
X-Received: by 2002:a05:6402:1d55:: with SMTP id dz21mr4598487edb.338.1624445758488;
        Wed, 23 Jun 2021 03:55:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl/daCOipGRoHNcu5HqM7PZSYLBKhJx+6m3jGMZC6YVrEBrzMUhI1Tf/lrymqJ58SdU1r77w==
X-Received: by 2002:a05:6402:1d55:: with SMTP id dz21mr4598464edb.338.1624445758192;
        Wed, 23 Jun 2021 03:55:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u22sm13518224edr.11.2021.06.23.03.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 03:55:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A4162180730; Wed, 23 Jun 2021 12:55:55 +0200 (CEST)
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
In-Reply-To: <20210622231950.GK4397@paulmck-ThinkPad-P17-Gen-1>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
 <87zgvirj6g.fsf@toke.dk> <87r1guovg2.fsf@toke.dk>
 <20210622202604.GH4397@paulmck-ThinkPad-P17-Gen-1>
 <874kdppo45.fsf@toke.dk>
 <20210622231950.GK4397@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Jun 2021 12:55:55 +0200
Message-ID: <87eecsonno.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Tue, Jun 22, 2021 at 11:48:26PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> "Paul E. McKenney" <paulmck@kernel.org> writes:
>>=20
>> > On Tue, Jun 22, 2021 at 03:55:25PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>> >>=20
>> >> >> It would also be great if this scenario in general could be placed
>> >> >> under the Documentation/RCU/whatisRCU.rst as an example, so we cou=
ld
>> >> >> refer to the official doc on this, too, if Paul is good with this.
>> >> >
>> >> > I'll take a look and see if I can find a way to fit it in there...
>> >>=20
>> >> OK, I poked around in Documentation/RCU and decided that the most
>> >> natural place to put this was in checklist.rst which already talks ab=
out
>> >> local_bh_disable(), but a bit differently. Fixing that up to correspo=
nd
>> >> to what we've been discussing in this thread, and adding a mention of
>> >> XDP as a usage example, results in the patch below.
>> >>=20
>> >> Paul, WDYT?
>> >
>> > I think that my original paragraph needed to have been updated back
>> > when v4.20 came out.  And again when RCU Tasks Trace came out.  ;-)
>> >
>> > So I did that updating, then approximated your patch on top of it,
>> > as shown below.  Does this work for you?
>>=20
>> Yup, LGTM, thanks! Shall I just fold that version into the next version
>> of my series, or do you want to take it through your tree (I suppose
>> it's independent of the rest, so either way is fine by me)?
>
> I currently have the two here in -rcu, most likely for v5.15 (as in
> the merge window after the upcoming one):
>
> 2b7cb9d95ba4 ("doc: Clarify and expand RCU updaters and corresponding rea=
ders")
> c6ef58907d22 ("doc: Give XDP as example of non-obvious RCU reader/updater=
 pairing")
>
> I am happy taking it, but if you really would like to add it to your
> series, please do take both.  ;-)

Alright, I'll fold both in to v4 :)

-Toke

