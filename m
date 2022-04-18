Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5593504C66
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 07:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiDRFvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 01:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiDRFvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 01:51:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68682167D3
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 22:48:43 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q19so17033990pgm.6
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 22:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j96XH3Dmbi26dxD+JATf6BURmTD2c8HN91xbkVbh2po=;
        b=OxceYtRLVE3XIAWwsHXKYktxfaEM7/gwDeUDTsJzEFuhOTe+lQfGxa6f2yBYGjDT05
         KIl80/6RmV0ENPCyLpnVWMDfuA/o1UUpxEBXMMj2jhENoA3GvFgxk4E+oQj9MQlqYec9
         RvzgJuV+Im9UyNPtjvLp9mV+qIYf0+YAiqV5I4QugmoBW4fTLYMEdg2HfU9fP9BatjTk
         lB6OXLBMwi77MgpkRGYj8g0KZC3KfymKUB1VhfxPSiLhQW1uOA8MpgIPivy+WIxmc+cx
         501tx51aIrbaMGwX0oU41re6tFEgvGr+FDRFEGF8Qds1h8ZI2g5bGSdfHRsLCer4DF88
         JjUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j96XH3Dmbi26dxD+JATf6BURmTD2c8HN91xbkVbh2po=;
        b=XbHgX0aZtwPhyMp3tw74YP1jTg+dt7MMPkGkxtvAls+jlJKn6TVapktiZL4NWqaxGK
         oE73NtetK1xVNjt9Am02DrxFaNtmSYffpqpSdtLc1IYz995quVcfCuW11nSsDcf5OzX9
         WGu3z0jJvce5iaFsukrHTeCPFJCR5C72crMBMUzBo/zwpkpAHjvc14aIxzf+tQwC5b/b
         OMvK0PEp9VG1KJ5ZWS6GvGrq4tjQpprKCnyp+UZnPq9bV8CsG+z57R+5GUh1llMDNJeX
         +0b0PePtwOdEAiBqIrpERs9DBQmqoarzg0oxgGTMGw3WAM1TCsgfwn3DajryvemwBS6S
         c7mw==
X-Gm-Message-State: AOAM5315Bzs4iwyqsv7WKfYoeqW4YMJJt5cUsLhVdnPKICIR5Kbuxpni
        0NnQuW20anwM+rrPqtyxIYApKXlrwks=
X-Google-Smtp-Source: ABdhPJztw7j8YswdjOn3Zz4zfbyZGnvSCYyzny5Ig0HvH8+f01VQnn5NXtzwPa2bxJpsSJaSHU4KBg==
X-Received: by 2002:a05:6a00:bd1:b0:4fa:a5d7:c082 with SMTP id x17-20020a056a000bd100b004faa5d7c082mr10527180pfu.85.1650260922684;
        Sun, 17 Apr 2022 22:48:42 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o34-20020a634e62000000b0039cc4376415sm11275062pgl.63.2022.04.17.22.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 22:48:42 -0700 (PDT)
Date:   Mon, 18 Apr 2022 13:48:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net 0/2] net: fix kernel dropping GSO tagged packets
Message-ID: <Ylz7s/I8EUca82NL@Laptop-X1>
References: <20220418044339.127545-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418044339.127545-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, cc Mick for the correct address

On Mon, Apr 18, 2022 at 12:43:37PM +0800, Hangbin Liu wrote:
> Flavio reported that the kernel drops GSO VLAN tagged packet if it's
> created with socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
> 
> The reason is AF_PACKET doesn't adjust the skb network header if there is
> a VLAN tag. And in virtio_net_hdr_to_skb() it also checks skb->protocol
> blindly and not take care of VLAN tags.
> 
> The first patch adjust the network header position for AF_PACKET VLAN
> tagged packets. The second patch fixes the VLAN protocol checking in
> virtio_net_hdr_to_skb().
> 
> Hangbin Liu (2):
>   net/af_packet: adjust network header position for VLAN tagged packets
>   virtio_net: check L3 protocol for VLAN packets
> 
>  include/linux/virtio_net.h | 26 +++++++++++++++++++-------
>  net/packet/af_packet.c     | 18 +++++++++++++-----
>  2 files changed, 32 insertions(+), 12 deletions(-)
> 
> -- 
> 2.35.1
> 
