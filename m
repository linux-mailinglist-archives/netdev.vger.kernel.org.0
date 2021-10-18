Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B387B432640
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhJRSYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:24:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26940 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229980AbhJRSYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:24:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICKCv2024145;
        Mon, 18 Oct 2021 11:21:58 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bs1buk984-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 11:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFeZzIwpm/NwZlixLoRLSr747p17mXu4/3QUHD3FHS9IBkF+WYlx8mZSrF5lMx6igfGMAkKwvaXfmB8jYfGyICK/X7+LQKvPuSVaQD7nK/d4AaMrymmPKTrdc7fn88vA3XJM7sk+hUx1rJPxQL9/6bv4P5+8aynanVJJwOB6s1nIiWN9OcoYQzgAdObamgbLC0dXPpGcG228tIaDymuh2Op2Dk/EyfBxWtDCILalhQjFbf5PCf++eVn5nbuGr5YQ2Jqgl4BR3J9wL16OpsUS/ZwI914JAuqNIItR/5YnjVqsLZr0s60c4ARtIz/LLq4/F4pHiKbw6lTpliZHuhBDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TY2s0vy7NccLea/LcrejGk0hF4frWcpwDesWsXXJpZQ=;
 b=VWURxpNZi88XLhlDzc+YB3vREcx+0xbPIK6Wuvo8/ujfzFc4KgBO9gCZ0WqGX8HemQyzWqs3G/4iKBAeprdaPb4StZqt85KPjatDpZUU20xrv+f23DIRYa33xVL4Qx73zGxIVYhregZ00UQms1z4BqrGSzUTklF1ghJ/rcKlAT/W1OwV66tMinszrJEXc4w1rRYxN0IlGN/7gB/Xj3NRtHwyFr22emImNsw6yhQxkSmhXE/VYEEHBIa+hGlkrvH57xu/FGgNuAovI7Gmmh3fZQIKqQhXiSMwZI/x38Pv34/l6rc6xzFcaQi6+zNVtS8jK/UTvUfCVdanlOXtAJLfIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TY2s0vy7NccLea/LcrejGk0hF4frWcpwDesWsXXJpZQ=;
 b=qw93V/4c4zi734TYRKTHy9uc6TeLK0YI5PfuLBDMJ5ZCpFfUtoBymm+8d+pQuWspot/ry7S77fZigq0xWgOTENMRkXOY9+VpoLU+flAAZ7GnIDuTuy3J1FRxgAmqD0phfXhM/3ZcCgGosd4A5+Pz1/DfxMh+J+beraYqu17G/XM=
Received: from CO6PR18MB4083.namprd18.prod.outlook.com (2603:10b6:5:348::9) by
 CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Mon, 18 Oct 2021 18:21:55 +0000
Received: from CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::85b0:35ef:704b:3a19]) by CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::85b0:35ef:704b:3a19%9]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 18:21:55 +0000
Message-ID: <3bc71e9a-8e6d-abef-708b-704e3b78c3d7@marvell.com>
Date:   Mon, 18 Oct 2021 21:20:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Re: [RFC net-next 3/6] ethernet: prestera: use
 eth_hw_addr_set_port()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Vadym Kochan [C]" <vkochan@marvell.com>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
 <20211015235130.6sulfh2ouqt3dgfh@skbuf>
 <CO6PR18MB4083DDE34183B96B4D882D60C4BC9@CO6PR18MB4083.namprd18.prod.outlook.com>
 <20211018100141.53844c4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taras Chornyi <tchornyi@marvell.com>
In-Reply-To: <20211018100141.53844c4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::23) To CO6PR18MB4083.namprd18.prod.outlook.com
 (2603:10b6:5:348::9)
