Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F25A4B2634
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244252AbiBKMsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:48:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiBKMsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:48:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF42B49
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644583719; x=1676119719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CPffyBivGYtsoJTtb68BBVknnTNJ1qyrUfE9ujgOBG0=;
  b=QkTYlzzxUSUhqFycWVU2ld2C4Yp8UHEDJtVysRt8wkTxG3gFhjUZRSjE
   ienmnKOXB75LXEOGgepbjfxqL+yTBpFNNFrMXdTHoPMGv/ay0yYoXg9NV
   yH00SIUXgGobDk0TX9tqMuxp8CHwHTZapC4i8WWliEjpxUnip09NHab4x
   ACn/T1vbEEKiZ/GujE99L5YWTk3nD8Muf+L3JsWNkrHR1Z6nFrq9hk5cX
   RHdQ1+P6gVwavqQCnNw0z7hxIxwG4KqTfB1iEUXHp183jZmLyX+BVyfL7
   GmAYI9nZ3UvrQXfHo836vAnU+hX4X8wdpdt7yfh+uAhQoRNZrPY0irfbD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="237129535"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="237129535"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:48:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="537640510"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 11 Feb 2022 04:48:38 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 11 Feb 2022 04:48:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 11 Feb 2022 04:48:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 11 Feb 2022 04:48:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeDyjA72E8HmbQykQdYrAzZNZIV7udNZ54TyWaQ9KY2rNmCqC8a/NmOfa2dBa7WcUJntAyegL6GCYtlkOzloLZbW5/bDZwC50uTMpkZw5CWDuFrDLvprX4zxUkjbbclPcox6eFxsDPkbglNGTyIh3ZIMS7PHqVj6GAV7CMI6z3r21YC2pXAq4cukzYfHmjGhve3c/3gy8BRsJi8WpdYy6Dc8s8g0pud3dBBih0/GrKGHUjp5lKI0kFyxmOO8hFxEb8TItyalZ88fNUP+nik3rvE80jSfLunjT+55p5EIQpv9t3U44NX6G4amxQDLo8E47wzNL4CjuIhfUcOi/uhmNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwyeCHbQkFBO4YAIxq7WRtMzJ5dqYVOofiwpIk03Eis=;
 b=KgM0zKxXs1IDJJMnRMRxgcXRmCqe/ENOdQZFCRGUtBVZ5VM4BBnmNU+qBaPYTkX7oG5uaPLRb+SydaCiBUCpMY0/ecpLsHE6JNHXA55UQBCIxt5xShZt8k2F2ZvM+Pd5CFFov2zpINB58mfTg2mhNf/oXSqnjzQDiGAP07ku1ZJeA3vjwfuR7e8d6JgjA43MxaLL3HtPmNDnw1ms3CTGaX7vm5fk+im97+ZRsxkRvywwIsFQmGYpQcXeyZPcux3dAd2VM9BLJOGzdNjoPk/ge5gkVxZaEFv2YDgSxRRlETzCUnlARUf/N/fE8x2dHh1e4YtmJhL1N/5oT988j1xZUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by CY4PR11MB1974.namprd11.prod.outlook.com (2603:10b6:903:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Fri, 11 Feb
 2022 12:48:35 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e%3]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 12:48:35 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@osmocom.org>
CC:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>
Subject: RE: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Thread-Topic: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Thread-Index: AQHYGefbqRcNOb4NqUCQWYuxV/hGwqyFLYqAgAR+yXCABG/wgIAAEuLQgAAlfDA=
Date:   Fri, 11 Feb 2022 12:48:35 +0000
Message-ID: <MW4PR11MB5776F58DE5585DEA423716A4FD309@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
 <20220204165101.10673-1-marcin.szycik@linux.intel.com>
 <Yf6rKbkyzCnZE/10@nataraja>
 <MW4PR11MB5776D18B1DA527575987CB1DFD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <YgYpZzOo3FQG+SY2@nataraja>
 <MW4PR11MB577686D883EEBDB2C9E0FEB2FD309@MW4PR11MB5776.namprd11.prod.outlook.com>
