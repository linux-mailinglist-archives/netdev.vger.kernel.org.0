Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73875B0D90
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiIGT5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIGT5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:57:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620D19E2D0
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662580636; x=1694116636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Rb4XoKOam9DJicT5HA87wYF/YIFq6+W/+ZnR/bjYHQ4=;
  b=f8fxHi+XbOsRwcASlaPn3nuPMckfCC3IUgn24UeJSeTIpEht2UrrHV+5
   PSsHthwe4giFrAmiOFMRiF2Q0JMvoPfl5wb6xFxvroizkgvf1Gbn/pdSR
   crvtEDAjsQoCSopBfOI78k311o+Q85KYbDAk8ZMgER4AvfWYy0/h52btd
   KpypN0vuPzKLTCTZCm9t+G7rSrGtbw6G3VZhCAx6d7gFkmZeBD6sj/RcP
   tJ7/xcA2upPfpcRMoWWuJDkrHErMRZvN/bVCoWMJeQD4X/yuurDQIhAWK
   nom1IFAd7/J9MxUi8z9qjHfyffRtpFEfZr8HVs3QZ6xiCS9umAldElWVi
   w==;
X-IronPort-AV: E=Sophos;i="5.93,297,1654585200"; 
   d="scan'208";a="172834089"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2022 12:57:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Sep 2022 12:57:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Wed, 7 Sep 2022 12:57:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUcn/2AjbVIdNouzQ2XpUnBdOSYwDjBlfPWseeSsxTVkPhWxvz4xNn5+3veboMSVK3voOXAoUJ3d3pj+V5MHWf48be4Us1ILY2WbdwS/BlTriJxtfwDXzeS7P9EB1OrXezTwtCu32EFbvRYrJAhuswJAoHKbrCTXcG+lVl+CwRYXTH6A2yfSOGXwnrk5X7VaCB2SJn7EMWbBFfwvJEWfBo6E7ujo/6haz3vUF/98yHb6nQ0TUtlTVgTsTVTAU86XASezSKXwpGHrISJUdIEhEGrUPcYQHZRBBAOnEDoc6isYPfBQwddcFlU8rmN2KAhjm2zlFRQqQuQ5b35ZcZ5Q2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rb4XoKOam9DJicT5HA87wYF/YIFq6+W/+ZnR/bjYHQ4=;
 b=f7FezBXj4jMXyN/U7YHnQbP4RyR/5FAXFNh0jXNKpvxGspRm3Us4HRgyVF9g3Yw1kya5ixEiUSwpR7pbzc6YGch3TAMCY4Pw8DtAnkLdvjqHkcChPAlkyp02//mNb266RX1HwzORuOUbX6X2s31EVPjjs16q4rUUgbdL2KkVcn+X9L0QohHJKPR72iQwqGjUMIkX+4bd1aPJL+Yf/zddJ+EahAjewHN0VxS77OEGQuoxltDn/rXj/2a0UQVKQ32OTUFE3F+NW1+zTilMCyP2pPoQL3c73Ukc4WAloDgdNZ18PZkIwxZi8jpa/zRvBJXTZ6+tQUt20nj6pbc/rPTzsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rb4XoKOam9DJicT5HA87wYF/YIFq6+W/+ZnR/bjYHQ4=;
 b=fcO+UMN6cbWXbSsuJGMa4Efpdpp0JQfRIgO/96RE4bJdbGFvOteQtW+QElJmnBixGiH8aEaQqIerNi0zMsQA6gOcv02fr7xpk3yg6gSbgm9bvnwk6V1rzWP553SnUPQxIY5OZWYxyNE/2S3ZV5ZVQyUQ7+zNlUPP5GRYKWfzjWg=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SN6PR11MB3309.namprd11.prod.outlook.com (2603:10b6:805:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Wed, 7 Sep
 2022 19:57:08 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::b082:2b7a:7b7:3c53]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::b082:2b7a:7b7:3c53%5]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 19:57:08 +0000
From:   <Daniel.Machon@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <Allan.Nielsen@microchip.com>, <kuba@kernel.org>,
        <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAIAAGesAgABY2ICABr5YAIAGp+0AgAeuXgCAAG6mgIAALLAA
Date:   Wed, 7 Sep 2022 19:57:08 +0000
Message-ID: <Yxj5smlnHEMn0sq2@DEN-LT-70577>
References: <87v8qklbly.fsf@nvidia.com> <YwXXqB64QLDuKObh@DEN-LT-70577>
 <87pmgpki9v.fsf@nvidia.com> <YwZoGJXgx/t/Qxam@DEN-LT-70577>
 <87k06xjplj.fsf@nvidia.com> <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf> <Yxh3ZOvfESYT36UN@DEN-LT-70577>
 <20220907172613.mufgnw3k5rt745ir@skbuf>
