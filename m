Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7835F53380C
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 10:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiEYIMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 04:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiEYIMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 04:12:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D48641C;
        Wed, 25 May 2022 01:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653466357; x=1685002357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s84CdGkjzTbeR2P8Y6PF5MiQKDEDdtPAIt3s8vX0TG8=;
  b=KjjnxaXjYduz2G596dW+hikC5N41sHrM1QN/NGAlaUakt3EEQUpxlYME
   ew5eOdYS0EB+/og+iqmiJNUwwmg1hxLXAncErxFG7HCTsGwL/DJD8YYhM
   T9NWQE2xn8msnQXKEgr4W7CPI6g2v1m5PNgoCjInce4SiiHnn3yB8g2yw
   XOQgLAhPyjcPAFkEEYKXIh4QYO6T5xQW/4WtpxPxNGqzvlUckT7pbN17o
   GoC9k9t1jWQ0LjAmgx3ZZYG3Se9PEeirsEvJ41J8z9afZY8PG7FkYl1p4
   I6xSXGNqOhT4n71tR534cmLdyzuC6STiciCCd+6ux/giCIlKfvlhT66Lc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="273479299"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="273479299"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 01:12:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="601774539"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 25 May 2022 01:12:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 25 May 2022 01:12:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 25 May 2022 01:12:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 25 May 2022 01:12:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbalkULlq5QpfQC4aUglKJtC1Iw7LEXQPAe/kbeFQSkattX/LEz5dKAvMFXBsqgx+pQinbhNtM2xvxSRD6FtxwgcEKhoVTrqaHECFJ2PTJ/4dVvW0dgd9ynsdOSdrH3clYaVA3PkIB9xtulmZ2WQ66LSTsHS362rrAAeX2ynC+fV96Kg095T6K19Arthtb1dHAzKw7r0Ts7nf4AYfWHgfstAh8xlAyi3ugi1xjCh5jt4CMUHwqr8BERJZLBVA/sKWs3BF8GPPnz/KU3rCHQa9g3L+x0FPVHNIoleLMz1D8+o8e94hWj7LZPPQS62rZ4q9+1GrnXMXRWsPyeRXjrIYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQn/ByOErGF1Di+CfnVmCC6h+5+PSBGafJCVOs8DSfQ=;
 b=BK/lUNNQs4pX8zH7te4tRpizzSQ0/EYVS1m77MtMbuwKRF8c395iPHiEN24r38insW/nKe4mk8CEhmMRhp/eEVz9ELs8Nm/TFqkgdyOe2cyYpouosrmlwQKNQ2kBwu3scqFe4EoSUn3H2/SaBkLJ/m2TDf26tCD75Ky5OYbvDW2Opiw1BX7cFaQanZfJshP/qA5nxXl2sd9j2O0sodYIuNWwDCyHKkS5+A0x6GUnrq6+FqOaffNGxunHHTkI05wvsUQ7PFpyD4r3ibENna6aD3FshNxRh5DY7bAxWii5r7biBUe7YeXV8xW7s7//VCmEPtvttrhs/2w5fIJboHAMVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5288.namprd11.prod.outlook.com (2603:10b6:208:316::22)
 by BN6PR11MB2051.namprd11.prod.outlook.com (2603:10b6:404:49::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 08:12:34 +0000
Received: from BL1PR11MB5288.namprd11.prod.outlook.com
 ([fe80::e5a1:4f2b:ea64:595a]) by BL1PR11MB5288.namprd11.prod.outlook.com
 ([fe80::e5a1:4f2b:ea64:595a%8]) with mapi id 15.20.5293.013; Wed, 25 May 2022
 08:12:34 +0000
From:   "Palczewski, Mateusz" <mateusz.palczewski@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH 2/2] igb: Make DMA faster when CPU is
 active on the PCIe link
Thread-Topic: [Intel-wired-lan] [PATCH 2/2] igb: Make DMA faster when CPU is
 active on the PCIe link
Thread-Index: AQHYa/PJyAbFkdHamkyaTGNjCCO0xK0vROrA
Date:   Wed, 25 May 2022 08:12:34 +0000
Message-ID: <BL1PR11MB528839B81758CFBF18B9452E87D69@BL1PR11MB5288.namprd11.prod.outlook.com>
References: <20220511122806.2146847-1-kai.heng.feng@canonical.com>
 <20220511122806.2146847-2-kai.heng.feng@canonical.com>
 <6246d753-00cb-b5dc-f5fc-d041a8e78718@molgen.mpg.de>
 <CAAd53p52gkv-PLRvEM3GunTwU1J=c+n0J6uD03AQJ4EnL2y4Kg@mail.gmail.com>
 <CAAd53p4h1-SJROvUghPYbBnh2Z9nRtgfNEagE4X6XtBwNg8JOg@mail.gmail.com>
