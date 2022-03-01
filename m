Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F034C9041
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiCAQYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbiCAQYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:24:02 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D7DB7DD
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:23:20 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 157835C0108;
        Tue,  1 Mar 2022 11:23:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 01 Mar 2022 11:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ii/N9bVxzZEIEA/ud
        ZaoEwnrklYQTwRSfOhK6813EEI=; b=I5OV4N7hbFJZL3DPs20rn4aaE7gHjQGfk
        5dts93rOenfKG4qUFDesEyNfV0QiKFT+HbyMNvWNmevFswQXniSR1od+SFO/jaMj
        C+D2YuGd0ynqWtUgHj4ovkGlPWntwcEi2qxpZdjet0UBTRILwj/i48VGy9ULu3UW
        1c4gwmJ1E+L8cmc+EdKiPE1c5i8kGGwkZRVgxEBU38U/6ARJ/mAP+l8xadQmIhZn
        Na43lgOEwh8IpuMpUY66VcHSjFpa1Ki8LBf+tS6YywEJIFcPjJfAmnxJTSvPadZt
        pTF0oGTvlPAfncXi6zinID3i5fV2rK0nnq0AlhwNCjbe+ewL5pVQw==
X-ME-Sender: <xms:d0geYgw4IerotpAiotlCDl1jMAgrfVXCNx4c4drOgBBnpR9Ol7kJ0Q>
    <xme:d0geYkTBheNDlS4G9pMcUY2RLbN5ZhlyNslbp9W1j3Voj3ZAViwaC5kusrbbeX63l
    rhSonr1gGSxTaI>
X-ME-Received: <xmr:d0geYiW6piXRkHFa3D2St3kTmVmVsKZRE_6YaI_8drE1LZJOVBKbMoAiVzws4_9SzX_HkF5s2gJoCkfKMcZBbh-TXgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtvddgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:d0geYujrOcjD3MCc8w_J9zvxN-P-fupFBuiqD67JkoaVx_uXj4PzTg>
    <xmx:d0geYiCmvzDILE6-K5S0Cohn7LQhyJN6i936qkzmh8dgpWALrc43gw>
    <xmx:d0geYvIXQVds4V7vj0W46thnMbAyn9WdcAISvziQ8huA3BRJ0hX3iA>
    <xmx:eEgeYtPJ5VYJpFxezXrK2ibQuDaYm1JstcZV-w_H-9Zi2u0zrHI3Dw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Mar 2022 11:23:19 -0500 (EST)
Date:   Tue, 1 Mar 2022 18:23:16 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net] net: dcb: flush lingering app table entries for
 unregistered devices
Message-ID: <Yh5IdEGC9ggxQ/oy@shredder>
References: <20220224160154.160783-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224160154.160783-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 06:01:54PM +0200, Vladimir Oltean wrote:
> +static void dcbnl_flush_dev(struct net_device *dev)
> +{
> +	struct dcb_app_type *itr, *tmp;
> +
> +	spin_lock(&dcb_lock);

Should this be spin_lock_bh()? According to commit 52cff74eef5d ("dcbnl
: Disable software interrupts before taking dcb_lock") this lock can be
acquired from softIRQ.

> +
> +	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
> +		if (itr->ifindex == dev->ifindex) {
> +			list_del(&itr->list);
> +			kfree(itr);
> +		}
> +	}
> +
> +	spin_unlock(&dcb_lock);
> +}
