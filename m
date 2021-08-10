Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E11C3E5DE6
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhHJO3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhHJO3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:29:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628605755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a5HPtj5FJajJtq7cTpyZIlPYjijGc0sARGJRC1gQ6JU=;
        b=GjL8JOjPQNl2dliGkcYTyuL1kaS6OYQO2IFwXPBN/8H6R4D4wq95gnFbr1ws4nnr5UYwtG
        VhCJnhWHIMzV5XPpWwJtQKCJDA5uJ4R01KCeocbYjHY1vMKsQX+0H4XGw74PKuKlCycMBh
        JrtmRHfj9biVOz42zk7LF8uh6LdyJLw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-30y-7esjOcCdiOFZYfwddQ-1; Tue, 10 Aug 2021 10:29:14 -0400
X-MC-Unique: 30y-7esjOcCdiOFZYfwddQ-1
Received: by mail-qk1-f198.google.com with SMTP id n71-20020a37274a0000b02903d24fa436e2so1229377qkn.3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 07:29:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a5HPtj5FJajJtq7cTpyZIlPYjijGc0sARGJRC1gQ6JU=;
        b=jMWMaE5YXffSfyYWTK9xq0Y1tXf1ldeFD0zIhHGYTHKm4+CsRUFMs2gpKEq0WMqFeH
         ovu1w1b6P5WwtdZLG5+MkxVE/0WafokYosPqr4f+z10zJiWkyAGECHWLW7W9CMXfr2z8
         9d9HZdqKgnLGxT9TNtJEUFK2BeNn4iPcvSESgYb+XKJhpBQ0JADPmz0X11VPAxeRtlLx
         fb6YBGwt3RE/5gn+rsRY0n+7vzBj+Ksu7eay8+WVbdo4peKEz80V0t66eAFF1qiHo10n
         RqySu2YavypPcU34IC/VQZp2CF0+VGYbPevxT+yJreqXpFr1w6B5H1EM5TwD2P985qAH
         zANw==
X-Gm-Message-State: AOAM531zcf0AYDNpHJl3eSP1nqcB6mLTb4C4Sv86kY0LC2rzimi2XJ48
        YhzDJiYsoTL7NGdz75m3LaERaBafWoal1gqcunWOu1SFGtCMeT2DfqgnuKvoI/EcKUkBOiGLtga
        YrrreZ7Xr4gMLV6ri
X-Received: by 2002:ae9:dc83:: with SMTP id q125mr22981409qkf.284.1628605754204;
        Tue, 10 Aug 2021 07:29:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOp1sLDoUfm3HQbjYvHObxtyLz/NZBYOU03WiawIFec+CXhcCMtOKkIeXUyazz/p0UzvCycA==
X-Received: by 2002:ae9:dc83:: with SMTP id q125mr22981395qkf.284.1628605754041;
        Tue, 10 Aug 2021 07:29:14 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id o139sm11140135qke.129.2021.08.10.07.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 07:29:13 -0700 (PDT)
Subject: Re: [PATCH net 3/4] ice: don't remove netdev->dev_addr from uc sync
 list
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        Liang Li <liali@redhat.com>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
 <20210809171402.17838-4-anthony.l.nguyen@intel.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <f6c250c2-392b-a898-9e03-167d771cad94@redhat.com>
Date:   Tue, 10 Aug 2021 10:29:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809171402.17838-4-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/21 1:14 PM, Tony Nguyen wrote:
> From: Brett Creeley <brett.creeley@intel.com>
> 
> In some circumstances, such as with bridging, it's possible that the
> stack will add the device's own MAC address to its unicast address list.
> 
> If, later, the stack deletes this address, the driver will receive a
> request to remove this address.
> 
> The driver stores its current MAC address as part of the VSI MAC filter
> list instead of separately. So, this causes a problem when the device's
> MAC address is deleted unexpectedly, which results in traffic failure in
> some cases.
> 
> The following configuration steps will reproduce the previously
> mentioned problem:
> 
>> ip link set eth0 up
>> ip link add dev br0 type bridge
>> ip link set br0 up
>> ip addr flush dev eth0
>> ip link set eth0 master br0
>> echo 1 > /sys/class/net/br0/bridge/vlan_filtering
>> modprobe -r veth
>> modprobe -r bridge
>> ip addr add 192.168.1.100/24 dev eth0
> 
> The following ping command fails due to the netdev->dev_addr being
> deleted when removing the bridge module.
>> ping <link partner>
> 
> Fix this by making sure to not delete the netdev->dev_addr during MAC
> address sync. After fixing this issue it was noticed that the
> netdev_warn() in .set_mac was overly verbose, so make it at
> netdev_dbg().
> 
> Also, there is a possibility of a race condition between .set_mac and
> .set_rx_mode. Fix this by calling netif_addr_lock_bh() and
> netif_addr_unlock_bh() on the device's netdev when the netdev->dev_addr
> is going to be updated in .set_mac.
> 
> Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Tested-by: Liang Li <liali@redhat.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Tested-by: Jonathan Toppins <jtoppins@redhat.com>

