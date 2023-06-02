Return-Path: <netdev+bounces-7579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B4B720B46
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 23:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E3BF281AFC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F588A943;
	Fri,  2 Jun 2023 21:54:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAFE2F33
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 21:54:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35511A5
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685742888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AFV95qiuTCRDmeVkNTdHSQQGo+oVfE68K0DxeSS0UPI=;
	b=OdIfuUMXvyxfAto8Q4mapWaRQeaQJFI7cC6fT03hKvY4pmGKt37Jjg8mkitzKxONFBPa3Y
	MDqgOksDcCDKGKf0g2zGQOVgj4g0MP3MNZOrJ3TDUSLvIkyw9Tac4SEO5zm9JA9HaylQRD
	34V9Nfh4VchuTUpaTK9TiRg4Nlkzx14=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-UZJdwuIsP16cr2MPfvWAuQ-1; Fri, 02 Jun 2023 17:54:46 -0400
X-MC-Unique: UZJdwuIsP16cr2MPfvWAuQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6261a0b2391so31252636d6.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 14:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685742886; x=1688334886;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AFV95qiuTCRDmeVkNTdHSQQGo+oVfE68K0DxeSS0UPI=;
        b=eUmnW8PExHzgM1FFEa9vDNghmErgRVtjLZjb4qmOuqfvDZBwu97sM6aAjF97iT++23
         utVjgnIeGd9fgAraa10Hyc+30T0+feP3BbwT14OVomMb7a14Zv2utdb/EQRMf61OE82d
         Q72KViZ8+cvAR71GlTSjKjx6t0s5xbc7Q6vA31X9NwNbSvArFN3ivM0m0dlogGzr+tUK
         z4LtVIi8zxUX8CuUeXLQxokWTvc8oj9KC8N2E816F6bUubhfjp3P3HpwNH77DnEcME/u
         jXhYzxwwCeReSnCOJwmo0eWFYCD6z5pRiJFIS3eOZG54X1Mf+cYlpyZr/1lmAXjCrynm
         R8JQ==
X-Gm-Message-State: AC+VfDx6PlDPntCOdAzEUh9kjQg6R65TDDWcn9wpHL0JmGc8nPck8aZO
	9ohQp8U/pCQAjUr38771SN4gUUYlcRD7+aK+d0GpseNWI/v1Oz5SWCZYyCCcqSFezSoua6mjVr+
	ANUR69yJwlL0zpxo8ZdR+CA9FN6b0OmC5
X-Received: by 2002:a05:6214:2aa8:b0:623:638e:aa20 with SMTP id js8-20020a0562142aa800b00623638eaa20mr13951274qvb.51.1685742886415;
        Fri, 02 Jun 2023 14:54:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4TkKBfIe9YRg4+CiOBXBjr41Tpu44+MdFdu/IKba67cDrQtWRoAoBYTLRQR4oZE8AiEgF+6S1HzSsCJ/YPNvE=
X-Received: by 2002:a05:6214:2aa8:b0:623:638e:aa20 with SMTP id
 js8-20020a0562142aa800b00623638eaa20mr13951248qvb.51.1685742886166; Fri, 02
 Jun 2023 14:54:46 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Jun 2023 14:54:45 -0700
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-14-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517110232.29349-14-jhs@mojatatu.com>
Date: Fri, 2 Jun 2023 14:54:45 -0700
Message-ID: <CALnP8ZbeMnSL_aHnzK-V=exWNCKjcpZf5P0x8XukJeooX4KxKg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 14/28] p4tc: add table create, update,
 delete, get, flush and dump
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:18AM -0400, Jamal Hadi Salim wrote:
...
> ___Initial Table Entries___
...
> They would get:
>
> pipeline id 22
>     table id 1
>     table name cb/tname
>     key_sz 64
>     max entries 256
>     masks 8
>     table entries 1
>     permissions CRUD--R--X
>     entry:
>         table id 1
>         entry priority 17
>         key blob    101010a0a0a0a
>         mask blob   ffffff00ffffff

I'm wondering how these didn't align. Perhaps key had an extra 0 to
the left? It would be nice to right-align it.

>         create whodunnit tc
>         permissions -RUD--R--X
>
...
> +static int tcf_key_try_set_state_ready(struct p4tc_table_key *key,
> +				       struct netlink_ext_ack *extack)
> +{
> +	if (!key->key_acts) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Table key must have actions before sealing pipelline");

While at it, so that I don't forget stuff..
s/pipelline/pipeline/

> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __tcf_table_try_set_state_ready(struct p4tc_table *table,
> +					   struct netlink_ext_ack *extack)
> +{
> +	int i;
> +	int ret;
> +
> +	if (!table->tbl_postacts) {
> +		NL_SET_ERR_MSG(extack,
> +			       "All tables must have postactions before sealing pipelline");

Same.


