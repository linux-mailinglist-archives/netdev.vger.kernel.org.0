Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D386D6919
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbjDDQmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjDDQmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:42:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C11E113
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 09:42:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8kw9uswfylt4cit49dBhWhD0c1gv0Xky+FPDy7mv3B34zBurnCC7lgAnTe6auM2FU6bOnd2/1W11vOoCCtKWvfIuIaWIn3b/Cljln54mrAVA2RMeEpdrhZiOxiYoHQHT8RtSZcsSa5rtp8jacAyIW/zi+Ax/ZJHCRRMHPoIZgI1oX1xNhx7dvgSboQvoE+z2r87i+Bmf2uwHftmIjG1+fFBVkGeP3T5uc6RM0+citcpaqNLwlK6fv8LN2v/hZGcsZciq/e00/SSQWX69khZDhNXjoegOV9es6JnlmYgwesjMcKrc6lT/AC+DC8lbus58mC42fF+hU47o/fGIbnzKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4a/u1k8IKiFFUOfsqtfdiW6qP+959NySs9I7NPGnfo=;
 b=MGLJr++ZX+bXzQAJRYYAQhZDAM3R+A4yqhh8+jQUVJnGieP8E4+AgxMKd4h5MubMluaz9FtyhKJKg/rwdAxK/yiXf79mV9zY3BZ2q3dtzxj9dVynpjqIiV8TMgz82Ap0gsZPXe9WnvqpIRWEl65zkI8bW5oBv8ekVDtJNtMWyqkXC7QXfELRXBa5DSV+wpINw0WvMdnzGvcmizOAt2LN7IEh4ez4OLd3YuR6vauLhs0mFnq4Y6/WGEl2CHDT3aJyQMHiqC2ALuC1OSUYcquLyVrP4OfMPL0lrMgQLTfCcVoO0UTs7VmBBXT5J4Aewl4JFZO7s+zOF63Ym1x5KL5YyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4a/u1k8IKiFFUOfsqtfdiW6qP+959NySs9I7NPGnfo=;
 b=d7DwBvqkPpugVCSPoqcciMnu3OlJ/psxotHhPJ/JrK/yK/9vosQ1dWs+B2cCEcYGkY5CxknCyaqdzfxIpGHUMMfsuZIktJox1GWE2BbOp8h1ffP2nry7yqci/4skpycthfYVOhFly/tZbnL38o/mo26FgCxjRyS+WwGrsXwgRCSEBQD0LW0IJaMu0Bzz0MHcuXLgzSofFDIZgTUZT6O9BvwZ/R56UYqCwHMon7RR0h/IkOS5BazCfDx20ZrcQUKd902PB88u57smeHTHPRy56MOIOgXFHAjoKxREpAzA38bJD8ZTnIhxRuDCaPErSszJnP4zW26/vhRjKKI1tydIXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 16:42:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 16:42:14 +0000
Date:   Tue, 4 Apr 2023 13:42:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        Christoph Hellwig <hch@lst.de>, michael.orr@intel.com,
        anjali.singhai@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Message-ID: <ZCxTZQJ59boMFJNZ@nvidia.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <ZCV6fZfuX5O8sRtA@nvidia.com>
 <20230330102505.6d3b88da@kernel.org>
 <ZCXVE9CuaMbY+Cdl@nvidia.com>
 <5d0439a6-8339-5bbd-c782-123a1aad71ed@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d0439a6-8339-5bbd-c782-123a1aad71ed@intel.com>
