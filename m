Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2E16B9F46
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjCNTCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjCNTCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:02:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2856860ABF;
        Tue, 14 Mar 2023 12:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678820530; x=1710356530;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=HhCwPd6iH5aMSn7QuW2EN8YzCC0FCwVG2o7ZJUbG6Fw=;
  b=DzPrkGGy0S+q74mLBZTe0dlrG2T1XmMRzZl9eFwlvaJfqU/2wUug8vWt
   VsbJzpvzosrgSXAdhRe0Ys53OF05dYA7oIAO/Uo00et44diGAY/LBkPut
   iUkslXeVi6x/h6PJ7+ctf8SxrYNiFF0lja0ZhJ40l9GgKF8U8oqzpurtw
   +XRTHPWeCugJ1ZEloBqw4xn9Um5712EKVrLNX7fgvR/1rVfOoEXdWmmo4
   GI2ge2mhCV44Gl4ZUoAz/knN+VD9jdEVlS8JiYT6kTEstexvVwyaTuXbJ
   6Rz02Uo0mhYwYJbMHs2zlw6leMOjW1nojLC22+c8YnSqMzKNXsIHfM+Yj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317914542"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317914542"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 12:02:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="709397246"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="709397246"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 14 Mar 2023 12:02:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 12:02:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 12:02:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 12:02:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcybJC+L8htyDF2g0X1BzSJZUgX6LFi60PfmMXlpKVym4hQVhGVKyHt8AboyZTjqF5K7PvGAHjOqGlrEyaO69+xOsTO6JPWvdOZdxdUt+1i1yCRzJwqpNTecoAlN+C6LLwl5yutLUkiP7C4o4AzCYn1n06/4krmlUnZzz0nQL9eXKAyDuuSq6sch8PvUiXMn4DA6lX2AAEh2ga9ackEd3nYYiYSM8PSd4/A5YSRlzhER1H6+54JpocPs0Cr0rjeYy6pBecLbSh8hJcpmnRyWBQ7B9IwApFh6IxaSTXmcdq3jIbZxOctwlLQD+AEDdNQqEA6TWftnkjk2FeQug0Fhsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QaWqytNcmy4UdLQYCzTBOXM+BDEYnoJ/lnID9w42/DU=;
 b=MsCDFz8YmxbQC0/WzyBVorLmveVPoWYAmRvwAFoVguUwOCQ7Qf7zuE5BaYYmy5w2hb6zWBxaKWS7SpyzcXYblXiD9Mf0WgCbgG4UrvEDADhmy4FLeUytkxqufKDvWjTxnnmRBQe8dCkPMv3ceSxVG9yeRC2BjzvzQyeVik2pT4yBVbincpNuBLNrGhEywtif2o6Poq24P2D3pRRyPsp8U/+a4h/7kUj1OvEA+ubNKdONr5fbBmYZTnOUmV3zxpwphLzG0jBJ+w4vNCI0QR3D7Erkipl3TL2NFp4KLoZkKMnErtWc1UwF6X7C5diJRbDItvHDYjUIKgI9cNqiQENW7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 19:02:05 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 19:02:05 +0000
