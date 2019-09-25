Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F1DBE0B7
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 17:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438433AbfIYPAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 11:00:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34976 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438382AbfIYPAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 11:00:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so7343428wrt.2
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 08:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=yrL9qSy/3grZaifloxyMrl1qoRWf0gLjQ/fLitAs1Sg=;
        b=tWFEpt1lBq/s0U7lRRMcg92G7ibk3Zphd/xQ6319ivkDGRcwuA2VsUEEhRXg6p3Rmo
         UFFLhSxCcBbU50mqQ0W8FKmttRbATzcWCmWzUlzCYmIZf7A17ZZWEAdjUO3Mltty3bJV
         gPuGpquxOoSIhqEJg9Oa8QbSXdbCW277ihBHN4xSJurJgqArzSADU2YFcSm5U73benaB
         CseZ5S9N3BtBYiecF3XIxDjZ2ZSvHqLN7yJQQZNDkFJWfr8qH7co/SD6q7xm1QQdVXbE
         URk33RcMwYrT1AJwrVuvrmUKTijJubzDzzZcglUtnKOBSJhwpSL4ci9KcKrbyZ3YSve1
         djtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yrL9qSy/3grZaifloxyMrl1qoRWf0gLjQ/fLitAs1Sg=;
        b=pT32+HM8p5gY+GJGcKATaif4VIP1zS/b5oFIKsnJ1CfitBCFajcZ5vSXLqBHUaELoE
         54RMjJ235dpJdEoB4F8z4H6PnJjk54nEgJfaLYRSFF9hGgnwxHN8RHbqktAiBgJ8tYD4
         3H34mdcoie1nuzdDKn7JqeTwTJ7VvC2WFBVhCTqWkC4OQ1O6ftMYfbFienYEe+AL/UP0
         aaCQkn8rzd8RS1uwKgWe8hBjvEedulZHLSNhte6OewYU+UW8yMWjfLMU6kM+3AvVH1DW
         j6BvKqCzzIxTq4a4YYOBv7agKeW/jhsPx1hYeponGaE6cP31Day4onAkY+RzzN9ZBzfA
         UTSw==
X-Gm-Message-State: APjAAAXnzEyYJe8EYa6Fa2T8ktBZLT+UNhOfhVqUyBeK7PcoHMOiegdG
        lKM8jqxff12rQeNGHF4ZyrdecQ==
X-Google-Smtp-Source: APXvYqzY26KY3DPvEXCysVewS/BT+v0bJdfTqB6QhZQoHrrjhoEyJyWKY2tBc0+lQU6tMfc61ziGzQ==
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr10224298wrr.334.1569423620189;
        Wed, 25 Sep 2019 08:00:20 -0700 (PDT)
Received: from localhost ([2620:10d:c092:180::1:87a6])
        by smtp.gmail.com with ESMTPSA id o9sm9880475wrh.46.2019.09.25.08.00.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 08:00:19 -0700 (PDT)
From:   Loys Ollivier <lollivier@baylibre.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32\@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: Fix ASSERT_RTNL() warning on suspend/resume
In-Reply-To: <BN8PR12MB3266A4C33D234165A0F2A978D38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1568714556-25024-1-git-send-email-lollivier@baylibre.com> <BN8PR12MB3266A4C33D234165A0F2A978D38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
Date:   Wed, 25 Sep 2019 17:00:13 +0200
Message-ID: <86ftkkzaiq.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 17 Sep 2019 at 10:12, Jose Abreu <Jose.Abreu@synopsys.com> wrote:

> From: Loys Ollivier <lollivier@baylibre.com>
> Date: Sep/17/2019, 11:02:36 (UTC+00:00)
>
>> rtnl_lock needs to be taken before calling phylink_start/stop to lock the
>> network stack.
>> Fix ASSERT_RTNL() warnings by protecting such calls with lock/unlock.
>> 
>> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
>> Signed-off-by: Loys Ollivier <lollivier@baylibre.com>
>
> I already sent a fix for this. Please see in -net:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/driv
> ers/net/ethernet/stmicro/stmmac?id=19e13cb27b998ff49f07e399b5871bfe5ba7e3
> f0

Ah good catch :)

>
> ---
> Thanks,
> Jose Miguel Abreu
