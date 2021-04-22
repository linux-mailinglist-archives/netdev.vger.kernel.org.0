Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817BE3677A6
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 05:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhDVDDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 23:03:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24586 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230338AbhDVDC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 23:02:58 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M2t46h024787;
        Wed, 21 Apr 2021 20:02:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oWnO1iF2WWGD4C6Ospjmwc/Wa1n0YZpDVfKL8mMxQPg=;
 b=hGSK9SMHRu0WTwj60+ur1sjP26l0gAmjobE05YKRHzfprXGT9ltlV1UxrCJoK5frrduA
 KXk59L3TbrMIvIVR8fLrRF5a67+n4rjNzhP/piNTF8jnP1SnUa1mCXOqO9RbFIvMvyfv
 JRQUyCpFfccMQZM2kisRP0ko0nLTarWVXQg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 382dq9xrs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 20:02:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 20:02:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPkKywPPIS6J3qC6DlyeS3yqsZTGpy2YvaMUpgvCa8lPEJ50Btk+ZT0IBsHjd0eQdCfS3vTM+A3NoIi6eR0tT/sPFNUU0vxb3yt+RYwhPe76l8b/p6dvJVYYQKzXq1A0oMEfpcjuXM643V0mZb+ujZ1qkpZ3PAibckAisZwJ62RDX7StgcEThWYIQxYFUzjRrcrTkSzPWMk3231gHHNQxjugTbFRsiL68+BVc0+SEI9LwD9xg7xOE0zRpB9ocoqL+UEouB9wqPzNhnElNr0N4uGBe5gfXGxQJb9ZisGZ1hpYvvLdJMqEsJfAe3321MOFHtjCrtuwiCVbwNFP/OI0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWnO1iF2WWGD4C6Ospjmwc/Wa1n0YZpDVfKL8mMxQPg=;
 b=dl1XWNsyywrj9+hAH0f3WvL83f+0+tWlY2yrnNnaTfHLDvPfvIE2ncTdQzOW6rI6THn/QU617twI7kncyAszw7Oljy9TAWRQTnP18ooO0mkeHVwPod75wI82SIQqQlTnMFOvWYJKFlRs4waH8dvVxf9FPMg8VBrzUn69WJ86hDKCFV78ffad2qX3kwaHz5OQsIb5CXZPDDmgH87HQ8ntvNL0EF98gqJoeZqnnvWQHiB8cTRzsNbuTUFRKK7VFJ+TeXH5UzaBRqGPnueC+1AOsLl1zODfUCiMGcBWUBeURqeIpAF9l4rgSz7vrfWfX0QELu/oqZzeBsOkmsoW2t4nXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4901.namprd15.prod.outlook.com (2603:10b6:806:1d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 03:02:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 03:02:03 +0000
Subject: Re: [PATCH v2 bpf-next 01/17] bpftool: support dumping BTF VAR's
 "extern" linkage
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-2-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c0b7fc63-75a8-1a0a-2d3a-c2e94db999e0@fb.com>
Date:   Wed, 21 Apr 2021 20:02:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-2-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6133]
X-ClientProxiedBy: MWHPR18CA0036.namprd18.prod.outlook.com
 (2603:10b6:320:31::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:6133) by MWHPR18CA0036.namprd18.prod.outlook.com (2603:10b6:320:31::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 03:02:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9faf902e-6496-4677-2b30-08d9053b0101
X-MS-TrafficTypeDiagnostic: SA1PR15MB4901:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4901BF6F7845ED0EF04AA557D3469@SA1PR15MB4901.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AwpP0pyfbiPLTqQdB8b2mWS+PLDckXQRdH7PDKfg/LHv7ar+NZerutN3/FmZRbwgEV+LrJwH4QKtkE+uP3MuAgv9/ooPLzrDF1ysIjHr/tFDiEi5hDvnJwkTnm0gyIkeHqPnDGQN9rS2cfe0OvG7XGA+LRKMqzpdv36UsEPAQp20a+zSIUFygKsbg1tQ5V0xtxO0OjOESDpshsbVrS5KED+GIiOUz67vBuOJCI8y1MVqsFcyhO7i3nLT70eBHxk3YvobH0W+CL8BoucNK6ZnTWwodv3z9Go+Rzf1xmwZGQ7WYrUUoPvEGyo9rKEtmsCIDCKWNBu+nmZxHoFrQfqzEsgqEk3XZnG8/pyyO65+c992SZUjRC7TpOeNJYQelIgy9eRvRPEPelyMsfXkI08RaNswvVC7JuQIazr9Xj99WXxtTadYQHDQ52Y+rZEhy+Mp7kxa/aYzYJXmeM/83X9ggpnegPXmOZzUOqul9T27RY6TvG0H0F7gSMFe4qMcQ2hYQb4waAC5ddpSWfu0Rl5pElBPnqbNTgoAS2PiS7KL3/LtJVJ4iNYEozoi26pFgAi+2wp9gl1tOcMZYNlA8WEz8lGChg6r3wRI5NSKRiTKVsdWpSRh1wThRHUdtdJNrPkDbgq0sAA7lsH0qGIKcgmwAIh8Kp6Zm+5m7sf0kc3UNKkJOKY0dFBnkfg5G45L0AmR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(376002)(366004)(346002)(86362001)(31696002)(8936002)(8676002)(2616005)(53546011)(66556008)(52116002)(66946007)(31686004)(66476007)(5660300002)(558084003)(186003)(16526019)(36756003)(38100700002)(4326008)(2906002)(316002)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QTFWM1hVTlkzbWYrQ1VXOHFhNnZtQUw3NlVKVjZXVWRpamJoYkgvSHJjWk9Q?=
 =?utf-8?B?TlhKUUxWVlVzRWc4VURIRmlqWWNIN3ZqZ01mRWxMaHI2cVFKZVJpOHl5MFFq?=
 =?utf-8?B?UWxjRGEvRmtMckdiK0RsUTVXL3dXOVlGb3dtRER3MWZsbUY0OXVvTVNpeWpp?=
 =?utf-8?B?ejhtN1VwbzdsRHlPcHowSlZoNHBWZUlTNHdiakRNb1lkV0NmQkVrVXNTZ3F2?=
 =?utf-8?B?U1pHUjBidTlBZnlxbVJtdHczd1IrN214SWsrQk9qUlNZQ2xsb3VEMFJTWmhW?=
 =?utf-8?B?SmJzVjFjSWNISysrWTE4L0FIN0pPSk5UaGxMUDlKSFF1d1BjeUZSQmRPa1hp?=
 =?utf-8?B?NkRMUnhBdXZSSm9aSnIwRnBLSGJqOG9RVTBpVjlIVWEvMmNjTlJTYWpSanFl?=
 =?utf-8?B?ejFvdVM1SjlDVWxMWWhJSFFjZGQ1dVlreEpWQWJ0MGVvM1o4VVRQcldMbkRC?=
 =?utf-8?B?ZzZaSDhBNXd4N2kyR2VNT0ZBazY3cDJUYTQyUWtTSFMrYVJSa0YwQ2xqZU5H?=
 =?utf-8?B?ZWdIUHk0UCttT2RERHZ5YjVVOTdtMjEza1RsTldyQUJkLzVFZjQyTEVnZHZL?=
 =?utf-8?B?MUdEZTFEMC8vVXZXdjNueVE0Z0RWYnRNNWZONmwrclVDbjdka0c2ZUtzcEZx?=
 =?utf-8?B?bEgvWnhJdWNmNXF3ZHZGUmJ2aWxkSDlQZklhVkpTWmVKWlBjTGVVWHpqdXhQ?=
 =?utf-8?B?SG82ZHBMWjhBMDExeDZDU1ZHaC9ONmxWZEhEUkdNZEdHOWI5L3prR1R0OWtv?=
 =?utf-8?B?NDRJTWJ1ZlhPeFZucUxrMFpvSjZBRzVQK2V1TXhIY21MK3J6VHRRbitoQ2U4?=
 =?utf-8?B?ZGxXRmtabm1pTThicStCcmlURUlJQ2pEdkdsem0rNEhhcHp3aERBbmhYcnlG?=
 =?utf-8?B?b1BxN05oMGpYbWl6NGNPWmF2YWhoWW9nYXpFQWJEbEkvZnFuWmZvM3plVTdL?=
 =?utf-8?B?aFlWamF3SXA2NWtUMnRXUzhCR0pWMHpHa25LeUJrVDFsZlh0K2QxVEVhNFQ0?=
 =?utf-8?B?OFRHS0R6bkoxRk8rbTRIck0wNHBjd0FaU2JMUUs3RjBITmc3QkUvMzkzWHkr?=
 =?utf-8?B?c1lhRHJiSlhpc2dJTW1lZlU1UUlVaGpOOHlUMEoxRWs5cGhhRUZUdVEyVXdj?=
 =?utf-8?B?ei9WU09vSkdpNlNOUGRPOTVaMVlkYVRyaXkweUVvb3Fka0pvWDVWMmUrKzlN?=
 =?utf-8?B?djBKSFo5OVNIT2hmejdBMjYxVFFoakNHaTRRaGlveWxuakhVY0NqU3U2OUhL?=
 =?utf-8?B?NkkxNHZIa1ZydlIwT2Z2cGdpS1JnbGZJZE1sVTVwUUV4bElvKytRNWJtK1Zt?=
 =?utf-8?B?eDBYUk5mS2FLYUtGWTJoSzFtbk14ejF0NVBYYU1EaXNUY1dsWFFycVVBeEp4?=
 =?utf-8?B?ZWRzMWNwaEdSRzgvZ1dlMXpPQ1dFWFpQK3RPcVIveEtlQWJRcm5DalpJaVlD?=
 =?utf-8?B?ODF3VXVkZHBnNDVkMmxORjY3TEVCWHpKTnZ0Y1ZSb1N1MTR5MXNta3A3K2dh?=
 =?utf-8?B?dGphbzZyOEQ1a2diWEI0SmhDbFlkQ1RYTmxnYUUrem9IdXd4NCs3ZUZNNXFZ?=
 =?utf-8?B?SGpzRllEbHZTdklYOXdrNW15WUdzbWJub1dadTRGN09MZTVlRVNFTTJBZTgv?=
 =?utf-8?B?UkI0dit3YzZrSGNldXZsTWZERjFqZ2pFeFBycWtTTVkxcWxob29PYmpvMStV?=
 =?utf-8?B?WVJLNnljVW9yNExIMGd3L1FzY3JHdElYRWRLcWNVZkQ5eW5JaTJtSjcyeExM?=
 =?utf-8?B?UkFyUHdEQ2Irb1B2N0hOZlBYWHdLaFp2L0JQQWJMbVY3MEREeXh6dnRxSzZ0?=
 =?utf-8?Q?+AIkhO3Zs1adGAy4BLkASYIf7uttGDSoMlqak=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9faf902e-6496-4677-2b30-08d9053b0101
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 03:02:02.9378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxX+dSdWow2+meyWL9uKlZyevxSM2WP1vCrx8cHKaufMVpoiqKvbbKOcCBVURxa0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4901
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: jkGNN1BInmgAwIlTmEVq0vOU6NBWKsft
X-Proofpoint-ORIG-GUID: jkGNN1BInmgAwIlTmEVq0vOU6NBWKsft
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Add dumping of "extern" linkage for BTF VAR kind. Also shorten
> "global-allocated" to "global" to be in line with FUNC's "global".
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
