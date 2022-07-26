Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE6358184D
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiGZRYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiGZRX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:23:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1351A2B18B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658856237; x=1690392237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bW8W0SUOkeEpc3+WEtXqRDvyMcGYu1ON1hly8PmAoKA=;
  b=VhRK//9Uss67/WkH6k9M2qE4acuZDyrttQShOUyjONdIGDJCuxU1A9J/
   a1mREm7VKne6vw/LIjU3m8rRz3t9RgjZQcdsGpJ36fQSE2QuDHUgX0LTn
   Z55TRJQcquKl95n2X8R1N0r74KfN/u72mDqp9wN0kiXc+5Dkjpr/boB4H
   A7r9JPGthBV26Te+gi+uSzYZAYglkqv7tCy8K6ZQ0yR6oqbhaCBE0eQ+A
   BSypf7JDaI496pId1Zjijl/Wt4PHuJHt6tGUf3XxIYAdBawJoeeKBC1R4
   xKaX6M2JoKEeHT9P324IUj2u5CMiYpsGD/iYjPPY9LU9BHXsC5M6SNTmu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="289203400"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="289203400"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 10:23:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="627989703"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 26 Jul 2022 10:23:56 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 10:23:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 10:23:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 10:23:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4yFH/bbvKWX8t2bmovqPDZE88R1ka3P+hjLdREl7RDdruxe6aPDu+22WlNqQnVcSR3yaZ+AWMrm5r1Q0DVQeoKSQFrEuojoT5Flpc6CkiV6yiWVAjUy/gyM4K/fLOzbtMlUvwccZgXNij6m34NVcypZ3QxSxJVwEx3tI7Sq2lvk8stcW1dzpdkMJ3GAJn0Ocmky2JT3RAMvJIHSNG4S7WkEFTgNZjCPME2RlxWg1og5o2u1Vfv8cbaZML6HzzPxByElkW/+s6rcIodyUMu+Zj2/7AQpquBgSTkv77JpkSigzADBbCFojd8RxdODJOyqEFFIla5r515O97tk6e7sLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=va09OLHeBfhM8hvSqIeJCxTzfhdBPMDLPxHJvi6DVcs=;
 b=HBakrabsz/cDK9Tm1jYkw2LBPpl4RTvPU+QKfkFHpSGFkd6+nRiv2s75HXcqqpnwwKtpHoFnuCsNemGciDXT5A2ODlyeiVlpihNpRyzJjHG/xiTkOdYUl8Npz+1ZyQndIah2x0X/2KdFzmP/MbCuC8icErwUMzczw0RRh9lZpANkPBdKz3rWJdsWwfBVX2Yg/lA/nUWVX/ZHi9+5pdHo5CkKfm6bVOXnh7nKRUC6K1zICFXUakZX99/CwzECEZVbbQkhKuEUCrB1eHiB+XkcSkStoM4Ewoh4F1YkO+lYNmOJ+5mW05XB24LzjRBVbt0lUhReTRi+WyKiRpHdfDY1Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by SN6PR11MB2703.namprd11.prod.outlook.com (2603:10b6:805:59::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 17:23:53 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 17:23:53 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bCAAAIMAIAAACQQgABOTYCAAQ5cIA==
Date:   Tue, 26 Jul 2022 17:23:53 +0000
Message-ID: <SA2PR11MB5100E4F6642CCF2CD44773A4D6949@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725133246.251e51b9@kernel.org>
        <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
 <20220725181331.2603bd26@kernel.org>
In-Reply-To: <20220725181331.2603bd26@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e44a070c-fb59-43ab-e09b-08da6f2b9d31
x-ms-traffictypediagnostic: SN6PR11MB2703:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CNjyy+6N9H74POqYaCl724lJN1/ObWLNrI3SC1JqTuN6TTSaiJdq8P4+pnzR7VvZvV4v6KRpOUPYh0LroKg2CSTlD47y0mlslLBo00ZJ3RC1rFsL65vjQhXlX8WjHM5exsbcqwPhk7Q4nCWV251hL1YXx7Y1HZc32gBcEvvG9FaUV7DgA2JCzwTia2WxwMduyYcOXwSFzt4maA4TBu8Xnnk3zzY2z0ucbqSm1De5K4R0SoADDbSJZZEKMhOQGyzdHKiF9Q1zBuOamZqUeb2fnTH44kcQlss9l5C0wWmyNs3YDAj3/cM/JVmzudJlcVchxDfCCZb2NRuuNi+CKFVtTG9r56MLNNa2rHTd6PY0lC9AnLS2GdnjN2eweH/YacXCYXr0eRRKzAs/fqQrQHvZxXf9uO61WrRQqfFKeTW86EM3y+Pb1/AaLATz32iKOzaIyfafhSVej4p2/JJDU3iPT7kz44la4MN8uJn0O0XpvQw+KmKD9Tmm3cCX2136Xh0renmmq7nmHk6Kjg0ADjx6SW/M7WjOJyOievzhC54E5rxlkQQTPmzzAwKntgPbm2lF7lw3yTW9eLE4NuALjyjOhaoWZGcLMJg6w2EYiDqXol9ayh86RtExapGyR3W/+bPD/7P+jRxlwEN9fz5t55UoBq3yi8OvzuJsYZ/KAHkUcQtyafweUp5JIPEakKBL5nAAFltqPojqTkjVMfYqhOUCArFsXFj6aKwYi1y4nX8X+lHjck/Ae78Bi8M2mfqts7t3v3pe+COCRNuS0c8pM1j+zuETaqVKCPJbwseVn2yLzk/ANGl2J4pfpwSSmfs7YEBP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(66476007)(64756008)(66446008)(76116006)(4326008)(82960400001)(66946007)(66556008)(15650500001)(5660300002)(38070700005)(122000001)(33656002)(2906002)(8936002)(38100700002)(55016003)(52536014)(26005)(71200400001)(9686003)(186003)(53546011)(6506007)(7696005)(86362001)(478600001)(41300700001)(6916009)(54906003)(316002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3nvFhMj79ihll1IJNe1EIjF0vXbs3kJKSiyP7APVw1Or7KG9z9xpuDjMSKXH?=
 =?us-ascii?Q?Fm+yiPbtiBzXsKTRNZTluXwORSkLmBpxKW66yNd3gzd6FTKNSY0Ob3l+VMnr?=
 =?us-ascii?Q?1Qfq83nmgcE4jXSHIxytc5eYbDfzrpCUTBGIIeKRwvfhK1Gcwhz/YpjbpEA8?=
 =?us-ascii?Q?4nvV4Ba5lvW2TBuxIH8Xt4ywDnge06V4R7yPVR4RlMpgMlbdtJT+JDOlLsSM?=
 =?us-ascii?Q?jC0+q+Nsh8u/VNH7UJrk3kCdw6GUV1/rJFo0Spjl0cpaO/+plrPGOrFPgBCe?=
 =?us-ascii?Q?UGm19niiDlfl2a9aYFBRMu+JimThsPBAaXe17lXKevyS1gAFayWODhlpmiHK?=
 =?us-ascii?Q?iHUyCxSu199YvKaKXGv/eNdpeai5MfWuwPjoFnZR180VQIyfWSrzA/RLGJvq?=
 =?us-ascii?Q?Ch4Yw0IrGhSH8xylygyKy4SSKaZouq9cH0rp6Qcamkn67X6bnRSw231sAdzR?=
 =?us-ascii?Q?P8ocISVxRNOFRRSat3+jwVossiyLEx7XrVtCe/E/j/MxIEH9H0kv57YN3GJ6?=
 =?us-ascii?Q?b+vecgEqN0S/Of4sHeZL9bKbHeMsIuG7pT1zT81qYca1fJFDZ/4D7CLyP/uD?=
 =?us-ascii?Q?6hJg29m0vOLlucRDeG5unU462r1t9V+pm53ycbk8fkekAwUIQr7DRNHO73I/?=
 =?us-ascii?Q?kWSP6ckbtA3T+ybLFjQHJWskei7dT6jveGpSHQ3PE4GfseUFX4m24zLRi+wR?=
 =?us-ascii?Q?0iF631RaOwA880gSOsTXq3eZZZ/vqYl+jec9s0RZEbVh1mSU5rRU/xakmzQS?=
 =?us-ascii?Q?ervdljnVfYTlwvERHEnETcARqUy5dHNe8H5pUKDUV5c5U16o8k6lfJ5bLBAb?=
 =?us-ascii?Q?b+SeKdICmQENYmO7a5HIt2TOzSFZZATo5oYvHlWJm5bh+5okTwERwponk2xY?=
 =?us-ascii?Q?fweuhSn1v23zuDvrWdm8/Z697/dp0lgdmJ4+uhV6WcB0Tqpk7mJUGN3ERqKx?=
 =?us-ascii?Q?F1LgMO7GOrOp04INxiNTfAlQRBK5qAXzbNH74wnS5jyjCWcqJ9+tokqL3kv3?=
 =?us-ascii?Q?o3oBsiYWFSkmG5xd06NawcmIzV6HeaqTpvVGfXyxWSLIaOXUO7HjfaDqvE3G?=
 =?us-ascii?Q?G53TNUl271FCplhjXB8VOxkJrw1IfOz3djbh7nMaZTR5wiVE76jJ0Dwu/4ys?=
 =?us-ascii?Q?aUNVYfcevq7z4RHfoJ30vrWySc51aSJYmU7KJXjJKajMHsO8Yw1PABkBKsWx?=
 =?us-ascii?Q?bP4n0DSeNZNmvrGuS8wKTMpfMY9VHBM5QDZg4FDTsVb6J4db3prvHqs2pdTh?=
 =?us-ascii?Q?Fc1Qa56/k0Sp5Wz1EgNPnze6jewp6oi6Bj1bqlHxmXvsYKBQgZCVDKZNIVM+?=
 =?us-ascii?Q?0ZJP4IJP8/wqwNTTBIPyyMKCUcvaC2iHjXbLCD2wWE5ZVv6xF0tL5xZKi71a?=
 =?us-ascii?Q?tnd9R4mcVyUeYGTDJ1mveMG0wcF+TRwKL3+2wpvSyo5c2hELQt5vnGF2wMtj?=
 =?us-ascii?Q?I79OqQ3ZmvCeHQLmA/bcSXPqdR3mmS9fB5ClFYnfTQDPzWuC6QRp8fQ4xV02?=
 =?us-ascii?Q?hzOvWXuld6B/shFtKENqsdq7/MEnDiPVmWnuYVxlAOLPA6BgLWomb6w/rofd?=
 =?us-ascii?Q?FFC+RH37yWsXf0+kjwIp6k84j6pL+Z0QlPhTpYCr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44a070c-fb59-43ab-e09b-08da6f2b9d31
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 17:23:53.7758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5/Cu0R4BygiQzshpA6gOZLDgNOxq8ib7qH7ttPEC4VNpukKjWZCKdwHZ7wpzvNTVAawB4mltonPUZsANx7JNVHXRz35eEcwnMhDW4PzXpdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2703
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, July 25, 2022 6:14 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> On Mon, 25 Jul 2022 20:46:01 +0000 Keller, Jacob E wrote:
> > There are two problems, and only one of them is solved by strict
> > validation right now:
> >
> > 1) Does the kernel know this attribute?
> >
> > This is the question of whether the kernel is new enough to have the
> > attribute, i.e. does the DEVLINK_ATTR_DRY_RUN even exist in the
> > kernel's uapi yet.
> >
> > This is straight forward, and usually good enough for most
> > attributes. This is what is solved by not setting
> > GENL_DONT_VALIDATE_STRICT.
> >
> > However, consider what happens once we add  DEVLINK_ATTR_DRY_RUN and
> > support it in flash update, in version X. This leads us to the next
> > problem.
> >
> > 2) does the *command* recognize and support DEVLINK_ATTR_DRY_RUN
> >
> > Since the kernel in this example already supports
> > DEVLINK_ATTR_DRY_RUN, it will be recognized and the current setup the
> > policy for attributes is the same for every command. Thus the kernel
> > will accept DEVLINK_ATTR_DRY_RUN for any command, strict or not.
> >
> > But if the command itself doesn't honor DEVLINK_ATTR_DRY_RUN, it will
> > once again be silently ignored.
> >
> > We currently use the same policy and the same attribute list for
> > every command, so we already silently ignore unexpected attributes,
> > even in strict validation, at least as far as I can tell when
> > analyzing the code. You could try to send an attribute for the wrong
> > command. Obviously existing iproute2 user space doesn't' do this..
> > but nothing stops it.
> >
> > For some attributes, its not a problem. I.e. all flash update
> > attributes are only used for DEVLINK_CMD_FLASH_UPDATE, and passing
> > them to another command is meaningless and will likely stay
> > meaningless forever. Obviously I think we would prefer if the kernel
> > rejected the input anyways, but its at least not that surprising and
> > a smaller problem.
> >
> > But for something generic like DRY_RUN, this is problematic because
> > we might want to add support for dry run in the future for other
> > commands. I didn't really analyze every existing command today to see
> > which ones make sense. We could minimize this problem for now by
> > checking DRY_RUN for every command that might want to support it in
> > the future...
>=20
> Hm, yes. Don't invest too much effort into rendering per-cmd policies
> right now, tho. I've started working on putting the parsing policies
> in YAML last Friday. This way we can auto-gen the policy for the kernel
> and user space can auto-gen the parser/nl TLV writer. Long story short
> we can kill two birds with one stone if you hold off until I have the
> format ironed out.

Makes sense, this would definitely simplify writing policy and avoid some d=
uplication that would occur otherwise.

> For now maybe just fork the policies into two -
> with and without dry run attr. We'll improve the granularity later
> when doing the YAML conversion.

Not quite sure I follow this. I guess just add a separate policy array with=
 dry_run and then make that the policy for the flash update command? I don'=
t think flash update is strict yet, and I'm not sure what the impact of cha=
nging it to strict is in terms of backwards compatibility with the interfac=
e.

Thanks,
Jake
