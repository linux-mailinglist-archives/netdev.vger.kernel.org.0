Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D666368D0B2
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjBGHjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBGHjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:39:16 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E997A1554E
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 23:39:14 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u21so14255846edv.3
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 23:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YATZtNx6IlyvrsedzBPrc0sfqopT6UwAxVdTkCgm2cY=;
        b=RVwh7MdJB4z/SRJ5ndaRlE6IcKTzEo74CkjXgssRMewqBdERyeO9oS82I4rwQVo39w
         Cva9jvURa3RFBskXR3iTJM8sZThAqMFKeGXxC1mcmsAPOTyq79vAguG1JAgboKZQmnkh
         afeSyRR9B8Xr73Py+TPzqJpcDzIDt6mlq7eJYvNao56EZFVEsGWdq6zq2aZ1YD3cUud+
         zkaLGAWTNIecb596SGF/sV37cVgm4yo22n2htDKz8vBf0AletRNKGMd4EHL8o2KYlY2D
         LceM9Cgmeg5z5YRTcV5gKy/n59Pe/+Eb6yaDFyrftiadFvSirRB10J8HIJh70kmtrq9r
         QrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YATZtNx6IlyvrsedzBPrc0sfqopT6UwAxVdTkCgm2cY=;
        b=phVs2rYUO6NSHm+qehxY9F/fzp+cnt4HGL38o8onB3HP3rbk8/ban+0mPKTzrhQHNm
         N7IyumyVrwbiyud0NOmGMt5Csi2rj7QJMa7fkrAbZ8oKO/1r14pvoKRRIqvfujpD0CZt
         zLU9fmQTbJ9LC5gDKu9MoNj1qYBTvuwN2Yfld7SkKrAn2sR0iibqhtfCCw2oIn2TKznU
         9B2NsFt5lMRzykcQ1CHrIdoj5N3J52BGFgtDcnzMmRLnkW9p8U7X1Y54R5hisX1e4XE0
         YPtoeNWT5tEdgqXEV3byxlQ/Tm1LZJrssZ++Trel9QZrHAHmWl3iVSsPSd+XJwR2b/Nz
         MpNQ==
X-Gm-Message-State: AO0yUKXN6kcHzvY6DO8VFbKQUFY/q/HRfr4WYwI1YTv+2AydrSJK1KO+
        EZ0efwoUWEtpdX+/GJ3kHkxTvw==
X-Google-Smtp-Source: AK7set9qQWXjVsNV2+cHQTXfFZBcgs7LjpVvcUEqAX1mPVPvPcsB2Akv+FBEMjABmq32TIEkFdLJtQ==
X-Received: by 2002:a50:bb44:0:b0:4aa:ab5b:99d3 with SMTP id y62-20020a50bb44000000b004aaab5b99d3mr2334984ede.30.1675755553391;
        Mon, 06 Feb 2023 23:39:13 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b10-20020a056402138a00b0046ac460da13sm6053107edv.53.2023.02.06.23.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 23:39:12 -0800 (PST)
Date:   Tue, 7 Feb 2023 08:39:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 1/6] mlxsw: spectrum: Remove pointless call to
 devlink_param_driverinit_value_set()
Message-ID: <Y+IAH9uhhcev9MXT@nanopsycho>
References: <cover.1675692666.git.petrm@nvidia.com>
 <bb8ddbeb644e9b631445515e338ecf1eef33587e.1675692666.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb8ddbeb644e9b631445515e338ecf1eef33587e.1675692666.git.petrm@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 06, 2023 at 04:39:18PM CET, petrm@nvidia.com wrote:
>From: Danielle Ratson <danieller@nvidia.com>
>
>The "acl_region_rehash_interval" devlink parameter is a "runtime"
>parameter, making the call to devl_param_driverinit_value_set()
>pointless. Before cited commit the function simply returned an error
>(that was not checked), but now it emits a WARNING [1].
>
>Fix by removing the function call.
>
>[1]
>WARNING: CPU: 0 PID: 7 at net/devlink/leftover.c:10974
>devl_param_driverinit_value_set+0x8c/0x90
>[...]
>Call Trace:
> <TASK>
> mlxsw_sp2_params_register+0x83/0xb0 [mlxsw_spectrum]
> __mlxsw_core_bus_device_register+0x5e5/0x990 [mlxsw_core]
> mlxsw_core_bus_device_register+0x42/0x60 [mlxsw_core]
> mlxsw_pci_probe+0x1f0/0x230 [mlxsw_pci]
> local_pci_probe+0x1a/0x40
> work_for_cpu_fn+0xf/0x20
> process_one_work+0x1db/0x390
> worker_thread+0x1d5/0x3b0
> kthread+0xe5/0x110
> ret_from_fork+0x1f/0x30
> </TASK>
>
>Fixes: 85fe0b324c83 ("devlink: make devlink_param_driverinit_value_set() return void")
>Signed-off-by: Danielle Ratson <danieller@nvidia.com>
>Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

>Signed-off-by: Petr Machata <petrm@nvidia.com>
