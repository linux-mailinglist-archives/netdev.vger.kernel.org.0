Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E205835B1
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiG0Xhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 19:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiG0Xhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 19:37:33 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C94FBBB
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 16:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658965052; x=1690501052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=996E9aIEwLuAFTwSq1fEuE9wbjoZutdg755FJhLZ6sc=;
  b=PAtD1W6+/2PMOK3ADVRiXAwE5GcSiw/UCuhA6fyuAmijy0zjCmusLK6Q
   JLK1D1qekbjRNGERE35qaH1ZpP3PYYM/GoNQvNpGHF2FRlLDTzCkMp9Xm
   1hrEyyaVhRRsLc5ZJn2QWE5Py90TPD0yXD/3T6M+k1mpLQcljEYL0xEyw
   d58D4+j5HwzZgcqtchZ4bc8aPZNk+EpoaQBmFqATdisSQf0RPfrEhTGF7
   JNEaS/kqwor2pZZXNzeAr7wdQefQH5cEAXoy4jKTP7CjMWYa5+GQhWHO0
   ftPPifVGj+KKefHyV7D1qUxQyh0fLpVBSUiOEAuGnpc2BYtsqSnh/SKzQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="314158398"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="314158398"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 16:37:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="633399377"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 27 Jul 2022 16:37:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 16:37:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 27 Jul 2022 16:37:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 27 Jul 2022 16:37:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8VHTqHzaG+Gl7hWAuh8/jwSthgJwuvBIA9k7ZYMzEyFA6xzNP0HTzaWV93p82PJwmd5Lq35nT6F772r9JuB3P2hodohWnBmqyLaNEPdoIPRzkSSODoijLyBGB66Nbea1JwobYFc0QZynS5V1ebT16jOTY9nWeH5DLpx5sXMZ61JdPHULouI12yNqlp3vBJYuGOPUZC+eQiJYkwdH25UMHQIjdMKco19KP9WVnG6eJZ/r5hSApTB+vY3mVdemPx9Gp9iaS3CpidjAqd4XUYa3KZ+Raj5a99+dj8aDGpitbxlG52nQvYbqpVLX/JcsLHtVKhJ0UrhmpeINCCGUT4uGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdstnZ+29MamaMAnhVeVOaLMK/ukwEPtGtNmPR3BPxM=;
 b=LwDIXc4yexiEQ/8hXTUyEM7NzF7wbcD6Z+xuyimDgnG/5W+g1W7nQz/NRvEiokG5KRsBDmMpxwZru5gTrOwjyuJa4uMzyypjLRUCBCFn0qBig+M+asBmXH4KFImq12S0qHDvNLPsQ90PJiH6rIT54dZkEtmm1z98zJgzKCwKmSSKguqrJyqpBBsXUCVGUO4MWFzbnddUlNtoLeQMsCH20+9ePId4fmcbdN1KiNxE60zfCXGL45sNQb2TDMW/kRYXe+nm7erVjPvtYIlIbJPCvsnAMWxPIsoLe7XJOaZ3i9qF74i0nLJ7Ue21Majv5gMdGtLrjG3N41AFmqfcwc46gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by SJ0PR11MB5867.namprd11.prod.outlook.com (2603:10b6:a03:42a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 23:37:28 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::2139:9648:f6e8:dafb]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::2139:9648:f6e8:dafb%5]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 23:37:27 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Zhang, Xuejun" <xuejun.zhang@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>
Subject: RE: [PATCH net 3/3] iavf: enable tc filter configuration only if
 hw-tc-offload is on
Thread-Topic: [PATCH net 3/3] iavf: enable tc filter configuration only if
 hw-tc-offload is on
Thread-Index: AQHYoEkakxPjj3e550OxoS73DH+LTK2P8wuAgALdkyA=
Date:   Wed, 27 Jul 2022 23:37:27 +0000
Message-ID: <IA1PR11MB6266229ADD3AF60477F4FE04E4979@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
        <20220725170452.920964-4-anthony.l.nguyen@intel.com>
 <20220725194547.0702bd73@kernel.org>
