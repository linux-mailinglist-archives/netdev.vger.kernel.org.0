Return-Path: <netdev+bounces-6272-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3006715785
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A7AA2810A6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCA0125BC;
	Tue, 30 May 2023 07:47:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C74A111AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:47:21 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::71b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E5F1BE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=excbYSKipPqtB5Cg0vpZJTid3zMhTEfCntf6gPh58C6OZnPoEB7Q1ugqTlyxzkoh3XqEtj38kW5NknJmnN5hX7PYKZjwudR7lpUPDLH4HC3DNFaYY7E5ctDac7pgWx+cz/kStk/xQuZnpqPGd7MfhMz8fe19jmm0xAGEooNjeOtc+NywJPFUnEIEdUho/l3Mky8oBkWG/IfcY25K02cTscdFJx/XaEtiyMHrCpd3v5g3hOZowLn2pcovWwnKmYUC6lkNJN1MCDtK/c+D5oU53969zxNHwEMvw5B3L1VWObd48B3GeajUYmlB3xyEYRciCgrSDjGdnBH/ZZbg6eLfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yP8zYKAXhjEzZipSdgo6C5Q49qU0SUDyT/R73gM9F4=;
 b=DlxRuvgu1rnWJwxKnQy7Sr1WKQa5XBeVHhWzm62wiTBnvB/GGCf6UwjU6EcHs3SvINUfmbC9FrPDuT3EvamfZWC7F/993jVf2iHb0z2D01l/8+KGIgP89u8blyOQddFSx1QBab6ydUqBTLTeeWBAv0DUfI70kznT7nS+mex61JUnZ2ESrDh1oqZH02kcIbb27o6bnkV/DglxvIDGnu9wFm4F9Wp+RVExtsJbCOXaR6/vJTZZ7BN7NEAzj/M7PbyIlhCxI+vQnV0za4DeF/zZXyBni3FihvWjCclB4BOOgUdJxmaEdCp0bpnz0UtrVyZZ66OCdPd8KVGD++5kRxK01g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yP8zYKAXhjEzZipSdgo6C5Q49qU0SUDyT/R73gM9F4=;
 b=DRBFS/kWDKw4LHVWRrsKmXkTrgo7fG08xw8zz3MnrhgfZFR+JDpKiE5vkB7c/rFv9K0nvUrPN42YxzR5p4yIkjinijEjHjV0naJFUNYbrJ+zOQZrDkpYM+N7F0AcLWk4jFg2lsQHuSHjdc0YP9bsA8MCl0y8wfvyyNWiRwJ80Zk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6494.namprd13.prod.outlook.com (2603:10b6:408:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21; Tue, 30 May
 2023 07:45:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:45:15 +0000
Date: Tue, 30 May 2023 09:45:09 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Parav Pandit <parav@nvidia.com>
Cc: edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: Make gro complete function to return void
Message-ID: <ZHWphd6hL+dccyVm@corigine.com>
References: <20230529134430.492879-1-parav@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529134430.492879-1-parav@nvidia.com>
X-ClientProxiedBy: AS4P250CA0027.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bbf31e4-2500-4eca-fd81-08db60e1ceca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GV0e4XLXS6pVQGkLYj/X7cfyZPl76DwGKMaJtpJw0Hqf5A4PDb3XAppsf3/Tr3Gz9JBQg4Fh48sHhBHNmYaFjmprSsq2Z6K34a0zvuIi9o30AZlrFbwyJyMq1beRLL8AEp1JjNSybcM8u3vhrzGKrMjLuRqtIv+zW+bRcgPMsjTgsTUVZrtYK7pNTVtaQ08h9CDkdtPNKzhPgXFiN3/JFQtwF7cGWDJ9BPxJ0+r3EV26dn2ZurpP8H6i0gTQFZISFEMUeIkp5rkO5hhJ4sareyJDFCP4Nr7mjCHFIkZLLTmQK6OuXdO5TaoI7GqSVCZcSI5HgdXLMgQT5gsGylJCzvOlpHX+uVOW9F2DcI1bUpKlMuAoPbjE/HLdWLACvityqVBaF8cGaShSIul10peSmipn24hk/qis0XniDV5wOh/uW7E4RuBg8sVDDtsPsgqEysauZHNcwzjmRPTHDiSjhntlvJ1qJtofwcxU+z1tkcyGn1rL0q//4p6mx0XxRRgsHA63S+CLdFzmVn79z8uWPcEep5mnxmUFzsUlCNqFnG4hEIf0wpekwi/dbl2K3vU3LGkBQlSa8zmZqtxvexWCY6g6RgwT/7pot1EcShvCY7M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(346002)(376002)(366004)(136003)(451199021)(478600001)(8676002)(8936002)(44832011)(5660300002)(36756003)(2906002)(4744005)(86362001)(4326008)(6916009)(66556008)(66476007)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(6506007)(6512007)(6486002)(6666004)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o66g7iFyr9LyDkp2URxamNlOnRbJh3zVOauejC8QRpk/k3cBqcNqQuqz6nKR?=
 =?us-ascii?Q?K8kESWfLuf0BMEzbawCvLZ2WTmSUqxJJwcBqc0hNJsHJ3nt3oF2z7fRE9iB5?=
 =?us-ascii?Q?b6gsxG8K7hdQYfYbA/HoP7vW9SQWX29Yt+og9P10OvdPuvhF4LzziNRtFPJU?=
 =?us-ascii?Q?PB1NtXWusncCieCpEFJtzeISoxQWIw5aJgdAHXOUb5LPwNuPVbx4rWNxvUmZ?=
 =?us-ascii?Q?tc0JeR1EAKL7KM4dxwApT4/Zd1jqA0sK5y4UMUkxBosDLDGaIWtqsM1zlrCV?=
 =?us-ascii?Q?MYHQrkIyJSATI6tyQimKpJPRtqxB5fLoR8SBINBiPljg3p5F8DKcgjup6IXs?=
 =?us-ascii?Q?yAdUJt9YPoJ2nXnoqXziEnd6jP+ufh16TQtZu3YjvQXY+swUVN8Oqvw0T52x?=
 =?us-ascii?Q?3dbjuT7ddkGXC860NUndChZU6chC0+HVFHJiLYkRkYmqc4VK6PrP38IFAoAp?=
 =?us-ascii?Q?eosccJDGmXPdugcYNYgGl5O4UPzBPT0eA+FoSoJi9wPemXfDLmmajVHsHYdk?=
 =?us-ascii?Q?Xwkdd/8JYMb+jGXJgtLQ8Cd0XePWWeCLb7jZfAWb89uqmq8qGKNUPMFU6Zna?=
 =?us-ascii?Q?Arru53yD7a1pgPtlXYyeyX1S7BfjHTqGtU4Aq6AVaw//V+Vv0YKlh6XMERWp?=
 =?us-ascii?Q?gvg9R6pwyeuXoPfZSrecKGL2zCghqq+OAY6/3+WVwCPpxvb33JPOlOtAUQG3?=
 =?us-ascii?Q?39Yx7hhFyOOuq+99ZYEZdeLwciu63pZ42xV9lbW/hBqdqbQljDXuHZOhPVGK?=
 =?us-ascii?Q?7wBUwJTEPrbD5aMFtHL4lGGBeN2U7nztlUeggRaxdiXQBnmmwQAbNTIe1EYJ?=
 =?us-ascii?Q?zeWoBe21VSqVs17Ixvl9DnRHRZqaVVXSaEuF4lO8utxVYTKlH2VntHP2drri?=
 =?us-ascii?Q?xDoozso60YWsFBJuhySfdejcpmfNoLVuQ5tb1ev1DHZD6LQKr3R8hde5C4jA?=
 =?us-ascii?Q?hcsElaGdkBOVreEgwLDsbHA+50X+9TuPkmMSfSVRhX0cgDUvjmaEkq/sDDQh?=
 =?us-ascii?Q?ifDjnMfAXjaTQeZTi3Ru9/es9WaIPPd1qmVnkzqPheHNvp8adbWys8mBwmrZ?=
 =?us-ascii?Q?Uvy8GrVPFLs5sc0M2xVepRdyF2bZLD7G7BYwb9Xu5CXPBcBGZ2Bwamsrw2ew?=
 =?us-ascii?Q?KeaRQPnmJQqV0ZKhYlwWtmU9m9tIS7VaS+grcEwVuSQswZ5JSB9tIf3HkYSA?=
 =?us-ascii?Q?VBTH/vZO702/1Q5k52WCWQjFXeB8BhuYajN9ix8TUaagf+t4R6G2EwTmxtqQ?=
 =?us-ascii?Q?x6Uan6MlUkzTNG4leyXqyLHGyNFJsDBxY0JdPNY9Di4fgrTlDwX+KvF1DQUX?=
 =?us-ascii?Q?zLvPfKqBWLoucH+trlj5y2KPqqOsjmhc11psNQI8wm2UrOy8vbGD6cflwO36?=
 =?us-ascii?Q?19jbSvf5nhfqp7VpusRet5Vx1elHEXo8ldxfCuYmLsVI8gvBBZKYp0aWKVxL?=
 =?us-ascii?Q?F7Ax7aajy6+IpB2eUEg4amHXcDLNlbvZgQMW7Msmu42u+JzE3LXaOm15GQbt?=
 =?us-ascii?Q?N+hinBHdXJVt3P0nPBal6WHDPc5NrHGMvvcLiJ1vettwHWQVCpjLtAHQouX4?=
 =?us-ascii?Q?En27z5jjhb2gDahLMi+fpeFnTpwGt1rQBS5pI6bcURJekXJtH9LMtpJCzqb9?=
 =?us-ascii?Q?s7EotMhMN1I72DHWWIT+7U8ZjW3fgbTajMqCQ1gvLoq+wTwVf4P4tfszpNtl?=
 =?us-ascii?Q?iX3eYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbf31e4-2500-4eca-fd81-08db60e1ceca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:45:15.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRU7ndmf9wJQlAxSdat0MprI1AIoC3+H/JH52RZkgeVHEUZIxFnDATpvDet6MaRCp0A0Z2VFpTwQLwKW3iXZh7wCDvpWENu5YjCoS0owM3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 04:44:30PM +0300, Parav Pandit wrote:
> tcp_gro_complete() function only updates the skb fields related to GRO
> and it always returns zero. All the 3 drivers which are using it
> do not check for the return value either.
> 
> Change it to return void instead which simplifies its callers as
> error handing becomes unnecessary.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


