Return-Path: <netdev+bounces-7484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD59720733
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E11EF281994
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB441C75A;
	Fri,  2 Jun 2023 16:15:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025911C758
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:15:43 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2089.outbound.protection.outlook.com [40.107.7.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556231B9;
	Fri,  2 Jun 2023 09:15:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSrJb0VHspNBOydDEbCOlgK2vnGDsVKK2zuJbEbns47FlqJ48/45MJQEJk4Iz9kInCI+O1SOGyfedOXbxrWGm+kBEmn1niFwPeFF6PL+FB7cE4RyRiNgaqUTQZCQMZIH2cY/tmfWVD3G1Eg8kNHVlVAO5cgFbfHVkAkzt7yzpZCrH2UqxTbCabyrCXZxBP4HhMym1Gkbup5Q7NEO9x7t4+t55OkuTC9C/UxNnS3rziaoq4zFht0vurlpkElfjRdzZvls3sBEF3aoicuCVrFuPX/sOKuEfmQBPZaQhV/4cRzB1ep2AtcOFixgEEkckawG+HDA5yDgvYT5BLoiyYr7Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBc0pZcfC0cRkNwp92Kzv6D6nro6Zm3cxMboyWktHoA=;
 b=hc3bXJ52nud0zdSeLVGSB5MMcBfpvvkf5oxJkyuBA9/p397gsC+OfKini/F3Zs/xV4d8uRaXLHqELr2dgkGRTRPYMPq6QL17hNAzVP+KCv3gKm2tpT3toTE6AP4+dDlOZcZmpu+ZIreni04C8nPD4rKprYPnyjXppGy9qrVURcfVwKRjgtXbhEYiMB+7hEWB23W4jJTpGtgKe2i5Tn/XhFAF3CULP52GnAHZPPOvkxy9BsMp+mLg/6VqR6ITWioU8q1G0YYIj3pNES71ukAunUSW7uJFeyGbwSI7nsNxmtLbUoTdgYP9iSwCy+RDi3jIGgxfYJgSrswafrPAXAbpMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBc0pZcfC0cRkNwp92Kzv6D6nro6Zm3cxMboyWktHoA=;
 b=F+8Ee+vur74Gt72Apz7+fsE1egyWzmHLizHEY1ClrqE1Im2+G/VCNutIppZQFoPRXRcVt5mD3FI9HoR0X1pIzx0pmm89pPpO314Jye8p7+g+mPVJx2m9ltI5GfYrYvGpW6Aa3sV83emYcw80MDcMNFQaqLdjcQbDqQ+YWLg97TY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7168.eurprd04.prod.outlook.com (2603:10a6:800:129::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 16:14:59 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 16:14:59 +0000
Date: Fri, 2 Jun 2023 19:14:55 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Tan Tee Min <tee.min.tan@linux.intel.com>
Cc: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	netdev@vger.kernel.org, vinicius.gomes@intel.com, kuba@kernel.org,
	pabeni@redhat.com, linux-kernel@vger.kernel.org,
	edumazet@google.com
Subject: Re: [PATCH net v1] net/sched: taprio: fix cycle time extension logic
Message-ID: <20230602161455.zle4k6th3qoee4ho@skbuf>
References: <20230530082541.495-1-muhammad.husaini.zulkifli@intel.com>
 <20230530194708.zz6wnzaenau54hcv@skbuf>
 <20230602071406.GA31501@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230602071406.GA31501@linux.intel.com>
X-ClientProxiedBy: VI1P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: 40362a1b-68c5-4bcb-7d4e-08db638482f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hXZGz7VOKgE4uGAuzi9ZsUeCll08F3qcEq+RNQeAXGahm1C4jHkav6IozJcs1yRKRTRIK4B8O6LChU6ABeFxc2dbKPOT/n+d8rfsGlZVUGntR0Fc5IG/dUZs/m5xYjs94FC8SNznT3DjM1wPJvUQzyIZdCmrWUQ78Dh6hWsirkJGY0OwyX7k1ZmhJhGS8Mot1306dHAFu/yijsBMKJcKyOSHGIS+nuMV9YotkIS0TG4KKtzE0PuECkTZCLLtdCJukkpvJQckcONQkC0O6co+2TR8fQ3xtHjKhGM3s+mblE8I3kgMVvSVSRFfFrV0/v7tRK6L7eqVq5uXJaJqoDTm7HHFG2+RaNOZnX7K5Pbk7ELpCRQ6IVHG8qw5aAE/6zU1WVABzWcs1brDn58E/Kh/CPbHqVxsGcXDYRVWHS9dMRpMJ+o3OV+jvGlP0G6KSDF5hTBVMO+cxbzx4BwNtPH23V0bQ0a7y9DvCutqKwokyI0BAEKF9+i/0wWcNy8jxRy6VipGfaaTF0lH9Sc8lsjVYhJGW9f0JpndqY8+oInsjpGL+iwOnIXt73ysMh3tbtmpxQ4OoW8AAXmILU/RCOtN7x4B3YP+xBxKHWtUH6u6VHw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199021)(44832011)(38100700002)(6486002)(33716001)(26005)(6666004)(41300700001)(316002)(6916009)(4326008)(5660300002)(1076003)(6506007)(6512007)(9686003)(66476007)(86362001)(66946007)(66556008)(186003)(2906002)(83380400001)(8676002)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFY1RTdQSXpwN29LSU5CTGllWUFoMStpNW9OeEtzWVNMKzdsc2gwMWl2KzZm?=
 =?utf-8?B?UjVDT3ZlZjhKaWN5TVhjcFVYek1uU1FrdVdzL0RoaHB3ZEJpeGM2OC9mbitm?=
 =?utf-8?B?MGtQZTVmUGd4UTJkK000VnZMQ1h1OUVMbjRic0NpSnlldmg3R3VqVXlsTEpD?=
 =?utf-8?B?VG52WERxeWtvQnBxSEhWTmJTREZqTEEzNlY1OFhFNEhyNFNQcmdUTWtmUGJt?=
 =?utf-8?B?VFpHNTIvcXZLNXRFS1JKYUcwdHZFUWE3bzVVZS9mRFFQeFZOZ1Bjb2tLTmFW?=
 =?utf-8?B?QTFqN0ZxajVKMTArd1pxRk5WZUNNck5RZDlsaXZORU5HUU5uaTJXdVRyeThF?=
 =?utf-8?B?MUVlZWpldWxiZWQ3VUhQUlVPeURDQWlwNlBUdnJ4Tmt5OFQyMnpiUGpsSklw?=
 =?utf-8?B?UU56clBlTmNwOEtHVk44TFg0aFZvUnczRGI4alhnNjg5NnR2eFhhVmN6R3dv?=
 =?utf-8?B?VWtqSUI0MXZVd3NOcTg0T3F2MnducmxGU0ZnQ01uV1hycXNSeDNqOUJ4N3NL?=
 =?utf-8?B?UE94N2UyY2NYKzg4RUlnYW83Ylp3cEVhNHJxOFFwWVZlU0k1OUdqMnVzSENr?=
 =?utf-8?B?emdTRUtFaEpHY0JVeUFOZWIxN1JVclpUUUxHVkJqcU5aeURxSERUaHNEQlFt?=
 =?utf-8?B?c1FSdlVtcEhyelB6YXQrY3RkTk96WFdqcnNOdkltSkkwMmRjNm0xaDVzTjYz?=
 =?utf-8?B?aU9kSGg1YWxWcU5EK0g1WituSEM0eU0rSGZIeHlMRVo2dThEOHpsK2x2RVN2?=
 =?utf-8?B?bXlHdVVDZytTaDdZMS9ZdkVla1AzdjZnWnUyVzY5dW1mVGpaQUZzUXFNMHRX?=
 =?utf-8?B?WDBQWmNkalRveWs2Q0JQaXNTa1pkZDhyQk1HSnJod0F5OVlhaytKL3RnckMx?=
 =?utf-8?B?YmJXRyt5NTRrVE1ZMW55MmdPdndyTW1ISFlpWFpJTHFIZTk2ckVNUGFyZUdy?=
 =?utf-8?B?QlFBNThHaXlqcVlBY3RjM1dJcGF1WDF3Tm1jNktCMUNsM3k0OXhYcXU0WkZw?=
 =?utf-8?B?Q202QnJzclJHNEZmWlo0QXdQSTgwMmtxREtCVWhYS05saVd5ejJ1Q0NiTjVq?=
 =?utf-8?B?TkJLdGZrVGFCNERWRW1xRzZDd2xHSVdsV3owTFFOSUtjOXlkWktyWk10Y29P?=
 =?utf-8?B?VzR2MHE0dGhOWFpINE0xY3huR0UyZWltNEh4WXdnckNLWjgrUmhSL25MUklm?=
 =?utf-8?B?eGhWdlZhaUlHYm9JcUFxNzhxQkJ3cFA4THE2d040QUI4SW05dU9FVDlxWkow?=
 =?utf-8?B?bktiZ0VjSnM3TThmK1FVaVZRVzJEb3Rub0t2QW56ZG5EQW1vQ2RHSTNwdWQw?=
 =?utf-8?B?T1hXa2NvT1JlTndGakdlRERRUTBhM3VRd2JHZ1RLUUpEQkgzZnhoSU16S0VM?=
 =?utf-8?B?Lzd1U09NeEljODBScmVCSEdEbjQyTXFWcDYrZ0t6QmZmZjVqZG1pOEtwQURy?=
 =?utf-8?B?Y1JGRVI1MlhsRGJrQzB2U25wSVFPUHM2cC9KU205NmlEODM2cGoreE9ONkhG?=
 =?utf-8?B?cXgvS21OOUt0VUlLcTNDTVIvRE5vU3RQZmNOZ2hzTHRWVVFqZVo3ZStBNkxx?=
 =?utf-8?B?Ry9BakpjdkcrNjNCQTYxOUxxSmdVKzFFUFNqVnI3YXlnU3NNTHhNWVZzbXNt?=
 =?utf-8?B?OGM4S1RBbTRwWUxxUE9rR2Y4WXFXMThuQ3lIbGFqMXNZb0QxRE11NFpJUllu?=
 =?utf-8?B?aG9ickdIeHBwVTVjWklLVnA5SFh6NExkd1laOXFKWW1tbzFjTjRwZDBNYWFG?=
 =?utf-8?B?OXI5QW5NODh6eVRYeTJsN05abFdKTjA5bWV1NTFxUXMveXEzSG43TnVKNm1G?=
 =?utf-8?B?ZVd4ek1PRnJLbHlIVVA1T3JBRFJDQjliQWl1WDFZbGUwdzJpUEloVitPaHlq?=
 =?utf-8?B?NEVHcHdSU2hyUTRxMjd5a1VkOVFkNUVGSkcyRUxMWldQay9LQWFaaXBLNDc3?=
 =?utf-8?B?bDJCU0E2cmVpRzl4ZGl0UHFrK2tzQWVEandhK1BtMnR0OEZMQTVtSnVMQmwr?=
 =?utf-8?B?WUo2RUgzL1RCWVBmTzU0KzlkZXFndkVDNnQ4VmFRQVRpN1lBeFN1Wkk0QmZX?=
 =?utf-8?B?dU1Bc1N3VmlML0UzS3FUR3ZPUGtjbDBIazc1Qm91QWVQODcwNmNNV3Q3bVVK?=
 =?utf-8?B?ckFLdFlzTkUzbUxTNTFaUElCVjk1QW5nbFFuMXdjQnFCS3o1a2NtenM1Smh4?=
 =?utf-8?B?SXc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40362a1b-68c5-4bcb-7d4e-08db638482f3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:14:58.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pIDdNRAdyMGdSswCymT3w1ka4zwftAaL4ytnsZL8QJb4/2s0oAqo1jYsBR2/6pEF+FM1o93mHWCeO6u7OHVk6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 03:14:06PM +0800, Tan Tee Min wrote:
> Do you mean a separate patch to fix the recalculation issue for
> gate_close_time[tc] and budget[tc] in advance_sched()?

Yes. You might be asking: "separate from what"?

I notice one other unrelated change in your patch is to delay the
advance_sched() -> switch_schedules() call via this new sched_change_pending
variable, and that is probably a good change. But it needs its own patch
with its own context, problem description and solution description.

> > I see an issue here: you need to set q->sched_changed = true whenever
> > should_change_schedules() returned true and not just for the last entry,
> > correct? Because there could be a schedule change which needs to happens
> > during entry 2 out of 4 of the current one (truncation case - negative
> > correction). In that case, I believe that should_change_schedules()
> > keeps shouting at you "change! change! change!" but you only call
> > switch_schedules() when you've reached entry 4 with the "next" pointer,
> > which is not what the standard suggests should be done.
> > 
> > IIUC, the standard says that when an admin and an oper sched meet, the
> > decision of what to do near the AdminBaseTime - whether to elongate the
> > next-to-last cycle of the oper sched or to let the last cycle run but to
> > cut it short - depends on the OperCycleTimeExtension. In a nutshell,
> > that variable says what is the maximum positive correction applicable to
> > the last sched entry and to the cycle time. If a positive correction
> > larger than that would be necessary (relative to the next-to-last cycle),
> > the decision is to just let the last cycle run for how long it can.
> 
> Based on my understanding, here are the two cases when the Oper and Admin
> cycle boundaries donâ€™t line up perfectly:-
> 1/ The final Oper cycle before first Admin cycle is smaller than
>    OperCycleTimeExtension:
>    - Then extend the final oper cycle rather than restart a very short final
>      oper cycle.

Yes, this should result in a positive correction - a new cycle is not
begun, but the last entry of the next-to-last cycle just lasts longer.

> 2/ The final Oper cycle before first Admin cycle is greater than
>    OperCycleTimeExtension:
>    - Then it won't extend the final Oper cycle and restart the final Oper
>      cycle instead, then it will be truncated at Admin base time.

Yes, this should result in a negative correction - a new cycle is begun,
but whose effective length will be shorter because it will be truncated
as you say.

> I think you are saying the scenario 2/ above, right?
> Let me rework the solution and come back with the proper fixes.

Yes, I'm saying that in situation 2, you're not allowing the schedule to
be truncated where it should be, I believe.

