Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCA960F31B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiJ0JBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiJ0JBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 05:01:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EB0160EF7;
        Thu, 27 Oct 2022 02:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666861258; x=1698397258;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NNmZ7gVmcaTf1HX79SWecbqpr9Iq+4safUkox7wqRfU=;
  b=dVpdw8b1Iu4WP7tgeJ2X3nT8esZcPtqz9ydzcmCDUiIG306gv2nZeHaF
   I73bWiCfgSmb3uZQIEt9EBvLviUVOekF0D4zvFsuimCCGVG5POaeFDvqT
   h4WSnTm/q0rCUGl50BB6WY7rWTgmQz5M49Z2TBhu7AMp12Nne2S9obekY
   aTe0MZ6nsfEqsDDQrxaovwnYnNfpXdnkniiJ1OHQM+6nMlfQ34RXAYN6/
   jINXP6QVCcuCiv5wDVA2kc/oTYW3DsWmimKWQW7ffbB9zjMMxL580gjfI
   offnrJrIZhB3uiyCeHhBxbbCO1tBFALotwJhHz8CueZtj++5Yv8oG9w6n
   g==;
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="197251288"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2022 02:00:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 27 Oct 2022 02:00:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 27 Oct 2022 02:00:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgFIfwgupMzuqFj5YPsxHAEpWgbn+TfDGhG5qSwnkJtqKAZOYcR515bM5INWjuPjbd6hBTh/t2qEieGJCMFTZGSb2yac9FGS2b2HSKCbt5SGBq/ESSytpyuMg+ZeA6GcRPGszqmlID0n0A+X28dWpIhhLl4Bnz1ksb17EvnYvnJ+v0QbIHJvh4CC6Na0+zuKtFqtqNRNmYkUJxbPwg7eNgWuIKxUOqJNJxgDiPqrXRHdoc/D59BirNJN8q4CxqKIRlAZN1ZE1icgPbfJU46NpNB/4Dufm9HYBbwYu+PwQiXnP9eU8q/JajTnHc5SlYPAOc6MrAFGBp3u7TCV+kGaEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxbMvjkVTS34LJCgoJgFaGSwYAN3aBe52DaU2yjWdBc=;
 b=noFLnk8euspVOSDZ9O5VNJ/tWYNe3VoHzPZ+YBbGd+8pi/AR5aVcBMCHGqlsI/zsnhdocW/mHdLzpi7y5F0ulmH9CrLhDRp+uLeJNJnvztGWP/l0Vq9+j9I67ptJa70cZwkzusk91gVITxm+kt9+H/YIs7otQqRuHUYBSpO9fDgHFg061T69WUX/3ONUKdZCi0rsGiF9c6S7mFx7W/vuf4vFaBoCIKqk5rtfDbGV9YrZd4di2tDfSeLRzr2SIAZD1iIvhE2QKFHvuLZxIaaXYLIygYY9mzBXTvTSNj8EnRiefCIkvUf5m1B42aLH8tmjWN8MX8BFHkP23joSYPXkrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxbMvjkVTS34LJCgoJgFaGSwYAN3aBe52DaU2yjWdBc=;
 b=i86bgEAv2KXzRHII0JslVgqy7yYFqKgVpOE8jQkoF++jlSlo9rP4Xz+Yl/mmTExaK2yglwhQCEv7bUSp4qZ8GRtuoGkhlanbbCUryd73Lc1j3QGmBOs5I7PfhE0tIn2Y4n9R4EqFl13B90ZrAKsiuyRuy5GJeXYtRYrreLANAyM=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by BN9PR11MB5241.namprd11.prod.outlook.com (2603:10b6:408:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 09:00:54 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::8ddd:7716:ecbd:9e3c]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::8ddd:7716:ecbd:9e3c%4]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 09:00:54 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [net-next v3 1/6] net: dcb: add new pcp selector to app object
Thread-Topic: [net-next v3 1/6] net: dcb: add new pcp selector to app object
Thread-Index: AQHY54e/oXdDISkOjUKo8XH7CRcTxq4gd3gAgAAV3ACAADh8AIABMyYA
Date:   Thu, 27 Oct 2022 09:00:54 +0000
Message-ID: <Y1pLHL/d96VKT3kO@DEN-LT-70577>
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-2-daniel.machon@microchip.com>
 <874jvq28l3.fsf@nvidia.com> <Y1kaErnPh5h4otWe@DEN-LT-70577>
 <87k04mzlc3.fsf@nvidia.com>
