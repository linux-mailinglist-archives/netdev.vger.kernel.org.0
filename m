Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF758102E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 11:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbiGZJnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 05:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiGZJnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 05:43:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41F431391;
        Tue, 26 Jul 2022 02:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658828619; x=1690364619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F7L5/YxEIztwvHMeEmtw6mEXwddrutFQaV2Cojamgao=;
  b=hxdNaJ98pVFkhwM0xbF6KA5bWlkl3VGz3VXK9ZDI1YSXgeMv3qy+orCa
   ieZpoO9VVS55KnylGLuwy0tkZKs03hU5+L073n/FCz/aVDjwpsqAPY9JJ
   6BCPN8cCUBEPziztFV7VVEzFl7A7/yIJT7AeAI3FNHme3VtexHd3GfbHv
   oQIcevvxqvSid6g63vj4+62/jMb9hsR86J8bwA6ET8uyPnNtIgUtZh28w
   6CxvxZW9pd9l3WFRXBOy38I2jjtQzZzZhsO9/eu13nqYDYyFLv9pM4WjG
   9x9zKjgimVQgt+ewqmYxjOR5NrErSvyE3MQCvFH3bwQ9M+uPwqGEcPsBP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="313671557"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="313671557"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 02:43:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="596964827"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 26 Jul 2022 02:43:39 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 02:43:38 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 02:43:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 02:43:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 02:43:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQz2sBGV1UVKMnYgzUIjMBa+PHQftey74FafhgKxFP7UzLxHC5RZy+OaP08F01ick91jtGqfnylNMqpdROJ/W2b4oq3OVVS0/w0gQaiYTjJcpfBGMOFCobVAY/XzrmTdEIgPAOFdk3wEOHZhiDTJgOnu1IFbgaYNDSg/X49NFoF02giS5iYY3SVUY/ihwR49NQfSl/xHC37GwCt6vV30N4lcRZPUKT+L/WFT0W4/PR3e72SWM/U+1BV7Ss2iw/O2qL/FhSB+b+1zU13KZUzYQPa918x452zeNlRKP83WLS8WCqJY2RvL4mcpoGx5HgEdTCj2CYUtN9QzKKAr5KVerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGpkmdd5BRdKkt206MZitFvlNtfmWAOIs0fhTRxcVc8=;
 b=KbAbCUuIBfq0ZST2Y1h6IHwD4ukZ4wlyWS3CeTM10GGvETknrf+62UDzIUyJxraK/oaMTIPs3gdiXG5R/DW10EGXVYYkSaP5i8zi2TUwO2Z6xlF8jjJ7BybX5TYnaeBNXMsUeoXx1z7KEyWkNXp75FwlRHLfw/vhUHOwLG8XQnR2MX2D4tecKBQmbf7IhV+ZQ1LWE0PiYI1m6SrkJcTA4An+MU+p7dh+CbTNi4JairUzl8uJVsFBhWJTOvEML7TCxlTVADDtYErTT50a9OD9NTWNRn1eHnd3XBsSERChjFqh13SshZGlZX/iTfl2THZdroY5eS1eJAXSYe8DdCj2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3995.namprd11.prod.outlook.com (2603:10b6:5:6::12) by
 CH0PR11MB5691.namprd11.prod.outlook.com (2603:10b6:610:110::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Tue, 26 Jul 2022 09:43:36 +0000
Received: from DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::4df7:c35c:7387:c82c]) by DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::4df7:c35c:7387:c82c%5]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 09:43:36 +0000
From:   "Koikkara Reeny, Shibin" <shibin.koikkara.reeny@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Loftus, Ciara" <ciara.loftus@intel.com>
Subject: RE: [PATCH bpf-next] selftests: xsk: Update poll test cases
Thread-Topic: [PATCH bpf-next] selftests: xsk: Update poll test cases
Thread-Index: AQHYmozD9Km0bnyrNEyqNWtE2fFuDK2KdhGAgAXy+NA=
Date:   Tue, 26 Jul 2022 09:43:36 +0000
Message-ID: <DM6PR11MB3995991A0874B1FEFB384376A2949@DM6PR11MB3995.namprd11.prod.outlook.com>
References: <20220718095712.588513-1-shibin.koikkara.reeny@intel.com>
 <YtqxJ4f1osDc1Rtg@boxer>
