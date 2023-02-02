Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39B668780F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBBI7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBBI7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:59:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6076311C;
        Thu,  2 Feb 2023 00:59:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE8B96192B;
        Thu,  2 Feb 2023 08:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92CBC433EF;
        Thu,  2 Feb 2023 08:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675328362;
        bh=8NSMvJdX2TBYQSVZ7UeW0jol0hoDcR4E5Vb+ot0qQ+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vP04wiZuGNYlHIoaTIRsLeW/+vW7wuKt6KEp3Tp4kQgC27dCj1qurBEBqy0XiOB9N
         zqy5wQDMbF4BpAPOMF4jRlnnAoKtDbsZM5WazaOsiBzeY1sVJHxgGuK1LKCkHm6Rom
         Mh0eqF+XpHP8JTfY7AnmI/ovl2lkRirxjaHXqZZp0dFx+q/SsBVfazgXt/1guAtjNX
         8c4RhFn9yeMXrczHniQlstc7/GQzf4dUCv26+GEOLik0xQ2GI/lE6/H1TdfNyBnVNS
         d0Ok4/kE/zODtHteKcnfnTCgu34zpeA3/oGb5JPM72wPDftYIogaECrJ3/N+HVylk/
         1DtcICVNfoIqw==
Date:   Thu, 2 Feb 2023 10:59:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: page_pool: use in_softirq() instead
Message-ID: <Y9t7ZnuVgMFpb3cB@unreal>
References: <20230202024417.4477-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202024417.4477-1-dqfext@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 10:44:17AM +0800, Qingfang DENG wrote:
> From: Qingfang DENG <qingfang.deng@siflower.com.cn>
> 
> We use BH context only for synchronization, so we don't care if it's
> actually serving softirq or not.
> 
> As a side node, in case of threaded NAPI, in_serving_softirq() will
> return false because it's in process context with BH off, making
> page_pool_recycle_in_cache() unreachable.
> 
> Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
> Fixes: 7886244736a4 ("net: page_pool: Add bulk support for ptr_ring")
> Fixes: ff7d6b27f894 ("page_pool: refurbish version of page_pool code")

Please put your Signed-off-by after Fixes.

Thanks
