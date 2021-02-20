Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6610132035A
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 04:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBTDA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 22:00:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhBTDAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 22:00:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11K2sH8D150714;
        Sat, 20 Feb 2021 03:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=A5u266oI/uUdkzBxXIyf4XBc/xf9ru9+6iIowUB+yic=;
 b=uyXK08GW2PogoTmJFa1cAzN+VR7Xv1vVcBvC24jTYSsuVICB8krTEHxX4x0W5Hz7ccum
 Bz4fNIOD2MrbBE3K1Jr1XbVOK3lMoXeLn2isVXM5/3+lZwjNabmGdiPhgPn0OjvoFXnS
 z2x0KiQ9/ReF7Hk6h3LhC9OxIAVpO8VRGflN4GGLuSBUC9EXckMBF3Jh728URvD4a0VY
 oBAcAKgoUTo2jx/wKg5Oozv0w64bNMIUGp74skMUhScRx0q//G+knRLX7T37gAKRRtGn
 ingePfp348i48jmHd4FouJvcDBGU4ZFcjucwQ2xoh/p+nkcDdyM3reXLv9F1VR0lYc5u Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36p7dnu5n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Feb 2021 03:00:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11K2uXtn083040;
        Sat, 20 Feb 2021 03:00:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3030.oracle.com with ESMTP id 36trf99t9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Feb 2021 03:00:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZutfACWzevJOxiaG7gsEIGmsck384lluByKMVsHh8O6Mfy0MZ+Ye6ffNEw1ru6xy5m8o18LtTj2el5wtGg06OF7PffCCgYgxLXDm5iG1AN63tKqRtXpAYt/iUd3sobcyRks6u4j1QMMMnsDyQvtLqHP/6NZ96Nbb8lzojzwLXs6dIJkHEA2j9dqL/OMevFvCfSGamfq9bFiKM8yyceYn4qjmm1Gc37Nx6TtsLA915a3D6N4rua70alQQIxqosUzwirtXdbTEL7k9a1raPju7jwGh66J0dz4upmnugJt4OKPZ3L/QvXLHynmRAUM4G3LiaK5DyGgiSW0CVu0pEjl2WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5u266oI/uUdkzBxXIyf4XBc/xf9ru9+6iIowUB+yic=;
 b=UwQmZYSSxHwZPA0VyTDSmJlRcnw8N7yqo3+QLNX3Qy5O2hoFxP6Ke/T41QqG6TwLc8DbHdM673gP3T5uAO0sL5S3DkhovH4sFBBHwRselcP5a0y+0KMRb0sAv+9iGvf5XNa1FqiQmFB2iYrCaqmSddM2c3w+WhcAFGy9OXjN1gwZ2yiGnPv8icYoxGKEYqmLbkOedHvCi9Q3ZWXp/W1as6mBD1zOyIeu3v7mKsLodap9fm3zDE8Juqoqa7nVrXW55wFVP5dP9fr8GlWec8qzuQ0wUf9dVCfoYaz7/j7TkBckbHt++z9DanCQZ8DYaxml0sr3Se0JKkyRHvvv2lLSSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5u266oI/uUdkzBxXIyf4XBc/xf9ru9+6iIowUB+yic=;
 b=gXVqHIapiEic4fTQIh5BKHcR7LDoqXfjgRT/aS5yw3qMu3V54+Yp7kS4bCeKisZNAu1nSGy7tM+WL7ED2GsqusJW6iRdZQAgVL/RyDVRZIo7JIWtMTH6BU4mxWAw93z1DvnX4IATxyEPGzPYlmpj/OCwJWlIqkeVpqqBNLh6Xc8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB3843.namprd10.prod.outlook.com (2603:10b6:a03:1fa::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Sat, 20 Feb
 2021 03:00:02 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3868.029; Sat, 20 Feb 2021
 03:00:02 +0000
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com
References: <20210204073618.36336-1-elic@nvidia.com>
 <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
 <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
 <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
 <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
 <a90dd931-43cc-e080-5886-064deb972b11@oracle.com>
 <b749313c-3a44-f6b2-f9b8-3aefa2c2d72c@redhat.com>
 <24d383db-e65c-82ff-9948-58ead3fc502b@oracle.com>
 <740b4f73-c668-5e0e-5af2-ebea7528d7a2@redhat.com>
 <9243c03b-8490-523c-2b78-928d1bcb0ddd@oracle.com>
 <b2d18964-8cd6-6bb1-1995-5b966207046d@redhat.com>
 <5cf5e0ad-efbb-dc37-8054-5c46722b87df@oracle.com>
 <2330af63-02e2-77fe-255b-c55f01292e80@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <c3760a4c-5047-8a03-2935-0b9b5a682dbb@oracle.com>
Date:   Fri, 19 Feb 2021 19:00:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <2330af63-02e2-77fe-255b-c55f01292e80@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34)
 To BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Sat, 20 Feb 2021 03:00:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13351751-d9ae-42bd-da13-08d8d54b9e1d
