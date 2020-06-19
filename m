Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA5D200267
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgFSHDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgFSHDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 03:03:45 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9687C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 00:03:44 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s28so6717485edw.11
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 00:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=29xULxJCIJJBM7FmlrqMmhHTK6tWJ7AFfkAGJqVdsnU=;
        b=L7U0ymEDMd6Bujw42JqfDFfjnSqwmTmi671C+VTC+1tsnM3fzEmNpzObB5E528wdw3
         gxHGYIVUTz0zs7LciEdJ4SaXvYbsfPtcvbz2+NqivtMnKi6STRcX1u3Ua62r7d2US6eH
         AD5Y69xW7hNFdou6RI+icSjFxUUtbNQVVsbKRfbXIGAp4G+x7nE6Dnq9dslmh60UIJyQ
         QV6PqoVBQ7ahn0I1jMcBcEmXUwg3tU6z9dy146hDNIBiwRAcmGz2ifNEJ8EeWOVgFVGA
         hzvpB1Ovknt3qJeSbPkckaQ0MKzntUX3NTNn86jrH/Hi4twNnFbjqfvEP+lHvthUI95d
         8KdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=29xULxJCIJJBM7FmlrqMmhHTK6tWJ7AFfkAGJqVdsnU=;
        b=ZJzeQlvDGb3kO+EdSBha4kDbVUxGissuRz2pzNO7CY9Svas2YklJ4RMtte0yVD0gv0
         S94rxUcCojiAYUKGwCfzN4Yp6oXp1WnWgJV7JYqEkHcXKpBNxXUpEaDYo4yKEM2JoPl4
         Ziyl+mgRetD9sPD4g5JQ4XMU5jRrmcOWN3xoi143cWdQizRzABOx3bCxNe5Z/CRA5VXE
         T/2j9H+HsCIIwhslfG1afKN3cKTSIdDeYyDIgUB/EWKlWYvHdS+432E07qIx1L9iO6ZF
         5hVMItwmvF5ekLvD6loKuM0ejd42PmAgloA+5JrdhIvMFyljSXsCUNtlqUIw7Ao5yLks
         nJ0g==
X-Gm-Message-State: AOAM532hjz73VYGJtYbOtFOgDs1Ex2gxsNNUgOFjLCUO0V2/PpVFTjE5
        nTUrdRaR9EplyT/NDuB6vNl8RA==
X-Google-Smtp-Source: ABdhPJyDeExvTCzUgxuPVQ8DjfspddnKSeF/AU4rVBhTYA7NKS7Z7eSzN+Jq6/1RX4eqfi5Lvzh6HA==
X-Received: by 2002:a50:cd56:: with SMTP id d22mr1800363edj.374.1592550222007;
        Fri, 19 Jun 2020 00:03:42 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id u3sm4208545edx.25.2020.06.19.00.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 00:03:41 -0700 (PDT)
Date:   Fri, 19 Jun 2020 09:03:40 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jiri@resnulli.us, vinicius.gomes@intel.com,
        vlad@buslov.dev, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v2,net-next] net: qos offload add flow status with dropped count
Message-ID: <20200619070340.GE9312@netronome.com>
References: <20200324034745.30979-1-Po.Liu@nxp.com>
 <20200619060107.6325-1-po.liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619060107.6325-1-po.liu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 02:01:07PM +0800, Po Liu wrote:
> From: Po Liu <Po.Liu@nxp.com>
> 
> This patch adds a drop frames counter to tc flower offloading.
> Reporting h/w dropped frames is necessary for some actions.
> Some actions like police action and the coming introduced stream gate
> action would produce dropped frames which is necessary for user. Status
> update shows how many filtered packets increasing and how many dropped
> in those packets.
> 
> v2: Changes
>  - Update commit comments suggest by Jiri Pirko.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
> This patch is continue the thread 20200324034745.30979-1-Po.Liu@nxp.com
> 
>  drivers/net/dsa/sja1105/sja1105_vl.c                  |  2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c          |  2 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  2 +-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c    |  2 +-
>  drivers/net/ethernet/freescale/enetc/enetc_qos.c      |  7 +++++--
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |  4 ++--
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |  2 +-
>  drivers/net/ethernet/mscc/ocelot_flower.c             |  2 +-
>  drivers/net/ethernet/netronome/nfp/flower/offload.c   |  2 +-
>  drivers/net/ethernet/netronome/nfp/flower/qos_conf.c  |  2 +-
>  include/net/act_api.h                                 | 11 ++++++-----
>  include/net/flow_offload.h                            |  5 ++++-
>  include/net/pkt_cls.h                                 |  5 +++--
>  net/sched/act_api.c                                   | 10 ++++------
>  net/sched/act_ct.c                                    |  6 +++---
>  net/sched/act_gact.c                                  |  7 ++++---
>  net/sched/act_gate.c                                  |  6 +++---
>  net/sched/act_mirred.c                                |  6 +++---
>  net/sched/act_pedit.c                                 |  6 +++---
>  net/sched/act_police.c                                |  4 ++--
>  net/sched/act_skbedit.c                               |  5 +++--
>  net/sched/act_vlan.c                                  |  6 +++---
>  net/sched/cls_flower.c                                |  1 +
>  net/sched/cls_matchall.c                              |  3 ++-
>  25 files changed, 60 insertions(+), 50 deletions(-)

Netronome portion:

Reviewed-by: Simon Horman <simon.horman@netronome.com>

