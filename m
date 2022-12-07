Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81913645BC6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLGOAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiLGOAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:00:04 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5030A5CD0C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:00:00 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id fc4so14126712ejc.12
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=973BvPTh1f6Kbx7ipPiwbV8z254q0zXYwIBL8xSZqoQ=;
        b=CPc6kblyr3CeVsxE5gLakh18vY/7Knbh3X76uzoGoTYZkJWDTD/SfpeFkWylbzNIOL
         5Fvm7gfBshzH9KU6GL1G+/q1Nu20N4o28NfMqx2SVfrg6yxcu4+OFVPW0nFuAb+0oceF
         sSd42ScI8AXw4P55WliIL/qEDhfDN5LaIj2Q2T7w4echS4XlJmUM5Tt6LekgFeAS0V25
         JeRF2tPemr7lz2wrhKNCubg7nEk73QQF9mP5+zp9KuN7GhVJ13eqjMdGUoIhshszEczj
         ZQAdOHBWw1S/3xsIfkfYmRwQ85XiR6l7ZoOj4jvIJ4ocRgvbF2rJi3vASSyI3vK8GcTA
         nNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=973BvPTh1f6Kbx7ipPiwbV8z254q0zXYwIBL8xSZqoQ=;
        b=Y2sVXhSRMMIjr715GagxE51grblTI1JiNdA/oUOMwLzTcwyGcXv/2oxn2VUrnwT5cX
         XfUWak2mA2QIfp14P/aSmmWfMAmcwWqjnyBjf6vJm3QhuUn6/f7Rz8GfChqe20CzA4U5
         7URwYTlU+/JaCtBM5fDXtPxsFvj+dUPAD+5iraqbL1OXvTo6+6qN/fBz+advf3EbHJE5
         /rMTLpD/q8/ovMywWtHTGqRh6W+x+35bjpuIWRbIHgbYrrItSQMD40GE+XHcaujQAiRU
         MP6POQLqRETBGFqFBUpiWeCD+6hEdDUXzNHvD97DScmDEsch7T+//V3k0KKRQRkRl4nf
         7tWQ==
X-Gm-Message-State: ANoB5pnxbKLD92H1w6630pHWDVMjCPrfxOqdCpOTpTwbQQrD3R4kffNJ
        tkwy8wCTpl1neCt6yk6jNTgQjw==
X-Google-Smtp-Source: AA0mqf7oUHn9ahfGCiPLFFQO3WLXsMA3PwKOGWZYkZ9N5KRELGhyeehxYsVnr/cSvtiWr0Mzq+RUNA==
X-Received: by 2002:a17:907:c709:b0:7c0:fd1a:79ea with SMTP id ty9-20020a170907c70900b007c0fd1a79eamr4594574ejc.45.1670421598919;
        Wed, 07 Dec 2022 05:59:58 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i5-20020aa7c705000000b00463a83ce063sm2209476edq.96.2022.12.07.05.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:59:58 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:59:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 1/1] tc: ct: Fix invalid pointer dereference
Message-ID: <Y5CcXPfi+M629RcE@nanopsycho>
References: <20221207082213.707577-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207082213.707577-1-roid@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 09:22:13AM CET, roid@nvidia.com wrote:
>Using macro NEXT_ARG_FWD does not validate argc.
>Use macro NEXT_ARG which validates argc while parsing args
>in the same loop iteration.
>
>Fixes: c8a494314c40 ("tc: Introduce tc ct action")
>Signed-off-by: Roi Dayan <roid@nvidia.com>
>Reviewed-by: Paul Blakey <paulb@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
