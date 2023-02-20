Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147FD69CA27
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjBTLs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjBTLs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:48:26 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2856C1BF5;
        Mon, 20 Feb 2023 03:48:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdLAv6I5RI9v78JdGcxbhRIhUd3isORdS/onUgoUXVB1XGPhumVPK0UiFD2PoTgk8NgB1rdbswSaSe5ijtdz4KHaGZ92BYoL1wwYQoTkltSd4cmTiWxNeKP5y9jvkzzzZA/Swfc6XrW9DyydHdLK/+BLQ86ORkrTLdi4excXNvemyx20o6tzb39/tlltoA4ggq4ZO2QVRARG0OpPUth8YJ/bgLTtCiab9W+2vsXH+ivh+3vDPf7w87vrEG7JCv04WNBdDiEaRUTjTy9cSKrx2QluIDye6suZx9nKNSCEiHQuRi8N9B1+LcGPOWjos+1eATvgnmrZZb12J+3eFITf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbHSpETy0swwx8+62l6qBPleTT0OYe6e4Q9dtzJDL0g=;
 b=nkx8ne7UFqx4dbzZpZQRw+DMHQlrYl7osryAeb1a9g3a+9qkqau5SUwxIPQIwLtx+zHVa1cQIkDoWiz1+e2/EGNHplV/d07tMFKXOZEm1DQB5ltbufsoTkXmDY6a21I7XAvMSLjAcQetoD55ojv0GyDrpSJM8lKtx3SuYpzQNRHA7m9U0c1ZEIutZPKpQLN7V4t85WslObZ+JtAVg7nmlR69fxmH5W5OWJnlyyZH0gIVOx624R2darHkjHnJpOEaf9ITjogcEOTTs1I8hPIPqXH62AaA7ccujjZ8+q9Y6GWGf8Xa8aZcZKGWWIjCy/OtJdpsi9R6etHds46pgwp4Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbHSpETy0swwx8+62l6qBPleTT0OYe6e4Q9dtzJDL0g=;
 b=hRdgvos0yBsmnPhbx5m050heunYx1yBgthtophPV+4hzdzP/K4/9TKPPGuL5q6UT3GPNqDz0Zq0QfiS7xxMieYV32ivlzDimM5tqv/QjFue2wi+SWFh6sy8NxaBMQh2hTpXtwhdgdeVyjGrfhg6+IrlRRR3C982WPcgwu46BJuA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8478.eurprd04.prod.outlook.com (2603:10a6:10:2c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 11:48:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 11:48:21 +0000
Date:   Mon, 20 Feb 2023 13:48:16 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <fejes@inf.elte.hu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH v2 net-next 00/12] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
Message-ID: <20230220114816.vfpabqxmkq4zul24@skbuf>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
 <d016f61224b293a77969c35d09d65d5cfea7d137.camel@inf.elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d016f61224b293a77969c35d09d65d5cfea7d137.camel@inf.elte.hu>
