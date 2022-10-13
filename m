Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479D65FD73B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJMJni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJMJnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E512014639B;
        Thu, 13 Oct 2022 02:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83396B80DFB;
        Thu, 13 Oct 2022 09:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876F9C433D6;
        Thu, 13 Oct 2022 09:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665654214;
        bh=1Wk/QwX861ZXRIsXyj/MtxL7hcOYvbboclUBxQXQ+gA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DyT3rESoSjtLAbY+trFdqeCZvhvg6UgB4I30nZMMVC/8n87iu+UzlDysgiyQklp5D
         fEAgah3z2TmDEpR3XQ+rbkxtfxTBekBMELjMkTSjooh95vZgOMJ219/aTe0yevqOud
         1XebXGWpc4CfUAHWByVeVdAe89P8FAuU59iaCjh+kJmUt/7/8ET+fxOJZYvNIwSCl1
         OSgJfO0R0gdK5XbwVLi2BssbD+1XisSZaiCM2aaLZeWwNQC/IhkcEVz5ebl9mLY9sE
         RBhA/143ZWa8RyVH8vHK6U2TZfijSGrb9wzX0gS4Z93xlnxvn0ylP1eEydre8KAIlw
         Kmhwv0RylfF/Q==
Date:   Thu, 13 Oct 2022 12:43:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] net/sock: Introduce trace_sk_data_ready()
Message-ID: <Y0fdwSkyoFI2SDuw@unreal>
References: <20221011195856.13691-1-yepeilin.cs@gmail.com>
 <20221012232121.27374-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012232121.27374-1-yepeilin.cs@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 04:21:21PM -0700, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> callback implementations.  For example:
> 
> <...>
>   ksoftirqd/0-16  [000] ..s..  99.784482: sk_data_ready: family=10 protocol=58 func=sock_def_readable
>   ksoftirqd/0-16  [000] ..s..  99.784819: sk_data_ready: family=10 protocol=58 func=sock_def_readable
> <...>
> 
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
> changes since v3:
>   - Avoid using __func__ everywhere (Leon Romanovsky)
>   - No need to trace iscsi_target_sk_data_ready() (Leon Romanovsky)

I meant no need both trace point and debug print and suggested to remove
debug print.

Thanks
