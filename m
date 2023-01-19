Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A00674AC4
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjATEfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjATEfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:35:00 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFC9BAF3F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189198; x=1705725198;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jaiXdlN3pWjKd2DB9B7utKUKck8zcWDzZesQE/WJpPQ=;
  b=JwtR3E2an88jBbSYbBhOOnpRAopYaIX/POnV+nTRYy16i3u6itbq7Q9/
   KvHGBWb/fFLurVB3BBirRe3LpWuixe6Pe0oyU+zp87c5uWIkAhkwB494a
   oJ+V3HPYTOlNkTnIgXxE0q9e9olCw5T9jICm5rQ+qJ3X0Ve2t7w+jMLhK
   2PY8hle3oyR8GLC/1K9I5uVYa8JV/yqLxQtDAdgWnKbxVPrRuEF2gAYuo
   vl539Qcfm6/ipVdNcppeDC1Ny2nrju8tjtYEeaOxYOU92VcW8iS+Ijsen
   6zdrkSYMiOn59Azwqzf72y97F2+c+OD3yVtsQoKu7xF6GQOrSLw/F4Hsr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411508865"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="411508865"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 04:22:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="690608315"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="690608315"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 19 Jan 2023 04:21:59 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 04:21:59 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 04:21:59 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 04:21:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeovNMnXzvxqY8Ih8tWYJKk8n4L4yDClQm3HhfTBXTOlAYY8kdP7nr2S+rNfj8VgAX+1OMSTzRlKUrcjUJBjwREHF3m+izjPVLoMgsQ06OsfHOfkL1FAqvnyTTEoLvR7fD15M+ES8JWwaPEvJYMzXpBifaza8430xHmtE7Iw0PAk6NfA+PxgEzb1/U6mUa4VcCMTVA9IwQus8BeAJ1KOx9s6ORXTMqEH0fZa07vREoRzQ9GjI9ZY2GkQr+nq/0zhV4F8WkeyuJg4x0JYTBFgRGCF2CupwHmPv6DO9Ntr0rxn8GSIjvtTnPiQBwqZDh+Y/jatl3jzGodgxpK+8SOTkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6OXpJJKyz0AJRMB/OCAD/NB7ZL8HAlqyiWy+F4wpr3w=;
 b=Ihx5Y5T+LEvgtjzQPstpxBI3BW+Q/iaYPJqF8b34zv4dKkIorrYKv51e/VHQ3BPGtQuu6NHoo+LHo9LgdStpiKt6uBnwMFcplxfOgIPpyxBoSoUatYbpi8twduVM7XEVT2owKlxRKarrLJL1jK8JBo7wMCZ5u5K3PHe9zUJpPuH/QN8ZHHjdetLtyvVmpSdmdImpKMoZnD9UVXnHgBNFiIkNpl7HZUM3E8MqtEWi/lDMczWaSUQOaxqRpf4VRQQSjTne191htwMPWRosMB6iA6f+7ennFuMV0aeNxamrsXpDFvKj/2SrNyWDFbh7B68naYo7eek9eUB5JHOqttu/6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3521.namprd11.prod.outlook.com (2603:10b6:208:7b::32)
 by PH0PR11MB7424.namprd11.prod.outlook.com (2603:10b6:510:287::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 12:21:57 +0000
Received: from BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::6665:be07:921b:30eb]) by BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::6665:be07:921b:30eb%3]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 12:21:57 +0000
From:   "Romanowski, Rafal" <rafal.romanowski@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        Stefan Assmann <sassmann@redhat.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "sassmann@kpanic.de" <sassmann@kpanic.de>
Subject: RE: [Intel-wired-lan] [PATCH net-queue] iavf: schedule watchdog
 immediately when changing primary MAC
Thread-Topic: [Intel-wired-lan] [PATCH net-queue] iavf: schedule watchdog
 immediately when changing primary MAC
Thread-Index: AQHZJMnUgw2KUkJMzkKBIhpMuyMBnK6Y+HoAgAy+qdA=
Date:   Thu, 19 Jan 2023 12:21:57 +0000
Message-ID: <BL0PR11MB3521C08FE39C9C9CFAE98F268FC49@BL0PR11MB3521.namprd11.prod.outlook.com>
References: <20230110080018.2838769-1-sassmann@redhat.com>
 <CADEbmW2LLTfZ6h=Cdkbc70Z61BuBKYMbaLYq-c=STP03VJ_O2g@mail.gmail.com>
