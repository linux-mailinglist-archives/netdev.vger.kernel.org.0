Return-Path: <netdev+bounces-7589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE9E720BBF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACD351C211F1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B61C146;
	Fri,  2 Jun 2023 22:08:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B9B8493
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:08:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE791B7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685743717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=daAt8hc3mM19oaRoAcJVccz16+ZbtNyhvVtjDRTmZQ4=;
	b=XLmtCCwVJIg2QqgvCC9ffZzlrck34QOLC04C+19qmK9tlrh13UBv6KkjN3hrMD1eRAwGow
	U7TT3B6RjEaz6sLAksl4unlZ/Ijb3xytSCUQ1JXZGtkMXHUVSTUbp1YXfUP3cuIjFkHdm+
	3iExT+I3RQNLrhCNVyNdiEBL/TYepk8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-S3BqbppdM-OeNuGhuk-fQw-1; Fri, 02 Jun 2023 18:08:36 -0400
X-MC-Unique: S3BqbppdM-OeNuGhuk-fQw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-75b0c2ee430so303143985a.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 15:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685743716; x=1688335716;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=daAt8hc3mM19oaRoAcJVccz16+ZbtNyhvVtjDRTmZQ4=;
        b=Fwh5YMogwiazPxzBY/Xxnb+kcyHKLXF5zN0ZXbTdpSQ68IJpCrjYXSOlUkmrGD4q6K
         7WR6VeQlTgNrTkoNpcxMVQMC3ubJaklP1HqOVAQyJ9RDJ7xssRS/QjTKrwR9ynKdmZRE
         MvVlNrcKmIZ5ipeVRizNTRzy3PReIEUsR7V5EY2VjlGurTZWjDIMtLCSpqXu1OYSC3Kg
         Ts/1vlvu3oc34lMiIU0EVceKBBMGC+qwikj01CfWwDuHrN6QujHrokvBBZ3pTjOFN9bj
         8A0BeVuEOTi4ToNNVlG6XcHUNRAkaRpR/GXfBtFXwt56pyA7AvGFVs0N2UyAwlsEYP4M
         Wgtw==
X-Gm-Message-State: AC+VfDzPQ6pGfocjI323RTiT0SIaaFUB66YVePHYtZ9kBmcjzSlQUwmm
	iwfMkAwtZ++ljBkyt4hKxK/dnY6pL+ODDn4umJtPjepwd1+cg3jcx+MkqcjpOuhfMmoAb5bRMIG
	AH77GkgvJLvZlgeKJ8Ft9AOabCPmJlRJ4
X-Received: by 2002:a05:620a:628e:b0:75b:23a1:407 with SMTP id ov14-20020a05620a628e00b0075b23a10407mr13242109qkn.29.1685743716039;
        Fri, 02 Jun 2023 15:08:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5I/Ci0gt+eDbo0rAXQ4cix0r+PZmlUFi6V3NSoRRKnzKxaCwfRY0sPgvgggqWlqGiUT/lhv3FHWXID4HO22ys=
X-Received: by 2002:a05:620a:628e:b0:75b:23a1:407 with SMTP id
 ov14-20020a05620a628e00b0075b23a10407mr13242080qkn.29.1685743715800; Fri, 02
 Jun 2023 15:08:35 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Jun 2023 15:08:35 -0700
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-20-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517110232.29349-20-jhs@mojatatu.com>
Date: Fri, 2 Jun 2023 15:08:35 -0700
Message-ID: <CALnP8Zb6tO-yuYXo4vD0DrJ=xuQN11-QPOg3FR_Gn1b8_Nm3Yw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 20/28] selftests: tc-testing: Don't assume
 ENVIR is declared in local config
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

On Wed, May 17, 2023 at 07:02:24AM -0400, Jamal Hadi Salim wrote:
> @@ -28,12 +28,14 @@ NAMES = {
>            'EBPFDIR': './'
>          }
>
> +ENVIR= {}
>
>  ENVIR = { }

Hm? :)

>
>  # put customizations in tdc_config_local.py
>  try:
>      from tdc_config_local import *
> +
>  except ImportError as ie:
>      pass
>
> --
> 2.25.1
>


