Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E357501195
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 16:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbiDNOZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347546AbiDNN7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:59:17 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE4D3FDB9;
        Thu, 14 Apr 2022 06:49:59 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id p15so10168041ejc.7;
        Thu, 14 Apr 2022 06:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m8ZH1QRf9uASf5s5u8tzlTaBurC1zqHxJb4eLZNXq+o=;
        b=EKw2WT2fRZ8eAUATbrMlkvLp0o2PWkQ5Gp8swARA9czaMiZeyQjtQdkP7alZkbipzd
         KYmgc0VpZld0/sKAM2bnHC6tcBG2Gt3bsvXAzZlNxgwMsTrPR65dAZnhBrBxHKXrAMVF
         xM11dFd5G3kLz4+icGfdyc0UEkR4El7/cHdGoZ+aCXzUcOhCSEpme2Epp1x0tnCPqNw4
         pR62jXYdTcEF/ma3PE+W1ClT8v8yf02JQbR845Z/OARk+/ZRVQGvc8JyZbdejecefaQa
         0i1MDZJuHuzRaKUgDZG9kFad13ZvKvq85feFZA09Dov0mz/o69Mw+Qo5Zy2mkuoJoAr7
         VZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m8ZH1QRf9uASf5s5u8tzlTaBurC1zqHxJb4eLZNXq+o=;
        b=70D+V9LcGcOYKt1XfbGB1uECCiup0GwqM5CaNk94j+Rr3Rs8UG0O6fYuaIbhYqJbGp
         8nwNmt+g8wvvvMdvHTbuos4pWYjMs+CvGsaIaFsHURl/lXBdKoPcGDeomGcm/giqbjsv
         cuk+RlaOKvM+O8HWVWdpphxG4eGFMvgzVDoqxd5S3pojzbM3+Nj/GkFDqNLkZ+uPg+bf
         DyHFM3gHU0Iw5uCZFzMNe26gQ3GIY2+5pJD13yi4Avv43P/2YObIU1QyzklbTpLm3l+X
         keyl4yD9KFzQR1TBhWm7is5aSW4j6UjC40ZAshJO2VOEz2BuUL1QyftZPkvpSQ/99iXl
         O48Q==
X-Gm-Message-State: AOAM530lm1fJr2cDJe8KFuBt/x+0zG4GtUb8gzYYpG7fVCh2XMjcK0Sg
        fLPJb3Y3vqYNhNS2t3Ax/+s=
X-Google-Smtp-Source: ABdhPJwymHpwz981JROZTM4IVL1QGEXRI2JUEmGM/YRgxOJio8SDv+IFeogbALTvvy66ki9PjiY0iw==
X-Received: by 2002:a17:907:6d10:b0:6e8:8fbc:310c with SMTP id sa16-20020a1709076d1000b006e88fbc310cmr2370020ejc.530.1649944197594;
        Thu, 14 Apr 2022 06:49:57 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b004136c2c357csm1058710edt.70.2022.04.14.06.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 06:49:57 -0700 (PDT)
Date:   Thu, 14 Apr 2022 16:49:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 2/4] drivers: net: dsa: qca8k: drop port_sts
 from qca8k_priv
Message-ID: <20220414134955.rzt4bbeolpq6b4uo@skbuf>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
 <20220412173019.4189-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173019.4189-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 07:30:17PM +0200, Ansuel Smith wrote:
> Port_sts is a thing of the past for this driver. It was something
> present on the initial implementation of this driver and parts of the
> original struct were dropped over time. Using an array of int to store if
> a port is enabled or not to handle PM operation seems overkill. Switch
> and use a simple u8 to store the port status where each bit correspond
> to a port. (bit is set port is enabled, bit is not set, port is disabled)
> Also add some comments to better describe why we need to track port
> status.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
