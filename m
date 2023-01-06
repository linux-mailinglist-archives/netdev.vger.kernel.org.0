Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2869A6605D1
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjAFRmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjAFRl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:41:59 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF82BE1D
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 09:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673026918; x=1704562918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S0js7P5IUlXu8fC3IaSdYytbFY/mBmJiEe3D2Us8Axw=;
  b=I9da+1QulpN/2dsIlG5s5aau0t28jCQwq4RZI1KEhifTjWX4bPQ7RFMk
   6VIrQt8UnZzl1tusECKHD8ULqFT5GqihXOleuRmc/lSJ6auCjC9jlWd49
   YBTTGEgpE4pIAuV6bffnu3+38+3Qjwy48hF4NnNvBP2da/dkPwLKN9MS+
   OSSAlFgbPCIhLFQmuAPiCHup+6UqS6DAIrW7i+mxcyH2TgppykPrcVO4V
   VXoFquV2rmPXxABZWrxD7zS6TbbRpWV1+890NUUJ92nyr4T0mTfroAut1
   SfMY4W8Z1yJK6GYCmmqA4nkt+YQO5cAekRl+qYId744hwgZL+MCMWUNBB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302222213"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="302222213"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:41:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="744704018"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="744704018"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2023 09:41:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 09:41:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 09:41:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 09:41:42 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 09:41:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZqxjbkJd+YEekqJV/eIfRU2J25bGKK6ICsy1ODMh4iMUHshJF1oDxYS9O4Ze+YTaoVkLP9CwsaiFB1OMirF2ee9Az8iq03aCVUQq08MqcCFm9hZFRMvitM99s7Ixu407QzgVN3Mwkd9BxJppq6n8yy5S8nrnoXUz2yVFfOINyuBCQMApdrIJ+2XdTwV7Fb9alTW43Chn4YtHUrL96sXVowY2l6Oxup4ZdlTO7ErMszITBQcVYkukAUvLz2aQ62gc5BlfgTzfTQLTB42Hff4XZDdkbjPjITQeiegdcFQRZkRw3gW1tn79HQm4sbNuf0W/FAjoRsQKUQG/4r+qwPqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vUj4WgUtUCQJ3OPLk6/rN+3gRSfYxNSYXS4ebBXqRk=;
 b=SJLK2+EoV6fkA/VFNeDRo+v/0jhboUgXZU6wpILjzII3/ydNIXBXjSu7eXGTYI8J2ZnM0VZyKQjZdysuWBz57mCPdVYGz3Rlo/o9DrG1us4vnL9txrDGTBFwfzFxgqTjt4p6HmKB33ZRm2qMCSo9cuEpdYfSnn5tPTDmGjGZvIWtYZgDal1UIoF5O0dla+r4jrrPc59cXa8gMWRbdA0ZTEJFMVfbi+mY3V8oalHYBnzqNhK/kAdnyucCVSTKnfyGkJ5omlxcD8wMU1TzzJxT8cFMSX2IHatrqMCJ/IWPthonKK0eY1XxSs8CKHkxn48i8SujQLLzH5dXzF7+MWPLJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by PH0PR11MB5628.namprd11.prod.outlook.com (2603:10b6:510:d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 17:41:40 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 17:41:39 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for get
 rss (-x)
Thread-Topic: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for get
 rss (-x)
Thread-Index: AQHZGyNj5InCPxiluUWC+3R4NpNH/K6L37UAgAXGb0A=
Date:   Fri, 6 Jan 2023 17:41:39 +0000
Message-ID: <IA1PR11MB62668007BA5BA017F5B46708E4FB9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221229011243.1527945-1-sudheer.mogilappagari@intel.com>
        <20221229011243.1527945-3-sudheer.mogilappagari@intel.com>
 <20230102163326.4b982650@kernel.org>
In-Reply-To: <20230102163326.4b982650@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|PH0PR11MB5628:EE_
x-ms-office365-filtering-correlation-id: 4992465d-f6c9-4ed9-72c9-08daf00d4450
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+2PWHziHV4P1bZMME+i+YUlscIsxiRmO6thQXcRhOtcZ31NuGG7BWe5x7dJYy5pOTbF9agbOHfHRMIWu/Eon6q9yfrU7Hc++/vmWsxyy+ZVmB/MCudEKkNlJM96yyTyBMMZBZgomdRanIlPfsJImle5/kI/mWuM3CIvKq3g/cZMsHBWO8eiaimHI2Tbr728w62R/apu8dCUHGmeENWVEblhzt3FNN7GdDWkX68+UR2D3P5tIOPjl0Npx9uU64UIk/w67GSk4Uvymd42Vn9deNX4eMfsp3tvobvHxE4JK/5EaeHYG1nefLQKtfk2LZWdkICv6CG8/6wzm/kva4XTvdSmAf+9174oQSleX9Gny0Yxmp7QiNoq2j6fKydn1ptkYQu+wCb+UEFWhF2NKM2mLyfIVxHvdn9vUwufK2iiL/4NSVedx1K9TcguvVL+wIEiyivKPjShKRQTySssM1F8XH64PxAt7zodXMGkRXnsMPMeUqcSZ61maoUNgO4a2jPjnvrkwZPE/54TEEQ91mPFOTyRwo2w7IoOpmVEXpsdpe6xWwr4Q9i+oeGK705N45O/iZps5wjegoQKBZCl9gPzhIbL9w02TZXU1crcBq+v5QJEZeNDL43hekmzRpL0u84CpGEzBoKbHBgsCTle/bCSkOuGWKoqmVflQdav1QrUq1takjL66HMYwTIvBPKdI8dd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199015)(38070700005)(6506007)(316002)(7696005)(33656002)(55016003)(54906003)(26005)(186003)(478600001)(71200400001)(107886003)(6916009)(9686003)(2906002)(83380400001)(66556008)(122000001)(41300700001)(82960400001)(38100700002)(8676002)(64756008)(4326008)(76116006)(86362001)(66446008)(66476007)(5660300002)(66946007)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cNPrwX7HyakSu00x+AmGemEYUrPzK2oBOhXub+VphurZwx/EJxYh2kjPRz1u?=
 =?us-ascii?Q?4r31LYJVZtmihZyHD2DYy3UWQxL0ZyOUVwgxJjIzEXBhKRcsK3z8FIBr98Ql?=
 =?us-ascii?Q?O69EubA+wubfzsFXBwvvDGevs/jPeT/AhrbwqW8xT5bc9h1wEDPEIejx+exy?=
 =?us-ascii?Q?L6gLk5qgVKUiVYk7JsSexJQG918qohNUvMAkJS0Z88Yyrs322Z9MQ3OHhvVA?=
 =?us-ascii?Q?/IonVOIzCOtflZdmymp+VddWXRBuV2BVrPG7JguY7XX8IiHSC83xxh72mL/I?=
 =?us-ascii?Q?tEFlFWz2XIHCEuiXant9s+r0vag25MOZanaX8TmboJ4C7AW4OptmQ3nnHcSJ?=
 =?us-ascii?Q?PuDSPoqOEmQnmBVil9HpIQ+inpNRpNHN7kz3/UpaRxYky6np0Tr+NXWPfQMF?=
 =?us-ascii?Q?owTRX6ge1v66JJ2r3VSNjWXq/Z+0YEtwLWOBYbIxV296oCTJA1aDNvAEg/M/?=
 =?us-ascii?Q?muwBb6+eDT8Fu5IN/jDLpQ39hacYL+EkIeT+E6Qo23PcKh1xJPmqSICTiqJS?=
 =?us-ascii?Q?GREsFhONgwMUWsrSX0drEAyahhwQrvh5AIevho5gHwzw1IcQJDKIJyivs4dk?=
 =?us-ascii?Q?Q29m51LYDiOQ7EPZVhgHJrB3eRfIzwFax4xQTSV2q/sIrlT9KE0NC8Ql7rDn?=
 =?us-ascii?Q?00C4Sf//rclZLn8dpyDKw4GHeuVT8SqHB9Vjn5+zfmmn4s+dtud828nsF4cD?=
 =?us-ascii?Q?/sXeANU+k3tTgF/xxNJQXurUsJQe+8nIk1ZlnVQ1RuUk7pwLZxCh8/M2XEsF?=
 =?us-ascii?Q?QYcT9qZpZHa3myvdlKRhP1NstpfehIRjj0iq4AjGRs0FGJR6VBOBLqYjJq2b?=
 =?us-ascii?Q?VWwlqnJl0tSd/qpO80WwDSk3ody3Zl9LABMP3MkU4xNvJLQHvN45yh7JOdjr?=
 =?us-ascii?Q?gyFGVG/5uT21WZK3B8fd+7+pBDXXtc3vIujOEt7XtEPNnP1bYcVWqrWyiA0/?=
 =?us-ascii?Q?K+LFeVXQH9snoZPRl21zdMwVrXBY7y9BlNAQztXemG/JLWj5fIM5T7swwLem?=
 =?us-ascii?Q?H0SEzDFOxAeN3JJ03SEk95cRUDNB4iA8QxHpyYi7Z9mlo7g7jeEKpLKVq3TG?=
 =?us-ascii?Q?KZjtnr7+qR2qfDaX9TH8yjTy91l77od9T+MtE8XGSv93oKKfDaBZ48RxQFF2?=
 =?us-ascii?Q?D/eshb35ozH9CP9yiultrGohj8ipCxmyPP+3hyE5Tok5KtBoWVnwb3J9936J?=
 =?us-ascii?Q?6t0zwdkL99YzT8oqU0SGdKBD0cJOfyZB8fs1sDbOoDO0DhgxQSoWyqm1yUvY?=
 =?us-ascii?Q?RGMyQihynrjaQC/c1VgIgz0fFb/HUreX79Mx6JOH9cxJEr0J8+ld6HZkAbFy?=
 =?us-ascii?Q?+UQYRH4IY8yNiSV9kVmticcwD7MPGvoLmqLzjqbo8VJ0acxbtI2zW4ReRjr2?=
 =?us-ascii?Q?97dicY28aAUmpGJWi6xKy0x2Jf6AjOgX2B6El4CKWOV2+4Dq2ZT5zkIrqxYL?=
 =?us-ascii?Q?Lsc06a6UFKOhIBO3mqCw5kccQzGMHveW/V4V2lxm0PzLS7Q1lLNgyMlaXajC?=
 =?us-ascii?Q?MAyRd/FAdpmehGGiwxJTZO/fXBzRSsdM3+CuEqFCoUGFGMYddmEhQH7JnB2J?=
 =?us-ascii?Q?MDT6It4THiOEfbX5w1MjAzojxZspgAugXiTHgL/BHX5RkgR6iqfyrSZ9ac6U?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4992465d-f6c9-4ed9-72c9-08daf00d4450
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2023 17:41:39.7085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pI1+7boePaTA4UvR2vu7bXR3FPsGlxd4ujhRirEDOqDOa359F36XHmTA9sAs+BX7jYEjXSihVVUyJ4UjNcGze/JVRGKNenv3GdTc63sul90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5628
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>


