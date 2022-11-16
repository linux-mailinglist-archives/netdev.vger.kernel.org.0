Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2562CED2
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiKPXgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiKPXgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:36:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A14AF29
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:36:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 804DF6204D
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC8BC433C1;
        Wed, 16 Nov 2022 23:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668641769;
        bh=YXNyog7zqus4isM+WVpqyJTvWQueVicIoSCuR3+HRaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkLWU/0bh5GjhVOnCWHBgq/tnnDJdY1g9W5vtensf99iXQ50d2Xv1DTIRAQ4y5ItS
         Xu83DB6PHinW0bYGs41O73jd+B8ZHxaLnHniJggEcapMRx20U7i9uDKO9ictcUTZhJ
         K0V+lM5PsR5Vuml4hvT6rHNAd/KJhLAY97LvFI5ydBH3bmdV0FTg6EIAOONOAsVKXz
         /r8Vvpy7rVnOJ2L7ktnyyrRp68H3dAUGhTT9+xAF2h6YFebYXKsQc6w1ZFuRtfof6R
         RzW5TZKChVYfAQ0CsLKAIZFnsJee0vrvXU2PmSaMyEhleBNPEZKm1HJMJ7E/OQs+k4
         /GONOPlGinbpA==
Date:   Wed, 16 Nov 2022 15:36:08 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next v3 2/2] gve: Handle alternate miss completions
Message-ID: <Y3Vz6BIlgE92hsA4@x130.lan>
References: <20221114233514.1913116-1-jeroendb@google.com>
 <20221114233514.1913116-3-jeroendb@google.com>
 <Y3RyUn8RLzyA6bGF@x130.lan>
 <CAErkTsQALv3NL2jvFY1xgaXsWCPtavZP1UTgDcqo-YBdQCyjzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAErkTsQALv3NL2jvFY1xgaXsWCPtavZP1UTgDcqo-YBdQCyjzQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16 Nov 08:23, Jeroen de Borst wrote:
>Saeed,
>
>Thanks for your review. I like the suggestion, but
>__test_and_clear_bit is for unsigned longs, comptag is a short.
>

gcc will up-cast it for you with no problem.
Assuming it's unsigned short.. if not then consider changing it to unsigned
short, or do the casting yourself.

anyway this was just a minor suggestion. 
