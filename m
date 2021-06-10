Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF03A21C2
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 03:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhFJBIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 21:08:49 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:36399 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJBIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 21:08:48 -0400
Received: by mail-pf1-f173.google.com with SMTP id c12so203002pfl.3;
        Wed, 09 Jun 2021 18:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nvGpQIQRzZ4aKpEFgqU/1fu9Ldkyk/7zvwTcPwGZToc=;
        b=X+4A+sorPPDMWcW+Lxa9fCXris4DFkI7Gn2lAwtCSvf8/Nbezsyp5nzW1l/AKLZFP0
         Uqk1KkmPxl4Rshu3ptB8bO/Ott2KtbIiu0a8D8G7ckyx0O8bImhlOpJHpO5L4PU4I1W5
         PpAY8LF3mKkktOH0YdlXt/rsmtPpdP4i2IVzgEDa6tIEtQ976VAspF0wEZsInqDFNcaU
         CV/QOA5RqdSTItjjAGkRRrp7W0KCAzwBiCJfnNDQL8NBHl4CS8bY3gmeC+RACr6klRrz
         Y4VlA4TfKBTfBUGuDW8/ccHa694BY9i/N2C15btWj8kw0LPC1juXVhlJlKVVHPVS5wbv
         WJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nvGpQIQRzZ4aKpEFgqU/1fu9Ldkyk/7zvwTcPwGZToc=;
        b=DDzhFR67/S8CpQQ98AZnwzk3/jQEDIv1EImfHyoibdMeZcIYawKwsjzYc7q7Cp6jxO
         DwjnoltK+evXIOs3IMLRGoh9cN0uRdlm4CbxTgDdOPwcX995oX4fCdfzFxjNqNtlCoWQ
         pMMtuTTics+X6vXdCeK9lgBNFkRUH1rSk+1QWy+XYoNuFW80HU0jBLPtyy5XtXMWF7t5
         vFATrbHD0zBpBsFQrriJNurmz1lP8tje08lYFh0kvuDLkvhrLHpzQkaaf/nRy0LB/ltJ
         qlAAehmTtfOCDv63adnf2LIe2LgOW0YSxK8Rf+1mWbrBfqqGWUghFmPLLiyeNn8MFU23
         VfiA==
X-Gm-Message-State: AOAM533we5FV6yvl/K/2LEUiM4DYf74vot+PITk8wIEMIXeVE6tPo1as
        nzrBiX1txku3nxQNP9Z1Pv40bGS5pjE=
X-Google-Smtp-Source: ABdhPJzf00sxPc2gCB9xitmU2gYWFPUZkInj8XO25MhwTwCBankzpv3Nx4+wY9PmYodwoRcfKj5r3g==
X-Received: by 2002:a63:ed4d:: with SMTP id m13mr2391075pgk.433.1623287145202;
        Wed, 09 Jun 2021 18:05:45 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b10sm614097pfi.122.2021.06.09.18.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 18:05:44 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always
 tagged
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, mnhagan88@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210608212204.3978634-1-f.fainelli@gmail.com>
 <20210609223048.xsnyaoqzr6uhlqsm@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <01be1409-599d-c16e-6459-f4cb79fcf7a0@gmail.com>
Date:   Wed, 9 Jun 2021 18:05:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210609223048.xsnyaoqzr6uhlqsm@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/2021 3:30 PM, Vladimir Oltean wrote:
> On Tue, Jun 08, 2021 at 02:22:04PM -0700, Florian Fainelli wrote:
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
> 
> Florian, does the hardware behave in the same way if you disable
> CONFIG_VLAN_8021Q?

Unfortunately it does not because there is no more code calling into
b53_vlan_add() with the desired egress untagged attribute:

00:01:23.015477 b8:ac:6f:80:af:7e (oui Unknown) > 00:10:18:cd:c9:c2 (oui
Unknown), BRCM tag OP: EG, CID: 0, RC: exception, TC: 0, port: 0,
ethertype 802.1Q (0x8100), length 106: vlan 0, p 0, ethertype IPv4
(0x0800), (tos 0x0, ttl 64, id 3662, offset 0, flags [none], proto ICMP
(1), length 84)
    192.168.1.254 > 192.168.1.10: ICMP echo reply, id 5127, seq 17,
length 64
        0x0000:  0010 18cd c9c2 b8ac 6f80 af7e 0000 2000  ........o..~....
        0x0010:  8100 0000 0800 4500 0054 0e4e 0000 4001  ......E..T.N..@.
        0x0020:  e802 c0a8 01fe c0a8 010a 0000 bc2c 1407  .............,..
        0x0030:  0011 3db6 f204 0000 0000 0000 0000 0000  ..=.............
        0x0040:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0050:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0060:  0000 0000 0000 0000 0000

Something like this works:

diff --git a/drivers/net/dsa/b53/b53_common.c
b/drivers/net/dsa/b53/b53_common.c
index 6e199454e41d..ac3bb5ef17e2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -748,9 +748,13 @@ int b53_configure_vlan(struct dsa_switch *ds)

        b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);

-       b53_for_each_port(dev, i)
+       b53_for_each_port(dev, i) {
+               v = &dev->vlans[def_vid];
+               v->members |= BIT(i);
+               v->untag = v->members;
                b53_write16(dev, B53_VLAN_PAGE,
                            B53_VLAN_PORT_DEF_TAG(i), def_vid);
+       }

        /* Upon initial call we have not set-up any VLANs, but upon
         * system resume, we need to restore all VLAN entries.
-- 
Florian
