Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9456BA983
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjCOHkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjCOHkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8907D5DCAD;
        Wed, 15 Mar 2023 00:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766BF61B4D;
        Wed, 15 Mar 2023 07:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7204BC433EF;
        Wed, 15 Mar 2023 07:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678865681;
        bh=7ktC4KDSsNddL7fAD3DLVDfKc9FhqOWXOu6nwsp2d0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SR+z+gJt69q4OX57aiLUqiPcD5bZbAgivQETse4CAyMiQZSnePAvfgJd4I1juLysu
         rqdxlUhkp9AwgonmFVNHF20ooAZSukVYZp5NxITv3NCMPypgT2SUEcFsf06BTsAwbb
         jMPObol89iEVg977CMNCWGHMtwA0iW7W26IiCqZ1Bd2vZmIXIbCaRKADlEoCrWlw9B
         bLb9le1sWRoyhnJd8Ns81U8znb4MIeNwBoj8nHnIrhDh+PjFsHZUTbeRke9qD9RDmx
         r1NrQN11Y9S2CvbIwSj0DwtWiVH0xgQ+t9+6/Dc26Dz8KcpUg5fPKZdSbGsLLBD0uk
         vBB6bnd1HwnWQ==
Date:   Wed, 15 Mar 2023 00:34:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai <KaiShen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v4] net/smc: Use percpu ref for wr tx reference
Message-ID: <20230315003440.23674405@kernel.org>
In-Reply-To: <20230313060425.115939-1-KaiShen@linux.alibaba.com>
References: <20230313060425.115939-1-KaiShen@linux.alibaba.com>
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

On Mon, 13 Mar 2023 06:04:25 +0000 Kai wrote:
> Signed-off-by: Kai <KaiShen@linux.alibaba.com>

Kai Shen ?

> 

You're missing a --- separator here, try to apply this patch with 
git am :/

> v1->v2:
> - Modify patch prefix
> 
> v2->v3:
> - Make wr_reg_refcnt a percpu one as well
> - Init percpu ref with 0 flag instead of ALLOW_REINIT flag
> 
> v3->v4:
> - Update performance data, this data may differ from previous data
>   as I ran cases on other machines
> ---
