Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD15562D7BC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbiKQKKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239338AbiKQKJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:09:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E310E32BB9;
        Thu, 17 Nov 2022 02:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E4A3B81FC9;
        Thu, 17 Nov 2022 10:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F72C433D6;
        Thu, 17 Nov 2022 10:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668679792;
        bh=fh4h+my1vHfdEW4dXSNVVgKU5JyWQEijupVnZaEobzQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Eq32OjiGAfLNDs6XsCukpJDWhiTh8CHucHmSaAPE6nz4u0/3RKeuFbA8fQ85n7vzV
         fi27lkn6Gpeq5H03twBsYZcF2eER6EkUNVg0KtS7zWqjE3Mdqdve8dO8g/OODt77K1
         Su173rrJANrrm/ZzInFwYwhBAV8QrROlMHHu1pSddygp4MhkpqbyetI3mR7FI2tbrl
         UBAXsETJ2xMmbS0MYKQP72PiKrzVjU/FreoFrZjNib5sHMxcUY1n0BHknbwahhIiE1
         YuufflsoXpVkcRqHjn8nG8nc7hWc6iXBRdFz8tFcBnApy3QrJ+nni52R2Ra2iygJuD
         lYCiBX3N3aF3Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johnny Kim <johnny.kim@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Park <chris.park@atmel.com>,
        Rachel Kim <rachel.kim@atmel.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless] wilc1000: fix potential memory leak in wilc_mac_xmit()
References: <1668657419-29240-1-git-send-email-zhangchangzhong@huawei.com>
Date:   Thu, 17 Nov 2022 12:09:47 +0200
In-Reply-To: <1668657419-29240-1-git-send-email-zhangchangzhong@huawei.com>
        (Zhang Changzhong's message of "Thu, 17 Nov 2022 11:56:58 +0800")
Message-ID: <877cztsxhw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> writes:

> The wilc_mac_xmit() returns NETDEV_TX_OK without freeing skb, add
> dev_kfree_skb() to fix it.
>
> Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Same as in your other patch, have you tested this is on a real device?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
