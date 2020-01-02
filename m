Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB2412F1E3
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgABXnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:43:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgABXnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:43:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5555B15707A92;
        Thu,  2 Jan 2020 15:43:06 -0800 (PST)
Date:   Thu, 02 Jan 2020 15:43:05 -0800 (PST)
Message-Id: <20200102.154305.639050830505824860.davem@davemloft.net>
To:     yangpc@wangsu.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated
 as D-SACK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577699681-14748-1-git-send-email-yangpc@wangsu.com>
References: <1577699681-14748-1-git-send-email-yangpc@wangsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 15:43:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>
Date: Mon, 30 Dec 2019 17:54:41 +0800

> When we receive a D-SACK, where the sequence number satisfies:
> 	undo_marker <= start_seq < end_seq <= prior_snd_una
> we consider this is a valid D-SACK and tcp_is_sackblock_valid()
> returns true, then this D-SACK is discarded as "old stuff",
> but the variable first_sack_index is not marked as negative
> in tcp_sacktag_write_queue().
> 
> If this D-SACK also carries a SACK that needs to be processed
> (for example, the previous SACK segment was lost), this SACK
> will be treated as a D-SACK in the following processing of
> tcp_sacktag_write_queue(), which will eventually lead to
> incorrect updates of undo_retrans and reordering.
> 
> Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & simplify access to them")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>

Applied and queued up for -stable, thank you.
