Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE744C0654
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbiBWApD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBWApD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:45:03 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C1D3891;
        Tue, 22 Feb 2022 16:44:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U61u9MObQkU7oKDZtPF52XHdC6Rh+lDncnNvmrfbX2bmyDGCaopZHB4+DLUD+wV/9Byic+tWWrSNcwbQG/gqjNjxdkhtdMLvq2TXtP1YT5sc/mQt4HiUKeqLyyXsN1tSNn/7SpRPieKjOvUwGF4tofBAXGOLKyr+S/uYMnvbFTpHJsBLPrq1ZmBGwpG1HmKLeEQxCwD+y/yS2i3MSWyA7Db/9L6t7sTT9RqwJGCmjjyHMWSAkn1Tp5nqQEtoUmtDgfI6IEy0pnr8mDGtYYRLwkpz4c43kU+Wb3UPluIVxK8I0+DyoppLC0yPW/5V7NPfGbNABvfQZBaSvd31afb8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3wmMKtYzmrPHLtHroTLVhaJ0ncnqNwnGlBKV8r8GBs=;
 b=RYLdTURxx8YN6nMRoRfjMjcbb0ivyAV1DPljEgLLiB4X+7H12mB8UKFIOmIpPOcyObmFvQ8E3p2fJPAG8xkP1G3ZlBzoVIVtFCyAmzQXWZPV1Wvg22+dnzLJu+RkKK/nODXARF6dWds5562XjTJmuXAFHd50juoxisyWAEIlZxBaSfAUoBxo6IYveDfBWbCJdrtoQeVyShW7P5CM5neRB2N+LYHUecqnMT4F1/m+HzTMIHF5Oqa3Kary4k1yra7Xz2c7Tz29Z+wndvKLpx9/yF+tIs0qMkuKrU35ZMLeahz/96XbOm4MB2EuED71UheJ5FX4l1fm1m0gUhEWz7kc8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3wmMKtYzmrPHLtHroTLVhaJ0ncnqNwnGlBKV8r8GBs=;
 b=QI++TPGJGFblE4LviN4oyLyESEuYulgAX5xbJKaUKZSM7iZs9tWKzxnqC+4yPPR8nwDU6psbbZ6tEhYnH+AvwlirJ62BoQ/lMej9kAt4a7FUiLsGmlH6Xq8phjNe+Fwvj5FHZq+xwYikYdOhBxKMSRZQmBSvi4NtyYicdAl/PwBhSQEtk/PoJyK5jGBjCJIIFsMw+X9RTWLejcIuzZfaIXhLYymxeWNSStKIFjEWKerSERhHXGiJVgzXA8tWmIOn2/3Mr0CxBC0erPPM1YWE3Mzjnx8gGJAzl3dQzTesTIvvfJP8JgpEatNx9D4RdLCYFb3t7SGDyuxL5/q4P6YU9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 00:44:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 00:44:34 +0000
