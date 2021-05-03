Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373893712A0
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 10:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhECIuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 04:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhECIuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 04:50:07 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30D8C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 01:49:14 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a36so5860318ljq.8
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 01:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=0EouFmRQtyp54q5lT4y8klpGIjEEoNDqsvWAVDSXz2M=;
        b=2Sah5MchUNI+6kq0vaRQ8pt8pxvRkS+n++D5YC/Co5K9MsXsDzST2/1zZdu2yrOXyb
         7+sijzb5l3bg3zREnVHc4xXYSBY/9W/bXW43Rx2834kYR7foUvAQ+S3Mqxgookz0Mb5I
         Fpgwi7MAZvEZtLUTjpDJ4+cd/q1I6rMlxypZR3bbU8WRVf2VjLI2JSqxpIGs40v+B0z+
         8M8GjPCKFmsw8PJEgV30WhCscYk0Ca9MX6xVbvwFSr7/hhMt5SjDIKUP1A60e+qhh8zq
         f5XL27XkmJfZZDcB3uTiBHWRy5we1spEbGZPnv+ESPYKkJ09r2v7dI2by8s740hgnCIQ
         iWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0EouFmRQtyp54q5lT4y8klpGIjEEoNDqsvWAVDSXz2M=;
        b=UjFPCWwM09L9OxBPL/D8wrIa+1TbSHCNIiIgW+KfEtAv9U3abohvNBVjCsadYQ4mgJ
         c5meR3vt/xtbSEVXWjETyO4Zbqkgc/lt9fOSvnV68eFoHTgNfIlYWZAZDMRaSIJKGrpz
         yJGLpp1nPesT+I/bGsacK0TA6ZMrJcXNrR1dT7LWwBb/KanSlhx0lVWhnpf0lMPSZU0X
         8XLYf6GsHx1udZyzHVOD8XbTycxvHL3Pzt3lCWNWaV/HMSHk3dz5LmLi8pCn5nYZUHlH
         XHpxocWRqK1w5CMPFfFGIfNtNM7Ca75UrE0wCtSHLKT8trfXVy9hY1/W3D9qRH7H5fqH
         5Gmg==
X-Gm-Message-State: AOAM5334nFWQZsqapLAoh4N4s1BMAYBjoawxUh41ovpSXYP0bFl2TEog
        LMtrEfjRE4vWKzEBI6Z1oUPG5A==
X-Google-Smtp-Source: ABdhPJwb8mrvJ4wwAtb4SslFBBY5HE5cOf6SFDqbzqVHpcpVFp6sLQs8rhg6nGMcZyhzkc6/hmxqQA==
X-Received: by 2002:a2e:a373:: with SMTP id i19mr4477066ljn.49.1620031753376;
        Mon, 03 May 2021 01:49:13 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g9sm1208312lja.134.2021.05.03.01.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 01:49:12 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 2/9] net: bridge: Disambiguate offload_fwd_mark
In-Reply-To: <YI6+kQxjCcnYmwkx@shredder>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <20210426170411.1789186-3-tobias@waldekranz.com> <YI6+kQxjCcnYmwkx@shredder>
Date:   Mon, 03 May 2021 10:49:12 +0200
Message-ID: <87h7jknqwn.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 02, 2021 at 18:00, Ido Schimmel <idosch@idosch.org> wrote:
> On Mon, Apr 26, 2021 at 07:04:04PM +0200, Tobias Waldekranz wrote:
>> - skb->cb->offload_fwd_mark becomes skb->cb->src_hwdom. There is a
>>   slight change here: Whereas previously this was only set for
>>   offloaded packets, we now always track the incoming hwdom. As all
>>   uses where already gated behind checks of skb->offload_fwd_mark,
>>   this will not introduce any functional change, but it paves the way
>>   for future changes where the ingressing hwdom must be known both for
>>   offloaded and non-offloaded frames.
>
> [...]
>
>> @@ -43,15 +43,15 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
>>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>>  			      struct sk_buff *skb)
>>  {
>> -	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
>> -		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
>> +	if (p->hwdom)
>> +		BR_INPUT_SKB_CB(skb)->src_hwdom = p->hwdom;
>>  }
>
> I assume you are referring to this change? "src_hwdom" sounds weird if
> it's expected to be valid for non-offloaded frames.

Perhaps "non-offloaded" was a sloppy description on my part. I was
trying to describe frames that originate from a switchdev, but have not
been forwarded by hardware; e.g. STP BPDUs, IGMP reports, etc. So
nbp_switchdev_frame_mark now basically says: "If this skb came in from a
switchdev, make sure to note which one".

> Can you elaborate about "future changes where the ingressing hwdom must
> be known both for offloaded and non-offloaded frames"?

Typical example: The switchdev has a fixed configuration to trap STP
BPDUs, but STP is not running on the bridge and the group_fwd_mask
allows them to be forwarded. Say we have this setup:

      br0
    /  |  \
swp0 swp1 swp2

A BPDU comes in on swp0 and is trapped to the CPU; the driver does not
set skb->offload_fwd_mark. The bridge determines that the frame should
be forwarded to swp{1,2}. It is imperative that forward offloading is
_not_ allowed in this case, as the source hwdom is already "poisoned".

Recording the source hwdom allows this case to be handled properly.

> Probably best to split this change to a different patch given the rest
> of the changes are mechanical.

Right, but I think the change in name to warrants a change in
semantics. It is being renamed to src_hwdom because it now holds just
that information. Again, there is no functional change introduced by
this since nbp_switchdev_allowed_egress always checks for the presence
of skb->offload_fwd_mark anyway. But if you feel strongly about it, I
will split it up.

>>  
>>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>>  				  const struct sk_buff *skb)
>>  {
>>  	return !skb->offload_fwd_mark ||
>> -	       BR_INPUT_SKB_CB(skb)->offload_fwd_mark != p->offload_fwd_mark;
>> +	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
>>  }
>>  
>>  /* Flags that can be offloaded to hardware */
>> -- 
>> 2.25.1
>> 
