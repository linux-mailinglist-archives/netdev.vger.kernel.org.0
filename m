Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912C744C4A5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 16:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhKJPxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 10:53:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:25248 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231838AbhKJPxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 10:53:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="219899574"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="219899574"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 07:50:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="452362621"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 10 Nov 2021 07:50:52 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 07:50:52 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 10 Nov 2021 07:50:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 10 Nov 2021 07:50:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+2Mof7KAHDYBAitStN+fYAYmn6soFlj0CTSLrC6CqBtQ1ro3+kHRhWm/bZ7nVORqC9pGze5MJCjGbLMtGSwRlgnbvep8NyLT/oA0OBjvdCgLZp/Y1oDj7975HakTrr2c3hgSqFioOX1DXND6Oe7oN9rKUtH4XIp+hcF655jApY7I5Vg3Mw61JlRgkUjjlwoMSdvsrLnOrVGwGZjBj6+6T6cD1rmpIlEfYqPg7QPzO4+ISjsFGxiPd6DNldx1qCXz6XtzC9VdwVXOM1tl6t73IWmUrTOK+XHtFpPz13XIZ0Qj936mC+cng+H2MxWXX3QCnwFNF+pmSlNxewVPTksBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbWxnQMP7LqqetXgu+c9q6uaexHqeRtsI08AzSOgGU8=;
 b=IOLQd7uYlWpvakwxXoXEOfwajyqfmpX9Cbf+wDpSpcG225a1niXr4xDMVv2UMZBOLXWwH59WdPhLsTbtOo+lmoLyD1myaFMJsApt5gYd7tI0lV9FSoY3LM9KmRvi4ns/ACZYEwQf220HVyZwUm3x2rP+PMOAhx62UvGJsJfNfMeiIEX3Am1X/VMCzQ6Ljt7a8g6Mt5Vb0Hp/HPZ3AVbWjRTWJDxtJ4+gylryQeDNxJVZyftNRIwtgr7RbQJP1NILcbIdrFCw9bRGdCXPjuvJd+Q5h6lyJJnMsSIjMDoYKhePm5zdT1n3Rp9IX6Jvz9bAuPfl6QX67XgrmYyyMaW5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbWxnQMP7LqqetXgu+c9q6uaexHqeRtsI08AzSOgGU8=;
 b=CamuuWqDNqrR5TQCPsj1Kyq5drfZKqMvXlFllYcjHEYoOAn8UG+v+Zn3F77yavvFS6R0thjuq3kRy9hpI4Zu8tLrpNC9ljbILe9CVNKYFWZomsUPCm0gA05wz7K7PkF1KYEy04/hBSRcNAqvBJr9T49acGiEtM3ZzxWMAinD7OQ=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR11MB1246.namprd11.prod.outlook.com (2603:10b6:300:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Wed, 10 Nov
 2021 15:50:50 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.019; Wed, 10 Nov 2021
 15:50:50 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX0oli6labJUcox0OLXoT9uSo8Gqv57+iAgAEU4LCAAEj/gIAAAf9ggAFGKoCAAAPsIIAATJIAgAACLYA=
Date:   Wed, 10 Nov 2021 15:50:50 +0000
Message-ID: <MW5PR11MB5812757CFF0ACED1D9CFC5A2EA939@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
 <87r1bqcyto.fsf@nvidia.com>
 <MW5PR11MB5812B0A4E6227C6896AC12B5EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87mtmdcrf2.fsf@nvidia.com>
 <MW5PR11MB5812D4A8419C37FE9C890D3AEA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87bl2scnly.fsf@nvidia.com>
 <MW5PR11MB5812034EA5FC331FA5A2D37CEA939@MW5PR11MB5812.namprd11.prod.outlook.com>
 <874k8kca9t.fsf@nvidia.com>
In-Reply-To: <874k8kca9t.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8723a0b-640f-43e1-de30-08d9a461ded8
x-ms-traffictypediagnostic: MWHPR11MB1246:
x-microsoft-antispam-prvs: <MWHPR11MB1246C57EF0B76FC9ECFC19EDEA939@MWHPR11MB1246.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VogaVP9fCGLXM7ktzaLJAUXjSQ5GAe6vlyw9STgjsIeelQviBJ9o6w5qA1Ck+OPQ6D0n+fPSb0Rfgw/9k8rlUQlRudfICwHIXI18Ui1fhvUOtVE3VXSbgPl9tZJssrbq4kgozxSasemK1gq9gBObhj/u3Vr+dQbwhYqvjdbBdmGurzQax1wCPt7uBA+2cYK9zVGKQIymlcIcVnk6ebZ1tS9TqdOz0I75AtxgiRWEn3gOdH61fRnhKbIjHJevvsvfXTzr7It3LV3z4x9MIaJy1HiuNmigER+G6gB2WGqdTNRAtxJcXI0huABVr0/mrdSJipRpiimhDSkjSYFiY0z9/hYHXJgbHuZY/OFYhTAYlWDI4tnNUA0lwrU8sXE7e3XQ5xiEQYuB+uvuea0fDh70nXDvGGi/AZYzrUJoxqi5OxYBIjVyzt7QoTsVUuOwkfBXa5CkMva1eF8ZT/SQSFRARxhA7ZaOeVYDw0lr0bXaME/bBcFefIVaGsmbDKYRmg9k6EOgdJY1u6oTYYfJ/l3nFRbSqe5EsAWLMvL93G7VqdHsyjEFPMP8QqjvQS44pCn20OSXbEtchzu5d8cJ53jofh6I0/hsqVJnUjgiDGw7mk/yH4exXRKAadMPQ8+LmzNdrJOqvBXEyYdSadn90IXkkKfpXW/5R7+77UNCTauAeW7GjWC4jrkmiNwcx6vEAUugvQgt1eQMqWDtsUTJVsWqWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(7696005)(86362001)(66556008)(5660300002)(2906002)(9686003)(38100700002)(76116006)(122000001)(316002)(52536014)(82960400001)(26005)(4326008)(83380400001)(66446008)(54906003)(38070700005)(71200400001)(64756008)(55016002)(66476007)(53546011)(6916009)(6506007)(8676002)(508600001)(30864003)(8936002)(7416002)(66946007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fRKKN35yP3+ex6nquS5PF1yas9xTGMX8xHjuovu+tZi2b4RKgx16PFb7dOiR?=
 =?us-ascii?Q?4QGmwOmscv+eu+XjsvfQLga7HlknvRbuLd969Nc12YMy22mcAmxeVslAWFm0?=
 =?us-ascii?Q?HKJJ8mRZrt095uShXEsbw6wTHxKf5coH+dcs9yEegP8DE2reZbztSU5z7hnY?=
 =?us-ascii?Q?zLKzdcTMR1hAhlkjYp7cODJydOFEVhPPP6pTppIAXHbLe0DLiaP4fTBeZx3v?=
 =?us-ascii?Q?mw3TVRJ5bvV4e3oWuk6IW1jtNgtLGIcV20+3Nk+32kDHvDRc7RWC3A4zqQ1B?=
 =?us-ascii?Q?fy72SGMG/fMo/xeLR6ULNPRg+M4a7Fhsj9TuHLCfIK9lzeEz1OxonqI1lrOe?=
 =?us-ascii?Q?6URm5C4ZWxQjufmlHBA9fm2cAQ/WYxOHzzO9nKmFFez2Xcs3maCjX1Ovd/UE?=
 =?us-ascii?Q?XMSQoA+ASl3jFoH9FCVkq6tinrdVaPClCMHNSNiYfYQL7jMrFyXV1Hkfsl5D?=
 =?us-ascii?Q?2KLpwqhM6jWcytOUzl0jhPOLFfExjK3vWe/xwxw6gmTkLuDbXlg0R4JZmeUc?=
 =?us-ascii?Q?2IoJ9n8Hcirz1QTjlLTn0CRSivvp2yM1SDaU298nBHAXo+CJvl8cOahO2OC8?=
 =?us-ascii?Q?QcRI0071OhUkscc727THjfzagDLHKS+VDlZpWadfEkqHUoKKxcmq1V6lZ34J?=
 =?us-ascii?Q?Yu7p3yWLZwLZcDR5Kc2GsaPevQDCECmogObA8IJfDfATmLOgnkixLm/1hEyc?=
 =?us-ascii?Q?TWdvtTnviAOy0DUMn2EJBqpXXYjicEVBuAyuTP2AOlZPl/d5LxwtDdNUb490?=
 =?us-ascii?Q?ofqpeEHALi+4p6E7O8VFS6WmiGiiSodAHZ8nVNwHwG+BUTyzdwOAos1f3p0e?=
 =?us-ascii?Q?lxbLuPqBVrOx8DAlqGiEu1QvuiU1cwaHF93V/TdNKCsfwNzdPLs3AgMlPnjG?=
 =?us-ascii?Q?HeCKjp3Y0c6NxuPMZgncqokuAwooRX0Q4NOMwcz4WBp2exI3jdeemFiPytev?=
 =?us-ascii?Q?9WNperVPJ0ztoLCU0ONyFdOE9RBoIS1uwtLuZW1Z2UAsl5/KH/3isUo9iNqx?=
 =?us-ascii?Q?jU1zZeyhEfpCrR/vWt8RZaqNW/OO5DOzx7Osw5r0J03C7/AT/bT6fo03P9kp?=
 =?us-ascii?Q?VT54GwTVpjVcKJe1PVNkOcJ1M/JTefY/UonMKNz7OlgWcXxxv//n9fjaSaka?=
 =?us-ascii?Q?XZgdEzv1i9YAV5G2163oq7WD1o3vxl0JeXwpNbo7afEGgr5Er4SablVOi0NA?=
 =?us-ascii?Q?gtI8ecYiPoVxCdfQ8p1hzx3NB+Im+cM9yAQLf/GsI59Cc5rwT7/ezNfZq75C?=
 =?us-ascii?Q?WNsalEkq6OrQbYReIyFXkZ36RQXrZ6tMmsuxeANzhKFYNPtCGFp+fq/TZx+o?=
 =?us-ascii?Q?gVrQSMmMry7sM29wdpD+rkgu57onFnbL3CabJrswM5ngSSxs+Usy2Psd1eXJ?=
 =?us-ascii?Q?z7YsVjUq9lDpBRA1/lykcTxVmmFhZuF7yrVTJ64YZGqzpc7o2rD+U3wvnsxa?=
 =?us-ascii?Q?q1uWq34ylDVGiUtJybmBoE8BZ29OqigiRToxgVBjFaDzmUTX0T59UWdvXVUe?=
 =?us-ascii?Q?jZS4gDKovUpK1MAG0QEemzAHDXtDAgSUFyjKuiz729wiq4aXoCuOu4dtenQM?=
 =?us-ascii?Q?du9aX2I+Vd2rSbisF8a2sJPEOtZqav6EmKP78U3JwFF+rz1Ln7MnB6LWRP06?=
 =?us-ascii?Q?k+zWCB+J20rBj8B1ytFlyXWA2uKfJKGJn8ed9boAn38gze4Hd1AtTo44gXKq?=
 =?us-ascii?Q?W9KZrA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8723a0b-640f-43e1-de30-08d9a461ded8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 15:50:50.5789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGm9ryUzVIChDsQd66IoxnpBLZX9UqjpSnr4FzwoCPoIyCRg/lTOH8VkMU0hE/xKDz7HIxZs4Wb6BHpT9i3DzALAY04fJVVEBw3uCVUDbPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1246
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Petr Machata <petrm@nvidia.com>
> Sent: Wednesday, November 10, 2021 4:15 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
> interfaces
>=20
>=20
> >> >> >> First, what if more than one out_idx is set? What are drivers / =
HW
> >> >> >> meant to do with this? What is the expected behavior?
> >> >> >
> >> >> > Expected behavior is deployment specific. You can use different p=
hy
> >> >> > recovered clock outputs to implement active/passive mode of clock
> >> >> > failover.
> >> >>
> >> >> How? Which one is primary and which one is backup? I just have two
> >> >> enabled pins...
> >> >
> >> > With this API you only have ports and pins and set up the redirectio=
n.
> >>
> >> Wait, so how do I do failover? Which of the set pins in primary and
> >> which is backup? Should the backup be sticky, i.e. do primary and back=
up
> >> switch roles after primary goes into holdover? It looks like there are=
 a
> >> number of policy decisions that would be best served by a userspace
> >> tool.
> >
> > The clock priority is configured in the SEC/EEC/DPLL. Recovered clock A=
PI
> > only configures the redirections (aka. Which clocks will be available t=
o the
> > DPLL as references). In some DPLLs the fallback is automatic as long as
> > secondary clock is available when the primary goes away. Userspace tool
> > can preconfigure that before the failure occurs.
>=20
> OK, I see. It looks like this priority list implies which pins need to
> be enabled. That makes the netdev interface redundant.

Netdev owns the PHY, so it needs to enable/disable clock from a given
port/lane - other than that it's EECs task. Technically - those subsystems
are separate.

> >> > The EEC part is out of picture and will be part of DPLL subsystem.
> >>
> >> So about that. I don't think it's contentious to claim that you need t=
o
> >> communicate EEC state somehow. This proposal does that through a
> netdev
> >> object. After the DPLL subsystem comes along, that will necessarily
> >> provide the same information, and the netdev interface will become
> >> redundant, but we will need to keep it around.
> >>
> >> That is a strong indication that a first-class DPLL object should be
> >> part of the initial submission.
> >
> > That's why only a bare minimum is proposed in this patch - reading the
> state
> > and which signal is used as a reference.
>=20
> The proposal includes APIs that we know _right now_ will be historical
> baggage by the time the DPLL object is added. That does not constitute
> bare minimum.
>=20
> >> >> >> Second, as a user-space client, how do I know that if ports 1 an=
d
> >> >> >> 2 both report pin range [A; B], that they both actually share th=
e
> >> >> >> same underlying EEC? Is there some sort of coordination among th=
e
> >> >> >> drivers, such that each pin in the system has a unique ID?
> >> >> >
> >> >> > For now we don't, as we don't have EEC subsystem. But that can be
> >> >> > solved by a config file temporarily.
> >> >>
> >> >> I think it would be better to model this properly from day one.
> >> >
> >> > I want to propose the simplest API that will work for the simplest
> >> > device, follow that with the userspace tool that will help everyone
> >> > understand what we need in the DPLL subsystem, otherwise it'll be ha=
rd
> >> > to explain the requirements. The only change will be the addition of
> >> > the DPLL index.
> >>
> >> That would be fine if there were a migration path to the more complete
> >> API. But as DPLL object is introduced, even the APIs that are supersed=
ed
> >> by the DPLL APIs will need to stay in as a baggage.
> >
> > The migration paths are:
> > A) when the DPLL API is there check if the DPLL object is linked to the=
 given
> netdev
> >      in the rtnl_eec_state_get - if it is - get the state from the DPLL=
 object
> there
> > or
> > B) return the DPLL index linked to the given netdev and fail the
> rtnl_eec_state_get
> >      so that the userspace tool will need to switch to the new API
>=20
> Well, we call B) an API breakage, and it won't fly. That API is there to
> stay, and operate like it operates now.
>=20
> That leaves us with A), where the API becomes a redundant wart that we
> can never get rid of.
>=20
> > Also the rtnl_eec_state_get won't get obsolete in all cases once we get=
 the
