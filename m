Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87175B6DC8
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiIMMzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiIMMyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:54:37 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CA52AD5
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 05:54:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663073667; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Q1Ob5rZyMmrtd2WipwqSn5+HEbyp8lpnmOrfmgL4SoRRAC37ew1Pt4LIM+ofnC+zyN61XWIytLX0VcWx+HdUkcV7Yce59aegFzhYMEiWhW72voCbnh/5M8oK1roA+i7PxHTqbXOpVmiTqdWeXfW7+mg9WaCua7v+KdKubjQXmjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663073667; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OO11ujuUk0klFc2p3/Bisw0CuhXz+GVa3UFQpmCwJTI=; 
        b=cMpFDSyTh80incSnQC0HUGFTNL9VJg0UkeiJVldfd0ZqPBw/OtHflhcYKQ8APZTU4bIRHzQNY2FBhrkVr6+NsysuTxQV071G0FTaXIERoVD8CYrMr9sVIwywCpEC+sqfd8p2u2AbOTIp06ehdYV+IsrFYj9t+ZHS9QRwOH8hBB4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663073667;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Message-Id:Reply-To;
        bh=OO11ujuUk0klFc2p3/Bisw0CuhXz+GVa3UFQpmCwJTI=;
        b=SLtnbZoCx2jtazkOEvUapWWOnJiV4sZXxCAAqXk5c9/t8xSFE+/Zle0FDE+/LvF2
        evNXVw03TgrSQ+6sOqg819WWTq9MZ6Bxv7vmHZ48xkS+vJB5wB2FsxvKb21PgFliPI1
        rL4kkhj9kA+9WBxH4PnZ8clFWixi1ivL8h5769nQ=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663073663708583.5460241287333; Tue, 13 Sep 2022 05:54:23 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------zuMU30EfzsaGWnBayWFe6DMQ"
Message-ID: <e75cece2-b0d5-89e3-b1dc-cd647986732f@arinc9.com>
Date:   Tue, 13 Sep 2022 15:54:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: gmac1 issues with mtk_eth_soc & port 5 issues with MT7530 DSA driver
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
In-Reply-To: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------zuMU30EfzsaGWnBayWFe6DMQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I'd like to post a few more issues I stumbled upon on mtk_eth_soc and 
MT7530 DSA drivers. All of this is tested on vanilla 6.0-rc5 on GB-PC2.

## MT7621 Ethernet gmac1 won’t work when gmac1 is used as DSA master for 
MT7530 switch

There’s recently been changes on the MT7530 DSA driver by Frank to 
support using port 5 as a CPU port.

The MT7530 switch’s port 5 is wired to the MT7621 SoC’s gmac1.

Master eth1 and slave interfaces initialise fine. Packets are sent out 
from eth1 fine but won't be received on eth1.

This issue existed before Lorenzo’s changes on 6.0-rc1.

I’m not sure if this is an issue with mtk_eth_soc or the MT7530 DSA driver.

---

## MT7530 sends malformed packets to/from CPU at port 5 when port 6 is 
not defined on devicetree

In this case, I can see eth1 receiving traffic as the receive counter on 
ifconfig goes up with the ARP packets sent to the mt7621 CPU.

I see the mt7621 CPU not responding to the ARP packets (no malformed 
packets or anything), which likely means ARP packets received on the 
mt7621 CPU side are also malformed.

I think this confirms that the above issue is related to the MT7530 DSA 
driver as I can see eth1 receiving traffic in this case.

Packet capture of the malformed packets are in the attachments.

---

## MT7621 Ethernet gmac1 won’t work when gmac0 is not defined on devicetree

eth0 interface is initalised even though it’s not defined on the 
devicetree, eth1 interface is not created at all.

This is likely not related to the MT7530 DSA driver.

Arınç
--------------zuMU30EfzsaGWnBayWFe6DMQ
Content-Type: application/x-pcapng; name="malformed.pcapng"
Content-Disposition: attachment; filename="malformed.pcapng"
Content-Transfer-Encoding: base64

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


--------------zuMU30EfzsaGWnBayWFe6DMQ--