In-Reply-To: <YtqxJ4f1osDc1Rtg@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b182e5d8-0183-442b-1534-08da6eeb502c
x-ms-traffictypediagnostic: CH0PR11MB5691:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qbd2YMtxnkb7ONihDolhlZmdnw2YtSytUtKIjGUkmgam5x684G9ouTv6tFfT2YHeWHBu8b3v7HEAlb7zxiBDIKwrOHQTRsld8n62pjrVqkh55ny6v2QzJHBYFWvq4jfgM1u4c368G9iixzfMpEqxzF4zlwJfRFxnbqBwp/KOzfvFmG4XlT/CaKjazfTZYlCGyDexiWgdl2W3jbi8TAqJ5QXm7WvFXDut8mE6c/TIdUQiL0pjmh76yW7XI8KMSDiEULoTjNf83CMMyLEq7SQxGcU3GWLRPkQC+AJ/6kTZqw3+GEQAuHGnPhlLBm0q5DODdbGXdid3qcCdVpkwYUgchTtfqeXNjCubF4Kua6+7fXvR+L2wAhyiShNHuS0PNHUEb4py7YbuLRaM22mXgqoor/KZ5aR4o/6IZuuXu+vEaiQO62n+uLKPuLIOmtI16yX0vlU66/fY/kffU21tJ65vlW5rC0nN/pvHZhK9g5YLMDmnqjFVbVjCpbjvbNF9Lq0OVh+0Q0lrpEeDfDoNOn3jPHmkfQk8YgdIYstdYiBXSXpRhfVdmB7gh1wzhhXwcapxQzV3/E9VCZYKKWd/yXGO2hdzeuXm7JonZTTRn6eCnFvZ9yXtE/hbizjdCXShBZBMSLJ/FfWABXIINg+kto+fljccPpqIAW39PXLl5l9plNm1MsdbI6ls25VhnT7aDqoatwaw573+kApS/EBxLjqfPpQuK+8QWq0Z48Uw2TLwb3hf9TwTsu8ynC8wXPGbgyZnXow2YsiHvjTcwUSWkCkWj369bx/eAzJXa+tKxsmj/H30ugAbhFWGJ/3yquNsGYqdjEFizAhnxWfOmT0AiUYlzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(39860400002)(396003)(136003)(8676002)(41300700001)(15650500001)(66556008)(66476007)(4326008)(71200400001)(66446008)(66946007)(64756008)(76116006)(30864003)(5660300002)(52536014)(8936002)(6862004)(478600001)(55016003)(186003)(86362001)(38070700005)(9686003)(82960400001)(53546011)(6506007)(54906003)(6636002)(107886003)(7696005)(38100700002)(2906002)(83380400001)(33656002)(122000001)(26005)(316002)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e3AIMMREAH3zHCHlG3LWOKIVZOw/YyhmHdPjBnqEfioJ0eVnJMO5L/8HoL1f?=
 =?us-ascii?Q?+9T7oLHHd4TZOrE8DRBWbgRiD67xOuAo59EA2Hbul4mP+ZPwF2EmQ7xXBB9O?=
 =?us-ascii?Q?v/TaHaEO0BXKxXs1aQ13DyuIa3EufrtmQ8F5XFzRnMIR0xCpPzXn+nl1kgOu?=
 =?us-ascii?Q?XGUCoVZkQsKIekFcIf1250zXrAHuHWH3wufs5qeRVEy+xBM+8jkDYcgu0XiD?=
 =?us-ascii?Q?anxWJHkPh6+M9EfikBZU33O038wSnhzxJBSExz3UA5gxOujIoVz2zbgLsmL5?=
 =?us-ascii?Q?VlHUYC4fFN3mG8nlYVcJ39XYwsHludrhFtB2/noM9C9d/JLbtFeeTaf5STk8?=
 =?us-ascii?Q?Uh2/wZaQ5alHSZmHQlo7n347bnkeLa8Qlhcd6AM6JvPF3wT35RaCh8rQSsW8?=
 =?us-ascii?Q?Ds2KoGGdP8BdcgdbcqzA36lLevScjtONLjRsQK3QdmAOIMWy8S/JljWVB6qv?=
 =?us-ascii?Q?7RTElO/8H0wwnNsOQewMKNDf9YOElw7UN3zZYU0wd2QXwpoHKAw8s2NNw/nl?=
 =?us-ascii?Q?TXJ8d7/UTOuilQ/PVcC6CBRXmc4BlEZ74hMEKudmuP488GQoZjsISnYZuoMJ?=
 =?us-ascii?Q?W3HkdxvcCPZoThCmSx/uz5JGaUObFVHus41ElahjV5SoBOQfkQ5BGj7c6Apv?=
 =?us-ascii?Q?ZLT4wzg6zA5/ibz0tthRPzFsd6HbytcMGqYLPuFOBEq8NJLHGmE+QZRdxHUV?=
 =?us-ascii?Q?2siSqpQkCKYMGytR8JN3LZJNPvvnRdlDRdFvLCBGF0oAgXPb9F5cuVvT1UCB?=
 =?us-ascii?Q?lXDASRxJNBhKJMRKpawuDvXXMd7QBz9eP1hi9qNgPCrAZJwbN9NP5YYizJpN?=
 =?us-ascii?Q?9VaeJwcr0pwtKDGgolQQUD51tSB8bhQSQ1McuStglGarPMYnui7ucroFhF0T?=
 =?us-ascii?Q?TBVSIhPiwwffdyPFqNIT4lfCcsJG8zWkJafHrKLFIniQCzfpQSUHdIqtXeMl?=
 =?us-ascii?Q?Wul5Zj3p7jJ87Vx6zUaIRF+obG76nB4WtzkSWzA41AID2juIVi0dVnjX6j7B?=
 =?us-ascii?Q?Y4OeeUrR0RXc/lBfwLWXp05DgLzcMh+dTWsKZRddKh1jOH4qXw1oXgxPJh4p?=
 =?us-ascii?Q?XIYBGD/kFHCrZlIhmVgzU/9UKlu3p6UM4j1MK6FGBbxcoNh6haM7mciZeg16?=
 =?us-ascii?Q?kYXlNcBBxypDIgPJyV+yuCLKAFw8NN0VxChjjbP1q1p0B5xa7kDsB8H7SM14?=
 =?us-ascii?Q?9F5mvugF3foB9iONEo/MhQSTI5slEZBYc47raAXykAJPLSDV5CPmT+o5Poka?=
 =?us-ascii?Q?5ZhF7fJrgGyzkoZbYjvcF0/M3ahdIuTXK+92/gvMSi/XxeYixr5AaLapGYrl?=
 =?us-ascii?Q?cFBHq4ZjkKrIfcAEYzLRov5SUHFzsoFJy8AAD5uTrTZEyBsUdNwCONTWxSKB?=
 =?us-ascii?Q?jmBvG7KEsTf0/OFW78CVDajG1Xbam7L7+Fh4IwLWcjRzVfj4oTCHyuVrwJC4?=
 =?us-ascii?Q?tvKo/GAMCZNwPWG4vG/sIukF08LRJT8VA2SJwnWUj4+0n40avo+c08pz5q4i?=
 =?us-ascii?Q?HVHJEbtaHb8VrYJEJvhYYSzXVeSJ6E3sWYdK5JOLWDoTszRL9Zz3vI62OpLo?=
 =?us-ascii?Q?Pb0jI4HBqXCnlPeX7Q1ywKjS9fST7Vq6sBO25d1YFTV8TSVbup8cy8WX35NI?=
 =?us-ascii?Q?OA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b182e5d8-0183-442b-1534-08da6eeb502c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 09:43:36.7001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8gFKnIoEl3VeH37RzS4tl91dNBgxqoeYQHkdp1Kim+m7aNPr9YOJiSbnKXl0X9bJIVp4OemUul/eqckDTCbP8a0HIlqUXdEKYUWjpV/G0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Friday, July 22, 2022 3:16 PM
