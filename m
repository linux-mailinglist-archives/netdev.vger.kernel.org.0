Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D585E37F754
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhEMMDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:03:35 -0400
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:5120
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233061AbhEMMDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 08:03:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVacEukWTeGatZ6+TnxNBrCIt8LBuFB7+nXD6bCxTvWufg1M710hkC1ZgJ6CIR08wf5SpJqcZgL1Yv1TEz169YdAsjC1GDCr7qwQ3bPJP3jQDWRFb1QKWEM8nMHKXlwBSaxC7qbXzqeToIm8znYWcPX3JF63+vIn8CnCTe2OIgaqzwAzKR9P0/dtHU0RAClPzvaenHmsqzh/g1TniRs1Z3katCaIk45W6l8bpyIw9aiGbW8yY+z/adsmwycJOHWLI0iET+/WdqKay9eYFMd3yx7lUAqMETBAb4VghxoFZaCg395OXgd1xDIEpi69+IKgpIp+PUjc8r/67H6wUDEFdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdpyEYmZy2LSYRhBT2FcVK8Zyrg+vly7pYR7eqZpjqQ=;
 b=B4RvEpHCPo6w2lpl9ED3SWYew2Ex80voLVqfQBEPwKHzcG4i/FXUiwAf2bR9BeDKTsvQrlTL9q8Y+3juwVU3dJL/1+ka9NIrEKlwtxE+I+39AZ0wAvWJGukCQJec1KI7qnL5dlYzp92w0IWiwgS61tUnqi8nkSL3/FnfxPZwyg4zcZA5FlRlTEpIwN6EN/HPHs5qC0oyjqh0nCGhv8PQnQFdML6XOQAO4AjWX0CcAwt6GUuMiS30UpxtyNkYYUSflCFc7ASCHaeMtcnvOSK8TewZwXAuIhEkUu30mRjR0sVByY5PWhIt800qkxqBMpepmXPBjLiu0arMAKwJsBKKLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdpyEYmZy2LSYRhBT2FcVK8Zyrg+vly7pYR7eqZpjqQ=;
 b=OFqmVF/6YDS9AiNsapp/n/ha3ZpFioDyL14nyau+lwCByFqmSyftlmayiJ+F8KPKNpfTx6/nWTb+53Kz/1GLJMs1zIOBfu3NtoEBqKZGWb5DwAMwDwmhQinfe8SA9qOEL1gWXaezHp4cLF3IU7s06vYBJKHX3aICqM+CYNYs4nLn2mBUTUWA4D57PC2KKm4yzRGi0Itl/gioxOyT672G5W/qQ7VfkbNQ11L3M6X5je37ye//WIdcUr9ps4VBH6ZvOXtvu73K5LIKJkgpRf6FIE8Lhc3GBxMUB8o2sCm/uASwUvBAFmwkZQpvwa32eSTbK1E/8SYEKCNLFlGN8218Cw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5087.namprd12.prod.outlook.com (2603:10b6:5:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 12:02:19 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 12:02:19 +0000
