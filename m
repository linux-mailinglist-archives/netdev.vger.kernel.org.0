Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049B23FAE5A
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 22:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhH2UMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 16:12:36 -0400
Received: from mail-oln040093008014.outbound.protection.outlook.com ([40.93.8.14]:16160
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231417AbhH2UMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 16:12:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWzua9hmq3Cpp03bevXQu8ro3AbJLA33Ynxe0hQK0j3CaZZ26VhgBZdAPRWbHBqhYBmURNqJet1nHq6apq0l/b+CUNsM5hwPuW3ody5uzzT6CrdI2N7X1AAhrY27sE1r7/g4ju1CqJa8elLmc2D9XgQfffMcrHD8keRODFfzqsIbE9Ze5mbBqJcIudbfn90D5Nr1mm/DMX7leGpEgKI5RKzaQxl5bHvaLMRhj2LzJ1jTWtvRDkR95Z5ddbADbMlWrMVyCBotzkf5hxL006AYMRrhfOobyrsELfQrAM0SpNeq9k0QmAGkN9vRmFOE86Y9UdG1q4FcyHZhChEIj1vU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IXslzTWoQ8j1nR686iBvZb/Tg+h6WIgINlJpKtYtOiI=;
 b=UvTAVNDX2+s0VSb1Pm3gl/lFTvBBK92cVG7ghPWJId2tprZObBNhonbvS2zb1uPK5NBrHCOavZ31JI7EVMez3ZvUuvQalIr/Jgf/G4ErXQdkGZxp1DCuxk9PnB3bPSYrfQok4G5epo8OGmHM78UjFxvW6YIW8LOZRSfEcZlMHC48x5bxWuXL2L9EsGi87c72iZWZcTE1HH8h47pt1OXDiHK8r1e/+1a7ctO2mZBg4OuWvUOYO8kG76/N0JwAATYLi1O5IxE0+1e6vI/7UOMvWvJDBS6HkcNhk2oO5lGK+nE3U6mEXr/PyUP9CjgIEQVblW4tZdOKA9Odzv3Jr/4a5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXslzTWoQ8j1nR686iBvZb/Tg+h6WIgINlJpKtYtOiI=;
 b=AvoHusi3ZXjSUSHiXSLc3LPAABAQtRGshpBkUzzN58ar+06Ds+jy6ESK5AjXk1bxC8Z9GoIqBWY7lAUFoNWYnIDiDnYcD0hTXoawgkcm9Pw33OtTOqM9XBSaE2OzbmSP5hqTbr5bDjZqmbB9k9B/cDql/AE+HoUAFTnCfEh+Eos=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1983.namprd21.prod.outlook.com (2603:10b6:a03:294::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.1; Sun, 29 Aug
 2021 20:11:34 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::d9dd:dc3b:2f98:7924]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::d9dd:dc3b:2f98:7924%9]) with mapi id 15.20.4500.001; Sun, 29 Aug 2021
 20:11:34 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        'Saeed Mahameed' <saeed@kernel.org>,
        'Leon Romanovsky' <leon@kernel.org>
