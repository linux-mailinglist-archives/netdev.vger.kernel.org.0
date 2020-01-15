Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA4713C9EF
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAOQsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:48:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33087 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgAOQsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:48:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so16475289wrq.0
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 08:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5kb/7FK3XFZ8+xw5shLPR//BFaG4pInBIKfPFR2hY4g=;
        b=uqm+2MKtoTBzJb3GSLyuiUONUpJRsCg1cMcU+lwCAzKjHST4HtfEK9z3ZvVqYMpxAQ
         GdINtR4/3MeWxpt2bt4ySpQePAS3PQjTlFkuAo8d3og3gW+iHs9zpA6Ncoh8B+h2ryxj
         3WQ8JtOeaiYkbINOVW9Jlmj9Tw2WpxwxoQ6qTgTfJOnl/noeBOioHommR+W205EIXQ2C
         wJfG/sw2lE2c5NbcPnKDMBCGVcdxp6jirAzfFg1ICmnpCXecEwucUc45bWQOykZ2dPLc
         mnSmeU8FX8Zgnfhaxt0p3qbdo/CoMzMK1ndkbkQVhgTbWVqv3/Fkir6baw179EJ20qG1
         mLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5kb/7FK3XFZ8+xw5shLPR//BFaG4pInBIKfPFR2hY4g=;
        b=idBPIZlAcaxKvZT739Ot0PvdsumGcQ66MU3IJr/VgXOl2Gi6gFjE7plv9hTrMIc/ox
         z5UQpYp7WI1i3yH9IUGXQvB9nGjKrzY9pF1xq1TABetiY7g6r2HjzV/usBdoUwhnj6xq
         Dtoql2K/wvOtjCqFpBc193P98WV8glNsrLGhwHhoQTvbJgTLmySypLXuP/TA4mHsK3dE
         BMn9+SlATNF0aFGWcvn/gCgWWmD0HQ7XfPI45U9AcYJ8ggFXFM0x/7ThSPu7phZObT+x
         h0A+wRc/WoXKb/uxKKETNCGxSQa2GqWD6rZkDeGIa9mGs93A/gjNuT0AAfoNoP1TCxHB
         geRg==
X-Gm-Message-State: APjAAAUFLyJXLX6M0F/YfT/TlW1cU3Qv+faN8JXT2d/y3isKW/3ZeWik
        07urD3j01eObeFx5hqO4HGzCdA==
X-Google-Smtp-Source: APXvYqysm9+qJxhdfZw4SfVxrSEnfNO7jPxZvvkQuPwoRDTbGKp7E+m8X87JNZP++0cv4tbOaeTVKw==
X-Received: by 2002:a5d:5706:: with SMTP id a6mr19353748wrv.108.1579106900722;
        Wed, 15 Jan 2020 08:48:20 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id a9sm43574wmm.15.2020.01.15.08.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 08:48:20 -0800 (PST)
Date:   Wed, 15 Jan 2020 17:48:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Message-ID: <20200115164819.GX2131@nanopsycho>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho>
 <20200115143320.GA76932@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200115143320.GA76932@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 15, 2020 at 03:33:23PM CET, leonro@mellanox.com wrote:
>On Wed, Jan 15, 2020 at 03:15:35PM +0100, Jiri Pirko wrote:
>> Wed, Jan 15, 2020 at 02:04:49PM CET, maorg@mellanox.com wrote:
>> >
>> >On 1/15/2020 11:45 AM, Jiri Pirko wrote:
>> >> Wed, Jan 15, 2020 at 09:01:43AM CET, maorg@mellanox.com wrote:
>> >>> RDMA over Converged Ethernet (RoCE) is a standard protocol which enables
>> >>> RDMA’s efficient data transfer over Ethernet networks allowing transport
>> >>> offload with hardware RDMA engine implementation.
>> >>> The RoCE v2 protocol exists on top of either the UDP/IPv4 or the
>> >>> UDP/IPv6 protocol:
>> >>>
>> >>> --------------------------------------------------------------
>> >>> | L2 | L3 | UDP |IB BTH | Payload| ICRC | FCS |
>> >>> --------------------------------------------------------------
>> >>>
>> >>> When a bond LAG netdev is in use, we would like to have the same hash
>> >>> result for RoCE packets as any other UDP packets, for this purpose we
>> >>> need to expose the bond_xmit_hash function to external modules.
>> >>> If no objection, I will push a patch that export this symbol.
>> >> I don't think it is good idea to do it. It is an internal bond function.
>> >> it even accepts "struct bonding *bond". Do you plan to push netdev
>> >> struct as an arg instead? What about team? What about OVS bonding?
>> >
>> >No, I am planning to pass the bond struct as an arg. Currently, team
>>
>> Hmm, that would be ofcourse wrong, as it is internal bonding driver
>> structure.
>>
>>
>> >bonding is not supported in RoCE LAG and I don't see how OVS is related.
>>
>> Should work for all. OVS is related in a sense that you can do bonding
>> there too.
>>
>>
>> >
>> >>
>> >> Also, you don't really need a hash, you need a slave that is going to be
>> >> used for a packet xmit.
>> >>
>> >> I think this could work in a generic way:
>> >>
>> >> struct net_device *master_xmit_slave_get(struct net_device *master_dev,
>> >> 					 struct sk_buff *skb);
>> >
>> >The suggestion is to put this function in the bond driver and call it
>> >instead of bond_xmit_hash? is it still necessary if I have the bond pointer?
>>
>> No. This should be in a generic code. No direct calls down to bonding
>> driver please. Or do you want to load bonding module every time your
>> module loads?
>>
>> I thinks this can be implemented with ndo with "master_xmit_slave_get()"
>> as a wrapper. Masters that support this would just implement the ndo.
>
>We are talking about code sharing and not attempting to solve any
>problem other than that.

Nope Leon, you are wrong. This is not about code sharing. You need to
know exact slave that is going to be used for the xmit. The hashing
function can be setup per bonding instance, it could only L2 for
example.


>
>Right now, we have one of two options:
>1. One-to-one copy/paste of that bond_xmit function to RDMA.
>2. Add EXPORT_SYMBOL and call from RDMA.
>
>Do you have another solution to our undesire to do copy/paste in mind?

I presented it in this thread.


>
>Thanks
>
>>
>> >
