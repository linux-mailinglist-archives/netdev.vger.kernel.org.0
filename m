Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8F823C875
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 11:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgHEJAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 05:00:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23249 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgHEJAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 05:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596618046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZSDQ7oldb8iII0VqxQ1pyiHwiNqGB3oUlAZtt9Ry2qQ=;
        b=URuVsqaWt1BW+gLdupfsfzDX2ty4iH046RGOcyvfib3oCrJVD6L7zZdIiXmWtbUXwoXroQ
        NFuVrhvX5IYea6n43lLnQtHrZ0C7fp7U2fZVAPuUz3MT+pg+EGoXuRtZfkRYFt+yiWZ2P1
        ZhGYZdBY4x0cCNjPA1rFkGOHLCOhb+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-iK3VVNtWMhWCex7zMWHdBg-1; Wed, 05 Aug 2020 05:00:43 -0400
X-MC-Unique: iK3VVNtWMhWCex7zMWHdBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 610091005504;
        Wed,  5 Aug 2020 09:00:41 +0000 (UTC)
Received: from ovpn-114-157.ams2.redhat.com (ovpn-114-157.ams2.redhat.com [10.36.114.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D0771797;
        Wed,  5 Aug 2020 09:00:38 +0000 (UTC)
Message-ID: <62165f6af630ec134713a7fa2c136ec60a67d2f2.camel@redhat.com>
Subject: Re: [PATCH] net: openvswitch: silence suspicious RCU usage warning
From:   Paolo Abeni <pabeni@redhat.com>
To:     xiangxia.m.yue@gmail.com, davem@davemloft.net, echaudro@redhat.com,
        kuba@kernel.org, pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Cc:     dev@openvswitch.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 05 Aug 2020 11:00:37 +0200
In-Reply-To: <20200805071911.64101-1-xiangxia.m.yue@gmail.com>
References: <20200805071911.64101-1-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-05 at 15:19 +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> ovs_flow_tbl_destroy always is called from RCU callback
> or error path. It is no need to check if rcu_read_lock
> or lockdep_ovsl_is_held was held.
> 
> ovs_dp_cmd_fill_info always is called with ovs_mutex,
> So use the rcu_dereference_ovsl instead of rcu_dereference
> in ovs_flow_tbl_masks_cache_size.
> 
> Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")
> Cc: Eelco Chaudron <echaudro@redhat.com>
> Reported-by: syzbot+c0eb9e7cdde04e4eb4be@syzkaller.appspotmail.com
> Reported-by: syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

