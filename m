Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4AEB131A8B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgAFVfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:35:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgAFVe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:34:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b3Wm+uXhIbTiq/MxKpttGGeUtpHNdSriyRcWo1I9x6Y=;
        b=a+blDqN3c5YlzMPK8E+9PhdbaQiYA/RMgzewHOn7xN1GS+cfyb9KAvbXbPlpv9AguSJJi1
        /ma9+EY6bi6G+gRRoJmlXtdQJXrzzVe243yaI8jSXjY72eab1vX5RR4BYpjW5YZUGu2D4S
        VsfRhdZjPVJ5HFKpKk73PErZjoSey8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-BjrI9V4_N92wKVXid-vgeQ-1; Mon, 06 Jan 2020 16:34:55 -0500
X-MC-Unique: BjrI9V4_N92wKVXid-vgeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F049477;
        Mon,  6 Jan 2020 21:34:53 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC45B19C58;
        Mon,  6 Jan 2020 21:34:49 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:34:48 -0800 (PST)
Message-Id: <20200106.133448.1654261172205332113.davem@redhat.com>
To:     arnd@arndb.de
Cc:     saeedm@mellanox.com, leon@kernel.org,
        adhemerval.zanella@linaro.org, tariqt@mellanox.com,
        shayag@mellanox.com, eranbe@mellanox.com, maximmi@mellanox.com,
        ayal@mellanox.com, moshe@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx5: work around high stack usage with gcc
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200104215156.689245-1-arnd@arndb.de>
References: <20200104215156.689245-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sat,  4 Jan 2020 22:51:44 +0100

> In some configurations, gcc tries too hard to optimize this code:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'mlx5e_grp_sw_update_stats':
> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:302:1: error: the frame size of 1336 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> As was stated in the bug report, the reason is that gcc runs into a corner
> case in the register allocator that is rather hard to fix in a good way.
> 
> As there is an easy way to work around it, just add a comment and the
> barrier that stops gcc from trying to overoptimize the function.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657
> Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Saeed, please take this.

Thank you.

