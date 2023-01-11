Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B45666035
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbjAKQSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbjAKQRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:36 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563D51CB13;
        Wed, 11 Jan 2023 08:17:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKd4ZaGN2fwkTNtxxf5sM2pE4NDMfJ3KZ2l3ghF5cZUTnIKp37zyNACtUwXY0Vmgfa3CJVsxZm9PGr7NCaQcAIqv6r4bgSVy2WM2fMXCsrVs8zYVeTADut61Bauheho3oKaQnv7DKz5kjixcCgaBNHbeMVm40qlKuWUY+waCKkEnR1n+pCmCt9gYf/BzCxWbYf72QsLv39gWWk2NqKrmj4oVWJ3vvZyXTs/cl+OelHnVbpf2NNacF9Cvt5g36EkjJnOA/XfnLkChQo6ldOvV5DmLkaKEBu2E6kjXpkqZfPIMD7tHyhxUdqIaldLELCAKbdf+KDzYtYPIjOFBm3JVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQOnehjKcyI98mQhWBbwELdea7SwmpicWmcqIuoAMx0=;
 b=O2pxn5QBjFjaN3W0+VJzrdXNjt8Q/35DiyELzPUyPCTa0WDJ9P777+k/8oSfRzbCQRKeHqVOxgCm5D5FFVTR9CS8lEE/k2JHJsAhI/bN8jAwiezIp3v2KdKlWYVgiTjYpawWdEgvqywEnk3c2446RZMjLazpi3oewKuCwPAtoZXNJT8ub8PeYeS2cWHxUxHCB2hVLTIVlUYNEwcUriQ9zbzUA8sF7CyOmJy9+BJeDrmMny8WrhipCeOIe01a1Ah/RuO8DNwJGWNkGjovK/VB3yt0eNDvoxwoYt5Gj9QDiL/3ZubFlJeIPQHM9OI9+67sNauImboxuUtl/J6PD2/gaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQOnehjKcyI98mQhWBbwELdea7SwmpicWmcqIuoAMx0=;
 b=Mf1cSTPncYUR193qcH1vxu1/HYP9JSHdVIcDncucryb70gSxAOfCsY992T8hEvfE6QqUgYJYlHi268lGR8fMZK1PCXMFlm0iBejwsf509VY4dAwiaI7JX6NHvdVE93g4JlTcmcpPGQHRbRh9nwxR5+1gom3KNyPAGqQtVtZttHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 02/12] net: ethtool: add support for MAC Merge layer