> To: Koikkara Reeny, Shibin <shibin.koikkara.reeny@intel.com>
> Cc: bpf@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net;
> netdev@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>;
> bjorn@kernel.org; kuba@kernel.org; andrii@kernel.org; Loftus, Ciara
> <ciara.loftus@intel.com>
> Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
>=20
> On Mon, Jul 18, 2022 at 09:57:12AM +0000, Shibin Koikkara Reeny wrote:
> > Poll test case was not testing all the functionality of the poll
> > feature in the testsuite. This patch update the poll test case with 2
> > more testcases to check the timeout features.
> >
> > Poll test case have 4 sub test cases:
>=20
> Hi Shibin,
>=20
> Kinda not clear with count of added test cases, at first you say you add =
2
> more but then you mention something about 4 sub test cases.
>=20
> To me these are separate test cases.
>
Hi Maciej,

Will update it in V2=20

> >
> > 1. TEST_TYPE_RX_POLL:
> > Check if POLLIN function work as expect.
> >
> > 2. TEST_TYPE_TX_POLL:
> > Check if POLLOUT function work as expect.
>=20
> From run_pkt_test, I don't see any difference between 1 and 2. Why split
> then?
>=20


It was done to show which case exactly broke. If RX poll event or TX poll e=
vent

> >
> > 3. TEST_TYPE_POLL_RXQ_EMPTY:
>=20
> 3 and 4 don't match with the code here (TEST_TYPE_POLL_{R,T}XQ_TMOUT)
>=20
> > call poll function with parameter POLLIN on empty rx queue will cause
> > timeout.If return timeout then test case is pass.
> >


