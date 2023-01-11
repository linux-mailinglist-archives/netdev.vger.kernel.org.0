Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35B6662DA
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjAKSel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjAKSea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:34:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F8537241
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:34:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7354B61DCE
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 18:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC00C433D2;
        Wed, 11 Jan 2023 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673462063;
        bh=IpJTaUEJjMTq5oX8LbaaunnRyiqEmlfRKOFdFDrg4T0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IZX0aSveFFJPF0G9+QZRMZGqFelpep4jL3PGyhzqGmD3DikmkdiRHXRMi4gHBiJcm
         wON7y2c0MlhfGVx64CjG374gfqY62A3A0jeLn/erBudNvN33jsic/3GtOGDG8XUfsF
         Fu3cc0OOOllwClxQYlBugok5w3ZGynN7w4IHG/pfhobUXypc7hBy52OoHhK/RsTUpm
         fayPSF68/15ZRXn0qAZfqAzQAYdW1+VdLq6XddrFWrTOb6buX6HCrNBJtnZcAAxfvs
         YPsOnntcs5iDlM8p4te2wJVYSOa8YFcdPACyEx5+fgFdsXX9DTd+jXe0OnkTU0vi0R
         t7r+rB8/WgPtw==
Date:   Wed, 11 Jan 2023 10:34:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Message-ID: <20230111103422.102265b3@kernel.org>
In-Reply-To: <20230111053045.413133-9-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
        <20230111053045.413133-9-saeed@kernel.org>
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

On Tue, 10 Jan 2023 21:30:38 -0800 Saeed Mahameed wrote:
> +	debugfs_create_file("hairpin_num_queues", 0644, tc->dfs_root,
> +			    &tc->hairpin_params, &fops_hairpin_queues);
> +	debugfs_create_file("hairpin_queue_size", 0644, tc->dfs_root,
> +			    &tc->hairpin_params, &fops_hairpin_queue_size);

debugfs should be read-only, please LMK if I'm missing something,
otherwise this series is getting reverted
