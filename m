Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FC46696E1
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbjAMMW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240987AbjAMMWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:22:11 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DC9213;
        Fri, 13 Jan 2023 04:18:52 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id n5so21757517ljc.9;
        Fri, 13 Jan 2023 04:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uJiz5Jta3wvLZk0MsHKHaLqW8MeDBPrQaYCspp02fXA=;
        b=KNm5OkGYaAwXu7K8ctoO/+5DtTmf8dgpHWl7iLP+DGaO3Jfr5pkRdFFsynO4q0FXfG
         g7xPb00bED7vPF+S/WwhRc1kLJcVFb++DkqUDPzPAxE8/brJqrq2PQQJE8g+mkEGpQWo
         19abXUUmouzPDIKFl14H3mVRQXwd7SQ5BnLjMf18onXyuRwqdXRAOzc9MpZ0rPjuQiNa
         8Q0SoAHHzLEs9oifPnDQkoR6BNIgJmA/hxTbi2d0zVbVDY5qn1aEX9Zx87Y5fO5tBynl
         55fXs0uvyaK7XkD31ux5RpuvUvxpm2o0J5I6NeAa4uXRblT9WG9MQXc8L1G71wVCac6Y
         0qoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJiz5Jta3wvLZk0MsHKHaLqW8MeDBPrQaYCspp02fXA=;
        b=6s1ePh25pwOFbULChRtKWMqN9ezpX2JFha3QEyQVYuhvP5DVQlVyye5Dl4kvrPX3U9
         gdvW35tftjELRKkOyb64loIr8aCDtTdAgTF5sp8Q3GZXa/iYLI+WOzxqJ/ZLcSffPkO7
         hI23OtRhaqnuu2majCHMeSHYurlNMqnFfnNwiujczzjoQg5FsAsoN9J1yerOExvo2Hou
         lOVc7pOxd25ka9SeZBOuFsSrgNdYx5+iRYrPeZZQ5KtioWU05r8nFCOy0RjKMNwJDtR+
         GvoOqgVLgNvQj8cIkCCl1abF1Zx4nVHa0xNeAGWl17QmS07ZxN0YNFVcUCNTFjRfRBmL
         e6dQ==
X-Gm-Message-State: AFqh2kr3rjesAhSJU6AqhHfCiAaI17nQY33ntDs9GpdT3gzE4NxUPpzO
        JE3S7uN597I66fk8/S6wxKFZOzWoFpsl6IgEt2ENrw==
X-Google-Smtp-Source: AMrXdXu/UNZbrbtb9rm5MMGZijB5pewWnoBcziMqI2rvlvUm61K2axZie/IMntNqZf7FcxNvf13qvA==
X-Received: by 2002:a05:651c:3cd:b0:280:505:d90f with SMTP id f13-20020a05651c03cd00b002800505d90fmr8404265ljp.13.1673612330881;
        Fri, 13 Jan 2023 04:18:50 -0800 (PST)
Received: from localhost ([185.244.30.32])
        by smtp.gmail.com with ESMTPSA id s26-20020a05651c049a00b002829141fb2dsm2430352ljc.11.2023.01.13.04.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:18:50 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:18:45 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next PATCH 5/5] octeontx2-pf: Add support for HTB offload
Message-ID: <Y8FMJUUvXdl8RhgR@mail.gmail.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
 <20230112173120.23312-6-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112173120.23312-6-hkelam@marvell.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:01:20PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> This patch registers callbacks to support HTB offload.
> 
> Below are features supported,
> 
> - supports traffic shaping on the given class by honoring rate and ceil
> configuration.
> 
> - supports traffic scheduling,  which prioritizes different types of
> traffic based on strict priority values.
> 
> - supports the creation of leaf to inner classes such that parent node
> rate limits apply to all child nodes.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---

Great job! Nice to see the second user of HTB offload.

(Ccing Mellanox folks for more eyes on the series [1].)

[1]: https://lore.kernel.org/all/20230112173120.23312-1-hkelam@marvell.com/

> +	case TC_HTB_NODE_MODIFY:
> +		fallthrough;
> +	default:
> +		return -EOPNOTSUPP;

Is there any technical difficulty or hardware limitation preventing from
implementing modifications?
