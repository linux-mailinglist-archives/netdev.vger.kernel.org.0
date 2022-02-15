Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5D4B7AB1
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244218AbiBOWtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:49:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243497AbiBOWtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:49:20 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1A8D4C84
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:49:05 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso4620038pjt.4
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YX/HT7gPaKWr0sE+LX/uodwT5+ro27QMyTVCAvr+soA=;
        b=p5s/2c0a9WCzAB9RshvS6TstODtXtvuceSVMYfyMudMBbt5mo7Mn7TV9K62fSw94Yw
         KS3kaqkbEqdiX570pTm06tXVhFmH9rjpdl5HqgaeShUFWYpAviJmJFR/Of13abiIJ21H
         0CRfJI9VTR8eFgISpFimswkZUJQvAcA4SyQ9ap3mbk82SnsEUwgIaegoTj/2xncvtUjP
         QoGUpoS2IUnH8LM1FlCcvgLMcPPTkob+wO+95ioUIyNaAXFj2f2dhpxGNiYCBKMc44Vy
         IuBR9ULiuDjxUGp09jc9vMQOu6REeQGXdgNk9aSe2UM7VJNKZzzXE+ti/sf8GlteUHIA
         TLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YX/HT7gPaKWr0sE+LX/uodwT5+ro27QMyTVCAvr+soA=;
        b=LuaTjMMAq9r1DywRdYpD2T85BJhjAfmRkYw2KefzN0u8dCDn+zvRVdGa25QKaOuhrt
         c1qPItOJooLnSRrzcrth/ygUl0pPfLH9Aib7Qc8808Og2pMV+Um7hqjegMmoZy2Jxnjc
         ZuY3G87o+zWZZwN4ALFWFSo5nTxALBgGfkcirr4wlisYeDTAicTMj41ZyPMuE3r0dgmf
         93loZnszKrwRteWmpcbx4uZ8jSuZinOA6bIIvrBzJvrraCH18hsrvfkOf9TgIwq9cTjn
         maJAOKL7M/DmE3NZbO3maEEPNsyvZIaLokPXsQsSc4n5l2GgqYgyGLo5EXAkvdENRDaw
         9A5w==
X-Gm-Message-State: AOAM531ZiRyBj5P65k5H4haRQwx9m6UyB3MKhOwamKnYOM+oz2IcUpGm
        FYMbixCYNLPcDc6eqaTWUth8bzdTe/WwiwB3
X-Google-Smtp-Source: ABdhPJxiVRWSt+FLeTB+BTgjTSQsjXXgKKRxeFUjaTWsFAo//tONYnZpS0v87CZsxChaufttZOSFdg==
X-Received: by 2002:a17:902:d3c6:: with SMTP id w6mr1281085plb.4.1644965344985;
        Tue, 15 Feb 2022 14:49:04 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l22sm43403085pfc.191.2022.02.15.14.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:49:04 -0800 (PST)
Date:   Tue, 15 Feb 2022 14:49:01 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] lnstat: fix strdup leak in -w argument parsing
Message-ID: <20220215144901.1ba007a1@hermes.local>
In-Reply-To: <9766312d-58ae-4219-036e-73a587de1111@gmail.com>
References: <9766312d-58ae-4219-036e-73a587de1111@gmail.com>
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

On Tue, 15 Feb 2022 23:53:47 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> 'tmp' string is used for safe tokenizing, but it is not required after
> getting all the widths in -w option. As 'tmp' string is obtained by strdup
> call, the caller has to deallocate it to avoid memory leak.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>

Would strdupa() be cleaner/simpler. I have no strong preference.
