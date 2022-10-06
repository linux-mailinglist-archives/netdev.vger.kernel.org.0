Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2AC5F6744
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJFNGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJFNGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:06:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0C6A3443
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 06:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665061602; x=1696597602;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tepq4sBnxvGu/21Na/l7Zf1kLdHBXl4E/PxDZd20rB8=;
  b=hiSQsLWM+Qr/Y4+NgEYecNubPx7MDLtc9Mfzf1t0AYFyZzQk4MVpsKJR
   Scx8JnpWCARAQioruK1dp/w3olF28fIz0zuFwmtq/j8VqB9+Hsok28nJg
   tuloTY/qDlcAEIVBgmND+swHP8AvuIV1IzeuZcjcCXEY898XsOs4xpyeT
   y3krC+zipuCJpews3zblIhMCuyN7oV+CFzFdvME+Zkv8lX1SVtcvDuIHS
   lDWNL9yJYfa/V2ETtkoHVWZEuVQwoDSYwjjxujOtt/cEAgrWx2PLk1evZ
   F8dBfAK938WQOX+AZrY0n2tJLz3suCaNquQDn1wumAUd4/MZGSz53O3wi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="329863428"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="329863428"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 06:06:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="619841100"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="619841100"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 06 Oct 2022 06:06:38 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 06:06:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 6 Oct 2022 06:06:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 6 Oct 2022 06:06:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNdz0IS46o42RhipNNUeWIna7C7Kq0Pi3/eofaV2XImwxhTDrI0vfrvnoyLdnof1Uv93Wr+ouQ977R7V1RE2s9u/M8LlH8DNIzkfIv5v4OWOYFJMvjUD5J0C1mg+EQ1OmtOGE2UMIiKaURCYN38ZY/5Yy2gLVnFG6wAzFbhEwpKrmcxMSb+tZkYvTumN2SRLmT6WRiS9ibTA7AI3RdiV4p1H6xADOtE3s1j+raIOZkT+g6PW0KUMeTeb3XeUs2Qjd+Hdjou8kZrryt3Rf+hPZTj3We0PY9KByh9sCewgHrLR0TzGepwnRGHTqf4LUYznW4rieQ3WrkLPsgNnZXsrbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIXVQI8WAddHahUYfFFYsPJP7niaS80MqBbNyURlBtI=;
 b=La7iINgwoP+Ov/3B9MOnOZ/N0liKVuXtYPWp+8/h1akSNLLzel5NWlCoy4iX0YDVVWhjEDhl+7dAXTEjv/gr6zly2pgog0fD55jrDZ6j9i7D8fx2KLavvPNO1adSqVd2kJVWbMVbcNKrQ++3L1XHIHXSVki9dBrIEOfkAHgh6FsDyoKselUQA/j/K2S9Jm0roBA0esFsrjNwVfo1kJxRhhAIfHHRzeTRtruHvI3/0CkQiPLBvApszLLhhqiqrJoC6mJzvM310GpXNysiM44aXOj+CdA+J5OcrZ1OHQ+7TsSh99kfg0Z7Z/MTTBH5o66T+EfqndMwMvCov7inYpwItw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5673.namprd11.prod.outlook.com (2603:10b6:510:d6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Thu, 6 Oct 2022 13:06:36 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923%4]) with mapi id 15.20.5676.028; Thu, 6 Oct 2022
 13:06:36 +0000
Date:   Thu, 6 Oct 2022 15:06:30 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     Joe Damato <jdamato@fastly.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>
Subject: Re: [next-queue 1/3] i40e: Store the irq number in i40e_q_vector
Message-ID: <Yz7S1oUaxN7AtsY/@boxer>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-2-git-send-email-jdamato@fastly.com>
 <Yz1chBm4F8vJPkl2@boxer>
 <20221005170019.GA6629@fastly.com>
 <aab58471-096d-db50-36f2-493a14e0e6da@intel.com>
 <20221005184021.GA15277@fastly.com>
 <94e40ec4-fed8-5d91-54a0-b96bb21c6b9e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <94e40ec4-fed8-5d91-54a0-b96bb21c6b9e@intel.com>
