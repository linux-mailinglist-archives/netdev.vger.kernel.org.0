Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC2C6D37DD
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjDBMiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDBMiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:19 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F1286B8
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hwcd4Fa5eEQAjeEWb6VQZ6OQVgGLDn5Oa4OQLrG7R6non6ksm2f0RjONnk2x+tguDJGJJTS1j5hk33cGVPZ0A5xEqLCcyBwT68ow5d/GB3YYnnPiGGFQod4dcKYcdQWyh7Mebcv918yquQYbrmb1+dLygyb+LluUUdP5aq8W41ddk9TXM1+aGByuinz64ZE/ecHujBn6/TuH1mMJ4Y8VF690rvXez1JaCITd5CxVSM6CeXzy3cg06a6kmfasGPNJbyOtyqS+7bae7wqelwqPHIEPhDM9TokpVeztz/awBYcx91xfLlbyMz4DRJewkZL6c1X2iG5NUATXf8VLSEFRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9csSpFE5MARI8yCHgX3edQpzLmoLvIZDpNnU+hs+D1g=;
 b=YBXkVpe+6/BN9FMW4OkF2zNtcvHeSCjvn9MxtOfTOj36q0JlfcDx06ayBduN91YE9LJBVEV19ge68dWLlzSdkwBnQgAxc/BOuLmKRf/CYGt83l3jvKt60uiR/w8EIxtdjUsL8TzBykLs+3XMTTbgNrKdkbbiboCeQ2vg9VCkX+218u5mn548uUnVG5lWYF0fJi74WZc1CV06mWxsohVBxglssLdYXyPa5T3fo6Xs2APl7BVqI+ImUoAIxIcy7rGd0I5Ypd9tW50s6C9JPNMJlQlqO0JP4wbWcf+EGUcc8kvdcMsYoLrRlqMB2DOc0jj1yJO9VrII2jTJiJfeZgWoNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9csSpFE5MARI8yCHgX3edQpzLmoLvIZDpNnU+hs+D1g=;
 b=bF+x3tSz6qniCxqHgTdE8OVX7tqXDW7pQuXi/XMCUmOO9xu3m+GjIAXOqJnCJRSaf+IYyDtTFvxXLza1dO6vg9sbnXFBq2BBkgCfF/G1wbWvO+kDWJ0rxe2m1V6m8L69omS02uHH7AD+owz/FCuqVIPgQnEaLjCYGdc0VbNRpso=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next 0/7] Convert dsa_master_ioctl() to netdev notifier
