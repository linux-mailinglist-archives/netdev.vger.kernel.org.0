Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5261DC4CD
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 03:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgEUBgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 21:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbgEUBgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 21:36:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80BCD206BE;
        Thu, 21 May 2020 01:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590025001;
        bh=50+omnV6kU5L+9tOyK1dQNBOsCEluF+W9UEGXGi8iyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SH5gNQhIlyeWDxygzf1TVBesxJsBvm7GHIkakTRGm/gx5A/HYozLkGnZSpnd0SCMZ
         nr6XRAI0Bp+97pN+FgTJwoZstljU2lwalLM4/D34ETnNDGYIu0u9drIZOm79XwzZgL
         WnLjqea5gCACicXdzUVfWvcDmxi/C65wCLMp5eo0=
Date:   Wed, 20 May 2020 18:36:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        GuoJia Liao <liaoguojia@huawei.com>
Subject: Re: [PATCH net-next 1/2] net: hns3: adds support for dynamic VLAN
 mode
Message-ID: <20200520183639.5e82bc09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <91bd81dc-5513-f717-559f-b225ab380fbc@huawei.com>
References: <1589937613-40545-1-git-send-email-tanhuazhong@huawei.com>
        <1589937613-40545-2-git-send-email-tanhuazhong@huawei.com>
        <20200520140617.6d8338bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <91bd81dc-5513-f717-559f-b225ab380fbc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 09:33:14 +0800 tanhuazhong wrote:
> On 2020/5/21 5:06, Jakub Kicinski wrote:
> > On Wed, 20 May 2020 09:20:12 +0800 Huazhong Tan wrote:  
> >> From: GuoJia Liao <liaoguojia@huawei.com>
> >>
> >> There is a scenario which needs vNICs enable the VLAN filter
> >> in access port, while disable the VLAN filter in trunk port.
> >> Access port and trunk port can switch according to the user's
> >> configuration.
> >>
> >> This patch adds support for the dynamic VLAN mode. then the
> >> HNS3 driver can support two VLAN modes: default VLAN mode and
> >> dynamic VLAN mode. User can switch the mode through the
> >> configuration file.  
> > 
> > What configuration file? Sounds like you're reimplementing trusted
> > VFs (ndo_set_vf_trust).
> >   
> 
> Hi, Jakub.
> 
> Maybe this configuration file here is a little misleading,
> this VLAN mode is decided by the firmware, the driver will
> query the VLAN mode from firmware during  intializing.

And the FW got that configuration from?

> I will modified this description in V2. BTW, is there any
> other suggestion about this patch?

The other suggestion was to trusted vf. What's the difference between
trusted VF and "dynamic VLAN mode"?

> >> In default VLAN mode, port based VLAN filter and VF VLAN
> >> filter should always be enabled.
> >>
> >> In dynamic VLAN mode, port based VLAN filter is disabled, and
> >> VF VLAN filter is disabled defaultly, and should be enabled
> >> when there is a non-zero VLAN ID. In addition, VF VLAN filter
> >> is enabled if PVID is enabled for vNIC.
> >>
> >> When enable promisc, VLAN filter should be disabled. When disable
> >> promisc, VLAN filter's status depends on the value of
> >> 'vport->vf_vlan_en', which is used to record the VF VLAN filter
> >> status.
> >>
> >> In default VLAN mode, 'vport->vf_vlan_en' always be 'true', so
> >> VF VLAN filter will set to be enabled after disabling promisc.
> >>
> >> In dynamic VLAN mode, 'vport->vf_vlan_en' lies on whether there
> >> is a non-zero VLAN ID.
> >>
> >> Signed-off-by: GuoJia Liao <liaoguojia@huawei.com>
> >> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>  

