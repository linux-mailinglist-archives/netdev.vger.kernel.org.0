Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284006EB7EF
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 09:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDVHzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 03:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVHzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 03:55:42 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2118.outbound.protection.outlook.com [40.107.96.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028671BDC
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 00:55:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4/xpvMMgCCa+wro4ANAQKnX5k7pkO4fDG5BHAtK/WkOpzLUodwEx21mp0PyEJvWSEODVEp/kd+TmOm60A3PnTqRQkejobpr6pXK9WMzv/IGQcGidMNfEGXzKi4oJXR02nht/7vpRhi/zbA4LYWU07xBPb+r8BShqcSPhC2RwD+cVWLRJ8/IR0GNKgB/utlTWXBAWjohUb/LjZeTIwu00ypZuHhpfoX7Qft31trSrzuLu8fYzShDpXsJnJ9ZQv39WO4+69v4MxtIIYOpJOBzygp5IeDW4HlFzO0lGvQL+DOr0yoJ8el3yRtOSUPXJVgRT0Ab616MKx/zRwDcuYDb4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNSQbPZZKfvQhfSed62P73SL0A+Lobao8wIb+g0eCJk=;
 b=Ufzm7BZuA3sQJ7k0FsBI7zRmOy/lbosIqE9eGWu9HQKFGHYOKku13d13al7YIJfzH52nxFE5At0CkEnMhhLo84jfGeIENcDV/vE3+Y7UdqGojV+PpV7352tIhfbMdVO6RUi/NzrtWckURmGlr3/sM/5vL/zJnXfspQTCjQRZuWD6AYEq2XIe1oZWyw3QLHpB2talyZTGsD4A+nkn2IIqEM3sEbutfH0PJJ8q2FwbF8Uq+dA4TBl2jjbZaQqo+cz6bzc7K/27nQzMKZL2UcF98ciX77LtVMostKbA101gMvM75yg7q8SVtq+3vG7ptorUrlqhYXcTaTwi3FUO0IlN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNSQbPZZKfvQhfSed62P73SL0A+Lobao8wIb+g0eCJk=;
 b=HcaNn6rtDh0Tg2mbIlRYdZfSngsM8e09tsQM4vyWDK2OTFCzv0yDkKNpJ1XPGUBghslqBvmlEZVBsLKnyZB1xer7AczoPADICTnIEV5sP6e1jTZFZ3KlXnm4K25EngBQP3GoB0dOBT4Y1oScfhDzUY20OAE3xmYstd7i0pTjDuo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5228.namprd13.prod.outlook.com (2603:10b6:208:347::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.28; Sat, 22 Apr
 2023 07:55:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Sat, 22 Apr 2023
 07:55:35 +0000
Date:   Sat, 22 Apr 2023 09:55:28 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        willemb@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        Phani Burra <phani.r.burra@intel.com>, decot@google.com,
        davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 14/15] idpf: add ethtool
 callbacks
Message-ID: <ZEOS8L9o+pDK02C/@corigine.com>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-15-pavan.kumar.linga@intel.com>
 <ZDUunmuPmM0E3Rx3@corigine.com>
 <bc8457a8-28d7-3c79-9272-314f8be5cc09@intel.com>
 <2fdd6fe9-9672-8bf7-f8f9-e9906fa25167@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2fdd6fe9-9672-8bf7-f8f9-e9906fa25167@intel.com>
X-ClientProxiedBy: AS4PR10CA0005.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5228:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c1aac9-dd76-4788-d9b3-08db4306f3df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGfFPTaiTV66k/7W95V0cm3IbrhLi4++BggCah/gptcgql8w7pHeqnWPMONK4Y8scZa8d4Im2Cj0U1kGLIMusrntTgSpTytseVnOX87tvuE8DHJSHFEcE0uPHhcPy+Hl5/wVVKj2O+jKZ8/kj/GJ7uUDLH32U+Da/YVIo2ncuHOzHFSbHlmyZxxfMYs3xF1LBPQnVEcG/8SxcrFJPbR0SilBKFo9O/P/9rR/H0KZgaSXM/gYCyH3F3mkOAn+mhiUgD7DUCWjzb4Gzc6AeK9Hi+cBnPm9O8rnk19Q7dLozHrlaTdD84DgBZFPs+ZyQiwFo4rpQR/eY0fqcE+Twa5lUqJxR8lVi3CORAkzz33+73TcU97kNkUmE/7HhEeRe2Q8GqOQc5Y4Pjqjgma5poGCfbuow2LOfHVasBbbsZcydj65KFwsHexljm+iAyxxmYjOItiMpgz3HZYo/yEwj5Eu/GQgcvwIfixzx8zGtTVYCZAiv7Ip0+a96bhkLoTveTWC4HAT++MFFxZFj0q40xjYT4+i2Z/WSXJR9vJxXIJ1QkfgsLL3YYx/EXamoIntpJvX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(366004)(39840400004)(451199021)(66476007)(66556008)(66946007)(44832011)(316002)(6916009)(41300700001)(8936002)(4326008)(8676002)(5660300002)(2906002)(7416002)(6666004)(6486002)(53546011)(6506007)(6512007)(186003)(2616005)(478600001)(54906003)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bE52NVdwc2RvTmdpbTYxMTNLT3BVMU1ZMzlVaVFwaXJzZ3NmYTJxQ05XTFFJ?=
 =?utf-8?B?ZDNvcUFLbmszYjlzNHd6SERyOHRiNG9QRG5PSm1xOHRyelY5aEQwOVFBK0I2?=
 =?utf-8?B?VmNmY1QxVWJtS0NJVFI4RDEwNnVSSzFVdlJsZ3pYaXZQZnFueThuZEdPdnlM?=
 =?utf-8?B?UGlOckVMYlN5RVlYSU56N1Evd3ZTby9TbTZ1VWEwTjJJeWZOYXBZWWhtelRw?=
 =?utf-8?B?TndXSWNYY3hmaTdNTlhCd2JqM0NJTmZLQVF6Y3F1bWNaUnFmeDhnTE9VZWJP?=
 =?utf-8?B?RFUwYkpFYkZ1WjZzbm42Q084RG1hMFV0a0dzVTBwUDJWeWZueUZLWWExc1Fz?=
 =?utf-8?B?TXJhU2pGYndJM200V1ArWmx6R2Q2aFV4T3hlM2M1eXF4aG53a2dEdFMraitL?=
 =?utf-8?B?Z0NGSzV4Mm85NGFyNEFTUUNuakI0d3dWdnpQaFA1d04wNU9jVUNqYUt4WlNF?=
 =?utf-8?B?QzhHU1ZlWDJhc2V4UzVoeTE1bUdSWGVtaEJrNDlIUDFKTTJwTFB4d1RDTFdu?=
 =?utf-8?B?KzBtam1qcW1Od2cycS9aZ0QrUVczWlowRnppWVhiM0llbEZOd1FIa2oyUG9C?=
 =?utf-8?B?a3V3eC9qN2ZhcW8vYU45VlQ3aER4ZkxjellLcmhMVFRYQWtkVzdRV3YrY3dU?=
 =?utf-8?B?SVBWa3QyRVIzVFM3TFNxV1pVQUptTTZ1Ui9HZkNHcngvWW9rQkQ0Z2ZTd3BR?=
 =?utf-8?B?aWVPWXFpeWk0TGhQS01Wd3ZuaVRHSmZua0tjQ1A2S1VvSWJxcmRoZTBMUlpp?=
 =?utf-8?B?Q252K3JjWFJBdjVJdDRpR296S0F4Z1BzMkliTitwOG52Z3Flb2RKQzNKT1k1?=
 =?utf-8?B?d25LZm93blR1OG5tVW1GYjYxaGd3Rm94S2NWR215dlFuU3NPSXhMbUxaTTZU?=
 =?utf-8?B?Zkd3SHB4SXNuSUxrQk1hOWNFdStvOXdJaUpuc3U1WERyWHJLdnBRZjZWV1dU?=
 =?utf-8?B?dXhTQjcwSUdVTVBtN3kxMkQwakJSV3JTNVVqYnZCQ0d2a3ZhdTNRZ2NoaU5i?=
 =?utf-8?B?bGdWVzR5dXY1b2hjd0JvR3VNT09vNE8ySTMyNkkvNjJ5MUtWM1p3OFVlRlRU?=
 =?utf-8?B?QUdVMi9VZTBrMEhzYWZSaVNEMWZnU3RHWVFCdkxCWWF0V0hjNDFwTlFsQlky?=
 =?utf-8?B?L3phUVlqbnpXREZWUkY0NEpJdW1ISDc5ZDJIK1VTZ29pMlFKSjFqR0lZd2Jp?=
 =?utf-8?B?bXdyd2w0UkxxZ2JzelNIZkhzWWF0TnlQTkZBb1ZwWG11QUJQS1Zpa2dIaXMy?=
 =?utf-8?B?Nys0TDZRSWQzdzVtU0NRZG55akdrRGpMK0hCSzNuOHdmL2dGaG9zTXJHa2Uy?=
 =?utf-8?B?cVREZ05JOEtZdHBvWDVGOVp5eUJuODBNVk9wcFhBR0Q0R3o5RGo0WFZvV2lm?=
 =?utf-8?B?ZzBPYnNEeGo0cDhxa2VaRFpkR3lLK1NoWERkRzBzQ0hXa1BCNitXNlVmbEpn?=
 =?utf-8?B?eStqVTZjenNyQmxOaE4wc0dGZThnZFpxVXJseHBEZ2RjRWU4SXBTbUtxN2RE?=
 =?utf-8?B?MkRBQ0xIRzZDaVNqakdUZ1NKWk5yRWdJZGgyWTRxM0tvLzN2SnVBUzAvZmNC?=
 =?utf-8?B?djBEaWtRQWtsTU4yZjJrdldxd2xiVDNHZXRxOXB0TFVNNXVMRmlIc0hmU0h3?=
 =?utf-8?B?RXNkUFo4WVEzMFU1SjJhZ2dYdW5PYlFVNGh0L1ZUY2ZpUUFJR2ZNMUNKMWNu?=
 =?utf-8?B?M3VwTVB4aU5rajdNMURSQk4wdzlmdEtNcUZMNEd2VlBraE1WblFOL3V4bHAw?=
 =?utf-8?B?akowbmpVdkFqTTVpVlZXRG5Zd3Z4Mmh6QU1jWkthb2tpN1B6azVMQUE3ZE9t?=
 =?utf-8?B?QlVrYUNweFFwNytIWEkxMjJlU1ZxWjhER05OYUlCcUZQMDk1bGtPNnUwZzRK?=
 =?utf-8?B?ZTdRcDBjRCsyNUdjNzRhOUFXMXhBTm9aaGZLSEF1QVBpUFRENCsza1Jkd1lX?=
 =?utf-8?B?K0puWmprK2VMWHR1OEoxVFg3enRqVzdHMWR5SnVpN0hUM1YxbFdSdUpNeWNT?=
 =?utf-8?B?UCs5YmJOd2ZYUko5bjl6d1dhN3JOSHNnR2ZWTWZjWkVSK294bEw5ZUdjZWZa?=
 =?utf-8?B?Z29lU3RjY1p5OXFMZXQvSlE3RGJtSytCZlRHNDVrb2NnVmI2dDhjTHd2TXVT?=
 =?utf-8?B?SldUNGJ5SDlySWdFS091NHdrTUdFWWRlWXpJSkFaODU5QUk4bWIwNzRVUFd0?=
 =?utf-8?B?enYvL2dpUDdBYWVCK3pFam1mQi8wSDd5MjRBdWMzbzdPeEJ2akhxTDdDaXhh?=
 =?utf-8?B?c0dpTTQ0R3IzVlFUVFZnYU50b213PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c1aac9-dd76-4788-d9b3-08db4306f3df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 07:55:34.5889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ca9Feq7YUdtrg8XnVlWY7Uew4K93FigyYhob9q6oBtmlUUy0d8V40UcmoS8ylR9EfQjIg5KLz0+4MlFzBi36YIrpkwR34Kk5loNA1JKWZkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5228
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 10:26:25PM -0700, Tantilov, Emil S wrote:
> 
> 
> On 4/13/2023 12:11 PM, Tantilov, Emil S wrote:
> > 
> > 
> > On 4/11/2023 2:55 AM, Simon Horman wrote:
> > > On Mon, Apr 10, 2023 at 06:13:53PM -0700, Pavan Kumar Linga wrote:
> > > > From: Alan Brady <alan.brady@intel.com>
> > > 
> > > ...
> > > 
> > > > diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
> > > > b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
> > > 
> > > ...
> > > 
> > > > +/**
> > > > + * idpf_add_qstat_strings - Copy queue stat strings into ethtool buffer
> > > > + * @p: ethtool supplied buffer
> > > > + * @stats: stat definitions array
> > > > + * @type: stat type
> > > > + * @idx: stat idx
> > > > + *
> > > > + * Format and copy the strings described by the const static
> > > > stats value into
> > > > + * the buffer pointed at by p.
> > > > + *
> > > > + * The parameter @stats is evaluated twice, so parameters with
> > > > side effects
> > > > + * should be avoided. Additionally, stats must be an array such that
> > > > + * ARRAY_SIZE can be called on it.
> > > > + */
> > > > +#define idpf_add_qstat_strings(p, stats, type, idx) \
> > > > +    __idpf_add_qstat_strings(p, stats, ARRAY_SIZE(stats), type, idx)
> > > 
> > > Hi Pavan, Hi Alan,
> > > 
> > > FWIIW, I think __idpf_add_qstat_strings() could be a function.
> > > It would give some type checking. And avoid possible aliasing of inputs.
> > > Basically, I think functions should be used unless there is a reason
> > > not to.
> > > 
> > > ...
> > 
> > Good catch, we'll resolve it in v3.
> 
> The reason a macro is used in this case is that it allows
> __idpf_add_qstat_strings() to get the size of the arrays passed by the
> caller. Is there a way to do this if we convert the macro to a function?

Understood, in that case perhaps a macro is best after all.
