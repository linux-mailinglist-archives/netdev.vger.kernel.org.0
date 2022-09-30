Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4454E5F16B7
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 01:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiI3XhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 19:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiI3XhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 19:37:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FBA1A2A08;
        Fri, 30 Sep 2022 16:37:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbefAA8+q9IEw6wfjCFiazqC3tbuDYFDtq0ncyFc75KFY850QYb+Sln0U9OMCnpqI0NTaH6cJmd9lXMdOs1HPsWhPnD76b6JLzHih9sdBddh4Rj6OcTHsoNiQiVw3UQLNgWl89ewgwzCzvydJ/hqwu3YT2v/Cp5mHVSiajemdX3KLghqncjVksuzfffv6ZymM2hw3A21upXMWh+xAiiLFJW+y4J9h98VlUzdEzLzylPE5l2osU+oK/LRcqgeD0oHbuMcUDxSmKoAtgyTKH79zDpvAe1zntY6QnFt/JjXKpf0xCVTVmyHqe0PvNTCfMJBT0kSNbWKyfWTyZ21PTsKJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAbZI5+BloEGcvy4QqGRjewcg8Zrv4+Gx+BsDXa8oUQ=;
 b=aobLiPNNHlzJZkCh4WWsJ8xiEU5AgVli6GlRvB15qPjDINqJTc+3Z+NEAbEn4RJkVvbkXZjjHoWfRQgNZa92N5YSpHhwIbb1NgohBNgNFLGFXST4XzZg1SUbc4EzKp82PesQ4m6Sd4Or7cD5yHKNb4J7OyoUMqXuogg8Sk5WHL5NoIu6FQ4r4hFVmeWWvCAGQ/PK4moUd4e7cgkoH7j1fd3Mekci9esGXgprsPQGATBWLjALnFmikWpTp0DFwgUX4r+9Ye9lKwxFUIZlx8eTyINB5pGw5mLrI4ILSRFS//ylRtGRrReBrUMRNk2pE84gui7/HVVdk9ndng7X0FoJoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAbZI5+BloEGcvy4QqGRjewcg8Zrv4+Gx+BsDXa8oUQ=;
 b=AzYjlZF/ljQf0jSmgq8vBvF95+nfzX8Cw6ORHjHE+uirtdu2l8X8xD7BTHL0o1qwhzNrLYNwybUGUEg4XSziboJuZb+TF9dnEaxaS6h9Lp9wYWQX3IieSnFR4M8VNa3k2Pv/RRnrQrN3cyYd6/oBX2tpwCn+oxW5vFTKWm57fS47GddMmHUbJf4Cs/M0W6aJipi1SRnKeexYMBkMOkk++qWma1IY650zdE08YANBDrZobgjDTKQupePC+GEOKHEmuw0Y1AsP0AoeTFv4ZjAc22nKBn98yUHOBhtW5Uc8Y0OfkhkdClZx2Nc4kCrmI/NXJnRnW1+RVI6B7wMXO7ZSgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by SN7PR12MB7106.namprd12.prod.outlook.com (2603:10b6:806:2a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Fri, 30 Sep
 2022 23:37:10 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::70d0:8b83:7d82:b123]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::70d0:8b83:7d82:b123%3]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 23:37:10 +0000
Date:   Fri, 30 Sep 2022 16:37:08 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC net] net/mlx5: Fix performance regression for
 request-response workloads
Message-ID: <20220930233708.kfxhgn2ytmraqhg7@sfedora>
References: <20220907122505.26953-1-wintera@linux.ibm.com>
 <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
 <375efe42-910d-69ae-e48d-cff0298dd104@linux.ibm.com>
 <CANn89iKjxMMDEcOCKiqWiMybiYVd7ZqspnEkT0-puqxrknLtRA@mail.gmail.com>
 <886c690b-cc35-39a0-8397-834e70fb329b@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <886c690b-cc35-39a0-8397-834e70fb329b@linux.ibm.com>
