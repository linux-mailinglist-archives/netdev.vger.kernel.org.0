Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37790363E07
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 10:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhDSIvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 04:51:47 -0400
Received: from mail-mw2nam10on2076.outbound.protection.outlook.com ([40.107.94.76]:48865
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238494AbhDSIvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 04:51:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fq/8m7Vf6TNt7syif2qfZyx8xmYMyXNa2PnjL6HDYewDa4UpSvQxmYvn3H1CPMfe5zm2kHRNT2Zokqc9QmniS/wdnBOCAi+gk4UaA8T2kZB2wZEUs4ZR7ve5Nu5DGAm+WjfrcKmQqbNTUNtHepHlEETYDfqYLubGnAukNi119POukIkxojXdMKc4arCBztE5YbFAQmPY7zjJPncJlQjV4/UI4NjVkMMD/Ssgkm1BGnR/dB1GeF9s4xAZ3UeG8e/3HeWTZLJ7K+YqksBxkSF3iqQWpUQ0Iy68aHFAFnwb/YQ5iA6TFhCRIUb9wWmI/HuAnkLC4U5P1bJUg/aFkmKk6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOiEe95cP/6kZdxz/piglLl3M1LlkkpF8TNaEMi2Iv8=;
 b=Uioz1/hNVcAl9JNXNXGVVTKxIjRvMXdISnEuI+tHec3xQhzSCm2ZfBZXofF/EXQ9Z3jZ6Y+ILxXc6jG9mr31ge8IrHJwF1aWd7u4xp2yG8qVJEkEjMAMyITA061KU+nvKydz+13pT7B8abx+e9dfD+zXRVY8ePKgEXBE+8q7UQh+CmQv9j3LNWT4SsEEUfVI/tjO293kCCl93z8CGJBLwFTiA+A/uKmAbkpilNqUbgtTZPtKAm7KToRv4z28iUcYoFe/8nRPkH1y4/MDNDoQpcF0+bvwhK8TtrF2COVvkt3T7SZ54AqCeHLsZKHHDPMKa7A9lscovcGzzYNYzlNT0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOiEe95cP/6kZdxz/piglLl3M1LlkkpF8TNaEMi2Iv8=;
 b=r3J/NVMhdntB8rDmRvUykdavF3h1HMdM+uFsB3fW8sxr8dbsw2apYn6muKb4vgXQX7e3luzZSpiEbyTQQjJllUi5yYVty0nMJJocgY8rCA4+jLlYsa18O9w7LOZyclf9mrqw5A5Fxh4nJs7+Q/0ikpnzNjinuH2Mgul3rFC8vQmUyLCCvfCLPAP/Q497SVPtlw7E8q1L4Ch4TR0GOspSV1Yq3c5kvaTWxEz+hV200551f5uEFZcieAHfQDzRv8GxEkfCwKnyuF2/vsvQDCB+wrIIvyXAHe2zwZ1sJTFP0hkOCLWaYBNC/LcCn3coEz8paaRUk2k4G08tatFKprz+TA==
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4652.namprd12.prod.outlook.com (2603:10b6:5:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Mon, 19 Apr
 2021 08:51:13 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393%9]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 08:51:13 +0000
Subject: Re: [PATCH resend net-next 2/2] net: bridge: switchdev: include local
 flag in FDB notifications
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20210414165256.1837753-1-olteanv@gmail.com>
 <20210414165256.1837753-3-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <1b4d616e-35e3-6699-3031-66ea469d4e7f@nvidia.com>
Date:   Mon, 19 Apr 2021 11:51:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210414165256.1837753-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::14) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.215] (213.179.129.39) by ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 08:51:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f983f0b0-fc2b-4744-9ab4-08d9031048f2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4652506D91343506975665A3DF499@DM6PR12MB4652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLfQKr9KyTxzvvnvDo6Ncdy8MsAsLffXoXE25BLeGEcxF2evxBENwCsDDXIuCxObYOqJ8VFFBT7lGBxEGMOt7C0gINL21AtK0p1AouejHXitfx9+iqBM7jvAi4i6+/VVFUzXNTFhc0VkC/Do/kPYU+5J7k0Ex8LmO5hIAn8d30H0wNf9/nFHjTjel3n+jzSa734OTdnTkt9AZyrFPcZrczMIoJtZkFwRKxgHD9nMFLStBgRtA7WS+F2Yc814NalE/2Rj357JQQ41mo1bQrGCWH575H6z7MWhTrcnJCNK8I2hQ+iPLKxmZ+qqvQftfW7rvhQtSg8xxXB4O4FMC52yIuQx3Pf/F05U6fRyWx3usk4tX/SQR78TYpuisbyVD+1pnxSa+DZLBo+mSEucCadRtbu5iMOQssEGWaUsh0dG2oBPDlVlZ/Uhgtqh4Btng79THPq7LY1+EbLkm6x2kgoR1RD5Uh5HrV4SLexkS2v0ijXo+NehBXkvAQKadB/sKb1cc7fGZvQXe6inQJGOmuOUJrouNOG9gEyIt3aT8JetfXslTn3QZ4hoIIJ7qAHRh1WLV4Fsk1fRsoxEwpO7srlVyEvJGl5GB1Sj4L2+jHZMIog3XNtxgpl8qD2LQFlnfwf399lohp++jorTia0MN4OpVBK2I6+cAYuMICPLG8pWwKANh+ip8/eMiuMnjxka4tgj/M94WebGgQOpmHglOCA9cOSQIAlW3OJ1rqpP6bVgXSC8TfH0fbE+G5OYWLSOgpzk3aNe9Ky/M/sxfdOhFHVuPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(16576012)(316002)(66946007)(6486002)(6666004)(36756003)(2616005)(4326008)(956004)(478600001)(66556008)(8936002)(8676002)(31696002)(5660300002)(31686004)(66476007)(26005)(54906003)(2906002)(83380400001)(16526019)(86362001)(110136005)(186003)(38100700002)(53546011)(966005)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cWtHWWJBcXU2SmMrc2g4NWY2c29lcXpWclZsN2tsaUt6QnN1U0NrQm9XVW4x?=
 =?utf-8?B?dEN4SGlCWkovTDByQmZGWjJtdVN5czZsL2tERm00MzJRUzREbG8xUW1Yb1kw?=
 =?utf-8?B?Q3F4Vy9EOWhKNWlYbTJPejJBNHZMUjc5SVZtaWYyZEpyemNGMzMxRmF5WDZZ?=
 =?utf-8?B?ckZDUkZHb1dvb0ZvMjh6TVJaOVVmQzBNbllKc2JmenhxbHpyTThZc2hrN1dw?=
 =?utf-8?B?bGxzakxISWZDQWpKOFhlS3hRZEZpbkY0amdpdjdGTGJHVmVaaGJWSjdZVUJ0?=
 =?utf-8?B?Z3VqM2FnVklKajZKRDFOazI2QlQvMFVWQmEzRGNzL2lHQWhYcTFiUXljSmQz?=
 =?utf-8?B?OThCbmhINFRTb3lHcmlRZFBaa2VFZkQzb3NsRERGYkFTWEFCOTlvNDZ5bC9N?=
 =?utf-8?B?ekxrOXBUaVV3WHVCQTlyQzFiNkt6VkZkeFpzOEpicCtTS2N0UEtDUm9ncHpY?=
 =?utf-8?B?aERrT1djaTlxa1V0UnJOcitGZzlob0ZPRnBBL0JuRjJSVDE3dVRKVDFEcFhl?=
 =?utf-8?B?YUdtdkZYcm5CQWtEbXcwUW94VkpabzcwdGRSOEY1TmRRVXNoR3BGNGdIaWRQ?=
 =?utf-8?B?cldEYjBRcW1IbXhoQnc0aFNoY1RzakZCKzV6M0MrZEY0amFJOW42aU9iaTlu?=
 =?utf-8?B?SXBrYUpNZ3V3eG1jVzZhcjJuTkxPS284dk5zVCt2SlVBWVkvdG1QQzdDTE52?=
 =?utf-8?B?SkZUUFdoZEJrcGw2cEYwNFNoSHoySncva3lsQmllcHBwQkV3OStIaWQyM3pm?=
 =?utf-8?B?czV0UzdkdnB5UUZZNy9OOWdKMnFzYVVhM3N6RFQyYjVqaHRaVzhDRmhZOS94?=
 =?utf-8?B?YTd1ODQzWWJVOE1hOXRlQlRFcFU4YStoNERHVVkwMjlIS2tuL2V2VnIyOEQx?=
 =?utf-8?B?MnY4MktIaGgyMUJ5eVV1S2F0SHZ1clp4aUxTbjh0UlBxaUhkbWtCU3JCVzBM?=
 =?utf-8?B?Mk1HbUhJSDJPRTNhODZVUHJpaGFlNkp5MFl2ckQ4Y0dyakpkbTNpTVVRdGlY?=
 =?utf-8?B?T1lyNG8rTTN1eVRLM29sdWJxRitQb2dPTDZzVlBodG5tTkRvME90bHVRNFFE?=
 =?utf-8?B?cDdOZWhKSzVFQzR2UkNTM0xvbE14RFAwSXlCQ1phakcvWFhGS2JGVVcyaUdz?=
 =?utf-8?B?YW1qMEppY2JweEkvdVhmdm0yNVU3bGtZelhiSlNDdGJEOHpVVG1TaHROcDFH?=
 =?utf-8?B?U29YaVoxMU81Z0t0RjJ3V0lObWl2YlRvTFlnOVJVY1ZTQXZ2Y3daeG04Ull0?=
 =?utf-8?B?Z05UTTloRHdNaE0ySHRFTWZWcUh5RklnT3hUQkRYU2NpSERrRzVZVnJxOThK?=
 =?utf-8?B?R3YveVdVN0d1QmN5a3dVNC9IOHk4Q3ZkRkp5eTZNSE9YVW9uQWoxWVFic21r?=
 =?utf-8?B?WEhUZEM5b2tVN2gyVE5WYm94N3lWVkhNandmRTljeUxJZS9INE5WOWhtQTV1?=
 =?utf-8?B?bkViMkkrTFVhT0l5UFZtMExwc0FPTnpIRU5KZlJuNWhJemNxeUk1VzFXVUZF?=
 =?utf-8?B?aHRwb25MVUxBcWkrYzFDTXhyaHZMLzNiZW8yb0NISVowYndxaVVqU3BWYVFH?=
 =?utf-8?B?eU9SS2VyTDZPa2RFeWV5VUR0a2g3dXdQNHhRNzgya1RPMHNqRGE5eFpNcm4w?=
 =?utf-8?B?YnFLV28rcUl0dUV0SXdhR0thTWhmWnRHb1lKa2pDQ2lUc3lLTGRBWVJSYWJP?=
 =?utf-8?B?S0xWWWZMaEdtcnNXWlNhaG1zU2E4REtKcENmWWlFQWFmbkhnTU5KVUhGWWN0?=
 =?utf-8?Q?xRXEk4rvm0ekQxipRKPBqQW7bYmSJkFwWoDIFdM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f983f0b0-fc2b-4744-9ab4-08d9031048f2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 08:51:13.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rllAyYOWhTFV+7unFtScZw9jocHI1eowdTsMq9NkX3JAMyOntHAZbfLT25v0kXL6gFgeqlqJwEKveYCf6eMBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4652
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2021 19:52, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in bugfix commit 6ab4c3117aec ("net: bridge: don't notify
> switchdev for local FDB addresses") as well as in this discussion:
> https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/
> 
> the switchdev notifiers for FDB entries managed to have a zero-day bug,
> which was that drivers would not know what to do with local FDB entries,
> because they were not told that they are local. The bug fix was to
> simply not notify them of those addresses.
> 
> Let us now add the 'is_local' bit to bridge FDB entries, and make all
> drivers ignore these entries by their own choice.
> 
> Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c        | 4 ++--
>  drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 5 +++--
>  drivers/net/ethernet/rocker/rocker_main.c                  | 4 ++--
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 4 ++--
>  drivers/net/ethernet/ti/cpsw_switchdev.c                   | 4 ++--
>  include/net/switchdev.h                                    | 1 +
>  net/bridge/br_switchdev.c                                  | 3 +--
>  net/dsa/slave.c                                            | 2 +-
>  9 files changed, 15 insertions(+), 14 deletions(-)
> 

For the bridge change:
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


