Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A060B641917
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 21:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiLCUoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 15:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCUoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 15:44:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C1A60EA;
        Sat,  3 Dec 2022 12:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DD66B80782;
        Sat,  3 Dec 2022 20:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BA5C433C1;
        Sat,  3 Dec 2022 20:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670100238;
        bh=Mjt6xiXtxGYM7hTuzc+6X726pwVTwWJ7KDsMrRCyBqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sC01FcTHOatBjyQjO1V0AOdBS3VZsPMseu0z32NLF02KYmcabavP0BQk27gQhXiEi
         ihg2w4Zo9gN38cthfobICA+hj0fetFrqZPIvfRzDZ1Q1Ig54TpcOGzeRkN1oenPffw
         f+k6FVaXedlo5Kkbt8nmiGixVg9+wk/tSYvrUrn9WXVzJsM08VZO7W686gYCyC1Vhb
         URKHPmddGQcc4zrhARzfsKDOIMSXnD64i8/UhL2It1x1SEUM7+JbOgMWISwpJpRmdk
         MT2r/E+7VFmzPdfLCqsdypaO0ZTiCxcBbUWsEKUEC+1kwvZvgusxAchkNiMtgbvP59
         +NsCF38rTY/3w==
Date:   Sat, 3 Dec 2022 12:43:57 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, zhang.songyi@zte.com.cn,
        saeedm@nvidia.com, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, mbloch@nvidia.com, maorg@nvidia.com,
        elic@nvidia.com, jerrliu@nvidia.com, cmi@nvidia.com,
        vladbu@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: remove NULL check before dev_{put,
 hold}
Message-ID: <Y4u1DVbFWFPx3hMf@x130>
References: <202211301541270908055@zte.com.cn>
 <Y4cbssiTgsGGNHlh@unreal>
 <20221130092516.024873db@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221130092516.024873db@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30 Nov 09:25, Jakub Kicinski wrote:
>On Wed, 30 Nov 2022 11:00:34 +0200 Leon Romanovsky wrote:
>> On Wed, Nov 30, 2022 at 03:41:27PM +0800, zhang.songyi@zte.com.cn wrote:
>> > From: zhang songyi <zhang.songyi@zte.com.cn>
>> >
>> > The call netdev_{put, hold} of dev_{put, hold} will check NULL,
>> > so there is no need to check before using dev_{put, hold}.
>> >
>> > Fix the following coccicheck warning:
>> > /drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1450:2-10:
>> > WARNING:
>> > WARNING  NULL check before dev_{put, hold} functions is not needed.
>> >
>> > Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
>> > ---
>> >  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
>> >  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> Please change all places in mlx5 in one patch.
>
>Your call as a mlx5 maintainer, but I'd say don't change them at all.
>All these trivial patches are such a damn waste of time.

I agree, let's not waste more time on this, I will accept this patch as is
since it's already marked awating-upstream.. 

Applied to net-next-mlx5
