Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D07BA6784
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 13:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfICLhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 07:37:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33647 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfICLhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 07:37:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so5554944pfl.0
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 04:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SyZ0OnaiZxTBRVMhjHHgMsFegnhPy0MogSls5tEiHGc=;
        b=PCbMZkclPJadTAOOHSEcUTF06VCwXWf6a9bM3v0a3BGXaVhqGf/g6hwbDWYFtBhLiH
         KzFhjJrq7C7AQMcY4dYhlrHNGeTIvDH4v2c8xdYIGg61mAj/ZFkQzOAtN1pajDd5eytQ
         DcP9hitP2lqkZAJKlnvA5x9h3Pwrg7cfZJzgsY2u3X2msITFOX3iz9zKGOpOL70RpG8G
         wTfEmcpldaaLLbwQOvAWk7EOiq+Ahq/SUo4MeVtojb+MAliLDqk3bGWSFNVTGNryIla9
         PtwhUMDbbdi3JDaF8ahi2WBdQk8ktFQc8ObiGP3eumjd/nV2c9mwcnXFmG+3zPNGnJw5
         1IiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SyZ0OnaiZxTBRVMhjHHgMsFegnhPy0MogSls5tEiHGc=;
        b=NKRCQIk2cOdnnOZInyFJ2KOfojXl31nQjfNMtxO1Mktsg3uQ9+C6fMevfJM8nZduwi
         zTh6seAi0fdmX/Dt2OQPGPnKWahm3iQrhHLdnrmkfgaEUloOLgEDsL83rkgefnTEzsiF
         s6sihRSXyoE6yfJ0Ab6peoHlEjVKit3wWnjCA1hAhWhD8x0T31AgJKvIOMVQxdxKTERG
         K8oklDzxIS/80lyenSdarArt8N35M8m9Wzg6FBp2L0ofxUbBX0yCFuu8yytNBdAWd1Xt
         1AMyB67IJGpLqD/OhSyPmUCB/1Q/HXHqD5dCUKrQcZfGA1mXiqt+4RGA0UmQYnZoy3hy
         ZjEg==
X-Gm-Message-State: APjAAAWt3YQxS7JBVA3/byN07Ys/BscEIQ6VfPnONWYlc/j6T5jpZe0R
        nxZFgbRSaytgxOIPz6qtX0E=
X-Google-Smtp-Source: APXvYqzWmYGPm+sr1wQUxGBvk6ZpuZw7Er4EgVJI8w8NPhXlZ0cREGEKXy9Gj+Q4Wt6t7Tx2oQ0diQ==
X-Received: by 2002:a62:2a55:: with SMTP id q82mr36416188pfq.23.1567510662675;
        Tue, 03 Sep 2019 04:37:42 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id j1sm18383866pfh.174.2019.09.03.04.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 04:37:42 -0700 (PDT)
Subject: Re: [Bridge] [PATCH v3 1/2] net: bridge: use mac_len in bridge
 forwarding
To:     Zahari Doychev <zahari.doychev@linux.com>, netdev@vger.kernel.org
Cc:     makita.toshiaki@lab.ntt.co.jp, jiri@resnulli.us,
        nikolay@cumulusnetworks.com, simon.horman@netronome.com,
        roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        jhs@mojatatu.com, dsahern@gmail.com, xiyou.wangcong@gmail.com,
        johannes@sipsolutions.net, alexei.starovoitov@gmail.com
References: <20190902181000.25638-1-zahari.doychev@linux.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <76b7723b-68dd-0efc-9a93-0597e9d9b827@gmail.com>
Date:   Tue, 3 Sep 2019 20:37:36 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190902181000.25638-1-zahari.doychev@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zahari,

Sorry for reviewing this late.

On 2019/09/03 3:09, Zahari Doychev wrote:
...
> @@ -466,13 +466,14 @@ static bool __allowed_ingress(const struct net_bridge *br,
>   		/* Tagged frame */
>   		if (skb->vlan_proto != br->vlan_proto) {
>   			/* Protocol-mismatch, empty out vlan_tci for new tag */
> -			skb_push(skb, ETH_HLEN);
> +			skb_push(skb, skb->mac_len);
>   			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
>   							skb_vlan_tag_get(skb));

I think we should insert vlan at skb->data, i.e. mac_header + mac_len, while this
function inserts the tag at mac_header + ETH_HLEN which is not always the correct
offset.

>   			if (unlikely(!skb))
>   				return false;
>   
>   			skb_pull(skb, ETH_HLEN);

Now skb->data is mac_header + ETH_HLEN which would be broken when mac_len is not
ETH_HLEN?

> +			skb_reset_network_header(skb);
>   			skb_reset_mac_len(skb);
>   			*vid = 0;
>   			tagged = false;
> 

Toshiaki Makita
