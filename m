Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4772A6659DB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjAKLR6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Jan 2023 06:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbjAKLRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:17:18 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00313B7E1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 03:16:48 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-VsqAeC8KP4yoOWEvMewHLg-1; Wed, 11 Jan 2023 06:16:31 -0500
X-MC-Unique: VsqAeC8KP4yoOWEvMewHLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 450571C09047;
        Wed, 11 Jan 2023 11:16:31 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 979931121314;
        Wed, 11 Jan 2023 11:16:30 +0000 (UTC)
Date:   Wed, 11 Jan 2023 12:15:06 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v3 1/1] macsec: Fix Macsec replay protection
Message-ID: <Y76aOvxVcW/upwjl@hog>
References: <20230111073259.19723-1-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230111073259.19723-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-11, 09:32:59 +0200, ehakim@nvidia.com wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently when configuring macsec with replay protection,
> replay protection and window gets a default value of -1,
> the above is leading to passing replay protection and
> replay window attributes to the kernel while replay is
> explicitly set to off, leading for an invalid argument
> error when configured with extended packet number (XPN).
> since the default window value which is 0xFFFFFFFF is
> passed to the kernel and while XPN is configured the above
> value is an invalid window value.
> 
> Example:
> ip link add link eth2 macsec0 type macsec sci 1 cipher
> gcm-aes-xpn-128 replay off
> 
> RTNETLINK answers: Invalid argument
> 
> Fix by passing the window attribute to the kernel only if replay is on
> 
> Fixes: b26fc590ce62 ("ip: add MACsec support")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks Emeel.

-- 
Sabrina

