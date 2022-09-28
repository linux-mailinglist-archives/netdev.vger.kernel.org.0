Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D825EDE2C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiI1Nw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiI1Nw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:52:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C66D8284D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 06:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664373175; x=1695909175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DXA6C0O5eqxwBVa325D1BmsZ34SZRUvPiC8I5ao2DP8=;
  b=PpYptVtxLVJHXAPppmhiUePFO6CSnA502k6tmidUa+CFd5MpG/igvxUk
   frGYHDuXSHL8xlY9PTE2+IOonxPS4h8CPJZM87JmHtD2W6jXr2qhr+gLi
   pk6ZIMhPGOaBJaVKZDp55blgAOef8vPrMZy8DwH9X8pXRZvMRV2wMVy5d
   VF29koBLnUsVGV7JN6yHL0eGQFEKR1cyjhSvDDlO1fKfaGlZDd4KW9ozT
   7OUWt2qQ+wRmG+ivzXVY+GHNr9TEHM53et8bQZkgXaUrlah0KNKtk4soo
   zzVsre7vLwihAC+VgwpuRJbpxYAhtrQyUfE38ryUuvXGhrgknCabUle52
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="176014426"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2022 06:52:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 28 Sep 2022 06:52:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 28 Sep 2022 06:52:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgAixxh0RkvM+3SfBieVdzRgSugFsFi2vDbhj/gr1E8SmLa8Nq6QpVdUH6+sQUG5CcueBe2g1i0oPIqqkET3EOgBULzivZ5sJsRGR5TUxWXnw3H1MvdNZ0uqB8RxA6R+Sngmcs/VKPLXo/2UZwP5u+y+2BgKNw5oWyzJfJypQguM3XzJpQAOwXG5WEWkgVYfN4gc5oEP3u7YxmWyhkgiGiRQxk0DaZ6lRIEOCdBaI09BqaiUaFTjZ88vPhHDm8HK77wqFUCez4BurAn20hxwpxysa58rWQrvQo9orPmJMFli1XVC/ipqiz29jfdOMrgzsk/i4kiT9eHqErw3oZBtWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKHoVNHLgIymM1fJUuBpYmjwvzDRDc0TTP0i573xkpQ=;
 b=j80LXTPvj4tpnUlHY3tZJPsYhCU9mTDzYcGn/R56Xze4GFGP3gIFQDW8W+q7LcXxEMdzJpiPG1kQU3l+DikKdOZ+HQjSOnuEqyACG6svDwkpBw4puAROdPrhatZaQBiUlSSy4fiKs2MYUvPjAJEWvXswPY0h0Y0FWDHWxOs7CDTIIpjwy1xzw5+pv9zDs1rKL4jH7WufP2d4snsgIyl7HAk58WrhtDju42WGXdrFj5CQ6nV6fUjbIF+3vJeWLcbwLpSKC3pNtgt0lBAneHNGsa4l2VW5dnCSD8FY62BMctB7FNWzPawb2vCF9av286pkgtyp8fHh64UfIagPVu9XVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKHoVNHLgIymM1fJUuBpYmjwvzDRDc0TTP0i573xkpQ=;
 b=goiSrD8ATIibKdyZHD16mlIijLGxrOlxrKgrOzUr6SkfIunMrGKmDJYwMoJ1rv2jbTZ4tqWj+NzS/UPQ62LCJW/phWzhrZwUl8ESu6O/F8fPsMm5SIVOMgbBEuASMvFhqzY5v10BCLc4FPI19ceOtG1naxnnotjjPcGrG6b282E=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by SN7PR11MB6603.namprd11.prod.outlook.com (2603:10b6:806:271::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Wed, 28 Sep
 2022 13:52:40 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::5003:35de:cfdb:697b]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::5003:35de:cfdb:697b%5]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 13:52:39 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 1/2] net: dcb: add new pcp selector to app
 object
Thread-Topic: [RFC PATCH v2 net-next 1/2] net: dcb: add new pcp selector to
 app object
Thread-Index: AQHYyOh5WXJO7bu/6UKxnJzFwAQOL63mh1eAgA5svQA=
Date:   Wed, 28 Sep 2022 13:52:39 +0000
Message-ID: <YzRT9hzoVU8h4q7i@DEN-LT-70577>
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
 <20220915095757.2861822-2-daniel.machon@microchip.com>
 <87edw7y93y.fsf@nvidia.com>
