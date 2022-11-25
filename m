Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C8A6382E5
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 04:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKYDxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 22:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKYDxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 22:53:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9E32B1A5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 19:53:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB62BB8294F
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 03:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512F9C433D6;
        Fri, 25 Nov 2022 03:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669348427;
        bh=h9+VWJhzNUUQVeKL9cX0SMWNsfJgSbncTszhe3pKzxo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=iCfVkgQFtGoQsYD6K2gvqf7hxT+DhAAPPV3Dq4X+mLStf3vAs/26kGBDsI9gaFjX2
         hg/lbsjUrPEm1y5UG6+oxu4smMpGa8qF2/mBLKbOoE+Bv7XAPcbRPrzahsvIiyvPUS
         eIsFjvT483b1iSQuawEUFdl/Lp9UucxGb4UmPBuhKH2++RxXkeUgG9E7DTayodDw/P
         dl70ktl38LeFfxBkpcsEWL0U2xMBVoSFLK5hKWDJLSHwGEihq//NG34RKA/+3nugqD
         Xu18zES2wn5pBNrVrMY1fhABaeWY+KSIf1dZM4GKxw5qCkKbQQ+ZaCTJDXkK4IdZxb
         9sgyrQnAiaOVg==
Message-ID: <f0e40fda-a162-2b05-4d77-55f6dea4e84f@kernel.org>
Date:   Thu, 24 Nov 2022 19:53:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: RTM_DELROUTE not sent anymore when deleting (last) nexthop of
 routes in 6.1
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <Y39me56NhhPYewYK@shredder>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <Y39me56NhhPYewYK@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/22 5:41 AM, Ido Schimmel wrote:
> Looking at the code and thinking about it, I don't think we ever
> generated RTM_DELROUTE notifications when IPv4 routes were flushed (to
> avoid a notification storm).

exactly.
