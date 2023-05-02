Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D3A6F45C2
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbjEBOFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbjEBOFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:05:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2132.outbound.protection.outlook.com [40.107.93.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2706DA;
        Tue,  2 May 2023 07:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZaJ+a0+FfGbbN7b1KJyV0dLEPxMMvRXyh9Gy7u8Xk+0CULotCm3esQDCkIXdjiuIH18DXrCPL+LN6PkNn4p9cb0G7feXo+FujWX6aUuDmLy+xcNu0TPQPmPzBKil6FvzVS0pUWJqGgH9pEtKs+VLRz0LDpN3eMVvcPbalTCguXcuataaI1JKj/+iedhB3V6h6YzdEhTPMSuVUZQV3AD6hGsT/7dz/nrPxvzE2OQ3uWzLJbCvTCudlRvpeMn4VyEqnYbYK3nkiL77BdIzUgJvb664TnAlUW+bwv993S7qGSsm2cpqlF9wW6nym0yDabdWU6VqbxQJvL8TbMcwo1+nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ak+pmnhtq/JbebBHubddAv+qm2h7eBsaEqL1mB3Flwc=;
 b=OlHHe0EBezVR8uKrxFSL4qx0kI8sxd11mBA4BC5X8sa5YOSPCzkszoHmob+VOX8bVs6RFSx8mvwDBRa98IGDSzwCPjPEqLDEl6gkk2w5HBOYY3ai/Hg+a7uTZN1VHBZylOZuQras5XcF5LMXqNTfHIbMuarLNKZRYjX73+9Mhe6vyZdumKdjN8djQvSJ0dWHjDaDSI3qr3cyjs435fGE8RL/MRsxL4Ol8351Vjdvk6RhAhXyFTnYkmuZQEJ4d40JB4ROCP/6v68YE9xXf6T5Gy6TuVUifGZ/QnII2LmPsNkJpjOrV2eanyN7ar2tmOD3SM0AJpgQyFHvbft70rrtGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ak+pmnhtq/JbebBHubddAv+qm2h7eBsaEqL1mB3Flwc=;
 b=DQlb1fStF64trP1vex2Y4aevs695mVlEBQs7Nc993lRVBuAB5kvOLFaJRcws9eqOUFeM3ZPl5vbZ47aI1+bC6TLdDCu0ar5s7jcSdMeN1dB8bNPl4q1KjNrqXGyyhAI8XI2lCMK+zEvaNhxrTqYceyMS4iz5XNBOUvgs3XyqZgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6301.namprd13.prod.outlook.com (2603:10b6:806:2e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 14:05:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 14:05:42 +0000
Date:   Tue, 2 May 2023 16:05:24 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Message-ID: <ZFEYpNsp/hBEJAGU@corigine.com>
References: <20230426150414.2768070-1-Ilia.Gavrilov@infotecs.ru>
 <ZEwdd7Xj4fQtCXoe@corigine.com>
 <d0a92686-acc4-4fd8-0505-60a8394d05d8@infotecs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a92686-acc4-4fd8-0505-60a8394d05d8@infotecs.ru>
X-ClientProxiedBy: AM0PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:208:14::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6ffb8b-7884-4ce2-ad99-08db4b165128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5a0tOsHZyPYl2X+KrmeTEcwgW4lGOw6cXSMPzM8TokfGWTHurTzqlZwYwOirdX2DhS+w5dy45eSkIpnh+rJuwlYtNpmJ4OF1HcxUlFnowFsR/SBV1C2voN0Ne99jk+daRGurfzoYQieYIsHxDvX4W+r5PA2LqowDfbighrZdp5KZGCEEGgF8i3vQQF9D5E13YAw/pL0wozleTg/8JPIiMf380V099sJQ5AV4WMYjQzwsstfJT97QiG+daqVsG2lIHI+dW+0FlzfHtVQ/AiUi/urs77UqifVjC0YUFQVb3/vhNEYRh0SJmgQs8jou0tVP6UCLIR8MxNGlmB3g7mIGlhEIBRSP0kfsb3XIgvU/nUcg1WPZLP0IYu1AUk2yeFnb1sMCD1georkLClJwHZr5ymzqKq/oPtXEfoECuThpmSq7myXEZNPd5zDZtBHmSSFAI9fNvNEYKRdQmIiJPb5mMBXiKLxSROa+oR+oXloOh22nhhCRqywk2A0n5FitdnO3AoDukk7PoS+Raqp9AQx8VYASBqb7kdjBXlFjln4VhIE/LWxT780rUFxjLaAcCG9r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(136003)(39830400003)(396003)(451199021)(4326008)(6916009)(66476007)(66556008)(66946007)(86362001)(6506007)(6512007)(41300700001)(36756003)(8676002)(8936002)(5660300002)(7416002)(6486002)(6666004)(316002)(2906002)(44832011)(478600001)(54906003)(53546011)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R3WxVsYG63VE6Z3YPK/SUFlro6RiLEZRjf9mWcKaA4lC1XcfvMAQESKiAyC/?=
 =?us-ascii?Q?SSkvzun1t/ooiEwezGpzUmrw9y6HyEJB7pV2aA5wWNsGnLbE7gQXfIN4royL?=
 =?us-ascii?Q?vIx7w0kkbDU6rvtxcbZ2qNWKl8lNv5dBE9cT0ZEUJ62biZzSHSpwDxzVdsYb?=
 =?us-ascii?Q?adFnQ1E0RwrCOSVaYrLNPHc69bu7cTnn18c4bWFdTFVgGrSEhJiERvjnS8uQ?=
 =?us-ascii?Q?kTCRci0HWtUb66sy+7fvDPWoaKyXdbYKX5ruxE0gh6t/Usj0SsJZRUe76PpY?=
 =?us-ascii?Q?UKS23Nn4AzlMGVlvU7NOQc7eTRa1x0OTjo+iMBKysahhiccxSp8kMMckeN2C?=
 =?us-ascii?Q?cPIPeIdkEHiC18Z2yIFYoYo5siN4a2+qcpvzpllzdmUcHdFNp9+xYDUpDXAk?=
 =?us-ascii?Q?qxJBjWG0jnpfBIxwL2brldEtt5y10QXWqcr6CnhD/Lxp3THMgdr3hn3NA/ge?=
 =?us-ascii?Q?pO0kiu6QhALYCqhbnDS6djCldJaTR4ncaU52h996z0ozH700f+7MpRUGnNIt?=
 =?us-ascii?Q?K8VIPgC1QZ4jWGi8kEy8k7Es3XIzxC/k4HruHaCwD7DRgMkgtxtqC8Mqnbkh?=
 =?us-ascii?Q?wBE9CY/6tY9GcWsbAP6RsjHMDTbj5iOP+giLUCg7gR0soZB8Lrxht1Gj2/nT?=
 =?us-ascii?Q?TL+S7cYvCiXIKnNBL28VKlw+uLoxwkP7nJ24VDuMTkLujB2bcTQD48krybCA?=
 =?us-ascii?Q?R/x14EurI2EJBAH5ZDiCGVygIDDrf+OG6SdtLYlDtJ+6tuFeA2KUQFgj0qc/?=
 =?us-ascii?Q?ETJ/fxVz2vfu818yoS2dGlP4d82KJTYSF+h/MTxmMsbOGNlgKnTH0qxllkI2?=
 =?us-ascii?Q?Uz1GxQ5046lPt+3RqEeTUwEZk0FH4sywcwn73YX4Di6vOwKvXBqaY0f9EjMe?=
 =?us-ascii?Q?r+sSCTbORusIgnhZS1N/78iBYcZFI9bAZKKYig4RfYdRNyLFEOvk9lNsIVw9?=
 =?us-ascii?Q?ELxWkcHzXQAihQ1c7XO3H1pi3YpreRnU8fA0bhVfFOKIeY4a4VW53y58WHzp?=
 =?us-ascii?Q?Hna6+Uv7BLm21rfEa+NSD5lp4rkvnUlt2WSRMSGo8XnIjiqSblrwhr8Zj8J4?=
 =?us-ascii?Q?rqgpA1a2jHW0i1q0K/dHp5gQofBzy3ZCHCl1/Oujde+5JBMaLJ5e0enTBb+U?=
 =?us-ascii?Q?28G77s19cu6Lc0oiAS2wKPZNZfdRwhq3yiW3baBl0OjRBXGjQKZnnc0Nvac/?=
 =?us-ascii?Q?z/Gk49/b5xGCAX21o1MnkTAYb8mjgY6s4T+7pSzoOje4MvpyJ6B6teNGlCZt?=
 =?us-ascii?Q?/9cjr8Ilh92ywg3dZ6kN6FDrQ20HFT2P9nGOY18r+Qoufn7fSTVoiS6xKn9E?=
 =?us-ascii?Q?J7PbbgoctiQ1QVOz0XNHeHq7W4qQhEyiNwB/dIit/5zCQ5QB8vxlcmOZPeyi?=
 =?us-ascii?Q?X8+oaKtUtq9K5E6P43f86uKjD4YJsMOxntq51PwBXTKM/eCDogMXddmqqIDI?=
 =?us-ascii?Q?nOV1lGPV+ZHQj59QC+/etf8pC8zp/lxTbTm+XMTi/k05sFFiLcpBhtTdkYes?=
 =?us-ascii?Q?QgzX7ygEYpNL0d2Alj6nhoTQHev40p9Ox962gKslnlMxE7+HXz7MHOOP/zCZ?=
 =?us-ascii?Q?Bpa4PkkOlb5ruqU3aAA5XmNc83qDj+4O/W/U/Lq+bAp08NMEDjdWHh+wwQzC?=
 =?us-ascii?Q?NkGWoSye9TSGZvi8unS3bfaHo5iyTgQTfwMHzY9CwXTVB2dd7gFhEUE+JwJX?=
 =?us-ascii?Q?Ht494g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6ffb8b-7884-4ce2-ad99-08db4b165128
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 14:05:42.8191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pwBn2k6qOrRCc0MUG9u6Akbl8MHRXGs93WUe/sBVtzqe136bIWznaGPIwVcWPbi0XXTgeZSFSYlWHOHBzNtB1us71ulndTPiw/VJubEDzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6301
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 11:43:19AM +0000, Gavrilov Ilia wrote:
> On 4/28/23 22:24, Simon Horman wrote:
> > On Wed, Apr 26, 2023 at 03:04:31PM +0000, Gavrilov Ilia wrote:
> >> ct_sip_parse_numerical_param() returns only 0 or 1 now.
> >> But process_register_request() and process_register_response() imply
> >> checking for a negative value if parsing of a numerical header parameter
> >> failed. Let's fix it.
> >>
> >> Found by InfoTeCS on behalf of Linux Verification Center
> >> (linuxtesting.org) with SVACE.
> >>
> >> Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
> >> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> > 
> > Hi Gavrilov,
> > 
> 
> Hi Simon, thank you for your answer.
> 
> > although it is a slightly unusual convention for kernel code,
> > I believe the intention is that this function returns 0 when
> > it fails (to parse) and 1 on success. So I think that part is fine.
> > 
> > What seems a bit broken is the way that callers use the return value.
> > 
> > 1. The call in process_register_response() looks like this:
> > 
> > 	ret = ct_sip_parse_numerical_param(...)
> > 	if (ret < 0) {
> > 		nf_ct_helper_log(skb, ct, "cannot parse expires");
> > 		return NF_DROP;
> > 	}
> > 
> >      But ret can only be 0 or 1, so the error handling is never inoked,
> >      and a failure to parse is ignored. I guess failure doesn't occur in
> >      practice.
> > 
> >      I suspect this should be:
> > 
> > 	ret = ct_sip_parse_numerical_param(...)
> > 	if (!ret) {
> > 		nf_ct_helper_log(skb, ct, "cannot parse expires");
> > 		return NF_DROP;
> > 	}
> > 
> 
> ct_sip_parse_numerical_param() returns 0 in to cases 1) when the 
> parameter 'expires=' isn't found in the header or 2) it's incorrectly set.
> In the first case, the return value should be ignored, since this is a 
> normal situation
> In the second case, it's better to write to the log and return NF_DROP, 
> or ignore it too, then checking the return value can be removed as 
> unnecessary.

Sorry, I think I misunderstood the intention of your patch earlier.

Do I (now) understand correctly that you are proposing a tristate?

a) return 1 if value is found; *val is set
b) return 0 if value is not found; *val is unchanged
c) return -1 on error; *val is undefined
