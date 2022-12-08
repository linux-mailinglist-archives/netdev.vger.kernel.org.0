Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAFA647012
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiLHMw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiLHMwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:52:25 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66528B1B5
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:52:24 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vp12so3576901ejc.8
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I0JHokktbhkIah68yRfG4/HegSUlSxkKPY0X0eASPTw=;
        b=ty9E24a8Msd/UVFqtd/bV1EDblMKDBTEmNvE/wTbeFhCjk8chekOlzT2DnFZv17WYY
         497Pt6JBvMGuuYgJ8x1xtWWAczj0K6gZrwlpafh7f6nD9Z9qujy5ixCjyLTDWgAWdX8a
         xmHOAPheITLnBvP7sNLMsMo0DY60P/dXds7naRx5d5E4vMtzSlw9jJWx+yq4pHnp+M2w
         5pjm0hurzj55X1zpJDva8mdu05RZgyFx0VpKHy6TINR+YZ0nN9dmhP4bt6nbW7Ddyyu4
         LzJieuxdTYHf3vBaLkG1l2uTd9zKcF82p5egg8HQuOT0B0uEZU0Sr/hWkkElO8V8x9+G
         Abjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I0JHokktbhkIah68yRfG4/HegSUlSxkKPY0X0eASPTw=;
        b=iTdj3TOpcM/Qq8qN+e2z7DmWswmpc0gqGEF/sCL3wHDoVPME0tVraeIz7DLEuMG/JY
         EhRFinBAX7CfhrdulB2zcnJGziJrDhVRIlB37S47Riv5wP2Mt+S/TJjRm/nUPDLQFJjb
         jWY5VjMlh37oxmMs4BEDMnqb63w9CnjOkfrAfjnvtqwHo+76nye6zFdX6TXlO50miGmr
         9guRh9X/b7Kbo8o/79Kl2rZwKv/To1qjpY75XhwB/EjTzlDxDgDfFUejUnpIFu6R2KbX
         v9vSICqoKEYiWNs5DA6O6DLp3NVJJlVJGAJMIWQ+heeGSS/ZnHsYNx7WxTuEOjTSVBta
         YAJQ==
X-Gm-Message-State: ANoB5pk7/JfL8qElz2KDlcSwZOxTcPkvEHKaSexmjfJ3Y7um1J8KTzwv
        q/317Z/VYziWuOYsKuitumGT4Q==
X-Google-Smtp-Source: AA0mqf4nuttS7+HwXddgEK/R1CrAsO3JtyZkFY3o/ZX+iEIZESNvoOvO8F+EpjUC3h+iSbDrnozhQA==
X-Received: by 2002:a17:906:25d0:b0:7b2:bb8a:9622 with SMTP id n16-20020a17090625d000b007b2bb8a9622mr1763745ejb.72.1670503943153;
        Thu, 08 Dec 2022 04:52:23 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fi22-20020a1709073ad600b007c0d4d3a0c1sm6477499ejc.32.2022.12.08.04.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:52:22 -0800 (PST)
Date:   Thu, 8 Dec 2022 13:52:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, dcbw@redhat.com, linville@tuxdriver.com,
        hs4233@mail.mn-solutions.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH] libertas: fix memory leak in lbs_init_adapter()
Message-ID: <Y5HeBT15/VTwazss@nanopsycho>
References: <20221208121448.2845986-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208121448.2845986-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 01:14:48PM CET, shaozhengchao@huawei.com wrote:
>When kfifo_alloc() failed in lbs_init_adapter(), cmd buffer is not
>released. Add free memory to processing error path.
>
>Fixes: 7919b89c8276 ("libertas: convert libertas driver to use an event/cmdresp queue")
>Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
