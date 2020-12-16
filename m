Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE62DC588
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbgLPRnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:43:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18686 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727664AbgLPRnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 12:43:53 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGHV8sl018701;
        Wed, 16 Dec 2020 09:42:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SkikUrQs9/Y7PkPTj908ONDT7j8mprvocwKlMRpateM=;
 b=NGi62mw2jHbU7wJvBeUkofUVglTN0C2W70M4Ci9IA4RkSmkcUdk6vVBjhMhUjSesZatZ
 z2/Vq2+8Iftm9kPsJj+QrHr+PnexTA2n0cue0yvfEfSvMyh+OFXWiE9BPuwqm6mjaquF
 J6mLGBvh+uWVpi38F3NaXI8/abEjop/jdLw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35eypsq6f7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 09:42:58 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 09:42:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYO1qg9pvF1APly2BYm/+F/7Cdj6P5Dl1A4ZeF/OL3mpHZyqG5DvjtI2B3fzanubmWvQ3Pe1724EpfWxhkkqzCZL2KzYLVdSKTrDv4/dy5PiSM5qEvD9Q17vwHc/BAhEKtDkr/lf80knq2xk8RlRS5X6ZhUBVsrqJIFh5S1DV/INBdpJrgdgXp5oK2pCpbwjFd1fwzyJzISApJ+Cuzd+DwHPlWBeLYYGaYGDcupGRA4v3vBePNasV5FVApYoMVdzSRF1RZ9podrwr7PYQrzZ2CNnHDeW9NtZeGm4quE9ZyMLWq8bnVC+AiiS8T7yzkLZa+xvdAp/L5vpYk8ego9ysw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkikUrQs9/Y7PkPTj908ONDT7j8mprvocwKlMRpateM=;
 b=cKvCGm84ikZ/rAMgkFHTJHRCD4LUfRoOExRXJULT+PnvJT4ubWbqQAPSOKZDSh8Rj+CJApJLfTh+DhVmJTHLmijDrAHb5pPb2Tf7M7tSi3EK2ATodqmmYTG7jYDqqD312EAY1CVYcCZu5gIPotkN/J1kRQFXpmTX+kuyyPLQZ+64RgIFgFF85eBzPKwn9oDk+w+9/X07pM8MLgX/z43S78LsY5wFWJz55ggNcixx85h1iOXZLU7ERXhfdJYszhKaTmk4ah89BoOi5Kg/Ss7eEZ1H/e6dvrFJle8UJE15BAx0Dr8GwnwJq0DHsv+ZwmBuoHXunjeAv36Z434Bx6EdpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkikUrQs9/Y7PkPTj908ONDT7j8mprvocwKlMRpateM=;
 b=jZaox8DYlA8M6oRra9uyXoay8ufzEdT6Q2pwgTHvFc8wIgvADydXEXYQtGI4o+FvUt1fL7UZrt8qJjh8cpgNtZ/RMwgv6LdFhTt2gklPbwIxVIy5SPuCDDfmWzM/bhfET2eCtpjaVGNVdd+VuU7PP9faOOZWYRRck5vRlrju8bI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3368.namprd15.prod.outlook.com (2603:10b6:a03:102::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Wed, 16 Dec
 2020 17:42:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 17:42:56 +0000
Subject: Re: [PATCH v2 bpf-next 3/4] libbpf: introduce section "iter.s/" for
 sleepable bpf_iter program
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-4-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bfa216a2-3692-dfdb-99e1-06b270564b78@fb.com>
Date:   Wed, 16 Dec 2020 09:42:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201215233702.3301881-4-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4fea]
X-ClientProxiedBy: MWHPR08CA0045.namprd08.prod.outlook.com
 (2603:10b6:300:c0::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:4fea) by MWHPR08CA0045.namprd08.prod.outlook.com (2603:10b6:300:c0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 17:42:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f66d973-b0fb-49a6-9931-08d8a1ea05ab
X-MS-TrafficTypeDiagnostic: BYAPR15MB3368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB33684BEC0413DD77913FF6C4D3C50@BYAPR15MB3368.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHhgvJFEui7CRgLGT289qkQqTwyHdhQ/xk15ixZwBGJinDN8cQ1MrrI/9af4xmMnAc+TMhjE5zTKua6iIOwSfkZoZJQNQ083EkKXdJ7O4x/F4c/TlrjtqyxXv42Klgj6l7FfEZMt8UVpFxsL2zQFeGDiR5Y16jbwGfkodzKcf/S2BhpPvZDq+ry+/PK071TaoJ2rXthVSYJ0Kd9KlqEhb75jNzJx15ttTkzamFm7D2yBVdP6C/UjGfmyDoI83Jj/XtvvCEE6h29FpUXOSNH7rqAXgaodkH5Ou2L9giaMxq1xvsPvt4bC9xpRkNy884s6UnArw7n/S7ujTQ5e9jB0OiW912GIClq7+atmg4umgwaRDCZLQ2S+VnNrwoXZ4O//Qu4giMuSX86MbkbPqZHtcqwXDNx1guP79LYGq1Ed3Eo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(8676002)(53546011)(31696002)(86362001)(478600001)(8936002)(5660300002)(83380400001)(4326008)(2616005)(558084003)(66946007)(31686004)(66556008)(2906002)(66476007)(52116002)(316002)(16526019)(36756003)(186003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cytFNm5HdnJoZUNTRDFUdG5rNytlOWRURXEzbTVocEgwcVRHUnRqRFMvakxS?=
 =?utf-8?B?aktBQ1owQ0lWYnVhaFBZS0lKUW0yRlJ0dUplbDJ4cTZHSXMzWWdvRDROOWhR?=
 =?utf-8?B?VmFjRERoK09iWDZsUlhTZ3ptaCtTUG96NVVmZDlWMkxmRFcrNGNMUU5lcjVy?=
 =?utf-8?B?VWJBZzUyN2lsSFhsQkpMZWZZcFo5UE9vVzJiV0lnWU5lL05LZFBQVy9DbVda?=
 =?utf-8?B?VmkwcS9LWG4rZEpwVk90QmY4M0FwWWRHMmJMYU0wdytweFJsbkZ5Rlk3MXFn?=
 =?utf-8?B?WDJSdStKMUE5SDE4TWRvQzd2b25pUmFHd1R0ZkZ5UDlRUWVESXFuZ0VGREZJ?=
 =?utf-8?B?aGpZb0taeDFnMHlFR296U1c5c0dZakFxay9adkJXVWRwSklHc1Fld0pkenZO?=
 =?utf-8?B?U01YZkxmOWFQUU5BcmJ3eWJIdGZUejlHSUExemoxYUtGdmJqQm1DeEFwZ0Rz?=
 =?utf-8?B?T0JxTGtIWjBGNXhGUFZiLy9BM0RLdjdNejJBd1Q4VnZpNTB6Um1xdThEbnhW?=
 =?utf-8?B?cVN3VjFSVzlyQm1RS0FGS1B3L0lUVTJiTVRaS2JkNkxuUzhhNklvbGxIcnUw?=
 =?utf-8?B?bG1Pb3dXWlBFVyt1anVTVEV4Z3RGNTZ2azRPUStSS1kwMGdVWTlNWjl5WGFs?=
 =?utf-8?B?eHNvd2FCRUpZTCsxYXU5NkJXNEhVT3J5QjlDSGJwTDFocUVsWVFkVm1RbWxi?=
 =?utf-8?B?d0hMOTg4cjM0UEIwaEMzRkUxd2JRaFd4NWJVa2pQanVFV1d6QnRjUzExeXZU?=
 =?utf-8?B?WFk0RlBUTGo1U0lFekVZc1ZqMHh3S3hha29jSlM3TGljMlhPSmM0QWtsaWxX?=
 =?utf-8?B?YkVtZmt4QmhSU0tPSTN3RjFmTmU4S3ZXZTU1L3lab2xZb0p0NUtGc3VxMDc4?=
 =?utf-8?B?amQ0L0lYMG51REM3emVTRThiUFRwUVRGZStSM3ZCZjhWS0Z2TnNkejdjOU9w?=
 =?utf-8?B?WHhNNlV4OTg0Zy9hYlZHMGZ5V2J5TmdaVzJ4MzhqTmVaemF0UFd2KzNZYXQ5?=
 =?utf-8?B?SU5IanJEeWwraC9VWjdudzd4RzMzdDFzQlMrU2g1WnBGTEtMOE9ac25vL2Vz?=
 =?utf-8?B?Vmt2dG1UdmdYak01byttN2FXKzJWTkRwTXQ4bTk3cjZ0T1l0NUtTT25ndjZi?=
 =?utf-8?B?ZFJzZmNpc0UrVG55bUNvREFnZHNuQllIVEFaeHVlejBCWlh6YU1mdHBiaEJa?=
 =?utf-8?B?NTlxTzJnVTh1NlRyaFpmVnp6UE9zZ0RIbjhEWmJOYmhBdUxISDhVV1ZxQnhj?=
 =?utf-8?B?TU01R0tNWWVVMVpDV0xCR01VcEgrTE5oY0phTUFOdGEzL2lFU3Y3clJuUnNy?=
 =?utf-8?B?dFJndXlaWEprclFzeVdWK1lmN1pBTS8zblNDUTZxMmloR0NjSy8wUWF0T1NX?=
 =?utf-8?B?VWpPWlVGYit4a0E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 17:42:56.1616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f66d973-b0fb-49a6-9931-08d8a1ea05ab
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cd5CQuQGrF5Njw2Bnvld/TzR4vEgEo3QyIkembWTmetJNc39pNppONXzIQOvhxxQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3368
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_07:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 mlxlogscore=761
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/20 3:37 PM, Song Liu wrote:
> Sleepable iterator program have access to helper functions like bpf_d_path.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
