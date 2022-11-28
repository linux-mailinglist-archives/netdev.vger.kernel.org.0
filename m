Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E67E63B13B
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiK1SZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiK1SZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:25:22 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B278EB1
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669659441; x=1701195441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ai3FiTEeRL6jNBTjBJwxzZCqnJRJejagGdqrQBvte/k=;
  b=JwJBxAiwnHKztSZp7AOJmO9ELsNXBac0QZZhAL/TUS9X5G9fdBDPWm3f
   glq7UCwnkNNfglsmMHeSFzXL0g6FiwViq32vXRe4mGJe166pCtWkQCws/
   4ZQ8D6zjS8ubAcnrhCJojpoJirc8wA8U+d7uczrdLA7M6h1WFPwzt76EI
   iwQn/c68WL+tGGXB605Aoq/iQrGC+xKxjabglotyDJ8kq0QftHVRlzYAv
   UYavQnwpG0LvCV/F4+yYgPYCOsYAr7km5f26sXFXeZ6u9MOIt3JY7TaVQ
   /KVP8QP1utcFkIc/z4sJ8b1/2zl7nmudwAvyPxkqg5WfE2V7CGHlOKnIJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="298265863"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="298265863"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 10:16:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="637314242"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="637314242"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 28 Nov 2022 10:16:31 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 10:16:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 10:16:31 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 10:16:31 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 10:16:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VblSRLZhnHhN3gJ8DEwPEE4fm/DtVNOq/dlUMgzg/Erifdnrx66OmHs2zd2VaCASar529dvG/Wgozh5ns0qTpYKhx9CENeG3DAM/OHY0WTKw7KRYp810ZCE3TO/jDpEGL5+lZmS5hM4h29XXZGdQUxgcXHZhVVse/H1dlhJ+ETNbgUkWP6C3VaIDgac3Aux+crWkbdfg01vRmnDAEUmSTTgZRfR/fv8JhMzD4/FJOoIn0pu5IBk89LmTce6IPx4EmqwswuzvDKEdap55t682r9HYR+WKpAIF+wW6KDLSextYmwQkKwgWuGaUswp96YDQVkKRp0t0WCMAXi9AjPPvTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+WTwqMr4esQBbGZtBV0L+6vqpoIUS28cGp70iUrv2Q=;
 b=mFPc+a//XY46CqyP5J5vcxfnWYNGMOn1mJ5k7uvwlPd+TdwheFeqzENBN0FF8QwoPAzRDCwbay68L5j6M9XSEu5prAuUWF3433nHXEb+u0aORZVYCq80QORuIxiYyk+ZQsNixFjqTuRBdLX6xBqnaVa0j7rRtk89lz7Kw3wan814jeRlPF0IcMOY3DR2BUSpSuGegtxxUAtoB9QD+k4nrgZLzXvK6YbbflLy4CQPRMKr4TGzL9BdB1hYcgzVgMASXwdXdCzIl3CB/4xq7hxkNxZt4HRav5IQ2AJwBuYdFgG/wKRjoHAcdsGyvBhSWocmBjcfCm31VZciFMhwdjnP4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB5392.namprd11.prod.outlook.com (2603:10b6:5:397::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 18:16:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 18:16:28 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH net-next v2 2/9] devlink: report extended error message in
 region_read_dumpit
Thread-Topic: [PATCH net-next v2 2/9] devlink: report extended error message
 in region_read_dumpit
Thread-Index: AQHY/3uWJJs8+HbM4k27dRv5WjUsvq5Nw4iAgAboVrA=
Date:   Mon, 28 Nov 2022 18:16:28 +0000
Message-ID: <CO1PR11MB508953E890CF3EC111E1B325D6139@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-3-jacob.e.keller@intel.com>
 <Y38vZ/AuQNI0uPjl@nanopsycho>
