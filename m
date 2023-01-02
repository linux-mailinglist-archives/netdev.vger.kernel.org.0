Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4057365B826
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 00:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjABXYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 18:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjABXYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 18:24:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3843A7663
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:24:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 149046109A
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 23:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C76C433EF;
        Mon,  2 Jan 2023 23:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672701888;
        bh=0d/uCh9Np5Esb5olJMvbGaXbs25tlx4SMh34FYgCjLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bbDU2ORc1wj46J3W/cQ+ffop7m7xUJybvemvb8SHnf1YUIq1PHJC3zU/mfvcQuqsK
         bLHbK5RClX4ZACwdwYqAy5zWY7B7UfLvKl6Nn5NLv3TTd0u5q6TOooAdnzK3to9byK
         r6eFS8J43+ZrcIu++QBB71hoQq9cBbtQSQBNGwfqmZwmmOeXIshN+tgOSy3YjZTIMO
         BTEoy8oDyJ4908ZVIa/x3AZTiHmYP3eYzX8DZNvudOKfqLhYGwbdbmB9pO56q+hE3P
         +c5coAxJtv/seX3VPLMd1N+1Rc/UxGTP7TZPRNVP9DnZnCLuW363+VCRLGdGZNAhV7
         JGgq3vCUJNVlQ==
Date:   Mon, 2 Jan 2023 15:24:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 06/10] devlink: don't require setting features
 before registration
Message-ID: <20230102152447.05a86e28@kernel.org>
In-Reply-To: <Y7L3Xrh7V33Ijr4M@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-7-kuba@kernel.org>
        <Y7L3Xrh7V33Ijr4M@nanopsycho>
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

On Mon, 2 Jan 2023 16:25:18 +0100 Jiri Pirko wrote:
> Sat, Dec 17, 2022 at 02:19:49AM CET, kuba@kernel.org wrote:
> >Requiring devlink_set_features() to be run before devlink is
> >registered is overzealous. devlink_set_features() itself is
> >a leftover from old workarounds which were trying to prevent
> >initiating reload before probe was complete.  
> 
> Wouldn't it be better to remove this entirely? I don't think it is
> needed anymore.

I think you're right. Since users don't have access to the instance
before it's registered - this flag can have no impact.
