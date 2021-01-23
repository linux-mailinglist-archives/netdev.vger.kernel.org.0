Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4A301857
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbhAWUSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:18:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53870 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbhAWUS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:18:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10NKFVHN065242;
        Sat, 23 Jan 2021 20:16:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Pca1rxI0gblrJuQE/QlEB65MkVlJLGitv2DYHKd1oAg=;
 b=AwZT2qYqc4bqtNPshaoOZI7YOtcLxSrqJnYf5SuIO2AHOL5oHjPCTQHXgwyM6CFjL6bc
 uASCkyIxwd1dU2sEZEwZAG0okJtq3WF5APvhGxA+sk9+4JvzwR9cfLbL8YQMdahVmbTn
 UbhU9T6gtAy7LGiPjCSHLuACnow5XqzwJcHCoDT639mzmD/FaSJDiFK3ivGEf8Dh8su3
 TW8GbNyBF1mab0UzjnaIF3rXnYBqAJ36ByfaAlz19LpXxsfWeLp08ZxqIwhH78859Pms
 fl2xfYqOQDp90I7dvg5pWpx9UeNWoiNtGbF/G7Bvs9dUJ1W/iFY2H2ZwJMip1+7O4X1S Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qherg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 20:16:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10NKEqQw009092;
        Sat, 23 Jan 2021 20:14:52 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2050.outbound.protection.outlook.com [104.47.38.50])
        by aserp3030.oracle.com with ESMTP id 3689u9b80u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 20:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRYuYK6U7sz80hdC4l76wz5o/8AnznWOhAqS8sMSj0nwQ06wWnooVjthYJS9rK453IreMcg8LILzgBXx+5tMcCv4aIYO1DUkFVEL5dyrX9ynnubgPpi8okAYOItkhGye3cbYorNW8qxdOCNMMumUmusqpkhaqj1AYbsmSU1XYtyJVjqDYbi697LUKeuPqaZf0nNFHpiqPejPHZfi6PCw1k2lh91NCW/W0emj7/EgXtZBl52s3uJZDoRuqkOcH4a0tQqdvu/BHEk026HQfzNa0tSycoHoOMJHijD09tJtywGR0nEkYPH5V9COLQV8YgJ+5sM9Zu4djoL6zYlZCY5PEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pca1rxI0gblrJuQE/QlEB65MkVlJLGitv2DYHKd1oAg=;
 b=KCSithAIO3B1GU/fpVSjZ3Z7N2rUtZ8VlBd1vKHyfF7SUEUKjqh63kp8USyQWoFgy8h0jQuGao+xNFUjfowux9xPU4tru7QnvBGlPDsDUeGZl+6uLh4Hrhay2RKbg7gm9HXLE0nZjK8U+2DszIdIGoVuHhejTYJAIgGyU0afkGD9+feqX4yXuZl9wfPdElL1ua1AtLrxkXgWGaeMu1qe26b2fXAci2W7T5RLJi9WZqJ5eK/kgRVROrSgNtqX2jloOVyZF4aD7zyjgdd95gDBLBh5m9wRLiBWZKBfmUa6A8k9etwQlEca6Vg0gzYmLNHxyk9vlfPzXnKVwtlmXpNXXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pca1rxI0gblrJuQE/QlEB65MkVlJLGitv2DYHKd1oAg=;
 b=Zu+pSP26L1/aS15TfkmCruf941wh0VGLhECLOyhwOJyKh9prQzQah94AHaP3Pldy5Al7F0LR9c2MSVOBvNp3+XsnnFHYIxRaYn9EtpCDMpWjzwXr87W8f3BtUViXrCFWhcOsqERSZe+NBfXfTBJbjyW+Der6hJcNrj4au2/8imA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3590.namprd10.prod.outlook.com (2603:10b6:a03:11a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 20:14:39 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::644d:92e4:7b5d:f8c1]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::644d:92e4:7b5d:f8c1%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 20:14:38 +0000
Subject: Re: [PATCH v2 1/1] vhost scsi: alloc vhost_scsi with kvzalloc() to
 avoid delay
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     aruna.ramakrishna@oracle.com, mst@redhat.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org, stefanha@redhat.com,
        pbonzini@redhat.com, Jason Wang <jasowang@redhat.com>
