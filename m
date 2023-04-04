Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CC46D6993
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbjDDQzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjDDQzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:55:17 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5CF55A2
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 09:54:52 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230404165448euoutp0249d1ba843cc8608bbc5b73c57cc7f120~SyZ1eciJ03244932449euoutp02X
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:54:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230404165448euoutp0249d1ba843cc8608bbc5b73c57cc7f120~SyZ1eciJ03244932449euoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1680627288;
        bh=9iMtrK6fAZfZzrbdyofBDo6C2P9YnJ8/Q5xMXgSr0IE=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=bbNimj9zsebe7WLvAoeAcalNN/eCswdTY2cQZs2dKIZI8RHhE0roVuCyrtDvPyeyr
         OxH7HNaIk0wOQEV40q2J7LOO/FJ48C3N0GNEaXhFvfdB7RcXL42fGJlUbzqLdgU9eu
         +fxvakQ9HTG56+SfZ50COmR3/vi8Zd76Bvt1hKdk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230404165448eucas1p1080a3deead7dd60858a31b5de3e1ddcf~SyZ09kW9r0653906539eucas1p1X;
        Tue,  4 Apr 2023 16:54:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 2F.02.09503.7565C246; Tue,  4
        Apr 2023 17:54:48 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20230404165447eucas1p114076509978a487acfe8312e2e58ecca~SyZ0lHlJv0397903979eucas1p1j;
        Tue,  4 Apr 2023 16:54:47 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230404165447eusmtrp1c8b2a2e46e8627a0c524a720e35045ca~SyZ0kS5EI2480424804eusmtrp1h;
        Tue,  4 Apr 2023 16:54:47 +0000 (GMT)
X-AuditID: cbfec7f2-ea5ff7000000251f-ab-642c565720ee
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id BD.21.08862.7565C246; Tue,  4
        Apr 2023 17:54:47 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230404165446eusmtip1b38a853bf083a308106b4b63a94bb7d2~SyZzdMr450566905669eusmtip1L;
        Tue,  4 Apr 2023 16:54:46 +0000 (GMT)
Message-ID: <d4750775-5d74-a081-f7a4-11d67fdb80ea@samsung.com>
Date:   Tue, 4 Apr 2023 18:54:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
        Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [RFC net 1/1] net: stmmac: skip PHY scanning when PHY already
 attached in DT mode
