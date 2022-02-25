Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0F44C3D8C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiBYFQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiBYFQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:16:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9E02692A8
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 566E861752
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 05:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E40BC340E7;
        Fri, 25 Feb 2022 05:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645766157;
        bh=JFVuYKyFaDlIitbihJLP6aQsbNCmaXNcxknf1S3Jggg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F3SbhkAtwdmAsJdc2Q03QeA/jqcc67QHqY7pLegL/PEAToCKapfwhWnYnJaZwZQW7
         QOgGCBcWUKk7uUvO8YjV+RZlxEUY8QqmDws32s9XE7PIOlCmghdiXrMEkrm9cdGBds
         GFWgSP5bQEFgEH7ty9EuIYxx/+Fcce59rAf57re7SujjJju89LACA1gwzTtlIXXv47
         RPQ+NvhD2zq4PwxnWksDNu7vTbykALoPywZxf5Q3wXvHFDAqdus1tXAflWi5oGc33Y
         8gLGfyxCwLNM7MMhX/vS6cZg8fT6jxdQWfpqkc8SL7k6w0OiV/WBTLP9oZ+BTf8O4t
         wkiBXlBjySGbg==
Date:   Thu, 24 Feb 2022 21:15:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-internal v2 2/8] ibmvnic: initialize rc before
 completing wait
Message-ID: <20220224211556.41874708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220225040941.1429630-3-sukadev@linux.ibm.com>
References: <20220225040941.1429630-1-sukadev@linux.ibm.com>
        <20220225040941.1429630-3-sukadev@linux.ibm.com>
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

On Thu, 24 Feb 2022 20:09:35 -0800 Sukadev Bhattiprolu wrote:
> We should initialize ->init_done_rc before calling complete(). Otherwise
> the waiting thread may see ->init_done_rc as 0 before we have updated it
> and may assume that the CRQ was successful.
> 
> Fixes: 6b278c0cb378 ("ibmvnic delay complete()")

As you resend please fix to:

Fixes: 6b278c0cb378 ("ibmvnic: delay complete()")

There's a : missing.

Also in patch three make reinit_init_done() non-inline to keep with 
the netdev recommendations.
