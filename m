Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831B26054A7
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJTBBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJTBBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:01:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C144143A66
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 18:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A60DB82648
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 01:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53761C433C1;
        Thu, 20 Oct 2022 01:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666227668;
        bh=C/4vGf5vXBYNQl1OLn7WOgTlElaIGQVUO9hZuKgzfgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ClOavNofcQN1rCxiU13kksEAgu62N5zqs5fySVt1BdaUIzqvZ/NeJwHOAN2rLYqEf
         k8woCsCK4eMT3wpDR48N3B9Rx/zgA3FPDuJ8qIY2MkzA5Kdyl7HtZ4bK2t6rJTgKIv
         K806cjPxjJoUU5Z0UsY2FZ9HpzRH1GuJuL8AKNm1S7OVn/wbPK9LD6tCneNYyh8Yxx
         yc3sowCSN961VSM9su1DXi5iK+b/vpioG/mnAhrAylHG7K9TkmgXFltJiO3vsylAWW
         GS+9ucZuwVsfpTn+O6G2UBEc2xikzptFmenmOLNKmGL7nemgC0DI9tYSoUsWYc43CM
         FatpMe//MDHsw==
Date:   Wed, 19 Oct 2022 18:01:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Message-ID: <20221019180106.6c783d65@kernel.org>
In-Reply-To: <20221019140943.18851-1-simon.horman@corigine.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 16:09:40 +0200 Simon Horman wrote:
> this short series adds the max_vf_queue generic devlink device parameter,
> the intention of this is to allow configuration of the number of queues
> associated with VFs, and facilitates having VFs with different queue
> counts.
> 
> The series also adds support for multi-queue VFs to the nfp driver
> and support for the max_vf_queue feature described above.

I appreciate CCing a wider group this time, but my concerns about using
devlink params for resource allocation still stand. I don't remember
anyone refuting that.

https://lore.kernel.org/all/20220921063448.5b0dd32b@kernel.org/
