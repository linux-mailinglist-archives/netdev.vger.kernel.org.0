Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F56CBD89
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389126AbfJDOkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:40:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389062AbfJDOkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 10:40:07 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C07518CB911;
        Fri,  4 Oct 2019 14:40:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6640119C5B;
        Fri,  4 Oct 2019 14:40:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190921122737.14884-1-hdanton@sina.com>
References: <20190921122737.14884-1-hdanton@sina.com> 
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+eed305768ece6682bb7f@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in rxrpc_release_call
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17921.1570200004.1@warthog.procyon.org.uk>
Date:   Fri, 04 Oct 2019 15:40:04 +0100
Message-ID: <17922.1570200004@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Fri, 04 Oct 2019 14:40:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

>  	if (conn) {
> -		rxrpc_disconnect_call(call);
>  		conn->security->free_call_crypto(call);
> +		rxrpc_disconnect_call(call);
>  	}

Better to cache the security pointer in the call struct, I think.

David
