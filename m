Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0C9DF8A3
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 01:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfJUX17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 19:27:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36942 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbfJUX17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 19:27:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id y5so9398524pfo.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 16:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WzXnfhMMbkyxsbipWZpmDaEvwrJstasCywDAINxmEVo=;
        b=NgmGbovCPleH2RLmDw5JhoDuEPGz4MOoogHyBtIP6mJ9Dcy6+emNzKGSxU3oVjAx0u
         A6Thotqa3AC+oXLpkNPc/k8nDI7mEP0DpWfEe9Ug5PITZjO8pgOe6BrQ+HXu7Lna4CyS
         vxUGrbn74CCKn00pPxuQ+8n+UoCFiicvHSud8wUsy9BVNHvJzV/pJYDRBkhb9QlqjriB
         0yBuHoBgdESlw55pEH5HDN4TnNcP6PEPc7Zm4zBmz+/mCm9G7uRFDDrbQIxhg6ek1+3Y
         rOVMVVFfOZa4CyAAMjflAmWWstpYjbWDxsE/u+E0FoZrJ7MkhAPIfM5NO2R14YoizbMq
         hhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WzXnfhMMbkyxsbipWZpmDaEvwrJstasCywDAINxmEVo=;
        b=eC24OIjG+BkiYaoxs3NVzchixaogvKbkTRuK4FrPDbn1ntnp/XfN0vhIjugTyM8q1+
         xVdiQcrZvRBJDup9a4fBC+cDq9zoq1qxUAw3mnhXjMrnGiRUeCJo4aEeRVTaEoFyc/e2
         qKNQLXkMvvj5fEfXpYmUl4+VpdU/HEb65J7bU5Vpj9+zadEbJFWAL9XFp4ZLOI/784i1
         +YC//auiSvXDm85E4wpb6V8RondKhAHHIoD4xw78x0V6U1SpYh5MFkBkIyiJykb1u5g5
         B3cs3CDLvaombmrCllc+qUQ9C64EfSYRO9K1OwjZ7eYb/Tv0acWxZGw282dDBJIrmSxJ
         J9WA==
X-Gm-Message-State: APjAAAXk115Bcfs9vlvfxfUl4yiK+JBbIfen06AxiIXqzm+cuBkDtKGw
        uVfhCIMTf12xhChtsRq/BjBbDg==
X-Google-Smtp-Source: APXvYqyFbqMB93ePo3KO7ai57nnAORUuMqwIhaAaU+w11quvMl42giRKuGVis1L3zububOtNf/9trg==
X-Received: by 2002:a63:f743:: with SMTP id f3mr427772pgk.410.1571700478697;
        Mon, 21 Oct 2019 16:27:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e17sm275837pgg.5.2019.10.21.16.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 16:27:58 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:27:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <dsahern@gmail.com>, <jiri@mellanox.com>,
        <allison@lohutok.net>, <mmanning@vyatta.att-mail.com>,
        <petrm@mellanox.com>, <dcaratti@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] net: vlan: reverse 4 bytes of vlan header when
 setting initial MTU
Message-ID: <20191021162751.1ccb251e@hermes.lan>
In-Reply-To: <1571660763-117936-1-git-send-email-linyunsheng@huawei.com>
References: <1571660763-117936-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 20:26:03 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> Currently the MTU of vlan netdevice is set to the same MTU
> of the lower device, which requires the underlying device
> to handle it as the comment has indicated:
> 
> 	/* need 4 bytes for extra VLAN header info,
> 	 * hope the underlying device can handle it.
> 	 */
> 	new_dev->mtu = real_dev->mtu;
> 
> Currently most of the physical netdevs seems to handle above
> by reversing 2 * VLAN_HLEN for L2 packet len.
> 
> But for vlan netdev over vxlan netdev case, the vxlan does not
> seems to reverse the vlan header for vlan device, which may cause
> performance degradation because vxlan may emit a packet that
> exceed the MTU of the physical netdev, and cause the software
> TSO to happen in ip_finish_output_gso(), software TSO call stack
> as below:
> 
>  => ftrace_graph_call
>  => tcp_gso_segment
>  => tcp4_gso_segment
>  => inet_gso_segment
>  => skb_mac_gso_segment
>  => skb_udp_tunnel_segment
>  => udp4_ufo_fragment
>  => inet_gso_segment
>  => skb_mac_gso_segment
>  => __skb_gso_segment
>  => __ip_finish_output
>  => ip_output
>  => ip_local_out
>  => iptunnel_xmit
>  => udp_tunnel_xmit_skb
>  => vxlan_xmit_one
>  => vxlan_xmit
>  => dev_hard_start_xmit
>  => __dev_queue_xmit
>  => dev_queue_xmit
>  => vlan_dev_hard_start_xmit
>  => dev_hard_start_xmit
>  => __dev_queue_xmit
>  => dev_queue_xmit
>  => neigh_resolve_output
>  => ip_finish_output2
>  => __ip_finish_output
>  => ip_output
>  => ip_local_out
>  => __ip_queue_xmit
>  => ip_queue_xmit
>  => __tcp_transmit_skb
>  => tcp_write_xmit
>  => __tcp_push_pending_frames
>  => tcp_push
>  => tcp_sendmsg_locked
>  => tcp_sendmsg
>  => inet_sendmsg
>  => sock_sendmsg
>  => sock_write_iter
>  => new_sync_write
>  => __vfs_write
>  => vfs_write
>  => ksys_write
>  => __arm64_sys_write
>  => el0_svc_common.constprop.0
>  => el0_svc_handler
>  => el0_svc  
> 
> This patch set initial MTU of the vlan device to the MTU of the
> lower device minus vlan header to handle the above case.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

The MTU is visible to user space in many tools, and Linux (and BSD)
have always treated VLAN header as not part of the MTU. You can't change
that now.

