Return-Path: <netdev+bounces-8740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2E57257AC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA34F2812E4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108802112;
	Wed,  7 Jun 2023 08:32:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0520C1104
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:32:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C13F1B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686126747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CML4ab6B58M9ev6BpdLEEY4A76luqMMPJKhl0+/qfpg=;
	b=BHlU73azs25uwOeAph1QWaOB6Q50180lG9hYmnBLsKJctRvNDGOvhFxCyoRp6xajBGALPQ
	MX58XLn+V7W/dQfs8QeNJHOdvxi98glUhadGTBtz+MGfpxMhJrzJeXB9v7ArrXHKbPhk1/
	vCCbn1fRf/ZSKKebYQqBf7wuhqzWbwE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-NRO6IdReNw67FASQeh4QKQ-1; Wed, 07 Jun 2023 04:32:24 -0400
X-MC-Unique: NRO6IdReNw67FASQeh4QKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B50393802609;
	Wed,  7 Jun 2023 08:32:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4014C40D1B66;
	Wed,  7 Jun 2023 08:32:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZIA2L76MUoBLyfQf@xsang-OptiPlex-9020>
References: <ZIA2L76MUoBLyfQf@xsang-OptiPlex-9020> <202305260951.338c3bfe-oliver.sang@intel.com> <521116.1685091071@warthog.procyon.org.uk>
To: Oliver Sang <oliver.sang@intel.com>
Cc: dhowells@redhat.com, oe-lkp@lists.linux.dev, lkp@intel.com,
    Eric Dumazet <edumazet@google.com>,
    "David S. Miller" <davem@davemloft.net>,
    David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
    Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org,
    ying.huang@intel.com, feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [dhowells-fs:sendpage-1] [tcp] 77f5a42b2d: netperf.Throughput_Mbps -14.6% regression
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2003297.1686126739.1@warthog.procyon.org.uk>
Date: Wed, 07 Jun 2023 09:32:19 +0100
Message-ID: <2003298.1686126739@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Oliver Sang <oliver.sang@intel.com> wrote:

> > Could you try running this branch through your tests?
> 
> sorry for late.
> 
> we tested the tip of below branch, as you said, it has better performance
> even comparing to the parent of 77f5a42b2d

Many thanks!

David


