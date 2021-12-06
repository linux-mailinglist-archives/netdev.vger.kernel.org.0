Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7FC46A1FE
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbhLFRH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:07:58 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348529AbhLFRBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=One3y0bq0UUnFCkGcKdpCS1kiAQNkf8UdwmrajUNIuX0s1fMKh7Jovv9jsnEaxgte420umOr7y+d2nwD0zJt1PR9yECpsIWpJ2z3Uep+v+0EfmdsDulnE/1/pSnnr1AKrfFK81VHNrXVMOBdsAGHt1kfaPzJQ5Ce+sPtz920cKSAyvjVx/JPgc6mplxY2HHx1a0U3xPJhpTvytjrJrXgm+uflx1NJj/Zo1gI82U2lVNuUuLdGzbm8TJpS0cHlUI/4YsT65pauiTpG/KpD8EEkrQFifzr7UDenYqpuj2pm+5m2+PavvXWLesHrC/r7l2zX52q8pNmNbCmt98l/aD/qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xl0VsTfGiE0/EU6l8C+56U9OBGwLA/bQ9jRjKn2r9Fg=;
 b=JA6XBUAxCLsuP6wtUho1c3p4osxvWxOATnqomGhK8YHS4NusYV8RqgA1HWs8jiyUQV2ySdSE+erVyOjowhCqb9sTYUvMc9c+n4D3zJn7PPhEvnjhqm2JBE+FhJxCiCHSz/lqZC49cIVTmpJIWV8MCT4p/m6/vQ92224uPa8+Juxwo5jH4FUnUOEDivqKfoKV346xi9xBbB+hr9+3oA9zfiV5Af25kbj4EHg2ak9JWTd9Q7X+C5URyB5uQXdOJ/4BdsTLWMnYlCsTFjOpMwdGfC8Ie7bUGYjr+qcqyD/CO5L/klhB/H42/7OkeS03YeDalXGWds3BRssUskpis9oHeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xl0VsTfGiE0/EU6l8C+56U9OBGwLA/bQ9jRjKn2r9Fg=;
 b=Stp8mf9M5w8CPWDrq9AUodD2Y0et2ed/1P/t1Kuh33cU9dI047nMaF5c9HMkUrlBxZbiXVcYQgOyygJupSgqt4KV8YiC2kV5cZqoCLs3gvpAE0nf/Djc6x4hmmDj1T77An6iW57tAnsCENYm6Va1BD2kBYT43vE1RU9yXuxJnlQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 00/12] Rework DSA bridge TX forwarding offload API