Date:   Wed, 11 Jan 2023 18:16:56 +0200
Message-Id: <20230111161706.1465242-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f797211-c0d4-489a-15f3-08daf3ef5018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +pdawDRMlNsPpyPvmh0bYGeu4K5aRxME7xTRyh9YTei5/0KBepsqVcs7uuYW99Bdtx8RkhyRX3gczd58QoAW5Tayhx1BGzkoahUB00OWXR4G8S/1DTAJ6UqLlrY9Cqmw0rOg6pSu8wTKz2/eYauTJEW/nnjhyi9D0UBnLZDgPtGx+30zUYEXKMPy7/hzdEcQ+fxgQ9yPa1QA2fuCZv3HzsU+6VT/2SJNFaPRJBTpXvj4dsnPppnRyJ90JOvAZJWSMxarlMSnLJD51wbI9+Zr6H+QBdiY104yfXTC1GmWMUS+5YGOzSBXaa3w2yBBpq7Z/nijqVryieMz7ykZvkjBcdAVh/EJP95fJhvQ4GXS9SCAhHVpEjnA4UAgsDgRFllMtwCJ+YplizFUjPMP8NHzixX2SAFr+LO77aXgxTT07Gz7O6nZeZfam8dKlsIOdH0nEWxIPDc8IZ5AX+akfSFxg3LFY52PHsBHCf9wtrYxK2jyFIkU1ASjgGLNMWcCo3ALwbYEp3ENEwDsWUEoB/SfZr2O2nD9RDe+KxkLuEVUn5DoNYNP4kLA+kt7DCOOm7mt1kQ91mu/r4tT+FApsgXL1JGRSG7WCHc/FpstScgozl2KeAgQr0Y1xtasDFvkl0LrIhJBOdsNoSaEXi/QwN22D88z9ssjoGR0QxXa3nW6WtNq2N2ORZXAXbrzonQzQjIHFnq5W67WZRK3jFkLyI05rk6t/45cWad3HufZuL1DqSI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(30864003)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(66899015)(44832011)(2906002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHZncDEyRVVBUUdRcUN6WGlUZzlLQUUyM2JjNEVoY0RGSWxPTVRiR3BjSmhn?=
 =?utf-8?B?V2s5SDNUOGw2Z1BiaFFhUnNBQzJOV1ZHNEFwNFZ6SXBCUklieVp0cVF3M2lw?=
 =?utf-8?B?bVdMNi92OGZOOGhFRWRvQmVNdlRWcUpXa0Z2OW1pVW14QTAvYXE3SnpZclFU?=
 =?utf-8?B?NllvOGNLNzBiRWhBSW80cWdHdlF3bHc3cGNPWTdnZ1FLNG1ZUzBORE5EOURt?=
 =?utf-8?B?VWpaVzMyeDJtQXJIZkdlRWJwMVR1aVA5NDRTUnhhSkRXQVM5MTUvWXlIVHAr?=
 =?utf-8?B?NXdMaTlHRWk5YjBFWEU0blVjMXBaa0hkYmxxdVZlbDNwMlBIRWJHaEhieHRl?=
 =?utf-8?B?ang4a0JlU1JHYVJpdlBLZmVQTGpCdmFCWDgyRW16bWFzUnBiQ3FkK2oyMnk1?=
 =?utf-8?B?WTRkNEpxSDkyVmEyYkFXSjFNN1JHNEtsWHE4MnNVWTZIUWx5YllrOVU1aGtD?=
 =?utf-8?B?bE1PcWxraTVBTnFXNms3VVRGNEI5bHordGMrWC9GK3Jic3lDVjVEV1VqZzMy?=
 =?utf-8?B?dWVxYy9PbmZaWitGbWxHS1kzRjZyeDhwSytweDU4MmZINFVDRzBiNExNMFFt?=
 =?utf-8?B?dXM4M0FYYUFxNGtwOEVReTZISFZzdm9zTy9YMXpVYXoyNXhjbTBXa3ByUkZq?=
 =?utf-8?B?Q0hUNzFmT1U2STY2MjYrWVNvdzA4eU0rbU5Jenp2N0FORWlNcVByYWFSdHpp?=
 =?utf-8?B?T0RrSlYwcnFTYndxZXk0MjNYT1pHQ09vUkJ5TFVFRnMrd2NHdTN4NWhaVXhL?=
 =?utf-8?B?K2o2UHRDbjR6YzFPVzVKWVhwdm9ORitzZmxld0k0cHVwL2l3VWl0NUMvY1F3?=
 =?utf-8?B?bFd4MEltc2p0VytjUk5oVFc2N01XSWJYVUp4c0puVEFVQXlobDNuaHhzOTNs?=
 =?utf-8?B?MzB0RVdXTU1SRHBkaFpGNWt4eTRZNUV4L0Q4aXh3Qm5nZnVSQWN3bDVsU0pW?=
 =?utf-8?B?S1lOdnNSVllldEE4ZVZrQlI0aTNtMlhTTFpaeFpUeWlsT0cxN2hVS1JSMThy?=
 =?utf-8?B?a2tKMU5DSWp2aWE5cms5RjExYnpMV3VpTDFSL1FQY0xvaFhCRXh5Mzg0ZnRJ?=
 =?utf-8?B?bEZBVXhwaHpNbCt2Z0VTcVJBN3ZNVVZVY3UrczhDUmtMd1puYUN5ejZqNURL?=
 =?utf-8?B?N3B4amJ5cDBtbllhdWNHZ1JRbjhnMmxzM3ZvL1NRTHNndlhaWnJXT2xjQzQ0?=
 =?utf-8?B?YjBkbzJFd2NMSElRczg4cmZYOUF5aS9UWW0zcWdaTWF2aUlPc3YxVVhoZFBp?=
 =?utf-8?B?S0w1RzNBdS8xby9pRlBWTHl4RlNPTlgyb2lSUWRqV1VQQ045ZU9TUDN5NTlI?=
 =?utf-8?B?ZjJVTjJDUVErQzZ6SkV2N2xnZ09oNXdkN281c3BYaGZoS3NCd1NPTGFSZm5T?=
 =?utf-8?B?M3QxUnRMQXQ5Wmo1L0VkcmRaOXVuZVhZSFA4cm03TTZaNDhGVStFdEtmNzRG?=
 =?utf-8?B?aFR6WlRHaFBqUnBtbEpwZzNSK2pVK0FZQWw4MkRkNStKOFJ6STZRSnV6QXhr?=
 =?utf-8?B?NE1TRzA5MXk0M3JoVStaUDVUUlVGVkJsT3BxSnZyaURlRDlZMFVvS3J5VEFD?=
 =?utf-8?B?NnJJK2tYRzZVc0tKM0FIZkZrTWI1QWltQmFKOC8vbDIzNEVOcTJ5RjYyeUIz?=
 =?utf-8?B?QXBqVFk0K1h4V1MxVHg2NUhBNmZ1MmozQ0UvdHEwYXBydkp2YnpnckdTTWpZ?=
 =?utf-8?B?RlBZR0lPVWZwemQyZGZlZU9oeTU2bjQvcXNjSHliN1pHYmhTcE85RXAvQTVy?=
 =?utf-8?B?bnlYeUc5emdLZ01heUFVWVVoaW5aeTB2UDhUazNpNkEyL1pZNHJLN2tUTEMy?=
 =?utf-8?B?dWhFTjJWZDVUU09mcGtsekFHWVI5SXVBVm1yOVExVy9OTHA2YjE2T01YN1hR?=
 =?utf-8?B?VWE3NFFPOGhhaW1jTFBpTE9vNUVKZmUvNHNCNS9reGpyb1ZCTVVJVUljUStT?=
 =?utf-8?B?UTRBT3VNQ3RlYXpRN28zVzlKU0tsSGFiNFJQVUFHSWJGZ3pSZ1pmTTh5NG8z?=
 =?utf-8?B?bm5RRmhmd1ZLSDZiNVFySmE1TVlFbUNZZ01NTnI1ZjhDVlVPdTdDV0hTWEpr?=
 =?utf-8?B?M1E0eEhwaG9jSGlQMlc4bWMzbDNiU2NpK2ViL2VzM05OL01KQUhVelNLMStX?=
 =?utf-8?B?Q0g3TTN5QVk3R3ppNXkvRnhwc2k1WGRsZDcxTlovZDYzSzhOUWdWNVlNei9F?=
 =?utf-8?B?Rmc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f797211-c0d4-489a-15f3-08daf3ef5018
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:19.5022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyqJ5ublE9WWHOysLl+F3OE0rGcHBCC209BE4oHw/FfUEX2chT9IbQK+2Qv13wuQpoWr/+G0jM7Gis26Dkzd4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC merge sublayer (IEEE 802.3-2018 clause 99) is one of 2
specifications (the other being Frame Preemption; IEEE 802.1Q-2018
clause 6.7.2), which work together to minimize latency caused by frame
interference at TX. The overall goal of TSN is for normal traffic and
traffic with a bounded deadline to be able to cohabitate on the same L2
network and not bother each other too much.

The standards achieve this (partly) by introducing the concept of
preemptible traffic, i.e. Ethernet frames that have a custom value for
the Start-of-Frame-Delimiter (SFD), and these frames can be fragmented
and reassembled at L2 on a link-local basis. The non-preemptible frames
are called express traffic, they are transmitted using a normal SFD, and
they can preempt preemptible frames, therefore having lower latency,
which can matter at lower (100 Mbps) link speeds, or at high MTUs (jumbo
frames around 9K). Preemption is not recursive, i.e. a P frame cannot
preempt another P frame. Preemption also does not depend upon priority,
or otherwise said, an E frame with prio 0 will still preempt a P frame
with prio 7.

In terms of implementation, the standards talk about the presence of an
express MAC (eMAC) which handles express traffic, and a preemptible MAC
(pMAC) which handles preemptible traffic, and these MACs are multiplexed
on the same MII by a MAC merge layer.

To support frame preemption, the definition of the SFD was generalized
to SMD (Start-of-mPacket-Delimiter), where an mPacket is essentially an
Ethernet frame fragment, or a complete frame. Stations unaware of an SMD
value different from the standard SFD will treat P frames as error
frames. To prevent that from happening, a negotiation process is
defined.

On RX, packets are dispatched to the eMAC or pMAC after being filtered
by their SMD. On TX, the eMAC/pMAC classification decision is taken by
the 802.1Q spec, based on packet priority (each of the 8 user priority
values may have an admin-status of preemptible or express).

The MAC Merge layer and the Frame Preemption parameters have some degree
of independence in terms of how software stacks are supposed to deal
with them. The activation of the MM layer is supposed to be controlled
by an LLDP daemon (after it has been communicated that the link partner
also supports it), after which a (hardware-based or not) verification
handshake takes place, before actually enabling the feature. So the
process is intended to be relatively plug-and-play. Whereas FP settings
are supposed to be coordinated across a network using something
approximating NETCONF.

The support contained here is exclusively for the 802.3 (MAC Merge)
portions and not for the 802.1Q (Frame Preemption) parts. This API is
sufficient for an LLDP daemon to do its job. The FP adminStatus variable
from 802.1Q is outside the scope of an LLDP daemon.

I have taken a few creative licenses and augmented the Linux kernel UAPI
compared to the standard managed objects recommended by IEEE 802.3.
These are:

- ETHTOOL_A_MM_PMAC_ENABLED: According to Figure 99-6: Receive
  Processing state diagram, a MAC Merge layer is always supposed to be
  able to receive P frames. However, this implies keeping the pMAC
  powered on, which will consume needless power in applications where FP
  will never be used. If LLDP is used, the reception of an Additional
  Ethernet Capabilities TLV from the link partner is sufficient
  indication that the pMAC should be enabled. So my proposal is that in
  Linux, we keep the pMAC turned off by default and that user space
  turns it on when needed.

- ETHTOOL_A_MM_VERIFY_ENABLED: The IEEE managed object is called
  aMACMergeVerifyDisableTx. I opted for consistency (positive logic) in
  the boolean netlink attributes offered, so this is also positive here.
  Other than the meaning being reversed, they correspond to the same
  thing.

- ETHTOOL_A_MM_MAX_VERIFY_TIME: I found it most reasonable for a LLDP
  daemon to maximize the verifyTime variable (delay between SMD-V
  transmissions), to maximize its chances that the LP replies. IEEE says
  that the verifyTime can range between 1 and 128 ms, but the NXP ENETC
  stupidly keeps this variable in a 7 bit register, so the maximum
  supported value is 127 ms. I could have chosen to hardcode this in the
  LLDP daemon to a lower value, but why not let the kernel expose its
  supported range directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- added documentation
- introduced pmac_enabled
- transformed verify_disable into verify_enabled
- made add_frag_size take a value in octets
- removed FP params (adminStatus)
- renamed "enabled" to "tx_enabled" and "active" to "tx_active"

 include/linux/ethtool.h              |  99 ++++++++++
 include/uapi/linux/ethtool.h         |  25 +++
 include/uapi/linux/ethtool_netlink.h |  47 +++++
 net/ethtool/Makefile                 |   4 +-
 net/ethtool/mm.c                     | 258 +++++++++++++++++++++++++++
 net/ethtool/netlink.c                |  19 ++
 net/ethtool/netlink.h                |   4 +
 7 files changed, 454 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/mm.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9e0a76fc7de9..6336f105e667 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -467,6 +467,98 @@ struct ethtool_module_power_mode_params {
 	enum ethtool_module_power_mode mode;
 };
 
+/**
+ * struct ethtool_mm_state - 802.3 MAC merge layer state
+ * @verify_time:
+ *	wait time between verification attempts in ms (according to clause
+ *	30.14.1.6 aMACMergeVerifyTime)
+ * @max_verify_time:
+ *	maximum accepted value for the @verify_time variable in set requests
+ * @verify_status:
+ *	state of the verification state machine of the MM layer (according to
+ *	clause 30.14.1.2 aMACMergeStatusVerify)
+ * @supported:
+ *	set if device supports the MM layer (according to clause 30.14.1.1
+ *	aMACMergeSupport)
+ * @tx_enabled:
+ *	set if the MM layer is administratively enabled in the TX direction
+ *	(according to clause 30.14.1.3 aMACMergeEnableTx)
+ * @tx_active:
+ *	set if the MM layer is enabled in the TX direction, which makes FP
+ *	possible (according to 30.14.1.5 aMACMergeStatusTx). This should be
+ *	true if MM is enabled, and the verification status is either verified,
+ *	or disabled.
+ * @pmac_enabled:
+ *	set if the preemptible MAC is powered on and is able to receive
+ *	preemptible packets and respond to verification frames.
+ * @verify_enabled:
+ *	set if the Verify function of the MM layer (which sends SMD-V
+ *	verification requests) is administratively enabled (regardless of
+ *	whether it is currently in the ETHTOOL_MM_VERIFY_STATUS_DISABLED state
+ *	or not), according to clause 30.14.1.4 aMACMergeVerifyDisableTx (but
+ *	using positive rather than negative logic). The device should always
+ *	respond to received SMD-V requests as long as @pmac_enabled is set.
+ * @add_frag_size:
+ *	the minimum size of non-final mPacket fragments that the link partner
+ *	supports receiving, expressed in octets. Compared to the definition
+ *	from clause 30.14.1.7 aMACMergeAddFragSize which is expressed in the
+ *	range 0 to 3 (requiring a translation to the size in octets according
+ *	to the formula 64 * (1 + addFragSize) – 4), a value in a continuous and
+ *	unbounded range can be specified here.
+ */
+struct ethtool_mm_state {
+	u32 verify_time;
+	u32 max_verify_time;
+	enum ethtool_mm_verify_status verify_status;
+	bool supported;
+	bool tx_enabled;
+	bool tx_active;
+	bool pmac_enabled;
+	bool verify_enabled;
+	u32 add_frag_size;
+};
+
+/**
+ * struct ethtool_mm_cfg - 802.3 MAC merge layer configuration
+ * @verify_time: see struct ethtool_mm_state
+ * @verify_enabled: see struct ethtool_mm_state
+ * @tx_enabled: see struct ethtool_mm_state
+ * @pmac_enabled: see struct ethtool_mm_state
+ * @add_frag_size: see struct ethtool_mm_state
+ */
+struct ethtool_mm_cfg {
+	u32 verify_time;
+	bool verify_enabled;
+	bool tx_enabled;
+	bool pmac_enabled;
+	u32 add_frag_size;
+};
+
+/**
+ * struct ethtool_mm_stats - 802.3 MAC merge layer statistics
+ * @MACMergeFrameAssErrorCount:
+ *	received MAC frames with reassembly errors
+ * @MACMergeFrameSmdErrorCount:
+ *	received MAC frames/fragments rejected due to unknown or incorrect SMD
+ * @MACMergeFrameAssOkCount:
+ *	received MAC frames that were successfully reassembled and passed up
+ * @MACMergeFragCountRx:
+ *	number of additional correct SMD-C mPackets received due to preemption
+ * @MACMergeFragCountTx:
+ *	number of additional mPackets sent due to preemption
+ * @MACMergeHoldCount:
+ *	number of times the MM layer entered the HOLD state, which blocks
+ *	transmission of preemptible traffic
+ */
+struct ethtool_mm_stats {
+	u64 MACMergeFrameAssErrorCount;
+	u64 MACMergeFrameSmdErrorCount;
+	u64 MACMergeFrameAssOkCount;
+	u64 MACMergeFragCountRx;
+	u64 MACMergeFragCountTx;
+	u64 MACMergeHoldCount;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -639,6 +731,9 @@ struct ethtool_module_power_mode_params {
  *	plugged-in.
  * @set_module_power_mode: Set the power mode policy for the plug-in module
  *	used by the network device.
+ * @get_mm: Query the 802.3 MAC Merge layer state.
+ * @set_mm: Set the 802.3 MAC Merge layer parameters.
+ * @get_mm_stats: Query the 802.3 MAC Merge layer statistics.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -777,6 +872,10 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	void	(*get_mm)(struct net_device *dev, struct ethtool_mm_state *state);
+	int	(*set_mm)(struct net_device *dev, struct ethtool_mm_cfg *cfg,
+			  struct netlink_ext_ack *extack);
+	void	(*get_mm_stats)(struct net_device *dev, struct ethtool_mm_stats *stats);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 3135fa0ba9a4..7ddc47a3fb32 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -779,6 +779,31 @@ enum ethtool_podl_pse_pw_d_status {
 	ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR,
 };
 
+/**
+ * enum ethtool_mm_verify_status - status of MAC Merge Verify function
+ * @ETHTOOL_MM_VERIFY_STATUS_UNKNOWN:
+ *	verification status is unknown
+ * @ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+ *	the 802.3 Verify State diagram is in the state INIT_VERIFICATION
+ * @ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+ *	the Verify State diagram is in the state VERIFICATION_IDLE,
+ *	SEND_VERIFY or WAIT_FOR_RESPONSE
+ * @ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+ *	indicates that the Verify State diagram is in the state VERIFIED
+ * @ETHTOOL_MM_VERIFY_STATUS_FAILED:
+ *	the Verify State diagram is in the state VERIFY_FAIL
+ * @ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+ *	verification of preemption operation is disabled
+ */
+enum ethtool_mm_verify_status {
+	ETHTOOL_MM_VERIFY_STATUS_UNKNOWN,
+	ETHTOOL_MM_VERIFY_STATUS_INITIAL,
+	ETHTOOL_MM_VERIFY_STATUS_VERIFYING,
+	ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED,
+	ETHTOOL_MM_VERIFY_STATUS_FAILED,
+	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5799a9db034e..e84a80957138 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -52,6 +52,8 @@ enum {
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
 	ETHTOOL_MSG_RSS_GET,
+	ETHTOOL_MSG_MM_GET,
+	ETHTOOL_MSG_MM_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -99,6 +101,8 @@ enum {
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
 	ETHTOOL_MSG_RSS_GET_REPLY,
+	ETHTOOL_MSG_MM_GET_REPLY,
+	ETHTOOL_MSG_MM_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -894,6 +898,49 @@ enum {
 	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
 };
 
+/* MAC Merge (802.3) */
+
+enum {
+	ETHTOOL_A_MM_STAT_UNSPEC,
+	ETHTOOL_A_MM_STAT_PAD,
+
+	/* aMACMergeFrameAssErrorCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS,	/* u64 */
+	/* aMACMergeFrameSmdErrorCount */
+	ETHTOOL_A_MM_STAT_SMD_ERRORS,		/* u64 */
+	/* aMACMergeFrameAssOkCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_OK,	/* u64 */
+	/* aMACMergeFragCountRx */
+	ETHTOOL_A_MM_STAT_RX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeFragCountTx */
+	ETHTOOL_A_MM_STAT_TX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeHoldCount */
+	ETHTOOL_A_MM_STAT_HOLD_COUNT,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_STAT_CNT,
+	ETHTOOL_A_MM_STAT_MAX = (__ETHTOOL_A_MM_STAT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_MM_UNSPEC,
+	ETHTOOL_A_MM_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_MM_SUPPORTED,			/* u8 */
+	ETHTOOL_A_MM_PMAC_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ACTIVE,			/* u8 */
+	ETHTOOL_A_MM_ADD_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_MM_VERIFY_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_STATUS,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_MAX_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_STATS,			/* nest - _A_MM_STAT_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_CNT,
+	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 228f13df2e18..ab824b2d3b7d 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
-		   pse-pd.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o mm.o \
+		   module.o pse-pd.o
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
new file mode 100644
index 000000000000..01a2acc40046
--- /dev/null
+++ b/net/ethtool/mm.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2022-2023 NXP
+ */
+#include "common.h"
+#include "netlink.h"
+
+struct mm_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct mm_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_mm_state		state;
+	struct ethtool_mm_stats		stats;
+};
+
+#define MM_REPDATA(__reply_base) \
+	container_of(__reply_base, struct mm_reply_data, base)
+
+#define ETHTOOL_MM_STAT_CNT \
+	(__ETHTOOL_A_MM_STAT_CNT - (ETHTOOL_A_MM_STAT_PAD + 1))
+
+const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1] = {
+	[ETHTOOL_A_MM_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy_stats),
+};
+
+static int mm_prepare_data(const struct ethnl_req_info *req_base,
+			   struct ethnl_reply_data *reply_base,
+			   struct genl_info *info)
+{
+	struct mm_reply_data *data = MM_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops;
+	int ret;
+
+	ops = dev->ethtool_ops;
+
+	if (!ops->get_mm)
+		return -EOPNOTSUPP;
+
+	ethtool_stats_init((u64 *)&data->stats,
+			   sizeof(data->stats) / sizeof(u64));
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	ops->get_mm(dev, &data->state);
+
+	if (ops->get_mm_stats && (req_base->flags & ETHTOOL_FLAG_STATS))
+		ops->get_mm_stats(dev, &data->stats);
+
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int mm_reply_size(const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	struct mm_reply_data *data = MM_REPDATA(reply_base);
+	const struct ethtool_mm_state *state = &data->state;
+	int len = nla_total_size(sizeof(u8)); /* _MM_SUPPORTED */
+
+	if (!state->supported)
+		return len;
+
+	len += nla_total_size(sizeof(u8)); /* _MM_PMAC_ENABLED */
+	len += nla_total_size(sizeof(u8)); /* _MM_TX_ENABLED */
+	len += nla_total_size(sizeof(u8)); /* _MM_TX_ACTIVE */
+	len += nla_total_size(sizeof(u8)); /* _MM_VERIFY_ENABLED */
+	len += nla_total_size(sizeof(u8)); /* _MM_VERIFY_STATUS */
+	len += nla_total_size(sizeof(u32)); /* _MM_VERIFY_TIME */
+	len += nla_total_size(sizeof(u32)); /* _MM_MAX_VERIFY_TIME */
+	len += nla_total_size(sizeof(u32)); /* _MM_ADD_FRAG_SIZE */
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS)
+		len += nla_total_size(0) + /* _MM_STATS */
+		       nla_total_size_64bit(sizeof(u64)) * ETHTOOL_MM_STAT_CNT;
+
+	return len;
+}
+
+static int mm_put_stat(struct sk_buff *skb, u64 val, u16 attrtype)
+{
+	if (val == ETHTOOL_STAT_NOT_SET)
+		return 0;
+	if (nla_put_u64_64bit(skb, attrtype, val, ETHTOOL_A_MM_STAT_PAD))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int mm_put_stats(struct sk_buff *skb,
+			const struct ethtool_mm_stats *stats)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_MM_STATS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (mm_put_stat(skb, stats->MACMergeFrameAssErrorCount,
+			ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS) ||
+	    mm_put_stat(skb, stats->MACMergeFrameSmdErrorCount,
+			ETHTOOL_A_MM_STAT_SMD_ERRORS) ||
+	    mm_put_stat(skb, stats->MACMergeFrameAssOkCount,
+			ETHTOOL_A_MM_STAT_REASSEMBLY_OK) ||
+	    mm_put_stat(skb, stats->MACMergeFragCountRx,
+			ETHTOOL_A_MM_STAT_RX_FRAG_COUNT) ||
+	    mm_put_stat(skb, stats->MACMergeFragCountTx,
+			ETHTOOL_A_MM_STAT_TX_FRAG_COUNT) ||
+	    mm_put_stat(skb, stats->MACMergeHoldCount,
+			ETHTOOL_A_MM_STAT_HOLD_COUNT))
+		goto err_cancel;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int mm_fill_reply(struct sk_buff *skb,
+			 const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	const struct mm_reply_data *data = MM_REPDATA(reply_base);
+	const struct ethtool_mm_state *state = &data->state;
+
+	if (nla_put_u8(skb, ETHTOOL_A_MM_SUPPORTED, state->supported))
+		return -EMSGSIZE;
+
+	if (!state->supported)
+		return 0;
+
+	if (nla_put_u8(skb, ETHTOOL_A_MM_TX_ENABLED, state->tx_enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_TX_ACTIVE, state->tx_active) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_PMAC_ENABLED, state->pmac_enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_VERIFY_ENABLED, state->verify_enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_VERIFY_STATUS, state->verify_status) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_VERIFY_TIME, state->verify_time) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_MAX_VERIFY_TIME, state->max_verify_time) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_ADD_FRAG_SIZE, state->add_frag_size))
+		return -EMSGSIZE;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS &&
+	    mm_put_stats(skb, &data->stats))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_mm_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MM_GET,
+	.reply_cmd		= ETHTOOL_MSG_MM_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MM_HEADER,
+	.req_info_size		= sizeof(struct mm_req_info),
+	.reply_data_size	= sizeof(struct mm_reply_data),
+
+	.prepare_data		= mm_prepare_data,
+	.reply_size		= mm_reply_size,
+	.fill_reply		= mm_fill_reply,
+};
+
+const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1] = {
+	[ETHTOOL_A_MM_HEADER]		= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MM_VERIFY_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_MM_VERIFY_TIME]	= NLA_POLICY_RANGE(NLA_U32, 1, 128),
+	[ETHTOOL_A_MM_TX_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_MM_PMAC_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_MM_ADD_FRAG_SIZE]	= NLA_POLICY_RANGE(NLA_U32, 60, 252),
+};
+
+static void mm_state_to_cfg(const struct ethtool_mm_state *state,
+			    struct ethtool_mm_cfg *cfg)
+{
+	/* We could also compare state->verify_status against
+	 * ETHTOOL_MM_VERIFY_STATUS_DISABLED, but state->verify_enabled
+	 * is more like an administrative state which should be seen in
+	 * ETHTOOL_MSG_MM_GET replies. For example, a port with verification
+	 * disabled might be in the ETHTOOL_MM_VERIFY_STATUS_INITIAL
+	 * if it's down.
+	 */
+	cfg->verify_enabled = state->verify_enabled;
+	cfg->verify_time = state->verify_time;
+	cfg->tx_enabled = state->tx_enabled;
+	cfg->pmac_enabled = state->pmac_enabled;
+	cfg->add_frag_size = state->add_frag_size;
+}
+
+int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct ethnl_req_info req_info = {};
+	struct ethtool_mm_state state = {};
+	struct nlattr **tb = info->attrs;
+	struct ethtool_mm_cfg cfg = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MM_HEADER],
+					 genl_info_net(info), extack, true);
+	if (ret)
+		return ret;
+
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+
+	if (!ops->get_mm || !ops->set_mm) {
+		ret = -EOPNOTSUPP;
+		goto out_dev;
+	}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret)
+		goto out_rtnl;
+
+	ops->get_mm(dev, &state);
+
+	mm_state_to_cfg(&state, &cfg);
+
+	if (cfg.verify_time > state.max_verify_time) {
+		NL_SET_ERR_MSG_MOD(extack, "verifyTime exceeds device maximum");
+		return -ERANGE;
+	}
+
+	ethnl_update_bool(&cfg.verify_enabled, tb[ETHTOOL_A_MM_VERIFY_ENABLED],
+			  &mod);
+	ethnl_update_u32(&cfg.verify_time, tb[ETHTOOL_A_MM_VERIFY_TIME], &mod);
+	ethnl_update_bool(&cfg.tx_enabled, tb[ETHTOOL_A_MM_TX_ENABLED], &mod);
+	ethnl_update_bool(&cfg.pmac_enabled, tb[ETHTOOL_A_MM_PMAC_ENABLED],
+			  &mod);
+	ethnl_update_u32(&cfg.add_frag_size, tb[ETHTOOL_A_MM_ADD_FRAG_SIZE],
+			 &mod);
+
+	ret = ops->set_mm(dev, &cfg, extack);
+	if (ret) {
+		if (!extack->_msg)
+			NL_SET_ERR_MSG(extack,
+				       "Failed to update MAC merge configuration");
+		goto out_ops;
+	}
+
+	ethtool_notify(dev, ETHTOOL_MSG_MM_NTF, NULL);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index aee98be6237f..a8c5b2521c46 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -288,6 +288,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
 	[ETHTOOL_MSG_RSS_GET]		= &ethnl_rss_request_ops,
+	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -603,6 +604,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_MM_NTF]		= &ethnl_mm_request_ops,
 };
 
 /* default notification handler */
@@ -696,6 +698,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_MM_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1047,6 +1050,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_rss_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_rss_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MM_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_mm_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_mm_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_MM_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_mm,
+		.policy = ethnl_mm_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 744b3ab966b0..a8012dbe39bb 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -373,6 +373,7 @@ extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
 extern const struct ethnl_request_ops ethnl_pse_request_ops;
 extern const struct ethnl_request_ops ethnl_rss_request_ops;
+extern const struct ethnl_request_ops ethnl_mm_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -414,6 +415,8 @@ extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MO
 extern const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1];
 extern const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1];
 extern const struct nla_policy ethnl_rss_get_policy[ETHTOOL_A_RSS_CONTEXT + 1];
+extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
+extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -434,6 +437,7 @@ int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
-- 
2.34.1

