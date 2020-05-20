Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4331DC0E9
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgETVGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgETVGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 17:06:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25925207E8;
        Wed, 20 May 2020 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590008779;
        bh=mktoGDJQC/fAa97P3VOHLea8UoOhJlAvmqvYbVJFscE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HX47MK5oOBict8yLT59bQJghOiHzwvgpFJdeyaOY3EwTej10p7dzPjGKR3m+XTxKM
         kc56F/fnmKO4n51HvcIlzFauJcGO+ESvcYSPrMcrc3L+JYBMd9OfGshOg45xBpG9Bp
         Mc3dMtW1mgo+QDRQSCZBT/ih8W5imzgBrBwzzw04=
Date:   Wed, 20 May 2020 14:06:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        GuoJia Liao <liaoguojia@huawei.com>
Subject: Re: [PATCH net-next 1/2] net: hns3: adds support for dynamic VLAN
 mode
Message-ID: <20200520140617.6d8338bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1589937613-40545-2-git-send-email-tanhuazhong@huawei.com>
References: <1589937613-40545-1-git-send-email-tanhuazhong@huawei.com>
        <1589937613-40545-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 09:20:12 +0800 Huazhong Tan wrote:
> From: GuoJia Liao <liaoguojia@huawei.com>
> 
> There is a scenario which needs vNICs enable the VLAN filter
> in access port, while disable the VLAN filter in trunk port.
> Access port and trunk port can switch according to the user's
> configuration.
> 
> This patch adds support for the dynamic VLAN mode. then the
> HNS3 driver can support two VLAN modes: default VLAN mode and
> dynamic VLAN mode. User can switch the mode through the
> configuration file.

What configuration file? Sounds like you're reimplementing trusted 
VFs (ndo_set_vf_trust).

> In default VLAN mode, port based VLAN filter and VF VLAN
> filter should always be enabled.
> 
> In dynamic VLAN mode, port based VLAN filter is disabled, and
> VF VLAN filter is disabled defaultly, and should be enabled
> when there is a non-zero VLAN ID. In addition, VF VLAN filter
> is enabled if PVID is enabled for vNIC.
> 
> When enable promisc, VLAN filter should be disabled. When disable
> promisc, VLAN filter's status depends on the value of
> 'vport->vf_vlan_en', which is used to record the VF VLAN filter
> status.
> 
> In default VLAN mode, 'vport->vf_vlan_en' always be 'true', so
> VF VLAN filter will set to be enabled after disabling promisc.
> 
> In dynamic VLAN mode, 'vport->vf_vlan_en' lies on whether there
> is a non-zero VLAN ID.
> 
> Signed-off-by: GuoJia Liao <liaoguojia@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