Date:   Mon,  6 Dec 2021 18:57:46 +0200
Message-Id: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb8ac109-fe73-4002-6407-08d9b8d9987d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB491287E0160120C6792C5931E06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZk75MRRDV1UH9yTKRBSOJNQWN4Gm3R8iGpuMJsOQ9uvwzh0NvpY/ye47ZoHPGqHeTxxAiOugMnyN0LWKCypLw0fki23uhD1Nos7NQGc62ImM7JOWQUuqhnNuTuzFlwIGDZ6ollgNhdrxWKwr/LaIhrtkxrPpAgGLAouBC4Wr51IUicwpaS8yTfZEO+OTdlp5G7VVVdKmygjkbMuRNEinXEuJQvUao+RNeePLoeQQPPuCTRGFKirD3S0uOgnpsKEafl5FZw2zN4lxfpQ+ctP9LZcfjLLKG6mprSwZSzyz47PE+HFMohICXeqhN9KgW6d6CV1SPbplkX3utGtm0u1t8+Rz9X2BYMKT2Z/+1rairCcJfYnYW6Ozr/GuMlgFuIul7FuyyiMRXS9EAMBlTQCpzFIfh4mN2/AChWVcmSZZRF1SCC5nLjPVDGo3rWhxJ4rScNC/bYB1REKJfm4sSSEEeIsWNmP0X4GNt6MDJQCPi5NuQwtbo+SaaRanBxGqdo9f36FtgV4tKpzY57Zh4ZTjjwHK9NSvZdXZ2ofrIXwjrsq/YK3OUp7pWhg0Fb/cay/3FhU2DNAzl7QBbRRw/QBrRpanW3PCtIc74kytLnzGFp3tajzbiPGm2zLoYzLjqk7ahmhNMUyLrUpArUOc8WVip6nwYsizzBgPWO1pVjH4f5JAtJq+nTOFTjRsf43turUZ/jNVX9BdYdakO9lz/nXlo8wfF0fTM0ZknRsRrFzYpvQ+oszxISEVwxcg/RlpzrS21QcQ3PXDWzDUIjJ5N+BslMtBDWXwllN0vFO+X40X2U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(966005)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjN4dG91OFZIVFVMNVVOSGJPbnQ1RXlNWllhY0FkY3BSY0Y5UVhUcXQwZzdi?=
 =?utf-8?B?M1ZnVnBFbmFaS0lpUnFpTTNSM3hyQWJ2L0ZsMTFWUWJYeGEwY3pvcUxmb21w?=
 =?utf-8?B?ci9RcXZSajR1a082OXB0WDcyN3dTNkhjc29DT05EMnV2bzZSWGtYWDhSZ0lH?=
 =?utf-8?B?Z0E4a2gxUkV0amxFbXp6NEYxbzBnRHlidkdEWXRwMXpNYTRYNnZva29venhi?=
 =?utf-8?B?WW91Rng1MXNhOVpCU29Na1RmUENwWVF0L2lTSXM0MTVMcyt3SnR3bVhueE1J?=
 =?utf-8?B?enJYcWoyK2c1aysyYWdiOXpvQXFrZkRXZmNMZWg2WDcxb2lzZkNyVVNWOFVR?=
 =?utf-8?B?UnBCSW1OVThGOUlVRkZSUU91S0prTnVwU1FiNXZuY0MvcVRya0gzOE94ZjFT?=
 =?utf-8?B?eVdUcGNVZzZmTkRMc2l5M1pXWHBsTVFVUnUrTUQwSVd3WnFnMjFIV1B5dzBP?=
 =?utf-8?B?Ni9aV3l6c3JvVWVsTHNPS05leW5GZ2l2Uzl6Y2pnUkprVFkwRXNPcUJGcW55?=
 =?utf-8?B?TWkrY0ZhU0lKOTNibi9SWW1XODFaRUkzNGF0L1M2SnFNYjllQU5Hb2xEMGlL?=
 =?utf-8?B?NkRqMDRsSHRTQm1meDl2T3d0KzkzbXhBYWlVdkZJYXRHVDc2OHpyOGtLUWtF?=
 =?utf-8?B?ZXlzc1VzOWNhUUUyTmNHYUltQXhZdTE4b0MrL3I3RmJScDV0TGZPWlpRa1ow?=
 =?utf-8?B?UUdDTGV2enFCZVBmSUNnY01xTW9MeDdGRDRYZ2xTRjBEMkVkbGFiVE4venQ1?=
 =?utf-8?B?ZVNJZ1JUMWlTNnNhYXpXSWlRMmJFUUkyUklYY2duZkFQcEFhM2V2ZG1zMDQw?=
 =?utf-8?B?NGg0Y1hTTXpYcnJEeHlNUjkwSm9IOEdLUUdueUVKWklqLy94TEFvWkhWUWZK?=
 =?utf-8?B?aEJZMjlFcEkyVDFJRDVOWDdvcURIU0VMOUdWT0VyRkdhL0lFOFduRzNoRjYz?=
 =?utf-8?B?SU40YnpCdFFQVXUwREsrWTV5STJUV2ZZN0d6Nm50bHdJV2NqeEVINml1KzNl?=
 =?utf-8?B?MTRLU3FzTUtOeXA2SVR0UG9wNzBNaTJacUpkNEFzUmtTaWcreTEvRXVGVURz?=
 =?utf-8?B?QzVYdmE4Z3hXUlJUSzBSeFJLNkZVWkY5azRVd3pNeit4dUtQMEVoOVA0bEJi?=
 =?utf-8?B?RUJZNWIwQ0t5UUY0YUhXOGlsYjBDbHhnbVYvNnArYzNscDdiRis3MHd1RlZx?=
 =?utf-8?B?emZCU2ttU2dEQkRaY1h0OWdFbmo5RVZ5UTZKMXQ5b085RTU0STYxdXNvTmd2?=
 =?utf-8?B?T3FOQ05ZbkhmVW1EV1pURGhMalRFSDVrRXZ2K2x3ZjAzNjBEaVBXL3BzajQ2?=
 =?utf-8?B?Z2NBaEx2QkFhaFUya1BBd2JhNjNXSnRSdmltQWdWN0swMmlYU0VtS29jSEFv?=
 =?utf-8?B?Y3lJckZrNE5PUXVZbFpCNWFVWVM0MDkxRkpOQW9NUmQ2R1NUUHhVY1dXeGJH?=
 =?utf-8?B?c2lEUnE1WmFZRUlTTlVtZ2VPU1VldXYySGtZVmtQOVFGdXkzMTdyMnc4cHFk?=
 =?utf-8?B?REE4VmsxU3EvdUZ1aTBsMHFyYmZwd2x6bVFVaU9xUS9Yd2l1VUJaS1c2K3dn?=
 =?utf-8?B?Vkkrem11dVNMdllXLzRYdHBmUDQ1YU1VemVkQXdiN3l6aHQ5V0pJWE41Rmdr?=
 =?utf-8?B?S0VtMUR5eGpxQjFSblo5UUw0MHljaG1jL3RVajlCUkFEYkxycHdmaXhMMlky?=
 =?utf-8?B?bGNVQnZ0S1k2YlBZaTdWNmxLSFQxZnNqQ1JwM0x1MXdZQ2w3YWRqNks0M2Vy?=
 =?utf-8?B?S1VQTzBKNlNob0lFUWpTNCtHYlFNWDV6RWF3S0g2KzZ0MDlSWko1ZTBOZWlV?=
 =?utf-8?B?YjhxMnZJaUxDZ2ZsTVFGbVVJcUI0MWlKelRxRmFRYUlwNWQ1ek9yMkdWR1ND?=
 =?utf-8?B?Ri9qbHBzOFRNNm0zQzBNdk1BeHU4Z2hpZWcvUlpBeTcyd1dlZzFsak9hTGRz?=
 =?utf-8?B?VmRNYzJPZFFJVVYvVzlQM2ttRW9UdjdKcktyK2ZxSkFKVVZZQWVIRWhmbVBv?=
 =?utf-8?B?TVZMS1cwUVgyQ2h6RkEwRzM2b3NHcUVOYy9Nb3kwUUZGdVl0UEpwODY3emsz?=
 =?utf-8?B?b3BES3gxemszUUhnREtjd3NzSG84SXMyeUlIRXFJZDI1RnBoVDczWWVoSlJX?=
 =?utf-8?B?Si8vVlplU1QxZklabkVPODZLMk9vOENMR010M1hONjNza0dyOExlNytpUld1?=
 =?utf-8?Q?uQ29ZBPF6sRw41TazPaDpK0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8ac109-fe73-4002-6407-08d9b8d9987d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:15.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlmq1IVWfTAtvEBjbw5PkP2mg4fUnwTQWzdviavHFePTKTHmv5iOcKHKHQZ3YlrIbFyNxe9ahn5dx/IiBM6BJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change set is preparation work for DSA support of bridge FDB
