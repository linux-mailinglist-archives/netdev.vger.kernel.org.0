Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CD26ADED1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjCGMff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjCGMfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:35:34 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C235D4C6D0;
        Tue,  7 Mar 2023 04:35:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJliNPtzFo3KDSim4m/rP38rV9TcRRjwF1/O92jlgbu3AZ9ApvVC3tTM3KcT/eS7JnGXaR6aLAgoahzkMXSB/sSyI5T/VDOzNqONbAvUThRPI4LggmigC0piXUi3xr8mMGxjmX0lmHSLfEns8EuTyx6FXWaZ7IiMMLJHM5z+gcGof/OP5CrQuR9zP1AwqUeKf/AN4zuEb3wnd4rwagl2VKMQbWGP5w8iKxvflP44LQ01zMRlrTQSoDmCHwpEhNLIz3QxcZn3TXzWrJmet6njnRyJHn3bMAyDTauvQOpaOqjwbTuXXTQN+F3fFyz2RGg0AuNtewA59zcMCEYkiiSKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxQSvhKd7MlIaK1vDjA6iBigRIsnaD9dndT6fCNEDV4=;
 b=ZE+hy14UztAJ5z2yjWjVjDxw4tEJRccCXBokoSB1bN57H2hFkt0UAtdlMht2JGGXevQakWn18DZFTihJt7R3iCCWmIel7SDXyoTVPyHks85uWAR8BKJrKcBrL3DCO2BGgM/25+KloDeIooQpluVtv9/FHx+wCTF6Utxf0D5p+hP1hBn2O/TDv+/IP2nX2nlH6EWLncAFsH7dIocM6Fy7jp2ND11HbvpK5LE5TU75NYUv8QSiNw1OSNJ6+eolvTkxdI7O0qbuKD4esnbaiyQPsKTG3Y8yyf0y9eauaT39F8Ae4H5ZszB/wmhmFxTEKo90P23Xa3g2B7thhqpUrnxvHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxQSvhKd7MlIaK1vDjA6iBigRIsnaD9dndT6fCNEDV4=;
 b=s/pSMEXH2p4r+FOjUDI35sKMlCP5MS20cjyFvk9H+VsqOTBn4pq7/2vdLPGC2YGbYNyDn5xzygewYMe5Pn5QCFmAOMhN2VSnhqk3XZfPex5yzd2ZpDe/tvVS3AOwKoay2dzBaWm+K6SA2GVN1HZWA9SU/dwMCP4t8HIKcV9YJqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7669.eurprd04.prod.outlook.com (2603:10a6:20b:29b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 12:35:27 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 12:35:27 +0000
Date:   Tue, 7 Mar 2023 14:35:22 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Song, Xiongwei" <Xiongwei.Song@windriver.com>
Cc:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Response error to fragmented ICMP echo request
Message-ID: <20230307123522.rtit24jseb5b2vep@skbuf>
References: <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
 <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
 <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
X-ClientProxiedBy: VI1PR04CA0086.eurprd04.prod.outlook.com
 (2603:10a6:803:64::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7669:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ce30f2-0946-4eb9-726e-08db1f086d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: npy52ROSib+oIsCsJVARcILctxnkMhvIC8IaAfvkfRkYkLZfhti/JMDTEKp9P0hkCQ+F7BR+JBPxtQQCWJ05IYCRfqPQ4f4x6CZ2vvLQyeo3s7eSr+VE0QuQfqS24TuogQ3LUr7THamCjcJe8JMP23knP0a9GBY60D4i70P11Jh/eunef7+XoZh3GzGn9gUw8KEiryp7RL0WDBVn8DB266PycL7LCwSly0LbCp5zzShY5hau5+T4uqTAvfTDPrcAS7jYUFQIxLBtbJJ6HrgON1bKKYztCPl6Ej/J+s1/5e8Vm+RX+WeOW7RIR1A7I7ADvKwlx3J8YQ67ZF1POQ7FW9w32RQP05nAwRzgg86kQxdFGDFEL4wBC6XGwF3Hwx5Uz+QF3vgPThu35+nwiQeIK24d5BZGrX4PNa2AYscUsR2Wo6DD+6eu1DuSPSUqc6Mlwbs5C4xyQWRJrizcx1Z8JQMekAvgAR/tY4lbfPCwm+cvoaO4l+ByM90GoNm4yqsbRktFfQoOu4UJL6hXOAPv780/UsejEw4dji3Y+kjqi5ydx0W5ZlkBGHBSzN34h9wcFI9xcxfsJccMJAANTnmasNqNnTILWgzzCijTGR2ph7EmUZ9YAacwZaBXpDZB5W7W9NCiUafg8wZaepsf7TGxgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199018)(316002)(54906003)(38100700002)(86362001)(6506007)(26005)(6512007)(1076003)(83380400001)(9686003)(186003)(33716001)(5660300002)(8936002)(7416002)(478600001)(6486002)(4326008)(41300700001)(6666004)(44832011)(66556008)(2906002)(8676002)(6916009)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fn1ZTE7PAJZJM/yD0OIhwVAjnHql4wR+ak0UZYGJtngAg2ABqcfK6VJLmIGr?=
 =?us-ascii?Q?otK7nfXQoOTmBP5zFBIXumnT+8HBlB9YHCF32XUW1qbyvM3iKPOB/Pd8HFkV?=
 =?us-ascii?Q?ruFm73LnV/tCwkjZXXfmOa0v1foZ1P8SeCg54GubtSMfhR0q9+WHjMCZzzyR?=
 =?us-ascii?Q?j4ubPlHJoGy6NBLftSy6uW8HveoF6DeBEge7xlK9lAdkL3SYxUxkbY5zAyjJ?=
 =?us-ascii?Q?ajSTQT3uMEhpY3/edS71Ru7cAH9OH65L51ho13+N8UVBru3E3TvuHH4+6eMT?=
 =?us-ascii?Q?1UjQMf3GFdcHuEEe870W5OslV07MUyk9kmyNN6/iEuwKlVKVIZ23qkb82FmM?=
 =?us-ascii?Q?4K5Li6q2ojm5SuHeIiCRGOO/mr5CllrADwIlE7G1gOYHIm36R2zv8FrB3LaP?=
 =?us-ascii?Q?mm1HhhQe5CIpUorCDQJcGU81etzwMcgHC/Oib8pk++oNxqwyDASZaH0qYVRM?=
 =?us-ascii?Q?+FnSrVuhwSXVjzfT88JDzadDuCrTYyd8kK/2cVSPYxX3KwHX8wcKRp2G4JIR?=
 =?us-ascii?Q?nWSAecaiOGZzGSa2sx+jRMyycH1EHIKo5KH9J70Rfd0INzg3ThQVH79+xmxT?=
 =?us-ascii?Q?IXd4XieP7Rpl7XNfYhYsXVZEghh1ymoYxWVB/x6DhdZXxe79l1Yg2oNO0A9z?=
 =?us-ascii?Q?lZs7e7oJQ1fggoBxTEHjLY32eiAT2+G4VUc4+lNTjLHmTKCEv0lEYEnjwc9M?=
 =?us-ascii?Q?Hu26Joo1eyZLnxmFInqeO1aURlgI6CO5DDGi6mfDQm6uvrAGVdUF1zVLLrVz?=
 =?us-ascii?Q?kzoOm+YntaY6oTGmGP50lb3trawzO2rwtzYlZiswEtG6+m7TUNe81OvJzqn+?=
 =?us-ascii?Q?po7vigzqPiymzhpQWlfF0ybmJMFPpraMZ1n+BzjZsIKZ5s4/SvyUGXBAjqDS?=
 =?us-ascii?Q?1HlI/rjHQpoQlz5mwoFJ73+SaGqlZtiALLeppqGCyy02nKuZIm/esiDv+T/u?=
 =?us-ascii?Q?gAEibOUalyC3WPY1PM+c4ClU9AWchzKQvUnrtq6/lFyzayDwUCEqq+qEHtkX?=
 =?us-ascii?Q?xEOG21FZUYOn9Y9kVhyLW10P2X8bgrhEBBqHLhb6yw4feJXpSZOyYWTAAx6g?=
 =?us-ascii?Q?JHgs5TLqTRS2O/moTTlfNB9iaCGfi/WMPnMvpwEZJURImv9MMTNaDEuK3Krm?=
 =?us-ascii?Q?XQVrW7LgVXWB+ubAtNEcyFEEJw9N/8Mg3ISTB/fPkTeEZMr8wpPvr9Xj5N0B?=
 =?us-ascii?Q?oejrtL0vDvkyiTti1O1XoABcTI9TlcNSd+3jYaBDoTb4ZymfsbYVMG18/e3y?=
 =?us-ascii?Q?UBopPWo93IFgYMlQtQS1dgoYXO9m6eK6kAeIftk5mLLouVfAopXnpn8Scx1Q?=
 =?us-ascii?Q?QGiZlT9F29Sa/GLbxrZzQ8ylGrf6qTfYCGulI2IOtud10a5AvgQNGTZNvseS?=
 =?us-ascii?Q?oSZWHPaRPW0MYeo0kctgdeQBDqq2Y19guzucvVTm1JHlamJR1Vs5FWCIjjJe?=
 =?us-ascii?Q?sawZtFF0KNEhNBBIZ4eAHWsTHxOYqkjRT2kqfndL/4Bd0QLJY/AsN79tsvpX?=
 =?us-ascii?Q?GhUFqGf4DLEcVdTOAZdlvbomVXV98BPwBPwdvqE1dF+n2ymLP0IT6VA5ONJ8?=
 =?us-ascii?Q?FCmKHKaCxCaKWfHB3lSqYh7buUHrHEos7MBELtLYaflDGeAxLVwFHPGMoXpX?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ce30f2-0946-4eb9-726e-08db1f086d59
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 12:35:27.3927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3d2dS8opELBFG3z/FcM75F/NQKCXzcwdbsZchgse2yLWW/wJ28P7EgSH5CvwvxgudKBhXLsoCJrzln2DTF2GJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7669
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Xiongwei,

On Tue, Mar 07, 2023 at 12:11:52PM +0000, Song, Xiongwei wrote:
> ......snip......
> failing SW:
> rx_octets                       +64
> rx_unicast                      +1
> rx_frames_below_65_octets       +1
> rx_yellow_prio_0                +1
> *drop_yellow_prio_0              +1
> ......snip......
> 
> 3). From pcap file(the pcap was collected on the senderside (VM))
> 
> Frame 1: 64 bytes on wire (512 bits), 64 bytes captured (512 bits)
> Ethernet II, Src: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f), Dst: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
>     Destination: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
>     Source: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
>     Type: 802.1Q Virtual LAN (0x8100)
> 802.1Q Virtual LAN, PRI: 6, DEI: 0, ID: 981
>     110. .... .... .... = Priority: Internetwork Control (6)
>     ...0 .... .... .... = DEI: Ineligible
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