CC:     "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Topic: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Index: AQHXnE12ky4fr+wgpUmMDouqUvT1gKuK4NhA
Date:   Sun, 29 Aug 2021 20:11:33 +0000
Message-ID: <BYAPR21MB12700177B1F53ACB01A92167BFCA9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <draft-87h7fa1m37.ffs@tglx> <87tuj9guzq.ffs@tglx>
In-Reply-To: <87tuj9guzq.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4ac00c27-cdb4-4515-9dde-ca726a6e33d8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-29T19:33:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32476127-2fc8-4fbf-137c-08d96b2932e2
x-ms-traffictypediagnostic: SJ0PR21MB1983:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR21MB198399687D51B82D63E1AF85BFCA9@SJ0PR21MB1983.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jMnnOBhEwNTdjBwy21j0P1xZL15YxuKrtSsJySrbBnyjKXfiOUzswyw0CbDmXLyc2nT56AIz/DIguWH0wGzK/5BLj2ZkVaeyaLNerLchFIRmI/1eNZFRctYA65RhH78As9ia36FwSC0b3f7Ye6Zf1b0G2+QZ7Xhy/qTjjAH2uirj9jFI8esV+6MokVdwvl9tfJm8C7QCrgfrQ2gqoST4IgsuBIomGqg7R/J5jA+L0QjINqARfA4BKvFLuCc/ahGUOgux0n1Xkm7HS4ODHqoCzwXRaFGpRWFHvxpFLNUpmK1aaX/O8C7uUmM1egxRqh7XjpazlBiT3nnFHA7SASmnI3dCF7MqacfABUumtvA6C+M8YMIp01j2nd85mHKiQWYReKlpIE/Nifs8XP1tNrNQfgkNpeMVBK2ZFmndiGiZRZXYESALk5gEqgE+M/9Ly2gNOIn6s+0M/KjHijNBiAV5pvtUm0Ul5rIklFHV2AFtCCMFIwYHmeNotlbxVzKcTzU+oJysVpTwAg51jXIKPb1WIyYkIf9gl+aW+B9pdfS9B3paIhX3fR3SOKvKCVxqtkwp8cfQYmlSgeGVpiowpW/YUr/ehzi9YFueSnMROk3LpEfkndO6NQAfaBUAlK0P0j56CKZ+K9+/YTYPPyw+g3+KgQ8hTbgVTCgw0SIL6CejWUzIEVNXc6lphBg4rBSXTt8FJiuhhMtLuo07TNRM7nKPIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(316002)(26005)(508600001)(6506007)(10290500003)(8936002)(38100700002)(82950400001)(8676002)(82960400001)(38070700005)(186003)(71200400001)(4326008)(76116006)(5660300002)(66476007)(66946007)(66446008)(83380400001)(66556008)(64756008)(86362001)(54906003)(33656002)(2906002)(110136005)(9686003)(8990500004)(7696005)(52536014)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o9C+y6jjbBu5wGX96O/Pj7VNCKHDfrllxoJZB8mWuQbEOJwIQxoE/BhidwPa?=
 =?us-ascii?Q?z02iJzxE5zXxMBbFTjLhkGELuqiSmGLEvWl+pFfInkrIw/nK+TkQYZYqjrdG?=
 =?us-ascii?Q?/Gjd9gerRZrmqDecoF36ibXv1NPCN3+/6rmD/kWoT4kk6jHP7fi7tRhj7UxS?=
 =?us-ascii?Q?X/pUBnOLUFjPSE7/ndQQhb4g19kAeW8uvSoJpQjPIHQtu3qgL7ICKnky9EUY?=
 =?us-ascii?Q?CJRqmUfDvBQAvPzHDm4+nB4qwHqa8nS3dReE+WzXsfgi3+iWl5RfcUjgJNLm?=
 =?us-ascii?Q?pfhg+7omoF8nfRYIjCk6LpFaEmZOo7EX2VYH3Hhnlpy/zrQEX78MlYHfl3Fu?=
 =?us-ascii?Q?rjwpqqbjXs79RZWnBiI7yB8hnr0NFmjpprL5o6wd/eV2jd74I1i5FTxRf4oi?=
 =?us-ascii?Q?spNIOlHjyVckusd0wO77kcJS5pOagqekJTkHzDAzzekomP/nZrYyYi2Wbg/E?=
 =?us-ascii?Q?bKRK7Z2mMlrTYWouCIYNmNa4eee94jk2h//PYGH9Iez6LfW8p8mqt6rqL59A?=
 =?us-ascii?Q?WEj7ceMTFeFCQ6d2YJa0InUA4PK9oy4X0ATkIXNTNHMiwj1dxszfy2ZaI5oC?=
 =?us-ascii?Q?7JHhd7B8E6gt+X+BvHDCRuJsfh+eIObmDCCSOVXiB9TgnkJNTW2PR3aFYOQe?=
 =?us-ascii?Q?c2PattxRy1kNuPuYFO5G6T+P51SqN1CnW6gyBLejHSRiTbIoS5aVIWIcq9BK?=
 =?us-ascii?Q?PU7NVPTR5lpvp9t+bqVeprODjlxgzWn/x/z6YrEpohM5I6HbI1tG0WmoZbIM?=
 =?us-ascii?Q?BlYF5ARzPRnpCoF8nV0YmqbXX2YxpAt6nr4FzRhyUqSnBnk+ED2cGThkRbvt?=
 =?us-ascii?Q?2x9ezJuYp9r9skOOXHZ73ppVoCHgFoOcVIh1dAuRBJxU8QBvrbDmV+GbEaTw?=
 =?us-ascii?Q?6SXtkyuU1MdMJO/fp/pHHpEKFWehwxQZJqZb4Ug5V4GlkrZfs/otZiZOqft7?=
 =?us-ascii?Q?xDk+uf/dA8dJbVDHBRdViSAKj6Bbvv8n+POhIE6tE4C34v725rKFOSo68y1r?=
 =?us-ascii?Q?/La2ppdLQb8mjCIzp27wRG6ehwiq119Hn/MDCQFOuE2OtRPlI1Vx0qwZBKZC?=
 =?us-ascii?Q?OmEe71JO5Zi/4tHp0vFPbhOEpo9hVGNsZEFwkXRY6zuE3YP2WcWRMFtPXVnu?=
 =?us-ascii?Q?6v7cU9ZT8ImHwYTNALb5/eBgt+JatAxc54qiUnUl+ScjzLkyx3p0VrEyKOh7?=
 =?us-ascii?Q?2qAFW/jcs/T3CJn/tbyb6fFpcuPqgaoan86pf76ZN05IshoyngjiCy6SVgYl?=
 =?us-ascii?Q?8rFRiwslsIFiah6YNdO2jD5950qQYwVcoyko6dmuF34my6OCpg7pNQBEvUrC?=
 =?us-ascii?Q?S8WY9oZxYv5jB4rge8hdwCAj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32476127-2fc8-4fbf-137c-08d96b2932e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2021 20:11:34.0304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OdcNhMZgr6thUPuz7iKpijxCrGSLuMP6UEaQh7KlmJwUpSCLH1Nlu3MPNCdfTB7xsHHBW9maJaodt1Guu69tzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1983
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Saturday, August 28, 2021 1:44 PM
> >> I tried the kernel parameter "intremap=3Dnosid,no_x2apic_optout,nopost=
"
> but
> >> it didn't help. Only "intremap=3Doff" can work round the no interrupt =
issue.
> >>
> >> When the no interrupt issue happens, irq 209's effective_affinity_list=
 is 5.
