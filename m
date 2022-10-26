Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DB560E507
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiJZPze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 11:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiJZPzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 11:55:32 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DB745F65
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:55:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lymlpliheruo2I6N9DlAS9d7xbiQcQXAjDpuBfA7MjUE+/1Uw3X7PKSu5tlSBAzFhKBOu9qII3/4GbOzgFVKsn+htsFMZJ2EfvvsBYBWLl4Bgd+DVZRA1jbAXXXmWghuOXZDHTAQaIb68XhtBTkWo+Moe/7zayKoGHz0nu/P5VzvjT0Yf2I1E1JaZRBola1wdw/CF6f9PF4zg3TpMuD7C0tusTdiy0JpK1mgntOnyL3m5po6MekbUacdixolRKLoV4hzHK3igF2uVN7eHX/qngtdjRNstiLcv9vPtSzFdQWcTmIybwpkXl2qmrhfbc+hUZKNBSeBE14aPnk5SHqtcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrTXH+CQu6Ghhp4livzIjUlQ1jVDYO5VUrtyRREjuF0=;
 b=UhTTwfV//HP0kPsrbuF/N8llew9SD5++smoGmCnkR6uKmEmW6L4jEwqwjnlVdN/7M9OmO/nx9h7bp3Gps1Jr+deNk3pxVC8iWqNZ+KR5gDn5wrHu/KH9oTMVlj1YtjXE71Ppl/uad5mQjBtatHE44cA+G+mlSR7c5wjI+lfMxa/0ODzprxwpXa4MygdhAdMR096fhs1xQRY5t8HYPVcfnZ5mhoKTjv0rasMXEyNwsUBZvNTCitLNWxYL47ua7WojqG/nSixjFKXQjXIJl4BJtdRFb2iW85ZiDDNQ8HZd30hp6neyEfDseGY7YaTQaTwXwOE5IqpD7oNXwpz6CNYHBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrTXH+CQu6Ghhp4livzIjUlQ1jVDYO5VUrtyRREjuF0=;
 b=j6IHgAb9y/nA2J4epb/uyX+eianPMgDOlXJCnxNhGeOyKii45Zepby2+ZqHyvD34194v+MwpHhCqFW8aAWxcUf6D3XWr//X+Lk5cSwhd2NsiUixk9GrjHBpZ3Hnanc9rpX3EI42Jdnxzk2YfkRGu822mWz4EWFO4DZBJudO//BdIPg5H8OX1Bf7L8BOZeUjF+Y29ELuLN/kHbzORNqMarKsk36AFX6r9JKZYOxzXfbI9fTu+JRVbcXreU1h0qk289zEB8Ar2md+rUhND7GXJDvqfCiFINYAbpMzr0Ijf5op3BUw8rBsd+aTsNvW3lh1KTaVy4uQW3m1Zwf6opwUiSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB5904.namprd12.prod.outlook.com (2603:10b6:510:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Wed, 26 Oct
 2022 15:55:29 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 15:55:29 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, smalin@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: Re: [PATCH v7 03/23] net/tls: export get_netdev_for_sock
