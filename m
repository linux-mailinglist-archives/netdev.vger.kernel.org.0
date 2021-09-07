Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AD7402960
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344624AbhIGNIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344536AbhIGNIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 09:08:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AC6C061757
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 06:06:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i21so19576475ejd.2
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 06:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L4oWWGov+bkftJWApz4guBbjvDk1FzTK4dXqUmqhsGo=;
        b=rnSIxm8cJRcatY6H7Eo6xNBmKdAEFiSjwDRpe1p581pHp2njaMR21jCJhp4BSa6AF9
         sdAlWMYna02+u2ELL6Dy9FN4vDBj1NbNoYRcvx7YrBG60NFQBZTkEkJkVB02YtmUl49u
         GlpTMTsuwJOd3+A4KMoTcJQE2njez1aT+nZbbWyHy3rE+DzcGRsL1uChH1WXPA3vVecs
         wpU53lPC5zPSWTm1g09vm2+9YVOWzWWPLoZh+1GyxgAox4HcOZudkDV2WBP6hHp75FVG
         T1WQdjvUc/J8teTsE4S6db1q46Vn+Zvjzy9m6ghat29UvFjY9ZQI2hgX58E499q6xR7Q
         1WRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L4oWWGov+bkftJWApz4guBbjvDk1FzTK4dXqUmqhsGo=;
        b=S+HKn8zsRC0Ggsii/IYYD0Taihu9iEN+iI2NFHs7trSWRUVsDJBXGQOCx8JdaCviB+
         25Nak6m3e3s12Bof8NYDWJ9M+sC9tGPbMQA2ZNWUXpr+4To3mDbVVZCa/LqhNyOaRxV2
         UWQSrSB7tzLIHvV8+mD3/hFMyekYTqtLzoH98QgYYM7ZGnZEmB9oeKhVdWGHWXsPhVKn
         gzJsURBOrvIVIBN7fqXH9NNFzI2yQhUCvhDf9DgLzTwU8wiFnU570JF/slXm4j/Etn56
         z4QX0IWoJ/PVvI7RsQ/6XNQGYnRpbIFrG5JegRwan8LLcIHCJwARPt5jNEcMQ5y9f3Ms
         3u2g==
X-Gm-Message-State: AOAM533vcr53y0vvkAvYmx1JnzEHzfqGHWdVXf3x6Tilbw4P2GfNowdT
        9HYNq/pu88OfM6hcmEOSQ+YIfDpofYdtRto6iAwk
X-Google-Smtp-Source: ABdhPJwDAmt2hGxT5ZkcZv9YGnSEohNbSITnIOxntCgMm5mnhtxhhGJHKQSwvGW7B6b8gVrXH65MjjesrNwq98dkGuI=
X-Received: by 2002:a17:906:8cd:: with SMTP id o13mr18352630eje.341.1631020016659;
 Tue, 07 Sep 2021 06:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210830115942.1017300-1-sashal@kernel.org> <20210830115942.1017300-13-sashal@kernel.org>
 <CAD-N9QUXXjEMtdDniuqcNSAtaOhKtHE=hLMchtCJgbvxQXdABQ@mail.gmail.com>
 <CAHC9VhTjFMw111-fyZsFaCSnN3b-TuQjqXcc1zVu2QTTekTohw@mail.gmail.com> <YTS96ql9DzxpYpnl@sashalap>
In-Reply-To: <YTS96ql9DzxpYpnl@sashalap>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 7 Sep 2021 09:06:45 -0400
Message-ID: <CAHC9VhR_eHxS9HFGx1QwRj9wqcmcg5794cCJ8QXKsbGA1+QELQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.13 13/14] net: fix NULL pointer reference in cipso_v4_doi_free
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 5, 2021 at 8:54 AM Sasha Levin <sashal@kernel.org> wrote:
> On Mon, Aug 30, 2021 at 10:20:22AM -0400, Paul Moore wrote:
> >On Mon, Aug 30, 2021 at 8:42 AM Dongliang Mu <mudongliangabcd@gmail.com>=
 wrote:
> >>
> >> On Mon, Aug 30, 2021 at 8:01 PM Sasha Levin <sashal@kernel.org> wrote:
> >> >
> >> > From: =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba.com>
> >> >
> >> > [ Upstream commit 733c99ee8be9a1410287cdbb943887365e83b2d6 ]
> >> >
> >>
> >> Hi Sasha,
> >>
> >> Michael Wang has sent a v2 patch [1] for this bug and it is merged
> >> into netdev/net-next.git. However, the v1 patch is already in the
> >> upstream tree.
> >>
> >> How do you guys handle such a issue?
> >>
> >> [1] https://lkml.org/lkml/2021/8/30/229
> >
> >Ugh.  Michael can you please work with netdev to fix this in the
> >upstream, and hopefully -stable, kernels?  My guess is you will need
> >to rebase your v2 patch on top of the v1 patch (basically what exists
> >in upstream) and send that back out.
>
> I'm just going to drop this one for now (it never made it in). If there
> is a follow-up you do want us to queue please let us know :)

Thanks Sasha.  The lore link below is the v2 version of the patch and
it is worth merging as a fix into the older kernels.

* https://lore.kernel.org/linux-security-module/18f0171e-0cc8-6ae6-d04a-a69=
a2a3c1a39@linux.alibaba.com

--=20
paul moore
www.paul-moore.com
