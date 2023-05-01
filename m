Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED156F386C
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjEATqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 15:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjEATqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 15:46:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A051AC;
        Mon,  1 May 2023 12:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5T7SNEFioE5bVYpZBmGJPqGx2AlTDrYehgilC8dKMoA=; b=okXKfCqsbmvFVvMvcb1Ec1FaPX
        6gXftB2GMFAKmeJvM6Q63hRQ2tgqm7SQPABq799C5KMdO/q+3XkN4kdbmymWBtDXMOgp+WxR11+Am
        8sEUikYK4F/63MXkSnaGqi+X0RRfoVklBTeLcnBCSK9gM2LdTevn950EOM2jONIUAALm++fEsofdc
        jMVmS2VGLdb1tB+1dID3vZWH5/kF/klCBHWHnH1j99cYNCAYtMvyuEOl/UQLwtabqZb0YA4sejg5y
        KHFla7z4jK5je9QDtVqF8mwJwLgsCLOM61ck+KtuxPCyLK0rXNzDRgBo3Y+8zC4RNxxeVUWVMSGk9
        PjBXuh6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35442)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ptZT7-0001Kz-KS; Mon, 01 May 2023 20:45:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ptZT4-0008N7-Bm; Mon, 01 May 2023 20:45:50 +0100
Date:   Mon, 1 May 2023 20:45:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/3] net: mvpp2: tai: add extts support
Message-ID: <ZFAW7pn3OQsiy/PU@shell.armlinux.org.uk>
References: <20230430170656.137549-1-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430170656.137549-1-shmuel.h@siklu.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been on a two week vacation, so I'm going to be catching up with a
lot of email - and I do want to review this before it's merged.

On Sun, Apr 30, 2023 at 08:06:53PM +0300, Shmuel Hazan wrote:
> This patch series adds support for PTP event capture on the Aramda
> 80x0/70x0. This feature is mainly used by tools linux ts2phc(3) in order
> to synchronize a timestamping unit (like the mvpp2's TAI) and a system
> DPLL on the same PCB. 
> 
> The patch series includes 3 patches: the second one implements the
> actual extts function.
> 
> Changes in v2:
> 	* Fixed a deadlock in the poll worker.
> 	* Removed tabs from comments.
> 
> Changes in v3:
> 	* Added more explanation about the change in behavior in mvpp22_tai_start.
> 	* Explain the reason for choosing 95ms as a polling rate.
> 
> Changes in v4:
> 	* Add additional lock for the polling worker reference count. 
> 
> Shmuel Hazan (3):
>   net: mvpp2: tai: add refcount for ptp worker
>   net: mvpp2: tai: add extts support
>   dt-bindings: net: marvell,pp2: add extts docs
> 
>  .../devicetree/bindings/net/marvell,pp2.yaml  |  18 +
>  .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 332 ++++++++++++++++--
>  2 files changed, 316 insertions(+), 34 deletions(-)
> 
> 
> base-commit: 3e7bb4f2461710b70887704af7f175383251088e
> -- 
> 2.40.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
