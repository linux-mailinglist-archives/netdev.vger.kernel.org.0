Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64601345BC3
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCWKPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:15:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhCWKP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 06:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616494529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33TioYNXdkIK41LK1fNmqaU/cASsOPpzjkwj2vLLbAI=;
        b=dASDQROYdzZ3Krjagc30uU9yswHgtIlAbEFkN3wI5Mwe747Av1kUQBbmVWiPEVTOuyFp1e
        bALW1z2apN0A3GcQbY2ydZdVBJv+VrVMmF9zwG6FEVq2VaiQjAKnCoBUg9hvfFn/D1iyqZ
        gUpcLMDt+cgbSluO934+Sd0rTli2rQc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-3_QfbEMyO_WUE7rAomHs1g-1; Tue, 23 Mar 2021 06:15:25 -0400
X-MC-Unique: 3_QfbEMyO_WUE7rAomHs1g-1
Received: by mail-ej1-f70.google.com with SMTP id rl7so828898ejb.16
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 03:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=33TioYNXdkIK41LK1fNmqaU/cASsOPpzjkwj2vLLbAI=;
        b=W0WFm1cR1bOjP/CSVcNDEgvLhtXKXbKrxrPdzt430kQ5g+hWuPQPCfy707fdw6gKeV
         VgDSGOX+ab223nI9ZgdJ+UGwun25Mpxlyz+/s7EIdgzSuMMUUxYbL4zGhc4fXoPljpSV
         89fRHZDesonKzjTS7bwg9yGAgiJUefpIqs+xa4SpY4MaXlKBiPGK34+TDeJ68K9vXHpT
         li2/EUOOtxK8h8a0qjOhM0AxBJg/MM2yCQioMA37plYG1kt3mLGqKriyiD9TaYsbfhH9
         vdyw8DxFwQ/evDBAyaih9Lhp6tZGYEWjnjcL0yKfE/FD+Ye2Q+MQUnPzDfDtB+uD+UGQ
         Tv6A==
X-Gm-Message-State: AOAM53320VYjLJSE8V+sEerapjyj6Um5gKLm41BRrxotKeE0ff0I3XY6
        mtT168cw0l6+wHn0OCFIEK+64b+ZFm/x3mw1YDJ9ZJTUSInud+6lZEzWwpseCX97RQdCUWI0vnF
        FMeLRf/f0K6R9cRQG
X-Received: by 2002:a17:907:f97:: with SMTP id kb23mr4109463ejc.33.1616494524398;
        Tue, 23 Mar 2021 03:15:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0ymyHSvddRqzkPHV01ILJ3coO7Gvl87MnOKtrp41zFNmRBCiHAagyP6FAX/LMp5E2mVhBQg==
X-Received: by 2002:a17:907:f97:: with SMTP id kb23mr4109443ejc.33.1616494524249;
        Tue, 23 Mar 2021 03:15:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id wr20sm6751072ejb.111.2021.03.23.03.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 03:15:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0CF0E180281; Tue, 23 Mar 2021 11:15:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCHv2 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210323024923.GD2900@Leo-laptop-t470s>
References: <20210309101321.2138655-1-liuhangbin@gmail.com>
 <20210309101321.2138655-3-liuhangbin@gmail.com> <87r1kec7ih.fsf@toke.dk>
 <20210318035200.GB2900@Leo-laptop-t470s> <875z1oczng.fsf@toke.dk>
 <20210323024923.GD2900@Leo-laptop-t470s>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 23 Mar 2021 11:15:22 +0100
Message-ID: <87lfae6urp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Thu, Mar 18, 2021 at 03:19:47PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Hangbin Liu <liuhangbin@gmail.com> writes:
>>=20
>> > On Wed, Mar 17, 2021 at 01:03:02PM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> FYI, this no longer applies to bpf-next due to Bj=C3=B6rn's refactor =
in
>> >> commit: ee75aef23afe ("bpf, xdp: Restructure redirect actions")
>> >
>> > Thanks Toke, I need to see how to get the map via map_id, does
>> > bpf_map_get_curr_or_next() works? Should I call bpf_map_put() after
>> > using?
>>=20
>> I would expect that to be terrible for performance; I think it would be
>> better to just add back the map pointer into struct bpf_redirect_info.
>> If you only set the map pointer when the multicast flag is set, you can
>> just check that pointer to disambiguate between when you need to call
>> dev_map_enqueue() and dev_map_enqueue_multi(), in which case you don't
>> need to add back the flags member...
>
> There are 2 flags, BROADCAST and EXCLUDE_INGRESS. There is no way
> to only check the map pointer and ignore flags..

Ah, right, of course, my bad :)

Well, in that case adding both members back is probably the right thing
to do...

-Toke