In-Reply-To: <CAAd53p4h1-SJROvUghPYbBnh2Z9nRtgfNEagE4X6XtBwNg8JOg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31741a0c-09e8-4efc-b792-08da3e2652a5
x-ms-traffictypediagnostic: BN6PR11MB2051:EE_
x-microsoft-antispam-prvs: <BN6PR11MB20513532EC1B2C9C5BF5AF8487D69@BN6PR11MB2051.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4CTNVnxilnr5IrWy0EVNDtnvC9jnb45DOlqbBh3HoxoGCP24wscUqx4zSYXnWa1g7HzhSCgay0Zepgdum+W2qSQmYcx/mlGb51vjSXptfOxhtWuBcAW9hnuBJQuYg1EZHUqY26Uz+5qdoCSb//EvZyuBR4Ossd346uyLoxsX8DYCnjTyJhbqML5P9UiX5p4qkbApEMgnrXzVbUDNjXL7gj03gzllpsPIiFEAtxJwK7vDCITdGYazlsPQ4XtH9VCfZN9iwDk/NijVo+QSA4RjgpZOITRfcUDvo4fmdqj81AN0U3al2l3YGpk1UkJhGsTx36iULsYOBPZWIyhkAGBNosmuxd5LmZ93Jm0XlpDoezrEF6f45F0W11HR13G9sQNMm2srbH/CQr3RIm0ByJEe4qBrgHii8WTffeRX1bPDXafrzZbLshC6ZQLt5I53BQKX9X/hp9Z628KMzSp4ToDIoKGqXglHf/dl6lRKwU2J9VZo2EJl0HDaA/eKVuec8SH14XoKhjpFpefwBGv+vRRASfVN9EKOxJJkrRYNIF6rCglZ/izVpKueTWnwNl+l6eUDSGgxIyFbWCDwAIVtRDNuKy3fP7qOCXmpmw9ml//84dtO4Z1gZwUDXNFsoYvK2r0OQsY4/tbPGEDheWbfNNGVTimHdFMFSVYI0o8bsU9F0btoR5vgq9lbC9NDxU7iD1gZFqRdvPb2tivols7xrrQi5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5288.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(316002)(122000001)(54906003)(110136005)(38100700002)(82960400001)(38070700005)(2906002)(26005)(71200400001)(66556008)(66946007)(66446008)(4326008)(76116006)(83380400001)(66476007)(64756008)(8676002)(6506007)(7696005)(8936002)(5660300002)(508600001)(52536014)(33656002)(9686003)(53546011)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Hy2Ka8FOwOcuA2LCKZY2B9qTx41RTmwUANidTZemMgs3kVW7Yh5/Ad8odTjO?=
 =?us-ascii?Q?uc740dXyWEOcm4pzspzDYDKypas0094sh1NxdlXQAmsY1y1z5O9Np4eZNRX8?=
 =?us-ascii?Q?ZxUV1SRLkhcqNuXk9WWHmhj6CGhNNjI/rWBBymuCZPal4YT2fHcD3NIgr76B?=
 =?us-ascii?Q?PkTbEWE3cveTNlfXZFp0WdmAAVG+W4a+BZ0hZ23/LoKkO1K95olbWaEkcY1s?=
 =?us-ascii?Q?el9Anl6u2jrj0mVYLph9jsn8YZLl73uV4V8NAbfcHmE7uRgkbbBz+hZO+Zi+?=
 =?us-ascii?Q?x59t6FVxmOWKTkHVBGzmv45Rb74A7Lwd79PHtHUHoZ1Jqw8Gc69K9U58LLR1?=
 =?us-ascii?Q?VQpU0dqSrKxYgN2OzwzTPGcMNPHWYxVYXqOPO9kdE4zR6jFhxXyzBmaUsckf?=
 =?us-ascii?Q?WGKT+vyXPrZfYvVytsImgt2Kj1BC8KqyQJ8WQyw7WYa5tU9uLE105ueQivjZ?=
 =?us-ascii?Q?wjqChYnVGpyXF0Z781GOo10kSWhaWhRt7OdF5pcSLzru1Esf/DleWFjkstMy?=
 =?us-ascii?Q?xC3pPlBewGRmrAIA8i1p3fEXey7jOc6umiTTSe+YXcTVrilS3tKjVYL7PT1q?=
 =?us-ascii?Q?hkvmsJaHN4Cs3VsKi6kL7szMhzpcSjs4Mjcn76d6+TtRb1mZm/NKOeFBiZVE?=
 =?us-ascii?Q?4XouG1OR3S9k8Yg6Y+L4Wxq/wgFJIyDbxZhze1fUQKBtMg46w22Yz6EjmO/1?=
 =?us-ascii?Q?1xUinzmbnX2yJahiCkGVZqXL6L72TCxHQGngGDeBwtlEpN2BbRlOJVHGcbYb?=
 =?us-ascii?Q?lSrMPk0f4NtE58mMY0W4sIEq0vx3zzRVVsm5nmWETUj34rMoCvSrlve2bDk1?=
 =?us-ascii?Q?gUgjdJ0e6z+HKDgwK9mOJw8MDlim4uyeotSNCz4nlgysLC7+EpMbT8CgTcLY?=
 =?us-ascii?Q?th0mwKjXVjW9q5umRYNRaGp7A9CF7wHXKh/tMlwNG2yaBof9IR7ZGkPQYNJa?=
 =?us-ascii?Q?nSrFfDP+YeytNFepFcvDSZQVJrnR1gb4tD9YFq2gBiWEdvUkQBiQKm1eVcUb?=
 =?us-ascii?Q?x60Nb+sFOugoB6THthSixLVZe8Z605gNF3JkPRyXIMs1TDuPffmI/deeJe6x?=
 =?us-ascii?Q?7UifIrxXRT5hiTquf1m+D3jMwYEs13SELkxZjJiALjolkR35JbYSPzsZIgf0?=
 =?us-ascii?Q?Qr+sMNcfwxvl9ZwGVvVdxYbIHWzCORGfX6f1uxdTx7lL/0FR1UxiE/HOgw5p?=
 =?us-ascii?Q?+tmQhqiCymwEWVifjrNxDvEFqvweYDwjNAsjJyaxWrgx9MVBYRI30HQgLkD6?=
 =?us-ascii?Q?7OHvaf4kmiFQicfAc5CWdmOt/v7OALZvOxMx29svmnTL+3GCuZptnBrA+GWX?=
 =?us-ascii?Q?X6uhPM7+q71DbE8sO57of0X0wejQOa7HOXWbp9AWDipFeNFyPeujXOcWTThb?=
 =?us-ascii?Q?JIj9uPuHWexcSDqHM1JhCqTiwe5605DtNVxdDpd2zDajy7itRdp3CoVgzCu5?=
 =?us-ascii?Q?ZVZU1xeOoC2hx65wsUGEJMI4AeoAZG2h7wydDYIkXMTtwzWFZUqbOi89GvY1?=
 =?us-ascii?Q?crXvrWhrLuL2qWpDBGaLloI5NzrHBgMTUFBiZlwDoexHddw8kJCMtO6m5gQn?=
 =?us-ascii?Q?5smrcGHsUxR8kc0QMHs0SzYCr2sV4U8alJqCtgJ4bhUZpQndLufnYnwSj0H8?=
 =?us-ascii?Q?1650kcyfgqvZlclO2nBmSbspZXa7KTQcMeqPq1bim0xaO6OE5+MRCJ/NcAtb?=
 =?us-ascii?Q?wPG9DeGXB4YVL7AuzCh4b4kyaR77pd6gGREqksSM8Fuyeb4LVijYKKgJQ/Ia?=
 =?us-ascii?Q?m4QzT+wMAAbRp8hb+2oeIaVc+3sFFZ4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5288.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31741a0c-09e8-4efc-b792-08da3e2652a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 08:12:34.2305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y+NPC3CbfKrtqZbnY5YcznjCXmTnk32Rs3tQOc8Qn8BNpVAhh0SKJGLjWzgfueVC4R+XcNctAfc6NFfoate7yQdDcTcrLbr4cSd1asJ5hRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2051
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
>On Thu, May 12, 2022 at 10:55 AM Kai-Heng Feng <kai.heng.feng@canonical.co=
m> wrote:
>>
>> Hi Paul,
>>
>> On Wed, May 11, 2022 at 8:49 PM Paul Menzel <pmenzel@molgen.mpg.de> wrot=
e:
>> >
>> > Dear Kai-Hang,
>> >
>> >
>> > Thank you for the patch.
>> >
>> >
>> > Am 11.05.22 um 14:28 schrieb Kai-Heng Feng:
>> > > We found Intel I210 can only achieve ~750Mbps Tx speed on some=20
>> > > platforms. The RR2DCDELAY shows around 0x2xxx DMA delay, which=20
>> > > will be
>> >
>> > Please give an example platform, where it works and where it does not.
>>
>> The platform is about but not yet hit the market yet, so I can't disclos=
e it.
>> They are Intel Alder Lake based.
>>
>> >
>> > How did you test transfer speed?
>>
>> Iperf.
>>
>> >
>> > > significantly lower when 1) ASPM is disabled or 2) SoC package=20
>> > > c-state stays above PC3. When the RR2DCDELAY is around 0x1xxx the=20
>> > > Tx speed can reach to ~950Mbps.
>> > >
>> > > According to the I210 datasheet "8.26.1 PCIe Misc. Register -=20
>> > > PCIEMISC", "DMA Idle Indication" doesn't seem to tie to DMA=20
>> > > coalesce anymore, so set it to 1b for "DMA is considered idle when=20
>> > > there is no Rx or Tx AND when there are no TLPs indicating that=20
>> > > CPU is active detected on the PCIe link (such as the host executes=20
>> > > CSR or Configuration register read or write operation)" and=20
>> > > performing Tx should also fall under "active CPU on PCIe link" case.
>> > >
>> > > In addition to that, commit b6e0c419f040 ("igb: Move DMA=20
>> > > Coalescing init code to separate function.") seems to wrongly=20
>> > > changed from enabling E1000_PCIEMISC_LX_DECISION to disabling it, al=
so fix that.
>> >
>> > Please split this into a separate commit with Fixes tag, and maybe=20
>> > the commit author in Cc.
>>
>> I don't see the need to split to separate commit as both require the=20
>> same change.
>>
>> I will add the "Fixes" tag once the igb maintainers reviewed the patch.
>
>A gentle ping...
>
>Please let me know if this is a proper fix so I can send v2.
>
>Kai-Heng
>
Hi,
Looking good to me. Waiting for v2 version with fixes tag and then=20
this will be fully accepted.=20

Regards,
Mateusz=20
>>
>> Kai-Heng
>>
>> >
>> >
>> > Kind regards,
>> >
>> > Paul
>> >
>> >
>> > > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> > > ---
>> > >   drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++-------
>> > >   1 file changed, 5 insertions(+), 7 deletions(-)
>> > >
>> > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c=20
>> > > b/drivers/net/ethernet/intel/igb/igb_main.c
>> > > index 34b33b21e0dcd..eca797dded429 100644
>> > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
>> > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>> > > @@ -9897,11 +9897,10 @@ static void igb_init_dmac(struct igb_adapter=
 *adapter, u32 pba)
>> > >       struct e1000_hw *hw =3D &adapter->hw;
>> > >       u32 dmac_thr;
>> > >       u16 hwm;
>> > > +     u32 reg;
>> > >
>> > >       if (hw->mac.type > e1000_82580) {
>> > >               if (adapter->flags & IGB_FLAG_DMAC) {
>> > > -                     u32 reg;
>> > > -
>> > >                       /* force threshold to 0. */
>> > >                       wr32(E1000_DMCTXTH, 0);
>> > >
>> > > @@ -9934,7 +9933,6 @@ static void igb_init_dmac(struct igb_adapter *=
adapter, u32 pba)
>> > >                       /* Disable BMC-to-OS Watchdog Enable */
>> > >                       if (hw->mac.type !=3D e1000_i354)
>> > >                               reg &=3D ~E1000_DMACR_DC_BMC2OSW_EN;
>> > > -
>> > >                       wr32(E1000_DMACR, reg);
>> > >
>> > >                       /* no lower threshold to disable @@ -9951,12=20
>> > > +9949,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u=
32 pba)
>> > >                        */
>> > >                       wr32(E1000_DMCTXTH, (IGB_MIN_TXPBSIZE -
>> > >                            (IGB_TX_BUF_4096 +=20
>> > > adapter->max_frame_size)) >> 6);
>> > > +             }
>> > >
>> > > -                     /* make low power state decision controlled
>> > > -                      * by DMA coal
>> > > -                      */
>> > > +             if (hw->mac.type >=3D e1000_i210 ||
>> > > +                 (adapter->flags & IGB_FLAG_DMAC)) {
>> > >                       reg =3D rd32(E1000_PCIEMISC);
>> > > -                     reg &=3D ~E1000_PCIEMISC_LX_DECISION;
>> > > +                     reg |=3D E1000_PCIEMISC_LX_DECISION;
>> > >                       wr32(E1000_PCIEMISC, reg);
>> > >               } /* endif adapter->dmac is not disabled */
>> > >       } else if (hw->mac.type =3D=3D e1000_82580) {
>
>
