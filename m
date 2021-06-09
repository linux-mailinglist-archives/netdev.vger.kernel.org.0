Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D753A1285
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239033AbhFILXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239011AbhFILXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 07:23:18 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E248C061574;
        Wed,  9 Jun 2021 04:21:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l11-20020a05600c4f0bb029017a7cd488f5so3980498wmq.0;
        Wed, 09 Jun 2021 04:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=bwDKN+fx80b8xIWad+0Gf9hZVdRvJZpEtfNrk4xlKmk=;
        b=ksIdmofHyyq7O0ohJbOjbUbWi3QPu88zgHW3V0k/DvBqwkncz1RJlaT8GDwjwCqaad
         /8XNlcGxnhCLg8nZ4NfZMtm9D3sdRHT7cm2H8k1YoXgwCbjcmJmyx7l3mByA1CPMiP1r
         h/MQjm43QnNOhXibsbyKjTd/pQv0iEqp/r3NVHY0upy19AXAxg5+TBgUY7BV8WhL8uz6
         keXg4XsKc6Vcg0Zf8wuF59jJFVKFY/Go5oCGEvz6LgtvKl+K2ETu6JTT/XF6CbTrXjMG
         qV2eCygfcl7hCxi5k1mtC0RazY7Jv4BU83k+yw0g9ptuVfRhYHwFDB7XfzvwIcqattGH
         XYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bwDKN+fx80b8xIWad+0Gf9hZVdRvJZpEtfNrk4xlKmk=;
        b=iffUbUsIlErP+I+1BqA8hbp0n0rMBh3sW4xCI/o3vjABgQeEUZE4TGbrmvT1ED3ahL
         kZUJlfggmUmQaMZHjra3X/ya6e9eILU4emgDHvYYdgbIf/OHC0kWB232Ppwx3DVXkdo9
         srh0xLw1Klj/YtBSwQRFldPpCAvW2c1PdHMLtENkqQ+bC5sBNV30nCKtEjiTPYmhxJA+
         sgOSNlIDYXBAT8hoV94x9tcuz8nnXssARh7nfQSlbTcuuETkaCaRDx7gmbwsFzV3bed9
         yy28pfZaQy1iDpVEE5ob/AIN0yYU7AxP8azSxkIjrZnaSly3dGY2a/eooUdTmen23Lu5
         45tQ==
X-Gm-Message-State: AOAM530WHdc5tF66J7jH1IFl/9fQykjJDsRT1JtUns53WWxIBw+eePRP
        bdAkcMRD4rwGhnsiBCiAmVOs7CgFdiAaEQ==
X-Google-Smtp-Source: ABdhPJz/uXgJ3lBkogrjFxQwFysRN8b+mM7ZJy51+Ca4tUuwl1Oe2uEeVFAYXpHfBiGtjEqkVzx5pQ==
X-Received: by 2002:a1c:b782:: with SMTP id h124mr9322999wmf.168.1623237681304;
        Wed, 09 Jun 2021 04:21:21 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id f13sm3043444wmg.7.2021.06.09.04.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 04:21:20 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always
 tagged
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210608212204.3978634-1-f.fainelli@gmail.com>
 <ddffc050-776f-9972-b729-a837a2a51b79@gmail.com>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <1f3e9e5f-ff5c-2fa2-7a6a-2608189a57d6@gmail.com>
Date:   Wed, 9 Jun 2021 12:21:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ddffc050-776f-9972-b729-a837a2a51b79@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 08/06/2021 22:26, Florian Fainelli wrote:

>
> On 6/8/2021 2:22 PM, Florian Fainelli wrote:
>> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
>> VLANs") forced the CPU port to be always tagged in any VLAN membership.
>> This was necessary back then because we did not support Broadcom tags
>> for all configurations so the only way to differentiate tagged and
>> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
>> port into being always tagged.
>>
>> With most configurations enabling Broadcom tags, especially after
>> 8fab459e69ab ("net: dsa: b53: Enable Broadcom tags for 531x5/539x
>> families") we do not need to apply this unconditional force tagging of
>> the CPU port in all VLANs.
>>
>> A helper function is introduced to faciliate the encapsulation of the
>> specific condition requiring the CPU port to be tagged in all VLANs and
>> the dsa_switch_ops::untag_bridge_pvid boolean is moved to when
>> dsa_switch_ops::setup is called when we have already determined the
>> tagging protocol we will be using.
>>
>> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
> Matthew, here is a tcpdump capture showing that there is no VLAN 0 tag
> being added, unlike before:
>
> 00:00:42.191113 b8:ac:6f:80:af:7e (oui Unknown) > 00:10:18:cd:c9:c2 (oui
> Unknown), BRCM tag OP: EG, CID: 0, RC: exception, TC: 0, port: 0,
> ethertype IPv4 (0x0800), length 102: (tos 0x0, ttl 64, id 25041, offset
> 0, flags [none], proto ICMP (1), length 84)
>     192.168.1.254 > 192.168.1.10: ICMP echo reply, id 1543, seq 12,
> length 64
>         0x0000:  0010 18cd c9c2 b8ac 6f80 af7e 0000 2000  ........o..~....
>         0x0010:  0800 4500 0054 61d1 0000 4001 947f c0a8  ..E..Ta...@.....
>         0x0020:  01fe c0a8 010a 0000 4522 0607 000c 31c8  ........E"....1.
>         0x0030:  8302 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0040:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0050:  0000 0000 0000 0000 0000 0000 0000 0000  ................
>         0x0060:  0000 0000 0000
>
> Let me know how this patch goes.

tcpdump capture on eth0 of inbound DHCP requests on port 4 of QCA switch sw1
which is attached to BCM switch port 5. Packet is VLAN tagged, VID 10.

Without patch (and without tag_qca hack):
0000   00 00 20 05 ff ff ff ff ff ff e0 cb bc 88 c9 a5   .. .............
0010   81 00 00 00 be 4c 81 00 00 0a 08 00 45 00 01 48   .....L......E..H
0020   00 00 00 00 40 11 79 a6 00 00 00 00 ff ff ff ff   ....@.y.........

With patch applied:
0000   00 00 20 05 ff ff ff ff ff ff e0 cb bc 88 c9 a5   .. .............
0010   be 4c 81 00 00 0a 08 00 45 00 01 48 00 00 00 00   .L......E..H....
0020   40 11 79 a6 00 00 00 00 ff ff ff ff 00 44 00 43   @.y..........D.C

Everything seems fine. Looks good!

Matthew

