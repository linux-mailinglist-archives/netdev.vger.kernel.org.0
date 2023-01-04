Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4FB65CDA1
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjADHbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbjADHbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:31:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CBE11151
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:31:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD920615AC
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B361C433EF;
        Wed,  4 Jan 2023 07:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672817497;
        bh=Jqh2DiINBYg0oFpHTMk/+3iH6QwGtUjdYsBYKNDMvGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qbFMinDGToTjPi63XaqH/MtUv5ltIuxLEnWy+cob93kmReOEveRh5bAe8RcV8UkzZ
         +z0E0jbMneHlKWGTLQDL8IUrSslludiOBrYdanKffEsep7FxSJ4f7DOQZEO5qrjJLf
         Jge9pHS62ygZN+pYo0O8ClVoCdsEbObdwDJxnFBvVxX3BfP89KzXcG//D83yHxZRAC
         m+D/C+OkFUFP1Ql7I8Ky6LjIIxuSBvjwNbZRmzI1lMhhpNnlTWoXeJYXdvDS33ffiY
         gur1ez1inY0uWypVLgjiYwjIjdZ7CS3lkJW1DrZEzeGP7OKPiIf0jT3uKvSW3z/oQI
         v96MMM2lxOmxA==
Date:   Wed, 4 Jan 2023 09:31:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Tan Tee Min <tee.min.tan@linux.intel.com>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 2/3] igc: enable Qbv configuration for 2nd GCL
Message-ID: <Y7UrVHZW32AI82W1@unreal>
References: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
 <20230103230503.1102426-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103230503.1102426-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 03:05:02PM -0800, Tony Nguyen wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> Make reset task only executes for i225 and Qbv disabling to allow
> i226 configure for 2nd GCL without resetting the adapter.
> 
> In i226, Tx won't hang if there is a GCL is already running, so in
> this case we don't need to set FutScdDis bit.
> 
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c |  9 +++++----
>  drivers/net/ethernet/intel/igc/igc_tsn.c  | 13 +++++++++----
>  drivers/net/ethernet/intel/igc/igc_tsn.h  |  2 +-
>  3 files changed, 15 insertions(+), 9 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
