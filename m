Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7351AE874
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgDQXA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:00:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24520 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726167AbgDQXAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 19:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587164454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7KGdTF+NLD8Xhkwl5nwHw+l3VQ9HqFkDHm1TE3ZyggA=;
        b=eNBLzQuU8Ikz3QWGUauuojkNSu+inZ1bXJLGAN7PMyVV/7M722jq5Jt3yw1T2rVWjgA0du
        y3LG51hmWvrQCuDjNyXLGsOeJI3owsZtG6A6ymqm98MzaLTWHzJDMUhE3v6vAFXUmSkgDk
        4gAP2LWzmSwEQOn73RIHnvFjsQ9P7xk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-Z6jo86v3Ng6PycfQ4J7_1g-1; Fri, 17 Apr 2020 19:00:50 -0400
X-MC-Unique: Z6jo86v3Ng6PycfQ4J7_1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8094BDB60;
        Fri, 17 Apr 2020 23:00:48 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03C479E0D4;
        Fri, 17 Apr 2020 23:00:43 +0000 (UTC)
Date:   Sat, 18 Apr 2020 01:00:38 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in nf_nat_unregister_fn
Message-ID: <20200418010038.57d5e5cf@elisabeth>
In-Reply-To: <20200417213348.GC32392@breakpoint.cc>
References: <000000000000490f1005a375ed34@google.com>
 <20200417094250.21872-1-hdanton@sina.com>
 <20200417213348.GC32392@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf,

On Fri, 17 Apr 2020 23:33:48 +0200
Florian Westphal <fw@strlen.de> wrote:

> Hillf Danton <hdanton@sina.com> wrote:
> > In case of failure to register NFPROTO_IPV4, unregister NFPROTO_IPV6
> > instead of ops->pf (== NFPROTO_INET).

Note that the patch you sent didn't reach any list you probably sent it
to (netfilter-devel, netdev, lkml). I'm seeing it just because Florian
answered.

This is probably the same issue we had with your openvswitch patch last
year. By the way, the IP address you used last time is now reported as
being "blocked" by:

	zen.spamhaus.org
	pbl.spamhaus.org

I guess vger might filter using Spamhaus lists (including their "PBL"),
which won't let your email through if you're running a mail server with
an dynamic IP address.

I don't support this practice, but this might be the issue. You can
quickly get an overview of blacklists your address might be on at e.g.:
	http://www.anti-abuse.org/

-- 
Stefano

