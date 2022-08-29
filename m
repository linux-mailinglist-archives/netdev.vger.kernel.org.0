Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC55D5A4F86
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiH2Opt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 10:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiH2Opr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 10:45:47 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F6C6D9DE
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 07:45:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fa2so546006pjb.2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 07:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=4xhbSfHIXEPpf3NUOrBx0xYugYcJ2zCzAv3+pcEuG3g=;
        b=mVLiW3JUDKo6cNq2W5ydy9QeZv8sHwFjKizrU9azMqAGUG5tdii5MWPxigIfERSj6h
         fVDCrzTGKhktBrUoXqVal/KKvn9qIy+w12iVYknjbpizTdxMIrdqEJz5JLW5R1vLCybS
         4C6J3iK0A/Jy8w3cXuZUV7Shu0LfagaPgBOFRicF7uvsqVuoePLyqNbnKEKUXUqJpO75
         j12J2mIwn8ofvNb4r6C5MDl7Qu/F/QUokiAmj5iNCXiC4eoywjKdWf8xdd3bblizq3SY
         hXlM/xligjoIymvCVEdw3a+LltHam8Sqv17YJxgYynxST6FupScanH5xnM4e9EXufa+1
         0D2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=4xhbSfHIXEPpf3NUOrBx0xYugYcJ2zCzAv3+pcEuG3g=;
        b=L9OAu70kG/1fbXjMdjJd72OyWtrlv4chYAIes3Da+TXwLT4cAnoZbxwGmsPFVel8QM
         44QdpHnqrA2YhbwL95W7w8NqvXguXR9iFu+KDCShq45ZrIuT/nCIB6UzYLLWxEhVfGH0
         18D3vuLNYMHilUJShsbfaUptDEFecG/Yg1N1Cfw/MzpD5D4/GryFW6m4jh+ldm4iuaWy
         4T1swwJpyuTSWq2AKyTFK6owag81hz7yaKnjGx2PIlqUTJh9Al8CrHj/K5AQQOwGPbk5
         EMMaVmedmthCqSSihACjjzESpZzD42BaX33ZQTEDWTKanaMVzFK5aAn4Wq7ZdhUmASvr
         flkg==
X-Gm-Message-State: ACgBeo1V5a7ahsKRQ9BOd7xYiRsoNgpAR+5bi0wgY8T9jxjoDACEhqLx
        wLcbqFPYiTeLTSmgCMQtIp8=
X-Google-Smtp-Source: AA6agR62Xcbfce2H1VrVRRghwpfoz3u/HlykG7QiVnUkm/zfvuIj9BWxwwIDxxj8lACzs9QTVwCLrg==
X-Received: by 2002:a17:90b:4a48:b0:1fd:df0a:eac1 with SMTP id lb8-20020a17090b4a4800b001fddf0aeac1mr3781147pjb.161.1661784345821;
        Mon, 29 Aug 2022 07:45:45 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902ea0300b00174c5fb500dsm2619813plg.116.2022.08.29.07.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 07:45:45 -0700 (PDT)
Date:   Mon, 29 Aug 2022 07:45:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] net: fec: Use unlocked timecounter reads for saving state
Message-ID: <YwzRF1B3R8GuZR1K@hoboy.vegasvil.org>
References: <20220829114039.56195-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220829114039.56195-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 01:40:41PM +0200, Csókás Bence wrote:
> `fec_ptp_save_state()` may be called from an atomic context,
> which makes `fec_ptp_gettime()` unable to acquire a mutex.
> Using the lower-level timecounter ops remedies the problem.
> 
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Fixes: f79959220fa5

> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index 78fb8818d168..fdd22c6ca909 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -636,7 +636,7 @@ void fec_ptp_save_state(struct fec_enet_private *fep)
>  {
>  	u32 atime_inc_corr;
>  
> -	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
> +	fep->ptp_saved_state.ns_phc = timecounter_read(&fep->tc);

The function, fec_ptp_read, does RMW register access and thus needs
protection against concurrent callers.

So you can't simply avoid mutex acquisition to fix the splat.

Thanks,
Richard
