Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6A149BFA4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiAYXg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiAYXgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:36:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAA6C061749
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB076131E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D313C340E0;
        Tue, 25 Jan 2022 23:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643153798;
        bh=E6tfEN8ha+Lxt4LF4uvgJ897Z30jCnh865B56nYQfpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PgTlzZQBbAhpjpmGYH05hBVaS5phEVyuHg7mNeIUjYjqtnPdG0/7GXPACGAbZqIT0
         zOFdOT2sPE6wYhW5qWnrjVqLIB46NuYAV1QHQq7v0agnmzlmqyyBHAUncqhaP07PnX
         SjZOo4W6dF6yAUM4/+pKUwMK2zvxlCZwhy2au6mv+pWSxcIjdPkYofJtHwO0Xt5CLR
         lEn0Z0xb9tDT2VEC36m5FY/m9xFZfaVxER1nmUKyma+agYaAev2hFAgQ85hyZFW0vE
         M4/ePGMzNMBgb2WHOA+7XgDfEjX/PJUAtD3B891iWGnwf+Ee/xLJRenCIauaKmHSMQ
         kwGdHjgD8gHvA==
Date:   Tue, 25 Jan 2022 15:36:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, jeroendb@google.com,
        Catherine Sullivan <csully@google.com>
Subject: Re: [PATCH net-next] gve: Fix GFP flags when allocing pages
Message-ID: <20220125153637.7bd81c37@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125215910.3551874-2-awogbemila@google.com>
References: <20220125215910.3551874-1-awogbemila@google.com>
        <20220125215910.3551874-2-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 13:59:10 -0800 David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Use GFP_ATOMIC when allocating pages out of the hotpath,
> continue to use GFP_KERNEL when allocating pages during setup.
> 
> GFP_KERNEL will allow blocking which allows it to succeed
> more often in a low memory enviornment but in the hotpath we do
> not want to allow the allocation to block.

Sounds like a fix, right?  Sleeping in atomic is a bug.
In that case please resend as [PATCH net] and with a Fixes: tag
included.

FWIW adding cover letters with a single patch is not required,
but you can keep it if you prefer it that way.