>     .... 0011 1101 0101 = ID: 981
>     Type: ARP (0x0806)
>     Padding: 0000000000000000000000000000
>     Trailer: 00000000
> 
> Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> Ethernet II, Src: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c), Dst: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
> 802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 981
>     000. .... .... .... = Priority: Best Effort (default) (0)
>     ...0 .... .... .... = DEI: Ineligible
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

>     .... 0011 1101 0101 = ID: 981
>     Type: ARP (0x0806)
> 
> Frame 3: 47 bytes on wire (376 bits), 47 bytes captured (376 bits)
> Ethernet II, Src: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c), Dst: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
> 802.1Q Virtual LAN, PRI: 0, DEI: 1, ID: 981
>     000. .... .... .... = Priority: Best Effort (default) (0)
>     ...1 .... .... .... = DEI: Eligible
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

>     .... 0011 1101 0101 = ID: 981
>     Type: IPv4 (0x0800)
> 
> Frame 4: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> Ethernet II, Src: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c), Dst: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
> 802.1Q Virtual LAN, PRI: 0, DEI: 1, ID: 981
>     000. .... .... .... = Priority: Best Effort (default) (0)
>     ...1 .... .... .... = DEI: Eligible
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

>     .... 0011 1101 0101 = ID: 981
>     Type: IPv4 (0x0800)
> 
> 4). What we've found so far
> 
> According binary search, we found out the following commit causes this issue:
> a4ae997adcbd("net: mscc: ocelot: initialize watermarks to sane defaults").
> Without this commit the test case was passed.
> 
> Could you please take a look? Please let me know if you need more debug info.

I've marked the DEI values in the message you posted above.

Commit a4ae997adcbd ("net: mscc: ocelot: initialize watermarks to sane defaults")
tells the hardware to not allow frames with DEI=1 consume from the shared switch
resources (buffers / frame references) by default. Drop Eligible Indicator = 1
means "eligible for dropping". The only chance for DEI=1 frames to not be dropped
is to set up a resource reservation for that stream, via the devlink-sb command.

Frames 3 and 4 are sent with DEI=1 and are dropped, frames 1 and 2 are
sent with DEI=0 and are not dropped. I'm not sure if varying the DEI
field is part of the intentions of the test? Is there any RFC which says
that IP fragments over VLAN should use DEI=1, or some other reason?
