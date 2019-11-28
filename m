Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BB710C155
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfK1BRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 20:17:12 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42956 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK1BRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 20:17:11 -0500
Received: by mail-qk1-f193.google.com with SMTP id i3so21310291qkk.9;
        Wed, 27 Nov 2019 17:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=SCnPXL8bPykPhZGlMn7ftNZt7W54n9LAos9Pr0g3VrY=;
        b=j69KeExGYZcXpliLEGsVduDxjTfb5YVdrjeBMGGpE9Sam40UL8htV7UUYddYCw1Jmk
         ebjWqo0B2xtEY/vUxQ7DrLoqtwBA8v3mHiuDIT2xTS0NZmFX8MKafKK2u28+WKReDqML
         Nd0ADeLu57Fx1hZHmEwL0Pat7USdcS9h0A0xnW+OaB72ddRo4PP2RHuh53eJneMWCaWq
         COIu9SmaLYUGxhxB6HDxwkpXimQlE6jpeTNOihlYfjrJL9yxCWo7i94h04c8z6RouuCN
         bh50tk8rrPrciEGNLUCfDXX2h2InpIol4QF8jU/DNjN5Wa68/MabnRwFEIrw9PAKMZRo
         VDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=SCnPXL8bPykPhZGlMn7ftNZt7W54n9LAos9Pr0g3VrY=;
        b=KLrLz48iU9tQyUQNzlf5TXI9bO0XpPmSnw5QsNbqBXSRCoQfBKzaNAVSyhb2uxC2jo
         652hNSJnvX6Ycq9mMCFEDkq6AdLpumBtHn6l3VYx6g+FkAus+43Age07pte1wVVRZ0tF
         ERVOKl7F3xaAxOUrmf9Rv72or8H/b71NTERi6vvKqwgpQuwnkdesWm+xgyB7b0F4HAaa
         PIhJQftSLK3No57Np7t3QID/b1wWxYeebzIMzIb8nN/1yCfuzxlpT/Y813/GXOujur5w
         Ts++k/PkFM5MhbYV7qmltoq6ME201UTnWNpsFCT/sHd2Bwap9xGznqYY+JwG2YODbdh4
         32/g==
X-Gm-Message-State: APjAAAV51sh2Y/khdek15ZfuoDIG2X3+2mr2r+qEdXwLY7fblNJSz+k/
        F2viCGLvRLMJvWVFelnthtQ=
X-Google-Smtp-Source: APXvYqxHH2BWJ2TvwiX7facJAjbmhR3H/5zqIxA+DcY2C4N8HeqCY1WukmDVkxhFo1EDkBH+ypkkZw==
X-Received: by 2002:a37:7705:: with SMTP id s5mr7691937qkc.145.1574903830336;
        Wed, 27 Nov 2019 17:17:10 -0800 (PST)
Received: from [192.168.86.249] ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id s44sm8837505qts.22.2019.11.27.17.17.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 17:17:09 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Wed, 27 Nov 2019 22:17:46 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <CAADnVQJc2cBU2jWmtbe5mNjWsE67DvunhubqJWWG_gaQc3p=Aw@mail.gmail.com>
References: <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org> <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org> <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com> <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org> <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com> <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com> <20191127013901.GE29071@kernel.org> <CAADnVQJCMpke49NNzy33EKdwpW+SY1orTm+0f0b-JuW8+uA7Yw@mail.gmail.com> <2993CDB0-8D4D-4A0C-9DB2-8FDD1A0538AB@kernel.org> <CAADnVQJc2cBU2jWmtbe5mNjWsE67DvunhubqJWWG_gaQc3p=Aw@mail.gmail.com>
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
Message-ID: <58CA150B-D006-48DF-A279-077BA2FFD6EC@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On November 27, 2019 9:59:15 PM GMT-03:00, Alexei Starovoitov <alexei=2Esta=
rovoitov@gmail=2Ecom> wrote:
>On Wed, Nov 27, 2019 at 4:50 PM Arnaldo Carvalho de Melo
><arnaldo=2Emelo@gmail=2Ecom> wrote:
>>
>> Take it as one, I think it's what should have been in the cset it is
>fixing, that way no breakage would have happened=2E
>
>Ok=2E I trimmed commit log and applied here:
>https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/bpf/bpf=2Egit/commit/=
?id=3D1fd450f99272791df8ea8e1b0f5657678e118e90
>
>What about your other fix and my suggestion there?
>(__u64) cast instead of PRI ?
>We do this already in two places:
>libbpf=2Ec:                shdr_idx, (__u64)sym->st_value);
>libbpf=2Ec:             (__u64)sym=2Est_value, GELF_ST_TYPE(sym=2Est_info=
),


I'm using the smartphone now, but I thought you first suggested using a ca=
st to long, if you mean using %llu + cast to __u64, then should be was ugly=
 as using PRI, IOW, should work on both 64 bit and 32 bit=2E :-)

- Arnaldo
