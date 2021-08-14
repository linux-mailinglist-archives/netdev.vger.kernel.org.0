Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C073EC3DD
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbhHNQe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:34:28 -0400
Received: from mail-bn8nam12on2106.outbound.protection.outlook.com ([40.107.237.106]:58778
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229818AbhHNQeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 12:34:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIuv9DB7Br26OXGGxI3XOWRHHjP5c60Tkol/ZqU8SV7h6xJQ4DjXhoeG8QFy0Fe2YHWty4XZEgMaiTJrkYkvK0GMH0Hq+XbztWHO3tsimxAZFollM+Cbt6qSbr5dwlX5bIVs/c9GGz4KbyE7GAqAdxJihD7CMZw7JBjsZmrrfZskue2kEYOrF3ZBBWFCKds1PdskY9q/bDbh8AM9FF6K9sabrsSvMyzJpczplvWSgz0iGVMI9nU0hMMTxrX9UfSHVt2OqfmWkXl0LAeoKxmoGwzIsXIekJWuT/k2krLl3YPF9QmfzW8CRJ+TyFV4IYFgnJBXhe9rBNzWqdP0GrKD5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qE2vtkvIicJU2uWB2uj3x/L+pRJhUA8HD6Mg1L1Rm4g=;
 b=Cpv3ScCY4rkOq0NpMsJxfzkFkuw/qcCKKhdHGIbFU//A+F06JR6CVcY9DO9whJD7Wn0qQGBZiRmnQhNjcLc5WZ3ehDeSNR/4eMiIYf23bLy4EmyCzc2lt8iYC2XU51QzWrmW4LMD9vJwNvKUA8dqMiSh2njD+Bb3vjO+AM/12O7x0KK7fllOIQXft6c8FLw7f/PE+ivcryghWME6upqpIXexIqBig55ptRtFAwTAPmwe713RyvYAdmYa0MvsCHz62URSU0ynZhgOM2JLNp72JDk9Jnqa9lM6g+9nIhLTqKo0PAfRC56ZU/GTAI6bzsuDPXyF0dJzLe58OuhjBMUBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qE2vtkvIicJU2uWB2uj3x/L+pRJhUA8HD6Mg1L1Rm4g=;
 b=KoL9FA03R6fqWjj21sWQ8vN+bm0kLTsM0j7pO/G+sPekQV6JSi19Z81pTV3H+Nc2NkTwAgpPAu4QwxDXpXNDInokkx02d65ssZTyQysPKERSnwpA5orh3CZmpJntiCWIvgkLCOhEVq4pYLHg95BgcQVpBMPCKrqO3I4r5Q317bQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4802.namprd10.prod.outlook.com
 (2603:10b6:303:94::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Sat, 14 Aug
 2021 16:33:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 16:33:52 +0000
Date:   Sat, 14 Aug 2021 09:33:49 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 06/10] net: mscc: ocelot: split register
 definitions to a separate file
Message-ID: <20210814163349.GB3244288@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-7-colin.foster@in-advantage.com>
 <20210814111509.p2ypda3yj5em5ro4@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814111509.p2ypda3yj5em5ro4@skbuf>
X-ClientProxiedBy: MW4PR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:303:8c::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MW4PR03CA0135.namprd03.prod.outlook.com (2603:10b6:303:8c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Sat, 14 Aug 2021 16:33:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c20a16a8-8716-4af0-ed50-08d95f414d2c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4802:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4802781F1C9DC949996D8542A4FB9@CO1PR10MB4802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g19RkGDnmfz1dzYpbVb43snITeHlT3KMTTgEuYijcHSNI5WKhlFGrSGRtbTQ9G7JEzoBjrT6P+0A3R5gSzuT33RgYdVZUnL6AcZHwMlXlvumIzXtGG+y1RtaBX0XEl9ZAjpThI5EV24jHdLCwHHQiqikNRNjMNA1r000GCXiWznir2NtYNJOVuKDHBci68TofnqHzxNYU2K8JT44cbqF/PxYh5Rn/uutSo446YCbifduSoFZXAkBmkeZe7rbwRV6xKazIFX17Xm4G8xUVOoU5BRGJ4uV0jEbNuqcQuCRVPrXr+w34eJmG8Wp/vKYf4lEMPy3qFUG8C6zpdTvxq46HupJNRrngDuPCzK7rokxuluQ1JH+i/2Zn8xXrCiz9K3WmKDrPx8N4ZGHko4hun5gHS0WoiX8S47+dAOzfkokMaHxHq78IgZvdwaQM6jzUfPPgUuSxpwz8xeZ9zC0/bgzPV2nr/YjQ5lMGlEnDjun8dbv4J8a5ydWju1VmCZ1mcN1p4Swk+7AuYqShCmf8k3sbbg1f1VQEABBWuKUKvf2paa6pL3hjUs0W5/2kb3hPvTLf8WJGl/Ue1XbUN38SRWlm+GNmCVkTphBqXOM9Bnt9PWfQpAF4oBq74MNtjWNLFHbIMtqaSM1Jo1xDjw7DtQCBfWpV8faZBtR3RS92nx1KEMn/TmqZTfdRcQLMaxKgfJH/2hwAWVcG8R9WhCUlO59hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39830400003)(136003)(1076003)(6496006)(5660300002)(4744005)(956004)(52116002)(6916009)(4326008)(83380400001)(186003)(26005)(8676002)(316002)(86362001)(66946007)(478600001)(9576002)(2906002)(55016002)(66476007)(33656002)(66556008)(7416002)(44832011)(38100700002)(38350700002)(33716001)(9686003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Ln7dBSITqD1k6ML6eSKHxtuKn5kIzZYVtZys1QySUDwQKLhg4nD+tpWl5m/?=
 =?us-ascii?Q?C7aOxA1lVqJd0CB8Xvm0q/2Hk/j3hAsw1Arl/LbknIByqXQZ2zFde0ze6Acu?=
 =?us-ascii?Q?lcXD6zDXmvWd+pZby8KTKFvZglAM3Qy/NReNkO64bO9mu0Pm9aQDGlHruMWT?=
 =?us-ascii?Q?VsiD14a+9MJOvav3RwhPrEcMCioBjI3y4eEKkzRjMyczmn2OXMjUW2Z7N1Rc?=
 =?us-ascii?Q?3BIj/rW4F+9TeEWHRTE/NYJiGvoXc7qSX1qTx5oNrpltOemgrOjC0kVRLGR0?=
 =?us-ascii?Q?3YRMpFvPCZ4mYDCYeFZb5qQIPhtQFg6PJv2ztCB8RGQICEQ6AE44Gn9XyV7r?=
 =?us-ascii?Q?OYxs71BY/qcj7sFZoBvYTHWdzfRChWBuQs0TeAQKupy1nb7xGcryFYoSDQ9m?=
 =?us-ascii?Q?wsTORcpekAb8+Wzu7C21DFsNeVC0i5sSxbtt37pB5fc6s9j5eni77NwYwvYa?=
 =?us-ascii?Q?UUjT/EMJkRCj50MbfKBCMf0q8k5KYbxlex07h9oKAmD6ZhWyXBvyveHaCeNQ?=
 =?us-ascii?Q?nmWMIw2ayTWGGOFZIXqphiAmRkXvm7Aa70ctTugLLBk4J5jz5S1g+zKVJjMB?=
 =?us-ascii?Q?dbBXnxr4QaRxOgINUSrsFMy7GkSLeFHpTFCqwavrkuPklzizrafeodWAZV1r?=
 =?us-ascii?Q?qfxvDirDubpfm8Jm6rtk4+vQb7UMiMPd9qySPwj7YFxOSKC4UAzs5Mzkxf/s?=
 =?us-ascii?Q?FCRxOH9TVdiNJMQETl6TBrOPpKxK4YARnNfQJs0JGe45ZCcB8WycixQSTiu4?=
 =?us-ascii?Q?y9o/6SA9n2s3FyDaiWhIpsqFWXAu1wKzxIlaIGrdLLE/mMG00wRE/+X9BgD8?=
 =?us-ascii?Q?nVMtnbfe8WrmM5lPqs9dWP4eYfmW8f+NWqTUb4/yfMAhk/U2D3F4wi0oPqo2?=
 =?us-ascii?Q?lbz1hJoujoWNC1hpaG3Rj2M83QSApQR+KDQDjS8Qa8wuRUql1PN8rm/Ijb6e?=
 =?us-ascii?Q?zDKOXbW9Kxnqh+FUr9kzqMepL37IHdH7HRvtwGMjThqZGp4pABKLMsYlakE3?=
 =?us-ascii?Q?cmfx7gfU1LOgd7rnYzl/sZfGinXKAhprUFeD9g9bIfrHmMDW/BtmKIudi77i?=
 =?us-ascii?Q?Op0a6dbWv7dLf0DCAMZhfUznSutMDrXIUwA/yBoNmUwDz9o8ypo4cPbssx61?=
 =?us-ascii?Q?Ca7RitZzQdSxaEmoMu158uaGNOo3TOH5D8VbfApWzUAp1GprV4zMqXw0AykQ?=
 =?us-ascii?Q?u8EPjjVIIlVchkgxT7mxPhQ7eI7VY8RHRKtmGHJMVoY3eGhotQUxZ6Y1iaPT?=
 =?us-ascii?Q?6WnJ/Z88Jz2m41Dmvv61yhULf0tCW2RcaPuS9F85OJ5FZNADatyDFSAUiPWy?=
 =?us-ascii?Q?EqeePhInM50cgAHAjDqQ6o7E?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20a16a8-8716-4af0-ed50-08d95f414d2c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 16:33:52.3877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEJmxZWfG490toBG1JJKwCb7HpcCYNz0q4N8QKAj7C2EwVdPVpWql1b+411dD6zxAnE1qe8LFUZqRc4NVSWwwNENSswydJYv3Mq3ZffbErY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 02:15:09PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 13, 2021 at 07:49:59PM -0700, Colin Foster wrote:
> > Moving these to a separate file will allow them to be shared to other
> > drivers.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> What about the VCAP bit fields?

Good find. I'll break those out and delete my duplicate copies.
