Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486B76DAF7B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjDGPPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjDGPOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:14:44 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B914C31;
        Fri,  7 Apr 2023 08:14:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g18so9055000ejx.7;
        Fri, 07 Apr 2023 08:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680880479; x=1683472479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XOp6B3Yrf8/IElRYh7BCFuo52ng4eeD3hfWMY8BurBw=;
        b=KhP0mxxllubIFX67GhecQYjfyspDjUfp6IGTgoo79QDraja9BpDHQSa4uh7byHUtmt
         fPOc0hSsv7wxiQV0ClZIm7eRLXBwuZT06gl8DWPT4+Gaytm1HPWNK9fVzPinrQvmCox6
         6vK7z+Xy42hOj0dp5EBSV9jzh2MCcsr8do92Nx5Yws6dIU7Db+N7/gQiqhw05m26i35w
         U+XGz4r3kIejOc+BY+2x3pXaWJaYqicTotHJaSiPCdya2j0oqI1knX59uBKNnFAkSumC
         HhuAhH3Ye7glX/+jacAIrrLjAlEXInSOSnJgnmT4RHs7V60sVeytdJOPF64oEVB3xTM8
         k2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680880479; x=1683472479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOp6B3Yrf8/IElRYh7BCFuo52ng4eeD3hfWMY8BurBw=;
        b=WJSWLdIFr9mqtZ5RsYqkynULv7u3lbe4gnuqgaY2h0uRzZjFRMZCrm/a3iosMRq8jO
         mVF4Ir9uWDw59FK8pwTedKNxQTNI7SUJ+cRRfRnAR/s+dbSTj/Q0FXfnQ+b0RV2zSwcS
         G8hjD6T8r2i8as8ydisTJLplNmNzdLff2b0mdpz7rMWDTbJw8TjlTLG/Eoasgc1sIw29
         +JuVMMW9+ROwYE9osfPEvoHN1bjzNywIvHKf86KSf6oZBH548zzto/fMu82nbDzvwSn4
         bJj3lQMzOJTs37oA6MeRK63HlPwYJrsmEottBMSFwlfV1mDw9cRCpTQYxI6mH4+jpzmB
         RScQ==
X-Gm-Message-State: AAQBX9fRQ15RsuXwgigjpYz+p2NYeMI4nyCVnBTaUohJAA7OlgTfiSBH
        BLAkEx+hxM0VDpEI6syau3wt0x5uejA=
X-Google-Smtp-Source: AKy350Zxpfd+mV+JpvOVmcht89hMk1sTTTvhCBkHEhx4IGZ5AZpcPGVlidvuc7lfat2Fgf7K8uwKXA==
X-Received: by 2002:a17:906:348f:b0:884:3707:bd83 with SMTP id g15-20020a170906348f00b008843707bd83mr2502133ejb.69.1680880479123;
        Fri, 07 Apr 2023 08:14:39 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q13-20020a50cc8d000000b004fbdfbb5acesm1989686edi.89.2023.04.07.08.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 08:14:38 -0700 (PDT)
Date:   Fri, 7 Apr 2023 18:14:33 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ax25: exit linked-list searches earlier
Message-ID: <5d555fd8-0c9b-4460-9adf-9f8c2076f39a@kili.mountain>
References: <20230407142042.11901-1-peter@n8pjl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407142042.11901-1-peter@n8pjl.ca>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 10:20:42AM -0400, Peter Lafreniere wrote:
> diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
> index b7c4d656a94b..ed2cab200589 100644
> --- a/net/ax25/ax25_route.c
> +++ b/net/ax25/ax25_route.c
> @@ -364,6 +364,9 @@ ax25_route *ax25_get_route(ax25_address *addr, struct net_device *dev)
>  			if (ax25cmp(&ax25_rt->callsign, &null_ax25_address) == 0 && ax25_rt->dev == dev)
>  				ax25_def_rt = ax25_rt;
>  		}
> +
> +		if (ax25_spe_rt != NULL)
> +			break;

Better to just return directly.

diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index b7c4d656a94b..a8a3ab8c92f6 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -364,13 +364,12 @@ ax25_route *ax25_get_route(ax25_address *addr, struct net_device *dev)
 			if (ax25cmp(&ax25_rt->callsign, &null_ax25_address) == 0 && ax25_rt->dev == dev)
 				ax25_def_rt = ax25_rt;
 		}
-	}
 
-	ax25_rt = ax25_def_rt;
-	if (ax25_spe_rt != NULL)
-		ax25_rt = ax25_spe_rt;
+		if (ax25_spe_rt)
+			return ax25_spe_rt;
+	}
 
-	return ax25_rt;
+	return ax25_def_rt;
 }
 
 /*