> DPLL
> > subsystem, as there are solutions where SyncE DPLL is embedded in the
> PHY
> > in which case the rtnl_eec_state_get will return all needed information
> without
> > the need to create a separate DPLL object.
>=20
> So the NIC or PHY driver will register the object. Easy peasy.
>=20
> Allowing the interface to go through a netdev sometimes, and through a
> dedicated object other times, just makes everybody's life harder. It's
> two cases that need to be handled in user documentation, in scripts, in
> UAPI clients, when reviewing kernel code.
>=20
> This is a "hysterical raisins" sort of baggage, except we see up front
> that's where it goes.
>=20
> > The DPLL object makes sense for advanced SyncE DPLLs that provide
> > additional functionality, such as external reference/output pins.
>=20
> That does not need to be the case.
>=20
> >> >> >> Further, how do I actually know the mapping from ports to pins?
> >> >> >> E.g. as a user, I might know my master is behind swp1. How do I
> >> >> >> know what pins correspond to that port? As a user-space tool
> >> >> >> author, how do I help users to do something like "eec set clock
> >> >> >> eec0 track swp1"?
> >> >> >
> >> >> > That's why driver needs to be smart there and return indexes
> >> >> > properly.
> >> >>
> >> >> What do you mean, properly? Up there you have
> RTM_GETRCLKRANGE
> >> that
> >> >> just gives me a min and a max. Is there a policy about how to
> >> >> correlate numbers in that range to... ifindices, netdevice names,
> >> >> devlink port numbers, I don't know, something?
> >> >
> >> > The driver needs to know the underlying HW and report those ranges
> >> > correctly.
> >>
> >> How do I know _as a user_ though? As a user I want to be able to say
> >> something like "eec set dev swp1 track dev swp2". But the "eec" tool h=
as
> >> no way of knowing how to set that up.
> >
> > There's no such flexibility. It's more like timing pins in the PTP subs=
ystem -
> we
> > expose the API to control them, but it's up to the final user to decide=
 how
