Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300B4231FEB
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgG2OHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:07:23 -0400
Received: from mail-eopbgr30050.outbound.protection.outlook.com ([40.107.3.50]:48610
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgG2OHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 10:07:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjlteluNnU2orJ1ZuWEUrRrhGLyxxzaMCxfckgRcgDCBaBraVFXNqWD8CqVGZe2B8ILj8Z1/zyHXYDI8Fj7MUIN6h93+RPSp3vS+FtiLxZdQFG3eleXjuz0TCsA9yHF/j+pocMcVMgQGWFStzNwwMbkmDzSeLeODt11R8TympluBWJftewXv67Ei0BE85Udp+PFrC31EA4p5cWAYTQbhe+0Pri2Urp90m/+qSmLImBHFVsnG1kozK5KUtYResvjlbecXxOhrmMoKCPmIrjBftfxwWvbFuEVRpeRZDt/I6ZRyZpQB0ARBSeKRDeKoM8scHuP6ryXSztvIbOf6GXZslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1VRRCGNamQaQvJZ1MpOoVKcy8iiR6ZW2HUf8/2290E=;
 b=AIYrNagYCndK4la4e9Thl1Et71RuHgyHD9QhXinEGW59tv6j/D8RtgcXmZvKdi+6StWHmRZaQDqw1SYKpCxUaID9P5WuqNF6I+XZ2wv+tsikksd0QyaPdErw42kL2UA5JYceeZd5Gy0XOSBsdAoePPCvqUYn8zPbYldAeyc4eRbIQ7cZTSStly6PIcDgq/dnCzfRqM8f6dJ4klW7YTHUu+PD/4uMWYYXWmi6Tac+hEWAu7WqpwUGH6ex/Q2tzVv/HLw7aJnrjuTyzHl94lvmzID6MVb8KyWYtuKxf9qyANnMe4uw+fEKEAmBX8b8WgBe4mzznshkG640KT2gf92GGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1VRRCGNamQaQvJZ1MpOoVKcy8iiR6ZW2HUf8/2290E=;
 b=LAWE2efhixKwZUO3yATDz9IRId5iQNNde8h56WinmaAWMvpZ9QOTJmhigVJfn6G2hx0lyjKvPf0lDLASG19iSLwRUW9P6YBKs/oz0WaIY4rC4ub6Pd/SgMLSBTJXrrO8y8rtnlinz0P7I/LO8rMcyld0+b0RmnqDYS8j12+XAzc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3116.eurprd05.prod.outlook.com (2603:10a6:3:da::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.27; Wed, 29 Jul 2020 14:07:19 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 14:07:18 +0000
References: <20200727090601.6500-1-kurt@linutronix.de> <20200727090601.6500-5-kurt@linutronix.de> <87a6zli04l.fsf@mellanox.com> <875za7sr7b.fsf@kurt> <87pn8fgxj3.fsf@mellanox.com> <20200729100257.GX1551@shell.armlinux.org.uk> <87sgdaaa2z.fsf@kurt>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-reply-to: <87sgdaaa2z.fsf@kurt>
Date:   Wed, 29 Jul 2020 16:07:14 +0200
Message-ID: <87eeouh0tp.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0021.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::34) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR02CA0021.eurprd02.prod.outlook.com (2603:10a6:208:3e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 14:07:17 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3feed553-df35-41fc-ca3f-08d833c8b46b
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3116:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB311660B414ADDA13288EB5E3DB700@HE1PR0502MB3116.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9xDM5YR6c0gCr1bDG7nGt7tPYTSdFN/kWvszNvMWfp+/vCTDaOsQpxtGlV+qbreXPiZovBlpqSAhWC61VOKsl6U9KHNsq0KDXNcHHou1Gr8FcgdOwe2IEthQkEDKSaMgxgdOIGO/QgcwiZ14bJqbmM9185rSFghuDydlaA1SvV90aEFEko9UROx3mQza2G/OoUWHInm24Yq+Km4xXLpsyVviyxLvc3jazPkuou+Ib+vCSpeYGzq9UtUqFKH+q9Pl0BfWUlfHpo7/eVZpp/xXL/Hjf8aoYwfxDGRY3DMb+6dATYAYpdVsM5iBLhKpj5FeKvtTXM7NChCp21/kE3guVLIbt6yarUVuRkw7DfQBzvS6kMcWF8+HHF5c+MAfcxLH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(6496006)(4326008)(86362001)(52116002)(83380400001)(6666004)(478600001)(8936002)(7416002)(36756003)(8676002)(2906002)(16526019)(316002)(186003)(26005)(6916009)(5660300002)(956004)(2616005)(54906003)(66476007)(6486002)(66946007)(66556008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lMynMUTijd3InrzGkij+bT8xtGypfGA35DjRXfSnTBI2akGcD2EjXCPImpJb01qU3ZXv/I9rVtkgeb59lPnIaVpYvRRXF33e1ZvdX4jSN35ovbgmyRG7kUb7DSC6lrUUGO72iP1d69hD1+MEHm25tRalkrZbLPUPQKkwww3ENMk0NIS60vw8MkpB64/DSH2+pfABdTcBEoQhrxhE5ui/g7Nv5bPv/0wt/X3EPnOmj2CNJJkU5uEqXxeg4jGtzg5grgNrpJSTXlUdGmMSnUtLHgleH9TexcIge4IYZMpzHsKXwPbf1/eTQ1TdVUBwf69grURcHgJdzemmjBpSGSZOz6ZfbxE9hOCD4ulUyRSCqCk8ecYURtRi8BejOSW9f6D53OjH/AdXQsn7C1wToWR5Qo4zMJ6aPNwqRNXmp4A/XZmdKFtsEpQLrhOEp3fZbW4YckUY/xKOVa5hutCFL5P7YkL8t4d/VrcIfuwZia3nVxCRapcch6QMsRFsCfUTffxo
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3feed553-df35-41fc-ca3f-08d833c8b46b
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 14:07:18.7683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lcqTb2xemAT3dxGec7FKdA0U0vDiftMc/xgQrzqPJ19vaabAIGZ5VYIrEUdlQX8zDEk8sEJ9LPSq1Ub5tAuzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3116
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kurt Kanzenbach <kurt@linutronix.de> writes:

> On Wed Jul 29 2020, Russell King - ARM Linux admin wrote:
>> Would it make more sense to do:
>>
>> 	u8 *data = skb_mac_header(skb);
>> 	u8 *ptr = data;
>>
>> 	if (type & PTP_CLASS_VLAN)
>> 		ptr += VLAN_HLEN;
>>
>> 	switch (type & PTP_CLASS_PMASK) {
>> 	case PTP_CLASS_IPV4:
>> 		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
>> 		break;
>>
>> 	case PTP_CLASS_IPV6:
>> 		ptr += IP6_HLEN + UDP_HLEN;
>> 		break;
>>
>> 	case PTP_CLASS_L2:
>> 		break;
>>
>> 	default:
>> 		return NULL;
>> 	}
>>
>> 	ptr += ETH_HLEN;
>>
>> 	if (ptr + 34 > skb->data + skb->len)
>> 		return NULL;
>>
>> 	return ptr;
>>
>> in other words, compare pointers, so that whether skb_push() etc has
>> been used on the skb is irrelevant?

I like this!

> The ptp v1 code always does locate the message type at
>
>  msgtype = data + offset + OFF_PTP_CONTROL
>
> OFF_PTP_CONTROL is 32. However, looking at the ptp v1 header, the
> message type is located at offset 20. What am I missing here?

0x20 == 32? I see it at offset 32 in IEEE 1588.
