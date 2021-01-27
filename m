Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C655306711
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 23:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhA0WOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbhA0WOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 17:14:19 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254E4C061574;
        Wed, 27 Jan 2021 14:13:39 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id l4so3392379ilo.11;
        Wed, 27 Jan 2021 14:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xa7nRNjq1wJ5kQJYYd5JBChxKARpHSYKRDqrITeShYA=;
        b=nfcpcUHyTzVfp3Z8xkRgDK2viuU/0t13bo+MsZLIoSf75PFBpfG7ilGF6vG/KkhjZ8
         2SO14wKd3bL7PABZMr3bHvRu3atbZJSXt+RCdtXxdFOp5tBYcfq9HbYCTmJmZgRLvSdw
         Ezw2Bzcqdy4ACthD4XB+Kue3VTOovQH8CymQPTdph8WTUiFVox1tCMToYpP78Wo0tt3H
         FNHjEgc5ESnU/rfquVVskO3/rqTcipysk8oDdqQaFeM9f7H1GCUKW0q+zM6VWkM046tj
         VptRl0nA8rhrQk8vn8taQhoZVHOub4gpc1ubuQRUWZbbEWOcAakYSjm/EIDVZnvKQ/2Y
         mE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xa7nRNjq1wJ5kQJYYd5JBChxKARpHSYKRDqrITeShYA=;
        b=c5h66Op0Zs3sTfyLe7qaSV4H6PF/a7htIc+9VsZpAzo1peiah1oVcnUItQw6gsxhZX
         5N5CPwB+UBWfxjgoQa7T0LVMMyFzco2x1R053I2QTwRGgZqA9x1b6USAyBpg5e9V4kdZ
         5DibHv/zOvOM+XLxaKzrJo4A6BMz7afrkjbg9bcJD9mI2XLsHGSM+OiaZ6nfRNfvY0vv
         p4PQc7CBTY2IsZl3CPUqS2g2xWzSDnNrfzVXthfM2gAlsEf1Xym1uX1Yx5EHekTV6g+x
         VY9XPD2z+nTNuQw9Xsx2bMcsvA3XU9rLrXG0oh2l2EihMRv+tE7EbmXdagohdsDP624Z
         DJiA==
X-Gm-Message-State: AOAM530Opb6WdA+DyYGBOWYktsrvLgcFBnH3/NleBsysIE43ZhAVqdQP
        Rp7JogQhzb52rwXrxff5ue8=
X-Google-Smtp-Source: ABdhPJyM6/UKcyxl+/mRUkSG2U0cru4QiI0f2p+p36a+MkcFE7OXn4NrrO2EI+kV2udKrgeQ5I1fYQ==
X-Received: by 2002:a05:6e02:1aa5:: with SMTP id l5mr10309934ilv.278.1611785618578;
        Wed, 27 Jan 2021 14:13:38 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id x1sm1504076ioj.55.2021.01.27.14.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 14:13:37 -0800 (PST)
Date:   Wed, 27 Jan 2021 14:13:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <6011e589466f_a0fd920840@john-XPS-13-9370.notmuch>
In-Reply-To: <20210122074652.2981711-4-liuhangbin@gmail.com>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210122074652.2981711-4-liuhangbin@gmail.com>
Subject: RE: [PATCHv16 bpf-next 3/6] xdp: add a new helper for dev map
 multicast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> This patch is for xdp multicast support. which has been discussed
> before[0], The goal is to be able to implement an OVS-like data plane in
> XDP, i.e., a software switch that can forward XDP frames to multiple ports.
> 
> To achieve this, an application needs to specify a group of interfaces
> to forward a packet to. It is also common to want to exclude one or more
> physical interfaces from the forwarding operation - e.g., to forward a
> packet to all interfaces in the multicast group except the interface it
> arrived on. While this could be done simply by adding more groups, this
> quickly leads to a combinatorial explosion in the number of groups an
> application has to maintain.
> 
> To avoid the combinatorial explosion, we propose to include the ability
> to specify an "exclude group" as part of the forwarding operation. This
> needs to be a group (instead of just a single port index), because a
> physical interface can be part of a logical grouping, such as a bond
> device.
> 
> Thus, the logical forwarding operation becomes a "set difference"
> operation, i.e. "forward to all ports in group A that are not also in
> group B". This series implements such an operation using device maps to
> represent the groups. This means that the XDP program specifies two
> device maps, one containing the list of netdevs to redirect to, and the
> other containing the exclude list.
> 
> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
> to accept two maps, the forwarding map and exclude map. The forwarding
> map could be DEVMAP or DEVMAP_HASH, but the exclude map *must* be
> DEVMAP_HASH to get better performace. If user don't want to use exclude
> map and just want simply stop redirecting back to ingress device, they
> can use flag BPF_F_EXCLUDE_INGRESS.
> 
> As both bpf_xdp_redirect_map() and this new helpers are using struct
> bpf_redirect_info, I add a new ex_map and set tgt_value to NULL in the
> new helper to make a difference with bpf_xdp_redirect_map().
> 
> Also I keep the general data path in net/core/filter.c, the native data
> path in kernel/bpf/devmap.c so we can use direct calls to get better
> performace.
> 
> [0] https://xdp-project.net/#Handling-multicast
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 

Thanks for the updates.

Acked-by: John Fastabend <john.fastabend@gmail.com>
