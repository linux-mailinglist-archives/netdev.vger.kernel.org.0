Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6673A4B1FEC
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbiBKIMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:12:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiBKIMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:12:41 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2117.outbound.protection.outlook.com [40.107.236.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408D63B5;
        Fri, 11 Feb 2022 00:12:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3aDd4sLBhY8lX5+8rKV+aUyj4r49gOnzb8eoqHivxyyAJmFDgfbdk6gLfByG1UDlnZ6pvc7XKOVegFnb2f8PtJ1WCoT9r+3Et8CwmPUARWO7BcG/H9ZMZsldw0jYWJSBrEEdwYOEHmZoL5TLXHu2vvfmfERKunYQu2+/0sBczXNqIGCmteT7im2WJXopOpwHiM3KrzU6q2njuPh6y1k4R5/Ci2hN6jg7U35wO+Fgqh/sLI9iuivNmAvBCyILol1nwowzM2nEsoZAi0evKxhPmlU7VaKlw7C9nXuaNqZThNS8WYJHrzIJuppeMzAQjmNyPaQQ7XQw8DNlZAkO3kY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJjx1s5b0NAvQRvPeN6m7aADwjWtph47MCfAEmUNEsI=;
 b=bzHgRaB8uKZLK7u9oWhxpCPRuou/7UV1kIBOR1zKPee7n5zndNg4NjKd7r0iyHT997Be8AUi5m2zUqO1cOTAyV57a/1VMLbR9o3eZxlhHf9BMr1IQvU3E0jU59yIq+AiQW3P6UNMKj/ALtmlhnCMfLqZk9QpUFoGx6jK84+rixGtnY9kyCdTvWMzFWAyEdnuzlrGgnEgq6VNzsDXxVNehjJVzCB6gFTQ0o0d9zA7RW5yyKmtM0VR6OVWDLRRuyLMQBU3nlcG8TanDc2PuMZyZyRl4mlmkCv2NY47d/WOHwjZ+ZB+BnO5+JgbAJZb98pQOWPlyeSIObP1U+Fn6JMdqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJjx1s5b0NAvQRvPeN6m7aADwjWtph47MCfAEmUNEsI=;
 b=EGiVLOKSqW4ncMns81l6/Mwdx/MvZca8qPFz/p+q9uRcc5BUxm7splB/0HSlMcQicwNgOQcR1DgHBXr3/rr0rnrK4IoqOowBUvUaof13nTnPH0O5DVV3Gef85Gq6Zkd8PZrFZayv5VCov3GBs7ru5D9pSnDy+TDlGnfD10sV7/E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3668.namprd13.prod.outlook.com (2603:10b6:a03:219::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 11 Feb
 2022 08:12:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.008; Fri, 11 Feb 2022
 08:12:36 +0000
Date:   Fri, 11 Feb 2022 09:12:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] nfp: flower: Fix a potential leak in
 nfp_tunnel_add_shared_mac()
Message-ID: <YgYabjkREkxw1/Uf@corigine.com>
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM9P195CA0015.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14717b6b-a4f2-47eb-7c59-08d9ed364307
X-MS-TrafficTypeDiagnostic: BY5PR13MB3668:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB366898C38E39E3028FABEEC1E8309@BY5PR13MB3668.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhmaF21jqdRE34W/4Bs0SyR9Cj3XgQsFkpYJn9eS07tMwvxZqIWGROGAXXRqfYmSNCWtWqmGlkHxLDYgiaggH9M8QqtPvIQ16wVXfyGyDDMcBZM/kZ+g9BKuSm5X3SlFvTLzZJ2wfX9xZrQL4cxPfSLodlD6eI4zgnOW6hyvMAHJYM+qK+IY8lS7C5QZ3xgeHspD9OSFsLw2MdXJ7JRlkGEvaLclX08U8B/uT4POgqEM+S5pGHD/CLgx4XW2dWUSV9jx1SXxilZie7Pios0LaIqmCQAFJDquwQgmbtHeXmEkTv5vt2uYoC+Qih7B2jeOI/+/Wu7nnkv+ZI3q0VE1nqqee6IrlM1G4eVRjyiodorJMdkVmt0MIBTJ4aRjL5UIFxDkpBv03QGdWpON7nRVJoD5VrtytOsCM0T4juvxOHWdnM9HX+L0DYSn3bTjwCNKviNblv2KR8hTOoo/2alP+Qp/i+BJd54XtMiSkUso5BoCa18UqpbD3C1wv0PqqzHg+UBlsHrSY/UK8JhIi7t0VTsL1tGe6f5pfrnedxamgWnHWlYwhjETucfFB9V3ZiWDsauRNOp/MyHlkvuzoaNPiKg7K0dlP1n3yh0RVTd1O3lqZt5G5tfd8C2x83HBB4DqijmQo/xIBffwQwW3jtLoLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(366004)(376002)(39840400004)(396003)(6666004)(54906003)(44832011)(38100700002)(6916009)(316002)(83380400001)(86362001)(6506007)(2616005)(52116002)(6512007)(8676002)(508600001)(66946007)(66556008)(186003)(5660300002)(36756003)(66476007)(4326008)(4744005)(2906002)(6486002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0jZjx+PmOj9A9aFj0aXoT+As8KAxE51Mgl/irT3E5Fwu5nNSXQxT8qBnUZFk?=
 =?us-ascii?Q?S91CzDhyJktrAE/2A1K1Wy9JOAWndqTXQg9qsfkw+TGFO9co4KG6awbX0xPQ?=
 =?us-ascii?Q?O9ZdWMSWRYi1d49C9T5ZmfRremntCi/qXi4Qaos17FREfoA8Ju2v1bzEphGI?=
 =?us-ascii?Q?i+zzZrsttD7BBLBu0DU5jm8o0IZB5d5kpHj+HMgq6ZVM2MwWrKxBmoQPrHDZ?=
 =?us-ascii?Q?t/uJqxWqlmqhS5uC7/4YEUPVyjlNpj/79yuyLrqP0MR2xOiy9d+1ElJbXvK9?=
 =?us-ascii?Q?YvOkriltpXBn1qlPQkx0y2OEHdiPGiw6mVr0LSN4HmvEB8+v7555I57cQkcG?=
 =?us-ascii?Q?7HmP62h4xtU8iDNGh3u1UYade1irWlNo16D4WG6OvnoqtwL3+DizTnYEDh3b?=
 =?us-ascii?Q?EC7Oi6e6XKkO9m+gtzFks4hEYqEek+r27/DOjHpbEOvCDehCu6gdzcc3UKqn?=
 =?us-ascii?Q?ShBZnZRvzOFSLxnNj0uLO63ib/fVBJqU7ZBw5tLh3ZyPvZREtfWwyyXm7sz7?=
 =?us-ascii?Q?f//w73TvTXBASI9samfacujVLe11ZGOtQOJCP6FtX9Kjz2XXi9rDoDDeQ0hh?=
 =?us-ascii?Q?OuezDoz12OhRfaYv7KMVaHDiPFBDPmqFu2CgfO7ScenFDAQ2lqWe4vIVjI+f?=
 =?us-ascii?Q?gXs2fLt6HBHZr3+XJ1cPJimyOfRlFn1EJ0GF+TWy+Qgs+eCHDVYeRi4vfJjN?=
 =?us-ascii?Q?7uN0b7KjRFyz/iw6EjxqBGSb6pH4DLI4krOiGjAFyAAzWidln6SUSojP9+Tn?=
 =?us-ascii?Q?AYztLEG1oDei6Z654QD5y2B7VDFcVbbOp1AomlQKa0Hes5qsYsvuH2GuPTh9?=
 =?us-ascii?Q?4Gvb798lJr1roMwJA3VZPdgcsRNwoJUKV8g2shIXCQqkphkQl00Drs59EqOZ?=
 =?us-ascii?Q?Ctb6LGGlsiht+UNqxOH5hwOzxOszFiBI0behcyrAEu6v5qOpx5Elaep4EICu?=
 =?us-ascii?Q?cwOvLZ945cGYXvaU+VJ+wQS1QN3iuoItueyutLxl6w12Lw8qXk/lTCDsvRmF?=
 =?us-ascii?Q?KMFgg+moS1q+ccJZVo7R7+1glffbQGMCqN+vz+JtfKJ++0/yI3jrre8fALbg?=
 =?us-ascii?Q?ndF7liDS1v5cOdlZUJIk7qo4w/uPRo7yhQDi4YACVxJWR+FzHTl/N6gdZMsp?=
 =?us-ascii?Q?7qwSw3Am1QDcdmcURWuusUJnisbNWsweSHEG0bH4jJyxdQnVnWUOMeSqcQ4j?=
 =?us-ascii?Q?+/luY7rzwLLkmYfR9DtWSzfpeDz3GVtypsJr0kJpDjAC4keQl2XBlMR+1mjM?=
 =?us-ascii?Q?hNv2tmr5e7ApaIfWNIORM6MQUWlt/sSDhhpTlHVoNICXv7ytCoX4tRNaxkQd?=
 =?us-ascii?Q?ZVmeuPlP1c2QNM9ao7QYS5BkcePomvRXn9vBa6zdA3G59+kO7g+E4QaXDCxJ?=
 =?us-ascii?Q?2aOVvMpxdQI3YgTJCjfLJZ4WBZPtkQr9OEvFaLNEB3yLM9QrApNfk/yjCepv?=
 =?us-ascii?Q?dFA7ZdHCMp9pM471aIkyXYi26OPIkvmdgB8beekeLfy+D8a0EFGI3fGM9RxJ?=
 =?us-ascii?Q?x1+NQ0SRhkXPWwNXdlVDHL08n5MY0WWN8SP8UfuSuTXKwE/BZ/ZyxW6Pg8Ig?=
 =?us-ascii?Q?W9//Lxui6stCXiR4jYQp6BlE9syjt1DcaKz9r9SnoBzv3XG287Q9ljaH1wJx?=
 =?us-ascii?Q?F4/fE5OEvQLxASTcl68DE/NA4Xox3Ujie1gh/AbzNFj/Et5gdeLXS3TMips0?=
 =?us-ascii?Q?yOCef+iNvWdAnVdMLAN4ZniivVfC0Mr/huqdRVeAReRBn6uBKehttPtXbKgH?=
 =?us-ascii?Q?kPtsK/GXcA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14717b6b-a4f2-47eb-7c59-08d9ed364307
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 08:12:36.0560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTqQeRgBi/18zeaDLn4OOhPLE4wdoxLIyRIBruLCp6FeHbfr6tu1jKMzLIA33iMY0L/KNMEBacGICcKhFkHaPvrYMXUSViyh8skx9N4SWiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3668
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 11:34:52PM +0100, Christophe JAILLET wrote:
> ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
> inclusive.
> So NFP_MAX_MAC_INDEX (0xff) is a valid id.
> 
> In order for the error handling path to work correctly, the 'invalid'
> value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
> inclusive.
> 
> So set it to -1.
> 
> Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks again for finding and fixing this.

Acked-by: Simon Horman <simon.horman@corigine.com>
