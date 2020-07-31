Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C18233E17
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgGaEJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:09:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725800AbgGaEJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 00:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596168594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uw4OZok6vwQ2jzLLzo6smptKxoyEL7PH9GKHJb7WNLw=;
        b=iqOc2WiyQKK2dyg6ETmTRgNbCLp2MLJYNYxgaadZJY8IjJNME2xVTKVRI7jWVqPbl16F5d
        XouAj9IJcvJ+MoDu+167V2B7IHnQVJJGtAG/dw7UO0zZUKkdmFrFQLNxbWLs6ttSZj37s3
        rHd+eMn7YCZIZGs3+8iP57CImqk/66Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-Y_plv5SlMla-ZToQzwpzBw-1; Fri, 31 Jul 2020 00:09:52 -0400
X-MC-Unique: Y_plv5SlMla-ZToQzwpzBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 351A418839C4
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 04:09:51 +0000 (UTC)
Received: from [10.72.13.197] (ovpn-13-197.pek2.redhat.com [10.72.13.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49F1A100238C;
        Fri, 31 Jul 2020 04:09:46 +0000 (UTC)
Subject: Re: rcu warnings in tun
To:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
References: <20200730161536-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <975ede3e-fa5d-032c-c958-b4cc2b5ca44a@redhat.com>
Date:   Fri, 31 Jul 2020 12:09:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730161536-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/31 上午4:16, Michael S. Tsirkin wrote:
> drivers/net/tun.c:3003:36: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/tun.c:3003:36:    expected struct tun_prog [noderef] __rcu **prog_p
> drivers/net/tun.c:3003:36:    got struct tun_prog **prog_p
> drivers/net/tun.c:3292:42: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/tun.c:3292:42:    expected struct tun_prog **prog_p
> drivers/net/tun.c:3292:42:    got struct tun_prog [noderef] __rcu **
> drivers/net/tun.c:3296:42: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/tun.c:3296:42:    expected struct tun_prog **prog_p
> drivers/net/tun.c:3296:42:    got struct tun_prog [noderef] __rcu **


prog_p in tun_set_bpf() should be protected by RCU, will post a fix.

Thanks

