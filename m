Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7D5B3B75
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiIIPGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiIIPGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:06:35 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9347F13BC68
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 08:06:33 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 202so1824252pgc.8
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 08:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=h9ttlWCtYtVis0YY0hxzMY2qjTiD1pFXm2BQf608hzc=;
        b=rJIVxZ9Jiyp9GZBMH7ltmn4ILM2XybGYMZrHq+cdRoQuteAuW5Gr9DPFCsvMAtHZO2
         40Hnyne+KIB6cymtP7qrv3+KSHQqkM1h03oKOH/fHt/7/tGXKxxcnh4QrBqHh7L8XqzK
         G46ksDEoWISDdrPLzO87/GHM7SY/1URmNLTFL84Z87hMUdsxbBe5CWWCGKSC8/zRGkCO
         KxV9kppAvsCBbyPwDzSnuEvjtAcJ3y9MOFtbf8zgAHHzcCtASUlrnE8upV4+XaWnokuV
         m2VBYnRksguKN3MAra1PR5YI/7kwdDx5ZUsryrri5+8jvFE3Iutszw7KZDoYBbDaAu2i
         nV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=h9ttlWCtYtVis0YY0hxzMY2qjTiD1pFXm2BQf608hzc=;
        b=e2ms2lk+O1HtFbClA++k8PtsBOmQTqBPfDDBVnWPPAgYLbxBvtfF54ow5yqxm4LcZx
         HDlSvCJGAYurtVe0QqB6GLcc5BWJwzj8S8I6UO6oiUef+u6kbwfdzx9q+QCHirlLC45C
         G5Tg8plnwoHsHTei+qtBYh01a9QX+j0oOIHLlGZPlDhlGVOfyj0dlSG0NbjPPkCRTkXd
         rAnG7PsGw1tPUarI+wtq6B/WpzkRehqeuS8Lz8ij1Tx7CCgSp/HtNYERqvGKQIFF3tHA
         Va50488EAXr/2Qd7HZbTxrSu1ov9whuirdc9/M4vy61aHXvwC+IdpKketnsACgxp7C54
         WYXw==
X-Gm-Message-State: ACgBeo2BJ/u4ZnYUt1x98GrgxYvK7FEEGBPcHhKNTOSrk563wD4ed4PO
        C0dOddGxNUON2T8Kt9FRSpPyJw==
X-Google-Smtp-Source: AA6agR7sgH6dWxMQC1VO0bnY43VSvZArcC95HKpEjuEZ6GCaCv3csEQK1IC5+5mLsM73hylnAMI3SQ==
X-Received: by 2002:a63:5747:0:b0:434:8606:b0a4 with SMTP id h7-20020a635747000000b004348606b0a4mr12246600pgm.529.1662735992788;
        Fri, 09 Sep 2022 08:06:32 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902f54700b001749381ed8csm559310plf.254.2022.09.09.08.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 08:06:32 -0700 (PDT)
Date:   Fri, 9 Sep 2022 08:06:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <petrm@nvidia.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH iproute2-next 2/2] dcb: add new subcommand for
 apptrust object
Message-ID: <20220909080631.6941a770@hermes.local>
In-Reply-To: <20220909103701.468717-3-daniel.machon@microchip.com>
References: <20220909103701.468717-1-daniel.machon@microchip.com>
        <20220909103701.468717-3-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Sep 2022 12:37:01 +0200
Daniel Machon <daniel.machon@microchip.com> wrote:

>  	} else if (matches(*argv, "app") == 0) {
>  		return dcb_cmd_app(dcb, argc - 1, argv + 1);
> +	} else if (matches(*argv, "apptrust") == 0) {
> +		return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
>  	} else if (matches(*argv, "buffer") == 0) {

Yet another example of why matches() is bad.

Perhaps this should be named trust instead of apptrust.
