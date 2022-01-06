Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30694485FE4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiAFEbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:31:14 -0500
Received: from mail-vi1eur05on2111.outbound.protection.outlook.com ([40.107.21.111]:7265
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233646AbiAFEbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 23:31:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9drK2DWgfq78oanhmNGVcEus/yQyLf6FsbrmRDElb3GUhu+DW9fLT1xHyuLExatwuLH2mXkpA6mUet26pCbDJ1LG7VJWBWIykUTBV1veQ2kysVINMyeN1TxwpjibpsMV8tPI1ncXgk9wCiF8KfzhlwJB4h0w4KWLFkFfDG4u1kEjFFgTG90GCbhP02ciOleAwWQqpvjadL1+U2iROWsFRRe0b/0U1BZIHpYOW979g5Yu1v0y1ZA7n9wAxp7Wg+MYrYa5CD0RJUYJVoDXOL07+r8f2KBDnY/5bD++ht7KAssCTNKrmfhZiOd9kAncyMEg/aJP3W2IeR4tZqLF9gJUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12moviHpRjQ2gOwKBi7htYWB0wkPVigWKR7ql/y5UaQ=;
 b=BagHAws2XWUo85RSfahdhHNWh7vYCWGR6kYw1se31eLMg2zqgP1lHennap2YjayYa/Y7wz+vJNEFONdrQXuuKdmKN61ggGaYj9+YQRm1TdLzJg9Z2QdrZXGYcFNuHSfNat8V2UA60wv/fn7XeEUrmdUXK6k19M6U68lDbEo7QIA0C6C0Ks8QURzMpWHCcbFOBf4AnhY+uF4IXXKCNUeWd4aVgdKca9I4LeTVbzS40IOSLGYeVInk1azu4XfA8GlE0VTfSdVLFLhzIJX42Z2JYPlAHK/jBZwJK39PZJA1A6k4sZEmo4KjocF1whas67ex2PTYMDTIoAe0ZjiibGp/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12moviHpRjQ2gOwKBi7htYWB0wkPVigWKR7ql/y5UaQ=;
 b=XfDIt6R/Bjr1Mc1CE6f1jfx/2Z3kbw7VYEaI2pECLS8t5ckha+FNlhDt8caLZ5xThE/dzcL5nx4nGpgfX28NaGFhOH29leRm//46rPQsmk6BqNMnuSLhCZh7Ni96P1wbknrdNrhpw9n1Tq5GrXno2AJhbhegLTZu4lEmXCsXcIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 04:31:09 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 04:31:09 +0000
Date:   Thu, 6 Jan 2022 06:31:06 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/6] net: marvell: prestera: Implement
 initial inetaddr notifiers
Message-ID: <YdZwigIn6IG3a4h4@yorlov.ow.s>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-7-yevhen.orlov@plvision.eu>
 <Yc3EmyltW1BVQv2n@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc3EmyltW1BVQv2n@shredder>
