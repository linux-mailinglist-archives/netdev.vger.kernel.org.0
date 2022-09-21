Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC725BFE68
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiIUMwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiIUMvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:51:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF5F99B43
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DA6D624FE
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 12:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7511EC433C1;
        Wed, 21 Sep 2022 12:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663764606;
        bh=MHv32fEB5oDelwnd9aab7a+F3rCEU02zgCbRjdX9uQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lIB2GNits/Qmp6UPAaZ7J3VfE5aydloQutKehM59LVSrkCn9izV74NvJIyGD7/Srj
         6uarWzyLxtXiXsWoj2Ua735TflbQTClcQnsDeBjcNV2BHnwqtMkfxu9PHghE0DKvfq
         5a/6JREdbUQIKn9mgqvfST4ygAConJs4mXrp6WtSXhjljFQSzUJ9It4SoiVPdclETT
         xzCAE2O2ayDtlBHVUKSB2nCGWKadrtMw3RC5hUdK0PCNcTTzbiiZQjSqgZI3d6B5WI
         EqEOuHIdsD/Hn7SUHSL1GpxkJHYQYV0BzQNl8mTl073Fkq5siqI0JcofWH2rdfexrj
         AuseycwtxGB2A==
Date:   Wed, 21 Sep 2022 05:50:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [RFCv8 PATCH net-next 02/55] net: replace general features
 macroes with global netdev_features variables
Message-ID: <20220921055004.10b6881b@kernel.org>
In-Reply-To: <0f60d53a-bde7-d5c7-f589-99774485f545@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
        <20220918094336.28958-3-shenjian15@huawei.com>
        <20220920131233.61a1b28c@kernel.org>
        <35b4b477-14b0-1952-4515-c96933e6f6dd@huawei.com>
        <0f60d53a-bde7-d5c7-f589-99774485f545@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 18:01:16 +0800 shenjian (K) wrote:
> =E5=9C=A8 2022/9/21 14:33, shenjian (K) =E5=86=99=E9=81=93:
> >> On Sun, 18 Sep 2022 09:42:43 +0000 Jian Shen wrote: =20
> >> We shouldn't be changing all these defines here, because that breaks
> >> the build AFAIU. =20
> > ok, will keep them until remove the __NETIF_F(name) macro.
> > =20
> But I don't see how it break build. Do you mean the definition of
>=20
> WG_NETDEV_FEATURES in drivers/net/wireguard/device.c =EF=BC=9F

Oops, you're right, looks like this patch just adds a warning:

net/core/netdev_features.c:99:13: warning: no previous prototype for functi=
on 'netdev_features_init' [-Wmissing-prototypes]
void __init netdev_features_init(void)


Build is broken by the next one:

drivers/net/ethernet/microsoft/mana/mana_en.c:2084:2: error: implicit decla=
ration of function 'netdev_hw_features_zero' is invalid in C99 [-Werror,-Wi=
mplicit-function-declaration]
        netdev_hw_features_zero(ndev);
        ^
drivers/net/ethernet/microsoft/mana/mana_en.c:2085:2: error: implicit decla=
ration of function 'netdev_hw_features_set_set' is invalid in C99 [-Werror,=
-Wimplicit-function-declaration]
        netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BI=
T,
        ^
drivers/net/ethernet/microsoft/mana/mana_en.c:2085:2: note: did you mean 'n=
etdev_hw_features_zero'?
drivers/net/ethernet/microsoft/mana/mana_en.c:2084:2: note: 'netdev_hw_feat=
ures_zero' declared here
        netdev_hw_features_zero(ndev);
        ^
