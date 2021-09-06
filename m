Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E257D40201B
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 21:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244642AbhIFTDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 15:03:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:53350 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230263AbhIFTDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 15:03:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="207251226"
X-IronPort-AV: E=Sophos;i="5.85,273,1624345200"; 
   d="scan'208";a="207251226"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 12:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,273,1624345200"; 
   d="scan'208";a="604801491"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 06 Sep 2021 12:01:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 6 Sep 2021 12:01:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 6 Sep 2021 12:01:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 6 Sep 2021 12:01:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBHq2fi1itOE/w1AOoM8gRml5fZWvYGjVbrWfdPCtdZ4f5Ze9WbAMNjyMOqn7BXONdcPKEcSWe46ymPsXmkDf6N+5/xkpzOXBCQ2brnCA/uW4UQOxYgP+0T89deVpsWTG7M2KpW1OHTWnfGke3FZXzur+ROdj6Ik8kAzu2wwvjrSlZeQEpmfRbbXnBEEj7JtkPJ8a1594YcXQFhrtD5t6pIZ05bhhm1+EEVsdnBQFXAfLXmAmXpK1eQ66piK0rLMuXfN2JCNyTTvyuUGSHwhu8gU7M0xiHR16gCpPrlAq+IXOPjzlrhk0/WFa6TFEAN0tpOBbBhW05GQPMpwizMY/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=N3m7Gsh1xjCuy4uZS0jHsP22CNaEMULE5nSuLbyptcU=;
 b=TwbvOOyfy9hjS8NtrQpXfeSoS9ME2CsoM1ur+cpnC4ZfzfWTVWa9yjSQMgYOx9T12YHEDxM31PkUT2tPZ48nfAzJ6mz13Odk4gShd7rvM5jRha/AKgJjA10+U+z3UpKsnsdnLe8/jTWBf+pT/gUc8GFhax9UphwIKqCWb57xL7byTONK4Om9Zas7v9gpuLFo1e31tEZNuTY/e30r4O8Y2qZCvGaEOe6/FEOt95ZANw79OA6gT2vHQcx/WRAmyNKnMfzdMt1uBtl5/MIbt29Uf16seix9ZGabzNzjkiYaoYpeeFc21X8h5Zmg2HjiuQf+kBk0/iZcY+92lWsDYI2Crw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3m7Gsh1xjCuy4uZS0jHsP22CNaEMULE5nSuLbyptcU=;
 b=HT63m3dlD057zzj0/DIwk/p8gXsUbD77mE6uieEyhO/M+PgbSL+SMzTwH3dj7DV618Jj+umw8osPnjEhT0iresWBiu9R+kddr3Od7wIY9V1TLHfw2nAMc2S3opknsZZ8cEGRnbFyX2ntfpzdRpAdCVvfslDyvWHxYtFBry0lv6Q=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Mon, 6 Sep
 2021 19:01:55 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Mon, 6 Sep 2021
 19:01:55 +0000
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
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHug
Date:   Mon, 6 Sep 2021 19:01:54 +0000
Message-ID: <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 3b3dcbe8-35f0-41db-8c58-08d97168cb42
x-ms-traffictypediagnostic: PH0PR11MB4824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB48246D353FA425BC0447E13AEAD29@PH0PR11MB4824.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +zqlywZ41Sq/aV1udRq+w2JzPVbUj/2hroHL3IzxHirRmVUo+CAcYJSniEJjayqnBdLGpVyTTpfqu/jx1pAjsDyJTaI6F0TEvtN3il2Zu9RTyyL+f7xkKEUY5IZ/KR0tOOMtdCtwSt2X08rf1eicawh3vsyqjqPMNxFwiPG64ogEoPxxy6LAbkP5kGkN2CN3DvoK3ZLfeTCGMkDRq809kBiM2lDb82BK4hes3oRJS7NbEicL1oi5NP+ORzGRYEQZMV2Yo3dNxfeWSJVEV5fHKT03YxbXpcej2Fz4Vj3+/1SO2Kaja4SdMTrRiCIFdqUgDubp6PjTcFFSkSbu0ZIRwiUCCUvECl9eqwxxWJdNE3s51UMgi2u4DUT4X0CzvsXRtXMpDxEjwKGmw2HHSLlaod6W3OOWqBG+L6GjNb/ZMuwgs6+u3aT3mbajy9YNiH27E4UMa2p53lkoEejUw7706BERpupj3e9HM4fap3XmqwAMw1HqV1lyn1vC219fbuUrA0miAUprTrmLz5ZDKy6Hs31pn+k6CkaO+2+OPj88zfvPp8Nq3PyPENYSb3lw6Sa7NcNzX5TH+43sXwLSSg5p8T5ZaRBUBp+8ke2BczoS+d4mPZYqJH1E9fxI/6D1SuV0xvqAwi6qXMbhcO2c5sioj2vn7Ic5P2MFD9mVVGk5zTCakCxMbScR2ki9VzWTZZVzKfxinvVPEWHnTlnUrykUiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(33656002)(54906003)(122000001)(2906002)(76116006)(26005)(6506007)(53546011)(66946007)(38070700005)(71200400001)(66556008)(64756008)(66476007)(66446008)(186003)(86362001)(478600001)(9686003)(55016002)(316002)(52536014)(6916009)(4326008)(7696005)(8936002)(8676002)(83380400001)(5660300002)(15650500001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MvXhuPTQOgR5YH/aK1Hpe0T6Vqlkl/3FGlkW5MpXWuAfYifH0jPREXpRzmWD?=
 =?us-ascii?Q?oe0tCAa7qGNqruOpBUruYDMJh2s0vGolmA168zpet/hkMY91G7Ma6ATh5dRh?=
 =?us-ascii?Q?X7uEYPmwozoJkL3om7I/cSEQQQ2syfmJijQoKNRaIhA6cza64In8H1maExfg?=
 =?us-ascii?Q?O8cNsggIusw1vCaJOfJziLl+FW4y1jGC23SgpTo4hj1WIlsm6iZsDVcwXNfd?=
 =?us-ascii?Q?0+S4Vb3/YAb+333F9grj/qZd57YZgR4dcqZcNHsWyYICvM2LLQpG6UBFJTEX?=
 =?us-ascii?Q?sbA/dUkAjEI4xwShKr8B3U1WBhoMJOl6aUov7GITaBsmmk5d/Z9fcD2v8WVW?=
 =?us-ascii?Q?yZ3mUc018RHPzrxyZyt8phXcWJa8GBX9GUqQefVx74UvarJf5sY4KNz8Lm4P?=
 =?us-ascii?Q?f2CV5dBuhwMV8EqMc5vqWOMolpru3PorkR9HKhV7rJaSsOhXTdFtnZvpLeel?=
 =?us-ascii?Q?T4FXM88kp2E0iue8yOACj7nnO3oIwmSkMKPtVhu5E7kX0oo+UmHH6RNnK6nD?=
 =?us-ascii?Q?aTDJA0Dc4c/BVfAeMsBV7FOnn98Nhy3CNpHyL10zqUX/mvYwevQiVK9W6xQE?=
 =?us-ascii?Q?PIXpIQm0RWw10N4QsQJ4YhRhigKrFLWo+H0YFkLUBV2uh4nGle9KCkPEr96y?=
 =?us-ascii?Q?PUTQAR8lhc9ghOqNm3Oc6iIo0DuMq+k7Ez8MNTpVssGMVvUdZRosXjhN9oPr?=
 =?us-ascii?Q?En6gSrz2U0IULULbxs/ps8zNl+5B9FbDwfJwHR6lPAQ+ksCSAxrSxr+6pzVr?=
 =?us-ascii?Q?R8G5WCxtTQVORrGabNAHtc2RJD3mFQB9ec4Tgm4FSTmQysi9Xz3qThGWp+Ib?=
 =?us-ascii?Q?+oc0+WXzT1tBPegRzoqvg29g7DfftHVctKjs96gBFusjq2U8b79kZPjU8z1b?=
 =?us-ascii?Q?/zZbsdQ/MTUF/UuXEHhEkElwhu/JfFW89LPxQQpKEkYLJMuoqHS+tYEqesXe?=
 =?us-ascii?Q?adSmag8KE1mlTxZA3JHbO+g4dxNpCHLsjvQBLLOflqtVMWXSW+7fS113ZYFw?=
 =?us-ascii?Q?Pb0+i1/uafMv1mMoH2d1cwNT3IDrTMVKTV26aT6Q3DtaDc2AXk3irkc5D1NL?=
 =?us-ascii?Q?1cR3gF3w1MDSriQowYvxe1nZyhzZED9hC4li/kfEV6t/5kzSVAq+i/lrLI2L?=
 =?us-ascii?Q?B/z0qtv6DF2Grv5Pc1fhTsPkNspe6Mp+L/WEqrlIn3TxGGisMFnyFOZBgeW/?=
 =?us-ascii?Q?j1Rw9qufFSlnpf4nBkjAZgpK1jnKiLAtix8jmCy6EH9xv0J6DGEL+/ujq58N?=
 =?us-ascii?Q?znhFeOHSgqCgyx9kskNQglOUKLOxl33GBB9RYMhK59R0ve2Oa7NwP8mRC3kr?=
 =?us-ascii?Q?JMU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3dcbe8-35f0-41db-8c58-08d97168cb42
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 19:01:54.9672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LqIOTsZUD2A/qtX6k5jTRXzhC0WIGk5TNDzPFOwy7ptW43JfV20AfhVy+BLBo9J44xXjYdnaulrfYpjcVwXXuhbF493Fd7fhBSgOb3IyR+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4824
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, September 6, 2021 8:39 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Mon, 6 Sep 2021 18:30:40 +0000 Machnikowski, Maciej wrote:
> > > -----Original Message-----
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Saturday, September 4, 2021 12:14 AM
> > > Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> > > message to get SyncE status
> > >
> > > On Fri,  3 Sep 2021 17:14:35 +0200 Maciej Machnikowski wrote:
> > > > This patch series introduces basic interface for reading the Ethern=
et
> > > > Equipment Clock (EEC) state on a SyncE capable device. This state g=
ives
> > > > information about the state of EEC. This interface is required to
> > > > implement Synchronization Status Messaging on upper layers.
> > > >
> > > > Initial implementation returns SyncE EEC state and flags attributes=
.
> > > > The only flag currently implemented is the EEC_SRC_PORT. When it's
> set
> > > > the EEC is synchronized to the recovered clock recovered from the
> > > > current port.
> > > >
> > > > SyncE EEC state read needs to be implemented as a ndo_get_eec_state
> > > > function.
> > > >
> > > > Signed-off-by: Maciej Machnikowski
> <maciej.machnikowski@intel.com>
> > >
> > > Since we're talking SyncE-only now my intuition would be to put this
> > > op in ethtool. Was there a reason ethtool was not chosen? If not what
> > > do others think / if yes can the reason be included in the commit
> > > message?
> >
> > Hmm. Main reason for netlink is that linuxptp already supports it,
> > and it was suggested by Richard.
> > Having an NDO would also make it easier to add a SyncE-related
> > files to the sysfs for easier operation (following the ideas from the p=
tp
> > pins subsystem).
> > But I'm open for suggestions.
>=20
> I think linuxptp will need support for ethtool netlink sockets sooner
> rather than later. Moving this to ethtool makes sense to me since it's
> very much a Ethernet-oriented API at this point.

Ethtool also makes a lot of sense, but will it be possible to still make sy=
sfs,
and it makes sense to add it for some deployments (more on that below)

> > > > +#define EEC_SRC_PORT		(1 << 0) /* recovered clock from the
> > > port is
> > > > +					  * currently the source for the EEC
> > > > +					  */
> > >
> > > Why include it then? Just leave the value out and if the attr is not
> > > present user space should assume the source is port.
> >
> > This bit has a different meaning. If it's set the port in question
> > is a frequency source for the multiport device, if it's cleared - some =
other
> > source is used as a source. This is needed to prevent setting invalid
> > configurations in the PHY (like setting the frequency source as a Maste=
r
> > in AN) or sending invalid messages. If the port is a frequency source
> > it must always send back QL-DNU messages to prevent synchronization
> > loops.
>=20
> Ah! I see. Is being the "source" negotiated somehow? Don't we need to
> give the user / linuxptp to select the source based on whatever info
> it has about topology?

The frequency source can be either pre-set statically, negotiated using
ESMC QL-levels (if working in QL-Enabled mode), or follow automatic
fallback inside the device. This  flag gives feedback about the validity
of recovered clock coming from a given port and is useful when you
enable multiple recovered clocks on more than one port in
active-passive model. In that case the "driving" port may change=20
dynamically, so it's a good idea to have some interface to reflect that.

That's where sysfs file be useful. When I add the implementation for
recovered clock configuration, the sysfs may be used as standalone=20
interface for configuring them when no dynamic change is needed.
=20
> > > or don't check the ifindex at all and let dev_get_by.. fail.
> > >
> > >
> > > Thanks for pushing this API forward!
> >
> > Addressed all other comments - and thanks for giving a lot of helpful
> > suggestions!
>=20
> Thanks, BTW I think I forgot to ask for documentation, dumping info
> about the API and context under Documentation/ would be great!

Could you suggest where to add that? Grepping for ndo_ don't give much.
I can add a new synce.rst file if it makes sense.
