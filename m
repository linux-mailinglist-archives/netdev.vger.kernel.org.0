Return-Path: <netdev+bounces-9544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B91729B59
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38EF31C210E0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D76174D8;
	Fri,  9 Jun 2023 13:18:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C8174CC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:18:17 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401A830D2
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 06:18:16 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30fa23e106bso345809f8f.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 06:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686316694; x=1688908694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgJZVog4QId8J7JaC0naUd6FnkaXXLTRPTgD1N+SRw8=;
        b=AZUurjpf72+T14kiStwV5o9YWM8M1QeNhoASj9V+a4aq+TthkHWeZ4LSAy3ddbBzF/
         yNo/JP5VJmrUCxErZi4CTSTJPAdF0/EHuwXfoaFIfUvhkUUskWTqHo+epj+q/1g6IWfZ
         8gLSU50NZxIJoXEvFNONaKcPf1mkslm2p0B4ZuVp4U98uMvPxiZV/uV3uOk0sPQzEvOR
         DsC7J1d4Xd9UML7hnEGCc1ARoV/RCa417uVeG+aA+cG7liKZlIPoDK5biFYydelGPTQW
         bBw9FQrH/r89oT/IxTquuUA76iyKubgw79vWq2Fra3Y7/irJtiXB5shX5p66xL+kqcw1
         iGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686316694; x=1688908694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgJZVog4QId8J7JaC0naUd6FnkaXXLTRPTgD1N+SRw8=;
        b=YF5fDE/XVizb8NGALEEobjcueAfAxcdA10O6W98uPwhhjUCtmjIo3G3LBG+eiNYTyw
         QTiH54DvRgC/eFrNSbiSb79s5nHJd1VdKIZ5SZwHZ+VYeJv2cj9mW8y8MC3UllfHbN5m
         gYO/W/aI2/IrkbqhGN8ow4iRRASTQIyN0EjHbvjSyRqQojBcnbPsD3ms7JE0u3mchOpI
         dZhsrbn+aaVldw8ogNn1Qzx1PIKXqX2/eXs50KLRiEWn8eetcmdfGM15eJsWrFKwXM+U
         0+YyC36/WUa7I318QY/Tz8kqlIoqg/ot5C2gLT3NqUt7x2Nmvmbuhi5IOsoVQr58oKNC
         7rOg==
X-Gm-Message-State: AC+VfDyjIc0k2SS5RO08zQHXV0u3lzZNh3o4mxJHL83M6Txct11gkSam
	dyK2+5AUYLwe0K7il0+uGFDjHg==
X-Google-Smtp-Source: ACHHUZ4ywMdZHZ56LMGYH+4/KpYZ25kc85qDDM6ZC48F8rBycFCPBFhYHAfQYbzl4+AVAw9cyQWQbQ==
X-Received: by 2002:a5d:51c6:0:b0:309:33c4:52e1 with SMTP id n6-20020a5d51c6000000b0030933c452e1mr772596wrv.64.1686316694583;
        Fri, 09 Jun 2023 06:18:14 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m6-20020a5d6246000000b0030e52d4c1bcsm4511387wrv.71.2023.06.09.06.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 06:18:13 -0700 (PDT)
Date: Fri, 9 Jun 2023 16:18:08 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Sai Krishna <saikrishnag@marvell.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, sgoutham@marvell.com,
	maciej.fijalkowski@intel.com,
	Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net PATCH v2] octeontx2-af: Move validation of ptp pointer
 before its usage
Message-ID: <880d628e-18bf-44a1-a55f-ffbe1777dd2b@kadam.mountain>
References: <20230609115806.2625564-1-saikrishnag@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609115806.2625564-1-saikrishnag@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 05:28:06PM +0530, Sai Krishna wrote:
> @@ -428,7 +427,7 @@ static int ptp_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  error_free:
> -	devm_kfree(dev, ptp);
> +	kfree(ptp);

Yeah.  It's strange any time we call devm_kfree()...  So there is
something here which I have not understood.

>  
>  error:
>  	/* For `ptp_get()` we need to differentiate between the case

This probe function is super weird how it returns success on the failure
path.  One concern, I had initially was that if anything returns
-EPROBE_DEFER then we cannot recover.  That's not possible in the
current code, but it makes me itch...  But here is a different crash.

drivers/net/ethernet/marvell/octeontx2/af/ptp.c
   432  error:
   433          /* For `ptp_get()` we need to differentiate between the case
   434           * when the core has not tried to probe this device and the case when
   435           * the probe failed.  In the later case we pretend that the
   436           * initialization was successful and keep the error in
   437           * `dev->driver_data`.
   438           */
   439          pci_set_drvdata(pdev, ERR_PTR(err));
   440          if (!first_ptp_block)
   441                  first_ptp_block = ERR_PTR(err);

first_ptp_block is NULL for unprobed, an error pointer for probe
failure, or valid pointer.

   442  
   443          return 0;
   444  }

drivers/net/ethernet/marvell/octeontx2/af/ptp.c
   201  struct ptp *ptp_get(void)
   202  {
   203          struct ptp *ptp = first_ptp_block;
                            ^^^^^^^^^^^^^^^^^^^^^^

   204  
   205          /* Check PTP block is present in hardware */
   206          if (!pci_dev_present(ptp_id_table))
   207                  return ERR_PTR(-ENODEV);
   208          /* Check driver is bound to PTP block */
   209          if (!ptp)
   210                  ptp = ERR_PTR(-EPROBE_DEFER);
   211          else
   212                  pci_dev_get(ptp->pdev);
                                    ^^^^^^^^^
if first_ptp_block is an error pointer this will Oops.

   213  
   214          return ptp;
   215  }

regards,
dan carpenter