Date:   Tue, 14 Mar 2023 20:01:52 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Jaewan Kim <jaewan@google.com>
CC:     <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@android.com>, <adelva@google.com>
Subject: Re: [PATCH v9 1/5] mac80211_hwsim: add PMSR capability support
Message-ID: <ZBDEoDeEUb6BQsf6@localhost.localdomain>
References: <20230313075326.3594869-1-jaewan@google.com>
 <20230313075326.3594869-2-jaewan@google.com>
 <ZA9UrX1I6XXOfnYV@localhost.localdomain>
 <CABZjns40eHSBDn3BVg0+Wc6dBOZjvx9ewty4wyOzE0WGrH6Tjw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABZjns40eHSBDn3BVg0+Wc6dBOZjvx9ewty4wyOzE0WGrH6Tjw@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0174.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::11) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SN7PR11MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bec4a7b-472a-43e4-abd0-08db24be9a39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xnYoDr5aJPLeuZJw54tHPegmeRz8430IpbIkQi+4ofZ8xHFmrfxaoiHoeHE08TrswTCQ7A59ddMY0k24TACS0H+TWmtVBCJ1I//JEJGzxCv2IG7ju0zOjcMbpJ7/1bJrA3VQCz3VyOOgMACzkmfUYT//ans72u5eQC8xsEg/WLin6XsS9Wb6fngdcGdW4m8ITcGTUijy2XTST3XHcgduQJPaDita/QStM9YwKC5GXdVaY0cBYj7kTHttORNj4MyJeY5kPwNt5gVQvHMsTaXvDp+CN+xsuyKEFqAlnGq+U+veeyVU/57FFeKRdsSjKhbv22cKA8RaPyzZQAROASNgWuJiGobhkJBJhiq5umynq6/F2CN6kjl8Q92qZOc3MtrBcJoyBphSGKeel62wYADORLmX+PHKSpY81fs54olkwGXlzYkDBSIfiwON9HBwIRCVWTExKyNKhbOa6OSCcEuVT/3Yz5byw+JQUqRQqz6l6l9FoJbsp8w+Se5XO6pZWSUFy9VXAusFCSVBj+P2xfebYDXSL+x8PCoW8gqdQm/UEpciHkBxGCdYb47dsyUTc6ZkKVXyJ1QtVwI34PouuyP/JU4qRV5wI1sMLDeeRE08WBtY7RCUN5pzrwNj6aAl5Go05+/rRr1VATG789LiY/bUJEkiNK1TJSAh4h/PsFjrcWljpWBRyzy8FUhJe8NRcT7H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199018)(316002)(478600001)(6486002)(8936002)(5660300002)(66476007)(30864003)(2906002)(8676002)(44832011)(66556008)(66946007)(6916009)(4326008)(41300700001)(6666004)(82960400001)(86362001)(38100700002)(9686003)(186003)(6512007)(6506007)(26005)(83380400001)(53546011)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXRxZ2YrUHVKRmpzRjJtWGZGSTd4Q1owaTZ4ZjRUTHM5MDAveVE4MlVhaG5I?=
 =?utf-8?B?Sk5jM082c0JQVHFGam0wQVB1WUVZSHBTQ29ZeWczVnRlNktBS1JPMGxzYkI2?=
 =?utf-8?B?T0djc1ZxZ2NHYnRlVkdoayt6SHBJa0h1RHNUZXdzcnFTWndLMHpheWZlWmRD?=
 =?utf-8?B?b0p1Z20zSnpsdGhieWxKZENXS3hvbVF0WWxhWUIwdTkvdFhQNHdzWEl5akNa?=
 =?utf-8?B?eUdzSWExN2FLd04vNGRSOFh6dytFSUVJM2VVY1poY0QzVWtJZXFhdjgzQ1RG?=
 =?utf-8?B?ajhTNnp0NzhmbTBzeUpma3RoejJQS2VvTmQzTGtNeHM4VlJ5emd2ZnlZVms2?=
 =?utf-8?B?UkU3Q21Hdmk1SGZaNk5DY1ZxaDNTeTFjZEJDSDE4TDhubStxZU5RMWxsdnYw?=
 =?utf-8?B?R0htVkxZQTBzalJ1SURLNUJ0VTA1dHhYdldiYWRzQWQ3eEMzUVBhZGpzd2kr?=
 =?utf-8?B?ZU1UVk5WU0NvVzc0U0o5Qmxmd29DMWp6OWliTXZaalFzUEQrSm1nUFFpTDdS?=
 =?utf-8?B?Z0FoSTFIRG1EWVdzS3FWdVhjeGlHYzNvUlc2c1hLbHQzZTZKbkdKVExIcWVP?=
 =?utf-8?B?ejhLMTRUS21xeU0xNXlwTnlSNWlEZCtjVnY1UkpDaGpwWTZRemZJeVUxeGg3?=
 =?utf-8?B?dHV3SzZVbnF3MUU2VEVKR2JzNVUyN2V0R2Nhb1BMNXBYVVU1TjB0VUJnQUNp?=
 =?utf-8?B?c1hIVUd3Vk9adkQ5TlJwN2Q5b0o1Zy9VR0crVEc2Mld6N3NxdmRuNW15dlA0?=
 =?utf-8?B?VS83Z0xLZnBDcVU4bTRPUDhxNFltdHZ3aWtJWDFOVlNFdkNGY0R2OWNxMUIw?=
 =?utf-8?B?dE5oNUFMNHBtc2RwNXp5dXR6cnQvV3RtQ2ZzcTRRdlFEa0JBakNqM2VWL0lk?=
 =?utf-8?B?MkZvQXRsQ2RxTGRSQ0xnVDR0V2lXZGIwRzhCcFcwUXBlSmNKc2JTdXV6eGtv?=
 =?utf-8?B?RngvRyt2TEEvZmZGOWVHMi9FeEdhMzgzc2QvZkJjRm9yYmgyVkhoWWVwWXQw?=
 =?utf-8?B?Vi9adXVZTzJBdnNiLzBMYXYwU05MaDdMTGc5SjhYSHg4UTVCMWRuN1NYZmpp?=
 =?utf-8?B?a2EvdG93bUMzTE8vZExOUEdqQUlENEIxWGJVemFQaWNST1l0NFY3UExPQW03?=
 =?utf-8?B?MlZoOTZWQnMwLzBDL3pCN2NaTXdVY3ZiQ2JXWDdPNjJMNkhLRUF6cFBldkk3?=
 =?utf-8?B?YVFBQTJiaHRFR3IybnFBRXRrU1c3TVZSSmhKbDZQZmVEcDkvYlFTKzJpL2xO?=
 =?utf-8?B?bWljU04zYkFETGxIMEVwenlKQ29aT2paZUFmY1F0VjkwVTgyRTJBeE10ZnQ1?=
 =?utf-8?B?bWRJYU9MLzRqU3VkWWVyclg0dUg0aGNlc2pOb0R2OUJhaFhaV0s5YWFHb2Ez?=
 =?utf-8?B?d1A4TVVTSi9POWxOUndIaDA0Y2JaQVhVVFdSM0FrTVowY1B2NWlmeGhyWnhV?=
 =?utf-8?B?MFVMcUhvd2dpK0NaTU9seWZIdXlqZEQ2dUtOcDB2VGllMC9BOFBGSWxpeGd1?=
 =?utf-8?B?Sk54SVI1ZHBBSW4zSlVBRDJkTmkzeGtNd0U0TE5tT1BlSEZqcHVSQ2M4dy9z?=
 =?utf-8?B?dUl5S2J6WWpsY3MxZml0K1MxRVpxREQ0QWZpeXVSY1QzeUZaTTlOY1ppTE8y?=
 =?utf-8?B?MGJZaHNTay84KzBGb0owcm84K2N1ajhUOHJndEw2QVJKS0RNVWJxQmVDMDhs?=
 =?utf-8?B?SUpCQUVvSWxrM2tDd1FrMTgzSUpDYkw1dFZNQUphd1NhOEo2bUxWdEJhaVZX?=
 =?utf-8?B?bFFNek9YU09xSjN4NmRqTFBwOWJIREFKM2RzbisvM0JWRE9jbGFtU3diVGly?=
 =?utf-8?B?Q2M1cEhrL3hrWDdCZThpMGM5NFRqVTZtdUw5ZHZhcTNPZlRGd3NZVmdZdmFE?=
 =?utf-8?B?dlRCNW9qbGNzOWM1QmkvdndoNGRkN0hGTkVsTDNVWVhrdFREcUIxdnpPbnN2?=
 =?utf-8?B?Y3ovTDNQRnF1bFkrQTNvQ0pnY1IyUzBIbW5CbnA0YUg3MlFRWTJZNzFQZ05E?=
 =?utf-8?B?dWtQMktjakhTWE1PU3J5OFZLTlV2eWdJWEEwWUNHUzNPdElmTElrUWFzdTBZ?=
 =?utf-8?B?R0N2cTFESTVMOEYwdXkvNnRvYWtQbGZpbSs5TFV2VCtPRDRZWUJ4SldwbkRz?=
 =?utf-8?B?OVJLYnZyNmJuL2FMMS9HVGFaMHMyejhQS2hVY0lCVFQzUTBRQStBVlNrM0hS?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bec4a7b-472a-43e4-abd0-08db24be9a39
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 19:02:05.4945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlJsmxo93So7WkUPMXoOnkkgy7kO6+yl+x8jYml0sxg2Fgkzn/iDyy1FDV56/n+AHtTUmaUfoOdEqbZq6PeO+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 01:36:02AM +0900, Jaewan Kim wrote:
> On Tue, Mar 14, 2023 at 1:52 AM Michal Kubiak <michal.kubiak@intel.com> wrote:
> >
> > On Mon, Mar 13, 2023 at 07:53:22AM +0000, Jaewan Kim wrote:
> > > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > > Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
> > > time measurement) is the one and only measurement. FTM is measured by
> > > RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> > >
> > > Add necessary functionality to allow mac80211_hwsim to be configured with
> > > PMSR capability. The capability is mandatory to accept incoming PMSR
> > > request because nl80211_pmsr_start() ignores incoming the request without
> > > the PMSR capability.
> > >
> > > In detail, add new mac80211_hwsim attribute HWSIM_ATTR_PMSR_SUPPORT.
> > > HWSIM_ATTR_PMSR_SUPPORT is used to set PMSR capability when creating a new
> > > radio. To send extra capability details, HWSIM_ATTR_PMSR_SUPPORT can have
> > > nested PMSR capability attributes defined in the nl80211.h. Data format is
> > > the same as cfg80211_pmsr_capabilities.
> > >
> > > If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> > > cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.
> > >
> > > Signed-off-by: Jaewan Kim <jaewan@google.com>
> >
> > Hi,
> >
> > Just a few style comments and suggestions.
> >
> > Thanks,
> > Michal
> >
> > > ---
> > > V8 -> V9: Changed to consider unknown PMSR type as error.
> > > V7 -> V8: Changed not to send pmsr_capa when adding new radio to limit
> > >           exporting cfg80211 function to driver.
> > > V6 -> V7: Added terms definitions. Removed pr_*() uses.
> > > V5 -> V6: Added per change patch history.
> > > V4 -> V5: Fixed style for commit messages.
> > > V3 -> V4: Added change details for new attribute, and fixed memory leak.
> > > V1 -> V3: Initial commit (includes resends).
> > > ---
> > >  drivers/net/wireless/mac80211_hwsim.c | 129 +++++++++++++++++++++++++-
> > >  drivers/net/wireless/mac80211_hwsim.h |   3 +
> > >  2 files changed, 131 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> > > index 4cc4eaf80b14..65868f28a00f 100644
> > > --- a/drivers/net/wireless/mac80211_hwsim.c
> > > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > > @@ -719,6 +719,9 @@ struct mac80211_hwsim_data {
> > >       /* RSSI in rx status of the receiver */
> > >       int rx_rssi;
> > >
> > > +     /* only used when pmsr capability is supplied */
> > > +     struct cfg80211_pmsr_capabilities pmsr_capa;
> > > +
> > >       struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
> > >  };
> > >
> > > @@ -760,6 +763,34 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
> > >
> > >  /* MAC80211_HWSIM netlink policy */
> > >
> > > +static const struct nla_policy
> > > +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] = NLA_POLICY_MAX(NLA_U8, 15),
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] = NLA_POLICY_MAX(NLA_U8, 31),
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED] = { .type = NLA_FLAG },
> > > +};
> > > +
> > > +static const struct nla_policy
> > > +hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> > > +     [NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_capa_policy),
> > > +};
> > > +
> > > +static const struct nla_policy
> > > +hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] = {
> > > +     [NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_ATTR_TYPE_CAPA] = NLA_POLICY_NESTED(hwsim_pmsr_capa_type_policy),
> > > +     [NL80211_PMSR_ATTR_PEERS] = { .type = NLA_REJECT }, // only for request.
> > > +};
> > > +
> > >  static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
> > >       [HWSIM_ATTR_ADDR_RECEIVER] = NLA_POLICY_ETH_ADDR_COMPAT,
> > >       [HWSIM_ATTR_ADDR_TRANSMITTER] = NLA_POLICY_ETH_ADDR_COMPAT,
> > > @@ -788,6 +819,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
> > >       [HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_U32 },
> > >       [HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
> > >       [HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
> > > +     [HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
> > >  };
> > >
> > >  #if IS_REACHABLE(CONFIG_VIRTIO)
> > > @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
> > >       u32 *ciphers;
> > >       u8 n_ciphers;
> > >       bool mlo;
> > > +     const struct cfg80211_pmsr_capabilities *pmsr_capa;
> > >  };
> > >
> > >  static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
> > > @@ -3260,7 +3293,7 @@ static int append_radio_msg(struct sk_buff *skb, int id,
> > >                       return ret;
> > >       }
> > >
> > > -     return 0;
> > > +     return ret;
> > >  }
> > >
> > >  static void hwsim_mcast_new_radio(int id, struct genl_info *info,
> > > @@ -4445,6 +4478,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
> > >                             NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS);
> > >       wiphy_ext_feature_set(hw->wiphy,
> > >                             NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
> > > +     wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
> > >
> > >       hw->wiphy->interface_modes = param->iftypes;
> > >
> > > @@ -4606,6 +4640,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
> > >                                   data->debugfs,
> > >                                   data, &hwsim_simulate_radar);
> > >
> > > +     if (param->pmsr_capa) {
> > > +             data->pmsr_capa = *param->pmsr_capa;
> > > +             hw->wiphy->pmsr_capa = &data->pmsr_capa;
> > > +     }
> > > +
> > >       spin_lock_bh(&hwsim_radio_lock);
> > >       err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
> > >                                    hwsim_rht_params);
> > > @@ -4715,6 +4754,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
> > >       param.regd = data->regd;
> > >       param.channels = data->channels;
> > >       param.hwname = wiphy_name(data->hw->wiphy);
> > > +     param.pmsr_capa = &data->pmsr_capa;
> > >
> > >       res = append_radio_msg(skb, data->idx, &param);
> > >       if (res < 0)
> > > @@ -5053,6 +5093,77 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
> > >       return true;
> > >  }
> > >
> > > +static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg80211_pmsr_capabilities *out,
> > > +                       struct genl_info *info)
> > > +{
> > > +     struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> > > +     int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> > > +                                ftm_capa, hwsim_ftm_capa_policy, NULL);
> >
> > I would suggest to split declaration and assignment here. It breaks the
> > RCT principle and it is more likely to overlook "nla_parse_nested" call.
> > I think it would improve the readability when we know that the parsing
> > function can return an error.
> 
> Thank you for the review, but what's the RCT principle?
> I've searched Kernel documentation and also googled it but I couldn't
> find a good match.
> Could you elaborate on the details?
> Most of your comments are related to the RCT, so I'd like to
> understand what it is.
>

