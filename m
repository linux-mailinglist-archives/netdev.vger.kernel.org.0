Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7B2440AD5
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 19:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhJ3SCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 14:02:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39544 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhJ3SCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 14:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gB+wpIJ8U1ArrgXfdajBIfT47rGQFWUIErmrElea+Qw=; b=KL/hEVst2i4Ix1e7CMe5k/UN/v
        uIPBIXPwWfccsHWdUAIAMDxaDbc8X73PI40+Y5EK1w+8rs5C47LZJZ0h9U4Q2weAobmoLlOh+fObl
        N51YmHkzeDOa9+IY08D6LY2SDVwGzvMJYaIOYgbbOGkMxC2js7JrmkmJkVkPPPR0AE4Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mgsd5-00CBqy-JK; Sat, 30 Oct 2021 19:58:55 +0200
Date:   Sat, 30 Oct 2021 19:58:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V5 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
Message-ID: <YX2H3yN2tJXKt+ai@lunn.ch>
References: <20211030131001.38739-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030131001.38739-1-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Rx buf len is buffer length of each rx BD. Use ethtool -g command to get
> it, and ethtool -G command to set it, examples are as follow:
> 
> 1. set rx buf len to 4096
> $ ethtool -G eth1 rx-buf-len 4096
> 
> 2. get rx buf len
> $ ethtool -g eth1
> ...
> RX Buf Len:     4096

How does this interact with MTU? If i have an MTU of 1500, and i set
the rx-buf-len to 1000, can i expect all frames to the discarded?
Should the core return -EINVAL? Or do you think some hardware will
simply allocate two buffers and scatter/gather over them? Which
implies that drivers which cannot SG must check if the rx-buf-len is
less than the MTU and return -EINVAL?

     Andrew