isolation. It replaces struct net_device *dp->bridge_dev with a struct
dsa_bridge *dp->bridge that contains some extra information about that
bridge, like a unique number kept by DSA.

Up until now we computed that number only with the bridge TX forwarding
offload feature, but it will be needed for other features too, like for
isolation of FDB entries belonging to different bridges. Hardware
implementations vary, but one common pattern seems to be the presence of
a FID field which can be associated with that bridge number kept by DSA.
The idea was outlined here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210818120150.892647-16-vladimir.oltean@nxp.com/
(the difference being that with this new proposal, drivers would not
need to call dsa_bridge_num_find, instead the bridge_num would be part
of the struct dsa_bridge :: num passed as argument).

No functional change is intended for drivers that don't already make use
of the bridge TX forwarding offload. I've tested the changes on the
felix, sja1105 and mv88e6xxx drivers, but nonetheless I'm copying all
DSA driver maintainers due to API changes that are taking place.

Compared to v1 and v2, the amount of patches is larger, but the contents
is mostly the same, just split up hopefully a bit better for review.

Vladimir Oltean (12):
  net: dsa: make dp->bridge_num one-based
  net: dsa: assign a bridge number even without TX forwarding offload
  net: dsa: mt7530: iterate using dsa_switch_for_each_user_port in
    bridging ops
  net: dsa: mv88e6xxx: iterate using dsa_switch_for_each_user_port in
    mv88e6xxx_port_check_hw_vlan
  net: dsa: mv88e6xxx: compute port vlan membership based on
    dp->bridge_dev comparison
  net: dsa: hide dp->bridge_dev and dp->bridge_num in the core behind
    helpers
  net: dsa: hide dp->bridge_dev and dp->bridge_num in drivers behind
    helpers
  net: dsa: rename dsa_port_offloads_bridge to
    dsa_port_offloads_bridge_dev
  net: dsa: export bridging offload helpers to drivers
  net: dsa: keep the bridge_dev and bridge_num as part of the same
    structure
  net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join
  net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload

 drivers/net/dsa/b53/b53_common.c       |   9 +-
 drivers/net/dsa/b53/b53_priv.h         |   5 +-
 drivers/net/dsa/dsa_loop.c             |   9 +-
 drivers/net/dsa/hirschmann/hellcreek.c |   5 +-
 drivers/net/dsa/lan9303-core.c         |   7 +-
 drivers/net/dsa/lantiq_gswip.c         |  25 +++--
 drivers/net/dsa/microchip/ksz_common.c |   7 +-
 drivers/net/dsa/microchip/ksz_common.h |   4 +-
 drivers/net/dsa/mt7530.c               |  58 +++++-----
 drivers/net/dsa/mv88e6xxx/chip.c       | 142 +++++++++++--------------
 drivers/net/dsa/ocelot/felix.c         |   8 +-
 drivers/net/dsa/qca8k.c                |  13 +--
 drivers/net/dsa/rtl8366rb.c            |   9 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  40 ++++---
 drivers/net/dsa/xrs700x/xrs700x.c      |  10 +-
 include/linux/dsa/8021q.h              |   9 +-
 include/net/dsa.h                      | 108 +++++++++++++++----
 net/dsa/dsa2.c                         |  67 +++++++-----
 net/dsa/dsa_priv.h                     |  59 ++--------
 net/dsa/port.c                         | 124 ++++++++++-----------
 net/dsa/slave.c                        |  33 +++---
 net/dsa/switch.c                       |  20 ++--
 net/dsa/tag_8021q.c                    |  20 ++--
 net/dsa/tag_dsa.c                      |   5 +-
 net/dsa/tag_ocelot.c                   |   2 +-
 net/dsa/tag_sja1105.c                  |  11 +-
 26 files changed, 440 insertions(+), 369 deletions(-)

-- 
2.25.1

