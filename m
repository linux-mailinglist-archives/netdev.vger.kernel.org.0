Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DD041CE3D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346473AbhI2Vfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:35:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26938 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346041AbhI2Vfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:35:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TKtQNZ031153;
        Wed, 29 Sep 2021 21:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OICZIUnOqdYOOPEjDsHuAisIoJ7HpzNl+VogUF1ipBg=;
 b=vM1LjEstljkkeEYoT20TvfTlGGzR2xHUBiBnqUuP1dTCpwhNFyQS9Mrx29pk/iucBHHi
 DDoC+lUnJ/YKA+LpTxv3eSjwBprG6h2aNCnvxc4ZyeTs+qXgZcTAV/Ao2Db5LCNVQmKb
 0ngHtlCRDoe8ChFR5BJgeknz9+o32P8uCDP03V5CVXXOD4JtoxHmhtDCTEfzeSiW4Bkd
 +EXZi9deBhoFvKUJrScN2lONN7DCNgjcFw7dOxr32rf//xznQnqx1ItnKDwqFbppSP8/
 N+nLrl53V4SpFUCbYJIWgP9ARoGtw5DP46E1Ao0/whoUS9R1F3Ns1xbra3VqOamRblxo 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcw27wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 21:31:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TLUDZ2066137;
        Wed, 29 Sep 2021 21:31:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3bc3cew3s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 21:31:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkyWY8kutpcL/T3/8QwUglR15sxFm8jfpBgV7mApNJM0QLdFAoH8xTR1k2jktlOonaN4TmVV0g/T8+P0ICCbil3hWV4DvGhhXTrGjFud6gHIrf585Y8uLRjqTOcQX2WWxuA4ifup5qvaGyYXS6/QpoDgzp0DzqvLSGQZ+O5eMwiTKTcYn0kx6LGVbWJR6ykZgSdlHh7y7UTxpeHjlCY4qgRUDs5s/vFzXwSqWqRn+9Ym6/z3P/7KnftYdcOeCiKEnUk+rs/WlkpCwZSxvtAKI26CcCH3ObEbNadGtCWjYU0nJxVD7H4jnwX+SWHiTLuZ8T/KDykt++O2dDn12NwDmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OICZIUnOqdYOOPEjDsHuAisIoJ7HpzNl+VogUF1ipBg=;
 b=ehub0si18uGUrmp5X6IM+RslQ+GfOtXwftJOb3EbbGQWmCbXAa5Kc/hnTJ84kfV+EPHfrQ7R1a3Z8EYxGW+gmMOKKK8DBJvOpmQpxJw8DEvvDY6N5uPMRaTyFzbem34O/4B9SvZTusFOnoL8tNJWkuizuR6D31IAmrB/JIHJI4eLN+wUeHqYKjbLi7CdquVJh5bqQgFxT9JcpL2FxmcSF/eqcMqA+GcTVSeEyOQ+cM8jgpOqcxqMndiL0rYtj/rWgHgAHYqdg2WCd28RH9lmLIYa0hehSpajY9AS2AI3nv9yPCj+xwTgQG4h4zBxGJYCvp+/uAIkdT7aiDGcu2gkJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OICZIUnOqdYOOPEjDsHuAisIoJ7HpzNl+VogUF1ipBg=;
 b=g7O76Dp6Lw58CB0Txa8iJUIxWSyeGTfZlZ1GQYhDZinSRm6EkLdPsiGGD6IbCNbKvpuMD7HpF9tFQgj8I6v6I+d+W2xfFteHje7R0X8T2WzcYKibQpXLcWgQTyJS02buFcwgFYvtl1ABPzp/mkpQjAyB68CPqj8vkuhGlnsvdaU=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by CO1PR10MB4515.namprd10.prod.outlook.com (2603:10b6:303:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 29 Sep
 2021 21:31:39 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::d44f:58e1:1202:9205]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::d44f:58e1:1202:9205%3]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 21:31:39 +0000
Message-ID: <73b75092-a0b9-04b2-64f2-1f28c245b64a@oracle.com>
Date:   Thu, 30 Sep 2021 00:31:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Content-Language: en-US
To:     Yanfei Xu <yanfei.xu@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <20210926045313.2267655-1-yanfei.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0117.eurprd06.prod.outlook.com
 (2603:10a6:20b:465::32) To CO1PR10MB4627.namprd10.prod.outlook.com
 (2603:10b6:303:9d::24)
