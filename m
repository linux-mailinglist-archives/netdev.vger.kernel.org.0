Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D478619BDC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiKDPjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbiKDPjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:39:40 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED96627D
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:39:39 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id b2so14273082eja.6
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lqF4NkcgM96gpspPsTE8hacNbSHniJKL1jXjvp4g3VY=;
        b=P9yMbWwaCSJ2MnoJSt2EKioU1J0BZbS80aRyQ4oD9gORXiKENvtWRBxY8rnvG/eEug
         3IFj4Jk+dN6WGrUckqubuT/RRMFGKDlYezjg3XoA+Zetl+s6H6Qx5R9wpwFN0+COQF6d
         b3Cme1pzNjZJlOP5EKHELu4MLsPKCNauJ+4r2ztaUa5aCwOw9QqgQ/Bb9/lh3f7Kos2h
         tKVncJ81+7n2LNiq2iGmXAlZrqPS/uxfhy5sVeQsRpTGVp+/KccR6lNJgJuUeRlstJYl
         hehtctcr8gcv+rRIC9FgXOrNKPeXMcfGovEZs/wIFgY/qMFz1wZRj7mnNqRgxCjVqQTv
         j07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqF4NkcgM96gpspPsTE8hacNbSHniJKL1jXjvp4g3VY=;
        b=FjYH6vf8MkqtXt9bFFr8YAdS6qq8HfOQEEG8PRj81SY0tMv6pBPSAX9NkXpS8QElLw
         8LJAFQMYTYKjN1W4JLjCTG1kduRtg/UzQCfJHxCKT2gy+qY36SrbIBGWuddsU4D8bBm9
         FaW+H4Zmz3m9KX6e6VUufJJ7SjmkPv2FBG+3VKfh5Z5Yr6vezLA34wGyXze0+bw6A+J1
         2OT2eGC4NBTM4Y3grAedf5Dk4BVkFAMd756sMm3+GNCn7m359FfBppJDv8jSiybhjb49
         nikSkiBOSNj9w9xb6qHSum0Cc++hy2D+Hw316kzevimgY6q+SMflBZy+oeMglqhkEnjk
         D3ag==
X-Gm-Message-State: ACrzQf04ocLmA9kLOA/UODiYUk4wwbeuJETDhLmcwyqytIt/ZGxw0/El
        GoDyDVkj7GPplfHvPCC+YJM/2g==
X-Google-Smtp-Source: AMsMyM4jW55BhMk6hCZFgubMrBHZyaHiyiVt8T6hRW25dNlT/pgXoG9ftAnQwGR6Xxh/s8LbOUMrNA==
X-Received: by 2002:a17:906:9b87:b0:733:1795:2855 with SMTP id dd7-20020a1709069b8700b0073317952855mr35397085ejc.156.1667576378244;
        Fri, 04 Nov 2022 08:39:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r17-20020a1709061bb100b00783f32d7eaesm1908484ejg.164.2022.11.04.08.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:39:37 -0700 (PDT)
Date:   Fri, 4 Nov 2022 16:39:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v9 3/9] devlink: Enable creation of the
 devlink-rate nodes from the driver
Message-ID: <Y2UyOB4nLXf77bVk@nanopsycho>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104143102.1120076-4-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104143102.1120076-4-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 04, 2022 at 03:30:56PM CET, michal.wilczynski@intel.com wrote:
>Intel 100G card internal firmware hierarchy for Hierarchicial QoS is very
>rigid and can't be easily removed. This requires an ability to export
>default hierarchy to allow user to modify it. Currently the driver is
>only able to create the 'leaf' nodes, which usually represent the vport.
>This is not enough for HQoS implemented in Intel hardware.
>
>Introduce new function devl_rate_node_create() that allows for creation
>of the devlink-rate nodes from the driver.
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
