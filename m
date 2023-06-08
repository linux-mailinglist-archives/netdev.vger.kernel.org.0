Return-Path: <netdev+bounces-9160-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A40B727A4D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A30628163F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAC0882F;
	Thu,  8 Jun 2023 08:46:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46F81FBB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 08:46:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D63E61
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686214011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=38+85OTQ+HMYUNOTdFrJFkBVZVJYpBGcWKwllCWAZOo=;
	b=TD7zuW6MHAObPVLmxc2UypjTUyI/fAgie2+VPyNQ9VH7HrVlNn2X2dt4ExgmtwrlH0dgEp
	w6olZXtXdMGsy8yS8qztCeIMNNF9qoYlQ2VEfCWuNh3q4vOy79rJjLLwN7tyY4a/Etkt7J
	5jZdZ2krEfpDTxrvnBep68N9+WMg6kQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-IeNC-6_3Nt23-aAR2B8JQQ-1; Thu, 08 Jun 2023 04:46:50 -0400
X-MC-Unique: IeNC-6_3Nt23-aAR2B8JQQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f7ecda6eefso569845e9.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 01:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686214009; x=1688806009;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=38+85OTQ+HMYUNOTdFrJFkBVZVJYpBGcWKwllCWAZOo=;
        b=EgJtcJDXeUBeGWC7OmZFoLl/RYkrl3KEeibZHV6kUBAXGSIniN1qFqQ2YMZH+4iqhE
         UKFq14Hy8NQzg4ufnnmVOUkIBSEdjcDmIDjqGspgyosfq9l1jogjLE5n97B021kKl1If
         tG8b7uds5n9oLISNrgeYXILZVlVnMejQEPW4tQ7yg4mJZ3VMNfUJEzH70VEER0qp2VPa
         xL0MfVF6etd3OGCyqxgQxApGO4/zLpZNyZsBmKI6mY+1b1U3/pigFQc0FRUreOgtryIb
         envrmuks2sk+uab3RcFne9QSycUXr6taZazx/5Dg0jd3XTKqpzsfO158p/HY9P1Jx+du
         i0PA==
X-Gm-Message-State: AC+VfDxn+7FL7TScKv57EHbHlZWFXoDIl0P1+FlbLrDA4YQIxRUX3hPh
	5Jt36VFVv+If0RJ4pd0eWjWwoSRUv1tKSFBEiSfYZ2i9zwMbWpKcwSdcqym0OAdrEy6g2+IN5fI
	H4FGK/4iFX5DAA6LI
X-Received: by 2002:adf:eac5:0:b0:30c:2bd4:5141 with SMTP id o5-20020adfeac5000000b0030c2bd45141mr5361868wrn.4.1686214009124;
        Thu, 08 Jun 2023 01:46:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7LElmLrbSv9SalvlL4nycFE++nBp1tuF09Dz34nRw45N8JWNsOVsy0MQxWyzfWTQsj4jayqQ==
X-Received: by 2002:adf:eac5:0:b0:30c:2bd4:5141 with SMTP id o5-20020adfeac5000000b0030c2bd45141mr5361857wrn.4.1686214008768;
        Thu, 08 Jun 2023 01:46:48 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-247-199.dyn.eolo.it. [146.241.247.199])
        by smtp.gmail.com with ESMTPSA id v18-20020a5d43d2000000b0030ae93bd196sm900421wrr.21.2023.06.08.01.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 01:46:48 -0700 (PDT)
Message-ID: <76ae9edbc10e8715797a0c1d9ef588fd72fe08f0.camel@redhat.com>
Subject: Re: [PATCH net] ipvlan: fix bound dev checking for IPv6 l3s mode
From: Paolo Abeni <pabeni@redhat.com>
To: Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc: David Ahern <dsa@cumulusnetworks.com>, Jianguo Wu
 <wujianguo@chinatelecom.cn>, Daniel Borkmann <daniel@iogearbox.net>, Mahesh
 Bandewar <maheshb@google.com>
Date: Thu, 08 Jun 2023 10:46:47 +0200
In-Reply-To: <20230607084530.2739069-1-liuhangbin@gmail.com>
References: <20230607084530.2739069-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-06-07 at 16:45 +0800, Hangbin Liu wrote:
> The commit 59a0b022aa24 ("ipvlan: Make skb->skb_iif track skb->dev for l3=
s
> mode") fixed ipvlan bonded dev checking by updating skb skb_iif. This fix
> works for IPv4, as in raw_v4_input() the dif is from inet_iif(skb), which
> is skb->skb_iif when there is no route.
>=20
> But for IPv6, the fix is not enough, because in ipv6_raw_deliver() ->
> raw_v6_match(), the dif is inet6_iif(skb), which is returns IP6CB(skb)->i=
if
> instead of skb->skb_iif if it's not a l3_slave. To fix the IPv6 part
> issue. Let's set IP6SKB_L3SLAVE flag for ipvlan l3s input packets.
>=20
> Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other m=
odes")
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=3D2196710
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> I'm not 100% sure if we can use IP6SKB_L3SLAVE flag for ipvlan.=C2=A0

I'm unsure either ;) Especially for a -net patch, as the implication on
later stack processing are fairly not trivial to me.

What about instead just setting IP6CB(skb)->iif for ipv6 packets?

Side notes we could possibly use nf hooks for ipv4 and ipv6

Thanks!

Paolo