In-Reply-To: <87k04mzlc3.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|BN9PR11MB5241:EE_
x-ms-office365-filtering-correlation-id: d1cab282-93c5-477f-b39a-08dab7f9c171
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oYr6yXNUSVdT15bstIztl/zL5s69g7M1J7IhdrDqIhEHW8s747PnEqU/4phTbd/5u646KxvjaOmCnkrsyexM8xlMrlendeo1PC5QysIrtBOjt+QNtuEJR+EKQQH6NTP2kYy1yAC/DOc5IVsfCdTKDmh63cWKCYnAOP3YHFtCehWYSWM2ohbbQxlvMZat2u6Z40gBG9RcmmH8+0g5d7lnD6sA+Pz8gEu5TI8Ey63gv6yPfKTs+TDrTfgnDG5jUdksgK58qB/VkOYKmRtBI6E3KY7JGO4aTvnvLx0U7jo0FPoEBYnMD77c3y4AU9kR1KvJatCrYik/FJu1pg/d+RPtoVVXabqprACpFyT1rFoihKhWeegiL4eiSIkaP8R6b+GKC7ENNgOz3vSybCwNYh0FaiZb0C7wHDE+9U23ioCxd3KYgIpmyO17eeXaKtaXLd/py1U1YjiImGyhlLgIIqtk1vtIssFxaE3khpZItocfs0tPbduyapRdCARIG2a3EMo96Wq8wzzjcLkQon0Chzr3v/Kkb8XGHOHRVssPTVxuUWJuPrykZC6xr19vzdEDBoIym9BVsDB4sUBnTOrvgpX+O5a2IgFAx7Q01dUQLewVY9Kq1KkhCSqRzYzRHhPFKiPlYxZmxptMSPBSCigNmaq4JXfbFHd+exDu5eUPfnwb2da5otWN+Gb0p4Zj8S/GPq3ZG2avvh9RT8OpFGIrnIWvmQ2yp49YopcDhjiaug3KfKBbDmQUiuIGUj/AjdCXW9uw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199015)(186003)(33716001)(6512007)(9686003)(26005)(83380400001)(6506007)(2906002)(7416002)(66556008)(41300700001)(76116006)(66946007)(91956017)(478600001)(122000001)(6486002)(5660300002)(38100700002)(71200400001)(54906003)(6916009)(38070700005)(316002)(8936002)(86362001)(66476007)(66446008)(64756008)(8676002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9Sr9j5mez/zaE9cLXHPkI1zCYa1trgJcQLdLnEzBA5BWLcvHXlcX6emaQgna?=
 =?us-ascii?Q?E6Cm/lGwyREFn7JrGLt4QPb8g2Xy61YaoBEYcI+hbcLiO4JhpbgTHcYBOaNo?=
 =?us-ascii?Q?UUDgTlQMYk+HovrCZNsyXdXYnxgDMlx6d8OFfsHtKja5z3j97qe1eD6raTol?=
 =?us-ascii?Q?L1KJxICGtZqoevgM4Lrly+QRPBT7P6cPFp5TWwG++EK5y5TdAJ5Slagz3dr5?=
 =?us-ascii?Q?TTypCgYOX94QbzR3QBNNGGvnd+iL8Y79ahxkl4WuTzFUIVd46FpquM/ydkwg?=
 =?us-ascii?Q?4RapzzivRlkNXzYsXCjCgJVgB+7UJ5cHi1N6OMQYcSXGxhIQHP2989iKfY8A?=
 =?us-ascii?Q?7UOGcjuHAxpNRRk75I7/yrULKQqm7zfTt58VAxLgk94oJhAapxCg62KmqC1Z?=
 =?us-ascii?Q?jTBeWU29t3yxnDWeyenjSfupMOt4FJh94s11ST9eyJCBxA9fhLVsI8YDmfOX?=
 =?us-ascii?Q?F8dabeS61BFPmV4ctsqURf7VdqvNIhTuTgGWgYPnmXXYPtj0BBt4weJYPuRr?=
 =?us-ascii?Q?RrkiGTVPzc8x8uR5yPQ1M+poOiRWGniCQQC6ekuTZonmeafwTsslkjBmk/VN?=
 =?us-ascii?Q?JmQ36Xc5kvkR/YY5aIHL+7y39oB4ugiB0Zyh6MrimCp1k+3POr2rY9h/a3j+?=
 =?us-ascii?Q?+nXMRR1i6BNGQ1MRTyD7F9AzA72uYSBKHy9tqjqcl5HeMrRuqZw8NptuCdGk?=
 =?us-ascii?Q?+SwNbmtMnfR7bMMhVrePuxP5uMN0L44ym2Fsax6ZjJvQetXFwI/ngBDhkHWl?=
 =?us-ascii?Q?yNWeEYReb5kB7NJVLQdEWTW/wYgMGU8KR2kSPJUtlvtXtDu7nYW6jz9FzYFp?=
 =?us-ascii?Q?5jjW1/1GOKg8CElPKOsEofF/scwlIRJ1pW0OAzx1dG7TuV2jmEW143AVNTM+?=
 =?us-ascii?Q?sz2VGUrsHoX5KveR6ackge7tNSyESPgFxwcrSXaRX1gacoGBfMTHU+LMrbDq?=
 =?us-ascii?Q?tgYEZcEG/lOseweSmbOVsYoFji7hBdxk9PBzsfdt5FP+ecNG1XURqoFjnYEV?=
 =?us-ascii?Q?0UEuJ9eP4D3zeDq5dkDMyPAdI8UsjraXLtzYi+BmBKAGepm3xtalEBPcHLjz?=
 =?us-ascii?Q?YkixQ+FAv3IQHdi2O2n5WAIMDH0Q7IL7jvNPM+3fUu0kNUiS1FYRxbAXWJTZ?=
 =?us-ascii?Q?wqn/imyxSmQb1tkhovy9pLa9t9jwrBqpODWAw9UhEwSEvbvSD1rPfpsrwJi4?=
 =?us-ascii?Q?Y/lzzMC5uMH9mcvTW8DZ/5HA9oB3erTvf7Rn9YXVbS28CaEGR68PZrcmctN+?=
 =?us-ascii?Q?Yu5DWSAqBIQ+vXBMhSNtHiKR1kaLgBX7eAawbZnLcEtu41JndkLW0XVzNpxs?=
 =?us-ascii?Q?OfNi7qWDNFBJlF5IGCWYCDG3pZFxRIK2QaKXdJTLtYOGBEmAAuON2ND6bm52?=
 =?us-ascii?Q?eewH51qvf4RHjXg9fxmF35eEleD+i7z4qUbx5qK0exCXre/wxRazFNeXTB0L?=
 =?us-ascii?Q?4hogmms0Mcosnx2+7RbBrxdQMVIffOeicenj1GipNlxgxei+5Qe1Wqr0mwfv?=
 =?us-ascii?Q?k1WqQm+dlwF+RVeHvAI7shwk7l50TSu+r8GlgQCiLaEy26mhQS2mOVv+V5zO?=
 =?us-ascii?Q?X03Ii67EBBz7P//IXbVPyvuc7dA/m/6VmShWZsfCdOmIoVD5ESN+c2GLwjoP?=
 =?us-ascii?Q?meg3/BoYfDCdCSD+PFGXoXg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14E13D1DC709EA4CAF7B0D3BEB44104D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cab282-93c5-477f-b39a-08dab7f9c171
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 09:00:54.5915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cvKAL2iPrENEEUX+DUgVuRziQRkpxstF1cmnP52+gX7/g/CRDbM3h+0YFICdXOMOJQ2W4BsH56KiWAfnDAOuwno77wE7KJwUQbL1y27iSvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5241
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> I'm missing a validation that DCB_APP_SEL_PCP is always sent in
> >> DCB_ATTR_DCB_APP encapsulation. Wouldn't the current code permit
> >> sending it in the IEEE encap? This should be forbidden.
> >
> > Right. Current impl. does not check that the non-std selectors received=
, are
> > sent with a DCB_ATTR_DCB_APP type.  We could introduce a new check
> > dcbnl_app_attr_selector_validate() that checks combination of type and
> > selector, after the type and nla_len(attr) has been checked, so that:
> >
> >  validate type -> validate nla_len(attr) -> validate selector
>=20
> This needs to be validated, otherwise there's no point in having a
> dedicated attribute for the non-standard stuff.

Agree.

>=20
> >> And vice versa: I'm not sure we want to permit sending the standard
> >> attributes in the DCB encap.
> >
> > dcbnl_app_attr_type_get() in dcbnl_ieee_fill() takes care of this. IEEE=
 are
> > always sent in DCB_ATTR_IEEE and non-std are sent in DCB_ATTR_DCB.
>=20
> By "sending" I meant userspace sending this to the kernel. So bounce
> extended opcodes that are wrapped in IEEE and bounce IEEE opcodes
> wrapped in DCB as well.

Right. Then we only need to decide what to do with any opcode in-between
(not defined in uapi, neither ieee or extension opcode, 7-254). If they are=
=20
sent in DCB_ATTR_DCB they should be bounced, because we agreed that we can=
=20
interpret data in the new attr), _but_ if they are sent in DCB_ATTR_IEEE I=
=20
guess we should accept them, to not break userspace that is already sending
them.

Here is what that could look like:

	/* Make sure any non-std selectors is always encapsulated in the non-std
	* DCB_ATTR_DCB_APP attribute.
	*/
	static bool dcbnl_app_attr_selector_validate(enum ieee_attrs_app type, u32=
 selector)
	{
		switch (selector) {
		case DCB_APP_SEL_PCP:
			/* Non-std selector in non-std attr? */
			if (type =3D=3D DCB_ATTR_DCB_APP)
				return true;
		default:
			/* Std selector in std attr? */
			if (type =3D=3D DCB_ATTR_IEEE_APP)
				return true;
		}

		return false;
	}

/ Daniel=
