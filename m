Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D790F516DC7
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384941AbiEBKAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 06:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384996AbiEBKAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 06:00:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 005392BB
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 02:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651485317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HTXZXrnDGxrjWA2WcNj3KGW8l5BvXy7g7QP22bmMR7c=;
        b=UCTk1KXiUiBrgX1Jsa4jfsxuSb+Vl8ZVnj7Jy8YE+DVrv/ICfIf6i3+cldxIKr9S+LbNAq
        jZyVh5NBfAmInWx4o4oyfxIlQJR0fWlwaf/hgjQxSHYrRYcjIcYNYHpODVjYVIrSQ1sBIC
        oC7Wu1CNErrEcRAInDCAAYLVXTjTQtA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-qKPVVpRlMEKGyCXuApBJjg-1; Mon, 02 May 2022 05:55:16 -0400
X-MC-Unique: qKPVVpRlMEKGyCXuApBJjg-1
Received: by mail-wr1-f71.google.com with SMTP id e21-20020adfa455000000b0020ae075cf35so5187884wra.11
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 02:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HTXZXrnDGxrjWA2WcNj3KGW8l5BvXy7g7QP22bmMR7c=;
        b=qPyceJWE1fZ8bLk71hXQvFKTQJ9BJf6hV87ELTJ1TYevBgyHEN+ttYdUyX2XaNCCl1
         DaN4OhUT/J1rjnS079xui1j7JzMO3CWWa8fzbg3Y6xgxnK2Ng+XQdaXA8dyZddmJrty/
         bxPWBgR7azqerqRpTli/W41GG17zJeX4Hl6jaUKKqydIm6B1DTU4J4w4AGJ3EXENLf+C
         ekK5rpc0FDxv6Gvb+lVh2pWP10J2FuScqIBgdcmhVlSVyl0qKccb7d1zYuEMUrfNpLuM
         35ty70TfVnxAH2A1l1djpxAVI3vL2xegSbkmSN34+H5JZYKMMpmWobsxfK920vhAc6L3
         Guqw==
X-Gm-Message-State: AOAM531K4OxG/nbISxqZcnqJnaiExD9FF4Im3/NurWn5zVPKVt7VujtN
        5/XpT5TeKnmA23CZEfjdvg94YKOUi6fmzKFDVFAJ5CRqfHFiGwt/V3s6S67wVRJdtpco+nvlpsJ
        zAZKxhqsKs+V2XVro
X-Received: by 2002:a05:600c:4349:b0:394:1702:6d65 with SMTP id r9-20020a05600c434900b0039417026d65mr14283615wme.4.1651485315307;
        Mon, 02 May 2022 02:55:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8/i3+5Lq6U3+pzPm64AG11XWirt0WkGNCHJtlVsUw2ad0u/NDwUjNeA9GhL5iqMbNNC0QqQ==
X-Received: by 2002:a05:600c:4349:b0:394:1702:6d65 with SMTP id r9-20020a05600c434900b0039417026d65mr14283591wme.4.1651485315059;
        Mon, 02 May 2022 02:55:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id j26-20020adfa55a000000b0020c5253d909sm7156085wrb.85.2022.05.02.02.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 02:55:14 -0700 (PDT)
Message-ID: <9b5c49dcd2b62549c8980d8e812715ee54c5d473.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, richardcochran@gmail.com, lasse@timebeat.app
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Date:   Mon, 02 May 2022 11:55:13 +0200
In-Reply-To: <20220430025723.1037573-2-jonathan.lemon@gmail.com>
References: <20220430025723.1037573-1-jonathan.lemon@gmail.com>
         <20220430025723.1037573-2-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-04-29 at 19:57 -0700, Jonathan Lemon wrote:
> This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> tested on that hardware.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Another nit-pick, sorry ;)

This introduces a few compiler warnings for undeclared functions
(bcm_ptp_config_init and bcm_ptp_probe), see:

https://patchwork.hopto.org/static/nipa/637209/12833026/build_allmodconfig_warn/summary

The warnings could be addressed e.g. re-ordering patch 1/3 and 2/3.

Thanks!

Paolo