X-MS-TrafficTypeDiagnostic: BY5PR10MB3843:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3843FA5A813B2B2F76422C13B1839@BY5PR10MB3843.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebeotKO/Yn1ZyP1Uw9s1mC/9pCylSIswpyJf4KwSPQBGq2e0WAl6JzSeP+F550Uomsmn72Aec11SuiSF5ykUqg+51uIKWTE6PymZS8gWhg3l0+xt6DkuAkGe9flYUbB6Uc0W6tPOAS0LlcIfloTi9w8APEhFygSHmY90A51RBU+maw8bqJ76oSopTrqv1ybzzm3Jg4qh9z7/FoTzLe5r+t+LVFTUCW8jro+89aPiQtJELwVD4uEidtPDRDBtN+TN3a40ugsfsgzswodIuoyfgYsK1c62f9lvY9kaJk3KHIrEropaQzCAQOFYT6WAZgNJeDTesbGtlybF92gIqyIrJtX+a1OCoqJdR3BYpJ1MyLq54QNWTxYf890BlgzUmobaTohLyI73LYCJ195Opld1oPBzhXCtIoJ+SNvU2rwZ5FJlLuEscqen8Gmxb6g6bUWLGjTSTOtR2wLIR1E3D4zW1e0c2NxmKkyYDbDPoAfz4b7c0yPJijWTzZSyWZa9L9PcNuqmR4e/0vkBykax51vUIZxabO7OxxEqFgceOZztt5aI9Uv1rkbhBm7lsI1Co6nU3lMEk+vkcFfccM+c5O0Vo7Bio9oMflOB5u++KCtVY3uI1nGU1fME/oPPDnZm33m9Cuabco2udn+TkIHUvVYPgdB/cI7y7EcaCZAuvC4tvg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(396003)(136003)(36756003)(4744005)(8676002)(66476007)(2616005)(31686004)(186003)(966005)(4326008)(956004)(86362001)(66946007)(5660300002)(26005)(16526019)(8936002)(2906002)(478600001)(66556008)(316002)(36916002)(110136005)(6486002)(31696002)(53546011)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N3JhYWloa2lPUXQzL1gybnRuSmpnSHMybmw3b1RiZ2h6TFVlK3dPeDQrZlNO?=
 =?utf-8?B?RFRrek5vbWRTQS9Cb0hKR1VzYUNybFlzS2I2RjNUZlJ4Wkl6QlZYT0llNDcr?=
 =?utf-8?B?WmFqUmZNdmwyc0FweklpNmVVRis1ZDk4c2ZGYmhPWW83L2hvVG5tSm42Nnl0?=
 =?utf-8?B?VjBIaFp3NFZpTVU4UkVaWC9lSyszekZiZVk1UnlIM3pqRTBDZUgvS0s1WWtr?=
 =?utf-8?B?c0hkcEJMMEx6TVltQkJ0OVdpVWJ1Rktibm0rckhiVkhUOW1PZFR5TCtJelA5?=
 =?utf-8?B?ZUI3QTRyTzlFOEwrRTAyWHdTRXI0ZC9pb3hDOWc0SW1GdVV1aFl0SnBNSzlO?=
 =?utf-8?B?QnBpSGgrTDFNeXo2NFlMeWZCNHZUbURoeUVYbjJFTTc4QjVCcVlIbXRiTFoz?=
 =?utf-8?B?MUN3RDVxYXY5NTFFdnZhYTdacVM4bDJoWWs0K0NVN2pvUDhpSzJ0bjgySE1M?=
 =?utf-8?B?ZFZkaHNWaldIblVGWVFUR3Qwc3hmWEVFa05XODV5SnJNek9OS3J5dHdyNnNL?=
 =?utf-8?B?VEJCZHhkM3hhQjBaSHBhSTZlTktlandHTzBUcjE1LzB0R1V1UThjU0lwNUpj?=
 =?utf-8?B?cVNjcVlpblFlUzB2eHkxQkdtdTh6SFozSTVhb1JNbS9saDY1YUFUQkZrZFUw?=
 =?utf-8?B?VENFZG9hdEprOFM2ckVnQ3ozNXNCZWNib0ZSellIdmttTXpydmV0VDZaRE52?=
 =?utf-8?B?VmJXa2cwWGM0eldBOFc0R0ttNWt1T3ZuWk95NUovNG9aK3JQOFI2SlZRTVkv?=
 =?utf-8?B?TUFINzhnMFdEQ0t2RVpiNXhBaUFadlBLOUoyNGg4RkNuMWNzZlR2dkE5M2pI?=
 =?utf-8?B?TkhCUUI2OXg3TFRwT3lZZktnaGRxMTMyZWs1SXdsN3BLNHpuTEJ6d1JvaGYx?=
 =?utf-8?B?TFdYN0Y4Zy9mdjBXNm1LWGNzY294a1psU0FIU2I2eCtpYzdFNkZsWDVUZVNa?=
 =?utf-8?B?ZnIwMVAzY0FvRFBqRUxBaUxwdjUyaDF4UFB5NHFWWmpUaE03MUJBeU1WMS9G?=
 =?utf-8?B?WThSK2NOdU9VU3MvZkVDNWdHTE1OWW15ZlVoMWduNDUyQjRLVGF6VjBNMkZR?=
 =?utf-8?B?QmhNK0NET0lYd29sc2liTW9Zb1FSR09QWVplOEZTcXA3R0NIT0JtSHkxa1F5?=
 =?utf-8?B?dm1vZGpmSXk3L24wUUhQTjJSNGRzMVlSWjlYQVZYMFExenNwR09kd2xvT3Jr?=
 =?utf-8?B?c0hjcTBoeVBNVXl1MlNZY1h6ZXFBUlhid2xkZ29takZXVEx0YW1xU0QrdTRi?=
 =?utf-8?B?eHBaQ01HbTNGRW44RjY0QmJHQlU1VlVNRHExSUgyeENmd2ZCSG9OM2lERnQ4?=
 =?utf-8?B?ZWNZOEFQRm5YVk01VHBVOWc4YktnVncvSzl2SXZaai92RmZlYVZBNWFQaE9K?=
 =?utf-8?B?amJRQjIvZG40TmVhbzZYUUhtN3VUQkpJZmpQWmkvV2VrTTVBR0kxWUpSWmhJ?=
 =?utf-8?B?ZG1jOCtzMEFrWjN2Z3JKVjJPeFhGL0JkOXc5L0V0SGMydHBpS0JkU1I2Y2Uw?=
 =?utf-8?B?eFgvUEJhSkJXS2g2cVVlTUhBMjFWTkVNNWtISkloVWNrRzd1ZG5EYzJoaU9q?=
 =?utf-8?B?MmRuVHk1Zmw3TkZSQjBhM2VJdlAyMUZ6SXl0Q094ZkhNMzFUZGdPdVpQTG0y?=
 =?utf-8?B?SjNGcjJYOEpkcnNpeksxVC9QVUpQd2lKSTdWdUlRbEhyckFDcVB1MXJmVEdZ?=
 =?utf-8?B?cnhncE4veEllQnAyQjVqT1FmdzI0WHhZOThRN1pMYXlGVmphOFI1OXRsMU5M?=
 =?utf-8?Q?HToiTnCMKEFBQ4QALyqLkXHEr4tY1NfsV1PqJEP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13351751-d9ae-42bd-da13-08d8d54b9e1d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2021 03:00:02.6634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1X2NJuG2gnl6+WcxFPPapLqV+SeOGgIysifQAJLNRTZocTPMtXO3JeE3o6DqSMo7tait/JpeDgzxJGsQdil+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3843
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102200024
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102200024
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/2021 6:38 PM, Jason Wang wrote:
>>>
>>>
>>> Right now the value is exposed to userspace via GET_VRING_BASE, so 
>>> only last_avail_idx is synced. If we need sync last_used_idx, we 
>>> should also sync pending indices which requires more thoughts.
>> Technically it doesn't sound right - crossing the boundary a bit even 
>> with simplified form of assumption. But depending on how userspace 
>> could make use of this API, it doesn't seem it breaks existing 
>> functionality for the moment.
>
>
> I don't get here, maybe you can explain a little bit more? 
Please refer to the email I just sent.

https://lore.kernel.org/lkml/033b0806-4037-5755-a1fa-91dbb58bab2e@oracle.com/

-Siwei
