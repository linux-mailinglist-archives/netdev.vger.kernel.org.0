Return-Path: <netdev+bounces-8126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5C60722D66
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9038828137A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E072DDD2;
	Mon,  5 Jun 2023 17:12:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8558F41
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:12:48 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77A2DC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685985166; x=1717521166;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=drYoKVkivoa//uQP8ACElYEc5d1BR9tQEnssJ66MExQ=;
  b=WBXCtwzebAKbRR9Fa9DtkQZYJt408edrll5bSDbLZshK3pwKZKmJNrC0
   KxEmPuQ46WfVp5+nZAAZfARDez6toPFxGbhdTBXevnLbg0Dh/HYZM5Gyp
   LSHEdgMPDQRDknd1ndZ7X3jvDvAvdGURSzbWEAng+N2RIiBa5xwVkMHw/
   Nyy4igwTGjY7yEp/RuTWV2YIDHpIh+5D5PhPkuzqdz/yCZ0AvRGH212/t
   TIy77QOLMRMrGC9JA/v15Geps+1YToUiAiwpG9NUBW7kamK4HyVZ2SvTN
   lJ3OBNfxx0tKgAmDAXrS6DzfpsoCgOqw7G/Ud4S1XtDqKkLrhtWRErzlg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="346020121"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="346020121"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 10:12:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="738431527"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="738431527"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 05 Jun 2023 10:12:42 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 10:12:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 10:12:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 10:12:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj2SnACoQOyvJ9CMU6QrbXrbSDXJgmPnLIx1On6yIIu5tLgpDtPi8sO41gNcZh4NdInpwLOM300cK8MIDQg4wmwAo1/XcGxRQE5DJ5U4LHhaARgGv5gADExgB6H4tkiBIpFfSqeYTPiZK264vIV7CXt0juVSbr+qZEagbpqpabmM9aIeI6M8rtDbt3tJlOdb2Id1BST8WCjj+GbtgbLd/11wdwt4HA4pnNV73qd1tGZYNWxQOBmz6DH72Tywx9Y2F2gCazRYVNn4Hbm5IazJ3GzWRU6aFnchP84EJkHVgd622o5x+JJRJQCtxbuoworpK5RXpGRZqVQYgloCiSZ6XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drYoKVkivoa//uQP8ACElYEc5d1BR9tQEnssJ66MExQ=;
 b=gUnDo+8721+qVBgRlBa4FZt7uhBu7Ax6L1ywaMRLIyDN8GYmrlsJtvfcTAuzTG8nHKtf7Iwqha+89SM+9o6tWa7MWwN2ZEXmwWGIjNMQH/Jpqp8WwgQON8nszPstCyM7GTBS8rfnJhmygtsS8mgwIa2zABGH//q3pEyfj1hmLy53Gsq3u9tlXmo2tkwJOBbu4v5VwUU5idipBJozrqxfXix76AQkuP90DMg8tY/zZYgnl02aNXyBm8b2SaiHZGskRbzRKNcp66sTUr3+Ih9Uy0WmvuKPlrtpPsRBp/9IEfOzEfoKhUf5AWQM0gjtyEAcHFCvaEWsvyqKSD2wQTwAyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH0PR11MB7446.namprd11.prod.outlook.com (2603:10b6:510:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 17:12:39 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::7b23:e512:60c9:ce08]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::7b23:e512:60c9:ce08%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 17:12:39 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>,
	"michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
	"marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
	"Chmielewski, Pawel" <pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "pmenzel@molgen.mpg.de"
	<pmenzel@molgen.mpg.de>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [PATCH iwl-next v4 09/13] ice: Accept LAG netdevs in bridge
 offloads
Thread-Topic: [PATCH iwl-next v4 09/13] ice: Accept LAG netdevs in bridge
 offloads
Thread-Index: AQHZlv6lpVixG3ecq0+3a7IzwK/SPq98b2xA
Date: Mon, 5 Jun 2023 17:12:39 +0000
Message-ID: <MW4PR11MB5776E0183A1A0683D726F0EFFD4DA@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-10-wojciech.drewek@intel.com>
 <ZHy2m2fATV0mXgBT@corigine.com>
