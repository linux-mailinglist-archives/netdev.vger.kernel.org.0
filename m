Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380CF637431
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiKXIkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiKXIkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:40:19 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A107E65AE
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:40:18 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v1so1371352wrt.11
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DUryxKPyqOqeo18ci5P62LBH5soC6UqETa6+VQzSiKg=;
        b=z/aE6+CINXrTH9IX5jaupdZA2Hgs8eKRnkwEhY6vjvc5mlzhOLNZZk6tSaURGYXGxc
         QjeWYFTlczWQE4b9vzlhQL35Wh4A0l/6mOFgl4sNEfsl/NKwBb2k0NDdJS+MoYtzd4yo
         WZKbFvEUZCOIMIHH8T37ucH6dLZCW/Zk5fs2N3Jtg44SPQ41I8g4O0WmYIPdwvbYS3G5
         2JRkg1w2gaIqd+H5UfJHppoQxgF50xxbBi0laLvon568pS7xX6UWEXXT7O7gL9D5bmOd
         AD5gLTBUDXUhzGuB4hQuxc3t6fL4BXgB/xdYTp8f73lhlQUHGVqYKwf+AsJFtCSLpNZ1
         l/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUryxKPyqOqeo18ci5P62LBH5soC6UqETa6+VQzSiKg=;
        b=AHlFLKbhiZNZ1URazy0nRLi83CEAq3Ph2ndhBjIDO9trwIjG3GqXd4BHcqlMwMonTr
         ktZbVTw9UhZPFDGh/QeFKz1KCugMS85gkQbzy+hEZSe8vVlr+LLAT3ON8Zv5O8oX7Vfd
         zCToR/YwZPGO9C2RzoP9fU/YFnCA2QioPp0g8llsq8+1GxvL4Bal9eDGVy1mcD1u4vCJ
         RyQolj+gBaFyPaW7dujiFJEWZj1Adu4vxArG1M+iEGUE2b61qUjAPkeOSnCFvgNWRDdu
         BmJDgd3F9GTo/WAiDV6BvZlGJHFQA646tieftiITrbJ+JJtCsqOSIX98Zt87Qvt1ZHyr
         lw3Q==
X-Gm-Message-State: ANoB5plcZEn3ZhSHwvFHyFgK8Uy4W31Q5kpgHFvQM3MqPAgWJQIr8u9Y
        IiIbfGXp0Nic31UuIjXofzD8odA70quSftQj
X-Google-Smtp-Source: AA0mqf4wt+to3Gzef5sGRhdNvwYhEPZCk77ZLrBWI5ldqygdJAz7yDGQgXiKB2x8MgMBGklSDZFnhQ==
X-Received: by 2002:adf:e844:0:b0:241:bfc9:5975 with SMTP id d4-20020adfe844000000b00241bfc95975mr11977281wrn.605.1669279217003;
        Thu, 24 Nov 2022 00:40:17 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c310b00b003cfd4e6400csm1037573wmo.19.2022.11.24.00.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:40:16 -0800 (PST)
Date:   Thu, 24 Nov 2022 09:40:15 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/9] devlink: use min_t to calculate data_size
Message-ID: <Y38t77Bu2gwKuZjM@nanopsycho>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123203834.738606-2-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 09:38:26PM CET, jacob.e.keller@intel.com wrote:
>The calculation for the data_size in the devlink_nl_read_snapshot_fill
>function uses an if statement that is better expressed using the min_t
>macro.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
