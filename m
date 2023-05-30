Return-Path: <netdev+bounces-6573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B795716FB1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C16C2812C9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628262D273;
	Tue, 30 May 2023 21:28:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DB3200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:28:16 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D40E5;
	Tue, 30 May 2023 14:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rtMOiQ1B6T7dYB7FwbV1KNs7Z9hwONAQYl5x937amzk=; b=U0hCUVtBCNQ//NjLHwtyoRJ2Sm
	EG7nrYN1OdOJvbYm2BIwRPwmtjWiwITDzqzCVUudTdqJXEuge4sk+NhOM4gGzGR6dP7Ox71yfZDrL
	EcyK9dskHLmOjf5IESag0VmsngOXITkQn26MjifhuNOgnfphlVhIPjsYPaCEi8Teo5ejaN0FYa+NF
	cilZYBO8nm9+yi5HD+nEcGdxhwrSLwD34DDigORiVvPhJl9QqBIjLUbDQhS2VsR/DtUTg3iSpBJr5
	XNpmjpuyFvnIP+vnfZFMcO4ZPDgzsKwbkRU2JwFVYWLWJvNN0EMdRIcm6czwYnxYsLjphMyhsLia2
	4KRC22tA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45726)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q46sy-0003Us-PD; Tue, 30 May 2023 22:28:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q46sx-0008PF-3F; Tue, 30 May 2023 22:28:07 +0100
Date: Tue, 30 May 2023 22:28:07 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <ZHZqZyCJGZjraJ6P@shell.armlinux.org.uk>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
 <90b1107b-7ea0-4d8f-ad88-ec14fd149582@lunn.ch>
 <20230530121910.05b9f837@kernel.org>
 <ZHZQ+1KNGB7KYZGi@shell.armlinux.org.uk>
 <0851bc91-6a7c-4333-ad8a-3a18083411e3@lunn.ch>
 <ZHZmBBDSVMf1WQWI@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHZmBBDSVMf1WQWI@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:09:24PM +0100, Russell King (Oracle) wrote:
> Having thought about this, the best I can come up with is this, which
> I think gives us everything we want without needing BUILD_BUG_ONs:
> 
> #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
>                                 timeout_us, sleep_before_read) \
> ({ \
>         int __ret, __val;
> 	__ret = read_poll_timeout(__val = phy_read, val, __val < 0 || (cond), \
>                 sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
>         if (__val < 0) \
>                 __ret = __val; \
>         if (__ret) \
>                 phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
>         __ret; \
> })
> 
> This looks rather horrid, but what it essentially does is:
> 
>                 (val) = op(args); \
>                 if (cond) \
>                         break; \
> 
> expands to:
> 
> 		(val) = __val = phy_read(args);
> 		if (__val < 0 || (cond))
> 			break;
> 
> As phy_read() returns an int, there is no cast or loss assigning it
> to __val, since that is also an int. The conversion from int to
> something else happens at the same point it always has.

... and actually produces nicer code on 32-bit ARM:

Old (with the u16 val changed to an int val):

 2f8:   ebfffffe        bl      0 <mdiobus_read>
 2fc:   e7e03150        ubfx    r3, r0, #2, #1		extract bit 2 into r3
 300:   e1a04000        mov     r4, r0			save return value
 304:   e2002004        and     r2, r0, #4		extract bit 2 again
 308:   e1933fa0        orrs    r3, r3, r0, lsr #31	grab sign bit
 30c:   1a00000d        bne     348 <genphy_loopback+0xd8>
		breaks out of loop if r3 is nonzero
	... rest of loop ...
...
 348:   e3520000        cmp     r2, #0
 34c:   0a00000b        beq     380 <genphy_loopback+0x110>
		basically tests whether bit 2 was zero, and jumps if it
		was. Basically (cond) is false.

 350:   e3540000        cmp     r4, #0
 354:   a3a04000        movge   r4, #0
 358:   ba00000a        blt     388 <genphy_loopback+0x118>
		tests whether a phy_read returned an error and jumps
		if it did. r4 is basically __ret.
...

 380:   e3540000        cmp     r4, #0
 384:   a3e0406d        mvnge   r4, #109        ; 0x6d
		if r4 (__ret) was >= 0, sets an error code (-ETIMEDOUT).
 388:   e1a03004        mov     r3, r4
 ... dev_err() bit.

The new generated code is:

 2f8:   ebfffffe        bl      0 <mdiobus_read>
                        2f8: R_ARM_CALL mdiobus_read
 2fc:   e2504000        subs    r4, r0, #0		__val assignment
 300:   ba000014        blt     358 <genphy_loopback+0xe8>
		if <0, go direct to dev_err code
 304:   e3140004        tst     r4, #4			cond test within loop
 308:   1a00000d        bne     344 <genphy_loopback+0xd4>
	... rest of loop ...

 344:   e6ff4074        uxth    r4, r4			cast to 16-bit uint
 348:   e3140004        tst     r4, #4			test
 34c:   13a04000        movne   r4, #0			__ret is zero if bit set
 350:   1a000007        bne     374 <genphy_loopback+0x104> basically returns
 354:   e3e0406d        mvn     r4, #109        ; 0x6d
	... otherwise sets __ret to -ETIMEDOUT
	... dev_err() code

Is there a reason why it was written (cond) || val < 0 rather than
val < 0 || (cond) ? Note that the order of these tests makes no
difference in this situation, but I'm wondering whether it was
intentional?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

