Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D7B4399A0
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhJYPJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:09:08 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:28609
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229822AbhJYPJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:09:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuZEE69GiMfuZtDEFABALx9VcXwK9POfjVNLOjT9Xb9akaWJbqUrdxZNIf8MVoUTSsAZqc+b0b36j6C1LQNNRlWzoPzxP+mfE4OXpqCa0T5Q9qn3mMtPJh6anUFEzCpoNVbH+o3E4g2+V4um5JNHMvjnIFswpjxlx21n269J1J7EJjtOZwtSyq0PN56iFb1ULTNVrtGoAmNuOnTUT93MVPabvEP54OOXI1+XZq342u5w0FGhXhBJRWUcW7JW1zBh+yzOu+y8fJpVxJospS2RE8DZ5EJE+eefne36JqMyRq9OjMoJ2ahTT3ce6KMK2v0NFinE9TchlUd0SOWK5gBz7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5OHgDEq+Dy7RdSAebNIPdw+2b0IghFaWMTg34KSvYU=;
 b=eg5UuEDhe3scUpA2rls4qdtI+mii4RQh3KqMZZ/1sKGT6RycdXn+DTuS5qoQhOXv0slKRZfUiSi1CrjKZi8E7cDB4v52rFa69lG+O2MAr6PHnV6cplebb4rs5EWA0cuJYCLcucX1YVz99ZBkNdoB2ohX5GsRQSpRJm3ZrTBYdCj0h8mFss8t4isjHMY2HD+VfHixqhRSaFBjC1kevtxlmyYU5KZb/FZ5f7mFFIJQo12+rdyi2TCqAb3NQK9uCxCOz5rL5ut08ZYcNycgFNNzZZCNjASigY5CvhfLLRKFxIcHVrbqTyHarJsKhnfBM1ytE7mV0OQSrd+fp4A+Gu9z6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5OHgDEq+Dy7RdSAebNIPdw+2b0IghFaWMTg34KSvYU=;
 b=eGRMWZDSgUD/NUQ63mc8YIzCI8BnwS3nvRceOd/xEvknykv6wwd8/k9L78kGxmRTUJC6uEJ2ubphmEzHda6T++Q/88KEVND3zMoD/l1XdB20lZzkQIiiGUt27qXeeEhm4HqieWOVZ7ToCKb9qdNvyIWPWlN48QNSnRusrq+gNsI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5577.eurprd03.prod.outlook.com (2603:10a6:10:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Mon, 25 Oct
 2021 15:06:41 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 15:06:41 +0000
Subject: Re: [net-next PATCH] net: convert users of bitmap_foo() to
 linkmode_foo()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org
References: <20211022224104.3541725-1-sean.anderson@seco.com>
 <YXWrBZJGof6uIQnq@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <741c9985-f9a5-6c25-70e4-4d174312585d@seco.com>
Date:   Mon, 25 Oct 2021 11:06:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YXWrBZJGof6uIQnq@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::25) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0110.namprd13.prod.outlook.com (2603:10b6:208:2b9::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 15:06:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9ac9e54-914c-4569-1d2c-08d997c90ced
X-MS-TrafficTypeDiagnostic: DB8PR03MB5577:
X-Microsoft-Antispam-PRVS: <DB8PR03MB5577AC7070A1AC410F78C1DA96839@DB8PR03MB5577.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqBLbUTfWCLOdNw7jWQ0yC6zd4bW1PdK5N30Qw9LyTkcu+oyRSKo7AXsdM5+fIypLvvvDDj6m/iHGJXKnPcVZ4jXyeAlwbvTXyLbPbxL9d/yc44Dmjri8qFBAxAG7xKW7BeOCLw8UKIPC2N73RyrKR7V9WRKY+Vb5m5FTxZ2w3mWNuiihlZZ0zDPwxakdiLfJfyhwwJxR8G4fcOozaq1Un68ZC77P41EwLtAknj0NoOQzqNfAr7viiTbZcKpQj1mFXgbBRtPqXADoESato1lXo5IDuuwiE2kmGtGrJ8BIylDQLngC6+lJ2xVxjLe2Qe0+LDxlIRRGbthBbuIiMfqEGrDm8nsR8fvicB65jH/87/iagPyap/0VZ3/lRGgT/wfplQyx906UVLu5cyGknJIidouqwAv/X0cLB18lv4NG4aLQ/kO1M8dUQlJhucJz2f/epA1Ms/m8DmIaBFAG8lVsZ7cSInfPpbiaYn02O17gZ3OKj6U17jZCP91pbuUNZuSrwR6dNOK3VtIWYq8Xyv19PCxag7Q05kWcmCIDyy9ni1zt8MM6tNzllV43ACXoDEBR1VFV9uedeDsHM2nDvximUGKt17ORvoqE/2aC+3ox2g6/uDj78+NvaTF/3qWERYlEybTRKgEyLiDAw0fblUP7Ssk1Ev3q7XrgwdMTvQwG68JyxuWyCil9jXF5o2mVlvSR6rZeR2OUR+feF55W9Ic9+AYk7jGRYcu96E4dpRijO284TUrw29RNRkxZS2BdJGnfgeyqZawurRD3bR4AxVoOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(26005)(4326008)(53546011)(52116002)(8676002)(44832011)(6486002)(956004)(38100700002)(2616005)(31686004)(38350700002)(2906002)(31696002)(316002)(186003)(16576012)(86362001)(36756003)(66476007)(66556008)(66946007)(508600001)(6916009)(5660300002)(8936002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2ZKQkpMTlhKdDhUT1BMRU9KMXp3TGFtYlU5UHg5UHQyM2xTR0lYREU3MEJx?=
 =?utf-8?B?MmdJamlCWlpSVUI3NXJqZUpJMU5rdFQvN1ZsVGFMaCtiTG1iUGlHOGlOeUxv?=
 =?utf-8?B?ZldhTzJxWkcrck4yVG9yQ2RCQkRtTmRyKzEvMG80dDNzQVlaZUE4bnppOVpp?=
 =?utf-8?B?V1UvZDNQTXVSUGtOaDRZSktsWURWUHdHLy94VERxU2xWYmpjRWZZbHlhY0sr?=
 =?utf-8?B?WjBWdkhScEsyK0MzcWFrRDR5dGptMjZtN2x1WVhXalJmWXVNOXA5cnVPRjdG?=
 =?utf-8?B?QUhUMFBuWWRkOHBRVzIzWEJJbkliTHlxbSsram1yd3dRclhtTmxieXhVcnhI?=
 =?utf-8?B?YXFyZDRaRFd3c0VjbmNBZlQyWkV3SEtWSWx6SzBheVRBcEVrNDFON0pOR3Nv?=
 =?utf-8?B?Vmp4T0MxVEZWSDJJY2c5OFNQb0RMeHBaai9MT0pBVFkyZDdDK1ZrWHYyU2xD?=
 =?utf-8?B?alY0cVJVQ2RLTFFBSktmREU1WTg3OGN0ckFDWm1qWTA3aDZSblRqUHNmL05i?=
 =?utf-8?B?T2lzLytqczRKS25HYmM3ZHFpdGFsNHV3bm16UHZicUJWbGVON09mWDEzeFhD?=
 =?utf-8?B?Y1hMTk13dEJ1MWphWVk2eGtVOUNMOE5PWGR4UmF0ZkdYWC94RXF4dGFJbDM5?=
 =?utf-8?B?QTIvZHJpSUNXNFNXUGh6TmR2S1lVYjZJTnMyODkvRVg1SU03Q1VSaGVkUnA0?=
 =?utf-8?B?UUkrYUJvT3lmejlTSExUSHpzUm04dW50cU5TMVBvTk9vdkw0MDlmb2J5WmFL?=
 =?utf-8?B?SXVGc1dXTWwva0hEUWM1T0c4VjZIWVpSSTZlU0NEUDZnUWxoeE9ZQnNRMEJj?=
 =?utf-8?B?bS9MeWpnOUpJWU14QjdlZGxIVjJtSm9zUGxrb2RQb1BTM1ZyZzJ3dVJiaWFD?=
 =?utf-8?B?cVFCRFNVV2lZY2ZobmRkWHZlRGQzbmdnQnpuSXFjcWdJSk5YRkJ1UUY0aWZp?=
 =?utf-8?B?RlQzVksySUkyVkJCRUR0RW16amxkZGdEKytoRHRqc3d0bkJYYlhiT3JJemp0?=
 =?utf-8?B?b1FNQzJuK01VenIvWUZMamNlQVlSclFtbGdrYjZXc29Hby9SeHNWWklVeWU2?=
 =?utf-8?B?cW8ySTNMQno2S1VKY3FEWU1mOEkzeG85UWZyU3VJNHlKcWhJWWhYY3EwR1g2?=
 =?utf-8?B?SGY4dWRzT1Q0L21kSHpSNk55TjlmcUludlQ2L1dUVmtxcWhkUTVBSU9Xandi?=
 =?utf-8?B?ZG5aN1I2M09GUDQ3dHFCZ3U1ZmdWeFo4b1cxRUVBWjhiVStRekpYcjZTai9I?=
 =?utf-8?B?d28xMll5RFB3ZWNBR0dWSklTTWNTSDhqdkVNeFk2RXFDdFZhd0hqRDcyQUJs?=
 =?utf-8?B?dXVwMFpHV0crSkpYOXBLeDFkamVxOEpseVo0NWVxS3BYMWpRcCtyekJzUzU2?=
 =?utf-8?B?L0hpTmFEUFRSemFyZzRMTVMzU1czMUduMmZ4dlRyMmpoS3FDQkZFMHY1RUlT?=
 =?utf-8?B?bXY1SGRhNmI2VEtWYk5ERjUrTEtZa2FjR2cwYmdMdWdyc0srZUIwZWxIK3k2?=
 =?utf-8?B?Qk0rcjh0cWFva0RSQ3RteXp1TzFBbW9aWFk2Si91Z01lYnVlU3hJZEFlNkNo?=
 =?utf-8?B?UCtpMTI3NFVUdjNtb0VCdkRNTlFCemk0NG5sL1BNNldTMGNMZk9Oc0lnckhh?=
 =?utf-8?B?bE03VUJ4Q016TmNWYTliRzJHdHpmWWJWUThmL2NSclluTnMrRkh0RTBXbTNU?=
 =?utf-8?B?MFNJWnR4SlR1Y29SZ1lQTDUrU092bWZXN2trbDNFQmhUQ2pWYWNEKzNCNG5Y?=
 =?utf-8?B?Nm1adHBOMnVpcW1ad1BqajhUZExqcEFSbnVFN1QrYVF0R3NXaW8vMldTSEZ6?=
 =?utf-8?B?cmxqNU81MEt3VDk1Zm4zVXdFRGQ3RkJZaXF4TVVYQ0ZFdThjdlFkb2lUUXpF?=
 =?utf-8?B?eE5lMUsreEkvRjZ1d0IyUTlqMG1sVms5Q0tqZEt1ZjZKdFRHM29GbjYyTHhx?=
 =?utf-8?B?MG0wNndHTG9UNFk0OCtoSHhvREJsOURPcVRRRnFuZGQ2YWs5L0VZL2l2Yjh5?=
 =?utf-8?B?UGk4Y0JnOEZuTnlNWS9HNG51TFRwekwrN08zVHQrQk00Qmg4Q09kcElsUTdV?=
 =?utf-8?B?UjVlSmpOK3RGRW1BdzRSQkNTTDFCNWNyUnhGYkd6VCthM1R5d1A5ejErdDlT?=
 =?utf-8?B?emI2ajl0YThiZEZKMWZCZ2hPeXdFZmcwUFJXR3RJaEJHbngrV0Y5NjBTK1Vr?=
 =?utf-8?Q?WMuTvyJj4g2005G65aXtVEM=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ac9e54-914c-4569-1d2c-08d997c90ced
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 15:06:41.2761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+GX8s225LcUfVul3ufm8DdwRbrXiENJfDUHw4MJ8FiLkxabbc/hJfLvWT0BJetHSWfkdMZl1zjavxU7KIOnCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5577
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/24/21 2:50 PM, Andrew Lunn wrote:
 > On Fri, Oct 22, 2021 at 06:41:04PM -0400, Sean Anderson wrote:
 >> This converts instances of
 >> 	bitmap_foo(args..., __ETHTOOL_LINK_MODE_MASK_NBITS)
 >> to
 >> 	linkmode_foo(args...)
 >
 > It does touch a lot of files, but it does help keep the API uniform.
 >
 >> I manually fixed up some lines to prevent them from being excessively
 >> long. Otherwise, this change was generated with the following semantic
 >> patch:
 >
 > How many did you fix?

Around 3 hunks. For example, in mlx4 the original is

		if (bitmap_intersects(
			ptys2ethtool_link_mode(&ptys2ethtool_map[i],
					       report),
		    link_modes,
		    __ETHTOOL_LINK_MODE_MASK_NBITS))

which was originally converted as

		if (linkmode_intersects(ptys2ethtool_link_mode(&ptys2ethtool_map[i],
							       report),
					link_modes))

and which I rewrote as

		ulong *map_mode = ptys2ethtool_link_mode(&ptys2ethtool_map[i],
							 report);
		if (linkmode_intersects(map_mode, link_modes))

(although upon further review it seems like there should be an
additional blank line there)

Everything I changed should be caught by checkpatch.

--Sean

 >
 >> Because this touches so many files in the net tree, you may want to
 >> generate a new diff using the semantic patch above when you apply this.
 >
 > If it still applies cleanly, i would just apply it. Otherwise maybe
 > Jakub could recreate it?
 >
 > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
 >
 >      Andrew
 >
