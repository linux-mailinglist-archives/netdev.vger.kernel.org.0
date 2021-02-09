Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB007314732
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 04:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhBIDrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 22:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhBIDmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 22:42:38 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01063C061793
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 19:33:31 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id f2so20517729ljp.11
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 19:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aDSgtI7jB8LQU1zxi2WuFZrnArZ4OvHMZQ9A08fldhc=;
        b=Bnhz4tfQ66+N5l15fRaQZlo1j5K3c4gIlYBk1pKdQK1n5QMEZi37+HqMtHhlxEdaYT
         tbWupJt+vQOlvN2OCqtPo/RyYaUrHJA7sA0TBClT7DRW2pyAe0s6MNXxqzzYT9MpvWjL
         xnCG3SzokxuTG0qpTaryF7iGJAgo6KAuyUJNYbikesa15HgVpe2820UsPYNeV4c48otF
         faQcooAIgOGyAK4c9HK8a1WME/8XpcCI9Sl2+hubBR12s5w9dww39B0wSsyAhG6jJ5z7
         8GPcF6odMNG/XoXVnL5oR/RUEBYzlfA8CSanlTdrFrpVcA/j2stPe0N/6UaKJyS0Ae4h
         tr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDSgtI7jB8LQU1zxi2WuFZrnArZ4OvHMZQ9A08fldhc=;
        b=K1RxPGPSztdFcjCzl/IolZbWD2h/RcNH6O1gq6i+3BzDUovbRc6aUywo3GzKgGYAnz
         J2IBj3+9IVJFlBK5c9G2CG3Fh5xfSR23Hy0sh/F/VNO9Q2DR4LM5GwvKAPhM8sBidKPj
         vgsDyoveCm2q1zPRI1zeoUjnth+vtBhqKIdkdctpJ1FQVlX2snFrnHj56+n0ZPMhXJBG
         ElZJXwA9UJqEqrXP1ta945mGUUWTl/Sc6LvhnnV2g0BZvilH/7KXWjD5AGaWxGDEBXar
         lJiYmf57MT6W0UxnRdrwIlcvZRrNV+OGVv8Lk5KFgTwgsJgcZVdA9ObtBQsXINzcDRFz
         LJ6g==
X-Gm-Message-State: AOAM533WHXn8SxWipxnnlU8RsVcAEgFXkK05YoGtMNjOv7cM5YHCMSae
        BnSFbcR8q+ckns7QXdcT27yhN1G0Zw1BHoV3x1k=
X-Google-Smtp-Source: ABdhPJxG3g3IDhINgQmiDWDdQhLSmUPvU7DY5RMZd3nkycMHgpmouZrIPjUIojUatWdn5jBIN2+bvC9amGV40hPWzqw=
X-Received: by 2002:a2e:b803:: with SMTP id u3mr5859972ljo.481.1612841609530;
 Mon, 08 Feb 2021 19:33:29 -0800 (PST)
MIME-Version: 1.0
References: <20210208175820.5690-1-ap420073@gmail.com> <8633a76b-84c1-44c1-f532-ce66c1502b5c@gmail.com>
 <CAMArcTVdhDZ-4yETx1mGnULfKU5uGdAKsLbXKSBi-ZmVMHbvfQ@mail.gmail.com>
 <8e1d588c-e9a4-04d2-62c3-138d5af21a32@gmail.com> <20210208185641.70ef6444@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208185641.70ef6444@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 9 Feb 2021 12:33:18 +0900
Message-ID: <CAMArcTVEGicVCXxBd2wHKhUikXxn05mAPoqv1M_bvS4x0MgJsA@mail.gmail.com>
Subject: Re: [PATCH net-next 7/8] mld: convert ip6_sf_socklist to list macros
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, dsahern@kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 at 11:56, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 8 Feb 2021 19:18:40 -0700 David Ahern wrote:
> > On 2/8/21 7:05 PM, Taehee Yoo wrote:
> > > Thanks, I understand why the arrays have been using.
> > > I will send a v2 patch, which contains only the necessary changes.
> >
> > please send v2 as a patch series and not 8 individual patches + cover
> > letter.
>
> And if you use git send email please use --thread and
> --no-chain-reply-to, so that the patches are all "in response"
> to the cover letter.

Thank you for the advice!
I will use those options :)

Thanks!
Taehee Yoo
