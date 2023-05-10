Return-Path: <netdev+bounces-1567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F926FE4E3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6539F281526
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F317182C5;
	Wed, 10 May 2023 20:15:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EEA16413
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:15:11 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E50461AD;
	Wed, 10 May 2023 13:15:08 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ADwxZp014159;
	Wed, 10 May 2023 20:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=33viJ1idfAiuGxPeAUAI3DW8aJTlGUj7CSJ1AkHJdho=;
 b=QuaEkdH7BVBHy8RETglVU5/1aCtjjFlYLnybwfsfa8exRoF1fULIJvfMjIUNqbH2HAgF
 dwiTyJ/GvC+HRgq7awB3u6z5SfRL1m9/i8qF2R+FXjKInYBbH0DsapZVgA6yOuweEeZU
 3F6YoKIJidFth/GTJo/F5IXadkumvHFedX+g4bWTpQDa1uuAliUQBGODSCS3Lj6ApCzM
 /iLPK6WVHXxq88RD45DSMYZY6TPnYA0s/+Fk+lmkGbm0YRuL0OUfgmpxr1CGuuEfO2Gr
 NfTcZRkEW6wGa1T0ZT4hOhzEvAgKaHP6jzEqtIXR3jp3ojmgazS8kzM9JHwS332XX4hd QA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf7755jrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 20:15:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34AIKxAS014325;
	Wed, 10 May 2023 20:15:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qf82xfygg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 20:15:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXLi9QCP5h0f1m2IKlT7wqAGruJHUaFO/Sw9K6u3MZgdGXPyI9sA5ZQPH3iWNdSmL22J91L1orfeQQqMCKBKxrBqJXR5xCSnAEw26SnvUMZSkBVZjswfiso0CBYlwqW/cnehwikK4EOSsp5y+aiOaFTSGj8EvcCikymPVXbYt0gmwjTPUMtyOMA+yKElcZXnYQew78IhdoIZjy2omTpfrPkH2T3iRgnxEMcnBOnYhiE8BQ8JY+Xk/KZUqHuKYa1eYWFt6UjRcUmeDydIClgBE112zqj/EzWXUX1PtcwlheZOwdUFNOrFMqXGVUqKFniNSmJmpkvdnHkE+KBrY/3PYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33viJ1idfAiuGxPeAUAI3DW8aJTlGUj7CSJ1AkHJdho=;
 b=Ww2yuo8J7I7VtsW3Ud6HCoAGMwhpXQHXoaKC1dBQDjECqNqQcq4QJ1DV0jFwAcMKmRqbyp2gjoKbmuIJQClYVlOvF2u6UgtQfg2xBRGBDcTzDYOqByHTdkdvKvzOie7U4ZDA3q0PUptG3GDiMAQqvlN0bBrZ+IHAwUQ5ixcibGXjTG/llVnOohgs8Nh0R4zQhzh1liUl0fFV9y3wZxOrG1wwR0pOT7WvhXZOCrQBx5NR3NLsDt/NlqThrM3y1wb7o87zhzvhmX8elmp0qKF0F+008Fo8WcZGwwRRh8ougCOV8F6aKjBmm2OpBBaxUrimAEbFw19u4R51dyn3I/d2ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33viJ1idfAiuGxPeAUAI3DW8aJTlGUj7CSJ1AkHJdho=;
 b=G+INOD5bu89NnYg6zwl3sFoI+M4vfc5TK4W0MPVwsYjPq1X5ZtN0aT/PDvW3VVAOW8cU5/lP2H32zMwC1TYqZM6TpDtFghwZt9bCi/72ox5A94bLBI0i9HiZl+4vjz3R+hNCpL0xeUaXTAgpHESswlVMcoEekxvJN/gIM5JvZ88=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6570.namprd10.prod.outlook.com (2603:10b6:806:2a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 20:15:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6387.020; Wed, 10 May
 2023 20:15:00 +0000
Message-ID: <2059dc74-a00b-fd53-f5ce-3dd41bfbf4f1@oracle.com>
Date: Wed, 10 May 2023 13:14:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH 11/11] iscsi: force destroy sesions when a network
 namespace exits
Content-Language: en-US
From: michael.christie@oracle.com
To: Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
References: <20230506232930.195451-1-cleech@redhat.com>
 <20230506232930.195451-12-cleech@redhat.com>
 <6ea35c03-09b9-425d-ddcd-8cdbf99f4fe8@oracle.com>