X-ClientProxiedBy: FR0P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::18) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4463bc7e-df11-4e92-46ed-08d9d0cd5cbb
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB142797B2EB4AC7C6495CC26D934C9@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BUITdJN8fq+v2NKL0pj1DS/xoNOScwocpgqbZsRynW5kM9eyLK3qp2WGMsMCZDcwhGogizEu7a26T28MpI1sIQg5+WsYPAUDannR2Dm6tqpPPeZtWXAvCM8LWdJC0fTLhCzZ1hGJmss+G0+Mj7XCZY//BdErdS5Bz/hJSNYbJp1oAvZw3WsTh2QEzn3BPTjnC3eZrn5EMBdlhbTW2FJPhknHr3hbbjvcTk6K5yOgCl7yb/yIzJcDCIG52ltaW0G8x8cMfp024unsxTjKPL3whqhtz8YFK6hMmWNe5m2aKD0MPwhKGnGLz23P1FhSrftNyhOz9sxuYN0wI+sal+EbRj/v/2eh2TCqlDTxiZa2pPs8CL71bV3f+rHSJVNqkUFZdmDGPcZSTW4B/z6FwAIHF4kjT0IwYbYoAMqqs5saYOhNq+M4Bd6cLnrU9WBpv8gzuYsps94kPsZ9leiGiohi07M+hdRW65lFsWqRx6eyEITVulNtTQUGdRDpMPZtrZFTpIxYgiebOkcvm/7Uzv3fW1KQxzxO0HCH3GcRI3BJRzx3nm7YPYiHk8dQkQzQ+UB0d8MlJJbPIkeeVumBgxEHWYdkBimKhzJCfC4jgITDJ5fQ+fwTZhZa414f1VQCECLpxTJ4dTcQYFU/Ku3QeNkeOO1LWJDwMMr+u80aiLqW5hkhwbBoEGmrvbZ2NjHc0jGaZEXkpPQ0q0e4iDZLK+TYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(346002)(366004)(396003)(376002)(8676002)(4326008)(9686003)(54906003)(5660300002)(52116002)(8936002)(2906002)(6512007)(6486002)(26005)(4744005)(6506007)(38100700002)(6916009)(316002)(38350700002)(508600001)(186003)(86362001)(6666004)(66556008)(66946007)(66476007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i9UB3VsewQDgltzDRwOIG+FYUZ5KSFfWor3gmPrk+HnAe9iQt1Bc+VKiKFaG?=
 =?us-ascii?Q?eutzQt2jKYbnyTNHj39GrpeSo55f21rv0hgA/s0MAX/TKI/eNv0lXqls8kMC?=
 =?us-ascii?Q?bTN1Ym9/IlMYlF+lAeK0LYCJ+hh1SBNuiNXme6ODzpYNjYPLkA9owv8DffRF?=
 =?us-ascii?Q?HL0xTdS+9EZpbv9OJjf4WFHo5+9ydAnxDI810xPX8OroOuWnKs9lhrnIxdJU?=
 =?us-ascii?Q?fNee9lh1Cmg4XE3cwyR+mJqIudMpwZYrtG8Tgpa01yQ9J0Ro2acu/kRdEl5y?=
 =?us-ascii?Q?fx5HlR+C3KP/XZIe31HAc6wD5svbIIVSMwr2NCWw2y4G6RoSzu3VlKkb6yGm?=
 =?us-ascii?Q?AzdF5hAbdqsRT4ABx1DATnJn0CDLLTTXa7kHSj2qI0u/5W9fbkxazbHBhG++?=
 =?us-ascii?Q?xEybx4kcMIN5ghMLhHzEKMye+DbcRFt4E7gka7XeaHBM+wY/cxEK9R+8Qpk5?=
 =?us-ascii?Q?ZpIkU8kZ7j/pbH2QiRfMqXZE6wreUW/Dqpn0vJ6vh9MzuLdb9PyiITsHQ+If?=
 =?us-ascii?Q?1tdGCHdSl2k2l9Kgf2gcilyKNPPUWhkhBgtt6/rHQQhOT44CtXJ1yILY+xJK?=
 =?us-ascii?Q?NRM6ewR4EP3M2kcNwK3cM4WqqOQ64hV1umXZunjRRFImZ7jUHdT5BKFAM8DE?=
 =?us-ascii?Q?jUHA+1gOdmc+SkWgpvaYpdae7FWOYcjir8d4yqXLxziSBTiReAxZEtkKWhI0?=
 =?us-ascii?Q?gH0QWARC7Pje+G68xG3/cOrGm3I6nQLzgK6zSLTKE+JyQgED9+Wz5lOzj4QY?=
 =?us-ascii?Q?az7u8yF0Kis3jD//CSGO/EhlaBdL8sF2LCWNh5Z6AjeflPzWyiIPJO8+9H9+?=
 =?us-ascii?Q?eqaKdto10uVHPml42FHVo180Izf2JsuvUT4LGh9PP2u6PQmTFbM4Bu7tC+0O?=
 =?us-ascii?Q?ZCK5zbzeC/sneHjdoGwml0hC91goyXSg61ePzkhoVwu83Z/4454V4/amlAat?=
 =?us-ascii?Q?GFhy4J2hbVW3SmXGvT+/EB3SD/u+Lqk7MfwoqL+JtyQaXzLqm0OCD+Ho0LJB?=
 =?us-ascii?Q?XflwBjrZqHOCIw9bECu1vqRs/Xn6TgXwFd/nUvKmaonWh/ORs1C2csoRkUhR?=
 =?us-ascii?Q?ZQcQirne9kuGOAYUaXV5eqymNlAiCXOwLozx0IwqLzUSsDVKlCeqazq+mf2K?=
 =?us-ascii?Q?AVs99sUacE4CIfKaILvCOY9MqIWTj3upoFQbwQaWz77zjbQdGEdfQQ5vBvXH?=
 =?us-ascii?Q?NflOZjVegGeexsF4ItDzr8nMZ53Gl8iRgNnmCdoX+VgTk73RweuRohtnxag+?=
 =?us-ascii?Q?H8gmunrFv/H+NGTYu8AaflkAwTTAbUtuAzCkDp5/bNMHaqCpGpzsOKMFJz6S?=
 =?us-ascii?Q?kdQnM9iOqdftr4Ayw+XLr2DqWEUupFeN+a0sOrGGnCBp8Q32DIZitL/JGaBn?=
 =?us-ascii?Q?3yuTM/dpNlMxh4bunHUzWwNho2YYQVvQy7mhg/wj3O+iBE1u9uY2wHWrNFKv?=
 =?us-ascii?Q?0iD/bPcp853UQiDtlvkULcgwfew5JRo6aMSJsJsRxCeTC0Hj7ZT06DKg9DqQ?=
 =?us-ascii?Q?2yEa1VwtK59yvncuzU/GPtRUwSr8lSY4lwHN7Ifw+QHi0Tg8REn2lEnn0Frf?=
 =?us-ascii?Q?Jg8QJRcc0LKpusaOWNiCfzpudiLNROimDwOiAYdPRzGIN6Z0l5wsq9Q3vlF/?=
 =?us-ascii?Q?FI0Gy6y05Elan0Si8lgIFyMnZrdtUtuPBuBoHpOZrxEFMnUzkIq1qOU0c6A4?=
 =?us-ascii?Q?l34VoZ6KjvMSTfvs0n5r5iTWGOc=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4463bc7e-df11-4e92-46ed-08d9d0cd5cbb
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 04:31:09.3535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vWdiK+tgz1Nh+V6iZtgPukH28mxvsVp5RsbYIOZlypJQZJsBF8patsqm8pV965kaa7TzB8YzbPqYZ0Z68BhefJ9a6DBMefniL8Ij7EjguoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 04:39:23PM +0200, Ido Schimmel wrote:
> > +			return -EEXIST;
> > +		}
> > +		re = prestera_rif_entry_create(port->sw, &re_key,
> > +					       prestera_fix_tb_id(kern_tb_id),
> > +					       port_dev->dev_addr);
> > +		if (!re) {
> > +			NL_SET_ERR_MSG_MOD(extack, "Can't create rif_entry");
> > +			return -EINVAL;
> > +		}
> > +		dev_hold(port_dev);
>
> What is the purpose of this dev_hold()?
>

To make sure the port_dev is not freed before rif destroyed.
