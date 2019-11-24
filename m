Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6450108447
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 18:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfKXRIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 12:08:47 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34079 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfKXRIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 12:08:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id z188so5874711pgb.1;
        Sun, 24 Nov 2019 09:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=l7wiGOGalhqmaunKzYR69ToVkqPhyra5u2ZDr05NXWo=;
        b=r4aNH5TnISb1ft/eeAo/0YZLyVrhw10sAQxy5iTnTZRJUb7LOlMpodXJE6njl6h2iu
         pfnZzZxQvGfpm1ysW3kzb1ZCLUBzFw4NglJ4+HCsp/QoxnoK45AjseK836p8p38x2OxB
         fRsWt8w0+4g4d5uDxHJFtr5M3+I8v/Wp84xVb+PTU9w3M7GS555FhyLo0FRqg4QGoYLu
         mjFeH8uug0rLtKfM/aFT/Y//k/uDCDN6cw0huA7xrfy8mGkaaaQhGmXFDnMZoGVt3WTN
         /vN0TPKqDyQ1VgKirbTNPXo+mrL6HglJviTm4hPpnQANA6QOYc8QcWZtCQ2UtWggzXAO
         ZxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=l7wiGOGalhqmaunKzYR69ToVkqPhyra5u2ZDr05NXWo=;
        b=STlhDbIT/KNX3W8obHO43RU8cWcBWvMlRDmJ+WeNGtDy38Ft8FPi8aZwcAlwdC12XM
         ynAZo9jfEy4acnyu67vqUpjLMB6feG5MiPquARzX8sNmEM6Gxge5MMcDicVHTLsb7/Dh
         at4bLThIoOsaerDq6zUpZc+pfr770+ALdTeXhOKVdKTTwddSSDmQGO7r0vtO3+D/lVRT
         pMtgY74LSl4C+94R2May16ZoDntwLuFzche+ICIjPnglmOW+2VmdGKUhrJS6VjpLKIEh
         Nfkvpt2d2UcKS2gPMqvnr5YEFeZncvJOy8IalggRF0zwelogKv9B6AugpvAyMwNyngE7
         hX8g==
X-Gm-Message-State: APjAAAXLsOXgx8UoJevwiP22hKNb5Jmi9JZFpTDMGiM87cUGY/M5tWdV
        L/dfqtsKkvNp2tpwRH15pHQ=
X-Google-Smtp-Source: APXvYqzkmiPlBdp2NxkFwm4Bz1pdnmb+Qad12HCVqY9GvrQWtnluMwmnEVr5OCCkWv0WGa+sdb68Yg==
X-Received: by 2002:a63:4441:: with SMTP id t1mr27046572pgk.179.1574615325847;
        Sun, 24 Nov 2019 09:08:45 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:180::9ba3])
        by smtp.gmail.com with ESMTPSA id w19sm5119992pga.83.2019.11.24.09.08.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Nov 2019 09:08:45 -0800 (PST)
Date:   Sun, 24 Nov 2019 09:08:43 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= 
        <thoiland@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [PATCH bpf-next v2 1/6] bpf: introduce BPF dispatcher
Message-ID: <20191124170841.x4ohh7sy6kbjnbno@ast-mbp>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
 <20191123071226.6501-2-bjorn.topel@gmail.com>
 <20191124015504.yypqw4gx52e5e6og@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNhtgvRyvnNT7_iSs9RD3rV_y8++pLddWy+i+Eya5_BJVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNhtgvRyvnNT7_iSs9RD3rV_y8++pLddWy+i+Eya5_BJVw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 07:55:07AM +0100, Björn Töpel wrote:
> >
> > I think I got it why it works.
> > Every time the prog cnt goes to zero you free the trampoline right away
> > and next time it will be allocated again and kzalloc() will zero selector.
> > That's hard to spot.
> > Also if user space does for(;;) attach/detach;
> > it will keep stressing bpf_jit_alloc_exec.
> > In case of bpf trampoline attach/detach won't be stressing it.
> > Only load/unload which are much slower due to verification.
> > I guess such difference is ok.
> >
> 
> Alexei, thanks for all feedback (on the weekend)! I agree with all of
> above, and especially missing selftests and too much code duplication.
> 
> I'll do a respin, but that'll be in the next window, given that Linus
> will (probably) tag the release today.

I want it to land just as much as you do :) Two weeks is not a big deal. We
backport all of bpf and xdp as soon as it lands in bpf-next/net-next. We don't
wait for patches to reach Linus's tree. So this dispatch logic will be running
on our servers way sooner than you'd expect. I guess that explains my obsession
with quality. Same goes for libbpf.


