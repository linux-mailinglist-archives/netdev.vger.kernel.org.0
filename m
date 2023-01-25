Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B6367A879
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjAYBoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYBoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:44:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD40340BE0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 17:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77EBC60F34
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE08CC4339B;
        Wed, 25 Jan 2023 01:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674611047;
        bh=ju94Rww7h+C7DbPBXwsKhudZpTk2mQvmxWZwjORUa/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g18U1nubLj6bfd3nqHHbNDsdhPm9ava0iHMmrH3EG5XRsE11bEUZTeUDkkQdfGAEn
         pJxiLbgRZyOmxiPEeLduauXn+IQqY0mImb2Pv9ZgCz5FVV8KPV4rlN3BAHanCJikov
         i4Fi+tiY2v33dHKLouNjJu7V/hssJLcXQylRVSlHNch7TuP24ECk0SlpeTixlEJjBw
         dd67X9RC5uEYDUA75Yfmi8DPR8Jf/XWQbrBL+PxUEHoIwjk2+ea74283LJrPadT440
         YrEMKuh+nl9B2n2YyDQcucQbf4nU825o3nm5+uDMn/QRDveRfTD6l8CIsTnGe0PmtI
         OTHNuiGnyFDCQ==
Date:   Tue, 24 Jan 2023 17:44:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Dutkowski <adutkowski@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: possible macvlan packet loss
Message-ID: <20230124174406.4dbe97c5@kernel.org>
In-Reply-To: <CABkKHSZV7OmkNnkZRi7dF=-_bJK9i4p_8XLdV_Zd0=Z_O8Jf6A@mail.gmail.com>
References: <CABkKHSZV7OmkNnkZRi7dF=-_bJK9i4p_8XLdV_Zd0=Z_O8Jf6A@mail.gmail.com>
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

On Tue, 24 Jan 2023 16:14:03 +0100 Aleksander Dutkowski wrote:
> I wonder what is the best way to test and measure the queue fulfillment?
> We can do simple printf when the queue is full, but maybe there are
> some tools or techniques I'm not aware of that we can use?

In terms of debugging tools bpftrace (potentially combined with kprobes)
will change your life.
