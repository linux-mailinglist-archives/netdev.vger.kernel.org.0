Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B4C446B74
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 01:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhKFADq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 20:03:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:31062 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhKFADp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 20:03:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10159"; a="230724862"
X-IronPort-AV: E=Sophos;i="5.87,212,1631602800"; 
   d="scan'208";a="230724862"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 17:01:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,212,1631602800"; 
   d="scan'208";a="668397925"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 05 Nov 2021 17:01:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 5 Nov 2021 17:01:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 5 Nov 2021 17:01:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 5 Nov 2021 17:01:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9MWH/StO3DZHaMI2fb/pcjfVA6SiLV/oUtNdluqcVmU0Xuv3Cntknzu7ZvDGcA7pLR47QJ04LrJuGbEIzXJUybne83Dl7uUg71Sg2LxAXkorK5RJUSTVEEArRjb/aI0QvTEvcJdm745AiWKECo0v1eVCF8P3tsECujWtAb8Lk8/gmwVb+Cin9pL189W4aIp1BP3O8fRYYktnAaHrQL17NVi3qP1lwayhxu5Ep9XjQ4wqxTrpbw46nKBZNZOzyBuL+YLk5PaRHfC+s1kcUM/WLzBHuyKcMku/mIZLFatSPnFbn/rN5JqT7kJqa6ee5/fQa18QPl93PPPvHsG8Oldgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDL08Zz9ttOojJ1tLWIvKgCHFznsPI8bYbGfHvxVSP4=;
 b=G3mipcIMhNuouz/+AJEAQorNlrxhRE9+5fNbGeHp1uL6fxOpMMQMGcGSeg2jFT3D53CURKORETeCHIcn/eBplp/rZEwBU5bNDBCofV0S/TlmvrHd4FDZw+LDl+sn0ofoCbl9lxaz8m2qy/RgI+XjneZ+0zlKGDSSrGQG+HWSa6/hl8GF1958ju8xVJFID+JwK5vkXaOwYP8IX+zNn4cx8J8ZIod9O5BcA63a/S7j9u1itZFD3/VjXVyRbaicEdRo0L0kBeROEYJ5hY7NiUNza4O+AYFbMvbzHdICncVzIJGIVxOcS9SjTOLZ0Q/am6UGHGMJGVaBIsKC6nziPbRACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDL08Zz9ttOojJ1tLWIvKgCHFznsPI8bYbGfHvxVSP4=;
 b=xjv6Ry3qvWP+If+NevfZbjE58RqHrNh5sHtcslle+XVsoAEO7Y3JQ38LUySeq6SIN43eR1iA9+N1m4bRMSBs4HYj5y6Xr9e07JEmeMITKbXekHPjKmDoF0rsNCOGPxsydI9FDcDoK6JMr0MDp6ymAdV5qf4ygFS4i/9SCFl9/Pw=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR1101MB2206.namprd11.prod.outlook.com (2603:10b6:301:51::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Sat, 6 Nov
 2021 00:01:02 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.019; Sat, 6 Nov 2021
 00:01:02 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX0VXcGtUZm/2t30+on8cXw89n7Kvzq2OAgAEBMxCAAMlggIAAHeZQ
Date:   Sat, 6 Nov 2021 00:01:02 +0000
Message-ID: <MW5PR11MB58126A63061BFACB81A98194EA8F9@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
        <20211104081231.1982753-7-maciej.machnikowski@intel.com>
        <20211104110855.3ead1642@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MW5PR11MB5812FA6647FF189D368C75A5EA8E9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <20211105143013.2cded2f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211105143013.2cded2f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a0e824a-6c36-41d0-2d9d-08d9a0b88584
x-ms-traffictypediagnostic: MWHPR1101MB2206:
x-microsoft-antispam-prvs: <MWHPR1101MB2206675336394B53AA0ED683EA8F9@MWHPR1101MB2206.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nx/kHcD78td6MQSbxE3dh1Mwe8cezrgr6HZnBx14pbSWhWKcVsoENENeCUNgBqTfOaf9F8MbGg0YBzeai9kxb+ftSjEDZNbR1zWT8cz1/5InndasxCaVYjJTjumTgu/PY3jSydUEXLG7yLFO8LbgcHOXJ5iccu+tYAdhsoARIsu4GrjjuZl7+pT45suopWPJyWEW7dI187hDRiZzyf5i1P1f4/pfRswVl6gxjoN/TXqtY8PI2UyjRO6AWmbZujD6Z6zmypdaTOGwS/XZV3Vlwr6AoSeipA6PRcgn+7oNYQAy8Qkh6pkO/X9IdV5cX7MQKQlFNc913Xf2m7clDuhPTyRmNnT7A4MyFd58RPSMPW57Lc1+nO5zFYGc9N/sw6cs9vAIJkCh7vnCDz/OQ40/9eEoeIZ4b/pnHmSQ2ywgfIP60uhh0CYV43WS1ynYMIMfuTBc7vp5YdNuftGJIC/y0w+xjxY/kpYaUasrMuV5GAUOBFT3z4xvRwe/bxgI/1EFuZ6TPteC/9vEaKrtAYYq/LIefd03PUcL0ynos3hhTdKS1G5f+iQc2pr+9EMSO/KN+vja/dPIwaejNn761dmh3A4vfRNC+HoiYsa5bsSdweTi86whhG0FiAR8vioJLHgmpwwUGEwQ+GqOa1OdXjKkwzGStU3ppV48c5gq5BtBGWIfsRTe9jBCjHHF59OteOgrcsDhj3nFqbrHSkIEWBYOVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(52536014)(71200400001)(4326008)(53546011)(82960400001)(6916009)(6506007)(33656002)(54906003)(26005)(186003)(66476007)(508600001)(7696005)(55016002)(2906002)(86362001)(316002)(7416002)(9686003)(8676002)(122000001)(66556008)(66446008)(64756008)(66946007)(38070700005)(8936002)(38100700002)(76116006)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zcJH5+b9QdKwv9Vv05f2ZUaFC6C8FKwQ2+FORMqKV5nR9vqeP7s3UaQ69A6c?=
 =?us-ascii?Q?vsdsQDlT78102rsctTFI9kL+kr+zdJCP4j8YpBKefJXIE3++XeUmiFX16Yjw?=
 =?us-ascii?Q?GP+T57iMqT+ptpJ0ZwTHIfJAUQocOv2sEsEIdQ1WUOiqjUa/mAnFHBNHMhfa?=
 =?us-ascii?Q?BcLyvCsEyaZyeV0bE1HlDXSKxj4fBEuZXjQ70dDSKW5ix1WFcRUYt2HEnrsM?=
 =?us-ascii?Q?G2P+aWfnW1fMTq15eRJtkJKs6OuRav2tmK1Br5+m58A+pLvR5AiUK7y9KKxo?=
 =?us-ascii?Q?5Df0FDm/vPyeU3uCeIZfFdCHMifCq6xyzzgKejSJ6p1JLXTRJaR79enO+8bt?=
 =?us-ascii?Q?uLJ939cewOd5gXFhrAkh8SfIgXoM0l+tovl0Yf3g4Ia6KDd3Ec1P/Jaj6eT7?=
 =?us-ascii?Q?RpSqKcQXiPLdO6HRxHN6YtnDkxrJs772TH5TIU/OGnAt5PAVV3p5YWJk688M?=
 =?us-ascii?Q?GGSyzsmtPqvWXmVa6ro3HfJ4NkMg77/x2Z9WuKBYJUVF8HaHs3r0IYPMKbkD?=
 =?us-ascii?Q?GUz99x8KLyPtlJyDmCNpT8GoBaY0gRKQj5sT0O+8zC8MwyXFHow/Y+sF13vi?=
 =?us-ascii?Q?dL9bfnFHSKFnPH8xGjkaZqHxn+PsFozUdzLJxEqCWH74W471tVZG2s4i+Onk?=
 =?us-ascii?Q?b71LdtBj95SpnNGXCNfpOwQuXOYxHccX98hY+n495b8xJKadVnmR3XFLR6Nn?=
 =?us-ascii?Q?1DiZ/sSDm5e19grhQoKDUF/+kBOZ3s66/VdMJ0MkBlWkJw5wX1aK24WdogJL?=
 =?us-ascii?Q?51WaE5ntC29YkT+Ee+kOv6v9VFtJDnppM1FEVKrHW+7E6ZWbq7oV12rKefpA?=
 =?us-ascii?Q?1jPPu5YPR5fy8KT48+pnLYNU4sqQ9La50mgoEd+go4DjYfsmciQdWJEggcNq?=
 =?us-ascii?Q?HIN+FE3TcrJZyB5ZggfvcZmYefXfIfU2pPcdjwgDjnRrdTXMl30IMnIr3/6c?=
 =?us-ascii?Q?bJdn5qUG+cUNVZga2OzlC7w0XaunFiuugTjFZtPqRxVaQMBz/vVEFg3YfKL8?=
 =?us-ascii?Q?KJ5lCmNdpCM5AJjjVqoNDuLL15HL4gYWmB8UCRgxwzMn1qK0Imfrv8sxPpTI?=
 =?us-ascii?Q?QmgVsqhl3nYhTtK+nZhyumqZKMXsBrjNo9C73zfB/QR2SlwlpSyrBer3vbEM?=
 =?us-ascii?Q?Cb2xM3Bk3OYuroEHfkeYBZZ0N1kPVaJDTPubfm35ueTCNPDbcSGpqzqfQnHb?=
 =?us-ascii?Q?WtZ3Y5TI1PIUWJQSTdK8ferKJgxpGpezebV2L4pISObmhQ99BZM3TIO9Bvxk?=
 =?us-ascii?Q?T2IPc2lXqQ0Id2IbHmVJHoPq43HN7lsesnDZ5pa01WmzExVEzpYE2FJw1rUD?=
 =?us-ascii?Q?yqZiF+ZeG/H+NR1N5cMXXH551mePhgDOYbQJo3ElXiJO/x3+fJ2kOBsJZdYH?=
 =?us-ascii?Q?FNhml+L2n2vw2PZns0TWcOjFclOs2Ct6c+NYYYqDqCte5KzU84NhKBde5IIp?=
 =?us-ascii?Q?KGUrx9f5ElZMYI5jDUjRi3ctNipvdP4rlLnjto5bTSDvr6a73PtdxvSFP6ch?=
 =?us-ascii?Q?faKDD1HUGB6yQ0d0MBEHgrTvyL98ppZcm5PJSS0Xb3CghYDC/ESS2FJvx0Bs?=
 =?us-ascii?Q?xfsXeSODemxnOKq+FFgAaRY2Yl3VTUXSzWSBD7X2Li4q9LfSRf5Sf1WhBEKb?=
 =?us-ascii?Q?QrNMqhhOLrzMCf8OjrDJE5l57IzfR4IXrqm3wE4h3RBvm02M+583SOPyR3Rm?=
 =?us-ascii?Q?9KgFtg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0e824a-6c36-41d0-2d9d-08d9a0b88584
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2021 00:01:02.2412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0I47UXkUnPAS0ApZuUsjiLTnGHgCog05XrkabPjexTxn8PpZnLYWHv3CgSh+w4jdtODCzzJFWSmFbtBdiQQCfx68NWuBmY+JKY4AIi94MOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2206
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, November 5, 2021 10:30 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 6/6] docs: net: Add description of SyncE
> interfaces
>=20
> On Fri, 5 Nov 2021 11:51:48 +0000 Machnikowski, Maciej wrote:
> > > I'm still struggling to understand your reasoning around not making
> > > EEC its own object. "We can do this later" seems like trading
> > > relatively little effort now for extra work for driver and applicatio=
n
> > > developers for ever.
> >
> > That's not the case. We need EEC and the other subsystem we wanted
> > to make is the DPLL subsystem. While EEC can be a DPLL - it doesn't hav=
e
> > to, and it's also the other way round - the DPLL can have numerous
> different
> > usages.
>=20
> We wanted to create a DPLL object to the extent that as a SW guy
> I don't understand the difference between that and an EEC. Whatever
> category of *PLL etc. objects EEC is, that's what we want to model.

The DPLL has more uses than just EEC. I.e. Timing card uses one to generate
different frequencies synchronized to 1PPS coming from the GNSS receiver.

Implementing the whole DPLL subsystem may be an overkill for some
basic solutions that are embedded inside the PHY and only handle the
syntonization of TX frequency to the RX one. In this case all they would
report is the current state.

> > When we add the DPLL subsystem support the future work will be as
> simple
> > as routing the EEC state read function to the DPLL subsystem. But if
> someone
> > decides to use a different HW implementation he will still be able to
> > implement his own version of API to handle it without a bigger DPLL blo=
ck
>=20
> All we want is something that's not a port to hang whatever attributes
> exist in RTM_GETEECSTATE.

Routing to the DPLL object will be a specific use-case required only
if we support advanced cases with external sources of frequency
(like an atomic clock).
=20
