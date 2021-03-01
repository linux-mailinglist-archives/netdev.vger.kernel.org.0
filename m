Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D4328A1A
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 19:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbhCASML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:12:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52358 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbhCASJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:09:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121I5dks061576;
        Mon, 1 Mar 2021 18:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3yg7abmEZ5nC/BlORIcbGptx+FeXZHmGEe1DwUhKBMg=;
 b=dSSiobPbLf73pBn5H5iuROaKS1e4Yu74n5JdN+0W2lLiZTNec57NW0p8/HL2TtSKqxfj
 QoOmvJkoVYw56Juiq1xxnwIOJdtTt8Cjm3vfX/t6KHsVf8UJmu/KrJF8LPjPhPo0lpji
 I3i5o9Ysc4vB/eGhkOWE5FdJH5EzMp3ZGQmey+26wZfY4gclFWNHGpWu/R8SJSqH5KGx
 YtwXG3B2wBCEjsvZutBlko9FEc6lWuCTyhCpTaAIZJZXepoaocpGATFPo97ZTYI+IBSk
 ynxKAiqc/DlRQAN9a83EI2moLZJNAvOFytn7xemReGQ5tMXLOyaPZuIA9kUlg0LO5ZGM fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36ybkb4y1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Mar 2021 18:08:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121I6U6d110341;
        Mon, 1 Mar 2021 18:08:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 36yyuqwbp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Mar 2021 18:08:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Muzz7VOUes25mGnFbASPNHkNryZ6o6L2iAJz7XX0AVWr4CMiohbTcRqNYPDIpR8tVlFMCOoMsgVqpMNRyYZxQEy3Jub91S0WyBttzpHnL9x+ZYZEnZl7sFCnAgeF/6X632KsirWVVxbbFJgT2vTcF9xDhz2+omkOYAz1uL1SQgsat4KG5VLSfjE+wufZ2wfa5ZOb4ShRAOuNRh5O/R/LFaiJHda9ucFvMDsADYvE3aPk9kzKTTyv6SiiGRIJOGB7mY5hRjitKl5HnchH7bwBgVddD+ZSBmuVWbHAmrASaIfd5qxlGQXhsNTqWapzgFH0C+u0m0JsVyVxHICalnwx5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yg7abmEZ5nC/BlORIcbGptx+FeXZHmGEe1DwUhKBMg=;
 b=PUxinjueiymToZz3vVH+sZnKVspUBr6ZZf+SWXKMiBWhN/S2RRz2hWKlDXvr0UsqNIYMRldtKhocMxL/6ctkgpPgrnVuWDkj8+C/F2BdZwoL9E2xBjxd6x4kIyGaH0VI3MdD8VeKmU38V/fitEeaSLKHNls9DzQb4DGkZhhTWfrjBxicmmNuOlAWExggt+wCzu53fqCWqALVpBinfhzxO3YlrSCy8ycduPsbWHH9lyovfR38aoNrEr+k6sNRVzTPpXXfjTEgeRwSI1x83Fx30r3c0iiwFbAWSw1ToYCmZhScDGrUYYFCWuJAIGfEacxHTumUWBEasWmij+DEHzg2Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yg7abmEZ5nC/BlORIcbGptx+FeXZHmGEe1DwUhKBMg=;
 b=y8WedqrK25jd3txoJaXYK044Jyat1Up6psnXJZezEp5HIgVKGGPR0KkiLeaah4SpVoHIu/4H78V/ejri9uAoRddir42gDejhRgJl3ujzUH893uVOoI11XAWd+/1Vdas49TSPkJCtLnBxZbafF1vRV17V7M6WzoZ73PJ67dXSKXw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB4308.namprd10.prod.outlook.com (2603:10b6:a03:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 18:08:24 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 18:08:24 +0000
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <3e833db8-e132-0b00-34d0-7559bab10123@oracle.com>
 <20210228162604-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <efde8d29-71aa-dd3f-21d3-e866c29bd080@oracle.com>
Date:   Mon, 1 Mar 2021 10:08:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210228162604-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [24.6.170.153]
X-ClientProxiedBy: SJ0PR13CA0042.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::17) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (24.6.170.153) by SJ0PR13CA0042.namprd13.prod.outlook.com (2603:10b6:a03:2c2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Mon, 1 Mar 2021 18:08:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd8bde4a-19ec-4844-0433-08d8dcdd012b
X-MS-TrafficTypeDiagnostic: BY5PR10MB4308:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4308AF3524B96C50C610D5EEB19A9@BY5PR10MB4308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwp6TWNn4I4/4Mta4xeEbLjm91CkiSZYinLzZKXVNxATgKA49jthXfqIARWPurAcSTj7HcskAGarPNzYVriEmugIdXyq6jf2h/7dhQOoymBV2vzX0+gdzq/Qi2n8xiRYySyNXbSj1W96mYeyPVF8/yIDS4Gyz4Jbgc5MmscmENxUzrPsg6/AEBaED3qFUDOCk7+nB8nkKxeX5GdaLX9+j1p69EL0KIRVOHECMZlP+kpQRT+E6ham2ABx9KepM1WgkdExk9iZuB5l4NpDnPrk7UJGsPuHUl+EReLZIwQ1y5Q/v3SPOLDEY6w8qEM1sm1jcSDuFL5CN6tMZcrrf94CZW3jOuY4GNH5MEa+Z3hZgNRmnU7zzhfkZweNfhjHj2gV2z0RpmUQYhBaO52orRo2/XbpxznuXHvhNo/ISk1jnzc3kGKmtvUpFHL+L5QAUTmV/3mVTJJ0UG36gYGn/jCFMSBKWgIaeV1HBP6GzwHsTyuohxqL3QUlu8CdnOpnEDNETsfcAlXWvAWeJu9NsGMWRq+aaxnx8GOBq7oME1DwFiNZDKdmNosEVXqMuRQUQgtMO3yrn3WZ+u4TGQftic+mnbiopq75F24VIX3vgbl+1GU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(478600001)(36756003)(5660300002)(53546011)(4326008)(6486002)(16576012)(316002)(6916009)(2906002)(26005)(16526019)(36916002)(8676002)(4744005)(31696002)(66946007)(31686004)(956004)(8936002)(2616005)(86362001)(66556008)(66476007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T08rSldoUVpNNGI1b3NFeFN1RUdEeU1lMXdZNm1qRUVDdFBqVHNhMlJROW9n?=
 =?utf-8?B?UlhGbTZ3dDlRcnhtZ1N5TzFmWUszZURBYmgvRGVrRTZGM1A1ZEhuNnVtUlBk?=
 =?utf-8?B?VEJFMzRYMW03d1U1dXZSTzhMZTZMR0hYY1QxQ2RxazZaSmh2REEzdlpxbk9C?=
 =?utf-8?B?TVFHQkxNRVJYUzZJM1lWL1pKa1BrZ09Xc1NTdTgwZUtjZnUxcXBCUHVMM1Vq?=
 =?utf-8?B?TGk2c1Jxd1NuTFhJWlFYMVVUTlJXbzhqc0h1VFc2ZmtoTXZnWXdMQWVaeFcw?=
 =?utf-8?B?dW9hQk5UV0psVmo0aHhUYTFUc2RmVnlObjZMYVBJU2EwTjU4VlFMUUFBWmJH?=
 =?utf-8?B?SlEydnUvVDJHajc5Q1lyZU0zOUYyZlcvd1JjTit2eWVWVTFWZXh3ZTBnQVpj?=
 =?utf-8?B?YjVGQWhIRzZPOURYNVlMdHJjT1cwQVhsd2VaT2tVam9keXhUMWRYaUs5bGk1?=
 =?utf-8?B?WjJDWnhJNEhKSzdJWk9RWlhPQW56eEVrOE95ZmNkaFcvTGNuWCt6RUNUL2Q5?=
 =?utf-8?B?cWE0em9VTVdpNndacnZOV2ZuQ0ZyNCtJTDgwL1UxY0FvYjJ4dE1uK3MvcEN6?=
 =?utf-8?B?VTE5b1B4V3B2UEN1VWlTeHVmRk9KSjF4SzNESGhpQjNnLzl2TjhacUo1Y3dz?=
 =?utf-8?B?bVRLellwWS8rbHk1bDNOendwOWdZK2l3V3o5MmY2U3JpMDBUMjltRlFYSXF0?=
 =?utf-8?B?cTV5VlRaYmpoWkVUcktoVDEzSVBMWHBDWUphek1ad2NjVzJwNVNXNVdJRmYw?=
 =?utf-8?B?eisyU3BHSDdzbmlZMlBzdjVlNU5zaDlNVy9BMmtWeVZPSDV6Y1B4UkdvblRz?=
 =?utf-8?B?V3dnMWY4YzhVaFF0RitEb09tVm91VEhxQUorYXpRMUM1MFlQR2MzTjA3OFlH?=
 =?utf-8?B?dmpJdUJFNkRXd3hneTY0RnUwVzRwanpSbVUwZDF0VFc0L1BGWUtsNXJIQWcx?=
 =?utf-8?B?RS9Fb0NhR0N2ZDExNndQRkFrOUM0Tk1vNnZPUEJCWTdTYWEwemZsRGNoeVF1?=
 =?utf-8?B?Qm9sTVR4cTZjc3dPZDh4SE9KdTBhWDVMMnRERFR0YXVPSFg3RlNtUjdqQVZG?=
 =?utf-8?B?WGxvay9vcnJzRXBJRVd0azhQYyt4cVk4dUkyVXFEMi8waXAvT1l0SWJQMkFY?=
 =?utf-8?B?cU5VVXFGdmhkMlFDdWF4OVFOMGFwbWQyeklhSnhpVHpFQmFLVEJrNlh4bmUz?=
 =?utf-8?B?Vk5pcElldGxkRG5VdzcwWm9qd2JuVmxnOVhPenhOcElNQnN6dUxRL2lXcEpE?=
 =?utf-8?B?VmRKclN1a0JHZUdRUVd3Q2dIckV1ajgxTDhqUEk1Y2pNTnBhekFDTDc3Z2da?=
 =?utf-8?B?eDR5aG9PeFl2UlZkYmRJbHhJditHb282cDBpajJZdU14KzlPZzZIYzdvb2RC?=
 =?utf-8?B?eUU3bFhSRzhZdHlpZVovbFBtU0dmcWszWXVOZU5MQStjKzhBekd3OE9KN0Fp?=
 =?utf-8?B?dmx3NjI1WEtxVkdNZFBjSC9zMzBRMU16VnF0Um5QUldOai9CTnlVSE96Umtx?=
 =?utf-8?B?TEtMYk5aYXpETmtYVzVtKzFDMWNycmpJdy92bGppQ3llejZQU1J3WHVXN3FC?=
 =?utf-8?B?TlM3ZDJrY1RxY1djSlNocTFDcmRMZGk1RmFCN2JGS0M2SXZWdFBZZnFCUjVi?=
 =?utf-8?B?MFZIenBsQnl6NDJwNWVmQjhXc3NjS0tkVHk5MDZYdCtwY0pIaklzZ3ZnZ09P?=
 =?utf-8?B?YWFKMzV1SHZhNCtRRWE2dkN3d3lMSEFlZU1FY3R5SjlONm9kVVZaUjRWOERY?=
 =?utf-8?Q?Y8/lEf4iJ5ug9fDVxGy88zZEbgxSN2gkHPE2a34?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8bde4a-19ec-4844-0433-08d8dcdd012b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 18:08:24.0543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4oBV+YA7Zyb2aqYRqjLdq9q7LFq7CmcC/8MS/Wgo0o08oN1MWU6MNMUF6CBybC+I93h7OYhVzTmPyHvz/BVBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4308
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103010146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/28/2021 1:27 PM, Michael S. Tsirkin wrote:
> On Thu, Feb 25, 2021 at 04:56:42PM -0800, Si-Wei Liu wrote:
>> Hi Michael,
>>
>> Are you okay to live without this ioctl for now? I think QEMU is the one
>> that needs to be fixed and will have to be made legacy guest aware. I think
>> the kernel can just honor the feature negotiation result done by QEMU and do
>> as what's told to.Will you agree?
>>
>> If it's fine, I would proceed to reverting commit fe36cbe067 and related
>> code in question from the kernel.
>>
>> Thanks,
>> -Siwei
>
> Not really, I don't see why that's a good idea.  fe36cbe067 is the code
> checking MTU before FEATURES_OK. Spec explicitly allows that.
>
Alright, but what I meant was this commit
452639a64ad8 ("vdpa: make sure set_features is invoked for legacy").

But I got why you need it in another email (for BE host/guest).

-Siwei
