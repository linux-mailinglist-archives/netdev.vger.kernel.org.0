Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1754B4B2312
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348887AbiBKK1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:27:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348894AbiBKK1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:27:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A915D2
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 02:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644575263; x=1676111263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aUX2cWK0WzllJrdwVPxA5m9aY8KEX+OvGoknCYjhGtw=;
  b=bB63e8aoN5ylj/z2ruBY2Ecd0hf3+lYMhFzbcuG/w3SlvR2VIRfDXSLW
   xWXISV97NtPEl7TwRc73EHDdRQ24pAgVsw0Ut3WfQPNrHSIbTYhlSevPE
   9+3LAsJvxxezoTxG5T4E8i/KfWqNnbhAbyCvj3g86HXrGZwUQgGclXNO6
   8yFHwaxhIG0WJ+0VzUvYOVLX3tnX9iJSinj+QuUe9x5YIC4vCbGDOoZBI
   jU8S83qDOqfs5csyKm2LD5Al1UFdhZlDIjT08iAcyHy0lwb1x0yB2ibHi
   4fijyGIZ0zR/O2vwOlPqJfHU9la5rb03ZkwSeCCyRD/D50kgkwLhn4vt0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="230350934"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="230350934"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 02:27:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="500738342"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 11 Feb 2022 02:27:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 11 Feb 2022 02:27:32 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 11 Feb 2022 02:27:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 11 Feb 2022 02:27:16 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 11 Feb 2022 02:27:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krjxLXnhd4F8mhswjCKjNOtDqJyiCL7tp3kUIOrBnwz+qGP92ExagyNdP3ZTDpzGPbh8eEFoD2HmOzvDT0/SpxFzCVD2dcjhol39PfN5fmZHnZLOvdqAJ5hTYeTseZ6QasPHVx8q2a3xK7zCAfx2uoOUkQ4/hejS/Qg6RwdH6bJInztgR1kbqN1ne67FDptkdpTGgo1IESGKbbg+/J10Vja39zRxJLSmOP5Fd6ZCcLmDy+Zs3NKbvNmfYfeVepuIgDDz0umHeFnRNtmEGal/+bnAh/zDBA6oLpl+RH/gPgwLIN5KX2iLeiyJbX44fjIeLz00vKrnKjrCEy3A6Y08qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFVmo8MD9P7B7L8xr6TZSW43teAfplC+tr+qDpJ/IY4=;
 b=kPIsCLoiQs0AKW0nJrRcp9WdjkwnNIoPe43uF/4GezIdwk1yK/8Cfil8iXHGbrWyvsbGdejxdyNXTZ+vPAVHcguoI85TxFm3P10TCEsrInn+zRQlCItRLAypFzzscaleO0gOBKFvAaRexDpaqHHI2LlrJ1zfqq9aLBlu4p9P2NkPAZx0jA1xY0gnWyhVme+PltJmZ0oMcETMeXJSdsMoXmW9h9dl2hzGCaRDfUF2+7PPyJr87XUvYjKQAwZtxd3yXkx0Hi1S8DPVUTmafM6gvyBxEX/Xdq6Vi35RUZderICjOLGJZ3VK9og08wyih7ZauXp3Z+x7mx6nuPqhevHscA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BN6PR11MB1716.namprd11.prod.outlook.com (2603:10b6:404:4a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 10:27:14 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e%3]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 10:27:14 +0000
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
Thread-Index: AQHYGefbqRcNOb4NqUCQWYuxV/hGwqyFLYqAgAR+yXCABG/wgIAAEuLQ
Date:   Fri, 11 Feb 2022 10:27:14 +0000
Message-ID: <MW4PR11MB577686D883EEBDB2C9E0FEB2FD309@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
 <20220204165101.10673-1-marcin.szycik@linux.intel.com>
 <Yf6rKbkyzCnZE/10@nataraja>
 <MW4PR11MB5776D18B1DA527575987CB1DFD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <YgYpZzOo3FQG+SY2@nataraja>
