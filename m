Return-Path: <netdev+bounces-564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DBF76F831F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC639280FE6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9AE079F3;
	Fri,  5 May 2023 12:39:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417B749C
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 12:39:40 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0F311B4D;
	Fri,  5 May 2023 05:39:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uqtmelylh9gYO4lFHk4J5/ljkNX+1NhstJSfNLfja4qsboHZH1G/l51R9reB+tcfMIwydsDOb681kjKTkgjvWXDKJHt4+7OH1hyqBiD1f0c0qL0iuJFnl0LB6MBPk6Wi+BwW8wB3wuAdogPG9MvGLWEIDOn+S359r7UqKfZbpN8OjRX4szMoYx8D3wGZgLoKz8evgjNg35pgLt7kHC53BsoZeXb2JDt/aT/Ccv/PitYzwwbnchIrIFRid0C/n0IKSZrLqyQmm4iU6b2aOWndWtm5jXqa5SzqktmV7UWtygWNXuGbWSn+1hsBzrIo6TyvEtWbISI/NfAiHAAz+x8oHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IZQlzr3wA2bRfIfuoS+Z2z9pieaEu5jipx/8YyE7jY=;
 b=PI7hq6b6npRyDTJQulw3HwGHldt+ezJQ6eu9kDiEP1iVghtm/hMshnPMhb8D3DK0i1JYuZjxF4BAajuB9cxtmP73LmfGLwMpWrJgw1ufVx4GNZMuf+Ihs+x4flCY8YhjXUwMUjfWxroEVbNgO3vUtm9dzW7/rlTpOGzGHPCFQjisfMtoWjcznllz6rV2mtev/hxvbSKgtttzJ1GxiMh8Y/ZoLCdtFTyW8jYbDHzJiLv3I8RWsBoOJjzjZSSkTOYYfy00hNRuajjcObLHeqYlhRNxDKUab20MK44VpdtzFxuWg82Avx65s/DuzMGtYNVuWLGqLfhAHdNM7RS1ZVOvSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IZQlzr3wA2bRfIfuoS+Z2z9pieaEu5jipx/8YyE7jY=;
 b=GZIV8jHyoiR2F1IcYqOyWLSljT+5gpcJQ1lR/KE3zwi99VaKhtnKeXeZZ9Q/qqmhnYbyXEKDgcRNHtk3oih/EYEiyy0/AD3b8aYikhzInnc93SjU0Y52p+yFtNZpNntTBDVbFS8m2kW9ubW57lclhQISZW3wU2cHUREEdBJfrZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4626.namprd13.prod.outlook.com (2603:10b6:208:334::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 12:39:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 12:39:35 +0000
Date: Fri, 5 May 2023 14:39:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: Christian Schoenebeck <linux_oss@crudebyte.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	v9fs@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2] 9p: Remove INET dependency
Message-ID: <ZFT4/SYt9QUsyHBP@corigine.com>
References: <20230503141123.23290-1-jandryuk@gmail.com>
 <4317357.pJ3umoczA4@silver>
 <CAKf6xpscky_LLxStzZ6uAyeWPXC3gALsA_zVFpF8X7uktw=MxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKf6xpscky_LLxStzZ6uAyeWPXC3gALsA_zVFpF8X7uktw=MxQ@mail.gmail.com>
