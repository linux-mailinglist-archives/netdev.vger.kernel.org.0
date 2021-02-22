Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD52321DC0
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 18:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhBVRK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 12:10:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32846 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhBVRKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 12:10:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11MH6Tr9037353;
        Mon, 22 Feb 2021 17:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LNKajXk+Bwu5GRLJQEa4Ic2UNlP1kbr1RVLdGBai5UQ=;
 b=SnHGVkDpSFGhZreeAz27jJ5DRiXcC2k9azHgiigFJxR5NGQlR3kTaw4OcCzRc64wU/Rk
 Vw6ZY/w2NWCkQDR1b6vSaa27cIzt5W1i+N8o5X2xcQuILr3JQS3vYdzwPA6n3m+bDHlh
 e6Pw+QvNl9vou5qVtzTOsiK1yGSCBf2ojKTn9V+YlNPHaKokhU0iYz2haxJnTAR9W/Ya
 EbBhiFvnEXf2iRBZ9lD7figrEpGWaDsZX+9fstPQ5Al4xSbL1pNJn8fIvHyVjRQ/33NL
 kpnXLbkmNw3kd1bNF4+7ZFnXNDxH/Du+Smjaoo6hqyySFDQagazot8u74ic3IBG58914 CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36tsuqvdr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 17:09:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11MH6IFj147914;
        Mon, 22 Feb 2021 17:09:35 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by aserp3030.oracle.com with ESMTP id 36v9m3h8kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 17:09:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RE/zrKjuEwutyu9WgFLI4BIguu+AhOyom9FDZcSAS7QgUkoOltiyI0+pbVzN2tvRqANEjLsN+pip2hxGpRIqUZj3ehpK/AcOp7hnbvSQk2y6VAbKg4lQdXezmEXSMjhLFEETpp6b+EPcR+RjPVG03U41afaFPgXTMiOlTrMgdPpQG43O3dWCtJkaz3Gr1QnNNJpjc6Pz8S8ISwhjIhrCACIZNcK9neZ/ORx7Q01TbFvQQ5a5JpBsLtFjOkUGOY8IrLYVvY04wC1pjDRN00xEGekJsMQcv960ia8NOc+iaHpIbcf2TIdHAgb1FdtRiFef5MrcmV9VDWZyFN0h2vyKqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNKajXk+Bwu5GRLJQEa4Ic2UNlP1kbr1RVLdGBai5UQ=;
 b=AqfDhW+F9bos2LG1bUDxBr8Muk9Zi2Vf6vbD+BvOKb95UMS4WBfp0I6lNGnO5SrN3VY77ZW+1ex+OHaws99VprBcpY+iQBG0mKl+bnLVcA6cA6yBEc2oz/1B4rC/eu35W104/oP5D6AzyY1nEYXOeV3bvB1YTeX2IHvDeGf+b/+dT0fU5EEVPP09VkYzOXwPc+HLlG9V3YggUfMqHr9D7qbuxirrz27x4fPWlDMHrvekHBotuojpIuTTAEvpd2zEyrx0usE8bZZzWmxocrli8KGpEwpKb+NI5fJHXxcIEd2u7SLCNNmOyVoY0nsp2bmU6W1WhGLQCIBSu6XcMuqx7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNKajXk+Bwu5GRLJQEa4Ic2UNlP1kbr1RVLdGBai5UQ=;
 b=tA+YnlDnAtLq+cVLXHeYcm8h8zd0mKOXQO73T5l0xiIdfw9RSDfSbCvRut3hQ323P+jAGZI46LyBiiJxflYusUq7dX4NbWI7KiiWoypt3Vl7rqEx4RhP94hsTyj7somUfE8oM7MWv4SFfzr5ZFsX6iDl3hveAMpQuKlS8AyOpTs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Mon, 22 Feb
 2021 17:09:32 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3868.031; Mon, 22 Feb 2021
 17:09:31 +0000
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <ee31e93b-5fbb-1999-0e82-983d3e49ad1e@oracle.com>
Date:   Mon, 22 Feb 2021 09:09:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [24.6.170.153]
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (24.6.170.153) by BYAPR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:c0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.9 via Frontend Transport; Mon, 22 Feb 2021 17:09:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28870827-3275-4275-0cad-08d8d7549ee3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4340:
X-Microsoft-Antispam-PRVS: <BY5PR10MB434059F0096FC22E98B40089B1819@BY5PR10MB4340.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cS9RGvqys2H0TwYxOLW9GXihvZmN1dJvznlVDWz/ySzBREpPQcmd7Rp42xn8jUhiYewjxcuF+/Lw0vugtJOAa0RlzHICpNcEF3sN9FvVy8sTsbudi6mK5MmQtAQEmreRZfksG5o9B5ykoXGVA/XK+6kUsXJ5V0zvldICK1y8iJ8EuF3WJnIzh7354jb2S3sISO1ocIynZmzpWP9FmD9d6bMgcmM6QJp24WtX7WpwOXceYgr/MabcR+TN0vFwbGNPgTwvQKJzJeAaEfUPSr8RelFsk5q6KwJAVPA0ZeFQaJ7KAGvyGslBPPI/OsBDZ08USQ5CroxCQ16HRl7ANf1X5MwSvhjJPFYUk9RnzEW9DIs9rSop8IOSigs41nvBmNNwDcDNrYeHxF5rWBm1ZyDj5nQHaC/yB4IF8RIVFGnE2k0rAJgyUFtH7zfSjr6mDlInYFWw5gu2No9h3eYzV9boa4QxEgtMSoJ6c/C78QXRUG2caSM2L/NzMyOidqHDq55TExn0VhfgGtxGeTeDtMDCQpvaQwpsr7lbcTSshgwZ0NZ2Dq/mDir0DIdVk9Ev0U6+bPzbghIKFICIrcPMosZ/mVKmGmD5x4e2q5daq8uNdFc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(478600001)(6666004)(2616005)(66946007)(36916002)(956004)(66476007)(16526019)(31696002)(26005)(5660300002)(66556008)(2906002)(316002)(186003)(53546011)(31686004)(8676002)(86362001)(4326008)(6486002)(16576012)(36756003)(83380400001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cXd5YjRTUWd5WWh2TUg5MW9YMmR3blZ4S3ZJRjlIRVN0RlpGNldIZGdwblZX?=
 =?utf-8?B?TUcwQUFSeTdsSmk4QmVVdVFXU1hBMFpYTk0zK2hKOVlBdHlJRm5hWndjK3kw?=
 =?utf-8?B?bjFacmhnQ3VRQjlidHB3cnprWTVBTmhTTEkvbXlJOVMxYjc0UHRJNnU3VVhm?=
 =?utf-8?B?VUZhbFpkdXlHck9uaGFGL3VXaE4yTklzeXk1aFkvMElBcFFlazA5YWhqYm9W?=
 =?utf-8?B?SlFPd2lvZVRSeThGeFh0SjZPNmhkRkxENzgxVHF6SlRBdnR6Zm9FV3FaK0xV?=
 =?utf-8?B?bHdlckxKcWU3MFRVOC9TbE5TUUtsUXRJVzdJRC8ra214dXFlVUE2czBCRDRJ?=
 =?utf-8?B?UDVpb2haNHFZd01VMEowNW1BUEREZG9WWWx4eHhjRkNrY2FOdllEUFhvbTQw?=
 =?utf-8?B?bG4rTW9VZTBCNjUzeDRpT3QzUFFaa3lQZzYySGJxRlpPeG1uUldNVFcwVnRZ?=
 =?utf-8?B?MWZjaW9lcDMyL2VPemRPZCsranVVNld1Q3JHVEthYXFhQVZPS1NwREd4bkpE?=
 =?utf-8?B?eDNoQk9QQldGT2dIMTlXUjhHaFo1MnpiNTdSUHBZSm85eFdLUEkvOEFMTzdN?=
 =?utf-8?B?NmZGQ3F5cXRTRDJhWXJ4TTRzREVEelFjc2haM2J4ODJZSnZyeFc4MTkrUW9m?=
 =?utf-8?B?T08xYkRUVGZsNjZOM1ZheloxN2xpb1NvT1NNclhmWEdVaHpoSy9YWXZvOW5C?=
 =?utf-8?B?ZUNJUUovQzYxOUFFQmdCM0VCOEJyNklKWXpJTG1sWUpzalpIc0hoMmppQ2Rw?=
 =?utf-8?B?RXpvNWMvMC9ENmVTRHZmVjQ1Q3RhZVN5MGptaFNHK0xSb29jYVk0cFdYNGpE?=
 =?utf-8?B?d2dTeTdDT0k3NFJWNGc0VWVLTmhYalRaU2xLN2NNZ3pCTjZ0aE1oellBZVpM?=
 =?utf-8?B?YVEyTkdCRUR6d2Z6aWtKQUY5elhxTWE5Mm1DdDRRMnhBYnJPZlBlUmxlRWZG?=
 =?utf-8?B?RTExVjBhYmpZcDJhbXZLVlIycno1SHpORU9mOWtRV0dhcGNyU1NsZmUrZ1dH?=
 =?utf-8?B?ZHBPRzdoeFBPbDhCS2VjZW0xVVJhRE56MUVWTytWRDlyeHVya1RNa1k4VERZ?=
 =?utf-8?B?eDFocVI5emo1eXdqeTdCb2wzN3RpVUl3NDh5OVRUeElxSjYycktCMFhVNXFu?=
 =?utf-8?B?NUtuWFF5T0pXR3kxM3k2bHFiN3haUUI1bnFaeFFlS1doYUdibElzWGZ4aGRu?=
 =?utf-8?B?YTl5NGxyY21CT2QyeThhaGhJelEwZzFnVVA5M05FMEJDV1dFTFpaOTQ1dzZG?=
 =?utf-8?B?YkpvQ3gwbXpXTmRET1dmTUJvMFRTa1JJSkk3RFE2QTZSUGFlc0RVTlVsckpS?=
 =?utf-8?B?ejRmSFpCVUJ6QTVtZXdJS2VJTENtRGRBcTBLQWVHUnFYSHlXYWdDc0pPL2xP?=
 =?utf-8?B?Z2FFQ3BnRHp0S3JIMG1TQlB3V20xRTlrZU03YWFaUGZWNklVbGJ3eUpueDBn?=
 =?utf-8?B?WkswTVdjcG1DNHRieGVDeEw2RU5xeW5RZGxhTFc4TmdOaW5Uc3ZOYWljNG9U?=
 =?utf-8?B?NVdZNjVFV0dGZkZibWtXSDR5dGIxQ3FkTWM5aGNCZDc5cFJYUCsxOWJqVm1h?=
 =?utf-8?B?SDJBQmtGZlJyWUtGWUZTVUtkQmw2V1gvSS96czVzTkt4TFh5cEVRRTdEeHZ6?=
 =?utf-8?B?b2hPS3NhanozekFsbFJUZk5xbmtNakI1TXlQdGVQdjM1VHpPQ3lrSWo4aFNn?=
 =?utf-8?B?OEV6NjlKS3NqREU2UlZDUmpjM2czdUZPQWoyb1IrMnJ2SnBaUHp1TVRIdmZ0?=
 =?utf-8?Q?y4hxSTASlQ2NI7EaL4PTADs45p78Ee38JnUBphP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28870827-3275-4275-0cad-08d8d7549ee3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 17:09:31.7518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: av4wrRhsozycllxjx6J8HIkhRV42UECUTLApbHN2gIp6NGhjgXCkjX5zuiQulFa7rYm1Iq12HFC2gQXtcmU6mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220153
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102220153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 8:14 PM, Jason Wang wrote:
>
> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>> for legacy") made an exception for legacy guests to reset
>> features to 0, when config space is accessed before features
>> are set. We should relieve the verify_min_features() check
>> and allow features reset to 0 for this case.
>>
>> It's worth noting that not just legacy guests could access
>> config space before features are set. For instance, when
>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>> will try to access and validate the MTU present in the config
>> space before virtio features are set.
>
>
> This looks like a spec violation:
>
> "
>
> The following driver-read-only field, mtu only exists if 
> VIRTIO_NET_F_MTU is set. This field specifies the maximum MTU for the 
> driver to use.
> "
>
> Do we really want to workaround this?

Isn't the commit 452639a64ad8 itself is a workaround for legacy guest?

I think the point is, since there's legacy guest we'd have to support, 
this host side workaround is unavoidable. Although I agree the violating 
driver should be fixed (yes, it's in today's upstream kernel which 
exists for a while now).

-Siwei

>
> Thanks
>
>
>> Rejecting reset to 0
>> prematurely causes correct MTU and link status unable to load
>> for the very first config space access, rendering issues like
>> guest showing inaccurate MTU value, or failure to reject
>> out-of-range MTU.
>>
>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 
>> devices")
>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>> ---
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>>   1 file changed, 1 insertion(+), 14 deletions(-)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c 
>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index 7c1f789..540dd67 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct 
>> vdpa_device *vdev)
>>       return mvdev->mlx_features;
>>   }
>>   -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 
>> features)
>> -{
>> -    if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>> -        return -EOPNOTSUPP;
>> -
>> -    return 0;
>> -}
>> -
>>   static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>>   {
>>       int err;
>> @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct 
>> vdpa_device *vdev, u64 features)
>>   {
>>       struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>       struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>> -    int err;
>>         print_features(mvdev, features, true);
>>   -    err = verify_min_features(mvdev, features);
>> -    if (err)
>> -        return err;
>> -
>>       ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
>>       ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>>       ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, 
>> VIRTIO_NET_S_LINK_UP);
>> -    return err;
>> +    return 0;
>>   }
>>     static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, 
>> struct vdpa_callback *cb)
>

