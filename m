Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C847012551A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLRVwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:52:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38455 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726387AbfLRVwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 16:52:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576705960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yRUJBmZBX5I2Quvhv35YiDu9LJ31CJC6zvSs/gKguzA=;
        b=Zc8I3QliTVKGxwP6LZbkgHCNgD7P7ET683mI0v8IMQRV2/+8bAiYAByZ5260vBzJEz+mhc
        dgWDPM8CfBbP45GUaB2QWcP5FX1gV2giXsd+p0EgCBlikumxew8HExLx/suo1Io0WF3pm4
        Ak1OZfgSQGS3+n7YQVnV6kmH3RCl3EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-wtj0NxmANJSLODmbSH_odg-1; Wed, 18 Dec 2019 16:52:29 -0500
X-MC-Unique: wtj0NxmANJSLODmbSH_odg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88FEA593A1;
        Wed, 18 Dec 2019 21:52:27 +0000 (UTC)
Received: from ovpn-116-48.ams2.redhat.com (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD1015D9E2;
        Wed, 18 Dec 2019 21:52:25 +0000 (UTC)
Message-ID: <518dc6a3c77f51a9d56b66ac80ffb883d80ceedf.camel@redhat.com>
Subject: Re: [PATCH net-next v3 07/11] tcp: Prevent coalesce/collapse when
 skb has MPTCP extensions
From:   Paolo Abeni <pabeni@redhat.com>
To:     subashab@codeaurora.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        netdev-owner@vger.kernel.org
Date:   Wed, 18 Dec 2019 22:52:24 +0100
In-Reply-To: <6411d0366a6ec6a30f9dbf4117ea6d1f@codeaurora.org>
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
         <20191217203807.12579-8-mathew.j.martineau@linux.intel.com>
         <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com>
         <20191218.124510.1971632024371398726.davem@davemloft.net>
         <alpine.OSX.2.21.1912181251550.32925@mjmartin-mac01.local>
         <6411d0366a6ec6a30f9dbf4117ea6d1f@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-12-18 at 14:36 -0700, subashab@codeaurora.org wrote:
> > Ok, understood. Not every packet has this MPTCP extension data so
> > coalescing was not always turned off, but given the importance of
> > avoiding
> > 
> > this memory waste I'll confirm GRO behavior and work on maintaining
> > coalesce/collapse with identical MPTCP extension data.
> > 
> 
> Hi Mat
> 
> Are identical MPTCP extensions a common case?

Yes, they are.

> AFAIK the data sequence number and the subflow sequence number change
> per packet even in a single stream scenario.

What actually change on per packet basis is the TCP sequence number.
The DSS mapping can spawn on multiple packets, and will have constand
(base) sequence number and length.

Cheers,

Paolo

