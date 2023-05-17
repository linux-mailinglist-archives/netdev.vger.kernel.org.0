Return-Path: <netdev+bounces-3268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7737064FD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C50E1C20BEB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2517D156DF;
	Wed, 17 May 2023 10:18:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167115258
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:18:44 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFA635B5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:18:40 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f41d087b3bso6237525e9.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684318719; x=1686910719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sh6TUytTx8wxEeH05oUpSXv6G2yuZqNrzgF6N7Kf/JE=;
        b=zCe8LxzUKmyqw6vOO9CGBnHOQlVUnRVuNRoTfZ+57IrX+pAxQArgqo5yLGdGZT4i1T
         8mPj2Jy4pjxdx1shCpWJZrBa+PxUOOufGz4FOs/5GO035D+guuPpq4q62NC0Q458d6b3
         AedB8pwzHc10YUnrtba6YW5HBAp9QKEFanoFO5QavAJbL11bDlWMXTQbc0BT7ZpSs9vY
         HE7sbsLMtEbdT674wlHtmpR8SpucMzOMS90hXpbA0OTGbDdhtsOXTPVL/PEp9Z+wIXXq
         XaNFy3PfbNd9ttUYXVgnwM+l0J/mLDXIzMr+QTE+pc8S0ovoLUb4kEruf4z5EUFPiu0X
         43Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684318719; x=1686910719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sh6TUytTx8wxEeH05oUpSXv6G2yuZqNrzgF6N7Kf/JE=;
        b=XrmE5dE4o63Ui1Ae2DnDw0aIqs90mXMao/5nyHZCX8X8v95BANxmsPfyoR83khoNJc
         1huJai+htGQ38+2bqzXQCWUtG9kJgyo8T/ajnVQNkDC1dO8pocG/cX5Zb1NrzaJZ6Ks2
         GFO1cL5spfN0BwGHDR3ez62bNA+4kSdr11adHRIJ9f/GJSk5sk9idvjt+JcTlXkoWibK
         WK9GADJ92L29HiAwNGghNMwHwBzurKokI8o5iyk6OKld6fdn2n6fXsWdVrzX0uAJ2iqA
         +0CzC2j1lYEy2TosWAoB8rV0/6EbxlqOqBx0yXKGuZzo0mxGh/YW+MggelAozXthECN5
         3xBw==
X-Gm-Message-State: AC+VfDxhWvICmwuusnWCGLCWUShEW6rst17+sqoik2b+8j2f3RJH3H7/
	fUviXgtW7c/g6FbqpsJD4/G6HQ==
X-Google-Smtp-Source: ACHHUZ4UlQsr2kc2g5MqE1OgdmK2YuPWRilWxI/M6/tgf2zjPIaxmYm87qqMrU+Uw79xVyRVicyNIA==
X-Received: by 2002:a05:600c:ac6:b0:3f4:2770:f7e9 with SMTP id c6-20020a05600c0ac600b003f42770f7e9mr20925393wmr.17.1684318719016;
        Wed, 17 May 2023 03:18:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d67ca000000b0030796e103a1sm2511144wrw.5.2023.05.17.03.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 03:18:38 -0700 (PDT)
Date: Wed, 17 May 2023 12:18:37 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 0/8] Create common DPLL configuration API
Message-ID: <ZGSp/XRLExRqOKQs@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-1-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Let me summarize the outcome of the discussion between me and Jakub
regarding attributes, handles and ID lookups in the RFCv7 thread:

--------------------------------------------------------------
** Needed changes for RFCv8 **

1) No scoped indexes.
   The indexes passed from driver to dpll core during call of:
        dpll_device_get() - device_idx
        dpll_pin_get() - pin_idx
   should be for INTERNAL kernel use only and NOT EXPOSED over uapi.
   Therefore following attributes need to be removed:
   DPLL_A_PIN_IDX
   DPLL_A_PIN_PARENT_IDX

2) For device, the handle will be DPLL_A_ID == dpll->id.
   This will be the only handle for device for every
   device related GET, SET command and every device related notification.
   Note: this ID is not deterministing and may be different depending on
   order of device probes etc.

3) For pin, the handle will be DPLL_A_PIN_ID == pin->id
   This will be the only handle for pin for every
   pin related GET, SET command and every pin related notification.
   Note: this ID is not deterministing and may be different depending on
   order of device probes etc.

4) Remove attribute:
   DPLL_A_PIN_LABEL
   and replace it with:
   DPLL_A_PIN_PANEL_LABEL (string)
   DPLL_A_PIN_XXX (string)
   where XXX is a label type, like for example:
     DPLL_A_PIN_BOARD_LABEL
     DPLL_A_PIN_BOARD_TRACE
     DPLL_A_PIN_PACKAGE_PIN

5) Make sure you expose following attributes for every device and
   pin GET/DUMP command reply message:
   DPLL_A_MODULE_NAME
   DPLL_A_CLOCK_ID

6) Remove attributes:
   DPLL_A_DEV_NAME
   DPLL_A_BUS_NAME
   as they no longer have any value and do no make sense (even in RFCv7)


--------------------------------------------------------------
** Lookup commands **

Basically these would allow user to query DEVICE_ID and PIN_ID
according to provided atributes (see examples below).

These would be from my perspective optional for this patchsets.
I believe we can do it as follow-up if needed. For example for mlx5
I don't have usecase for it, since I can consistently get PIN_ID
using RT netlink for given netdev. But I can imagine that for non-SyncE
dpll driver this would make sense to have.

1) Introduce CMD_GET_ID - query the kernel for a dpll device
                          specified by given attrs
   Example:
   -> DPLL_A_MODULE_NAME
      DPLL_A_CLOCK_ID
      DPLL_A_TYPE
   <- DPLL_A_ID
   Example:
   -> DPLL_A_MODULE_NAME
      DPLL_A_CLOCK_ID
   <- DPLL_A_ID
   Example:
   -> DPLL_A_MODULE_NAME
   <- -EINVAL (Extack: "multiple devices matched")

   If user passes a subset of attrs which would not result in
   a single match, kernel returns -EINVAL and proper extack message.

2) Introduce CMD_GET_PIN_ID - query the kernel for a dpll pin
                              specified by given attrs
   Example:
   -> DPLL_A_MODULE_NAME
      DPLL_A_CLOCK_ID
      DPLL_A_PIN_TYPE
      DPLL_A_PIN_PANEL_LABEL
   <- DPLL_A_PIN_ID
   Example:
   -> DPLL_A_MODULE_NAME
      DPLL_A_CLOCK_ID
   <- DPLL_A_PIN_ID    (There was only one pin for given module/clock_id)
   Example:
   -> DPLL_A_MODULE_NAME
      DPLL_A_CLOCK_ID
   <- -EINVAL (Extack: "multiple pins matched")

   If user passes a subset of attrs which would not result in
   a single match, kernel returns -EINVAL and proper extack message.

