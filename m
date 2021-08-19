Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326643F21BC
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 22:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhHSUmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 16:42:12 -0400
Received: from mail-oln040093003001.outbound.protection.outlook.com ([40.93.3.1]:47986
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230052AbhHSUmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 16:42:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6xIXscca/OMqPSecmdQIk1+FmjvLVummq/sV4ZaHhahS3YHYSdQNLYI0v34jK7Xl0la4fPNHH2BBkN+qgHmWmpxX7ZwhAzOxCWt9lsePviolYLjVMfeeidamPhMjKBoXQUYEipIFz1OhqKwUgoYLbZk9+pF8OwweAHNRgyU05dfxFqharRFX+wxKthQiHy1mRZx2aotLGsspnxkE2igbokXYllGQhsUtUCI+Mo/0RF6FMCh5Tenm2hPvHNX1sqqfd4rYpuj5U5ZMrEjEQobUgCfARPz6WdYuKbODNiWZmyfQaUtiv7egHpklq4hxSl3SSSGAVR/H5PuccMpg4vCHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAm79MXm905qeUaJ4tKA2r7Rcfx/V7ks7nCPlO0E8ak=;
 b=Tg07lEgqC0mE/mUc3J0Qo00qbNeSYQlhIh4CZQ/PJfqWT2hY9HNd7s69hpFxQME8OmdrFCgekM3mgue+fNGlC2T13k+qLdRsXuY8JrthUZ7oBz45CvPwUGkas38nPUWCTE9djhIYDAOKESpn6iccfH3cPpZWbuyhMm238sEsAdZ/MC9rXiWrw2ewyx8+FpS/2iReLtheJacqk4AFHVwYWQ203BnpvrHUoCG4SZq0RdTKT6E1wJDw6IHJqdXEfUd+fxJI3Xt7IULWgR25HRMP7e3XOqEnrUMCEkJrSiTCKGOPYYrrogJL0T+ZSqU5OVnZ4yqDjxLO9pm5TIiv3bW2NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAm79MXm905qeUaJ4tKA2r7Rcfx/V7ks7nCPlO0E8ak=;
 b=ibGG/Tne3rYgUdnqKHTwbKeH7SgoOV3rt7Ak+ZZxXkCgKV2HKu2zrCEUoUu3hEZr3xHLI8MeDQ7OzaKQ4j2yeTVbExmT+Ql57MM/CmlCrdPACjQY7K3wiLvxj4u/Sb/nsvcLQDstqn2WiVufQDFDSDNBIgLgD5UDzUBuJZzuVyY=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1207.namprd21.prod.outlook.com (2603:10b6:a03:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.4; Thu, 19 Aug
 2021 20:41:30 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::40bd:1fd1:f54b:e7b7]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::40bd:1fd1:f54b:e7b7%3]) with mapi id 15.20.4457.008; Thu, 19 Aug 2021
 20:41:30 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     'Thomas Gleixner' <tglx@linutronix.de>,
        'Saeed Mahameed' <saeed@kernel.org>,
        'Leon Romanovsky' <leon@kernel.org>
CC:     "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Topic: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Index: Add5D8Zto2s5ndNhQDWxYbgsDd9OBQABZMKwAPF1LOYAAFUOYABmTCiABX99UTAAMPOTAA==
Date:   Thu, 19 Aug 2021 20:41:29 +0000
Message-ID: <BYAPR21MB1270EEBECCA3E9630FA2214FBFC09@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
 <BYAPR21MB127099BADA8490B48910D3F1BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
 <YPPwel8mhaIdHP1y@unreal>
 <c61af64fd275b3a329bbad699de9db661e3cf082.camel@kernel.org>
 <BYAPR21MB127077DE03164CA31AE0B33DBFE19@BYAPR21MB1270.namprd21.prod.outlook.com>
 <87czrbpdty.ffs@nanos.tec.linutronix.de>
 <DM6PR21MB12752F080EEE916DACA9F8D6BFFF9@DM6PR21MB1275.namprd21.prod.outlook.com>
