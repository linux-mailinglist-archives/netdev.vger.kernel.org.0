Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87961B4559
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 03:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391886AbfIQBso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 21:48:44 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44664 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbfIQBso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 21:48:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id i78so2111330qke.11
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 18:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=edT1MwEV0Yvt3Eaj1HjVvWX2OiCmS2l00yghhSQmhh8=;
        b=aSP3I+0I+nRIj+73SiztqkTLRBYipxWxVa/2eCQpJX2zav0Vt2t57egFxrhJXLJN4T
         O9I/rutgX3kq2wLwfAuMftmT+yN3onzIGaQ/Cd5rlDXR/SQQztigJqKDjlIigsoZVZj+
         vmSCZYh/1v1+IldHyE7nga5tStmq7w1vkrO8F4A5wyq0hBaQeW6F2vcrbwGEbdX/MjJJ
         uIKyvkGH4hO8JMTnfQZvTShrcMGkvFA6csXm93BTeHBMzJkSkrX9PZdw6rAMxIyP5BWB
         ihsHObJmLtOl8WpR0Xp9cyE2kapAPxmjLdcrBVDaMWS+/rbpDhhfaZvC/6jaMmTmGzFX
         g47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=edT1MwEV0Yvt3Eaj1HjVvWX2OiCmS2l00yghhSQmhh8=;
        b=gz4DZLNu/hlARxbav6R0YS+VWRVpiXV+MaU5/u5pGafk7Pe0nMoqBQFgupblKqhY1V
         qT28+CCLl6SvjiInT1ydkjgDI3zh2kepy28o2Cw7Wnv94H3jqZmgzY6nj1yL2FAoE70n
         PP9BG87w3V9LD7Z4HK5TdMlrso0nkNY6cmc015oOT697mKz2DFYiEFEh+2IbNo2e+So2
         cTZz1U1YWeqz6x+ezYXEwhhC9hZBNZyNFG45RdUTrAyR3kZZY6yMdNVbG0k3TItPiGl2
         56ToNG5NztvzP2FA2uyE9fkmBMQ/vGcRFRwXHc6/uRjbn9Vpf3jtf2WKxZGxbPLD/DQU
         ooQg==
X-Gm-Message-State: APjAAAWUksvDZVmvsekjjn8X7614b5EZVB8ean0O6S0C6dTy155yQYQ+
        bedQVWzr/Sa52+2ODe2jO/hpKl4vH7dtKOwcQrI1hw==
X-Google-Smtp-Source: APXvYqxB9RUk2shXtPH36lM2sXDH6jnQgPup4a+emMeOnlShQR82DfRnnbGWl4+ZDJFFnKeHKMeuZgn7jU+QI6sHw2U=
X-Received: by 2002:a37:7403:: with SMTP id p3mr1286816qkc.366.1568684923337;
 Mon, 16 Sep 2019 18:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190805131452.13257-1-chiu@endlessm.com> <d0047834-957d-0cf3-5792-31faa5315ad1@gmail.com>
 <87wofibgk7.fsf@kamboji.qca.qualcomm.com> <a3ac212d-b976-fb16-227f-3246a317c4a2@gmail.com>
In-Reply-To: <a3ac212d-b976-fb16-227f-3246a317c4a2@gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 17 Sep 2019 09:48:32 +0800
Message-ID: <CAB4CAweWoFuXPci5Re6sdN_kB0i4DkpsYxux+GAHyRHWhC+hhA@mail.gmail.com>
Subject: Re: [RFC PATCH v7] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:21 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>
> On 8/12/19 10:32 AM, Kalle Valo wrote:
> >> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
> >
> > This is marked as RFC so I'm not sure what's the plan. Should I apply
> > this?
>
> I think it's at a point where it's worth applying - I kinda wish I had
> had time to test it, but I won't be near my stash of USB dongles for a
> little while.
>
> Cheers,
> Jes
>

Gentle ping. Any suggestions for the next step?

Chris
