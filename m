Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528486CF0BE
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjC2RKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjC2RKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B54F6A7A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8664B823ED
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 17:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD78C433EF;
        Wed, 29 Mar 2023 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680109779;
        bh=xV7w7Q0pVqLo/nNFlpe1jdPZ2c7ehLkGmjBGDMfaA+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tc+vPrXwkUpUUoQYDVGJabd5B9GwEURLi1pM3qbus2+uTQ6S4iKRZNO0M+IOt7bLR
         TiFkYPc52EREv49nOEGAwfmLTTrcOkGyRqKxK26MPDdya1AnzFULlCao2mVWoTqygS
         cL4f5/tRkkoVyEIlkx06H0nB+mA7hzCE7drlwGQo1j+WkCP/LdOCb/+Iy+Ulm5o++Y
         uzhcDvYPHRKR4RROmyG2HDu0eac+g8RS5ssJJ2hftsYgiuTpLTasGVoU8jiAzurjxs
         6DBnl51ySyHjbW9kI5LjR3Gfb2Bg6T0sIV826nlwLHplHYV6KYC+iazqCmca5r71EF
         PGeJpHL7aKMZg==
Date:   Wed, 29 Mar 2023 10:09:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] devlink: Add port function attributes to
 enable/disable IPsec crypto and packet offloads
Message-ID: <20230329100938.1f8f8d9f@kernel.org>
In-Reply-To: <20230329074537.GH831478@unreal>
References: <20230323111059.210634-1-dchumak@nvidia.com>
        <20230323100556.6130a7cd@kernel.org>
        <20230329074537.GH831478@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 10:45:37 +0300 Leon Romanovsky wrote:
> On Thu, Mar 23, 2023 at 10:05:56AM -0700, Jakub Kicinski wrote:
> > On Thu, 23 Mar 2023 13:10:55 +0200 Dima Chumak wrote:  
> > > Currently, mlx5 PCI VFs are disabled by default for IPsec functionality.
> > > A user does not have the ability to enable IPsec support for a PCI VF
> > > device.  
> > 
> > Could Mellanox/nVidia figure out a why to get folks trained on posting
> > patches correctly? IDK how to do that exactly but you have a rather
> > large employee base, it may be most efficient if you handle that
> > internally than the community teaching people one by one.  
> 
> IDK why Dima postes like he posted, but we guide people and provide nice playground
> to test submissions internally, but it is not enough. There are always nuances in
> submission as rules constantly evolve.

I'd say that we try to improve the documentation these days more 
than evolve the rules. The suggestion for how to post user space
is 2.5 years old:

commit 6f7a1f9c1af30f1eadc0ad9e77ec8ee95c48b2c9
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Tue Nov 24 20:15:24 2020 -0800

    Documentation: netdev-FAQ: suggest how to post co-dependent series

> > Or perhaps there's something we can do to improve community docs?  
> 
> People don't read them :)

We can make them, but then we'll be the bad guys again :(
