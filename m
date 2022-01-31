Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2AA4A48EC
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 15:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349405AbiAaOEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 09:04:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240723AbiAaOEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 09:04:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643637878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=esE3nBda7+wwogYQhF38boxT6jAL49uFw0DfnxCNw2U=;
        b=ONYxoDrwKiiLsSF37HNQwBOriHbLD+lvKQ/i9novNUXCuByZykuv7ENI0RkSE6H1XnN9HR
        WG2phoAOrjoodyVhVPCNtvJFxfyGTaGQ1U5lu8VxjIuaDk+vIEgbqFqk9fSix0G2oI4Ovi
        k+sMmvkXEx098pFW86KJBYJPEtYYfj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-W09HmSwOOmm8wqmkzfYgNA-1; Mon, 31 Jan 2022 09:04:23 -0500
X-MC-Unique: W09HmSwOOmm8wqmkzfYgNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DE43801B1C;
        Mon, 31 Jan 2022 14:04:21 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41AD9708D3;
        Mon, 31 Jan 2022 14:04:21 +0000 (UTC)
Date:   Mon, 31 Jan 2022 15:04:18 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Vlad Buslov <vladbu@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, echaudro@redhat.com, netdev@vger.kernel.org,
        pshelar@ovn.org
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info
 when PMTU triggers an ICMP reply
Message-ID: <20220131150418.0fabd263@elisabeth>
In-Reply-To: <164363560725.4133.7633393991691247425@kwain>
References: <20210325153533.770125-1-atenart@kernel.org>
        <20210325153533.770125-2-atenart@kernel.org>
        <ygnhh79yluw2.fsf@nvidia.com>
        <164267447125.4497.8151505359440130213@kwain>
        <ygnhee52lg2d.fsf@nvidia.com>
        <164338929382.4461.13062562289533632448@kwain>
        <ygnhsft4p2mg.fsf@nvidia.com>
        <164363560725.4133.7633393991691247425@kwain>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

On Mon, 31 Jan 2022 14:26:47 +0100
Antoine Tenart <atenart@kernel.org> wrote:

> Quoting Vlad Buslov (2022-01-31 12:26:47)
> > On Fri 28 Jan 2022 at 19:01, Antoine Tenart <atenart@kernel.org> wrote:  
> > >
> > > I finally had some time to look at this. Does the diff below fix your
> > > issue?  
> > 
> > Yes, with the patch applied I'm no longer able to reproduce memory leak.
> > Thanks for fixing this!  
> 
> Thanks for testing. I'll send a formal patch, can I add your Tested-by?
> 
> Also, do you know how to trigger the following code path in OVS
> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#L944

I guess the selftests pmtu_ipv{4,6}_ovs_vxlan{4,6}_exception and
pmtu_ipv{4,6}_ovs_geneve{4,6}_exception from net/pmtu.sh:

	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/net/pmtu.sh?id=ece1278a9b81bdfc088f087f8372a072b7010956#n81

should trigger that path once or twice per test, but I haven't tried
recently.

-- 
Stefano