True but  It was change to RXQ_EMPTY and TXQ_FULL from _TMOUT to
make it more clearer to what exactly is happening to cause timeout.

> > 4. TEST_TYPE_POLL_TXQ_FULL:
> > When txq is filled and packets are not cleaned by the kernel then if
> > we invoke the poll function with POLLOUT then it should trigger
> > timeout.If return timeout then test case is pass.
> >
> > Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xskxceiver.c | 173
> > +++++++++++++++++------  tools/testing/selftests/bpf/xskxceiver.h |
> > 10 +-
> >  2 files changed, 139 insertions(+), 44 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c
> > b/tools/testing/selftests/bpf/xskxceiver.c
> > index 74d56d971baf..8ecab3a47c9e 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -424,6 +424,8 @@ static void __test_spec_init(struct test_spec
> > *test, struct ifobject *ifobj_tx,
> >
> >  		ifobj->xsk =3D &ifobj->xsk_arr[0];
> >  		ifobj->use_poll =3D false;
> > +		ifobj->skip_rx =3D false;
> > +		ifobj->skip_tx =3D false;
>=20
> Any chances of trying to avoid these booleans? Not that it's a hard nack,=
 but
> the less booleans we spread around in this code the better.


Not sure if it is possible but using any other logic will make
the code more complex and less readable.

>=20
> >  		ifobj->use_fill_ring =3D true;
> >  		ifobj->release_rx =3D true;
> >  		ifobj->pkt_stream =3D test->pkt_stream_default; @@ -589,6
> +591,19 @@
> > static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info
> *umem,
> >  	return pkt_stream_generate(umem, pkt_stream->nb_pkts,
> > pkt_stream->pkts[0].len);  }
> >
> > +static void pkt_stream_invalid(struct test_spec *test, u32 nb_pkts,
> > +u32 pkt_len) {
> > +	struct pkt_stream *pkt_stream;
> > +	u32 i;
> > +
> > +	pkt_stream =3D pkt_stream_generate(test->ifobj_tx->umem,
> nb_pkts, pkt_len);
> > +	for (i =3D 0; i < nb_pkts; i++)
> > +		pkt_stream->pkts[i].valid =3D false;
> > +
> > +	test->ifobj_tx->pkt_stream =3D pkt_stream;
> > +	test->ifobj_rx->pkt_stream =3D pkt_stream; }
>=20
> Please explain how this work, e.g. why you need to have to have invalid p=
kt
> stream + avoiding launching rx thread and why one of them is not enough.
>=20
> Personally I think this is not needed. When calling pkt_stream_generate()=
,
> validity of pkt is set based on length of packet vs frame size:
>=20
> 		if (pkt_len > umem->frame_size)
> 			pkt_stream->pkts[i].valid =3D false;
>=20
> so couldn't you use 2k frame size and bigger length of a packet?
>=20
This function was introduced for TEST_TYPE_POLL_TXQ_FULL keep
the TX full and stop nofying the kernel that there is packet to cleanup.
So we are manually setting the packets to invalid. This help to keep
the __send_pkts() more generic and reduce the if conditions.
ex: xsk_ring_prod__submit() is not needed to be added inside if condition.