In-Reply-To: <20220725194547.0702bd73@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15311a9b-259c-48a3-a00a-08da7028f765
x-ms-traffictypediagnostic: SJ0PR11MB5867:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OF2aJ1Qnl6IXhPY6tmcI8AGkoxTJ5OkY8HeTNOcHf4Hjce2NVEaeFve7UJDopRCEQTwjVnz1RoNRR7Oyudum7stJgVdO3ISKJvJv54MUOGPhVcnInEvIkS8gZxpARcF4KAWqpknRuHsgpnnufITu9VG6YDO1GZcOdqjzpNu4PcJxBXhtcTuHDqwVE0wggUR4Zq+b10Kh8E2CSLfUtxHAYcgpUh6jODkE9+3PnPOOyWhLSxlei26YwLWNpgwha7s4tkamf3OjkMWq3zhrDsTjSH/Uwx12/jeOEqQaPOw9lxyNHPobUl+sYSrokYP16sSG1FeP480K8yPeLHJh3MpLT18IcqG+DYiH4eUG3CMW8M/3nmbRTFitIBftj2bVI04Taw2ae9WbjVRUvqtU+zPYobbgXpnvAKPzvVK4F1mrIZweSXT9q4L8SXhQaK9ghxXy1shTECbhWziSBborK3NzdZnwNJ9OT8yq85UfBksOO2O5T4kkjohIg1jly/3QI+ohfuqR6LxmGq0K6zfoXBUg4FlDcYdcDXDQrcm3KgB8ocoGGbGNAZ4df8jHT//i3lqi75I6dMgcqO0hDcxB1DVg08wRSMZpNKE7JN2MAwKR/urN/RxtL6sNzX1C84MGX0N0CHbsBAxlOAmiwFF5jF9yiwmiSttD9h+sXiCp7fsjkiC1W1TChiqJNVWj7exsef4n4wv3VfCXWZ3F3giZZ5CH3WtY9Nzwst/itiw0OVA0zlz94JQ9JXpLDOVjEZ2rug4LjOhOMwbJ2qhD3exh4KikP6QnGaFzlb2WK88EN8XyVnGdWD/f/km/8VvEW/LWdQN1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(136003)(346002)(396003)(366004)(8676002)(33656002)(71200400001)(316002)(86362001)(82960400001)(38100700002)(122000001)(53546011)(478600001)(107886003)(41300700001)(6506007)(7696005)(54906003)(110136005)(6636002)(9686003)(26005)(4326008)(64756008)(2906002)(186003)(8936002)(5660300002)(52536014)(76116006)(66476007)(66946007)(66446008)(66556008)(83380400001)(55016003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6zarAZ0zt7FEmAn8yBqw02X8eImBB/D/30/HQsQDlAdCQ8nvxuMpBsZiH1mW?=
 =?us-ascii?Q?sMZVL+tMgPa/w/BMVu58zxpq+1+lCoD80l40JOkTLIoitp7OVSdu4HLdx1hO?=
 =?us-ascii?Q?GUr1+gSV2ukYvNEyjGURzOvfWhmCK5pS/qpkiUkZX78OayCkcQqcq53G9KLa?=
 =?us-ascii?Q?hqPq9e87CebCLp6ATebEpzzgkqZndcbrL9TD5NTs0hhXOGJjMF7dqoLGkskr?=
 =?us-ascii?Q?Hwl1jmIJJ3QW8esh/82rZ6UsMYkoQAhZdR1jDWHp6WQumht78bg3nlEQVhrr?=
 =?us-ascii?Q?UOnhbOQ6oVaQKP7WtamNT/rHYcahb2DKP4I2AlMpeNjLhXwcVP9Hm7T3b31f?=
 =?us-ascii?Q?Vw/eulKPkANyZD+1vnBszmZRm+054RNu7DfWWI+YmE6SAV186wg5zG1zzzuD?=
 =?us-ascii?Q?K5hYP/VuQLshmGXadZxjc89eImT+iXkGp0XbsU+vwR9QoQJX4WS5j2h36mum?=
 =?us-ascii?Q?SoOVV8IMxutEYok8mRCGr7JbE0+VTrGKLxRJ2U0KuSj5dgWgCmYg3HZrfPKe?=
 =?us-ascii?Q?YQ121kGnjuCbypWZt19WVI9cPqIVmVblVNGpKsKA5kEcWrAG1iH8ke5JxLNF?=
 =?us-ascii?Q?qDaYwpm5l87G8CmbUm4cyaUN2oAB3pUuepteCsgZDIGkGZHI/vQl5HjozdTU?=
 =?us-ascii?Q?A7txluZx1mXKpD8GhdgzB6hrMZG8I7B7UtayEGfsAkSvAfbQj6lTN4Q7Dcz7?=
 =?us-ascii?Q?NalW4IdRHmrh3HHknHyCCcnBIksuEIg66Lmj6UMPRRmstVW80jKrl8C50uLH?=
 =?us-ascii?Q?7zQiyxd8CPXSHQtY29pO1OggsnNXwVnTa8mf9qeQNYI2f7e/neil/GP1MAxS?=
 =?us-ascii?Q?NNnX8xkJ0xn2p0q6q8c64bjlQeYwbmh2aVSWQUsruVkrgKwe6Asj2OMGUmMc?=
 =?us-ascii?Q?Et6PdP3Pbq+fK9XyEP6cOu64hKzN0PGGGnMPl4/llxihRgRg+vUaWvWaT3ca?=
 =?us-ascii?Q?F2QLFIdFlskoupXXK6Uzdsc1BR8CxUyhuO2OkgognYzGrVa+bwYJTxUiW90J?=
 =?us-ascii?Q?uuiOXR75TSc6eGq87jA1uaM+SToPoidQh5vPTMitleGVYj+sve//44P2BHqs?=
 =?us-ascii?Q?xqt9DWsE7Ex7N7jL2dGg02ZEFPu2kVpKdOspOZpNkOaJb+thgpMqxhk4Btfd?=
 =?us-ascii?Q?z1b239TkCBsCsIcVcrq7uZEhkAYLEIBt8qOBh6MK8NTVYKNit5HekTaUZ5uU?=
 =?us-ascii?Q?kyyMxJt239taxy7eU/aDSHg1xBt0s17FgRCO/VXJOdxRUnY4pguHCH3SmzLf?=
 =?us-ascii?Q?Xv92FbHrad1PfAFg8J5jKCUqdTVvyhDeoF3zPOm188Ojwu16kjtq3fRq25bw?=
 =?us-ascii?Q?wFFBHd2DBxpbuhn37rEoF/8hucjdKlt8T9KVoDqaphxx5DbIP3ovjlVhFPIM?=
 =?us-ascii?Q?26qb13twxGGmPqKqXo3yC9BJmu9r2G4J74pW3M2eefoNylhkjy+eeH0hK/m4?=
 =?us-ascii?Q?8r6wpPJ4VMctmOdOuiZQA9HUw9X9eBa8q6S4HUL62xfYORMlSuMEgFl7UZkP?=
 =?us-ascii?Q?RgO6SzoIXiDJowbvJYiFZLOW2gPuCrAEG+XymLVOtLHxogEVsYVBziUPExQs?=
 =?us-ascii?Q?wkxmhXK5O4bOLSlKz35tuZBKSKXpWO1iiGjZYDin42bY1ibPsK5wiG6OXqVQ?=
 =?us-ascii?Q?9g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15311a9b-259c-48a3-a00a-08da7028f765
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 23:37:27.7825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FfTxZQBSLh6eLSwQn1pywNUaP7LOADY9c+dXLzrJgXIpHgo+3wWfQGPOKr371AbFg6VOAVp48MQun329hngrNjgkAQhGOLYbMdBSKn9VddE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5867
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, July 25, 2022 7:46 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; pabeni@redhat.com; edumazet@google.com;
> Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com>;
> netdev@vger.kernel.org; Zhang, Xuejun <xuejun.zhang@intel.com>; Sreenivas=
,
> Bharathi <bharathi.sreenivas@intel.com>
> Subject: Re: [PATCH net 3/3] iavf: enable tc filter configuration only if
> hw-tc-offload is on
>=20
> On Mon, 25 Jul 2022 10:04:52 -0700 Tony Nguyen wrote:
> > From: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
> >
> > Allow configuration of tc filter only if NETIF_F_HW_TC is set for the
> > device.
> >
> > Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
> > Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
> > Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
> > Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> > b/drivers/net/ethernet/intel/iavf/iavf_main.c
> > index 3dbfaead2ac7..9279bb37e4aa 100644
> > --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> > +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> > @@ -3802,6 +3802,12 @@ static int iavf_configure_clsflower(struct
> iavf_adapter *adapter,
> >  		return -EINVAL;
> >  	}
> >
> > +	if (!(adapter->netdev->features & NETIF_F_HW_TC)) {
> > +		dev_err(&adapter->pdev->dev,
> > +			"Can't apply TC flower filters, turn ON hw-tc-offload
> and try again");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> >  	filter =3D kzalloc(sizeof(*filter), GFP_KERNEL);
> >  	if (!filter)
> >  		return -ENOMEM;
>=20
> tc_can_offload() checks this in the core already, no?

Hi Jakub,
Seems like there is no check in core code in this path. Tested again
to confirm that no error is thrown by core code. Below is the call
trace while adding filter.
[  927.358001]  dump_stack_lvl+0x44/0x58
[  927.358009]  ice_add_cls_flower+0x73/0x90 [ice]
[  927.358066]  tc_setup_cb_add+0xc7/0x1e0
[  927.358074]  fl_hw_replace_filter+0x143/0x1e0 [cls_flower]
[  927.358081]  fl_change+0xbc3/0xed8 [cls_flower]
[  927.358086]  tc_new_tfilter+0x382/0xbc0

Thanks
Sudheer