RCT stands for "reverse christmas tree" order of declaration.
That means the longest declaration should go first and the shortest last.
For example:

struct very_long_structure_name *ptr;
int abc, defgh, othername;
long ret_code = 0;
u32 a, b, c;
u8 i;

As far as I know, it is a good practice of coding style in networking.

Thanks,
Michal

> >
> > > +
> > > +     if (ret) {
> > > +             NL_SET_ERR_MSG_ATTR(info->extack, ftm_capa, "malformed FTM capability");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     out->ftm.supported = 1;
> > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES])
> > > +             out->ftm.preambles = nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES]);
> > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS])
> > > +             out->ftm.bandwidths = nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS]);
> > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT])
> > > +             out->ftm.max_bursts_exponent =
> > > +                     nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT]);
> > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST])
> > > +             out->ftm.max_ftms_per_burst =
> > > +                     nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST]);
> > > +     out->ftm.asap = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_ASAP];
> > > +     out->ftm.non_asap = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP];
> > > +     out->ftm.request_lci = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI];
> > > +     out->ftm.request_civicloc = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC];
> > > +     out->ftm.trigger_based = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED];
> > > +     out->ftm.non_trigger_based = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED];
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cfg80211_pmsr_capabilities *out,
> > > +                        struct genl_info *info)
> > > +{
> > > +     struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> > > +     struct nlattr *nla;
> > > +     int size;
> > > +     int ret = nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa,
> > > +                                hwsim_pmsr_capa_policy, NULL);
> >
> > Ditto.
> >
> > > +
> > > +     if (ret) {
> > > +             NL_SET_ERR_MSG_ATTR(info->extack, pmsr_capa, "malformed PMSR capability");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
> > > +             out->max_peers = nla_get_u32(tb[NL80211_PMSR_ATTR_MAX_PEERS]);
> > > +     out->report_ap_tsf = !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
> > > +     out->randomize_mac_addr = !!tb[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR];
> > > +
> > > +     if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
> > > +             NL_SET_ERR_MSG_ATTR(info->extack, tb[NL80211_PMSR_ATTR_TYPE_CAPA],
> > > +                                 "malformed PMSR type");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size) {
> > > +             switch (nla_type(nla)) {
> > > +             case NL80211_PMSR_TYPE_FTM:
> > > +                     parse_ftm_capa(nla, out, info);
> > > +                     break;
> > > +             default:
> > > +                     NL_SET_ERR_MSG_ATTR(info->extack, nla, "unsupported measurement type");
> > > +                     return -EINVAL;
> > > +             }
> > > +     }
> > > +     return 0;
> > > +}
> > > +
> > >  static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
> > >  {
> > >       struct hwsim_new_radio_params param = { 0 };
> > > @@ -5173,8 +5284,24 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
> > >               param.hwname = hwname;
> > >       }
> > >
> > > +     if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
> > > +             struct cfg80211_pmsr_capabilities *pmsr_capa =
> > > +                     kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);
> >
> > Missing empty line after variable definition.
> > BTW, would it not be better to split "pmsr_capa" declaration and
> > "kmalloc"? For example:
> >
> >                 struct cfg80211_pmsr_capabilities *pmsr_capa;
> >
> >                 pmsr_capa = kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);
> >                 if (!pmsr_capa) {
> >
> > I think it would be more readable and you would not have to break the
> > line. Also, in the current version it seems more likely that the memory
> > allocation will be overlooked.
> >
> > > +             if (!pmsr_capa) {
> > > +                     ret = -ENOMEM;
> > > +                     goto out_free;
> > > +             }
> > > +             ret = parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_SUPPORT], pmsr_capa, info);
> > > +             if (ret)
> > > +                     goto out_free;
> > > +             param.pmsr_capa = pmsr_capa;
> > > +     }
> > > +
> > >       ret = mac80211_hwsim_new_radio(info, &param);
> > > +
> > > +out_free:
> > >       kfree(hwname);
> > > +     kfree(param.pmsr_capa);
> > >       return ret;
> > >  }
> > >
> > > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> > > index 527799b2de0f..d10fa7f4853b 100644
> > > --- a/drivers/net/wireless/mac80211_hwsim.h
> > > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > > @@ -142,6 +142,8 @@ enum {
> > >   * @HWSIM_ATTR_CIPHER_SUPPORT: u32 array of supported cipher types
> > >   * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TBD) for
> > >   *   the new radio
> > > + * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD_CREATE_RADIO
> > > + *   to provide peer measurement capabilities. (nl80211_peer_measurement_attrs)
> > >   * @__HWSIM_ATTR_MAX: enum limit
> > >   */
> > >
> > > @@ -173,6 +175,7 @@ enum {
> > >       HWSIM_ATTR_IFTYPE_SUPPORT,
> > >       HWSIM_ATTR_CIPHER_SUPPORT,
> > >       HWSIM_ATTR_MLO_SUPPORT,
> > > +     HWSIM_ATTR_PMSR_SUPPORT,
> > >       __HWSIM_ATTR_MAX,
> > >  };
> > >  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> > > --
> > > 2.40.0.rc1.284.g88254d51c5-goog
> > >
> 
> 
> 
> -- 
> Jaewan Kim (김재완) | Software Engineer in Google Korea |
> jaewan@google.com | +82-10-2781-5078
