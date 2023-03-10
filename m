Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A87E6B3468
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 03:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCJC4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 21:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCJC4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 21:56:02 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40E6F2884
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 18:56:00 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id i9so4873273lfc.6
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 18:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678416959;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YoQpPIrm/rUVCF4s1hbQk90Fj6JtCsU08M4CGTjz5E4=;
        b=BFbup24jQJLYesxdlwoodi2LCkRorXbq+NfJK6jidVWGcUm7Tn1USl4YmxNIPyneh4
         E+3ydalBw/H4IJXuu+Hd2COU6/v7vhTcPRhBiabOiYEdFnyHZBJ5EBbUUkadLitzeCgT
         pOenlaJN27TG7bHlY/YTHXvoXz22jjKcxEO90K8+Z7bz0w/ctB7lOlDlGaJTLhxMRSia
         2YEGCUgNqZslQwpEDYRsmJmFkN/Kixhus9m8FZ0Zz9loNVdaMGdTwnC/exWqkrMlXcC/
         XK/7drztZBCNF7XzIXy0WydsSNJ92wzzmSgr4aMoQzsi9g6L4Qd7rJfZtDPYHyc8CHJZ
         +ieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678416959;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YoQpPIrm/rUVCF4s1hbQk90Fj6JtCsU08M4CGTjz5E4=;
        b=AW6Pynsst209UU4f2RsWW9Vyjeli6bifktZWfTQl3sD3bTkmNngS0tPOW7BvJOcLMS
         fn5/Gl3M91IbeUzTPR1stHMLsW39IXj9nUCl4Cd5Z5Lcjde0D6AFaioAesB6+p32xqOJ
         /HCU+hiHfvjyXY1o2YUHLHbD71wukDV1mS04T4q8BqmOW7h5hS6T+esblM28aDBmzBQp
         /PeEpk/jmIuLSqVwwAc3FdQMth9WE4rSWKDFWgZiNbUIHBL6ssjQtKlAWzty/aYAz6U+
         9vaGtVyUheENJKGOiid5rnhdqKbsDfRTrVBin4UQwT4ZAFn3TfQBrWlHaOPA3qDA4Jj3
         +5Ng==
X-Gm-Message-State: AO0yUKUQsXE5QY7fyOS28xv77uH5ehzahGmt7rhzr3rl+6Ns01SNzitF
        asBomAbOkO4M64FI2sQPAwTNe0f0ZmE4ySyQMW4=
X-Google-Smtp-Source: AK7set9ysDDiWgzHkWyW7kRBVITCc0BCjds1F/e5G5omhvzUXN7VonYZnB0kSd2Hbw4mHOAgNAMzWP1cM642A9ege+M=
X-Received: by 2002:ac2:5934:0:b0:4dd:9931:c555 with SMTP id
 v20-20020ac25934000000b004dd9931c555mr297053lfi.0.1678416958915; Thu, 09 Mar
 2023 18:55:58 -0800 (PST)
MIME-Version: 1.0
References: <20230307210245.542-1-luizluca@gmail.com> <ZAh5ocHELAK9PSux@corigine.com>
 <CAJq09z7U75Qe_oW3vbNmG=QaKFQW_zuFyNqjg0HAPPHh3t71Qg@mail.gmail.com> <20230308224529.10674df1@kernel.org>
In-Reply-To: <20230308224529.10674df1@kernel.org>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 9 Mar 2023 23:55:46 -0300
Message-ID: <CAJq09z6ZG4bw_fiLM_-1NfzyE6LDnko1uehzSWCN9RLu_48Ffg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: dsa: realtek: rtl8365mb: add change_mtu
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could I trouble you for v5 with some form of this explanation in the
> commit message?

Sure, here is a new proposed commit message:

The rtl8365mb was using a fixed MTU size of 1536, which was probably
inspired by the rtl8366rb's initial frame size. However, unlike that
family, the rtl8365mb family can specify the max frame size in bytes,
- rather than in fixed steps. The max packet size now defaults to
- VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN, which is 1522 bytes.
+ rather than in fixed steps.

DSA calls change_mtu for the CPU port once the max MTU value among the
ports changes. As the max packet size is defined globally, the switch
is configured only when the call affects the CPU port.

The available specifications do not directly define the max supported
packet size, but it mentions a 16k limit. This driver will use the 0x3FFF
limit as it is used in the vendor API code. However, the switch sets the
max packet size to 16368 bytes (0x3FF0) after it resets.

change_mtu uses MTU size, or ethernet payload size, while the switch
works with frame size. The frame size is calculated considering the
ethernet header (14 bytes), a possible 802.1Q tag (4 bytes), the payload
size (MTU), and the Ethernet FCS (4 bytes). The CPU tag (8 bytes) is
consumed before the switch enforces the limit.

+ During setup, the driver will use the default 1500-byte MTU of DSA to set
+ the maximum frame size. The current sum will be
+ VLAN_ETH_HLEN+1500+ETH_FCS_LEN, which results in 1522 bytes.
+ Although it is lower than the previous initial value of 1536 bytes, the driver
+ will increase the frame size for a larger MTU. However, if something
+ requires more space without increasing the MTU, such as QinQ,
+ we would need to add the extra length to the rtl8365mb_port_change_mtu()
+ formula.
+
MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
(where rtl8367s is stacked) can go. The register was manually
manipulated byte-by-byte to ensure the MTU to frame size conversion was
correct. For frames without 802.1Q tag, the frame size limit will be 4
bytes over the required size.


Let me know if I'm still not clear or missed some important topic.

Regards,

Luiz
