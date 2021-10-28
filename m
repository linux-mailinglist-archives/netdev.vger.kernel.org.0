Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9095E43DD2D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJ1Ix3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:53:29 -0400
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:28900
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229835AbhJ1Ix2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 04:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JteRBWifvIPzMk9gvqW7oatEKA2fA2GqZ/kSlmF7GTDVvoGp26cv8ezpT4gq1R17HT7Bm/PPE/l43pJQU/gIek4mS7CVQyUfyPTOAIsXoUL1WApdAuyOC+horQPLKqJfdsIHI0duBxmXwMDHROWTchlICxKp2nOjY2ro7z2EBVle5K7SFSQQUUvhTRqibjMwRvECsc8ucqA9LLJGWWYvmNIGmhIFptclHG8Qre0Cuexz1T5wVtakL8CLwLkp8OMILPPnRs9ipDn2JvEUdcxld5YvyCaR6tWteqWr0EeAiwgcq45tsnFABPW6wj7M+enqjzy63Jc69bai9ag7a7mhRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uubcTJwDeWRC3KqDuiWm3dok071GM2AdNIMGkXAeqGA=;
 b=mp07pqOtLNHA8F/qHSB9vKkQ6WqhdLIcScIlnrZezyrDyHitoboFJuFN6pBquEuWm1echAVV6J+4OS63rsonYWmN2B2IwPeW8b/XnBkE1vMa9jQFiUQKGuSlOs+F0md9/VwUrd2egj4dxaPH7IzVUenlkiut4Lhabc6UZAA/NzEEJZOyqDgEx7NH8t8V30+Bw3p2s3UR3BZWF0U6us/NK62SPFLIz9Xj9vwCjwqLxGhUUj2QC9PE9lwc/QMzHpKfVjBIEPAbp6BFJpRXYJ737qatoxt3H5IajyL3PLmPCF9A0fiXuNiTiBS/8d9s6eUJKhvGnv+IxjraWlSWwHtp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uubcTJwDeWRC3KqDuiWm3dok071GM2AdNIMGkXAeqGA=;
 b=Lj7EhIcPM5jaEwh+gS71vVYi11+sHKJ5DYTgLh1ETg8B9G2QFU9IKKegn0DSlTfCa69cToSnWfru7MmtJFpfI6AiR3j7Lt8F8aMmzj9nifWsGhV0GLsV8E/I4W9pIWgIY8MYlytjxHKuzB2I5CjcWXrzwbdcA8HMq7wrHhwDqtkuTJrGyY1PGFdKQWwYjXa57vZbFTTDFeBkEXJK5LYE4WiCcrERiuXsCYT+68rSTqL69mjmDygNksLLxlUtfSiMd+2Ytd9NI9xVmkPEmgbgSzxVKgIFgEzsgq2ClyfAaPvQT2JzPnlLqoD+xLxv53zJavJ+zfHWLN0fPYne1zClgg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5360.namprd12.prod.outlook.com (2603:10b6:5:39f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 08:51:00 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 08:50:59 +0000
Message-ID: <eaf15b9d-79c7-199b-74fc-90e0ec68437a@nvidia.com>
Date:   Thu, 28 Oct 2021 11:50:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 5/5] net: bridge: switchdev: consistent function
 naming
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-6-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027162119.2496321-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0036.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0036.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Thu, 28 Oct 2021 08:50:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b02f1d9e-e7b0-42c7-6526-08d999f0106c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5360:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5360E01BB84F865FD5254B9BDF869@DM4PR12MB5360.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aArU913c0mrivdMgXfewGY1JtrQd/qzncX/9dLeIjXlorqW0iPyrdHL73yPzkzFqNXKzj3jrfWgTkNEATRC9VXSmby9ZuqLkw29OCZ7sb8zU83I86zW/ThFkc7G9SCDuAHglSBBa9Oihv3DWXkxHHr/M3nLKVWc7PeG6LFmM+33eG0GyJBX2zrGdDZHAvLmwxRXXwfBul9wwjACOY54lcG1QD5N3OYW38pFgQDhe3XzONWxq0vJAnLuawR4/KbtZheLbQ7H/sjFhhaJ8LmQRVfxII1GR7Ibh+oj0XoN9pW97PDWQ7S8dr32a7v3//Cc+KpJBiTCVxnFr+xzLP7yUfSRFj50DwVfau0HOvm+5rqXhC0BWLq+CcjRhTgr9XDM1sIC8FX0j9arvvqjA0SYvY/LsvvoVmRl7fZI7HHST4ozZRfCcwbfHjrPUXrmIpZCyFTTq/OVT+wmWAKvEgC+rr8j6+xQuv0hK16s4FMqynVEcFM4zPiQjVmHCze5H5H1ENsB7rGcDsbrlvvp6wgGpRDrXWHnAq6/UFgk+cdrZRWlYPY7Hgyv7NRFJBC1+jwkzLW3+3mVtuGnpeAJJEYfwrtAQ0Ez6BIrtvv0qYsJWSLPLXMSy4gjHnJCYYfFOrrE/HNkLjcCylAeyhL1Is+WTdDj1Yb6QKma8/NfDhfhsYJqFdLbGzQ4wzJisLVARRGqz6WlWHQb4+hZZPLoW36on0AbFSqwwUon8eVarbOjHMYU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(508600001)(31686004)(186003)(66946007)(2616005)(4326008)(26005)(38100700002)(53546011)(66556008)(956004)(2906002)(8936002)(16576012)(31696002)(8676002)(316002)(83380400001)(6486002)(86362001)(5660300002)(54906003)(4744005)(107886003)(36756003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVZ4MFBkWnY0ZkVhVWpDaGhkalo2cGFLZXBsMFErYzZZR2FtZTREVDBPZFl6?=
 =?utf-8?B?cHQxenV5LzA5MnE4RDdHdVNPR3lJZkc4TzRycmFyTEpLNnUyQm9LSmVkWWh5?=
 =?utf-8?B?UjNaNFJtdUl0Q3lnU2pvQkdlL0g3czcwdkJFallUMmgvK095UXUrQWhUZGhU?=
 =?utf-8?B?T1lBbzRRcWM5MU8yZnowYUNwbkJqOXFaWHc1V3dJVkRWb2pQRmtXM2ExT1Ir?=
 =?utf-8?B?cWFSaHlXQS9xbENWYitVemJvY095emU0ZVB5VlhOVTYwM3ZmS1p0VmhEYys4?=
 =?utf-8?B?dzM4MzQ4MVh3UTV4UDZLNUJ4WWNGNFZST0gzbERKa21GU1BvVlJvdXYzMFdD?=
 =?utf-8?B?Slp0V1hlWGliM21BNm5JMjBQUkhad2tKUFBzTFRZeGtYOXAweDBqb29xUlJI?=
 =?utf-8?B?cHZ0elhZcDFBOHpZWVl0enpkTFJkN0RPekc0dE9HK2t1UGpMekdvQ2hMMUdO?=
 =?utf-8?B?R3djdVNrSDdSUWRZeDlFS08zNDJHYk1aMmd2NHlaWldESlpiWjBnYmpKdXFn?=
 =?utf-8?B?bER5NVNPZ2FrYllERVRMS2lOaGNGQmtOMXBRTWtmRDlNNFQwTEg4bDNidHho?=
 =?utf-8?B?OVpRNHFGTkpLYmYvMHdkTTFMUGU4bnFDV1ZjaW5DR0JFa2szTHZWNG44NGtZ?=
 =?utf-8?B?VnFvS3RhdDJJVlRUWXQrUFBvam1MVXBsZkpKa2JjRkYyVkgxS0JrYU1tYmY2?=
 =?utf-8?B?UHZoVjFyUDhqcDg3NTBrRW0vbHVKRFlqTUFvNnhlK3lwM3gyVzUrNWRacHNi?=
 =?utf-8?B?eWJTYzhjRWRlWjVMRzRQUXBhR2VPR215OXhCb0E5blM1LzFrNFgyaWE5K0Ex?=
 =?utf-8?B?WFI0L0dmOS9VY1VYVk10VEp0S0tWalg3ZG81Vm1qMnl5V1ZEMm1IeDlTb1Fq?=
 =?utf-8?B?aEFVQ2RyaVZPclNldTRqWUtWVHpuQXp4enR2cmdPMEY0MXhkOVNvL0wyZEZz?=
 =?utf-8?B?cnkvakFUd2FMRzBtVDRrUUVxK2dGd2RoVkl1TW0vL1dtZ2srVDQ2Q0hWeEFz?=
 =?utf-8?B?SXpKTldlbWxWMjNTQlhKVXY2YkM5RzFiTnpZOXBKbk5LRGkzU095RFIzaTFu?=
 =?utf-8?B?T25iVUxWeHIzT2g3YmpyK29tSGdSY1ZGc0QxUEFXNXJzVWRSN3hIUzQ1MFFS?=
 =?utf-8?B?MEFDV1JxNkcvU01aV3FoVzdreE9iTmkzeHd5bVZLK3RxQ3Y3V0lYTDM5a2c4?=
 =?utf-8?B?NmRvNFpyVlF5Z0VTblZFQndUdFZlM25nZzZSdHIwUHZHcU00RVMxaDFSZnRC?=
 =?utf-8?B?b0dsV1B2ci85eG1BdWxYanhMa3ZkdUo5dUxYbnJISWVCT2J4RmdDNHF5RllZ?=
 =?utf-8?B?ZHRSZkExaWt6UWJycWZIQ2prQU8xZHBSSDUzVGp3Y1NNN29VbGJTK2V6bTZv?=
 =?utf-8?B?OGFxUTBEUVFtRE5HYmd2WnNXVlFDeTBnSEx4K1UwcWRGQm9LQ1BIMHkvWW44?=
 =?utf-8?B?a3k1NHJsNW5BeFNVbVAzYzBSeXVEdVNyWjJ0b1RDSlFJNWc0QTAxSFZyVkhV?=
 =?utf-8?B?S3pRYSs2WlNSOFZHemN6bWt3Ni95Rmtka2o2Rk5PQ3pkTk1SMml6eEFldlVF?=
 =?utf-8?B?d0p0aE5RR3hXWFlzdUhMK2RydUk3d090SFB5LzVnNDJTTi8wS2pxTVZKRWhR?=
 =?utf-8?B?Q2krdDVPOGc2TTBNZ3dvOWt5VVQ4WWdOZENYSkxNMGE2cmZ3SEZQbnUwdWlW?=
 =?utf-8?B?VFJsVGVWanU5TVVlTHcvMWRWWGhTRTF6ZlA0b0I3YlRTMkI4aXZ0VWR4VzAr?=
 =?utf-8?B?K1I2VmN5STdGSWNWZkVqUkYvTlR3dXZLRitZNC9vVGcwZFEyK0N2UFc0cExq?=
 =?utf-8?B?dlZHMkVnRHhjeFJpb0JPRXZaaENKdmVFTTYyUFBMb1B6dUgwREsxa0IxOEJC?=
 =?utf-8?B?aG1DcURCbldCOEY0dDdVYjBWclRycTBMS3piU2FuSDU4TkZCSk0zcmZQWEVn?=
 =?utf-8?B?c0s1Vmx0VFVtZ2YxNlAvYTg0NDVlUWxpZWorSFdRSmlnd1dCM0ZrWEZYaXgv?=
 =?utf-8?B?OUt1ZXRNQUloekJMc2JlL3RUQ0dkSDg2eFpBcnZrdm80ME0raUhGVElic0Z2?=
 =?utf-8?B?bVlIUjdxcituTXBxYTc0eDU5OVNxenA5NWcwZTVsUVRLQndCZkdrNmwwN2s1?=
 =?utf-8?B?ZnI4RjNmdEhkQnI0cVlaZ1hINHdlMms5eTJFOTBCVlZsWTZIUDl3SFZjdUww?=
 =?utf-8?Q?aQFCOdx8Mi0lz0m6S4pVLRI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b02f1d9e-e7b0-42c7-6526-08d999f0106c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 08:50:59.8974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKZkWct4vZguIWr/yoagcuKpBJRq4kO/PFIltYwxJoI6evyM/3JgogoD6tp0PNnFP2wXTblbG60afFozPU524g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5360
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 19:21, Vladimir Oltean wrote:
> Rename all recently imported functions in br_switchdev.c to start with a
> br_switchdev_* prefix.
> 
> br_fdb_replay_one() -> br_switchdev_fdb_replay_one()
> br_fdb_replay() -> br_switchdev_fdb_replay()
> br_vlan_replay_one() -> br_switchdev_vlan_replay_one()
> br_vlan_replay() -> br_switchdev_vlan_replay()
> struct br_mdb_complete_info -> struct br_switchdev_mdb_complete_info
> br_mdb_complete() -> br_switchdev_mdb_complete()
> br_mdb_switchdev_host_port() -> br_switchdev_host_mdb_one()
> br_mdb_switchdev_host() -> br_switchdev_host_mdb()
> br_mdb_replay_one() -> br_switchdev_mdb_replay_one()
> br_mdb_replay() -> br_switchdev_mdb_replay()
> br_mdb_queue_one() -> br_switchdev_mdb_queue_one()
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_switchdev.c | 117 ++++++++++++++++++++------------------
>  1 file changed, 63 insertions(+), 54 deletions(-)
> 

Thanks,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


