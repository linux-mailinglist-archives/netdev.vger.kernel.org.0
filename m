Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3400958CF64
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbiHHUtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237485AbiHHUtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:49:47 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B878863E9
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 13:49:46 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id cr9so4155753qtb.13
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 13:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=2lGEdmp5wPlqw4BdYA59fqeBz4L2mpYg32y6FMNzd2c=;
        b=cyII1vqSrUQGqAR4jCiaxDlbVJ9hGgsg2ZDhF+X4TK3rOdJcMuBgMY1ltIIF/lxOe/
         lEOOIt09zAL0zQIr3DH633BAbEKCYb+GnrXXkLrQEAon4YJVqSP2rj0quVYB9fCsq5Pg
         rxyU1eZh47BxZziWi7ASbMqcJfYb2+5ASXsDYVJXHfQsorCvv8YNYVYF/WHANKcf0mlV
         l7MjX0AqrCgFduoJQctjwrm6Yt1AeyDlolcVjV+iysViO/Nf5COsRxUtjaNOK457HOoB
         GS7x9KOdItpWBLC6WVMmx9+QlYl9g1PiRuGN6/bHsYjrt79Xd+5224A+2Hr/WIm5hXYW
         k95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=2lGEdmp5wPlqw4BdYA59fqeBz4L2mpYg32y6FMNzd2c=;
        b=cB0i78JD+H9UvkAACT8/yaH7DVHAjKHfTGfki0KRoTu1iM+R1LVszFpWAzIBs1Du0T
         JbxLhbiuuiIvc7LgFr8EY7gJprJxbVp4il8ah6KITPRn9tC18fxHIBKyvKTMFTawC/7c
         bGVdRm5pYUn9X9wmgWiFivAKxhO1ij3OM1ovcuTVJACZ0ggpYnTuYXqABU+ipf0Qezih
         4L4ruCwBIAb6ZbAf+pob2oqjSO+gChg67Ioy5z7LQQYT+pn6r2OZ4Tk2TXGnOXREq1qU
         AH5xSnOCbWc0quKAp876QkQkqBCo1Bo2BgfI8NeZ20QALWocGkwF9kOXBciHitznBGsX
         YcBA==
X-Gm-Message-State: ACgBeo2X03zxmuX3R8yF3+T43E6fjoiXWhYW8QyYXTeFYZiLkb3hNh4n
        fiQZikMZ+Qei3/4ff+cdrdLqrcmH+JY=
X-Google-Smtp-Source: AA6agR40R/TEvRwt2PankJaE4p81HXBDW7HN8i5imDpNwgzB5MM9rde6cy4g1x5VB7JanSEUOtmeeg==
X-Received: by 2002:ac8:588d:0:b0:31f:720:e00 with SMTP id t13-20020ac8588d000000b0031f07200e00mr16986792qta.285.1659991785744;
        Mon, 08 Aug 2022 13:49:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05620a454c00b006b928ba8989sm1936193qkp.23.2022.08.08.13.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 13:49:45 -0700 (PDT)
Message-ID: <0bca9e3b-b44e-eac0-f797-1bcb4ff8ce41@gmail.com>
Date:   Mon, 8 Aug 2022 13:49:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: dsa: felix: suppress non-changes to the tagging
 protocol
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220808125127.3344094-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220808125127.3344094-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/22 05:51, Vladimir Oltean wrote:
> The way in which dsa_tree_change_tag_proto() works is that when
> dsa_tree_notify() fails, it doesn't know whether the operation failed
> mid way in a multi-switch tree, or it failed for a single-switch tree.
> So even though drivers need to fail cleanly in
> ds->ops->change_tag_protocol(), DSA will still call dsa_tree_notify()
> again, to restore the old tag protocol for potential switches in the
> tree where the change did succeeed (before failing for others).
> 
> This means for the felix driver that if we report an error in
> felix_change_tag_protocol(), we'll get another call where proto_ops ==
> old_proto_ops. If we proceed to act upon that, we may do unexpected
> things. For example, we will call dsa_tag_8021q_register() twice in a
> row, without any dsa_tag_8021q_unregister() in between. Then we will
> actually call dsa_tag_8021q_unregister() via old_proto_ops->teardown,
> which (if it manages to run at all, after walking through corrupted data
> structures) will leave the ports inoperational anyway.
> 
> The bug can be readily reproduced if we force an error while in
> tag_8021q mode; this crashes the kernel.
> 
> echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
> echo edsa > /sys/class/net/eno2/dsa/tagging # -EPROTONOSUPPORT
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000014
> Call trace:
>   vcap_entry_get+0x24/0x124
>   ocelot_vcap_filter_del+0x198/0x270
>   felix_tag_8021q_vlan_del+0xd4/0x21c
>   dsa_switch_tag_8021q_vlan_del+0x168/0x2cc
>   dsa_switch_event+0x68/0x1170
>   dsa_tree_notify+0x14/0x34
>   dsa_port_tag_8021q_vlan_del+0x84/0x110
>   dsa_tag_8021q_unregister+0x15c/0x1c0
>   felix_tag_8021q_teardown+0x16c/0x180
>   felix_change_tag_protocol+0x1bc/0x230
>   dsa_switch_event+0x14c/0x1170
>   dsa_tree_change_tag_proto+0x118/0x1c0
> 
> Fixes: 7a29d220f4c0 ("net: dsa: felix: reimplement tagging protocol change with function pointers")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
