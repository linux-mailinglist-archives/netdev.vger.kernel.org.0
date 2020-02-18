Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B21162096
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgBRF5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:57:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgBRF5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:57:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6465515B4789B;
        Mon, 17 Feb 2020 21:57:16 -0800 (PST)
Date:   Mon, 17 Feb 2020 21:57:15 -0800 (PST)
Message-Id: <20200217.215715.632639629013006126.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        liuhangbin@gmail.com
Subject: Re: [PATCHv2 net] sctp: move the format error check out of
 __sctp_sf_do_9_1_abort
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7f0002ee4446436104eb72bcfa9a4cf417570f7e.1581998873.git.lucien.xin@gmail.com>
References: <7f0002ee4446436104eb72bcfa9a4cf417570f7e.1581998873.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 21:57:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 18 Feb 2020 12:07:53 +0800

> When T2 timer is to be stopped, the asoc should also be deleted,
> otherwise, there will be no chance to call sctp_association_free
> and the asoc could last in memory forever.
> 
> However, in sctp_sf_shutdown_sent_abort(), after adding the cmd
> SCTP_CMD_TIMER_STOP for T2 timer, it may return error due to the
> format error from __sctp_sf_do_9_1_abort() and miss adding
> SCTP_CMD_ASSOC_FAILED where the asoc will be deleted.
> 
> This patch is to fix it by moving the format error check out of
> __sctp_sf_do_9_1_abort(), and do it before adding the cmd
> SCTP_CMD_TIMER_STOP for T2 timer.
> 
> Thanks Hangbin for reporting this issue by the fuzz testing.
> 
> v1->v2:
>   - improve the comment in the code as Marcelo's suggestion.
> 
> Fixes: 96ca468b86b0 ("sctp: check invalid value of length parameter in error cause")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
