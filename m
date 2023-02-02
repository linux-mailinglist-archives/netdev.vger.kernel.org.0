Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CE1688608
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBBSFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjBBSFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:05:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB0111E81
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67E0B61C43
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 18:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F44AC433EF;
        Thu,  2 Feb 2023 18:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675361139;
        bh=holoQS7Iqo3i9d04NWRzeZP0GQxuUqfG31YJ+72hQAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CUNDXFHIAwaQvnfwrl3Iot8Hl6Wbk1v5rqaIR7XgMPmuVNgwo/tKySD/gN0VDZkAc
         fblbpHrzptJVbM1Z1oSKIPrNGKZdMNjZubBJWDevOercDRkWfie8N8rodJGOXR2rl7
         RNk/mE3czrWU+p1inSYa70HNU8y4uGNRO5eltrn2XbY9wYIVAkYp4O9cbX2Oo+oPAH
         Y3SvGcdLU4BgiydM1/Z6EwboQ77WSQKTypQNBBhGfSPQMu6AiKw+PO4EjNWOpUUG5z
         +a7KsFz5NVnC7C8vbFK0ldENvECbNi8OLM2AULSowEKh9mnhNn9kEPTaDVYcQLQBBL
         4aUJL1NJjXREA==
Date:   Thu, 2 Feb 2023 10:05:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <drivers@pensando.io>
Subject: Re: [PATCH net 3/6] ionic: add check for NULL t/rxqcqs in reconfig
Message-ID: <20230202100538.6f9a4ea3@kernel.org>
In-Reply-To: <20230202013002.34358-4-shannon.nelson@amd.com>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
        <20230202013002.34358-4-shannon.nelson@amd.com>
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

On Wed, 1 Feb 2023 17:29:59 -0800 Shannon Nelson wrote:
> Make sure there are qcqs to clean before trying to swap resources
> or clean their interrupt assignments.

... Otherwise $what-may-happen

Bug fixes should come with an explanation of what the user-visible
misbehavior is
