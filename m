Return-Path: <netdev+bounces-7434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67AAB720427
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E98AA1C20F25
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850B81992E;
	Fri,  2 Jun 2023 14:19:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714D117748
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:19:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209C91A4
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685715586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7QhW7/i0FRlUnhrbmH72Ja6oOS6tHr9UF8yYfs7l5Z4=;
	b=BzoJhwWpIbwLXCH2I1PTHPsUOZDFv9IgmI7XLwmEeexMrSWyoN/EwHzaiH0GSK+2mMR5Rj
	oWUo559ROeHYDJTYXFkOAtbCfvKfmcDT/rta0i8jfaKN3sCb3oUiM8thUz4jPrCBZayPVq
	5bVXofZuDrV7F7lOHG5R6UoduAH9ibs=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-KZ7mgIcJNb2gKWVrWthaRg-1; Fri, 02 Jun 2023 10:19:44 -0400
X-MC-Unique: KZ7mgIcJNb2gKWVrWthaRg-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-787259f0c14so707524241.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 07:19:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685715584; x=1688307584;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7QhW7/i0FRlUnhrbmH72Ja6oOS6tHr9UF8yYfs7l5Z4=;
        b=JVIwDYQBUgAiNUJF/tYSTZGD8eIE95WdGipmePk/oxnI3iL8hip1doHkJ3oeJv8v3b
         Bf0cprV8v024j5yLDvIKunESf0imskKOh63hvEc2KOIQdR7JcxElGd2ei8r7Lyi9nnsJ
         Fhbue+bEmJuhh/ronOwXIc0w3xRXmCuUrWkUyJCTcbUoZE45XwL/xViFXjiUXN365n/V
         /F+KjmzDBVUgrPtsgi3I3vhPMQvQjblYwYiRGj6jiQwEL/rdH/Kmykoe5DYKAoqBVIKZ
         IXDRngiPgxk5TZKr2Mi2WHyN3Mn6ebqjC8af5+YM4xNA0WgFcpyQxNBljOHH3p2Jd3Yv
         00vw==
X-Gm-Message-State: AC+VfDwlPCXpXmCNsxUG6k5ZKJaVUT/OHr35GFb/HrlljDhNvJ5Eq7le
	SHgNbAF3sRPtjE4nJIpM/Eu6mt1vGpdUO2s8pmj/3IZu+PBZxjnSN+WzHC+rS/HE1qDxpaESEUK
	DSM8//lMwOTV+hrmUn1McPznuEJ97FA0+
X-Received: by 2002:a05:6102:386:b0:43b:2a58:8eb5 with SMTP id m6-20020a056102038600b0043b2a588eb5mr539719vsq.20.1685715584055;
        Fri, 02 Jun 2023 07:19:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6H3lxW+/4C2SjR7NzpUxMz9/lst7zea9fwpp0G1WUsfu5uk6aGqNxIL8kxBSAO1f5QfeP8abKkOz7xfhNwH0E=
X-Received: by 2002:a05:6102:386:b0:43b:2a58:8eb5 with SMTP id
 m6-20020a056102038600b0043b2a588eb5mr539705vsq.20.1685715583832; Fri, 02 Jun
 2023 07:19:43 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Jun 2023 07:19:43 -0700
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-3-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517110232.29349-3-jhs@mojatatu.com>
Date: Fri, 2 Jun 2023 07:19:43 -0700
Message-ID: <CALnP8ZbH+V5gq90+m8uwYy_8V-FKQtoVmEdj1DKw051RdBJ8xw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 03/28] net/sched: act_api: increase TCA_ID_MAX
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

On Wed, May 17, 2023 at 07:02:07AM -0400, Jamal Hadi Salim wrote:
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -140,9 +140,9 @@ enum tca_id {
>  	TCA_ID_MPLS,
>  	TCA_ID_CT,
>  	TCA_ID_GATE,
> -	TCA_ID_DYN,
> +	TCA_ID_DYN = 256,
>  	/* other actions go here */
> -	__TCA_ID_MAX = 255
> +	__TCA_ID_MAX = 1023
>  };

It feels that this patch should go together with the 1st one, when
dynamic actions were introduced. When I was reading that patch, I was
wondering about possible conflicts with a new loaded dynamic action
and some userspace app using a new tca_id definition (it is UAPI,
after all) that overlaps with it.

  Marcelo


