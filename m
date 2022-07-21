Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A6B57C63D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiGUI22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiGUI2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:28:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E382A7E304;
        Thu, 21 Jul 2022 01:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658392100; x=1689928100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tr4VFwD43t7uMExqLkD9qMzy1rcdQr2U0S2DUT4K0Qs=;
  b=ZML71aKm5k+v1V5B4b9MNZIGbQ7LAgdI2Fz1Bj43RgyGV9kzlz5xIAJj
   d4ugyIUfwO5+zg6SOAvr2RB6TS6J/ta/zOuz+ffMyventSvCUBqYtwIe8
   YHVsQ8lNr1Gz+HdiRgnkD/UYGnqo9Xr+ssmddoV83Mbg0NyzGHPfCEhhW
   7s4lyVNcRP92PmuEGobOpM9c5eca8ifactfH/k5iQ+VLalkq8GrqjF5AR
   TVsjB0eOs4DdtNedknzueXLRWQVBeiPy/bTmRlo/t+6xYjgVoABAv1tP0
   QubHu4mKdTk7V/njiSKfMXzUvVISEuQ960ztrWzvaxSHlhDMvyFFAgEhd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="273832020"
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="273832020"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 01:28:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="595525593"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 21 Jul 2022 01:28:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 01:28:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 01:28:13 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 01:28:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djkCMesKqpf8R0NiS48qEvT4G85z4aBBhGL2/h8uojjRVYrXPYhmADEy8jaYMN+UpjS+m+BaKGpiJYr6wKL6KJ1AEWMR4C4fJ62HaGPEUkE7wyoZOq2rxxqt53uXrIMcg1FOqnMqcqqWCS/d0EBSRc/VEY4n3TqAlgmtT7I+vXiqJUIkmxuIoialRYnBx3lCGhrqEE6KcIJigR02hj6aCGG8dTOLmRjC4OtRGpESZtXJql5dzb9O/UP5J2MPed2JQ0xluY8j4rCSwgIMRXzzCg/9u1VUarwh/W+AATTGaiKlpqs2neL66Oh0ptAKWMBOTraTDutf1B54SjSM944zUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fyhQQTxvv78eFUt5hwjL0hJMcyjSyyPNXk2Yaq9ASU=;
 b=PQmOkiWgDo+rIm2hBrrcNz1pGmPyTOVB5vALulGBPIjHm4cwW/l9X+sDAzxshF+Tq+cEDImYe4436hq6CeXKgRFD06FEvTpj/62b9AppD2Xd8ZddhGh0RyIfRsfbsy4cZBooC3qSL5HZffL4Ev9dm16S/Ca0v5kqLMv82ex+JI2fvbKppGHJaZ/EYt5y4F/kk8Lz++pbn0390mNKiL8lJRyAKHCD9TL2X9Y12t2lMmxCDDrcHHoxL+Vxb3kg5ulX7W4/QaG5PC+3pUkb+ApR21RF+N0tRAMi4svQjnBh5tGzy4fjeS605GbW30+xTciwLH6il6PXyAtALxeBMUToPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3856.namprd11.prod.outlook.com (2603:10b6:208:ef::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 08:28:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5438.023; Thu, 21 Jul 2022
 08:28:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 01/11] net/mlx5: Introduce ifc bits for page
 tracker
Thread-Topic: [PATCH V2 vfio 01/11] net/mlx5: Introduce ifc bits for page
 tracker
