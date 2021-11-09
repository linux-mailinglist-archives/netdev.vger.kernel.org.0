Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4844ABCE
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243251AbhKIKxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 05:53:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:57446 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241110AbhKIKxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 05:53:04 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="256103111"
X-IronPort-AV: E=Sophos;i="5.87,220,1631602800"; 
   d="scan'208";a="256103111"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 02:50:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,220,1631602800"; 
   d="scan'208";a="563977335"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 09 Nov 2021 02:50:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 9 Nov 2021 02:50:16 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 9 Nov 2021 02:50:16 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 9 Nov 2021 02:50:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYG3NaVHSc7vGNWL93lrgeE1jFzsy70Ow3UjxT44SFru9VrwqgN//gltyJEVQ4dkNBVTsGWgne4zw9i9Z41JbKWH571A8M9UMJNbrDMpt/RvqvpYPmegyCVCrmOJarOrrplhnSfr9siuCR/IGYEXeqfIOrZHjYXBXpUwXS4i2O7c3zfpXYiL38FlMkoqxOuf7WLPr2jJi4xZbvTC7ceZf3nTGX8t18IuGgmvxRu6i+5K0QJbDXwG1N3DdPRjzpLirihGnxLrHh+PPCl/l5OcBc2RNcJopgQdijlecsky53wG8Xs1DsRIf96EkLGCYYZiXBZDOOux2+cwfKUIu/atVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpERv0RvmHVQlg0q33UxI/I8aeEqu7BNhrJujq/0gXg=;
 b=VmP0KU+0NeY9PyIWz1YodwwvUKAEdoVl74zgIiMTUwI2A/Qn5Q2Rzbjvodamot7doNuYAeYpXTqQPaPAGIY3dVR3wSWUhtU9JCPrRXc9POhKu6apI26U5k6EKR+UOyJWXzFv8KN3NuobeS5qZTlhEc83WsNafCRST3LQzhblH8JuuD749ODNbKQ/vO7szLLswUJq3XAohyW/F7F/rMOIoDLWU5AI3jTlVdQbr0oUpRQhn3kSKTQVy3T5s7wUt82dnRUYnj/vY+GtBQYdQG2QU9qTRo14Sa+r0beE2tjbLWbgi3cPyVrkESiNCUfy7ZPok6/SMEyr7zI5Ys9efVrAqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpERv0RvmHVQlg0q33UxI/I8aeEqu7BNhrJujq/0gXg=;
 b=J55rzd2cUx9WSillyKhepLqYPuqIOjvE7+6YuWxJQl6JDQ3bdsyjlM8ov8HZ3sA0VQ95OEPWtBnzODSns40P2oeYZfvxJ9s3Tfl8lqVNi+8kV7w49ZsF9/oO5FgrU2/4jP0S2ZjPcTXKDnVH65+sJS7GBDBXmPDAJ5xQr2Gi0pI=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW3PR11MB4730.namprd11.prod.outlook.com (2603:10b6:303:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 10:50:15 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.019; Tue, 9 Nov 2021
 10:50:14 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX0oli6labJUcox0OLXoT9uSo8Gqv4HN8AgAEw1JCAAIjtAIAACUcAgAEobTA=
Date:   Tue, 9 Nov 2021 10:50:14 +0000
Message-ID: <MW5PR11MB58121891B56004F5AB3DE922EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
        <20211105205331.2024623-7-maciej.machnikowski@intel.com>
        <YYfd7DCFFtj/x+zQ@shredder>
        <MW5PR11MB58120F585A5CF1BCA1E7E958EA919@MW5PR11MB5812.namprd11.prod.outlook.com>
        <YYlQfm3eW/jRS4Ra@shredder>
 <20211108090302.64ca86a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211108090302.64ca86a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59e45d1c-2fbe-4920-08c3-08d9a36eb63c
x-ms-traffictypediagnostic: MW3PR11MB4730:
x-microsoft-antispam-prvs: <MW3PR11MB4730AB9F8CB01CA9DEFCB1D7EA929@MW3PR11MB4730.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IfJU3gjnNR1KPjntxfaDzUqu9C0TV5TCHfdBwTRqSCusuk8/2XZQupcZ5v5WXT4ASG6pMyMg2rMviI1ik+rqt6FRGwDa04S4VLQxyWowHUMj9Mi+nhLLbLWl5kUghlYweqUa1JZriqZzlx88iLeX813dwOy8Go9aOoiLYQevcaqy4fKIIuUXNNFfl56veJOqWKDEKTnhFhsaDroe0Vtb93CxjAlMhhJly8irnool1J3EUcL5RjIagrDkNjSObAHPKRW/vWiuY10FVzsHzFGWa7QEdAbYAA0qUkOOgcYGH+MVCkitjdKPM0TDmUV3z2tES1fykNpkWSp241UPWoO5G6ns5VCJ8L5P+p7Lfd4knAjGh3VY23uiUpxPMT+Lu4NYza4FqmaZjPaVVDp3MVolpP+0XmNN5hPB+eyc9EWtSD83riWdVORu2QDwS+k5++pbuxFGjUhICV2VIUZf4q2UBqOCblSv143NfjeLZoUuK+EjM/zUT5MLbRlTTn/Bus9GHYbcaOcb4U2Sj5l7HrL8tdZe46TesS7yei0rJ+5Qn+GI2G4GQMHRJyuQ/TVUeBBt255I9twhPz09CzM5KAE2LwUXbP5T/ggLBPNVILnJB8BfskgOsvhvkRQaJEoMGN4BlsqUCmDZrGnGMUfekUz8FG2S9N9RPB2aDKWNlratFx4lZUIJCmCGdjpvlPR2htG90WSUEnaru+jw/a4qguMbWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(66556008)(8936002)(9686003)(508600001)(86362001)(82960400001)(110136005)(38100700002)(26005)(7696005)(53546011)(66946007)(66446008)(8676002)(55016002)(66476007)(6506007)(38070700005)(76116006)(7416002)(186003)(122000001)(71200400001)(316002)(5660300002)(33656002)(64756008)(54906003)(83380400001)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9spmujWhuelNvpXDvGl/jBkRAmu5uWSMb+bFyRGD4Fy9xvJACxopH4paoG+w?=
 =?us-ascii?Q?svWTuhdhTEIJfhatELJUCDQsORZnEK/E8hGA4RjmF6AfL2KmZ8h3EuyIljI2?=
 =?us-ascii?Q?OOuQZ1ENg0GnI20gOQygvBV3J2yvOGu0DVlqI3qVFuiJBVU8Pa5E/IXxsRTr?=
 =?us-ascii?Q?QxiMAM9GKxp0ELBHYIQjPPPihWDJE2NT7O3kcQcsCZNxpmbfsYWO93QKnyfU?=
 =?us-ascii?Q?4wfZm3U4zQKctBM6EqPda8bC1UjUZxd0k3oUzHYRCCOhKmrDkY8zqy9DxP6N?=
 =?us-ascii?Q?DrIvT7YFt0h2/Rzbxsx89gvlruAiTM+wJ/H37ANT2HmJWSiB/4uNrzlYH/zF?=
 =?us-ascii?Q?bwjGi9egye225WC4E1AMWgfnR+FgPvD2mjc8K1WMR1ht1aC1E0rFZuKmRIZu?=
 =?us-ascii?Q?NjbOxOfE1zWe6ETj0nOwSROp0jUCYBog3SKPKJMNgYxMdckl64wF6f0SVpPf?=
 =?us-ascii?Q?dnAT6H1jcxwhAfx3b9SjRCpdcuqU9Vl8pJpnhAv9rzRhRWO6ECbnmO0/aLOP?=
 =?us-ascii?Q?yHbAQ+IDSHQFZzln7iuTzHlgie/G8apntSvv0YrrFxVVAQWG++MmXmL6m04E?=
 =?us-ascii?Q?u2WpLib4odPbUcXrpMb2OUWYlkJYUuf9wk/8qDIbFf0EswDktFsaWGSIYWqO?=
 =?us-ascii?Q?ggUjCaEMndzgx5qaqzlBhZ+SR5n3ItQK4oNcFgJtnZzq3WzeKWQ7DbNkkZ6/?=
 =?us-ascii?Q?YEJsAX5kQGypGJMmbR94dmIWjupxXnPwwadVFVFgAZpfs/udKjEpKOL/VccP?=
 =?us-ascii?Q?1xVm2NS0cuWk28jlrUXXx4/YjQk+k0fszupNMmXukgsiZL9qgajeZMoc7n51?=
 =?us-ascii?Q?TM+m+LK2W5+QMoavzfK8fg95ijubGERMeZH5sGu4XG+ZPykQoda9reBe2woB?=
 =?us-ascii?Q?RQuCevHVC77+B5t54d8x8IRAHnIy5JP7gwN81oF6Z/19w29Y8lrDkcw+l/7G?=
 =?us-ascii?Q?QQhRCs8SoXxblJdfKNEXKrzfZcdm6FGP3jK6lSQhU5Vdn7aOIx30s0AGx3Bu?=
 =?us-ascii?Q?YI2kfciH+FwxVY9TLq4uk0K0TWB3Wswb5YnkRszkTTrNJl4kcZuQmKwhnvUJ?=
 =?us-ascii?Q?nYHReIGvhTEx3tpINu4ocycg+1NS9hcV9kvbk171EG/YWH9F5T2xdDBpFpK2?=
 =?us-ascii?Q?M03ou0W8FTO0Iwt1PlTl6Ha2xs5ozOv5e7w0xNCNI13Hq4ThrQs2WnXcckKr?=
 =?us-ascii?Q?44NYxU+cn223bNQvdsc485zfT5fBOf81lO1MPw4mg8cTNkU+LkzFyRHTkYLO?=
 =?us-ascii?Q?s2g+Yr4cHNtcRPTBkKN7pJS1Agf7Pu0mTh366M//jePh/u8qg0LiWzqrp9GV?=
 =?us-ascii?Q?HmWaZvOEFTD7oChlsY/3YCXdtoYc1P2OvBJI2t/jYYTc7HFBgMSyHMykvlVa?=
 =?us-ascii?Q?aDLIBrxV4eYA/AH5pZgqZyMj5GYSugFjm8jIPXwRyeY1P3vrbWKl1bUKN8rN?=
 =?us-ascii?Q?35UsARPza/NZ2K6JMx+dwvCJSEJa8qEUB/Mm3oaVfMcRh8ApyjzUml6BmOGA?=
 =?us-ascii?Q?MLsXyBpCEEthwAYkRr6nngIZWCqwz4cMQ+h2me+TLNrdUQppt+0dByBdh5JZ?=
 =?us-ascii?Q?GfI8uLjugEVUrDm1A/NI2m3YKhaYG9DT1iJQRqSAYCb9owZbfJmTcuUZdqf1?=
 =?us-ascii?Q?4BSuiVeAc38T2+ShT7omwo1J2hNsB3ZhxHMCHZ6RLAANCnaXrjU+S2KVK7/8?=
 =?us-ascii?Q?rgkRcA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e45d1c-2fbe-4920-08c3-08d9a36eb63c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 10:50:14.7140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k0qfMJ8Tm5jCm1CjAE5/NF4AsRJ58ydkhvTzarapXn72RP5EjFOOw5cNVJ1LQQFIn5+vjAHD6Rf+m71irntZQxRfghNNICNfKU3vGWEWs1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4730
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, November 8, 2021 6:03 PM
> To: Ido Schimmel <idosch@idosch.org>
> Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
> interfaces
>=20
> On Mon, 8 Nov 2021 18:29:50 +0200 Ido Schimmel wrote:
> > I also want to re-iterate my dissatisfaction with the interface being
> > netdev-centric. By modelling the EEC as a standalone object we will be
> > able to extend it to set the source of the EEC to something other than =
a
> > netdev in the future. If we don't do it now, we will end up with two
> > ways to report the source of the EEC (i.e., EEC_SRC_PORT and something
> > else).
> >
> > Other advantages of modelling the EEC as a separate object include the
> > ability for user space to determine the mapping between netdevs and EEC=
s
> > (currently impossible) and reporting additional EEC attributes such as
> > SyncE clockIdentity and default SSM code. There is really no reason to
> > report all of this identical information via multiple netdevs.
>=20
> Indeed, I feel convinced. I believe the OCP timing card will benefit
> from such API as well. I pinged Jonathan if he doesn't have cycles
> I'll do the typing.
>=20
> What do you have in mind for driver abstracting away pin selection?
> For a standalone clock fed PPS signal from a backplate this will be
> impossible, so we may need some middle way.

Me too! Yet it'll take a lot of time to implement it. My thinking was to
implement the simplest usable EEC state possible that is applicable to all
solutions (like 1GBaseT that doesn't always require external DPLL to enable
SyncE) and have an option to return the state for netdev-specific use cases
And easily enable the new path when it's available. We can just check if th=
e
driver is connected to the DPLL in the future DPLL subsystem and reroute
the GET_EECSTATE call there.

We can also fix the mapping by adding the DPLL_IDX attribute.

The DPLL subsystem will require very flexible pin model as there are a lot =
to
configure inside the DPLL to enable many use cases.