References: <20210123080853.4214-1-dongli.zhang@oracle.com>
Message-ID: <b85fb58d-72b4-2c0a-a412-3dbdb437e042@oracle.com>
Date:   Sat, 23 Jan 2021 12:14:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210123080853.4214-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:646:c303:6700::a4a4]
X-ClientProxiedBy: CH2PR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:610:54::38) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700::a4a4] (2601:646:c303:6700::a4a4) by CH2PR11CA0028.namprd11.prod.outlook.com (2603:10b6:610:54::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 20:14:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 679245d3-5164-4045-23c2-08d8bfdb82b2
X-MS-TrafficTypeDiagnostic: BYAPR10MB3590:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3590F2F7E51463025BBEFF21F0BF9@BYAPR10MB3590.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMzZXePu2X1p4oHJE8ogQ3iZEo8e/JpaedpF5E/xYyuPEllSycTLAAhX+at2CMs+Cc5OHwSpa0H6UxhypMLw2AylEh3rVs+7A02Z4rOWHyPGQX3JByqMIeRJ32pv94KmHiVVTfpfx8lgEiFt241XGr/VHGRBasgdbd+rVVgEalNYYBJQYaVKU6RUTfLFloACt79etznOIHp3+MhbSHdGDZ9xx2g4FwCuk92t7Mq3X0SnnRASFUS0hm3rcEwEUVMx5Cn3T086BNOF6ZjqXL/5VBCJBGsRq+zPm/loncwwu0XebuMDG13CBWfUwLMkX12priwxC1wkSH8ECh/nzvPTOVSfT2SQHJqBZa03nMB0NqoVGgiX0qCJT5yWkapmaUcvjcTmuUh3XjEdsp7/qTNLKYJniQeK4fbrQr/WPB0HO6oFNdabbrej0wzChFN0OPKP+gZ4YQVkD/hzCqdDMJ/cCNgr5paTkZuY+2WcCySsiIA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(346002)(396003)(66946007)(66476007)(66556008)(2616005)(8676002)(16526019)(186003)(44832011)(31686004)(2906002)(4326008)(6486002)(36756003)(8936002)(478600001)(53546011)(83380400001)(316002)(86362001)(5660300002)(31696002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YTZwUElJUFhORGU4ZUdFYm9IcEx5VnovME5oRWpTcnU1cVNpbmp4bi94akkv?=
 =?utf-8?B?U2tNeEpxZmFTSEJ6RndLcGdMOU13OHRaQytYNitiVnZ1VDVwK0V1VUZUQUJF?=
 =?utf-8?B?KzZ6dVBHeUJvaUcwYmF5L1hSb1UxditNcW1Xak1KUzdEaVU4ZmlrVWI2TmUv?=
 =?utf-8?B?Nmo3bS9XUTY2eUIrdDg2RkpCd1IyUy9aK211bmNIcjB3TWY4MU5XS0FYbUxN?=
 =?utf-8?B?NFljeHBCei9DbVMxb1U0ODRNdk5sMGtITGJ5cEFCQ285alZzL1RJTDZ3cFc4?=
 =?utf-8?B?ZTVyaUhXM0IzUWRMK0xZekVxMEtodU5aTlVFbDFhNFAwalJMM0hOaC91QWlz?=
 =?utf-8?B?UnNBQ0h6ejg3dkxnaHNZcHZkSGYvUUJSNElZVkxCZCt1THpqTzErSXd6cjJ0?=
 =?utf-8?B?YUdGQ21IODRFMnRpaFduQTF5OGxCcVo4T21Qb2ZkeExDenowY1BjcWxqQS90?=
 =?utf-8?B?NThyajlBYzdLQUNkeEJTaDFWWXo3OUFkMlgzanlLRGxIZDdyRnhBd0tFU1dO?=
 =?utf-8?B?cERPK0o1SHd5TjFNc2hSdU11c2VYSmFxelNyRkNLVkZwWTFiamtvV2U5REx5?=
 =?utf-8?B?U29sbGV1eUV5QU90MGNCa1I3cndTOWtqemM4cFJzK3MvWUMybVBTOHJKSkZG?=
 =?utf-8?B?UzRvOWRLakJoMzJiNjVrYnNkRHRlSGNvNFF3SjJJdHFDTGlwRFNXVEZ5eCti?=
 =?utf-8?B?QVJKU2JlaERXQm94MTkxeEpVcHJGVjZnN2pKdFlmNnJFSVQvMldUMlZLREp5?=
 =?utf-8?B?dVcrazJqVjJNc2I5cWpXTDhnSGZRZWQvck4zT0NRaEo3NUVKMGtJYzQ5U2J0?=
 =?utf-8?B?N0h1ZXM5VVhZYllvVWN5SCtuWG53SldHNUp6UmtXU1RXUGlFR1V4UVRjaFJT?=
 =?utf-8?B?S0lHYnFKU0ZnYTVGa0prelZaMUNFaDQzUndLVWtsVE1sWHA5QTlIWnZ4K2g5?=
 =?utf-8?B?dTlPNG9tZ0p4Z1VIcUcvM2dMTzNVUEJRTGk4ZWd1UVZLS1lXbmhvK2ZEalh4?=
 =?utf-8?B?clQ4MHpqTkZJRHNmMllTdjlmTzdtQXdPZ29teW9DZEY2emp6VnRoYjFFV0Fs?=
 =?utf-8?B?cTk5Y2w1QWtOOXJKMDI0NEVwcko1dEIxcXFPYmxzMStwaFBrd2RsWUNMaDhu?=
 =?utf-8?B?QUd3TURZVXFlS3loa3h5WnRkU0NRNzJXakxjRXZXTklvM3lHdnY3bXNWVURG?=
 =?utf-8?B?MklNbE5vNE9RdlNvS3RMZ3ExQVh0UWdWb1RkU2paL1RjQzF5Sk1vVk40bXFE?=
 =?utf-8?B?VWhiTjUwZHhJK0RBd05MQ08wZWttWlczQVJvODNiekU2QkQ1b2tsYVdTbHJQ?=
 =?utf-8?B?d1ZoL1ZwMFcwbGNQYVIyckVuclNHU2tOaXErNzhOWndKdWVLb1FMczRyOExx?=
 =?utf-8?B?NzNKNGk1RmlUUlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679245d3-5164-4045-23c2-08d8bfdb82b2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 20:14:38.8678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rr27xgnzmfzq0Pyeg9ehfyXvK7JaYICI+6j2GgcQQDBGQB33R3DS8oRmddagDhnHYJDg89E7Lv50AMv1yD3meA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3590
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9873 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9873 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to my "git send-email" history, I have CCed jasowang@redhat.com. Not
sure why Jason is not on the list.

CCed Jason. Thank you very much!

Dongli Zhang

On 1/23/21 12:08 AM, Dongli Zhang wrote:
> The size of 'struct vhost_scsi' is order-10 (~2.3MB). It may take long time
> delay by kzalloc() to compact memory pages by retrying multiple times when
> there is a lack of high-order pages. As a result, there is latency to
> create a VM (with vhost-scsi) or to hotadd vhost-scsi-based storage.
> 
> The prior commit 595cb754983d ("vhost/scsi: use vmalloc for order-10
> allocation") prefers to fallback only when really needed, while this patch
> allocates with kvzalloc() with __GFP_NORETRY implicitly set to avoid
> retrying memory pages compact for multiple times.
> 
> The __GFP_NORETRY is implicitly set if the size to allocate is more than
> PAGE_SZIE and when __GFP_RETRY_MAYFAIL is not explicitly set.
> 
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - To combine kzalloc() and vzalloc() as kvzalloc()
>     (suggested by Jason Wang)
> 
>  drivers/vhost/scsi.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 4ce9f00ae10e..5de21ad4bd05 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1814,12 +1814,9 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>  	struct vhost_virtqueue **vqs;
>  	int r = -ENOMEM, i;
>  
> -	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
> -	if (!vs) {
> -		vs = vzalloc(sizeof(*vs));
> -		if (!vs)
> -			goto err_vs;
> -	}
> +	vs = kvzalloc(sizeof(*vs), GFP_KERNEL);
> +	if (!vs)
> +		goto err_vs;
>  
>  	vqs = kmalloc_array(VHOST_SCSI_MAX_VQ, sizeof(*vqs), GFP_KERNEL);
>  	if (!vqs)
> 
