Return-Path: <netdev+bounces-3711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80142708661
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15F5B1C2116F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504D624E92;
	Thu, 18 May 2023 17:06:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D14023C90
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:06:38 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2093.outbound.protection.outlook.com [40.107.212.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7BC19F
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:06:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQ+WBn/0d6Rrjc1E+kyymQcXuAkW7bC+Qyojg9Arr/skJjAFTCAUynz6UaFb/GmHCSBRdOIiOLQzZR+bNuvKobafRDALJCcPnX2ChxpiEIk4GQVxHh1XPuODf7Bgvl3co8Bd1XvHJsIN9VVJjdnjdbZX4EDJyzPKF12EquvdUZDx7AlCnBmSxsCqEx9Wcc/DIdErFE1M7WLeaZkTcOv01qmmHQgW/H1uteHk5UV4RaOvTO3T/85BXMPk5VgvSaiIH/6R7JwufOs51BJRdQZ2c/Jg0uyfqxm7xG9qsqdJJtsIsm9hGCmExUgL9OG5tFdALnTQK/dWXLT5Lo3WyRh8Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Py+PmDTzupjP5nv0kYUafJMH7tvJemPw4eOfwvmheVU=;
 b=YeSL5jVURWNtj4OPljXc6pPI6XQ7isCn6w3pSahkZ9GQaz0JOsuz6WtHmqWmdKxA00q4xuHcleb/Q9w5azk9DlKboXT4YS/izgL4RPQ2E2rByraQNPult/MiFZLBAeOHY7VFHL95W3UJY3ixI55OPXOSiT+5hh+hUrxu/YuGuk05UZs2G1V0u89obdcRZrxh5/qwlWdjBgku7gyFhsIBXrOJ+xPbkuG1FJWVLxACwJkPpDj/ukR0D3aqnFe296dOuufjXRNIcgxw/4knXnt2wEyeGgZWhWbgefXxY/UDbZ+9+spnKUSfX26VcBSaWDpV9kEgoLXC+l4pHa/CbRbOBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Py+PmDTzupjP5nv0kYUafJMH7tvJemPw4eOfwvmheVU=;
 b=nrRgCVe/HOnxh6SBktk9+bOO7OwCT0BqhN2DCD0Ol1SKVQITBiXpXHpsp2wMssqn8asAXaDi1rnHqWElQQQC40LaHTDSVmqB11fQAkB9eSonDikEz1vTx8/Zef9lF11opHrwFdggKJo26GSk4lYO7dcOF4zMOJKkjQngdDGCiPI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4079.namprd13.prod.outlook.com (2603:10b6:806:70::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 17:06:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 17:06:34 +0000
Date: Thu, 18 May 2023 19:06:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	David Lebrun <david.lebrun@uclouvain.be>, netdev@vger.kernel.org,
	eric.dumazet@gmail.com
Subject: Re: [PATCH net 2/3] ipv6: exthdrs: avoid potential NULL deref in
 ipv6_srh_rcv()
Message-ID: <ZGZbFD4Xhui5mjd1@corigine.com>
References: <20230517213118.3389898-1-edumazet@google.com>
 <20230517213118.3389898-3-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517213118.3389898-3-edumazet@google.com>
X-ClientProxiedBy: AM3PR05CA0095.eurprd05.prod.outlook.com
 (2603:10a6:207:1::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: fb56734c-864f-48dd-ce7f-08db57c23b9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nCU5VH6/lOVn+dkXeqxKGqWZ+9pba0iQhOJNdu4RUmKoDdM/TBc7fQjD+Yr6RAKW/mMg+LZhf4awA184gjXB79h4GjxsC4BRz5RiQ+GEg7xqbS/BvpzZxODb2evbtNLIEFtQSq1U/MtgRwOhgjLtOZ6BrE/eO+nSd692n45nHPx/ReX4PoRE/zeNjytm33ARWXpmdqL7I46tm6mi9/CDXB/FQYv8fWPMdk2D3bOE1I73cqIoNju2pxV+eyInnXQ07o7vpNAuVoWoy/zmCKyiWWpHJp6ILiZyQes01Xxo52j+etFHCBUigGyVjhjmtWu3NBfdNsaIsiCWT7xAgw4nKu5n/WA+VhSGK2bhp+5FoaDhZPNv4ngwEgSV9RfYagIedGaqaNdkullCUvB+aPgQCANkK4+mxQ5jf+/tZSfGQDCMJMyXM/4rgDefPjaB4Fb2dXm8qltp1sHj7McF4LVXEaR3vZWFTl3ayYDHvH1viwYmYhwQIrRAeXvL/nFuYa0NQJMUyob14zz6baM4zd7sQ9JMsvBYT4ovfNRWr8c19hoolnGHLRjPHX+EL8AhU8c7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(39840400004)(376002)(346002)(451199021)(66899021)(316002)(66476007)(4326008)(66556008)(478600001)(54906003)(66946007)(6916009)(36756003)(6512007)(186003)(6506007)(2616005)(86362001)(2906002)(5660300002)(6486002)(8936002)(8676002)(44832011)(4744005)(6666004)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?enpeQoK0zQSMZSPHuk6RTzhtbjWLqQWZf0+F/TMDXkGdOBZ96NmCWc3JzP41?=
 =?us-ascii?Q?XwM31v6mJob5ndEEOQu4dtyWzt/DcyxOdDNKVh+nsIrYOgJgM2Krf5s09y8i?=
 =?us-ascii?Q?0jrqhIk/u9tl2Asvb3w0HTeR2NocznG/NphOsbo9lSilIeBApb2k6BLhqtLh?=
 =?us-ascii?Q?Mk4FfLmPKpelYo3L/8UKysRVsEx/O9SSeR17p8ebgyB55Im6eDMLE0pNF+5L?=
 =?us-ascii?Q?kV/Hc577xKC0Dkg+6e8PrU98oS+1gjnoyokNgrNDiIvd6i3x/y76o9z2MFSa?=
 =?us-ascii?Q?7XUcZV+q1G90XmOwdti9vDEVRShCdbToyd/EHu18LXxRfYMnj+Wjgfk/PFWs?=
 =?us-ascii?Q?XHdRDsmcdQxPKXy+9uQuPywXKhlFvbkviAA8iIchNaVPLAfjdqkevdqdG4JW?=
 =?us-ascii?Q?1Oaq/3RHStCebuK9E8V0pZM+ZRikQnRUlTh8dT5WxiXakvwLS9fbA8ALdQnP?=
 =?us-ascii?Q?y32dTsCJCDGvuaUJR8qVFnh+CWkm5e8LcV+WgB/TJw165n+0eFOWGztoYtS5?=
 =?us-ascii?Q?mxhWGeceQ5KPUaIR/ju306HYENpk5InfIegArUo1BUUo6SBM8eSnt2lry2If?=
 =?us-ascii?Q?l6JU0Pe6++9jaDpv4eWCf1Us0PFO/JnDVQW1JDtbbwfZfdbm9xmK5So6hich?=
 =?us-ascii?Q?PRLkUn20Po0QVVhc3NoOtgucGZGckgBpW4TVeHDF9MsWgwEVvXo0tx+g88lR?=
 =?us-ascii?Q?50i6dlU5V/rYIxO2I9wQ5aFxgZEEVHR/iT/wlcQeWUsA39JEJI2VRwOdpw96?=
 =?us-ascii?Q?8CFoHUaG+2/UiIfZwXVSxQvWDGmubBjxX108o5sobC23nSQveo6N+NB3//tC?=
 =?us-ascii?Q?BgKGZCDzQhSpkNKLfGgISfFaqlfOHCcr77gSHO/5BiUk6zbuyvS3SCwlnADX?=
 =?us-ascii?Q?IcUnvxRUUR6cfcBLny5v51ohM6DRvCKTED90SDnC9u//t5147+NwGYWM45KS?=
 =?us-ascii?Q?c77hOF85UpXFoxbpAUrgvRaHkcA4baUbOBaZlpXpfy0NXEHzAov2ms9IX43y?=
 =?us-ascii?Q?h/nltYus+A8IExk+uhmzxiJtfth7M/0r3m9I2Z7zZZTZoFoCV3MpH2L/B/2w?=
 =?us-ascii?Q?uNiQGec4cLxHZv+Igl6yHv9Yo28nh4NKtOxC2pdMleFK7Vg0NMnAjLCaxsgG?=
 =?us-ascii?Q?+70YeBfdr4oHFq7YlSG9c7vBqsTHp/Px9X7J4GstQY9zykH0cbx4ZUf+vUIg?=
 =?us-ascii?Q?8r8H76dwVLShz95JcJ5ABQsGJshdD7Xy546wGzC+mp7RQShR/ArocfBnGqt5?=
 =?us-ascii?Q?e68mafQBtgd4ZJAXl1ZxD7Fs3euI9xeN/K7tx/h6s5yNbIwEqr6Q5crUjkLk?=
 =?us-ascii?Q?UtgAHQATbV+3ywIhV0iDoRqgchSf378wXT61sVUQFFaKl5dwpNoSi9ItUy+9?=
 =?us-ascii?Q?f8XALBRNj67UyejSA8gVPwd5pcEXLEXJUDIEfv/qiHwfsKubtyWtVXtIbjZO?=
 =?us-ascii?Q?3hvaxXBLjsi8YMcpf0/vM4CFaD0M4M1f3XPL1cPuHlEm3wVCa8O7kovpHIjD?=
 =?us-ascii?Q?CBtPajuDn2lO+ogWB4ZA1MKWsknN5liNWxY/herCULFIeCkTKL+g6829iTpE?=
 =?us-ascii?Q?TMz+q5Iv77pmQo3f4ct1p/xKwdYroMFpoHfFCuQCRVRyK3usmr2b/VRrqSNf?=
 =?us-ascii?Q?WExdo10MXr3aGpirSw4AAXC1kiwXAQuUK2Vug+0H5CwyTwnPQFlnaUCEKzak?=
 =?us-ascii?Q?0C42rA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb56734c-864f-48dd-ce7f-08db57c23b9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 17:06:34.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DqPgF/F0MhK6cUTMj+E0bODIPrdgZ27A2CjWbymHaUgHBLoje8Hrj6ub7cEAbjwHYjJtZFgz4PRptvTF+HDrxPxACR6gwbQERkdDHsmyGbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4079
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 09:31:17PM +0000, Eric Dumazet wrote:
> There is some chance __in6_dev_get() returns NULL, we should
> not crash if that happens.
> 
> ipv6_srh_rcv() caller (ipv6_rthdr_rcv()) correctly deals with
> a NULL idev, we can use the same idea.
> 
> Same problem was later added in ipv6_rpl_srh_rcv(),
> this is handled in a separate patch to ease stable backports.
> 
> Fixes: 1ababeba4a21 ("ipv6: implement dataplane support for rthdr type 4 (Segment Routing Header)")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Lebrun <david.lebrun@uclouvain.be>
> Cc: Alexander Aring <alex.aring@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