Thread-Index: AQHYl1nDxarbX5uS9kKeacihkojz5K2IiIHQ
Date:   Thu, 21 Jul 2022 08:28:11 +0000
Message-ID: <BN9PR11MB527622A46E2C50C13E7AD4708C919@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-2-yishaih@nvidia.com>
In-Reply-To: <20220714081251.240584-2-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3217f6b2-ea40-4465-3f7f-08da6af2f2fb
x-ms-traffictypediagnostic: MN2PR11MB3856:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j8XEGKEk3ZzAja427710DH06MJ1kG7AgbrmejlmC3F0z43bLMa+AyWhZ5gRKsBMyU+AK0LLSaZwy8K7hJs+DerqNAg7eIjUlvemZecYKlOD+ILZxZuchXqpWY/Rjw44MnovgpTG8m1jNbxbju+RoqYdFBBqMuCxiDMEptXuKww0CunWox2+v6C1XiRSUS66dreBGU9Qg9RUMq8iKn2QfCu+LiHCcQ0KsvjanaCsC6IokE3vy0vSOU8B+oPFPkgfxho99pRAND26KlWt9gaoklsCoOdMsSa/tbJdz4yu25DU+9BSUNN1RrYDSgWIw6QviqemYjraavboE6BPaQd7dVEDNDPMOueKy/EVP1DkmVVmUQPS4E8pulijbeZQqZVNLdK8wxd/0CfnenN7UOfnts27HpDmUcgY6qbMEIqOCMZWbZUesaEnzj5YkSdB+7UtaI1juwnxFEFVjEfII4WdTZWIbw4xm39qDZ/fX8/sssu4SjxnUj+Uu2Wiplxaf2BaFIBl1nARyoVkzJAnxfbsDSJJTMnMQ3O0cFSeuB9xyzPvfWpVS5T4g7nKaraFnU+vt8nPTghPXv9Ub5RwCWuCfCOXtYaIONfM+WhYzFe0v/Ct8/SXsxIjk4OKibk/MQed2vzhnu2VW0N1sD+Fi0W9K6e7tzBa6+z2R4xCiuWS5AGCKAj9olROF04SXBavke9e2dNM4Th1/QbMUvzWpPE/Qu+NrhRlhVZwO3W/qMLmkWbpG5EblKxVoy3g3T0x02k43ZhWockEIicO3dMwc3L+FFmGySHxNyBHsn4zDnkAjfx7x7IAMMjXtzsODnIgqXTsH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(366004)(136003)(376002)(2906002)(71200400001)(38100700002)(7696005)(6506007)(122000001)(76116006)(66446008)(66556008)(86362001)(33656002)(26005)(66476007)(64756008)(55016003)(66946007)(8676002)(4326008)(9686003)(38070700005)(8936002)(5660300002)(110136005)(52536014)(316002)(54906003)(41300700001)(478600001)(7416002)(82960400001)(4744005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e05Oi2AHedG0tY8H/qA7pkbbkrpU0vuVF5tTeQUxAAaOdIyccy81r+p+Avz2?=
 =?us-ascii?Q?IlB5rcIoGdYug2Gz6YEWM2h/c/GiBHdIfwGJUpm/QQ2MedSEXAu4ZGPp+79k?=
 =?us-ascii?Q?UNKqQkGUII90TXiYMLdKvdsZkeoc9FygHmVfc5qp1gqNMgEqOiFv+FewHms3?=
 =?us-ascii?Q?3a+mznAZedQmUubyKq6k28KaAsikOn35R4h8pXY/83jXdsSaEP+0GZ1w8mXh?=
 =?us-ascii?Q?tYqy1Sx6OLGefg1BSHJGSByyFf7Io6dch0BAByzG0KDSU1cD2oiBfcnbpYs/?=
 =?us-ascii?Q?6Dh9eB81NM4ZH86r7HYHfn2WrxckorKgxnX4zVR0bjFUIgKdDjfigv5GpZoJ?=
 =?us-ascii?Q?Fq3+ztY5bBUAd6xaF9CqLOwBdCPGgYccyF2arc4w7hIFeTftz5JSOKvW9ByE?=
 =?us-ascii?Q?xvth8Fr2e9t31jpBjzwxugHZZ2AIcXsA0nSTdkKjvH7e+aTzwCk7c8jmoDEr?=
 =?us-ascii?Q?lk9/mBG/xoRMaB4m53Jxt/MY60aEfuN/QnxrwtBfEvxD2++yrvxdmSWvF07S?=
 =?us-ascii?Q?j/ukJ5nBdPBTZtLjiRKAJepHN4Y/X6F5hGU28z2/B7p+kSux5DQFhOtq2D7B?=
 =?us-ascii?Q?pURnDtvD/dvHslioZjSL6fLFSCjLUTJGVZNKXtCMr066yOIM5lFwOmj4dUs/?=
 =?us-ascii?Q?uYqUeY1PyFn0LsQoAEuwtOO5ZpRxVb7ruP1Ou7dk4Lv3ASNJjlAtW9wHwX+x?=
 =?us-ascii?Q?mW5rca/+CIw9m+4k2i1vHlUIXcnh8gYrVzaO3fYJbPa9pm4Ztl0Eq1hR0O8f?=
 =?us-ascii?Q?lrFNrZ6rrXDwvQ8ZoWnxCnNurmEDXRI3XSukfNR6QZq5vJG8r3x7VLLLaPd7?=
 =?us-ascii?Q?hlKCZJ5GwMBa/qbfvN7NC2DoUFzRNvN22QLk48domRPDAkScVAplfo0B91FX?=
 =?us-ascii?Q?eYzPtk5HA0sG1wgHKVU4GDdtw3RBmON0HIrBRddP3wgeT9XRKfPDC7zRr76q?=
 =?us-ascii?Q?mjOj6hPCjYvuZ1fQJKVFeDa/hL6HuIXzrr70SCqZ2Thdliux6enPPb2w6VOi?=
 =?us-ascii?Q?XXXyKljPvn5CtTXWOov9gjx4PcsowcSQ5h4JlShUlQEcTAFOadRUmRdy5Stw?=
 =?us-ascii?Q?WUzJ8nSEpAAtWTLyZvXUfvy918uRrcIIRCq0PLeTQqBej2aJ9MjyZgQpWiIs?=
 =?us-ascii?Q?OmXrRrWzp2bTitzzk4yUFddA1/DWiSknOeJ7n8YX5hixBR30x386p7OKANBX?=
 =?us-ascii?Q?yXmhhnXxEq6kqclGDr4Y9J1vc8DFFwGr7e4guIJzlr/2QMB+SIgLIK0VuPC/?=
 =?us-ascii?Q?AtPeLQP5KIWLg9MXtQYtOoQpFQnKnoeWaW5AV7X+VtDI9WhKGt4oMq31fG9B?=
 =?us-ascii?Q?iGlG+x/Bp3TZRANpIPSQMxDOkMB0J4ZpchlaSzoZvW/GsJVfS+qPbPOILdHc?=
 =?us-ascii?Q?34O80fpOjie6Ug5uTBg+JeqDQQk7fl0CrIdP8QMrGYaJ3XJpiBng+BinZXP4?=
 =?us-ascii?Q?gEnWQogbcUr6iu3ZNQ4YG3AK1OzAYzL1dViqx63zrMax/+ck7K3zXqQ6xNct?=
 =?us-ascii?Q?gZirjsAu7DECeAqKXdHOhuaPHZ0lvajV08Sz5GEmP8ZpvArtzsIEAvFFY6a1?=
 =?us-ascii?Q?8Sh5efSRpcbHlo9yETEo1UNOA9WtyUJ7N7fAs47b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3217f6b2-ea40-4465-3f7f-08da6af2f2fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 08:28:11.7059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: chobCxaVokHD+TRl8JVf5ZbQDOaRLm03TLtlIXRtaAf8ap8zZEiaiE3mWQsN8pYWANJ50BtOZcDg96MXJ68SBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3856
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, July 14, 2022 4:13 PM
> @@ -1711,7 +1712,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>  	u8         max_geneve_tlv_options[0x8];
>  	u8         reserved_at_568[0x3];
>  	u8         max_geneve_tlv_option_data_len[0x5];
> -	u8         reserved_at_570[0x10];
> +	u8         reserved_at_570[0x9];
> +	u8         adv_virtualization[0x1];
> +	u8         reserved_at_57a[0x6];
>=20
>  	u8	   reserved_at_580[0xb];

any reason why the two consecutive reserved fields cannot
be merged into one?

	u8	resered_at_57a[0x11];