In-Reply-To: <20220907172613.mufgnw3k5rt745ir@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SN6PR11MB3309:EE_
x-ms-office365-filtering-correlation-id: ae78fc6b-b06a-4b56-29df-08da910b257d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aYkJO/HSfC1j7qr8+7I1lTZbEluqMlqAZexh+39NaQP2jPCPmDghRU6fCZPVv2pEnWNmSLRFd8fWP8A1CjT3mBF7DulgEb1UbcbjCzVEZ2l2tKl7lVmUg63b+e0hdRY8jrCN4OgbGfX/59fNTPjfXpL/1fTC+xEw2HVoit4DevTAMOWyphlnKnTWucOmNLtYO8r+R2KjD5Oj8DfIq+n9u9v7pLmsG/Wvh2symqJuSIwpPiVMPTma8IYessKJhn+2bQc+y/gNOziMPd8ip0cR47eJSlTH0sQ+6jIAg+gfEtRN1qsRNDg6FAYJXD4srYJPDBoxE4Uy+ua4uarN+0QRXzwPlvk8laWPRHWFGarX5hL13tOkopoo7RA4kYz7NYT6qucW6F9ztzjRv+qL5OVZczTQ2jBVzdrfWfZlPA+0vYHNe6HEw9kyYk5a+sAyEdMjk2U3W9U1lhFSI/UPGFfmOzRX6RJck8p13T69oOaLCgzG2+dFsyeWAsrZWPNMu+mSrMSPUUbaaT10B1CGzQnZhgRrHMrwDErvpzFM7qkhsBJ1vELl13qg1YURBi9Q99JXO0FuxFjEKkmWX+VKJf5EMuji2vR9mToN9Qx1IJ5z37BV8CvhXvkMtHndppAl2osdfjAApFh1spnk7ONX1BvK5hr69Q43i3kdCjdM6GaVgsu7hw1IrvKgNwfULpK2c25NJAUVCAcnS3h2UXDSHfzMhFfjadVXp2O32FRQolYH7bbvmArvWyuHaX0OMUxS3pcyMaikNRYmULhvTvQF6zqrCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39860400002)(396003)(366004)(136003)(376002)(33716001)(9686003)(6512007)(26005)(6506007)(76116006)(66476007)(4326008)(66946007)(8936002)(2906002)(66446008)(8676002)(5660300002)(66556008)(86362001)(64756008)(6916009)(91956017)(54906003)(41300700001)(71200400001)(478600001)(122000001)(6486002)(186003)(83380400001)(38100700002)(38070700005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JuHOdfI4Evq39P+K1yFozVfqgNlqKPdkgO407eNpXo/c/tubVu559G4ABxtE?=
 =?us-ascii?Q?RZciD/Amcz942YpqoRYJoZbbCa0Oq9VAnZlAfZbWLgKXTTxWZP4cQKb+JKEV?=
 =?us-ascii?Q?DYuXwI6Xsyy86oth70obVySjP6/4LJrvJSYywdmr/D7psvdoxASJZkGfeQ1s?=
 =?us-ascii?Q?gUvbiwSeQsDCXmtb3W8Vr2ltfXP/OL5BJS2yqhB0lZbVVqj4dhNSm/027JdP?=
 =?us-ascii?Q?M8CTYGoyexZD4JTCz7KUUQbfFNT009F8CNadN5wiIhFJIepEs9q1LYr/up3f?=
 =?us-ascii?Q?waqOXmOXfiz7MBrQxcSfYWnWjMYMwvD5o8sKOWvJjcmOVAtiEN4PdA8+Ti5s?=
 =?us-ascii?Q?Q2cLJzHxufhHKQS461wBabDowzTuYoYeLIhuiXv3Xybj0nV93jWB1kBddAWB?=
 =?us-ascii?Q?UeSLvsrAqNNfHC0p5+sbj1vWPdIN/Zj/ROBqHADNzgIg4fkaALtP1O0YgrP9?=
 =?us-ascii?Q?iSyLswx93jQzr7clia0CEcMqX0TjkT+/PX0gRGXhJAjhTcrabjO7CGsIiNpr?=
 =?us-ascii?Q?j5wlt0pO+zrmD/avEWbYX6he5Hv8iPl+57Qi/bIzVwASuhKFzBJ6Zfvh4r5R?=
 =?us-ascii?Q?3WaIMYvXCXJDv+wzciJJ/c1BY3zllgZyHMRwGSE9hnaoyb7uqeC2kJ/DBNk4?=
 =?us-ascii?Q?MuAS/Kuc21YVfmyJYkKc7iJ7mrlk95thzykqfq2V38BqzfKtYPkyN2ip5UHx?=
 =?us-ascii?Q?EGd3qU2GXQHCryxF9T2OF2B9YOsB8wfCG+Y3kg3t2HQagR6bTuDr7HkxU9Cc?=
 =?us-ascii?Q?8UCo1/poaKBUMPCxeglsrJC6OydMeqOur1zbWJjibfqEWiA7U6SQrBxJMq1l?=
 =?us-ascii?Q?V38l31r3uu9b0rwgfIwCXiR9KOmIkhCLfUcbKgB8T3P3OsZBWivAmiDhCbXM?=
 =?us-ascii?Q?XFcU+mkaUahRNPiwlCGH+ExrZ3iUOFQXtnhnrmKqHysfOeCO/iq+Lb9ZGdqA?=
 =?us-ascii?Q?ZA1UzWiCgh+ytfBugCNTRn8DVtXglJ5L9x12KeRfIwXh/gv2bxHqV6tu0oQk?=
 =?us-ascii?Q?ML0Bm6K0MpFFsNk6dpTJuac6YE4bN49aGkEp86Q2r/bVPYnDbXDlCj4v75G7?=
 =?us-ascii?Q?UceNqqdwrrRYn9bK1bQNrxUzckGCmO3vhw2r3T4105LvmPlwmXumVbbf7mGc?=
 =?us-ascii?Q?oWZgIxzI//B1f3oiImf+fytazJKyV++fiBSCaaQOf9c4pAlERvCnK6G/CrIO?=
 =?us-ascii?Q?XvBYNZ63I5/fwUopA+y/888kw6+s3waubt7u/CsBwHCJIShsOGqnhLs1VyAx?=
 =?us-ascii?Q?EEE1sx0GGmA4zarBffMxjO7wARtcnwL896WIBPlgSzY5Kejt0aWwZXFn0YwG?=
 =?us-ascii?Q?i6h/OqTem26jq3JyUV5Mx01BAUsznLstuF/kTg09f6josWmQq9ipMDCbkXtP?=
 =?us-ascii?Q?3r6IR3PgfdATPRnlksyXcKznZvvRSD8GCd9UzRYuQAaLg4xMZccQC0xAKQ++?=
 =?us-ascii?Q?/HqBPRnDWZ6HSc29aR4lvHUnZFhhvQM1kXacv7QKdFqKb+YDoxBkAf+SGxJt?=
 =?us-ascii?Q?qD0EyUzF2Zap5ujoC1GiGQfTwIlqOypTAEnrwjVi/iY3y1GToSwOuAeCvFkv?=
 =?us-ascii?Q?1ZD5favvONxXkJPNdp4qVjedjclgxvZ4QQ8vK1vfMzrWU1OHBR3oQPWOGjC2?=
 =?us-ascii?Q?tD9hJPZaU4fM3TsT+aGlMa0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7ACCCE4CDA53CE4F9CB1FB2242F47F6D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae78fc6b-b06a-4b56-29df-08da910b257d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 19:57:08.5817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wz/3O0Xuy9uYAXJ8qC0clVeYOV5z5XTAyCpBI0YrZlwVK0vJAO5UN5UKmJ5Lug30tW1WCQUYMHtVBqRPUPXmoDtMGQeKsXsfSgSJbdnj9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3309
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Sep 07, 2022 at 10:41:10AM +0000, Daniel.Machon@microchip.com wro=
te:
> > > Regarding the topic at hand, and the apparent lack of PCP-based
> > > prioritization in the software data path. VLAN devices have an
> > > ingress-qos-map and an egress-qos-map. How would prioritization done =
via
> > > dcbnl interact with those (who would take precedence)?
> >
> > Hi Vladimir,
> >
> > They shouldn't interact (at least this is my understanding).
> >
> > The ingress and egress maps are for vlan interfaces, and dcb operates
> > on physical interfaces (dcbx too). You cannot use dcbnl to do
> > prioritization for vlan interfaces.
> >
> > Anyway, I think much of the stuff in DCB is for hw offload only, incl. =
the
> > topic at hand. Is the APP table even consulted by the sw stack at all -=
 I
> > dont think so (apart from drivers).
>=20
> Not directly, but at least ocelot (or in fact felix) does set
> skb->priority based on the QoS class from the Extraction Frame Header.
> So the stack does end up consulting and meaningfully using something
> that was set based on the dcbnl APP table.
>=20
> In this sense, for ocelot, there is a real overlap between skb->priority
> being initially set based on ocelot_xfh_get_qos_class(), and later being
> overwritten based on the QoS maps of a VLAN interface.

Right, so VLAN QoS maps currently takes precedence, if somebody would choos=
e
to add a tagged vlan interface on-top of a physical interface with existing
PCP prioritization - is this a real problem, or just a question of configur=
ation?

> The problem with the ingress-qos-map and egress-qos-map from 802.1Q that
> I see is that they allow for per-VID prioritization, which is way more
> fine grained than what we need. This, plus the fact that bridge VLANs
> don't have this setting, only termination (8021q) VLANs do. How about an
> ingress-qos-map and an egress-qos-map per port rather than per VID,
> potentially even a bridge_slave netlink attribute, offloadable through
> switchdev? We could make the bridge input fast path alter skb->priority
> for the VLAN-tagged code paths, and this could give us superior
> semantics compared to putting this non-standardized knob in the hardware
> only dcbnl.

This is a valid alternative solution to dcbnl, although this seems to be a=
=20
much more complex solution, to something that is easily solved in dcbnl,
and actually is in-line with what dcbnl already does. On-top of this, the
notion of 'trust' has also been raised by this topic. It makes a lot of sen=
se
to me to add APP selector trust and trust order to dcbnl. This is the solut=
ion=20
that I have been implementing lately, and is ready for posting very soon.

/ Daniel=