In-Reply-To: <6ea35c03-09b9-425d-ddcd-8cdbf99f4fe8@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0268.namprd04.prod.outlook.com
 (2603:10b6:303:88::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff4f5fd-eb39-49d6-58bf-08db51933b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	eOdpIOWsWMSL91QwoA/yQwJs0CRwWRcDAdIynJURvJfcw4INmwuMbrES/NOldNstMUE73z4ZJUpa4gPIe5BPfpX8XvW3mQUVzDJ+0CCP1mZmGnDJ0bgkis+uPsW6RgYfG632XLBR+U8y3EpsYF0glalL2TqizuNA+Ru4PYlIO5WEmb50kpmLth98pxoGLMHTUcV4PUpvTkEEgKOzrO3I6oQ+c4o+KPD/J8GWSnGk39eG2PwBMaUqEkBI2H/0BsUWpPZphZ2XQ4n0FXJ/X+aW9MDY3eR30OuYcSZZDaF/yRFPNAxReBES71gDr2mzGhlPfY8SeEYo7VQAVwkFEg5QJZWN0lTVnvm7Hym5JrbHDHn7c5Ss3E9YYgvSlJaAhXwsmCD4FK8t/7ltUrJjkrgqjDHZsDxGQs3l041BO+eT/hbWxed+1pkARODqn/1PneGgqlXE6tBXa+cgV2o7/lXHS63i/VVd/ohbYWcnsuJ0YKTJmheTIl0/4z6VbBLIVPsfjLxSPH6vm186P5ernl5y2LjlVXPg0iRSNNRulgdd/E/8K/yDbeUUL0/Xw25Gwd0YqJOTgm7mjIKZe9PG7W/MOuM7ikNQU9MSqdJgqM28mWJmJ4OLmq0UR0xoUZB/MGr3
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199021)(86362001)(31696002)(36756003)(83380400001)(66476007)(66556008)(110136005)(316002)(478600001)(66946007)(6486002)(5660300002)(2906002)(41300700001)(8936002)(8676002)(2616005)(186003)(38100700002)(26005)(9686003)(6512007)(53546011)(6506007)(6666004)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?L2VvdlZaQU1iVzU3ZHVKbzMrc21oOHc1N3dBSVh0NEhoSFNqNTBkcGIveFFv?=
 =?utf-8?B?YVNieUNCaDlCTzFjTnVZN1NGWkpBQjNGVWMzR3IwM0NKNm51eHZJUHhMekJC?=
 =?utf-8?B?YW4rK0VPNWpwbDhlTHczTFRZMnI0a3F3a0NPVkxDZlAxRGowcllwbHhRaGJz?=
 =?utf-8?B?Y1FudjVIZ2Nac3l2SkRsa3BUVWVzVE9YZmRkS25OMDV2OXJSOEZYV3B1ZCtU?=
 =?utf-8?B?a1Fqb0ZNdFJtNkJhY0FNYk1UTHJ3dTRnYW14VlVpRkNuY3JzUzA2cUd2N2sz?=
 =?utf-8?B?RjlIbVdNWnhUL1l3dXYxYm9YMysycFUxdUVqWTdOTFYxZlVONExEcGRjSENT?=
 =?utf-8?B?a1RucG9DSWFlYUY2Vm8wWGZscnBuL2NVZnE3S0VwemN6Mzl3dWRyV2dQUitx?=
 =?utf-8?B?d3h0Nk9iUU53Y2p2aS9YVnJOV3FqRVRMK0ZTMStvZHVHYitPRnlxSm50clVJ?=
 =?utf-8?B?UjkxakZ5dW1jNnF1dUJkbTZQbExaNkFBRk0yUWVsbVMxdks5TURCcFUzK0xs?=
 =?utf-8?B?cTRMNjNxc2NzdjdMM1RiR0owUExwb2pYdXRsTnV5a1hlZ1VvTmc2c2pVT1Rs?=
 =?utf-8?B?Z1R5UzdVdE9BTE9ZUjVNREJLd25uMHdNZnY3cVJvenVGYktRd0tTTC9sdkJX?=
 =?utf-8?B?WUoxbDRJUG9mSWp6eWdkcTQ1ZkxOcndjT1J0MjVRU0RsaHVIUXZ2WUF0bDlH?=
 =?utf-8?B?RTFOUmlFNm5PRXRuMFdwWWVmMWhuL3MzaGZ0bFZmb2dNSVBZM0FRcVRDT1Ro?=
 =?utf-8?B?dVplR2hXV1B0OWozQ2U5ZWtuR2lKWlZ3b3NGdmRCVjlPY1VPYW9BVXJMMndq?=
 =?utf-8?B?VUlmUFBJSHVlYlhYZG5WR0MrUTZlNWE5SEVEekMwd2dib3BIVUo0NmszTGFv?=
 =?utf-8?B?VXJlZnlDb1BRcW5EdVJ1bURzMUtJSTFLZlFJUVk5ZEZOZUg1OFlCQ3ZBRGor?=
 =?utf-8?B?d0tLV28wVVJXeUwvVE0yd1lhemUxeFVNeEFmMDA0bXZ5Q0QyN0REclFXSG1z?=
 =?utf-8?B?cithY2tESytwc2RiS00rd0picEZVR0FlZ2MvWXZSWGxreitBUzFWL0FmNy9T?=
 =?utf-8?B?NDJUWnBwelllYmdjNjNjSGk5Y3lLUThTRXhCYmhqMXBvdUhvYlNnZE1lWEpK?=
 =?utf-8?B?WmdTSkVROVFmL3A5NG5yb01OMDJSRS9WM2c5eXhxQldLYkVUbEhtcUZjT3g2?=
 =?utf-8?B?djI3TWs3eTVhQUU5T3plRiswaVhQSmJTS1N0MTRQbi9LMVg1RExOWno2ZGF1?=
 =?utf-8?B?M0xKYkU3bzJtTHU2WmlDS0tmYWVzbG9EdmFkVU9FQjhkMUlDWU9sZlU5ZjY0?=
 =?utf-8?B?dGVLNFh4aktROGxxVE9zdmFBZFgyK3NHTTR3eW1tQXhhMUpyTGxxNHBHVTV2?=
 =?utf-8?B?Sm40YnhxOHRtYUF5empEOTRZNFB4MzI5eWxtRlQ5YmJ3QXExMEpTdVczazNx?=
 =?utf-8?B?K3FWVkJwM0V6REtIVTIxVUlsYTV3NGNwWmg0bGJ3Y0dRUzBHZ0Uxc1FsOGk3?=
 =?utf-8?B?RksyVkNNQWIzbzhxQUlqbjNCVGN6Q0NoZE1WdVFKMFhidmNDakpmaE43NTBu?=
 =?utf-8?B?OXV2Q0pvbkJwaCtrKzdLK0xtMVBqZCtVQWFVU2xkMWd0V2g1K3B4dmU3WWxr?=
 =?utf-8?B?bi83dzdzR0tLR0JTNTdNMWtSM0pNMGIvMHh5UGduaUhiSHlFV29DMG0zSjls?=
 =?utf-8?B?MG5HRjRlWVVZMWNKNExqMWhQVmZqVUFXMUR6VW9oVHRrMGVXM2VBVi8zOUhN?=
 =?utf-8?B?VXdVS3JNdDhVSExvNXYxRkNNVG1FN1BzendWRENCcVhuNGNKRWtxdGEycVYz?=
 =?utf-8?B?QVYrY01JNW9YZmZHbTkydHhzcFJRNERWSVFCaEdxUHVueUVONm5HYmpjL0Rv?=
 =?utf-8?B?UzZEU2pOVGcyU0ZvQjZaU3VLOGhYTEsvalpIcHgrLzFYVUtDMGtXa0RmZmxZ?=
 =?utf-8?B?anFNN0RqY2loeGphelFoU0tDdFNxTldWZUtlMzJUTU10dzhCSmZPTkp5L2N0?=
 =?utf-8?B?blVabmN2ZXBKS1NwcFF5VjVFNHR3d3dhWkVvbzhrbzdibTd0b1RTZVF6SW0v?=
 =?utf-8?B?R3JmU0xtNlBPOU5WQzNwTFZLWEhDYmpCay90WFZrczVhOERhTXR4Rk9IUHhl?=
 =?utf-8?B?Yi8rV0JJcERycUxOSEFYMVRXd0lFbUpiTGp6MzJjdEUzb1lJUlc5S25pdWJF?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	TriAbSkiqzu8dYsMuSuavW70LQ+IkYQbJs07Hqk/9Urk3o2TO62h9DQogr4494hLfdpRSQy3q/mjljvterXdaJJOIY+qfQzASDWfhDLAIixMclfTXYLXjh5ZQUP2j5/O18VOFQ9lpbMaA4sFAin8m2WZ9YA+8fNJ/anETRuoaaIBIb5ZfUWc/dzUCXDN4x9Mai77+2T6xnfNM5E3Fz6n9tiH6Gd3i2TzRrd+FepvSGS16ik0nwBkFfDes72y6XizfPBkisKr35tgK5cjr8O5E8DeCo7aZSrJc+Mu4u3Nt5Lo/l8CAZJNByCWXnSrkDHQ55/ryT9nkvwQbWcc4H0wGn6l7QnEDpS/Z+D8N0xPDZqe+iczBMyCl3YL9Iev6TMHIhciwKZ4EvISt965cUHPWVO3E6DmpUNUXSvtr3turlf/6V0SZQ+fk0t4dqPvG/TYsFIckpDbZ7gLbnBwR2UsYVpyGtAgI6pgeEVHElttWqVN8SU9RbXIPV2eFxHEyPOYG3gCx+YzB8nZqwt6y8vNEvy22GiP9XSgdDlxx+lrRIHWO/+a050/DotaNhI1tkwxPxRPTyqk6Dk+BsS3kw10rbYihe7FWT4Ox+mmtvTlE2FTS9vpjUflG7tgINKEDPx4X41/6wlQr9Kn6ghLW+VB33c0WM5oB8c+YV8NSJluUtVqN0HhvZE0zblCu8zYfUUCxkQIPOaEauq/TfJYcxbuwgjrEr7ZRlvputwhU+EH8IZLANkXrV4hXWApkvl9kmcUSrgdIf4Fj73+bqGxexOS6CoyGqIVc03pjH3H15dtPxO9OkuDWR9gfBVRRq6PAxSCB6zQMt6HhUtLm7qNts/yuKY6yphHVg1YAT8L/WwgWtM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff4f5fd-eb39-49d6-58bf-08db51933b5c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:15:00.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9U+YtLfUfEpEpO2qWMs1FRVUSStdcmEntkmlIoj6M2L5DaSnlyOMK6el4we4IoGevYOYHyQ27uC05akWu5BIDgHFFDtdXw8J27bNyfieXxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100164
