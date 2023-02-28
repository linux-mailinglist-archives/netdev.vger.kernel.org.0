Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE46A63CA
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 00:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjB1X20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 18:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjB1X20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 18:28:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5037DBB86;
        Tue, 28 Feb 2023 15:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C2B3B80E4B;
        Tue, 28 Feb 2023 23:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA55FC433D2;
        Tue, 28 Feb 2023 23:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677626902;
        bh=PrRSA+G2g+osBlGTfuXk2QH617/VjNB0LRZcrhv80v0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSz7fLDcRMWnDsaoKw/jvhQNesQ2J0KQUhVZZbbF+FUrtSCKFa4bF0cGJSlZtKTKk
         tRN2YY1dPopkd/lO1FpU7zRAEasUXNpLVa6cimBzdn+rW58VncuOQ+ndsBpxudgxXU
         KOP6N/lKlZ7m7ZD9ajuoDlGgZAkqQJZJZEgIHFgdf05To804GouVXty7n0DVoaWzYh
         WDhOSe5B6WE7syAftVv+44YN4HvoqUzDVKmQKfQqPD2ahxHUyQmeTKNR7Fy097blU7
         zxrBenP3KtqBL3gVUSq0IWFokjOozQq5xdyQCj+mL395zXZrPFLEE0u0Iy0/pPX1Kq
         YKWbnfSDthO6g==
Date:   Tue, 28 Feb 2023 15:28:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: Re: [RFC net-next 1/6] tools: ynl: fix render-max for flags
 definition
Message-ID: <20230228152820.566b6052@kernel.org>
In-Reply-To: <Y/6LQH4hU/gYROKO@lore-desk>
References: <cover.1677153730.git.lorenzo@kernel.org>
        <0252b7d3f7af70ce5d9da688bae4f883b8dfa9c7.1677153730.git.lorenzo@kernel.org>
        <20230223090937.53103f89@kernel.org>
        <Y/6LQH4hU/gYROKO@lore-desk>
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

On Wed, 1 Mar 2023 00:16:16 +0100 Lorenzo Bianconi wrote:
> > I think it also needs to be fixed to actually walk the elements 
> > and combine the user_value()s rather than count them and assume
> > there are no gaps.  
> 
> Do you mean get_mask()?

Yup, get_mask() predates the ability to control the values of enum
entries individually so while at it we should fix it.
