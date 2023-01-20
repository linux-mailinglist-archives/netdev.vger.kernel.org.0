Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F1A675C30
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjATRyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjATRx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:53:58 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9727402F6;
        Fri, 20 Jan 2023 09:53:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKwTwhEOI2/vKWprvfhYxukFWV1hORC3apUFwJDo2g4NIv8TZQR2gqf6s3KkVYoU30eS9qBIwLLblyVbvAV34UqOoaQSs5reamaYvzE350fm/62IWhVgr2GTNpEdwqmPq2Fkwa6vE+JcM2FgrsIvNXjJkXML/wbRFpj/YsBnjasmbQNWKCiiMnUvN1mgdbE2q6JTD1tiBnWQSxkM/55cMvEpebfScKSYJ6lJdxFUxY5+YM1YoZVi+ihjeAOvlTH6FVT16KMNJ9qGg3ZH/GkUDDCeoYQFzLVMKDVcDh5ll6wiMpbC95ZFTvkW4cWZ9Z9Vs/vUENvyC5MU6RXNlXrRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXFt93pMtQTD3Nr5BElncWhLzk/oOeSjayXm6n79zuw=;
 b=i7BF2hVOIQ3YlJNTULTu2B68T5G+R9CjuSqjvagzh4tBs5GmNsLXx51wkll2UYfRWgBeZdCtkIsaiehqzR3ybXVvbF6QTRjydo9VYW0NZ1mUrHNuJ/1U3/UhHTLv3mdTlM0uq64naoHMyaH+sTVBvgXTruaFJ8bL7CPe2m4rF+p9oEn/8q+8UKJZNBSZN9J2tkGk3zpnfuknK/pwmIISXc6rtyLKDvmSg5WNsJec89HOQn5S/bYSr0UT1d3zyFGugJVoEPAgkT9quPW7U4W68Gfycm4QrMGYt+MmTZdMQWm6hqM9o9zjm+Rhbr5EltuClgYAeHuP8VtaK6KbKyVkKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXFt93pMtQTD3Nr5BElncWhLzk/oOeSjayXm6n79zuw=;
 b=DrF3k+K+897Yq50c0abDAZ6YHYeB9xWUTjXZ0pCSws1N29HXJ3TDUxMxQNvFNz0yZNTVu/YOje/Gco99n0OaPgWEu8q221L3VpCSTqzbrsYfCk8iwiHYKoE0CU/dKNE89cHW9mKyy1FNkbVi5iQaA3ZVqLoqbrP6T9a0QIZIW/QhYWh6AIxhw8IJZcD5bvRvc77NqNoP5eTbkUBbk1bYpETUgWFNKPg5T/rPrGDUfTNJjWox3goggBJGPbG8rK8Op1PDykN6zHDEhA6QmZrXnodKunBw5SR+v1Zuk2Wr7G2byH3knDOdQ1hYP+XXZ7KD7eaWwT9Jhsvipo96YZP2+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4076.namprd12.prod.outlook.com (2603:10b6:5:213::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 20 Jan
 2023 17:53:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Fri, 20 Jan 2023
 17:53:41 +0000
Date:   Fri, 20 Jan 2023 13:53:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/8] iommu: Add a gfp parameter to iommu_map()
Message-ID: <Y8rVJGyTKAjXjLwV@nvidia.com>
References: <1-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <4fd1b194-29ef-621d-4059-a8336058f217@arm.com>
 <Y7hZOwerwljDKoQq@nvidia.com>
 <Y8pd50mdNShTyVRX@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8pd50mdNShTyVRX@8bytes.org>
