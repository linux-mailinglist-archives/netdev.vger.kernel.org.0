Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEF835D394
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbhDLW7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:59:12 -0400
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:21345
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236485AbhDLW7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 18:59:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgF3JxDV1oayw4Bf/Yx1y0pu/EN28Bd2BNrEuSErEWY4Ikd7VIODeX200AfHmhMXHNOCOY48dEYUn5aW5jl1KblfeHc+HRGReJSxC30hjMOLVVjWF5P48w+hnXLhXmLz67x98XN83w7NtL1/WFyU60mMCqjRLfsBYh7CSY+97FD9Q8sh3MPUtfY7xf2q3mLyj2ZCbrQc6CbA252/orMUD3ubWYgI35n3K3gxFpVjv9GdsPYYqV0n/3qPN9FWvggtSRqerfiYq1Fk9k5vxJG2i14IhNzl2rB0HRBubkWOGIG6B+7B1xXPAuuHK3qt3TgInPpFnzZGUFvVNIQVe5VQUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5gkd7UlYN+KcRbGsfKa4MiJ+5KAnf/XSrXzhnLJNow=;
 b=mMCy2UpqioES6tRZi4cNZzBDLzPY1NeUwzAZryo374opa+JDOhJwFjg5LSfrtm2Z8UzhHhV+dko8Mb5ms0GLGrGpYXaW4Vf0xPfz1iUb1p93TJ2o53kbrG9gvu/G05UuNKyaXCAo+vIX274p1uDLcty7//x0iEDKC8eBxhQyzEJpikCnIk3TmoDKssMRY7IN9tgg9L2T0DIwAoJryt4JuHqHgaBeTFFailWqZEwQR7oKpGqBwXppLPJoouafkEE163HunN/RO68NVkpe3/iZbtgzCzO90m6gdE9xuWu6qdvSNrDxXs4CSYiv9ijVmQE8fgfX2/7+pFOHqG5lrvXYjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5gkd7UlYN+KcRbGsfKa4MiJ+5KAnf/XSrXzhnLJNow=;
 b=m9S79aebnSua/hEO+WfQbFFrmPGm4kVaSv3V+XKNLoVzIpoYhohGyyF2DvNznREM8kh0ubf6/F6LHAWPdFoImVZFy83iL1zxJngAF0bRAlzkWzr7f84epWcb7jlckpc4Q0anEkOaJl47n1wCj5rT4YP1W8QrS7QYhQEcJJ5YNRyI8u2n3ktJwPx39cfrwL6XpfUXHXdKgN7ypNtmaQHPH6glAwgg7kSvdzlX3v5mmtp6cSKGoVcMv4N6s9MICwN+bpTD4NsM3sBAkm62W4vv7v4AGrqs3ufAFZsAxHXm/Cd2JS1nMuNLFpL8FL64HhXccuikA6wMLfvl5muiL7cMvg==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3833.namprd12.prod.outlook.com (2603:10b6:5:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:58:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:58:49 +0000
Date:   Mon, 12 Apr 2021 19:58:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Message-ID: <20210412225847.GA1189461@nvidia.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:236::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0045.namprd05.prod.outlook.com (2603:10b6:208:236::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Mon, 12 Apr 2021 22:58:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lW5W3-0050Le-Qi; Mon, 12 Apr 2021 19:58:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c52a63e5-f283-4b28-4739-08d8fe0688a3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3833918B34099800D6FB113BC2709@DM6PR12MB3833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: udyeN0q1xYMRS7pqsS8TgWZeLdM0W6c4nBOXleR1sJtgaZOcMf6fDH3JW1MnLBak3WsshyeHy/LrQu6z1sH0k1oeGlitfJQfE+0hzdawciz1XmnIzsTtxSNxknGnUQm8AGMU2P7emvxaMQO2i/MEv9UntkHlSUBKSr8peTyN8bU4iTAO7fw7P8YYu9ONFaYUMI+8jG+jB2rLd3ITV8GtAl2B5zH55HPGHNQXYcumnHoPf/YHDNqByPmDNDOD04COnrzjAMfUufm17jLtrNAF+Rnrt1bKXr5tACLOUk6PuymCx33JZ15CUSZFUcpat6jZRPirDEDsEJMMEApi07M8dE8l1uR8nfkN0yYfztLzaDNLiMD8GbWaabAsd+wSpcIlckK+E/CgTk9AG7tpEq4paJlXYyyVzLqJnYAz41SQIJX/RkDlTDUc5UqJMJLuyPlu4IAWHW+j2tXLHQUOsATVf/k1IRmTJYhk2ZmSnryZMP7wSl6AVKnF+JZjSEtbrZtitAOxIOL+P4xFGOg3uutykN2EnN3ucgJebiIbU2WIv2u+BDyq8/L5mfW7Ll9ofyjQGTL5Gt+kIZx/drgIm58HmpMh7NMiaZw2emxzU5nKC84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(2906002)(66556008)(9786002)(2616005)(33656002)(186003)(8936002)(8676002)(478600001)(36756003)(4326008)(316002)(5660300002)(86362001)(54906003)(426003)(1076003)(4744005)(6916009)(38100700002)(66476007)(26005)(66946007)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YVNZbmREZVVOWEtvQ29FMVVzK1BlWm1kK1ZwbGxPWXZRbDk3VGFzaWVnVi8r?=
 =?utf-8?B?cDZBMTU4WXRwVnh4R3ZMZTZDcHZRZWFTblNZZHI0WTBTaSszbGp3WHBZWXR2?=
 =?utf-8?B?MlQyRTZzcXl3WUY1SmdmYmNrdGxVenNXZTBBYW5iaXBtU3EzQ29wa29ocWJy?=
 =?utf-8?B?bHdIZzhDQ2owQUNWK1JrT1BmWjR6TzhmSGpBa3JDelBTOW4ySytpczhqSnJq?=
 =?utf-8?B?aTZJK2hVcncyQUttS0l1R0VZVUtLdFV0ZDljVTFxNURqWVJKMVplZjJidEVI?=
 =?utf-8?B?aHQrR2FWRTZMSEkyWXlpdStPVWo1OWtQemtOUDlCbWFrTXF6dG5ZOVBQQldG?=
 =?utf-8?B?SmxyRTh1dTdSTW5KVEhRNHNNU001ZmRwQmdQcTZ0Z3lkc1dBZlNRdjNZc2JL?=
 =?utf-8?B?M2lWQWZGZ2J4ZkpBVElTMkRHK0UvekJ2aFIzaGpwZDJpa3hrcVBYZzdzOGFr?=
 =?utf-8?B?NE1YeHhOTUlOdGdQVzhSUm95YmZ1V2NGYnJIcDcxbG1NMTJvU1VoejJ4ZVhO?=
 =?utf-8?B?NHBuZXRGWkF0UkJmMWZ0Q1B6cW9xV0NzbjhKam41YTFQbUd2STNTck9NblNq?=
 =?utf-8?B?Tkl2TUs3MndDQ2N4NEllRFZZZ0RZZGZJVFdLN005U3luajZ0VWowTXVKUTc5?=
 =?utf-8?B?NERiMEt5YnVUZlZDc0Z5aW5hNXBBU055eXhlb0ZKdnBBR2Z2cG16emliNEg3?=
 =?utf-8?B?SUNZY0NIMmpYdjFNNXQybFJRMENNNjNHbTFyNXNTQjNXcUd3NXgrd05JZ25I?=
 =?utf-8?B?c3dPRjExUStTay8rdVFnd05HN3JpVm16Z2E3UjVQRFVheXJMcXBGTExNQll1?=
 =?utf-8?B?djB1VERQeS8rNXppU2NPSWpYNzQzVk9QSFFJRHZRc0lKSlNPU2h4cGw0K1Y2?=
 =?utf-8?B?TktlNWJ4QW1zbms3VlQwU2llNmNzMmxubGZlQ3BscWlMdXA0ekltdHpRMERp?=
 =?utf-8?B?L0lkV2RMTERJSEYrNjhqTklLQ3UxK0lJS0ErSzYvbnFxdUIxTDhjTGFjeVVa?=
 =?utf-8?B?ejVjSU9lUkxEVkl4cnhaMGorS2h2VnZvczZweGY3Z3lHQzhWV1kwdHFadnE2?=
 =?utf-8?B?bmZnL1AvbWVWSmNlVlZJRUV5NHI1REZsOWRySmFObEp3QkFUcXY4RHhhaXho?=
 =?utf-8?B?VWVMdUNsWGlvZXFKUXNGM3J1S2VhRUZsUkZQeU5kVis2bkFpTUhMdVF5LzYz?=
 =?utf-8?B?d2g3K0lVenU2eHJIVHRlbERiRjZiWVZ3OWpLMnQ5a2wrRWdNZWllT0xyOHd3?=
 =?utf-8?B?WjR1NGJUNG5XTlZOcmIydEZrOEZtbXpZSHNvR1lCa3NvOERpMzgxWkZXMXNq?=
 =?utf-8?B?dnhBNktJc0UvR0JVcFZ1ZWlhdmhmVkZkZlBmSkRUMDRHZUg0UFBNYzQzVkMv?=
 =?utf-8?B?K0tOT2tJRlBpaGdnL2dSdCszdmtMUkk2c3NnbHJWaHpKNnhHbkxlcjkrSkdI?=
 =?utf-8?B?aGpMdDJQUG9qTGVFNC9yS1VhcjFnTUtNTldkRmhvd04yR0V1UVFocDYyNmtI?=
 =?utf-8?B?WXlhNmVnVEJIREw4ZGxKSGpTNlMrOWEvUlcvS3ZWWDE0cXMxVWtGekY1bFp4?=
 =?utf-8?B?SSsvUTI4dkllRnpzcmFjREF6VGFCbzllb3VGaU4vQndLZGhZdWhIMTVYYUVa?=
 =?utf-8?B?QWVlOWlJcHBTT1cwZS9IY1B3aWpRblVyaytTbE0vUVZvc3BIWlFnTFlhdS9T?=
 =?utf-8?B?cEd1KzdHZlYrOHExc2xoOVZxYmZwSDhmMnd5VHg5UEtlcUVjOWZmRnlGdEhI?=
 =?utf-8?B?K3FXdTdURkFJekhoUzd2RmJGa1ZmVVF1ajlQTjUwN3JvYWg0OTl2eDBRQ1pN?=
 =?utf-8?B?OFlxaUtWdVhkMjFlQnB2dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c52a63e5-f283-4b28-4739-08d8fe0688a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:58:48.9645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kBLEVqpZR/ejpjTNI4/73E2GP1Hh2rCMe+xH4YlIFPJDSbOdkIQoWmt+Wgy2QOg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3833
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 08:43:12PM +0200, Håkon Bugge wrote:
> ib_modify_qp() is an expensive operation on some HCAs running
> virtualized. This series removes two ib_modify_qp() calls from RDS.
> 
> I am sending this as a v3, even though it is the first sent to
> net. This because the IB Core commit has reach v3.
> 
> Håkon Bugge (2):
>   IB/cma: Introduce rdma_set_min_rnr_timer()
>   rds: ib: Remove two ib_modify_qp() calls

Applied to rdma for-next, thanks

Jason