Date:   Sun,  2 Apr 2023 15:37:48 +0300
Message-Id: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB10052:EE_
X-MS-Office365-Filtering-Correlation-Id: 597f8bfd-f607-4de9-c3df-08db33771d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: chor0IJ7YQPFlo2cs/EIhyXsZE/sDLr+v4rs5BNPqIhGLkU3yL7N4AddcWlc0pYcJcM4vSJITq1Tm7iZSQ7w7yBX5L/UyoWOuln1tnrhY4hjEj9qpU48NWgebW+dqRjOIWclkxkiwM2jC9vRaHEAvV5qg3IfEoY1mUQddGIyTYaMLctNtQrop5IOwvKpZJwgh+okpu09YW8cbFOv1vt3N7PuI9gxVb0QBDmNPeP78wrSZBM8GV0Nt+b9dKOj9N8RTuZ1TE6epHZHg6gQ36C6dNAgTc7Q0cN3zkTFqI9gw1wkxUwoZmobUoXJWU98PgtRcNQu28kRdy1kchdLBnB9SVcc6DVtNwidZMU2UWXB9Mj8AG/L5o5gCMjSo3UHGnXEh8G5mn3dtyu8eIfGbt3Nbkxbvc+OO3pN5kQXK6btwAcEJ6W+vAELFSWg+LZHS6oTTS44VjEbfuL7LI8DN7NnyeI/OZFuxC7SAq5DbRvCdRVLjkxyEHBYJb+mayO/JiB9PkZuG60y6Q9gCXwOIlhTEYDQ+YkVKvmw0ILlixGn+Ndxy3rIQNc2l3j73zPDEBstpjdEYRK2/+DlUZ2a2erN1/HR7pD9FupYuoBBFmMjEVG+Boq11+jwMAo4TcvSCuHPmg+gchzXuNbms87/IyLOSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(966005)(4326008)(66556008)(6916009)(8676002)(478600001)(7416002)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(66574015)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWFqSjNqS1JwRXJOMjkxbkg2T0tEdmRDWHJwNTlMdFNBTUF1NWxVd2RtMmF4?=
 =?utf-8?B?ZjNvSkQwTDgveGtob3QxNE5Ob2JFOFpGRmZ2ekFhMThJYUU5ZEppN09kSk8y?=
 =?utf-8?B?SU4rVW44TjdIR1d0RDdaZ25pSkpINUJONkZzTk5kbE0rbm9CRkoxY2Eya2VU?=
 =?utf-8?B?Vk84RWVUTEVKSnJBbkQ2NUtiM0tVUTBiUWI3UElLbFZqN09sZ29sbkFjZ0d5?=
 =?utf-8?B?TUtzTmV0OTBpb2VHTkViTitBeUJVOWtYbExtUHNaV2lNRFREK2xrODF3eHVU?=
 =?utf-8?B?VDJ1bS9UMkVUb1dQdVZnaTFKQ1lVNksxcEdrbTlHWVR0SFJ6emVVaWY2TEF5?=
 =?utf-8?B?VCtTaTdELy9abXJmREsxbmxUR2lSMHQ1TEdRU09rM3JKd2p2dlBsRmJqbGF3?=
 =?utf-8?B?cG5oa2MraUxHZVc0d1NLN2N0dmYwQVdFOFpXRVlxL2RwVGk4Z1hCNCsvWHZr?=
 =?utf-8?B?ekk4czhlcG5HMEdjeElDWXRORXdLYmRQdTI5dTkvVTF4K1VvYTNWcGxVOHlu?=
 =?utf-8?B?d0NncGNMejRzMVgwOXQzZkFoRHNJTi9nM0ZQcHhVSy9UblBCMjdQNUVraW5U?=
 =?utf-8?B?YU1SNUpjQk9jWEdMa1JzbGROckJBS1hER0t4YloxTFQ4aEdmbU5ITnFMOHkr?=
 =?utf-8?B?UWh3OVJZSWdZQWUvRGVPaWtqK25ZV2VXTzd1RCtwM2o1T212MlhBdVdhTEh6?=
 =?utf-8?B?a0MvUS85MUIxcG5NYzcrQjJtampzMy9GM01WQUFrSlVXbXViRkVodDRvblNm?=
 =?utf-8?B?czRYMnFNMlhpbmRLN0M2a3pManYyNEVtMitwR3lwT1JxYWhiaDdBQnZCbm9z?=
 =?utf-8?B?NUVKQjRDVVZFM0cyUDVEZkRuNnhWSDFMdER3RDVSRVVLVWlVV0UzSnMzbVk4?=
 =?utf-8?B?ckNnYUlYSXVRZGFvY3hFQUFnWDZzVk5mYTBla0xPc2h0QVNKNFllNDRYTU1t?=
 =?utf-8?B?UW5IZmJHUXBTY2NNOUx6VnFtTit0dTl1UDZuUERVQ3p1VDZJVzlmVGZZeTVX?=
 =?utf-8?B?ZVlPNWIxMWliU1V1UzA3Nk9adXNsalM5U3pRRXFzR3cvWnhGb05EbEtYaWs3?=
 =?utf-8?B?L1NYOHN0WWNZWVJsR0VNVEZncDA2WlZnWUJaVldlUnJTWE1lOEVSTisraUE3?=
 =?utf-8?B?dUlrQlZ0OXFYS004bnFuK0lOMGpRSGw4RGQ4Z296VGVnQmRRRkhwSVcrWmFQ?=
 =?utf-8?B?ekpPbUNVL0pOUk51ckZvUFgxVFdRWldNclliRVVWM2NHRmF1VjZiVElHVHQ5?=
 =?utf-8?B?QW1uUjRvSGh6eEV5L3ZkNmxrNi82NWE0Snh6N2NnTEh4NDY0QS96VkU0cThk?=
 =?utf-8?B?Snh6RG9SREhTbzFacGlXYStHMVZFVkMvSy9laTE2L3JDR3ZjL3NPZTB3YXpP?=
 =?utf-8?B?TDFnYjROTGFjOEhtNldORTVkcWlkTnhZUDVuK0VldmF1b1ZNZnMzZjJnVFR0?=
 =?utf-8?B?RUIxK2tkWG9NZGpOYnIwRzNrb01Ca0g3eFd3M3RWT0haeWlnOHFIelIwdE43?=
 =?utf-8?B?RXZCa1NoL0o5dHBBWTlZdGlTNWQrSWkxWkgzKzVhUW9PYWMxbmlhTEM4Z240?=
 =?utf-8?B?cXFtTGgxOFQvVXpNeDI3aThLU3pUTllKaXdSRDI0V0FhbXBGTDA1VTZNenZ1?=
 =?utf-8?B?ZEJqZzUrOUZnbTZtblF5WkdhZ3Z6azRQM3lsN0VtcVlSbDFUUVNPRnNtajZn?=
 =?utf-8?B?d29FWjZHTXlZWFQ5cVc4alJuZy9kSDBUb1lqNU9jOWlVTk1MVXF2VE12ak5a?=
 =?utf-8?B?WmxIRmpCV1FkU3lpbFRFLzBVNkZmTGt3dXZWQ3RRcUU1WTY1bGhaVENQank2?=
 =?utf-8?B?dHNMYjNIQWVVMCsrQjlPenVleXcrQWFkb3g1ajU4UTl1WVBibi9ZdDczeW0w?=
 =?utf-8?B?MkxIdTd5VUFKeGxGTVdqYmJlU2tEckhyaWpTUUhVZkY5L0R5dU0yTlJXcGRR?=
 =?utf-8?B?YzIrbDB2V0RvMi9rSEwrL0ZuWll4cEUrODRGWkU2QmdITG4wZEVWYk5EcUdC?=
 =?utf-8?B?L3VsZGFhZWFHOGdKZk14eC9wV2pEUjF2QmZDZElXY3I2Skh3bFdXT25rQzNZ?=
 =?utf-8?B?Z1l5NVRrRkFGdnBuMlkzbURZSVQwQi9oRHU1SnB3cnE3dkFQNy9DUWFLQVpv?=
 =?utf-8?B?UnN0QjdSRnpMSmdrTEdRcDRTK0hUNWsyYkk4MkNFaHBvZ1l3eTFjaEdIZzlV?=
 =?utf-8?B?dVE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597f8bfd-f607-4de9-c3df-08db33771d36
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:08.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptiLJqLfCu6/V4Bge3lD6s8ADax4XYS+j4zn4F1FCTb1sCLLfLpeMf2ztyPsguIe6BQbRky9uksqLN1TEa8wCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is preparatory work in order for Maxim Georgiev to be able to start
the API conversion process of hardware timestamping from ndo_eth_ioctl()
to ndo_hwtstamp_set():
https://lore.kernel.org/netdev/20230331045619.40256-1-glipus@gmail.com/

