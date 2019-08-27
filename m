Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229F69E877
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 14:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfH0M5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 08:57:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfH0M5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 08:57:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED55910F23EB;
        Tue, 27 Aug 2019 12:57:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 856E8104B4ED;
        Tue, 27 Aug 2019 12:57:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190824.143533.1547411490171696760.davem@davemloft.net>
References: <20190824.143533.1547411490171696760.davem@davemloft.net> <156647679816.11606.13713532963081370001.stgit@warthog.procyon.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix lack of conn cleanup when local endpoint is cleaned up
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23573.1566910624.1@warthog.procyon.org.uk>
Date:   Tue, 27 Aug 2019 13:57:04 +0100
Message-ID: <23574.1566910624@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 27 Aug 2019 12:57:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> Once you've removed the entries from the globally visible idle_client_comms
> list, and put them on the local garbage list, they cannot be seen in any way
> by external threads of control outside of this function.

Yeah, I think you're right.  I was thinking that it might race with
rxrpc_discard_expired_client_conns() but that takes the locks too, so it
shouldn't.

David
