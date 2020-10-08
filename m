Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CC8287241
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgJHKKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:10:17 -0400
Received: from mail-eopbgr770042.outbound.protection.outlook.com ([40.107.77.42]:36439
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729210AbgJHKKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 06:10:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvE7jiih6RwUSBcVVp6QONibC5Kz0CygJ4115Z9gGduRgev6nIjyv3zq+cElVK17c1nk1//tWEZ0LvBjwlLna2Lnv9Qx29d+nP712epypzqrZkA3grlyVcRjWdA8q+NJNBjfPaovlSyV92SUflxGD7KAvfV0RWu211Lh+stU2GVxcCchHcN8XskkKZ1fRkYsKHwEnqaLIXVqWwWRfkR7QZkHA7wHm53r9Hhm6oI72IVXj6yD9+Py2+ZMJnFNs11ZoiNQDyBLxCzOKLXPtQ9y0smLzYPzBvrMB5MDQyCjD/wzd8Mt0heFuIx3Op+hRaZ/PgTWejtrhDSrIyTJ+0Y92g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHuDbxcBKbSN2JwfUv4ERQtFnj7CdeJuUE6EyFDYPaw=;
 b=f7zU/t1LU7y15kgmfn8eGFkopZkZffhjoeU2vgBrgKjcr1+t2Ub9zaa5e0Qn5ZOLYGfBxsZ22L+58Z6USCPYtQsG/tTcfZqGwohhsju+wMNNA7rfbmu6aMrX75uV6Al6PpVwuxxnsnnZY1SEpqD61/RHTnRBxpEAsaZajgkTUEFY33+OPKMcLSz1lbf8ZvglDw4wgAaXxUTR3RXr9rGfJ/zgz81uzRa39LiGjAj0agg6ta9mzl6mUEBy4wWxDSHjnm4lnN1y6dhH1BR3eWLyf6i/xEs6uTa0E6lA7ONtfo6XNrqHtae7WGIUjAZnBQd2z7bo3NSoqBlXeq4ASd5Vgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHuDbxcBKbSN2JwfUv4ERQtFnj7CdeJuUE6EyFDYPaw=;
 b=pWTTTCrpaAg1MVd0ds5eGluzMR/ej+JD090CYNvO/nO4dq+n7+MfLCHA0QmqTo6NGpt5XVgHd7Ek5IRJuMnpZK/J5l0GYWeSMsp0ze7h4bGYQTreskP/e7TTwjBrguVNrzX3/ggxREj+KbiqKHFZYd9RJLCiS++saSmSDd3O0zs=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Thu, 8 Oct
 2020 10:10:14 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 10:10:14 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/7] wfx: move out from the staging area