X-ClientProxiedBy: BLAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:32b::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5732:EE_
X-MS-Office365-Filtering-Correlation-Id: 79d31c65-024d-47f0-46f4-08db352b8b95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZmG+1q3EgcBJ/jZmOeKNe6Yd/+wuSdYO0D/bpRYJECHK8eqIRI+cZzAIjgS0OCLqsXBy9tRFsci1LMpafTkzMsG8EdC5Gj9HPZb77nOUfkLiH1pF5r5NXnI8xbFSJaoW6fIa8hibpLMgYjfdK/p7DRRGweN/7IP5NhEXmerR/xjePlurkRJPJ/PVpBBqc4xF3Ug8RO9SV+BG8+Bo9jRrORsjE5eitJus/GgDhRbtZ0x5ub4b2QEzQIEcaPFFr2jud1ISu4l47m6Hsviq0/zLaNbiv22h8kt4wUDBdbDyteit3KbXjBVb7PXIAlz7i+2vy6Q21DOXtIPG1ko/hJQwkfmHvyCS2sILiLKNmIcZ+vWTqkFvI8by9gn7C552Zi2J1jpgUnjbwpKpOUaMqK8Gx7xKwqe7g63UTKUsHnfQSz4Pj0xZqQrXzsEMFfhZeof6i57u8eFLtLWD8QrQd0orK4km/h+Jg0UnbR2pE3rMoKGFYRrXYLQWGsIGcLVf0euDhEwcdVCvpr4Ur6gwkxtYrsx/+fnZfd7tl7gj3wiYw4u3gJyvQQ6/nMdi9ikylKYI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199021)(6512007)(26005)(6506007)(186003)(86362001)(478600001)(54906003)(316002)(6486002)(5660300002)(36756003)(8936002)(7416002)(2906002)(66556008)(66946007)(4326008)(66476007)(8676002)(6916009)(38100700002)(41300700001)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajZQSENqTlVaN0JtMkZtKzVUWDZmQURyTnZVQy85ODhBQUxENEI1U2s4blRT?=
 =?utf-8?B?alRYaTAvYUhZOGo3KzNIQ0xIZllCTnBpSElQL2NDblBnMkVxNzBvK1l5YlAr?=
 =?utf-8?B?R2s0U2pMcGNTS2xhcFF0R1NXK2pSRXNaak1VMkg0aE9neTBjVGllYVJ1aE5Q?=
 =?utf-8?B?VXFIMjZBRXhGUkZzVStYWUJDVnFtZ24xR2VPM3poNVNrMmE3aGJJbzlTOURu?=
 =?utf-8?B?LzhBYm91NHkrdjFodmNyblJmOXRINmRZcGpZRkpiL3pkSmRxL2ZzRzhsMHRx?=
 =?utf-8?B?Ny9GaU1rTWQxWGx5aTQwdXNHaXEzcUZ0dlVEaW9EeHpZZXpBUDdxK0R1OXZt?=
 =?utf-8?B?SkQ5VUNnVXNLK096U0ZXdklsam1mYUcxeDVhVjhUMG5nai81SkRDbnVlZTFF?=
 =?utf-8?B?SmNISGp5S2FPTzNGci9Ud0JDL1R5RGw4Wk5SREZnRE5TZ3FuSnpVRGt3aisz?=
 =?utf-8?B?V2t0SWI5YzJJYVdWVGxlK3VLYkdZQTg0UnpvcWxsUzRCWHUyUDZVdnB0TmR6?=
 =?utf-8?B?SEdGNm9yRUNNaGl0V25PZjR2S2NKSFp3SkxpT0RwdXlkRm9Uc0hrTldSUUlo?=
 =?utf-8?B?UjdBa3BLRVZLbXJaa2lDSEVPNWNHV1Fpc1MzZVVzdXRKeEVCYTN3QWZlaHhH?=
 =?utf-8?B?cW5qZVcrODFhSGdKYmJxRFVVTUlDaW5QT0xxa3FMQUloUnoxZ0xNQ0VSd3d1?=
 =?utf-8?B?YmNPb2g2L0J2Vm5acHFwcTkrZ3ZpczFpaFRWUjBCZzNFcVRSTlZRdVErc0Za?=
 =?utf-8?B?d29KbzJQbmRPTktremZPMnpudStIQU5TNXNXakxKVXkwOE11aUsyRVZuUENr?=
 =?utf-8?B?M1M0YmEwVG9LcHRXdkhRVGl1OFgwcHo0clhpNFZIVldvcFhMUThKZjBPVHpX?=
 =?utf-8?B?bnFGd1lCbGt3TWtQbGVUeWZOaW5COFRVTGhaZVd5RVZlaHBBejBwV3ZNRTEx?=
 =?utf-8?B?Rys4RFhYdTBGd2t0UWxMMTdRMVA2SVN4cEh1bHVscE9kVUZDMTY2aXdBUGVu?=
 =?utf-8?B?dDZxWVNLNTdVUmhUdXJpNHp3eXc1a2t2cklFWE1ndDJWVnZwcERmZmpramU4?=
 =?utf-8?B?ZzlBMWZKUjhsM3NnUVBwak5ueHZseXA1TmFTdzEwK0wvYitBa0JHTWs3SG5u?=
 =?utf-8?B?QTVsdUVXbGlLQWtWU0x5TjA5WkpwYzVCZVdEcFQxOWxZTjBqOWZHNFlPdWg1?=
 =?utf-8?B?VGxOOXhoUkVkR0xYRUh5cm84QTFHbkQ3ZlFpVXI5V2dSekh0SUt6c3o4ZURj?=
 =?utf-8?B?UUFjbzhtRFg3eUxrMUQ3eWZybnYwOElnMzZ0eFJocDk3UzJGaEpZSVQzSEk3?=
 =?utf-8?B?TWFaQjBvbVhnc2JwR1RFNTh5d3NJNnlSWFhwSlZadEQ0SnV3dzM4b2RMK3F0?=
 =?utf-8?B?UmRscCtuS1NUcEsyU2s0NzNDMXI5bWlUZ1NIN2ZmNnE4bm1VY3ZnbkExRFdZ?=
 =?utf-8?B?ckhLSTREWkc4NDd4Nkc4amlwNklvOXIyT0g2ZXEycy83ejdnZkhCdzlYNzhM?=
 =?utf-8?B?STRHRHc1R3lBWmxGc1NnMmlHbWRFRm9Ec3NENWFnb3dJZXhRTnpGNG9OUENn?=
 =?utf-8?B?SnMvcVRaTUVCdlV2OVl6S3E5VDlGM0lBWEpUYnoxd1UyS3Bqd0lscStiejZs?=
 =?utf-8?B?REh1MXgwYTZiNENsbGErdnZuTkM1dEVXWWJKdWtpKzBJVklvMUk3Vmk0dnNl?=
 =?utf-8?B?QjZLL0VKYkNQbFJLSnRRRmVNMjBlM3lFZXNYK3c5akpnV3VmYXRZWkEvSy9Q?=
 =?utf-8?B?VnJ6TVBhdTM0TkdweWRpaWdNd25CcTFaWmVaVHkyU3Yzc2dlbnRFakFnY011?=
 =?utf-8?B?YTV6N29xUWE4VEJXZk1obFhuRmxiR3hCOTFVRzBaRjR1ZWF0RktHd2lWTlJx?=
 =?utf-8?B?L0ZubjZtSzIyVHU4S1V0UjFCYS9FbnhlYk93SHRLRHlodGNkdEN4cXZ4N0VE?=
 =?utf-8?B?a0U5Nm8rdTlBSk1sUlN2cU5kZlYrcEpIZmdRUFdlaVE4aTg1OVc3RU5nN1JV?=
 =?utf-8?B?Q2RsOTdGbWIxVTJiVXZaaVhZTG5VWTVTT1JEMXFheGhWQmF0ZmxwZlMzREJl?=
 =?utf-8?B?bHRFVVgvU3JLZmQ5Sjl1bTFEWmNmNC81S1B2NWIvbkQxb01sR2xzbEtoRzk1?=
 =?utf-8?Q?jMDdjg/gUBb96OP23JsZGP2/5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d31c65-024d-47f0-46f4-08db352b8b95
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 16:42:14.5969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFNiZoi6EtupUM2W0Ifaz5iKVnFTjDShVfOnjVA0o/M5+YYe2excRaxAI641Qo3c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5732
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 04:36:56PM -0500, Samudrala, Sridhar wrote:

> > Further OASIS has a legal IPR policy that basically means Intel needs
> > to publicly justify that their Signed-off-by is consisent with the
> > kernel rules of the DCO. ie that they have a legal right to submit
> > this IP to the kernel.
> 
> OASIS does NOT have such a legal IPR policy. The only IPR policy that
> applies to the IDPF TC members is the “Non-assert” IPR policy as stated
> in the Charter.

Non-assert is relevant to inclusion in Linux and is part of what the
DCO considers. According to the OASIS IPR non-assert doesn't
automatically trigger just because information has been shared within
a TC.

As the submitter you need to explain that all IP and license issues
are accounted for because *in general* taking work-in-progress out of
a industry workgroup with an IPR is a problematic thing to include in
Linux.

eg you can say that the 0.9 document this series linked to has
properly reached "OASIS Standards Draft Deliverable" and is thus
covered by the IPR, or you can explain that all Intel has confirmed
outside OASIS that all parties that contribued to the document clear
the IP release, or perhaps even that Intel is the only IP owner.

This abnormal thing just needs to be explained, maintainer's can't be
left to guess if IP issues are correct.

Jason
