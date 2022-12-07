Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7302F64601A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLGRZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLGRZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BFE5AE36
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DD52B81FE6
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1E2C433D7;
        Wed,  7 Dec 2022 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670433918;
        bh=PYXBz1lZtktY026NANZtDmxn4UMOWMjcu6x5rTKbVaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xs0G57pcDcmAj/3XoYKWjqtiRskL4nLKhH5Mq4ea1U2TlzYdicoWt9Zivr041rdjU
         TmhASNmFGAX0fI9J1WCoXE3RdXtOluOl4FUpQLVR0s7NSeUzOlYFOaCY6/0CKzeVkn
         egjtm+K221GAK36eZl9XL4UrXpGrz23/CNL7UADCcWKgIMfHB5LBfav3hM1TPWFxEc
         yGTA1x5rNYMbc3geL3dz05RDX0Kf7ckfh2zj+Hk42TR8vXe97vLalaPrz7zZ8Um2BD
         4P0CvSSdbi9B30JMA9KGfn8nJM1draCzQ2TiRvWDSBMay2gEfTuzX42+ut8HurLCHx
         pCJOT+rFZMzUA==
Date:   Wed, 7 Dec 2022 09:25:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <20221207092517.3320f4b4@kernel.org>
In-Reply-To: <Y5AitsGhZdOdc/Fm@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
        <20221203221337.29267-15-saeed@kernel.org>
        <20221206203414.1eaf417b@kernel.org>
        <Y5AitsGhZdOdc/Fm@x130>
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

On Tue, 6 Dec 2022 21:20:54 -0800 Saeed Mahameed wrote:
>> I can't take this with clear conscience :( I started nacking any new use
>> of the legacy VF NDOs. You already have bridging offload implemented,
>> why can bridging be used?
> 
> I really tried, many customers aren't ready to make this leap yet.
> 
> I understand your point, my goal is to move as many customers to use
> upstream and step away from out of tree drivers, if it makes it any
> easier you can look at this as filling a small gap in mlx5 which will
> help me bring more users to the upstream driver, after all the feature
> is already implemented in mlx5, this is just a small gap we previously
> missed to upstream.

I recently nacked a new driver from AMD which was using legacy NDO, and
they can be somewhat rightfully miffed that those who got there earlier
can keep their support. If we let the older drivers also extend the
support the fairness will suffer even more.

We need to draw the line somewhere, so what do you propose as our
policy? Assuming we want people to move to new APIs and be fair 
to new vs old drivers. 
