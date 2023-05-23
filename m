Return-Path: <netdev+bounces-4559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 629EB70D392
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D78128123A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B071B918;
	Tue, 23 May 2023 06:05:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5533FEEDD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:05:35 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6CA109;
	Mon, 22 May 2023 23:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684821933; x=1716357933;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=USrSgpFudtIh1zu5LM051yf6/jRGQyjwYAPtPl8I6LM=;
  b=BvDZzTK2oAwwxCwQeGCDqPhXE7fIvgtYcgcdOcrAOVchrvPoN2kPT7l9
   NsOKTvQiAfogWT9f1Liu2rrYWduw8eKS9Zjtly90BxZEjfA+35y7p1TAu
   raZJmiTLam+WIG2DIiOLr29Z5SIkSkSuLNMtOMf3KK5oRpWGEpcbeHuaw
   TegIHnqCEU1UKQwJuVSlWQwPua2/Ib3NarEVIOwguPL3G+mUK25uDXaHA
   RUOgCnBnH0rFLFyv5q0GkdWipSzkmMWJqMdgfkiBcAbr1ZIaKyzDQsdg4
   5txl5Xfs7EH9fVergsv/h+6RGBONJFprQQpmcNL3QpOkqxXbqUCEuwMQA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="418847875"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="418847875"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 23:05:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="827962281"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="827962281"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2023 23:05:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 23:05:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 23:05:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 23:05:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 23:05:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRsrP5bLUrpv3A2oqCFXxDuXCvxHJb7IOJdm8SPWjDYmLCa2f1NazVdEib82sQnkz4kU5krD0c1Z/RHEn8CmtILWpd1LfGtZyPArkLCC0ph+q9smkbVqGomQ1NAeTqbfhoKgKBfsQxbajwtFsJwsSqzXdkhxldIYXDUiMBZOb+7AosEz+xxeNHUEeE9QCF+SImBnnkQkByzfOjHGaz3OAqNuKG7qf7SNyaV27y3lwNk+dWNnabyneQptmp2caOND4h3XEQbI8P59ObvAOcIgN+B3tmG/NrQEV7wha/oLRn7RGjjG9twOzItzcRAp0pRMEXMLRI2115SipJ68TCPhtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zriA/jUbB4ZLcNNVvefPR3wUX6/uHXcARFmbkG0Fz8U=;
 b=TcCOWLjcAWntxW4gtnOpkYFKKIEN05yBRoW6QYVH4A79WZCipuGOfXKOm5PxIUJE1QiwfaWguNdIXLvcNXSfNdNGGZMcNn3lv8Eib+JxsYYgIMAebQcvgIXrQojVCqRDcJc/OyiUKOiWjiIiyoZz4CoZalT/byVFcVr9ICwR0zvtS32lTYXtAjZS+5nPWw1gZEYinfZ31v8Mgrjba6vwWD2rYPFIYbr6OF4oSZHwCdPg40F/8G+ZqWun+50mtVRPcDNuj8eyjfHnZcX1ggKZaOpYfKH2zqpgUo0S+o1j1oHgQxQr0so5eqXcMBKEGZJJrTXcSMtCxxDKHsPfuw5sNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3306.namprd11.prod.outlook.com (2603:10b6:5:5c::18) by
 MN6PR11MB8196.namprd11.prod.outlook.com (2603:10b6:208:47b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 06:05:25 +0000
Received: from DM6PR11MB3306.namprd11.prod.outlook.com
 ([fe80::30a3:dce6:e690:19ef]) by DM6PR11MB3306.namprd11.prod.outlook.com
 ([fe80::30a3:dce6:e690:19ef%5]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 06:05:25 +0000
From: "Gan, Yi Fang" <yi.fang.gan@intel.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, Alexandre Torgue
	<alexandre.torgue@st.com>, Jose Abreu <joabreu@synopsys.com>, "David S .
 Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Looi, Hong Aun" <hong.aun.looi@intel.com>,
	"Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
Subject: RE: [PATCH net 1/1] net: stmmac: Remove redundant checking for
 rx_coalesce_usecs
Thread-Topic: [PATCH net 1/1] net: stmmac: Remove redundant checking for
 rx_coalesce_usecs
Thread-Index: AQHZjSqMA2vw48oBS0GjjLvxixFw6a9nXhhQ
Date: Tue, 23 May 2023 06:05:25 +0000
Message-ID: <DM6PR11MB33060877F8CE38E1BA65EEA8B9409@DM6PR11MB3306.namprd11.prod.outlook.com>
References: <20230523035548.188651-1-yi.fang.gan@intel.com>
In-Reply-To: <20230523035548.188651-1-yi.fang.gan@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3306:EE_|MN6PR11MB8196:EE_
x-ms-office365-filtering-correlation-id: e5b3e58e-19f5-424b-fd44-08db5b53b354
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l8s1oSm0R6vMN85JhQax0b5in8nlVN8m2mlgPsv5CXnMnLGR8MyBdeZJYoUZENjvXt5MVf0sr3PJpuyEpMJC4KS+nPRBoUr/kXVQNiYvoMx6qx5WlXX+zFaeVpqxuUBC31jF6f8l1YLw/W0jlhGH9pFZmpGpo1pI9pNIPIua1SX5y8ON5m3lU4Yv7mE2VoKf1i92i5fqQY9UDa+6io1JDbRZ6ERajBp38a7RnhFKcZcn2ty4639WzlD4aiLIec8TG9nLzR7WtRFA5FXdPMrxyyLIV8VoX7YQwXVNaVgGyJn76YArCSLXRbtvrqPb9fg2YhJdgVsxA7dGAmOaX5qZJYQw/syQXuyIDOyjDAYi6nBedv4gKNC6PKqC1ulj8eIa1QBYQOg5l95gkLgfG73dcWi4lwUETHuq05I8cLTeOIfhbTryVcU7Z71a/RcGmTegWARGQASxT5fw5GrrQaMpSrF54UiBtl+3cRpIqSSX14StwXZWo09QqwmNPiX3q2caV9E3yvrCrrMMpgeIn6ZV5FPuXS4G7FLPtIo2MmEFtz9jj+uGIb+E/H2qqJJHdupuKYXRItpLd7I8yJSnuitVZ9VTH7eh8hg9xbP4+nDo9jJgKychWjmac6bHa+p15MIC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3306.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199021)(83380400001)(186003)(2906002)(4326008)(66556008)(76116006)(66446008)(64756008)(66946007)(41300700001)(7696005)(316002)(66476007)(54906003)(478600001)(71200400001)(110136005)(53546011)(52536014)(7416002)(5660300002)(9686003)(26005)(6506007)(107886003)(8676002)(8936002)(55016003)(38070700005)(122000001)(86362001)(82960400001)(38100700002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NYwgFF70RmFw62JbrwKDIP7EZpMXvXyO0/fwJld3+4p8kaqDKca0DQo5OqQJ?=
 =?us-ascii?Q?dokmPglURA+wd99boSTY5Q/B7yPELXhfR1yTTDWk/CiR8zOEi1NcCyx0JOnK?=
 =?us-ascii?Q?+D67YYZIyci6hVqTyXGBXUliPeKBtquBAZSIQpijj+aFWlO8x2rU7xsUvCpz?=
 =?us-ascii?Q?R0tHQg0iIIiBxS55VPfrwA80pzNcNrwByNNWEOj7js6DdU/vES4gN473u8N4?=
 =?us-ascii?Q?Hcv3M4u78fTn60n0K11xzEOBP5Vr+cg36tbMDU3Zy3hKF7bFlH1ORNIIMtLK?=
 =?us-ascii?Q?HqavqzhjZf4AgE5tEFbRIJKNsC+cf/gCTZ81ZrkU9aTKn1MSRpoljxsoX60l?=
 =?us-ascii?Q?+SkZsRthkuvTZThg8+Yj6lnj/bGzayK6koc9jYnu8fFaCJsLrY2dPZqe7X+M?=
 =?us-ascii?Q?WpJdTpkkXLUYLLcYkDLj7l8lhrowvCgsWNiDUGkZ6WfQjQayUly762sS0DPW?=
 =?us-ascii?Q?ZdEyfIMg36BjtXZ0DcILMM+LU8Qx6/Hq7gsF613KsUQfjzDRYtfJ+vQ6s1f6?=
 =?us-ascii?Q?HrRtESDNiFc7LwGVX9MNvwDVzen8+Na5WUT0/mFR61ZfAWLQO38NYzIPvDKq?=
 =?us-ascii?Q?hKFhURhqXy700di6W4vL7dLoxHPe0rrjz5KTYGK+sPklH3dHAYT46rsb3AMa?=
 =?us-ascii?Q?aACW00Yl+LDNpiLEctA5mqdW5tce7pg8tXRPdyjUHh51GkymA2fJ6xlFKOwy?=
 =?us-ascii?Q?CsmKdKaeJB0vzQYbddf5aXpBV7jfjOEQ2p8+wIuOMxJx++keAIL9EHnhjdO9?=
 =?us-ascii?Q?zR7IaC0efNU0/Kv3c1QETzzrWqo0k8ZNQX24JXj0RJ+dsGpCWhVZEy5azxcY?=
 =?us-ascii?Q?ii3u5MYjB0TtV8BJfJBCYYfc1rjRF5r2BunUDLHHga5c1PoFU8brg2+I5Ixx?=
 =?us-ascii?Q?caWfoWBdj4afY15ZDOQm5DXTLm4fwARGCP9JhI0nU6SecvgYqj4b9xGZZjmf?=
 =?us-ascii?Q?gHTgUXxEK25Fose5wzCmuEnSQYEZtQC0efqUkOIqJ2JDpbKShLfMo227BSkN?=
 =?us-ascii?Q?5AaiCsnPeXG/p90y/rDTAgeWj/3jIXeOG8D63r8oBEkIXxtlYH2LZ3yBlLPx?=
 =?us-ascii?Q?4K3/OpJ8CnfjRaKmHtNDpZoGDgihSzOPGf2EDs4TVplsXQ8wHqMvss11qjYN?=
 =?us-ascii?Q?itvlEtC43Ujuea8taaJNigWp44wNL48MHkh53LBY4aKmxgFZTnw5AsXiPZtG?=
 =?us-ascii?Q?UkX25iKQ8+1EHX5CLv27RmjDxbloIbtO4DZs7jph6kRi/6sqBRZAoEkV54/m?=
 =?us-ascii?Q?Aa+I5WtD8cTmSvGJgwd2u9tGUgwcCPl5un5w5sfVtwVWiJKbWIwymxuSxjQS?=
 =?us-ascii?Q?mugYlaDJUcYD/p9UVTbTsJvbMu4MvOHzKWlg8HZxKRaLDFvsRrm2u6kjq566?=
 =?us-ascii?Q?bYlv/P2npOD0m2VNDeymHeed7gWMqYS+dC3tVCTcY4wpT9BmiemjKiacV75e?=
 =?us-ascii?Q?T+gZW6o7HqR5gKZAuUlZ1oDdbVrIiWGnejYAqHMltk0mXyXzbIrofdG6lql2?=
 =?us-ascii?Q?/mzWkz1KhVGO0QtsuU3yThO1F2kZBBzqKwktaPB9FgrmpI7b6LLr9ttJo7Qz?=
 =?us-ascii?Q?sglGmfY1e/LgbjdSEhQXpmtokbLkcyGQPEKyH5Q3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3306.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b3e58e-19f5-424b-fd44-08db5b53b354
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 06:05:25.1579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kFmykcD8bZx6Lbxkg7rxRIV6l3RScgSp1TJPS5/EzZBG5NDLWjLabYZKw0EKbaJYBJfNsuzBWAcsuDjd31CWuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8196
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Gan, Yi Fang <yi.fang.gan@intel.com>
> Sent: Tuesday, 23 May, 2023 11:56 AM
> To: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>; David S .
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>; Maxime Coquelin
> <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,=
 Hong
> Aun <hong.aun.looi@intel.com>; Sit, Michael Wei Hong
> <michael.wei.hong.sit@intel.com>; Gan, Yi Fang <yi.fang.gan@intel.com>
> Subject: [PATCH net 1/1] net: stmmac: Remove redundant checking for
> rx_coalesce_usecs
>=20
> The datatype of rx_coalesce_usecs is u32, always larger or equal to zero.
> Previous checking does not include value 0, this patch removes the checki=
ng to
> handle the value 0.
>=20
> Signed-off-by: Gan Yi Fang <yi.fang.gan@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index 35c8dd92d369..6ed0e683b5e0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -917,7 +917,7 @@ static int __stmmac_set_coalesce(struct net_device
> *dev,
>  	else if (queue >=3D max_cnt)
>  		return -EINVAL;
>=20
> -	if (priv->use_riwt && (ec->rx_coalesce_usecs > 0)) {
> +	if (priv->use_riwt) {
>  		rx_riwt =3D stmmac_usec2riwt(ec->rx_coalesce_usecs, priv);
>=20
>  		if ((rx_riwt > MAX_DMA_RIWT) || (rx_riwt < MIN_DMA_RIWT))
> --
> 2.34.1

Hi All,

Please ignore this message. The patch is targeted for net-next instead of n=
et.
Will resend for net-next.


Best Regards,
Gan Yi Fang

