Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2356A1CD0
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBXNMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXNMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:12:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::70d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC4110408
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:12:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIDGu/Dda9x3kOY7M+UiL5YWDL9JeBZfDo89JReM6sR4r8XjUckqXZudnVAKQ26PIcQoJgL5dZiHFSr9Fyjn3QFaiH+jXPosmCKzWaiXm/5Tx1ggsOnuLyLFjK4oP4/mIw/mWToLej3Y1lafan/IenCFXmryL8ZWn2zbYBRIti/qyE0OpkGwsfYkm5y697jSTB6fxxGMC3WjoOMaFAw7zwF8LlRqATGlGQwwFBziRxhzDxTOEzKjwOmwjd/6RuR4c17bP8Rq8QJBBM/orbgZesV2TUa/6kc3ooCiUsH4/4o9lNs3tcgxj0gCY2WTnmmpE/KXMTiyKzWX+UgljISaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mj2WfbiORzdS26nQDFkwa+cVtPBBJUa4OPzjcb8vU6A=;
 b=n5Liux+5fqetkGFSuKw4brWYTfMEk3+uyzaF6DbxGklZcaaAR7LMxcvSeiuMIRwIIELFy5fOlOBNvrCYBRRKBhth3sn3u4SGZzCSV5n44phDF5rKMzR/FTJRc68pxkP8ctW6Rpp2pHKy02RIOwj0UhINjHrCjfrGV53e0MXveWH70rBd8hXKHWih/48vuBIl6nV3XYhZhvhg8ODo0VOPburSd5v7TWrjOyLIsHkG44O1/JN7GfcxOdbRlHSrQEN22XMmGaHXljf5FtMN3kmMu6f2a6du1l8sXEaSvXxyoaArcZxYvnwqbtYbEOLNVXUNM/vYwhHz+me0g3ThLWJj4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mj2WfbiORzdS26nQDFkwa+cVtPBBJUa4OPzjcb8vU6A=;
 b=sC0D4O2aoCfNCWY/3zaU/i4JV4bo35XPxDxm/r40Xhikhw1S5vlwshTba42+vodrMMOxHuUGKg0kSmikiHS6HMEq/rxU2TXDWWf8nJtkNpeGE7uuRZfQlJSEt2my9+BG8hs6cyeBusTxy/NDVis3nnDc1ilqtY0ryUTOw/H6PYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4858.namprd13.prod.outlook.com (2603:10b6:510:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 13:12:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 13:12:28 +0000
Date:   Fri, 24 Feb 2023 14:12:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        error27@gmail.com
Subject: Re: [PATCH net] net/sched: act_connmark: handle errno on
 tcf_idr_check_alloc
Message-ID: <Y/i3tbtgeNxc8M06@corigine.com>
References: <20230223141639.13491-1-pctammela@mojatatu.com>
 <Y/h9x8c/XdJeT7e0@corigine.com>
 <CAM0EoMmidx7VfX3UW7ELnDruepCe3O6WZfdNav=jJfDHtC1tEQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMmidx7VfX3UW7ELnDruepCe3O6WZfdNav=jJfDHtC1tEQ@mail.gmail.com>
X-ClientProxiedBy: AM0PR02CA0136.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: d90af094-34db-4ad3-47a4-08db1668c76a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uqnc5OWBbn18Z1qiJKYj4z3wvDjGnDTqS18eTUJlG1SYcGVGcGWJvEJ3z6L8olsfwk6v4+C2bAJfCP2utq8poK62Qx7AyiI3NmZEqyPBaeD4PsI9+CROIF8oiGvNt1Rkd0hkVwHksGXgpqXMeyNXa6Aq8IuKGs5qRys275EGnREc1OUuFoid61S3t4S6AYqDcph5BnBwpv8JSo6DHUffjRnEZ/a4jN1I1ggnDEtO/kJPUkcS8G6JKK+nyva9PzCamd5F3iJW8G4oDK1DSGFvy+4WCKm7ht6Sr40vafbliHDcO0OGy6zNq+Lw2VSovQ5Cb1wmxFSilueA5jbsDZd5UYq973MS1Abd0i/YtVluqBjL2wL7JYPAdfWW84+tpmC08RA/1FR0Xlqy1OsPA/hWqz1saSNKfcb2vgc6YiDilJXtI5AmB8XpnPRtMGsJXpU4Zgld/Xp9zLuLccxk7jg4uqueHV3fNjMBa7a6Xfz9Kmm8c8d1mYt5u26wXwdbFSJwzJqQRhkpz40gjI3wj4zWAR3gYGYfOUlIcnfEb75lgNXxCUJzRWxWqMSGscDDU0JchUJZKUeORwYjoS42en2k89wPfn65/LfzMUUiAXHHCvPObASHVMBnfRBszKzjfEbh1qWb34FJDnExUuy3Z7vhgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(366004)(346002)(396003)(451199018)(83380400001)(38100700002)(5660300002)(86362001)(36756003)(2906002)(8936002)(7416002)(41300700001)(44832011)(2616005)(186003)(53546011)(6512007)(6666004)(6506007)(4326008)(316002)(66476007)(6486002)(66556008)(66946007)(478600001)(6916009)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oac7EE7IRhFq5lcBo2bXFVqXibz/6fdUEc5hjOqIll/wIyI24dHBccJM6sIl?=
 =?us-ascii?Q?xcizVUjl0+PpYws3MV4iswBlUkpCMBWKpDEz6G3IzsxmBxf0xuy8lWBtp65N?=
 =?us-ascii?Q?DPH7zay6nLxnniAGDVQ4cXhw8MpDj37GB2XgZf+2zIwM5BGOWI0vy8gof+Aq?=
 =?us-ascii?Q?bmKAO3anovpM4piOkXZ2+bCDmUaOMTXuAugihd1ABDjYLvb4BVqJFRh1ANpP?=
 =?us-ascii?Q?L1hZpLHDzqE+GO5tchY4IX19YfEejBHrXNJgVRH7BAkOI9k/q6j3gcSJONnu?=
 =?us-ascii?Q?rE9zB0TqxcTNoHN+YNu4BC/Xj3lpjfNB48iXJAKVN4fDZzLEckVPmTZSLDxW?=
 =?us-ascii?Q?1eYSxfLh9Zc8mE4Dv2P8h+EUbwany32vZIENB+W1efpM8nExhR6VOjAiXPwX?=
 =?us-ascii?Q?QzE3ufGUNVlMS/yHh4Er2aXvec7mpesGTel+fGxDsMUKRvHwIN8EDzNcpraU?=
 =?us-ascii?Q?7FyoTP4jVXQuploc4KJrR93gxPjj1iLcMmSY0ekcU5B1HB3Sr5VjqV80apM2?=
 =?us-ascii?Q?vb1/tNtjXU3kKGbnTUc6TL6qwhwrEP/TCzyFsiNMieTlzC7TuWAVxW34cOGp?=
 =?us-ascii?Q?nlZy8RsSQuWeGOmFa11vsB8Gjgdn3ZNJvxo1zusKGNVtUUiF/vJnxl5Yq7Y/?=
 =?us-ascii?Q?6W7iLlAlzGYAFmYmfzLn2U60v7mEE06nf/z5DMuVBgcYWEyRMjlwahMh59rE?=
 =?us-ascii?Q?HF4f4kVUtvkcSNXSuf1VsFCf+xTgMgiTzvYJzoD+z1NisYdyO/gs/IDFmJ3s?=
 =?us-ascii?Q?y0C4bb1rI+vEg0VxfH35w6okjyxs6c3hib9EJHCme254nLnwdmAZrU/CWt0Z?=
 =?us-ascii?Q?liNDLzzkweiG06gzi/o80HzNeLPAIKAv4ZZvSMwNE5DRbYyKz1F9QWJv13TM?=
 =?us-ascii?Q?t3kGRfZ8u7oPK22kCcziykLVJ+cTB0pj0GdSE62Ya6RGd65+kRWwoVo97F5h?=
 =?us-ascii?Q?bCU/+YsHFX9hsinfmtNzdIndvBExLJJ7zdU7CIxAuHSKSNjHq0fsAy7E/JX5?=
 =?us-ascii?Q?P+S2QVDE0QyERkfrEmcjLKsG+3X+Juw0iAHMEHflJgA6HHW1F5fx6LUt/hFc?=
 =?us-ascii?Q?skw7yXuEsPDAQLQBY8Gs0s0EAFBtLYr9mihChjYbvQZOPzmVxcLJmdKlXX+9?=
 =?us-ascii?Q?KcPn9D1PgiUjdBUqazAV9TnurskdYCL1XuFBSgEynAsToeaPUnxLwM/C6r/S?=
 =?us-ascii?Q?bDAlSW8FzE8dux+ijyABXKFGAGUGzzJnU0Dc6qF73QrzlFSGkGWnpZtcTbBG?=
 =?us-ascii?Q?IGGnBobg46Jlq10xTGzzArHAQRUBp8S7SJZaRaLodNsF8j1qBN9tuWd5yAqB?=
 =?us-ascii?Q?lZW+ZuBTF6IlRZ8clpEGozhSKX0OgnO1nx3vpeVGwY+bGPmUSg420BER68RU?=
 =?us-ascii?Q?RpNLNAe4YVwgWjkwweCNJmmFS7CnnRNA/zWeOW5tNMowr+3HD6/nKGbpO/2L?=
 =?us-ascii?Q?i8JXlI3ztLHyrS5kxa5DlU1Xjaai/0uBALmIwhJENdjL0kRTL+7hO0WgymhA?=
 =?us-ascii?Q?pARezvBKLSYNiIFwSNRO99k4ANIzNSt03YIDa7aFXvAjr0qKRGJNbz+yLSBZ?=
 =?us-ascii?Q?/zOsWd9bP4Ek5+3/dQhksztHgmmmWZEKm0yjTMTABaXITYeQpudiHr1ySV1U?=
 =?us-ascii?Q?KcG2QMgsOpWcJkz4yrmfhjGHlgxpnGTEy/o8DOAiDxchNrDiOwsbf2XAqmRn?=
 =?us-ascii?Q?VivPDw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90af094-34db-4ad3-47a4-08db1668c76a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 13:12:28.2972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOUSUQuwEYEVXk00aH5ZAu1PrjBKp02xZG+JqbyVJlB74QUC9aoLx8GZmB2N/Mq3euNU9ebFyj9s3DUpqqcwXZ6tZ8CgJs/4GZ1atKcmlcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4858
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

On Fri, Feb 24, 2023 at 08:04:44AM -0500, Jamal Hadi Salim wrote:
> On Fri, Feb 24, 2023 at 4:05 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> 
> [..]
> 
> > Hi Pedro,
> >
> > I think the issue here isn't so much that there may be incorrect usage of
> > ci - although that can happen - but rather that an error condition - the
> > failure of tcf_idr_check_alloc is ignored.
> >
> > Viewed through this lens I think it becomes clear that the hunk
> > below fixes the problem. While the hunks above are cleanups.
> > A nice cleanup. But still a cleanup.
> >
> 
> I agree with your analysis. The initialization could be left as is and
> the else being an error condition would cover it
> (although it is one less line with Pedro's approach).
> However, on that "else" train of thought - more comment below:
> 
> > I think that as a fix for 'net' a minimal approach is best and thus
> > the patch below.
> >
> > I'd also like to comment that the usual style for kernel code is to handle
> > error cases in conditions - typically immediately after the condition
> > arises. While non-error cases follow, outside of condtions.
> >
> > F.e.
> >
> >         err = do_something(with_something);
> >         if (err) {
> >                 /* handle error */
> >                 ...
> >         }
> >
> >         /* proceed with non-error case here */
> >         ...
> >
> > In the code at hand this is complicate by there being two non-error cases,
> > and it thus being logical to treat them conditionally.
> 
> since 0190c1d452a91 unfortunately given we have the potential of 3
> possible return codes (where's before it was either 0 or 1) and it
> would help to have consistent code in the spirit of if/else if/else -
> gact is probably the best example for this.
> My opinion is we should fix all the action init()s to follow that
> pattern. There are like 3 different patterns and the danger of making
> a mistake with clever manipulation of the return code (as is done for
> example in mpls or vlan) is susceptible to breakage once someone
> submits a patch that is not properly reviewed.

I agree with that line of thought.
