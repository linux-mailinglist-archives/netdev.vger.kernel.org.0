Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF237F6CE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhEMLda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:33:30 -0400
Received: from mail-mw2nam12on2087.outbound.protection.outlook.com ([40.107.244.87]:35393
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233374AbhEMLd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:33:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiHaj6ItR/ttmaOmWIWEvhrK9HNLzPVjiRkSMtUE5SGdu+JdcUL5VBlgiegD4m0USMRHUWP0kV/InibPAQGqMo9LI0a/lERRv/Pu+2yDawDF3s2FL58Q1l9MRhjAs3tIYe2K5ancqFsff100Z2yANJjzCPK+TjXwZIGXme9ORTok9Lvy+tJH0R361TiRzRBWHJ/ChfCF3wbh2+dyAPNoq9h0sOvNNTd/BoeuwcXZybk76/vYgYHzAKyENuXZFUDaE3J51YxFsTElQx+YbHNQ9acEF5pxfI0uUnejnufq3A/8tFRK3V4OrwMWIFybe7p7tewk309hLwYoTUDdauoqFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbzVia14gGixUTi2PiNzvrcGuAixaykfj10i3Izqs/U=;
 b=L/t8I2VacNDFq/KYcSgd83zI9IRyK2cRAPkC0xDPSoORax+TR72Da5k2UMgXkCeD1CCokeO4MjMHPTENMLwbD76syqIkc5l2BZAcyOqs8Zg3qJOKJHgCNTtxrEdSwIxvRk9b7BDu+AH0iOidoEQ3U6Kiz1yFehn/3cyDNGJgmJiGSdWoptWbNa3zFGj6v6Oc/68GUeiCgXlay42HqgXeqBzAkDXnt8tw/QHls8MFe5hPTeXTecjQYtWaWplbfX81/Y1U9Rq4lh2J7T0HQ3DuCopagzPx7JYP7qZTdFBmmMUk3Qnjcx541J5hlTrzl6LD+tup2ujapCywqSma6ohJAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbzVia14gGixUTi2PiNzvrcGuAixaykfj10i3Izqs/U=;
 b=TTLHoP5fIJNwHZIiBa+NWWapp6joBsfViglzCJoqPeUXScAMEIxapaK2z+k9Q2uq+jyNILAnXPUKgj0nERaXqFK1Koo80cxsf0Z+0N3dfqHhSistCHLKsJDzShd1CY1eH2I8lRGlxNKx9Xy/+IvYYRyjQDzNLpunVYJp+kG0NHd9sGbsvzLlAYKjCGlyOEDxDeivHe+jVGFwYyISRK8TzdYflWT0C8p7XDjTl5CJzxFMnlhVdWQV0yw/2CEbdfFc5SnByPxL6igSeFOkHOfwanO1vCp0ULTGYSAPf/djHg4DGySAFad/wCpVPEJEPQdXnlsnk3OSfJSRV0phsy7cxw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5517.namprd12.prod.outlook.com (2603:10b6:5:1be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 11:32:17 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:32:17 +0000
Subject: Re: [net-next v3 05/11] net: bridge: mcast: prepare is-router
 function for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-6-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <1e18b246-1efd-98ef-60a9-3bbf2a7f06e7@nvidia.com>
Date:   Thu, 13 May 2021 14:32:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-6-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::19) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZRAP278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 11:32:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ce636e0-1913-426d-f953-08d91602c341
X-MS-TrafficTypeDiagnostic: DM6PR12MB5517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB551733B25FB7A00C257BCFFADF519@DM6PR12MB5517.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huaEi1u5bzfOAqcn4PfAkBlxNQyCGpnqrtIKm/v3eZfE0B8FBrDHAsUz1PqeS4i2u7HDYH3LurvDK4OVMnH/UaPdWTasigUjHUsljFFamu1rn6/SWspfUdxb+zS8kub2Hn3jVX7I0kaCq8/eMWKrthiEMA5gK7UHpPvWccEQLRhNSpG3qvzteYOp1uvjkpv++YXOLpzFfLUNDRUvjdEob9Lab6nUOLddfIjwo2vvXYmgmlRyi21GhXdKLvUKerxC95ZsQW/mRsxc+i3QauV6sm9IVPBtAK7URAPeHj5NwzVI0Ryscd2v+MoOcsqclFFEb/bH8/uUJfjgvHJJe5wh50N26mrxdmM+MR1/6wOqxGvqNBnf4KdtBuYSPT3R5ltxuoa7FXcjpJ803PoFi5AOTy/6uePCCcU7+jzVoG+lm3xto60RhJ8srbU8dcLoSgLutoMF+5RzQgnUe4v1PJdebquWXviiVP4kOXltk/2BX756vgklTKN7KwP6rdMJh/FY44JyCXz2Cl5Xu5X6BceY8RY5yEvLbnBRGPUGeDZz1dLIFLKwTUQCN8GRSmDH+A4FrEhdy/I7BOTAc5300ZDM8r6PhbgvNIwV2IeZOpz1ty60y2sO6xB5qAnTOt2czfdExPSDq97aRh09P5mRzWJH4bCUn0qoA1OX0ehxgxRNTPn7inJEgMlrqCznH7qG7nI9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(6486002)(8676002)(54906003)(316002)(16576012)(478600001)(16526019)(186003)(956004)(2616005)(4326008)(2906002)(53546011)(5660300002)(8936002)(31686004)(4744005)(26005)(38100700002)(66574015)(36756003)(31696002)(86362001)(6666004)(66556008)(83380400001)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cjFvNERQcHY5Mnd1TGNNTjFCeDJ6NFRzTjRVS2VSR1FNU0VFbnAraVdLM0hC?=
 =?utf-8?B?eTBsSnRiWTJzbHpEWEs4QnEwYkdhMXh0TEpYbHM1UDJDMDBLdVdRMlk5T1FU?=
 =?utf-8?B?UkRSK1h0d2RrUXNtL1lDb28yWnV3NEZTbzVHTU8xNElZenV4bUdPNnBGYU4r?=
 =?utf-8?B?emtzUXFJaS96SFQzdjFrcFp4ZEx5b0pGKzNSUmRKUmdqZksxZXhxQXk1bGly?=
 =?utf-8?B?WDdFWXYyR0c2YVFZOEVTSFk3endpcFFVUmc1bjVCeWNFL3JWMkgrME5yQnV2?=
 =?utf-8?B?MTQ2MHRoSUhvQzJVNFE0ZUxRU2tOR1hMOUVGZGVhYzdXWDAzRE1sVEVkV3J5?=
 =?utf-8?B?UzJ6ZldFekpjcU5aT0ovYUJNbk5iOUlhRWtETHFJSDJKZFdnOGRhaVJXRkdw?=
 =?utf-8?B?OE95QzVUckhhS3ZXUFlnaktiMmgyWXhIN2RBSXVpNXRMck1VcC9tYmNXZFVl?=
 =?utf-8?B?WjExYjZpbXZLamRtQzE0RE9BUkdmaGY4djFOUEg3MnlkQUY2ME80bXEraGlj?=
 =?utf-8?B?RzF6ek9ZL1RjRzdzRXhqRG80cEtqOHZrTXpUZDBzRUozOXgzaUNHUWNnYmsr?=
 =?utf-8?B?RGJKTExMekY2Rmg1YUE1aWlJQVAzaVluVXl0bFFaNVR1NENOZWZBRkQyOXpL?=
 =?utf-8?B?dXJHR1BiQmpQaGYrNjNnWDhKb1Vpd3IxQnJWOEJDK0p2TGk0NHVCSEM3VjR3?=
 =?utf-8?B?TzdrS1VsWURNRDZxR3ZuMUEyb1ZXRDIwTGtQQWFVblZ4WFNMSjJiSVZxWW9Y?=
 =?utf-8?B?RzVjdktKS3B3R2tDY0NqTkY4bXg4WDBkd2xweUFOempjYWtBakE0cGdHNHRj?=
 =?utf-8?B?N2FNV1NVdEpxTFZia0lBSXpMd05DclZoanJQMy96RHFGWWN1c0FMZ1JQWVBh?=
 =?utf-8?B?TklhZ3BNU3JFcUlZVDVtNTVXOVdxbUE4SWEzSThiaDRSMDBtT21NQVVNTzUy?=
 =?utf-8?B?NHBROVdpM3k4Zmdzdm9weXhmVDN1Mmg4VnVCS1FVcEJSMVpjbk1lNEY3VFdl?=
 =?utf-8?B?Z0VxNjlMcVdOWG5OVHJyY2xwZFhKT1M1cmdTd1NGT0ZqSWVGSzVBcFFPZU1D?=
 =?utf-8?B?UTF3MEQvM0V3cHRxSktOa1p4bU9tK3JQS3J1aUVkTEZxWmdrWnhiL21IanhI?=
 =?utf-8?B?Y3VlTkJ5eVpiTmNNZlhuc2haNGgxY0xYc2d6dWt6UHJ1eHdRNEViYTdqS3g2?=
 =?utf-8?B?M1dEWm84bS92WWxNelBiRWpYcWNIcmtHemlWUnVVKy81NHZBQ3ZzV3N6NVo2?=
 =?utf-8?B?WE9hSjRmOUJXZEw5bEllYk1acVNVVUEvSk9JdHMrZDI1aGhyeW1zaDVoTnJV?=
 =?utf-8?B?T0RNZkZrdlI3Z2k3QW14UzRHdUlIRGpoZWZYRVBsUlFWRWtFNzU5cDZSb3cy?=
 =?utf-8?B?UUdVQ3BaakJDVjdQc0hONHE4SzY0ZUlhazM0T0w2NEM5Y3d4WXYxL0E3Z0po?=
 =?utf-8?B?QzFjTlhSNnQ3S3dsbzRpRGM4d0h2K3ZqeXBUbFVJdFdBV003THhKMlVaa2Mw?=
 =?utf-8?B?Z2k3SC9kZ3dINDZUOWhwU0FOdCtBd3VsOStSNHErd2xpNzlwNENwd2xGMVpy?=
 =?utf-8?B?SVUvRjBSYlpMWDlOVGFvblZjVlMyS1J4RlNQYmpwcElsTlh2eXE0SEVFenZs?=
 =?utf-8?B?dFFMWHloSHRFMlVNeEgrcFBFN1JIb25NTjdiQTJpYldBLzZmbnNDNmtkbjZk?=
 =?utf-8?B?Z3dFdkQ0b3l2REJxcEZvenVOMktCU3hJbDBzbUF2TTFsOThBYnlLNktCa1Yv?=
 =?utf-8?Q?r6pJrc4zWqIZeMZse+eipU0/nmJ2zkBJcdfTJtE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce636e0-1913-426d-f953-08d91602c341
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:32:17.2496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yN4XuzINJ4TLPHTWroas76qNEF22MB6TFMf1sukCqgDBHBbxh26El5nS3eah16F+nb+S913pYsS5qSIpOe2pqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5517
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants make br_multicast_is_router() protocol
> family aware.
> 
> Note that for now br_ip6_multicast_is_router() uses the currently still
> common ip4_mc_router_timer for now. It will be renamed to
> ip6_mc_router_timer later when the split is performed.
> 
> While at it also renames the "1" and "2" constants in
> br_multicast_is_router() to the MDB_RTR_TYPE_TEMP_QUERY and
> MDB_RTR_TYPE_PERM enums.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_input.c     |  2 +-
>  net/bridge/br_multicast.c |  5 +++--
>  net/bridge/br_private.h   | 37 +++++++++++++++++++++++++++++++++----
>  3 files changed, 37 insertions(+), 7 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

