Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225031C0CFE
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 06:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgEAECb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 00:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgEAECb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 00:02:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7ACC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 21:02:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A877A127806DE;
        Thu, 30 Apr 2020 21:02:30 -0700 (PDT)
Date:   Thu, 30 Apr 2020 21:02:30 -0700 (PDT)
Message-Id: <20200430.210230.813380690503816289.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix EOTID leak when disabling TC-MQPRIO
 offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588186339-6249-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1588186339-6249-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 21:02:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Thu, 30 Apr 2020 00:22:19 +0530

> Under heavy load, the EOTID termination FLOWC request fails to get
> enqueued to the end of the Tx ring due to lack of credits. This
> results in EOTID leak.
> 
> When disabling TC-MQPRIO offload, the link is already brought down
> to cleanup EOTIDs. So, flush any pending enqueued skbs that can't be
> sent outside the wire, to make room for FLOWC request. Also, move the
> FLOWC descriptor consumption logic closer to when the FLOWC request is
> actually posted to hardware.
> 
> Fixes: 0e395b3cb1fb ("cxgb4: add FLOWC based QoS offload")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied and queued up for -stable, thanks.
