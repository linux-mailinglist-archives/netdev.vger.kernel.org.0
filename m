Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26ECE6D5541
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 01:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjDCXnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 19:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjDCXns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 19:43:48 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7002D4D;
        Mon,  3 Apr 2023 16:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EURmgD8s07BoeIsFgUxoIDnZSje8R9IY4dhPNGcOEY6VfSqMLxe0Mdg92jsrG3UEL9TXGW5fM+fVoT2KZH1PmH3DcpUjPYE018jHILbaAldhqxKI8jKOI37zk7NP2cssUhRCTLSrr9FtlllfWXginb5MJjrW0VhmfuvO2+OCk/8DXzjUbRfWx0CvXNkNuBJBb9hvVo1vzaU+oBETSYlepE7D3KWEZyNg1OPDsnivH5D+YTHpuKeT5foqDm1ClF8xNwaT3GW+ci26BtX2VybrgVX+r2wM108W5kn3uIvtaAhYs0KOpyXUIJK0m6FO+80++Txsot7XHI+dlKZqqrum9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPRyHXZ6UE0N6ogfOH9ansfglXYv0kmYo+hEA2ZU9II=;
 b=Bbo6uM0vEhKoPffczHTH6+PyG7HizsJD8/32rYCTd2/ufmPQUtqdleOK6KJK5dlakZzfXeCkChBN7dLYCMydsoqj3srsMblpmG+ploOLGutr8g64dVcp8c2ZCUk1xDbcTTZatCLc0oLiyPQKnRsGkTpM57UWnv2iLOKJSE/6yacKP++2FjqsHLF80hFSlz/Hwj3AKMYC3bt91nVjwP7pCxoG8ec2Ess1sPNNXB1LYTNT0V/9f19b3A1GH698PTzZ8sW3NpzI9/tFCo24hznJzPKbUiBh5CoTL14LO+3zrnblykRJPlM1bcrfTvMrGW3zEYi4rr04HzT4HVI9krH2Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPRyHXZ6UE0N6ogfOH9ansfglXYv0kmYo+hEA2ZU9II=;
 b=n5hCjLRMcGBwRta8wTuapvmIsBDclbVw34ALhBBMRhxVQtAMiJV27XEV9ikALTdwg9FQKuYhacAtfk7DXKmNe4oQRKGXnLwT3REkiX/Nbccx32y7rDUGm08+KcHZoUGr1P2EukUcg1gL47wiBkZpcMqtwTUvxaO+U3rQOA+xsG8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7836.eurprd04.prod.outlook.com (2603:10a6:10:1f3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Mon, 3 Apr
 2023 23:43:44 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 23:43:44 +0000
Date:   Tue, 4 Apr 2023 02:43:39 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/9] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
Message-ID: <20230403234339.h2eaomwqoawicaij@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
 <20230403110458.3l6dh3yc5mtwkdad@skbuf>
 <20230403143229.415ede88@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403143229.415ede88@kernel.org>
