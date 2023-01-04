Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B6E65CC03
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbjADCur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjADCur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:50:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940CD165A9
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 18:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ACC6B811D6
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 02:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3381C433D2;
        Wed,  4 Jan 2023 02:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672800643;
        bh=lYfK4VLlonwl4OBlK647SSiMTxKScQiHiaIpOBer6Ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kmRKY3rXPAKrX2CBSj2r1AJXEErKL7ehgxQD4S4K/SqIb8GsoczraEhEf97HG0nne
         Dz8x9Ar8eG7VxFU3qZLCeCNQnIpCdIdofNtfoDt+LDIF1DtOohgH56g78aOCMSUkqc
         0BfBFwscTT5L9PlfL00OlfUXrnp1U7HIRrvxKeUfEWx81ZZIZs4BRkGjRuMYNg/BIr
         aCa2dRpthDZgSQySx6qDj36BXv4SQD9XLMBGOZaS59NVX6dFtxARzBd2mTqy6LkWli
         Loh7XyVUCUPdk0JXTdjLHlqZdYT4tFc3GhUkyHRKytcw67Kannu/JLzOcT0K9nobKJ
         0SGMURV9hT4PQ==
Date:   Tue, 3 Jan 2023 18:50:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <20230103185042.7931b8da@kernel.org>
In-Reply-To: <Y7Qe9qHUVuqr2Wgd@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-5-kuba@kernel.org>
        <Y7Qe9qHUVuqr2Wgd@nanopsycho>
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

On Tue, 3 Jan 2023 13:26:30 +0100 Jiri Pirko wrote:
> >+bool devl_is_alive(struct devlink *devlink)
> >+{
> >+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> >+}
> >+EXPORT_SYMBOL_GPL(devl_is_alive);  
> 
> Why is this exported? Drivers should not use this, as you said.

I'll make it a static inline in the internal header.