X-ClientProxiedBy: BE1P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8478:EE_
X-MS-Office365-Filtering-Correlation-Id: 330c4832-2747-437a-166e-08db13385d74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 915rbsBjV4yd+mxBWZordjzZK2AIUCx13NfTolZRHtnopyBV5nbqSxgpC5bIvgq+9IW6950GciSMw6gR6f4CTm8SknYbxj/9pDll50ovJ2MDcji4v6KlTXkhqdnBjzBKucYNM8/b+geEXSRBu0MSRGmpkH3wk5cz35aFE7Ek6yMWcW4iAwCqW5wFGQnKohY0EMnpS0nLJSX5A4kGXDnfJ1feLwOOfRcr5epPN2JHcmWw4sTbViO2JEt5eJagId1a03KHwa3LII3eja13yCEZ8IWTfFb/siUVdi0mJaLMXGMnA+TLGFFXUJB6FBncRQzLIPEOM3zs/33VVOK6UvLajgQ0PTsdjAgAByGpPEKzd9Kc4iwUnu4YntwM75Jvydm4plj81PIDqsaSk9xuOrKPiuk4fhtIH7aZ4inJL10RRxaOj1gy2aYjL6Pq9l66vNWSk/GnhlYTjzUL+8ljeFIFAhOs7RZMFotQ9wQhBXEymzf2VYnbBKq0REVz9AzdyHpg3M9VdUAjZ4NTcyMvzj9dYBssKiNqTZiGRn0MHvrDnxZN4V42wiGYk3AM32AHwqcSIqtYoXCTTc9AFebXe+BQVu/bPhYtOdxz95TqAAVKeP8804SwPYpY4G45DM5rxvBkKbnN9roSbYTRk88zf1X8Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199018)(86362001)(66476007)(7416002)(6916009)(66556008)(8676002)(4326008)(6486002)(41300700001)(5660300002)(8936002)(44832011)(296002)(66946007)(316002)(54906003)(2906002)(33716001)(83380400001)(38100700002)(6512007)(1076003)(9686003)(186003)(6666004)(26005)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MAtj4F6lZh/C/PniXz3I59ktTD1cNShugo//pwi+JmfT3K1W9gsgrwSjGw8f?=
 =?us-ascii?Q?00HqZUPyK8oyav35INj60uKa2qhjDjf3xnRModuKxmOGBL/YvVZ4gipMi5pN?=
 =?us-ascii?Q?LUjssTPEm4E3GsYr+yX8faMsZr4tYfvi9qv6UwRTNox46eJk101DewjrPOVL?=
 =?us-ascii?Q?KmLQjL3bpYK11mJikfchFzJuefnhLlMscmYSWZ5rgGZggBwbKd9DzY0TKhvL?=
 =?us-ascii?Q?1K5qP+Wfqc/Y9ZwYyfHGt9qqsrQgJkn3GcfhkpvcbHliZVL7yYFbo9SzY7Jh?=
 =?us-ascii?Q?e6FyYCcATa6mfaVQa1PINtszzih+oFdx2H65xtkRyhI5pwB7Whg3Xhg2xzOU?=
 =?us-ascii?Q?9LFaLr39meJRwfxTotvW2ftJ+HMlEE4o7yMRcPPm9RHN9dfDLYFJbD5WFQ2m?=
 =?us-ascii?Q?1I2U/YYmxdUmKDOUKHmzl1I3f0BPhSyDCJJzDmj0FsLxHIgqxBq9aX3EYdo7?=
 =?us-ascii?Q?pntKyDPXny3pZFbWLMFo+cM/jFAPT3ZVmIOL4+URp3YtGyDplInpe9mqeHYb?=
 =?us-ascii?Q?OgVz/UZ4UUgdhT+4cYbtk50RnkFFOVCzWZUp2HyUJVVRU/DsJidK7WsrDY27?=
 =?us-ascii?Q?UGKfnAolvNawWIqojcSbb6bwruzp4pfm6fC7a414U8oRa8+h2fQWLGDmVt7y?=
 =?us-ascii?Q?jjynAKDKzz2bayfBdf+AXVFN7zn439CpOT3aVXwwgAQPNKg10GhlU919pGUk?=
 =?us-ascii?Q?vRa8uQfl5+0E53yQP6FjIoo5IJMIN/E8U2EKALKfsqe42WqXPdIDsXUSEsIe?=
 =?us-ascii?Q?yljXjzXljbHTO4mAFVhXUOaHnH3j+0c/Ef0FCimMv7OXyQSL2d9SEonQ0Jcr?=
 =?us-ascii?Q?FMRouPrbEShkqtB5SuAskxTixy12Ttc3AcyOhE2FEZuPVeD3drrAo0fXAlhO?=
 =?us-ascii?Q?axxD+6qKZOFz58iCsDpsDxyEpPMUC0p7A9ZcohS+pUp3x4m9PH+Q9nJbe9YC?=
 =?us-ascii?Q?LY8+F1bcuVhxTQVQEF7a0u0Paf14uaRjLwjqFWMf0PjCzEKuCIVW7a/Rqs0v?=
 =?us-ascii?Q?s35nuv2oTs4nT9nvOLHrjfucbSt28Y8w/YOmdWpfZZTIrqBzbdH4UExvK9bH?=
 =?us-ascii?Q?ajLEV1kNIwbDGFQz0R7ScdLc+VQUZkw0ILFItgU0L8qgZ9JZAqR0F+arvZYP?=
 =?us-ascii?Q?J0EC8JYMDWegthvOBUim3KdZCdF+GcU9re3JZmwmlJbBlt3XKwTYc1+/qPve?=
 =?us-ascii?Q?lxaFBRnJhVODGwctL25gekLqbKsDXAzEh2vZrp1sW+FBXxwVvkK7SEIXUsaS?=
 =?us-ascii?Q?VwyexhV6QY6MwULwYDJNnjj8jIu6roT5CluDpswLfmD5im6jalcOimtwIO0T?=
 =?us-ascii?Q?oZ5GdcLyof7nSkBsmmVFQMc7cveNNOXuLRfKhBIElsvLjiCyDoYBhhYeUytP?=
 =?us-ascii?Q?D5v+Glev5xfzYfkfAYnMUaM0ZtJ5HQjQ0R4iI6rbiqN9ghwbXxXAG2yMqheI?=
 =?us-ascii?Q?ODyS+dbuGbvgWhqMhEwlCiLQLlQrqN6KqGDxy5U1RYkuGZm4cg2kgibSYtS0?=
 =?us-ascii?Q?UYo0xM6GL9rD00lnXCDu71/QlSppNga74b29BPJgq61xRq7dRfNwSmdxNdV5?=
 =?us-ascii?Q?eDh5fPs9e9Qdochu989V6JnlUtyrEHrT6YUCn6rkjkqR7oraaJI2sPhmS6Yi?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330c4832-2747-437a-166e-08db13385d74
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 11:48:21.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fol+p8EdGEghnUuf0F2cgcyL5M9gk3E9wlGVh5kSukJ2S8dudw8eu7zjffDkX1DpKSo8m1Feg9GqUySsE5SIQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8478
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 12:15:57PM +0100, Ferenc Fejes wrote:
> LGTM.
> 
> Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>

