Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B74456059D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbiF2QRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiF2QRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D5032EDB
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D51DB61BEC
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 16:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F11C34114;
        Wed, 29 Jun 2022 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656519472;
        bh=4SJePwVB8JZnlXbFWHb3CxTDcbMALYeDJUtchxxFsp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TFE6jC+1GtWKrp2cD+wbSo4GVDXqknjTFDASfbGdJi1ScDsFZeEOugTUSpzZ1iMxI
         ujR4pk1lHjCB2x8GE6yOtnRiWlmAXVAlpDA2I9EZ7iFoHK6rQtVPN4GriPGE5VZEAS
         ghhZLlnWNlTENwOkQjA1Ll7/gtfvdVomzMJsGt1PJoA6CCmdgVToJofA/Q8NwuK2Is
         zbOaHsWAlnOu0HJsBpUPOHiXhhZa2cTv2DyifHyS3Irg82vYjOvZUfYG9K2BdyYGss
         m+FP8cbwr1b0Aid8/f5opkU1RUC62tt2vxMa0iFsNZ2mXXz1H9lMakOk+nWjNsrM9G
         kssMoquqOGxmA==
Date:   Wed, 29 Jun 2022 09:17:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@aviatrix.com>
Subject: Re: [PATCH net] net: tun: do not call napi_disable() twice
Message-ID: <20220629091750.1f0dc8ed@kernel.org>
In-Reply-To: <20220629093752.1935215-1-edumazet@google.com>
References: <20220629093752.1935215-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 09:37:52 +0000 Eric Dumazet wrote:
> syzbot reported a hang in tun_napi_disable() while RTNL is held.
> 
> Because tun.c logic is complicated, I chose to:
> 
> 1) rename tun->napi_enabled to tun->napi_configured
> 
> 2) Add a new boolean, tracking if tun->napi is enabled or not.

Not a huge surprise TBH :S

Is there a repro?
