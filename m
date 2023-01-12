Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E421667FB4
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjALT4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjALT4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:56:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EF2DD2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:56:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B79FB81E62
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A664DC433D2;
        Thu, 12 Jan 2023 19:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673553375;
        bh=FrPA5f/bauN+r9llVROYv0FY25BDNcGYLO+tJfidgxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AJz7Vw4vh3wIBV21TmyLvmCo8c90K+plBpa3km57v2lDeOcGoK/iqCdee0JN3P87H
         cyMfmKQ/DEj+1asGV1f6uGlDG5cOjHBOQ2KscBH1+OPYhdOz4XXdn4/wx/frOk84G6
         9VgcEM2sZkSxQYN1+i6PSnhTsA1J5XjMp9+TjQIY0ERQK8uNjGVQbj6g4oTz24Nj4b
         YhAfuk4yYRs2E+Fblgdyj/zOx40xfBkWT7uyjdsqzQ7Mqf+SDdjQ76ZgD7QWcU2NpB
         RQw1pjF0Vt5k2Zc/nFjrxYLcOwUAkHRFgB7cVzIBfpzUfNOR1kjmBMPD9liJ6pfK/1
         A4jzOTy/I32Nw==
Date:   Thu, 12 Jan 2023 11:56:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230112115613.0a33f6c4@kernel.org>
In-Reply-To: <pj41zltu0vn9o7.fsf@u570694869fb251.ant.amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
        <20230111110043.036409d0@kernel.org>
        <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
        <20230111120003.1a2e2357@kernel.org>
        <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
        <pj41zltu0vn9o7.fsf@u570694869fb251.ant.amazon.com>
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

On Thu, 12 Jan 2023 15:47:13 +0200 Shay Agroskin wrote:
> Gal Pressman <gal@nvidia.com> writes:
> > TX copybreak? When the user sets it to > 96 bytes, use the large 
> > LLQ.
> >
> > BTW, shouldn't ethtool's tx_push reflect the fact that LLQs are 
> > being
> > used? I don't see it used in ena.  
> 
> Using tx copybreak does sound like it can work for our use 
> case. Thanks for the tip Gal (:
> 
> Jakub, do you see an issue with utilizing tx_copybreak ethtool 
> parameter instead of the devlink param in this patchset ?

IDK, the semantics don't feel close enough.

As a user I'd set tx_copybreak only on systems which have IOMMU enabled 
(or otherwise have high cost of DMA mapping), to save CPU cycles.

The ena feature does not seem to be about CPU cycle saving (likely 
the opposite, in fact), and does not operate on full segments AFAIU.

Hence my preference to expose it as a new tx_push_buf_len, combining
the semantics of tx_push and rx_buf_len.
