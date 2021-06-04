Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9E439B009
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhFDBwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:52:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37834 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDBwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:52:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1541m9MC051830;
        Fri, 4 Jun 2021 01:49:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NbRCNCPY8R1hSw7JhonvH/YFtcFYtqbJUiX8S0oc01Y=;
 b=pnhtjbUmsIEY4sG/zPhvG/TeCWwVGsLIUspF6X5lKBqIGYUEdZVnW2EdTSxDy/a4SLnm
 0I3nNsc7ccM0aT+JPjeapBbbODdTm/VWHNzwlC7+u/Sq8QpyWBtdGUJUibMXY2mn1GM0
 +JplUrKIMatC8S754ZgTx1NSsndACRDQLlo1jt/jAs9jtXE6JL8qBWn1R/FbUnKDSgTd
 nrxPEb7a/MbzktIHSUmiKzdKdrp5lnpuHa2WpL3hUyst4ob4PH5hLdKdFIzWLaSH9XtN
 bMlQWDPUYGpmiDb8fXsBf1z9U9T0MhTzmEyvq6P7tMxUrgtB96PcJZM/NfzmE5mDRfkn ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ue8pmqx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 01:49:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1541k4tc001373;
        Fri, 4 Jun 2021 01:49:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 38uaqyt6uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 01:49:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9FY/OcteczFF+sqeu3i3cWk84bjrEe2Nyzg9yjw+p5WAjW8czPz9Y35uBgsCZRNqgiCE5CHFfQ0nq0dqS8wndNlPt8nuC2w+e+mBFY3QeYh/kpvuPgjWjHgN2mDtwu4iXc2Za9kPIjM5sC96lwSahvW+XKAch95SiQs6tTYj+D/EcmlfgmsRB2eJjH888UpuBeMrtEX7xlbsrW/DOd3Zhqvq1MCt4pTDLS8G+ivv86S1PZergHeDT174usqlt8z0O44HV5b972IDZTDdhQaKH8h5XkoEQRXtRaVxpMYI3teixlGBJKoFOQYAvB1aBWwgY0+dMh2DPwRWGGervOYrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbRCNCPY8R1hSw7JhonvH/YFtcFYtqbJUiX8S0oc01Y=;
 b=R29twU9k55JT/x8Dai0HMzG2ytvxffZuwKySk9aB1ds98kMRisHGfylf/f8m0e5j7CL4unowS997sZs99QACFETXE88r9oP6Oiom62JAafLZ2a+PfR15rf5a5kDo64/okht5qy2wfAs2VNJkxIbLtvWsr5MnNXlUn3lRJ52y2pAKwujdAnaFG+pgEEb7//J5qf8B96qjKCA1XhXz5ZTmbUyXeKO2rclj6IJdimhY4hevaukPlX+jXHDETIJIUt/b1cgdfj7YrrwHFxlyuay0cwtoOkSrYB6s8O53fuLRoBcXXQRu1VyP+/ao0xzYan9Cpc8vXTRaEx/OWHrBC10xRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbRCNCPY8R1hSw7JhonvH/YFtcFYtqbJUiX8S0oc01Y=;
 b=teD6CnAvT06EaZH1oHtuSiThk+JIeT0V6r7cXJVy1hwH0Ub/3igfjb2As9yflrh3pj0iEE0GP7QhDwp/otYd96kUvrMl+B+FX0202P/r/HI33+ELIIXgly5cfLm3GGPqsPKmEqI9yKo5AgD5XFGr70luXrVdMDdDcjQRwyFGaZ8=
Authentication-Results: amazon.co.uk; dkim=none (message not signed)
 header.d=none;amazon.co.uk; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4384.namprd10.prod.outlook.com (2603:10b6:208:198::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 01:49:12 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf%7]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 01:49:12 +0000
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend
 mode
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
References: <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
 <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <33380567-f86c-5d85-a79e-c1cd889f8ec2@oracle.com>
 <20210528215008.GA19622@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <1ff91b30-3963-728e-aefb-57944197bdde@oracle.com>
 <20210602193743.GA28861@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <2cb71322-9d3d-395e-293b-24888f5be759@oracle.com>
 <20210603232742.GB14368@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <07fca94f-86e1-3a0a-0078-0c0d6aa52363@oracle.com>
