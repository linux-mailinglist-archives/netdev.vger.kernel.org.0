Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CD7A480E
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 09:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfIAHO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 03:14:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbfIAHO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 03:14:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB10F189DAD1;
        Sun,  1 Sep 2019 07:14:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41D0A19C70;
        Sun,  1 Sep 2019 07:14:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190901020519.2392-1-hdanton@sina.com>
References: <20190901020519.2392-1-hdanton@sina.com> <20190831135906.6028-1-hdanton@sina.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix lack of conn cleanup when local endpoint is cleaned up [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14575.1567322096.1@warthog.procyon.org.uk>
Date:   Sun, 01 Sep 2019 08:14:56 +0100
Message-ID: <14576.1567322096@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Sun, 01 Sep 2019 07:14:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

> > It's certainly possible that that can happen.  The reaper is per
> > network-namespace.
> > 
> > conn->params.local holds a ref on the local endpoint.
> > 
> Then local endpoint can not become dead without connection reaper
> running first, because of the ref held by connection. When it is
> dead, however, there is no need to run reaper directly (rather than
> through a workqueue).

The reaper is per-net_ns, not per-local.  There may be more than one local
endpoint in a net_ns and they share the list of service connections.

David
