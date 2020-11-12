Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989052B032F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgKLKxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:53:24 -0500
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:50017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727819AbgKLKxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 05:53:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFUBNc5GfU6NrAr9/8oMVpx8E0P2lWzelj6mSCTjHTRmwsWNQGuJhppuxZg1/gUODgr2azK+EM+3jSWkp0zlkPgfmbkxrZv8zBmdiQvIcINI1p5uX3XcAYa0UrGgrMsFtv5cN4ezqdZL3oeMaOBja4oG3L7/n18EclAVqLF0az/H9E/FWXQLnpOLEm3B4QcNZTfN2NDiQ0XrRERcmRYj7ek5XBOJwOJh/MhJ3LOtfASCX2p1gtxqYK0p8hgeBeF70xASOOLxvjvk4TCjk/I4SOnuloUfik9QFKT8bJPEMWFwR9BBuYSU8w4R0VD7ifrGD2beKYYDKcFmLVlr64m6+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyLVFKR/Oar27w+kuoTIRfXL3HV8m+O3VcBcX+10F3g=;
 b=mnwbFIB6np8ciS6ItbbfGRzjLUn7Zt7+uFKe8AO/8w4xITiFFnLyxPG0ZztbBUV0Iq+Gm2jrsDJ35BsfW/AmAp5TDR8mkxwnPgbW1eIij3qmW2TPXyPh0byMc55hENcJuwrqlEShcGIvt3Zg6ksnoqBsNxXMYZAHRYxXyx42qv7/CXyCTkv27NUENBN4Ii1Hcm69LwY3vU1Kp2RbJniCQ1pTaJ+JQzPSTiR3EjV3PXfBXSnEbPukTQN/c592UO7TrC4DJBL4vHnHCUMVvLLPAnjA3Qj6z9oYjsPXGyLoUHAjh79O05aFdNYSM/b658moAMjzrIxYp+4Y7W1ejwrjBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ipetronik.com; dmarc=pass action=none
 header.from=ipetronik.com; dkim=pass header.d=ipetronik.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ipetronik.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyLVFKR/Oar27w+kuoTIRfXL3HV8m+O3VcBcX+10F3g=;
 b=cYkfnnB/a5SYwMcags1UpBPGjdtvkmZeu4VyvMuV+EAsS1XyCOpAMtZz5LqaMBE7bNr5zdvYjKgKbL/+Sj9lUC4zFfFD6skoA7KVGb8CBUSKkASsRts616eqoT1/UoSMtgRzfu/zJTcrYtr/7DBszEMr9b/ewkXSEo72Jc3rBg1CuRHm+o6RDSWDfwkFwqX/BcT6YoDORcN3tLMsxzyszZfQ/8R0Sf1Wd8oosKRRmTAqCnw0+xWaGZf4AboWFgIGkNHLcsK8oKB1HE9GxY/6ex4bynmBFDBRv2x4AuZ/rqnd0UIkvLcY3v5Aui3Q9LC5tJHayrLLO1iRn1s5jB4a1g==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=ipetronik.com;
Received: from PR3P193MB0537.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:34::19)
 by PR3P193MB0928.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 10:53:17 +0000