In-Reply-To: <20221025161258.GC26372@lst.de>
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <20221025135958.6242-4-aaptel@nvidia.com> <20221025161258.GC26372@lst.de>
Date:   Wed, 26 Oct 2022 18:55:24 +0300
Message-ID: <253fsfazij7.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0319.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: fa277a3d-64c8-4e86-28b2-08dab76a8183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52bP713dnsrXU/2mp7VUUprBnu1+GtTJOd4xIO2YpIUfEzjqL+p3wzRqJFrQut0j7gfzYtU8JDcEhEfrzjOxCyZE9QXM55zFUbgBiMCUWSLZld+pWBeIi5BXQ34tfjhTXj4HrOTEGsO/a2IshLdR3P1/utGXgSCJ76GmqR4EirfcupScFjToJUmLAvIJqlkXMzf6fuSyou6aeR/v7No8S/CYWADunH4Dk/l1ZIclFcnwL43beBNyf4bDAefYyGmP60+A1etH1Aze5/PsnSzHegmH9e5bywLWVuLptwlbhpBNFmF3pB3FxSKXxrV0rDPacxapXwii1zFbTJmAeHz2urLaOYKMdjV88qf8IZ6pegU/9xdohBWk+Mt/zYwEy3/f8ND/egVYtz+Hg1jbYR1tjdMBNWU/AOqGVOu7dm3VV6uBGcxbM8um6iqK5KHAZBk9VVvoEz1YyR3XGDZJfWjd2Hp6RK3L34E0NymHp/IR9w3dz2KwJP89yx2NKhngOAhnoVH375YwqWNO2DEREibe7QeIzBPRvuzcbXww35TIMyXLHhdcUBLVyJl86x7he6qkrG9+YXIc2yOMARAR8ASb64u7hdXVi18vBsjrIGfE8O5nmhsJmbrqpQr/v/QxsQp5jr+V9nE4WxA0UxIPmBCSSK9ITzJWBAkhq5uHQJDL2+6W3tEHF9SlSRqTk7n9BLRgxp+FQKBZcAjGyi85M4hy0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199015)(6486002)(478600001)(38100700002)(6666004)(316002)(9686003)(5660300002)(6506007)(8936002)(41300700001)(66946007)(6916009)(4326008)(186003)(2906002)(66476007)(8676002)(66556008)(86362001)(6512007)(7416002)(558084003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FZqT29ahDz8fTgR+lE3Nao12J+U+YvKbqO4p7BuwPE2r4TE3rg0aKyAgit90?=
 =?us-ascii?Q?Pb+Jk3Vy9iwKcduKEqGSD5r+T/1c7FcM9rVnUO1nVeBb0qDHz1aAJJShtbL3?=
 =?us-ascii?Q?b/0XwyCwECFb5AA5Wal9+/YCFykdfrHslrWJN+ibg/vKXvnIothzUavLgnPP?=
 =?us-ascii?Q?HSH09L6mcxPv4gafauYE0UrJ3KXjOFPOCGFARhlo/KZbURejiYHzJIhpeN3r?=
 =?us-ascii?Q?J2c+y/pfKcnPIUBj3l/EIaxeYA7MUKG0yiSXDZ3CDV6q3ZsjFDXxRfYX2in6?=
 =?us-ascii?Q?QQpX/lG5UBv17BjjBc10IOG7/x4ovuLl0NY7xrsyA5YbEY5ghgZlTJvzploQ?=
 =?us-ascii?Q?pKg4NnwskiMaTp5j5UJ3kFz7XCkuvTBevDbgVYXIH32ThSymNdy9y6Ik9KV2?=
 =?us-ascii?Q?b1EPT5F+15Q0R6hdjbulfg7o0vwDdp/J5WQE6jVGHvRdDvDplMqhY7HwkveA?=
 =?us-ascii?Q?al0h+IJswTtyfDGrneY36I4obnjvQUDIbVdHYovACxIn6q6j1A0raCz1JrDZ?=
 =?us-ascii?Q?omxoMqEmQVxLFjJWPS2lir55JKgyemJOeIijHMJQ2bLF1IqD5WO5lm6xSEUk?=
 =?us-ascii?Q?0KSMtVN1Fq+GHL+TPXx8hKeU2wkO71N8CbRFfbKFlrIBoUhsV4kFk/FyNg0j?=
 =?us-ascii?Q?N+2/4FlEwV5u6xA1Saj7fBTGj34d/Z0eJRcOHcuinXZXnaM9X3J8WxTti6qI?=
 =?us-ascii?Q?ns97wYnaFCJHk9QAN1Eizbp9MHSCXoyRj+EaQ9wXGpb30/X3Aa2+OWvSSIp5?=
 =?us-ascii?Q?j/T7qXvUB3JZJ02yeJqMODzfjPEFkxnLKvxo6cEAGPmPjdh5p6NaBcy5rnky?=
 =?us-ascii?Q?G77X7/TlbjbUnjjyaY3Z2iTldVcveFhH9a3o6yFYyftjznZSln5o+6dplwVm?=
 =?us-ascii?Q?8KNnmPwE1DIMV4+O1SmkjhTQ7tDU+xtgX22Iu7CqHxfaXxFBm93cbjsrCSRD?=
 =?us-ascii?Q?B9/+uFoPKQnBXyFoGNVeRGwk0EiJS3NX0fPsRGcJTuG4jLI0drph2n4mhqER?=
 =?us-ascii?Q?lllrcllu1T0joNfvNe0zy61yndCh5wJ7xAtrc4+S55opkJA87Iy5VmOu/oxG?=
 =?us-ascii?Q?QWODWx+OiTrU02+67ChJYNbVkimiSP2dBHpefoAut3EEpcWr4Nz9MStFAcv9?=
 =?us-ascii?Q?fo7djG7dxHvsWm/zUx6zbNECzuLLbVQpJZJKvl7266niLmXLHYerLndqjcBQ?=
 =?us-ascii?Q?2DgO3LJyIkbBipG642BZ/FGAm8YBSLCvDyW8fwCdk80JOav//vOcVqniU96r?=
 =?us-ascii?Q?MU0jqWTlZrKU5DuVE7GOdcjEi4d6TjJVjVcxr+9dS0DnFYFIuKRRqGC6h9Py?=
 =?us-ascii?Q?8tPDKipELgUhQjVhxNOAMIIGQH++xNyZRqmhHPKchy5kcZwLCA2qSTThRPrG?=
 =?us-ascii?Q?KFdrEoTnuGknZwbZHjr8uyl3hAj7SY60mzY5qT/8vSzai/B5/p0jvvaxyHVh?=
 =?us-ascii?Q?dKxl4wrQKRxsLtKUY9wl3KlZ8fiwSLStb0mdqpPCW20UU+olljdbnXSOzroI?=
 =?us-ascii?Q?w1YbgO7r9BTu/lsV4fnztO6U4Y7w5XBjv8HpOrYAJVsRkF06mJiLOwcRq+kP?=
 =?us-ascii?Q?Hlv3vESjto2VAl8bZAfok1Cgpkk7kVwtWWn2AGj1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa277a3d-64c8-4e86-28b2-08dab76a8183
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 15:55:29.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7q1jkOCLHivCtljM4LrBHvbBUqK5LyR09iSNqvsfqduZYo60h74TnkdofOXaPUpoQp1vjKhxHlFPZ18jjk8XbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5904
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

Christoph Hellwig <hch@lst.de> writes:
> Any reason to not just fold netdev_sk_get_lowest_dev into
> get_netdev_for_sock?

Thanks, we will use this.
Could I add you as Suggested-by?
