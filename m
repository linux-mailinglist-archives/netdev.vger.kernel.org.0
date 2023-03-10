Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A589B6B36E8
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 07:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCJGyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 01:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCJGyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 01:54:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E1F6545F
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 22:54:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1CD60D33
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 06:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFD7C433EF;
        Fri, 10 Mar 2023 06:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678431287;
        bh=6wVITcLNB4pdjccvPyFfRZK2kf0yxX3uFPz0RyUHoC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hdduyPVf2VyiLz+hHE5/xPg8PslXDTxEqM2drfrIqJ8nYLsv/Ckude2GsAfZFqzQd
         VXKt/LpItk1MhseFEEPQIEktZMZI/RyNX0AMvD30OLvmcDmm4CvL7T80lSWJ2i93LC
         elEQ0h2fwzSdaO0EewAf9eAC+Mec84mUNLzJ6b3I6vLsp0FG8k+oI/kwObBoahdPGO
         RiwqZ1Wmn7GsDolw7B9bO6MljWOdymds0N7+wHFLprr3yrtcgikFiXGXwx68SueGLR
         W0cfTFPlPm4RbV1CY6CKzme9Md/yhjIXcNS9aB7N9hYdsUHPU+T2QWkm323o6QIk/A
         swv559x/iSGfQ==
Date:   Thu, 9 Mar 2023 22:54:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v4 net-next 5/5] net: ena: Add support to changing
 tx_push_buf_len
Message-ID: <20230309225445.7c37b747@kernel.org>
In-Reply-To: <20230309131319.2531008-6-shayagr@amazon.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
        <20230309131319.2531008-6-shayagr@amazon.com>
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

On Thu, 9 Mar 2023 15:13:19 +0200 Shay Agroskin wrote:
> +			snprintf(large_llq_size_str, 40, ", %lu", ENA_LLQ_LARGE_HEADER);
> +
> +			NL_SET_ERR_MSG_FMT_MOD(extack,
> +					       "Supported tx push buff values: [%lu%s]",
> +					       ENA_LLQ_HEADER,
> +					       large_llq_sup ? large_llq_size_str : "");
> +

You need to fix up the formats, it generates build warnings on 32 bit.