> > to use them.
>=20
> As a user, say I know the signal coming from swp1 is freqency-locked.
> How can I instruct the switch ASIC to propagate that signal to the other
> ports? Well, I go through swp2..swpN, and issue RTM_SETRCLKSTATE or
> whatever, with flags indicating I set up tracking, and pin number...
> what exactly? How do I know which pin carries clock recovered from swp1?

You send the RTM_SETRCLKSTATE to the port that has the best reference
clock available.
If you want to know which pin carries the clock you simply send the
RTM_GETRCLKSTATE and it'll return the list of possible outputs with the fla=
gs
saying which of them are enabled (see the newer revision)

> > If we index the PHY outputs in the same way as the DPLL subsystem will
> > see them in the references part it should be sufficient to make sense
> > out of them.
>=20
> What do you mean by indexing PHY outputs? Where are those indexed?

That's what ndo_get_rclk_range does. It returns allowed range of pins for a=
 given
netdev.
=20
> >> >> How do several drivers coordinate this numbering among themselves?
> >> >> Is there a core kernel authority that manages pin number
> >> >> de/allocations?
> >> >
> >> > I believe the goal is to create something similar to the ptp
> >> > subsystem. The driver will need to configure the relationship
> >> > during initialization and the OS will manage the indexes.
> >>
> >> Can you point at the index management code, please?
> >
> > Look for the ptp_clock_register function in the kernel - it owns the
> > registration of the ptp clock to the subsystem.
>=20
> But I'm talking about the SyncE code.

