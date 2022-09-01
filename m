Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2DF5AA38D
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 01:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiIAXP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 19:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiIAXPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 19:15:20 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744947C75F;
        Thu,  1 Sep 2022 16:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEE9V/5YpN1AiCO4NbdrBNE+BBjrB1LDb8qpYOKvMOodcMB2ZqTnKDkqHWNlCcij2zbZ2x9Ge/9y/LIxcdzEq4cLUUDGuhOD42DiV8Awth06RfrSON/iMhdPWP2ewKhM+FyJO7xCfU1e1FLKJW7/7fBTeX629yMCgOFVKIwQ9uU7kaTxGXBl3JKBjqBo+3uZaeqFUVoC5X3Mg3IWa5WFKwdjR3IyPdm4hwUCJEM1/tlMTPM6ezYu74xwm+Eh0UkHVQrEtKpJKSOvYg0NKAVRp2JoXZDOi+cDaWgSdn62dw4nALbEoydeAjh7LZ8NvWB8D+MF/iqY2MPHcdEktgBVJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q25lQcWHu1RaIOb+JPky+mHe87i/cd/EMXVH5l/mhy4=;
 b=E7i2IzG8Tg9UhlsT0rf6kAcVD6pgGR1D0uDRIcLq7L2FmqBnI4BpekTFVPfLjkUfH5HhsgDNodz/LfJ0CgEkmLGeign/qeRVN0ApJqxxTrJt6mt//2tugGWa9szWG7E7D6ctvYHkphyWZChy3ED40q/UGSc9KJdzJhOfMqkFm8pejT3Jhj7cSZx2MIjrZnF0NTTXLtl49ra++cuwKZmWbgaWVDzJNk3BVY1q51qGoHhnbdVLzvUxL0kUvDiVrgfYIUHoQQ0L79S0CpTh58rfxzmNTfUo1Mvw0Ry0G7XTDSjcqKehK0khhYMIPg1Q+Jmn4n5ozR+RT3zbDB09lM+jSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q25lQcWHu1RaIOb+JPky+mHe87i/cd/EMXVH5l/mhy4=;
 b=aSZ3cJccZhfYp4N7llUx1fhKq8wh/L4oDZErWmJdozCSrJYvsMUE/8kJLNiMHOsWjCUyiJ96DYw2H9HkeLqhqCuGhaWUhRn9E/8k1p1AOEi7+4Lo7uCgiztyhkTBBEwIUNAoC0wnK8SNP62Ldm4Ae0W2H6lfHDtotaim4zBvhh4X+HLiUqu2L0JlVlQwnp5gPu2j0Ax4kXQwhChUwJGX5E4IKpOvMcVX48VBJbvZB77FwJ5DPZeSWEyvJQDWrmI6iE8EDExd129f7xrxGiEYo/fietExBYWNusKaGI3d+wDkKKTwZGUuv7t1dP/5ATUnIq30M6Zn22EwVpryDIc10g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB7081.namprd12.prod.outlook.com (2603:10b6:a03:4ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 1 Sep
 2022 23:15:15 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 23:15:14 +0000
Date:   Thu, 1 Sep 2022 20:15:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     joao.m.martins@oracle.com
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, leonro@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <YxE9Aco0Wz2vBYfF@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
 <20220901093853.60194-5-yishaih@nvidia.com>
 <20220901124742.35648bd5.alex.williamson@redhat.com>
 <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
X-ClientProxiedBy: BL1PR13CA0399.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02673c1a-101e-44a6-4c6e-08da8c6fd39a
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7081:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MZqh03HOcpDKDHH+fZNt5xmSFH+AY/Hrd4qm7FQ9sakOn43E8SiKy7x62eV58HHB7BPZYcHL0e41vMVVyhz6MMWVVvHgMLVUIeceYOLuMeaLDlTbFkSXATzweX+qzMaMWWapAiwuazPVtRnakWwl73MpRioPg5pJgykB2Yx02VbihWrTjn6EbmkTeNoDS8V7OH4c9GJF0cr68pFVDUOPttnFyMa1y7li608BoYkHOyq6SxFf0AFX6Ok763rG4Gpxj6UFJEHFU55ojYkO/wAYPgqqj7LTQn4rcDYrtNpJ/tF+uwh0D3zl/4iZeXY/8VNvTRxmqs9kDaGNa95gWsqRzP35/1visb3FJ/6FkR7tZkfcrJytMcAZFlZm/0l/MpZcuybBMCZeZhyBp5lwAQ5hv9qp85ejxur4b4orOP0t6aCdmAmZ6qQU+SCl7SeGNZv1bV1dd1zzTPKeHPZfCAQhXoBgPKx1X2UYpZzA5fU5arTpQsPbZLiAPrRH/BeSS+2/3jX1+IRoUaDc3wkwdd4VjDtXt/FAoR+kAYCTlApVhF+lQYwAoYVS8FyhrRNxf36HtpkrfFuY7oUkl7W79cbEIVI8CmhhDSCF1bLtxkVlBszX5gX5XmnUTxY7UVvQtR5BUrloOTtDFRyp5xID3fKfMKJ1cD8BrptrFEs1q5AKMZOaL/+ozUAUgF3YWLQvnBVNOPBcVNnHmiexkDp1xEdDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(86362001)(36756003)(6506007)(2616005)(186003)(41300700001)(26005)(6512007)(54906003)(6916009)(66476007)(316002)(4326008)(8676002)(66556008)(478600001)(66946007)(6486002)(5660300002)(2906002)(4744005)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wQOjOf1JYO/n0dYiT1EdgrHpoBBjztgC9grgfuRjfECepCr9ee6Fc5mzSFJD?=
 =?us-ascii?Q?gIzMyp7bXmxEgp01QAww+7xxswBKT9f48Z424hYacbPKrFCgMfsPSf2XnI3H?=
 =?us-ascii?Q?x5lNwt2T36fybT92ILpN/lcEsszzPiopFA27QXKpYqpqobCvCzUSrFMd6mbr?=
 =?us-ascii?Q?LkgY/QGAFUYbL+TLFNNAHl/5K6NNaS3VnZZkycvvfzs3Apz+htjlQaKJT9mg?=
 =?us-ascii?Q?n/5Xogph/xCVRwTyrEqtawAfXA/0vtpzMPKpZSkurep8oEANrThhZC+q09D+?=
 =?us-ascii?Q?DGo+8bjZY5i3/XUzbC8uFh/h4pnZbXaihMkJAJu1eRmS0mPT+7cUjoebh0Ua?=
 =?us-ascii?Q?ir8NwHJc9U2c4Ot0ZQOvhyMaX45g4qXPfMHjL+LAwO2spFKIpblIwUrSQb//?=
 =?us-ascii?Q?SB4FQteuMm9Rapc7l8L5J0Ao0q8FK4r6rrYNc7TSNNMQYKUy9NcAuUHvpczX?=
 =?us-ascii?Q?udVZOuK/Qse/af9oOd5I2JMWzaqXWwG2BCJ+Z7XbnRF7Tk3Qou5uj+Ie3aPR?=
 =?us-ascii?Q?Jmjalr19+sh/xXhNlVCwSLYLXZtilgOZOwEhtaWXfPXzcW9PEwnyHr34yi7L?=
 =?us-ascii?Q?yWjQYpv1q4u9NjmDLpaam+Gm+vnBAVl+dYrnYe0Y1APyrM6EKzlHaTDq6ASs?=
 =?us-ascii?Q?qMxUlm0ovYbwfv9mxUXymtl8u/V1R/ephme0y4zK5NnlyQ9HhqprDhk4qn66?=
 =?us-ascii?Q?Vxe4i0ePpw4GCxJe5ZTBHq6cLNMqBSkA0tma7t8nBqJCPqjire1ZSG7Y09U2?=
 =?us-ascii?Q?A/Y7eEeCEqtPpaTHxUDpRZLuo0iA+uFPewFL8BVYNp2qOV5tI9G8L9Rnh/mC?=
 =?us-ascii?Q?LJ5j+YALnh71WL+anp3bbVp2NDyY8hZVYNwyNGgBpfOqstOePENYRTMet31N?=
 =?us-ascii?Q?MNIkYIYkitiemd1GMaW4XEnrsy2w1dJZJXtve6jW9vh7hKUqgRSAennNVr+w?=
 =?us-ascii?Q?zT7BammcvgdX59YFz2qLcOCaoKUTRe6N/cy+nyjUmeGRRU8QU8+KPK2eBjQP?=
 =?us-ascii?Q?SyPoTaqECvTR4u/QcmJEoVUWXPjyJj/6csvPdAShBDQlKMu4DypNOrLBm1Qt?=
 =?us-ascii?Q?GM6XJkGsQYW70Pu/CXoZ4icrddCoPk/t+kG3zJEbx3Z0NOPWfzpFwaHnGtTp?=
 =?us-ascii?Q?bUcV8dGNl1aZLUaj7p2TqD3xoPxVPau/7bum0tBm4H7XBpqjtUYBg8cUsfc4?=
 =?us-ascii?Q?YEYiU4/UcmeNHTxuNvPttQ3jKmVrMjSvFRvZBmkvEvAtLqe3/Nx/2q7GbbJ1?=
 =?us-ascii?Q?8Nsy9muJhEwUjiqR2Ks9V+GjvtEgA3Ue+QWBtk14+YXc0LORPlxtIEEZb25J?=
 =?us-ascii?Q?uvVgZaiql5RV/l+DZZpin7BFDHVW71uWcyTkvk3sdrPnMtANmqlwdVnAMABu?=
 =?us-ascii?Q?eUx6URt295bjXdLDJ7n6rZsI9gt+fMFquDTztiFiLSGNa8TQ4rX2fJGrAQc5?=
 =?us-ascii?Q?KwqoLpeYEOSs8rPKqCro7lb97JobfZqjOc4ixCeIRpSW7glm3jHoeIrL27WS?=
 =?us-ascii?Q?EFXb11YMd+XEUbaLKUnCd0QVMLCzvoliGHDwJ2M5F/qzPm2W4UPYY0Cbh/I8?=
 =?us-ascii?Q?RJ4HL7AARbISpl8mVXH33HRq2yfibWIfJ3JsNIdG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02673c1a-101e-44a6-4c6e-08da8c6fd39a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 23:15:14.7271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYgp2B0/vaQWo9hcTCi/lGayxlyJva9hBZwWv/C9bSawOBZQwB8CXqeiM97A7yUN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7081
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 08:39:40PM +0100, joao.m.martins@oracle.com wrote:

> > There's no sanity testing here that the caller provided an iova within
> > the mapped ranged.  Thanks,
> > 
> 
> Much of the bitmap helpers don't check that the offset is within the range
> of the passed ulong array. So I followed the same thinking and the
> caller is /provided/ with the range that the IOVA bitmap covers. The intention
> was minimizing the number of operations given that this function sits on the
> hot path. I can add this extra check.

I wouldn't add sanity testing on these hot paths..

Jason
