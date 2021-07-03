Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B23BA78E
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 08:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhGCGk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 02:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhGCGk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 02:40:27 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFB7C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 23:37:53 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 62so4117418pgf.1
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 23:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kPmM0qinLJ8na3gWM6Uf/E9DwBH1wNRut0xI6oRNTzo=;
        b=F4WvyAQ+b/JCUbISfeVgg0jP/xWSM0rPGQu2dBDOH6E4BJ15gelzX5ktkHex6eIwip
         ZDAaRzapPcmI59Humu7exhfMsSKSs4ZMFnNY8LszEnzLGbZUxPE5G0WBCH246rEpU/36
         JVWNWBF4zNbUEqISjT9o3HEBIGOBMgo2owRUgRz2EDOfH4T5MEKjC4CFHTBrte9B0CHc
         eSAeVVyJsawzkWekJGSe6JbUtYSm4Tuhz6+nerLXU7Lc1WX8x6xtwL9wK9MlYBCz5Jhz
         ArqUOtKmUaOfrxeEC77/HI5YghEU3wKWO42O5qX1YlLBFz4919aRcKb6UGb7nYA8v/sj
         hHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPmM0qinLJ8na3gWM6Uf/E9DwBH1wNRut0xI6oRNTzo=;
        b=rrF4J6SSrhukGqYqTCGeZRajbG3kMxFKGMb4pBxPyaYw3jitMnHWE7LsUEqBfWCD+4
         zY0RS7BtJG6P/lFctvYJW+o272R8KTxpLKj6FpV6aTXYRJuIRYd1aewJrRpW83+wN6Pr
         1W4piqIrq4WYc5TJu92zA2TOBPqqF25ywCw2bdfcm8GAxJ+CvFSdkUzs4unWxHSdbEro
         suozHONMhIb1ArqLtKQIxVJkquz5/VoGLoY+hfstz0Vhpo0MCwEfh308u7KB8Yqllc4X
         0Y7yswGtqG4KKpd07mKNYvpJ/K4wJhbVS1jwXv7mM64eq6noeztY+SvCJ1wg0PBVjxGS
         HsoA==
X-Gm-Message-State: AOAM533fZWyWX6LJ7lNEgMKaXHh1YdTvIloYUqIVoaYv2L0RbFy/Hcpq
        ZQXF902rdZuA/60UoSFhKeg=
X-Google-Smtp-Source: ABdhPJw/YceierdDjCSnrf8pnkzyeG2vdUx2HVSaBSWuBA6mrC+rC3S2zx9k9cQltwDqt0WLBMk6mQ==
X-Received: by 2002:a65:648f:: with SMTP id e15mr3870824pgv.165.1625294272800;
        Fri, 02 Jul 2021 23:37:52 -0700 (PDT)
Received: from [172.30.1.44] ([211.250.74.184])
        by smtp.gmail.com with ESMTPSA id p29sm5544713pfq.55.2021.07.02.23.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 23:37:52 -0700 (PDT)
Subject: Re: [PATCH net 6/8] bonding: disallow setting nested bonding + ipsec
 offload
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
References: <20210702142648.7677-1-ap420073@gmail.com>
 <20210702142648.7677-7-ap420073@gmail.com> <14149.1625260463@famine>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <27082299-0436-2f95-11b9-9ba7077f165e@gmail.com>
Date:   Sat, 3 Jul 2021 15:37:48 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <14149.1625260463@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jay,
Thank you for your review!

On 7/3/21 6:14 AM, Jay Vosburgh wrote:
 > Taehee Yoo <ap420073@gmail.com> wrote:
 >
 >> bonding interface can be nested and it supports ipsec offload.
 >> So, it allows setting the nested bonding + ipsec scenario.
 >> But code does not support this scenario.
 >> So, it should be disallowed.
 >>
 >> interface graph:
 >> bond2
 >> |
 >> bond1
 >> |
 >> eth0
 >>
 >> The nested bonding + ipsec offload may not a real usecase.
 >> So, disallowing this is fine.
 >
 > 	Is a stack like "bond1 -> VLAN.XX -> bond2 -> eth0" also a
 > problem?  I don't believe the change below will detect this
 > configuration.
 >

Except bonding, all kind of virtual interfaces(vlan, team, etc) doesn't 
support ipsec offload.
It means these interfaces' xfrmdev_ops pointer is null.
So, configuration always will be failed at the following line.
         if (!slave->dev->xfrmdev_ops || 

             !slave->dev->xfrmdev_ops->xdo_dev_state_add || 

Only checking the real interface's type is enough.
So, bond1 can't set up ipsec offload but bond2 can set up ipsec offload.


Thanks a lot!
Taehee

 > 	-J
 >
 >> Fixes: 18cb261afd7b ("bonding: support hardware encryption offload 
to slaves")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >> ---
 >> drivers/net/bonding/bond_main.c | 15 +++++++++------
 >> 1 file changed, 9 insertions(+), 6 deletions(-)
 >>
 >> diff --git a/drivers/net/bonding/bond_main.c 
b/drivers/net/bonding/bond_main.c
 >> index 7659e1fab19e..f268e67cb2f0 100644
 >> --- a/drivers/net/bonding/bond_main.c
 >> +++ b/drivers/net/bonding/bond_main.c
 >> @@ -419,8 +419,9 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 >> 	xs->xso.real_dev = slave->dev;
 >> 	bond->xs = xs;
 >>
 >> -	if (!(slave->dev->xfrmdev_ops
 >> -	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
 >> +	if (!slave->dev->xfrmdev_ops ||
 >> +	    !slave->dev->xfrmdev_ops->xdo_dev_state_add ||
 >> +	    netif_is_bond_master(slave->dev)) {
 >> 		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec 
offload\n");
 >> 		rcu_read_unlock();
 >> 		return -EINVAL;
 >> @@ -453,8 +454,9 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 >>
 >> 	xs->xso.real_dev = slave->dev;
 >>
 >> -	if (!(slave->dev->xfrmdev_ops
 >> -	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
 >> +	if (!slave->dev->xfrmdev_ops ||
 >> +	    !slave->dev->xfrmdev_ops->xdo_dev_state_delete ||
 >> +	    netif_is_bond_master(slave->dev)) {
 >> 		slave_warn(bond_dev, slave->dev, "%s: no slave 
xdo_dev_state_delete\n", __func__);
 >> 		goto out;
 >> 	}
 >> @@ -479,8 +481,9 @@ static bool bond_ipsec_offload_ok(struct sk_buff 
*skb, struct xfrm_state *xs)
 >> 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
 >> 		return true;
 >>
 >> -	if (!(slave_dev->xfrmdev_ops
 >> -	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
 >> +	if (!slave_dev->xfrmdev_ops ||
 >> +	    !slave_dev->xfrmdev_ops->xdo_dev_offload_ok ||
 >> +	    netif_is_bond_master(slave_dev)) {
 >> 		slave_warn(bond_dev, slave_dev, "%s: no slave 
xdo_dev_offload_ok\n", __func__);
 >> 		return false;
 >> 	}
 >> --
 >> 2.17.1
 >>
 >
 > ---
 > 	-Jay Vosburgh, jay.vosburgh@canonical.com
 >