Date:   Thu, 08 Oct 2020 12:10:08 +0200
Message-ID: <16184307.3FagCOgvEJ@pc-42>
Organization: Silicon Labs
In-Reply-To: <87ft6p2n0h.fsf@codeaurora.org>
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com> <20201007105513.GA1078344@kroah.com> <87ft6p2n0h.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: DM5PR12CA0021.namprd12.prod.outlook.com (2603:10b6:4:1::31)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by DM5PR12CA0021.namprd12.prod.outlook.com (2603:10b6:4:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Thu, 8 Oct 2020 10:10:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93758fa3-c108-42d1-0eb0-08d86b725901
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-Microsoft-Antispam-PRVS: <SN6PR11MB350112AAF3B70E8B296B9B2E930B0@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +DBOgOi+gRZdl1zPV/L10tNQO4TglbBWds7yhddwWr0PyG5zHzuS/zolJ0DfU8mzrQRKY67LiojLACfQs7ZD1eSWybFe5EG/dnwv+rKjhLqbRz+IWDwb5G0TD42rTRQ/bwx6wiCK6i/IcF5vx7aWBI3vvsHWaUk0Txldod47NJPTO7jiIAMMwSaf/AUdr2tiy4OX/4Ivk3hIh82/uUAI0HhVQ726/1tXcn8Qzn6lFQoB7SisqpdGIcTnLOYvgDRvimcjzjumfQPn7ZxkPwx1aY78AWkeYZu+HrcqJqf9YYitgYf+21xBxFOsTpSSlHM7wBfjVuE9xcKF6z2zAMHwwmEJ+aL5NjvRpcBK9fPKIooKxKO2Zrmzv248y/bjntvs28RSAqbEp53N3qYc+0urecDzxQyykxutbkWdjh4Y7S1yzZYINXoP6GZyjiFSpUcgD6TOSWvgxudoTUdBh+4gNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(136003)(39850400004)(396003)(110136005)(66556008)(36916002)(6666004)(66946007)(52116002)(16526019)(6512007)(26005)(6486002)(9686003)(316002)(8676002)(186003)(8936002)(2906002)(66476007)(6506007)(966005)(478600001)(83080400001)(4326008)(33716001)(5660300002)(86362001)(956004)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7WMdYVTuxY/Sl6Amc7C8R71zhvvTa0edPImB+ZMnhQ72cq3ct4wnkRYBlHvKiuC93Czz5FGwAARymD5Lxx2SxvwkXQkz/WL2E6g0ZcvzeUU7jZvM9RHDoagqgdlbYMqpGgACXoQ8wFLw4Y6z73U0/p1szJlmhjdKZURinflRJy1jGiITPwd75ILStuh9a0rIsLgUjow8ufCe4HxBy6rwPAwm7Mq5knNZKrQeR3mWFg7InFUuQK7WgqTIA7ZNcN+gKHmclqxbL6YKPsOtpiQCdedqIwKXcyfZfcUxoYKdlnFB9QDGX0MDLUuOGc8KB9kO/0YUQPY2mVggBlwkiBSFdxr2Alml8oQYdir6oIC1kJ8oVWComYLT1xsAdOtePsyalGvWruBXWhuQHVTabLGZsZHrrbRvnkAen7XFOeuKm3dvWPmNNgpIvUqCQuDmp3Bya70ZpRb0Lwp2P5U0xMqrveLE4TiZa9vLITTfsFOy33IY6j8K7h72IN5NaRyp98W+dsXPq/jCLBN/LYCurUzCRNtQIwwroaA8aT0WkXYCaR9K3IC681N5Qp82qNYH76O7fDmD32YwOQ16EpKhLxhCvjyNB8kze1arvK0fuR7Arcl1TFerzpchc8rKWfjKK7hKCmtRW9vlhiwpSr1LheD8GA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93758fa3-c108-42d1-0eb0-08d86b725901
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 10:10:13.8989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T2YJwHPXi2nmysDUsvzj2rMB9TyeTHqRVgitrUzV/8k6rtDzwhQbp91cBu3HEBRxOM6Kd8E5SIZg66c3gX777A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 8 October 2020 09:30:06 CEST Kalle Valo wrote:
[...]
> Yes, the driver needs to be reviewed in linux-wireless list. I recommend
> submitting the whole driver in a patchset with one file per patch, which
> seems to be the easiest way to review a full driver. The final move will
> be in just one commit moving the driver, just like patch 7 does here. As
> an example see how wilc1000 review was done.

I see. I suppose it is still a bit complicated to review? Maybe I could
try to make things easier.

For my submission to staging/ I had taken time to split the driver in an
understandable series of patches[1]. I think it was easier to review than
just sending files one by one. I could do the same thing for the
submission to linux-wireless. It would ask me a bit of work but, since I
already have a template, it is conceivable.

Do you think it is worth it, or it would be an unnecessary effort?

[1] https://lore.kernel.org/driverdev-devel/20190919142527.31797-1-Jerome.P=
ouiller@silabs.com/
     or commits a7a91ca5a23d^..40115bbc40e2

--=20
J=E9r=F4me Pouiller


