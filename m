Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6D15BF0C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbfGAPId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:08:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727568AbfGAPId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 11:08:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C826C1EB207;
        Mon,  1 Jul 2019 15:08:28 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 211376085B;
        Mon,  1 Jul 2019 15:08:20 +0000 (UTC)
Date:   Mon, 1 Jul 2019 17:08:19 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com, Robert Olsson <robert@herjulf.net>,
        Jean Hsiao <jhsiao@redhat.com>
Subject: Re: [PATCH 2/2] samples: pktgen: allow to specify destination port
Message-ID: <20190701170819.548a7457@carbon>
In-Reply-To: <20190629133358.8251-2-danieltimlee@gmail.com>
References: <20190629133358.8251-1-danieltimlee@gmail.com>
        <20190629133358.8251-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 01 Jul 2019 15:08:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 22:33:58 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> Currently, kernel pktgen has the feature to specify udp destination port
> for sending packet. (e.g. pgset "udp_dst_min 9")
> 
> But on samples, each of the scripts doesn't have any option to achieve this.
> 
> This commit adds the DST_PORT option to specify the target port(s) in the script.
> 
>     -p : ($DST_PORT)  destination PORT range (e.g. 433-444) is also allowed
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Nice feature, this look very usable for testing.  I think my QA asked
me for something similar.

One nitpick is that script named pktgen_sample03_burst_single_flow.sh
implies this is a single flow, but by specifying a port-range this will
be more flows.  I'm okay with adding this, as the end-user specifying a
port-range should realize this.  Thus, you get my ACK.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Another thing you should realize (but you/we cannot do anything about)
is that when the scripts use burst or clone, then the port (UDPDST_RND)
will be the same for all packets in the same burst.  I don't know if it
matters for your use-case.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
