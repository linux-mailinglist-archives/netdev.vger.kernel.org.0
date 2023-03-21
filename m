Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A52B6C3C2D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCUUtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCUUtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EA2BDD6;
        Tue, 21 Mar 2023 13:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A48A61E22;
        Tue, 21 Mar 2023 20:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E938DC433D2;
        Tue, 21 Mar 2023 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679431780;
        bh=2Wwfj2ffEfWI7ejpq1BZ8zSr3+KnhBGdy+rl/B7TI1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EPgqBAS7OR+RSqF8lbVStrb3JyJDsZt/Mzt6cOlEW+lT8jRf0pka0FLWTZASzZIZ8
         HRtDURVlmBpxTegB9ZoocN1gcjQSp21+CzqT3O1Ri9QLwFKZs4FUHkWHBumykMpp/Q
         UzNepFpaQaz2voK9f27YCAqKxmVBlms0GUqlHdjbX4/qe/QMNwbVjPU2ZEbhXIZN7x
         BW0C0eVO/bsOnospfulgKT1palYALQ6o2BMXRK8V1dXoetbzJnBB3hpNEvOpjlSe/Z
         2j9FSoPw75EBRj5UC6BYzT4/icvkhEnB+agr+b65iqxUIqRIlY6LMJkRMUiUOl5o7t
         cyFq/FUkwHR5w==
Date:   Tue, 21 Mar 2023 13:49:38 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakob Koschel <jkl820.git@gmail.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next] net/mlx5e: avoid usage of list iterator after
 loop
Message-ID: <ZBoYYhbE7TpIOFbf@x130>
References: <20230301-net-mlx5e-avoid-iter-after-loop-v1-1-064c0e9b1505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230301-net-mlx5e-avoid-iter-after-loop-v1-1-064c0e9b1505@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Mar 16:26, Jakob Koschel wrote:
>If potentially no valid element is found, 'priv_rx' would contain an
>invalid pointer past the iterator loop. To ensure 'priv_rx' is always
>valid, we only set it if the correct element was found. That allows
>adding a WARN_ON() in case the code works incorrectly, exposing
>currently undetectable potential bugs.
>
>Additionally, Linus proposed to avoid any use of the list iterator
>variable after the loop, in the attempt to move the list iterator
>variable declaration into the macro to avoid any potential misuse after
>the loop [1].
>
>Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
>Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>

Applied to net-next-mlx5.

Thanks.
