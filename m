Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650486A231E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 21:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBXUWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 15:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXUWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 15:22:46 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746091ACD6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 12:22:45 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-sywlCAklM7KmAoGsxNHjmQ-1; Fri, 24 Feb 2023 15:22:26 -0500
X-MC-Unique: sywlCAklM7KmAoGsxNHjmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1275885621;
        Fri, 24 Feb 2023 20:22:23 +0000 (UTC)
Received: from hog (unknown [10.39.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3199C404BEC0;
        Fri, 24 Feb 2023 20:22:21 +0000 (UTC)
Date:   Fri, 24 Feb 2023 21:22:20 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangyu Hua <hbh25y@gmail.com>, borisp@nvidia.com,
        john.fastabend@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ilyal@mellanox.com, aviadye@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tls: fix possible info leak in
 tls_set_device_offload()
Message-ID: <Y/kcfM5jWrQhdYFR@hog>
References: <20230224102839.26538-1-hbh25y@gmail.com>
 <20230224105729.5f420511@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230224105729.5f420511@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-24, 10:57:29 -0800, Jakub Kicinski wrote:
> On Fri, 24 Feb 2023 18:28:39 +0800 Hangyu Hua wrote:
> > After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
> > tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
> > before kmalloc cctx->iv. It is better to Set them to NULL to avoid any
> > potential info leak.
> 
> Please show clear chain of events which can lead to a use-after-free 
> or info leak. And if you can't please don't send the patch.

Sorry, I thought in this morning's discussion Hangyu had agreed to
remove all mentions of possible info leak while sending v2, since we
agreed [1] that this patch didn't fix any issue, just that it looked
more consistent, as tls_set_sw_offload NULLs iv and rec_seq on
failure. We can also drop the patch completely. Anyway since net-next
is closed, I should have told Hangyu to wait for 2 weeks.

[1] https://lore.kernel.org/all/310391ea-7c71-395e-5dcb-b0a983e6fc93@gmail.com/

-- 
Sabrina

