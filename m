Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2066A401FBF
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 20:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243903AbhIFSbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 14:31:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:31712 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230263AbhIFSbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 14:31:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="281034306"
X-IronPort-AV: E=Sophos;i="5.85,273,1624345200"; 
   d="scan'208";a="281034306"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 11:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,273,1624345200"; 
   d="scan'208";a="523447477"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 06 Sep 2021 11:30:41 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 6 Sep 2021 11:30:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 6 Sep 2021 11:30:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 6 Sep 2021 11:30:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCm9bJUcu+8e2WApwBaMaL67JvBBWvPwUBNTS+H64Eh6aagawtaTmtg7eplfvO+dXbubqlbKCReRI6XX/YvoUmB5dt8ctL7BjyLVM+K/yb8mDLCbZMzpA5bD3D1wVYqnKNWV0s9r4IsWe5mF2a+ByfvrCdqdXcaS1DLWXxNqS0G+ZBbyS7UjHN+y/cnDCpDQTfwUCeuuLqi6P9HiM/gyIjhhcT8rPT/+Gt9ti489pjJersMu+u5i2gTJTFUm9p03ZpJ3WlyZUDbmZu39tUVC3v+7jtuYSsssI2FWpAFDNSE8RNlLqvUkivFf862fycVclNK/30ZNeRmnphNBZMAkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=riH2Mt+Y4uUHXwPC54rueuWbj0T1T/qTIhffhke8v9I=;
 b=hkB3/V/W+yCz7mFL5gYwYmidTlDs51mXdYyYmFvPOGpbTKg5viSUU/tF3+sNDv4RG0Qal53RDkbhLCdJmLtwGzfV35xtvyZ1Xv4JXJURc51WWezexqK6lSFKiFtuCmY16JRh5JJagHwN511C9BzW1yET6xkES80xKEWw3M2vc4jT/V3HU7Kv7EvLfenPLwvZ3mhFkVCrA9jSh3yAIXo8YZ/59B0putknHrpV5fr77Mz26HCZljAQxJ1XF8f8KorfgVRA5uV97627cpMA4chNcvTsgxACVT793HF7VdRrMiSeNITxWy96ZqBb7WaHlWlrwkKevJnp9S3SrFr857Q6sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riH2Mt+Y4uUHXwPC54rueuWbj0T1T/qTIhffhke8v9I=;
 b=Lyuw0hgJFbrh/i7kQtc6MFhtu6yqHNd7I2tYZihKAKgI6Nnhxh1SofaGTLiFX/xvMBbYfDuDBwTq3QB+B3LSUdZvxdz3Or+d3Yo52STA2O9XVNKv18JV+9CpCzWs0QJdCwrzaMHz90p17bs6tL46cBPEN8WdHbMcNLjIziSGuSI=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4773.namprd11.prod.outlook.com (2603:10b6:510:33::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Mon, 6 Sep
 2021 18:30:40 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Mon, 6 Sep 2021
 18:30:40 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniA=
Date:   Mon, 6 Sep 2021 18:30:40 +0000
Message-ID: <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
 <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f8eb8f4-1865-456c-e100-08d971646dc8
x-ms-traffictypediagnostic: PH0PR11MB4773:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4773890331DFBD6B1CBA8265EAD29@PH0PR11MB4773.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6A6Netg4N3o4PrApzA5sfQFoesV4OBKzLwzr/0xZPpyEcswygoQDxgxZbrF5GKOWp69Lwb20jIsyKZ7fJFkwfSditkYBWg2BuAPiUbNtxbnYBHIjf8PMAcVEfg098vQkGSbcJ4RcLpHJqAdfVqtLDdgNeg5ePZnC5lyRIPNUNNRF8+Rht04nXEmbGEczmA/3aoiTOpWVuQaLQAGq0FKHdZlCnC6ClGb61TrRSLmH2yxXtV+ZrmTArCADqoGvgI522VDZzINtNxtlbqxNDBOtnyPgzR23ik6+vM0Oywx+Ry6zTUdo7lEYuzDuwaretXOSkFvvYAm3fUrmI8HdLJdd+fi0WZpaRaDtmfXQRwvrGrS7xv/GLq8PeNUUK3/64fzy+NS+Ny8zRg8i03BCEkpnlfr9oz6XWgo1MMMonykmPGqmVcTjgiimHuxS5h6Xz94qwUWMIgzx1oEIf5tiSHfHoRUSH5kIWsoRxK67Mwk6SlOZvDzdV0JaP+jp4nYneRpyoXHyd2vsgKUqGOyusbiiha0ae6aE8yasS8yBCLTpXN1XbA/HXHTCA3H+LZSOT1sDd6f5pf1KTUrEv2fMkqv6Ct0We/+5cX0EdF9gtM/TOImHtid5s9fhIz61Uof1vPjs+ExdG916+uT9yLkwwMzyT5iUBClCJ0z64Pq0aqBSHZCXvIDUbOzn49aMBktBtzrUlZ0HtoO+ky4X9FD1aiksWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(316002)(53546011)(6506007)(83380400001)(8676002)(6916009)(66446008)(66946007)(66556008)(64756008)(7696005)(33656002)(15650500001)(4326008)(478600001)(54906003)(2906002)(8936002)(38070700005)(186003)(26005)(66476007)(76116006)(86362001)(5660300002)(52536014)(122000001)(71200400001)(55016002)(9686003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jYHPWu8cBXQj9mEhcETd8sy1ouqt9/qCJ1NxhHMQmoypbAGESzFov2pnhURn?=
 =?us-ascii?Q?T0jy6S4+JBISEtmHQsCUdvFdBpaPtKzUO5pmZYEztUMHykAW/fI9f1Cs7YRS?=
 =?us-ascii?Q?tRdO+J1/kXmOCsz8i3WfaPuQaQHhD5qeT0sgcTcoPLM3+RKfUkjRhIfwgSTU?=
 =?us-ascii?Q?ZnsF/k8PNVM3N8eRrmfFjkPCtZbOFpEDkbuX3kQN+9nrN6I0abK12SXeKp8E?=
 =?us-ascii?Q?afzcrg1xZBpq+gQOA/xuKP/mzs9/hSnWFyVzMML3nfeW/B7FALvng7daoO/3?=
 =?us-ascii?Q?9pGC/Kv3QKBn5oxPGwqEXNJVKLGD5YRCvvyquXwDh1Dl0fow74T86scck0fi?=
 =?us-ascii?Q?jnd4vnqDTnTpxQ57Xc3WvU6ABPCPYViZkimfmiKq7tuGlDN0uVVg8SQrT64g?=
 =?us-ascii?Q?TDYmpjI8AupFUykoMUDzu/u6nT6YYeQWjXpXHjH20kMeXUgMmbHQxhb6TBGM?=
 =?us-ascii?Q?UPUFXcoeqkUjHW5N/sjH0+XSR18o4rWP6rLc3bTZkauXKKmp2TQ8ACu2650/?=
 =?us-ascii?Q?zhDIvMMPev26ZzG5lTNWNhXbGF548A3jaYIQxfwlwx31CTGLuM4g9tXjuj0J?=
 =?us-ascii?Q?2iQCy1BfJbhIMjyea7vyYWhlIz1zwLCKSQO2W/YidvsGnk7EKVKnJ8xxqOVH?=
 =?us-ascii?Q?c6MVN57WFuT8T0atGFw1sezzMDVrIW0TuEL8i3MlMJfucifdJ+W34wY2MuAV?=
 =?us-ascii?Q?6eAvUlLWYEPUBuNNVXr8/90fNc8DcMEIRUfxig/SdpfYUono30q3GEb5UHsK?=
 =?us-ascii?Q?9/3Q/NlAT8lrdiuYcwwr+PcZkyNCh8pkFxShX/Vkg7gOJzAuHpFkIQ9IBaqI?=
 =?us-ascii?Q?q38yIXsxvBCHag7mDjXMKVqnrQHK4JNoVACnxK+Yla4mLrPGyPFef9lImoUU?=
 =?us-ascii?Q?nKO48AdYPbB2VPEvYDbxianCVWUPOW3KjgD1X0pW9z8S8eMdyM7tmue7dSY8?=
 =?us-ascii?Q?L+RKpNYr8FvD7ccX10mdvFU88//D+0pFSbVht7UIzpCRJ90hQCVN4aWTd2wT?=
 =?us-ascii?Q?Odd5xaCTWehwNazNZflS2cblJ22ioH0jjqpfw1xyYQ3FgIwSyfiRSHgbMVkj?=
 =?us-ascii?Q?CHxr9/YzciTlflAx2HLdcZVpD4VL7LCixgZzw0FBe2WaeGZMxMDneQ5TI4j5?=
 =?us-ascii?Q?mhDv7ZUXeqIMsEFYY1jeIF67IohAyCUfJ0KKiElnQEJf6rkgG9ayW4OmBWGN?=
 =?us-ascii?Q?AAUlnU0jIKAXG37CMIKA87+75REXRbdN/EhjwhH1/DQJmhDsGEW6N2SbIW2O?=
 =?us-ascii?Q?uqQI7ax1GHylRxRytin8AoZO08OE611FFPl3WY8AkzhGFzZ1jvYMQkRwC+2h?=
 =?us-ascii?Q?pa8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8eb8f4-1865-456c-e100-08d971646dc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 18:30:40.0940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUjEmNy8minGlRFSnRRa9uJ8ld0qv9XQ8KTQoWtDUSDdBhbnt6JQ/56HMBMd1xH55JeUxc6hGUraCRPRoTelInBZf9U8CoPadKfBOzB7Hj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4773
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, September 4, 2021 12:14 AM
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Fri,  3 Sep 2021 17:14:35 +0200 Maciej Machnikowski wrote:
> > This patch series introduces basic interface for reading the Ethernet
> > Equipment Clock (EEC) state on a SyncE capable device. This state gives
> > information about the state of EEC. This interface is required to
> > implement Synchronization Status Messaging on upper layers.
> >
> > Initial implementation returns SyncE EEC state and flags attributes.
> > The only flag currently implemented is the EEC_SRC_PORT. When it's set
> > the EEC is synchronized to the recovered clock recovered from the
> > current port.
> >
> > SyncE EEC state read needs to be implemented as a ndo_get_eec_state
> > function.
> >
> > Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
>=20
> Since we're talking SyncE-only now my intuition would be to put this
> op in ethtool. Was there a reason ethtool was not chosen? If not what
> do others think / if yes can the reason be included in the commit
> message?

Hmm. Main reason for netlink is that linuxptp already supports it,
and it was suggested by Richard.
Having an NDO would also make it easier to add a SyncE-related
files to the sysfs for easier operation (following the ideas from the ptp
pins subsystem).
But I'm open for suggestions.=20

>=20
> =20
> > +#define EEC_SRC_PORT		(1 << 0) /* recovered clock from the
> port is
> > +					  * currently the source for the EEC
> > +					  */
>=20
> Why include it then? Just leave the value out and if the attr is not
> present user space should assume the source is port.

This bit has a different meaning. If it's set the port in question
is a frequency source for the multiport device, if it's cleared - some othe=
r
source is used as a source. This is needed to prevent setting invalid=20
configurations in the PHY (like setting the frequency source as a Master
in AN) or sending invalid messages. If the port is a frequency source
it must always send back QL-DNU messages to prevent synchronization
loops.

>=20
> or don't check the ifindex at all and let dev_get_by.. fail.
>=20
>=20
> Thanks for pushing this API forward!

Addressed all other comments - and thanks for giving a lot of helpful
suggestions!

Regards
Maciek