X-ClientProxiedBy: MN2PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:208:23a::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4076:EE_
X-MS-Office365-Filtering-Correlation-Id: e29fdfc1-a93a-4424-19c0-08dafb0f440c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6qU6mqG7QQPIANewSeV3NY/O6fs4qOmTSfk9eK3ubu9AyrR1Anxe0vmSpG10K3DWpbZ9mn+/9wXZJpPWZoiR3md3epyfFdJkMwD1B82Vxq/js99fWzuIYoJr0hqGfRlVJZagOwxyNI8B5ViK6l5TINHNSnIInltEgJF5u0Td0xURxNGpW1euuiQ3iG4Vd7ceq1JbqIqu1ZSCd2E3BJBjCxMulhP140Uk/sqYRtAyRh/r42qK0XuwQlsNUt+b+dshRTT6FbbxsYSvGhtnkCIEyEJLPu3+4D5mNxyJaRTDJS3iTO7qwX4G0GZ9co6/dfeE6XjqxfhOfra918zxu8u6ageYBix5Sl8VpC8GAiOpHNk5wZWKW/qdKPjhxAjNkbayedJLlvQvCtoDj/iAxrXYzu2bQfVL3bl1ZiHruNyOi+doxL6tK5URthNNG1Yl1W5mOqTHCRY/mNQxhTIYoBY1vpva13nNn7zHx9wmQu/ZQpA0ggvaBd2Eh6cDP0EjTifOK83jDHVb/byllW0dqkJud1whWIvZO0Cm+Aj1/3AypijWJuan/nUdJB7EFvXhxmnxkUgKcybKWtThY0SCEcLN5Qx1N4xjVYP7esNJOJNAToXJJgQwW7eaOt+QMqocAyMZL6dyzhbQxscA64t1BBRxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199015)(66476007)(38100700002)(66556008)(5660300002)(478600001)(86362001)(316002)(8936002)(66946007)(4744005)(7416002)(2906002)(4326008)(6916009)(41300700001)(8676002)(26005)(186003)(2616005)(54906003)(6506007)(36756003)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8v1EMXBN73/TrR2ymZ61ASZdsthvduOnp0JZ6UJItEqeJepd8eAVU6K1Jhnt?=
 =?us-ascii?Q?mDjxgkEMVIrj/bjh1Zx1u3DnlsOIM9XXW7xCNzCVWBO2u3D2wUEHzzQg0Su1?=
 =?us-ascii?Q?3zcQmxgFb/nj04eBQbjW060wF60MXYY9vBiZXDehCKAClS+HXaC9vRs/lHES?=
 =?us-ascii?Q?IxKQfymRS/3DeIQmQNfe91HTd6raseBBLXhfKYqZN6cRiu5hq6Vkwep+xCJO?=
 =?us-ascii?Q?r3qquSbMNLcjCtC3oiXaE/WmOM4G1gxafA9NrA+Y0Z/ibN174RqAOi5lMBNH?=
 =?us-ascii?Q?5cXjgxxPwdFA5Jyniahx0ScHEiG6VR+vYQzQC6KSIdvzoAK4cx3U11F6O+oD?=
 =?us-ascii?Q?PpXytuzURAysCVMqDnsEuzxVb5zg722xy1wvxzetAN6mkbGq20uzkzXlxehV?=
 =?us-ascii?Q?oTaTmK2KHHOt8mgFusxeAF68eQt7+9hwgqx34QLSbUBvVTvRsugWslELuOuj?=
 =?us-ascii?Q?1Vf49DLhosezcSprLKncMfDiOB+lliDnuT9qVWlc/Y2/1UIidUxk6HIgjm8x?=
 =?us-ascii?Q?pTn3z4O+5JWfK3wwV5NoJyBUr+2NUWVbGifatEsJF++/mN6hwBesHJyZwmsb?=
 =?us-ascii?Q?5vdZg426Hwx/FgYlWhZv6kzihSqj6JtaKxwHlZkinOBOL9lwrbThQKdkg1XC?=
 =?us-ascii?Q?5zsRIl/FA0StWJ3gJ46tAxlNvcUb4zSVxU5Jt1Pwo9XuzOdJeOavoD5w9q3z?=
 =?us-ascii?Q?aVe36csh7yNtT1j8fB05xnfJHDXPxrPciW7hm7aieWst4InpWdFBkqPdfiGF?=
 =?us-ascii?Q?s/lH/xFfWRIM4GNKBQtkbvhdlHVYDG8Rr6IXrsGhZHDFTchwZKj8m+qKlrW3?=
 =?us-ascii?Q?XduIzE8+DUvWoroATR1hXDj4jcqXRwela2x9fRT0pGMM7ofM2T4CKv1cEI4r?=
 =?us-ascii?Q?tfs9NX1aaIqBhNnUHIq6T5KvXNTQ5ryETOgfGH1NBQlagFFVT3y6rt9oACpS?=
 =?us-ascii?Q?jwOu5HfZc1CxlvU5gqELhJuzU74vo4FQAwNZV59kE0b3BmTAVrkLjqh+Ds0/?=
 =?us-ascii?Q?2RFa8zX7HQaPd+S6tu5tXc/xoP+vn4xmjAaRo4Ki4avXBXGz3oHdzTQCKa2P?=
 =?us-ascii?Q?FnPJ/OCZc9Yw822T2tKpQy7lci+6Sy1ojeBobphKiyLIYI/eKvr5t5TFA97Q?=
 =?us-ascii?Q?kBymkNkxj7KaXpR5YVs/0V75LTJfv2BXQ0EFcc667lVWlz0kx4EvcxyUjKMu?=
 =?us-ascii?Q?vUjniN7MEp02WN5wMPozpgXPajQ6HKnYSvdI2BLsbGTOh5UGfc4q+l6hKbTV?=
 =?us-ascii?Q?l9RmF4ZpepGbEIO0d2dPQjod8n6H/QaWv39uFP+GuUmXiaVxyFuUOPgZzKjS?=
 =?us-ascii?Q?o/bOuYLizTog3+p1x+72B3/+uJFPVzu4eIpRJXDdB8V/RPkxrDTtJgGagv0w?=
 =?us-ascii?Q?OWXbno3cNXWjxDpi3VhDIP+hqbu/Frrx/1T/cyPd4gcm1FZhAyUrt47TQeAs?=
 =?us-ascii?Q?huM7u5pF9aW+fZcW24foaSJGN7v04Y7sAM3R/ccJ6/qzyrHw9gFLTh/Vfsz+?=
 =?us-ascii?Q?tj8rPV9vW2RoSsDRwsvvP4bZvkxmJeqRMsBVjoGqQf5gkUkN3uwrZQ3L4EiF?=
 =?us-ascii?Q?3q+iP4mIYpeIHLdhp1oYXyWlrMgO3yUnR6KcLSVL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e29fdfc1-a93a-4424-19c0-08dafb0f440c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 17:53:41.3258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/ShNRiahaTIoIB6a/UQRktiU0bLbxGlrw3I9KvaFFDMptah/1bC4Sxj+oCgwfl+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4076
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 10:24:55AM +0100, Joerg Roedel wrote:
> On Fri, Jan 06, 2023 at 01:24:11PM -0400, Jason Gunthorpe wrote:
> > I think it is just better to follow kernel convention and have
> > allocation functions include the GFP because it is a clear signal to
> > the user that there is an allocation hidden inside the API. The whole
> > point of gfp is not to have multitudes of every function for every
> > allocation mode.
> 
> Well, having GFP parameters is not a strict kernel convention. There are
> places doing it differently and have sleeping and atomic variants of
> APIs. I have to say I like the latter more. But given that this leads to
> an invasion of API functions here which all do the same under the hood, I
> agree it is better to go with a GFP parameter here.

Ok, I think we are done with this series, I'll stick it in linux-next
for a bit and send you a PR so the trees stay in sync

Thanks,
Jason