In-Reply-To: <YgYpZzOo3FQG+SY2@nataraja>
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
x-ms-office365-filtering-correlation-id: 47f3e14f-180b-4139-6c05-08d9ed491278
x-ms-traffictypediagnostic: BN6PR11MB1716:EE_
x-microsoft-antispam-prvs: <BN6PR11MB17169DC334495799AB96E32AFD309@BN6PR11MB1716.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WOylykL7wmVpuv861loNOMICVo/RpgH0tTuTifStf6AFV8cK9BCXO8GCsPIOatesY/i/mmbB2JXwvUZqKra1vTtRo6tyrTi3Mb7UqkSFw2wLVEM0NKKNXYCfMUqm5FpxGqGoh3ARKnPmClM4ucoqJU/kBGsemASHnnWB41BMNGba1pUe8Bm8juF2fhWZBGBwNOTTNEIj+1ofDCc/VkzHx1Xhl2L4LOKOh7c1X+Ra/XMYUsNDll96PEKavkPYBG/x//ZowRUxsWE8sICpjX5Y3jheiZUybo6FCIe8PdzW8eSTH9PNIE04Qn3GVh9OjtCtxp/olVJtrw/tT6+UQZIPc7y4QD/xEj8SC56BQh2shIr2oh8O/qLksMaUN8luhOU9AaGsoKbB7wPao4xbhO9oPEMhGsFRAyIyvDzkwm/DNChKtyQg3NYL0IWO3MD4vS3vhaQARS/FhLc7Xlza4nGsj3BwObC742CTZ6MSZ7X9VPgl4O5hAGhN9DM/WA6N+l/A6SkGq/feLfEBBOpOMZxSfAflrD27oJnCwEmBJe2fmkpAqJ9TzAT2QZ/H9VG/zlXbZ0aptOhwBdNELjhnoDGTaRE8ekHl2zCsfMkLbIvwqgirEA38PPqzTvitHleDdvlyGD5amC3eXqWkRDXe5iR8f9KUmM2nnUzTzwHUmOAtaiyxOAsN05sM9WNNi7LiX5dmcspJLYQe0DzL8H1ik3podBxXoCzHH6xrUG/ODwQvq/+/6qyrheVcn2eYKcnzCX2kAREv4PZl+eOq67hctrKq7cr0ENs+QBKN4bMumJUTdnU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(508600001)(966005)(26005)(9686003)(53546011)(7696005)(6506007)(82960400001)(83380400001)(71200400001)(86362001)(66574015)(4326008)(66946007)(5660300002)(38100700002)(122000001)(66556008)(52536014)(33656002)(76116006)(38070700005)(66446008)(66476007)(54906003)(2906002)(316002)(64756008)(55016003)(6916009)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?QaEElN5AbdkIsSEaI5tceVYWv9MpVRUJuq6o9KxZArTTKlAmGiuQAsplNY?=
 =?iso-8859-2?Q?r6bEHcNF30WVk5mr7gUEqWcJueRgNlNpdCN4+IcN1b3NQX7Vrctm11kh4g?=
 =?iso-8859-2?Q?zssPlSUMfaVePBSahB/I7glDi4ZHUtNEcvIBumHmLsCQoXW1lUweDYHMl7?=
 =?iso-8859-2?Q?fOTEOEg8fHNBKZdhfgINn9vKmR+VjQ5HibiGzxTOjpa6XoLMaQkauceaa8?=
 =?iso-8859-2?Q?9etPsA+rzcm9SJ/BGcxypUsLVgpuSXnKpyQYltDYgG4oL2yEWaK3pREF46?=
 =?iso-8859-2?Q?HFidNItUsulAM5my/8wT4LdMwhjn+WJ0Vi+UMhYpL/6ak4ipI8KmZYqsgT?=
 =?iso-8859-2?Q?W7g8Lig6tvJ/V9bqFqB9V1VS5qkWAyVOJXIcENt8p4ca//xNkUemb9K4UK?=
 =?iso-8859-2?Q?ciNfyjkXbSAuGNNao4a9/A9iz+u8bT5PwWjXDYMbD75GQsz3pCcrtgmcJg?=
 =?iso-8859-2?Q?N9+GKFJ4UBQPt5NA/EYjqz7+xSjtFcxIpbtB/zTYtYTceW2G+ZZbKJChgU?=
 =?iso-8859-2?Q?Jjo0nc9pIIRyvu9b7oeGsP5CLyhYX8N7AO2FDpsuNsBzDObJLWSbU2qerX?=
 =?iso-8859-2?Q?nKvNST/m2sIoY5+GI/OIpRWHSnmJO78s48KbkZNekgean9JTi4NiVjsREz?=
 =?iso-8859-2?Q?P3ZRP8RbDoVbfNPVz1XPe7G7XQ4VclUkr0CMGHdj3SJpQUQkSm/IzplWoz?=
 =?iso-8859-2?Q?w55qGCBazY8el+ngmrF4ttbDOSxcnpo9jvCANnVVX8FVPXdB4vboyA8j4C?=
 =?iso-8859-2?Q?6uW+v1Ve3vu47IjWAuk+jyPuH5DyRMkC25JJrU6gKhEGNd5iSAvojIoALy?=
 =?iso-8859-2?Q?JLnaQiPoZyiX9V5PVLjmgr7w3aP10fT7NJrF4GpeDvziNHUXnQepRxffpO?=
 =?iso-8859-2?Q?3KUjn4jhbPHlPph+17PnEgJbMfG76b/+tGXWA3VbEq8RqFH+W879tunVlY?=
 =?iso-8859-2?Q?sbPpp9ajegeLO7lWhOumzxUpPBywHHlaXmHsuMeJdV7/DBNIvDbOck9eal?=
 =?iso-8859-2?Q?kxZtcL/C7GHBU2eeogJwHnf7UcYDAlWwnN8f0q2eE7IbNEOuIPCtGHT8Er?=
 =?iso-8859-2?Q?/jxsktAsKNjLyuuBinNb9YwJUuM0T3vGepcuZkqjAFbIG23qdgHdEJNSa/?=
 =?iso-8859-2?Q?8NqdxyCCPAwEMRCgY18OWeZh1i9IFGR5W2ej20CGrXkLuqUMc32diVPm03?=
 =?iso-8859-2?Q?+6d4JcX20Tn2AjbLsB9vGd1c03mhV6Gw+jfVVQ1HWWwPngAEhFKaFTZkLB?=
 =?iso-8859-2?Q?Uq7iZQZ/wZO+Ykkx9XGTw24eItTsDA/ZejocvRWDKYsZB6hnw8JRLmciEB?=
 =?iso-8859-2?Q?Ki6CiTjtakRV3JLsYHvU81l/U43Tns7BUroKFcXDSyIXA02mMZ0EoXDvbV?=
 =?iso-8859-2?Q?AWntWBicLutvGZEuhC/8f8c3wcEXz50REJBHrTUClbMJKlfqHPWeh7d3rO?=
 =?iso-8859-2?Q?tXS5JJo3SqidnfQSE5ok5epwQ8pH+z/dG6JyC6kjaOuDCtJg0DBC+RV3oY?=
 =?iso-8859-2?Q?/IyzHiU33Ex6UWZtcs+XpTPwY9w4hp3W5N0yXf1fUDsNuc9y7u9vwP7Q+1?=
 =?iso-8859-2?Q?YpCau/TWd3jlvPt7nn736fNZlsYM+5L/dMTsjXaEhSO1tuGGAEZq/KBb2W?=
 =?iso-8859-2?Q?Kjyjb0dfs1wdiMg9kj+nk2t8+o/PccINQGS+No9/cNvd0yTr9DVEmrRxR5?=
 =?iso-8859-2?Q?PM/i+fDFL7SCb7dgtKwM4GWSx5rRfaEhfOjulGfn?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f3e14f-180b-4139-6c05-08d9ed491278
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 10:27:14.7133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4qdNsFXa/IbmlfYMJzxvj/3glLoSh8+MUakaRM7ZrcL7ZzOoEPwBRPZ3TilppUAc55dNVbGYV3ZWd9dVxf4V6eLa3GwEmWFJQH4H4ahsBuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1716
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