> I believe there can only be a single bit set here, so why not print:
>=20
> 	 "rss-hash-function": "toeplitz"
>
> rather than:
>=20
> 	  "rss-hash-function": {
>             "toeplitz": true,
>             "xor": false,
>             "crc32": false
>           }
>=20

Was following similar output format as current one. Changed in next version=
.=20

> > +	rss_hfunc =3D mnl_attr_get_u32(tb[ETHTOOL_A_RSS_HFUNC]);
> > +
> > +	indir_bytes =3D mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_INDIR]);
> > +	indir_table =3D mnl_attr_get_str(tb[ETHTOOL_A_RSS_INDIR]);
> > +
> > +	hkey_bytes =3D mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_HKEY]);
> > +	hkey =3D mnl_attr_get_str(tb[ETHTOOL_A_RSS_HKEY]);
>=20
> All elements of tb can be NULL, AFAIU.

Didn't get this. Do you mean the variables need to be checked=20
for NULL here? If yes, am checking before printing later on. =20
=20
> > +	rss->indir_size =3D indir_bytes / sizeof(rss->rss_config[0]);
> > +	rss->key_size =3D hkey_bytes;
> > +	rss->hfunc =3D rss_hfunc;
> > +
> > +	memcpy(rss->rss_config, indir_table, indir_bytes);
> > +	memcpy(rss->rss_config + rss->indir_size, hkey, hkey_bytes);
>=20
> Do you only perform this coalescing to reuse the existing print
> helpers? With a bit of extra refactoring this seems avoidable...

