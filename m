Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11CB131A68
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgAFV3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:29:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726721AbgAFV3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1TujLPBEThsKpdJQeFPjKs89DKPYNBP4mKTgJjnllqU=;
        b=HqByoBQ1yxyAox4yKPeyYpXu1t8ciw87uihUNJWI0oGx4BiCwksu+qw+f9sYxbjYTqac0e
        vOqacxhhY+FrUTRMZk+RCTRdt03JtNRkfqv6DYSCG0jl3j0r+ipJ6P//BuCjFyrZed18NA
        4sUDT3HHQsVJc+mk/+04cNliynPnWMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-GaXrYHu6OAWZf1owPuROQA-1; Mon, 06 Jan 2020 16:29:26 -0500
X-MC-Unique: GaXrYHu6OAWZf1owPuROQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9414018B5F94;
        Mon,  6 Jan 2020 21:29:25 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE5555C21A;
        Mon,  6 Jan 2020 21:29:23 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:29:22 -0800 (PST)
Message-Id: <20200106.132922.717594592451500648.davem@redhat.com>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: free cmd->obj.chunk for the unprocessed
 SCTP_CMD_REPLY
From:   David Miller <davem@redhat.com>
In-Reply-To: <f5ea0cd0d1ae40046da27fcf9f3cf5c21772be49.1578118502.git.lucien.xin@gmail.com>
References: <f5ea0cd0d1ae40046da27fcf9f3cf5c21772be49.1578118502.git.lucien.xin@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  4 Jan 2020 14:15:02 +0800

> This patch is to fix a memleak caused by no place to free cmd->obj.chunk
> for the unprocessed SCTP_CMD_REPLY. This issue occurs when failing to
> process a cmd while there're still SCTP_CMD_REPLY cmds on the cmd seq
> with an allocated chunk in cmd->obj.chunk.
> 
> So fix it by freeing cmd->obj.chunk for each SCTP_CMD_REPLY cmd left on
> the cmd seq when any cmd returns error. While at it, also remove 'nomem'
> label.
> 
> Reported-by: syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.

