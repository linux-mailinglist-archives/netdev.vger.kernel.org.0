Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D806F13FA
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjD1JV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjD1JV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:21:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030921FDB
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 02:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682673684; x=1714209684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n1X67oxVcqwY6+xl7mvMdQX0vRgZWQBtvC6fh/EzJvE=;
  b=hyeP5r6MkyUxgOsp95aLgK7TX/ktVxEHBeBMYhCDc44R6c+IyILtz+1l
   V/ioMAiyN9bEaOkufyn9smHs0heBHhJt4rLkJPAHHIUfOmiPp18OV1oFC
   RHdOQimmwuyeTg/MDxcvBCWCjjzs+dg3Sc9exH0J0tYVhvy1FWnUln02J
   Pp+qNXLPJZ5bF90IEq9hweC9SRq/9uKvmDKvyn+pn4i+CCGiKt+xgu74B
   reYjv/oUIrVW1kI1VjUofqUQakNNOQKfsU7yZlvFyKqsNMZqr1EVYWU+i
   Aw/tYfgqSIscFhDCEo6lGf7fm6H6uBt0rbuuYIm+zf389F45qT1xSWNpy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="332004413"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="332004413"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 02:21:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="727465855"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="727465855"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 28 Apr 2023 02:21:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 02:21:22 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 02:21:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 02:21:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 02:21:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw9nwBwKjjmHTv+ikW9LRXPa1MVOYtSwUB0Dd4UTNo/8+xGw/XtM2yqsT8Rq56HkUj1HMfNfJ2GVhZqhlMZ9bFBqp4Z8Y8FD/tELK4kNZ5ZCvZCmJFs3nW5aH7wTsd5lo5/nFMkDLPpPiZ6lol7YqKORt0s44caEST+mbPA4mp0c/mfHsgBK8JQ0vjqjqKAujNQiMCg8M5rw3lHuIeI5JQiwU3X0uE3jl56iAtWuxdSzTVX+PqDNkTnISMC186dUGap2FcTGufnFvJiOXx+BWNp913OxZpCrdglZ6yCBU4S3qKLKPMampYdjuEeVwOM/9qjtTPdcU6//pC58HfcNLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62j16mNky1BYB1ti28h4i/1xI68nuVxLjKuqr+TR0CM=;
 b=dZr/cANCaSdNA/R9UvAGR1jxb8iWuE94Bps09nYo0tlSny7faKDv/0Kifr6CpYOM3wXqFh3Y6vf34AyI5kdqplfcSu21t6V+yHbzdWfVNgq3cH+eoaksdSECbqDs8OU9/10BX9qaxdtAOo4/ClOE4Z9idVwaLHNvgMCOm9Th+sC5w5BcY053bwkEqJGWt2kl0jUgJKcNJS29TXdt4G8Il7VJu0hEZQBi+KGcJUmU6X4C/+HHSZsYR51BG1nL/pBd55uKiUf83Zt7wNSCgnj063lO+BRXa6mBIOad2pakBQntgiH5oLkwedK43oCsa+Pc1sUBeXAJODKZRc0gPq8Dqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by IA1PR11MB8198.namprd11.prod.outlook.com (2603:10b6:208:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 09:21:19 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3280:683a:a9d0:c497]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3280:683a:a9d0:c497%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 09:21:19 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Samuel Wein PhD <sam@samwein.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
Subject: RE: NULL pointer dereference when removing xmm7360 PCI device
Thread-Topic: NULL pointer dereference when removing xmm7360 PCI device
Thread-Index: AQHZeUxq6D7a9+8L5kqBjQGHxVkp1q9AMnJQ
Date:   Fri, 28 Apr 2023 09:21:19 +0000
Message-ID: <SJ0PR11MB5008C45C06B1DDE78A8CC874D76B9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <Yhw4a065te-PH2rfqCYhLt4RZwLJLek2VsfLDrc8TLjfPqxbw6QKbd7L2PwjA81XlBhUr04Nm8-FjfdSsTlkKnIJCcjqHenPx4cbpRLym-U=@samwein.com>
 <20230427140819.1310f4bd@kernel.org>
