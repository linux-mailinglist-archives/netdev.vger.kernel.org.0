Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068CA347294
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhCXH1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 03:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbhCXH1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:27:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC70C061763;
        Wed, 24 Mar 2021 00:27:19 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c204so16689896pfc.4;
        Wed, 24 Mar 2021 00:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QRhh4AI+56q72LE1qwHnMWk1VFIQQqng67qjMuELUzY=;
        b=K7TSlyBGRm9loEIlm8ObNAK9hDbldIij4zZhSqbKWcngL3HaxMyzAQpgJ9ucVK9HxQ
         d5gvnbcezu+09Cy4sHkvNAITrPOZVeZnwEEbBYY3+SQVzuHFpkjkKvG+xRDGSMb/sHW3
         Nbn3ljSzZJy6QL7cFYxWC0jvW3/LQcAkviBYiieZoy4OhvNb2nuALeHZTJGSVZ0SPFro
         rb3YuEjxG9BVw/EUca3oonX45E+PLOe0ODQ261G6WL3DYLtmXrvsE/YLUBdseGVKVhlp
         NARFssQmsj6EvMgVOiyWGmCdU+VNFcspC2vue0KHRGdzI1JxE3zhmdEz5OkeK6PAZbKx
         6IDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QRhh4AI+56q72LE1qwHnMWk1VFIQQqng67qjMuELUzY=;
        b=Y68SiAga0EwdNG5ioJJA5ADC57Fc4q98sD3ahtJJ43gcC++4loq6DzaRrD/ahmTTGm
         HEhZKAtketpinwU5i0c926K1ewxVea0R1YHHaWsnHP19spVNF/vvtUYZrtgnay/baw+p
         YPsuCX0atZq0yipCcDdmD5PcykznqwSvHi6HVUfusdHk+W6I5oTfz46a+p2ZzWxbvy5Q
         EfS/FBbUvJRiesx8V9cW1bRgRBBREO55oIo7dTR1UWHyBcQJZEYPbQJHintXIzrvpSPu
         B2OhSn4Bq87FTTpyD1PoBHFLiqszYEjVDZSiziVUtQTI6oNGXtjIvTbDw7E++kAltc3r
         SbfQ==
X-Gm-Message-State: AOAM5328nrJvEahnewCfJ2Cfca++KC+wP8sQs+M7PFnGBFh10A3tsLCN
        67/8P8CtOuIeMMQJcE8hel4=
X-Google-Smtp-Source: ABdhPJziDRLAHZD6xw/Uxh6tbmv30ieWHMUfiR5H57HnT1lKapL84smPZ4rZMSIBRqETVj/QkHBGmg==
X-Received: by 2002:a62:7ecc:0:b029:1ee:f61b:a63f with SMTP id z195-20020a627ecc0000b02901eef61ba63fmr1713552pfc.57.1616570838702;
        Wed, 24 Mar 2021 00:27:18 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id l10sm1347961pfc.125.2021.03.24.00.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 00:27:18 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next,v2 01/24] net: resolve forwarding path from virtual netdevice and HW destination address
Date:   Wed, 24 Mar 2021 15:27:11 +0800
Message-Id: <20210324072711.2835969-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210324013055.5619-2-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org> <20210324013055.5619-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 02:30:32AM +0100, Pablo Neira Ayuso wrote:
> This patch adds dev_fill_forward_path() which resolves the path to reach
> the real netdevice from the IP forwarding side. This function takes as
> input the netdevice and the destination hardware address and it walks
> down the devices calling .ndo_fill_forward_path() for each device until
> the real device is found.
> 
> For instance, assuming the following topology:
> 
>                IP forwarding
>               /             \
>            br0              eth0
>            / \
>        eth1  eth2
>         .
>         .
>         .
>        ethX
>  ab:cd:ef:ab:cd:ef
> 
> where eth1 and eth2 are bridge ports and eth0 provides WAN connectivity.
> ethX is the interface in another box which is connected to the eth1
> bridge port.
> 
> For packets going through IP forwarding to br0 whose destination MAC
> address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path() provides the
> following path:
> 
> 	br0 -> eth1
> 
> .ndo_fill_forward_path for br0 looks up at the FDB for the bridge port
> from the destination MAC address to get the bridge port eth1.
> 
> This information allows to create a fast path that bypasses the classic
> bridge and IP forwarding paths, so packets go directly from the bridge
> port eth1 to eth0 (wan interface) and vice versa.
> 
>              fast path
>       .------------------------.
>      /                          \
>     |           IP forwarding   |
>     |          /             \  \/
>     |       br0               eth0
>     .       / \
>      -> eth1  eth2
>         .
>         .
>         .
>        ethX
>  ab:cd:ef:ab:cd:ef

Have you tested if roaming breaks existing TCP/UDP connections?
For example, eth1 and eth2 are connected to 2 WiFi APs, and the
client ab:cd:ef:ab:cd:ef roams between these APs.

> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