In-Reply-To: <CADEbmW2LLTfZ6h=Cdkbc70Z61BuBKYMbaLYq-c=STP03VJ_O2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3521:EE_|PH0PR11MB7424:EE_
x-ms-office365-filtering-correlation-id: 46da8f8c-1a98-419a-2168-08dafa17c219
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vXM5eTlPKj4U4tcRZN6DZ8vTatVddAkX2O9xJtSLbTFiz2G8CHEpcWEfnPvXKBfjWzTu3NEX8e1Imr+DBaH0alFyTAM8VubvLnQfZJfyLNAVSJbLruJRMLD7AozT35Y1nqHasxGMUAIsVmHodMsN1kOJFh+zktFtAXkTCmpmYdM954Bl174RwCtBJZV3bsmAMuNhQqbuf026Hib2kjcI7Xq5W2aPRRrqcIS9vD4NgU0L1T3H356U7kFZQK8WiHnFqC4X+hhM6VEl2Xny5jzsOkA+i1JCp0oj37TOtsxvwG7SPgfY+aytBWd8Nyyyk9A7pCaPrFTgDOee8HXkGZaY7F+lz1mWfuzNzfntyi2ggZUNjV/VWfPoPkpYnWrVsRhsRsZWKSrpqirvrcwYCcfmMF7hMK3fcnPQVB0zH5vQ71svrH2iomS85ZoFlThmJZrsisl4XL+4Cg6q55DdBaNvq381foXF5+wHcerLSTvQwXkwQy5Jh7VslUi7oLHEdSaCgXds9u3dzppDPZvSWkVtUTeknU+pRrxBH66Tfyx2yUr1/Uw1rMKoUtmLqDZEjPqy+DBS9ldZNy682866aV1e1hTqAwqtlZ7MItdPsm887UCqoRzA4s2Nh+NSCbV2TfiC80o7MjeuHLkfMfp31upBT9TbJJ8oLNM3KkqAWsNmxapcG7IqYtyvTDIdVotAG23nyz8/JfnTXogjci2drmxMEaQNatHS6VC/Hj5C4qfSV3U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199015)(71200400001)(66476007)(7696005)(6506007)(316002)(54906003)(38100700002)(26005)(186003)(53546011)(478600001)(9686003)(110136005)(66556008)(66446008)(66946007)(5660300002)(8936002)(83380400001)(76116006)(4326008)(8676002)(41300700001)(52536014)(2906002)(82960400001)(55016003)(38070700005)(64756008)(86362001)(122000001)(33656002)(14773001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?He8ik+wHtavWEBMKyVdsmLmrlkbFM/ApmDwRhYqsb2HIY+J94fasLlexXN?=
 =?iso-8859-2?Q?qXE3q1h7SiiMxFdNqvgtYtF/1kiidc75MCQvgeDsWWT80Zsnf0NRsXPNPF?=
 =?iso-8859-2?Q?7nWkfWvRvbveheI8d9hqmI3yJQU4gFz9WZyaOyUuH2LIKSZYNO9ljgiMOT?=
 =?iso-8859-2?Q?iLZyhAGO2autz6tD33KKL39E6EcxwfK4FMUQ8GAtAt3EP0u/CtWT3Heo80?=
 =?iso-8859-2?Q?D3Lq3nnqWmsUB4GOjSDV800TCTW17DwjdjsswqSDQ0KYxtULi5sLHuA8ma?=
 =?iso-8859-2?Q?rZ/GWxfY0RQ0MvovgyiKdPyu0vJGD6OK3lt+95G1WhyLXaCGvLr40Rys6v?=
 =?iso-8859-2?Q?6o8dAWhRV+GukeoxTOXyLZ/XXXoOwbQPlYW93RCIyx+n4o9y5CgSzZiGgh?=
 =?iso-8859-2?Q?vMTJ+Sq+d3o1a/Uk6maH3t/n6ElkKTZkai4CzFlAKDxsx4KE9xQbqcXOdS?=
 =?iso-8859-2?Q?lmeYualG+rzJ3IqpRZkrOdxKzJKLOhZ4hHvQd4q+kaHuzPcEH7d03lj+bx?=
 =?iso-8859-2?Q?22aS2dnbwSq34AZJQ3nAUXP1Nn6otZI3VEWeVAWW3Oh/OFBnE+eSK+nrZp?=
 =?iso-8859-2?Q?jEjnl9Tog38QEetOO+/yXp0vKdKScteVO+twcd88SxvwtVxgODx477f4Vy?=
 =?iso-8859-2?Q?/p2zuFur4hicTV7BefgmARDv9MUoB2xdjEltaSvGHNaz8VN4rlxR7ZzC4/?=
 =?iso-8859-2?Q?31JnE1kthc04ValEGNxF6rQb3zROnjyIZy8OUqUaOaNK3YEMiqSRfRAsG7?=
 =?iso-8859-2?Q?wIxwqPDiiTdM8IGolefn1KHq1/M/H798bCy5bq9oWXj2fZtDR6WtbGtSb5?=
 =?iso-8859-2?Q?v/wHsbw+zsLvyQ7naL16wGKslcGYa9e71dGXDVXRI9KIEfSGfc94danNcL?=
 =?iso-8859-2?Q?RxxghNbvfFmJTP+t6TZZu8tdPTWXA0QJwywFPC0DGrwsP286ZT2jY2FjsG?=
 =?iso-8859-2?Q?63aAw6z8cZmunVf2GVaLcFn+cyg/PhR2jPVdXElKsVFq+MV9vQWV4bZwSS?=
 =?iso-8859-2?Q?NhAfw5zSAmY9F4I6dfKHmrr+tduYoRIHbS0Ur1cnwgYdwv2eyZ1HWEZwSi?=
 =?iso-8859-2?Q?m+u01p/VEPkXXg23lkCWqVYO0gfwfmIOytpXk462FTmiTt+FYVJrSrM4bD?=
 =?iso-8859-2?Q?0m9s7fZ9gePD979+9uMexMcG/+qirleBbwRjtW2lwwnqZnd2w6aC0giQMK?=
 =?iso-8859-2?Q?DNCYsTDreqB4DflTm38ptix5MHq9USmWcHgGESlm6EpwUmIoP1T8+Wepvg?=
 =?iso-8859-2?Q?gNNB2jjX8nwKhlPHVOkWbH03byOpMTjZI7iVcWnvljUf1MtlYPpEUw3xso?=
 =?iso-8859-2?Q?88MLYQbwxrVsxJYOq3WJbYHE21UchsW0bQxmHrpM5J0JbmTfsOP0r+oMoL?=
 =?iso-8859-2?Q?G0uXRJ0rA2dZewEtgnGwv5IFEzNFfJAAAD0YZZhca5xRKCsVf6e3XFk1Zb?=
 =?iso-8859-2?Q?gHTuKJQqa/3c4Zd+UEMzZ/vwMsSnkaUrYR/yaPwpfNx6ZtlpGRkvIdVqMq?=
 =?iso-8859-2?Q?c7mz3rYYRAzHv7Q11loWd/02bEZEztUJDNTCvfeQzAbR5xLI42BfCo0Kjr?=
 =?iso-8859-2?Q?43RZEGATm7YqDRA68FgcA9UvvsRwX3lgr18ChVYShCy3sOSIhODLe163Wj?=
 =?iso-8859-2?Q?hX9YF1y83TBSgagIXCWGrMWjBISe2apkf6BmEWyg4nAt0jzjDONJ1FmA?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46da8f8c-1a98-419a-2168-08dafa17c219
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 12:21:57.3340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjsMTesS7z1oMTRUe4vsRxDboLwTMKyxOvR3yGSml4XKEEQk9CgntJfuBL1KCKwcgflowxSQbfpP4/0lDzIc1nfgkjFG3HjRSG2mN3/v6o4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7424
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Michal Schmidt
> Sent: =B6roda, 11 stycznia 2023 10:43
> To: Stefan Assmann <sassmann@redhat.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> netdev@vger.kernel.org; Piotrowski, Patryk <patryk.piotrowski@intel.com>;
> intel-wired-lan@lists.osuosl.org; sassmann@kpanic.de
> Subject: Re: [Intel-wired-lan] [PATCH net-queue] iavf: schedule watchdog
> immediately when changing primary MAC
>=20
> On Tue, Jan 10, 2023 at 9:01 AM Stefan Assmann <sassmann@redhat.com>
> wrote:
> >
> > From: Stefan Assmann <sassmann@kpanic.de>
> >
> > iavf_replace_primary_mac() utilizes queue_work() to schedule the
> > watchdog task but that only ensures that the watchdog task is queued
> > to run. To make sure the watchdog is executed asap use
> > mod_delayed_work().
> >
> > Without this patch it may take up to 2s until the watchdog task gets
> > executed, which may cause long delays when setting the MAC address.
> >
> > Fixes: a3e839d539e0 ("iavf: Add usage of new virtchnl format to set
> > default MAC")
> > Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> > ---
> > Depends on net-queue patch
> > ca7facb6602f iavf: fix temporary deadlock and failure to set MAC
> > address
> >
> >  drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> > b/drivers/net/ethernet/intel/iavf/iavf_main.c
> > index fff06f876c2c..1d3aa740caea 100644
> > --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> > +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c


Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>


