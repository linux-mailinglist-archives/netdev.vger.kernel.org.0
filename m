Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755DD3243B7
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 19:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhBXSZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:25:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33476 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhBXSZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 13:25:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OIEk5F004355;
        Wed, 24 Feb 2021 18:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lsJ4lFDNojE98d6dfL68DHzOJ6gtdU8Akm+nWaXMxX0=;
 b=ogumHI9SKP2vwZuN9Tn94k95KKki3VHrjjnB8yFt6Ep71C1OT8yxb+HplCSVaCjHuS50
 2tsj8SBaCCE6oHReclH+uZKXBhvfQyE5FVzPjJofbtkQQV6WzmRFFMUzWZBIgLo0kxCx
 n+zRC/EXxXKahQ6BwIDggjVDhIHrood8Euju6inEbTQYAyTF0AzazSZr2v/9216ytXYI
 PcIwdtdR/C+J0xKntJxlraUFgLRQkVAKiw6/ZiwFKFxq3PF3NWPPW+LJfM70MuMZOLOb
 eLV0cOKO11+pasCVlbqM/u/tNeK9hA9tLLIoh+K9gZkarRFKjraeOqwDoNxi47bEI+wv zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36ttcmbwx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 18:24:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OIAYbo050742;
        Wed, 24 Feb 2021 18:24:47 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2058.outbound.protection.outlook.com [104.47.37.58])
        by userp3030.oracle.com with ESMTP id 36ucc07cee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 18:24:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw0RLQ5VXbaVOIKE3RtDCmD9wOXWYDmcPe6F9M1WRQNSw0e644gqZ3e+Nszlc2zeFjRJQAa7/6JvqExZNapwvNdAu0ceY09RDxILmA99Ev37uS21W4J/h42kQU2LHxJZX/67DHoUr872AGO3gP4bW0o3BR6Jr9qYr7PaBN9n2PIvoG5TngZCfRxNzs8NUTgYg2cA7sFNQg3RFS12ZKp7cIxbrr/6AOOlLT2v9AiZJQZaz18QxIhKz57vtsRv1jT1eNHYOKWaNDOsyUpurKhFdNZOf1od3tmU/jQT6kBs+cNH719nj0k3xWyryUMA3hgnuUGhkbZRzLxwydG5OFxJdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsJ4lFDNojE98d6dfL68DHzOJ6gtdU8Akm+nWaXMxX0=;
 b=Kay0o1fsooLTtxsN2K6weC4HwRyygmS57+t8/5j4HADN5LBPbx2aIXJXEC2f5pIv6SXxwLdWPa0rkfc4l7XgKwwfJ1H8url+Yqsi2bx7pNOezHqHvtaaYif3/F1bxr23JxXnMEkajmbwXXft46KeBrcgHtoOxUmi1Xm6hE43ZO5Jt7RmzHW2IIF+bN2l37Y7NULCYw9hIog+SuO1HP9WNYC4XJEsL4HomvsJqIj0edeo8SsaGitA6XaqnWyKofstdvdWYbhl+88tEI7iHhJSWXtG9qXzWW3tD+a/d1hpmUh7j7Icv/B8GRRJBsNfmHWgf5Bs7A/sHoRHDf7xMwmd9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsJ4lFDNojE98d6dfL68DHzOJ6gtdU8Akm+nWaXMxX0=;
 b=i3RqpYJLWnTZ4WxPw+k2Xg/BvKwhi+M6Vhq/Cp+U5ofoIz+jszLnb2cJZ9vx7LkwaSlIwiOEpxwYI4cMqk/kRN11l3JfEps90PdIXbUmMATqQo6dB92BlLK8r+GYP4MRFUc5gTZ7l3pxRVkzB+xZZf+dIdIfW/nu7wH57a00W3Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4543.namprd10.prod.outlook.com (2603:10b6:a03:2d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 24 Feb
 2021 18:24:45 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 18:24:44 +0000
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
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
Date:   Wed, 24 Feb 2021 10:24:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210224000057-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [24.6.170.153]
X-ClientProxiedBy: BYAPR11CA0086.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::27) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (24.6.170.153) by BYAPR11CA0086.namprd11.prod.outlook.com (2603:10b6:a03:f4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 18:24:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9773255c-1259-4f01-0e4a-08d8d8f1756c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4543:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4543FFDD5B0376A6B80DD20AB19F9@SJ0PR10MB4543.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 88+Z3gsGFzoRx3yPbdDhYNWlMRx8zlABgRKZaH2Wp5GnbjXejONOiQ+sTzS32E8vgeY/Q5DGJxHDPQtROTXUag3cPx2PMpOcxlr+VisrRxH9hWMNoW11Fun5mE8Ug6NjdAqzVIFC0aGET6Q/qdj6eMtWm0VckBpHKUhhCadIFOODKHCrZjKX/X80niAVN0poymHxnNhpJOIqAbWBUoMYPOzo2unbUG4FbeZAcqqArWzHl4e3Da3DGmgwYo6y6vWlOaH71nK7tUgZz7E57fYBCVldzgTu0/LzNDtNaflOiQHCXtMAJGmkZZ3ERHXrAGJ0cLqa8wIbONzFxeqSPsQ+XXSOM9nh7frCVIDgliWkJtCnRRMUZEqDm7kFxMyJlNYSJp6TDahgwScu7UsNCCeWete9PZnvfhumYr/CZyHDR4bMowp/bjmkgTcf7X5kpu/SEpioUqiirmGheJPZONEwmR+U3yeRM/0UXjwCoz2e2qhCrqofXdFtw7f7K9z9wrAIDWHiUQgbXBcVfw4HqURf80/Tud8j6Eajlk3R6H9mvEExmVXzMvdlG8/5WXrxpwK29hAjw909Yc6fhwedY8E5x/0BjAYsWcZE9zRf8XLfyk8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(66946007)(66476007)(8676002)(8936002)(6916009)(5660300002)(66556008)(4326008)(83380400001)(36916002)(53546011)(16576012)(26005)(2906002)(16526019)(478600001)(186003)(956004)(2616005)(316002)(31696002)(36756003)(6486002)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVZNYS9maFFacTRpTEhHdGhJZUJNVXViWGlXNGt4Z1V1cGVmMWFIR0VzYmFC?=
 =?utf-8?B?MWZhcmx3Z2ZjNnJXOUdjMWN2U2JkejFLYXRaNUN5eVhQbUZWT2hqcjlQT0Mv?=
 =?utf-8?B?Y0JnTVZJREZBVks5U3g5TlNSRjU0OXdpUlpZQ2VOQ05XQVUrQjIzVi90bjJW?=
 =?utf-8?B?MWRlbW1LNktNV2pxYW1Bb3JCb1FYV1dvNEFSVHN6ZTRmeVQxL3NjNHBsUWk0?=
 =?utf-8?B?U3BaWXlGT1pPRmZYcTg2aCt1cjh0ODh4R2xuTW9CZUpQYzB3QzRPeERKbldR?=
 =?utf-8?B?a1ppaFNvMmE5d0hNL05WbE9taHBXWnJuN3JJMnJWOU9oR21pUFF1Sy9sRStB?=
 =?utf-8?B?cjE2T2txRHQvcTQ1eDYyWVRoYnVsWEZ4WHpvcVpVVzhIWTdLR0hDVTZCNUg3?=
 =?utf-8?B?TzJUNXlDRTRzZWJpQTdydjd6M1YwcjF1aURwS0hhQUFjalVZNE1UcWltUG1r?=
 =?utf-8?B?Z0pzVFluUUpJNWdUcDJkY3l6ZG5WZlBPRGFESGJsNGpJZ3djUlVlTWNJNzU1?=
 =?utf-8?B?bllmcWY1aGl5REFLcW00dCtwL2RQSVBoSHBVUGRlaCttbFMxYUtEaUVyNndm?=
 =?utf-8?B?VDczSDhnN0xwYXlXU3NyVnFPL3FLdDlHWXVNUE1RckF0WU9xb3lyODVpa1p0?=
 =?utf-8?B?R1lBMUNOdEZ2TTVtbVZrUHRhcGt2RE00WU1ra3NiRCtsQ0RySDN2MzQ5eXdJ?=
 =?utf-8?B?Zmp1VzJaKzFRYjg3Y0RlTnY4MjlBandvTFBIa3hHeFB5WEVnV2NNMlVPMFBm?=
 =?utf-8?B?WWlJU2lMOURVdkVVZWZNK09sQm53RWgxV2dZRXNmZVY1QVRGb1MwU3lvaGdR?=
 =?utf-8?B?b1l4ZnNweldUaDlXakxWcXBtcjdKRFlpanNzMS9hVnd2eUcvK0NNZk5vQnNE?=
 =?utf-8?B?dDBPRDIwQUtUYkF0dW1UWFY1bkNsazhRZ3dkZzRjRlk5Z081QnN4bmk5OTJZ?=
 =?utf-8?B?akJXN0pOT3BLRkdxOHVnakhtTjJOWHpxeFVUV2IvZkhkUGVQMXlQL09KSTBU?=
 =?utf-8?B?NkJrOUlvK1BpVUhZYWdjNTJlc21Tb2UwbUVpZ2xwRno3b0RSbGp6V1pIUkJK?=
 =?utf-8?B?MnJzMVBhMVdoVGpNNFo0c2sxRlJCM1B2QkJQUXhlUzVGV0ZmUUZaMEwxTit0?=
 =?utf-8?B?Rk1ZT1l3VDVPaTZiZFVRS0ZOMkhWYXNicDNXZnhPdzQzZUJXQ2JhZWZEbnpl?=
 =?utf-8?B?SXBud2wrYlhVMEhwVkFNcFBmN3IvQlpDbUczdllQZkJhc1R1MUk0VTZnMUJN?=
 =?utf-8?B?ZVJTSkQ3RXl2YnZwbWJRN1BoU2ZhRnduSmQycStvRUl4TGthZmNZakNKTXcw?=
 =?utf-8?B?emxHZ3RSMlo4bFV5bXEvVEliWmJLZ09rRDZ6c2M3Ty9JbzhnanlWNUNBSEhQ?=
 =?utf-8?B?Yzk3b0lGM2cweUxuaUZ6eDNsZzlVTUc4U0xqZ3JBem8wSHljQUFaR3dxMEJs?=
 =?utf-8?B?eFlDaGpyTS9yZ3dqZnMyeGFEQ1haZjhEbmIxYk5ManFSWlE2ZHZJS3k0eHZo?=
 =?utf-8?B?aHFmcXBTN0lsMDI1eFZIb3Q5K0Z0RnZzc2VpbWFienN4RSsvODNvQ1lnSlIw?=
 =?utf-8?B?cFltTUx6NjRQRDhMQktTK2EzbkMvWW9VTGlaamhROTdURU0vME1LSDRKNnRP?=
 =?utf-8?B?VEx2ZFZHWWlCKzJyZWNBYTlOYm1LK0h4MWRzQ2JLUzZvZGtxMVhpM1FLaXIw?=
 =?utf-8?B?Zy9qKzNkTENscklQVTFSMkZZWWlieUJRbHRROXVLQ0t3NDN2clo1UDlBWVFC?=
 =?utf-8?Q?VmVaRk5dUrS+i1pHrfgCIZKkD51SqGtf0pZmes1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9773255c-1259-4f01-0e4a-08d8d8f1756c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 18:24:44.2888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iq754Bt8owMX7osWi+lfFkU32mcRnJ6Qdv5t2uDv8fOAd34eaRpbtDZhxFgDaGrKe/6Hv8TAPzv4EMwCWfR4ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4543
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240141
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/2021 9:04 PM, Michael S. Tsirkin wrote:
> On Tue, Feb 23, 2021 at 11:35:57AM -0800, Si-Wei Liu wrote:
>>
>> On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
>>> On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
>>>> On 2021/2/23 9:12 上午, Si-Wei Liu wrote:
>>>>> On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
>>>>>> On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
>>>>>>> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
>>>>>>>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>>>>>>>> for legacy") made an exception for legacy guests to reset
>>>>>>>> features to 0, when config space is accessed before features
>>>>>>>> are set. We should relieve the verify_min_features() check
>>>>>>>> and allow features reset to 0 for this case.
>>>>>>>>
>>>>>>>> It's worth noting that not just legacy guests could access
>>>>>>>> config space before features are set. For instance, when
>>>>>>>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>>>>>>>> will try to access and validate the MTU present in the config
>>>>>>>> space before virtio features are set.
>>>>>>> This looks like a spec violation:
>>>>>>>
>>>>>>> "
>>>>>>>
>>>>>>> The following driver-read-only field, mtu only exists if
>>>>>>> VIRTIO_NET_F_MTU is
>>>>>>> set.
>>>>>>> This field specifies the maximum MTU for the driver to use.
>>>>>>> "
>>>>>>>
>>>>>>> Do we really want to workaround this?
>>>>>>>
>>>>>>> Thanks
>>>>>> And also:
>>>>>>
>>>>>> The driver MUST follow this sequence to initialize a device:
>>>>>> 1. Reset the device.
>>>>>> 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
>>>>>> 3. Set the DRIVER status bit: the guest OS knows how to drive the
>>>>>> device.
>>>>>> 4. Read device feature bits, and write the subset of feature bits
>>>>>> understood by the OS and driver to the
>>>>>> device. During this step the driver MAY read (but MUST NOT write)
>>>>>> the device-specific configuration
>>>>>> fields to check that it can support the device before accepting it.
>>>>>> 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new
>>>>>> feature bits after this step.
>>>>>> 6. Re-read device status to ensure the FEATURES_OK bit is still set:
>>>>>> otherwise, the device does not
>>>>>> support our subset of features and the device is unusable.
>>>>>> 7. Perform device-specific setup, including discovery of virtqueues
>>>>>> for the device, optional per-bus setup,
>>>>>> reading and possibly writing the device’s virtio configuration
>>>>>> space, and population of virtqueues.
>>>>>> 8. Set the DRIVER_OK status bit. At this point the device is “live”.
>>>>>>
>>>>>>
>>>>>> so accessing config space before FEATURES_OK is a spec violation, right?
>>>>> It is, but it's not relevant to what this commit tries to address. I
>>>>> thought the legacy guest still needs to be supported.
>>>>>
>>>>> Having said, a separate patch has to be posted to fix the guest driver
>>>>> issue where this discrepancy is introduced to virtnet_validate() (since
>>>>> commit fe36cbe067). But it's not technically related to this patch.
>>>>>
>>>>> -Siwei
>>>> I think it's a bug to read config space in validate, we should move it to
>>>> virtnet_probe().
>>>>
>>>> Thanks
>>> I take it back, reading but not writing seems to be explicitly allowed by spec.
>>> So our way to detect a legacy guest is bogus, need to think what is
>>> the best way to handle this.
>> Then maybe revert commit fe36cbe067 and friends, and have QEMU detect legacy
>> guest? Supposedly only config space write access needs to be guarded before
>> setting FEATURES_OK.
>>
>> -Siwie
> Detecting it isn't enough though, we will need a new ioctl to notify
> the kernel that it's a legacy guest. Ugh :(
Well, although I think adding an ioctl is doable, may I know what the 
use case there will be for kernel to leverage such info directly? Is 
there a case QEMU can't do with dedicate ioctls later if there's indeed 
differentiation (legacy v.s. modern) needed?

One of the reason I asked is if this ioctl becomes a mandate for 
vhost-vdpa kernel. QEMU would reject initialize vhost-vdpa if doesn't 
see this ioctl coming?

If it's optional, suppose the kernel may need it only when it becomes 
necessary?

Thanks,
-Siwei


>
>
>>>>>>>> Rejecting reset to 0
>>>>>>>> prematurely causes correct MTU and link status unable to load
>>>>>>>> for the very first config space access, rendering issues like
>>>>>>>> guest showing inaccurate MTU value, or failure to reject
>>>>>>>> out-of-range MTU.
>>>>>>>>
>>>>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for
>>>>>>>> supported mlx5 devices")
>>>>>>>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>>>>>>> ---
>>>>>>>>      drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>>>>>>>>      1 file changed, 1 insertion(+), 14 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>> index 7c1f789..540dd67 100644
>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>> @@ -1490,14 +1490,6 @@ static u64
>>>>>>>> mlx5_vdpa_get_features(struct vdpa_device *vdev)
>>>>>>>>          return mvdev->mlx_features;
>>>>>>>>      }
>>>>>>>> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev,
>>>>>>>> u64 features)
>>>>>>>> -{
>>>>>>>> -    if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>>>>>>>> -        return -EOPNOTSUPP;
>>>>>>>> -
>>>>>>>> -    return 0;
>>>>>>>> -}
>>>>>>>> -
>>>>>>>>      static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>>>>>>>>      {
>>>>>>>>          int err;
>>>>>>>> @@ -1558,18 +1550,13 @@ static int
>>>>>>>> mlx5_vdpa_set_features(struct vdpa_device *vdev, u64
>>>>>>>> features)
>>>>>>>>      {
>>>>>>>>          struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>>>>>>>          struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>>>>>>> -    int err;
>>>>>>>>          print_features(mvdev, features, true);
>>>>>>>> -    err = verify_min_features(mvdev, features);
>>>>>>>> -    if (err)
>>>>>>>> -        return err;
>>>>>>>> -
>>>>>>>>          ndev->mvdev.actual_features = features &
>>>>>>>> ndev->mvdev.mlx_features;
>>>>>>>>          ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>>>>>>>>          ndev->config.status |= cpu_to_mlx5vdpa16(mvdev,
>>>>>>>> VIRTIO_NET_S_LINK_UP);
>>>>>>>> -    return err;
>>>>>>>> +    return 0;
>>>>>>>>      }
>>>>>>>>      static void mlx5_vdpa_set_config_cb(struct vdpa_device
>>>>>>>> *vdev, struct vdpa_callback *cb)

