Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAA1229B64
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732690AbgGVPbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:31:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27017 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727778AbgGVPbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595431908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jLqBc9RYniLFUUTWsxq6fjT8G8kMJYPSdGSPtHg5y+0=;
        b=XNdKY46h6ypKXfOoxUowGb0sJsgvegqj5mc+lJDxx4TBlKxXoZI+/Bfrg96U3zp4a2CuJF
        624rkH+jnV4Z3UMIhQE4Zi5trz3CBu1G8E3/QVDJJM6d62qVNZydHbRtQRf0riz1WmRqxx
        d4stCNGTGEj8iZeyL/n2/Yd1DvQLmoI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-jYBIU6wCPjuoM6OOIlqqzA-1; Wed, 22 Jul 2020 11:31:44 -0400
X-MC-Unique: jYBIU6wCPjuoM6OOIlqqzA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE2C819057A0;
        Wed, 22 Jul 2020 15:31:42 +0000 (UTC)
Received: from [10.36.112.226] (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D09AB8BEC4;
        Wed, 22 Jul 2020 15:31:38 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next 2/2] net: openvswitch: make masks cache size
 configurable
Date:   Wed, 22 Jul 2020 17:31:37 +0200
Message-ID: <967448E7-939A-4E3F-8D59-DC0F780C8D09@redhat.com>
In-Reply-To: <20200722082128.53cf22e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <159540642765.619787.5484526399990292188.stgit@ebuild>
 <159540647223.619787.13052866492035799125.stgit@ebuild>
 <20200722082128.53cf22e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; markup=markdown
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Jul 2020, at 17:21, Jakub Kicinski wrote:

> On Wed, 22 Jul 2020 10:27:52 +0200 Eelco Chaudron wrote:
>> This patch makes the masks cache size configurable, or with
>> a size of 0, disable it.
>>
>> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
> Hi Elco!
>
> This patch adds a bunch of new sparse warnings:
>
> net/openvswitch/flow_table.c:376:23: warning: incorrect type in 
> assignment (different address spaces)
> net/openvswitch/flow_table.c:376:23:    expected struct 
> mask_cache_entry *cache
> net/openvswitch/flow_table.c:376:23:    got void [noderef] __percpu *
> net/openvswitch/flow_table.c:386:25: warning: incorrect type in 
> assignment (different address spaces)
> net/openvswitch/flow_table.c:386:25:    expected struct 
> mask_cache_entry [noderef] __percpu *mask_cache
> net/openvswitch/flow_table.c:386:25:    got struct mask_cache_entry 
> *cache
> net/openvswitch/flow_table.c:411:27: warning: incorrect type in 
> assignment (different address spaces)
> net/openvswitch/flow_table.c:411:27:    expected struct mask_cache 
> [noderef] __rcu *mask_cache
> net/openvswitch/flow_table.c:411:27:    got struct mask_cache *
> net/openvswitch/flow_table.c:440:35: warning: incorrect type in 
> argument 1 (different address spaces)
> net/openvswitch/flow_table.c:440:35:    expected struct mask_cache *mc
> net/openvswitch/flow_table.c:440:35:    got struct mask_cache 
> [noderef] __rcu *mask_cache

Odd, as I’m sure I ran checkpatch :( Will sent an update fixing those!