Date:   Tue, 22 Feb 2022 20:44:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Message-ID: <20220223004432.GH10061@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-16-yishaih@nvidia.com>
 <BN9PR11MB527683AAB1D4CA76EB16ACF68C379@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220218140618.GO4160@nvidia.com>
 <BN9PR11MB5276C05DBC8C5E79154891B08C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220222155046.GC10061@nvidia.com>
 <BN9PR11MB5276DF4B49F7D57E81675C068C3C9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276DF4B49F7D57E81675C068C3C9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0435.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea974aaf-d844-4bd7-1c34-08d9f665a920
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB525415DC67DC8061385B9744C23C9@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjosczP2GKQ6SbyzTsdzt9dCsmq727vnRsGlvBtiZUAtuV9XhmtWRigHRKxh+fvsfHb65G+a4NlkFUcbggSyazYKiTRvgdPnl+Rcvmcj8CLvr3OBOWIh9vqCHiBW7gxs+rarbxkqIi0nn1/E3vfogVve7zJZV0XNnrBEnF7si3R33Q8j/i3TCS4PbcGooTE0Cbxyc8pbKm6ZxFTpBu+4JSIkrayQaqTwmZ7w3caU6HhV0L/2NY67os9wtJyH4ta7dXatCykwMElJzibCn5LJf83vih3tZV3Vb0qIhA9xRSvO2nuospsnpjcxNVRkuVO+1dCeQ0wDtf0RLQQOCJUah40SkkFoy/XuOfO+2oW8eYDOWfoYxOiDZyGhhFW4tciC/L8szeRuwt73p0wvkk8RlJqsQC6nZzKXD/NH9SSxDdc4Rird4Om7bSn+JJidl197iun39vhvL46uBVoDt87b8fpbSyaIO4qXNzaqSMKHb502tnu+3wtKWsZD5QhnJq8Qwg3i5JBVeJ/KohYNnJ6XDfVGFf2A6of2z+QDJPQIMRgBjGw4sjOdzZMbJa7nQUuDMRdMPfAte99yAtjghfzqkSCD+a0UZEBw23ApGhnOD7CQmNNA8QYMYKKSuTMEfZRPCWD31GfrfKpUBRdTU1LDew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66946007)(4326008)(6512007)(2906002)(8676002)(66556008)(5660300002)(8936002)(26005)(6506007)(2616005)(508600001)(186003)(6486002)(33656002)(86362001)(1076003)(38100700002)(6916009)(54906003)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4WRTTEGHGgHLzf6BaykZfz0ZQUG4VjtibWQ++JiV7waxGV1aFNBhDzAwDFzz?=
 =?us-ascii?Q?/rtREqG9Yb5Q8Gfu97xUpoUhtMT9adnBBPEI233Mp5WWVQJpXZy9NqrKBwdB?=
 =?us-ascii?Q?XeOZMr6qxMNJyuJpOkyn34BCh9DTbeDGp18BRkn5lrKVks3lhS55Z8w80nN1?=
 =?us-ascii?Q?90VOMqEPwceVxv0XEpdaDbg0/7ps1GoLE79Dtqvm4FkDclNTMgBqqTJAgJ3X?=
 =?us-ascii?Q?b9jJj4rG41micBsrIBVtrykOHjHP4TRlNYRfhlV3D7yo6JRNRBiKrERJ5O0f?=
 =?us-ascii?Q?717mw2oBhoLHEJr3L3w9QL+7jeuYEDkhdgjrGlf+j7FM6JsDDWl0mLqh+gsI?=
 =?us-ascii?Q?Sj0IM/oFkZ+g3tV3+wPsK504ez6z5t+bPWVnRB7chK6STMDj3vcMIDaRZaDe?=
 =?us-ascii?Q?ay1BlGq1SWJ/QzegT8fj6+Rs7xB8er4yHHuvHlfCnt3H4Oqx693f92pNDaVg?=
 =?us-ascii?Q?Izt9zaXrvxE2R1P4/I7jnSFlHcrHPfU1zh7wc+3i2PhiYQaSbdmSXFdOExvI?=
 =?us-ascii?Q?Loy9MV0X00cqW74iTDvdy3NyIv53YWhtvqhIb9LiUMeS0mD2+wC8/vWFBnxZ?=
 =?us-ascii?Q?pUrNiVLNC3FGOPGfW+tzzP0tLIu0HFU1ZvGCZ8J3bdGfjMTh0lH8uTnekNVC?=
 =?us-ascii?Q?bG3jjlwHuwmx1+4NFAp/EUfncslR7hyDgNX47AKFurvXQpEX1h3NNm3UUo/H?=
 =?us-ascii?Q?gqZKBfPansEJIkIa/LAdDfq9vqKnrvtn7FF8Fj4mNq6F5Na4C/vbkG3G3oKh?=
 =?us-ascii?Q?Ab1hY0X3512wbc34M99+7rjBVyxm0Bv1/S8wrfVE2INmqbeT93ITKEyL/FFG?=
 =?us-ascii?Q?AWmKfvDeEiqFCTw4kE7TDIBj1ntfSvSyDJY+P92w1YQqMafPjgYZSVpd2h25?=
 =?us-ascii?Q?IVrSAWmupeghBrKGL7cijHIpfyWwQQkiDUBTI0A+Lmmk5oa0d7pmSWcxjO11?=
 =?us-ascii?Q?2UN9qY8vQaDbRyLdXoe4CzEGMeZT4tYdM69NEmJU5ch5Tj2Ky9/YO2CRljnD?=
 =?us-ascii?Q?yIhRTq8qb4ewVFLUQnt37eDej/mnA3SijaMenCsAfJkoFE1fbqgQWzjay70h?=
 =?us-ascii?Q?VaVOGrjRFwb4PYr7mnITusKsASQg5fA01ez6BH7q77wMtAuXiwbiqngs5MFi?=
 =?us-ascii?Q?hdCG2sXVuR2db4+3zldWf87cdx2mJdzMYu6kAnKrFZFY7sC8KHschwJe4ToS?=
 =?us-ascii?Q?yijomCNFwytX/JnMQURHPG19J6ZkEE7PQY/p8QcE2YOtT6xPQqIheZC/NwxA?=
 =?us-ascii?Q?b4CDIMAeySffuyJ4JQSb3/mol7vKS2uApcW4dmkCsvcPN6EnTvSNI3akG+3L?=
 =?us-ascii?Q?tr5koGtlcCQgWmNQvH1U9jluCsHloIRUo+RAzuz2swzXKsgMMgpQGa8DzA/F?=
 =?us-ascii?Q?tOktl0UiWfBHdXaUH/k0gtLpQ3/dyCDbHt/dE4sAigZM7dqQtYKkXgINMpiW?=
 =?us-ascii?Q?HTo7VO61Mnw8gv+hdZEixyYahoCRMGnh1hAzAojj+ySp8g6Dw6Jgwxo0ro4q?=
 =?us-ascii?Q?ZQq1b7ve3lj3JpAmv/8spO5PZWq/KmV/DEMq2D98KyFwDAxahUbqdoiPZS1w?=
 =?us-ascii?Q?2TCIe/xK3ohO6UANTQ8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea974aaf-d844-4bd7-1c34-08d9f665a920
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 00:44:34.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ki4wZK5kQGYn+qDq0+4h1m+kngysBL2mXwpBJGgPtoqDboLk38XxNmxhKymONylG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 12:40:58AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 22, 2022 11:51 PM
> > 
> > On Tue, Feb 22, 2022 at 01:43:13AM +0000, Tian, Kevin wrote:
> > 
> > > > > > + * Drivers should attempt to return estimates so that initial_bytes +
> > > > > > + * dirty_bytes matches the amount of data an immediate transition
> > to
> > > > > > STOP_COPY
> > > > > > + * will require to be streamed.
> > > > >
> > > > > I didn't understand this requirement. In an immediate transition to
> > > > > STOP_COPY I expect the amount of data covers the entire device
> > > > > state, i.e. initial_bytes. dirty_bytes are dynamic and iteratively returned
> > > > > then why we need set some expectation on the sum of
> > > > > initial+round1_dity+round2_dirty+...
> > > >
> > > > "will require to be streamed" means additional data from this point
> > > > forward, not including anything already sent.
> > > >
> > > > It turns into the estimate of how long STOP_COPY will take.
> > >
> > > I still didn't get the 'match' part. Why should the amount of data which
> > > has already been sent match the additional data to be sent in STOP_COPY?
> > 
> > None of it is 'already been sent' the return values are always 'still
> > to be sent'
> > 
> 
> Reread the description:
> 
> + * Drivers should attempt to return estimates so that initial_bytes +
> + * dirty_bytes matches the amount of data an immediate transition to STOP_COPY
> + * will require to be streamed.
> 
> I guess you intended to mean that when EITHER initial_bytes OR
> dirty_bytes is read the returned value should match the amount 
> of data as described above. It is "+" which confused me to think 
> it as a sum of both numbers...

It is the sum

initial_bytes declines as the data is transferred. Once everything is
read out the sum will be 0.

Jason
