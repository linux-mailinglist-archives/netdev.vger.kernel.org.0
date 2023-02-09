Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1961D68FC32
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjBIAwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBIAwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:52:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E1712061;
        Wed,  8 Feb 2023 16:52:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EB7FB81FE3;
        Thu,  9 Feb 2023 00:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9CEC433EF;
        Thu,  9 Feb 2023 00:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675903956;
        bh=qQfNa8Ga6wjwcMS3AVNUxkLw48SuvlRiozdFyCSUCKU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RjTxCHy0JUqLTOeaDv8MCZyoy0qe+LiOXlBIWYbU8YnLrHP6rbrxYwq4ZWbjMeDmV
         KMvrV9mJgOuXqfhsJZaFneGmeVs8X4EHrQ9g6v8XSUc5ejQgiDDfsKTVUNhU1KgK7w
         cWXW6EIO9NMccFp+Lx7Rz/m/sPp9nY6A+fgXuOebcmjvf2gf4PDMgc2Y0fvd7daKuK
         VmfVuY/kLOpVltspwjSONB+eF2knOHJEM5UWGjuZrnl0pUcLi/4abLCTBn5uHKNWSY
         /E8ayenI37KlKVoFmPox0icivVrDNk6heSwPPYLNvaRw0dMIk4lMIu9EcsYr+RLYj1
         7yd0Y1XBpC6SQ==
Date:   Wed, 8 Feb 2023 16:52:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230208165234.3002ff25@kernel.org>
In-Reply-To: <Y+RAAowqXn1JmMY4@x130>
References: <Y91pJHDYRXIb3rXe@x130>
        <20230203131456.42c14edc@kernel.org>
        <Y92kaqJtum3ImPo0@nvidia.com>
        <20230203174531.5e3d9446@kernel.org>
        <Y+EVsObwG4MDzeRN@nvidia.com>
        <20230206163841.0c653ced@kernel.org>
        <Y+KsG1zLabXexB2k@nvidia.com>
        <20230207140330.0bbb92c3@kernel.org>
        <Y+PKDOyUeU/GwA3W@nvidia.com>
        <20230208151922.3d2d790d@kernel.org>
        <Y+RAAowqXn1JmMY4@x130>
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

On Wed, 8 Feb 2023 16:36:18 -0800 Saeed Mahameed wrote:
>>> I honestly have no idea why you are so fixated on TC, or what it has
>>> to do with RDMA.  
>>
>> It's a strong justification for having full xfrm offload.
>> You can't forward without full offload.  
> 
> This pull has nothing to do with "full" xfrm offload, 
> For RoCE to exist it has to rely on netdev attributes, such as 
> IP, vlan, mac, etc .. in this series we do the same for ipsec,
> we setup the steering pipeline with the proper attributes for
> RoCE to function.

I think I already admitted that the exact patches in the PR are of
secondary importance.

> I don't see it will be reasonable for the rdma user to setup these
> attributes twice, once via netdev API and once via rdma APIs,
> this will be torture for that user, just because rdma bits are not allowed
> in netdev, it's exactly that, some rdma/roce bits purely mlx5_core logic,
> and it has to be in mlx5_core due to the sharing of hardware resources
> between rdma and netdev.

That's very understandable because for you as the upstream maintainer
of mlx5 either side of the equation (netdev or rdma) are "your users".
Whether we need to be concerned about their comfort is much less
obvious to netdev maintainers.
