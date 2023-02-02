Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260F468860F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBBSGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBBSGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:06:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F984F853;
        Thu,  2 Feb 2023 10:06:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7AC1B82784;
        Thu,  2 Feb 2023 18:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A50AC4339B;
        Thu,  2 Feb 2023 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675361201;
        bh=Mi7i7JeEfblYcNj+79jZ4R7YcAf5fdTQ0/wtDDCo79A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ijis3VqaeNRTLTkSqgD62UsdOPBoJHW7q1QLWP0KaJvyDLVN5fnFl7e7Cap3W2eJL
         I8a3vKnhBS2zPqW0uu375Ue1Mi4eRVrSbGfTEu3gAcozgsWyAn0trF+zFTSQKoEjYk
         oW1xKgHJCHP5SswN2Ft0MCjlYTpd1RexxyXO2NAO9JYlRo2KPX3sASWQjrrRtqxttD
         lv4kDyw82EFPXVJJk6cpNNJMojt2/g2d5cKbSg9v+OF9wZShA2viFdpdFQ2mygo6Pt
         IhVU6B1HpMJI+J0znErDEbIsbCOD40SLWCCtoth9NmkjPArsTFYTw3bOSBv9UR+NmC
         MObiengTuzJQQ==
Date:   Thu, 2 Feb 2023 10:06:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: page_pool: use in_softirq() instead
Message-ID: <20230202100640.350fcd08@kernel.org>
In-Reply-To: <20230201220105.410fee4c@kernel.org>
References: <20230202024417.4477-1-dqfext@gmail.com>
        <20230201220105.410fee4c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Feb 2023 22:01:05 -0800 Jakub Kicinski wrote:
> On Thu,  2 Feb 2023 10:44:17 +0800 Qingfang DENG wrote:
> > From: Qingfang DENG <qingfang.deng@siflower.com.cn>
> > 
> > We use BH context only for synchronization, so we don't care if it's
> > actually serving softirq or not.
> > 
> > As a side node, in case of threaded NAPI, in_serving_softirq() will
> > return false because it's in process context with BH off, making
> > page_pool_recycle_in_cache() unreachable.  
> 
> LGTM, but I don't think this qualifies as a fix.
> It's just a missed optimization, right?

Well, nobody seems to have disagreed with me in 12h, so please drop the
Fixes tags and repost against net-next :)