In-Reply-To: <MW4PR11MB577686D883EEBDB2C9E0FEB2FD309@MW4PR11MB5776.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f5685d6-9396-4697-d40f-08d9ed5cd186
x-ms-traffictypediagnostic: CY4PR11MB1974:EE_
x-microsoft-antispam-prvs: <CY4PR11MB1974E8129E6A5B0FF224C2FDFD309@CY4PR11MB1974.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L8vpzhQyzXCR7do+LdBuDZ7IOIipxhCFDf5366biIWXUbN9VRjhiKGsiUKiQ55hdR5xCTaE29SNZ0rlP3GDz5FSF+28QylppAgrfTx1x7Q2oNkFH9y6+ZFUB8nRYWCVG/DjgxopaijW5nWhpAlSExz1+cNiorYjM47jUvtS3vUuV7+INeccPr709JrkuZy0BEnCxx2Gnn5yKzAXrZZCBITsAaayutgY4zQes195zqFl+k7Tc/gyhC58alF8IbnnpzTIjzNmp7nXCS4djsBdQbFMziU/IVDfPXLb0GqSiYEjrI/k5RAtxIYIbYZT7E1/VrfKEV6o/viOWkOYVAWkItDpCkYQYk5NopFJCftUsNe2F0hyPsmUeVIbjKjt7IrEOrq7UW1d3HJr4/dH1JslzXKLoYzcJf15VsDwEiDWixW+dwDY46WCPxcwVVcM+oooLSVEZRpRaceh33MfBP+j56mzoC6CFpiqnC5meuX8zcW0vp1s+N7si4O3w3nljyCAlJat+JxOoYY/IcFYO+Om9RYtp+z+RKU4xnQXF7uSfCeoOPEvrmV+WaEbhQeFL94ElOo7DWE2U3Fy3UgmnTNbPyewFpl6jUUxGxkdFhNNPHh4aLY6AuOkl7BPFAAZp+RMUoMpdWaa/oqk05yllyisEZmOypdFS9r0y4r3R1ywgaUb67ZtJbIzC/5i52SdHkcRfmOvBC2xRwJjSp5JUqCthEjfomRYraO1kLsbv0GtqN2CQUbFNp8ihQ7LxbXZp2GhIJwrFWEZuP+ebKl+0aDquD7JhFApVs5Kj3qhUso8bit0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(76116006)(316002)(26005)(2906002)(186003)(508600001)(38070700005)(66574015)(6916009)(54906003)(66946007)(53546011)(86362001)(66476007)(8676002)(55016003)(83380400001)(33656002)(52536014)(64756008)(7696005)(66556008)(6506007)(66446008)(966005)(8936002)(4326008)(2940100002)(5660300002)(38100700002)(9686003)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?JPOUth3LLXRR2Td+N7R8AmeJP069yEVeb/lbVdky/jJH9SjDUAmHdR9oew?=
 =?iso-8859-2?Q?0ZQrS4UMPdTLjaEwDnXoNk489uxz+2e04+aobc95kpLFrd/Qd9EHG1w2bO?=
 =?iso-8859-2?Q?Vl4lCTqr7ds/CYsjxYIEpHb+6qaIooSlhVb8ArfEiLrk+OgIqGFesmnaUy?=
 =?iso-8859-2?Q?WJ+/ULxG3MMcBRltpls2Pvf6nUq8or2j9QWxbOqIc9bK6JlM+Fux15J6s1?=
 =?iso-8859-2?Q?UCZ7snLqfhNu/hRC/MVibKJY8iDGkJW+oGckMnBmm2PkqnbPFL+E3ruPUj?=
 =?iso-8859-2?Q?gLYv37cy2nzzQnUuiUIpeJ3UwEXL/tfFP+bCdnNr5PABqXXFZnbxey/cnw?=
 =?iso-8859-2?Q?2kYdRVUFki2GpKN38HBd7y80E90ngOT46kfQZWy9czWCXciABSfOfS+lEa?=
 =?iso-8859-2?Q?KU5rB51gggd/nsH5S/PpgTpODuP2aj42VyCB/GPXb5ZSVMVpiF0LSEinIV?=
 =?iso-8859-2?Q?Fps0cel0mKwkFU9EPMsumLn8snbbvEivYNKnvG5TWJT/tGrmBuEEvO7On4?=
 =?iso-8859-2?Q?QS1L3FdOsbDq1fZRMOjUMifyTusp2iQ7glV7HKZDP4cOaIhgyj4zi9lzKC?=
 =?iso-8859-2?Q?jlesTqEPcJRdTKdqhyaaKFCYJMUnboQkfUruJDxp8CfP+PeybKD2kclhrc?=
 =?iso-8859-2?Q?DsZR4vpX3O2SgpHeB2aLPSzgWhQWMEuo3t/J0C9/RXcAl8zuOplz2YtmjM?=
 =?iso-8859-2?Q?dOl8YjNnd1C4G5v0Xbi8tC144SzZdLTuCTdNeE3ZYdBlJ8fSs2jnfIrqNL?=
 =?iso-8859-2?Q?0VqrRwRmYjGqKEM7MnIh06RYg7K3BiGUGy3ITYMl3Tdl5KjLKKAeqCXkno?=
 =?iso-8859-2?Q?ZP0dLKqZxGFx+y24w/xOt1BYiut72GUorGGV/5lO36B0PDAxhYHE6XK8MD?=
 =?iso-8859-2?Q?za5zJ2N3bV8kZS8zH69deKT0COW4+1PaqajOaCJuyiLmYFaVOiIxu3QA01?=
 =?iso-8859-2?Q?oT5xkRBDeG4eEhFLQEEVs4QXLtDc6+mIR0Uoc5YMOH/6UGo70lPg78uEcB?=
 =?iso-8859-2?Q?NHJNxhPKshfXrmK1HMrLqkrJpMJbMdFw7AfSzuZvgKnO05BHkC/5bYAQto?=
 =?iso-8859-2?Q?8R6NSY96+DQuBF3tVV5BZrAIrLOemr9juGu/CIem7wwEH9uOMnlzbAp5Sj?=
 =?iso-8859-2?Q?6yyN20VtZnEzHEJcIEDkcKe7LETNwaQHkXHaVB/98ixhTUmToPcDt9X19D?=
 =?iso-8859-2?Q?iwsfgQAtcSB7UNPyRTxcRGOScz4hgrE4Nvn0OQEYIQrE15Ni76R4cmAPsD?=
 =?iso-8859-2?Q?JGJ5fA6gaVpfaDEfixZUfHwSNPg+cdDHX3sy+6kpMofDptRSxWAIxiFRto?=
 =?iso-8859-2?Q?UN4Cwqq2diQG2QQ7WL1qxp6kgfVdy1yRM+INNyUE3oRb/nR7qicEgrZXL/?=
 =?iso-8859-2?Q?8IDDaCEGDjNpd08t9pn9ZXXDOm/9UMLg+AqTqSfgVnCjUbH0fHo117Oqjc?=
 =?iso-8859-2?Q?iRabo9oyKSN/KyK9tQIU7aaRaq+kIHl6ZBVCigFyN/9yEW1kPJhb4BfUBW?=
 =?iso-8859-2?Q?LWnudu2SBSdZLR+Au/xS1dj5d0b9Zshs7paN0704Lb5jE0e4jpFS9Yqc2q?=
 =?iso-8859-2?Q?kH1oXs+O+c2Yp42t2Em3cR+yNtSGkS7JH5GpFA7oB8CfWvgXeZR9TfzTns?=
 =?iso-8859-2?Q?RcuWZKdFk5rVTLqQ9guTHflIOy8OmvAGEb9kHHhrV7qv3evb0A6e6GIHOp?=
 =?iso-8859-2?Q?QZyRH0t/ywOx4OUBI+sxpqUVZz3/cNYxTzFS0ArN?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5685d6-9396-4697-d40f-08d9ed5cd186
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 12:48:35.6590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmVaftsalxKLs8K9wMbOt9/Fu9E8eu5ZkQNpolrti3VU6CPEpEWUP1tyEO/yHq17LpWNmAV5fhZOwJ4Z+AKYgEpVH1ZcGDVSOaeCiwqoxis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1974
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald

