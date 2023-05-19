Return-Path: <netdev+bounces-3821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40DAE708FBC
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D917281A48
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6406E65C;
	Fri, 19 May 2023 06:15:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE787C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:15:33 +0000 (UTC)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611181A6
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:15:22 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-307d20548adso1871226f8f.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684476921; x=1687068921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yCYh8uS1PtNXF3LwY9umV8pnonHc4qG+wyV47LgNPyE=;
        b=luy86l3Q6tr9NE36/PaWY/NMcy3vQDicAQDuobaG/T7kxch7KuZ8BVQ+wVi/vL9S6f
         kY3dQObPjIhNNCCUF+fzApWI0G6ehTqeAzN3LngL2hwTlbsP8Xj4RkODjGjD4FE84HBk
         CmhrMa40U75tpP4FC10rrbW8OBQK0xBmQgDhR7bDcO+mBlysOh5+1kZx0YHH3J1vqnvo
         zyQZaRe12+IkmBfektwQgUAerZJs84gM12s/JYFwVYiK8pjU/AByk0NcrVXzBivUThJD
         PDjMLFdLsf99KtU/w/gFGj+2a78jv7oCqpsn+31Z4z9OB228QG76QUCn6KD+bhBVKF0Y
         nbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684476921; x=1687068921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCYh8uS1PtNXF3LwY9umV8pnonHc4qG+wyV47LgNPyE=;
        b=UmjycmpV6M6jADR7UkCEcfigtL5017oe7VqXkkd06Woe2hSDJ+0mUgEIxLIW3C3SV5
         4GEW7xDJVBGdRAhDBRkgOJd48UU2Gu2VZxf0Q4NkpoGBOtopX+DXX3dpNOUc8BLWicCu
         eJkLvgvowjhxPZT6+/0LTZ9a5JkXXTGtwotWY0zGLa9WDfxQTkhc8icNeld9USMW5Ifl
         UfZhQM0X1XD6bjY9ROUhJ1cLjLfCOxv+/WgyEfueo/n3jaaIQqdO7ApxxMpOWGfaEN40
         PpnFAkwaNQRutKuvTQFR9p+R+WXrfMdJ/JPe37/taCzlgwYsyIW+apsQK8QrKw8n+vCQ
         3zsQ==
X-Gm-Message-State: AC+VfDwF26rjDFgHOGk4auwuubd9bH7byadSNig880QzB4UV05rkbLFa
	2xKTCnKpryw4DhPOEKh6Y/e8HawJYqjzH8uKeUQ=
X-Google-Smtp-Source: ACHHUZ4ZwhFo+c6dqH/926xcq+W9gpeBGHfa3x8yDrWM5NcnK/XK6011FVVufCnnN9UCun2EEVMjNw==
X-Received: by 2002:adf:e4c5:0:b0:305:e8db:37df with SMTP id v5-20020adfe4c5000000b00305e8db37dfmr762233wrm.22.1684476920736;
        Thu, 18 May 2023 23:15:20 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d18-20020adff852000000b002ca864b807csm4334055wrq.0.2023.05.18.23.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 23:15:19 -0700 (PDT)
Date: Fri, 19 May 2023 08:15:18 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Message-ID: <ZGcT9tx/xsKGVYBU@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com>
 <ZFJRIY1HM64gFo3a@nanopsycho>
 <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGMiE1ByArIr8ARB@nanopsycho>
 <DM6PR11MB4657F542DD71F61FD2A1C20B9B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657F542DD71F61FD2A1C20B9B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 18, 2023 at 06:06:03PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Tuesday, May 16, 2023 8:26 AM
>>
>>Tue, May 16, 2023 at 12:07:57AM CEST, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Wednesday, May 3, 2023 2:19 PM
>>>>
>>>>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>>>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[...]


>>>>>+			pins[i].pin = NULL;
>>>>>+			return -ENOMEM;
>>>>>+		}
>>>>>+		if (cgu) {
>>>>>+			ret = dpll_pin_register(pf->dplls.eec.dpll,
>>>>>+						pins[i].pin,
>>>>>+						ops, pf, NULL);
>>>>>+			if (ret)
>>>>>+				return ret;
>>>>>+			ret = dpll_pin_register(pf->dplls.pps.dpll,
>>>>>+						pins[i].pin,
>>>>>+						ops, pf, NULL);
>>>>>+			if (ret)
>>>>>+				return ret;
>>>>
>>>>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin, ..)
>>>>here.
>>>>
>>>
>>>No, in case of error, the caller releases everything
>>ice_dpll_release_all(..).
>>
>>
>>How does ice_dpll_release_all() where you failed? If you need to
>>unregister one or both or none? I know that in ice you have odd ways to
>>handle error paths in general, but this one clearly seems to be broken.
>>
>
>It doesn't have to, as release all would release all anyway.
>Leaving it for now.

So you call dpll_pin_unregister() even for the pin that was not
registered before? How is that even remotely correct?

Fix your error paths, please. I don't understand the resistance here :)

[...]

