Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC91834D968
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 23:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhC2VGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 17:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231157AbhC2VF4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 17:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EFC61976;
        Mon, 29 Mar 2021 21:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051955;
        bh=OtcCjjLZbaur2B7OExtX0LSlInIrcR+m6q3EDw1d8VY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qX6AVYYpRom0Cgd1fHjn6VNR6OkX9Z+WOXyPDEBOZe4fpoTulKBbBu3MZSL4hE2vm
         pXAA3owv19RyorkgxSQcE7ckgeOgiTh1FGOPeUXPNwhZq1qY91q49IoyxFOM7ws9nu
         gW4s3ldybwk2WCfrD6X4DC53HrcMq/I9mxSoL/lJ6C1QVccVJOBEWMeyk/sh1X2rH2
         5tchL8tmksW7Nr99FD55avl/RULERolmC9DJmUzPA2hzejU/Ea9H3upqBWCmhzF9IW
         gv7u+zQ4aavJzE0jZYNdCPVX0jTrulicJLq9HCX4YKVcpSpWLIVlR7f3C+YrCQPzt3
         OQZpHlPFlBXaA==
Message-ID: <026c789b7d3b6f81698803cc9ef86c3467d878d5.camel@kernel.org>
Subject: Re: esp-hw-offload support for VF of NVIDIA Mellanox ConnectX-6
 Ethernet Adapter Cards
From:   Saeed Mahameed <saeed@kernel.org>
To:     =?UTF-8?Q?=E9=AB=98=E9=92=A7=E6=B5=A9?= <gaojunhao0504@gmail.com>,
        borisp@nvidia.com, Huy Nguyen <huyn@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Cc:     netdev@vger.kernel.org, seven.wen@ucloud.cn, junhao.gao@ucloud.cn
Date:   Mon, 29 Mar 2021 14:05:54 -0700
In-Reply-To: <CAOJPZgkLvkhN4+_OCLPyWBiXPRc=qLYa3b5jyz63dkn7GQA2Uw@mail.gmail.com>
References: <CAOJPZgkLvkhN4+_OCLPyWBiXPRc=qLYa3b5jyz63dkn7GQA2Uw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-29 at 16:42 +0800, 高钧浩 wrote:
> Hi Boris,Saeed
> 
>      I'm enabling esp-hw-offload for VF of NVIDIA Mellanox ConnectX-6
> Ethernet Adapter Cards, but it doesn't work.
>      Before I created VF, the esp-hw-offload function of CX-6 is on,
> after I created VF, the esp-hw-offload function of VF doesn't inherit
> the esp-hw-offload function of CX-6.
>      Enable esp-hw-offload could refer to
> https://docs.mellanox.com/display/OFEDv522200/IPsec+Crypto+Offload.
> 
>      Create VF steps as follows:
>      modprobe mlx5_core
>      echo 2 > /sys/class/net/net2/device/sriov_numvfs
>      # lspci to get pci bdf number(example:0000:07:00.0)
>      lspci -nn | grep Mellanox
>      echo 0000:07:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
>      echo 0000:07:00.3 > /sys/bus/pci/drivers/mlx5_core/unbind
>      /etc/init.d/mst start
>      mcra /dev/mst/mt4119_pciconf0  0x31500.17  0
>      devlink dev eswitch set pci/0000:07:00.0  mode switchdev encap
> enable
>      echo 0000:07:00.2 > /sys/bus/pci/drivers/mlx5_core/bind
>      echo 0000:07:00.3 > /sys/bus/pci/drivers/mlx5_core/bind
> 
>      Then query the esp-hw-offload of VF:
>      #firstly need to find the created VF(has the properties:
>      bus-info: 0000:07:00.2, driver: mlx5_core)
>      ethtool -i eth0 | grep esp-hw-offload
>      esp-hw-offload: off [fixed]
> 

Huy, Raed, Do you know if we support IPsec inline offload on VFs ?


