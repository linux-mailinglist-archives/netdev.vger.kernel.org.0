Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A1F10C162
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 02:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfK1B05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 20:26:57 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34908 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfK1B04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 20:26:56 -0500
Received: by mail-qk1-f195.google.com with SMTP id v23so13529564qkg.2;
        Wed, 27 Nov 2019 17:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=v8LU2xOwjieQDa2R6tGnD5twL2ibcfNQBKehMMo1pOM=;
        b=p836t4C/Mb+9Qvhxsav8CCyUyHlm3wBMtfPfrn7bYMeeIejCGlv2YUMbpMA0MK1L/+
         VXLxbYJ1NRwLdz4WkoVp/VfhBcqoiVEyHiO7HWdo6shS9Tl5xZzi0OMXtAc3vfX8T99h
         M5iouGVNciEqs7b5tcU+peOjlNwiRSnt8kZXmpIwK0Ur818WjukKiDKLjldfYPg+FV72
         xwAZ6ZIEcbcyos8SKyHW7pFoJFtzmgL1p8HGIUpHLHd2dqkmRjrT1TmtSvbIT80C2myy
         ArzTiwQSWj70wXmczp2vX7IPGgt7mx746sp/kEm5s0K2x9XVmeuEHXoYAcAEChc6dcfN
         PmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=v8LU2xOwjieQDa2R6tGnD5twL2ibcfNQBKehMMo1pOM=;
        b=SjPM2F7Q+zOq9wFKOTsQwHw6zlo9qWtMowfHTpHokZzg7FB3qbQfAIqVb//vi0hyfp
         i9+WWPFndCBxGyNPNUFdJ2sVh0qVAa2DF0vnYtRtnvRJ7UdYpoPOTRjRm1sTnDtZNRe/
         3icA/6Xdz17fB5QUfPZemWwMutbzL8U7yRkLg0Yf9pXmFqFXg8i8VEyAEtOBz2aloyuR
         gdXA1O5TjFsu2SOMOA+xJ/2kgF1P1yxMU8LGVaAkxXx6r4z0L/6kM9yrbN5NKxcFRWJW
         9CxpXTwNiqhvCiCIdQn4OpDqptDokcpnRVSNN1B/Nci54iDOFFmDpOfwzwMm2aDl7azw
         v4rA==
X-Gm-Message-State: APjAAAX7kGd00KlJt6D+7hwSiuM0HiASiGUWslCHKonFJw5J2fL3WddM
        87g5D0zkwez6hZRK5qsabLk=
X-Google-Smtp-Source: APXvYqxB/VbbPWmpBnSxp8Xt72z5BjnOGfBI/88tlr4XpstuxJxLusLIEXERyHyxku4qUIZyCYEegw==
X-Received: by 2002:a37:b12:: with SMTP id 18mr7235035qkl.387.1574904413916;
        Wed, 27 Nov 2019 17:26:53 -0800 (PST)
Received: from [192.168.86.249] ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id o33sm9020218qta.27.2019.11.27.17.26.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 17:26:53 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Wed, 27 Nov 2019 22:27:31 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <CAADnVQLFVH000BJM4cN29kcC+KKDmVek3jaen3cZz2=12jP58g@mail.gmail.com>
References: <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org> <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org> <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com> <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org> <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com> <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com> <20191127013901.GE29071@kernel.org> <CAADnVQJCMpke49NNzy33EKdwpW+SY1orTm+0f0b-JuW8+uA7Yw@mail.gmail.com> <2993CDB0-8D4D-4A0C-9DB2-8FDD1A0538AB@kernel.org> <CAADnVQJc2cBU2jWmtbe5mNjWsE67DvunhubqJWWG_gaQc3p=Aw@mail.gmail.com> <58CA150B-D006-48DF-A279-077BA2FFD6EC@kernel.org> <CAADnVQLFVH000BJM4cN29kcC+KKDmVek3jaen3cZz2=12jP58g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <D93F5A0F-7675-4A66-B90A-C6091F995BE5@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On November 27, 2019 10:20:17 PM GMT-03:00, Alexei Starovoitov <alexei=2Est=
arovoitov@gmail=2Ecom> wrote:
>On Wed, Nov 27, 2019 at 5:17 PM Arnaldo Carvalho de Melo
><arnaldo=2Emelo@gmail=2Ecom> wrote:
>>
>> On November 27, 2019 9:59:15 PM GMT-03:00, Alexei Starovoitov
><alexei=2Estarovoitov@gmail=2Ecom> wrote:
>> >On Wed, Nov 27, 2019 at 4:50 PM Arnaldo Carvalho de Melo
>> ><arnaldo=2Emelo@gmail=2Ecom> wrote:
>> >>
>> >> Take it as one, I think it's what should have been in the cset it
>is
>> >fixing, that way no breakage would have happened=2E
>> >
>> >Ok=2E I trimmed commit log and applied here:
>>
>>https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/bpf/bpf=2Egit/commit=
/?id=3D1fd450f99272791df8ea8e1b0f5657678e118e90
>> >
>> >What about your other fix and my suggestion there?
>> >(__u64) cast instead of PRI ?
>> >We do this already in two places:
>> >libbpf=2Ec:                shdr_idx, (__u64)sym->st_value);
>> >libbpf=2Ec:             (__u64)sym=2Est_value,
>GELF_ST_TYPE(sym=2Est_info),
>>
>>
>> I'm using the smartphone now, but I thought you first suggested using
>a cast to long, if you mean using %llu + cast to __u64, then should be
>was ugly as using PRI, IOW, should work on both 64 bit and 32 bit=2E :-)
>
>Yes=2E I suggested (long) first, but then found two cases in libbpf that
>solve this with (__u64),
>so better to stick to that for consistency=2E

If it's already being used elsewhere in lubbpf, it was tested already with=
 the build containers and since nobody complained, go with it :-)

- Arnaldo

