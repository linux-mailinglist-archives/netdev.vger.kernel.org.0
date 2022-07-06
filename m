Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE578569361
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiGFUex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbiGFUew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73851248CD
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 13:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D7ECB81EDF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 20:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BF2C3411C;
        Wed,  6 Jul 2022 20:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657139688;
        bh=PDzDPlnvV5u+w6fG+s5+MAYHlJZdOmJEpcTYjWxgiFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SXq3UyJKHQyZUAEBy/RMfly1WYjgfWb7SOySPyQtIvTymI+LB5dtIkg8wEkPE97dx
         zBMnnqNqiDHuoixPU09Ya9NdsfpjpVP1md3z48ptjmwwtuFBdwlIW3eAhLaBgKPf4s
         nAfPwlKOSE68aL2S3O6cOzN+scpnI7j4IHmf56Se3QmfaGmnqBLa6ghYX0y0JyyssI
         94iUBDFTDlrVCHOkpN+SZLeEwXhWpWOteK3YeNQJLmouP+9mWb2dBrwNBzKdicPko/
         FWqIxYnVXKpU3q6Mk4TK0nq4qGQO9YLJft3s9C/1tK/RQ7oz7Fkzz8AK52/3/cS0o8
         AdWB8Gc59ut4w==
Date:   Wed, 6 Jul 2022 13:34:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org, davem@davemloft.net,
        syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
Subject: Re: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Message-ID: <20220706133447.7c2b4414@kernel.org>
In-Reply-To: <20220706133334.0a6acab5@kernel.org>
References: <20220706034752.5729-1-hoang.h.le@dektech.com.au>
        <20220706133334.0a6acab5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 13:33:34 -0700 Jakub Kicinski wrote:
> Alternative is to use strncmp(..., nla_len(attr)).

Correction, we have helpers for this - nla_strcmp etc.