In turn, Maxim Georgiev's work is a preparation so that Köry Maincent is
able to make the active hardware timestamping layer selectable by user
space.
https://lore.kernel.org/netdev/20230308135936.761794-1-kory.maincent@bootlin.com/

So, quite some dependency chain.

Before this patch set, DSA prevented the conversion of any networking
driver from the ndo_eth_ioctl() API to the ndo_hwtstamp_set() API,
because it wanted to validate the hwtstamping settings on the DSA
master, and it was only coded up to do this using the old API.

After this patch set, a new netdev notifier exists, which does not
depend on anything that would constitute the "soon-to-be-legacy" API,
but rather, it uses a newly introduced struct kernel_hwtstamp_config,
and it doesn't issue any ioctl at all, being thus compatible both with
ndo_eth_ioctl(), and with the not-yet-introduced, but now possible,
ndo_hwtstamp_set().

Vladimir Oltean (7):
  net: don't abuse "default" case for unknown ioctl in dev_ifsioc()
  net: simplify handling of dsa_ndo_eth_ioctl() return code
  net: promote SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls to dedicated
    handlers
  net: move copy_from_user() out of net_hwtstamp_validate()
  net: add struct kernel_hwtstamp_config and make
    net_hwtstamp_validate() use it
  net: dsa: make dsa_port_supports_hwtstamp() construct a fake ifreq
  net: create a netdev notifier for DSA to reject PTP on DSA master

 include/linux/net_tstamp.h |  33 +++++++++++
 include/linux/netdevice.h  |   9 ++-
 include/net/dsa.h          |  51 -----------------
 net/core/dev.c             |   8 +--
 net/core/dev_ioctl.c       | 110 ++++++++++++++++++++++---------------
 net/dsa/master.c           |  50 +++++------------
 net/dsa/master.h           |   3 +
 net/dsa/port.c             |  10 ++--
 net/dsa/port.h             |   2 +-
 net/dsa/slave.c            |  11 ++++
 10 files changed, 147 insertions(+), 140 deletions(-)
 create mode 100644 include/linux/net_tstamp.h

-- 
2.34.1

