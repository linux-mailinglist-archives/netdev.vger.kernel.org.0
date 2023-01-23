Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36F06789B7
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjAWVb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjAWVby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:31:54 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718B8126FF
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:31:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXPpTWsP1FglgVRNVqcxNoo6l4FkSZxKnfD/ZeEbSa8z11Usj3rjUUuDaYqQWqncR3wEUc+dERu2IcD/CE5MLRHFopje9DmYYXah81nBKPrE9rAEfIFLisuYUpLjN8Tfi+e70LnkAb74TUDBy5Z1nGA7HquWoE+/buZvIcMhzTtx1k5BB3McnHsXuHrbd7ty8ijOMgcnxnos3ZRMWkrvoSge41xaXSEL1YUDt0N2YPPtLZK4MaS1wAJO+hRW18OudiJS4StaSEJiEdu5/3VT8oHjSiLEmAuob/v5YHJ/6HrKW5tPlreednTcn1jX/kFw7BRTfIcaBjDgEyyJf1x/Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDBJl0ZfT4C3LafkOwJhYNi/CS+UdS+H18pfpxTEZgY=;
 b=GCSKxHJX4NHcJECKteX8Q+hSMNlIgIDF/bzii5WkZmvUo0EwcRhHOw//d7aSFK5WZMxHweHb29zzawP3YhtcPenA6YMCUx06NfO9yklcI/netkHrfqbnGhfBoeDSk/KixVhh49llQoKr9W1pdkiwTZFnsUGn2bMh643Ra+IEpPDS+GHbIPeX4gQwz16/pPY6hhh6I1B7wuBdyQcjLPX+prgdyBvYwY7ORYtjAagNIb2wstcSLTnzyprhlj2cf8rKZ3zhE2uphJXe9j6xAhm7GhApeytqtPoMO9ONzp8NxGVwJdWmXqNCPjFIM9mQO09XLJAhE3NsySEozkfO146CkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDBJl0ZfT4C3LafkOwJhYNi/CS+UdS+H18pfpxTEZgY=;
 b=dU+EdgHatqLRk4HPoLckaRvy0PV9kaYC7M87ZvMmoocOZpsWGE6vXY3k1nIoqSLEyCurPhWtCoqKPqESJ5iuiX6vUUfcq5/ObqiRgotl17zakIjBZ4zx6yhR/+9jllIwSoQqa9E6j/jjlhnHwGNPvAkdf1R3VI+LZBV1JatNa4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7919.eurprd04.prod.outlook.com (2603:10a6:102:c1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 21:31:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 21:31:47 +0000
Date:   Mon, 23 Jan 2023 23:31:44 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Message-ID: <20230123213144.jixdztjnut4tnf6r@skbuf>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <3e324602-a33a-b243-80db-6f6077ca5029@engleder-embedded.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e324602-a33a-b243-80db-6f6077ca5029@engleder-embedded.com>
X-ClientProxiedBy: BE1P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: acfb3a5e-cefb-49ac-d6a7-08dafd893b83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: agWGFGd19LGtqe9yY+LcbWX2gC4LOFBcsT5krZqLvsaQjYkjmwUfBtF+q6WhLSpwSCkRSiCCpuBC5EaEy22OZta3L34+NHFrF/aL4kv0xkwOmfgTJgKmRuSB/bo1QBnQjzbKkgnXLslvhQnxrDFPygKhPGqyXqAkIGUEmAKQZWc3TBiWqnM6ESgtpBIQa35PeYHvPnpU1q369fOOI1uAo9j/uC3lYBK6kvYZoxbddgRU3cMCHRFBdIRdDSqsiu48Y3ePtD/L3iwYbVaNqC/R7vbV66dICfk+tR71JIM6O4RSNjvWwW+GiLMAswRohqc3czMMh2e/D/lQZkuNon9IWKOno6e40VRuksIwxmR2su+n9dGM4vF7LgtzFI6qilfr6WDP0HMTgU47R1mcLEPlTCjl+zv+1nqUSEc2RBn/121h6wMVxbYp8aOL0ENhxWZ8An7X8FdRd1fOp/JZtT372+OJro0OeQLHTu8JTGBxuuUY71nxFXBTH1onMVXpCf30pX9USGtOtplHfap1FmTNrxirhZsxa1MVGqFal6ZFWTodMBmTm368Iy9BRVFXjHdz2A+uH4sXdo+e9kHhGkA3FoKfJKgGeInTF6DLh8i4llqPGFUjA5pGm2AdsM9LeXmyiPJzcfALox7le6cvSeoekg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(86362001)(5660300002)(7416002)(8936002)(4326008)(2906002)(44832011)(41300700001)(38100700002)(6486002)(478600001)(6916009)(26005)(186003)(6506007)(8676002)(33716001)(6512007)(9686003)(66946007)(316002)(66556008)(54906003)(66476007)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IlpHRGX5QBazAPUYtN1vZZ2YI8qNi8lVu6UbSkZHU9dEozVdc2wO6ZXq/REq?=
 =?us-ascii?Q?wwk2md02TnM+50D0WMLb6axLEN9e1dut93Y/MMy+gF3YUeAaiCq7oky1+diz?=
 =?us-ascii?Q?F9icIurXqoSpz8zNXC4Cz4n0sC6MO2ObnnB6JwGYk12xznIGHwtUVVJebPm5?=
 =?us-ascii?Q?O9TnSA+SAZOfgqcBsuKxHtu9NUpRvKMqlgP1qaWF/+z4mO0kWVN/4/YgXo6F?=
 =?us-ascii?Q?if3ELcx9xZW5hVWaIG7hDviNyOwNydM7uDgXjnYTHxk3ePRTkfJPd2ZOkvAn?=
 =?us-ascii?Q?FBEQPhxMCyQhxD+Ye7avW3smmzZfWnYRFPAWpu0GyDabndz3WS9Ry5xMEz8O?=
 =?us-ascii?Q?nz6cCsVguEoBs+Hg0Ofsj86A3bz3apb1F7m/oT/PBw3eF9OkBXOwE5qC5/4T?=
 =?us-ascii?Q?VUmBjb+Y4E4yEKTQxuYd0ioB+I+wZp2Yc4/UzUUVGrdRiYm3UQ0SlwEwkF2b?=
 =?us-ascii?Q?zv3SNcsnE1EnxC2CsTa4h7LtSNTOV5noESmDPXiWg3Pj8kSQvkU8ESQ/yblN?=
 =?us-ascii?Q?2Ds7D1ApnsWYWmXI04xlgvGP6Yj0vK2d/9MxWPIWCKBOwwXMTYDUH1nKMNo8?=
 =?us-ascii?Q?5tp5B9riZzcXl+2q5eG9bL//iKm+lXReU87w7n8xlWDy2dSMkB5szNBM85xX?=
 =?us-ascii?Q?y7y+7qi8RscFI1oVDzWC/vnfOsElKsIFDEIEVXrdKX3FA+rbWrF9LK2ruxAc?=
 =?us-ascii?Q?THJ+A20rPuuMM5POeOjzxwqmZYTtpdPvDmMseBz62sNUXbxiwNQIqeaWlLGh?=
 =?us-ascii?Q?g6oz+pJcVYpRXRAfLjWYN/2G9q2fzVu4j6BXouCfb+sPsvVxEbnk0oYq2X7Y?=
 =?us-ascii?Q?07oHpNVaDGeIA2uddPbtUPqql1XwLSUTd0bul0P9mqWKSEPLiq7BNCDIvbQg?=
 =?us-ascii?Q?zje/kWDDSYGt9QeIMRhEho7DEPBPEzhZONN5cZDvPVTztdxyO+NsmImVDJsC?=
 =?us-ascii?Q?FWLWhLMuqC627GEgs8my96KPeobtUn7M7bX+91LNdceLrIGpo406TYURVVMB?=
 =?us-ascii?Q?gtHtox9DfzbMpPUKc9XLAqonjvU2Z2Id7EUra9RrKQRPqxwf6T6EYpjAT6T9?=
 =?us-ascii?Q?sFmWH5M2xAvMTg7Wjfcxdei80CMX06NbGtmn3kNId08eN5RFW/MBhfcHLaGX?=
 =?us-ascii?Q?3opj08Wk2h1Ne3aLfLllTJUH+3G/da18QoeLBJn758v+VwsnUOR3J+TJNyEH?=
 =?us-ascii?Q?JCAFNstSjzGQXIYGDQD3RYhV6ifWmA3Q9qe/VetbCKz1dcgkdIHt5PXryavr?=
 =?us-ascii?Q?/9cVxxErrJ6LBLo1JDHq5Vv1qRu7L4kRLo1M/vj2RXA3qlE6FNXRJV66BjZ/?=
 =?us-ascii?Q?N9A8he3OrCWHeiWLN8hCEnCLKzaacfasWw06vyouK8Sg8r0TbjWA4GTgKciq?=
 =?us-ascii?Q?TpEoRZYMwl0HtC/x6zKAfKYiuHpiHCoz/Nv4BUGqc+6alYT7oFmQyntAr+uF?=
 =?us-ascii?Q?kb+PeZEQA7E1YsEfEDonlfVo7pVb6EwdKtqqhI66UhVjGC1TQarVTbDFueB2?=
 =?us-ascii?Q?b6gajVDpK/pa8vUNWraKa/36PJdhiXTYq94MuS6Ej+WEDNFUpMlNA3Nef2Qe?=
 =?us-ascii?Q?qZOOVwdGV5h+d6EnYjLHXUysV4wcZnkSwgXzoCNSCpHzcSz5C+Jb1g0zOGbx?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acfb3a5e-cefb-49ac-d6a7-08dafd893b83
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 21:31:47.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2+PNYdbeiBcBl1vdfeCPcTEUnHlireS2eXvQnnQK1O+3DxMP3k/e9uAF5sOO3A4Cmdiv7fehtcN8d5SCkxflg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7919
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 10:21:33PM +0100, Gerhard Engleder wrote:
> For my tsnep IP core it is similar, but with reverse priority. TXQ 0 has
> the lowest priority (to be used for none real-time traffic). TXQ 1 has
> priority over TXQ 0, TXQ 2 has priority over TXQ 1, ... . The number of
> TX queues is flexible and depends on the requirements of the real-time
> application and the available resources within the FPGA. The priority is
> hard coded to save FPGA resources.

But if there's no round robin between queues of equal priority, it means
you can never have more than 1 TXQ per traffic class with this design,
or i.o.w., your best-effort traffic will always be single queue, right?

> > Furthermore (and this is really the biggest point of contention), myself
> > and Vinicius have the fundamental disagreement whether the 802.1Qbv
> > (taprio) gate mask should be passed to the device driver per TXQ or per
> > TC. This is what patch 11/11 is about.
> 
> tsnep also expects gate mask per TXQ. This simplifies the hardware
> implementation. But it would be no problem if the gate mask would be
> passed per TC and the driver is able to transform it to per TXQ.

If tsnep can only have at most 1 TXQ per TC, then what's the difference
between gate mask per TXQ and gate mask per TC?
