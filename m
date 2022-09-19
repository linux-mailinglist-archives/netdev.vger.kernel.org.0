Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC7A5BCF78
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiISOrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 10:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiISOrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 10:47:19 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6FD205D3
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 07:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z+kxORwauhUb0TYPJWG77jP59WmKxaCL2UYsRCGZbfA=; b=g9VRpivwBgvUntOEV8hQ8sxEFY
        NnMwLtKNIM2AMT93kPpjMpiNlYhNiVvCcfV7pORcR0y2jilq33QN/MdFDoCti9zZRArzKuJ1so8sC
        N/8rh4NgLYVfpBXnKFV+2HT5KB46DyynCN8Cfk+YaRTiN4V2JDVx80XwLJQIvRWyJAi6Ut8i510uc
        3Tx6aEbI403LISIyz86vU3KGukdCF6Lq06fRsVlkI4KTanbKGAoWldEfg8NRVj9Zql/iU4nM6xmrj
        PK4JVzn1tfIZrQZrorVKi1Cv9apb9KUleApjwbiKP0xC7Pa213Np7YI24+lR32zbR273DRW0I9Vnh
        67iLzthA==;
Received: from [92.206.252.27] (helo=javelin)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oaI3G-0019Ch-74
        for netdev@vger.kernel.org; Mon, 19 Sep 2022 14:47:14 +0000
Date:   Mon, 19 Sep 2022 16:47:13 +0200
From:   Alexander 'lynxis' Couzens <lynxis@fe80.eu>
To:     netdev@vger.kernel.org
Subject: Handle phys changing the interface between 2500basex & SGMII
Message-ID: <20220919164713.13bb546e@javelin>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've a mediatek mt7622 SoC connected to a realtek 2.5gbit copper phy
(rtl8221) via SGMII/2500basex.

The rtl8221 is changing its phy interface depending on the link.
So 2500basex for 2.5gbit copper and for all lower speeds (down to
10mbit) it's using SGMII.

What's the best way to implement it?
Should the phy driver change the phy_interface on link up?

As a hack I've modified mac_link_up to handle the different speeds
and changed the phylink_mac_ops validate to allow advertising lower
speeds on 2500basex.

Best,
lynxis
