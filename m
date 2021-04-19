Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6E364920
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbhDSRip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:38:45 -0400
Received: from mail-mw2nam08on2045.outbound.protection.outlook.com ([40.107.101.45]:30048
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233228AbhDSRim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 13:38:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzpG8IV/Mc57MOzfj5K9zZSENpipKbvVwYyMdGRLGIh/DY+FnYTUG45vYGFrFT95wbrT4McoGN/RTgQTmxpyDQ+PDSkDr4rk02iT94x2VS2tSaDaensNlLHUUJao1BctXfgk37dfOI+yzWZ/A6kw0V9ZLV2Gp/izEfko6DNCV3wl0eB7hQh+S8xjTL+W2iXWMIiAQ+gVONHPTGiZNwOPKtwZ+oEbdKJtAXnpLejRAnrxoM+d7AQWKEIA2/jQhqnV/+dI2H+LuQCz3u0QX1M3aXnDTVEo4HI7ylhNLwaYvPy/OgMwHJfns3dFhs2wlsJYHvimA3ADhFI/kgErSttdGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAPvVQyF0YTYXCavJCm2nN1v8wtXYCO8lrWawGRl0pc=;
 b=JZ+UvI7CqSDn5IsoRMP4k3XKQ/nhmvu9uJkmrZLEAMNn+SOFsad2xEAfbLSFjMebSQMJGHnzg3xwssjjQBFeyDIOrLNxRN8DDnPGPkvmtCqUu1buneObovv6YBkJ2w9xW1V2566iqIFIz9M6gXvN+dyayqv5cxMDK6j4kMos3SFNo4++SKsNvDMtphtcQgbmOrzb+hchSTyokzRGVp5oU/C8kyRVM1fPF2p3gkxbNfYrOf88mDrUYp6lyS93uH7e9OTDQzVoQ2n5fl/LCQUCvfOeaclzB3NHoECvd3dI8IVA492TZRX/Lbz+vH4RFpHe1BFhxWSREsX+sYSJs6iNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAPvVQyF0YTYXCavJCm2nN1v8wtXYCO8lrWawGRl0pc=;
 b=E7xMje55pYyN/TFYTXexZTjakv9dvum7rqwG4iCm7ps6NIlRsZuL/s9KmDNNSTH7GyrNP++OFh2051ibZTfufA7xKrS1mn/0xSHm46YgAA+uSAdU8LZ2Rjs8IXpGF+1JgLKZgkRNqp1lZrL3714UB+jx+0t4y3251LgZHXjpDC3/psxLFobiZ1XNT4BwUhXIzIA8uFrG8s12zVfITOljFdujAZW0npC2gysVt7f6Nbs9Jgtd3jVFwyDgOFun7ZhlxJd6Ps4u1vVYZ4brsqEslSabyAQMqEFR1DOuWr/yw3y9aTm7NOTHX1ZPYaO+ORUVRBXom5+b3L6yFLKHAJZLyw==
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1147.namprd12.prod.outlook.com (2603:10b6:3:79::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Mon, 19 Apr
 2021 17:38:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 17:38:10 +0000
Date:   Mon, 19 Apr 2021 14:38:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Devesh Sharma <devesh.sharma@broadcom.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH rdma-next v2 0/5] Get rid of custom made module dependency
Message-ID: <20210419173809.GW1370958@nvidia.com>
References: <20210401065715.565226-1-leon@kernel.org>
 <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
 <YGhUjarXh+BEK1pW@unreal>
 <CANjDDBiC-8pL+-ma1c0n8vjMaorm-CasV_D+_8q2LGy-AYuTVg@mail.gmail.com>
 <YG7srVMi8IEjuLfF@unreal>
 <CANjDDBirjSEkcDZ4E8u4Ce_dep3PRTmo2S9-q7=dmR+MLKi_=A@mail.gmail.com>
 <YHP5WRfEKQ3n9O0s@unreal>
 <CANjDDBhpJPc6wypp2u3OC9RjYEpYmXuNozZ5fRHSmx=vLWeYNw@mail.gmail.com>
 <YHqY8Led24PuLU5W@unreal>
 <CANjDDBgsh9FrQOgB-uR0GGYZHcF5cnTy4Efnd3L_-T2_eWqxsg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANjDDBgsh9FrQOgB-uR0GGYZHcF5cnTy4Efnd3L_-T2_eWqxsg@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0135.namprd13.prod.outlook.com (2603:10b6:208:2bb::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.8 via Frontend Transport; Mon, 19 Apr 2021 17:38:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lYXqb-008cwF-Hk; Mon, 19 Apr 2021 14:38:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06cd178f-8bac-407d-a1ed-08d90359e6a4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1147:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1147DF364388C1C7F8C764E5C2499@DM5PR12MB1147.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UqeYoucuTaT1IURngAusIW9ksqKIgkZqtCWxO6oBGVEwkdzxTwLl3zy8ETHR4QXhmRz2srSeOxcSHQIGxKKCVL6L0GXrlNEDsVH96OMEjVrP1SYSt50nT5hyVz4BwPE8HNYfkOEsBjh2SPsY5z0uiBIhcYSHF6eKC4ZhmNRlWUJiQyj2PNsPjH4tzlysH7l4vF8C8u0ccI6UKo8e1DP/rqK/HKUcKKBJDLn8fubCIHNbtDPEhQn9wZ1RTgtvhTVUChqWywH1DnpQsmSVIrDeUQ1akbBRZhrS0nz2TTFbTWKRLUizhEZgbzSErCCiihGUSgYQNOfmxmjFRD6l1a+lP9axKlS5h2poR/dqjvNF8c70wo2mYubkoIUKEkR3o31Bid+wdzF7O+HcPfLk3QAJHg5daijx/X5DM1DsKT0oYu1rq0Vb9Z/CWkPOb3uL6Og4w3MevDwnB6eVFdN/ImcJ06RtnfHTX2KdmGEZ45k3kqc9Ldt0G+/wsCFCsAI57zWub0nGwDaC1R1DsDdnKFD8yojZjpSBir2ZLbPwkLo4upovYXO+2JLk6CYIhMf94luPthYMp1rPC5soPGnNVwR85mlPZSQGHXbG9aBd95p5dwA5ROD7/nUb9bdQ/BqNf4/aXDYUS22efVCpS6fhB6o5FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(86362001)(7416002)(186003)(8936002)(4326008)(1076003)(2906002)(66556008)(9786002)(8676002)(4744005)(26005)(66946007)(9746002)(316002)(426003)(478600001)(54906003)(66476007)(5660300002)(6916009)(33656002)(36756003)(2616005)(38100700002)(26583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5NX8feyw+9aiaW4KCCHFwWmkstPoQHzXhD9/OSnpaeboDV/L8P7YISzcZ5jT?=
 =?us-ascii?Q?mS7cCUhvAwxpEKDRCp4Gd4Nvn8QTgtR7NAnytjQy6CndC2gtGkzW+7113HrE?=
 =?us-ascii?Q?T6eYMePIVK8qmz43jAWTD5SHPNfAro7/WTrw68CvzKQOt8oDFM1YJvN8o6zT?=
 =?us-ascii?Q?RnYIDALsoFtVeSb9bZ2we/qbuM5fafd3Ie6+uy8NDpkWf2cSYNvO+/YkuRtH?=
 =?us-ascii?Q?h6mgzBG7C+RtAhJcuwFc1PGQntmKusUTuYaAuAwOew89F3lyzSyKYTxA7okM?=
 =?us-ascii?Q?rqTW0TWOYyfd7UI1eSID35hg8yXWM14RboGaFXTNr8TU5gm61HAp5ZNwFgS0?=
 =?us-ascii?Q?vs+/QLnJWNR4kpPWk2fcLTJ6oDPhCdkHtYKKjXsgxRMS2RfkN2DmtYAuaYMN?=
 =?us-ascii?Q?g+2QYLlj7UbB2TdUgPsBjvxu1ojS4iJIrBYg38ROnh13ehqQdKoOx6H7msWT?=
 =?us-ascii?Q?ltiTEzd9Z5OSjezKynzl50Hi/gDf4npcPVK8o5CBnBvn8X34Zined7LGqajv?=
 =?us-ascii?Q?tm/zrpjp/s63iXpeG1AXyTPsfxwhCe5bLIkJ1HPZDpFdHyP46CRgfXWlQtTa?=
 =?us-ascii?Q?WPIZrVRAEefGvUsnef4FijAD2sfV//zz9rYSlPzJzbQPAIkoXXPrLA5rAhvD?=
 =?us-ascii?Q?/8vtHw6vNsBIK6uekL0WYWzXE8Lnw+gKZpCMtGmnaa22PGcDui5P5LRw+FW9?=
 =?us-ascii?Q?VaUJfroEkqgwRf+Dz8OwH/CxpSp/bSy9wXd/ujery0QwQ6WfbMc8Hpz8tucV?=
 =?us-ascii?Q?alpuOFP6j3zkhrv4D+hiHL9aIaLZ+u8WfHF7rWhn3x1UpBPLWI503OM7URb5?=
 =?us-ascii?Q?v6EKoFVfmajC5i3Day3YpCCawe7Fy3TIf+bWkF3oI44Tl7xNQjcrBb9T0Qls?=
 =?us-ascii?Q?WKYrlJ312jcJokd+phJJe28wITMZ1QOJ3TxXjb5/Li23jBxXSu8zqwDssBIU?=
 =?us-ascii?Q?Z+StCbqQXUMaHquGTCKZwzoC91KvFsqc87TD8GPmFqQkzLSQGByOKNe1o7ju?=
 =?us-ascii?Q?muRB7loq7VihP+D8Mv0BtsZnJiACRkoTaEifanfqaDHLUA2tXdJmTgnojerL?=
 =?us-ascii?Q?c3NrakOvUwLajBaGJc15XNYu2fifpa2o/93I08kFRwCXgBYA70f68Xy+Z41i?=
 =?us-ascii?Q?cAEhaDdH0QYR1KXrmonocohcDGmKEMKu8bUuHy98k0IVVO+6nxfz6XIGwufe?=
 =?us-ascii?Q?0839fBXjzBpYNrlEvmy8FXc4Y9jyWsKEvLv1ZbluCWx7nzi8ATKsgmjUsHI4?=
 =?us-ascii?Q?kdxLMbZCihWGWD4B6erv+QL6M7pnK3iDQq6Ld10zjcYpoK1bsvh+jTMtVZvi?=
 =?us-ascii?Q?o76qh2sj274ivch18sMmTdXvChRohWIXNLHQVBRWvWEbUg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cd178f-8bac-407d-a1ed-08d90359e6a4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 17:38:10.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JSUTqe6kIqUIPDJVZCkdqKdSLUNugWIvUP3TLp/Q7cQ6PtfFMX51abq+iG+Vsz+Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 12:09:16AM +0530, Devesh Sharma wrote:

> The host crash I indicated earlier is actually caused by patch 4 and
> not by patch 3 from this series. I spent time to root cause the

This makes a lot more sense.

The ulp_id stuff does need to go away as well though.

> problem and realized that patch-4 is touching quite many areas which
> would require much intrusive testing and validation.
> As I indicated earlier, we are implementing the PCI Aux driver
> interface at a faster pace.

Doing an aux driver doesn't mean you get to keep all these single
implementation function pointers - see the discussion around Intel's
patches.

> The problem of module referencing would be rectified with PCI aux
> change by inheritance.

The first three patches are clearly an improvement, and quite trivial,
so I'm going to take them.

Jason
