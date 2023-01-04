Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED9F65D783
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbjADPsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239720AbjADPsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:48:01 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3629D395D5
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:47:58 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so26793331wms.4
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 07:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J7zyW6AyzmHwhueHF1eLtOgCeg4zSfySh7C1IgXxsWQ=;
        b=ndcJYPSRtzqioggRTc9alhByIoWgo8ubcdaG4afSL4+uiW0VNIjnIbRTsW0bYvpitI
         /jnKCLh+cJl1CKkIUSRfvGF3juAIHId/vCTZE6z+yKPixrPDurkE4jTAUPNfedDZmAIz
         rZq3Vrk925Vr3fqXZbN5JUB2dA7ygnCqJcoVk7ASPRP/eRQ92XQj4139+Thb1X5NOtj2
         pxnTuiNyO3KyIPKWvScdqcrnLQxCJNS226KNe70EBwx2JyLYSVRRqx0b1oOYxnmKWObT
         imIZlCpF2gVEbHn79p78WtqFX3+0NBL/iNNNfW2vAk6zuni/PCTZ3MQab7TSo5L5XFAM
         coVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7zyW6AyzmHwhueHF1eLtOgCeg4zSfySh7C1IgXxsWQ=;
        b=f3Y7yQ/mOLxJl0uojkJKh4+PJVsiyfcF/c+8cIySNJxxPBa1z6gHWxnC/X9CMSNvNH
         0VGcv6RHG0lCiT6+KQ7es5hdekfVI7QWj+OKLem6rS/b3NRvNr3mpqKb71hU+xZSaVDf
         NuWo2A7Nnc6UkQ4H1r27hg0i2AbrHiXp8uCDtCQbYjoUE1pciGX2VRz4NfeOydeKkcJ8
         ySsu7Yl52ZSTMTDPf+TUAaF7ljlEjts9NJCI7nwmrhT7lgVP0XWXzZN6pVbMI3gIayiN
         le4Jrf+SVTkCOH9J1aKTwWGmqYWgtk/Cfm2D2jzSX33/0Cwavn9yZ+/tINrSNs5eBPZN
         q8LA==
X-Gm-Message-State: AFqh2kpMcz6/fLRTrzNi4vpqhXKwwaxPtpCMu94DJDiurnqhEv1Qahpm
        F/vDfsWpuIm5mUV8z9YecNLW5w==
X-Google-Smtp-Source: AMrXdXsO3n9nhXp8Zx8jQ3OlQb/+Q646UvXSmig15iRhlI8OhpJUq4GxIVT/cZYyQwz0rcnBmXPLfg==
X-Received: by 2002:a05:600c:5399:b0:3d9:c6f5:c643 with SMTP id hg25-20020a05600c539900b003d9c6f5c643mr3150195wmb.29.1672847276700;
        Wed, 04 Jan 2023 07:47:56 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p19-20020a1c5453000000b003d2157627a8sm49726890wmi.47.2023.01.04.07.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 07:47:56 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:47:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 10/14] devlink: restart dump based on devlink
 instance ids (nested)
Message-ID: <Y7Wfq5wDnASz5WDF@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-11-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-11-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:32AM CET, kuba@kernel.org wrote:
>Use xarray id for cases of simple sub-object iteration.
>We'll now use the dump->instance for the devlink instances
>and dump->idx for subobject index.
>
>Moving the definition of idx into the inner loop makes sense,
>so while at it also move other sub-object local variables into
>the loop.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
