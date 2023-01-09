Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFF46630C2
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbjAITuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbjAITty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:49:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E5727C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B013B80F79
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 19:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C776C433D2;
        Mon,  9 Jan 2023 19:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673293790;
        bh=MWnmCjcTUxKxP7MKj9oXq9t26zrMWaec9oOIfu7a5DI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=leVKXH8uXEJ3mMbj6Tdw4fYInsNhNdZpCopEC31L97HbQJpplvEc/QLfx51ONYS8B
         FaivPZ3lHqq/okG4fRIIiQL64LdDEahUmTHxYbpV8fZgU8+qayuBh/3HvLBSeAOKY5
         7FbJjZaODPdJ/I9pEKlYtvaJTrNNPjZwDgwg9D/OMT2EkErVD7Xq0u4nTYTiUz/t6M
         K+hdUr//gRQhm8yuEzfW/bUN9SJWfJZdmCri/UmfzivcVfrSeuk43zvc98DfDfXKUs
         WlSqfvZkiH1QAGN01Wt4ZiRjoXbRfLgz/jh8nNCOvkYhlWeuHiMyvGuKZXb8nrpDBA
         AOQja5DmBY2ig==
Date:   Mon, 9 Jan 2023 11:49:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <20230109114949.547f5c9e@kernel.org>
In-Reply-To: <Y7k6JLAiqMQFKtWt@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-14-kuba@kernel.org>
        <Y7WuWd2jfifQ3E8A@nanopsycho>
        <20230104194604.545646c5@kernel.org>
        <Y7aSPuRPQxxQKQGN@nanopsycho>
        <20230105102437.0d2bf14e@kernel.org>
        <Y7fiRHoucfua+Erz@nanopsycho>
        <20230106131214.79abb95c@kernel.org>
        <Y7k6JLAiqMQFKtWt@nanopsycho>
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

On Sat, 7 Jan 2023 10:23:48 +0100 Jiri Pirko wrote:
> Hmm.
> 1) What is wrong of having:
>    .dumpit = devlink_instance_iter_dumpit
>    instead of
>    .dumpit = devlink_instance_iter_dump
>    ?
>    How exactly that decreases readability?

The "it" at the end of the function name is there because do is a C
keyword, so we can't call the do callback do, we must call it doit.

The further from netlink core we get the more this is an API wart 
and the less it makes sense. 
instance iter dump is closer to plain English.