> -----Original Message-----
> From: Drewek, Wojciech
> Sent: pi=B1tek, 11 lutego 2022 11:27
> To: Harald Welte <laforge@osmocom.org>
> Cc: Marcin Szycik <marcin.szycik@linux.intel.com>; netdev@vger.kernel.org=
; michal.swiatkowski@linux.intel.com;
> davem@davemloft.net; kuba@kernel.org; pablo@netfilter.org; osmocom-net-gp=
rs@lists.osmocom.org
> Subject: RE: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
>=20
> Hi Harald,
>=20
> > -----Original Message-----
> > From: Harald Welte <laforge@osmocom.org>
> > Sent: pi=B1tek, 11 lutego 2022 10:16
> > To: Drewek, Wojciech <wojciech.drewek@intel.com>
> > Cc: Marcin Szycik <marcin.szycik@linux.intel.com>; netdev@vger.kernel.o=
rg; michal.swiatkowski@linux.intel.com;
> > davem@davemloft.net; kuba@kernel.org; pablo@netfilter.org; osmocom-net-=
gprs@lists.osmocom.org
> > Subject: Re: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo respon=
se
> >
> > Hi Wojciech,
> >
> > On Tue, Feb 08, 2022 at 02:12:33PM +0000, Drewek, Wojciech wrote:
> > > > Remember, GTP-U uses different IP addresses and also typically comp=
letely
> > > > different hosts/systems, so having GTP-C connectivity between two G=
SN
> > > > doesn't say anything about the GTP-U path.
> > >
> > > Two  approaches come to mind.
> > > The first one assumes that peers are stored in kernel as PDP contexts=
 in
