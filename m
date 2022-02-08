Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1EE4ADDC4
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240190AbiBHP6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiBHP57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:57:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2BCC061578;
        Tue,  8 Feb 2022 07:57:59 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k17so14221320plk.0;
        Tue, 08 Feb 2022 07:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+/JyyE+URKj87BO7QT8MnRUrWcrYgGPbIYYPz/QVNhY=;
        b=N4nxQL4kLDKcA34UlvpL/6UjYKpg3lUPka1TZ+URuphai7tRxpXxJHmboJhzQS5Z2U
         OyHRdBdHWRSvLkKIxDS88p5VRjGX1ptwPN2YO897RK+jnj1YzdoQZxHE2gm8I3q2lC+a
         4fgaogNHIynEJ9zZk2N5IF4bA1WbZfaCderIMZN4QpWmmYwT8Ds249312Mz47ovII+p9
         yd0UXpMD7Uf3gwcbiyU82JNQTegW/vw3DvNasO4x9OvqarF0zfvWCp5AoUpfhQCojhww
         uQif3zXay9ca27TjK+cN69mfcgt0RZpbyAkaEqLkMXXjca9FJJJ1NTubsA2yc04r9WIw
         CVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+/JyyE+URKj87BO7QT8MnRUrWcrYgGPbIYYPz/QVNhY=;
        b=qx83yGREVb7Jh2tzCLUvDDWup6KPBYHpfAsqIhPHHp+D5hiCKT+DgAeQgNheNTaYXj
         3aB/+UBUXymJQsZKyeupqzML8vIk4JfkkqIc1Xqv7WTOjCdD8vDdlQgNc0bAv2Y+Q6KV
         D6xxtsjMdQoRVMfDyYmbdi1lv0HPP9Vejuh+8YkYfD80+Kf/2b7ptRkOAygYkNz9i6Bg
         TpFBy7zVGxjADzeOXY6zs5IBMXwSSeVOYK2uD53qtGt2d71y+90jolnt5+7tRNFqHxrA
         TY2CAO6YxFWOHFX/dlDLizpm/2Pwk/6AYZ5us4VUXPnqcLtiRY+EJWdsi4QVi7lIzFMw
         CF+w==
X-Gm-Message-State: AOAM531ZnYUFZG6PYDR2mqYPEYFPiAHLCekYbduf6B502hMFxyPgd6xA
        68iLhOyfmlQFH0YyjDL2f4o=
X-Google-Smtp-Source: ABdhPJw9GI3LmijANA6YNg6ucBYaKBZ1Kmmqr0H5BC9suvjUjyEtX6w/E9WyIaPKUu+RN4l/U0sJLA==
X-Received: by 2002:a17:902:dac8:: with SMTP id q8mr5025423plx.164.1644335878641;
        Tue, 08 Feb 2022 07:57:58 -0800 (PST)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id s4sm11481437pgg.80.2022.02.08.07.57.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Feb 2022 07:57:58 -0800 (PST)
Date:   Tue, 8 Feb 2022 21:27:52 +0530
From:   Raag Jadav <raagjadav@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <20220208155752.GB3003@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
 <YgANBQjsrmK+T/N+@lunn.ch>
 <20220207174948.GA5183@localhost>
 <YgHQ7Kf+2c9knxk3@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgHQ7Kf+2c9knxk3@lunn.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 03:09:48AM +0100, Andrew Lunn wrote:
> > MAC implementation[1] in a lot of NXP SoCs comes with in-band aneg enabled
> > by default, and it does expect Clause 37 auto-negotiation to complete
> > between MAC and PHY before the actual data transfer happens.
> > 
> > [1] https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/t-series/3241/1/AN3869(1).pdf
> > 
> > I faced such issue while integrating VSC85xx PHY
> > with one of the recent NXP SoC having similar MAC implementation.
> > Not sure if this is a problem on MAC side or PHY side,
> > But having Clause 37 support should help in most cases I believe.
> 
> So please use this information in the commit message.
> 
> The only danger with this change is, is the PHY O.K with auto-neg
> turned on, with a MAC which does not actually perform auto-neg? It
> could be we have boards which work now because PHY autoneg is turned
> off.
> 

Introducing an optional device tree property could be of any help?

>       Andrew
