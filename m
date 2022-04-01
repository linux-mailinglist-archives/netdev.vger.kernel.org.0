Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADC84EE6AF
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244488AbiDADYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244490AbiDADYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:24:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEDC25E32F
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6171CB82201
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B137BC2BBE4;
        Fri,  1 Apr 2022 03:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648783372;
        bh=rFUojLb9f3B2DD8OSl97/Rjh0qeaL+C4cid770VaFF0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ckgtnzs077BkrhGkCbbUwvu4egnFP+WzZETnCbtmXxiWp1ImKcaoXPB6h4eMCLiv0
         Fjp2NK+YR+BFPY6rNqteRkJibC0mC2TUF4ztYgZsDFyZ3XaybG4KbryrCukPqM5eXB
         03IJNSXG593gJXu2dAjoaldy6heUg8DnqLfz2eNWt7idoLkz/eyxrkWHJKTRxNxMMA
         cHUxAUXb7KpIHFzv033UaWUyN6s2NTgv7zpwiTJu9nhCoVPhe83h7MTNwyLgsxGcw3
         wh6Dwlp9303+9pNCvVb9ibDqouyIOHy0FUDIK8pctVjiHIj3M34ag2MUcxJAIIRh3N
         6Wu/i7O7LH21Q==
Date:   Thu, 31 Mar 2022 20:22:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RFCv4 PATCH net-next 1/3] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
Message-ID: <20220331202250.01f53929@kernel.org>
In-Reply-To: <20220331084342.27043-2-wangjie125@huawei.com>
References: <20220331084342.27043-1-wangjie125@huawei.com>
        <20220331084342.27043-2-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 16:43:40 +0800 Jie Wang wrote:
> +``ETHTOOL_A_RINGS_TX_PUSH`` controls flag to choose the fast path or the
> +normal path to send packets. Setting tx push attribute "on" will enable tx
> +push mode and send packets in fast path. For those not supported hardwares,
> +this attributes is "off" by default settings.

You need to be more specific what a "fast path" is, that term is 
too general.

I presume you want to say something about the descriptor being written
directly into device address space... and that it lowers the latency
but increases the cost...
