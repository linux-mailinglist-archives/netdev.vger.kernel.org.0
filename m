Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41384A6932
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243337AbiBBA2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:28:38 -0500
Received: from mail-dm6nam11on2060.outbound.protection.outlook.com ([40.107.223.60]:29600
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230330AbiBBA2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 19:28:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhvpvpAh3ZsRAvUoXykVSsPNOEWZ7cPMYZ9o3aNIF0X+pGtpDScbatctu1/X1opeFtIeued6hKG5NjKnDemNnlXk704E4MctMDO9q+M4BnUHKG8Sxb1JY3lRN18Fedz92G8mQe8dVDY1ZFGpvhCo/E7sOYMd3sOOAj29U56+2onkbMOeSqS+PbhvNazZqXvY62GvPzPOKNba5h6rat99GNHTxQnC9YtD/EhU969FhB+nSlsJUNdnZaiRLYK0APHeQ9Udtt2VP8JfflCXRs/IRgww8wyqVWYtddfc9kiq5geIgekiljyaoMzRwu1U5/imtVVTbmhXf7xatqSEVEUBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FD246ub+RphDsN7ij9IzfzQCMEp4YJuu9ErGnTYZ1HM=;
 b=ihKK/AKlSngyXJ91X0fU6dmZofjp+0mpZw7VpSDKLlnYrlcdXWkIyTxsyTsMOuqPd9lFvdeNzVOcXmE1qM4j7cfQJoT8iQG3DmdMizKq+mu+99NZ89ayonkmuYOL5B53QhwPIHe7UXUNnkGgbeGtuUsSo9cZMQj2Roga0UVyNKfDimL3bxDP7pQLxXBS2SmhtUhOC8XJGst+Z5DgeA5/DoBWWEDynxlFEeAcp9z6AmjS2on5hDVfTIa3Dgz0nlD0n/b8Iq/Hn0pFFR48AQTWFbEJWGVkewEQDYCJ0Ge7F9yx4dr0r3VT5ir11RrhPs/SQ+gETpSGHbcwgsMjYv6dEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FD246ub+RphDsN7ij9IzfzQCMEp4YJuu9ErGnTYZ1HM=;
 b=RBhBoLM8MsehA5FkIDBKUXaf2TAgRhX2aBVvfkG+itvY22NworP/JmmurBzK1qrsdKEkoTOqlgVSRkBM2SyP+WgTTtvZP2K8+zh3njPG2IZeDKbdGnPg7dJumwKNzX2aF0Ujz1YUVtVGEmRoBwwLts5rAcf/E+e52UwmtIP3eUteZzI2i7g10h4lwm1hA3S8ZSAoRrH4C6mThEi+azg3mhi6Hicf6L6VJ8g/1t8qC79KN/zp77nJmsAXiwPzOL/fxHMNIqS5Sk/HsRMyLCWPcnBUGaXjlLo2aCKk2DnvS1Njf2iGK1rZ2JCukATdXdBydMfZV5YJ2MouGpmMRYxOsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3201.namprd12.prod.outlook.com (2603:10b6:408:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Wed, 2 Feb
 2022 00:28:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Wed, 2 Feb 2022
 00:28:35 +0000
Date:   Tue, 1 Feb 2022 20:28:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Message-ID: <20220202002834.GQ1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com>
 <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com>
 <87sft2yd50.fsf@redhat.com>
 <20220201160106.0760bfea.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201160106.0760bfea.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR15CA0003.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a76ece13-6334-4e24-eb20-08d9e5e2f32c
X-MS-TrafficTypeDiagnostic: BN8PR12MB3201:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB32014B6CF89E9C37D8572D42C2279@BN8PR12MB3201.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HfKJhtw9LqZyT/w5sK5jDVXUBGYCml/MWOR7RgrnkyPG9SQxUyenDxBQjjoxsw1xAG3yo4kSzC7Fw3J4L7M8tlvOl7IaYhDv1E9xNZLrhNyQ00d0/tP50mt0jsP/15BBNG8dhEUDCcUdS4y6yKt+mUxDZri1Yl1cp4pFwXchkMjG9ylTbapqNQHoyGjHd9y5y4bMB/UNQyQ6MtzT6xk6zgyPuckfKKx86LPmnsMYxoioC/oPP/Ud6/F2vuXzXfFA/doVbUB2/6QUSdJyngX7aCvSDUjQ4kRcJVp2nDByrVfbqTqf5y9hvLwAzvXVNHEaOSEZJFZxYl6//JDdj7rOcvpE8Bek3Q9t/6xmG7DY0QbbXHW31UdqHX/A3kQ6v/kDN74knLY55pyXv/OuVM8PrHbcOZJUIra20l6FGUlSy5IrImM+SoMJVXC8g8ocaObrSj14iHP/+Oh+0u8w41RPNy4VqScQBuGo0vqTYkHiHwBHCrQ9WwgKYwLjVMdHS7dJEVlIslGbT5uDTaJijbD4Y570zZ8oMft16xvBKp4AMucKFnrRh048e5/6a/qHqqgEwPaE4RsL8jZnuczuRczV0jgXs8NfssYaupE+0E6et7ZcxVtUhpeupwJiUGfrzgrSVTTRgC23yklC/dESkO2BNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(66946007)(508600001)(1076003)(186003)(83380400001)(2616005)(66476007)(6486002)(8936002)(26005)(66556008)(2906002)(8676002)(6512007)(6506007)(33656002)(86362001)(107886003)(4326008)(38100700002)(4744005)(316002)(5660300002)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PGSQ3GjT4Qk0DLzAuWlG0Hnsn+TrK8OSB+wQfz+R709FFYIRmP9ahP+DLU5U?=
 =?us-ascii?Q?Usx62WDYik41BmIamrrlQvSbpmm1G31aF9zvZI9nHeVoNMQPArCk4Uwk50AK?=
 =?us-ascii?Q?eB+siMVpOpZHXHGoDFgjHfbv4gq5Ve0BCrkaPlt1p/9MsUJut7i5uKOJ6Z84?=
 =?us-ascii?Q?G296TVDUx8BKJg9Bp/3EKrPwPf8IVako0eESOnP5yCEcXrx2Cp17UKNkzVkd?=
 =?us-ascii?Q?1H3XIi/NG9jVJlK1MqFsNNS253987XPd/C61q95Mef/+wPyzYfHSU715x1jb?=
 =?us-ascii?Q?cJuS/D6deTsad15kTy9fHLztOCiVPrT5tY6OiPCuZK0PdC8JInyxnDOgP3f6?=
 =?us-ascii?Q?j0o7f/F4j7Skz4Xn4o/2H+U7eXReI7TzCz5FtHfhA5ajnkB9QY8ZBdi7snao?=
 =?us-ascii?Q?5M5xOT0k/8eVjPN3BPWnzM8LCSRf/jeQlN0tHrGPJ8D8DfwhnfF4SpKmtsj8?=
 =?us-ascii?Q?M1afyi1dDhVMuqKwavgxAnfZa9hwpz7o2pZvPwOIKe+KFCm4JBPUuXMjllAR?=
 =?us-ascii?Q?SkKGfrSmgRYRLQ6mYLAp3gFpjj80fj13UwskjIpOvhqoYd6yFIe4rk3s756+?=
 =?us-ascii?Q?/m2WL7RBMxqA3HmYg1dAMpy6rehcHCAPLkS400+HxB98XdbyDLExrLwQw8G1?=
 =?us-ascii?Q?FRjztaySpoCbzjd4zcgUnoliBftzX4El5l5R8DqQb5/NmW0u5of3rbmTOlX2?=
 =?us-ascii?Q?r4Bq9TAVVnKx3fTTIBsCikY3FmPUVuSxWt+WoFmCIW4WIDf6ow5vz2UhC+pk?=
 =?us-ascii?Q?Cuexjd4PN+w+OjpV0t16xoK9u9/+gi0DYEsd4RQiBvbNF2SoIi9u8/NR2USY?=
 =?us-ascii?Q?FT7eT6LJpXz03xfnYBWbaioDIm5cFGjRyc/9A+W3u0seo3oIDCvntGYWyuv0?=
 =?us-ascii?Q?+84CA+LFKTDyVxCAEtWMvS1iKUZ71z3YjjW9nVtJG7b0oWdjSGURhdUQgGHE?=
 =?us-ascii?Q?D+c0jNsiT+6K/U4fZhUIoDN3oA+80dCx1TrsuGtC+URL3uOd9x5w21IfRHRO?=
 =?us-ascii?Q?qcaQ2HmgOHvKV6b2gvqAd2zz3BWYsq7363Ws+ghBFc+g9edD/gTm1qWLAo9L?=
 =?us-ascii?Q?guI0cwMoKmQcOJQqwqgRYfL17KS1Pm5Q1NqwN1tNPeR7ieQjahuwsKncAgpc?=
 =?us-ascii?Q?eiIb0bBjdV0mwss4kSOfhKE3WANVtg1vH4uuG+GqkwFin7wIpkGD0DqPtJ2L?=
 =?us-ascii?Q?qvx2eN9oy/Hb/g4h0USUDnbm8vQKm3evIKcVISyrBBh7AqtY5ABjjIiOW9Ut?=
 =?us-ascii?Q?H9BumBkUU8adhf69ALwZ7FNJ8EO8Y8FdanyPlfFBz3hAE7M6gHiPb11RKomd?=
 =?us-ascii?Q?OgGwnurOIO7qRgXb70gd+jdr9w3iebaeDYsyLDNIbr7pjAIlOIfMlkrYMyaU?=
 =?us-ascii?Q?z9JUSZm7tmz+4REgXKlRPLDm7PFPVKeParBbXdLOgtm9gr7hJYS3vH3Nt4OK?=
 =?us-ascii?Q?QMIyo1hwv2I33E55HxNwRjGt6kADSMQIPGFs2N7mbjJsSvYIhtDNc4dAnzMW?=
 =?us-ascii?Q?j7R4uDfVEs6rzgA5ASofXR+rzNJkTNVdqKQAcOVZUIyRHUQiw5X36dq9wy7o?=
 =?us-ascii?Q?ElXWOgtoVQ93J4eE5sA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76ece13-6334-4e24-eb20-08d9e5e2f32c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 00:28:35.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aB4l1tOUlHkn9CEab9gpcQwhDhCCgjwzfBJzDAvaWVwdh4fj0I3wjU8UsieYnCic
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3201
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 04:01:06PM -0700, Alex Williamson wrote:

> Agreed that v1 migration TYPE/SUBTYPE should live in infamy as
> reserved, but I'm not sure why we need to make the rest of it a big
> complicated problem.  On one hand, leaving stubs for the necessary
> structure and macros until QEMU gets updated doesn't seem so terrible.
> Nor actually does letting the next QEMU header update cause build
> breakages, which would probably frustrate the person submitting that
> update, but it's not like QEMU hasn't done selective header updates in
> the past.  The former is probably the more friendly approach if we
> don't outrage someone in the kernel community in the meantime.

So lets drop the removal patch and keep the V1 rename, it is easy for
qemu to follow along with this.

Sometime later we can purge all the dead things from the header, eg
the POWERNV stuff we left behind last year as well.

Thanks,
Jason
