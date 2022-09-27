Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4099A5EB623
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiI0AQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiI0AQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:16:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06653A2A9A
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B6A8B81684
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAEAC433D6;
        Tue, 27 Sep 2022 00:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664237785;
        bh=hAKb5FNaTXADdjQbu5IJKHzwIHko38zKDPvf4F3gat8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ghUqO6hd6Pt+aVedZ7ROjNpvnfCnaLjYfwPWHoiVJWMqPTtQmtBEeLjXDglo8Tjgy
         qUqcGcKdfLe17TT8R18MJ4fIeOtoQkJKYNF9CQD7BaNjT4fmMQ3LauV0t7gjZetNr0
         letnw3CbfVuvz3v/+lkVTjE6TLbJ+Zs+iLrPrvCzLKa+VV9JJ3A1EUTRacjyDT442p
         WHzvxkCYEiwJcqOIHg9L66Vz2gO+r775e1vP6Yh8Z9K6bJ5rXQ/D7ISWdv/LWoXLH5
         7mxaoIkH+hOyQDTX/1hRfeNh40FESH5Xr9XFL3U0zvHtl/h6lPtMxdjpj3o+XVJL5h
         3acZSF8PlKlFw==
Date:   Mon, 26 Sep 2022 17:16:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <20220926171623.3778dc74@kernel.org>
In-Reply-To: <7003673d-3267-60d0-9340-b08e73f481fd@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
        <20220915134239.1935604-3-michal.wilczynski@intel.com>
        <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
        <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
        <20220921163354.47ca3c64@kernel.org>
        <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
        <20220922055040.7c869e9c@kernel.org>
        <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
        <20220922132945.7b449d9b@kernel.org>
        <732253d6-69a4-e7ab-99a2-f310c0f22b12@intel.com>
        <20220923061640.595db7ef@kernel.org>
        <7003673d-3267-60d0-9340-b08e73f481fd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Sep 2022 17:46:35 +0200 Wilczynski, Michal wrote:
> Also reconfiguration from the VM, would need to be handled by the VF 
> driver i.e iavf.
> So the solution would get much more complex I guess, since we would need 
> to implement communication between ice-iavf, through virtchnl I guess.

Yup, but it's the correct way to solve your problem AFAICT.

AFAIU you only want to cater to simple cases where the VF and PF 
are in the same control domain, which is not normal, outside of 
running DPDK apps. Sooner or later someone will ask for queuing 
control from the VFs and you're have to redesign the whole thing.