Thanks a lot for the review!

Unfortunately I need to send a v3, because the C language apparently
doesn't like "default" switch cases with no code, and I need to make
this change (which surprises me, since the code did compile fine with
my gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu toolchain):

diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index 21d5656dfc70..f7766927bdd2 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -57,20 +57,16 @@ void ocelot_port_update_preemptible_tcs(struct ocelot *ocelot, int port)
 
 	lockdep_assert_held(&mm->lock);
 	
-	/* On NXP LS1028A, when using QSGMII, the port hangs if transmitting
-	 * preemptible frames at any other link speed than gigabit
+	/* Only commit preemptible TCs when MAC Merge is active.
+	 * On NXP LS1028A, when using QSGMII, the port hangs if transmitting
+	 * preemptible frames at any other link speed than gigabit, so avoid
+	 * preemption at lower speeds in this PHY mode.
 	 */
-	if (ocelot_port->phy_mode != PHY_INTERFACE_MODE_QSGMII ||
-	    ocelot_port->speed == SPEED_1000) {
-		/* Only commit preemptible TCs when MAC Merge is active */
-		switch (mm->verify_status) {
-		case ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
-		case ETHTOOL_MM_VERIFY_STATUS_DISABLED:
-			val = mm->preemptible_tcs;
-			break;
-		default:
-		}
-	}
+	if ((ocelot_port->phy_mode != PHY_INTERFACE_MODE_QSGMII ||
+	     ocelot_port->speed == SPEED_1000) &&
+	    (mm->verify_status == ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED ||
+	     mm->verify_status == ETHTOOL_MM_VERIFY_STATUS_DISABLED))
+		val = mm->preemptible_tcs;
 	
 	ocelot_rmw_rix(ocelot, QSYS_PREEMPTION_CFG_P_QUEUES(val),
 		       QSYS_PREEMPTION_CFG_P_QUEUES_M,

Besides, I'm also taking the opportunity to make one more change, and
really do a thorough job with the netlink extack: I will be passing it
down to the device driver in v3, via struct tc_mqprio_qopt_offload and
struct tc_taprio_qopt_offload.

I'll replicate your review tag for all patches from v2 that will be
present in an unchanged form in v3, ok?