X-ClientProxiedBy: FR3P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: 9835aa1f-d454-4a4c-a1fe-08daa79b9963
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZeQthWwqoScANil8NbpGUrS9m7zPtPHQYpFxefvUx+KvDiOWLFe5IKsMAsyKDrk4hVwHdNcpDlEr8IJRWLBMcO81wJFptKiQwh4HpB4WgtkI+KTg54BuTqbR+dIIKEzHYe9gDcEc/+6hWPFyZ1Kn2ZlZyOgYZolUDME2AR8iX3qo/iq1Tx35Jf1kevbejtUJI8D7HDRSj0idWwySLyYI1ggBMUwudaIgDcnzny1WkIjIA+9T1JAldIidYdJuyrxymrO5tGYVJisERTanj7/9RVEi7ef7k8+gLy/XtsP/eCAmbpP/t5thui3qNgE5iJmN2bLJ7VYvCEwqMeaWLygFQx8QAf97ugYIDFXsD40LWyNBwTeVBIiu3lc5qMC4RaUAgrpJQvWaA9X4MtaHRBQ8Zx/HCtMX3Iiy8W8BpIYjXqNXvOb5KSOvhg2Es1CBPVIyCyPKhpw+cJlivR0z+Mly6OWS3YlaoWgynMNdmz2PPJTc0hQEuQDkp6fjZhu4ltxVJQDWxBIoLxj7/JeMUYb2OJwbMAsHHeZinQooEMRI7XFQKYpbUVTvJoAHb8P8zVeYklpYEnUBarEolPYNciOM+cZSn4GcxPNMUNMbcTgyrcaES9dESUEZT2UGbrUaVGPlPWbk37ZlUn3+575PAPnFET1Ooyo50PF+ALBaxXzcxiI5ojUgQxBnwMpDOzrrjqTSvKEtN8PCIoGAlK/QTIxoLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199015)(86362001)(82960400001)(186003)(33716001)(38100700002)(53546011)(6506007)(6512007)(26005)(9686003)(107886003)(6666004)(478600001)(2906002)(44832011)(5660300002)(316002)(41300700001)(6862004)(66476007)(4326008)(6486002)(66556008)(6636002)(66946007)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wXEscOq5LKJInYuI3/46hnvQpisGzHvv60SJbb+Fx+1YwWWuhvdH9Mnp4302?=
 =?us-ascii?Q?iJtYIaFz9Gt6QPCRhaumNxvIp2uUpVTtJbVRBe55muetIdF6EVlinAP42Bm/?=
 =?us-ascii?Q?mOOTo0gQjTgLejhO604yVIHpbbO+bgjtQe7vsyzhjvIP6KjLgM1Vaa7tLfsB?=
 =?us-ascii?Q?8M3bDXkaHsm1kQ4oHxHTUnHpzOeHUT6uMbNOGaPQsIMPaJNPA7EvEGO3tpzH?=
 =?us-ascii?Q?lpT1zF5HMWxl/K2Dmu48nXUa6D3oQMJVNWAIeIof6aSEQrlRFax/PmRV4cEn?=
 =?us-ascii?Q?PztQT0LNrhLDqTQPK8r/Fb2iHBc78jEwSf4ToOi6c+vSvEfLleYF8wCjeX/K?=
 =?us-ascii?Q?+7Ul91J3EbBwVPxe3nLmY24t5x317wbV6HrvAPn9hhVjfgws/g74YOPVy3vU?=
 =?us-ascii?Q?HTzTjhhBowhGSYe+stiPe41XJDRuKOX4n/APj+KAAN8qBkWpELWdvrfnXHV/?=
 =?us-ascii?Q?jyKLPF1tOpc7hbrj9lPgQCcV90jKcUChC8wrdxuDVj/ObH+PhMKreAnb3/CU?=
 =?us-ascii?Q?jS5kTfYhjrqgw8ZB5fCmtmPNbCAFhvO21k4WT95tDbZ4etGXvA1X2qCZVrl3?=
 =?us-ascii?Q?/pzOzMd8r9zzP2gNWHFc6stDiDuGkhKUOIZQIb8fwLWa8uWeDj+SJMglkrjG?=
 =?us-ascii?Q?uKxNh2yhTDb0T6nBAc5lOrPwyeOblOmFhKynn7ray+5hjFLwvmYPmr7dO+0o?=
 =?us-ascii?Q?kV1ynJScSwANVVnLPgAJtTSLv0Fm0HlED03385OwbZSZyon8LL9aDU2jsT/2?=
 =?us-ascii?Q?WIqFgmETC/3f4IfPqyfkSF3t9BTMlzijAxBnGCd85px5FeNH9w9dL1V+KRIM?=
 =?us-ascii?Q?lVFnYllNxRVD1EWDmXDs6zJduAGFZtHjV9lNEZsU2lBpTFMCUOx5hY8B77HS?=
 =?us-ascii?Q?J6AmJ/dh7gZqaNo4iFE/1efeU+h9t4m87s9FtXiI8jlbBR0ly1IBPq5lDfhW?=
 =?us-ascii?Q?TLZpb1rqyGA1CK3UimFYw/QO7uDFkbBCUNXZuDE3XGwQ4K5QC1+//fZ5Fb3W?=
 =?us-ascii?Q?v+9HXBvq1Ib7KhWs7Dt3NLy/QwR/rL4Sqh5PQ0QwrtzRE7Svj8n4iRs1UWVl?=
 =?us-ascii?Q?PqG5yt0u1eTZypXJAIlGD2worLjAcOo+r2OS2KgM82M+0nBxyB/JEVENItjZ?=
 =?us-ascii?Q?cw2vXpoMYOiVLrUNPN6G7IA1oZm8xoBr3ehTK1S51I9Ye+NBsdxfpmY7KX8U?=
 =?us-ascii?Q?ueSvbOYCoSsVJ+Ah8M4PHAZ7qt6PVj+Mrvq4FAGSXIQVRdFDj+pWcEigh7Hm?=
 =?us-ascii?Q?AlTH5VH7kAp3x04UAYBM1Rdld6HmxY9foYTWDya4yUOWfnB7Zv33BpILqXLo?=
 =?us-ascii?Q?SmI1lwn4LD4WxGunJf56ngjAq+HzSsSh8m8uDUlAZ6RnjvNTeqyy+RhPJ7Wr?=
 =?us-ascii?Q?kjj3+nphfoyBFxJxwZ0VcmoO2fkjB8/mpDiESiVImOTYo3Pz0cb55eJazpKW?=
 =?us-ascii?Q?u8LbqHrvOFnxvdsP51hBkMaBetEfd9AUSvRuNksQ2zR7nSgYWvddil6x/LDy?=
 =?us-ascii?Q?2r13maTdubnmbHWZxRXOhOHLS9ZW6uz8jfg7Cpy1jVutWvzE53Pa5m7vKTz1?=
 =?us-ascii?Q?a/UINbzSE1djVOH1DGzYcoAz4gIxFjK4m1D7A4e1pFJ2nrq9sb5waBUWgJj7?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9835aa1f-d454-4a4c-a1fe-08daa79b9963
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 13:06:36.2496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlmDiaFi4lw7adyF7izP1mYM7G6/b5WMzuIXFJBJZgkqjivnG3SFFaWSp9DdMj3wWklwtaEC9sDhJNa6HQIaUHAAJ2MF0mRpBGB4Z36pqZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5673
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 12:37:19PM -0700, Jesse Brandeburg wrote:
> On 10/5/2022 11:40 AM, Joe Damato wrote:
> 
> > > If you're really wanting to reorganize these structs I'd prefer a bit more
> > > diligent effort to prove no inadvertent side effects (like maybe by turning
> > > up the interrupt rate and looking at perf data while receiving 512 byte
> > > packets. The rate should remain the same (or better) and the number of cache
> > > misses on these structs should remain roughly the same. Maybe a seperate
> > > patch series?
> > 
> > I honestly did think that reorganizing the struct was probably out of scope
> > of this change, so if you agree so I'll drop this change from the v2 and
> > keep the original which adds irq_num to the end of the struct.
> 
> I agree, especially in these routines, doing simple, explainable/observable
> changes is best.

Jesse, I recall now that this weird qvector struct layout is also the case
on ice driver. Maybe we should document it somewhere/somehow (or even
explain) to avoid touching it? I believe that not only me would have such
a knee-jerk reaction to try to pack it.