Subject: Re: [PATCH net-next v3 00/11] net: bridge: split IPv4/v6 mc router
 state and export for batman-adv
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <c5634f19-f9f3-5966-a5b3-a0a64ca4534b@nvidia.com>
Date:   Thu, 13 May 2021 15:02:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-1-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0004.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::14) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZRAP278CA0004.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 12:02:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 873231a5-e66e-4624-76b0-08d91606f59c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5087C4BEE38A15A9EABB9BCCDF519@DM4PR12MB5087.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VlLsKHzghCCW506m7n1Yeyxxv5jYdCfnJgdGrbo5nLDDYU5xwOm8+I+MZiP10J3ETk3W4xC1RlfHQySacKteQfEQlr+94CuAz9GpLiGWD8p3f5kM3jJRSHBMTM1pDR1zDl40XsjYg0b10rTdsQdo4e2gqNRj/S2Q6WDZriK43KxftojwKvVa9Wqudx4ZVY8wIQOZpdG5l28n8yA983do0gHd07sWz2fBMP7EYMyeqWvIM3rNya3ROs5nMMDuZgv6x3J43i73KaO4scuLnj3q+037skq1bBchsJLXQprqp+dbAf6h5fptMgRhtYuu2/X1qynx2dy70pEWWwd6LvX7T/AvdsIoldliIYVASYMvgZ3V7psCyztXlN/kURr0f4icKWYZtofW1WDMhGyIR0UHce3xpPi55oNWFJE7Ppt2q/OXGpLc0vIZHrA8+DfGVgbKgeZ6VifEyVx7RPD9a4W8VfzTbASr5lBMrUqAqqceJnKiMdXgtiD2sqvxkdgKhiPO2xPpuUKNl4LwQHsx/tEcTFN1DjPJWI+fEejcvNj8L6Qknqolo35dh+GdgZFgw/hN2r24/upVckZWceNS0CtnfeeQO2MV8RREsTGJB2EKpbgRSFudTShw8NXNpYB49n7JMWgR3okI9ck4nb6EkiUax134zwu/oNghtJWAZfT+goNDp6i64Y9E5HjOqvrKpUQOkXZ4Bsp0N7ZOprGe0puU1zFtNsr4Ge78MRhzU+g3uBUXGdkbZT/nmPo4jSY8FUC2Lx0ZMvjfh4MMVipVBeayMt5xpeux1YA4Ox473cxRah0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(4326008)(6486002)(16526019)(6666004)(186003)(86362001)(31686004)(8676002)(31696002)(8936002)(53546011)(26005)(5660300002)(83380400001)(66574015)(316002)(16576012)(38100700002)(966005)(478600001)(36756003)(66476007)(66556008)(54906003)(66946007)(2616005)(956004)(2906002)(80283002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YStQOVlYRFRyTEp4dnlwMURTZFRCWVdwUUU2QkdtT01HbHR4bmE0bFJlTXpC?=
 =?utf-8?B?YmxNeTVpZ3JOT2lSNXMxd2IrUDNLMXE1czRxUDEyTmZlL3VaRGJPa1RFdVUy?=
 =?utf-8?B?blovVHFuWDBhR0ZqVFUyMU5HL21NVTE0T2dOc01ZYW1WeGpLbXdYeDVmSHVh?=
 =?utf-8?B?YmJFcThoRTQ3eGdzRHNoWk9RYjY5bG5OZHFUa2ZjUDdtd29rd2dXb2ozdW5p?=
 =?utf-8?B?Y29QYjUveGcxUHVFVlNRU2FEbCtUeUk3SkpHWHQyTDVCMk9BV1l6emdXb3A1?=
 =?utf-8?B?cElRbmNOdm41YlZXQ0xpL0dKaTlOSFgvNkhGYnVDVEtQMzZnUEJlN2RxSlZH?=
 =?utf-8?B?Ti8wVkNVUXpwaGxFNHZwakloT2ZLOE4xWEY1amFSa2dXZVVlRXBqK3JXRnd6?=
 =?utf-8?B?ZEhIQWlpYkdiOEZ0cTEwVDdnUm1ZUEZyWFpnK2djWFhJTFFYN0I3RkRoL25h?=
 =?utf-8?B?dVo2MHVJWjloOHRMeEVWek1oOC9TM3h0VWcrTFdhTEhQdXBwY2NxdWt4ZjMw?=
 =?utf-8?B?T2p1U1VzOFNzdk11WGdianNvVXErUDNKZjh4cTJvVTNyTUZBZmJNa3o2RkJt?=
 =?utf-8?B?RTZnaFlXa2pGQ0RKRU9WbjZibFhOdUpXanVJQlphcEYwTmJrQUlaWDZuSDhG?=
 =?utf-8?B?NUE1TWZQN0ppZEkyRGVvUUd6ZTByTituNTlhNHFyNWowaUxSNlZrcDBsMG1C?=
 =?utf-8?B?NVA0NzZCYXdaMGVGU3oxMWl0VUIvS3dIWEo4SFlNWGlVTTBBLzhHMmxLWExZ?=
 =?utf-8?B?KzIySVVMeXhhSHN4TlNlUUR3WHNDU3dETEN2UU9iUkpKSjV5bGdLTUZoOG5k?=
 =?utf-8?B?aHJYTm14MmFFMThJQ2oxUEcvVWNaYklsN0NNMkVBOWhCamRNSnM1Z25ySjhp?=
 =?utf-8?B?MHZUdXNKME00cFdLUXRETkRCYzQ4UkRFMFZYQUhWUWV2Qnh4TU1Jdll1dnZW?=
 =?utf-8?B?QWh2ZHpod2wyWkp5bGx3UXVuZXNUc1JZZTJmS2huVy9SM0JHbUV6c1NFREYw?=
 =?utf-8?B?VU1KRnNZOVgwdnF5TEliS0thYUIxL1QyOWFZU0xPTmZtWmVOTVZKZytmR3do?=
 =?utf-8?B?bUxpdDllaXBBM1Y4U3VwdEtjV1plelJsSmwrNkNnQzdSNXhxb3VNeVdnMnNO?=
 =?utf-8?B?UDc1SkJSUERZM1d4WitLSHh5YlFLekwwRitYQWhjUno3cUR2OFN3eWh0Qy9q?=
 =?utf-8?B?TTZnZ01EUldCWHB1STZlY3hpbmJkWmxFZ09nYW1vcFVTYUI1ZDN5d0p1QmZQ?=
 =?utf-8?B?ZVhzanVzcHpVakFuaXhYVTV3R0wwSFRKYmkzemw4Z1NqOS80TGlTbXFOVXhI?=
 =?utf-8?B?U0pDMVNva2w3bUZDdEU1T1FYY1VQY0dUT3pVY3VjQnRJU0VnUzZSQzcvSWRR?=
 =?utf-8?B?Yi9YVUpsSlhJNU5NT3QyMG13SVEzRTQ4NGE3Y0o4citoamUyL3dLdFBOOFdi?=
 =?utf-8?B?SEw5SGZnOU1nYzV0NDVFZ085dzQvUXZGby9IbERqUXNTOHBwMlluVWpyTCs1?=
 =?utf-8?B?VmdVVEIxdGR4RnhGa3JjN2xqZXRnMlVFZEZTRTBUeVRUU0hxbW9RMDF1Qmdr?=
 =?utf-8?B?aUZaKy9JL3dXb3pFdjZwb1p2cm82WVJOK25vS003enh5Z2ZEd1NsQUV6dDBI?=
 =?utf-8?B?MXk4STU0TUdwTGF6NVYvSXJaSXkvNWVsNmVhQUJLa2xJb0tTOEJ6Ty9NWlZn?=
 =?utf-8?B?cG5oUVFMeHRuenB3TlpzSTR0TDI0U3ZBNzBXcm1LRktVSzNsRElpNE8zV2hZ?=
 =?utf-8?Q?gXn3brfMmSAoIR+G+IbPc3h3MIjoXs/BYKThKd0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873231a5-e66e-4624-76b0-08d91606f59c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 12:02:19.7157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozmyrwX0EUQBcJNYkRdwxmYUw0Kwu+NO008xvEKR+I6b3qe+5B7dY5f1S2wiDhyVi8qWnxi7HksRSV4dOpPTPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> Hi,
> 
> The following patches are splitting the so far combined multicast router
> state in the Linux bridge into two ones, one for IPv4 and one for IPv6,
> for a more fine-grained detection of multicast routers. This avoids
> sending IPv4 multicast packets to an IPv6-only multicast router and 
> avoids sending IPv6 multicast packets to an IPv4-only multicast router.
> This also allows batman-adv to make use of the now split information in
> the final patch.
> 
> The first eight patches prepare the bridge code to avoid duplicate
> code or IPv6-#ifdef clutter for the multicast router state split. And 
> contain no functional changes yet.
> 
> The ninth patch then implements the IPv4+IPv6 multicast router state
> split.
> 
> Patch number ten adds IPv4+IPv6 specific timers to the mdb netlink
> router port dump, so that the timers validity can be checked individually
> from userspace.
> 
> The final, eleventh patch exports this now per protocol family multicast
> router state so that batman-adv can then later make full use of the 
> Multicast Router Discovery (MRD) support in the Linux bridge. The 
> batman-adv protocol format currently expects separate multicast router
> states for IPv4 and IPv6, therefore it depends on the first patch.
> batman-adv will then make use of this newly exported functions like
> this[0].
> 
> Regards, Linus
> 
> [0]: https://git.open-mesh.org/batman-adv.git/shortlog/refs/heads/linus/multicast-routeable-mrd
>      -> https://git.open-mesh.org/batman-adv.git/commit/d4bed3a92427445708baeb1f2d1841c5fb816fd4
> 

Nice work overall, thank you. I hope it was tested well. :)
It'd be great if later you could add some selftests.

Cheers,
 Nik

