Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A5813502F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbgAHX6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:58:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbgAHX6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:58:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 710291511CAB6;
        Wed,  8 Jan 2020 15:58:03 -0800 (PST)
Date:   Wed, 08 Jan 2020 15:58:03 -0800 (PST)
Message-Id: <20200108.155803.2292394746055216594.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix wrong connect() return code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108021900.24802-1-tuong.t.lien@dektech.com.au>
References: <20200108021900.24802-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 15:58:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed,  8 Jan 2020 09:19:00 +0700

> The current 'tipc_wait_for_connect()' function does a wait-loop for the
> condition 'sk->sk_state != TIPC_CONNECTING' to conclude if the socket
> connecting has done. However, when the condition is met, it returns '0'
> even in the case the connecting is actually failed, the socket state is
> set to 'TIPC_DISCONNECTING' (e.g. when the server socket has closed..).
> This results in a wrong return code for the 'connect()' call from user,
> making it believe that the connection is established and go ahead with
> building, sending a message, etc. but finally failed e.g. '-EPIPE'.
> 
> This commit fixes the issue by changing the wait condition to the
> 'tipc_sk_connected(sk)', so the function will return '0' only when the
> connection is really established. Otherwise, either the socket 'sk_err'
> if any or '-ETIMEDOUT'/'-EINTR' will be returned correspondingly.
> 
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied.
