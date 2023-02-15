Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDF7698873
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjBOXBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 18:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjBOXBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 18:01:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956F1868C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 15:01:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47B19B823B4
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 23:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54D6C433EF;
        Wed, 15 Feb 2023 23:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676502091;
        bh=S3JPKtocPDazqnPz056/PFDSv9ZI6l49GNrWiGdjI28=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=InB4urtqpF3BOf+lIJoz0WLmqaVDU+5zuWdZ3xqTJiVISn4LyiMhYTuXbcf8kcv2e
         79WGxKuodojd/Z0eu5aZc2c5vpSf6PUAren3vFXZoCckyJhvvgJb/amCcOKok/adxn
         bcMIyYaopQeLEFt0IEmZs7824lEC3SKhvIQ0Arq9L3BT/p0zdACWBTqobW3NXTeYLK
         mEj+xCtsVvV7VuZ8oHt3Q34eGw2oiOmtUxiE5VvXNKgJcC4MksM1BNhKGAI3Yx8a2L
         86/tNL1prWxKlwXvgcL9nUGk/uefayTmf+E6w5vienz9IKGBgm65po7ETy5z/iZWXm
         4dgxRVIKYvxwA==
Date:   Wed, 15 Feb 2023 15:01:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 2/2] skbuff: Add likely to skb pointer in
 build_skb()
Message-ID: <20230215150130.6c2662ea@kernel.org>
In-Reply-To: <20230215121707.1936762-3-gal@nvidia.com>
References: <20230215121707.1936762-1-gal@nvidia.com>
        <20230215121707.1936762-3-gal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Feb 2023 14:17:07 +0200 Gal Pressman wrote:
> -	if (skb && frag_size) {
> +	if (likely(skb) && frag_size) {

Should frag_size also be inside the likely?
See the warning in __build_skb_around().
