Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33D96A9E31
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjCCSLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbjCCSLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:11:43 -0500
X-Greylist: delayed 417 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Mar 2023 10:11:42 PST
Received: from tygrys.net (poczta.tygrys.net [213.108.112.254])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E57518AA2
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 10:11:42 -0800 (PST)
Received: from [10.44.222.153] (unknown [192.168.0.142])
        by tygrys.net (Postfix) with ESMTPSA id 90B2F417D894;
        Fri,  3 Mar 2023 19:04:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nowatel.com;
        s=default; t=1677866683;
        bh=CJT+5jr7h2CEWTLTCEU8+Z+C2Xm5TeNm18LSJvK5+n0=;
        h=Date:From:Subject:To:Cc;
        b=sLv0qKofldf+OMHHm+0XcaFKFmugaRr+lJf9381bcyxVCqlmRUwNMwvUlZHUUceAI
         H0MhPFW4BB0l/7TxHRMcBqVTyAxXvQPhyt/cipqOqqVitKI8GRUAOQCpMcbsXlrYbx
         2WhDr6wsXgMwD+rrXOPlnojnXj9M4j68wDITvg2E=
Message-ID: <dccaf6ea-f0f8-8749-6b59-fb83d9c60d68@nowatel.com>
Date:   Fri, 3 Mar 2023 19:04:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: pl, en-GB
From:   =?UTF-8?Q?Stanis=c5=82aw_Czech?= <s.czech@nowatel.com>
Subject: htb offload on vlan (mlx5)
Organization: Nowatel Sp. z o.o.
To:     netdev@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm trying to use htb offload on vlan interface using  ConnectX-6 card 
(01:00.0 Ethernet controller: Mellanox Technologies MT28908 Family 
[ConnectX-6])
but it seems there is no such a capability on the vlan interface?

On a physical interface:

ethtool -k eth0 | grep hw-tc-offload
hw-tc-offload: on

On a vlan:

ethtool -k eth0.4 | grep hw-tc-offload
hw-tc-offload: off [fixed]

so while there is no problem with:
tc qdisc replace dev eth0 root handle 1:0 htb offload default 2

I can't do:
tc qdisc replace dev eth0.4 root handle 1:0 htb offload default 2
Error: hw-tc-offload ethtool feature flag must be on.


modinfo mlx5_core
filename: 
/lib/modules/6.2.1-1.el9.elrepo.x86_64/kernel/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko.xz
license:        Dual BSD/GPL
description:    Mellanox 5th generation network adapters (ConnectX 
series) core driver
author:         Eli Cohen <eli@mellanox.com>
srcversion:     59FA0D4A4E95B726AB8900D

Is there a different way to use htb offload on the vlan interface?

Greetings,
*Stanisław Czech*

