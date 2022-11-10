Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEFD6243DC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiKJOKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKJOKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:10:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A08BC3D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668089390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4XYurhd29LYrxY7oxBugU/CFN4NBPGNybaFxAiF1pgs=;
        b=Z2UN0DwyXSB2iq3elisnhmSIjuPk3HmHf1vKrN+t6Iu0nFBYm6e/Zsy+zNLBOKP38zX37C
        kvYbjzisXHG7S0MeBzyYgtnRqIHfeIkcgjX/T1AiWydXNHmS2P8OyBiegiLOs4qdBjJIya
        IPJDKBMzCY62E6qW/14k1X1RP6P4cwc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-HSyVkxo6OQGIbYTiO4TBFA-1; Thu, 10 Nov 2022 09:09:47 -0500
X-MC-Unique: HSyVkxo6OQGIbYTiO4TBFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5322B833A09;
        Thu, 10 Nov 2022 14:09:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A81C40C83DD;
        Thu, 10 Nov 2022 14:09:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y20A33ya17l/MqxU@lunn.ch>
References: <Y20A33ya17l/MqxU@lunn.ch> <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: Fix missing IPV6 #ifdef
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3080952.1668089385.1@warthog.procyon.org.uk>
Date:   Thu, 10 Nov 2022 14:09:45 +0000
Message-ID: <3080953.1668089385@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> wrote:

> > +#ifdef CONFIG_AF_RXRPC_IPV6
> >  	return ipv6_icmp_error(sk, skb, err, port, info, payload);
> > +#endif
> 
> Can this be if (IS_ENABLED(CONFIG_AF_RXRPC_IPV6) {} rather than
> #ifdef? It gives better build testing.

Sure.  Does it actually make that much of a difference?  I guess the
declaration is there even if IPV6 is disabled.

David

