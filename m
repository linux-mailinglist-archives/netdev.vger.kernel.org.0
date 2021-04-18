Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4B13632F6
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 03:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhDRBj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 21:39:28 -0400
Received: from mx-lax3-2.ucr.edu ([169.235.156.37]:32229 "EHLO
        mx-lax3-2.ucr.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhDRBj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 21:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1618709941; x=1650245941;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=6CEFV76gW6g3N8oapt+HAqwgsAOXSLMXTf8g5Tcasak=;
  b=DmXBvYZrHfkypWIWQxPcn+UwBSCu/J4BQ2ZMdUJCt4fjJl28F1+47yq4
   Att5JgoldD6ZUs/cN17GBzIb1KpVg2V66ZZl7XjkUM/AFAH9fOxvZNVvm
   R6RXQM4ARzATItGiUtDC/ZqFk3P6JbXpg5ZehbizzvGDEZALgM4LQgJP4
   +dyO2NCMwKKQbUEuSdBgc9ZCAZQt7TY2cS3XJis3fFh50/ekO5FvMC6xG
   XBbukzbGdRXt16e8JGSNUjmtI025soqEQaTYZUqo3P7PZ9wuS77mB4In1
   IZ1ipNw/ELFYp5Xo+NVjKfkOQaJ+nWeoEjQsWQkuPZ4qOI4XsQLtM23nt
   A==;
IronPort-SDR: zFin6fpPsA7d4Mzb/xlN/Q3WaURnY8LaWksobgqXkPCgncOVHjV5pRtF/4r3+kAXLpsnHvAGSH
 yEXPKwb2km+KlPBRDJVuOfyb14u0Gic74N9N/qI73bAKPBGuk2oIMsekK9/03Vf3/knNUjsbZT
 R/0DtrnwFDWgS35v500RBOj7KOg893XHWTZR7jz9/Mgc78bpqasLhRxduP8lxc3X4IX5zifqWY
 rnkNQry2/twCTtswEHa1jL//xwmpxgpbE4D/wjH4lyBtXrR10mnOZO0Xhz9DB6rL9tccQOq8W5
 e9Q=
X-IPAS-Result: =?us-ascii?q?A2ECAADgjHtgf0imVdFaGQEBAQEBAQEBAQEBAQEBAQEBA?=
 =?us-ascii?q?RIBAQEBAQEBAQEBAQFAgT4EAQEBAQELAYN3a4RDiCSJTwOaa4F8AgkBAQEPN?=
 =?us-ascii?q?AQBAYRQAoF0AiU0CQ4CAwEBAQMCAwEBAQEBBgEBAQEBAQUEAQECEAEBboUXR?=
 =?us-ascii?q?oI4KQGDbAEBAQMSEVYQCwsDCgICJgICIhIBBQEcBhMbB4VXnWWBBD2LMYEyg?=
 =?us-ascii?q?QGIGwEJDYFEEn4qAYcChCiCKieCJ4FJgWyBAD6HWYJhBIFlfYE2CYEkQC0Bg?=
 =?us-ascii?q?RgBAQGSdQGKYpwsAQYCgnUZnQwjlCOQX7hxECOBMYIUMxolTjEGZ4FLUBkOV?=
 =?us-ascii?q?pw2JC84AgYKAQEDCY0PAQE?=
IronPort-PHdr: A9a23:eMorzxIgs8kis7NgItmcuGJmWUAX047cDksu8pMizoh2WeGdxfzKA
 kXT6L1XgUPTWs2DsrQY0ruQ6vG/EjVYqb+681k6OKRWUBEEjchE1ycBO+WiTXPBEfjxciYhF
 95DXlI2t1uyMExSBdqsLwaK+i764jEdAAjwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba52I
 RmssAncsssbjYR/Jqot1xDEvmZGd+NKyG1yOFmdhQz85sC+/J5i9yRfpfcs/NNeXKv5Yqo1U
 6VWACwpPG4p6sLrswLDTRaU6XsHTmoWiBtIDBPb4xz8Q5z8rzH1tut52CmdIM32UbU5Uims4
 qt3VBPljjoMOiUn+2/LlMN/kKNboAqgpxNhxY7UfJqVP+d6cq/EYN8WWXZNUsNXWidcAI2zc
 pEPAvIOMuZWrYbzp1UAoxijCweyGOzi0SNIimPs0KEmz+gtDQPL0Qo9FNwOqnTUq9D1Ob8XX
 ++rzKjI0CjIYfRM1jf79YPFdRMhofSWUrJ2bcbd1VQjGhjYjlqMs4zpJS2a2fkQs2WC6edrS
 O2ghXI9pQ5rvjiv2tkjipPPho8N113J6CZ0zJgrKdGkVEJ1b92pHZhfui2HN4V7XswvTW91t
 Sok1LALtp62cDUJxZko2xLSauKLfYaU7h79SuqcJTF1j29mdrKnnxu+71Ssx+nmWsS30FtGt
 DdJn9jNu3wX1RHf9M6KQeZn8Ei7wzaAzQXT5/lBIUAziKXUNYYswqU1lpoPqUTDGTL2mFnug
 K+WaEok/u+o5vziYrr8p5+cM5Z4igD5Mqgzg8C/D+Y1PhYUU2iU/uS807Lj/UnnT7lQkvI2l
 azZvIjbJcQduKG5HxdY3pg/5xu7FTur09QVkWMaIF9EeR+LlYrkN0/WLPD9F/i/glCskDlxx
 /DBO73sGpbNLn3Zn7fnYbpx91NQxREuzd9D/ZJYEK8OL+/uWkPprtzXEgc5MxCow+bgENh90
 J0RWX6SDaCHLqPfqkGI5u0xLOmWfoMVuyjyK+Ij5/HwiX81g1gdfbOm3chfVHftO/16Pw2yZ
 mDlhtMGWTMMsxYyQfKvjFyZTRZWbmquVKUm7zU/D8StCoKVFa63h7nU/yqqA9Vzb2YOXlOJG
 HGwL9ysRvwWLi+eP5kywXQ/SbG9Rtp5hlmVvwjgxu8id7KMkhA=
IronPort-HdrOrdr: A9a23:bI1NP6B5vUvQqMTlHelH55DYdL4zR+YMi2QD/UZ3VBBTb4ikh9
 mj9c566TbYgCscMUtPpfmuI6+FKEmxybdQwa08eYivRxPnvmzAFuxfxK/v2SfpFSG71sM179
 YDT4FEBNf9DUd3gK/BiWHSL/8azMSa66ftvO/Czh5WPGJXQpt95AR0ABvzKCxLbTRBbKBXKL
 Osou5riX6FdW4MZsq2JnRtZYL+juyOsonnbx4ADxsO8xKPkjus1b7/H3Gjr3Ijbw8=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.82,230,1613462400"; 
   d="scan'208";a="35448548"
Received: from mail-io1-f72.google.com ([209.85.166.72])
  by smtp-lax3-2.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2021 18:39:00 -0700
Received: by mail-io1-f72.google.com with SMTP id v1-20020a5d94810000b02903e0f4d732b4so7051045ioj.5
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 18:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6CEFV76gW6g3N8oapt+HAqwgsAOXSLMXTf8g5Tcasak=;
        b=kWwMqRW3fTO4sfff7Rl4V9UjEACPdLg94Yfzw9OvgZHiYZXNCx4XSjlyrD/KU6PA4l
         jpR4xMLO6AtVujzahsBUXa42+BIvBoZjNN6pYRxDulpOoM7J+Lwlr/SnXaaR4ejcul+t
         uAg0Mne/qjKRIHbHJ4dkXadKKcbuUPbGmyI9j9A36RqKUTGJC3hPvrg+25du6KLddIvl
         njSaqzb3+ro6GlOitYmurnQKc+E20U8VAVzTqyLRCjzm74gjQNJDZejFKmu6+gsZk8JU
         ibrG/JW9eukwaobjJFGzsDcWf2heBt6HlLECq6TX0vjDZCkOiTNV6KcufbxakepjSJF9
         BKPw==
X-Gm-Message-State: AOAM532vfda1ac8mpw1F5LagvkJutr6Kh44jk2UJcaKipLPXrhcxroXo
        isFMk6aidzit/aPQI0z+0uLjj3izd+nrJqbnqr0Sr77LlnkkvfJL5rqfdzUfn70+7fCjAFlN+9R
        YjD1Ha+hRGjNi/OgAyfBfjpzjsjGBoXz8Tg==
X-Received: by 2002:a05:6e02:4d0:: with SMTP id f16mr12628128ils.80.1618709939436;
        Sat, 17 Apr 2021 18:38:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOhw3R6ftLLuz7G0wN5MrRyWOm92ed5tQMKUHJNJFIY2JII8+iXinEexXpHW/qP0iUtsWV5ytSuzxmYX2D/xM=
X-Received: by 2002:a05:6e02:4d0:: with SMTP id f16mr12628118ils.80.1618709939197;
 Sat, 17 Apr 2021 18:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com> <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu> <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
 <20210417075030.GA14265@1wt.eu> <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
In-Reply-To: <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
From:   Keyu Man <kman001@ucr.edu>
Date:   Sat, 17 Apr 2021 18:38:48 -0700
Message-ID: <CAMqUL6bAVE9p=XEnH4HdBmBfThaY3FDosqyr8yrQo6N_9+Jf3w@mail.gmail.com>
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
To:     Matt Corallo <netdev-list@mattcorallo.com>
Cc:     Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willy's words make sense to me and I agree that the existing fragments
should be evicted when the new one comes in and the cache is full.
Though the attacker can still leverage this to flush the victim's
cache, as mentioned previously, since fragments are likely to be
assembled in a very short time, it would be hard to launch the
attack(evicting the legit fragment before it's assembled requires a
large packet sending rate). And this seems better than the existing
solution (drop all incoming fragments when full).

Keyu

On Sat, Apr 17, 2021 at 6:30 PM Matt Corallo
<netdev-list@mattcorallo.com> wrote:
>
> See-also "[PATCH] Reduce IP_FRAG_TIME fragment-reassembly timeout to 1s, from 30s" (and the two resends of it) - given
> the size of the default cache (4MB) and the time that it takes before we flush the cache (30 seconds) you only need
> about 1Mbps of fragments to hit this issue. While DoS attacks are concerning, its also incredibly practical (and I do)
> hit this issue in normal non-adversarial conditions.
>
> Matt
>
> On 4/17/21 03:50, Willy Tarreau wrote:
> > On Sat, Apr 17, 2021 at 12:42:39AM -0700, Keyu Man wrote:
> >> How about at least allow the existing queue to finish? Currently a tiny new
> >> fragment would potentially invalid all previous fragments by letting them
> >> timeout without allowing the fragments to come in to finish the assembly.
> >
> > Because this is exactly the principle of how attacks are built: reserve
> > resources claiming that you'll send everything so that others can't make
> > use of the resources that are reserved to you. The best solution precisely
> > is *not* to wait for anyone to finish, hence *not* to reserve valuable
> > resources that are unusuable by others.
> >
> > Willy
> >
