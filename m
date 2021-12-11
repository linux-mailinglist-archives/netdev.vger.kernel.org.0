Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8436E470FF7
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 02:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhLKBsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 20:48:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19006 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhLKBsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 20:48:03 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BANhcqt030122;
        Sat, 11 Dec 2021 01:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HtYjb7iEoPXU7AC3EhbGr4vY+eZDX+/EM7gz8SV707Y=;
 b=UrTOW8Ck2mMYNOXUb7Rvg4rFBC/VCPT7gFCbsdCoMPTtiesG4DFK9QNKIcrjYXBoigCH
 6Em1vwoBIKm7zO008AdSSBSMiPk98ZTNiCQZ1CPc6y8tiNnZbSjO5HGsnWabj4nH9+NW
 rpQJZyIXgmlxOWtcq1OAWcU+MWe4bARGxolezu0mjd6YRwgTJsCYWIQm2HfnTbdUYBNr
 R8k4aTkjaUvbbWsUCHz8XzBzd7CqlCFwN2g9ChVg40H4gbBZa+PHX+TwGcdiXRZmOEbt
 dJogrmkXCfWlXCQzGKZuc65hn3ZLUme03EK28qLlOC1iR2qWh7uD+DvaSfYoti2AZHs6 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cve1ugbsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Dec 2021 01:44:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BB1fMdl046741;
        Sat, 11 Dec 2021 01:44:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 3cvh3sbwyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Dec 2021 01:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNL0nWjXtP0dSzxC1VrszlVfsNSpK1WyjgzJd1YhMLL64Wwy9NyfdBIdeaKA1ff7wf1vLkqz5oKoTkcVnvvR4sIBjMDs2cDpEf2NanAycFGseb7cAHId7vEiBFOtofHjF07a7kAU0DbXsxC/Sc5ByLU1aoFeJi3X2ul/2eZbp45WRpEvKiI4QheANHR1QaKkYVHR8BrCBAjtcKLfGnZF2c3rcsArtX0Sqh5oz5i9pD51BAcorJ34omL6L/vRdwl2+cTve3LyezpW9LmLvlyQCJ0TASarlByNPC0pi5DVg4YyGscCUOZRo+OtPmq31UXh/w0I5UKqKP9rPxsctuM5OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtYjb7iEoPXU7AC3EhbGr4vY+eZDX+/EM7gz8SV707Y=;
 b=CRE9F2EfuJOeGplqUjwgsBr1ZVtp7FOJCc5VdX9BhzOZftCquUg+PU8t1RISB/xZc7sC0dFpWtGuSOGRZjf/XXEAdFRqPGCTNvl8evBmEjSbDigWIVdg8tSRTHiroSS3cC20kmke1l31+8vVRN2wfPbfOVWKlHg2hF8SHkSF1S54PyWLg75DzxJC0EWEYwpD7CkRaiObL242BQW/NSL6JmFiTr/rfqKS4GVJ1t6m6u86dNTDCwUE3mLrd+GHCGoaMCaDrpcW4yBSlMstx0OwT3Hzp8y0T5jYMlpl724nzXWaFs6NaAnxqAT7keiGruhp87lQ4Xt82VUNJOnDV0vuBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtYjb7iEoPXU7AC3EhbGr4vY+eZDX+/EM7gz8SV707Y=;
 b=YdOK9UVUm9oSozc21JgFEN36sqKMg04cvBnqXNohv7keSegptbW/O2buVPeBgti73Ur5+79OcglU/0eZmxOIu7MO48Ya60ic1w92XQ0ExO36yc1wTRNy0hptoufze787/8BCnZmJ7EBm6WXWrknIog7sOVbxThtvIDMfP9QqGdQ=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB3748.namprd10.prod.outlook.com (2603:10b6:a03:1b6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Sat, 11 Dec
 2021 01:44:19 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4755.025; Sat, 11 Dec 2021
 01:44:19 +0000
Message-ID: <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
Date:   Fri, 10 Dec 2021 17:44:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5: set_features
 should allow reset to zero)
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     elic@nvidia.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0034.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::47) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
Received: from [10.65.153.25] (138.3.200.25) by BYAPR06CA0034.namprd06.prod.outlook.com (2603:10b6:a03:d4::47) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Sat, 11 Dec 2021 01:44:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f37eda3-95d7-496e-54cc-08d9bc47bf97
X-MS-TrafficTypeDiagnostic: BY5PR10MB3748:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3748AE3B120261213FE8F677B1729@BY5PR10MB3748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hj19dnd7MIAJSw6MovH7qZ1WLaHVWgkC14uXPWf6ryBAEzlmrsivLUyUP8es7p6lyTGvSFg+MN1+OYBvpgBDBgG7dh5yHmo/Z6d7MIjEiBI4RB6NaeF+6mm+wDUodq2Ud9TeMjwgCiuZhi6kGWoHGYWB95rqa8pDcYsMx/3ZvkcH6RACvBnY2oUVqsPqCrf4+HQgorlqTMyzq/ytoKtVqQ+EK/RiWcmdGYnE9s/5fkW0h6R4FJNyu8N/EqjLZy8gviZoaNzk9KVEBRATjLazBZ4XJqoiNkJoGDN02IuDB5HKDPUAxsECwZFyXRvh2TrBDttVJ1CR0NqUVYpvEU+ga95iU6WGQmY7qF8zaarf3PpVmcNTCiAFXQBGWjz4v03fTjZtL2sv/r/oFW4fECXPCgpAjc04Ky8V3/Ob58ImwjTNBXTV4kDDjDjg0M+NxY4rK3Wy4eDm5rqNfcusqjdROFiD8F83aBAIQcSJid1RHb7jcIwooY/8vPm9Zo0MSlnVrdTwW0egWg357i8PTzAcJ2rlJWvo5Kb16YPE+K2hDoJBEDVm89EBwHvRcsUj/sfOaUzde8c+7RbPf91Qm7VleP69EfobkmLtkLpdS4irjAzYDN8rBkc1w2vo0ayED8XVzpMoghDBlVzXxLACXnXbhxjpXBDGsU3wU2CM56F06HS/ZFRM8aYEoll0XzKEhhw6vF2fW4XuA19qjG8OB7EEsE0bmgo4jVXZNeQF2hsMg1q5Pe/r98vrebM+AgufrlgQvjSmxa6o4n7bbqsPoZ78g4Ig6kx8roh7aI+eELxEC4YxV4uKx5R2+OLSFefMaMiI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(26005)(66946007)(316002)(66476007)(31686004)(38100700002)(53546011)(86362001)(186003)(36756003)(36916002)(956004)(8936002)(2616005)(8676002)(6486002)(2906002)(6666004)(83380400001)(966005)(4326008)(66556008)(16576012)(110136005)(31696002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDF1aUVnZHp3YW9lbTk0bi9QdXUzOWRUTlowUXcvTU84RnNjV1RURFN4REVs?=
 =?utf-8?B?cURENENxcXhpc21seUJkanZTSWhIaXhTN21jeG4vb3VhOEFHVWQ4WEFXeFBp?=
 =?utf-8?B?SzQvTzd2TzJ2UnlsL1BNdnFZR2xCWjg4a0M0VDBSVzJWMnlWNldjck1PQnpz?=
 =?utf-8?B?eWl4NTg5Z3pnUmFzSlc5V2FULzBIbkNKVUtjd3h4MXR2RUZLY3B0OFlTaWUv?=
 =?utf-8?B?Q3l6T3ZOUnprTUpHTWg5RkpUSkFySkl1Q09mKzlFRzl3QVFycC9RSWNCRDVY?=
 =?utf-8?B?TFg3NGdhbThmRVZNWTNUZnNkVlQ0bG1TT2NPakdNRmNKWXlZZkdVTXE4VzZS?=
 =?utf-8?B?U2dSSitGKzZWUWwycktvbTUyTXRyZFVwRGVXNWhPN0FMYWdoWmdaVWxMMHRl?=
 =?utf-8?B?TEtwTklBWHBadjlxWE1PV3VoeDc2dElDNUFhVnhRRFNFbkR2OFArOG1jZmg0?=
 =?utf-8?B?bVU0b1UrcWZSeUQ4VUhSNFN3NE1GVjhPdUQ1V2pBT1dONloyUlhMYlNmNDND?=
 =?utf-8?B?M01KUllUMTUxRExVL2J4ekFPcUF4T0tBNE1JVjA0VmovSmVBK0dJRHBkUHMw?=
 =?utf-8?B?M0FONVRMUXFBTTllU0lGbUhHSEozRTZiamUzUnJOMnBoUWdnZmZHa2U1T3RL?=
 =?utf-8?B?L09GWXNqSmZBNXhFVVhVa2p2R2V1bFlyT0V0eEJlV1lQdENLU0VqaDRoUmNj?=
 =?utf-8?B?bjQ3OUcvQnhhdXNwc1JMcjlpU0R6UExqZGtTNjBqOTF6QmE3ZU5WZ1BxR2ND?=
 =?utf-8?B?Wm9VV3YzSW9FOXV5dHd5aHNEbFdrelZtZlUyaHJsMDNCeUZXRGpON2lWNU55?=
 =?utf-8?B?aGRncksxek9iM3VSMEg0WGVYQWV6WE1JTkwzbEtsSEdoSDExQlc5bU5xMUdI?=
 =?utf-8?B?RGxoOEJ0bE92TU9TZ0VudU1QckFGZ0s5OFNVbTFOUlh5YlpJUU9VSE94d3dh?=
 =?utf-8?B?QkNOaEhoUld1dGphK2I2aGozeTlIdUdwUmNxaTQzVW9URHQxazhKKzhoOFFT?=
 =?utf-8?B?aXo5L2RvVUk4SzNtdEs2QjRpWXF0cSt5MGhEUFJRTlB3dTZFK2Z1cUw3MFpS?=
 =?utf-8?B?NnkyYkJUeFlVT0xkMjJFbFZQSEtiWCtBdVYyQ2RjcUl5YVFhNVlESEtORHEv?=
 =?utf-8?B?WHJ0b21ic0F0UkluQTFYdlAyREt4TmpycWR1MlJMTFZpclg4WTEwVGk1dWNK?=
 =?utf-8?B?b1RKN1Rob2Y5YUJrM1psSjh0V0YvczlTWkNDVDh2OVQ0dUcxaHB1ZUhHK0k5?=
 =?utf-8?B?UmNFZitiMjROdmdIWFdlMmI4cVZ2SnBlaDRvVzQrTWpiQkxQejdybnBDd08r?=
 =?utf-8?B?NDlGc05Va1ZTSitNeC9yZ2N4VmFvM01oR2VmdUlzbXFXWGxhdEt5dm5IekJu?=
 =?utf-8?B?U2J6dGhPRWtFZ2NoeHc3K2pXRVM4bnhqTjVOMjBwYStibmtPSUJJaWFia3Nm?=
 =?utf-8?B?NUg3ck5LYU5PYzBwYkFqTU1QenhmcUdFVWJRVTluRkRzTDhRK0kxM29wcGwz?=
 =?utf-8?B?RXpYeUVTd25YSWV3NW9tcjc4RVFLOUJxM1lPTFRHTVpPMjRCSHJVNVUwYTlZ?=
 =?utf-8?B?NHROby8yZHdPUHhNaXM5K3lYV0hkaGFiUXN1TDJuVVFmaWVEanlhbHZRMU9Z?=
 =?utf-8?B?MmtSdlNRRnphK2E3OEpQSE41K280UWU2Qms3WVdnUVRqLzNWWWFHd2pBdFlI?=
 =?utf-8?B?ZzlNd2V6U3U2VGl6WDNvM3BuQlhocXBrOW9Ia1dhMFFoZXNIeDZYZFZyTklE?=
 =?utf-8?B?VWltQnBvdkxVV21LVEk4RDZOUVVkN0RTZnhMZEhySEd2TlU0UFRYSEpndktP?=
 =?utf-8?B?bXpjMDNCaWlDR2orVlY4cHVlVU1FNUxjNHBRbEVOem9PcHc2UldaSlZhZS9R?=
 =?utf-8?B?Ylo0M3lFTEtVVG9sNUdXVlVYVk52YmJaNkp2RjVKR21FM0VYTitLTmw0YTlV?=
 =?utf-8?B?RC9HbHJmQ1A2bDZTcVlOeTJJSHJkRDRReFlZQjdpTG9yNWhCRGFaeU0wL3ZH?=
 =?utf-8?B?T2gvRXQ1MDExeGxWYjRyOVloTktPWEtlY3VSc0JURnd2aXZSZ3phVEd0WnJr?=
 =?utf-8?B?dVhFVDRSYkk5VFVVbEgxSlJDc3huaU5zNFMzM3AzY09UQ2lrZURXK1RHRzNR?=
 =?utf-8?B?YUd2M3ZweDVJV0NqOWZiYUlmZG1JalpqMjRVRlNHQmFNbmJBTUhJeEt0Qm9l?=
 =?utf-8?Q?iOz6qBTl3ay2AgnB5uZLkoA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f37eda3-95d7-496e-54cc-08d9bc47bf97
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2021 01:44:19.4732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mzs/lgdqm00l6aSBNZqlHnjjWOjk2IzQoGxast186IQjq5rTA7zYdqfwTSgF+3jkcPTvwBiXIZf2iSliRc32Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10194 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112110007
X-Proofpoint-GUID: Fa20rtltT8ib61QgmgIFpxpbhz34mvXC
X-Proofpoint-ORIG-GUID: Fa20rtltT8ib61QgmgIFpxpbhz34mvXC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for reviving this ancient thread. I was kinda lost for the 
conclusion it ended up with. I have the following questions,

1. legacy guest support: from the past conversations it doesn't seem the 
support will be completely dropped from the table, is my understanding 
correct? Actually we're interested in supporting virtio v0.95 guest for 
x86, which is backed by the spec at 
https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf. Though I'm not 
sure if there's request/need to support wilder legacy virtio versions 
earlier beyond.

2. suppose some form of legacy guest support needs to be there, how do 
we deal with the bogus assumption below in vdpa_get_config() in the 
short term? It looks one of the intuitive fix is to move the 
vdpa_set_features call out of vdpa_get_config() to vdpa_set_config().

         /*
          * Config accesses aren't supposed to trigger before features 
are set.
          * If it does happen we assume a legacy guest.
          */
         if (!vdev->features_valid)
                 vdpa_set_features(vdev, 0);
         ops->get_config(vdev, offset, buf, len);

I can post a patch to fix 2) if there's consensus already reached.

