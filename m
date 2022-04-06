Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9727D4F6850
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbiDFR4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbiDFR4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:56:39 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2050.outbound.protection.outlook.com [40.107.212.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0B2DA6F4;
        Wed,  6 Apr 2022 09:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJAxyyexhCNTrYFWLLkSxS0byuNsAS8k7aspK6OcnPWn5TaBbfi4l0OQWYB/GkebVs23SRhCHhcW+jg+6DZ9UaXj+rTFBeDEaGATa16Wj3wOGC+qOJf6odTc4ZLqxusxajMksXjUS3lEM9rrrprqzITfo1F73XiN9CvbTFV/DsLRJ+fUUyaNEXNuKAG9lLyYf5JTMrTT8m1aoHl9sMtIyeVStb+Zqevdv2ITOgvxaEcbqcoMXWW08dlaA0xZOlEMiArHzzRUMAPnFdj63NZmm8ZljZZbG2/9IbnU/cw23Ewb8ZToNb/CxplXhuP1XQqb/SVa3GX5XL1H7vV9AehiAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lW2Fvt3m8ZRbdlVQPM81JmChp/B5x/ej51pU8binjzg=;
 b=TA7BWNYZmC6l+9iV8e16WUvfRk2qoFaVmUxqDNn5DDKsDDHlFjui+vxL1BBEJqPY2l6tBGtYZeZ4CqCo9+RJBNvet80VIL13Fh6gztFwmdXo7IBoGjhvD+UXGSBbvXncRa/fp5QXHx9r44Yedeg1RhN2HFNASRUW2wxtGSomdNjyFm58MR973I/f+cZXhl0/HAEqtp9TcUzlD5ffCTfGKNPOBY+7Vj4GjmKB8bCL1XOXR2igtOlQeczgRuMO9kZkuQp5YIChMeYPb7NGciO5ivlKfma9FkjBaJXoWzioayaN7V6mYDv1CRxhRwzAsVh4aE0oTFL5MM+FBKKtTYZAFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lW2Fvt3m8ZRbdlVQPM81JmChp/B5x/ej51pU8binjzg=;
 b=PuPgwKwkWQY0E2rSmwUJP4+ni4871iSR2DnSPmHFC8Y8acPZ18v25l7fuRlWlbHCiVtn9x4hs9RubBis+PkqFiTMMhi5qNvwl/z8JIpTBKVvrEn5daa1iWr2Ns/8TUZlnAK2UnEzTtfpWGLO6vwcOKgfRv8GG3GKdjrtMTaCew0fIxVuhUacMBYlaBfldKQfYv72hkhTPQMsprmH7tOmo6vf/CI/tICffb5x77WsvGYO2vg3nT9MHmkimXu+AAX9ohHf+EXwCeYFM7k3gsX2E8anQWENCV1BvPBFkCm6zw+/rM5awxebfpvN0ZbLk7D/EsxzfgarmLR9wKmIYCS5Yw==
Received: from CY4PR1201MB0245.namprd12.prod.outlook.com
 (2603:10b6:910:1e::10) by BYAPR12MB2776.namprd12.prod.outlook.com
 (2603:10b6:a03:67::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 16:06:26 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0245.namprd12.prod.outlook.com (2603:10b6:910:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 16:06:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 16:06:24 +0000
Date:   Wed, 6 Apr 2022 13:06:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220406160623.GI2120790@nvidia.com>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
 <20220406142432.GF2120790@nvidia.com>
 <20220406151823.GG2120790@nvidia.com>
 <20220406155056.GA30433@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406155056.GA30433@lst.de>
X-ClientProxiedBy: CH2PR14CA0019.namprd14.prod.outlook.com
 (2603:10b6:610:60::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2f73987-db45-4dd2-3ad1-08da17e76637
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0245:EE_|BYAPR12MB2776:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB024535DF1D90632BD02CDD46C2E79@CY4PR1201MB0245.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnBKJX3nTidpz71XN+8DHN1j4VRWGxEl9GP3obS8S7A5TmGYI6SQS3mKMQcaTLrTq37BW14XiwQYarjKNVuetx/fJxX+MPXfaIxloM+Y4RJHLz7VF/GtqSmhjZtDnISmmkpixGlNidGY7Rl7OXkxOK0Ev6yPbOdS/vuaS6IiVGKrRpASjsoEFTxEP3M1QJdJ0QGqKZ5c3DiXT6Wn77Yg4mgp6/thadd3RMCpH2dcL3KU3ABwQ/coqMuWK5r8a4we181Irnn6N23xgCw19YquQ3rtetXgLjObaM68Ucc5RRiPrMsSi0GLRevPEdRQR3xuK0/KP9bBWFtfnCZaVeJ/32XK7jtc9ifjOaDmgk+Hga30kRuPWEH19QgWphnXfoDu/oDb7+r9eNNnuurx5dYzs/YfBHXnIG6rx+aAH/x9wp9v07vLZf96NpunjHd18H1rMx3CKddzIfBD1Qkjq/75CNW8s0Z7Ace3cEfoY8v+8tqexQkpAYTf/JxohDYHRqKdAjhZu5IjsWZe8jl5d0pnOcNtrzDbBgzOFP5KmLvq1U2aSth7iZL/7zGQ8PCKFBqnfQ6OBYfGpRwFKuMEUa05HZhDLKZsLks10CU0zrvqs+bklA0cEReESRmQ9Ty0GEMqti9FdV+ut7C6tVjK92kHFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0245.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(36756003)(186003)(26005)(2906002)(66476007)(5660300002)(6916009)(38100700002)(316002)(2616005)(4744005)(7416002)(1076003)(8936002)(54906003)(4326008)(6506007)(6512007)(86362001)(508600001)(33656002)(6486002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vQZRX8/fMCYMcwZ1VnH6zPvciYF/AD78AykDXOrbtCRCVqKsb9+1UhpHqdbP?=
 =?us-ascii?Q?GqjTwwl4e9vx/fwot7X8W8+06L2SiPOWyQcjPWX3O9UJDWTcq2jhfMDST9k6?=
 =?us-ascii?Q?ZEjj4bx7ltxRJVkhWye0py2jlcD+/DQbH5BWAjpZou3TK4TJTxZtlmT9cFjw?=
 =?us-ascii?Q?t4SesBR68jpgf3HBTsWigkLCfEqa2ff4vLdnB7KW28jxA5RV6E/zwy2ry7nf?=
 =?us-ascii?Q?D4hhFNAHZLPZqOrWuRwV1N8o45kGiqw3BJxhs6/OBYkbr1LVWPzS+11n/I0M?=
 =?us-ascii?Q?TQeYOJhAmi8mEZq0TFFD5psQ1x3T+L0u3AP+c+qVQKi2TdSQrMJRBq9EbEkQ?=
 =?us-ascii?Q?zzqRY32cDUsJqsBsSZKIVTb/OFEjGQALQLeCIXuEWXHGHaKYAg7UySlQWFwc?=
 =?us-ascii?Q?JzpkLL5rP/cymuUkCfIerDFqm6x9eJWbe3HNu2Hhj6Q6JeOlXpt56Xdgd1jO?=
 =?us-ascii?Q?o6PLXazbAJYe3H0EyXMFChv+0izmqktMl2C36Xwavpd/q2sW1nfJmsseU8gZ?=
 =?us-ascii?Q?Q1cDux/VWUjao2isv12cRP+PdHUu08BWS99liJsulpIjAxAF9aPUWIXeJSjs?=
 =?us-ascii?Q?XKMo11efR5gakOdhMYVvLJPbp6FEMdTHeApLT99rAaVgy9XrbjjlQw8D17fj?=
 =?us-ascii?Q?nUfLWUqAmdZ6GtdqMd5WeZSVpqiiurOp56Id9GfT/cMXCTc1T3xGqQ5pRoMU?=
 =?us-ascii?Q?G0npwVZXlvEoUUNjn3TpYpiOMsa/I70qUV0HiTN0Bv5lu8TkcDy7qmfeMLDl?=
 =?us-ascii?Q?zGnhXKilrDfP5bIapjelE5YoFXZ/8VgJiPtvdxgfP4ksEL2fCjX8L7UlYvUJ?=
 =?us-ascii?Q?lCjRpg1s4ot5JmLicQLbDW0A4lcjZr4XpzxTC0xAPAkLc7yGjUg/sfbW/5mY?=
 =?us-ascii?Q?jP6Fm7w33MZ5DQbmeEJ7efcWp8/u9akB5lqcidWMenRtf0LlgeG+CB9AL/zb?=
 =?us-ascii?Q?+avxdro9ch7grcrWVfb8rSfo+v27apjhhHPSCvBgVElVTffy5+WCrc/p7VoO?=
 =?us-ascii?Q?J+pIwKu0MYgU+uHIoQ5yJVsWG0yRd9m16dRzppeAHm0DYfE6odUAIwpGCyU+?=
 =?us-ascii?Q?AHlDelh19OMQWEWiHEi/1HkEMM9IwUyJUsTZtU5cgMSeTCGBViKR+ctTimN3?=
 =?us-ascii?Q?KEWq4x/GO/QPhCdq6OCSSMuto/X2YUSvd1eiXoydfcdb9iWpW4IE9rsF8a5/?=
 =?us-ascii?Q?1PZdSLpsMSMWbarwQXBSfx/pN5l4GzZYJmmB8xnJbywuTBuh0Ywf4+nGRyte?=
 =?us-ascii?Q?t8JfqUmLhLgcCY+ZxDxFQH8A709evCzh3c2i1iw8j9b5hR00a5YnmB0eerBR?=
 =?us-ascii?Q?pyzt7P2+WN44khec39rNj9/t9MmTqpu4xdYGhgqzrhksaRF5jGD7c92OFArD?=
 =?us-ascii?Q?JzO0SG2rJv8Tj+F8653imrszAimoEoWZMEr/Q56mEQ0icd3vB7yNXtE1DaCA?=
 =?us-ascii?Q?0U96TFOmF1gxSwaDTKbaXXccb6/lV5xZpotKqlzt1NVEqlI+mdVabWTurt+f?=
 =?us-ascii?Q?e+nq0IY6WLc+fgLTCXGOO29fPUKOl6OOTzn9jRRoyHdXrEBSssf2xrHfyhGJ?=
 =?us-ascii?Q?zePvSNjGdPhBJWSP2UF8RoVs8mqDwYZxnYed3nm2FeiWn3Gv0TZWTZXghePh?=
 =?us-ascii?Q?0Ax1PxnWceTHN3MdZJnYMaQiiYXOr3PYYwaEO9OQEBiCD2UwLhKs8unf1eln?=
 =?us-ascii?Q?A6CfZ1qiyWDAJXoYQ13y+MTVeKZIJvbIpATNrurtZCRxgStiGIP/stWLIJt+?=
 =?us-ascii?Q?dJT9yKU0tA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f73987-db45-4dd2-3ad1-08da17e76637
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 16:06:24.8782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glf4c+/tslE7cYARKT1ufKfc21mYRycUd2HG2k8mBh29LPsnfTzG2vLZ/TcV4cV9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2776
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 05:50:56PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 06, 2022 at 12:18:23PM -0300, Jason Gunthorpe wrote:
> > > Oh, I didn't know about device_get_dma_attr()..
> 
> Which is completely broken for any non-OF, non-ACPI plaform.

I saw that, but I spent some time searching and could not find an
iommu driver that would load independently of OF or ACPI. ie no IOMMU
platform drivers are created by board files. Things like Intel/AMD
discover only from ACPI, etc.

So it might be OK in the constrained case of having an iommu_domain
attached to the device being queried?

Jason