In-Reply-To: <Y38vZ/AuQNI0uPjl@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|DM4PR11MB5392:EE_
x-ms-office365-filtering-correlation-id: 3bbc829d-2ff3-46c4-d712-08dad16cab5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CkA2AaXGAruAhlSjzJqvu7Xu6G4sXaZwCOM5r8vRyarmXwSnRd9ZRYGkYo+N3jTZxMWOJ+KVurC+i2GAcwQkSACuEg38q/ijCtrOTUkBQlEX6LDKK1LKwXKA1owJs8Mx1HQaHO+pqHOcQfzR2IwYiaC1vJZ6O79t1Wh06PKmJO1KwV99KNcZJeyTMoUkRAkF0vpHiUphNK9blV7uQIKgfCUs81zK09ib1OxKnxUtFWc8qc33HY00Xc35leNXIv6K7kTbT9yAQNblWTmA/9jmFRA6SwiBq7pvE99eMkVSZukL394bxRbHtgAXAKs/en9lfc8oNTKB0BLUcR0csrY8RRmlbS3W1MoCZd70alkz9slEaBmtzN9hrEyJo605zaI5Pc9u5Hxutlwb/yVXk80AU89SixyrzI2ZUUGAOjeL0SpDeh97ej6oJ2n4R2KLIFUdJs4hCdhgj9u793Gq3C9jerfdMHKwE0tPGdvV1HfWRA/IWKy3yTqx04BimhZmVehgiJ65gdgESxoiQB9WZi+NkbMS6H8X55IsP5Qr2/u2/h795b3RnKB6zngQNlM4e3TBKmlTFyTZSzLAySyh8CXquYbt0OaS5wr3htpe+DELehGQ6ZT+sLbtJvILF9uWaOBZOaqlydkd0/4Ge7Mqn2xct0AN6Em69WReU5YbDg5bxkBFlw4Rul6AoI3/Bzbc7198
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199015)(478600001)(53546011)(83380400001)(2906002)(71200400001)(66946007)(15650500001)(6916009)(54906003)(38100700002)(5660300002)(38070700005)(122000001)(8936002)(52536014)(6506007)(4326008)(41300700001)(7696005)(66476007)(66556008)(86362001)(64756008)(66446008)(82960400001)(8676002)(26005)(9686003)(76116006)(316002)(33656002)(55016003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PLqLYZxb9AmoEXKJ1nHE9FtJLfY0rRF/YUL8DOcdWo2yitmPsPR3p6WnJOsZ?=
 =?us-ascii?Q?Qu84TXKdZxiH3Ug3GfZn0G2cWlJim5/zyQWvwvNrHtFry6Vi9tnvzz5vGIkQ?=
 =?us-ascii?Q?iqUqi90lx8A/CjA2j7o04UAaviW2RC//8gEGL9DII/nhEtoAgXAyocDcM1JT?=
 =?us-ascii?Q?+6QOCcqTN90pf3QDlcYEOXueLzf4q70OL9banYcMFU+3FwvBC38016Ri2N3I?=
 =?us-ascii?Q?tdmEhD7W8Nb4kqWE/GwxCEQQVEYQMZ1ri3TKkzzrI8AScEIYE2LldaI9WuaE?=
 =?us-ascii?Q?Vp29TnsuPl8axreH7PoNdCFZSQmn5Hv0GQ4FtbzTnka0uS6Gr+RFJ1zoqOQz?=
 =?us-ascii?Q?I6oBUQa13b3BrA3aesqBZs/7NF5xVjgzI72WknQMydFs0pvOQEHQ3hH5t1kY?=
 =?us-ascii?Q?RoxyOMusEk/dkGSTkrgWlD8Go5IFuY0Sqmj8UF7ECps0YQ6sS+jbcZTM1zng?=
 =?us-ascii?Q?6AGJeC+TaBpzVUFMVVb+GGS7pfXqdpNN4e047/oz+BPk0O2z3Vf9Ve1AGbTk?=
 =?us-ascii?Q?Sp0WNfny8iqsNQcp6qrRgwE3LFjO3DnlxNN9b7zp4lUu99M17BPGO0/cccxH?=
 =?us-ascii?Q?mTAvaWOToMARUr6uN04yZgL9tRF3aSYAmu/sgDvspQkqm/vbqEw2BuSBG5Gi?=
 =?us-ascii?Q?vC8O6N1YXT/oQ4KdaOpg1fPFTuljofsvdU9Iih6X3RMrhi9MbbhXci8bEOLV?=
 =?us-ascii?Q?e5t7L4uKkzAqILYJm6//VX3oRO+SYQ7fdVs712JXEE5GwPFUmCbxKp4+zSQz?=
 =?us-ascii?Q?skUpP1X0TTsXCwsoXz38PDtU3Y9r90oJHNFBz0xQz40hY8B1a4l+Xhr5P+ee?=
 =?us-ascii?Q?x79sssptRKA+DOShvkPVcpqc9/Ox7u0RuYnHIEG0StbthRI456R+1Vcbr+bx?=
 =?us-ascii?Q?wvWcO8PHBoK4cqCqRwlNYnEDbWQX6r10VGOenr8yChQCtyhxR9yqikPPKNnZ?=
 =?us-ascii?Q?ghMr/XWKWKdasIgdkm18n0SyF0pvVA8WG5yLd6tpBPsx2WZViHmuUnLtvFor?=
 =?us-ascii?Q?ZtuHCTSBdo3L933+FCYESZkGNYepj7c1SKz0pLnIgx9TP6oB0Pt2+fSkmJRb?=
 =?us-ascii?Q?VFUZ72iFZSpryoZBFlel0wH61zgohOTIsTRtBSKBUcHqRCMYlu/qIrvpzHFv?=
 =?us-ascii?Q?RGjCxXL+diJZskd2ZS31BBWh4FXXUBJo18HiJSw7imXa36ZfBmAemp4IGbmR?=
 =?us-ascii?Q?S9FrTqGFX0wUGvD3V0+YqNaJKezu+9kirJSwXL+VMvVTV298fKUIGpLsA9/E?=
 =?us-ascii?Q?WKYYTxSBDHxHo7A/3XhE6hptSXnhOAnKrApeN/dw+qDAXj1pjwJNnSez5vUi?=
 =?us-ascii?Q?OcTTQHK4IO9Ru1hFen3xyYWGVo0865YIOkb0/VetTD4QAd0zM1agvyenNmb2?=
 =?us-ascii?Q?w4xzpKPMfHeQryFkP6nY0UXD6bRhBM5sQH1D+5DuE2I03uBkhvjfcozOso/y?=
 =?us-ascii?Q?gwS9UvAfMwNkre8h+8IiP4rVh/+rqyQ+mRtxXpn5ZoOiPne784ME5Y6H/ldd?=
 =?us-ascii?Q?E7lzqxrIO2qaxO6Bp3WiiU2tVz6D6k/K6/HqtaCmWOgcQg8SQNiTXxil6q/j?=
 =?us-ascii?Q?Fbet97AHWAWGYi6w4KYQapEmzY9Ou+4OE+yaRjEW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbc829d-2ff3-46c4-d712-08dad16cab5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 18:16:28.7892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QAMOVVl5rZ19Rb58tMbF/mXA44+uU3s3SUM3lT05thN2ZCjVgdj1G67ceW+obXmJVe3T1YDNQN+xi1oekdEZWJ6z9KDDWwABLfIbahz73sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5392
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, November 24, 2022 12:47 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@nvidia.com>; Jakub Kicinski
> <kuba@kernel.org>
> Subject: Re: [PATCH net-next v2 2/9] devlink: report extended error messa=
ge in
> region_read_dumpit
>=20
> Wed, Nov 23, 2022 at 09:38:27PM CET, jacob.e.keller@intel.com wrote:
>=20
> [...]
>=20
>=20
> >@@ -6525,8 +6525,14 @@ static int
> devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> >
> > 	devl_lock(devlink);
> >
> >-	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
> >-	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
> >+	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
> >+		NL_SET_ERR_MSG(cb->extack, "No region name provided");
> >+		err =3D -EINVAL;
> >+		goto out_unlock;
> >+	}
> >+
> >+	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
> >+		NL_SET_ERR_MSG(cb->extack, "No snapshot id provided");
> > 		err =3D -EINVAL;
> > 		goto out_unlock;
> > 	}
> >@@ -6541,7 +6547,8 @@ static int devlink_nl_cmd_region_read_dumpit(struc=
t
> sk_buff *skb,
> > 		}
> > 	}
> >
> >-	region_name =3D nla_data(attrs[DEVLINK_ATTR_REGION_NAME]);
> >+	region_attr =3D attrs[DEVLINK_ATTR_REGION_NAME];
> >+	region_name =3D nla_data(region_attr);
> >
> > 	if (port)
> > 		region =3D devlink_port_region_get_by_name(port, region_name);
> >@@ -6549,6 +6556,7 @@ static int devlink_nl_cmd_region_read_dumpit(struc=
t
> sk_buff *skb,
> > 		region =3D devlink_region_get_by_name(devlink, region_name);
> >
> > 	if (!region) {
> >+		NL_SET_ERR_MSG_ATTR(cb->extack, region_attr, "requested
> region does not exist");
>=20
> Any reason why don't start the message with uppercase? It would be
> consistent with the other 2 messages you just introduced.
> Same goes to the message in the next patch (perhaps some others too)
>=20
>=20

No particular reason. I'll fix these.

> > 		err =3D -EINVAL;
> > 		goto out_unlock;
> > 	}
> >--
> >2.38.1.420.g319605f8f00e
> >

