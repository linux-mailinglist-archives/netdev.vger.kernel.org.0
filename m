Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0271523CF87
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgHETWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:22:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60419 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728415AbgHETVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596655280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=upKzByoNKnp369AJluJi0nFx3m44uHJVXXhuZAbsbC8=;
        b=b/ZJeH+V1vVzVnbsiNuQfh1vKuc+2Bm2fjQLnJU3XyE7O/8eKal922oN/p9p6jCVNfZgVF
        GryMJaMVQ1Ng1itO8h7FuFOUNhU9GcHdxkpaDwrxkBbnnW1HMXFjEwk5iDXqVwTOIk7CFy
        7qEjIWc9Eb2rUjYFGECYiyuIMB+1u2I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-XyS_1MxZPM-kBNySJASiUw-1; Wed, 05 Aug 2020 15:21:18 -0400
X-MC-Unique: XyS_1MxZPM-kBNySJASiUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2993B79EC0;
        Wed,  5 Aug 2020 19:21:17 +0000 (UTC)
Received: from [192.168.241.128] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EA2C87A43;
        Wed,  5 Aug 2020 19:21:15 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     xiangxia.m.yue@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: openvswitch: silence suspicious RCU usage warning
Date:   Wed, 05 Aug 2020 21:21:13 +0200
Message-ID: <323728A6-9ED5-4588-92D5-3F6799357D0A@redhat.com>
In-Reply-To: <20200805071911.64101-1-xiangxia.m.yue@gmail.com>
References: <20200805071911.64101-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5 Aug 2020, at 9:19, xiangxia.m.yue@gmail.com wrote:

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
> Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size 
> configurable")
> Cc: Eelco Chaudron <echaudro@redhat.com>
> Reported-by: syzbot+c0eb9e7cdde04e4eb4be@syzkaller.appspotmail.com
> Reported-by: syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Thanks for fixing this, I was (am) on PTO so did not notice it earlier!

Cheers,

Eelco

