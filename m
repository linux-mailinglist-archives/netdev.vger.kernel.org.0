Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEED66BEDFF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCQQXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCQQXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:23:37 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF80831BD7
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:23:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id p4so4956270wre.11
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679070215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CFTtTxvvW2TaL2/uZrd+qk+RLkOl91PVBRCzxuQjGWw=;
        b=GIhWGXJ5Knl0XVgoVWulLks9QMvK/u2eiLSx1DqrMfzZSv0/XPh4Zbat9/9WMfU7p0
         hW62ixZTKAg6wjaip8CLuMklarycB/B9sFdNhU9X3qw80il/YVHrnKimzpEeXeKDoQrm
         6YPgo8zYPkPObSphfQ/wCp72s+jrS6Q+bDo6jko+dK7JuEmukwHOi3TWXmmsmvkKiU+C
         2oDZkqQaJIG5TxX6kycQDH8i7ZYtTwoPNpBJVWHwBrv1nRnVsIwvx9Hfq4TCEG4ilL0r
         NCOkxPbi/axlNMzYVJx0O5b783LrGpIAtfQFdNenXDYcq4xeO/9kLzEvYct06uA12Sd1
         CRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFTtTxvvW2TaL2/uZrd+qk+RLkOl91PVBRCzxuQjGWw=;
        b=ZiVHqUEp9/UuPHEe3vSyyTwcTFJDiEkrKMiGfaYfIiq+nt7j8fIAZk10GNd8PAEmEF
         Ab/+IxZdYG67IB6nmKM1/qW9v5+iq/g6dUzsfHNUmVnh3iSz/yOBZrMCpYs00HFV5Clu
         OGQiilHVMqn0VK7nEQQuh5JR25y/7PrBmapuNmBbzrojKvQVuOr4WS7DgpaXp2eI2LZc
         qOgvet8uY4otLu62gyViewX5p+jKZqMHWulZsUJLOLquCNLfvlp1PsVuLFVoKw6N1RQA
         fo96153jfo9egi+yMpQh87Y6IVT+Iv2IfHicB8lfyP7ZIwVST0LAxho+i0CS1C18HIv2
         5NqQ==
X-Gm-Message-State: AO0yUKUhR95qsgEv02ItpRxZAD/Aq1jtYfl2IVoh5CQRtzJu+0tY9J/a
        guFVFxn0CzpKBqyf2LDxyqnw192eU2JCuT3JUK0=
X-Google-Smtp-Source: AK7set82AOZ21B+YPX2qFt9bjaX9ZLa16gktIkU6CDKG/dnIuXtZidLv7gQyW/PJP7iAUaN9/opdaA==
X-Received: by 2002:a5d:4908:0:b0:2cf:edf0:f8c with SMTP id x8-20020a5d4908000000b002cfedf00f8cmr6987957wrq.29.1679070215487;
        Fri, 17 Mar 2023 09:23:35 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k16-20020a5d6d50000000b002cff0e213ddsm2330005wri.14.2023.03.17.09.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 09:23:34 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:23:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZBSUBWUwC0FLlS/D@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-2-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:02AM CET, vadfed@meta.com wrote:
>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[...]

>+/* Ops table for dpll */
>+static const struct genl_split_ops dpll_nl_ops[6] = {

It's odd to see 6 here. Should by just []
But it's an issue of Jakub's generator.

[...]