MIME-Version: 1.0
Received: from [10.68.32.40] (109.173.81.86) by AS9PR06CA0117.eurprd06.prod.outlook.com (2603:10a6:20b:465::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 21:31:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a91daba5-681a-4a58-8070-08d983908580
X-MS-TrafficTypeDiagnostic: CO1PR10MB4515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB451539D72C5B0D5E22960FB8D3A99@CO1PR10MB4515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 38pgBlyG5yVucEvGoOYjJZ5T0ehSakc4TwQpTd3LbgrYNQIgfCZ9aYxDVEu0i59AAcRZX0wjDwQ1Xdnajl1L/0nK4yk/YkurjhvACNWLgn7P22DxH44WJrSbhWx6m8SaS74CnY57ochx1WjtVHMdorN+cGt+wxJXR0yjb8V7+4QLArf9+eOBjA8cTeAEaYgs/jkP2tkycDYVebh0d5wQQDy58f/KjbnFt1lskGE+i35CVhKeuGAOsUiHRjATg0TqXcCZjcxrOEde3cTpL943yZ1JXzxWRkh5yKb9s9Yk2vc+kWGCe8iU/wrq1f8VNj3DkPqwNMqMTP7ZMZ7pJReYC+buAhrNypu30a6iV+MGWtQ1g+cM9rQjwDBjrKNDOWYTUotHkwmHxudlub/C5vOX9QHyacitOIHQ4OvsDJ4BPnXRVV56Rw9KidmLuPVAC2tds9SLL/q1Q+LJFXUA1EKUEKuWDfmxMb+VT84BcSeTvXs8DEP8AXo+Z5wYY36SGxJPwln554GAryeUSEHTUJ1yeT+jbsO2DoYv3RXHGBi+CAU7EaPzgA6Vo5PVS8+ruRiY9z64b9j0AFHAQL7BmBFHeOWzC7Jo2It7jM+6md2oraBSZEzEeG17hqqzNGMbNlAw7L1mk3tIS5a6oKYfN4ISdXn00OuTQHPNoZq/SEaGfIocKQJ0ySM69uPp4iFuXUyDbCJfPLJKVuEmKGnnzMkNAHtMODbTjoYdjePE6BAyfHf3NFaaJXYi5F+SYy7+x8zk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8936002)(4744005)(31686004)(8676002)(6486002)(921005)(110136005)(6666004)(83380400001)(16576012)(508600001)(316002)(38100700002)(66946007)(7416002)(2906002)(86362001)(36756003)(26005)(66476007)(4326008)(66556008)(31696002)(186003)(2616005)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHNGTzBVTHo3TFJTQjJaMmhaUTMxbjQzN2ZPb3lHbHp0djVtQlBjZGpIcXhK?=
 =?utf-8?B?OU45bnR6a0xPOC85MGFydHIvUVIrUnhsRnRsRUp6M3V1WTJUUENCS213b3FB?=
 =?utf-8?B?U0hLTDBCbVY4djhtSU9nUVNucGV3VEp0M0VvR3Q1dWwyc3d1bzZsWDdXeVNE?=
 =?utf-8?B?MUx3d3g0OGVPSTlibmNuQnp4cmFNaHFDdnd6WEdYL2JOVDN3R3VsK0JSQ2tp?=
 =?utf-8?B?MElndkxhV3FXMHpZNVg3ZkUzK3ZIT1FhUTFFbU5ZbjBvaTZjeld5S1NYeEUv?=
 =?utf-8?B?Q1JUS2RtWlNDck1xWjdUWEVldWxiVmE1all3TXFGUVRFVWp0a2tNeENuc1BX?=
 =?utf-8?B?QlYzMklsSVRxVDFlc0hCTW54bEEyYkZoM3RLQW85ZzA0MDZibWRKY3FSZU05?=
 =?utf-8?B?cWI2cFZkdk0wSkxvRGVxK1dVN1h1UEtSMDVyaDJPT29ielJlNjBoS1N3OUZi?=
 =?utf-8?B?NmwwajZxM3FldDJnenN5OHYvbFg4NUh1RnM3aDFpcTlvN2YzNlROMDlFbnF2?=
 =?utf-8?B?RXR2ODlxdEozZWRHTHU4RW9JbEp1eStBbDY1bC9qZVVOS2JrakpGdi9aQ3Y2?=
 =?utf-8?B?TjY4bkQ1NnNyZUNEeXMzNWNmaHJGZVY1OGhPNFo2YWxsbmk3VXpqMXZKVEZL?=
 =?utf-8?B?VjBUYjN3ZXJpdHMySDFITi9ieTAyT25VNUVNV2V3NnZNakJtUWdJVEZvZFgv?=
 =?utf-8?B?blhXWi95ZVVmcE1sdVpNalNKVlBxdzB5WlVma3VYQVJqNnZTbFZuWUxMdUpL?=
 =?utf-8?B?M2lVZkljN3VmUktEMlZxVkRUMU1iUTdZV2h4UjFwdC9iTHkyVEREVlJwQXEr?=
 =?utf-8?B?c1VKSHN1cmJJSm5ma0ZESDgyTHpPRitzbCtFM0FrMTBwMWdaQk5lcWRMSXZD?=
 =?utf-8?B?Q3dFazhGc3l0djg4QVMrbFdwTWxLcGM3ZUNwSXBsMFhxTk5DcXZwZ29yTmJw?=
 =?utf-8?B?c0R0bjZXODlubmc2L0lXeFltSnBLa2h0R0ZSR2dJZk1jamVRejY4aDNyUDd5?=
 =?utf-8?B?NnEvTU96c01SZWJ0RkFRU3VqZHlCQ3dMOUxGZHBYdzZ0d2lId1VyWGlmc3d0?=
 =?utf-8?B?K0Z5dmVPVWx0V09iVVIrOEptZWhKekFuSDFaUlhGQ0pWbkhKZGVXa1daVGgy?=
 =?utf-8?B?T3VVQlNzeVJFZWtWSkN6L0thcytKOFFzbXpEZUNXQ2VpTTA3b1FxNUNsMW9n?=
 =?utf-8?B?d1E0ZGlVY1lMMHFucXBPK3VMeUdMdzlnRFZodUxmaWc3eVBuQWFrZ0lxTEwv?=
 =?utf-8?B?U0E5S1Nsd011bkx5cTNwYS9nMGZvc3pSUDJvdkJlbFFzdTBHMmJkbFIwSFcw?=
 =?utf-8?B?N0FwV1JieEYramd1aUpxMWRFM3VQS0lJVktjT2UyTURubzJjQm1WTzNnYTEx?=
 =?utf-8?B?WGFyUGlUZnRXZnZVY2FZY3RxQ0xET3dmeklDY21VVVRaVlM4K3BrVEZRS1Ix?=
 =?utf-8?B?U1NwaUhZalBzYlkyWlgvNldQalQ3QWprRW9CUmM5cm5GUFFFQlZaMEo0U2Vq?=
 =?utf-8?B?dnB1c3FkYkFsTzJXL0xZNEpQeXp2dG1oSDZCV013L3dZKzBDRTgyQ2pPeHhD?=
 =?utf-8?B?SGluYlRkZmpJQ1haL3dmNmFDU2s4SmQ0TGZ1ZWpVOGZxYUdWa3VQSDFGQXpU?=
 =?utf-8?B?NytISHpUS2RqSFdHWk1yLzF3M1c2YUgrNFlPb0VIc0MxTDFkNW8wTHdGTXQx?=
 =?utf-8?B?cW81RG1SVzJMTzhIN3Q3NGFvenRPQ1JsMXVBMFdwVWlLZHUrdHZDbkpMNEJN?=
 =?utf-8?Q?LisTg1J3ataoq0V41fCjJfos5JcZ+MEyae75jLX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a91daba5-681a-4a58-8070-08d983908580
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 21:31:39.1341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dliX4Wr8SNb8IfuLnbODJdE1CV2nF28yBfpqQpxC51tLdAPRiX4+oTBzDWfKE/Hn7Cfps/Dtw4x0jRFdGGZBookWpCN8wOMV6rPWtRdBc+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290126
X-Proofpoint-GUID: lQmQX9znw2DlFZ8mECEWhHN3EHhFhGJ9
X-Proofpoint-ORIG-GUID: lQmQX9znw2DlFZ8mECEWhHN3EHhFhGJ9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just want to note that highly likely this patch reintroduces
CVE-2019-12819 that was fixed in commit
6ff7b060535e ("mdio_bus: Fix use-after-free on device_register fails")
and added by the same patch in commit
0c692d07842a ("drivers/net/phy/mdio_bus.c: call put_device on device_register() failure")

>  drivers/net/phy/mdio_bus.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..6f4b4e5df639 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -537,6 +537,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	err = device_register(&bus->dev);
>  	if (err) {
>  		pr_err("mii_bus %s failed to register\n", bus->id);
> +		put_device(&bus->dev);
>  		return -EINVAL;
>  	}


Thanks,
Denis