Date:   Thu, 3 Jun 2021 21:49:04 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <20210603232742.GB14368@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [160.34.88.237]
X-ClientProxiedBy: BY3PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:a03:255::21) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.96.237] (160.34.88.237) by BY3PR10CA0016.namprd10.prod.outlook.com (2603:10b6:a03:255::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Fri, 4 Jun 2021 01:49:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e2c7768-a512-4fcf-a69f-08d926faf37a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4384F0C9073711605DE313DB8A3B9@MN2PR10MB4384.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xppyepoSXXUHZ74e6dRnIAODnvLMecFa4hYdTHhjtyH7vtaDCz88FCM8TVln6poQ8B8vbLzwthXYnK7aNbS01+/F60SLUFeqKdkSNk36SHLxcffjzOCAAzyG6gGAHs37BaMFj5h1l4HFI51afSAl/unGLgCKpIjLF1lYKWt89QQWbGg1F5iebuc14Q2YE3rpdzwLr04TbT5+qrSPIWr2ZqdGG35qBnELWH2Ci0MtwkOM+oRt/y7V5FT/VRvbpb1cyPRr+zXx9YEvyyUHTvAe1KhLznSRQBWTY0o97KwC+SZ6GPOXrh5jJxIGyJ8hRHvJc+GPc3bmRz5BC9ptvIDAg9fEkITtYZ4XyHCbUW6eB6w7b+ku0p4PvHt2bDqKIul+rupG3BTTIdl/9qAfZGvkyIhVevkYIcD3knF+zV1Ic2qh2M9FQaKcsBUNxhHhBnrV/GmL8fA60xgRCJ8szQuzWjp1B42h7cGJ+KAz8iXbOxKiUnJAbLjpvxYtxDIAFF41weifjOW31QRSoU9nPaG1CbwXenYk6sPelh1sGqDM96YetCub6TfNlzURXhT+S/svN4fE41EunUjjqyQfY3lHuY/PXE/5qXfLVK/aNCcoWJ8inZpLmcJlUp/uq/UHi8kLzyIME6/2jrXTB45SFRLesKcyEm3FdF98bJ9RFUgwaA3JQu4IIzMLogw6kyGC890P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(366004)(376002)(2616005)(4326008)(186003)(956004)(8936002)(31686004)(44832011)(6666004)(66476007)(66556008)(66946007)(54906003)(86362001)(316002)(8676002)(6916009)(38100700002)(26005)(53546011)(31696002)(16576012)(16526019)(7416002)(36756003)(5660300002)(6486002)(2906002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N1VPb0hiejZuL2FsdWQrbHFQcUx6N3FYcy9lUEdZY1ZwSFVlcXFpeHZnS05z?=
 =?utf-8?B?b0lCcW5Ud3FRZ1JSeWE3eUtxM3AvUk1yYnVSdTVKSTlhQUI3eTB4YWNQdDJ0?=
 =?utf-8?B?YjNxZVM4elZydEl1Z2UvWG5yM0xCQlhFdW5yKzRKUWxsY0MwTlE4OEJLRFgw?=
 =?utf-8?B?UEY0QzRuM3BOSDY3UldyWWVjL0V2UUIvcHY2TDBIOGk4Q04yQTQvbUJDNHp3?=
 =?utf-8?B?anMwZHVINnI4T3JXQUh3SUVjNXNKcHBDT2s4c3l2MVord29zN0lZTHNGTG94?=
 =?utf-8?B?TUcvR3RTUlA0MS9hT0huVFdnQ0VWNWtVQkNLTHNSM2ZZOGFIdGNIOUxXSEVV?=
 =?utf-8?B?UVNIZGxvWElYaFdBT2hsdTE2dzM3ZldWY0luMVFhRlgzK3VBRTFYQzNUZHVx?=
 =?utf-8?B?WXBlU1BtY0pPOWRpazVGS0JselJDRkVLN2czVE96cXpEckxVQXIzUERmZHRR?=
 =?utf-8?B?WWxtR2ZaZ09EeUdtdEtXMGZudjJCR1FHOGlLa3orRGo1YXUvTGduaURSK3VY?=
 =?utf-8?B?WXp0SEgyTENTOHlaeTZOYWZ5SkpGQ2lZU2ZMYTJyNlQrbkRFTUlHaHVpTEV0?=
 =?utf-8?B?YmdmZWxMa05oTHl0U2V6OGp0d2xORDVjbDZlWk1aaEtjM0cyR0FFN1pGb1gw?=
 =?utf-8?B?R1J4amJsTmNDbGoweG0wY1J3Q3g5RjVOUXluMlZGTjNrODBGOGtHQ3pQSTFD?=
 =?utf-8?B?SEJUenpxbUlZKzl2RkdjbVR5bmQ3ckFQTEtKK3habjNkT1IxVWlwWGd3N1lF?=
 =?utf-8?B?dTZQOW5RSE5rekUyRHkxbFJYOW92S1U3aE96S0xaeVUvbnBEejZOY0thdm1H?=
 =?utf-8?B?dmZPdS85WnFwSUU4Ums5TkhuK0hJZHl3UHpaeFNKNDc4bmw0aWQxMTA0Wndk?=
 =?utf-8?B?SU83Njl1SjAyMjRHL0wvSUx4azh3NDFyUHhnTGtSdnFoSmJBTytWYmxIUHFU?=
 =?utf-8?B?dEpyNDk0dVlicnBmcnVVRURWL1NWNlZkOHJYSUl4NmdMQ2VBdGxYM3VrVVpt?=
 =?utf-8?B?V1FUdTVMQnM0OFltcVNrNDl2Y2tVeWlBM3ZhazV4QXIxZisrS0ZvcVV6d2s5?=
 =?utf-8?B?elVBMDRnK2U0RW5OU1ZpVE9RR0FDMUUwaWV3SEFOcDZqTmxvUmN5aW5hSTRn?=
 =?utf-8?B?NENaa0tIOG1tNFNaNWJ2U1RRdDhCSnlFd1Q0bkswcjVQZFBibEoxT2ZURWJv?=
 =?utf-8?B?RmFFUG1hRnV6S3owTkVqRmgvWWIrRmxrYkdrNU5iTHc0VDh1Ri9oYUExbFFB?=
 =?utf-8?B?RTNUcXJOOUN5QVNPRHZnUFJmS1RpOThaY1h6b09aeWpvbHQzblVTbWMrMVlB?=
 =?utf-8?B?OHNhNWo4RnVzak80c1FMUTJDbDQwcjRxVjZ3ZStDZC9UTDRmSWthME9ENFF0?=
 =?utf-8?B?Y1JPWVAremoySFFBMUxoenlFVmd0SWVoVGo4Wnp1MVU0R3U0VWh4RXJhaVly?=
 =?utf-8?B?NTY5b3Y1RzE0bHRXRi9PQUhwWG02TmdpTVdsVzJaVUdDR3IzcE1GUjQ0T2Mr?=
 =?utf-8?B?YWw4cDhtam5yTHNaTUtidHozTjZSQXQ1MkN4TXYzSUFVZGNlME5VQWZtL0dF?=
 =?utf-8?B?bEFkU2NLeFRBcDBzWXlTYXY0ZHFVbEhWS0JuQ2pXNUhGSEpwSkkwZzlrQmVU?=
 =?utf-8?B?WjcrSlFtSDEweGVrMEtaNDVFUlR4OUw4ZHRObkoyUzc1RzhHSml0SE5lcytl?=
 =?utf-8?B?cDFkRmJXM1ovakNweUNpNWtzK1lhQ205TjR5bHluYVJ1Vng3ellidVJPcU91?=
 =?utf-8?Q?DtZw17TWNzoWC5nEL5f8Bf0sRV6a7LRRMqE6IA/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2c7768-a512-4fcf-a69f-08d926faf37a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 01:49:12.0078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1CwEogCqehyqD0GR7MtzrWrE8iuWyxyTvNicDZl0JshfgZWaeKkaK0uh634HhEXU4BX00PS3yqYIbe5np2J/n4g0fvGK4TQx1LBV4vnT5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4384
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040011
X-Proofpoint-GUID: x5WmnGmBkAhpLuhBekWwk9rG35LzaNYM
X-Proofpoint-ORIG-GUID: x5WmnGmBkAhpLuhBekWwk9rG35LzaNYM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/3/21 7:27 PM, Anchal Agarwal wrote:
> On Thu, Jun 03, 2021 at 04:11:46PM -0400, Boris Ostrovsky wrote:
>
>> But if KASLR is on then this comparison not failing should cause xen_vcpu pointer in the loaded image to become bogus because xen_vcpu is now registered for a different xen_vcpu_info address during boot.
>>
> The reason for that I think is once you jump into the image that information is
> getting lost. But there is  some residue somewhere that's causing the resume to
> fail. I haven't been able to pinpoint the exact field value that may be causing
> that issue.


xen_vcpu now points to address which is not where the hypervisor thinks vcpu_info should be.


> Correct me if I am wrong here, but even if hypothetically I put a hack to tell the kernel
> somehow re-register vcpu it won't pass because there is no hypercall to
> unregister it in first place? 


Right. You will be shown the door in map_vcpu_info():

       if ( !mfn_eq(v->vcpu_info_mfn, INVALID_MFN) )
           return -EINVAL;


> Can the resumed kernel use the new values in that
> case [Now this is me just throwing wild guesses!!]


I don't think so --- hypervisor is now pointing to a random location in your image.


-boris



