Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259FD3A22C4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 05:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhFJD3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229557AbhFJD3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 23:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623295663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ngvdJHglrMNCCNHm8WER4c7hQ+rLR+jHQ96D4YhKKE=;
        b=de01V/QzoDr/rC71jZ0J5z1Aij+GqcDl7qiEbkf/mXkOIlMV8B81+qpE5M4FUHLTjSn/gj
        DW4SIclSRkvmGTvRsgDNtUnLL0QMggZGhHSN47B1R0t5lQ5lZkdei4xsUbMe2RsQNuwbDi
        bjCIKXTqtYA5RwEuBvR5iba2zF7WCl8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-1w5fOmyBPte9EG1LS04-Qw-1; Wed, 09 Jun 2021 23:09:10 -0400
X-MC-Unique: 1w5fOmyBPte9EG1LS04-Qw-1
Received: by mail-pf1-f199.google.com with SMTP id g19-20020a62e3130000b02902effdaa4a3eso399520pfh.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 20:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1ngvdJHglrMNCCNHm8WER4c7hQ+rLR+jHQ96D4YhKKE=;
        b=IoMJHi/7BuEwX1TZOThOy/xzsLZgWsHCmwBjSmt8/fFHPGcZsCPlG7gs3CjR03a3k0
         m+dy4bEh85vlp37iFudis74E2keb1c6s6354X9ReJjlIggEy80oCkHE/nkCvA9++DOkx
         BwgDxpAbqbXsjevNqzsptW4kSJpi1X4pFYzM6dNu5Rqec11r0HCleTG0NZeXke/5gL4u
         iqmsIRjiTl8SePrXEdlAf8IoxEgZ9z1IVKlR3N/q+qi8Me/+Gn78izJDbyBi9TUKsMJD
         xc1kLjFfYKWiMVOKgGcbCJN5fBoHC9VP2dGM6IwjXcPejyIrBEH4Eo4epz1vc7Cd3ONn
         afHA==
X-Gm-Message-State: AOAM532pLIkwGKlCehn9nCmrC47LHpH2MTnQFOV8OnpAvtAKdIML8utW
        RD3jXR4tVGqxyyf4+gNuLG8TlIuXfBxHwC0xtL1v1BuctEC9iFGH0guTWDY1O6vNR6NJ6PHoDoq
        HMhU0sU05QB0pLbSa
X-Received: by 2002:a62:2785:0:b029:2ec:b165:db1f with SMTP id n127-20020a6227850000b02902ecb165db1fmr876437pfn.34.1623294549240;
        Wed, 09 Jun 2021 20:09:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTx1TCfnzCzfCrV+6k8NpJrWucmB/2alu2rIatuf0k7S7sALfX7Pb2DwsMiwB8aX1kA9pwxQ==
X-Received: by 2002:a62:2785:0:b029:2ec:b165:db1f with SMTP id n127-20020a6227850000b02902ecb165db1fmr876421pfn.34.1623294548994;
        Wed, 09 Jun 2021 20:09:08 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15sm949356pgu.84.2021.06.09.20.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 20:09:08 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
Date:   Thu, 10 Jun 2021 11:09:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608170224.1138264-3-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/9 ÉÏÎç1:02, Tanner Love Ð´µÀ:
>   retry:
> -			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
> +			/* only if flow dissection not already done */
> +			if (!static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
> +			    !skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>   							      NULL, 0, 0, 0,
>   							      0)) {


So I still wonder the benefit we could gain from reusing the bpf flow 
dissector here. Consider the only context we need is the flow keys, we 
had two choices

a1) embed the vnet header checking inside bpf flow dissector
a2) introduce a dedicated eBPF type for doing that

And we have two ways to access the vnet header

b1) via pesudo __sk_buff
b2) introduce bpf helpers

I second for a2 and b2. The main motivation is to hide the vnet header 
details from the bpf subsystem.

Thanks

