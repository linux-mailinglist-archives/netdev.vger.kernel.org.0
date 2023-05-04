Return-Path: <netdev+bounces-285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDB46F6DA4
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 809F51C21139
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41C9FC1E;
	Thu,  4 May 2023 14:24:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973AB7E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 14:24:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7A5BBD
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683210269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOzsHxc5BgpQ8oc2mk4fuEbtTU3ybZLEMBOpZWsooMc=;
	b=dFMMoT9KYDcfRwja2d/hZBbmBhiQDaRNpT+oCHlWvXyeUWxF6LVbvlGFYMPNkvB43A0RvU
	qQB3w5BND15e3m5oJw+KZk5CyXO4BPNSk96D8oWBgiLsX6ashooMq9nRsoT8SW70DcM/zf
	c5wi2c2rRHZ/oCL2ULJgmDe461tvy/s=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-RSTbbRwGOt-TamPODZm30g-1; Thu, 04 May 2023 10:24:26 -0400
X-MC-Unique: RSTbbRwGOt-TamPODZm30g-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-61a3c7657aeso173306d6.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 07:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683210264; x=1685802264;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LOzsHxc5BgpQ8oc2mk4fuEbtTU3ybZLEMBOpZWsooMc=;
        b=LPrCCdElZYfWo2khKXxoSDZkdN6qfUd0KrZzoYosca4ti/1wcwCVEU0sUZXQK3cy2D
         WojBNlkame1HBIo6rhrOOGvLozWdewBrfKxXjGwszRjD8N94XVFuB7DpQ5U4ejF8coA7
         XzenfBr3jF2uIS0hHQxwc02WWZXBNJ2JWlIlagRVl9IcaVP00oDNH0hUx4JEfOyHr7k+
         IiEO+zz+vmTWiA41LGdSfwfC2xvKwiNIFlgYLk6wyNDz1WqFecB/hkkA7G7YQ+1ORidz
         Z4Zyn8GnuAcrATg/8nfZBlqLObLXEtLb3yXBom/69QyqmE//C2da/brI3WG55rBbVTKZ
         G6Jw==
X-Gm-Message-State: AC+VfDxLylP+Nuo2uZ1pS++J0FH3ZbUxmrk1M10Gk1pDCmnxUJnqUoaM
	NIGpxaRf3wVBGRAY1kMQr5r+t8MLSnEBmEUR2ESgeSYhIG52K1z581Dk9fnAO/PGRVg9Vx8pUeI
	WN/84WSEif6XlfS1M
X-Received: by 2002:a05:6214:5199:b0:616:870c:96b8 with SMTP id kl25-20020a056214519900b00616870c96b8mr31698346qvb.3.1683210264575;
        Thu, 04 May 2023 07:24:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6fuP9Q846qlkHZ88KB3rzhNDszjpLNiXYkhPpTFzfn7gNfCzcHHiwdeLmQzdeevOsXqvEGRg==
X-Received: by 2002:a05:6214:5199:b0:616:870c:96b8 with SMTP id kl25-20020a056214519900b00616870c96b8mr31698302qvb.3.1683210264244;
        Thu, 04 May 2023 07:24:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-79.dyn.eolo.it. [146.241.244.79])
        by smtp.gmail.com with ESMTPSA id h3-20020a0cf203000000b0061c073dd45dsm624017qvk.45.2023.05.04.07.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 07:24:23 -0700 (PDT)
Message-ID: <5c325bab5f4b4503c7740fd73e9ab603285d0315.camel@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
From: Paolo Abeni <pabeni@redhat.com>
To: Vlad Buslov <vladbu@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Ivan Vecera <ivecera@redhat.com>, Simon Horman
 <simon.horman@corigine.com>,  Pedro Tammela <pctammela@mojatatu.com>,
 davem@davemloft.net, netdev@vger.kernel.org, jhs@mojatatu.com, 
 xiyou.wangcong@gmail.com, jiri@resnulli.us, marcelo.leitner@gmail.com, 
 paulb@nvidia.com
Date: Thu, 04 May 2023 16:24:20 +0200
In-Reply-To: <87mt2kqkke.fsf@nvidia.com>
References: <20230426121415.2149732-1-vladbu@nvidia.com>
	 <20230426121415.2149732-3-vladbu@nvidia.com>
	 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
	 <87bkjasmtw.fsf@nvidia.com>
	 <1bf81145-0996-e473-4053-09f410195984@redhat.com>
	 <ZEtxvPaa/L3jHa2d@corigine.com>
	 <bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
	 <87354ks1ob.fsf@nvidia.com> <20230502194452.23e99a2c@kernel.org>
	 <87mt2kqkke.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-04 at 16:40 +0300, Vlad Buslov wrote:
> On Tue 02 May 2023 at 19:44, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 28 Apr 2023 14:03:19 +0300 Vlad Buslov wrote:
> > > Note that with these changes (both accepted patch and preceding diff)
> > > you are exposing filter to dapapath access (datapath looks up filter =
via
> > > hash table, not idr) with its handle set to 0 initially and then rese=
nt
> > > while already accessible. After taking a quick look at Paul's
> > > miss-to-action code it seems that handle value used by datapath is ta=
ken
> > > from struct tcf_exts_miss_cookie_node not from filter directly, so su=
ch
> > > approach likely doesn't break anything existing, but I might have mis=
sed
> > > something.
> >=20
> > Did we deadlock in this discussion, or the issue was otherwise fixed?
>=20
> From my side I explained why in my opinion Ivan's fix doesn't cover all
> cases and my approach is better overall. Don't know what else to discuss
> since it seems that everyone agreed.

Do I read correctly that we need a revert of Ivan's patch to safely
apply this series? If so, could you please repost including such
revert?

Thanks.

Paolo