You are right we don't need rx stream but thought it will be good
to keep as can be used for other features in future and will be more generi=
c.

> > +
> >  static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts,
> > u32 pkt_len)  {
> >  	struct pkt_stream *pkt_stream;
> > @@ -817,9 +832,9 @@ static int complete_pkts(struct xsk_socket_info
> *xsk, int batch_size)
> >  	return TEST_PASS;
> >  }
> >
> > -static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> > +static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds,
> > +bool skip_tx)
> >  {
> > -	struct timeval tv_end, tv_now, tv_timeout =3D {RECV_TMOUT, 0};
> > +	struct timeval tv_end, tv_now, tv_timeout =3D {THREAD_TMOUT, 0};
> >  	u32 idx_rx =3D 0, idx_fq =3D 0, rcvd, i, pkts_sent =3D 0;
> >  	struct pkt_stream *pkt_stream =3D ifobj->pkt_stream;
> >  	struct xsk_socket_info *xsk =3D ifobj->xsk; @@ -843,17 +858,28 @@
> > static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> >  		}
> >
> >  		kick_rx(xsk);
> > +		if (ifobj->use_poll) {
> > +			ret =3D poll(fds, 1, POLL_TMOUT);
> > +			if (ret < 0)
> > +				exit_with_error(-ret);
> > +
> > +			if (!ret) {
> > +				if (skip_tx)
> > +					return TEST_PASS;
> > +
> > +				ksft_print_msg("ERROR: [%s] Poll timed
> out\n", __func__);
> > +				return TEST_FAILURE;
> >
> > -		rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> &idx_rx);
> > -		if (!rcvd) {
> > -			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
>=20
> So now we don't check if fq needs to be woken up in non-poll case?
> I believe this is still needed so we get to the driver and pick fq entrie=
s. Prove
> me wrong of course if I'm missing something.

xsk_ring_prod__needs_wakeup() =3D=3D>  *r->flags & XDP_RING_NEED_WAKEUP;
This function only check if the flag is set or not and it is not updating o=
r
triggering anything. In the original case if flag is set then trigger the=20
poll event and continue.
In this patch poll event is called in any case if it enter the if (!rcvd)  =
is true..
We don't check if XDP_RING_NEED_WAKEUP is set or not.
=09

>=20
> > -				ret =3D poll(fds, 1, POLL_TMOUT);
> > -				if (ret < 0)
> > -					exit_with_error(-ret);
> >  			}
> > -			continue;
> > +
> > +			if (!(fds->revents & POLLIN))
> > +				continue;
> >  		}
> >
> > +		rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> &idx_rx);
> > +		if (!rcvd)
> > +			continue;
> > +
> >  		if (ifobj->use_fill_ring) {
> >  			ret =3D xsk_ring_prod__reserve(&umem->fq, rcvd,
> &idx_fq);
> >  			while (ret !=3D rcvd) {
> > @@ -863,6 +889,7 @@ static int receive_pkts(struct ifobject *ifobj, str=
uct
> pollfd *fds)
> >  					ret =3D poll(fds, 1, POLL_TMOUT);
> >  					if (ret < 0)
> >  						exit_with_error(-ret);
> > +					continue;
>=20
> Why continue here?

You are right it is not needed. Will update in V2 patch. Thanks.

>=20
> >  				}
> >  				ret =3D xsk_ring_prod__reserve(&umem->fq,
> rcvd, &idx_fq);
> >  			}
> > @@ -900,13 +927,34 @@ static int receive_pkts(struct ifobject *ifobj, s=
truct
> pollfd *fds)
> >  	return TEST_PASS;
> >  }
> >
> > -static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
> > +static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, bool
> use_poll,
> > +		       struct pollfd *fds, bool timeout)
> >  {
> >  	struct xsk_socket_info *xsk =3D ifobject->xsk;
> > -	u32 i, idx, valid_pkts =3D 0;
> > +	u32 i, idx, ret, valid_pkts =3D 0;
> > +
> > +	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> BATCH_SIZE) {
> > +		if (use_poll) {
> > +			ret =3D poll(fds, 1, POLL_TMOUT);
> > +			if (timeout) {
> > +				if (ret < 0) {
> > +					ksft_print_msg("DEBUG: [%s] Poll
> error %d\n",
> > +						       __func__, ret);
> > +					return TEST_FAILURE;
> > +				}
> > +				if (ret =3D=3D 0)
> > +					return TEST_PASS;
> > +				break;
> > +			}
> > +			if (ret <=3D 0) {
> > +				ksft_print_msg("DEBUG: [%s] Poll error
> %d\n",
> > +					       __func__, ret);
> > +				return TEST_FAILURE;
> > +			}
> > +		}
> >
> > -	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> BATCH_SIZE)
> >  		complete_pkts(xsk, BATCH_SIZE);
> > +	}
> >
> >  	for (i =3D 0; i < BATCH_SIZE; i++) {
> >  		struct xdp_desc *tx_desc =3D xsk_ring_prod__tx_desc(&xsk-
> >tx, idx +
> > i); @@ -933,11 +981,27 @@ static int __send_pkts(struct ifobject
> > *ifobject, u32 *pkt_nb)
> >
> >  	xsk_ring_prod__submit(&xsk->tx, i);
> >  	xsk->outstanding_tx +=3D valid_pkts;
> > -	if (complete_pkts(xsk, i))
> > -		return TEST_FAILURE;
> >
> > -	usleep(10);
> > -	return TEST_PASS;
> > +	if (use_poll) {
> > +		ret =3D poll(fds, 1, POLL_TMOUT);
> > +		if (ret <=3D 0) {
> > +			if (ret =3D=3D 0 && timeout)
> > +				return TEST_PASS;
> > +
> > +			ksft_print_msg("DEBUG: [%s] Poll error %d\n",
> __func__, ret);
> > +			return TEST_FAILURE;
> > +		}
> > +	}
> > +
> > +	if (!timeout) {
> > +		if (complete_pkts(xsk, i))
> > +			return TEST_FAILURE;
> > +
> > +		usleep(10);
> > +		return TEST_PASS;
> > +	}
> > +
> > +	return TEST_CONTINUE;
>=20
> Why do you need this?
>=20

__send_pkts is expected to return TEST_PASS or TEST_FAIL to send_pkts funct=
ion and
if returned TEST_PASS then continue sending pkts and exit when all the pack=
et are finished.
if returned TEST_FAILURE then test failed and return.

For TEST_TYPE_POLL_TXQ_TMOUT  TEST_PASS is return value when timout happene=
d and
should not sent anymore packets and break. But this will break other test. =
So needed=20
new return type TEST_CONTINUE to keep sending packets.

> >  }
> >
> >  static void wait_for_tx_completion(struct xsk_socket_info *xsk) @@
> > -948,29 +1012,33 @@ static void wait_for_tx_completion(struct
> > xsk_socket_info *xsk)
> >
> >  static int send_pkts(struct test_spec *test, struct ifobject
> > *ifobject)  {
> > +	struct timeval tv_end, tv_now, tv_timeout =3D {THREAD_TMOUT, 0};
> > +	bool timeout =3D test->ifobj_rx->skip_rx;
> >  	struct pollfd fds =3D { };
> > -	u32 pkt_cnt =3D 0;
> > +	u32 pkt_cnt =3D 0, ret;
> >
> >  	fds.fd =3D xsk_socket__fd(ifobject->xsk->xsk);
> >  	fds.events =3D POLLOUT;
> >
> > -	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> > -		int err;
> > -
> > -		if (ifobject->use_poll) {
> > -			int ret;
> > -
> > -			ret =3D poll(&fds, 1, POLL_TMOUT);
> > -			if (ret <=3D 0)
> > -				continue;
> > +	ret =3D gettimeofday(&tv_now, NULL);
> > +	if (ret)
> > +		exit_with_error(errno);
> > +	timeradd(&tv_now, &tv_timeout, &tv_end);
>=20
> This logic of timer on Tx side is not mentioned anywhere in the commit
> message. Please try your best to describe all of the changes you're
> proposing.
>=20

Will update in the commit message in V2 patch.

> Also, couldn't this be a separate patch?
>=20
I prefer to keep it. But if you suggest otherwise I can remove.

> >
> > -			if (!(fds.revents & POLLOUT))
> > -				continue;
> > +	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> > +		ret =3D gettimeofday(&tv_now, NULL);
> > +		if (ret)
> > +			exit_with_error(errno);
> > +		if (timercmp(&tv_now, &tv_end, >)) {
> > +			ksft_print_msg("ERROR: [%s] Send loop timed
> out\n", __func__);
> > +			return TEST_FAILURE;
> >  		}
> >
> > -		err =3D __send_pkts(ifobject, &pkt_cnt);
> > -		if (err || test->fail)
> > +		ret =3D __send_pkts(ifobject, &pkt_cnt, ifobject->use_poll,
> &fds, timeout);
> > +		if ((ret || test->fail) && !timeout)
> >  			return TEST_FAILURE;
> > +		else if (ret =3D=3D TEST_PASS && timeout)
> > +			return ret;
> >  	}
> >
> >  	wait_for_tx_completion(ifobject->xsk);
> > @@ -1235,8 +1303,7 @@ static void *worker_testapp_validate_rx(void
> > *arg)
> >
> >  	pthread_barrier_wait(&barr);
> >
> > -	err =3D receive_pkts(ifobject, &fds);
> > -
> > +	err =3D receive_pkts(ifobject, &fds, test->ifobj_tx->skip_tx);
> >  	if (!err && ifobject->validation_func)
> >  		err =3D ifobject->validation_func(ifobject);
> >  	if (err) {
> > @@ -1265,17 +1332,21 @@ static int testapp_validate_traffic(struct
> test_spec *test)
> >  	pkts_in_flight =3D 0;
> >
> >  	/*Spawn RX thread */
> > -	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> > -
> > -	pthread_barrier_wait(&barr);
> > -	if (pthread_barrier_destroy(&barr))
> > -		exit_with_error(errno);
> > +	if (!ifobj_rx->skip_rx) {
> > +		pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> > +		pthread_barrier_wait(&barr);
> > +		if (pthread_barrier_destroy(&barr))
> > +			exit_with_error(errno);
> > +	}
> >
> >  	/*Spawn TX thread */
> > -	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> > +	if (!ifobj_tx->skip_tx) {
> > +		pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> > +		pthread_join(t1, NULL);
> > +	}
> >
> > -	pthread_join(t1, NULL);
> > -	pthread_join(t0, NULL);
> > +	if (!ifobj_rx->skip_rx)
> > +		pthread_join(t0, NULL);
>=20
> Have you thought of a testapp_validate_traffic() variant with a single th=
read,
> either Tx or Rx? In this case probably would make everything clearer in t=
he
> current pthread code. Also, wouldn't this drop the need for skip booleans=
?
>=20

My suggestion will be to reuse the existing functions. If you suggest other=
wise
I can look into it.

> >
> >  	return !!test->fail;
> >  }
> > @@ -1548,10 +1619,28 @@ static void run_pkt_test(struct test_spec
> > *test, enum test_mode mode, enum test_
> >
> >  		pkt_stream_restore_default(test);
> >  		break;
> > -	case TEST_TYPE_POLL:
> > +	case TEST_TYPE_RX_POLL:
> > +		test->ifobj_rx->use_poll =3D true;
> > +		test_spec_set_name(test, "POLL_RX");
> > +		testapp_validate_traffic(test);
> > +		break;
> > +	case TEST_TYPE_TX_POLL:
> >  		test->ifobj_tx->use_poll =3D true;
> > +		test_spec_set_name(test, "POLL_TX");
> > +		testapp_validate_traffic(test);
> > +		break;
> > +	case TEST_TYPE_POLL_TXQ_TMOUT:
> > +		test_spec_set_name(test, "POLL_TXQ_FULL");
> > +		test->ifobj_rx->skip_rx =3D true;
> > +		test->ifobj_tx->use_poll =3D true;
> > +		pkt_stream_invalid(test, 2 * DEFAULT_PKT_CNT, PKT_SIZE);
> > +		testapp_validate_traffic(test);
> > +		pkt_stream_restore_default(test);
> > +		break;
> > +	case TEST_TYPE_POLL_RXQ_TMOUT:
> > +		test_spec_set_name(test, "POLL_RXQ_EMPTY");
> > +		test->ifobj_tx->skip_tx =3D true;
> >  		test->ifobj_rx->use_poll =3D true;
> > -		test_spec_set_name(test, "POLL");
> >  		testapp_validate_traffic(test);
> >  		break;
> >  	case TEST_TYPE_ALIGNED_INV_DESC:
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.h
> > b/tools/testing/selftests/bpf/xskxceiver.h
> > index 3d17053f98e5..0db7e0acccb2 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.h
> > +++ b/tools/testing/selftests/bpf/xskxceiver.h
> > @@ -27,6 +27,7 @@
> >
> >  #define TEST_PASS 0
> >  #define TEST_FAILURE -1
> > +#define TEST_CONTINUE 1
> >  #define MAX_INTERFACES 2
> >  #define MAX_INTERFACE_NAME_CHARS 7
> >  #define MAX_INTERFACES_NAMESPACE_CHARS 10 @@ -48,7 +49,7 @@
> #define
> > SOCK_RECONF_CTR 10  #define BATCH_SIZE 64  #define POLL_TMOUT
> 1000
> > -#define RECV_TMOUT 3
> > +#define THREAD_TMOUT 3
> >  #define DEFAULT_PKT_CNT (4 * 1024)
> >  #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)  #define
> UMEM_SIZE
> > (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE) @@ -
> 68,7 +69,10
> > @@ enum test_type {
> >  	TEST_TYPE_RUN_TO_COMPLETION,
> >  	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
> >  	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
> > -	TEST_TYPE_POLL,
> > +	TEST_TYPE_RX_POLL,
> > +	TEST_TYPE_TX_POLL,
> > +	TEST_TYPE_POLL_RXQ_TMOUT,
> > +	TEST_TYPE_POLL_TXQ_TMOUT,
> >  	TEST_TYPE_UNALIGNED,
> >  	TEST_TYPE_ALIGNED_INV_DESC,
> >  	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
> > @@ -145,6 +149,8 @@ struct ifobject {
> >  	bool tx_on;
> >  	bool rx_on;
> >  	bool use_poll;
> > +	bool skip_rx;
> > +	bool skip_tx;
> >  	bool busy_poll;
> >  	bool use_fill_ring;
> >  	bool release_rx;
> > --
> > 2.34.1
> >
