Return-Path: <netdev+bounces-8090-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C57D2722AA7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:15:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D58B2812B8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C80071F946;
	Mon,  5 Jun 2023 15:15:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B818D1F19C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:15:24 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2103.outbound.protection.outlook.com [40.107.237.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D3010A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9JLGr4G9q443+sK7Ir7L9Ouyhe+tIwlO6MTqzwgrz7SJW+/DSDYdzpu1hQAMBLveHFqpVMS8ZKaCk7/80L4hupLi8WSsv4o+52xXFXMEsjABVORJF2JuXIMlYZKITYmfeIuuBcs0+MzVQLagJ2EnprG/g1Qcs3gnfnuBzQGLi9Jp6WgHIJZoCcoXarTd78V3WsdIBSCh/ovQDxyE+CXVMDbQHNTbev8KLiNVfqydPIUwYAAZ5RhUsJsDdQm1zGaSmO5wPbWYAsku6doEjc5hNfK5zQv1jaX/uMucvCPEnS9QQvIc9O0lXjevUEXDUTeo1qZ88zkRzBFNoh3wJLO8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vC+/Lp47yzC2o874TC5HR5AJTrxovR6LiBgUHZe1yQ=;
 b=KTM9ipkiMOEgPHSi7t1/QMdrUjsqiAIfnp1bSV9RCozawS/AJ3NmQb6VpDAcRC5LYAfHFgbs/4HgJ616mgToh4T0fwwyAbZhuAJuuRlNnGj22iIflZD2suOtq0zSkyFZKzZd4LFeyZxkdbAyZS2YNLr7jTaHNIeVtIST6N9lw18QWCqZKc4bufD9wr23ttuyts8BjH899W83ib24rPpULZJ9h9dr5DOuMziQUONkLqzQ3GyNsGxECIgj4xpvHQZFWj/gJstu4DKp5r375Aj9p2+36BQpZL+UwqLOyf2APkjsuqE6zfcsIK4yt3FzoNaWywlZHrqUgrILh7FRyI0fAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vC+/Lp47yzC2o874TC5HR5AJTrxovR6LiBgUHZe1yQ=;
 b=EWjqLfkm4wLnvUy/jjutYp4EqxBFOIZMiowS46rmsqoH/xVjVo+4QWVMSFVUX+XkpuyqazYfq9SHmCpWocA9ojHYzeU1+CaXR3PTK1wcVhYwEiDkHSZISjL8KZHzFbV4s6wx6BABPMYFzH1aAVuxcSqetvNcc2gSmFHtIjTpWy8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4930.namprd13.prod.outlook.com (2603:10b6:a03:36b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 15:14:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 15:14:28 +0000
Date: Mon, 5 Jun 2023 17:14:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <hadi@mojatatu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
	deb.chatterjee@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com, tomasz.osinski@intel.com,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, khalidm@nvidia.com,
	toke@redhat.com
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 12/28] p4tc: add
 header field create, get, delete, flush and dump
Message-ID: <ZH37za6g7UU9NPgO@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-12-jhs@mojatatu.com>
 <ZH23+403sRcabGa5@corigine.com>
 <CAAFAkD-=hLQzZoPtuvc0aaV8pOd8b=z2G8bYqsqM7qdKUeSB=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAFAkD-=hLQzZoPtuvc0aaV8pOd8b=z2G8bYqsqM7qdKUeSB=g@mail.gmail.com>
X-ClientProxiedBy: AM0PR06CA0129.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4930:EE_
X-MS-Office365-Filtering-Correlation-Id: df10bffe-a025-4b92-8e29-08db65d78e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	h2vfg/5z1MHg/FaE9T7O669qIK4cZj2WePoM48NdrYy0nPusta6ZgMLW/XIphfIc1Erf0bIzk+I0+cRLinCVOIHeVUa4OgOAVtbBmRkpM1kbClAGYABQ8ecZ9YieJ3F5AWuBgd7/wWVF0sRL7PoXkqd9fHXtxhWeir2JaBYOnLeyKkNgoOpzOA+qv5FP8JT3gu1KscoT2D7Lhs/zJCk8WNPMH1n4zN1Q9nQ53+oCSq7zbXhINKTKt4RTRmMfppyEQDqtgswgyPvcWzJWkuk3L6Qkn4nhSPtFEnoyiOllN3oMxn2e+aSB6F/UdyKkd5mC3/IbjDkAmRhHYX1LwQ/CPFvjGlFwoMe9vayPDUI+l7LXLLXa2ynUC3HCCtj3BK0g84720t3U/QpxxXEX0lK9OazxflH1mN8lJSa9dvEMgoTF0RuImiuBTWMyL1NcheCirhALOz/cecgZRY4C9fNuEpN8ZIfz1HmY/QG1ii5RbDWuP3d6lFl531t9+trfQXV5lMyyDwIO8HPKl2CtF/Jnmcam36rWZx4GhaahNNok9x60lUaB+Ouw4yMiWwW5acPHr7mMXvZPRpSWe9XhcmqoS8aCsfwlu2DuAyY5CvzRo0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(366004)(396003)(376002)(136003)(451199021)(478600001)(8936002)(8676002)(4326008)(6916009)(66946007)(66556008)(66476007)(316002)(38100700002)(41300700001)(2616005)(186003)(83380400001)(6666004)(6486002)(53546011)(6512007)(6506007)(86362001)(44832011)(5660300002)(7416002)(2906002)(36756003)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEtPNnNPWDZETEc2NlVTbUVYUXVtSHI3T1ZRZ2pobGtZRzRWYmc3alp0UWdS?=
 =?utf-8?B?ZmtXZy9kMk9RQTZLZGRXQWcwd2d4TVFvUVV0dXZ6VHVacTc2YXhGZm9zSEpC?=
 =?utf-8?B?TSt4Z2FTVjVuRVR4bnA2TjE3cVpGRUk2QnBQZnNhdmtvVGdHa2tZVk93UjZh?=
 =?utf-8?B?YTR4Z0JlQ1VRWUlNYk16RktJMVpzR2VmM1gzUXQzUllRRWRjVmhQYlI2V3lq?=
 =?utf-8?B?R2g1WW1PaWdlOTZnNzkzSVViSDhoc1hIMER0NXd6NnY2VitTQlArSUJwTU11?=
 =?utf-8?B?T1RBMVNmT3Y1VHVVSHlBWUZ4bWx3SjZpbmovWTdGMjc0ZU44U0FyVkJvaDFx?=
 =?utf-8?B?endUcERzUnZBeUQ2TkpKTmpYSzJiazAyQXdxTnRJWG9ab2RlRDgza1VGYlkr?=
 =?utf-8?B?cE1jdHBkZHBSL2JTd1UrN0lGV3ZpdDhidldab3hJL29rVmlSSlZ6cW45d3Zt?=
 =?utf-8?B?OFBVd0dpK3ZnOEtJbm42c1JXMlRmV05ueHBlV3NrZXNCMVdqc2l2b29uTTBJ?=
 =?utf-8?B?Z2UzdUNHZnNTNEFZYU13dnU5YzRlSW1zRjliNm1oZEhzbzYvNHBDd0tBdk1O?=
 =?utf-8?B?VGoxOGVBc3BHZlFnR1NMeFdvMHVOT3JRQlcvTmFzTmdaWHdmMFZQRThaeVdX?=
 =?utf-8?B?dW9CS3NmZXVtcnBDY3A5RFpZeGZSa0I1YVFsMlpGM01Xeks5OUswcFk4aWIy?=
 =?utf-8?B?eTROaUFkRjNJZnRlazZIeUVMZS8vdDYwRU5pU3hKaUVKb0JIUHk5OTNadlB0?=
 =?utf-8?B?dDlYZmNuTlJ3UkkxZnkycEp4djkwTk5LVXU1SEpRM3RTMGZncU9VQlo2ZUx6?=
 =?utf-8?B?Z2swRTZJZXAyYUZtSE11OTlPVFhaek5BdmlIdGc5MFNXTzg0Tm5xTzl0UlBw?=
 =?utf-8?B?KzZmbUVUK0lyMXRtbG9jUVJFcW4xYzVJakllNlVNNGQyNVhIbXVGYWo5WWZJ?=
 =?utf-8?B?a1BqbTYwVzVtbkdBdzdJMHhzOW84ZXpiN2FFQ1ZaSU1DcDhvYnBNek9zdlR3?=
 =?utf-8?B?Y2VZaVUyQXZWYmlSdkVIQjByWENkTUZUTHJ4ZXF5YkpKZ1QxTEM2RHQyQzJx?=
 =?utf-8?B?WWUxSm1zM0FhMVdrZGlySEx3Z1UxRmRSNm1NUngxZU9KSEF3aHBxMFVTNXJR?=
 =?utf-8?B?cnMwMHJZZHhtNktBU1hKalRIcUFjVUVId0tXUjVnMVRvOGUxelJabEhpeVlt?=
 =?utf-8?B?RkNsNUZpVmNOSS9VS2V3R2pmOVozNWpTMmJhaXoxZ1NiVU1vdlcxNHdNelYr?=
 =?utf-8?B?ajJLbDhGcjBvZGNFUnlSYVFTUmc2SjJIK3ZpazBITWZNZjZWSHgzblBqYWJa?=
 =?utf-8?B?MEtJZlVocjNzR3hSY0lXTkg5YkFQYjk2ekJKbitBTTRvWS9wZjhpby90MTJi?=
 =?utf-8?B?N01wK21uSksxdktUWllvbGQwQVMyRW15UkRsdTRITE1CSWZ5WWkvQlRaVDRI?=
 =?utf-8?B?RWYzazhPY2xuUi9tTzV1Rkd3M2VzVHFkaDdNdStnTlJWRVJzTVFySC9DeE8z?=
 =?utf-8?B?bVFQWWxjMXVkZlVkRm15RUp5ZUNJMm8zZllORzNhM0hqLzVYUk9qRjI0MVJB?=
 =?utf-8?B?cTFQKzl0Q1ZqSUx4ck5CRFRJeGZwRGJES3dONisva0puYVgwd3p1UmtVYXZC?=
 =?utf-8?B?Q0FKUWNZanNaUTlIcCt2Z2pSTVI4ODJVbGpPdWtjWmpCcmJoRFVhdDRlVXI2?=
 =?utf-8?B?dUsxemZwdEQ4eVcrMWxqbXJNOFpWWXVKbnZwTEVpamQyUTZDN1Rwa01ENDFt?=
 =?utf-8?B?OGNnWnVmVUxlelc2ZGRtSWVhNXFGK0U1WTUybUttRG5ITStGckJid1g1VCsw?=
 =?utf-8?B?TEJyd29BY1VSTnZIT3NqTk1HMDVPMHZyb25ZaTFRR0poY3dNekFjMjJTYWpH?=
 =?utf-8?B?d3N2N0s0SkRUNzhiaTVBZnFKSTRQSTBOOWpuakNKcDZQNDdGNzR3YnM3WjZi?=
 =?utf-8?B?ZldaamZXT1ltd045SmtxYStsZE55QU1wenBkYk5kRTNNMzduT2w4VzRBaFlE?=
 =?utf-8?B?cy9NdUsyYXY0YmNqd1crWmxxbXV6UTArQVZSaVhTMklsRWhGcGoza21CMVFW?=
 =?utf-8?B?dHkvZEE1aGRrMngzTXJpdEUyTkljeVJlWXFjdEVPcFc1M2N1TUsvNnhzS0k5?=
 =?utf-8?B?UndTczdYbTZHOG5ldE1XdjNCMy9DcGJtWCtydU5Mb1haT2d5ZDFPNmZiVkdK?=
 =?utf-8?B?NU40dmVwMmNwKzFQTkxMRUxlVnllWTluVG9IVlNBaHAvK1F2elFXTVFFaGpr?=
 =?utf-8?B?OWhnajJrV0ZuQ2hROHl6eU02dytBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df10bffe-a025-4b92-8e29-08db65d78e67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 15:14:28.5937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPgSDtcBz29oYCWFkyNTxs7fW11bH7HWYFSD01UF8IxZLIeFBQ1KWcYw4b6IASOzoBaHiMBf9vKjeJcfLefbmw/Qu5pOW9gc3yFCmWpEJO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4930
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:48:18AM -0400, Jamal Hadi Salim wrote:
> On Mon, Jun 5, 2023 at 6:25 AM Simon Horman via p4tc-discussions
> <p4tc-discussions@netdevconf.info> wrote:
> >
> > On Wed, May 17, 2023 at 07:02:16AM -0400, Jamal Hadi Salim wrote:
> >
> > ...
> >
> > Hi Victor, Pedro and Jamal,
> >
> > some minor feedback from my side.
> >
> > > +static int _tcf_hdrfield_fill_nlmsg(struct sk_buff *skb,
> > > +                                 struct p4tc_hdrfield *hdrfield)
> > > +{
> > > +     unsigned char *b = nlmsg_get_pos(skb);
> > > +     struct p4tc_hdrfield_ty hdr_arg;
> > > +     struct nlattr *nest;
> > > +     /* Parser instance id + header field id */
> > > +     u32 ids[2];
> > > +
> > > +     ids[0] = hdrfield->parser_inst_id;
> > > +     ids[1] = hdrfield->hdrfield_id;
> > > +
> > > +     if (nla_put(skb, P4TC_PATH, sizeof(ids), ids))
> > > +             goto out_nlmsg_trim;
> > > +
> > > +     nest = nla_nest_start(skb, P4TC_PARAMS);
> > > +     if (!nest)
> > > +             goto out_nlmsg_trim;
> > > +
> > > +     hdr_arg.datatype = hdrfield->datatype;
> > > +     hdr_arg.startbit = hdrfield->startbit;
> > > +     hdr_arg.endbit = hdrfield->endbit;
> >
> > There may be padding at the end of hdr_arg,
> > which is passed uninitialised to nla_put below.
> 
> Yeah, same comment as the metadata case; we could add initialization
> or add PADx at the end. Or maybe there's another approach you had in
> mind.

Thanks. Yes it is  the same comment, sorry for the duplicate.
No, I don't have suggestions other than the ones you have made.