In-Reply-To: <20230427140819.1310f4bd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|IA1PR11MB8198:EE_
x-ms-office365-filtering-correlation-id: ffdbce38-38ca-4bc0-a427-08db47c9ed03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rwnyKIYqbEs8LpUyMf6W1S30y5zgyv6zStNOrbuO/lzVPPUC04mzDNjuP4LvmcNNW0rMAmw/dpCYOIXrg95H6VQbslMOnGZS+e77TFZUuUKtwrj9qK9KyKqombVVkt1q4vZBmQ19fdCHUMGHX/g9FskORuM1JqNV+h+fjLqFftks7gqgG5VF7OMRq/34UL2ct+fppfMyIZSD8VYcwW6IfSJzYe89dQihMVxrHhfDtJs+BhsvE5a+TIOfieTYjGTlj6EM4kkgh4m3we56ne0Zx65hUkSR64wCIsayCJjDnib3SKNE+qFY1eJUC6yqz7powTvdeAXLxXGo5iI/m4njh8rEB0M/doVnFnb4oPs2u2d0cAMWbkPJMmg46NIK0sFtDC4gsGjhrOjiTonIb09DqoloElUisOqwWF3wNWxWEhXjW9A2cW7kGnwwHKHKFZTQ5RdTA934fZOuEgiERDzCTxKKZc9LfSrnddcjtVkAqQCuNPYyXUDAvcSyhqdqElTYuTMDw/ITzZG8K+bddcs7jPnwZ9k7dknKDyxVTqAWsdSsqACN1ehLYHRGLnfsq73R4Pd4jn3FrIPrdu+IBn6g7sydRgmsFFFyavAkKtzMnSk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199021)(86362001)(107886003)(53546011)(41300700001)(26005)(9686003)(6506007)(55016003)(2906002)(966005)(52536014)(5660300002)(8936002)(8676002)(38070700005)(33656002)(122000001)(83380400001)(54906003)(186003)(478600001)(7696005)(38100700002)(71200400001)(82960400001)(66556008)(66476007)(6916009)(66446008)(4326008)(64756008)(316002)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uGA9hZ67ZOFFChi3rvdZFERErhZs/dfxbY9MwduHhOUCFstZnQ6/hcUfJb+X?=
 =?us-ascii?Q?FhGTjhoTRpE88uRtYsK0DhW27OFi8iLyBhVBYwLAZXWMnerCtb1nV7UGQGTv?=
 =?us-ascii?Q?yugp3rgm6o1CdUS1/i/cKuTgoHLpggh0hhqQCIxeAMkyVQfxqQpp8Ui7zM9a?=
 =?us-ascii?Q?ny8qrc3bFpn7hQN8YWaC+T1hnrwSg8BLGu1mJpBO7SuzMC5snsQfTP3zHB1/?=
 =?us-ascii?Q?PB+Er7WDtIu2zmACIAeiGmBvldlPWhQt5FouKCT7lSGjf0wKOMGSuA4zfgTC?=
 =?us-ascii?Q?bLe5RupO9G2kLAHDUT+NJanSlt39JKdV+JSHmxy9i/gcZUzVOIgUli1y4Kfa?=
 =?us-ascii?Q?/pLdOJom14VKuBdHNVJakQPRjS1oYL9q/aiLfS0xeA1XpsIbwTf1s0o3uHs/?=
 =?us-ascii?Q?TP3/XG8Q5CzsqvqpBaxNKE50fjYMdHW3qs9SMCh/1EdF8/8J/4UOfwgHZoey?=
 =?us-ascii?Q?kL1MvoAjNbqDcRzdFeL60wXwRY9/AeI0AO1Lq5dyUdbiYCCX7UWdpj7Ef3nO?=
 =?us-ascii?Q?gf8aHv2CP1jSFLCMlE7Z4sk47AVcbfH/RosrQMdF0C432NCWJlFMlKxFQOO2?=
 =?us-ascii?Q?SxguWEGjiWTjtRPh9wRgexjGUtspnGR+fchqlAoosEtcfVPC7Tj26BDUqcWZ?=
 =?us-ascii?Q?riwO4PqQmnwmWRKVeKThJrgu4SOOQdacqXbRxyVBOHteX4YkRMiIVEpXwg+w?=
 =?us-ascii?Q?XcqPUc24PYo7Hhcs87gTwH55jkWlqLp+NnxrQZva4tTF1CGQbhecYmPBKrL/?=
 =?us-ascii?Q?mwqFv7wt8P7BJCtfPcq0iBKwATLdLX6LYCnpDEHie11L1pgER5DiH2sHB0t8?=
 =?us-ascii?Q?9GmFfGNEsZht/DAKbVTkfvALJbbMqQB90dsVd6KrgKDesEwhNsIomtF1DcQq?=
 =?us-ascii?Q?GmdZHqkvOdU8jJ8YozKcC5lscH4JvaYgoFbsdl8U/3lBN+0D3WXg9U2P8Y2r?=
 =?us-ascii?Q?NOAnGi2h7gBeeexDKuqYE2lbopjv6c6aQ7EOoCVDHchSC4hK2s1NTXHTRuiV?=
 =?us-ascii?Q?GChkMGUYrruibysexUfMqw/iPSNabPTtC6jLeY+1L8iBube1eVBRWf6JUmW9?=
 =?us-ascii?Q?22dVKdH6DOCH1tFN9vVrMloMJnOyhfer7f/51nlEBOWaVUHA+LqiU4K4EDvr?=
 =?us-ascii?Q?Jr+jMyKrES+5US5mgrhvhTi+wnFKs170jWR87sM8e5i24T+e6Dq1ki5IkLTj?=
 =?us-ascii?Q?yg/87qB9RaehAr1//2cgaWxoK2Dqr4bGaZt7ep6QlaI9wnGYEAj6Jxdcvjnx?=
 =?us-ascii?Q?01pJmwLO7otU5AS3GmWXlMH5ZCcV9cq3F2FOn6cbrEGfNchtMfH1Ft7ZLyCp?=
 =?us-ascii?Q?8xlPdunLvKP0DVHOIxszljmJ3JZz31JpQNFNE0wZwU8EOlk5iaVqD3L6/KJS?=
 =?us-ascii?Q?r9TcklIyVxUMH6uSW3ubZWEgssio4ZY0IIvIJLkQXwS6iO+lmZK/VNmAne1q?=
 =?us-ascii?Q?NKK8zLWpRCivJ1vqA+eMbzQZC6S5nNCJHwCATX3x3PhYvZ1M+bqPV5YTGdGR?=
 =?us-ascii?Q?ePLuG6MnjKmCAXIB12iBsytdOKaXBIxesCvZNfKWi56gnVftSnhp8+yVRg+Z?=
 =?us-ascii?Q?nBX28373j2x5dkFQLrn1zbrd+EQSFmcaoXDYDc4W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffdbce38-38ca-4bc0-a427-08db47c9ed03
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 09:21:19.2934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JlTUizODukixe4XAgPR99MAsVQsUePvFKDPygClmtBWRDDIRiVRj3i4tAq/+aP3QJA7Ee8x1PyO1sxMJ+zDnx1hpSE94GAPN7q4NhdlfsVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8198
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, April 28, 2023 2:38 AM
> To: Kumar, M Chetan <m.chetan.kumar@intel.com>
> Cc: Samuel Wein PhD <sam@samwein.com>; netdev@vger.kernel.org;
> linuxwwan <linuxwwan@intel.com>
> Subject: Re: NULL pointer dereference when removing xmm7360 PCI device
>=20
> On Thu, 27 Apr 2023 10:31:29 +0000 Samuel Wein PhD wrote:
> > Hi Folks,
> > I've been trying to get the xmm7360 working with IOSM and the
> ModemManager. This has been what my highschool advisor would call a
> "learning process".
> > When trying `echo 1 >
> > /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/remove` I get a
> > variety of errors. One of these is a kernel error
> > `2023-04-27T12:23:38.937223+02:00 Nase kernel: [  587.997430] BUG:
> > kernel NULL pointer dereference, address: 0000000000000048
> > 2023-04-27T12:23:38.937237+02:00 Nase kernel: [  587.997447] #PF:
> > supervisor read access in kernel mode
> > 2023-04-27T12:23:38.937238+02:00 Nase kernel: [  587.997455] #PF:
> > error_code(0x0000) - not-present page
> > 2023-04-27T12:23:38.937241+02:00 Nase kernel: [  587.997463] PGD 0 P4D
> > 0
> > 2023-04-27T12:23:38.937242+02:00 Nase kernel: [  587.997476] Oops:
> > 0000 [#1] PREEMPT SMP NOPTI
> > 2023-04-27T12:23:38.937242+02:00 Nase kernel: [  587.997489] CPU: 1
> > PID: 4767 Comm: bash Not tainted 6.3.0-060300-generic #202304232030 ...
> > `
> > the full log is available at
> > https://gist.github.com/poshul/0c5ffbde6106a71adcbc132d828dbcd7
> >
> > Steps to reproduce: Boot device with xmm7360 installed and in PCI mode,
> place into suspend. Resume, and start issuing reset/remove commands to
> the PCI interface (without properly unloading the IOSM module first).
> >
> > I'm not sure how widely applicable this is but wanted to at least repor=
t it.
>=20
> Intel folks, PTAL.

I tried reproducing the issue by following the steps you mentioned but so f=
ar could not
reproduce it. Could you please share the logs from boot-up and procedure yo=
u carried out in steps.

Once you boot-up the laptop, driver will be in working condition why device=
 removal ?