In-Reply-To: <DM6PR21MB12752F080EEE916DACA9F8D6BFFF9@DM6PR21MB1275.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5b3267b1-afd0-45b3-a0e7-36d6e2e236cd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-18T20:57:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89dfd108-9407-4bb7-a16c-08d96351b93a
x-ms-traffictypediagnostic: BYAPR21MB1207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR21MB120746C715935A561FFCF347BFC09@BYAPR21MB1207.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TDQcg9MsqcG3L8gky/2YNUkiQ0E8ynvdZFFjUpZWypR2oscSuD71ER9ceAXZE+ZZbP/1BkHebcY22teFIJaD5DsBo8oElYvCXQMsOj2kX55jWvaba6LFINN8BTrYyWceXg9txGVoxxSH2QfnEQ4j1frYIB0EQm4ivr6WWZsgEJMoYpm7RPu4d5xvMbR1q/SROoT1LCoIJ5u+psny9N6Po57POmhZRMWaOP7h5WSwkxAV17qNAZpbmC7naB2MKe1ggVftT3K/4zvHlUeAu6cr87/wy4jtDwGw8Ri3T91m3eN8+i586zOYk6DSiQgNfxDcksgKbCVfl5ohLzBZWnSltNi0p55HUClWH4lfqIhR7DmW1uyclChKzQfsiwcSRx0tpf6hrAwSGQlvpa/lXZ8rpM1P9sEN+rRBXvzwhSgTQ6nVDYf+7QGzv70ZGLTZuO1V6RSS4lSO10LHlR5pkqSsRqOnhxT5AAaMwHCeU9kVQ4ybmXJKLsA5pyHZsF2ioPQq+DCP1RhI+aOExYs06UPyN2YAEhftGLLNEAl8uJLMKDtPnPkRqzBf0M+ndMYaYL2DNURTX+3xKkGaMDKDS73hQ77U61E906lJaicFNgk4/3NBcjmC2Gck7kZ0loONM/lhBQN+X7063tOyOx/fp1ko4BmX+u8Lhb2H/FJrVZlpQAhcX3SFdypndTyhLBaHoSezbgWVNv+pCGg/NJHhv9tB9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(66446008)(64756008)(316002)(66476007)(55016002)(5660300002)(33656002)(66556008)(122000001)(38100700002)(66946007)(9686003)(52536014)(76116006)(8676002)(2906002)(7696005)(83380400001)(38070700005)(8936002)(6506007)(86362001)(4326008)(8990500004)(110136005)(54906003)(186003)(508600001)(82950400001)(82960400001)(10290500003)(71200400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oTtKaTtEDBErEgho5B0OMgg5uUscf7R8wYvlJEyJH2AXX/2gIOWPoxFyJ6jO?=
 =?us-ascii?Q?fdR0RRlKA+0E04umUtMDgdQGBzZs/FaJaEKWYcvutw073eFWu29nXL8P7V7e?=
 =?us-ascii?Q?nJxCJ6K1AFzqi6PuFz1rvAHysZXZ0exZWKdr5dXpPZDOXyx1I/JJW0Rt5ziL?=
 =?us-ascii?Q?J3/uW7/aGW7HeLm/m5jphZfCgLwApzJikUSQyOOEdPXZZU1u/6AjzqCx8Elj?=
 =?us-ascii?Q?lJyWp+wMpsGP4daapcBaKmrSbszgTOKC+W3wD0/+u8hAIqAaGHA9Wvns+4fS?=
 =?us-ascii?Q?EieCp3IduO0Qhfc5Gxr8q2dcNlfmrtg6462ZlbAOY0mBNOUwFPYHyg+TNg6a?=
 =?us-ascii?Q?2JxF7zqxIpETkqg1PEie7w3HPgCBy0WuUtyxjpeL6UewUE1OkzJefeia+J4b?=
 =?us-ascii?Q?QP/1Xuar0bloOosP9vvHrOIVRhH6nfqhSx3hcsAmCWXSNo6MT1OwslGnq3Ou?=
 =?us-ascii?Q?sqpX3f9hYiOzlxg1SsR5f1F13hgxUPgCJ+4QS5WzE3qgl0vZ6HaOqfVvHLb0?=
 =?us-ascii?Q?zKYKCS806PK0BkXcIF0lMyZLFRZuUSZqdXePdJGVQ7BIV+/o1P8jQ4/8P1Ky?=
 =?us-ascii?Q?Yxz7J1OO75hD7GaC72yUEymgPnT9m/M0/5hBcgFNEfSvsJ04RJhp3mGLDyvu?=
 =?us-ascii?Q?/zz+uAKQ9Nju4KCRzFpuPaHmlWNe7mr7Mdiv3JHP+btHcWDb4wOCU7TV+8aG?=
 =?us-ascii?Q?p0oas+h/j0ys0Sy/REorwW66DTvvS1BitZJf5sOV3tdju1Nm43rWj/YTpHX0?=
 =?us-ascii?Q?f9KGwG/EOmS9Mu8OqmYJ/zc1qzx+uwn32j9atduamw/ARNHXUP/lLrKq7LYq?=
 =?us-ascii?Q?dK4GB4RDtCsxRwgEOz24cGzpTdFGR01QkZ5TtU+csyg7G5H1g8GgBRRbOWr7?=
 =?us-ascii?Q?Bt3tlRIqLZb+JGKrcawx5gRpmu/6ViH0WjBpC4jihFKK1n1wiKIjP4m7lgti?=
 =?us-ascii?Q?F5I9XGx3bCCkVA31Lpxv+z4hbw6CMiS2JfVeyd1MLxX4wTCwm88rVcynmQc3?=
 =?us-ascii?Q?0y4H+jqOsr+dCi0+VUnhIqxzKenmNVrNsn3lMw05Bj4jCJ1KATgGx/ZVz3NA?=
 =?us-ascii?Q?dda+xQ7FXbCDf9XAK3JMSjrWGNnZ4BH43iZYpZmK8zZLHis+CjTTdggk0q3c?=
 =?us-ascii?Q?VuxmrSOPGWibFa0BzjJz9InOukFGLMbZX7tnyl5G+O5NbWTN21V4GrWnlZlH?=
 =?us-ascii?Q?i3HJXp9WuHBXOIXQpZlVqQeCJD9mM5XfSd7GkcY24ldoFN6Xqk8PyKBarotu?=
 =?us-ascii?Q?NN32Pmq8NyWY6nkXNNwsDqlvgYHHpeagb+jvuYvz2m5oOJW6C4BpWNNeQJ3l?=
 =?us-ascii?Q?dUF+/dXqxKpj41K9wRoj9zoB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89dfd108-9407-4bb7-a16c-08d96351b93a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 20:41:29.9834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CFu3KxvH7UNiYvxq+SFzJkNe8iOZdOcl/No1B76HO2zwffUPJGb/zqnn+v3yWLTsGn9KWJj9rKdUfZrkhovDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1207
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui
> Sent: Wednesday, August 18, 2021 2:08 PM
>=20
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Sent: Wednesday, July 21, 2021 2:17 PM
> > To: Dexuan Cui <decui@microsoft.com>; Saeed Mahameed
> >
> > On Mon, Jul 19 2021 at 20:33, Dexuan Cui wrote:
> > > This is a bare metal x86-64 host with Intel CPUs. Yes, I believe the
> > > issue is in the IOMMU Interrupt Remapping mechanism rather in the
> > > NIC driver. I just don't understand why bringing the CPUs online and
> > > offline can work around the issue. I'm trying to dump the IOMMU IR
> > > table entries to look for any error.
> >
> > can you please enable GENERIC_IRQ_DEBUGFS and provide the output of
> >
> > cat /sys/kernel/debug/irq/irqs/$THENICIRQS
> >
> > Thanks,
> >
> >         tglx
>=20
> Sorry for the late response! I checked the below sys file, and the output=
 is
> exactly the same in the good/bad cases -- in both cases, I use maxcpus=3D=
8;
> the only difference in the good case is that I online and then offline CP=
U 8~31:
> for i in `seq 8 31`;  do echo 1 >  /sys/devices/system/cpu/cpu$i/online; =
done
> for i in `seq 8 31`;  do echo 0 >  /sys/devices/system/cpu/cpu$i/online; =
done
>=20
> # cat /sys/kernel/debug/irq/irqs/209
> ...

I tried the kernel parameter "intremap=3Dnosid,no_x2apic_optout,nopost" but
it didn't help. Only "intremap=3Doff" can work round the no interrupt issue=
.

When the no interrupt issue happens, irq 209's effective_affinity_list is 5=
.
I modified modify_irte() to print the irte->low, irte->high, and I also pri=
nted
the irte_index for irq 209, and they were all normal to me, and they were
exactly the same in the bad case and the good case -- it looks like, with
"intremap=3Don maxcpus=3D8", MSI-X on CPU5 can't work for the NIC device
(MSI-X on CPU5 works for other devices like a NVMe controller) , and someho=
w
"onlining and then offlining CPU 8~31" can "fix" the issue, which is really=
 weird.

Thanks,
Dexuan