PHY pins are indexed as the driver wishes, as they are board specific.=20
You can index PHY pins 1,2,3 or 3,4,5 - whichever makes sense for=20
a given application, as they are local for a netdev.
I would suggest returning numbers that are tightly coupled to the EEC
when that's known to make guessing game easier, but that's not mandatory.

> >> >> >> Additionally, how would things like external GPSs or 1pps be
> >> >> >> modeled? I guess the driver would know about such interface, and
> >> >> >> would expose it as a "pin". When the GPS signal locks, the drive=
r
> >> >> >> starts reporting the pin in the RCLK set. Then it is possible to
> >> >> >> set up tracking of that pin.
> >> >> >
> >> >> > That won't be enabled before we get the DPLL subsystem ready.
> >> >>
> >> >> It might prove challenging to retrofit an existing netdev-centric
> >> >> interface into a more generic model. It would be better to model th=
is
> >> >> properly from day one, and OK, if we can carve out a subset of that
> >> >> model to implement now, and leave the rest for later, fine. But the
> >> >> current model does not strike me as having a natural migration path=
 to
> >> >> something more generic. E.g. reporting the EEC state through the
> >> >> interfaces attached to that EEC... like, that will have to stay, ev=
en at
> >> >> a time when it is superseded by a better interface.
> >> >
> >> > The recovered clock API will not change - only EEC_STATE is in
> >> > question. We can either redirect the call to the DPLL subsystem, or
> >> > just add the DPLL IDX Into that call and return it.
> >>
> >> It would be better to have a first-class DPLL object, however vestigia=
l,
> >> in the initial submission.
> >
> > As stated above - DPLL subsystem won't render EEC state useless.
>=20
> Of course not, the state is still important. But it will render the API
> useless, and worse, an extra baggage everyone needs to know about and
> support.
>=20
> >> > More advanced functionality will be grown organically, as I also hav=
e
> >> > a limited view of SyncE and am not expert on switches.
> >>
> >> We are growing it organically _right now_. I am strongly advocating an
> >> organic growth in the direction of a first-class DPLL object.
> >
> > If it helps - I can separate the PHY RCLK control patches and leave EEC=
 state
> > under review
>=20
> Not sure what you mean by that.

Commit RTM_GETRCLKSTATE and RTM_SETRCLKSTATE now, wait with=20
RTM_GETEECSTATE  till we clarify further direction of the DPLL subsystem
