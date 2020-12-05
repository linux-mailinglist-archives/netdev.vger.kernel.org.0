Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4542CFAEE
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 11:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgLEKBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 05:01:24 -0500
Received: from mail-am6eur05on2106.outbound.protection.outlook.com ([40.107.22.106]:11616
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726069AbgLEKAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 05:00:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xn7LqLvH2tGO4RAC1Mbg2oQXnybR5jCIjZaYuNoO5qSgxY1ebbn88bEhpjb6hEbw/y3KCqLotiB6N5BbpF3btlfRaZJedt5Mb7HYmmYV3SpS+G6vqpBkvTPV6qHEBrQbRaDpDQ65DKJHBvPVCT8lHqW5hVkjfsgHUKeW8gvgyGcttTkKJmlSDERLj0wVH63MbWWuEkBTlgnfgY66vHc98uOTGISwrWM4jSdwhjhigZKeKbkWoWI9liTbW+sFwswGofN+D+t4MrBQ5C9SD93Q9gYtD/KQenVUwrcE+EWUQs33KVfUm2VqJ4eKfx0+UUeNg0fTH+m1xoWd2JL5d3L+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9rmSgPTVPRaqz7EnjrL/TCvfEbaR64lr27WqaNOGN4=;
 b=JZy3KQnFK0y1fsawx6Vp+Ijkhdi7JLl1y3sKEeHbwj1U6hDp95HJXZkIBEDR+a3wKdszltXN2ID4JzkkpB7f0GJz/97AUetB8xQAuS+vvf34TJfkMI5/QJgANicBQINl4tD0KoAWQ5XsFH08qNuOQBFBOLIKZ8ScbkJgDQXKG9cdTn6j7HW+zUU6aDzOJWlvVimtLbSSIN4sjjQYG3jigqDfp3L7xG1CTEmw09ncPmbNGjgjypOFLZnVeCf0PCWmG+1uN7HeYWT+548udHgyj4Oe9//0vOCbG8a9H1+sj0ToRCQpPp4I/ABkktSrRqblecxSaEQt79XzH2Urt0oFAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9rmSgPTVPRaqz7EnjrL/TCvfEbaR64lr27WqaNOGN4=;
 b=Q4Q4e8uns3JMuJwiYhksptnEDbmmnmGZNuMV25BAzwQ4iGcmknZUr+YFQXyVMUuwu0d6smQzCFMeLwie7NAQG9IXQeUuF4KJL2PzGn+nRxtjXyrAnsfh+dOWbnKaXL8cYU9XaO7L3Q4wHeVDeub155/MXMt5GcdY/kjxiu3W2xE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB3634.eurprd05.prod.outlook.com (2603:10a6:208:18::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Sat, 5 Dec
 2020 09:42:15 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%5]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 09:42:15 +0000
Date:   Sat, 5 Dec 2020 10:42:13 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH v4 2/6] igb: take vlan double header into account
Message-ID: <20201205094213.p64bkcmd3lr4iejl@SvensMacBookAir-2.local>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
 <20201111170453.32693-3-sven.auhagen@voleatech.de>
 <DM6PR11MB454615FDFC4E7B71D9B82FA29CF40@DM6PR11MB4546.namprd11.prod.outlook.com>
 <20201201095852.2dc1e8f8@carbon>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201095852.2dc1e8f8@carbon>
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: AM9P191CA0027.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::32) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir-2.local (37.209.79.82) by AM9P191CA0027.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 09:42:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20bff97-58ad-4157-5bf0-08d899020c75
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3634:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3634181A6DC0D018BC82AF06EFF00@AM0PR0502MB3634.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uwd8pnNVC42eZEmxV6/T8meI65MP36C6EgzPo4xoE33tpBPd+/daCp+6TXkrW/OOMznXSSeBtbIsHuN41kE16lcmlj96aNiuMKPOMpqc2nc9SnhLNX+WLlLKO9GBRVKHmjniy6WrXmsrNw+dRHyAx2IYxgaaLwVp1i1pDvggkubUYguN8mXOIdnteqEpVMWdG4DAPKBJTpxtjI5va9I9ql0/bYrafTNxNPPGRxTKC5SXxEgVoGYwRGiaZyiw+7Lql9zui9g/8ZKaLBqMlZa1bes3L10QsJjF+OTIOH+wdDRRdbpXuxJKpOwNrnWH6Gu+ONHaQHxUQWovD1kTEEQwXON5eIOhjofpRiXs+D9lpuQf3ciaeih6KZvj9yoAaxT2UqNNFdbcOd3JSytY97qLIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39830400003)(136003)(376002)(346002)(26005)(54906003)(2906002)(7416002)(8936002)(66946007)(66556008)(66476007)(8676002)(478600001)(52116002)(55016002)(966005)(16526019)(6916009)(4326008)(86362001)(9686003)(186003)(1076003)(7696005)(6506007)(44832011)(316002)(4744005)(956004)(45080400002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2m/bXkhmAfboHj7HfFQPnZKPPN/ArfJVzlrr3gduT1FzSxlF9KRK6wjrJ1hd?=
 =?us-ascii?Q?5JEkeTqDYX5Y2f6IrwUp/L030bmKaAFqHVVM5sESpfp7De8Q0RuLUBOpbdKq?=
 =?us-ascii?Q?3E7eLNSgDQoanRVZRoBb+ukNxE1F9qoGVkLKBfoKaarGNNXn+9RNPNl2nDe/?=
 =?us-ascii?Q?H11lNhyiOrmYpxMREVOzNQ/Y1ABHd6EuUB4RT30gr3ei/xhnYGz7hIy4Y2Xd?=
 =?us-ascii?Q?9R71VRQ+I92pJWsDg+n+3BL9TsufYKdsjFbR4BDGO/UNAjwkoGdHBubndFeG?=
 =?us-ascii?Q?+ZvMTDoM7oEGsuKlx3JL90DGi8kDUpSWxt89ZRYRXLe8fmstLhB/6hkhjYTH?=
 =?us-ascii?Q?TUNpPMFSCCzpTg9DpF8hvpi2hTZrRc9WGJnF9HwDsFRTGOvfYiq0YAaViMRL?=
 =?us-ascii?Q?JFWNNmx3ucWkk5g5HefaCGwAkfm1DKLwDYsKX0KWtXAvWOwcALlpWiuPU78c?=
 =?us-ascii?Q?XNd26eNitraFNkhqn1V/hIvV8InWIMb2YXexJ4nIRJSOsycV/Q1IbstLV8AH?=
 =?us-ascii?Q?JiHssI6JeEbvHfMpUQso6b+MmUcr4KnWf4zN71/yl6hkK5JuX6CMSMmJ4C6L?=
 =?us-ascii?Q?Y62VnvJKPy0SGq56Xok0D4JqbMo8uGkAlcplCsLi/c2f5SL3a/PF+a4sPELu?=
 =?us-ascii?Q?kYORNtmnZHkj1ZjwqQlPssd9/oLGhSY2QL8Fi8EnobLl4OX1zNQJL5EcjJCR?=
 =?us-ascii?Q?zxM6lkTJR1u8Hglf8XfsI3s4pAMp2XIvB58XaGV/Od14JdJxUyBRauhx/fJb?=
 =?us-ascii?Q?B3x79I8lIuNsq8vsTxgYPRDQyorfDhd5XAluMvfFl9huDU+xyqQXfV3nalZ0?=
 =?us-ascii?Q?jPvnrQHuDmJr1+WQESpz89/Tj7fNP4bsGL5c4CXZbfzJCfxfvas1R9sPnCy+?=
 =?us-ascii?Q?faGYJpt7mziGViJjoKmSn+voJlb3qg+IahcMC+8FRG1rCvnAzVa1DwwQNyt8?=
 =?us-ascii?Q?NeB8gmEtbWoNN0Yb2Ttc6WC2UNNbhCZroI8dNb47rSr6TayT2qtEhNWTaXZn?=
 =?us-ascii?Q?4Snp?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f20bff97-58ad-4157-5bf0-08d899020c75
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 09:42:15.4153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdhxMRcMl2FNXFgVEL9sTI55e/ejfcsAbsiQdzzmsYZaZJcapOW6+tgSrgYJjfEmlsnnUpxrkh4OhjkluNc2ZAM/bN4/3+DudcGA/DhBIm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3634
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 09:58:52AM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 1 Dec 2020 08:23:23 +0000
> "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com> wrote:
> 
> > Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
> 
> Very happy that you are testing this.
> 
> Have you also tested that samples/bpf/ xdp_redirect_cpu program works?

Hi Jesper,

I have tested the xdp routing example but it would be good if someone
can double check this.

Best
Sven

> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: https://eur03.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.linkedin.com%2Fin%2Fbrouer&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7C5a78333f75c945b9bcee08d895d75e5b%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637424099531073949%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=g80690tGbCHAi3lr412ZlKoxwIFSIzn5e8V8nO1aZcw%3D&amp;reserved=0
> 
