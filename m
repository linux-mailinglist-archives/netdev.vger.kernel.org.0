Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDA9619BD0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiKDPfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiKDPfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:35:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5237E317DD
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:35:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bk15so7526389wrb.13
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UYbwieF/wonMvnhl5gu7Yq8fcpQSahuRcRRz1KtSSkg=;
        b=FiRys+yhmBCj/ElBdwATA+unE/d+0oZevOdJZzYuMAtpQvH/IlOBlbsrWOmGmW4Arh
         BnKFG8C2L9qzXi9YnBS3eCfaa5cG+OA1YVAXY2pD5cN1MTaBvfE1Pbaukf3bLH/NaeOR
         IKSMDQ2TRy5HoHALpIKhlBfumszAaGeRZpTpOYn0eKmt2lKYo7x4R96StFDhbzxhOqp8
         gi6bGo5BGWh0BZ3F+QdyeZEcZlBJLO5/IWDsc2SRIwlMVVc2GiBP6I5HbQFEzgn8e5GO
         kYiVWIng2P4x07BhhHO1RhBs2/NQpaUOJQmPKOyXD+7/cRCmEqgtoTJ3SfwafYJKRhN/
         gliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYbwieF/wonMvnhl5gu7Yq8fcpQSahuRcRRz1KtSSkg=;
        b=ac7gGDp9eUL0FD41Yn/4lHekDVP0JgNP7MnyX/+HbLGqgwz5nPv0Sb+oUkIC542gH4
         afNs27XOiour1aDAI+Sc+LK8+gaUDa7+jlnSH98EclMp6fHsvDJDIXWhJA3q8c4X7Bnd
         lL3c5EhcjbUbaIwmNTOYQbqUojlCqBg/8apVqoiXmxCpHpyMsw1ICx+RbZf13sDs9HgC
         NoER3wipAaq+Gx/Rk4xSUomq0mFbEYtZQXl/IDULMW5bWqgC7q6AxN+/uac3Vo1grU/H
         tVOK6MGS++QRQwVou7xAcLcz7OT/OdDZQW5p9GdLgly/ylwschaVQc+Vi8iDiYpUll8D
         xc1w==
X-Gm-Message-State: ACrzQf3oipIRY9wQEDPQEM3skU8FVjd+oDV14qWVERT7Zk57JQB9G/VG
        OaIur6wsNhpwUiJYeOG1kvlSyQ==
X-Google-Smtp-Source: AMsMyM4sqlhIaMzmWtK+QT9/aARvKoyRK8bndEtERnuZR/w3YsWS8DHn6z1A2zQ/4zyga8+HDfzW7w==
X-Received: by 2002:a5d:5004:0:b0:236:c92e:5b41 with SMTP id e4-20020a5d5004000000b00236c92e5b41mr19445018wrt.655.1667576132880;
        Fri, 04 Nov 2022 08:35:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t16-20020adfe110000000b002366e3f1497sm3745795wrz.6.2022.11.04.08.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:35:32 -0700 (PDT)
Date:   Fri, 4 Nov 2022 16:35:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v9 1/9] devlink: Introduce new attribute
 'tx_priority' to devlink-rate
Message-ID: <Y2UxQmWTKmXw5tTI@nanopsycho>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104143102.1120076-2-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104143102.1120076-2-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 04, 2022 at 03:30:54PM CET, michal.wilczynski@intel.com wrote:
>To fully utilize offload capabilities of Intel 100G card QoS capabilities
>new attribute 'tx_priority' needs to be introduced. This attribute allows
>for usage of strict priority arbiter among siblings. This arbitration
>scheme attempts to schedule nodes based on their priority as long as the
>nodes remain within their bandwidth limit.
>
>Introduce new attribute in devlink-rate that will allow for configuration
>of strict priority. New attribute is optional.
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