In-Reply-To: <ZHy2m2fATV0mXgBT@corigine.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|PH0PR11MB7446:EE_
x-ms-office365-filtering-correlation-id: 44e175f7-d658-46dd-4f5a-08db65e810fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Ax5sGgbNC6zJUvTRXi5x09lr/R+IQ2HrUH0ZJrKwliAVjKJCfwAwOsYhoo/O5NRgvvCkCJKzekm/48SELQ7J+YmvZBMdF4HVTBhEupmVzj61Ert4LrDcnVNm1iKKnjoeLK9fvc3DlgjKzidaAowknUmMW/vfUtii9KCj+JtGt0rdqtAGOkYcaTt7MBzh6gk9RSIBlZJOFTZgnbclwM8hkM60dHlao+BjRJ8eVzd9fvx7V9YmGtXYRS7P2I8xHHG5WILiJVxSnZM5AtkKtyW1Al//IMLzspUnZ4xv7DAPqh2VEy6QrhhgsAhLPIFHYTunTz1bBG5VXvaWbwpQSOO0wuzyS8GZT0FzHdINUKIS5cUPE2oy29ShW5V8zRkyaV/4o54UkATTP0rThjDD3LLRlbx+U+c8apQOIZjDjvjZZ2XeYH21EdfJ7+oLwroButrGazW4z+xMYUxsVRyZkOa8+D/3sW6OBwTga0e7rd1Kl588ey1rCmJNI+oJrY7+TMKBBJIVkTn6AB6K2HwxCeAHScfEos8Qi0o36hInXEEUuPzMqcyWi3meTqJciceULC1u4Bczthz/Iv7UB0OttV0AudFVgrTXeVeFPYe9UWuxd8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199021)(478600001)(2906002)(966005)(7696005)(33656002)(71200400001)(38070700005)(83380400001)(6506007)(26005)(9686003)(53546011)(86362001)(122000001)(82960400001)(38100700002)(186003)(55016003)(316002)(8676002)(8936002)(66946007)(76116006)(6916009)(4326008)(66556008)(64756008)(66476007)(66446008)(5660300002)(52536014)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uDMpTNA4vp3UUHgMrJMAfD81fXj0h5//Thz2hpBWqKLR+BA5Bq1pGdJg7R0X?=
 =?us-ascii?Q?JoodC28HnBiRpN6d6van5nbfh+gi/oFdelVlNHph/wq5vw5xMjhXi8c6y1Wc?=
 =?us-ascii?Q?zErqqVQrbjDJzI8tUnL09FFsAd7g1vqWIk9PjkPYSUvmJATA0nrVN3a2qUyo?=
 =?us-ascii?Q?x6S3EFuFzuBXJqOpBkXNexp5eP+qSxpN1sBqcPaSmBN8qKS4gVm4y834+I1q?=
 =?us-ascii?Q?cTOuzFLWr2Now1jMX2GRD5kC4o7/xKOuK5h+TwMuO6tnUDYRM39fqCBYwpWI?=
 =?us-ascii?Q?DPynY82mO7rfnNEjbjrbzsx0KSS5phKFBnxMbqhMHp7eEpqa+/CY5P0cUoPf?=
 =?us-ascii?Q?s07wAGxrFW2n6h8GWfauOkOfZ+2gH6SPxCRY78R99nQBl8smzosyZ/c/V11J?=
 =?us-ascii?Q?+xYwI8oS2gftcD+a+6/iD9Ewx/g86cvpRdyO9y1TWYnc17+LYaGTKGHVvEHA?=
 =?us-ascii?Q?k8DSMbgEFGgylCrWfrDEt6MxuJcTkLVIVNzr6+30Fzywzsa8HhXBPQ6E3AwR?=
 =?us-ascii?Q?B+235qirHcr7u8mWvgk3YpY0Qq0FWnTUFKZ3pJcdVUHbol6mt3pSXIp3pH8c?=
 =?us-ascii?Q?jSfHcVnvPkUbUMeMFt/M9N2UcBTr6/jTYRjkvusyPHEbzfYxmA/2zbmE2g8+?=
 =?us-ascii?Q?4SGwkfIBrYuF/Bh3rQC5HaKPoGiGA0srQx6mfPmxC25k0WjOm4SNafYbQOcD?=
 =?us-ascii?Q?OJjkiCjquz21FCxfffSVWAZ7YYTp8vSusEQyZf878dgrlPcUZXxYtGL2aF5K?=
 =?us-ascii?Q?9EQt3CL1plFweFdIMLTfLuzsS7D0F4ktKtOJFV3BthPxhwah7IDzqz2ifjnu?=
 =?us-ascii?Q?oD+EV5NC/rIVwtLAh4a71W7O+9GbD+Ilw5MXCSiOJb51IgiD2gRJlJnJanLK?=
 =?us-ascii?Q?/zNqdYDyktQvBPvev2q2P2Md/TODrS3qxNNxBKsZnNLRrzcel2z4W053KI6D?=
 =?us-ascii?Q?my9419fqoskalHklJl+mi878mbFwSmwcsBA15m+KOUs9aMnWWsC9tbMEnPm+?=
 =?us-ascii?Q?VkqnCRFNsbjQshAGh/Y7ajUUioAFmI1UM/+oPQRSxu184Po0qaRp9VYWpIT3?=
 =?us-ascii?Q?9WKEwP6omz4gOUXE4AJt5dp4BTwb9t2VH25TfCQRtBlAIsTx0QHgxiQ3++UU?=
 =?us-ascii?Q?GyV86YFjF8+Ex2LALwVtkbZcqHKs7NibCQpy2bQPFXp+xiTo5ngeUbdp8flA?=
 =?us-ascii?Q?hdjafq9gsRmmm/tKqm/xFMvjaXphEQqmA+QlTzoj+daIntVZ/KFfFXOjLq0P?=
 =?us-ascii?Q?9EuqjGY1FUiEobG9/WIUR+zuhQzoxXlqgd3SEhZ8YWgarxwUOGWb/w0l2f2d?=
 =?us-ascii?Q?Pjf6T+Jwg4oy+66qSH7eNxoFVD9SWLPiHtnU6N0g9z07AYsH3T3fZLgrac9c?=
 =?us-ascii?Q?ZtwLsbYHZIo6emUpbFk2M0OcLEzfvCqWmk70QfJfUlwBiKPD0aPiKiDdbaGG?=
 =?us-ascii?Q?/Wam+j4Oi/UsX0FPxmBadWASp74+BnWusbSakwr37kkTh2RBGxXJHYLWyJGf?=
 =?us-ascii?Q?Zfzo/XxHTPlFt7/cT1tVDQyVkt4/BpTmhV+LjuZMCnxxLQ6N06POhltWEokn?=
 =?us-ascii?Q?pF7BBEx7N1RY/f18+FwqCbV9d93mI2NxfC7GwSRO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e175f7-d658-46dd-4f5a-08db65e810fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 17:12:39.4699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVSEZXOV6TaoJY+nGUPVEvDDu0RXCXSaTFGstaQmfgBNO1vrLRBnhyCDnnDw7OlH7KOrEWGJyovpYm+1a/wLWtEJw69TcUCH4rnUJXaB5uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7446
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: niedziela, 4 czerwca 2023 18:07
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Lobakin, Al=
eksander <aleksander.lobakin@intel.com>; Ertman, David M
> <david.m.ertman@intel.com>; michal.swiatkowski@linux.intel.com; marcin.sz=
ycik@linux.intel.com; Chmielewski, Pawel
> <pawel.chmielewski@intel.com>; Samudrala, Sridhar <sridhar.samudrala@inte=
l.com>; pmenzel@molgen.mpg.de;
> dan.carpenter@linaro.org
> Subject: Re: [PATCH iwl-next v4 09/13] ice: Accept LAG netdevs in bridge =
offloads
>=20
> On Wed, May 24, 2023 at 02:21:17PM +0200, Wojciech Drewek wrote:
> > Allow LAG interfaces to be used in bridge offload using
> > netif_is_lag_master. In this case, search for ice netdev in
> > the list of LAG's lower devices.
>=20
> Hi Wojciech,
>=20
> As this uses the first lower device found that is an ICE netdev, it is a
> little unclear to me how this handles the (likely) case of a LAG having
> more than one lower device, each of which are ICE netdevs belonging to th=
e
> same eswitch. And the perhaps less likely case where it has more than
> once lower devices, but they don't all belong to the same ICE eswitch.

The only use case here is Active-Backup bond which is send in separate patc=
hset[1].
6th patch of the series[2] makes sure that that below scenarios will not ha=
ppen:
- non-ice devices
- more than 2 devices
So the only possible scenario would be 2 PFs of the same nic bonded togethe=
r.
In this patch we want to handle the situation when such bond is added to th=
e bridge.
Maybe we should wait with this patch until the LAG series will be accepted?


[1] http://patchwork.ozlabs.org/project/intel-wired-lan/list/?series=3D3554=
87&state=3D*
[2] http://patchwork.ozlabs.org/project/intel-wired-lan/patch/2023051723002=
8.321350-7-david.m.ertman@intel.com/