> -----Original Message-----
> From: Harald Welte <laforge@osmocom.org>
> Sent: pi=B1tek, 11 lutego 2022 10:16
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: Marcin Szycik <marcin.szycik@linux.intel.com>; netdev@vger.kernel.org=
; michal.swiatkowski@linux.intel.com;
> davem@davemloft.net; kuba@kernel.org; pablo@netfilter.org; osmocom-net-gp=
rs@lists.osmocom.org
> Subject: Re: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
>=20
> Hi Wojciech,
>=20
> On Tue, Feb 08, 2022 at 02:12:33PM +0000, Drewek, Wojciech wrote:
> > > Remember, GTP-U uses different IP addresses and also typically comple=
tely
> > > different hosts/systems, so having GTP-C connectivity between two GSN
> > > doesn't say anything about the GTP-U path.
> >
> > Two  approaches come to mind.
> > The first one assumes that peers are stored in kernel as PDP contexts i=
n
> > gtp_dev (tid_hash and addr_hash). Then we could enable a watchdog
> > that could in regular intervals (defined by the user) send echo request=
s
> > to all peers.
>=20
> Interesting proposal.  However, it raises the next question of what to do=
 if
> the path is deemed to be lost (N out of M recent echo requests unanswered=
)? It
> would have to notify the userspace daemon (control plane) via a netlink e=
vent
> or the like.  So at that point you need to implement some special process=
ing in
> that userspace daemon...
>=20
> > In the second one user could trigger echo request from userspace
> > (using new genl cmd) at any time. However this approach would require t=
hat
> > some userspace daemon would implement triggering this command.
>=20
> I think this is the better approach.  It keeps a lot of logic like timeou=
ts,
> frequency of transmission, determining when a path is considered dead, ..=
. out
> of the kernel, where it doesn't need to be.
>=20
> > What do you think?
>=20
> As both approaches require some support from the userspace control plane =
instance,
> I would argue that the second proposal is superior.
>=20
> Regards,
> 	Harald
I agree that second option is better so I'll start to implementing it.

Regards,
Wojtek
>=20
> --
> - Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. =
A6)
