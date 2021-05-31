Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29A23967BF
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 20:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhEaSWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 14:22:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231997AbhEaSW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 14:22:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622485246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4POkak3F8ARUexGXSTi92lWdtKSIJwxYMXY8qwxnllY=;
        b=QtQwDhXajqTGNu3DkXDdJOpdYrcWQG0H1kw0/lAgyX/m6NK4c8rwaUxyORd9m6sg9L0E48
        pBFUfumHfGro6y6FyXslv3j0Tu2KZnt8yESb0/YuzBW4Y8NyHRzuoeQEyZYxV1BgcCsWs2
        TrsWH9/vncSNVHj6+7ljQMrTexoji2A=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-VlGnAEMPPomvmzbbxqlFPQ-1; Mon, 31 May 2021 14:20:44 -0400
X-MC-Unique: VlGnAEMPPomvmzbbxqlFPQ-1
Received: by mail-il1-f200.google.com with SMTP id w10-20020a056e021c8ab02901bb7c1adfa1so8499090ill.3
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 11:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=4POkak3F8ARUexGXSTi92lWdtKSIJwxYMXY8qwxnllY=;
        b=NgyG2rm0FlYi8sLFshcKbgSREt9t2tA/4aqQ12T/MVWedpKVsUuxHGRaHkgzZ8RCan
         DHOL6qTLGpt+h6T2j/iYle9LJA/Sy99VPmr3z6dvPdx2kLiJiVXNvh67uJEt92m3YueH
         zY2/mXXoiSf/wzlwS7xU/KbG2SqPmCqjfGlUjMYgmMHmgU76TurRZw07lqftVAAmRGY4
         vhi48bKkEkEY/NDNu988kuyzL+Tx99B0vY86VHv6fCGjrc73P7a0IEMscT3tcTPJdaio
         fq/eBQAvCdLnd82wJ1EYtc5xiWYx8XkwUug3b8JSWuvkXV/Z37V36y/irIcNrgtXEFyb
         OCxw==
X-Gm-Message-State: AOAM531Pa8Alk30hRIJyiJr07j3e53OtNzFxfpArNPoL9Ha1CxSgDsif
        hH073z/g7mOA+o+drK6M5VXmwEwfDevYDch45/0/9hvnG6EWtkR8d277LVz+MQ1r4h4J2aq4Ksc
        uKMciuFJYITDNHlMJcWCEqQz1jBickRgj
X-Received: by 2002:a02:ac82:: with SMTP id x2mr3626545jan.53.1622485244292;
        Mon, 31 May 2021 11:20:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzprnlanFXu29pY//nty7/iCHvIPoYG8W0RhU1hlfLUju+ot1kV7bI4YJ9/3GAV1WQoBrX3/Z0hhNxFhLBX38g=
X-Received: by 2002:a02:ac82:: with SMTP id x2mr3626532jan.53.1622485244073;
 Mon, 31 May 2021 11:20:44 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 31 May 2021 18:20:43 +0000
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
MIME-Version: 1.0
In-Reply-To: <20210531124607.29602-1-simon.horman@corigine.com>
Date:   Mon, 31 May 2021 18:20:43 +0000
Message-ID: <CALnP8ZZyckUuefLMf+oS4m5OE_PJc6+RvLh_9w81MmKFNpoQrw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/8] Introduce conntrack offloading to the nfp driver
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 02:45:59PM +0200, Simon Horman wrote:
> Louis Peens says:
>
> This is the first in a series of patches to offload conntrack
> to the nfp. The approach followed is to flatten out three
> different flow rules into a single offloaded flow. The three
> different flows are:
>
> 1) The rule sending the packet to conntrack (pre_ct)
> 2) The rule matching on +trk+est after a packet has been through
>    conntrack. (post_ct)

I think this part (matching on +trk+est) was left to another series,
but anyway, supporting only +trk+est is not very effective, btw.
+rpl/-rpl is also welcomed.

> 3) The rule received via callback from the netfilter (nft)
>
> In order to offload a flow we need a combination of all three flows, but
> they could be added/deleted at different times and in different order.
>
> To solve this we save potential offloadable CT flows in the driver,
> and every time we receive a callback we check against these saved flows
> for valid merges. Once we have a valid combination of all three flows
> this will be offloaded to the NFP. This is demonstrated in the diagram
> below.
>
> 	+-------------+                      +----------+
> 	| pre_ct flow +--------+             | nft flow |
> 	+-------------+        v             +------+---+
> 	                  +----------+              |
> 	                  | tc_merge +--------+     |
> 	                  +----------+        v     v
> 	+--------------+       ^           +-------------+
> 	| post_ct flow +-------+       +---+nft_tc merge |
> 	+--------------+               |   +-------------+
> 	                               |
> 	                               |
> 	                               |
> 	                               v
> 	                        Offload to nfp

Sounds like the offloading of new conntrack entries is quite heavy
this way. Hopefully not.

>
> This series is only up to the point of the pre_ct and post_ct
> merges into the tc_merge. Follow up series will continue
> to add the nft flows and merging of these flows with the result
> of the pre_ct and post_ct merged flows.
>
> Changes since v1:
> - nfp: flower-ct: add ct zone table
>     Fixed unused variable compile warning
>     Fixed missing colon in struct description
>
> Louis Peens (8):
>   nfp: flower: move non-zero chain check
>   nfp: flower-ct: add pre and post ct checks
>   nfp: flower-ct: add ct zone table
>   nfp: flower-ct: add zone table entry when handling pre/post_ct flows
>   nfp: flower-ct: add nfp_fl_ct_flow_entries
>   nfp: flower-ct: add a table to map flow cookies to ct flows
>   nfp: flower-ct: add tc_merge_tb
>   nfp: flower-ct: add tc merge functionality
>
>  drivers/net/ethernet/netronome/nfp/Makefile   |   3 +-
>  .../ethernet/netronome/nfp/flower/conntrack.c | 486 ++++++++++++++++++
>  .../ethernet/netronome/nfp/flower/conntrack.h | 155 ++++++
>  .../net/ethernet/netronome/nfp/flower/main.h  |   6 +
>  .../ethernet/netronome/nfp/flower/metadata.c  | 101 +++-
>  .../ethernet/netronome/nfp/flower/offload.c   |  31 +-
>  6 files changed, 775 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>  create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.h
>
> --
> 2.20.1
>

