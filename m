Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167166EE4E8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbjDYPlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjDYPlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD9113F9C
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E14A262F71
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 15:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1415EC433EF;
        Tue, 25 Apr 2023 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682437265;
        bh=SSmiHh305LkV5YmnyMs98GJjUxZr44fkjgTXZimf2cM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W6oM//QHBRnGIvllaHuu7Pogia6x2oIiuWO6FIvCjMRGraaVa9b2iEhl9F9b5klK4
         FTY8c1Wf0LY0wdQvp4Z6CWCpp+VMka1Yt1c1lkav33QP738qrBXGvItwsNe21WTQsW
         9qkuevhxes1rOuz4FpVfdU/SSFT7reP7r4fuc78VoNPU3lSOGUIeVnOixrkNCtR51n
         JI5HHeiuC7+Yu3+qhAWu4XuseP+5E7dFyhW9qKPhUNF+uF2l0Bm9H+sYClxuWUZg22
         J7HoYzTnaY+NZGe90ucc67s99kzEbiRpZuxJfLj9Zm7rHlyNJh+Yovl7cAlkxjVKuI
         OLw5vsrTjqXxQ==
Date:   Tue, 25 Apr 2023 08:41:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, Sudarsana Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net] qed/qede: Fix scheduling while atomic
Message-ID: <20230425084104.1a92b0dd@kernel.org>
In-Reply-To: <20230425135035.2078-1-manishc@marvell.com>
References: <20230425135035.2078-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 06:50:35 -0700 Manish Chopra wrote:
> Bonding module collects the statistics while holding
> the spinlock, beneath that qede->qed driver statistics
> flow gets scheduled out due to usleep_range() used in PTT
> acquire logic which results into below bug and traces -

Quoting documentation:

  Resending after review
  ~~~~~~~~~~~~~~~~~~~~~~
  
  Allow at least 24 hours to pass between postings. This will ensure reviewers
  from all geographical locations have a chance to chime in. Do not wait
  too long (weeks) between postings either as it will make it harder for reviewers
  to recall all the context.
  
  Make sure you address all the feedback in your new posting. Do not post a new
  version of the code if the discussion about the previous version is still
  ongoing, unless directly instructed by a reviewer.
  
See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#resending-after-review
