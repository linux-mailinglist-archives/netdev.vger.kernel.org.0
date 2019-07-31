Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B217B6FC
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 02:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387529AbfGaAVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 20:21:44 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43474 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGaAVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 20:21:43 -0400
Received: by mail-qt1-f194.google.com with SMTP id w17so20518395qto.10
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 17:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zZuVIM8QeDsvHulJTgwwSmVbK1Pr+l5Dyla7hZ8EFwg=;
        b=YlnCXahE7T3HbfquvfIE4Nb7ZxledzCWkncuYT1RAH2rRAOjnmvoFqwB2dnqN27Jh+
         A5GRS1GjQSsFTd//RfN/7nIR2yPPXHOxdlPlbcgpnUbKNSVXy8Ohr/HFd8UtRTe51iC2
         C4rQXKADVIkNkutwUO/poItq2OZY2OK1owOuFqm6OUParARyMD9XfuQ1dCJq6ToxA3mn
         8gzHQ35svUUcaKaSYInFMWMB4W9ARI55JgIy8aj3dw9vpECkYbjhuiBv+vFNlvhQCH2k
         IMFt80EyHJzMYkHBXhsfalcDvYDEun787MUzZzehWLJpOqUwLxJqlEHNchfJmbQM90D8
         E/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zZuVIM8QeDsvHulJTgwwSmVbK1Pr+l5Dyla7hZ8EFwg=;
        b=mkhNz+ArkfmIKF4SLU3jWOn3gIG8u9r/mQvliJdTeMle8ieTCbJxQBD6wpKWtkoCXr
         zi8OTv6il7G6FSbvkmYMakMROJK3uMOeZ6OUZSEgstROUhdKCOmg+blczpeO1KVKesk0
         jZ9fUNg6M/5SAlyRp4ZmpzDjFPxgsvoze897PdkW1FUEXTSwZadPq7UwwQzuHm62mYCI
         JCDthsI8KqmLocBphZrH7t1VT6oujZRksHAIF0dTQ2/ckL43WIybmhTWekvE3V3igQQj
         TLBhPVTKKrbBEVr8ozblI6z54b4oIrI3IL0UBaE20S9RaY8H2rCrL3uai2USS+e4998I
         EJvw==
X-Gm-Message-State: APjAAAUcTtZbYDJIsxJHjbVrNKYj7mLtaoqNAbwcTM6ln8rGsAp4Zmil
        3QCXeBLpBTiKYcgz8JPT1RlRHA==
X-Google-Smtp-Source: APXvYqz928PF9WpXi6Qo5dBYR/bjI2MVi1C5o3EqzqDoLBW0LylinIUJOI9mO3yoInO6tSzuI9e1Cg==
X-Received: by 2002:ac8:40cc:: with SMTP id f12mr82158214qtm.256.1564532502789;
        Tue, 30 Jul 2019 17:21:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z18sm30324878qka.12.2019.07.30.17.21.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 17:21:42 -0700 (PDT)
Date:   Tue, 30 Jul 2019 17:21:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, wenxu@ucloud.cn, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com,
        gerlitz.or@gmail.com, paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: map basechain priority to
 hardware priority
Message-ID: <20190730172130.1f11de90@cakuba.netronome.com>
In-Reply-To: <20190730105417.14538-1-pablo@netfilter.org>
References: <20190730105417.14538-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 12:54:17 +0200, Pablo Neira Ayuso wrote:
> This patch maps basechain netfilter priorities from -8192 to 8191 to
> hardware priority 0xC000 + 1. tcf_auto_prio() uses 0xC000 if the user
> specifies no priority, then it subtract 1 for each new tcf_proto object.
> This patch uses the hardware priority range from 0xC000 to 0xFFFF for
> netfilter.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This follows a rather conservative approach, I could just expose the
> 2^16 hardware priority range, but we may need to split this priority
> range among the ethtool_rx, tc and netfilter subsystems to start with
> and it should be possible to extend the priority range later on.
> 
> By netfilter priority, I'm refering to the basechain priority:
> 
> 	add chain x y { type filter hook ingress device eth0 priority 0; }
>                                                              ^^^^^^^^^^^
> 
> This is no transparently mapped to hardware, this patch shifts it to
> make it fit into the 0xC000 + 1 .. 0xFFFF hardware priority range.

Mmm.. so the ordering of tables is intended to be decided by priority
and not block type (nft, tc, ethtool)?  I was always expecting we 
would just follow the software order when it comes to inter-subsystem
decisions.  So ethtool first, then XDP, then TC, then nft, then
bridging etc. TC vs NFT based on:

static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
				    struct packet_type **ppt_prev)
{
...
	if (static_branch_unlikely(&ingress_needed_key)) {
		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev);
		if (!skb)
			goto out;

		if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
			goto out;
	}

Are they solid use cases for choosing the ordering arbitrarily?
