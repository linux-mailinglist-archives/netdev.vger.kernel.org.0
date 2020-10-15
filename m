Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F222A28EE46
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 10:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbgJOILy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 04:11:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728283AbgJOILx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 04:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602749512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4rrmzJcH8XwGIK9+NfTOda3/Ha5CINen3BqZbMVuGcI=;
        b=ALeIv1+FfCDHvTIbyfkgvP7lKtwAYrBaTBfDW5956UQLzPLeB6QGRZ3PIdS28rNmLx2/sH
        oEmf95DFHJTzcEj++L/kQFAYfr23uB/UmupsT5y06hZhVV3dUA6eefrLlQK0i6Ctad1yzN
        LIzT7/AAi/HViJqLhIMERhT2Mk3Nbco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-yW7YWbCiNZOXcYc8rzOKeQ-1; Thu, 15 Oct 2020 04:11:49 -0400
X-MC-Unique: yW7YWbCiNZOXcYc8rzOKeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2847280365F;
        Thu, 15 Oct 2020 08:11:35 +0000 (UTC)
Received: from [10.36.112.252] (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 660C35D9CD;
        Thu, 15 Oct 2020 08:11:33 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        jlelli@redhat.com
Subject: Re: [PATCH net-next] net: openvswitch: fix to make sure flow_lookup()
 is not preempted
Date:   Thu, 15 Oct 2020 10:11:31 +0200
Message-ID: <80D4D885-0E28-4B29-8C1E-34F5FBB6CF38@redhat.com>
In-Reply-To: <20201015075517.gjsebwhqznj6ypm3@linutronix.de>
References: <160259304349.181017.7492443293310262978.stgit@ebuild>
 <20201013125307.ugz4nvjvyxrfhi6n@linutronix.de>
 <3D834ADB-09E7-4E28-B62F-CB6281987E41@redhat.com>
 <20201015075517.gjsebwhqznj6ypm3@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Oct 2020, at 9:55, Sebastian Andrzej Siewior wrote:

> On 2020-10-14 12:44:23 [+0200], Eelco Chaudron wrote:
>> Let me know your thoughts.
>
> better. If your seccount is per-CPU then you get away without explicit
> writer locking if you rely on global per-CPU locking. You can't do
> preempt_disable() because this section can be interrupt by softirq. 
> You
> need something stronger :)

Thanks for your reply! Yes I had it replaced with local_bh_disable() in 
my v2, as I noticed the hard IRQ to softirq part earlier.

> Side note: Adding a fixes tag and net-next looks like "stable material
> starting next merge window".

Have the patch on net-next, but will send it out on next (will do the 
conversion later today and sent it out).

Thanks,

Eelco

