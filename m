Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E450E3F0D21
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 23:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhHRVI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 17:08:56 -0400
Received: from mail-oln040093003010.outbound.protection.outlook.com ([40.93.3.10]:42582
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229965AbhHRVIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 17:08:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQVDBKUBUtG1JdUN6UiS+9gFJj289KVWeJZWet5PSEuaT/g2ubDr+4j+XSOeXHd/43bBAN2Lk5Yg2rBd8QK7pdGSoVhim8iCQw3YxdrZQBKMeTDEFQHHLNsB1jlXBmMAcHuKzxFpoX/u8p+sbPyvz7yRG9SV6/L1ZL2bcJWVFgB/EHrNhvMExGhU0M1JNTXZkToBlI6y4VmFRmph0wrNkqBKg0OuulEqcNTnO4xR09lnKx4Lxgyar0keKx7PngwzQEKZ7il6I0HUsL30e3vC0BFwb9R4Xcpee2JiZBJhDwkMyCD1EkZgHYzrO1sdYzIh+iHFh+VY4sc00dpvvdNDgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tbseaehl9kCfv3D2mVRUrF2JkD4V+Sa/utKDc0mtYIY=;
 b=jdsL8VwQEK7TUC8rvRwa9UBFZe0WaEQrcIpzNSkdj82cTubcrkDcztUHjxfM9GUlOfmvA8rEKEMPo8VxXbNxvKvCHCj0ytSKnqgpiaGJsuHdougp551DuJBuox81NuxxGcr9kMsESaKCTE3CnxXA3ohPq8Wue40FkB+T1cz64nUirxrwblYH3Id6LFP5XMid8TKZgUss2wW8H1njpTnb5NLRwbYoOkZYAzrLEs51iYzhrUrTW5AHj9jV9MEnUuucmP8x8RJbirtRoTDa50X5/9zkVJaZN1qCJfbVLVxXzUqU/NoGYeotA1Ie37tEL9xlPwtL8rf8VF2C0JPhSjWDwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tbseaehl9kCfv3D2mVRUrF2JkD4V+Sa/utKDc0mtYIY=;
 b=E5VNjjIqPdrO31ntD9OFslY5QpwPFMeVU5v4duAji8XUmAjnYQ3lfVjuorfmrodPTBwBPLWtvY+oq5ykOqOUPJw4OfqFHHgMwgCayc63mPkLN3XCbvpqGAaE8M4onzQ0Kh602val+MtIBlPdGLzvZJGjIFwmBVkM4rnVb3WdWNM=
Received: from DM6PR21MB1275.namprd21.prod.outlook.com (2603:10b6:5:16c::29)
 by DM6PR21MB1337.namprd21.prod.outlook.com (2603:10b6:5:175::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.5; Wed, 18 Aug
 2021 21:08:14 +0000
Received: from DM6PR21MB1275.namprd21.prod.outlook.com
 ([fe80::45d:4c1b:beb9:590b]) by DM6PR21MB1275.namprd21.prod.outlook.com
 ([fe80::45d:4c1b:beb9:590b%3]) with mapi id 15.20.4436.011; Wed, 18 Aug 2021
 21:08:14 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Topic: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
Thread-Index: Add5D8Zto2s5ndNhQDWxYbgsDd9OBQABZMKwAPF1LOYAAFUOYABmTCiABX99UTA=
Date:   Wed, 18 Aug 2021 21:08:14 +0000
Message-ID: <DM6PR21MB12752F080EEE916DACA9F8D6BFFF9@DM6PR21MB1275.namprd21.prod.outlook.com>
References: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
 <BYAPR21MB127099BADA8490B48910D3F1BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
 <YPPwel8mhaIdHP1y@unreal>
 <c61af64fd275b3a329bbad699de9db661e3cf082.camel@kernel.org>
 <BYAPR21MB127077DE03164CA31AE0B33DBFE19@BYAPR21MB1270.namprd21.prod.outlook.com>
 <87czrbpdty.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87czrbpdty.ffs@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5b3267b1-afd0-45b3-a0e7-36d6e2e236cd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-18T20:57:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61b74f20-3ab9-4708-d295-08d9628c4b11
x-ms-traffictypediagnostic: DM6PR21MB1337:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1337B0B6F399DD264DFB9E87BFFF9@DM6PR21MB1337.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jbRWanyRcLYegnQ6fcq+9D9yl8jnh4W8I2nt41jrBt+pasYrZmAudK9ouUf5/suAkerC13rqQ01DB9oi3yQo/QCvX8/n5TEfx1dY1oDYrs4e7+wutmMU5xHQE4krcEiyXBGlrKQh87tKbcGhh14A3v3SN8W2Ve3iJEHVUP/9P7sSewagwQM3Il2i1ANHUmnKLLGWjRpxrknQ/VSR3Fm0YEbjJRK9xU7TIfko/dk5dX/ZwxTTEIqItzpbvfx+3it09E9I20Xk7ePn+YB8UtjTYB/D0OmZffvJ2NgbYDCMO7/6CbznpNM03Q2CyMBgU+PKOyDzhGKf1nCuCC7ndyy11j9wA/VOtw0axBK6ubEa5IHxF3pQ4Pg8248nJPDwvCeRJ9z4FE3IbOSzlJekY42jT2fUXIrkxMh+qaSgSApnNmWsQc2HxmW6zyQ7UgDacWxGqlKiN/pOWz/m3rtXAnFnB4Y2i6w7qZzbLlL+KA9pqMVmbOLVfEHhrL6cT2BhqbIUZPAI0OUSSmlzX57mf3w309UqYEA24sFveCWZrJOjQ5MlRgygA9ZQWxNCc1M1+q6/zEqCEgMfVRkFYFz3NGQEGtULdmVvTeC1d92M8N8ToUMTM/arO6b4qj1UBa9mHCnnGMxTJQXmMVKT6GV2wVPYKA18pSG7sSB9QY2+EkJOjrZQJk9z836W12TyXAo8Vaxq/unRKSNBJXOr392aGduFtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1275.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(26005)(10290500003)(508600001)(71200400001)(54906003)(52536014)(110136005)(4326008)(186003)(316002)(55016002)(8936002)(53546011)(86362001)(6506007)(66476007)(8676002)(66946007)(7696005)(2906002)(66556008)(64756008)(66446008)(83380400001)(76116006)(8990500004)(82960400001)(82950400001)(122000001)(33656002)(5660300002)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9qlVJ7Iw3f4FXMpYuw3xDCpkM0pCWpk58LhzqqK3/MZktnRN7r4quT871sK6?=
 =?us-ascii?Q?237sdr5ul+vXMnFWjY2fwqiI1lmFDl0YSqYVnwvc3wyMGqJ6Zx78O2YsYUfB?=
 =?us-ascii?Q?lR8VG87OQXmjYc3jlAMIUnlIE5BSuOzHRzsF6CSBJZHkBbpBgioMIVWVx6PN?=
 =?us-ascii?Q?dMPIvHsZcceWdRkqfixsswBgG2DMXQgtugyuNwA6k/uPnq1Wbt6ZyBWQxVJ6?=
 =?us-ascii?Q?j37RWQjSjHB9/Vyi/EHQS5GwXwyumKUUyTAgzeemNikNlLdZgWEJ/qfnXsFz?=
 =?us-ascii?Q?Y+1QQzgfxKqpmJ7+3oQJOoFWXk1Qsl2Yz2yitH4dotoVUfwdoS5A158ZK6cV?=
 =?us-ascii?Q?kuNxOqd4AC1KR62C3GXp9RtUy8VfM4EPCabKniTHQAvDaByZ+U9hUbY+PeFN?=
 =?us-ascii?Q?0VPZeKv1eY+TvpcwRlbSORcX3mgXEMkHucGV5kamiM/UMTkezc315UdZSqxt?=
 =?us-ascii?Q?USDKj/eLvOmRI6wMsy3g5ANDwgevSN4ZBJIIDwhSNiSTx8sQu4KIRuTY0Cru?=
 =?us-ascii?Q?rPS/ewSl6il8pALhlhxP6k5U+wbAvmWaETPzLKhKQp2IeSrHnNJ3wZ0sPFva?=
 =?us-ascii?Q?bxud/2XELls3Whi6LJ1RTR67le+MqRgIDQSkkiv1voFfYrf6CTcreL+//4tx?=
 =?us-ascii?Q?faDir2cLEe1JBmDnwUAIPhvsH6cebmYK4GNm+piqfv4UHJt9m6JZovHkLazC?=
 =?us-ascii?Q?wA7wpybJMM/zu/HkhLoZPaaUinqxw5SmjKVXf/djT/gZzjkPPArLi1CVLnDs?=
 =?us-ascii?Q?valXZkYrN4xLWyqWXkQL3ccZMEzUO1IoEXLp7ln81TO3cC9gKujvArzKOJQ3?=
 =?us-ascii?Q?+FqP6Y3wYDp5h7dMMnRq+brDLCkVuY53iZmR4ZM09AIH6OL1CV1p1s3YKS0t?=
 =?us-ascii?Q?qnVqvaZQIrw7tJPgFzV6xVaL4G0f6As+O5csFR57ElzIvyOonh5IN9tRpaYv?=
 =?us-ascii?Q?XV3xiENDJ0nj1zGlZ3GGMOBMJUCMNpz+R4tbm738uH8JYhDN3j0xcpzDbpHm?=
 =?us-ascii?Q?uOFfH32MkWxG5sQ7v3eYr2EtGg1GrjBZ1tIIjES9MPfy/yhlLif2PlJncKck?=
 =?us-ascii?Q?T2G/L9gasQucgnM0tk1QrpecVzx/wy98wLRhqK10OodrLGXi4WUvW2I5BrZU?=
 =?us-ascii?Q?R7/H7BTcxHi9uI+e2DQbZrLDASyriMtqboZH9Bm1XPauRp3ww0kUBPE0R8bT?=
 =?us-ascii?Q?FS3lanZhuhslQaNLnTQaW4hQbyeUP1VfSWAbO6OKM1XxuXd3B5eyfX20a0Ki?=
 =?us-ascii?Q?z5t7yOBhaNfcrM6ofim5cvT399QKnk6pge3PuDKlACRU80bt/vgp2awu4A3L?=
 =?us-ascii?Q?asvvDDNfN53C9+xMvf/19AYK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1275.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b74f20-3ab9-4708-d295-08d9628c4b11
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 21:08:14.2829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lMpf4wSWffN++XWwZ3yBpU/vLFEakM4CMZqBBs31kw3zEqwyyb9vTpStYhk9TBBtcjXQDbkUeahL68CbuHlFJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Wednesday, July 21, 2021 2:17 PM
> To: Dexuan Cui <decui@microsoft.com>; Saeed Mahameed
>=20
> On Mon, Jul 19 2021 at 20:33, Dexuan Cui wrote:
> > This is a bare metal x86-64 host with Intel CPUs. Yes, I believe the
> > issue is in the IOMMU Interrupt Remapping mechanism rather in the
> > NIC driver. I just don't understand why bringing the CPUs online and
> > offline can work around the issue. I'm trying to dump the IOMMU IR
> > table entries to look for any error.
>=20
> can you please enable GENERIC_IRQ_DEBUGFS and provide the output of
>=20
> cat /sys/kernel/debug/irq/irqs/$THENICIRQS
>=20
> Thanks,
>=20
>         tglx

Sorry for the late response! I checked the below sys file, and the output i=
s
exactly the same in the good/bad cases -- in both cases, I use maxcpus=3D8;
the only difference in the good case is that I online and then offline CPU =
8~31:
for i in `seq 8 31`;  do echo 1 >  /sys/devices/system/cpu/cpu$i/online; do=
ne
for i in `seq 8 31`;  do echo 0 >  /sys/devices/system/cpu/cpu$i/online; do=
ne

# cat /sys/kernel/debug/irq/irqs/209
handler:  handle_edge_irq
device:   0000:d8:00.0
status:   0x00004000
istate:   0x00000000
ddepth:   0
wdepth:   0
dstate:   0x35409200
            IRQD_ACTIVATED
            IRQD_IRQ_STARTED
            IRQD_SINGLE_TARGET
            IRQD_MOVE_PCNTXT
            IRQD_AFFINITY_SET
            IRQD_AFFINITY_ON_ACTIVATE
            IRQD_CAN_RESERVE
            IRQD_HANDLE_ENFORCE_IRQCTX
node:     1
affinity: 0-7
effectiv: 5
pending:
domain:  INTEL-IR-MSI-3-3
 hwirq:   0x6c00000
 chip:    IR-PCI-MSI
  flags:   0x30
             IRQCHIP_SKIP_SET_WAKE
             IRQCHIP_ONESHOT_SAFE
 parent:
    domain:  INTEL-IR-3
     hwirq:   0x20000
     chip:    INTEL-IR
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0xd1
         chip:    APIC
          flags:   0x0
         Vector:    42
         Target:     5
         move_in_progress: 0
         is_managed:       0
         can_reserve:      1
         has_reserved:     0
         cleanup_pending:  0

Thanks,
Dexuan
