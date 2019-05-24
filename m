Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B15629572
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390513AbfEXKHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:07:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390248AbfEXKHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 06:07:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9FC7A30821F8;
        Fri, 24 May 2019 10:07:22 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 104635B683;
        Fri, 24 May 2019 10:07:16 +0000 (UTC)
Date:   Fri, 24 May 2019 12:07:15 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     brouer@redhat.com, Saeed Mahameed <saeedm@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] net: core: support XDP generic on stacked
 devices.
Message-ID: <20190524120715.6f1c13bd@carbon>
In-Reply-To: <ebf12468-504c-fae7-b62d-2b6db47391f9@redhat.com>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
        <20190523175429.13302-3-sthemmin@microsoft.com>
        <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
        <ebf12468-504c-fae7-b62d-2b6db47391f9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 24 May 2019 10:07:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 12:17:27 +0800
Jason Wang <jasowang@redhat.com> wrote:

> > Maybe this is acceptable, but it should be documented, as the current
> > assumption dictates: XDP program runs on the core where the XDP
> > frame/SKB was first seen.  
> 
> 
> At lest for TUN, this is not true. XDP frames were built by vhost_net 
> and passed to TUN. There's no guarantee that vhost_net kthread won't 
> move to another core.

This sound a little scary, as we depend on per-CPU variables (e.g.
bpf_redirect_info).  Can the vhost_net kthread move between CPUs
within/during the NAPI-poll?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
