Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBD02FF5B1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbhAUUTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:19:22 -0500
Received: from mx0b-00010702.pphosted.com ([148.163.158.57]:39740 "EHLO
        mx0b-00010702.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbhAUURf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 15:17:35 -0500
X-Greylist: delayed 1019 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2021 15:17:15 EST
Received: from pps.filterd (m0239463.ppops.net [127.0.0.1])
        by mx0b-00010702.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10LJx6ZT015744;
        Thu, 21 Jan 2021 13:59:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ni.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS11062020;
 bh=IHLe1HnfNpZqytIdYjD54X7WS+NY0Fk1tn9kC/cj4Co=;
 b=ZRjeBN3v6NDpdk3dQPvbfRgcytn0JexJiYDlDPG/pk+815Oacm1vYwH1LOqFzUQH5ST8
 6j9cWVcPz+2cpzHLcDIGoZFzQ23niR+Tulx8JPmv4TS/kXgYU2OtQI75oRg4TAxc+mlJ
 ACX03ppop0BvanmAwE16uK1EfGNft2eBac6+GEERzIwBTRfKiPObMZBP0QJhBu2qZXxZ
 u7uWAZpMLsfL6vhXPiMcgUX47ON6mB0IGdXedy378fJXE9bFGPibCMzD2yjKtwxOYg0F
 ArazvAJNV2jyp1WIJ7SuP9YcnR1DHqIHX40i+oTPlgM6xn5SJ+HiN30WMRuj1Hi+xv+4 Jg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0b-00010702.pphosted.com with ESMTP id 3668r13wj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:59:06 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKxsUIPrUQ0K3E1kQ4q6d4nyiYbXJzm2Zf7ygNsPqMe6RqDqeFJrFzifLnWFpJjePpaoH+hjK/6kfKJbjuoKp+e//8OPqwZ5loIEgvqvTwtn8akYJ0ERPxOAly3gooOqmgQwRrr3BdSCSVX/A9PtCpPZMw1BI4wECfoEd84dI9LATR/fCe5Z9iGdLcxsZkCGLTIHH0zUEjqX6NmsmFq7ok8oE79QBYK2qH+E2kqoyaSiZzvuS+8fz9iyNiARNfXfMqq0K5OYxapnMsArNLuaHb1FtBEjSmzUcp/OMN6/YA2vkpmOW44fiaZqqNfpRzYdqePmFPDAcR+Jjw6eiHPAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHLe1HnfNpZqytIdYjD54X7WS+NY0Fk1tn9kC/cj4Co=;
 b=ZSYhKWWsijOriSpnR9QLRxFjzNr6baZOlYO/Ht5HHVQo3aGrgFS29cynSyRGnPt5ZpG/STi4R+ystMYcSUqacKpXT4tYFkzC0xw0bL9h1VDFFHh4gjVTky0SOyc3ulrk8io9GYRnU4b6Lumt/5x44Q+7KB1WXdMkqxeY7X0h+hLcei7korfF8QkdsI4z6nWcqbcqtEq8obvgJwwNRnJSq7Ku3MGpvcmLCucNIB0Zb2xX5jat/dCw7Nyu6EOvc8jkm1/Au0zGbOJ5GFW5krDITDd/0shxu/YfwpDbki75Y2TPEFbvkS3h3J3d/XoP9qiJwlFW9R8cSGspMXj63hP8kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ni.com; dmarc=pass action=none header.from=ni.com; dkim=pass
 header.d=ni.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nio365.onmicrosoft.com; s=selector2-nio365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHLe1HnfNpZqytIdYjD54X7WS+NY0Fk1tn9kC/cj4Co=;
 b=DntUqaQV6+0ZtY8MOIaD8obSNNfoSCWibjVXrRcHWPVGZCfEBPY4XR7RugWcCQVdji121YPsCIr/UGncYl4IIh9h9TABTuQHcFb8RpFct/GwDL9PZZivZsP9qMs7zuaBcYobEWQ4Oxmh5VQ0oSkpdoObjLs3c8Xj4MKa3gpRdhA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=ni.com;
Received: from SA0PR04MB7386.namprd04.prod.outlook.com (2603:10b6:806:e4::13)
 by SN6PR04MB4544.namprd04.prod.outlook.com (2603:10b6:805:ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 19:59:02 +0000
Received: from SA0PR04MB7386.namprd04.prod.outlook.com
 ([fe80::4115:8ede:6f55:f63d]) by SA0PR04MB7386.namprd04.prod.outlook.com
 ([fe80::4115:8ede:6f55:f63d%7]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 19:59:02 +0000
Subject: Re: [PATCH net 1/4] net: dsa: mv88e6xxx: Remove bogus Kconfig
 dependency.
To:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1611198584.git.richardcochran@gmail.com>
 <ad52391dba15c5365e197aea54781037a1c223c7.1611198584.git.richardcochran@gmail.com>
From:   Brandon Streiff <brandon.streiff@ni.com>
Message-ID: <6f83347f-5e8e-815a-9692-1f1bb2994fc0@ni.com>
Date:   Thu, 21 Jan 2021 13:59:02 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <ad52391dba15c5365e197aea54781037a1c223c7.1611198584.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.115.135.86]
X-ClientProxiedBy: SN4PR0201CA0036.namprd02.prod.outlook.com
 (2603:10b6:803:2e::22) To SA0PR04MB7386.namprd04.prod.outlook.com
 (2603:10b6:806:e4::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.169] (70.115.135.86) by SN4PR0201CA0036.namprd02.prod.outlook.com (2603:10b6:803:2e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 19:59:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbde7c14-7c12-456f-877a-08d8be46fffe
X-MS-TrafficTypeDiagnostic: SN6PR04MB4544:
X-Microsoft-Antispam-PRVS: <SN6PR04MB4544E9F7E1669635A9F1414C9FA19@SN6PR04MB4544.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxIgeP8CA/kd1Sgk0nDwT02+EGJwPF+oAkkzOYgVx9hqMusSMfK2DyU0qdopdZFip9+gCWQRLt9IUBlNqxe3QjWn2kkXsT2dKeQQYWkibjvy6fNmBxM6R9d5lM56mJbDn6TAsxD5YlTAg17PHu7VPEeYXC1kHLON515EiztFANxzRaRZQJ4lJJvTqAiMHPabGXcR92jhTdycA5QItEKabpcwak+BJKEoXxwpfEEG0obGB0UGRVIyOGGvoxhDvsDprSOIQBTUGerfaYi4eKHhIfob4OEg93B284MN0sjZB2yu7EOPD8Hty/uVk6tg7VsRuPxscpFhvSJWxVjFnHu9lyiEq5wqn1h7roL9/sKym3GdcOaEWkmT7Zl7v2OGQ02xUQ2rb5KB8AktusnfO+6fj43P7In7Ud3SwHNDjLFHkwUVw6I94h5SByPn49dsQFzOctJMY4WSZyHfmnf5Xyuu2G72/4tV5eelSJ37FFJ1OaYKmaiPO39SKEUS2+p8cDzGn/+GURPmof+4r3gg6Ar1iNylRE8pzRqnxwG5lw6UbDLZVZxwEzoFIX56TBj6eRmjUQZghXPka0AnlZVxvWou/feuGqrvc3SxI005L4IkVqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7386.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39860400002)(346002)(366004)(8676002)(7416002)(31696002)(83380400001)(52116002)(478600001)(4326008)(2906002)(4744005)(44832011)(54906003)(8936002)(5660300002)(26005)(31686004)(66556008)(86362001)(53546011)(36756003)(186003)(16526019)(6486002)(2616005)(16576012)(956004)(66946007)(316002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUR1eE1SVzczc21QN0ZWUmtXcmFLQ1ZlRS9LbHdFZ05uTm1hblRzbFY2VkJX?=
 =?utf-8?B?N20xSnVQOVltMW9TTHMyZDZ0UWhzZjlUV2hhZk1tUGl3clZCdGVZRDIwODNu?=
 =?utf-8?B?US93U0lWN1RHeG5ISVl2V29KYVRzR2twNlc4WDNNbUhaT0VGdklDR1JVd2Fj?=
 =?utf-8?B?N1NROERvTkJma0lYRTRTMlFQNkRZVnlFYmpwVDA5TXUzVGFQUVpBejFaUUVj?=
 =?utf-8?B?aHBKNVNWRUowdlJtaTZ1ZjQ3VkdEWWlPSkNPL1dIUTU5UThKcHFKc1JEOVl5?=
 =?utf-8?B?ZThpV2NPdGJYSG1KUE9nQlkvNnQ1aHN1YzhwSSs5Z01ONGJST3lvU0xrYWRo?=
 =?utf-8?B?SU5ST0U3VXVYUk5QOXlEeTRQR0NOZ0l4ME8wYTE3V0JaaGxjUnFqR0RLSm5w?=
 =?utf-8?B?L1VLaHZGNWRvZnpTV1JGNVlERDF3b1BCa2NhMzEzSHdaeENvMHI3WUk3RVcw?=
 =?utf-8?B?UU1oQ3NLV3dvVlJsMWljekM4Q3FNNlpWd0RxVENKc29iZzc1NU44MVUwSTBB?=
 =?utf-8?B?ck9mUUZyQ1doaWY3aUkrS1FRWTlURktoY1l1UVZNUGlXRDVTWmMwVm5id0Va?=
 =?utf-8?B?UU9idjBMM2FmY2JnazFWZWtTOHdoUGF0Q2JqZzFoV2U2RE9mL0FhNmd1SVU0?=
 =?utf-8?B?YW9hak9uNkV3bkVRMjRraFVrWUUzb2J4YWdjN3QxcnVnaC84eW5WazJPb0JK?=
 =?utf-8?B?OW1RMGtZb252Q3o3SlVHVlZieGpudlVQOW02Q1duK0w4OE5HM2FDT1pxV1RN?=
 =?utf-8?B?ZVhiSWJsM3FPY2k1L1lCOVdqWG9vaUYwWG8rS1kyUks3OHhaWldCQnpPRWkw?=
 =?utf-8?B?eG9RZWJ6QmcreEp3R29DQVJ6YWFuaEl4c2UyZC9KazJXU3ZCT3lzdERBVTh0?=
 =?utf-8?B?MXNma29jMXNHTitjTENSWWxFZ3VUUGd5MGM1d2tVbWpqR1F4azg4c21wamJG?=
 =?utf-8?B?N0V5Q29OWE1SK3AzWXRoa29yNXo4cSt2UlI0ZzBLaysyYXJmY29ScEdERzA2?=
 =?utf-8?B?WlVLWDVabEVkRnJrbkVhVGNVelVlWHBYcVJnd04zYzlQSzZRdnc4Ujd5NEZT?=
 =?utf-8?B?T2NJb2hFUmZrbUZ6a2d1bXl5UHpGb3JlUm5QQ1h2ZDhqeFY1SlJyeDZBQVlz?=
 =?utf-8?B?U3JEQlFNNGJxc05ENnpVQ0MvMW96Mlo0ak1jbzZlb1JMbUlTVW5IcUM5VDlY?=
 =?utf-8?B?WmM3QTBXRndMUUZ6d0R3UkZCTFRoTlRWSUJiOXk1TFN3cmNRYmJYdVVKaWo3?=
 =?utf-8?B?emN5bHgvYWZWLzMvZ3hRYVFmd2VhQkhrUWVSSWszWkRrV1VrS0tPbnBBNU9Z?=
 =?utf-8?Q?9Yq3qjf9tsKmBWKEc9dq0rqh8QJ2/fs5VS?=
X-OriginatorOrg: ni.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbde7c14-7c12-456f-877a-08d8be46fffe
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7386.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 19:59:02.6705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 87ba1f9a-44cd-43a6-b008-6fdb45a5204e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juKCYO8aK/xrjBtzt+INvzzFMHphaWZyeZvPANX9XpUgtKgJw5AAxdYuXZT7253a0S8ElcXcB1FomqCX4il1yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4544
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_10:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=30 adultscore=0
 impostorscore=0 mlxlogscore=825 clxscore=1011 phishscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=30 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/2021 10:06 PM, Richard Cochran wrote:
> The mv88e6xxx is a DSA driver, and it implements DSA style time
> stamping of PTP frames.  It has no need of the expensive option to
> enable PHY time stamping.  Remove the bogus dependency.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Fixes: 2fa8d3af4bad ("net: dsa: mv88e6xxx: expose switch time as a PTP hardware clock")
Ah, I must have thought I needed skb_defer_rx_timestamp in mv88e6xxx,
but instead DSA gained its own timestamp path so mv88e6xxx turned out
to not need that at all, and I never went back and dropped the Kconfig
dependency. Whoops. Yup, I don't think we don't need it here.

Acked-by: Brandon Streiff <brandon.streiff@ni.com>