MIME-Version: 1.0
Received: from [192.168.0.122] (193.93.219.25) by FR0P281CA0084.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Mon, 18 Oct 2021 18:21:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a0c0838-4c6e-4d75-2e16-08d9926429cb
X-MS-TrafficTypeDiagnostic: CO6PR18MB3873:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR18MB38735E1C6DE91F93960FAEDAC4BC9@CO6PR18MB3873.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ML0sKtBypnM9vJxqkL2G3PiOv8LRdwY6k3MzoXWzjVd8kfbyQEOFhS1pnYutWCbL/gtm9pQLp2fPAA3ZNLKGIGqe3Y7PWD/eKMc7KNPZyNm0giD6gkLwpdGtmhuy/1NlxCtFO4lHzZTlk7GDv//6OD2xCSrRprQHawiPoweePXRqy5wHg5dm+vBimVqCIrsnBu4Er9GVCijgAwm0ftoUVZiz0DYhBP7Mw7tKbEE9+9WvbOVktTlOZg7i+ZNLclDFnmsH7IKqKA1voGgqRkIFeODhtbL6EAxX8/Ia4LQhWtmCJH6zJRAP2KzDPLZEINvBEFcb5ZAH3ZS5p9A1GgpZcG5OcHV7Syo62qZ6qj/lV7lJXtX7FarRQS3GqNcoII32pFsGKWciELmIl5IavmbX2WdrGe9qkZuwpeIzPI5oVfBCgc/0L8rl1BeBV7J8lQE2wLEfgyX8FQcUPvczR8PZhc9gFQe9EMUx3OYCBarYkIJD3lfpgcW8+jYCJ5BNuvkRrCeEzh3bzWaUfag/lbWoDyCWLDba+KHXvFpyzaJYcAfoY56ljmQ43I4ygfOhhNztoJSHGcurbomVKg6Nuwlta4hZhVuIDulrO58yabBzAepkYiLPUSV3OKduDCbPmyV4Z+RzdiYoR9oD7ZiWjX5MnUsBe/CqOeo6eFMYQUnITlBa5yzOVFCezoD78Ts1k3a5xpjyWyTEqFIP697jfJkPnki+/hR/c4eYkVDqTXHxJ7Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4083.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(956004)(8676002)(107886003)(8936002)(2616005)(66556008)(6916009)(86362001)(66946007)(66476007)(36756003)(4326008)(6486002)(54906003)(316002)(16576012)(31686004)(38100700002)(2906002)(31696002)(6666004)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NCtvSUNXK1Nsb3pqSUxJbStxTXpQNVFScEZyOUp6K3NLT3I4K3JGWTZSVEVh?=
 =?utf-8?B?WVU0N2ZXV2w0N25uY2FOd3RoMHYvd3F6eDVvTmpsL3NVWXJMYjN1WnoyUStM?=
 =?utf-8?B?K29MeHUzQjZrNkdUSWJ4NnZZaW9YZmhUL3pnNE8zMlFSdmJhVWs1QVFUQlh1?=
 =?utf-8?B?Umx0bjFBdkZkdlM1cUkrS3J3R2lvbzZsTmdSLzhOeTdLbzV6VUkwcmt5S0dh?=
 =?utf-8?B?SGt4a0JjT3B0TlJXcms0L3U0Tm4wODFMVDVndmpXLzk3ZGVPSktGdHpYb3Fr?=
 =?utf-8?B?WjI4cmhodUxFMEdFQVhqa2phOTFsdzdnQmdDUTJGdUtBY1JUK1R3L2I2dFRy?=
 =?utf-8?B?UzMvV2taMTRaTXVsTnpuWXlTeHBJbG4rOTVYZ2FhenNYbjhmcjZZUFNxTDBX?=
 =?utf-8?B?c0V0UFJXUHBmSE52alAxbDJpWjFLZ3BlYjRZcHowWmt6cGFZY2dlLytWNHhu?=
 =?utf-8?B?WTh4ZkpxUTBxWjVWNjY4R09DSGpqQlZEbG1JNTRCRXAzNisxQnR3dlpuRVlZ?=
 =?utf-8?B?bk52aHpSNW1YN04yVWh5YUxaZk8yMnpzNE9vUDdsaXlCVG8wR2lnUXVBVlQv?=
 =?utf-8?B?ZWVEZUJubXdIMnZsMnJ4NmV4ZjdiODg2Y0JyUnlGUjM5aHB6NXNYZGZ0bnBO?=
 =?utf-8?B?NnB0azFXMWx1TkhsclFhZ2FWTS9MYjJacHpKMkNXakoyT25FTFdKKys4Nk45?=
 =?utf-8?B?TGhOcUN2aG93ZXFTQ1E1dXhxR0d3ZFF4VE5EVkJjZENaMGxFSTdyTmVrMU04?=
 =?utf-8?B?eXF1VzFYUGN0c1NnR3ZqSEYydWcwNDRwK2I1c3FjdVdHTDdrVUt1NkluWTd4?=
 =?utf-8?B?UDIycGkwQytzODhMUERwUm1EMWJFWnBXN1VNOGtTWnNObTdXODlIQlJ6enhC?=
 =?utf-8?B?Qml2eC9sMnpBaENaMGNJV1hBRktGU2JUc1I1VzFNOU1hSDJ4bGdpSDJESTdu?=
 =?utf-8?B?MS9GYTdseHRIZW1Bc3dodVhzdmIzbklraHFmMGpoRlFMQ2hDamJ0VzNvaUFQ?=
 =?utf-8?B?U0t5Sy8rUzV6K09rYUlZcUovalVZV2xyOExJUENaRlhxcWhhditUNUlCclN5?=
 =?utf-8?B?T1BkSU8yTlEwZ1VObnhjalM5bHZQdEFIdDlTUGtScFVMRzkvZVgzVEpDT0hB?=
 =?utf-8?B?RWorbWdmdXY4WEhNUVg0T0NqZ1FzQ0lIdTdlQ29kK3Y4RHBKbDZHa2hWQlZl?=
 =?utf-8?B?RFpLRTU1OXFkeUhxZkZTSGVTR0E4cTZmRklNdHJWWldpcWpRT0dQdCtzaks1?=
 =?utf-8?B?TEtRREFoUk5DWUszQ3BJVEVoOXA2Rmt5YS9WYVlLdjNGN2RDbFE2ekhKUUo2?=
 =?utf-8?B?R1NIdXp1VlV5ZkIzc0NJM212R0hPQWtMeENqK3B3cFc2dXZNV0NBeFJjdDhq?=
 =?utf-8?B?NHNLS0dVS2lBNW9keFNGaU1NVFovQk9OSGkyMVdYU2o1SkQ5WVJTR1VCbSsr?=
 =?utf-8?B?QXRpWHVBUkl5VUI3UVJidGRwbGNHRUJJMXg4WGZsd2hpMlJaM3krR25mQXNv?=
 =?utf-8?B?MU5YRUY4RjBSalV3Uy9LOWh1Wm9VdjF1Tm5zLzlKUHZSQWJBSmI4NUJtN0Fz?=
 =?utf-8?B?dXQrbEdvZkNRSDg0em9VV0FndU1PZ1lJSHRZNlV2RmJOei9lWTZvcjFXdnVY?=
 =?utf-8?B?VC85MURqODRScUJYV21ySWFNRm9ya3pXTEpSSVQ3SGVhem44SG4yRGJGblpx?=
 =?utf-8?B?ZXcveS9mLzZteDE5NzNTSlNvcitFOEpZdmVCTjRnMFpCbVdNYXlWM0NaVlZO?=
 =?utf-8?Q?LcJovVcqSlk1TqKFX0op/fNwnIWwkwlBx7VIsxG?=
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0c0838-4c6e-4d75-2e16-08d9926429cb
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4083.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 18:21:54.8647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEH2+zdfph5bvWfMdVXFVsMJAa/y54elHjkQxltJ4/+3qXUB0UKbEGmjRhyakUqFiWePXzZp8jBq3ew3tHdrBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3873
X-Proofpoint-GUID: J1MyD3kYanly2KDkPyO9F7bKmeULH1gP
X-Proofpoint-ORIG-GUID: J1MyD3kYanly2KDkPyO9F7bKmeULH1gP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ----------------------------------------------------------------------
> On Mon, 18 Oct 2021 16:54:00 +0000 Taras Chornyi [C] wrote:
>>> @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>>>       /* firmware requires that port's MAC address consist of the first
>>>        * 5 bytes of the base MAC address
>>>        */
>>> -     memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
>>> -     dev->dev_addr[dev->addr_len - 1] = port->fp_id;
>>> +     memcpy(addr, sw->base_mac, dev->addr_len - 1);  
>>
>> This code is a bit buggy.  We do care about the last byte of the base mac address.
>> For example if base mac is xx:xx:xx:xx:xx:10 first port mac should be  xx:xx:xx:xx:xx:11
> 
> Thanks for the reply, does it mean we can assume base_mac will be valid
> or should we add a check like below?
> 
We can assume that base mac is always valid in production environment(stored in eeprom),
however if can we can not get base mac it will be generated.

> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index b667f560b931..966f94c6c7a6 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -338,11 +338,14 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>                 goto err_port_init;
>         }
>  
> -       /* firmware requires that port's MAC address consist of the first
> -        * 5 bytes of the base MAC address
> -        */
> -       memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> -       dev->dev_addr[dev->addr_len - 1] = port->fp_id;
> +       eth_hw_addr_set_port(dev, sw->base_mac, port->fp_id);
> +       if (memcmp(dev->dev_addr, sw->base_mac, ETH_ALEN - 1)) {
> +               /* firmware requires that port's MAC address consists
> +                * of the first 5 bytes of the base MAC address
> +                */
> +               dev_warn(prestera_dev(sw), "Port MAC address overflows the base for port(%u)\n", id);
> +               dev_addr_mod(dev, 0, sw->base_mac, ETH_ALEN - 1);
> +       }
>  
>         err = prestera_hw_port_mac_set(port, dev->dev_addr);
>         if (err) {
> 
