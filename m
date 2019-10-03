Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2E2C9806
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 07:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfJCFsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 01:48:09 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36882 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbfJCFsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 01:48:09 -0400
Received: by mail-lj1-f194.google.com with SMTP id l21so1256139lje.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 22:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n3peBCGmoMQ8oWT4xeQhDsEdz8bsDQQABUU5Ia1ck8o=;
        b=H0/XlQvPnj51af1Zg0nMxa1vOZpllkBSJRSmUGZkk5w2wVuHUxKMnTVurT7Lf8u9Kk
         qAZ+Q83ycL7yJKxSrosPZSGDwKBCwaKkmOy1S+izNKFzo77PhModabj3g05m9uJBRzRV
         JScaAfZ2VAHNAGbFTSF6SHUvdQX46ONuAX7FkJ1adTkme0KLLfhFWt7BXx17JRZVzSy5
         9TAvtc8kDM2M6ZC/+WlBdokyX3VKA8DJJp6ozmNLALlJK+jju7tvtRmJU8Va8zCOVBqo
         vDXm9uv+4LkzXi+1BLPeRxqAI08XKFL2w2Dph2dwQhltP031RFy/0wXQSXAYYUcy5gqa
         6Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n3peBCGmoMQ8oWT4xeQhDsEdz8bsDQQABUU5Ia1ck8o=;
        b=RYFfo4yFScV2JM83kFx8+zMEHaw/DjMyaSLOHJLZb6q3aPVtuym403HLpXsl19vOCH
         ZaSpeQ5RjZEXg8uinixaEMjUx/ylSlIeQhCdPvVLf9+DQDuwznD2wCfdpXqwafLCqS4o
         cO6tlCx/NTB7+RVsTHrtuTs9zo7eOUrSZ4VOHkhYUfY+jjhf78mUpEuWGpLrFDnLC6Ey
         UJxnCMhuyaT+I+oE51WVzSiZJ+wB0AiPgjxovBsyKCbQy1R2OM3a3adUYHAg14JpDw7X
         z3BgQDCLHyma/G9ZVwiR75W/oMLs72UTB/3TWUzPuDT+laWyVNgT2nutSxvhmIKUl4Tj
         XBmg==
X-Gm-Message-State: APjAAAWojZo5r7dSmcDIK1X4P1FT6jykDZvvGw35/nA6DRmgyzrcGh4R
        K9fUJ5+A8Xz4KsxrpAvdoP7ISrXjVm5I6+5SRyqZjw==
X-Google-Smtp-Source: APXvYqyq9DhP9eRaj8WFX2Hy5vRf8wKnoGe50YriZsyGo+Cl5XvZ5EcNTvnRB1w/pA6/zpa04EMaKZk3jpdM7ITGtPE=
X-Received: by 2002:a2e:9f4f:: with SMTP id v15mr4961160ljk.222.1570081687233;
 Wed, 02 Oct 2019 22:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191002221017.2085-1-wdauchy@gmail.com> <025bcf1e-b7d4-5fa2-ec68-074c62b9d63c@gmail.com>
 <CAJ75kXZT1Mt_=dqG+YEZHpzDLUZaPK=Nep=S85t9V+cT1TNMfA@mail.gmail.com> <d0b1f5b1-8182-a1d0-4abf-924a0f050393@gmail.com>
In-Reply-To: <d0b1f5b1-8182-a1d0-4abf-924a0f050393@gmail.com>
From:   William Dauchy <wdauchy@gmail.com>
Date:   Thu, 3 Oct 2019 07:47:55 +0200
Message-ID: <CAJ75kXavKopDRboRufpsYNNu9w-xqocqkRb=5YrdBiqkMj2GyQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: add tsval and tsecr to TCP_INFO
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     NETDEV <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 1:14 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I would rather use a new getsockopt() to fetch this specific data,
> instead of making TCP_INFO bigger for everyone :/
>
> ss command can dump millions of sockets in busy hosts, we need to be
> careful of TCP_INFO size.

Thanks Eric for your advices. I will see how I can come back with a
second proposition.
-- 
William