Content-Language: en-US
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20230404091442.3540092-1-michael.wei.hong.sit@intel.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfVDTZRy/5/ey/VgOf0yK57AX22V3YKJcej0dizIFf/2hWb5xeAY79ouZ
        A7xNCuHMnRCMNV4OW8F4WzgCFLGbOB0oiwWDSeJggG+AYhvgHHFEdSFZMYbFf5/v5/P9fD/f
        53sPhQtOc0KpQ6lHWXmqWCbk8AiTba53fdy+1yQbz3oAmnv4NUA3Rqw4cp2v4aCKGzkEctse
        cFHNdCmJrmnsGBrIqSPQaM0vJHKYCklk/HmIRM6WCg5SD7lIZNVeBchWYydQ1ZNzJKo+acZQ
        X/d1HNn0z6E/erwA/fPoIkAny4wLKEdJoNqOUu47kHEO9eFMc8NtjHEXXeQyZt0Il9Eb0xl3
        8Skuc/rKQ4wxnsnnMBcMJxjz5VmMmW4b5DDtbZGM+8+rC0bLLGBmjS/uWhnPE0lY2aFPWfmG
        6ESeVFtVzTlSzs8oLLDgSuDiqUEABelNsDYvm1QDHiWg6wG0m34kfYKA/g1AT0GiX5gF0FDi
        JZ86yhuqOH6hDsDJxpalYgbA0c5B4Ovi09FwzHwX82GCfgW253YTfj4I2stci/hZWgJb7W6u
        D6+iE6Gqq2IR43QIvOOqxnxDg2kjCUfrGoGvwGk1Bn/qdS9O5dCRUD2l5vhwAB0L81tHltwv
        wUtTFbjPAGktD/7w+3dLi2+DD0rvAz9eBT1dzVw/fh72nNIQfkMegPr5e5i/KAZQOXFnyREF
        h3sfL8RRCxFh8HzLBj+9BXbYtbiPhnQgvDUV5F8iEJaYvlmi+VCVK/B3vwp1XU3/xbY7+vFi
        INQtO4xu2QF0y56j+z9XD4gzIIRNV6Qks4rIVPazCIU4RZGemhyRlJZiBAv/uOfvrl8vg0rP
        TIQVYBSwAkjhwmD+WnW4RMCXiI9lsvK0BHm6jFVYwWqKEIbw171lTxLQyeKj7GGWPcLKn6oY
        FRCqxPbEZtRLVZ3X5uIT3j3uWdN8bCwm8ct7dERsrejN3ePlWyfMdwtl6rKbltBNUwZQeT1o
        xWPXAVGMpjEDf+RUz9c5FP0nDA7jbYfscHCfI1G6N+zj+mGltkHy1aVAG+hcWSc7qLg/XF10
        oTG6IGb/rOijPRbvThPaNT3TWvtJda4qa3+egbzyvndwzdY3NJtf/iCqxrI9Ljj783Prtmiy
        c18//uQ9b9otoUggihXuKGq6OdCdtfnbku9XxL+9czIzKax/9fqwtuLacNLb8Zd+x8ED+R+a
        9ZL5icrh8W0Du7OixkbWTpbzm/IMugbDxhecKum41zvyjPOLuL1nU6j+hH3OzA4hoZCKI8Nx
        uUL8L1QAL8s2BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t/xu7rhYTopBr3fVCx+vpzGaHH+7iFm
        iyfrF7FZzDnfwmLx9NgjdotF72ewWpzqOclkcaVlOYvFvUXvWC0ubOtjtdj0+BqrxeVdc9gs
        uq49YbU4NHUvo8WxRSdZLOb9XctqMb9pJ5PFxRNnmS2OLRCz+Hb6DaPF/9dbGS2aZm4Csloa
        WCyWHpnB7iDhcfnaRWaPLStvMnk87d/K7rFz1l12jwWbSj2eTpjM7rF4z0smj02rOtk8Ni+p
        99i54zOTx/t9V9k8Du4z9Hj6Yy9Q4/7PjB6fN8kF8Efp2RTll5akKmTkF5fYKkUbWhjpGVpa
        6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZUydN5+tYDZvRV/vfuYGxidcXYycHBICJhKz
        V85j62Lk4hASWMoo8aR1JiNEQkbi5LQGVghbWOLPtS6ooveMEmf+PmEHSfAK2Ek83HmbCcRm
        EVCRONh2ggUiLihxcuYTMFtUIEVi14SlYDXCAgkSHcfngPUyC4hL3HoyHywuIrCFVWL/slCI
        eA+TxNXdxSC2kICrRPudjWwgNpuAoUTX2y4wm1PATaJz912oOWYSXVu7GCFseYntb+cwT2AU
        moXkjFlI1s1C0jILScsCRpZVjCKppcW56bnFhnrFibnFpXnpesn5uZsYgaln27Gfm3cwznv1
        Ue8QIxMH4yFGCQ5mJRFe1S6tFCHelMTKqtSi/Pii0pzU4kOMpsCwmMgsJZqcD0x+eSXxhmYG
        poYmZpYGppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTAaObJMfmm6efeamUYyz+qvE
        1OPFS/6er9fTc1/DN/XCIq3yloV6YinR9y/rBGWxprVx3Tyw/9dWO0nF4Cy+u39cBW6HiPL1
        sW33c7nl2rNp6raCrEC+2w+i34cIemhtUE55NzEo9Rtjf/WTi/l++w+//HBLobD7sa154DyJ
        6Z06p/PuMt/TXi9r1HXnZsT1k29Lvio8zCut+2EbuuPbgQBjsz6FD3dN5+tFs/7mjJXLuNfL
        sd8n5di0BTr8WzYGzswtz5Q4uuXLcoXsxz07515ee+ayf9Q2eY45Hy6EOzi7+b+2cxSf1r/9
        1RW/lJV3V8/VCr3Xfzpr4s4Ic2fWINH9KWoifarOV29dnvL5vxJLcUaioRZzUXEiABZe+xLG
        AwAA
X-CMS-MailID: 20230404165447eucas1p114076509978a487acfe8312e2e58ecca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20230404165447eucas1p114076509978a487acfe8312e2e58ecca
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230404165447eucas1p114076509978a487acfe8312e2e58ecca
References: <20230404091442.3540092-1-michael.wei.hong.sit@intel.com>
        <CGME20230404165447eucas1p114076509978a487acfe8312e2e58ecca@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 04.04.2023 11:14, Michael Sit Wei Hong wrote:
> If PHY is successfully attached during phylink_fwnode_phy_connect()
> in DT mode. MAC should not need to scan for PHY again.
>
> Adding a logic to check if ovr_an_inband is set before scanning for
> a PHY, since phylink_fwnode_phy_connect() returns 0 when
>
> 	phy_fwnode = fwnode_get_phy_node(fwnode);
> 	if (IS_ERR(phy_fwnode)) {
> 		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> 			return -ENODEV;
> 		return 0;
> 	}
>
> Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

This fixes broken ethernet observed recently on various Amlogic Meson 
based boards (like Khadas VIM3 or Odroid-C4). Thanks!

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index d41a5f92aee7..4b8d3d975678 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1149,7 +1149,7 @@ static int stmmac_init_phy(struct net_device *dev)
>   	/* Some DT bindings do not set-up the PHY handle. Let's try to
>   	 * manually parse it
>   	 */
> -	if (!fwnode || phy_needed || ret) {
> +	if (!fwnode || (phy_needed && priv->phylink_config.ovr_an_inband) || ret) {
>   		int addr = priv->plat->phy_addr;
>   		struct phy_device *phydev;
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