> > > gtp_dev (tid_hash and addr_hash). Then we could enable a watchdog
> > > that could in regular intervals (defined by the user) send echo reque=
sts
> > > to all peers.
> >
> > Interesting proposal.  However, it raises the next question of what to =
do if
> > the path is deemed to be lost (N out of M recent echo requests unanswer=
ed)? It
> > would have to notify the userspace daemon (control plane) via a netlink=
 event
> > or the like.  So at that point you need to implement some special proce=
ssing in
> > that userspace daemon...
> >
> > > In the second one user could trigger echo request from userspace
> > > (using new genl cmd) at any time. However this approach would require=
 that
> > > some userspace daemon would implement triggering this command.
> >
> > I think this is the better approach.  It keeps a lot of logic like time=
outs,
> > frequency of transmission, determining when a path is considered dead, =
... out
> > of the kernel, where it doesn't need to be.
> >
> > > What do you think?
> >
> > As both approaches require some support from the userspace control plan=
e instance,
> > I would argue that the second proposal is superior.
> >
> > Regards,
> > 	Harald
> I agree that second option is better so I'll start to implementing it.
I have one question. The new cmd should be allowed to send echo request
only to the peers stored in the kernel space (PDP contexts) or the userspac=
e
daemon has its own list of peers and any request should be allowed to be se=
nd?

Regards,
Wojtek=20

>=20
> Regards,
> Wojtek
> >
> > --
> > - Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks=
.org/
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > "Privacy in residential applications is a desirable marketing option."
> >                                                   (ETSI EN 300 175-7 Ch=
. A6)