X-Proofpoint-GUID: su1x4T0PrY5cBxJD1p3tyGnteUK7bhtL
X-Proofpoint-ORIG-GUID: su1x4T0PrY5cBxJD1p3tyGnteUK7bhtL
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/10/23 1:09 PM, michael.christie@oracle.com wrote:
> On 5/6/23 4:29 PM, Chris Leech wrote:
>> The namespace is gone, so there is no userspace to clean up.
>> Force close all the sessions.
>>
>> This should be enough for software transports, there's no implementation
>> of migrating physical iSCSI hosts between network namespaces currently.
>>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Chris Leech <cleech@redhat.com>
>> ---
>>  drivers/scsi/scsi_transport_iscsi.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index 15d28186996d..10e9414844d8 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -5235,9 +5235,25 @@ static int __net_init iscsi_net_init(struct net *net)
>>  
>>  static void __net_exit iscsi_net_exit(struct net *net)
>>  {
>> +	struct iscsi_cls_session *session, *tmp;
>>  	struct iscsi_net *isn;
>> +	unsigned long flags;
>> +	LIST_HEAD(sessions);
>>  
>>  	isn = net_generic(net, iscsi_net_id);
>> +
>> +	spin_lock_irqsave(&isn->sesslock, flags);
>> +	list_replace_init(&isn->sesslist, &sessions);
>> +	spin_unlock_irqrestore(&isn->sesslock, flags);
>> +
>> +	/* force session destruction, there is no userspace anymore */
>> +	list_for_each_entry_safe(session, tmp, &sessions, sess_list) {
>> +		device_for_each_child(&session->dev, NULL,
>> +				      iscsi_iter_force_destroy_conn_fn);
>> +		flush_work(&session->destroy_work);
> 
> I think if this flush_work actually flushed, then we would be doing a use
> after free because the running work would free the session from under us.
> 
> We should never have a running destroy_work and be ale to see it on the sesslist
> right? Maybe a WARN_ON or something else so it doesn't look like a possible
> bug.

Maybe not a WARN_ON. What happens if there is running destroy_works for this
namespace and we return from this function?

> 
> 
>> +		__iscsi_destroy_session(&session->destroy_work);
>> +	}
>> +
>>  	netlink_kernel_release(isn->nls);
>>  	isn->nls = NULL;
>>  }
> 