X-ClientProxiedBy: AM8P251CA0020.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::25) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d7bdab-f36f-42b4-2aac-08db349d42cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ODWfsWtUK0zjMmvyjMLc4yL3NTFDm+41yCu/C/d6KkY75Q5hz9YpWr1tXub+cou3J+J6lfME7BwZJIuhcTbrDbwmRsbxxTua+BkBhOIIOnSDq8Y0Y5kVls8n0xUFnol7LAjGhNAvVudvngtdqb8S2IKdZaTUeBWXdmoMoOd13kqL7W17Q4HTBQSue4a2pJ8ZA7sipWPmpUdlUapQWOTu3OoRFdilE0U780+ZFu1oNX1Tnj665TaYVtuo97KIi361HsUiESWK4ePTN6mO7dxa/dMlwZ31Kq0s+1mZbGy8P+mxkVUq3ZXH7Jw+Q6oBHXIWgR8yw+rP52bO4vxtj92fSPTn2TUvKM3zrT9YW/3u+yAqu+k+0Rnd9UFUV2e7iEXEHbOx8dika6AGZfIj5f48859CYFa+M6E+NBBNAz3wv2ebpiHs5CKmFXm2J7082dDBnfaBQuTxKRQFS8fJ7mxZ/LrV1NMCUHYZvvMWLu7WDYa3la6E0s2cMi8S19VJ9xyAIoR21jfM/oOPoxMGtzKWq42AlZMRrASUqvq4UJkbxLBLu7UH+PwMgi8kA5zXwpE8/bkf7vXrWNAaxJblgIqTTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199021)(86362001)(38100700002)(966005)(6486002)(26005)(1076003)(6506007)(6512007)(9686003)(6666004)(186003)(6916009)(4326008)(8676002)(5660300002)(7416002)(44832011)(66476007)(66556008)(66946007)(41300700001)(8936002)(478600001)(2906002)(316002)(54906003)(33716001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sGmkGlAYrCM3/YYYE6aMZbsEwsek70lhONNOGNbssAxl3fGEXACpX9xwpmag?=
 =?us-ascii?Q?6JlSGkEg4SnzJpl+/iKSuQBKTPDDI4ehzGw0IVPRlJ6rDq+hOxeBjftIOiAr?=
 =?us-ascii?Q?XXe6Jvn7uX7U3vKF0uhKCB6jR8mU6SUOVvxUHatFYygELyJloF0Fh25ap/9R?=
 =?us-ascii?Q?xhxHyq0xu19KiROu6jjM/MVHu0uGxrnbzMWft245hSxwvHL59ntB77ai2mDs?=
 =?us-ascii?Q?LydOXPUm5FmD8/zfW1Ap5GQr0m6XDSTSCsw9xHMRLY5rwQBrzxnV0T6uYQDa?=
 =?us-ascii?Q?gggfWCs2+CxC3stelFujQ2DTtHHtK4LxLmBQ5Vqvm6X18YQ1o+7HMukjJ86Y?=
 =?us-ascii?Q?SFG88v9wZbgE/eFzVzIjSXfFwfOGUjO7LCvFQOSiYadaifGwAvuQfxNc6ja9?=
 =?us-ascii?Q?2KsrMiToainkuj3pOA9XZqy4qzalIDJ+yUDJk3oRQoWOOEI18AZWiJirY0lS?=
 =?us-ascii?Q?uee+fJWUBDq8pkGbWAqknjL9qsS0e6jKyl9ephA1Tl5EaIp/Lec4zRuKE0eS?=
 =?us-ascii?Q?eAA599/kiJQOynbgvLBNjnxPgdHj/4BEV6ERKzF8tKSfu7jNE2PxfP8xP9/5?=
 =?us-ascii?Q?n3y7EJ10efIUP7muLA9Re3NI0VXQ0EgJ0jgPffpKJTGkRDw2dNuzDAwjr1se?=
 =?us-ascii?Q?v5TYDTUAVhMNU8ffcwUl8DprtyL6hmkfZRX/Ag2aYIWSYTOybW9dmv8wotF9?=
 =?us-ascii?Q?g7HBK2wzsbFENqgi7SujUCnrQ6ehJF829nYqAqpwlo0CR95qkhLCRrqtiVgz?=
 =?us-ascii?Q?CP9R/t4xqiAlOadI7LQjeT//LzoNDeDwfn+oKgek7iBNZh0BQvfAOYJDunWh?=
 =?us-ascii?Q?3M1Oiam9YkfqPjR8+LX7hlKgPZw6aUDEmstOP5Drr3t6oBp5oZnDsn/iR+tX?=
 =?us-ascii?Q?Ho7GTkPuBpblNW+lIk3i7CrCI7BD1o6ry/udY89DyjKCPQ6lXhTFV76kC9Af?=
 =?us-ascii?Q?q0lGQJr51nPJYUB6aL6usbpK4qYjNeGkQdSZLsVBvCmjnfR7JADUKk6aMA/7?=
 =?us-ascii?Q?ApSQVNwIrF5huvgITEar6/USSEMvbCuowFF6YMi+aHFMqxkXmtTXxz+bvBPf?=
 =?us-ascii?Q?0y+VzOyIewdgBNVFL+N4QJ/BC0NEW7ZDQ5XJj8Udz/gWA6BHhfBDdiHwGZGX?=
 =?us-ascii?Q?ie+rgPCHzx1QNyz57ryEexTt+sqFr/TctoPDpY3uZ0J7S9EOagrGyj0hWPyg?=
 =?us-ascii?Q?tsf1Jtfv88vkwmJ6yJHYxHeCO6sktv/VDUJnG8274lDEEHJJJQBwoBfevHz5?=
 =?us-ascii?Q?5eSKde7urW/dRi+Tv5WM1LKqi8P+fvOVEJj4Aq3Xg5QB+2x/8ipnozF+sT3d?=
 =?us-ascii?Q?tu7K7EKL5ZpG9JGkYx7sqaJH+V5g8CX1D73CQjeXAtfVYchwO4ESJaLD1gxs?=
 =?us-ascii?Q?aWWcMdYCe8DAh8klPqqXQgH4G5Qu3vwbQyDGwn1SD1tR1L3YAFsRl9KvwX67?=
 =?us-ascii?Q?ao1/MslPPZDhsRCYH0x36/JwzzEGMJ71uzJocjsbVKKmjfujhyCbsGBL8ieM?=
 =?us-ascii?Q?uwtknWxnaMwtYULW9s4tNy83eqIVtd2NXdzSDBaoVBLVgHjSkh2RZbSIwiWz?=
 =?us-ascii?Q?6OmLg3RGhGhpy0r3vvNuhFZhi2B4g7HQaWpEcpuK02jmYLnR5MFYaal7Wh9U?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d7bdab-f36f-42b4-2aac-08db349d42cb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 23:43:43.9704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDme8aY8arPKasVTou1heUtYA/O5Gu254uojPm5+ps8BuLjyTDa0rlJEjGlIaC6QcTnTg83shO1uO9k3iUEsoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7836
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:32:29PM -0700, Jakub Kicinski wrote:
> On Mon, 3 Apr 2023 14:04:58 +0300 Vladimir Oltean wrote:
> > On another note, this patch set just got superseded in patchwork:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20230403103440.2895683-1-vladimir.oltean@nxp.com/
> > after I submitted an iproute2 patch set with the same name:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20230403105245.2902376-1-vladimir.oltean@nxp.com/
> > 
> > I think there's a namespacing problem in patchwork's series detection
> > algorithm ("net-next" is not "iproute2-next", and so, it is valid to
> > have both in flight) but I don't know where to look to fix that.
> > Jakub, could you perhaps help, please?
> 
> I revived the series. I'm a bit weary about asking Konstantin to make
> the pw-bot compare tree tags because people change trees all the time
> (especially no tree -> net-next / net) and he would have to filter out
> the version.. It's gonna get wobbly. Let's see if the problem gets more
> common.

Thanks. Was it supposed to change state? Because it's still "superseded".

Let's wait for a few more days before merging, anyway, just in case there
are any other comments from the more TSN-oriented folks. I'm still not
completely happy with the UAPI duplication in 2 qdiscs, and no indication
that the duplication would stop at 2. For example, if I understand tc-etf
correctly, it would be possible to see bands as traffic classes, and so,
talk about preemptible bands and end up adding UAPI for those too.
