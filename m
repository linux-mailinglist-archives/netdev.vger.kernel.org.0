Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E2A6ADE9B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjCGMXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCGMXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:23:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883D937B51;
        Tue,  7 Mar 2023 04:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678191812; x=1709727812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p5IZuyZe7iDWoRXD49pYIfXr0LLz5rIJEElnZWnKVmI=;
  b=U102+e7rf8E30SG7WkXpDd8aNKCOaQITbEBP1Joux+pVJHidzae5f3lc
   LPWJ+FJQmM7V4HJu0nYLh3CvO0nnsqSDj6TEbdkjJdZ5OI3krpbI3fHJ8
   EpSfbVp85/r37oqhl6PnvCpDsTmCol9bvB2uT6YrRvqvn8iuiU0rtGMxj
   27W3QX7rGXLVcKvBBDOU+PUQYJ482wpbwVWDJW8Zk0n7w4mnCXrFwhMSs
   Fv4B2mAWmFWj37R4fykXOk9T4LRdGYMa135ySaocEguDLr4P7Tc9shcqK
   R2aUtdCkNmkGYPtjbzh77epg4vGMQaezuGss2uBKscxWwjFL1GurQbGua
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="335858886"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="335858886"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 04:23:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="706783405"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="706783405"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 07 Mar 2023 04:23:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 04:23:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 04:23:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 04:23:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrgAhYQ6KWpKDFNSKXF8r2n7+DkqSHkCSaMc5qkVGeIqYPIqkTSOzG0Rla8sVveN9puLV0G0Hqhk4psymwuPT0XEGOH6sIr/MnsLjMHSJJyt+aoGTozVK55lLMEzDSUOOJcgSKhiNZ4bBNbqmz5hDeLryvjLrUruzrd4FostSNvRdEOhHufS2sJhtNrTIgfTOrWkK2wguNK40KNvkStpr47DwR94RUcsiPu0FJeV88ZAen514H9S5ZJ8VOMuLTacI6C67mO57xTtbkm5VbvhkihXJBKU/qu73Tg01KffVPHbwWaSqjRJn/C8AdG3aC6CpjgcFKnEF2FafoBhOA+Hcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7m9h7stJamfLKCWoEjiV+4HCq4OR5h6qURUfvwfHb6M=;
 b=ckEet2pfFupzr2NlY9x6koCfoO6OilCtS22OG7SouLWscV+3zGkLOOKa5tiMbLCD4FXlza0ooKKQLElqJ/MhHu+1iKequ/dQJPFCR1xosA3KpsFvrNUQIsX7+bXhSh8vLYU+xRxrV0k82xPdCaxfov+SksN3RD7WIrXxYK36MZFRrDT7mLYuDW2dggbL9cj36w5CEBiQAiYb0vEMQK1/JcljtVm5i+tVqV9v/5kuJ2X33rQVvcmWWracHVeZ3yBb3SxKI1hE+XIjMr3uVYtmrK0bNV+NjLwQgcR8Cqj+Gkq/xEQQyEGiMP3ByGBHNBeN2ibkX8b5d3SLJiccW1E6Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB7593.namprd11.prod.outlook.com (2603:10b6:510:27f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Tue, 7 Mar 2023 12:23:28 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6156.027; Tue, 7 Mar 2023
 12:23:27 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZKp4K9cfIHTE4HkioJShQwVs1zK6l/jqAgAyiMiCABgMagIAIpJoQgAJf5oCAK+Gx0A==
Date:   Tue, 7 Mar 2023 12:23:27 +0000
Message-ID: <DM6PR11MB4657468307AD658AD2A763FB9BB79@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <20230117180051.2983639-2-vadfed@meta.com> <Y8l63RF8DQz3i0LY@nanopsycho>
 <DM6PR11MB46575F782A66620E1A2D04229BCC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y9ke/+0z3r6WOjWn@nanopsycho>
 <DM6PR11MB46576B19A5DBA46C20AC26679BDA9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y+JdAVZ5hPxrRgvT@nanopsycho>
In-Reply-To: <Y+JdAVZ5hPxrRgvT@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB7593:EE_
x-ms-office365-filtering-correlation-id: 3910683b-ee4d-45a2-0d0a-08db1f06c165
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mvpuzGlVHsMGmPysCmblBzJoZAVNoAnyDiiOKix3ScxZgfhdXBmBaLbblWqbAGzEa4dMcBh8GrgJbtycdDCb6VNPmsKYKy/LP0OTcWojJJoYPYcD8PSnj+6fb7u7vut8in/p9CL9uNBPvLB2/HH0auUMV3wuJsbj7B2cZX3+xHxVMerGBcRohRUae4P1lg1sKvA1nRYSKARNmadzq63pAyAbVJMZNrs1FfS2Dl9cUMPZ2qRWAzALBReKudpUdNeBvc1lzPYMO790eEPU5RtSHqRer3qw6EY06eGJbox8eshiCSGbZeXOU+sv7X834wh9yKZE00J9EawzDiOEITqL6/qdggwdd6hFe0J72jgw4SEezXT62bE5J/MWz908ypUBgLkzUFdELkQIlEMgrShwr8ccHAfAU6jQ8TKvBwTuu6KoaP0Mwlxxau1RNsg2+XGcWj/pqJQGSaCSVznGIqX3RE07Zm9EDiTEHxrAJ4Eu7u9ZOqaCu0tCh7CLaiY4MH0bkFxWG0LVKyMOafOpTak4jw3a7XA5tqqYU2OX73NK9EaVbu/Rdc5OSKyBi3HrcL1M7sBl2/VYuMkl5XN0dGsiPGh7rE6kUv3Vy9nZANzsSuVgYNwt6w6Nj5qfg+sbsztaAV0w7k2KbHK/wSFqMivS3L3oncblDCQBG/GvWNDuFIRerYdtecJxCfO+DZfwQjfqKuSm4mk3zaJqc6pkByEVwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(316002)(83380400001)(54906003)(55016003)(86362001)(33656002)(64756008)(9686003)(186003)(30864003)(82960400001)(76116006)(5660300002)(26005)(478600001)(66946007)(66556008)(8936002)(66476007)(8676002)(2906002)(41300700001)(4326008)(6506007)(107886003)(66446008)(71200400001)(7696005)(6916009)(122000001)(38100700002)(52536014)(38070700005)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XePmtxGYy6ReAnQcASc4wnngDdphbv026mvgaftT82u7oI4U2Z9joMCW02sk?=
 =?us-ascii?Q?iqhwdJDl99AhNrFc3NC3g6XYlJxkcZ//iYMTk4tgMVzDOwfpPFZuKTkJEWrN?=
 =?us-ascii?Q?uXX2fQpjDB2XM19dmzGGaH4E8y8R9u6vkCB7FnPmXShB0p/BPCiMJAFMkg26?=
 =?us-ascii?Q?p/nIDxe1FnQxn9w1U1H7lOe29fnXqBZemdpfrM61J2j+NqsAf7Y/WH6NCelT?=
 =?us-ascii?Q?RhRrSWU6TRxBQT6MXYcC9bnge4AD6lpUEzJRYikxvEiEY9BqsH9AD7esV49k?=
 =?us-ascii?Q?xd5asFpQgy4pwh050rp9Ezqr5n2V1lg5A+ONh0D9gklCrWnWWLnwImhBy67d?=
 =?us-ascii?Q?HpgnIKjzUlnjn0k52roIiSOdcbZOsZPxD/dA/nHXcnk+z9+gODpU+a8/KMEM?=
 =?us-ascii?Q?DRLqMha5TEAnZkdMlCqz4t0+/dUNH+4nhFOPBGZcF9s/2LwWkjU2mwNjCTHo?=
 =?us-ascii?Q?/ExZIyuTvag++Q9Lgh7ZYerWP5rxkhUC0atQkPVYclJ1WMbLmccnbp7GfSpp?=
 =?us-ascii?Q?x6Dd1+3149laPTO2tGsjEgr7pxeBK3jregPwHkz3pTS8DSKuVa7//JcW9CGy?=
 =?us-ascii?Q?dXTv1GFdLcAn/VRxN1NA3ahhPpPWdFKAUg4bmCdiqVFGPL4zq1V/To8C6XwC?=
 =?us-ascii?Q?chuobrRIzKnHxKW17rD2gWFyUyvefStBVZavxV0HAYC5aKLL9M8BvPSzCDm/?=
 =?us-ascii?Q?xM5OLOHtPi9Hv6nxPoKlKWI2DVPUI4XNWPOvnzzFUVXQAYbiKgXFtpD9KRnr?=
 =?us-ascii?Q?wD4HUEH4mFlPnsLQmahVPAmzdarLbiOacjVuP7ok7NGFRlUvFZLXFCyQdAxd?=
 =?us-ascii?Q?9QqvwTLSVuJDv8Li3LhTMTzLWMZoOz3c4thhNULYItcYdaDb2HPrQj43D1S7?=
 =?us-ascii?Q?RWSjRtZcpS9yVpLTfv23XYNF844ew00j5lPuqW6Ikq+UNSxIg2h3pRDyR4+W?=
 =?us-ascii?Q?KmeXKRXDh/+RS7AfbY/9Bp/+20Un/FpB06TI+RNUGzXDIzBMd77MVaCdUflN?=
 =?us-ascii?Q?dY+Y+wFPNMxx4hhWBYelro4NfX22XELGaZfx03UwWKkhuKyoghIWdq2GaPlS?=
 =?us-ascii?Q?h3okvkEshqKdlToBALiueyRdDiGDu1OJZfpaFEzcsX4Df2yAJlJJxqy27oqB?=
 =?us-ascii?Q?mLCqHfxEYYvdGMW9GPpFavSfn6Hh7Zijay5Kv6Bww9tC1HGVkxQmSSEVi+FH?=
 =?us-ascii?Q?W74e7MnwRPOchP0P217h1D2oADFc1FkvAAAb3VHCBeoUpvLfTcloOqHQnjb5?=
 =?us-ascii?Q?sDV8MRzYm8n7V9InDrvowQAurgwAyjXzAwFse36B3zvYd6/gsvvtHAwu9IsI?=
 =?us-ascii?Q?ZQxALBEA5oKgZDDHBNmZ0P3eB7c3X7D4m7m/doOzlVczf7p0y7vbwe5x8nS4?=
 =?us-ascii?Q?E80CbsFLJ03yXCN9InUfUTL8Ivfwu0QK2lVBlXmSFNNohud3DPrP9LFCfrYP?=
 =?us-ascii?Q?E8fggLcd4Ur3egmZjFwURmR1Lxa3NIkh6028r6N0kgV0JmGXjobtFSCR33bO?=
 =?us-ascii?Q?D1S7IbErPn+sWiw3egi3P6Ei2ckzR6CYbr/BbDsTx41UheI3SCq2p8aGQCRC?=
 =?us-ascii?Q?j8t0NPKldGH2Ogmwr7q0JkS6Mi7ElGvOQ3mToz9vMoCVCDx4UkFBMUDnEa6S?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3910683b-ee4d-45a2-0d0a-08db1f06c165
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 12:23:27.7478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6mdgKaLOVZwwfoc+hHPNVdiApCBvc/ZlO3fzKt69QCb0HiAM5VNqKfHZTJjhpDx8xFtb3hbiPDdvOIi8MGc3njmTxUwEgV+EvhzJiBfgg4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, February 7, 2023 3:15 PM
>
>Mon, Feb 06, 2023 at 03:00:09AM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Tuesday, January 31, 2023 3:01 PM
>>>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>>>Cc: Vadim Fedorenko <vadfed@meta.com>; Jakub Kicinski
>>><kuba@kernel.org>; Jonathan Lemon <jonathan.lemon@gmail.com>; Paolo
>>>Abeni <pabeni@redhat.com>; netdev@vger.kernel.org;
>>>linux-arm-kernel@lists.infradead.org; linux- clk@vger.kernel.org;
>>>Olech, Milena <milena.olech@intel.com>; Michalik, Michal
>>><michal.michalik@intel.com>
>>>Subject: Re: [RFC PATCH v5 1/4] dpll: Add DPLL framework base
>>>functions
>>>
>>>Fri, Jan 27, 2023 at 07:12:41PM CET, arkadiusz.kubalewski@intel.com
>>wrote:
>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>Sent: Thursday, January 19, 2023 6:16 PM
>>>>>
>>>>>Tue, Jan 17, 2023 at 07:00:48PM CET, vadfed@meta.com wrote:
>
>[...]
>
>
>>>>>>+			 struct dpll_pin_ops *ops, void *priv) {
>>>>>>+	struct dpll_pin *pin;
>>>>>>+	int ret;
>>>>>>+
>>>>>>+	mutex_lock(&dpll_pin_owner->lock);
>>>>>>+	pin =3D dpll_pin_get_by_description(dpll_pin_owner,
>>>>>>+					  shared_pin_description);
>>>>>>+	if (!pin) {
>>>>>>+		ret =3D -EINVAL;
>>>>>>+		goto unlock;
>>>>>>+	}
>>>>>>+	ret =3D dpll_pin_register(dpll, pin, ops, priv);
>>>>>>+unlock:
>>>>>>+	mutex_unlock(&dpll_pin_owner->lock);
>>>>>>+
>>>>>>+	return ret;
>>>>>
>>>>>I don't understand why there should be a separate function to
>>>>>register the shared pin. As I see it, there is a pin object that
>>>>>could be registered with 2 or more dpll devices. What about having:
>>>>>
>>>>>pin =3D dpll_pin_alloc(desc, type, ops, priv)
>>>>>dpll_pin_register(dpll_1, pin); dpll_pin_register(dpll_2, pin);
>>>>>dpll_pin_register(dpll_3, pin);
>>>>>
>>>>
>>>>IMHO your example works already, but it would possible only if the
>>>>same driver instance initializes all dplls.
>>>
>>>It should be only one instance of dpll to be shared between driver
>>>instances as I wrote in the reply to the "ice" part. There might he
>>>some pins created alongside with this.
>>>
>>
>>pin =3D dpll_pin_alloc(desc, type, ops, priv) dpll_pin_register(dpll_1,
>>pin); dpll_pin_register(dpll_2, pin); dpll_pin_register(dpll_3, pin); ^
>>there is registration of a single pin by a 3 dpll instances, and a
>>kernel module instance which registers them has a reference to the pin
>>and all dplls, thus it can just register them all without any problems,
>>don't need to call dpll_shared_pin_register(..).
>>
>>Now imagine 2 kernel module instances.
>>One (#1) creates one dpll, registers pins with it.
>>Second (#2) creates second dpll, and want to use/register pins of dpll
>>registered by the first instance (#1).
>
>Sure, both instances should be available to both module instances, using
>the suggested get/put create/reference system.
>Whichever module instance does register shared pin can use
>dpll_pin_register(), I see no problem with that.
>

In v6 those suggestions are implemented.
AFAIK Vadim shall send it soon.

>
>>
>>>My point is, the first driver instance which creates dpll registers
>>>also the pins. The other driver instance does not do anything, just
>>>gets reference to the dpll.
>>>
>>>On cleanup path, the last driver instance tearing down would
>>>unregister dpll pins (Could be done automatically by dpll_device_put()).
>>>
>>>There might be some other pins (Synce) created per driver instance
>>>(per-PF). You have to distinguish these 2 groups.
>>>
>>>
>>>>dpll_shared_pin_register is designed for driver instances without the
>>>>pin
>>>
>>>I think we need to make sure the terms are correct "sharing" is
>>>between multiple dpll instances. However, if 2 driver instances are
>>>sharing the same dpll instance, this instance has pins. There is no
>>>sharing unless there is another dpll instance in picture. Correct?
>>>
>>
>>Yes!
>>If two kernel module intances sharing a dpll instance, the pins belong
>>to the dpll instance, and yes each kernel module instance can register
>>pins with that dpll instance just with: dpll_pin_register(dpll_1, pin);
>>
>>dpll_shared_pin_register(..) shall be used when separated kernel module
>>instances are initializing separated dpll instances, and those
>>instances are
>
>Why exacly would they do that? Could you please draw me an example?
>

I think we shall not follow this discussion as in v6 we already
have the mechanics you suggested, but sure:
+----------+                =20
|i0 - GPS  |--------------\
+----------+              |
+----------+              |
|i1 - SMA1 |------------\ |
+----------+            | |
+----------+            | |
|i2 - SMA2 |----------\ | |
+----------+          | | |
                      | | |
+---------------------|-|-|-------------------------------------------+
| Channel A / FW0     | | |     +-------------+   +---+   +--------+  |
|                     | | |-i0--|Synchronizer0|---|   |---| PHY0.0 |--|
|         +---+       | | |     |             |   |   |   +--------+  |
| PHY0.0--|   |       | |---i1--|             |---| M |---| PHY0.1 |--|
|         |   |       | | |     | +-----+     |   | A |   +--------+  |
| PHY0.1--| M |       |-----i2--| |DPLL0|     |   | C |---| PHY0.2 |--|
|         | U |       | | |     | +-----+     |   | 0 |   +--------+  |
| PHY0.2--| X |--+----------i3--| +-----+     |---|   |---| ...    |--|
|         | 0 |  |    | | |     | |DPLL1|     |   |   |   +--------+  |
| ...   --|   |  | /--------i4--| +-----+     |---|   |---| PHY0.7 |--|
|         |   |  | |  | | |     +-------------+   +---+   +--------+  |
| PHY0.7--|   |  | |  | | |                                           |
|         +---+  | |  | | |                                           |
+----------------|-|--|-|-|-------------------------------------------+
| Channel B / FW1| |  | | |     +-------------+   +---+   +--------+  |
|                | |  | | \-i0--|Synchronizer1|---|   |---| PHY1.0 |--|
|         +---+  | |  | |       |             |   |   |   +--------+  |
| PHY1.0--|   |  | |  | \---i1--|             |---| M |---| PHY1.1 |--|
|         |   |  | |  |         | +-----+     |   | A |   +--------+  |
| PHY1.1--| M |  | |  \-----i2--| |DPLL0|     |   | C |---| PHY1.2 |--|
|         | U |  | |            | +-----+     |   | 1 |   +--------+  |
| PHY1.2--| X |  \-|--------i3--| +-----+     |---|   |---| ...    |--|
|         | 1 |    |            | |DPLL1|     |   |   |   +--------+  |
| ...   --|   |----+--------i4--| +-----+     |---|   |---| PHY1.7 |--|
|         |   |                 +-------------+   +---+   +--------+  |
| PHY1.7--|   |                                                       |
|         +---+                                                       |
+---------------------------------------------------------------------+

>
>>physically sharing their pins.
>>
>>>
>
>[...]
>
>
>>>>>>+static int dpll_msg_add_pin_modes(struct sk_buff *msg,
>>>>>>+				   const struct dpll_device *dpll,
>>>>>>+				   const struct dpll_pin *pin) {
>>>>>>+	enum dpll_pin_mode i;
>>>>>>+	bool active;
>>>>>>+
>>>>>>+	for (i =3D DPLL_PIN_MODE_UNSPEC + 1; i <=3D DPLL_PIN_MODE_MAX; i++)=
 {
>>>>>>+		if (dpll_pin_mode_active(dpll, pin, i, &active))
>>>>>>+			return 0;
>>>>>>+		if (active)
>>>>>>+			if (nla_put_s32(msg, DPLLA_PIN_MODE, i))
>>>>>
>>>>>Why this is signed?
>>>>>
>>>>
>>>>Because enums are signed.
>>>
>>>You use negative values in enums? Don't do that here. Have all netlink
>>>atrributes unsigned please.
>>>
>>
>>No, we don't use negative values, but enum is a signed type by itself.
>>Doesn't seem right thing to do, put signed-type value into unsigned type =
TLV.
>>This smells very bad.
>
>Well, then all existing uses that carry enum over netlink attributes smell
>bad. The enum values are all unsigned, I see no reason to use S*.
>Please be consistent with the rest of the Netlink uAPI.
>

Yes, exactly, don't know why to follow bad practicies, saying "that's how i=
t's
done". Is there any reasoning behind this?

>
>[...]
>
>>>>>>+
>>>>>>+/* dpll_pin_signal_type - signal types
>>>>>>+ *
>>>>>>+ * @DPLL_PIN_SIGNAL_TYPE_UNSPEC - unspecified value
>>>>>>+ * @DPLL_PIN_SIGNAL_TYPE_1_PPS - a 1Hz signal
>>>>>>+ * @DPLL_PIN_SIGNAL_TYPE_10_MHZ - a 10 MHz signal
>>>>>
>>>>>Why we need to have 1HZ and 10MHZ hardcoded as enums? Why can't we
>>>>>work with HZ value directly? For example, supported freq:
>>>>>1, 10000000
>>>>>or:
>>>>>1, 1000
>>>>>
>>>>>freq set 10000000
>>>>>freq set 1
>>>>>
>>>>>Simple and easy.
>>>>>
>>>>
>>>>AFAIR, we wanted to have most commonly used frequencies as enums +
>>>>custom_freq for some exotic ones (please note that there is also
>>>>possible 2PPS, which is
>>>>0.5 Hz).
>>>
>>>In this exotic case, user might add divider netlink attribute to
>>>divide the frequency pass in the attr. No problem.
>>>
>>>
>>>>This was design decision we already agreed on.
>>>>The userspace shall get definite list of comonly used frequencies
>>>>that can be used with given HW, it clearly enums are good for this.
>>>
>>>I don't see why. Each instance supports a set of frequencies. It would
>>>pass the values to the userspace.
>>>
>>>I fail to see the need to have some fixed values listed in enums.
>>>Mixing approaches for a single attribute is wrong. In ethtool we also
>>>don't have enum values for 10,100,1000mbits etc. It's just a number.
>>>
>>
>>In ethtool there are defines for linkspeeds.
>>There must be list of defines/enums to check the driver if it is supporte=
d.
>>Especially for ANY_FREQ we don't want to call driver 25 milions times or
>>more.
>
>Any is not really *any* is it? A simple range wouldn't do then? It would b=
e
>much better to tell the user the boundaries.
>

In v6 those suggestions are implemented.

>
>>
>>Also, we have to move supported frequencies to the dpll_pin_alloc as it
>>is constant argument, supported frequencies shall not change @ runtime?
>>In such case there seems to be only one way to pass in a nice way, as a
>>bitmask?
>
>array of numbers (perhaps using defines for most common values), I don't
>see any problem in that. But you are talking about in-kernel API. Does not
>matter that much. What we are discussing is uAPI and that matters a lot.
>
>
>>
>>Back to the userspace part, do you suggest to have DPLLA_PIN_FREQ
>>attribute and translate kernelspace enum values to userspace defines
>>like DPLL_FREQ_1_HZ, etc? also with special define for supported ones
>>ANY_FREQ?
>
>Whichever is convenient. My focus here is uAPI.
>

In v6 those suggestions are implemented.

>
>>
>>>
>>>>
>>>>>
>>>>>>+ * @DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ - custom frequency signal,
>>>>>>+ value
>>>>>>defined
>>>>>>+ *	with pin's DPLLA_PIN_SIGNAL_TYPE_CUSTOM_FREQ attribute
>>>>>>+ **/
>>>>>>+enum dpll_pin_signal_type {
>>>>>>+	DPLL_PIN_SIGNAL_TYPE_UNSPEC,
>>>>>>+	DPLL_PIN_SIGNAL_TYPE_1_PPS,
>>>>>>+	DPLL_PIN_SIGNAL_TYPE_10_MHZ,
>>>>>>+	DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ,
>>>>>>+
>>>>>>+	__DPLL_PIN_SIGNAL_TYPE_MAX,
>>>>>>+};
>>>>>>+
>>>>>>+#define DPLL_PIN_SIGNAL_TYPE_MAX (__DPLL_PIN_SIGNAL_TYPE_MAX - 1)
>>>>>>+
>>>>>>+/* dpll_pin_mode - available pin states
>>>>>>+ *
>>>>>>+ * @DPLL_PIN_MODE_UNSPEC - unspecified value
>>>>>>+ * @DPLL_PIN_MODE_CONNECTED - pin connected
>>>>>>+ * @DPLL_PIN_MODE_DISCONNECTED - pin disconnected
>>>>>>+ * @DPLL_PIN_MODE_SOURCE - pin used as an input pin
>>>>>>+ * @DPLL_PIN_MODE_OUTPUT - pin used as an output pin  **/ enum
>>>>>>+dpll_pin_mode {
>>>>>>+	DPLL_PIN_MODE_UNSPEC,
>>>>>>+	DPLL_PIN_MODE_CONNECTED,
>>>>>>+	DPLL_PIN_MODE_DISCONNECTED,
>>>>>>+	DPLL_PIN_MODE_SOURCE,
>>>>>>+	DPLL_PIN_MODE_OUTPUT,
>>>>>
>>>>>I don't follow. I see 2 enums:
>>>>>CONNECTED/DISCONNECTED
>>>>>SOURCE/OUTPUT
>>>>>why this is mangled together? How is it supposed to be working. Like
>>>>>a bitarray?
>>>>>
>>>>
>>>>The userspace shouldn't worry about bits, it recieves a list of
>>>attributes.
>>>>For current/active mode: DPLLA_PIN_MODE, and for supported modes:
>>>>DPLLA_PIN_MODE_SUPPORTED. I.e.
>>>>
>>>>	DPLLA_PIN_IDX			0
>>>>	DPLLA_PIN_MODE			1,3
>>>>	DPLLA_PIN_MODE_SUPPORTED	1,2,3,4
>>>
>>>I believe that mixing apples and oranges in a single attr is not correct=
.
>>>Could you please split to separate attrs as drafted below?
>>>
>>>>
>>>>The reason for existance of both DPLL_PIN_MODE_CONNECTED and
>>>>DPLL_PIN_MODE_DISCONNECTED, is that the user must request it somehow,
>>>>and bitmask is not a way to go for userspace.
>>>
>>>What? See nla_bitmap.
>>>
>>
>>AFAIK, nla_bitmap is not yet merged.
>
>NLA_BITFIELD32
>
>
>>
>>>Anyway, why can't you have:
>>>DPLLA_PIN_CONNECTED     u8 1/0 (bool)
>>>DPLLA_PIN_DIRECTION     enum { SOURCE/OUTPUT }
>>
>>Don't get it, why this shall be u8 with bool value, doesn't make much
>>sense for userspace.
>
>Could be NLA_FLAG.
>
>
>>All the other attributes have enum type, we can go with separated
>>attribute:
>>DPLLA_PIN_STATE		enum { CONNECTED/DISCONNECTED }
>
>Yeah, why not. I think this is probably better and more explicit than
>NLA_FLAG.
>
>
>>Just be consistent and clear, and yes u8 is enough it to keep it, as
>>well as all of attribute enum values, so we can use u8 instead of u32 for
>>all of them.
>
>Yes, that is what is done normally for attrs like this.
>
>

In v6, there are enums and attributes:
DPLL_A_PIN_STATE	enum { CONNECTED/DISCONNECTED }
DPLL_A_PIN_DIRECTION	enum { SOURCE/OUTPUT }

also new capabilities attributes DPLL_A_PIN_DPLL_CAPS
a bitmap - implicit from u32 value.

>>
>>Actually for "connected/disconnected"-part there are 2 valid use-cases
>>on my
>>mind:
>>- pin can be connected with a number of "parents" (dplls or muxed-pins)
>>- pin is disconnected entirely
>>Second case can be achieved with control over first one, thus not need
>>for any special approach here. Proper control would be to let userspace
>>connect or disconnect a pin per each node it can be connected with, right=
?
>>
>>Then example dump of "get-pins" could look like this:
>>DPLL_PIN	(nested)
>>	DPLLA_PIN_IDX		0
>>	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_EXT
>>	DPLLA_PIN_DIRECTION	SOURCE
>>	...
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		0
>>		DPLLA_NAME		pci_0000:00:00.0
>
>Nit, make sure you have this as 2 attrs, busname, devname.

Sure.

>
>
>>		DPLLA_PIN_STATE		CONNECTED
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		1
>>		DPLLA_NAME		pci_0000:00:00.0
>>		DPLLA_PIN_STATE		DISCONNECTED
>>
>>DPLL_PIN	(nested)
>>	DPLLA_PIN_IDX		1
>>	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_MUX
>>	DPLLA_PIN_DIRECTION	SOURCE
>>	...
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		0
>>		DPLLA_NAME		pci_0000:00:00.0
>>		DPLLA_PIN_STATE		DISCONNECTED
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		1
>>		DPLLA_NAME		pci_0000:00:00.0
>>		DPLLA_PIN_STATE		CONNECTED
>>
>>DPLL_PIN	(nested)
>>	DPLLA_PIN_IDX		2
>>	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_MUX
>>	DPLLA_PIN_DIRECTION	SOURCE
>>	...
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		0
>>		DPLLA_NAME		pci_0000:00:00.0
>>		DPLLA_PIN_STATE		DISCONNECTED
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		1
>>		DPLLA_NAME		pci_0000:00:00.0
>>		DPLLA_PIN_STATE		DISCONNECTED
>
>Okay.
>
>
>>
>>(similar for muxed pins)
>>DPLL_PIN	(nested)
>>	DPLLA_PIN_IDX		3
>>	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_SYNCE_ETH_PORT
>>	DPLLA_PIN_DIRECTION	SOURCE
>>	DPLLA_PIN_PARENT		(nested)
>>		DPLLA_PIN_IDX		1
>>		DPLLA_PIN_STATE		DISCONNECTED
>>	DPLLA_PIN_PARENT		(nested)
>>		DPLLA_PIN_IDX		2
>>		DPLLA_PIN_STATE		CONNECTED
>>
>>DPLL_PIN	(nested)
>>	DPLLA_PIN_IDX		4
>>	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_SYNCE_ETH_PORT
>>	DPLLA_PIN_DIRECTION	SOURCE
>>	DPLLA_PIN_PARENT		(nested)
>>		DPLLA_PIN_IDX		1
>>		DPLLA_PIN_STATE		CONNECTED
>>	DPLLA_PIN_PARENT		(nested)
>>		DPLLA_PIN_IDX		2
>>		DPLLA_PIN_STATE		DISCONNECTED
>
>Looks fine.
>
>
>>
>>For DPLL_MODE_MANUAL a DPLLA_PIN_STATE would serve also as signal
>>selector mechanism.
>
>Yep, I already make this point in earlier rfc review comment.
>

Thanks for that :)

>
>>In above example DPLL_ID=3D0 has only "connected" DPLL_PIN_IDX=3D0, now
>>when different pin "connect" is requested:
>>
>>dpll-set request:
>>DPLLA_DPLL	(nested)
>>	DPLLA_ID=3D0
>>	DPLLA_NAME=3Dpci_0000:00:00.0
>>DPLLA_PIN
>>	DPLLA_PIN_IDX=3D2
>>	DPLLA_PIN_CONNECTED=3D1
>>
>>Former shall "disconnect"..
>>And now, dump pin-get:
>>DPLL_PIN	(nested)
>>	DPLLA_PIN_IDX		0
>>	...
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		0
>>		DPLLA_NAME		pci_0000:00:00.0
>>		DPLLA_PIN_STATE		DISCONNECTED
>>...
>>DPLL_PIN	(nested)
>>	DPLLA_PIN_IDX		2
>>	...
>>	DPLLA_DPLL			(nested)
>>		DPLLA_ID		0
>>		DPLLA_NAME		pci_0000:00:00.0
>>		DPLLA_PIN_STATE		CONNECTED
>>
>>At least that shall happen on hardware level, right?
>>
>>As I can't find a use-case to have a pin "connected" but not "selected"
>>in case of DPLL_MODE_MANUAL.
>
>Exactly.
>
>
>>
>>A bit different is with DPLL_MODE_AUTOMATIC, the pins that connects
>>with dpll directly could be all connected, and their selection is
>>auto-controlled with a DPLLA_PIN_PRIO.
>>But still the user may also request to disconnect a pin - not use it at
>>all (instead of configuring lowest priority - which allows to use it,
>>if all other pins propagate invalid signal).
>>
>>Thus, for DPLL_MODE_AUTOMATIC all ablove is the same with a one
>>difference, each pin/dpll pair would have a prio, like suggested in the
>other email.
>>DPLLA_PIN	(nested)
>>	...
>>	DPLLA_DPLL	(nested)
>>		...
>>		DPLLA_PIN_CONNECTED	<connected value>
>>		DPLLA_PIN_STATE		<prio value>
>
>I think you made a mistake. Should it be:
>		DPLLA_PIN_STATE		<connected value>
>		DPLLA_PIN_PRIO		<prio value>
>?
>

Yes, exactly.

>
>>
>>Which basically means that both DPLL_A_PIN_PRIO and DPLLA_PIN_STATE
>>shall be a property of a PIN-DPLL pair, and configured as such.
>
>Yes.
>
>
>>
>>
>>>DPLLA_PIN_CAPS          nla_bitfield(CAN_CHANGE_CONNECTED,
>>>CAN_CHANGE_DIRECTION)
>>>
>>>We can use the capabilitis bitfield eventually for other purposes as
>>>well, it is going to be handy I'm sure.
>>>
>>
>>Well, in general I like the idea, altough the details...
>>We have 3 configuration levels:
>>- DPLL
>>- DPLL/PIN
>>- PIN
>>
>>Considering that, there is space for 3 of such CAPABILITIES attributes, b=
ut:
>>- DPLL can only configure MODE for now, so we can only convert
>>DPLL_A_MODE_SUPPORTED to a bitfield, and add DPLL_CAPS later if
>>required
>
>Can't do that. It's uAPI, once you have ATTR there, it's there for
>eternity...
>

I am not saying to remove something but add in the future.

>
>>- DPLL/PIN pair has configurable DPLLA_PIN_PRIO and DPLLA_PIN_STATE, so
>>we could introduce DPLLA_PIN_DPLL_CAPS for them
>
>Yeah.
>
>
>>- PIN has now configurable frequency (but this is done by providing
>>list of supported ones - no need for extra attribute). We already know
>>that pin shall also have optional features, like phase offset, embedded
>>sync.
>>For embedded sync if supported it shall also be a set of supported
>>frequencies.
>>Possibly for phase offset we could use similar CAPS field, but don't
>>think will manage this into next version.
>>
>>>
>>>
>>>>
>>>>
>>>>>
>>>>>>+
>>>>>>+	__DPLL_PIN_MODE_MAX,
>>>>>>+};
>>>>>>+
>>>
>>>[...]
>>>
>>>
>>>>>>+/**
>>>>>>+ * dpll_mode - Working-modes a dpll can support. Modes
>>>>>>+differentiate
>>>>>>>how
>>>>>>+ * dpll selects one of its sources to syntonize with a source.
>>>>>>+ *
>>>>>>+ * @DPLL_MODE_UNSPEC - invalid
>>>>>>+ * @DPLL_MODE_MANUAL - source can be only selected by sending a
>>>>>>+ request
>>>>>>to dpll
>>>>>>+ * @DPLL_MODE_AUTOMATIC - highest prio, valid source, auto
>>>>>>+ selected by
>>>>>>dpll
>>>>>>+ * @DPLL_MODE_HOLDOVER - dpll forced into holdover mode
>>>>>>+ * @DPLL_MODE_FREERUN - dpll driven on system clk, no holdover
>>>>>>available
>>>>>>+ * @DPLL_MODE_NCO - dpll driven by Numerically Controlled
>>>>>>+ Oscillator
>>>>>
>>>>>Why does the user care which oscilator is run internally. It's
>>>>>freerun, isn't it? If you want to expose oscilator type, you should
>>>>>do it elsewhere.
>>>>>
>>>>
>>>>In NCO user might change frequency of an output, in freerun cannot.
>>>
>>>How this could be done?
>>>
>>
>>I guess by some internal synchronizer frequency dividers. Same as other
>>output (different then input) frequencies are achievable there.
>
>I ment uAPI wise. Speak Netlink.
>

1. DPLL_MODE_NCO is returned with DPLL_A_MODE_SUPPORTED when HW supports it=
.
2. DPLL_MODE_NCO is requested by the user if user wants control output
frequency or output frequency offset of a dpll.

From the documentation of ZL80032:
* Numerically controlled oscillator (NCO) behavior allows system software t=
o=20
steer DPLL frequency or synthesizer frequency with resolution better than 0=
.005
ppt
* Similar to freerun mode, but with frequency control. The output clock is =
the
configured frequency with a frequency offset specified by the dpll_df_offse=
t_x
register. This write-only register changes the output frequency offset of t=
he
DPLL


Thank you,
Arkadiusz

>>
>>Thanks,
>>Arkadiusz
>>
>>>
>>>[...]
>>
