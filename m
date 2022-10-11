Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A215FA986
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 02:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJKA63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 20:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJKA62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 20:58:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ACF1D329
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 17:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E53E61062
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 00:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E4DC433C1;
        Tue, 11 Oct 2022 00:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665449905;
        bh=0/Xhb0BibbjrP/I1dHYYBg5//ly+Ab+Xj+pwk20cg0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q3awKTSzgRywETFvgRUcuM5Hsjx+ITuqwO7c+PksfpMBdlZqG6YgftQKXY2opbCl2
         mcGF4S3a77Vjif/ym8uj96iJDR9kS2VWhpd/ZTNLml3w+BAhKv5eMkgD/wyaxyH22A
         qAOfFsu5Zf1QwxawaywV0mKKt+qQaO6+nZpxd4xqfXJOKdtZHjZ34PWrYRm6nCqjdE
         WgUBdMzkha3CfqfGagUKgX9lBKxX6hmHdi76NCLxen7vKpHInW2ZNh7HoOCr7WFW7Z
         EyU+MP/AzEYV2zRpjK1Lzj7d8Z1owJ3yZ4LZAzoRS9DTL3QXe33hnjd5rMYlR+3/ra
         SXioyNlOOaFdw==
Date:   Mon, 10 Oct 2022 17:58:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com
Subject: Re: [net-next PATCH] net: core: Add napi_complete_done tracepoint
Message-ID: <20221010175824.28c61c50@kernel.org>
In-Reply-To: <1665426094-88160-1-git-send-email-jdamato@fastly.com>
References: <1665426094-88160-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Oct 2022 11:21:34 -0700 Joe Damato wrote:
> Add a tracepoint to help debug napi_complete_done. Users who set
> defer_hard_irqs and the GRO timer can use this tracepoint to better
> understand what impact these options have when their NIC driver calls
> napi_complete_done.
> 
> perf trace can be used to enable the tracepoint and the output can be
> examined to determine which settings should be adjusted.

Are you familiar with bpftrace, and it's ability to attach to kfunc 
and kretfunc? We mostly add tracepoints to static functions which get
inlined these days.
