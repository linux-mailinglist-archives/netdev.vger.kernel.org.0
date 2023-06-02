Return-Path: <netdev+bounces-7377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A074A71FF57
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30CB11C20F42
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC51D524B;
	Fri,  2 Jun 2023 10:31:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70518C09
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:31:55 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe16::624])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9A026A0;
	Fri,  2 Jun 2023 03:31:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBDA7dkn1GFrgI5ELh9Fk82U+FEfHkMzFlfxlm80KIOyFi0guwsMEbFkCpjXnr52a/nkBNyHoLVTlpuJk79gh6DBCvOiQe3yxtX/O6in29SjiTEUHuuxiiOPZd5JuN/77WQnHgLSdnc9Wvhs+1Y9THA1coUZiJP7TIRxIEpKrOPnOlTk2ydanPo3kZkYpDeWpR5jp5ic5ge3AnuQDu+YA2Qx2w1FS77Qqof6Rul+1xe+LMsC/HYeO9fq/cgkQgnSTTQ1wrE72jaIzIYuMVLEgRbREAmAE8hXHrqPavDbKRT8GLDdwDaNKkKmKn26WL1XRuPSsfsTMv4q2VQBxpeXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtGlfLC+rzDCHwjsVwM+fsNTjELDLbwdsi7WzIB+fQ4=;
 b=GjFqH0HWYOGfTpTBwmkLniOnhWTKGOrOpRmJc/jPQRA8KNvytYG54hHSE+BuLtMTCN1KeMM1cSwH2V0gFAlzv/35wJh5h3lFUIgu9sitK+7R3jABHLQ62ga9/J/QbHN+JlMfdkJTPsoSguRP4jHiZhtinPBu9oZzmRxTy90ntJ25ThiuoZewp3R1VN4zPCzS0Vgg8PvaJH4ynXcB3dvdsXy18EJgmvWLpVgbUI8ciQN8XcGTLdoIX6jREyJSrQZ8mwxhq4CpJnanGheUzWvbajxqqERzkx9ULQ0UETvnP6sJxwYpp0ey4RqpKk/MEYGJFTkk4itmTbsNAJvojZ9DWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtGlfLC+rzDCHwjsVwM+fsNTjELDLbwdsi7WzIB+fQ4=;
 b=b4hOwkFQghozOj8EEg25MgvvMbjZ2dZdK/zwG6Fwzz35+YaftLjgezDBgC2MeH/CzfB9Xh8w7LQNGAkAFe4wAeXzyLkaY5+sUA5leqzFNApygm97XaCI1Oiohqh9+3/yHv8jQ1gcmYwWEOybLBXg159yeXAy5w0rJ35QTM7tLB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB9306.eurprd04.prod.outlook.com (2603:10a6:10:36e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 10:30:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:30:11 +0000
Date: Fri, 2 Jun 2023 13:30:07 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: wei.fang@nxp.com
Cc: claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.or, pabeni@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: enetc: correct the statistics of rx bytes
Message-ID: <20230602103007.ldgo3vpin5ugtm5h@skbuf>
References: <20230602094659.965523-1-wei.fang@nxp.com>
 <20230602094659.965523-2-wei.fang@nxp.com>
 <20230602102710.vnfh774wkpt7rclg@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602102710.vnfh774wkpt7rclg@skbuf>
X-ClientProxiedBy: BE1P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::16) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB9306:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ea02a52-c1a0-403f-ff12-08db63545800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DNmJ/kyOno71TN0KrmlDtLLNhE2X+r1PMhUJMYpENhIKeG+cfwSTHXvDckDD9EkSaEqm7fgj3KRGLPCWoXtM0+6OC9EF2e3554GPx9LJU1ITXal6FfipEfw2J2yr6chtlqC0TnzwwPUPHdPdFjBvgoVT+z2vBTZWopZ2CR7Db+HIR1Zq08o7F3RL/+M4gRmicNdw9JakP31niViQMQSQKKS1QMaz6/0vYJilTfLMnvq9+prVaiNucLqG3DuTRHTRvT4RmDgxwQEBKWfxrsq7ptiKBADJt09ApdCQhScp9Yj62MGWv8CFEHJRHuQm97nH/V2w0Oejb/NOh5od5hu8ei9hAzWpPo7zAN6RiU89samJmFHRIdWQ/MMqYGVNZC/hCv0WLET5NhyKfjWsoz6F+KrB0dmuoQv+793w/EZw9kujkYn8zrsrWYyPI4QtkczYBpBywHdT5eQjqahsWON3N23iPukRDgYJTsKTdZLCI9BadLPjC4gidt3NGCfYlXzkaK35hWvgqyqmsF2lQbMbBI5Hu8+JNBPkM1g1otDHtcJ2Faof7ZvwBEuTQ2X7Hcwa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(6506007)(9686003)(6512007)(1076003)(86362001)(186003)(66946007)(66556008)(66476007)(6636002)(4326008)(7416002)(5660300002)(8936002)(8676002)(478600001)(83380400001)(34206002)(2906002)(4744005)(6486002)(38100700002)(44832011)(316002)(33716001)(41300700001)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O/d1n7SCFQ7P8JhzFfUynxAzHBOMlWdFd37taJ94pjF5SqF02RjQUTZEDT0s?=
 =?us-ascii?Q?Dvj/hTFPGvLa3wG703mnH4+DYSsKYrcqKZm9rkIId2YMgSfU6Q65084a1dOV?=
 =?us-ascii?Q?8WgiVpwiMDwrKgkniVeKVmPPnCchUDonGOY6g/j7gAHZfWcIWWC9ekS8zTB2?=
 =?us-ascii?Q?VbAx6H6WpcOiWAcNsYABJ0MgrXC+EYZinSvVHsfgZ8CDVIb0YvQwM6CKEVnu?=
 =?us-ascii?Q?vFqYeUs5oH0btSsDwZ8FPOWFwaCZoUpQIiFhArrO9Rvzc0E+xpMWpplYR6fG?=
 =?us-ascii?Q?XBhkR7Ddf4jnHSiippb8QMLw8UH23SLO6Fb6ZxFtShZaZ/kpHm3qfWIkM3jr?=
 =?us-ascii?Q?OQgcCib8GM95b/gxk8KkofWiSWT1lBH1sPMYhICk2qJEXnfWDM8TDZqwYFmY?=
 =?us-ascii?Q?W4GBq6Acv0+KQfEkHdaN49fux4/jauIqWsE4nhFOb+JErzTI1L06bjkNECGx?=
 =?us-ascii?Q?gL++X7SJFDqilWlEZx5t1mskcrQVUgFPyrmTMDN1c0GKwlS1AfEPDu2vnNm0?=
 =?us-ascii?Q?jrdKNggkIHfHDMD9MznN59+FFFSlQ5gPVK5TEauSW7IaL1AO/brahertDFhO?=
 =?us-ascii?Q?W4rrjcAZY1CLlyt3mT583li0fwVXP4zDeG92m7JMG8AzhSmFsUxi7KAIqwYZ?=
 =?us-ascii?Q?lonQUnQl5uGyu64XDVJYkVUV/tlorFowLnT/6ChNKZMFvEYI1fWLb470ZA5E?=
 =?us-ascii?Q?AAOLuO19Y9sYHzmZS/UCIVKL4wjQvNaJryYg4SW19UfqCegAx0LVj7QOUdEW?=
 =?us-ascii?Q?71D951Mg9qdSX/awSk6yAlKIZIC6+9yrnF/6LBFiwpKSD/AcHtwnpLjh/T67?=
 =?us-ascii?Q?dMp1q5eYSIVH8lUKRRz8Im6FYJkDa4QhpIabWtHyprVnDRL4/nYz0PM6rBba?=
 =?us-ascii?Q?7Tp4Qs0w8L1EMzeejMqgFKewK6/dGgeoOt9ksM0cKO0BEL5j4aPrufEOOc2V?=
 =?us-ascii?Q?SEsPshYhld/lea/AjdacmKMS9lg4tlyXavIrpsf/+4TUxcFpobD2U2C4YfMB?=
 =?us-ascii?Q?VoH9XwmG8fnF0g2/CtXPkrC+tajxiXmzLc3JyZkGIxQmHJ/gX745VSqPVhw6?=
 =?us-ascii?Q?5GvcgXIzQy6T2cIPpu3lTvTF/fhuCJr2rSrXJ0ZZNR+bq3JSP9BsfTmNSGLj?=
 =?us-ascii?Q?73pFw6XOjuCwtGaCcM0Mg/ixGRtBTcR6lA73Hxt91v9N38tGUF6UPDqJxMc6?=
 =?us-ascii?Q?Hovw8P1quiHcQPSKSpkurLlX2BoCig066xJboEb/s8VSvd8hSl84WOnvi3Ca?=
 =?us-ascii?Q?B0iigI2Bbj58IIQ7GnHOobYiSTQkvR/wA143GdEMWs5UbOzjaWliVNoszOTW?=
 =?us-ascii?Q?jZf/s0XiFK0LBFt48mrjmazn7QMjQJEcZHQJxdXhDyI7EyLL8f2FpJcsjkIA?=
 =?us-ascii?Q?3axWg96zWnLsGyMEZxPN8j9iQidvYJ6m5L9IQoqq5NKLkYYkH9tvGAn0WhtW?=
 =?us-ascii?Q?7RHhlAuiCnkOarh69UDxCXczVkQMJvGqt4PT7jxBjcNJKr9S5aDKMo3dcb5+?=
 =?us-ascii?Q?nkTgdrgRMXOlPMQ44LxXdLAOQ3SPIV/b3+tgYeEc6s+fq2+7QdRuq7yzChwk?=
 =?us-ascii?Q?nF4hqnRcF5sSG9M1EFE3xh3XqarTiyhv0ANwAWzgfKWIFG1I+JRRXl1VdLW0?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea02a52-c1a0-403f-ff12-08db63545800
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:30:10.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfUEWohopo5Cr0OQTCoLfD8Eb7QUHDkCyDQhvB0AJwdrFq6+JEkl5AJMkqKURhjSA9Z7flvweMzmiSMdiSMZiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9306
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 01:27:10PM +0300, Vladimir Oltean wrote:
> Hmm, to avoid the conditional, have you considered adding an "int *rx_byte_cnt"
> argument to enetc_build_skb()? It can be updated with "(*rx_byte_cnt) += size"
> from all places where we already have "(*cleaned_cnt)++".

Ah, don't mind me. We can't avoid the conditional, since the VLAN header
is offloaded as you said. It's not in the buffer.

