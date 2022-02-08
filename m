Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191264AD340
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 09:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349344AbiBHIZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 03:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349670AbiBHIZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 03:25:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AA6EC0401F6
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 00:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644308750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vK6N04AyX07pMpT7bwBFBL+2ctaA8ouHGk0qanbWuN4=;
        b=NU4Uk+H6vDLPr9KtLjREbNbG4ed04M4vxojLvSIV07AhRSN9AspH74i9Nms3ItFmcahiGa
        hsmG9iyJpprrMcSQpd6NRvwPZQGQJfwFV7R8k7d0wbbzXCXzC5L66VRXdjVtjSkATSx+lV
        1KlMOUQjdrhqvtrqV5r5Zx04Kf359xs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-eoJ_WtgXOVyIgkSILBqmlA-1; Tue, 08 Feb 2022 03:25:49 -0500
X-MC-Unique: eoJ_WtgXOVyIgkSILBqmlA-1
Received: by mail-wr1-f72.google.com with SMTP id b8-20020adfc748000000b001e333edbe40so805901wrh.6
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 00:25:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vK6N04AyX07pMpT7bwBFBL+2ctaA8ouHGk0qanbWuN4=;
        b=D1d5COdN8Boiz8RjEn4y4Eu5zt6jGsiAHhwplea9QNkmHJNIJz/v49kk3uDKa8MBzO
         q6KeFE+3uy39sZjmllOaU5EzXQV+fkJD2ty8EUFCq+iWKOM+tsn5SV10JenprEw4+H4N
         GLTWhWfcHj1uUT3YbDc3sKILLa/n3d/+nfbVca+OXC4z9AJT9E1PFlIFhsBL4FU+p86N
         9enPYkDIJuTqmmpgCvOeOoIlRonl4Rx+gpEKsD1qN3qdZlxDdbbdrUSeyVgXqpfwjK8d
         Z2lwtweG8paeN7h+Z8QhSnQuennQt7YuK9CFJQNoMu6gMdRcq1OOrKv7VrTplrXLxyuv
         LDLA==
X-Gm-Message-State: AOAM5302xIOHHKwgRMqbvePIW+U2gLFZoglDLDNI8BA9/xL5VBqKX7pL
        hjgChklK/H+rVdJmp9DeoXQqFOBDUKkI6m2WqMhwwUlqGIK9DxXiCMV2crL3oULK86C5IJ16QpC
        /2creSI5peHEsR0iP
X-Received: by 2002:a1c:f004:: with SMTP id a4mr92387wmb.1.1644308747831;
        Tue, 08 Feb 2022 00:25:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwcIp4GwwlLjr351VgLNGexExdoCChF42UovxVNCbQl1Hb3RiYgQkMtyyft5+2jnWx1EvDaA==
X-Received: by 2002:a1c:f004:: with SMTP id a4mr92362wmb.1.1644308747614;
        Tue, 08 Feb 2022 00:25:47 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id e17sm13943510wrt.27.2022.02.08.00.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 00:25:47 -0800 (PST)
Message-ID: <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
Subject: Re: [PATCH] net: fix wrong network header length
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, maze@google.com,
        willemb@google.com, edumazet@google.com
Date:   Tue, 08 Feb 2022 09:25:45 +0100
In-Reply-To: <20220208025511.1019-1-lina.wang@mediatek.com>
References: <20220208025511.1019-1-lina.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-02-08 at 10:55 +0800, Lina Wang wrote:
> When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is enable,
> several skbs are gathered in skb_shinfo(skb)->frag_list. The first skb's
> ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
> network_header\transport_header\mac_header have been updated as ipv4 acts,
> but other skbs in frag_list didnot update anything, just ipv6 packets.
> 
> udp_queue_rcv_skb will call skb_segment_list to traverse other skbs in
> frag_list and make sure right udp payload is delivered to user space.
> Unfortunately, other skbs in frag_list who are still ipv6 packets are
> updated like the first skb and will have wrong transport header length.
> 
> e.g.before bpf_skb_proto_6_to_4,the first skb and other skbs in frag_list
> has the same network_header(24)& transport_header(64), after
> bpf_skb_proto_6_to_4, ipv6 protocol has been changed to ipv4, the first
> skb's network_header is 44,transport_header is 64, other skbs in frag_list
> didnot change.After skb_segment_list, the other skbs in frag_list has
> different network_header(24) and transport_header(44), so there will be 20
> bytes difference,that is difference between ipv6 header and ipv4 header.

> Actually, there are two solutions to fix it, one is traversing all skbs
> and changing every skb header in bpf_skb_proto_6_to_4, the other is
> modifying frag_list skb's header in skb_segment_list. 

I don't think the above should be addressed into the GSO layer. The
ebpf program is changing the GRO packet in arbitrary way violating the
GSO packet constraint - arguably, it's corrupting the packet.

I think it would be better change the bpf_skb_proto_6_to_4() to
properly handle FRAGLIST GSO packets.

If traversing the segments become too costly, you can try replacing
GRO_FRAGLIST with GRO_UDP_FWD.

Thanks!

Paolo

