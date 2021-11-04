Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D300445386
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhKDNJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhKDNJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:09:38 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237D1C061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 06:07:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t30so8508698wra.10
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 06:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YI7bEsvaa9P6T1BxeXDJHD35omyehNZNvxDjHcofyQw=;
        b=KwUcpwdgzLUwVUY0mx23TgErTco3/7RgudpLX6qNtHIqZnEnQ2Xuy4ErChUaoHWZlR
         xed32y97cITsBTH6bQ19SQ4BgvzB2Nyp4HUGGJeMEapL/82gXWy5qI6pHHtOREZFeNr3
         naAa4lNAmFH95Pt9HyqUkNGeAz1Fal+sZr8L+soMlJ0KdGBNVtG294YQgejE/hBhtxTh
         hxFbhFosyCo+BkpGj2BVOxHHfGb9EUG2bYNue+zYP6QMzZr7WctsVPxElRk2gJFjedJM
         RUE7pxQPcF3nCvoHfgbY+ot7nlFGaCU3cZfco6s1R+hguDmEUAuv6CZ4LfMhj3ECLPss
         tlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YI7bEsvaa9P6T1BxeXDJHD35omyehNZNvxDjHcofyQw=;
        b=KgxUVkn536D3wU6yruFqNuL+koTwHo87iHZGaN/N+FTYGhLA29YPhbKZ2J+MSldtfa
         givzRatToPsqX7E9G59rns5UqruTU9rm7VBFZsBalUzEgN7qoWWKY8vPOsvsELa8i9Sw
         YaCubDcyo7oHyJAI+6tzSJO97aqs2ULCCpyn1Enfpcxx88B6vOqRGgU3TS4FqCyJ0wSu
         JJL0JHMzUdVRFZByfSmWpuzniRrYHL1aclTg/+P5oyhWYHL57QnVZWvOuOrbpIdSghqb
         ib0LDlBpKVLE5qaeTTg0nsP5szgyyj7ETRWT6kHGAYQV/MZC7kl9z5nez5UVn98qVGZO
         j2FQ==
X-Gm-Message-State: AOAM532ZwGXVxdODkBYDhow9lXSC2LBGx1oAa5cBh6dwv7Q7hLeku5/K
        es4CQreui01Rns+dHUKdTkhr3Q==
X-Google-Smtp-Source: ABdhPJxVMfGVWbafZX1bgK5ZoYDR+E8GoSoH6bkQ+vwnRA2v3fjhltw7Qgclh5ItbpFPkQH38dbdjw==
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr51590433wrx.192.1636031218581;
        Thu, 04 Nov 2021 06:06:58 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c15sm4915251wrs.19.2021.11.04.06.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 06:06:58 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
In-Reply-To: <YYPThd7aX+TBWslz@shell.armlinux.org.uk>
References: <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com> <YYGxvomL/0tiPzvV@lunn.ch>
 <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com> <YYHXcyCOPiUkk8Tz@lunn.ch>
 <01a0ebf9-5d3f-e886-4072-acb9bf418b12@ti.com> <YYLk0dEKX2Jlq0Se@lunn.ch>
 <87pmrgjhk4.fsf@waldekranz.com> <YYPThd7aX+TBWslz@shell.armlinux.org.uk>
Date:   Thu, 04 Nov 2021 14:06:54 +0100
Message-ID: <87k0hojci9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 12:35, "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> On Thu, Nov 04, 2021 at 12:17:47PM +0100, Tobias Waldekranz wrote:
>> On Wed, Nov 03, 2021 at 20:36, Andrew Lunn <andrew@lunn.ch> wrote:
>> > On Wed, Nov 03, 2021 at 08:42:07PM +0200, Grygorii Strashko wrote:
>> >> 
>> >> 
>> >> On 03/11/2021 02:27, Andrew Lunn wrote:
>> >> > > > What i find interesting is that you and the other resent requester are
>> >> > > > using the same user space tool. If you implement C45 over C22 in that
>> >> > > > tool, you get your solution, and it will work for older kernels as
>> >> > > > well. Also, given the diverse implementations of this IOTCL, it
>> >> > > > probably works for more drivers than just those using phy_mii_ioctl().
>> >> > > 
>> >> > > Do you mean change uapi, like
>> >> > >   add mdio_phy_id_is_c45_over_c22() and
>> >> > >   flag #define MDIO_PHY_ID_C45_OVER_C22 0x4000?
>> >> > 
>> >> > No, i mean user space implements C45 over C22. Make phytool write
>> >> > MII_MMD_CTRL and MII_MMD_DATA to perform a C45 over C22.
>> >> 
>> >> Now I give up - as mentioned there is now way to sync User space vs Kernel
>> >> MMD transactions and so no way to get trusted results.
>> 
>> Except that there is a way: https://github.com/wkz/mdio-tools
>
> I'm guessing that this hasn't had much in the way of review, as it has
> a nice exploitable bug - you really want "pc" to be unsigned in
> mdio_nl_eval(), otherwise one can write a branch instruction that makes
> "pc" negative.

You are quite right, it never got that far as it was NAKed on principle
before that. I welcome the review, this is one of the reasons why I
would love to have it in mainline. Alternatively, if someone has a
better idea, I wouldn't mind adapting mdio-tools to whatever that
interface would be.

I agree that there should be much more rigorous checks around the
modification of the PC. I will get on that.

> Also it looks like one can easily exploit this to trigger any of your
> BUG_ON()/BUG() statements, thereby crashing while holding the MDIO bus
> lock causing a denial of service attack.

The idea is that this is pre-validated in mdio_nl_validate_insn. Each
instruction lists their acceptable argument types in mdio_nl_op_protos.

> I also see nothing that protects against any user on a system being
> able to use this interface, so the exploits above can be triggered by
> any user. Moreover, this lack of protection means any user on the
> system can use this interface to write to a PHY.

I was under the impression that specifying GENL_ADMIN_PERM in the
`struct genl_ops` would require the caller to hold CAP_NET_ADMIN?

> Given that some PHYs today contain firmware, this gives anyone access
> to reprogram the PHY firmware, possibly introducing malicious firmware.
>
> I hope no one is using this module in a production environment.

Thanks for your review.
