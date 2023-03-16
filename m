Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977396BDC87
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCPXBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCPXBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:01:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395512CFE3;
        Thu, 16 Mar 2023 16:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=biRMyrU+XuL95zR8LqJLaB3BbRBCfLHWBcOSEHaHpBw=; b=pIgAMqYbbabotPI+N4zy8hC0i1
        3oVn0WhjzKXndze3t8usxuVfsyHha5Xt53ZFvYyY1K67zU/D4T849rurl3vJ0gi2NDr5tZNPkzZ8a
        QYPNEBvRE8WHjciK9NmtyeRABG0o5tlvdUDnrcItxBuFVtTiCYz+xyp+LI5Ndfv+acE30cpOuGWwD
        caHfTPq0Fdv+Yojsf+5o3ZzTLzAITOAs/J4wUjiPdqPijRGpFrlRsskRkxT6fxfkvM7nhBdL3F1cw
        91GKiv2REcLX6YkKjOjyDZ5yPKAXsKMIxLdgeNw0vF/ry8R++1k7uTWmwAdp3FPUIIN61W4AjpYYx
        J7tapbJw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58674)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pcwb4-0001Qe-65; Thu, 16 Mar 2023 23:01:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pcwav-0002pC-9n; Thu, 16 Mar 2023 23:01:13 +0000
Date:   Thu, 16 Mar 2023 23:01:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org,
        agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        veekhee@apple.com, tee.min.tan@linux.intel.com,
        mohammad.athari.ismail@intel.com, jonathanh@nvidia.com,
        ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
Subject: Re: [PATCH net-next 08/11] net: stmmac: Add EMAC3 variant of dwmac4
Message-ID: <ZBOfuSBifFO7O/xQ@shell.armlinux.org.uk>
References: <20230313165620.128463-1-ahalaney@redhat.com>
 <20230313165620.128463-9-ahalaney@redhat.com>
 <20230313173904.3d611e83@kernel.org>
 <20230316183609.a3ymuku2cmhpyrpc@halaney-x13s>
 <20230316115234.393bca5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316115234.393bca5d@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 11:52:34AM -0700, Jakub Kicinski wrote:
> On Thu, 16 Mar 2023 13:36:09 -0500 Andrew Halaney wrote:
> > static void emac3_config_cbs(struct mac_device_info *hw, u32 send_slope,
> > 				    u32 idle_slope, u32 high_credit,
> > 				    u32 low_credit, u32 queue)
> > 
> > I agree, that's quite gnarly to read. the emac3_config_cbs is the
> > callback, so it's already at 6 arguments, so there's nothing I can
> > trim there. I could create some struct for readability, populate that,
> > then call the do_config_cbs() func with it from emac3_config_cbs.
> > Is that the sort of thing you want to see?
> 
> Yes, a structure is much better, because it can be initialized member
> by member,
> 
> struct bla my_bla = { .this = 1, .that = 2, .and = 3, another = 4, };
> 
> That's much easier to read. A poor man's version of Python's keyword
> arguments, if you will.

What I would say is be careful with that - make sure "struct bla" is
specific to the interface being called and not generic.

I had that mistake with struct phylink_state... and there is an
endless stream of people who don't seem to bother reading the
documentation, who blindly access whatever members of that they
damn well please because it suits them, even when either they
shouldn't be writing to them, or when phylink doesn't guarantee
their contents, they read them.

As a result, I'm now of the opinion that using a struct to pass
arguments is in principle a bad idea.

There's other reasons why it's a bad idea. Many ABIs are capable of
passing arguments to functions via processor registers. As soon as
one uses a struct, they typically end up being written to memory.
Not only does that potentially cause cache line churn, it also
means that there could be more slow memory accesses that have to be
made at some point, potentially making other accesses slow.

So, all in all, I'm really not a fan of the struct approach for
all the reasons above.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