X-ClientProxiedBy: AM0PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:208:1::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: 0270a2dd-1ae6-4b0e-49b2-08db4d65c82d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	01c3HdbWuRenYyqvAsgVtJwqDq4VV/WttImF6W1xVoDt1RmDcsrA6LEj/pGwnP3QcRhmheJchvlrAoOP96/Yuhk4gILnnqvKEKQloWyi+pbngB0b+uVgJkjcMivBO4h4UGdLjd/zdaROK4nxf4ES9VSfWHBa7y8KjgCwMqwY2QtawWBOBU2kQk6p87oYvYqATRqOBs9Z4LfNRvcgefH/kri+aq9aDfHtO2pXV09hWlffpB1sPMhOJuxRc6Baq5FRQdDOi2x7tU1CShTGmneNBWDac4k1gklrIxIRsN8khMBJhQm+IR+awzgjg5pZuVyzbsoKzcZQeMgM9AMDiv8CxkcBvOyK4QlM/PefdOyf0Tv8gS7fqjFmrBjcsdMClFssm0mtdbkxA4GfRvEIhRQK9HfoQCzM2YGgXUG8+EBzmppJzSj2PqaPDR9j5MXkOl28XJSt8ba/UGoU6g04MzHA+lUnlq0YMtP+SY5wNucZ2COzWk4O34Ux5WaYqyzfiZIZddTyq7wGJ8a4d5/i4284V+pCZ6wgQaVQGcCHYneGmRgMBBmHKqQWCah77cpRPA6wxftFR01y2sNTlS8kf21s8m//H/JTu9+B4f0YLBkDJcQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(39830400003)(396003)(376002)(451199021)(36756003)(86362001)(6666004)(54906003)(316002)(6916009)(4326008)(66946007)(66556008)(66476007)(6486002)(478600001)(41300700001)(5660300002)(8676002)(8936002)(2906002)(7416002)(4744005)(44832011)(38100700002)(186003)(2616005)(6506007)(53546011)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGNvZUxvcmpvVlBYSVM2WEtGSVVuaXJsUllsbmloMDU5V1Y0V0xzdGs3aVFC?=
 =?utf-8?B?V2c2QWRabTZLaXExaFhrR3hYNmhIbEVtT3hXSWxvLzFoeTRsd1dnRnl6cGZI?=
 =?utf-8?B?ZUI0VUZkR0RVNEhsamRjT1V0eW4xQTRKeHIwSjRmdXhoSWZQa3MwTHRGQkd0?=
 =?utf-8?B?ZlQ4QWpocURCUDlvLzMxVC9hYlRGWUNmbGtnM2h4Wk56S090cmJOQXNEVzFw?=
 =?utf-8?B?bTY4RTFLT2JCUkphMkRTdjZMZFd6UUtCL0lpeXR4YlZnUzZiL2dFQlJqekNK?=
 =?utf-8?B?bHlBWlpJR2t5TnpaYnpsL3NDMFNNNDBuSVpmMVpzMmp3elZpdVFSbkU3Y2t6?=
 =?utf-8?B?K2JtSzJnczMxRzVRdDhoczFKV3ovSUVITGxGOG9wZGMwbTk0YXZOc0JrTUkv?=
 =?utf-8?B?UEoyTStLQVV3UmM1Tzk5aHpwdDZVMFJMRkJPZmlEcUVyT2t6dHNWdml1bWQv?=
 =?utf-8?B?ajRQTytxNlRxWUo4bEpTVXBJeXVsWDdEeHRHdjVSVWZjZmtjZHRzZlY4NVdS?=
 =?utf-8?B?N3NlTHowTG1BbGNabTBzV0Z6YjlOdGJVcS9yMEs5MHhxYnRjL29UUGQzUnFI?=
 =?utf-8?B?SGdydzdnN0FGUnRleDJ3aWJ3QjdwUEpMWHBrRnFmRXdOalg0Y3NKa0hLb3lH?=
 =?utf-8?B?OG5uY3UwZXdYZXo2VEN4akRRaTJseURyZW53bGtiMlN2aDZ0WlB1MVRIYVFU?=
 =?utf-8?B?ZEFHZnFLYU1zN1RIUi82MTc1UlMyY21GcmxWKzhrZ1VsZURUMXRLT2wrd2NF?=
 =?utf-8?B?RVdrTG4vemZFcXFGQ3JDaFlkeEZSbU5uSkNPZlpXVllNUEM4RlAyeTJtYzZi?=
 =?utf-8?B?V3J0RWNOZStvdm9pTDJKTDNzbGRsZzM2TDNEb3l3b0hmaHZiMmdZaHk4OW9i?=
 =?utf-8?B?ZG1XQmpBVmtnNXV6ZDBZWUIvc1NKZDMzOGtaNm4vY1B6UVBFUndTQmhIbGdL?=
 =?utf-8?B?ODBxSWRSNW1FY0RaV1pzbXlKcHRqY2hyMDNOd1ZtTkVRWS95OVVuUXNCb0Jo?=
 =?utf-8?B?VmQ0SE1pdFNRZ0xoemhzZ0Q0ZGVaemx3eUs5SGIwME1TS3gzelNnTHpGVGRU?=
 =?utf-8?B?YkZ1NjV2WjR1TnJyeHBmUC80b29vMUE4c3FoMlJTcHcxbmRBWktydVlpWFNo?=
 =?utf-8?B?SGk3WVY5MWU5YVNMWUdPem1EM2JnNVdHdkFVMzJHOEVrY0pTcXhHUkNoSmhw?=
 =?utf-8?B?ZkdIUm9rb0hVcDl5U0ZvLzZ2eHptVE1UVjhJbDNlN3IzMXVmczBZeVF1VXBZ?=
 =?utf-8?B?emJPVnBUYm85WlcxeTk3N3VnMWQ4ZitkOEhaaWV2VU1mVUx3L3RjR1oyT3Zz?=
 =?utf-8?B?WWoydjVibHQvbENZNVJQcCtjSFNyQ2JEaU12ektvK0dINy9henVwbkIwWi9n?=
 =?utf-8?B?LzJjRVJPQnhNWk92L3lEanNCYk43a2dzREs4ZEpsNzExNEN3bmZnSGNPMloz?=
 =?utf-8?B?dzB3NnJCVkdxMVh5RE9XNG5jQzRpcFdIY3ZObDVhOWx1eVB5UUhEVWg1NnNQ?=
 =?utf-8?B?TTByYjFqRU81ckRwNzQ4SXVtb2hRUmJWa005VUgwRlFFTHJHTzI2V0JtNWNU?=
 =?utf-8?B?aXJ1c0JGQlFzY2lLcHVEemZSYzZ0QzdLcnBmRzIvc0dIaTg5Y2I2RlI5V3Uz?=
 =?utf-8?B?REJDQlBNb1pMS3ZNRDdYekJSYkdrVlo3ZnFMQTZMSXZ1UUwwcWRVQzBHZDNG?=
 =?utf-8?B?MFN4aklGQzRjVDlYV3F4di9kZGFZRDhTa2pQUHpSQ3hMTE5Pc3dqYnBFcjFm?=
 =?utf-8?B?RnRsaFp1VEdla3UrR0JKd2JTWTVXVnhuRlo4WGg0QVF1cm5zVUxDSkRzZWhR?=
 =?utf-8?B?bWxyTGhmdUVHbmxFWFNMT0xoaEJsdm5iNUpXUjRMeENVZnd0Z2JLVFdpQmJH?=
 =?utf-8?B?UWlvRU84ZWswTVdGS2VSWEpwZUhValRTNmo2R0dXeS9qc0laOCtxR0QxSkVq?=
 =?utf-8?B?SFVKVEpDWmJnSmJPSkZNZnA1WVhUUHo2Q0RRZUgwdXpUTk4xZXJZbW5jcjNy?=
 =?utf-8?B?L1dwNUF4TWozN3k4THVjajgvMXlPTWVyaU8zKzFTSUptV1NTWTBuTlhWSUx6?=
 =?utf-8?B?UXdGM01Uclc4a3k3MjNObHorZTZ1L0d6MmZhaFVGVmxwRXhhY3h1emNJcXd6?=
 =?utf-8?B?TTBtZnlLa3RRUkpQZVgrRjZNd2ttaDZ4VFQxZTJVZ2hFY0NEVk16WXhXSTZ2?=
 =?utf-8?B?MGdDZ3B2STRoTEVtUE9aRG1pbTZ5cjdlbVhaYUhHY2dZYVd2ZGN3T3MySzRI?=
 =?utf-8?B?S3JibnFTQ2RsaWNmU20zMHVDOHdBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0270a2dd-1ae6-4b0e-49b2-08db4d65c82d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 12:39:35.1506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPVqKkQv3nkG3byKPgtDTMuo0D0DXr371q3WXBts7LrmTH7MVtgIoB/7EoX4f5vMtuu2g29ct/i77uaGt8KKjVqkqzUgYK2zfXK+GI7zyxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4626
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 07:55:17AM -0400, Jason Andryuk wrote:
> On Thu, May 4, 2023 at 6:58 AM Christian Schoenebeck
> <linux_oss@crudebyte.com> wrote:
> >
> > On Wednesday, May 3, 2023 4:11:20 PM CEST Jason Andryuk wrote:
> > > 9pfs can run over assorted transports, so it doesn't have an INET
> > > dependency.  Drop it and remove the includes of linux/inet.h.
> > >
> > > NET_9P_FD/trans_fd.o builds without INET or UNIX and is unusable over
> >
> > s/unusable/usable/ ?
> 
> Whoops!  Yes, you are correct.  Thanks for catching that.

That notwithstanding, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


