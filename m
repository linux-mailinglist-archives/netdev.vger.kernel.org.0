Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087B2349356
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCYNw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:52:27 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:62400
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230348AbhCYNv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:51:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMqAytPW3hQ5/dAcWKSbzAYTqOQo0+7P+dW5ewZP76N21ZgQoef7aiHSE7o+1WcxbFOtaxlgC5ArHdePwgd7If43LhzbZFf+KpM4TO7444J7R1qkjhULejsMa+GPN5sPQPUku2oN/Nmo5k4ZFtNQ2MtKd2XgcJ0/45oOgrzT82/tWSt0z+YBNMIrIq0c20GpyPZYkn6wpnbl/O2zAb4JL3dIwZG+DGSG5Ch/fAfpmYCdRKwFc9roHe8OFEMU6ix1VRgqOsWy7JjB3c0VODpA5McPjDVWrFDdafRHYHHniKStRkdrtEcu+M2JYhhVg0xdfGPcpj2Balqfc9DRB/jbIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JQHh76Pw3jOXtXgjUfv7Mpj3IfQl3KkQhoJQ99eKKY=;
 b=LzxGYWeg70a9XRX1KtYg2BT2Jc7M4Y5J2vbwjQTjIjFX0KD5ui7dY5mQUbBWF4QjwZXhSs0k9p9n+qi8Juocc9qUL+psyZ27kWYcIqT0FE3/C+7mFvQSkiYHchHyGeZLEXXDjzrXzKZEeYuIZV9eT2iXd5ZoREtWqZ8tJyNv/wuFr832CDokXxOUqgEdv6NhdkM3OyPK0JowWmYHO96PxW8+vocHzQs+w2HhzObzHSjOC1wkK/HWozpPQlR7Ex5Ea7hFf4qXVtmmy0YYd4WEzE8rLilx6uVvq1mJ+ORiwmfz04EpoOb+T8JZxfYDubyHxdCOimbZdiWNmkUFIDI01Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JQHh76Pw3jOXtXgjUfv7Mpj3IfQl3KkQhoJQ99eKKY=;
 b=O8x99WgClUD2t6/K+8VMoI6dZQiirp41Y34VMjMgcYdiqGKMQKRB6k8NJcqOku8MCU8815Ik+Ip6YaMSU4+D8HGYwrfDUmfxHDZvQ1EVrhqUMTreTWwiRztEay3BPtxpQpOCcDwTlUYlloksTYUSEBPVI0wkhPo/+fio5kQ04lo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4436.namprd12.prod.outlook.com (2603:10b6:5:2a3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.25; Thu, 25 Mar 2021 13:51:52 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 13:51:52 +0000
Subject: Re: [PATCH net] amd-xgbe: Update DMA coherency values
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210325030912.2541181-1-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f24a0081-d9bf-65d4-92d9-e0a24c63c3d1@amd.com>
Date:   Thu, 25 Mar 2021 08:51:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210325030912.2541181-1-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:d3::6) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:d3::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Thu, 25 Mar 2021 13:51:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 576a10c0-f4ee-4999-d0df-08d8ef952499
X-MS-TrafficTypeDiagnostic: DM6PR12MB4436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB443621B4F3379247A76822B6EC629@DM6PR12MB4436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83bXx2E25zKwAITNacr7WM2w48+9BJWXSlyMSVI6dH4gDnTp+S4tKeZXDDaAR45Vug5U2atRTUsRHP12f1Lq8ENegXX8IsITQlI8bH2qdeovIUQhzbwrMaKzh8z46Mm9odo5D5A2B2fp9BeLSo3XciQO+WURgZdzkWEzbS8sdRtlf51hI28pgE1p4JPIqeTNntMPBUxWoBNFYx+G68CaiP1Z/Lr/iy/+euBZNvcpbWaYAM2GOnMEK2c1ZPT6OAv5DOwPAav1F9Ox+QgOVoHfh5Jt0IxbwdY3JkOsaI52x9DoeZXT1X+nGbCc5PPWzHUsr2TJ1QyXBUj0rGOkWkUunsrsmnXptcmUS9lJUqHGUo06qWSn47xPHcrSoPZzLVHO4aS2xiCf2w0RUdhflu39KOlJxTdbtEhmLU8ue2DmxLdNYe35adw8egzu8hyNvlRJJdMLE5PbMcm9hk4/NzzjOPN+e5XERfzlPpzLV6lrvzF//bKha3KkplDhx6bHO+J9E/unROzCxa+33wChkVLgb2ZMM6e5DV8+1BNmdNlzggnjIlHKlzQbpZmwlw3w4NAUrlKabawvwKgriKoBNf2JC4b4aYTMGzN3fUfcpQpjb4MIy3OmHLmsWd9a5S22msArAykrDcok2Ayd1aC+kStY5FQsC1W/RZjH+anDAJjQvf+43zO8LFYG4DTFpo0uJ1v7Xn0cI7S9pTsen3D7dsz2IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(66556008)(2906002)(66946007)(6512007)(186003)(31686004)(6486002)(66476007)(31696002)(38100700001)(8676002)(2616005)(26005)(36756003)(5660300002)(956004)(8936002)(83380400001)(53546011)(86362001)(478600001)(110136005)(16526019)(6506007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZXpHLzE0anc0UmFUUkRLdHJIV3JoazFaaHh0bW5leXd5ZC8rdWl0VXRFaXdR?=
 =?utf-8?B?cm9hb29OUVVLQ3h3TlRlVUZObUNZTDJTSzZLQ2I0QmVwYzdDMXQvcXY0NVRo?=
 =?utf-8?B?NWtuNk1yc05zS21yd0EzVncvMWVOZWQ5YWROdURJemc0cjlrMU1Wa0tKcG5w?=
 =?utf-8?B?Z1Z2a2RCdFBmZnlQM0kydElSZU9yQWZxeDB3OTdONVN3eFM2MmlQcTZWU3RX?=
 =?utf-8?B?Wk5NZ2VyditQalVQUE9EemtLOURzOHhJTkhCcmdvUjYzenF2SlpyL1FEak5k?=
 =?utf-8?B?bjRyeFdGUlFiSzdoUEdrbkFmTU1FR3hQZGtVRmhBU0wxcVNBZGNES3lUc3Fy?=
 =?utf-8?B?elFjN2ptWlArRGk3YmptZkVJdWZYbmFRSVhBSEp2RzlJOUdBNlBnSFBGVVZX?=
 =?utf-8?B?bkNzMm1kWndGTUJIRHVjMEVzbTVTZmVpVzFSVUsvUGJ5bitkSE43dWsvdzBq?=
 =?utf-8?B?Y3ZKRFo0b3JOVFVHeW9wZEdaaDIvTUVpa29yU204NWNHRjhEK3lycTR3djRv?=
 =?utf-8?B?a1JDdVFSSFFvM01qMk5pWDdXNUJ3K3BLVEZRT0ZldFVFaVY2WC9VZ2ZxYkxn?=
 =?utf-8?B?MWk2Z3hPRmMzN0dSN1JoUTJTRXlMU0tzY21xOUNzcEtWdG55U1BoTWVFWTJw?=
 =?utf-8?B?VnpEOWtyUGQycXplTktKcVNwQnJGb2lpSzJyc2d3a0R3SlpPL24zQzZxM0hS?=
 =?utf-8?B?NDRMc2xudEhxRW9iaHpFN0ZXcEt6RktKTDlvUUNqb1JVNThVQWI4TFlWeXJC?=
 =?utf-8?B?OUExU2Z0WVh1RTduMVBsRHcxR3o4cEczNkp4TFFWTVdxNW5BM0xZQTZ3eG1t?=
 =?utf-8?B?WnB5dmhKUmg3Rzk0RHZpM1ZRWGxwMktFMUd5eWQzSU9OVkFJRkZ1QWVZZzg4?=
 =?utf-8?B?Q3NNNUlDN0lYVWhQU2tqOC9aSnhYZnFKYmNkdy9nU005VTNBdWZHVmZ5ZWdp?=
 =?utf-8?B?c2xGeGRrY0U5NDVXSzNwWEd3Ui8xdklGbHlBQktOczJWaGkxcEJHc3BaSlhL?=
 =?utf-8?B?T3grYnovZXNrOGZZWmMvYVZZaDAzdmpCTVF4WUpEZlN1NWZSWVNRdWZpcGM1?=
 =?utf-8?B?cGdTYWRFRmtQV1krb1BMWjVHK0lWb0RlWDFPak1SckhBKy9mdkxHS2tudStz?=
 =?utf-8?B?TUI5MjlvdlJ2TTMvVXUvWXdsNitNbUx1cldMcVZCTmFrNW9xNDRkLzN5Mi8y?=
 =?utf-8?B?QXFSa1NqdUhZQWR1bitTRldoMFRDV0RQN2JrMUJZM2F0Vjl2blpnNEJpYzhm?=
 =?utf-8?B?WjFTNjdkMjBHTlR4bUVJT24yR3FWblZ2RkFYREFBM2c5Q2FSR1U3b2xYTkR5?=
 =?utf-8?B?Ym92TU0rbTlKSUhRRUZtb0VGZzNmdWVKS3I4YkdDSW80TXlFckd0cURVU3Ji?=
 =?utf-8?B?L2pHRXZnSEFzRGpJcEhJbXBQb3UrNlNGZ0tLL2ZlSEVIRnk3S2tvM3ZNUzBk?=
 =?utf-8?B?MVZyY0Eva2EwNzhEbWZhYUh0TzdoV1ovRW5QSWFtOW9OUlpjUTZuZkkzTVlW?=
 =?utf-8?B?a3M4SEhtaUhzeFVVbHNIY2FPenZiUm02NzR5cmovS09EamtiZ1h2ZmJINWpH?=
 =?utf-8?B?Z1A2NldPNWtmTWRGTjRiQStxNm5oODBUOFJBL3l6MFdJMys0aG1GdGp4eERF?=
 =?utf-8?B?clJWT0xGRnJidUFCVVBXci82bjhvVDQ5MHl6U083akp6N1c2UmF6bXhKcHk0?=
 =?utf-8?B?UXZQTUVTbENGL3FlR204ZnhDZjg1MytFd2IzRjNlVmVmNW96SXdSU0ZPaGRy?=
 =?utf-8?Q?Vfg3iBozcARbJuzBp/At5qQRS0LXLUUcCiPhi01?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576a10c0-f4ee-4999-d0df-08d8ef952499
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 13:51:51.9729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9k2+hlrn5/w9nsc84k/3RQc+m2x6O3Qcl1WywI+LnDxy+UaiZgUznuvjekhZAvKHqxpEHH/jwf5lh/S8WEsGog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 10:09 PM, Shyam Sundar S K wrote:
> Based on the IOMMU configuration, the current cache control settings can
> result in possible coherency issues. The hardware team has recommended
> new settings for the PCI device path to eliminate the issue.
> 
> Fixes: 6f595959c095 ("amd-xgbe: Adjust register settings to improve performance")
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> 
> Please queue this patch up for stable, 4.14 and higher.
> 
>  drivers/net/ethernet/amd/xgbe/xgbe.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
> index ba8321ec1ee7..3305979a9f7c 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> @@ -180,9 +180,9 @@
>  #define XGBE_DMA_SYS_AWCR	0x30303030
>  
>  /* DMA cache settings - PCI device */
> -#define XGBE_DMA_PCI_ARCR	0x00000003
> -#define XGBE_DMA_PCI_AWCR	0x13131313
> -#define XGBE_DMA_PCI_AWARCR	0x00000313
> +#define XGBE_DMA_PCI_ARCR	0x000f0f0f
> +#define XGBE_DMA_PCI_AWCR	0x0f0f0f0f
> +#define XGBE_DMA_PCI_AWARCR	0x00000f0f
>  
>  /* DMA channel interrupt modes */
>  #define XGBE_IRQ_MODE_EDGE	0
> 
