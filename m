Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A83239CC82
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 05:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhFFDgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhFFDgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 23:36:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FC6C061766;
        Sat,  5 Jun 2021 20:34:09 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u126so6542921pfu.13;
        Sat, 05 Jun 2021 20:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cD3PIyyRRNvnz4KzDbhUtn0a4n/Wk4m7evXUvjpgZfY=;
        b=pvVxsfstMGnXG+eRdkHkHSAJy+jpzBCkU1kRH1TG9ZoTMTCCH4xolhTNwqwdrCt/FR
         HzHMR854IoS80M+4lpw04TH+s1W1An44aC7zS3WsX8v6i4q/uSFm+yz8rLKjLsNHNDCV
         YDbsejcHMa1rveQ9MhPZ2rbmswkUzO6yoclTWuJYONUDCuylQtwewfVxTHRSsThwGoUH
         dHgqnSwXApBXAV1NLDKGWSYNniqDcp+L1pYpkkSXV94GV6fEp4bXjLHOtSVFN7mGKUGJ
         Gswjvkxe21vmRetJqTuWJm5rebl2j/UnOBk1estSZy+9+ONU3NHEjYcp+KjmqdTifVHL
         kXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cD3PIyyRRNvnz4KzDbhUtn0a4n/Wk4m7evXUvjpgZfY=;
        b=U6nRFQSE3dtAH+YitEIHFirn1y++XolOAnmmBw7nUfA9X9f+nXVSYimaWNEG26suod
         einB65FnvL3JFeAHEdgr6cT4eTF11bb35V2f1cKNwN/Jx4Qu5X5IIuhkoiLm5XnWSySO
         Ldr5pXWkRKxspa6po0rlp4YKFch9lS6SvBIl26bQum0R0A8gx3uaqAdoJOj4b8IKPuIs
         F94hfo0c8xIU0AUkSpAXB1fpbh2dIhDtdQnXavCrLnMKvuSo9GHN1cYjlWiW6SQZBRz8
         y+GKQbP7yRuNxgVqbRirU254uuTx+gjJaDUUc7ncG/hm14AQk4OFEtHGE1B3CSgfj+15
         18Ow==
X-Gm-Message-State: AOAM5306SfY9VntqISLF05tUMYCWqwKIhLOJzw8aUDcsuwACdYmRBraM
        QiCpwlla09UO8IJEN6tLJoCy/jgOmkQ=
X-Google-Smtp-Source: ABdhPJzuylY57U1xriEfcDf7oWfyZhpqtuILs9vuo/dnLY4bggCRxyDgGEAHbeZ2P7etGYGa0bqGQw==
X-Received: by 2002:a63:ee10:: with SMTP id e16mr12157405pgi.135.1622950448850;
        Sat, 05 Jun 2021 20:34:08 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f6sm5001098pfb.28.2021.06.05.20.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 20:34:08 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
To:     Vladimir Oltean <olteanv@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210605193749.730836-1-mnhagan88@gmail.com>
 <YLvgI1e3tdb+9SQC@lunn.ch> <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
 <20210606005335.iuqi4yelxr5irmqg@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2556ab13-ae7f-ed68-3f09-7bf5359f7801@gmail.com>
Date:   Sat, 5 Jun 2021 20:34:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210606005335.iuqi4yelxr5irmqg@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/2021 5:53 PM, Vladimir Oltean wrote:
> Hi Matthew,
> 
> On Sat, Jun 05, 2021 at 11:39:24PM +0100, Matthew Hagan wrote:
>> On 05/06/2021 21:35, Andrew Lunn wrote:
>>
>>>> The tested case is a Meraki MX65 which features two QCA8337 switches with
>>>> their CPU ports attached to a BCM58625 switch ports 4 and 5 respectively.
>>> Hi Matthew
>>>
>>> The BCM58625 switch is also running DSA? What does you device tree
>>> look like? I know Florian has used two broadcom switches in cascade
>>> and did not have problems.
>>>
>>>     Andrew
>>
>> Hi Andrew
>>
>> I did discuss this with Florian, who recommended I submit the changes. Can
>> confirm the b53 DSA driver is being used. The issue here is that tagging
>> must occur on all ports. We can't selectively disable for ports 4 and 5
>> where the QCA switches are attached, thus this patch is required to get
>> things working.
>>
>> Setup is like this:
>>                        sw0p2     sw0p4            sw1p2     sw1p4 
>>     wan1    wan2  sw0p1  +  sw0p3  +  sw0p5  sw1p1  +  sw1p3  +  sw1p5
>>      +       +      +    |    +    |    +      +    |    +    |    +
>>      |       |      |    |    |    |    |      |    |    |    |    |
>>      |       |    +--+----+----+----+----+-+ +--+----+----+----+----+-+
>>      |       |    |         QCA8337        | |        QCA8337         |
>>      |       |    +------------+-----------+ +-----------+------------+
>>      |       |             sw0 |                     sw1 |
>> +----+-------+-----------------+-------------------------+------------+
>> |    0       1    BCM58625     4                         5            |
>> +----+-------+-----------------+-------------------------+------------+
> 
> It is a bit unconventional for the upstream Broadcom switch, which is a
> DSA master of its own, to insert a VLAN ID of zero out of the blue,
> especially if it operates in standalone mode. Supposedly sw0 and sw1 are
> not under a bridge net device, are they?

This is because of the need (or desire) to always tag the CPU port
regardless of the untagged VLAN that one of its downstream port is being
added to. Despite talking with Matthew about this before, I had not
realized that dsa_port_is_cpu() will return true for ports 4 and 5 when
a VLAN is added to one of the two QCA8337 switches because from the
perspective of that switch, those ports have been set as DSA_PORT_TYPE_CPU.

This may also mean that b53_setup() needs fixing as well while it
iterates over the ports of the switch though I am not sure how we could
fix that yet.

> 
> If I'm not mistaken, this patch should solve your problem?

How about this:

diff --git a/drivers/net/dsa/b53/b53_common.c
b/drivers/net/dsa/b53/b53_common.c
index 3ca6b394dd5f..6dfcff9018fd 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1455,6 +1455,22 @@ static int b53_vlan_prepare(struct dsa_switch
*ds, int port,
        return 0;
 }

+static inline bool b53_vlan_can_untag(struct dsa_switch *ds, int port)
+{
+       /* If this switch port is a CPU port */
+       if (dsa_is_cpu_port(ds, port)) {
+               /* We permit untagging to be configured if it is the DSA
+                * master of another switch (cascading).
+                */
+               if (dsa_slave_dev_check(dsa_to_port(ds, port)->master))
+                       return true;
+
+               return false;
+       }
+
+       return true;
+}
+
 int b53_vlan_add(struct dsa_switch *ds, int port,
                 const struct switchdev_obj_port_vlan *vlan,
                 struct netlink_ext_ack *extack)
@@ -1477,7 +1493,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
                untagged = true;

        vl->members |= BIT(port);
-       if (untagged && !dsa_is_cpu_port(ds, port))
+       if (untagged && b53_vlan_can_untag(ds, port))
                vl->untag |= BIT(port);
        else
                vl->untag &= ~BIT(port);
@@ -1514,7 +1530,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
        if (pvid == vlan->vid)
                pvid = b53_default_pvid(dev);

-       if (untagged && !dsa_is_cpu_port(ds, port))
+       if (untagged && b53_vlan_can_untag(ds, port))
                vl->untag &= ~(BIT(port));

        b53_set_vlan_entry(dev, vlan->vid, vl);
-- 
Florian
