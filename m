Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3634BEC09
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiBUUoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:44:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbiBUUox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:44:53 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF605237F1;
        Mon, 21 Feb 2022 12:44:29 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bg10so36237508ejb.4;
        Mon, 21 Feb 2022 12:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+tHtW9qpcptaDKAypuy7gFBJ5TmuRSh2L4X8lOYzJ3U=;
        b=CA58Zl7PXatZ4vfJ5s4fOWUOf5r2heLy6+mWi8+ndacEQ7ZQi312NT9gA8pl2iIXQD
         qbMI7Tjwwa2kMX7+Ogj2rVLZLiqdbO7Kx2Ocni3/T08xjU4PPelvID6f99J7YkWAWs8q
         tL6tvUy5FXLnnrQLB7wEXQLrQ+WFLbeXYI575Cvy5oLkLL/OxgeYCUN9FhE19KdeijyS
         WiixcvSe9tyWiVEa5BT0KWE+oAJ7UZYGscB+IzPceTZyAbhRQvcx6f7DyjcEAxfiPgFu
         APS3//0jNUvcits8jfF8j9Ekj/beRHyNgnlgtASNxLARjYt6T6QYzI5/MH5zDkNQIDBc
         aITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+tHtW9qpcptaDKAypuy7gFBJ5TmuRSh2L4X8lOYzJ3U=;
        b=UWIKvBGokmS2CIJRwPpq7+a+7dIwLu32lhoZ9snieLtVjJgNhZAO79t6wyqYpRC2u2
         nqBse+9yfdoQe5k/wneBZAzxezMJA1OVZVa7SHNTjDpOBx9BiRD24dAIAq+YHNXz5Fdk
         DoBhQOoLRx5IJXKx+o3zTkpoCRTk+5kjX4+CH+up9od59TonLCi57rDpEeokufl1mlHx
         m9a67tLPdngLOnFm5hvzReNwpkbqoVuGPFN7iU0yjXTv7k4RSQe6D6uM6cWyYMDsSWOn
         QI4BKhy/vcvoivFbPd8h4jBlbjdr+BDTcSxHv1wTIfsld9FvoB/JHp4RDBrYWHp6Fq/6
         EkBQ==
X-Gm-Message-State: AOAM532yh5pZnwkiRSYOn//CCEiPqPJGNfMRXpGEGT/Mw338cAZPgNgb
        2SeuNMnxICvNZKJKoq2D9tw=
X-Google-Smtp-Source: ABdhPJxf7yfsSem7m4bZdvY+sDDxyhdD5WybvYiFk+srzKcFEalZVEMF+Tz/tGZpbBUMmmlQukqYrA==
X-Received: by 2002:a17:906:fb8a:b0:6b5:d269:bb48 with SMTP id lr10-20020a170906fb8a00b006b5d269bb48mr17425123ejb.91.1645476268420;
        Mon, 21 Feb 2022 12:44:28 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id m17sm5557191ejn.118.2022.02.21.12.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:44:28 -0800 (PST)
Date:   Mon, 21 Feb 2022 22:44:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: dsa: fix panic when removing unoffloaded
 port from bridge
Message-ID: <20220221204426.qqvrlxfefpp57h65@skbuf>
References: <20220221203539.310690-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221203539.310690-1-alvin@pqrs.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 09:35:38PM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> If a bridged port is not offloaded to the hardware - either because the
> underlying driver does not implement the port_bridge_{join,leave} ops,
> or because the operation failed - then its dp->bridge pointer will be
> NULL when dsa_port_bridge_leave() is called. Avoid dereferncing NULL.
> 
> This fixes the following splat when removing a port from a bridge:
> 
>  Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
>  Internal error: Oops: 96000004 [#1] PREEMPT_RT SMP
>  CPU: 3 PID: 1119 Comm: brctl Tainted: G           O      5.17.0-rc4-rt4 #1
>  Call trace:
>   dsa_port_bridge_leave+0x8c/0x1e4
>   dsa_slave_changeupper+0x40/0x170
>   dsa_slave_netdevice_event+0x494/0x4d4
>   notifier_call_chain+0x80/0xe0
>   raw_notifier_call_chain+0x1c/0x24
>   call_netdevice_notifiers_info+0x5c/0xac
>   __netdev_upper_dev_unlink+0xa4/0x200
>   netdev_upper_dev_unlink+0x38/0x60
>   del_nbp+0x1b0/0x300
>   br_del_if+0x38/0x114
>   add_del_if+0x60/0xa0
>   br_ioctl_stub+0x128/0x2dc
>   br_ioctl_call+0x68/0xb0
>   dev_ifsioc+0x390/0x554
>   dev_ioctl+0x128/0x400
>   sock_do_ioctl+0xb4/0xf4
>   sock_ioctl+0x12c/0x4e0
>   __arm64_sys_ioctl+0xa8/0xf0
>   invoke_syscall+0x4c/0x110
>   el0_svc_common.constprop.0+0x48/0xf0
>   do_el0_svc+0x28/0x84
>   el0_svc+0x1c/0x50
>   el0t_64_sync_handler+0xa8/0xb0
>   el0t_64_sync+0x17c/0x180
>  Code: f9402f00 f0002261 f9401302 913cc021 (a9401404)
>  ---[ end trace 0000000000000000 ]---
> 
> Fixes: d3eed0e57d5d ("net: dsa: keep the bridge_dev and bridge_num as part of the same structure")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
