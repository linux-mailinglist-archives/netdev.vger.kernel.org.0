Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6718567E28C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjA0LDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjA0LDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:03:21 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BC6530E5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:03:17 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l8so3171455wms.3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81RZox4vIkjEQz6VRLjHNf5FS42vJVVEE4dODSo9rwY=;
        b=NXeBMbeRPTJ4eAbErLybgVm9wmi1aCXhzDGKepHcu6MdGzo3Lx9e9/nAtzyC1JcHPE
         ij5j0hml9o+0wrt8p4FxfY03ANY3qqKSiiN6bjvng2vQqAnDz2r7gzqYIQva9LEdD0NW
         7OGjLzCqAteqMHlRshzYSQTTO+IGRhsTmaqpfO1We53SM7kBU2dpEkqBNHom05B67q+v
         15WOdq3REnZH+sLRAXcXZDeLnV1lsdkxK5ayliMkFIbg6YHKldBUf+Zaa+qvLuYh/v/5
         y2W4pqB7rsDfs8MSiGsgvziQ1Cbcpx/6mWP3vgg3RqFtHX5NbjCetrixPS6lbGpLdURX
         4xJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81RZox4vIkjEQz6VRLjHNf5FS42vJVVEE4dODSo9rwY=;
        b=ooLYZHf4D+khjYkpXIC2MJ/d8gZh0upg9SQfV/UOtExEOwWp+hqWQNjFJAiJ63QU2f
         mOG0Fldf2H5tpjAZKv8wLNd2x6fGEY/d25y3rm/4TwgDUDb4+VQRou0bSkc5vQKYJkwo
         6UBdzLLumMkR2LDYy5RJbxI8DJC1X9EHPzVI0BuamD4WMXMrp8iZ5sSfo8T+N+XIXwjo
         X06UiOoTsc1PpXXYDbNX+szYJVgECF96dq+HmEC08TVsB28ZAf6yc0mFWcXx6WZbv8D1
         QVidryit9XAoVUrcjEjBoK4nGkVt2oI1r01WuhH3x+Bb1uLCWmmZZ/zv7nPBUoiU4w0V
         4eoA==
X-Gm-Message-State: AFqh2koTP84+C0GekfLMbOxiFU6TKuMT/AP6ZN0lyIx4CGEx2Rm2F38w
        PjooQfFzzmRPuBXIt+DUEac=
X-Google-Smtp-Source: AMrXdXstXLLvmq+lug4OKZASglHNfWa34r7LjtGbX3h1NZ6rY5mB8Ot0VyiybOYSNXeaGaDRnIpAPg==
X-Received: by 2002:a05:600c:2d0b:b0:3da:fcf0:a31d with SMTP id x11-20020a05600c2d0b00b003dafcf0a31dmr39501119wmf.22.1674817395700;
        Fri, 27 Jan 2023 03:03:15 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n23-20020a05600c3b9700b003dab77aa911sm8546429wms.23.2023.01.27.03.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 03:03:15 -0800 (PST)
Date:   Fri, 27 Jan 2023 11:03:13 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH v3 net-next 0/8] sfc: devlink support for ef100
Message-ID: <Y9Ovcc5jkiEVz0XC@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com
References: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 09:36:43AM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> v3 changes:
>  - fix compilation warnings/errors reported by checkpatch

I hope you also fixed the modpost issue reported in
https://lore.kernel.org/netdev/202301251924.Vt4cZmeM-lkp@intel.com/

> 
> v2 changes:
>  - splitting up devlink info from basic devlink support
>  - using devlink lock/unlock during initialization and removal
>  - fix devlink registration order
>  - splitting up efx_devlink_info_running_versions
>  - Add sfc.rst with specifics about sfc info
>  - embedding dl_port in mports
>  - using extack for error reports to user space
> 
> This patchset adds devlink port support for ef100 allowing setting VFs
> mac addresses through the VF representor devlink ports.
> 
> Basic devlink infrastructure is first introduced, then support for info
> command. Next changes for enumerating MAE ports which will be used for
> devlik port creation when netdevs are registered.

Typo: devlik should be devlink.

> 
> Adding support for devlink port_function_hw_addr_get requires changes in
> the ef100 driver for getting the mac address based on a client handle.
> This allows to obtain VFs mac address during netdev initialization as
> well what is included in patch 6.
> 
> Such client handle is used in patches 7 and 8 for getting and setting
> devlink ports addresses.

port in stead of ports.

Martin

> 
> Alejandro Lucero (8):
>   sfc: add devlink support for ef100
>   sfc: add devlink info support for ef100
>   sfc: enumerate mports in ef100
>   sfc: add mport lookup based on driver's mport data
>   sfc: add devlink port support for ef100
>   sfc: obtain device mac address based on firmware handle for ef100
>   sfc: add support for devlink port_function_hw_addr_get in ef100
>   sfc: add support for devlink port_function_hw_addr_set in ef100
> 
>  Documentation/networking/devlink/sfc.rst |  57 ++
>  drivers/net/ethernet/sfc/Kconfig         |   1 +
>  drivers/net/ethernet/sfc/Makefile        |   3 +-
>  drivers/net/ethernet/sfc/ef100_netdev.c  |  31 ++
>  drivers/net/ethernet/sfc/ef100_nic.c     |  93 +++-
>  drivers/net/ethernet/sfc/ef100_nic.h     |   7 +
>  drivers/net/ethernet/sfc/ef100_rep.c     |  57 +-
>  drivers/net/ethernet/sfc/ef100_rep.h     |  10 +
>  drivers/net/ethernet/sfc/efx_devlink.c   | 660 +++++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h   |  46 ++
>  drivers/net/ethernet/sfc/mae.c           | 218 +++++++-
>  drivers/net/ethernet/sfc/mae.h           |  41 ++
>  drivers/net/ethernet/sfc/mcdi.c          |  72 +++
>  drivers/net/ethernet/sfc/mcdi.h          |   8 +
>  drivers/net/ethernet/sfc/net_driver.h    |   8 +
>  15 files changed, 1285 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/networking/devlink/sfc.rst
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
> 
> -- 
> 2.17.1
