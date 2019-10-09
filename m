Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36874D0512
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbfJIBLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:11:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36421 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbfJIBLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:11:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so720693qkc.3;
        Tue, 08 Oct 2019 18:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HizNyR9oSlLvlCtnlJYLHBFqDkX7aFm+VeoMRezWJZE=;
        b=Uj6ATkvA7rW9rRPZLKFvR1rm6wPB9QiuLvRLoK3brrJs5XBXt2fAH5zMOQqBMdLvff
         o9/yNnLVBG1kWSb2iHPvorhEhRwLExpETtI2gpCsekFqiGTdBOYqrEV03ds6n7vMmBe7
         yhaqtfjJ5aNCUWt1x7jdXZFfPhortJrxN2SKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HizNyR9oSlLvlCtnlJYLHBFqDkX7aFm+VeoMRezWJZE=;
        b=WMmtTOFtx1PV1bvGwlKNyVjbQCLBpj3L99j1X36GzTLy9rQ1RdboUhQVuahFpBR5Yj
         cY4bVH7bfhfiy1LmMjeSlWy2U0HY3FvckE2y+VFU94yVT5pDHvt0x8pR+IoOzkfQhG/j
         AIgmZYf5XxIqa76hdM/GGmqoQodwo+TV8Gkk+dbUjjFlApDUIFHR9c8x/T5CNdo6eatK
         e0hwt80vMhiHCwBIScAMke/UCVN2okLbIYDfe2ZyT5QKTAqt9BaJQaeQvnqmmkoWuh+/
         D67t3F8VmnOlLamRO2EFgDF3l1VZuL7qKweauSXgTq9kDdPDDUBxX+5xyslBTu/uocla
         alUw==
X-Gm-Message-State: APjAAAXpkmm8i6CxO4RpHv5+tlyhx8DeU1BnQq0TkfZEKwnCbspZo3dc
        mzYkqt2BQkEbs+5P/B45ck4hZWu26m42Sv7huu45nqo3X3Y=
X-Google-Smtp-Source: APXvYqx3M96C65FFqJOXj6SLv7cKXGek3vuS8RjdW5ODTS1Z9zAoE0DcsuXwdOYx+Idi0Y+c4sHGrghyGe2X/1pmGqQ=
X-Received: by 2002:ae9:e30d:: with SMTP id v13mr1198369qkf.208.1570583506281;
 Tue, 08 Oct 2019 18:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20191008115143.14149-1-andrew@aj.id.au> <938706da-d329-c4aa-fcce-2d390a4e98f7@gmail.com>
In-Reply-To: <938706da-d329-c4aa-fcce-2d390a4e98f7@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 9 Oct 2019 01:11:33 +0000
Message-ID: <CACPK8XeNvHLqurE=bEzJ3qJubpnzP=KqgQZU_4THCvGa3zHYxg@mail.gmail.com>
Subject: Re: [PATCH 0/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 at 00:38, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 10/8/2019 4:51 AM, Andrew Jeffery wrote:
> > Hello,
> >
> > This series slightly extends the devicetree binding and driver for the
> > FTGMAC100 to describe an optional RMII RCLK gate in the clocks property.
> > Currently it's necessary for the kernel to ungate RCLK on the AST2600 in NCSI
> > configurations as u-boot does not yet support NCSI (which uses the RMII).
>
> RMII as in Reduced MII or Reverse MII in that context?

Reduced MII ( https://en.wikipedia.org/wiki/NC-SI#Hardware_interface )

Cheers,

Joel
