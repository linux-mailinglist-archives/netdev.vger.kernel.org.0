Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE4B598F76
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346875AbiHRV34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346251AbiHRV3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:29:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E30D86C0;
        Thu, 18 Aug 2022 14:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660857995; x=1692393995;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0VJF1eZPGiMZXrG+Rss2iCidNixeH9M2B81KQFOGZBw=;
  b=AW4BRreML5FAtSP/V+Ghcyx2mO7OAl80GCvxiFsDtFldrOSztSIjQgJG
   gImvxIuBZtZB9KF+zG3pjzHmKcMgOG9jZW3Erq5NIxEnUMl7TLiB2EH/Q
   NY3/FES1j6zjHS6xrUey1A/FO7XOVNvUwi1Dn4SDYxUXlRAJ81aihY4c5
   gE8nvx+9rVeKkMjkmujqPDXRbhzgqCH4EomcxsH7+4lagg0uqZ1JEOFuR
   hrxZz15p8n98rv99eOM6ew3AHm3bd6AaMOO0EGiUZIDVnQdAfhWin7rX9
   bG+2Cb8hjmL34KTouVSIzpLPCvrPNuje3WYps/+ybHNd6eJ5drBs/8QLM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="290440975"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="290440975"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:26:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558700541"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2022 14:26:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:26:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 14:26:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 14:26:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1rjEDOSis1PihyRvMmbERtI7BCIz3hUFooSX8ze6J3xTXwc+rzXXOFJMln1zka4FtTN2BlkQB4pTmq5GRL6Mtz4XDqiYbxsRDqItH4/ZMrcXm7frpYqPwVF510Lg76vBH2kOErg7X6+hDTjyjHrGQWzbxyOTvVuiqkMecVBJhu9BD2RFKIjrb2380xTJmRh+3fJ5gNdGlDDkrWeLeYFEY7uAARolluUhEIwjTeqo4PEOXAFx5g3bn/Fue/FZxuQRFHpZGveAciykdMSMSXbzMSlb2z/VgxSwL6HmblC5y5RFstZkPopRJYIaJn0DK6WdjKo48uEwDbMftwNSwV4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIvTB8GpU+ytjVNkG1RvL+CkfHV+FqUZDdtrvNTvoUU=;
 b=jbs5eAhN0eQIClTpMfCUnLnjgyceFd06WS4F982dkVT3dI+iaZpUwabtoeKTNlEb9kNSBerQthksA63lDWSH50ikLaMTUfgRYKXKoi3HNeHxDcNmeEFonRkdx7kLyCrukuP7P/kDGr5PBUkJXUauB6O2+/k+NMo6QZBAq031laCBIeHy0EEgg7vN1Ie9DJx78w3KX7UPjuRaQ7PL5sh+zrAr5TJTz0GdzcKkouk2MBunAl9JER0YtlDOryaiM3Vn3BDBsfs83mEttMZJOgv38eQf5cuQltKseJ4Oq4fCaw/T8te2+szbSkRJXrdMDRVVj8SaIVq7TNz7GTIQGRx5zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN2PR11MB3903.namprd11.prod.outlook.com (2603:10b6:208:136::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 21:26:30 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 21:26:29 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sdf@google.com" <sdf@google.com>, "vadfed@fb.com" <vadfed@fb.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [RFC net-next 3/4] ynl: add a sample python library
Thread-Topic: [RFC net-next 3/4] ynl: add a sample python library
Thread-Index: AQHYrSleBPMcBdRFEUKzYm48LloJGq2qdLsAgAD1UICAAHxAgIAJUX4Q
Date:   Thu, 18 Aug 2022 21:26:29 +0000
Message-ID: <CO1PR11MB5089F2051CB169BE94370A42D66D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-4-kuba@kernel.org>
        <20220811180452.13f06623@hermes.local>
        <0e27c04a-f17c-7491-7482-46dc9a5dd151@gmail.com>
 <20220812160735.06325b7b@kernel.org>
In-Reply-To: <20220812160735.06325b7b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e464e92f-bd29-4ea4-2fbe-08da816050d3
x-ms-traffictypediagnostic: MN2PR11MB3903:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dMavO9pxC0+E4hpSd10rVfSOKwJbWHg/sbcObquLUoMm87Xjl1IWT7cN/EdpJyOro1EPkx4UEQO9KjG23v/HxEa1uh7hWbXR80b11B6CSSDPY7QwXkbLt1jkn50LjPK9RL5rw64+KzkNckvbm+NYI2sLCxod20LdevHZa8F8RprlxYZ+VZndWSFubywoc3TcCcmOICm5xviSQ85VS25R3kRNrKVT/X1WwVOpFUxEWJRorNYcDtMH7+HrPUIM9AEHfsoUkOYN+3JTgFIpyQOmqyqNugv8w50mm87eRoQQSIW/Vv+ioB4yqeZCG59kpbwyAaDJrGLWGAjnmQ3QQShj08W+uFo+iVY4fkzRg0Ry2U3ePKfm+8dldnAz0S62C7zlVg3iZ6MOg9PjPBjJOFn6m4F9vVROFg02ZTgIKvX3Snwba7bMCgHGRC6hW3R+7mtONfc5cBimCWPspm+uMGC+oxan8nTEdZCvpMBqLjy/nhFjyShTPXCN0BR80yy6IhbhKQvC0ARNqBXeNiINBj0HyqcMaRbqiPj92JO8VfDNTxrj/KRY1/6YO/wOqL5kVpmtvIjtneiV2qsRC7yyUQkBVf8FkNcbmWHG9sT40gunYPkKo6kgW5qRH6pS/u014Z8jpFzxRG+kfuTsev5Y4l7JkQsB5cpXWClFez58lBznpuhAnTtQftnpEqgr2+8MlTMwrxXv1M4b0i0ISt3FJ9RVwpK8B2/dtyCAX6A2ZdUhIMdkRWI8w0pJjeQyHxjxop92jgT75eHtYfKDFj4LqQaB+9RQNMUH5TwPK1igdAe6qPo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(376002)(346002)(26005)(9686003)(38100700002)(2906002)(53546011)(7696005)(6506007)(55016003)(186003)(83380400001)(122000001)(66946007)(82960400001)(4326008)(71200400001)(64756008)(66476007)(66556008)(66446008)(8676002)(76116006)(33656002)(478600001)(110136005)(966005)(54906003)(316002)(86362001)(41300700001)(5660300002)(38070700005)(8936002)(7416002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eW9FOsumrbc5vMILWNnQL02XNVrrEWGwBRUXgCc+T8DVnMjNfJjR5BGzx9Ax?=
 =?us-ascii?Q?BHsoLYH7MCTvV8C0T+AJ6FW9pmEEQbCaHmtzJV9Xo4zb9BoQI613EQDx9COp?=
 =?us-ascii?Q?pOxkLFrxrQouBpF24RyyGgtIeWhiEMiVpOH1l47Jbu5iJcDYk5Etf2K+Kfbg?=
 =?us-ascii?Q?cYIcQ3aiGRTDkq1j8W8ozGFkavAEoOX+ctWcH3G59jiNrwGWizysKhly+o6Q?=
 =?us-ascii?Q?8v6AmcTKKiCRIxpAki4sIv9rYZXHYOuHiqgmeZf1R1OVB0GMKV/21qjsH1TJ?=
 =?us-ascii?Q?W9LcPetrkAWkC3vMHS+Uvf0K86x7j+rACirYpDZeobHjcR0DxHcaAkBnNQ/W?=
 =?us-ascii?Q?fIx9NCzowPjZR7c0/1I5MZAU+pBIk1we5/Zt8XZJlXpAgSSuDKPE1KRstQoZ?=
 =?us-ascii?Q?TWu5yaCcMV3Vu40peGq6/vE7hLKMPlRRCf+KDHT3v5qvbpve6OzJQwxECtHJ?=
 =?us-ascii?Q?2hQK3N6uUNhmbaUbd/37s44tgkFeTzohYwvHjMpRgyKo+uquZf2TJYqY8UQC?=
 =?us-ascii?Q?Kfmr3CnxCHQRe7XkgRs+uy8/voo9WaQQNrpHMzHlefFkxIhge9H/ll2HHKt7?=
 =?us-ascii?Q?MepKbt3Qerost3qRtxl1SmMuGyMxhMlK5bjweuMsXafMwuz2kWJyx6+JHszI?=
 =?us-ascii?Q?SrQU0HVad/wwfIDWPvevfZKFv5vSVh0JTtml38OEIU3xn0tJErAdMBIZXe3m?=
 =?us-ascii?Q?bBJerAds+tYqBYTEPrm74dZL6glBKbgD20JFr9DQp5mjqt4g5gZfemDplEAW?=
 =?us-ascii?Q?gihj7xje+x5irsnluoB5TYG3VPHJo4L0FWMtCw2s7aqZTB/vup2CVf+0iIq6?=
 =?us-ascii?Q?4n6f4Eb0yvFLI8h6Pu+PDlsE+Za+WVCZ96Qk51HwyNHM7tvKXg514jnf//Fo?=
 =?us-ascii?Q?7bnweDMunkQNDlQo0yI+0xONy19IEfeHGV6CvZNH7JI8vpNzatxoVbF1MzKb?=
 =?us-ascii?Q?2ohpmyacgGXArjmrApkfgF5YSF9Iu+j6+o3zMBd8NLrf0Mr43R9yG8NB7Rsh?=
 =?us-ascii?Q?2dAiHZIEXFXnRzf9vLFD1euY/Nly3Ar03ifgGo38rq2byV5BjYp/Og2jo4Z3?=
 =?us-ascii?Q?dCFNGmAGrjUA8rGdQh4TckqxEIW1J5qJkotesoKo7lQMcmwAIFpra4xehXri?=
 =?us-ascii?Q?jGGPu9qnfhrIgwzZ/qapryOFLsPk4juYBuL/q4r4282GrwNJ5qbCZnKjPyxs?=
 =?us-ascii?Q?MnLtTPzJXRtMAC5XSAaPTLloo9y2YqB2pXnYCN7xFrQQDQNiWq8AQqMfHktw?=
 =?us-ascii?Q?9aGLy5xmAlnAc9B8cp7RK8cEgg592vSWdPMfJKsKReVzaozL5B5XLLxpoujO?=
 =?us-ascii?Q?l9GkQhE37iz4Wu5BumlPbS2nlfOQ2W+jYkkGzDArXjyS68qiVZSdePwlcKK6?=
 =?us-ascii?Q?cDtpAFADPt5uA0GLrMpiqMfOXjXNhzE/sztnh/2+ks93VpaKmVbS5yfSrk9h?=
 =?us-ascii?Q?/tD9GDZ23yJrbpOHJgs751goibKejtAOtReP6k/bFAr4e1bx5CVWga+tFU9v?=
 =?us-ascii?Q?dx8JUhicU44M7xTapKESiBDkc5bnfQSUagY13LKsohGjAeHUO/KkuuOXnA/G?=
 =?us-ascii?Q?reBmcUAZeYxG9Qy8nU2OtEc0GQVx95PV0I9bDeYI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e464e92f-bd29-4ea4-2fbe-08da816050d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 21:26:29.8895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ibJExpILOZ+CiLxBKohlvRkzesrwfRgCjx53sRmMP3vuTKXIpmFRX0lT9sxAqafeW4lMLVRTy7waKrFnkFwoLlLy+8ntQc21YiRMe7ezObk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3903
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 12, 2022 4:08 PM
> To: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>;
> netdev@vger.kernel.org; davem@davemloft.net; edumazet@google.com;
> pabeni@redhat.com; sdf@google.com; Keller, Jacob E
> <jacob.e.keller@intel.com>; vadfed@fb.com; johannes@sipsolutions.net;
> jiri@resnulli.us; dsahern@kernel.org; fw@strlen.de; linux-doc@vger.kernel=
.org
> Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
>=20
> On Fri, 12 Aug 2022 16:42:53 +0100 Edward Cree wrote:
> > > It would be great if python had standard module for netlink.
> > > Then your code could just (re)use that.
> > > Something like mnl but for python.
> >
> > There's pyroute2, that seemed alright when I used it for something
> >  a few years back, and I think it has the pieces you need.
> > https://pyroute2.org/
>=20
> I saw that and assumed that its true to its name and only supports
> RTNL :( I'll reach out to Peter the maintainer for his thoughts.
>=20
> This patch was meant as a sample, I kept trying to finish up the C
> codegen for a week and it still didn't feel presentable enough for
> the RFC. In practice I'd rather leave writing the language specific
> libs to the experts.

It has some generic netlink support, but the way it parses messages was a b=
it confusing to me. It could benefit from the automatic generation of attri=
bute parsing though!