Thanks,
-Siwei

On 3/2/2021 2:53 AM, Jason Wang wrote:
>
> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>> Well, although I think adding an ioctl is doable, may I know what 
>>>>> the use
>>>>> case there will be for kernel to leverage such info directly? Is 
>>>>> there a
>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>> differentiation (legacy v.s. modern) needed?
>>>> BTW a good API could be
>>>>
>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>
>>>> we did it per vring but maybe that was a mistake ...
>>>
>>> Actually, I wonder whether it's good time to just not support legacy 
>>> driver
>>> for vDPA. Consider:
>>>
>>> 1) It's definition is no-normative
>>> 2) A lot of budren of codes
>>>
>>> So qemu can still present the legacy device since the config space 
>>> or other
>>> stuffs that is presented by vhost-vDPA is not expected to be 
>>> accessed by
>>> guest directly. Qemu can do the endian conversion when necessary in 
>>> this
>>> case?
>>>
>>> Thanks
>>>
>> Overall I would be fine with this approach but we need to avoid breaking
>> working userspace, qemu releases with vdpa support are out there and
>> seem to work for people. Any changes need to take that into account
>> and document compatibility concerns.
>
>
> Agree, let me check.
>
>
>>   I note that any hardware
>> implementation is already broken for legacy except on platforms with
>> strong ordering which might be helpful in reducing the scope.
>
>
> Yes.
>
> Thanks
>
>
>>
>>
>

