Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F4D4E74CE
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359181AbiCYOHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239973AbiCYOHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:07:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE92D8F66
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:06:01 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bi12so15630280ejb.3
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L0RwxpkpCXfOp34FE8Xe2aHcGprBogkUgnf1qu7vhKs=;
        b=kpESudql4xmy6O7fQtn1hTQbcSmcyQ/YsUIC+nS7bgTJcooizHM/+Mc3rmI2cBR9ES
         xFdiPi1d3+Pa+/FY0/miq5eBJqiCYszB0OV1EDsZbVZ1gbzM41NgZ4f+0ZLpfo546Jsc
         6R35wMsUFomXmphWy/yDiSMa4mxchdWJe/kc4+pjEBtT53MxEXOn2PeL9s5jyLLiCDsx
         D+t9vlBvYYamjhsizZYEV2ydpvzD4L7qsglI3Sj+pdXqC0PSwseeWTHjyPBA74J1o/9o
         ZCkK013zglTMIaKsQoCOS9Yrszvkm38KM9/71z4922SwPvcl/mCf9jmZ1SemmJTaY7OQ
         qj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L0RwxpkpCXfOp34FE8Xe2aHcGprBogkUgnf1qu7vhKs=;
        b=qHMrLqIJvTbGhL/NKjyOvZ+4OQl8eD+3hqj1A6baOf6ugdOHigYQPm9UPkcE3gDrgW
         YfKZ9LNRBc3G3cbXKQwLD8SaVgFd/KrXMqurrDTdWTqMO3rUPMSb5blfd+4VVfOxnvw2
         j4eaDHZLQTOSYh5mTpF4y4L+q2xV7dpQRoyhBcLjw2jCYkxcAe+haDjh9VtrVEVWVlzV
         PqKDx34xmGxeldi+Cy7EM/eIHDlHztCK8cuTrQ3PBQHFT501c27jXvaCEHXc46GpI7+3
         pNCCAyEYPG/P6Y4oUxV9jbvdKQFjMBwmobsTHeR6N2vnyknEjtm9RV7tu1bjK6fJWTFM
         P9SQ==
X-Gm-Message-State: AOAM533yfKoTJYnU5MmXFahRWGhLmR/ROCKkPuTC9ACC7DzxMNzI2SgA
        NM95NWyX6itCNnwHRBvlHoc=
X-Google-Smtp-Source: ABdhPJzR+IsqaqL1/wo2y7GbEyefFsPRtfvWt1XxnZw2Nc9vH2SbobBfub0bdLtr68f+cDdHoHkRiA==
X-Received: by 2002:a17:907:1c16:b0:6d7:622b:efea with SMTP id nc22-20020a1709071c1600b006d7622befeamr11616259ejc.110.1648217160256;
        Fri, 25 Mar 2022 07:06:00 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id o7-20020a17090608c700b006cef23cf158sm2382295eje.175.2022.03.25.07.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 07:05:59 -0700 (PDT)
Date:   Fri, 25 Mar 2022 16:05:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Broken SOF_TIMESTAMPING_OPT_ID in linux-4.19.y and earlier
 stable branches
Message-ID: <20220325140558.qdxl25ggqhpztbjh@skbuf>
References: <20220324213954.3ln7kvl5utadnux6@skbuf>
 <CA+FuTSe9hXG1x0-8e1P8_JmckOFaCFujZbJ=-=WTJW3y1sJQNQ@mail.gmail.com>
 <20220325133722.sicgl3kr5ectveix@skbuf>
 <CA+FuTSeJCZ1F3b9rrLpdcp6sbok8OXBA40jSmtxbJ7cnQayr+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeJCZ1F3b9rrLpdcp6sbok8OXBA40jSmtxbJ7cnQayr+w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 09:48:41AM -0400, Willem de Bruijn wrote:
> > Do you have any particular concerns about sending this patch to the
> > linux-stable branches for 4.19, 4.14 and 4.9? From https://www.kernel.org/
> > I see those are the only stable branches left.
> 
> The second patch does not apply cleanly to 4.14.y and even the first
> (one-liner) has a conflict on 4.9.y.
> 
> It would be good to verify by running the expanded
> tools/testing/selftests/net/txtimestamp.c against the patched kernels
> first. That should serve as a good test whether the feature works on a
> kernel, re: that previous point.
> 
> If you want to test and send the 4.19.y patch, please go ahead. Or I
> can do it, but it will take some time.

I think I do have a setup where I can test all 3 stable kernels.
I'll see if I can backport the SO_TIMESTAMPING fixes to them and
validate using the kernel selftest and my app. If I'm successful,
I'll attach the patchsets here for you to review, then send to stable if
you're okay, would that work?
