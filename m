Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127F860446E
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiJSMEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbiJSMEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:04:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E6112FF83;
        Wed, 19 Oct 2022 04:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PVpOsxEzdr5YmEf/ilBvlkD6m/QIlYqBmm4sBpABB3Q=; b=mHak/Q9wP3WjwMBvxTBkyAw5n9
        yakEd2nsSzQKgZxFWn43jVawQy+1RaNtVXfSopk3dDLSPDQnCPC9KkKxtw4t9MNHTiT1mO1xXDUaJ
        YZ9spKa8S/ceTDbIXPk09t+bgTf+wMjLOUPvj9cGOkKh1qcS/eM05/2tn89h6K8TnqE+5Wcmu9Z4D
        I0xvNuTIBL3wIO1fnKJrIv/KAhXmrKE8ht+WwqPgF2aahFqBbzoGnzMrxHsRSTuAz2Lt7y6fhOMAs
        7Yd1camvSTeMCaJehKJ/wMmffxw6hRjVxxPnhLBwHJ6z5zd5qzJl0cZhMUp6wdmefCni89kcIjnFN
        UOKLY8UQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34792)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ol7Q1-0005ZJ-NA; Wed, 19 Oct 2022 12:39:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ol7Px-00027Z-N7; Wed, 19 Oct 2022 12:39:25 +0100
Date:   Wed, 19 Oct 2022 12:39:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] net: phy: marvell10g: Add host speed setting by
 an ethernet driver
Message-ID: <Y0/h7ecTLYkhOTCw@shell.armlinux.org.uk>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019124442.4ab488b2@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221019124442.4ab488b2@dellmb>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 12:44:42PM +0200, Marek Behún wrote:
> On Wed, 19 Oct 2022 17:50:49 +0900
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> 
> > R-Car S4-8 environment board requires to change the host interface
> > as SGMII and the host speed as 1000 Mbps because the strap pin was
> > other mode, but the SoC/board cannot work on that mode. Also, after
> > the SoC initialized the SERDES once, we cannot re-initialized it
> > because the initialized procedure seems all black magic...
> 
> Can you tell us which exact mode is configured by the strapping pins?
> Isn't it sufficient to just set the MACTYPE to SGMII, without
> configuring speed?

(To Yoshihiro Shimoda)

Please note that I don't seem to have the patches to review - and as
maintainer of the driver, I therefore NAK this series until I can
review it.

I'm guessing the reason I don't have them is:

2022-10-19 09:51:17 H=relmlor1.renesas.com (relmlie5.idc.renesas.com) [210.160.252.171]:58218 I=[78.32.30.218]:25 F=<> rejected RCPT <linux@armlinux.org.uk>: Faked bounce
2022-10-19 09:51:17 H=relmlor2.renesas.com (relmlie6.idc.renesas.com) [210.160.252.172]:24399 I=[78.32.30.218]:25 F=<> rejected RCPT <linux@armlinux.org.uk>: Faked bounce
2022-10-19 09:51:18 H=relmlor1.renesas.com (relmlie5.idc.renesas.com) [210.160.252.171]:58218 I=[78.32.30.218]:25 F=<> rejected RCPT <linux@armlinux.org.uk>: Faked bounce
2022-10-19 09:51:19 H=relmlor1.renesas.com (relmlie5.idc.renesas.com) [210.160.252.171]:58218 I=[78.32.30.218]:25 F=<> rejected RCPT <linux@armlinux.org.uk>: Faked bounce

Why are you sending patches using the NULL envelope sender - this is a
common trick used by spammers and scammers to get their messages
through. Please don't.

(In case anyone questions this - as all my email is sent from encoded
envelope from addresses rather than my published addresses, bounces
do still work.)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