Yes. Was reusing print helpers. Have refactored to avoid need for
coalescing.

> > +int get_channels_cb(const struct nlmsghdr *nlhdr, void *data) {

> > +	silent =3D nlctx->is_dump || nlctx->is_monitor;
> > +	err_ret =3D silent ? MNL_CB_OK : MNL_CB_ERROR;
> > +	ret =3D mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
> > +	if (ret < 0)
> > +		return err_ret;
> > +	nlctx->devname =3D get_dev_name(tb[ETHTOOL_A_CHANNELS_HEADER]);
>=20
> We need to check that the kernel has filled in the attrs before
> accessing them, no?

Didn't get this one either. similar code isn't doing any checks=20
like you suggested.

> > +	if (!dev_ok(nlctx))
> > +		return err_ret;
> > +
> > +	args->num_rings =3D
> > +mnl_attr_get_u8(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT]);
>=20
> u32, not u8

Fixed.

> The correct value is combined + rx, I think I mentioned this before.

Have changed it to include rx too like below.=20
args->num_rings =3D mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT])=
;
args->num_rings +=3D mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_RX_COUNT]);

Slightly unrelated, where can I find the reason behind using combined + rx?
Guess it was discussed in mailing list but not able to find it.

> +	return MNL_CB_OK;
>=20
> I'm also not sure if fetching the channel info shouldn't be done over
> the nl2 socket, like the string set. If we are in monitor mode we may
> confuse ourselves trying to parse the wrong messages.

Are you suggesting we need to use ioctl for fetching ring info to avoid
mix-up. Is there alternative way to do it ? =20
