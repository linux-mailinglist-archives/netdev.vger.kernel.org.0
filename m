Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE18E61338B
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiJaKZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJaKZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:25:53 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2634BDF85
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:25:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id g12so15276454wrs.10
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c3RYqhWma8/GV+z33wp3GyGnpJPVvvJN5mQO7Nz1XW8=;
        b=eECDHvD+h0TeYgXgelNZXQVV/BxAlMlmOXN/eY0JMmtS/eVX04nEO8FyCD1Oe5bxmv
         xZZiawpYZIT0yGeaamZXxY4IqiDip1oVWndyMIf33mX6rOaPPZwkQxwItR171uVX/e3h
         RhYDwd3kjai6Lq4xWSYJ4xgMbjKnhkNjU2Bd7PJD845X4Efean4SnAWqs3vciBAqzQXy
         UfD3JbJM9uwkanKOmUANR1LCLCVcQU8Qom+4gOvfVv6GCIRHGkV/AYRuFqEFyE4lq3uQ
         4WMSYbm1yNiPmfEG7Tjtl2MCoW6+bhhMzVHsOPLYfiSHiBqUcM/S91l2SlI5gOLNCmP2
         psQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3RYqhWma8/GV+z33wp3GyGnpJPVvvJN5mQO7Nz1XW8=;
        b=Eegq7ybRQVdlQzUUoSe+u8fivjzH+lBk/vxeng3iStS9p+Unvh9H5agLpI1C6BrCkZ
         GY5okDVinEUXIfNp1srg5AXUoZmx2T6VM2HAc6T59AYk4NT/1dO5A7WQ+0QhJ88sfopl
         OJUxzaGXUPmkvjDs5UIArGRIqAZBECw3vlhAxgX0pyEE0rqK9pGQAlNsyAaVzvZ6Q4eT
         Kg8GGFEl8uOLmJxcsqZMqiHhw2wZ/06wPAQLXtc3w7HmEeEdC2j517OfJUPGdfYDV0al
         W/JArtPTxb9eEnP5Ak7csgtJbz5M15Sx/Vqvb3m4Pu+LRvUgzZoGNZ2yGxeDYBcHhEBn
         2HJg==
X-Gm-Message-State: ACrzQf0LbCZ+zQzqrttNcxuBOPePgw83pTlVRkVlMkIgB9ArdL7BTK8M
        wDolgXdEVOcusbpTtY4XJ2Tstg==
X-Google-Smtp-Source: AMsMyM4SnS9q3z5JybpYuP4YFlbBEfr07Ie73X2C3wEurITl2BWiN6AecYMTDkOzdTsrcNt8NMZ1Og==
X-Received: by 2002:adf:f14e:0:b0:236:d073:dad with SMTP id y14-20020adff14e000000b00236d0730dadmr1786577wro.15.1667211948662;
        Mon, 31 Oct 2022 03:25:48 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d4612000000b002368424f89esm6616627wrq.67.2022.10.31.03.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 03:25:48 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:25:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v8 4/9] devlink: Allow for devlink-rate nodes
 parent reassignment
Message-ID: <Y1+iq00NWayy0G2j@nanopsycho>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-5-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028105143.3517280-5-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 28, 2022 at 12:51:38PM CEST, michal.wilczynski@intel.com wrote:
>Currently it's not possible to reassign the parent of the node using one
>command. As the previous commit introduced a way to export entire
>hierarchy from the driver, being able to modify and reassign parents
>become important. This way user might easily change QoS settings without
>interrupting traffic.
>
>Example command:
>devlink port function rate set pci/0000:4b:00.0/1 parent node_custom_1
>
>This reassigns leaf node parent to node_custom_1.
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