X-ClientProxiedBy: BY5PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::17) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|SN7PR12MB7106:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f943ab7-054b-4a03-8feb-08daa33cb17d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFYxSg7iZcetTefwIMFAIRF6mSzknFaOibwjYl8dxkbaxQ0bvFh5OnNtoZ+LjFvi8MejNM1esxf+W5r9L/nlL7wec29IT0k8rUBVcdJzc1P0PAp7DYyEgq+kjgiNp7Qp6KaypNhee1F2VEt4FpNgDhm7BySPduq//ebi5OpNYvn7escjkM4ECJ+aF2r3uHcCjmRBeSQtF8LvIoxiGdzLSzkIwHI3riQeFL0q3sOV3lu2wF+EH4QWYFKHOTjofkqhGdUk12JUp+3Eceeafk17CClizulmSAa4Ed7nYYjnLWr4M3Yes54TVlB1dGLL55lzqEwVLkKK5wg7/0u22QsqZz2WTi8XeBZVwZEEB2NK0aGkPgdFBz3/A+JojG+pnD3+pttS4+dFjBvpQ805cQJQXq1IJJRyasqRhscibCR1NVf6p/frQV6c2qqXCWhVV/lGAyqE6MNfldLGZ25JTc+9Bem9ckr3dZDsSJVJkOCCqHY2vmr0AwJKKXJbc4QKT3vNQtukYSIM/GNkF/i67zm9zOQKE0Pq7JBjXlXvH1p9RdMGuAQbniDx4Zu19CERgQmtsIqrU7VbwTsdQ2bM5VpCaLpaR5LUP9x7DEBs+YzkUWEctr8sb6M5nuoVPYhCk6gnPBLf2lmx4FAPIJwLiPLEwP49dPGmqa8Ol4P6NV/nvHv2hgZcyQjUebp9RbYLBdSmAe4wdYa4tdJLZi5dVmoesg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(478600001)(38100700002)(33716001)(6486002)(6916009)(4326008)(8676002)(66946007)(9686003)(26005)(66556008)(66476007)(6512007)(186003)(83380400001)(6506007)(4744005)(2906002)(41300700001)(8936002)(54906003)(316002)(5660300002)(86362001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oZ5B1kpNw6rnkOp5EmM+tqZXJxK9ltIToPTMHo9oDVfkQF6mEy7r9igMLZuG?=
 =?us-ascii?Q?2Vft/3FtYilOFTzErEjN7OMNEsvigKq1/1pYzpbX25A6Nj9lmaURhycFR0kI?=
 =?us-ascii?Q?KeGOP0N5uK/YbnoobCRAKfHGL/4K1d5PPM5DsM0rySrqBPB1QHDdO3uT52RY?=
 =?us-ascii?Q?M/TdRLPf5QzMo4PHNONgv5r0vuJFcDCrCzpYyYb/LVUm+aRK1HEc9QxKBaM/?=
 =?us-ascii?Q?Qa1cod5S5rADZ15+wXb5r44x6uMKBa5+vEwKY4xNhkTsU/OhB7WDcPCyz8Td?=
 =?us-ascii?Q?dMNfzcW2/2XKIcx1n8g/XDd/PsmCxyVXYxuo/8cbyAGHwowwQU+3yip36vox?=
 =?us-ascii?Q?aDdKEigGjjmfwe6WqfLw7Txx3Rz9kzVY9iCfovhMDDjZK5KoUYuwvs5FOWNF?=
 =?us-ascii?Q?yRRLwLUZXs+x29s+wR0H4lwqSmcCEjUVdJxzd7OJqvnycgyJvLbMqhPHxFAU?=
 =?us-ascii?Q?FEf4cy6nN+X5Fj9Eyr6pddH9Hd+NfEeXHJdROr6lGbjpW3en3aJA2LwD3jq4?=
 =?us-ascii?Q?YHwiUEteAIAnHlCz0D58ZRyrYga2Yw/dIl8cc+4Cz9+1NId+XYwkvsWgpZp1?=
 =?us-ascii?Q?R6eeswA73alySZ0kA1lfTCOlvbSqUgfmaDSFbwyyOyzpjArKW8S9FdUOGGKW?=
 =?us-ascii?Q?M2XiAbixcO51g1l2B7rH3f3Vt9Yp1Ueedd6cXWaBAfIUT+Mi4uVdWg8zqllK?=
 =?us-ascii?Q?08/eUytBnJDy9CwRI9GP68FaqVAEdo2ZcOjXmOsoNKkZNqb6DsDr2Mdk9gTB?=
 =?us-ascii?Q?AKHLHl4biJInZaj53WFCJDRBC56i8LneI94K4Z7ir28x23U02O9aVnCpsTf0?=
 =?us-ascii?Q?wy0fyrrPvREa8NzJGZ1fFylxPGsbkruGC/JfoJ2idVNlgu4FXSv5ZY036pdX?=
 =?us-ascii?Q?iptVbZpTsSg2DdF8/8kZe+JdWieJsVZQGCciZXbID81Zd56GjDoB6ykezNqG?=
 =?us-ascii?Q?RxUxVeTsV9wWSlc+zRHXAS6Gep4aB9VJhr+zW4vSiXnBCufAH3T1pOb6Y7A3?=
 =?us-ascii?Q?B39wU2AMyfDzzvUDRw7KBM0BxxPGg/KteNE2XSjI6kF1kx471XNQG1WmYQvf?=
 =?us-ascii?Q?xZID7OaG4VbyBaQ7hp0SckFllDLImgqeHoQzfpGl2F00bV13Jx3wnAAhoBay?=
 =?us-ascii?Q?ZCIhJchVVAD8Z8kyCCv5OKzRvc5zIBALDj85A/jLlS2p5obl/aPFSKXaRPcb?=
 =?us-ascii?Q?9zeSzZtvGJlMCAa6e5ZoCBhM0lORlIljyNLUyN6/AZzJvJaDyxAZk8L7d47w?=
 =?us-ascii?Q?vwSdVkoiiMndphsLgyTOpL7BrcPryBwx4O+EVD322GsGGy/72qcq3ASQjxNx?=
 =?us-ascii?Q?OxqCtb9trAzLL9vtn4nf980VHG8qUot5IVPKbVb2Bvl3JFhCRcM1TnOYD37I?=
 =?us-ascii?Q?XK/YijpNkGkzIEJM6md7EsNhf+S/dDuGQg0pEc9xqaR1BmadgKWvdG8Sl8xN?=
 =?us-ascii?Q?/qXxfgEK9YaGp0rPAtn9KuxXVCMR9yOKAyIyX3wPSXQV/b86K80zwsH2o1G+?=
 =?us-ascii?Q?s06JBwUt3qpjPw/p0E0SPoc3vDqmAIMqCCGGCLHiq8odweuhF6KbAHTBnMkJ?=
 =?us-ascii?Q?bzNVMfi4OCBJlaw5zwsu6tQuw3pJL9DYqgyYw/bG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f943ab7-054b-4a03-8feb-08daa33cb17d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 23:37:10.2506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ygtc2YEQ8WkjFQsjnen9KCg68cesOZ36kipIMEGcyG4vE+jWzsZuGOOEbj2DSHx2gwkxk6sSSPx6N8O8xyPpmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7106
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Sep 12:06, Alexandra Winter wrote:
>

[ ... ]

>[...]
>
>Saeed,
>As discussed at LPC, could you please consider adding a workaround to the
>Mellanox driver, to use non-SG SKBs for small messages? As mentioned above
>we are seeing 13% throughput degradation, if 2 pages need to be mapped
>instead of 1.
>
>While Eric's ideas sound very promising, just using non-SG in these cases
>should be enough to mitigate the performance regression we see.

Hi Alexandra, sorry for the late response.

Yeas linearizing small messages makes sense, but will require some careful
perf testing.

We will do our best to include this in the next kernel release cycle.
I will take it with the mlx5e team next week, everybody is on vacation this
time of year :).

Thanks,
Saeed.
