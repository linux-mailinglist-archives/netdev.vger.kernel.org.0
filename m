Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC72D619BD4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiKDPgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbiKDPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:36:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFAB27B2E
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:36:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h9so7641753wrt.0
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p8OHJNfXdLxPcJbRaY3H302tf4cHS83hQhlZEjdGxBk=;
        b=sIdCxvNDcY2gSEghxADD2Ze0hCkSeVOfX31wk5q4BPLfv47E6zg80yNb61EThluQaW
         /2PYF1fkmRpfwyE2e3jOQ5Ls7MglbfpcESnQuSAyJMiydJqHENOjBcs7GwrlDrARJJFH
         RmumiCH6EMw7hnJqdJcAh+B4ZCrj37mDsHJzGGBxCZO0pwz8ZdDnUkmn7NHtPFcXbwL7
         PdRQa8OqbvhmfGGScuZ+NX0ubWF44QFJfTj7G9jqMGpjoUxulILuIipZO2aqCJfAhBhC
         vzeOPJeitOplxT5HhTPU/I1YYfBKy/JGKxlAISkRvOe3lDA+L1NFB5K4VWQkF09M/Xlz
         d61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8OHJNfXdLxPcJbRaY3H302tf4cHS83hQhlZEjdGxBk=;
        b=mbI/ZSzmK9DaRdF1iuaKAkkyJIuAqjPubGWSYWihe832gbcCEZ+aZdjNSM38A2/MWW
         qe29iQAI8k9Wj74fTayK4HqKicDlYcYpJFfwR3SM+cZTYLAyuRjwI4sLwm5usnEIbSM+
         b5Xgp+HE1wwPA6UFTBQ+IH+a9YlXe4pIVSFCmyRngJbA4d6e1nnryKs2y4xiZmv5+du5
         RtjGpkQe6fz8DbSiJ1g8GonfqoE9UDhtH1tYHvdnq3OD8x6EAFXy5ng58JqRt92vsGBN
         9CvxxXp6iqeMEbRdTJQuGGHPrsuMDoClEr6CMYzzDULe2HDdF09+cO+Us4K0+VJXpItg
         qXUg==
X-Gm-Message-State: ACrzQf3KdZ6B25rxziLJPiutOw2xgV+9wDIvkmpZUyuP7HDeHP/RvuQJ
        F06BCBmxfzIMh754aJUawHAU1w==
X-Google-Smtp-Source: AMsMyM6h5Da3wsGWo9WFejGhhyKrcP10pTp9mHApzj1PpI70YDf0VGSozbDAy6mGAkEqN5xJ1JVXHg==
X-Received: by 2002:adf:eb82:0:b0:236:d5d6:7dbd with SMTP id t2-20020adfeb82000000b00236d5d67dbdmr17280173wrn.647.1667576207701;
        Fri, 04 Nov 2022 08:36:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k39-20020a05600c1ca700b003b47b913901sm1528500wms.1.2022.11.04.08.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:36:47 -0700 (PDT)
Date:   Fri, 4 Nov 2022 16:36:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v9 2/9] devlink: Introduce new attribute
 'tx_weight' to devlink-rate
Message-ID: <Y2Uxja4oBdpEmj2K@nanopsycho>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104143102.1120076-3-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104143102.1120076-3-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 04, 2022 at 03:30:55PM CET, michal.wilczynski@intel.com wrote:
>To fully utilize offload capabilities of Intel 100G card QoS capabilities
>new attribute 'tx_weight' needs to be introduced. This attribute allows
>for usage of Weighted Fair Queuing arbitration scheme among siblings.
>This arbitration scheme can be used simultaneously with the strict
>priority.
>
>Introduce new attribute in devlink-rate that will allow for configuration
>of Weighted Fair Queueing. New attribute is optional.
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
