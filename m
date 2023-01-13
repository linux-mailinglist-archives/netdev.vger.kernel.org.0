Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9A668BB7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbjAMFt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjAMFtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:49:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD14687AC;
        Thu, 12 Jan 2023 21:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5046B62206;
        Fri, 13 Jan 2023 05:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08365C433EF;
        Fri, 13 Jan 2023 05:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673588833;
        bh=LW8TnaibHU54vrL0vPl9vuILz/2J0PtXSn9Y9MJpIM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jYXuikPElIiZLpCpgEPw9EzisX6zGqhA8mqkSB44BiFu/Wt0AnAdt9se/2o7AE5YP
         qm1RuwwbrJFHIpqEDlh7O0j0dyJShzn0/cZXM3C3TDaEmEnfbvWRbE3XviQrBnlCgA
         JHcHUBiolb+hvW1kqRxDbvnk0sBq5j40+yVgzkoG9v5zI8uFNVMPeL4lSmQsGiJ5at
         4pi1lUpHoI09/NO209TPNPI1q2hUObiyKpZtxXHUBpfnF934aBcYKylPDQJkSuf4pA
         ZKpwpsf8Rm3fMojzOIA2x7/4yfpcxJ6Aiaf248BEkgFR60dXgloQuZlOuCUmr56jk2
         ambovgE/5biTg==
Date:   Thu, 12 Jan 2023 21:47:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anand Moon <anand@edgeble.ai>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>,
        Johan Jonker <jbx6244@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix
 rv1126 compatible warning
Message-ID: <20230112214712.0a32189d@kernel.org>
In-Reply-To: <20230111172437.5295-1-anand@edgeble.ai>
References: <20230111172437.5295-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 17:24:31 +0000 Anand Moon wrote:
> Fix compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
> 
> fix below warning
> $ make CHECK_DTBS=y rv1126-edgeble-neu2-io.dtb
> arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
> 		 compatible: 'oneOf' conditional failed, one must be fixed:
>         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
>         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
> 
> Fixes: b36fe2f43662 ("dt-bindings: net: rockchip-dwmac: add rv1126 compatible")
> Reviewed-by: Jagan Teki <jagan@edgeble.ai>
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Anand Moon <anand@edgeble.ai>

I think this patch should go via net-next?
Please let us know when it's ready to be applied, 
'cause we're not CCed on the entire series..
