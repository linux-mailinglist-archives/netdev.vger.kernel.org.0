Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C33863C73B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiK2SeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiK2SeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:34:03 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF32D4B982;
        Tue, 29 Nov 2022 10:34:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inwxmqM+kJ32k/wv8k5CmDVnMKWpdcMgFYsvSm2ZyVs5iwouaMnXhs8UPP/D1Mn/AJE+ztPOKGmcJSgviiDAA1xUOThLcyGiHCuliSDCH/TQ5SITZz4iQ6MtbxBFPEaZ09h9D85EBvVLbess5Eo9HVy3BTXgoCRAjY0Qx5psZLSlJ/9iOed9YnkMBtFjabAZ2OEjjrni3tnq1Ln48lfr9AEtLZqXt5uBOz+tnbur4Tnuz6kbs3NkKftNdA1AMAkeIlcNLKs6Z1cCVhD4ioNfz31m2ZjIdWjMrxPnhT3R1Hr/imBQWVUk3zhU0nTZIhezZK1kX4EV2RDxC2Fn90maaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzFz2mzvW9v2UKU8cYxSxph3E+F35UTFDmyWukcFJac=;
 b=btJ7Tp9VXtqgIgJT5o2kuBHMIF9e9CuEtbW0wpq9U6/Xff+Av0Sf7YumzjcfQ3rqZ+I5awqeLdmt2IhO1A3SmpNBglgO6BUkCtj4EJq3bOsMTCOm720bQxINRDUJSsy5PVT8wwZ/+lcbWGJtltOgud+7AznFrXyp6YT3mQlGDxbLQIBySSvPVyupH/N0iGrw1DM876udP9CiHXA4yRyVeiH3OKlVR8n35SMSrhRgDhMzfUYmsdQmcEmKBIzS5OOGNlbjvjamoC05SYKex9eIctbAE6IdDoC+YOQ5XILBqwqrpq79sAwLZ9WV10Bm78yWSc0/g7Jpok9vZS8E5K5+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzFz2mzvW9v2UKU8cYxSxph3E+F35UTFDmyWukcFJac=;
 b=CCMIznpjzEAcz1hJqsdDmMAC3V2vDqXCiVxWkfV8x50AsFnfyzF7E1Jzlu83lFf2M2DbZ1wUUKVmBjVoo198/0sGBA+gSTP82hZEIwCDYbZ/GQh4UvXGnLvBd5rJjseXBW58kEjjgYNLnJvgx52aFmTDPZhR80MgufqEdIG+/dg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9700.eurprd04.prod.outlook.com (2603:10a6:20b:473::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Tue, 29 Nov
 2022 18:34:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 18:34:00 +0000
Date:   Tue, 29 Nov 2022 20:33:56 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     yang.yang29@zte.com.cn, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xu.panda@zte.com.cn
Subject: Re: [PATCH linux-next v2] net: stmmac: use sysfs_streq() instead of
 strncmp()
Message-ID: <20221129183356.bdlhgset4rk5a5kp@skbuf>
References: <202211291502286285262@zte.com.cn>
 <Y4ZOpQL3daLPqXXl@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4ZOpQL3daLPqXXl@lunn.ch>
X-ClientProxiedBy: AS4P250CA0027.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS1PR04MB9700:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b3a9800-56b1-4a1e-8b87-08dad23848ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHz+Vgja380/FzdXPbSRlTA0iiv6tSfnCvnfuJobTmhy/aOxFp/JMlneDkcbwmM7Fja0CDlz+40rI1gxJl68PPDqLLibWbsLEcuCSQ2c/17ur+gKQWD+YQMxcTjcz+KXgest0S8mtP9XQL3ZYPfUH1IY+7nmjWSFmI+YYMfp0TjoxdpKNat9kDBHRpww/HkCgkx0Lg5inlo0P5M9oMzixF5ESgY6DMAU+bIcC8wPchK9qY0xR/Mb6aPhdxUCMJPmeGnOB0lpGJtJE64NhtoYHMpgEziFkcKqNYFcSDTCG1AdIAEPapVljGWvgBhQYg11bs4yWkRyYOuOW8D7JmfQcT6yZRWYa0zAOXoOqGWhGAXB1xmLambJh8jEPePleP6uXNY1tRB3LlvOlbqASHk449Jxcy330LLQ8FK+rQ1BgdcNRphPTbiCFWUtmfyaswXccFM3WjZgGNobR2KUEWrr8jBQVWQbsyyge4qi1M1sjB4VdAhiontaCjaYEptgZwvcinHN0iE/CGgH+sGZavm4SHq4UoxAOCwmONvcnlo73OgtYXIvGwgNgfsC8MKUA/S+mFrxOp4DCmwlW2wFjR1W++nqcF48zXmlWXMBwiqqFFinPQlF9ONm9X+S6beFXy99ZEKHtV+3BfwsaNxhzq2JC0o6XLcGKB5arBUJYmeFwDWJoM5yeR8o6EcIpnNQBldK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(2906002)(4326008)(86362001)(44832011)(66476007)(66556008)(66946007)(5660300002)(41300700001)(4744005)(8936002)(8676002)(7416002)(316002)(6486002)(478600001)(38100700002)(6916009)(6666004)(6506007)(26005)(186003)(33716001)(9686003)(6512007)(1076003)(83380400001)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cXFSCbg1XIUi1ppY1icO4f8hReo5+549pf1FFhVS7AmuSOXIE8b1gyLuOWWh?=
 =?us-ascii?Q?z7yY9LzHDrOlbyp35oq3FTUIZKMnouAuNyqvAXPyZ+TnEFvtVgLiGgt1jtUq?=
 =?us-ascii?Q?bYcNUutSLAIep6A+VLV/9l0BUiUwpwsFoyfNBek7WUviY0Lm2k0pTzhZw0kn?=
 =?us-ascii?Q?q9BjJpxx7jU52Vc2GLP3ZciuWn+XEPj6Ig4FuNWOxepafiD/dFfUuqVtTL6+?=
 =?us-ascii?Q?NKloO+XHgafmktHf2DrTgDcFpYkfBg2E40o0Ot3nBmMiZdR/lnoh/8fXBCrI?=
 =?us-ascii?Q?VyMXoaddW8kaJPc+ZdZZZS7h6ujLCe/iORp11klNBKgJIF8HZJvr93AdYyFO?=
 =?us-ascii?Q?fsxRw/BjcwRH99VhajLkl85ZaT1SMcnXQGKb536yPd+6VdJ7LpIMyUcsFpuX?=
 =?us-ascii?Q?+uPHh97gbmiyjbn6t8lCUOi7Y4ZlI0Mr8Agtmm5ySh9XcTDBSpOaz0/6nw3v?=
 =?us-ascii?Q?dG+s8sUsZS607QFZTneBkhv7s1X44X7xE4Ml/5XeCrOnCyYAjlRcAOU8Zhlw?=
 =?us-ascii?Q?03xToWhKKbR/VxSe60lOT2veDpcaHhh2h//MfyxfTMvDtvCDLEqEvv/GYv43?=
 =?us-ascii?Q?/810YXl8JnRAnwdo37rcd/foxC02XkOo3ttmTPa+mj1egFFNM8TeGJucUI6S?=
 =?us-ascii?Q?9PW+JQ57d9iGSs+NkYGRa4vmLeq9g/qFtAII6OLYCCIRlPziKvBXkzRuYY/H?=
 =?us-ascii?Q?sl6qH6DK3q4uJD2SiaNuOsKhpvgHEzxYvHbxLROeI8m2ifVvTLQ4KQijL85+?=
 =?us-ascii?Q?NhJ26W5iA9vXsuSVLqi2tiIwOgzGROEE1iBO3g82a0RZ+fDc7avJiaYzcZ2y?=
 =?us-ascii?Q?ROkJ56VZrYxbdYlGtzD9xTKa30vjTn+1AY7zOeGdDyoq+qbMAKYu9PowEvIA?=
 =?us-ascii?Q?CMyx1HcfdBo9Z/cAOEV+OfR+1cHFrdMj76baq2J9ZZE+PM7tEdeWIz4ckPJq?=
 =?us-ascii?Q?AS7EGsPz2Lnq7FR4wAgDw7WYrtdr53vX2QPMeo6hnM3afNxE3sgQGlQSMEb+?=
 =?us-ascii?Q?knZhpPKX1UPWbW9JRBrJLx0E4xmq6m7mrCAhzr/2AreThAg4Es+S9i8D0KW+?=
 =?us-ascii?Q?OA9reRoQ5XNME8CzYglplJGpOR3maUp/fEixqSr+w63ci9pCUEv/1PtXFQUL?=
 =?us-ascii?Q?aNTQ73tRl3r26m9I2UJFIsEU9bqeKQTnKV2vIyFJMPJtAvkl0+oxFG/VTIuR?=
 =?us-ascii?Q?KSwRvbu6f9w5BNbVJFY+uj1D9HLcuzl05NvMXzNApbVl9T3PhPxN+p87WUDa?=
 =?us-ascii?Q?5JoWIaQ8YhON4Zo480jPcxI5XazRczGHQIj60Ip7vP+u29OtFfezmZTr92u9?=
 =?us-ascii?Q?t7qO1TmHZL7O2ljLEqf4J636S5zE1tGFrupnPNQ7cUFjcsxDbJTQLI4GXHcL?=
 =?us-ascii?Q?Rgrw2Y0Ch5OuQcKI0lTA3FclRpMXEYyeG2+VMem9o+f7DH0V+Gmsm8Pywfv+?=
 =?us-ascii?Q?qP2aCQOq5jO6LB+jDLSBCsGdfeCL+uQWx9QKYW0hJOyK0A6iTm2Zo4bJw1G3?=
 =?us-ascii?Q?KQkn1STpK+JGGp/noL7eYCJ9SXPbqbpxgei2LErDYBXIBWBIaR+1VNMvW+O0?=
 =?us-ascii?Q?DARSQcdi+CeosCCRgM0c3HMq9XayHOKMKGrFloJr7duuzr9wNhBPWzxTUw+y?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3a9800-56b1-4a1e-8b87-08dad23848ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 18:34:00.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyZ1aySYIvDbyCsXnVixX8od0mjJ69OXps8sbL1MTd//xe6sGQwQmtTc1T9Ykf+rtfHDrp6qu0GY3QiO7by8/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9700
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 07:25:41PM +0100, Andrew Lunn wrote:
> > With strncmp("tc:", 3), the code matches on the "tc:1" token properly.
> > With sysfs_streq("tc:"), it doesn't.
> 
> It is not clear you have addressed this point.

As they say, "let sleeping dogs cry". I'm not sure that we should be
making (especially untested) changes in the cmdline handling there.