Received: from PR3P193MB0537.EURP193.PROD.OUTLOOK.COM
 ([fe80::8420:63a5:bcc2:6268]) by PR3P193MB0537.EURP193.PROD.OUTLOOK.COM
 ([fe80::8420:63a5:bcc2:6268%9]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 10:53:17 +0000
Date:   Thu, 12 Nov 2020 11:53:15 +0100
From:   Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201112105315.o5q3zqk4p57ddexs@ipetronik.com>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
 <20201111164727.pqecvbnhk4qgantt@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201111164727.pqecvbnhk4qgantt@skbuf>
X-Originating-IP: [2001:16b8:2d60:3000:228:f8ff:feed:2952]
X-ClientProxiedBy: AM0PR06CA0134.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::39) To PR3P193MB0537.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:34::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ipetronik.com (2001:16b8:2d60:3000:228:f8ff:feed:2952) by AM0PR06CA0134.eurprd06.prod.outlook.com (2603:10a6:208:ab::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 10:53:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebbb47b4-9182-4ac4-2b9a-08d886f9297c
X-MS-TrafficTypeDiagnostic: PR3P193MB0928:
X-Microsoft-Antispam-PRVS: <PR3P193MB0928A97E099F62257AF4761692E70@PR3P193MB0928.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2fRrNnNp28Db4/YYxipMuyArgaafmoX8qE6tBahqAGcGxb+D7tXtQ+mxpAuFL9M9XP5HMAXQI9MuHTQ1r0tPzROxslsSoerEvgjrUHs46QQ2YqPX1DsKLdaFOA9Tl103xqMUK9g+3g1kOusA66idmj2wAYdwPic6OQ/iQp5h5MVrQVw2jPorYBfCeBavcHcER8IvRWd9cLJXx4P043BX+XR8xpOPFMoHkKPy9rYaFPDOnquUYjvfyWr2Y7B66GzDZhSC/DYdrpgA9AV8vDgHSHatl6FVpzMEX3rcynu+r1WyCUzB3Srdb7shKXPLT5dz84isoXRyWo19Yg/CsPlt3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0537.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(83380400001)(186003)(55016002)(5660300002)(86362001)(2906002)(36756003)(1076003)(7696005)(16526019)(52116002)(2616005)(8676002)(4326008)(8886007)(66946007)(66556008)(498600001)(110136005)(7416002)(54906003)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WU1QUThPZWJPc3lJN0ZxZ2JBTHZ2WmlEZnR1SER1eElGVEIyUXg0L2R5bUxr?=
 =?utf-8?B?LzZUR0NlcDNPanVGM0xMSlJtV2VQWktQOHM2N1dIYlBPd2dGeWxxQUh5Uldn?=
 =?utf-8?B?VldqMk1jblJTYXRYYXc5N05nSC9Mc1Y3bGxjUEVwTUQ0ZmttY3ZyMUpNODY4?=
 =?utf-8?B?aWYyNCtTYkFjOThBeHpnci92TVp4dzRhaURFS25lV3dOaExIYk9hNDVlR0hX?=
 =?utf-8?B?UnZwUm1DQkRuM00remd5V2pCM3VveGVMb002M2tRT1YyUVFhNzFZWUNkQU5X?=
 =?utf-8?B?UFlYMC9sZ2VYRmlMS0ZhMDFhelJRMWJVeld0aEZQbko4T1hyaXpSUklkQU5C?=
 =?utf-8?B?SVJ2VnZrM3BZaVgyRVBXUW9rem8yemdxNURBTTlGcGpBSVhxWUFUT3o3dDUy?=
 =?utf-8?B?eU1zQ2s2TW81S3FlQkh1MWk0ZVAwYm45QkpYU0ZITnpwMWlhRXBLNEJZWVlw?=
 =?utf-8?B?MU1ESEEyaXpOQTl3Z1RCcWt5SjBHc1h0VTVUT0JXdnpvbjBYVlFVWkdtOCsv?=
 =?utf-8?B?SzFOVGxJWkVVZnU2Y0J4bUpsL2g3M3JzWnpyOHEybU0zVzlDZzlkN2paZkZw?=
 =?utf-8?B?M3NZUWljS2kyVW16VnRjR0NWNEhNYTRldzFnUUJlZWpIZ3FYQmtZZjhqOXpa?=
 =?utf-8?B?Z2UreUJIRzJoRmljWEJjM21aTmVESzNMSTFBL2o4UGR4NFBMYXVTOWZTTlRi?=
 =?utf-8?B?a1F6Ni9iOGlacEV1c1puN05jMW55a0xrL2hOOUM0OUpXMXNPRUMxZWRCRWV3?=
 =?utf-8?B?N3Z5T01hTlpBc2t6OXZ4V1p0YTZ5VnpHby9mWk84WnRQcHdKT1BjdC9tUyt6?=
 =?utf-8?B?cmZ6aDZuRmxJOEMraVBEOGJBcnBiN0JZRTZvUEJvcWo1Y2ZSSzRuQ2hJaXN6?=
 =?utf-8?B?QnJTOXMxZkhYL0t5M2EzSVlOUU8ySlBEN2F5WkVKTS9keWxiQUVvZTZTdCtC?=
 =?utf-8?B?QU5oamRxZTZwcWJHbVV2c3BJVkFnTCs5M1NlOUM1OUpZdHhXb2xHRjdhbC95?=
 =?utf-8?B?WXlSNkpPWmxreWt5NjdJaXJyM1d5aTNkNTdlQ29keEJiL1AxNng5WGp0cFhx?=
 =?utf-8?B?dEt1U1JIeEJNVEN0VnVEUWF0UGFWbTZkUnBRRWVFR1VZQUZ2Q2xxTjJzdlZL?=
 =?utf-8?B?NGRud3ZRTlFxVkhXWXNrcHhONnc3VDJGSGJtVWl1b0Y2WXF4VXRabDl3TUtv?=
 =?utf-8?B?VGhoN1NZL012dCtmRTF6cHhGaGVibHJ0VjQ2a0puc0ZKcHQwTU9MWlI5cXN1?=
 =?utf-8?B?MXMxV29ZeHRvV1BCT1A1a2VCdVJoZmFVdjhQWDJDb1R0bkdnUT09?=
X-OriginatorOrg: ipetronik.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbb47b4-9182-4ac4-2b9a-08d886f9297c
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0537.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 10:53:17.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 982fe058-7d80-4936-bdfa-9bed4f9ae127
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/YoQaNMWkb408xmW/nyOSXKj1ButDX4/EI5Ux7PVTvNNIy8+e0XpWf0heXf8Y6YqcicmxRMZHpYFpqSAfHIjOsmWuuOfiFPCRR9Htt+7Rg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0928
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 06:47:27PM +0200, Vladimir Oltean wrote:
> On Wed, Nov 11, 2020 at 07:56:58AM -0800, Florian Fainelli wrote:
> > The semantics of promiscuous are pretty clear though, and if you have a
> > NIC with VLAN filtering capability which could prevent the stack from
> > seeing *all* packets, that would be considered a bug. I suppose that you
> > could not disable VLAN filtering but instead install all 4096 - N VLANs
> > (N being currently used) into the filter to guarantee receiving those
> > VLAN tagged frames?

Adding all VLAN ids to the filter is certainly a possibility, I just don't
see why that redundant extra lookup per frame should be done in the NIC.

I guess, we could also put that feature on WISH while promisc ist active.
That, at least, makes it clear what happened.

> 
> Are they?
> 
> IEEE 802.3 clause 30.3.1.1.16 aPromiscuousStatus says:
> 
> APPROPRIATE SYNTAX:
> BOOLEAN
> 
> BEHAVIOUR DEFINED AS:
> A GET operation returns the value “true” for promiscuous mode enabled, and “false” otherwise.
> 
> Frames without errors received solely because this attribute has the value “true” are counted as
> frames received correctly; frames received in this mode that do contain errors update the
> appropriate error counters.
> 
> A SET operation to the value “true” provides a means to cause the LayerMgmtRecognizeAddress
> function to accept frames regardless of their destination address.
> 
> A SET operation to the value “false” causes the MAC sublayer to return to the normal operation
> of carrying out address recognition procedures for station, broadcast, and multicast group
> addresses (LayerMgmtRecognizeAddress function).;
> 
> 
> As for IEEE 802.1Q, there's nothing about promiscuity in the context of
> VLAN there.
> 
> Sadly, I think promiscuity refers only to address recognition for the
> purpose of packet termination. I cannot find any reference to VLAN in
> the context of promiscuity, or, for that matter, I cannot find any
> reference coming from a standards body that promiscuity would mean
> "accept all packets".

From what I can see, most other drivers use a special hardware register
flag to enable promiscuous mode, which overrules all other filters.
e.g. from the ASIX AX88178 datasheet:

  PRO:  PACKET_TYPE_PROMISCUOUS.
    1: All frames received by the ASIC are forwarded up toward the host.
    0: Disabled (default).

It is just so that the lan78xx controllers don't have this explicit flag.


But since my change is more controversial than I anticipated, I would like
to take a step back and ask some general questions first:

We used to connect something akin to a port mirror to a lan7800 NIC
(and a few others) in order to record and debug some VLAN heavy traffic.
On older kernel versions putting the interface into promiscuous mode
and opening and binding an AF_PACKET socket (or just throwing tcpdump
or libpcap at it) was sufficient.
After a kernel upgrade the same setup missed most of the traffic.
Does this qualify as a regression? Why not?

Should there be a documented and future proof way to receive *all*
valid ethernet frames from an interface? This could be something like:

a) - Bring up the interface
   - Put the interface into promiscuous mode
   - Open, bind and read a raw AF_PACKET socket with ETH_P_ALL
   - Patch up the 801.1Q headers if required.

b) - The same as a)
   - Additionally enumerate and disable all available offloading features

c) - Use libpcap / Do whatever libpcap does (like with TPACKET)
   In this case you need to help me convince the tcpdump folks that this
   is a bug on their side... ;-)

d) - Read the controller datasheet
   - Read the kernel documentation
   - Read your kernels and drivers sources
   - Do whatever might be necessary

e) - No, there is no guaranteed way to to this

Any opinions on these questions?
After those are answered, I am open to suggestions on how to fix this
differently (if still needed).
I'd rather not get involved into discussions on flow filters as I am
absolutely clueless in this regard.


PS: Sorry for sending from my companies mail server. It does some nasty
transformations on the body to outgoing mails I just complained about.
If this isn't resolved soon, I might follow up using another
address which should preserve patches.

