Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC848AA18
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 00:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfHLWAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 18:00:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfHLWAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 18:00:18 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE9C730FB8FC;
        Mon, 12 Aug 2019 22:00:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B4826A225;
        Mon, 12 Aug 2019 22:00:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <7e84e076-7096-028f-b49d-29160aea0831@I-love.SAKURA.ne.jp>
References: <7e84e076-7096-028f-b49d-29160aea0831@I-love.SAKURA.ne.jp> <00000000000021eea2058feaaf82@google.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+cda1ac91660a61b51495@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, linux-afs@lists.infradead.org
Subject: Re: WARNING in aa_sock_msg_perm
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18090.1565647215.1@warthog.procyon.org.uk>
Date:   Mon, 12 Aug 2019 23:00:15 +0100
Message-ID: <18091.1565647215@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 12 Aug 2019 22:00:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> This is not AppArmor's bug. LSM modules expect that "struct socket" is not
> NULL.  For some reason, peer->local->socket became NULL. Thus, suspecting
> rxrpc's bug.
> 
> >  rxrpc_send_keepalive+0x1ff/0x940 net/rxrpc/output.c:656

I agree.  There's a further refcounting bug in the local object handling, but
it's proving annoyingly difficult to reliably reproduce.

David
