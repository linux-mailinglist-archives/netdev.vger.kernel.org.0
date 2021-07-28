Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBC03D8D01
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhG1LtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:49:01 -0400
Received: from mail-dm6nam10on2091.outbound.protection.outlook.com ([40.107.93.91]:40288
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232530AbhG1Ls6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:48:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3zx/t0I+qYTEv4nnF5c+w5lksmVpyZ6we1o4jMiNTLWbThc9DLwbuzLQ7MIkEnfEdF+FeNQAD0c0/OQ4dxMyfVV4OcaGM8tOrXF2dcS4vO3rTTqizfGIx4+iqkbzv06hVK6FqJN6EIM7YpYmrZP5oPYDYc7TEVBervuZhtgvz03Hu6luuMyYaWUnG/Zkm6Y2azpfZVb71gWFsdahtIQ4uXJNK4w2t+8zepmc5IIHMAAlu8YeBN2KhtbiL3bnDvJZh6RW3RHKcjSLXJxHAx05ZeQT8onlhcU8D/qBIgnfSpxkNvasiy4IVbRL0MX7y9svtnhjf4PaH+esOepG4DYzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoXYGPc1Mes2/TDokIIZRwJ4YE7M9qMGmes25FFM60A=;
 b=MKlG9XeOLbNofBiNLyAMqZtcp6AkRj19Y6RNH8GO3MZ2RT/SDDCUDvzAWyPVamPMgOD9MWvF6SLIzjqov1LTI9BtgDzZDSvwI+LovTGPk8ewLtPIVTvLs5H02QIJrQWTdBDQjaoy0+yJx5RkUHi7retGKSoFA1DbUQhMfazJNAhhu5lqKuOZ9RdExFoy0WTz7KK3+4W0bD0/hC1rVqvZ/dBiwC8sS/Yfy9SfxLhbfkJ4xo+gBh5jKHWWVckgGFCGbaPOvmB4dmdQ0Oc3S3PWiuXCmSlFoT/w9J7W9DS2VNoMWFYL8UfQD7kXQKtRrUp+7jk6YMtBzvvEWVic7q0i0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoXYGPc1Mes2/TDokIIZRwJ4YE7M9qMGmes25FFM60A=;
 b=iL1moIlNsPaelo/tjhdhNGVnUBnlQA8Hb5eHcPOHVC8oAKP6rVVuwgYOMuUkUcTnlygUHlvDRnfY3TfeQ8RVYGgnr0Bqsomjv7UW2xwFs1ms7Y1qaNt+YwU2G9behvMroTeOJVr1a1yIs4FNipax7I9cwnCWPLkd7juiDM6S8Ic=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4970.namprd13.prod.outlook.com (2603:10b6:510:90::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9; Wed, 28 Jul
 2021 11:48:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 11:48:54 +0000
Date:   Wed, 28 Jul 2021 13:48:48 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, louis.peens@corigine.com,
        yinjun.zhang@corigine.com
Subject: Re: [PATCH net-next] nfp: flower-ct: fix error return code in
 nfp_fl_ct_add_offload()
Message-ID: <20210728114844.GA25291@corigine.com>
References: <20210728091631.2421865-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728091631.2421865-1-yangyingliang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM8P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM8P251CA0021.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:48:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87905f56-c44f-4f05-6c19-08d951bdad22
X-MS-TrafficTypeDiagnostic: PH0PR13MB4970:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4970D7EFDF43221DD689B83BE8EA9@PH0PR13MB4970.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsie8UMPd9qYA2uvtOlOad9J1bCY/DG3psJmrD+8X6yGVYiAeUTnyXkFZd9xJfj2d/hu9GAeHLHs0Nzj3hPtGFK3NVilkBPYLIqzvfhKcNNJBZduAk4VsFbscxoDaYSpU8T+n0HN2MFzOWI/q1Y7/CI9EsclSk9H9G1DxryL5Q3kMlwk3udWcFPfO5PNZIq0kskQHgGXZXzInu1io1+HOwm4XM4nOoG+z4l863iJ7MMsUJV1lMZkdLcf94PHGKGjQmxGkKK0/K2UgniX1RXR2eIeYeh0cLXz0w2g2HkQBRGSW/j4BJrN0gHdrowJxvQw4B3yzm8XVGhNNITUuDsZe1qDCfZEstdh/fUxTCqDt9F+by4s0ueFKmbq6AeVOgF1X6XlbYJfYhsLr7qPATLtm/3hrVEh6xV6Vgd9I0CODxKIHuLm2ijZrRZlS+/+MPW3l2TyCBxSKwEpHGgbXtkOLIL2rD55L5ed+/sOEY2HJ/cvTXg2PWlYsvXr+kLOH6+0QPSVvCiP5aUeOIAUcc0xAQtN/O93VFc7vcEIDKGNciPbKuIcLXZ1pFE/sqXlz6vxeVF5Z+p1T3gZpelnpbLyEhX/Xh5pWISo3jDO1WLfjzKjx7WP2ew6qeduxnRKDmMh1SggTBDoU1dA5l2QdHdzQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(39830400003)(136003)(346002)(33656002)(186003)(8886007)(86362001)(2906002)(38100700002)(6666004)(7696005)(5660300002)(52116002)(4744005)(316002)(8936002)(107886003)(8676002)(44832011)(2616005)(1076003)(66476007)(66556008)(66946007)(36756003)(55016002)(4326008)(6916009)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jEHOtLtnM6gYTzaUIR6TVHVVfKla52cKtsjaI+rKQh/rgJhTm4obYCAvrF+l?=
 =?us-ascii?Q?TOmSY95QmAiMuvLGAg83M42a68I3Z/uDQtMtvDYCY4SJeNR5dO76Se83nNWv?=
 =?us-ascii?Q?WLYtTBcj9sgiypnQKeD7378YOCcVHGuq+M1LfpNhun477Ft7K3fXpsNN4HrO?=
 =?us-ascii?Q?wpD8KgS2zY6CrrFFWelP9a1NtRxaAWfXUaT0P2LrqOJxL3Gu1Eq15Fn7g1uo?=
 =?us-ascii?Q?dIYBYwCsAnEGD0HBxVNJOKuWDr1xPvV7Nx1uV9scu1gd+88k3KfPT1UIWuTj?=
 =?us-ascii?Q?kpM9OXCprOaLX9l7jcNaxA/YlLDnV3RrCeocs10Lpvi+qaypugBPA5QxJosJ?=
 =?us-ascii?Q?CMBz8aWBAO/TtPI0Rky8bg9tDdkBM6EwY4biLbAHLdswINEAXux1E5QLfvFy?=
 =?us-ascii?Q?NTBbqhRoirDdGU674+4kzy/L4HAcPtI3m6hP7a8mQOCrZ/UYgdHqNs2nXhOm?=
 =?us-ascii?Q?J8YZaF0YXMKwQlJX6mQxv/aZ6AHnAgqSrMx6w4ZouOYYSPVz/M3sE5Ke7AFZ?=
 =?us-ascii?Q?phKeqHfUgr5xfYh1gXmhEGq6TSSzMBEvy8zyFuolb3qRD126gzpARnK11nOZ?=
 =?us-ascii?Q?WWKv19IiOgCTbW0/CNcGBMfJotq6Jw9qvj/jbOOXowjBAe42s7ZdEOhJQbKC?=
 =?us-ascii?Q?sZAnCIy1G3cflY5dXJs+27+7zamLXAkFqIjbP8XoCO+UglZyzaFXik95FWcr?=
 =?us-ascii?Q?ZXYK9C8ap42swm7D2FpwUKFWcrG9r9rVgokJMaPJFAfY7qDfbfmH0pzxrHav?=
 =?us-ascii?Q?xFP5GoTbUfmute2e/QhGx33QO8gj7lurCRcIdL7WrANND0EwmBUVBfkCKr1a?=
 =?us-ascii?Q?WjxW4gVZVmgvcQ1yriVNBlNyDmg+GWSuiLTQXWpFedYbe7cujCVJ8jfnwsgX?=
 =?us-ascii?Q?uVeKLeUrzw3NEraMLV9Sm19hTgpRYgU5eFId00L9vBGMRNKgiaXgpWjwIYzG?=
 =?us-ascii?Q?zSDrSdwjU6ozLb809bUa9nbCnUcY14L5CFiq1P3GJ9iIJylcZVvYOiRj2bV3?=
 =?us-ascii?Q?J1eW8SqkVuP5GwE/N2MgWH7P13tm5f5Lug+gHDNquuGIb9D3GYGAjBJx/XNL?=
 =?us-ascii?Q?JTTYWvcIZTyJWms8W1pLwKO60TMtW3Qsk4G8QtYIn5PjEclc8tYxRuh465gv?=
 =?us-ascii?Q?09ZwXQrme3AzgEtcUOVrXSxjZCPpcJs5aAf9dymkhu3BxesuPNSjlp3RyYz4?=
 =?us-ascii?Q?SBApCLFHXJ/EU8ky0sI5JSPOfxfpPfUshs3AiQqHX5iDnU/gIFQvmdbhktSZ?=
 =?us-ascii?Q?Q9jMIUMGyGMYYrhs3JCJUb67TULF3Ak8t+F5LJmSulZqrUMheQIdN84xX/ts?=
 =?us-ascii?Q?U9Hi4ON3casDiNszlU5Pv0EQpwRkbQc3MZyVm5Nzg+RnkIjyEBgxBhSFc7oT?=
 =?us-ascii?Q?doP+u0Gfs5X6XBjEw1kg985sjUrN?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87905f56-c44f-4f05-6c19-08d951bdad22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:48:54.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AFnlvSVK32SFPdKrBXA0MuP2xORU+lSJGXw+bk9e1m/voGw6Dfp0DKMbauc/SGpLSJcwB7ccWpXbYpR7BpeRA9ZFC4lHR38jRtKWZYSsbfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4970
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 05:16:31PM +0800, Yang Yingliang wrote:
> If nfp_tunnel_add_ipv6_off() fails, it should return error code
> in nfp_fl_ct_add_offload().
> 
> Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

