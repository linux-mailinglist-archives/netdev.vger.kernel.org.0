Return-Path: <netdev+bounces-2877-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6890370461D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 301CA1C20D3C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033741C773;
	Tue, 16 May 2023 07:17:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61AA156E9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:17:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD20A1703
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 00:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684221432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lhuSrwd9fgN2JCGIYbu47UG4UUxhirjw8ksWArcDvyM=;
	b=JMrHWsiFVbM6EIv5J7RSKhRlBsaNPe+RN1S2HAc5/UUaxHHd+pYunAdkd3skpQAxHkxoE0
	gVR11ENanKL9qyt1bTdx5QqIRPxWhkroHfR08zdT2moQNcxPKEgWTw1BRT1TRwb30ba1/u
	twmRahwqSe2dbIWpVjGgIrUNNdV2R/k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-uqhyouBjNSir8oG-H92WTQ-1; Tue, 16 May 2023 03:17:11 -0400
X-MC-Unique: uqhyouBjNSir8oG-H92WTQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f508c2b301so2783665e9.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 00:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221430; x=1686813430;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lhuSrwd9fgN2JCGIYbu47UG4UUxhirjw8ksWArcDvyM=;
        b=lpl2Ew2zKTto0j3uXWgc3RlpZl/u74p5sgJah38QLxVBzxPeRuwHt/NG1apBsW5EMe
         hN/kG+hPsiOLaeMVWAXEAhqymhbH6LqXErMyg9BkrLXxo+fikYLceUZ8HBhCkOEFE/mH
         t4N8b8YgSit9EZtpSsUvJYLGP6IsSrRODwALhaqlf2D8FXo/rIWsvqnWqAhBNy+qztkp
         ALY1tjN+h0+RW0bZZae3KwUefwmlmpoM5UBMgvaFmU0g8fxTBmp1Qi+At2JjpoDi+DFI
         M08B3KJy+ZuTUd4HGJk8qFsWkquqPDXh8XZTPMakqjv2bewonHhKimndh5KO5X7LLt0P
         PlQw==
X-Gm-Message-State: AC+VfDxFMf/n0sXqLNWA4fJkOWGZjek8E7Zix7orCDOmt38incyeaEdj
	nrj7jwY1Iys0crXrPy0jghLN+4WvoDPBalgpeNNygqKdZ5Y6zpDUgdphBMBNxKCkbJwMO3cRXm8
	ujWuieSN5lUg9pH09
X-Received: by 2002:a1c:7319:0:b0:3f4:e86b:798 with SMTP id d25-20020a1c7319000000b003f4e86b0798mr1688864wmb.1.1684221430501;
        Tue, 16 May 2023 00:17:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6HzhNEoB7+RJp5aRv8QSWui09/dclQsgOPQMK3YAPqH47hSvw0jUumKqlLGJC/WlClcF4fow==
X-Received: by 2002:a1c:7319:0:b0:3f4:e86b:798 with SMTP id d25-20020a1c7319000000b003f4e86b0798mr1688842wmb.1.1684221430173;
        Tue, 16 May 2023 00:17:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id t22-20020a7bc3d6000000b003f427cba193sm1208635wmj.41.2023.05.16.00.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:17:09 -0700 (PDT)
Message-ID: <d84a75724637a58d25ecbc35316b6b11a979e923.camel@redhat.com>
Subject: Re: [PATCH net-next 4/7] net: lan966x: Add support for offloading
 dscp table
From: Paolo Abeni <pabeni@redhat.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	UNGLinuxDriver@microchip.com
Date: Tue, 16 May 2023 09:17:08 +0200
In-Reply-To: <20230514201029.1867738-5-horatiu.vultur@microchip.com>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
	 <20230514201029.1867738-5-horatiu.vultur@microchip.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 2023-05-14 at 22:10 +0200, Horatiu Vultur wrote:
> @@ -117,12 +164,16 @@ static int lan966x_dcb_ieee_setapp(struct net_devic=
e *dev, struct dcb_app *app)
>  	if (prio) {
>  		app_itr =3D *app;
>  		app_itr .priority =3D prio;
> -		dcb_ieee_delapp(dev, &app_itr);
> +		lan966x_dcb_ieee_delapp(dev, &app_itr);
>  	}
> =20
> -	err =3D dcb_ieee_setapp(dev, app);
> +	if (app->selector =3D=3D IEEE_8021QAZ_APP_SEL_DSCP)
> +		err =3D lan966x_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_setapp);
> +	else
> +		err =3D dcb_ieee_setapp(dev, app);
> +
>  	if (err)
> -		goto out;
> +		return err;

As Piotr suggested, please drop the out: label altogether, replacing
even the other 'goto out;' statement with a plain return. Additionally
you can replace the final:

	return err;

in this function with:

	return 0;

Thanks,

Paolo


