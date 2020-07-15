Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E5C220FA0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgGOOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 10:38:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727044AbgGOOiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 10:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594823895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RNcA+TtqSKkcqFrFQ/lXwvp66Zlvrn9XWdE3nzqpNYU=;
        b=Yufw22oLE5tcxKmCugmpnMZIKsMkmFEHZhoOtU43iS6tZqgF7okrLktAWc1ok5QWZrfMGx
        XEdEmdWbMSitbnCD9LvTurvt3nwKcC5WQxFqzgb/U7siTUeDi7nKtJcVSglYzOIifxWkOv
        1f29A3sYT0xGJl8Mhr5LoKPSY9fc3Ng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-M4DACBRPMhqs1pW_uStGhg-1; Wed, 15 Jul 2020 10:38:13 -0400
X-MC-Unique: M4DACBRPMhqs1pW_uStGhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FE2215642;
        Wed, 15 Jul 2020 14:37:44 +0000 (UTC)
Received: from ovpn-114-12.ams2.redhat.com (ovpn-114-12.ams2.redhat.com [10.36.114.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A08B60BF4;
        Wed, 15 Jul 2020 14:37:42 +0000 (UTC)
Message-ID: <b9274778380debaacd8f31d7720df5c48457c0c7.camel@redhat.com>
Subject: Re: [PATCH net-next] net: openvswitch: reorder masks array based on
 usage
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pshelar@ovn.org
Date:   Wed, 15 Jul 2020 16:37:41 +0200
In-Reply-To: <159481496860.37198.8385493040681064040.stgit@ebuild>
References: <159481496860.37198.8385493040681064040.stgit@ebuild>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 14:09 +0200, Eelco Chaudron wrote:
> This patch reorders the masks array every 4 seconds based on their
> usage count. This greatly reduces the masks per packet hit, and
> hence the overall performance. Especially in the OVS/OVN case for
> OpenShift.
> 
> Here are some results from the OVS/OVN OpenShift test, which use
> 8 pods, each pod having 512 uperf connections, each connection
> sends a 64-byte request and gets a 1024-byte response (TCP).
> All uperf clients are on 1 worker node while all uperf servers are
> on the other worker node.
> 
> Kernel without this patch     :  7.71 Gbps
> Kernel with this patch applied: 14.52 Gbps
> 
> We also run some tests to verify the rebalance activity does not
> lower the flow insertion rate, which does not.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Tested-by: Andrew Theurer <atheurer@redhat.com>

Reviewed-by: Paolo Abeni <pabeni@redhat.com>

/P