> >> I modified modify_irte() to print the irte->low, irte->high, and I als=
o printed
> >> the irte_index for irq 209, and they were all normal to me, and they w=
ere
> >> exactly the same in the bad case and the good case -- it looks like, w=
ith
> >> "intremap=3Don maxcpus=3D8", MSI-X on CPU5 can't work for the NIC devi=
ce
> >> (MSI-X on CPU5 works for other devices like a NVMe controller) , and
> somehow
> >> "onlining and then offlining CPU 8~31" can "fix" the issue, which is r=
eally
> weird.
>=20
> Just for the record: maxcpus=3DN is a dangerous boot option as it leaves
> the non brought up CPUs in a state where they can be hit by MCE
> broadcasting without being able to act on it. Which means you're
> operating the system out of spec.

I didn't know about this. Thanks for the reply!=20

> According to your debug output the interrupt in question belongs to the
> INTEL-IR-3 interrupt domain, which means it hangs of IOMMU3, aka DMAR
> unit 3.
>
> To which DMAR/remap unit are the other unaffected devices connected to?
>=20
>         tglx

With maxcpus=3D8, on CPU 5, the NIC receives no interrupt, but a NVMe
interrupt ("INTEL-IR-6") on the CPU works, and two "IOAT" interrupts=20
("INTEL-IR-7") also work.

Except the NIC, the only IRQs connected to the faulty IOMMU3 are
irq33 and irq34:

root@lsg-gen7-a:~# cat /sys/kernel/debug/irq/irqs/33
handler:  handle_fasteoi_irq
device:   (null)
status:   0x00004100
istate:   0x00000000
ddepth:   1
wdepth:   0
dstate:   0x3503a000
            IRQD_LEVEL
            IRQD_IRQ_DISABLED
            IRQD_IRQ_MASKED
            IRQD_SINGLE_TARGET
            IRQD_MOVE_PCNTXT
            IRQD_AFFINITY_ON_ACTIVATE
            IRQD_CAN_RESERVE
            IRQD_HANDLE_ENFORCE_IRQCTX
node:     1
affinity: 0-103
effectiv: 0
pending:
domain:  IO-APIC-18
 hwirq:   0x0
 chip:    IR-IO-APIC
  flags:   0x10
             IRQCHIP_SKIP_SET_WAKE
 parent:
    domain:  INTEL-IR-3
     hwirq:   0x0
     chip:    INTEL-IR
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0x21
         chip:    APIC
          flags:   0x0
         Vector:     0
         Target:     0
         move_in_progress: 0
         is_managed:       0
         can_reserve:      1
         has_reserved:     1
         cleanup_pending:  0

root@lsg-gen7-a:~# cat /sys/kernel/debug/irq/irqs/34
handler:  handle_edge_irq
device:   0000:d7:00.0
status:   0x00004000
istate:   0x00000000
ddepth:   0
wdepth:   0
dstate:   0x37408200
            IRQD_ACTIVATED
            IRQD_IRQ_STARTED
            IRQD_SINGLE_TARGET
            IRQD_MOVE_PCNTXT
            IRQD_AFFINITY_ON_ACTIVATE
            IRQD_CAN_RESERVE
            IRQD_DEFAULT_TRIGGER_SET
            IRQD_HANDLE_ENFORCE_IRQCTX
node:     1
affinity: 0-7
effectiv: 1
pending:
domain:  INTEL-IR-MSI-3-3
 hwirq:   0x6b80000
 chip:    IR-PCI-MSI
  flags:   0x30
             IRQCHIP_SKIP_SET_WAKE
             IRQCHIP_ONESHOT_SAFE
 parent:
    domain:  INTEL-IR-3
     hwirq:   0x10000
     chip:    INTEL-IR
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0x22
         chip:    APIC
          flags:   0x0
         Vector:    34
         Target:     1
         move_in_progress: 0
         is_managed:       0
         can_reserve:      1
         has_reserved:     0
         cleanup_pending:  0

root@lsg-gen7-a:~# lspci |grep d7:00.0
d7:00.0 PCI bridge: Intel Corporation Sky Lake-E PCI Express Root Port A (r=
ev 07)

irq 33 doesn't appear in /proc/interupts.
irq 34 in /proc/interupts also receives no interrupts.

So it looks like IOMMU3 is somehow not working at all
with maxcpus=3D8. "onlining and offlining CPU 8~31" can
somehow "fix" it. :-) I'm not sure if this is a kernel issue
or firmware issue.

Thanks,
Dexuan
