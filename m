Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0136568C6F9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 20:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBFTmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 14:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBFTmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 14:42:37 -0500
Received: from sender4-op-o16.zoho.com (sender4-op-o16.zoho.com [136.143.188.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB7713DD3;
        Mon,  6 Feb 2023 11:42:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675712515; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MYmHxZrvHBbNoRD8edWQraW9/wPJAGVdB3JIp2nIhaa+OaqgXcmdGBjBkQFemXeAaUAw63tz81I89dBWRBRFdPmFvw1HyxuCIEdqxqppiUOTHJM5tp6cH03Vy1Rt+LTVzZ1N1HAp1ZQ/AGPa6BmhJxPRFQhsXUqSXi8uvb+T8QY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675712515; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tKES81hgyd3uZmNg8dQBk10l3khfvFORuLOkdJzPJw4=; 
        b=abNFaqNijcF70DAAuPPoD/r8tguVLsnyYDKNzpyXy1RfhfdQA96uul3414lrJWDElLjwKMNOq2Qb/+Kts8r7cS+2F/yuSszAtT8o+LIqZlQqTFhvpIEiQE3TKHOo9BRGWuU9N3Ea3nsezgImHmnTE4fixv0eScryU+6Kp77Olvw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675712515;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Message-Id:Reply-To;
        bh=tKES81hgyd3uZmNg8dQBk10l3khfvFORuLOkdJzPJw4=;
        b=RCEzXkk2sIuxnqExl0V2PjwQSt0hl/u76xrsLS3Sq1JcIbHGURQH6XSoYzK6ITVv
        hk64ZEQshLBghueTPcbwzeGEhwg9xqzHNRgXqAna1wji0QMFIXlZyXzeonFB8JrLPmO
        0xu0WvQqu4/31rlvhJOWCwMgq744EMmyxaZkTDZE=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1675712513787495.8395705964474; Mon, 6 Feb 2023 11:41:53 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------B2kTEFN8ZUTqa40kjsZFlmDv"
Message-ID: <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
Date:   Mon, 6 Feb 2023 22:41:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
 <20230206174627.mv4ljr4gtkpr7w55@skbuf>
 <5e474cb7-446c-d44a-47f6-f679ae121335@arinc9.com>
In-Reply-To: <5e474cb7-446c-d44a-47f6-f679ae121335@arinc9.com>
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------B2kTEFN8ZUTqa40kjsZFlmDv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

One last thing. Specific to MT7530 switch in MT7621 SoC, if port@5 is 
the only CPU port defined on the devicetree, frames sent from DSA master 
appears malformed on the user port. Packet capture on computer connected 
to the user port is attached.

The ARP frames on the pcapng file are received on the DSA master, I 
captured them with tcpdump, and put it in the attachments. Then I start 
pinging from the DSA master and the malformed frames appear on the 
pcapng file.

It'd be great if you could take a look this final issue.

Arınç
--------------B2kTEFN8ZUTqa40kjsZFlmDv
Content-Type: text/plain; charset=UTF-8; name="tcpdump-ping-output.txt"
Content-Disposition: attachment; filename="tcpdump-ping-output.txt"
Content-Transfer-Encoding: base64

IyB0Y3BkdW1wIC1pIGV0aDAKdGNwZHVtcDogdmVyYm9zZSBvdXRwdXQgc3VwcHJlc3NlZCwg
dXNlIC12W3ZdLi4uIGZvciBmdWxsIHByb3RvY29sIGRlY29kZQpsaXN0ZW5pbmcgb24gZXRo
MCwgbGluay10eXBlIE5VTEwgKEJTRCBsb29wYmFjayksIHNuYXBzaG90IGxlbmd0aCAyNjIx
NDQgYnl0ZXMKMDA6MDA6MTYuNzYzNjUzIEFGIFVua25vd24gKDQyOTQ5MjYwNzUpLCBsZW5n
dGggNTY6IAoJMHgwMDAwOiAgOWExNyBlMGQ1IDVlYTQgZWRjYyAwODI2IGMwYTggMDIwMSAw
MDAwICAuLi4uXi4uLi4mLi4uLi4uCgkweDAwMTA6ICAwMDAwIDAwMDAgMDAwMCAwMDAwIDAw
MDAgMDAwMCAwMDAwIDAwMDAgIC4uLi4uLi4uLi4uLi4uLi4KCTB4MDAyMDogIDEyMDYgMDIw
YyBkMTRiIDAwMDMgM2Q0ZiAzMDMwIDMwMzAgMTAzMCAgLi4uLi5LLi49TzAwMDAuMAoJMHgw
MDMwOiAgMzEwMCAzMDMwICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxLjAwCjAw
OjAwOjE3Ljc4OTI0NiBBRiBVbmtub3duICg0Mjk0OTA5NjkxKSwgbGVuZ3RoIDE4NDogCgkw
eDAwMDA6ICA5YTA3IGUwZDUgNWVhNCBlZGNjIDJkYWYgMDAwMSAwODAwIDA2MDQgIC4uLi5e
Li4uLS4uLi4uLi4KCTB4MDAxMDogIDAwMDEgZTBkNSA1ZWE0IDRjY2MgODAwMCAwMjAyIDAw
MDAgMDAwMCAgLi4uLl4uTC4uLi4uLi4uLgoJMHgwMDIwOiAgMDAyMCBjMGE4IDAyMDEgMDAw
MCAwMDAwIDAwMDAgMDAwMCAwMDAwICAuLi4uLi4uLi4uLi4uLi4uCgkweDAwMzA6ICAwMDAw
IDAwMDAgMDAwMCAwMDAwIDlhMDcgMDAwMCAwMDAwIDAwMDAgIC4uLi4uLi4uLi4uLi4uLi4K
CTB4MDA0MDogIDIxMDMgMDAwMCAwMDAwIDAwMDAgMDAwNiAwMDAwIDAwMDMgMDAwMCAgIS4u
Li4uLi4uLi4uLi4uLgoJMHgwMDUwOiAgMDExOCAwMDAwIDAxMmUgMDAwMCAwMDAyIDAwMDAg
MDAwMCAwMDAwICAuLi4uLi4uLi4uLi4uLi4uCgkweDAwNjA6ICAwMDAwIDAwMDAgMDA1ZiAw
MDAwIDAwMDMgMDAwMCAwMDAwIDAwMDAgIC4uLi4uXy4uLi4uLi4uLi4KCTB4MDA3MDogIDAw
NDUgMDAwMCAwMDAzIDAwMDAgMDAwOCAwMDAwIDAwMzggMDAwMCAgLkUuLi4uLi4uLi4uLjgu
LgoJMHgwMDgwOiAgMDIwMCAwMDAwIDAxMDAgMDAwMCAwMDAzIDAwMDAgMDAwNCAwMDAwICAu
Li4uLi4uLi4uLi4uLi4uCgkweDAwOTA6ICAwMDAzIDAwMDAgMDAwMyAwMDAwIDAxMjMgMDAw
MCAwMDBjIDAwMDAgIC4uLi4uLi4uLiMuLi4uLi4KCTB4MDBhMDogIDAwMDMgMDAwMCAwMDAw
IDAwMDAgMDEwYyAwMDAwIDAwMDQgMDAwMCAgLi4uLi4uLi4uLi4uLi4uLgoJMHgwMGIwOiAg
MDAwMyAwMDAwICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAuLi4uCjAwOjAwOjE4
LjgxMzI0MSBBRiBVbmtub3duICg0Mjk0OTI2MDc1KSwgbGVuZ3RoIDU2OiAKCTB4MDAwMDog
IDlhMTcgZTBkNSA1ZWE0IGVkY2MgMjlhNiBjMGE4IDAyMDEgMDAwMCAgLi4uLl4uLi4pLi4u
Li4uLgoJMHgwMDEwOiAgMDAwMCAwMDAwIDAwMDAgMDAwMCAwMDAwIDAwMDAgMDAwMCAwMDAw
ICAuLi4uLi4uLi4uLi4uLi4uCgkweDAwMjA6ICA5YTA3IDAyMGMgZTI1MSAwMDAzIDM5NGMg
MzAzNSAyMDMxIDE0MzAgIC4uLi4uUS4uOUwwNS4xLjAKCTB4MDAzMDogIDNhOGUgMjAzMSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOi4uMQowMDowMDoxOS44MzcyMjMgQUYg
VW5rbm93biAoNDI5NDkyNjA3OSksIGxlbmd0aCA3MDogCgkweDAwMDA6ICA5YTA3IGUwZDUg
NWVhNCBlZGNjIDI5YWYgMDAwMSAwODAwIDA2MDQgIC4uLi5eLi4uKS4uLi4uLi4KCTB4MDAx
MDogIDAwMDEgZTBkNSA1ZWE0IDRjY2MgODAwMCAwMjAyIDAwMDAgMDAwMCAgLi4uLl4uTC4u
Li4uLi4uLgoJMHgwMDIwOiAgMDAwMCBjMGE4IDAyMDEgMDAwMCAwMDAwIDAwMDAgMDAwMCAw
MDAwICAuLi4uLi4uLi4uLi4uLi4uCgkweDAwMzA6ICAwMDAwIDAwMDAgMDAwMCAwMDAwIDlh
MDcgMDIwYyBhMzhhIDAwMDMgIC4uLi4uLi4uLi4uLi4uLi4KCTB4MDA0MDogIDIxMDMgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIS4KMDA6MDA6MjAuODYxMjE5IEFG
IFVua25vd24gKDQyOTQ5MjYwNzkpLCBsZW5ndGggNTY6IAoJMHgwMDAwOiAgOWFkNyBlMGQ1
IDVlYTQgZWRjYyAyZGFmIGMwYTggMDIwMSAwMDAwICAuLi4uXi4uLi0uLi4uLi4uCgkweDAw
MTA6ICAwMDAwIDAwMDAgMDAwMCAwMDAwIDAwMDAgMDAwMCAwMDAwIDAwMDAgIC4uLi4uLi4u
Li4uLi4uLi4KCTB4MDAyMDogIDlhMDcgMDA0YyBhYTIwIDAwMDMgMzk0OCAwMDAwIDAwMDAg
MDAwMCAgLi4uTC4uLi45SC4uLi4uLgoJMHgwMDMwOiAgMjEwMCAwMDAwICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAhLi4uCjAwOjAwOjIxLjg4NTIxNyBBRiBVbmtub3duICg0
Mjk0OTA5NjkxKSwgbGVuZ3RoIDU2OiAKCTB4MDAwMDogIDlhMDcgYzBhOCAwMjAxIDAwMDAg
MjEyMSAwMDAwIDAwMDAgMDAwMCAgLi4uLi4uLi4hIS4uLi4uLgoJMHgwMDEwOiAgMDAwMCAw
MDAwIDAwMDAgMDAwMCA5YTA3IDAyMGMgMjVhOSAwMDAzICAuLi4uLi4uLi4uLi4lLi4uCgkw
eDAwMjA6ICAyMTA0IDAwMDAgMDE3MCA0ODMyIDAyMDAgMDAwMCAwMDAzIDAwMDAgICEuLi4u
cEgyLi4uLi4uLi4KCTB4MDAzMDogIDIxMDQgMDAwMCAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIS4uLgpeQwo2IHBhY2tldHMgY2FwdHVyZWQKNiBwYWNrZXRzIHJlY2VpdmVk
IGJ5IGZpbHRlcgowIHBhY2tldHMgZHJvcHBlZCBieSBrZXJuZWwKIyBwaW5nIDE5Mi4xNjgu
Mi4yClBJTkcgMTkyLjE2OC4yLjIgKDE5Mi4xNjguMi4yKTogNTYgZGF0YSBieXRlcwpeQwot
LS0gMTkyLjE2OC4yLjIgcGluZyBzdGF0aXN0aWNzIC0tLQo3IHBhY2tldHMgdHJhbnNtaXR0
ZWQsIDAgcGFja2V0cyByZWNlaXZlZCwgMTAwJSBwYWNrZXQgbG9zcwojIAo=
--------------B2kTEFN8ZUTqa40kjsZFlmDv
Content-Type: application/x-pcapng; name="new-mt7530-port5-malformed.pcapng"
Content-Disposition: attachment; filename="new-mt7530-port5-malformed.pcapng"
Content-Transfer-Encoding: base64

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
AAAAAAAAAABsAAAA

--------------B2kTEFN8ZUTqa40kjsZFlmDv--
