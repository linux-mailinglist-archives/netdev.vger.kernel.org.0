Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D1A6D7888
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbjDEJiY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Apr 2023 05:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbjDEJiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:38:23 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB42558F
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:37:58 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-EDDWpa7tNsOL86AGmu49Kg-1; Wed, 05 Apr 2023 05:37:51 -0400
X-MC-Unique: EDDWpa7tNsOL86AGmu49Kg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DE328996E4;
        Wed,  5 Apr 2023 09:37:51 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13BBF40104E;
        Wed,  5 Apr 2023 09:37:49 +0000 (UTC)
Date:   Wed, 5 Apr 2023 11:37:48 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net-next v3 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <ZC1BbKhzYTjGQuzz@hog>
References: <20230330135715.23652-1-ehakim@nvidia.com>
 <20230330135715.23652-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230330135715.23652-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-03-30, 16:57:12 +0300, Emeel Hakim wrote:
> +static int vlan_macsec_del_secy(struct macsec_context *ctx)
> +{
> +	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
> +
> +	if (!ops || !ops->mdo_del_secy)
> +		return -EOPNOTSUPP;
> +
> +	return ops->mdo_del_secy(ctx);
> +}
> +
> +#undef _BUILD_VLAN_MACSEC_MDO

FWIW, I didn't have a problem with this particular macro, only
VLAN_MACSEC_DECLARE_MDO. But if you're going to remove
_BUILD_VLAN_MACSEC_MDO, you need to remove it completely.

-- 
Sabrina

