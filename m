Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9444D46D4BD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 14:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhLHNvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 08:51:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231571AbhLHNvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 08:51:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638971261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WgXBhT10uUPntd9D3XCgnudzdibRWkPr5w60jBLDpjI=;
        b=OOuiwV1WCP7fx6zHQitHozYfM6nr5LVVrRVBdfH3QjhZbsXiM45Y+1WzgqV8PACqHTRn1k
        tSPkEZXej0kSlNibXi09Yr/STNq7RnbPxtsGt2jFQ6Fl4v8OjGiHJgHyr7JL3SMC37dRYD
        pQ2yboET3ZDazpu5GkYbJZWa7SKwzr8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-tcGq3DedPECzE60kuK-pmg-1; Wed, 08 Dec 2021 08:47:40 -0500
X-MC-Unique: tcGq3DedPECzE60kuK-pmg-1
Received: by mail-lf1-f69.google.com with SMTP id k10-20020ac2456a000000b0041bd7b22c6fso1106141lfm.21
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 05:47:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=WgXBhT10uUPntd9D3XCgnudzdibRWkPr5w60jBLDpjI=;
        b=ira1sscEWmwhFQG1PdvheBHjHQht31eOZCYEBnrFBBmKLjuAdystvmaJAgvH62AiPX
         j3tr8Uj4om/hfDfVG2AqoeDN4nQnpRvwzBYFP7DtbndLB6Pg0A4d5U0Tqq0MLAfqroa1
         vKtlVY+T4/3ofE6dVy+JwyBq2u3s2A6fBBDzp0smaeS9BW8OphftrXm9WxReVc2VDVtI
         oBLqrXOnXhdZrpbz7h1Vfb0t6yI3ReVHrovN/tTU59EgJy837b7+T2JSccjflI2hF/Tk
         IBBwYfCqWrmVagOCALTrmyr0BuO7e7nN+fwVRw7+dtlmnejPgXVm10pd3BeeNvJtrzFR
         Knbg==
X-Gm-Message-State: AOAM533oIjJ/tkamS9yqA+S5xBh1T7KuQlWHmFl0cYAtZZHFBXeRjnfH
        qyl6d4ipT6NurLt1xKr7QAlwYscCbDulIzzBFzZo1DCll8GMsU2zrSACXZJHV7KOiX/8THr+Crq
        LFkWKB/y3hPpCrFla
X-Received: by 2002:a05:6512:33c4:: with SMTP id d4mr44446293lfg.182.1638971258512;
        Wed, 08 Dec 2021 05:47:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBhIOzFBLL6AjKxPyHM2J++Vww0G7j189KtWPTFzpPdI2id9zE+pRzYQH9ANJkJY/Y/JcAlA==
X-Received: by 2002:a05:6512:33c4:: with SMTP id d4mr44446255lfg.182.1638971258261;
        Wed, 08 Dec 2021 05:47:38 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id k8sm259731lfv.179.2021.12.08.05.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 05:47:37 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <87463ddc-bf93-99cc-65d1-cbc215125ec3@redhat.com>
Date:   Wed, 8 Dec 2021 14:47:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3 net-next 9/9] i40e: respect metadata on XSK Rx to skb
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org
References: <20211207205536.563550-1-alexandr.lobakin@intel.com>
 <20211207205536.563550-10-alexandr.lobakin@intel.com>
In-Reply-To: <20211207205536.563550-10-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/12/2021 21.55, Alexander Lobakin wrote:
> For now, if the XDP prog returns XDP_PASS on XSK, the metadata will
> be lost as it doesn't get copied to the skb.
> Copy it along with the frame headers. Account its size on skb
> allocation, and when copying just treat it as a part of the frame
> and do a pull after to "move" it to the "reserved" zone.
> net_prefetch() xdp->data_meta and align the copy size to speed-up
> memcpy() a little and better match ixgbee_costruct_skb().
                                      ^^^^^^^^^^^^^^^^^^^
Misspelling function name.

> 
> Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)

Wrong driver (i40e:) "tagged" in subject.