In-Reply-To: <87edw7y93y.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|SN7PR11MB6603:EE_
x-ms-office365-filtering-correlation-id: 0d33bff5-01b2-4c77-5566-08daa158b567
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kyidl4Jj9zA6PM6D64ZYTqZBTp/V44qcJu19DAkdsz8JEARqMkrGxki+4M2ujoiep6Hbn4cUybpe+kiy5Iw5dL1UL4t+8j/h30PME/LC8KQbI0cgV5qST/pUzueh4icymQK0sd+qkLvuyDbXb2z2saufH1yYhPO9Xix69Kdv0/8vZNC7D5xktNxWWx5QCcnEmxilmSvNeqzN/LK/KFl8QOrpQlikB4d0MtMH6d8xwxJ35ffqam7JcdmWpjTFS+OIvMAaI4FJ1qZKClPMi9ixmMVPD32nCsNE1oXZk+lp1Ei8hO5cWY5Q+8x4LqsKuGnuMHn65zNYGYCFYFpgjnKxGDY6Q5POQv1T3eDN+udpey4uh4631DIdq0Ui8MMnsYAmIPEI6rqBQWVKKy4yLazI4IRaULI3vkAJaB+OltyW1msthuoW9DPkZrHCCU9gnSj3YkER6auBA6Jk0M/7RACmcXsK8fuBMkUv9MNAvAcW3Xglx2PO9aSDPE9ygXgKiltPzPfrMJ2fNXa3ntu1TAEpeLMODDdmBQJx8/6jitNX+770HIfdxkGyD1a2K1Bvqp4sP/AzEiwb5eek8PB9BdNYj82GDeOEn8MzdAD9oewwbnkRPSKz/060kd81WHVJ2X66GtBIUjwTKxWg39sNznxR6CrlZx3ezKBVD3b3AEzfgTT7ee8JYpucPvbfJa0Ss/VTLT+N/+VdKd23PhpK7vpjZNCn7NTXIYk9HvhTdT49c7dXdUF+1ckegHMLVe8g1j2q5dWIGEKnLyQE8Ag1pnZNv/k/L3LuEOSAKnJ/zQagkKM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199015)(83380400001)(86362001)(38100700002)(9686003)(66476007)(38070700005)(2906002)(64756008)(66446008)(6512007)(8936002)(66946007)(5660300002)(66556008)(4326008)(8676002)(33716001)(6506007)(91956017)(122000001)(316002)(6916009)(54906003)(41300700001)(76116006)(186003)(966005)(478600001)(6486002)(26005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MdCy+L0BCPQN5HkQPnjzRDahonUBhr7bfvT6+ZPJJsLUwhz6zPR8gWuR29DG?=
 =?us-ascii?Q?q/YnqUjzSIoB0X0r4oe9agKE/64z+JQ3E5Ny43y97cwv8HkRxyOdKNt3oN0a?=
 =?us-ascii?Q?W4KumR11mKAX0m7Dls+egOh/Jnsn2emsJBMSYoiljBwklI2+s0QcfSZdfdED?=
 =?us-ascii?Q?kwhdPC7WhQuTQpdQVJFn4kX2dIYyKnnpdQd3NAEjn5LoBC6dC30B0Zc5HC31?=
 =?us-ascii?Q?ylNNHBaeFy+74Bqdq/mbYg63WCJxy48GJNBgpXSPX33rgfmJUGxzMlQ8gt1P?=
 =?us-ascii?Q?vx1KV9dFfF6u9BJXfSAGgPVzqtM6kF6FtP9NgH+ZnG7badM3XE/gYrDEO1pw?=
 =?us-ascii?Q?Od4hLemD4Ngds6OFtTlb7TmTk3SamNs96PkOUnJHVEJXh7NGglMFPZX9C+nU?=
 =?us-ascii?Q?j4V0n+gxzUmBH/MQg4Tz+D1SwX5fenip7MR/FsRxwsiTsjbmILDBQuV6A2la?=
 =?us-ascii?Q?DK4a0hX35jJK7FNynVZ3x4XI5LpaXo/lMeBio1uEDA0RYGDTjmadNb/RdYQG?=
 =?us-ascii?Q?VP2BJfBbAJqdqB7xznQCdxFdTds/ehMwxi3q2patIioJ7/tj9Dbu6tu5UvxK?=
 =?us-ascii?Q?0CPblaZ8dm5sAElXhJonDStsEVU/bOw9XQ/FfN+a4QFLkSS9RrclRm0EkNLR?=
 =?us-ascii?Q?FwCGx8xLQNFYu7PNl2TULprW7nSLya4Nr1alHZx/7l+UvC/mAQn+9iK/OfZF?=
 =?us-ascii?Q?59NKPnlSRHxh2QtwSvT8sB/R1lIir1HyntnsE8uX4KpsnKZkG/Rnh8+0ElsX?=
 =?us-ascii?Q?GlX/jpdmDDJG8DD7IpFs7gxucGJ5Zuw+VMvXH2a/ccSp0uv+0o8bf7JYtOXv?=
 =?us-ascii?Q?CV/G8dS/5Hh12eSVcUmgEVCSt1bKUbRNNnxLm4N0CAEuPzE9DadiSuvr/5H7?=
 =?us-ascii?Q?JYBEhIJpiHZvTpNSXx0qcaFzGzfjmnBnDE1n2NyhF5h+uEcoHVTGP8X643Hr?=
 =?us-ascii?Q?eODNnkQRrOnh3Qs6GZ8h0fe85F6mdHZKkJ/akOjdxvryr56TclipdH0hiHIs?=
 =?us-ascii?Q?nb6fgCTbxTTlY3sfnE2gVdPBs6YHF5YLffDBk1hVApe+Jgd66vcQ8H0+cFOd?=
 =?us-ascii?Q?LB9FtvxBvBdMpRyNyNu/iMRy+AseBBK46v+Q4YRod2Yu2CWv7347D2vK98cK?=
 =?us-ascii?Q?Bwk3Q1tnlfdo/1e6qPS99HEXcpIVAoDPQyJh8V9vCejFAP0lr4KPCvjXoUpA?=
 =?us-ascii?Q?/ypJKaichmdlbqK2ODqjA85Q5gYTLubj2C0drKgcPaxwhw4+HMEmvfS3Ll1C?=
 =?us-ascii?Q?pUEEGyvy/b8juiuY/yeErLVfrC8GeQ0Bhu1aotrsKJceunY26sDvk9r7Tlag?=
 =?us-ascii?Q?mc/9v/l5p8F3fSHvpsaPDY+I6XnNHHpFJAEn+P1sRQcKQYUtg9a15f5FzfG+?=
 =?us-ascii?Q?QRG/rfL8hXdhgZ/OCv/2IlfAasq0Za0FDTBsAJMH4yf8MWrRUiZ/rzIRUr3y?=
 =?us-ascii?Q?8SBeMkiZ8IROjeLyfmG3uYszDsi4MEIS8bHbWmSyzebaBhnuZxg2L6RIQhhB?=
 =?us-ascii?Q?htWkH0mLMVK+jZkInPfy7pdiyNvyiyWJ1zIn+6yMfckf1OybSKRHpgpGIzhD?=
 =?us-ascii?Q?unQdhX6/ybKRD2gcV10mc7oSFFhJ+nLv2L84UW3et2MNGUSYs14DlBR82RsF?=
 =?us-ascii?Q?e7QTGJMR7RsAhlcSubg3EAQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4159B3D1DCC4F49A30B49371835D9FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d33bff5-01b2-4c77-5566-08daa158b567
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 13:52:39.8938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5gZZ/WmWzktWRbJA4Zyik/nrMaTECLOBsdFUC85bbuFNneOdGWiHjpe9fxMwi/7g5rBgBbE8ODmVfLtqtOa+mwPDi7K9qxgwWg92tV8j8zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6603
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Mon, Sep 19, 2022 at 11:45:41AM +0200 skrev Petr Machata:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> Daniel Machon <daniel.machon@microchip.com> writes:
>=20
> > diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> > index a791a94013a6..8eab16e5bc13 100644
> > --- a/include/uapi/linux/dcbnl.h
> > +++ b/include/uapi/linux/dcbnl.h
> > @@ -217,6 +217,7 @@ struct cee_pfc {
> >  #define IEEE_8021QAZ_APP_SEL_DGRAM   3
> >  #define IEEE_8021QAZ_APP_SEL_ANY     4
> >  #define IEEE_8021QAZ_APP_SEL_DSCP       5
> > +#define IEEE_8021QAZ_APP_SEL_PCP     255
> >
> >  /* This structure contains the IEEE 802.1Qaz APP managed object. This
> >   * object is also used for the CEE std as well.
>=20
> One more thought: please verify how this behaves with openlldpad.
> It's a fairly major user of this API.
>=20
> I guess it is OK if it refuses to run or bails out in face of the PCP
> APP entries. On its own it will never introduce them, so this clear and
> noisy diagnostic when a user messes with the system through a different
> channels is OK IMHO.
>=20
> But it shouldn't silently reinterpret the 255 to mean something else.

Hi Petr,

Looks like we are in trouble here:

https://github.com/openSUSE/lldpad/blob/master/lldp_8021qaz.c#L911

protocol is shifted and masked with selector to fit in u8. Same u8
value is being transmitted in the APP TLVs.

A dscp mapping of 10:7 will become (7 << 5) | 5 =3D e5
A pcp mapping of 1:1 will become (1 << 5) | ff =3D ff (always)

Looks like the loop does not even check for DCB_ATTR_IEEE_APP, so putting
the pcp stuff in a non-standard attribute in the DCB_ATTR_IEEE_APP_TABLE
wont work either.

The pcp selector will have to fit in 5 bits (0x1f instead of 0xff) to not
interfere with the priority in lldapd.

Thoughts?

/ Daniel


