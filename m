Return-Path: <netdev+bounces-11048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C860731516
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 461FA1C20E48
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC67747E;
	Thu, 15 Jun 2023 10:18:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D3363B9
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:18:34 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B7E2713
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:18:32 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f63ab1ac4aso10080375e87.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686824310; x=1689416310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ap56JKyLvPpMQr70iQfAfA8ozIFkekLl2MWDnBSTZaU=;
        b=G7hdmIzBDETiEE5iMiHb3AGQB0YjHcndkZpI2wORxM972znVrv9oRL68b7oJ3paSIL
         M0CfSVHPU/dQGd3Zbs8iOIHbqceKMXPH6sd1qg0tvO9l6+ZEs9RbohLc8TkXSCkcJcWP
         LWw0Fi37tmlaeLzfgDnd49ozjgOE+6Yu1v56s6fn00KqlK4XeHUFOEZsPKcTXP2ttIAS
         PbrQhhj9P4fQ6zYIN7UF75Waa78doFwEnrLiOOrDV3Az2YCLA4rV7XLkhBN+9+QPyLZD
         abvxr6mklhO6N4Bo8a+9vOujXj/KQGy5p7DH22a+qo2ebd2tL5uun6hsdjuafKjIuGMf
         yRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686824310; x=1689416310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ap56JKyLvPpMQr70iQfAfA8ozIFkekLl2MWDnBSTZaU=;
        b=TZt4FTyXXn2fxN8/oXaF0TlOIjC2SNQtWmYwFH6w+zjDBkroCyVjOazQNobXocQHwV
         /H27/Vxe3SfFYC/pfkudzoTtOVwabnTcRkbSUxawKBMV5a/U/gn34ljfkFHfL/MhvlTE
         9McAOMe+ud4dGAkrBxFusFHSL7RmHcFAYJn96Y0Ti8rbXgfX3rI4wK28sqJqBcxK2TE5
         hMSfSm59ATYMg/waMz/Ed/AHuFo2agXQPvIMjLEQXn7X8aG8Y1NT89qOrNAdwIDZy6E9
         3X7tUAL7twnYOXrMJ0q3/kizggBiHGuM+3L/Ki9WwCTIKL9QGj8CJgHPty/xDG0UBAE0
         PmTg==
X-Gm-Message-State: AC+VfDySzBtW5GZN8AoFNcFlm8DyqK9OUL6lucnHbBJ0OX2GyIUb7DQS
	c5S/gBdXmH1jTZJ6eG6Yl+Js0Q==
X-Google-Smtp-Source: ACHHUZ6/50vU8AQuSAyGpNppIftO2bSH+nwKhe2pIDi3Dw6x7zHyzTV4OzfNc/SfSMarEfxr7QqB+A==
X-Received: by 2002:a05:6512:329c:b0:4f6:3c67:ddfc with SMTP id p28-20020a056512329c00b004f63c67ddfcmr9899222lfe.23.1686824310334;
        Thu, 15 Jun 2023 03:18:30 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i17-20020a5d6311000000b0030fae360f14sm15218538wru.68.2023.06.15.03.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 03:18:29 -0700 (PDT)
Date: Thu, 15 Jun 2023 12:18:28 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
	"vadfed@meta.com" <vadfed@meta.com>,
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"vadfed@fb.com" <vadfed@fb.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
	"M, Saeed" <saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>,
	"richardcochran@gmail.com" <richardcochran@gmail.com>,
	"sj@kernel.org" <sj@kernel.org>,
	"javierm@redhat.com" <javierm@redhat.com>,
	"ricardo.canuelo@collabora.com" <ricardo.canuelo@collabora.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"jacek.lawrynowicz@linux.intel.com" <jacek.lawrynowicz@linux.intel.com>,
	"airlied@redhat.com" <airlied@redhat.com>,
	"ogabbay@kernel.org" <ogabbay@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"nipun.gupta@amd.com" <nipun.gupta@amd.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux@zary.sk" <linux@zary.sk>,
	"masahiroy@kernel.org" <masahiroy@kernel.org>,
	"benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
	"geert+renesas@glider.be" <geert+renesas@glider.be>,
	"Olech, Milena" <milena.olech@intel.com>,
	"kuniyu@amazon.com" <kuniyu@amazon.com>,
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>,
	"hkallweit1@gmail.com" <hkallweit1@gmail.com>,
	"andy.ren@getcruise.com" <andy.ren@getcruise.com>,
	"razor@blackwall.org" <razor@blackwall.org>,
	"idosch@nvidia.com" <idosch@nvidia.com>,
	"lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
	"phil@nwl.cc" <phil@nwl.cc>,
	"claudiajkang@gmail.com" <claudiajkang@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	"vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Message-ID: <ZIrldB4ic3zt9nIk@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
 <20230612154329.7bd2d52f@kernel.org>
 <ZIg8/0UJB9Lbyx2D@nanopsycho>
 <20230613093801.735cd341@kernel.org>
 <ZImH/6GzGdydC3U3@nanopsycho>
 <DM6PR11MB465799A5A9BB0B8E73A073449B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230614121514.0d038aa3@kernel.org>
 <20230614122348.3e9b7e42@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614122348.3e9b7e42@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, Jun 14, 2023 at 09:23:48PM CEST, kuba@kernel.org wrote:
>On Wed, 14 Jun 2023 12:15:14 -0700 Jakub Kicinski wrote:
>> On Wed, 14 Jun 2023 12:21:29 +0000 Kubalewski, Arkadiusz wrote:
>> > Surely, we can skip this discussion and split the nest attr into something like:
>> > - PIN_A_PIN_PARENT_DEVICE,
>> > - PIN_A_PIN_PARENT_PIN.  
>> 
>> Yup, exactly. Should a fairly change code wise, if I'm looking right.
>                               ^ small

Yeah, that is what we had originally. This just pushes out the
different attr selection from the nest one level up to the actualy
nesting attribute.

One downside of this is you will have 2 arrays of parent objects,
one per parent type. Current code neatly groups them into a single array.

I guess this is a matter of personal preference, I'm fine either way.


