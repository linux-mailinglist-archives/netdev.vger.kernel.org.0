Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3A2510634
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242786AbiDZSFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiDZSFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:05:52 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1F027CD7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 11:02:43 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so2794110pjb.4
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 11:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rQG4DLA/93fkpQtfnOqx4eShfUHbVsVVDeQFnEjTF/c=;
        b=h1VzKAIk0QLUSQpm4uo0kzCBXIDoqsLhs4+5YxkKg4TXMd/h6N75pQjfokqSkZUKnP
         LMghmlMzCjRHT5+sCjYEnTiGGs8lkTpx3DxzS77bLl18pU0yIdNYyICJVDxjj5570O2w
         mAyFA4SuRSXDTB8l8CbtRxUkpcNLpnztsiI8nPrJLJ22Yu7S7ZRxf6+bcv50bQy49avK
         dUwgGdOwMorCKrl4YLj0FEspV5jcatbRdGrz+su8YhNm/Qn9BF3bpZf7tZaPwKDAO1mD
         aYqZUX3LsJbHFzVWAl032qAoLF+yC112N6T3KVjdf4rHuaKmWd9Yc7NuBjA8qRjRWFgJ
         JKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rQG4DLA/93fkpQtfnOqx4eShfUHbVsVVDeQFnEjTF/c=;
        b=ka1YwTvdgXx6tAvt2th0nGEjhhaOFcRgYGJmWvLHA7qAO5rVBuS5mU7kcoxSgb+fCX
         DV10hAcuMkkShubKO1HX9w/oC7kkCC+SJUdFNCu9Vg+JC7y3/cd0KZwna4jR1W6Frz3Y
         RtLNNvfZArwYkM8TOHmCdMoirz4Jar+tfzRCa7Qmy45ZXh6QozqehInmgewgCo/It8gb
         AUyRO4cLEaS5U8PsMo7GrMuAyBv2d07CDGowIUap8SItWa0OMY4ARSgul/lcjyxaGGRG
         8nrh97HnhYWyEj2ubCLjCBkJ1zU0wQL3IIn/2GZwFRKT/WksgKHJUPfAbX9vYlHAn5wn
         puYA==
X-Gm-Message-State: AOAM532WIDW2GALM9YnkbbNh0VdYATYKthKikvvxn8xsJAZPqIsHlClf
        P0pIczE4PeTXEZpWGV4Rd78=
X-Google-Smtp-Source: ABdhPJwgUst2DriMQqqc6b1H7lCuNsYNJXQVJsnuKn1mRDL7T7ldJUIOfIXpprQdD8dHJGd1f9KVXQ==
X-Received: by 2002:a17:902:854c:b0:158:35ce:9739 with SMTP id d12-20020a170902854c00b0015835ce9739mr24305540plo.150.1650996162930;
        Tue, 26 Apr 2022 11:02:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s8-20020a17090a074800b001d92e2e5694sm3518241pje.1.2022.04.26.11.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 11:02:42 -0700 (PDT)
Message-ID: <9d38b67d-3f2a-1829-250d-686490f2d482@gmail.com>
Date:   Tue, 26 Apr 2022 11:02:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] net: dsa: mt753x: fix pcs conversion regression
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <E1nj6FW-007WZB-5Y@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1nj6FW-007WZB-5Y@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/22 14:28, Russell King (Oracle) wrote:
> Daniel Golle reports that the conversion of mt753x to phylink PCS caused
> an oops as below.
> 
> The problem is with the placement of the PCS initialisation, which
> occurs after mt7531_setup() has been called. However, burited in this
> function is a call to setup the CPU port, which requires the PCS
> structure to be already setup.
> 
> Fix this by changing the initialisation order.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
> Mem abort info:
>    ESR = 0x96000005
>    EC = 0x25: DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>    FSC = 0x05: level 1 translation fault
> Data abort info:
>    ISV = 0, ISS = 0x00000005
>    CM = 0, WnR = 0
> user pgtable: 4k pages, 39-bit VAs, pgdp=0000000046057000
> [0000000000000020] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
> Internal error: Oops: 96000005 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 32 Comm: kworker/u4:1 Tainted: G S 5.18.0-rc3-next-20220422+ #0
> Hardware name: Bananapi BPI-R64 (DT)
> Workqueue: events_unbound deferred_probe_work_func
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : mt7531_cpu_port_config+0xcc/0x1b0
> lr : mt7531_cpu_port_config+0xc0/0x1b0
> sp : ffffffc008d5b980
> x29: ffffffc008d5b990 x28: ffffff80060562c8 x27: 00000000f805633b
> x26: ffffff80001a8880 x25: 00000000000009c4 x24: 0000000000000016
> x23: ffffff8005eb6470 x22: 0000000000003600 x21: ffffff8006948080
> x20: 0000000000000000 x19: 0000000000000006 x18: 0000000000000000
> x17: 0000000000000001 x16: 0000000000000001 x15: 02963607fcee069e
> x14: 0000000000000000 x13: 0000000000000030 x12: 0101010101010101
> x11: ffffffc037302000 x10: 0000000000000870 x9 : ffffffc008d5b800
> x8 : ffffff800028f950 x7 : 0000000000000001 x6 : 00000000662b3000
> x5 : 00000000000002f0 x4 : 0000000000000000 x3 : ffffff800028f080
> x2 : 0000000000000000 x1 : ffffff800028f080 x0 : 0000000000000000
> Call trace:
>   mt7531_cpu_port_config+0xcc/0x1b0
>   mt753x_cpu_port_enable+0x24/0x1f0
>   mt7531_setup+0x49c/0x5c0
>   mt753x_setup+0x20/0x31c
>   dsa_register_switch+0x8bc/0x1020
>   mt7530_probe+0x118/0x200
>   mdio_probe+0x30/0x64
>   really_probe.part.0+0x98/0x280
>   __driver_probe_device+0x94/0x140
>   driver_probe_device+0x40/0x114
>   __device_attach_driver+0xb0/0x10c
>   bus_for_each_drv+0x64/0xa0
>   __device_attach+0xa8/0x16c
>   device_initial_probe+0x10/0x20
>   bus_probe_device+0x94/0x9c
>   deferred_probe_work_func+0x80/0xb4
>   process_one_work+0x200/0x3a0
>   worker_thread+0x260/0x4c0
>   kthread+0xd4/0xe0
>   ret_from_fork+0x10/0x20
> Code: 9409e911 937b7e60 8b0002a0 f9405800 (f9401005)
> ---[ end trace 0000000000000000 ]---
> 
> Reported-by: Daniel Golle <daniel@makrotopia.org>
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Fixes: cbd1f243bc41 ("net: dsa: mt7530: partially convert to phylink_pcs")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
