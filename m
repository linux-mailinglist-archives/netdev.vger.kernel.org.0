Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4D76B225E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjCILMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjCILMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:12:20 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591B8ED6AA
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 03:07:01 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id ec29so5371592edb.6
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 03:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678360002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3sQYroC6APiwYcm1g36pPzbATq1AHOj/31gtUf0m+BE=;
        b=RL7RNXla5AB6e1ubSz2OAokiBvxQeLhRuXu8cdFPmh0XMb8uCDnl+T8aYJgEiVTPFI
         Yy7IXQ2LJmSEfGd2bu+MZsKSCnzixXV9l+k0V7JAjPDDRFAWjGy3G3JDqwJjtP+qK5pG
         znWWpUDvzlMOYEgheBOeSUZYskJf5xee5H6OiB/uO8rkYLJn2drAFK300se7Nzndu69R
         TiNj+Sa5d9kO+tLUbrcGDzSqla9aQxZJ3Ho5q69jW6gnuOzQJauE+W3O/Qvbpq32HR65
         wimc8WGHX1imTYe69Nlj/L4eqgx/hZtbAYz08lQp3pxjeuBj5q083T2lba3cOfOjIvCd
         7iyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678360002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3sQYroC6APiwYcm1g36pPzbATq1AHOj/31gtUf0m+BE=;
        b=Li+01YhZMLfD4NLBORQbsVPYwAwiqUSP3HjilRF7sWRMcnmEN/4zq5gKkB0QjibEoX
         zZ3MPJaoECba3sK1Q9NaLKBE+UuYB3Q+AUMmMkK2sBjjqpvM/drdqN18yJlTgLwG1S26
         caTZxKrSp7QzYOqPUedrw2beiC84zGNwJxLZA7QrPVvAqwDwUNMnbXC0Dib+3J0lcsA/
         53jD1Lt7bndMvQIF4mKEtq7O7U3fjnbSa2uS9iclVzTet2rK468BulMfOx9Jh6GYiVOi
         Ws1DKgGYETVUfGM0QgGHS+uK0oK75SkedrCFRZ40TOC/yQjHxd6SszXKi2NRNNCiGFOh
         FufQ==
X-Gm-Message-State: AO0yUKU2+lmumDsYxlEZFPcWLTsa7STUFjt7d5/zN+AXew/7UqIkBXFi
        AUH4hBrJBA1VoCgUz3zshqo=
X-Google-Smtp-Source: AK7set84Ah0pM3Htf89w8A/3mPPJENBuctd2MgtdsWSEAYTb2XuCO2VSpF3y+y+eI7ed3aqD12qvqg==
X-Received: by 2002:a17:907:7f0b:b0:888:7ac8:c0f4 with SMTP id qf11-20020a1709077f0b00b008887ac8c0f4mr21331543ejc.25.1678360001777;
        Thu, 09 Mar 2023 03:06:41 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id k17-20020a170906a39100b008b17fe9ac6csm8811681ejz.178.2023.03.09.03.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 03:06:41 -0800 (PST)
Date:   Thu, 9 Mar 2023 13:06:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Qingtao Cao <qingtao.cao.au@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: Question: DSA on Marvell 6390R switch dropping EAPOL packets
 with unicast MAC DA
Message-ID: <20230309110639.lvbhzexnim7vrkwx@skbuf>
References: <CAPcThSFCN7mKP2_ZhqJi9-nGNTYmV5uB23aToAudodZDEnunoA@mail.gmail.com>
 <CAPcThSFCN7mKP2_ZhqJi9-nGNTYmV5uB23aToAudodZDEnunoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcThSFCN7mKP2_ZhqJi9-nGNTYmV5uB23aToAudodZDEnunoA@mail.gmail.com>
 <CAPcThSFCN7mKP2_ZhqJi9-nGNTYmV5uB23aToAudodZDEnunoA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harry,

On Thu, Mar 09, 2023 at 08:19:27PM +1000, Qingtao Cao wrote:
> In this success case, there are two major differences from the Setup One:
> 1. The MAC DA in the EAPOL packet of Request Identity, the 2nd packet in
> the above example, was the multicast address 0180 c200 0003.I guess this is
> understandable since the hostapd has no port-level authentication so it has
> to use a multicast address to reach the potential supplicant.
> 2. The DSA tag = "0108 efff", specifically, the mode = 0, or *TO_CPU*.

> So, how to make the EAPOL a success in the Setup One when the MAC DA is a
> unicast address instead of a multicast address?

My summary of your issue description is: when wpa_supplicant on your DSA
box receives packets with the MAC DA of the PAE group address (01:80:c2:00:00:03),
it can process them. When it receives packets with the MAC DA equal to
the port's unicast MAC address, it can't.

How have you determined that this is a problem with the kernel?

In the title, you claim "switch dropping packets", but there is no
evidence backing this claim in the email body. Furthermore, we do see
those packets in tcpdump. To drop a packet would mean that some drop
counter increases, either on the DSA switch interface
(ethtool -S net2p9 | grep -v ': 0'), or on the DSA master
(ethtool -S eth2cpu | grep -v ': 0'). Note that on the DSA master, DSA
also appends the port counters of the switch's CPU port.

I am also curious to see drop counters when tcpdump is active, and when
it isn't active. This is because tcpdump puts the interface in
promiscuous mode (accept packets with any MAC DA), so there may be a
problem there as well. The command "ip link set eth2cpu promisc on" may
also help to diagnose whether it is a filtering problem on the DSA master.

I have not used wpa_supplicant, but I guess it might be possible that
the application is simply written to bind() the socket() only to the PAE
group address (01:80:c2:00:00:03). Otherwise said, the kernel doesn't
drop the unicast packets, but the application is written such that it
doesn't process them. This is just speculation. Apart from inspecting
the hostapd source code (which I haven't done), "strace" could also be
used to determine this.

If no ethtool counters increment, there is no reason to suspect a
hardware drop of your packets. In that case, the kernel network stack
could still drop them somewhere. This set of commands run on the DSA box
might help identify where:

CONFIG_NET_DROP_MONITOR=y
sudo apt install libpcap-dev binutils-dev libtool
git clone https://github.com/nhorman/dropwatch.git
cd dropwatch
./autogen.sh
dropwatch -l kas

I have no reason to suspect at the moment that any change to net/dsa/tag_dsa.c
would be needed. Until proven otherwise, the difference between FORWARD
and TO_CPU DSA headers is a red herring IMO.

Hope this helps.
