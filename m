Return-Path: <netdev+bounces-4792-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77EFA70E4CC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 306272814E3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF4C1F957;
	Tue, 23 May 2023 18:37:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385711F93C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 18:37:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF2A121
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684867037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ne4lI3XBOfn/dU70cqrJB1YITpsxLYLGq04RDFg9HVs=;
	b=aab5m+Qj2a6Rfja05VsdRHHtgiBWM3QsncmQ28lMgzOatcPwqmI1joCYjDgrtxtB86dnNk
	YROGO7ltWqu65m0lBDoDMo63cFxham5ujmRktnKgCS5JRKp8pWHY+Q81+5twERVxWRVGkd
	4wXmxSL+k5GOBvHvzsbXANmthDETcgU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-kTtGeXteMZ2zoZQvw6WWLw-1; Tue, 23 May 2023 14:37:13 -0400
X-MC-Unique: kTtGeXteMZ2zoZQvw6WWLw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-751409fae81so29329185a.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684867031; x=1687459031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ne4lI3XBOfn/dU70cqrJB1YITpsxLYLGq04RDFg9HVs=;
        b=cZ15+Gn7s8PT08XZoO35n6n3WLzxMvrvbRbn4ip8sxtJcw5rRACyHKtoDnsMyktysc
         ixmKFosIn7raWrZpOhX7z1cSoMFafSPk1ptZr1PRLZEyNUtCerzJ1/k51dmVXTDsnrPC
         CzdawQRcfVHM4afc4xMshR6Z95jbCqsjk1Rxlvn4PyGsukrfnHoqwT+3z8CHb+XwxYGj
         bTThmIYey1AmQ7eW6YEujRZwIqyychGrl26VfmtelG0+tE9qwiEPGDnjpZSwvQXhUYHH
         DnEl2+wCqSsND4ZycKGc9Wrr0MNFRVqmX4KR3oY5tx10krAwdGq6zlSRHV/dr3j1LV2p
         zTfw==
X-Gm-Message-State: AC+VfDyE5Et4HWG6qAaendTsWbqqq85fXVqSGOgG7Mbx1pnh1NOlSTY1
	c7Ivbq1gyNp1ljwzZ3DJ5ufFIH6GT1fszrpUavOTBsdGtTydChhoU5DbcMcaL4c5963NEu+fIe9
	riXqFCt0EM4iVos+f
X-Received: by 2002:a05:620a:25a:b0:75b:23a1:47c with SMTP id q26-20020a05620a025a00b0075b23a1047cmr5399071qkn.66.1684867030825;
        Tue, 23 May 2023 11:37:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4vKKkkQhDC5kjthEgm3oez1SkLO6FNrU8QgU5tlWWSYzEfoJ+DRMy6HY3ELLAHWXBiul/TJw==
X-Received: by 2002:a05:620a:25a:b0:75b:23a1:47c with SMTP id q26-20020a05620a025a00b0075b23a1047cmr5399055qkn.66.1684867030576;
        Tue, 23 May 2023 11:37:10 -0700 (PDT)
Received: from localhost ([37.163.86.172])
        by smtp.gmail.com with ESMTPSA id a19-20020a05620a103300b007576f08d3afsm2704662qkk.111.2023.05.23.11.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 11:37:10 -0700 (PDT)
Date: Tue, 23 May 2023 20:37:04 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
	liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v6] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZG0H0OYaKlni3Je9@renaissance-vector>
References: <20230523044805.22211-1-vladimir@nikishkin.pw>
 <20230523090441.5a68d0db@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090441.5a68d0db@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 09:04:41AM -0700, Stephen Hemminger wrote:
> On Tue, 23 May 2023 12:48:05 +0800
> Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:
> 
> > +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
> > +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
> > +
> > +		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
> > +		if (!localbypass)
> > +			print_bool(PRINT_FP, NULL, "nolocalbypass ", true);
> > +	}
> 
> This is backwards since nolocalbypass is the default.
>

Stephen, I'll try to summarize the discussion we had in v5 here.

- We agree that it's a good idea to have JSON attributes printed both
  when 'true' and 'false'. As Petr said, this makes the code less error
  prone and makes it clear attribute is supported.
- I have some concerns about printing options only when non-default
  values are set. Non-JSON output is mostly consumed by humans, that
  usually expects something to be visible if present/true/enabled. I
  know I'm advocating for a change in the iproute output here, and we
  usually don't do that, but I argue there's value in having a less
  cluttered and confusing output.

  For example, let's take what you see with a default vxlan:
  $ ip link add type vxlan id 12
  $ ip -j link show vxlan0
  [...] udpcsum noudp6zerocsumtx noudp6zerocsumrx [...]

  IMHO printing only "udpcsum" is enough to make the user aware that
  the "udpcsum" feature is enabled and the rest is off.

I'm not against Vladimir's change, of course. But I would be very happy
if we can agree on a direction for the output from now on, and try to
enforce it, maybe deprecating the "old way" to print out stuff step by
step, if we find it useful.

What do you think?
Andrea


