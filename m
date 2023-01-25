Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1872867B381
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbjAYNgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbjAYNgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:36:39 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3BD589AB
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 05:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674653791; x=1706189791;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=lP4nk91lpW7nSh2/Aflxd9fsoBP1hjg0IvEtTUw2hfg=;
  b=b5/ohz6+SPnNKu1GF/XtdIan9tZ7kmYaWIfqzaOJAuZwa7ZE02w3STAT
   8I+SXBnhNsaeKxNRujOSA7URp/BTC1yxcsAg0DmOh172w+8jVPBiplOpY
   SDCwsSs+K16QPkiwctiv3sAr5Ae/kD1RM7SiH+LviWvNXySPBFch1PX5J
   QfA1Sc1ng7QDy6Xa0SJXWydUMCeZoyDkNykUvru2dBKxfQkQclKE9Meog
   pXJol7KKTTICC+FRwhpShICP8PyTopO9Khd8qRoRwVk0zuIg6R9iOQBQP
   wzBqEK9iiutfuob8d21OCfqKPm2bzI5XO/pkaUYGlv+GD4wjBCie3UFGv
   w==;
X-IronPort-AV: E=Sophos;i="5.97,245,1669046400"; 
   d="scan'208";a="333711219"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 21:36:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RR3LAJEcJF6rh4Aaq1LPrd//gdyLAH7z74u+i4gROdXNEDp6FZdyEarHcvOWFMAfhbddd4DXJ+81ql12GAjWG1uJXw2LOjyy06R1DvJxm5vnDr6mSrhii9BwDR27xmQb2S+VuloHjdQuLydKi0nfXxAbvgemNJCmVDG9qBM+awsxgz8PvELf0BslxkRaduSn712EvYeld1FcLmbMBFf3cRQzuwVFkxLjcRoR/9erA7uSuzqqtWFNjIKC3k/lUPTzGNmFKZWt4z46HSRVyn9d8Tm0alPxHahN78GCJVQYAUplsC7/0wHvTa6DBKONXfhhd5txcxSFgl0nbV/LeIh01Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXC7ax/m7VSOU8Bc3+B5FbBVpcEB+roa/0lNOmqXNOQ=;
 b=ge3fe7CDhYRIJZVUUACHgPp5eodRxAUDlIxHnOb/NSSAItv6dQlrbJpYrnQ14Ea3QcmvHiZXDcnJZszOD8VkFIoExqLh5L0Shn1DpNeXCRM2ofFIbSK3eMzGnDkHFRcomNMdDkMXqWjCh8ug0zH54qA3qBT973aHb8ubuga90Uw+djsbbFfHgpJfN5H2Jg+Kfyxv6HVcnC6BWmeWDHT6O67bqmShr29vnUHRPmtFadDbiKIj3Bo17t+Y4+zhBVJJUa0qBIBif5k12rNwhwSnhN/IAYAPC0JdQ7k7Xe+nSTt3A1NSRtOT57JRgmtboinMZbCTzIjsjvPbARMVmg/mHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXC7ax/m7VSOU8Bc3+B5FbBVpcEB+roa/0lNOmqXNOQ=;
 b=GiEthAy7XMw5HpYbM++KFyopqmtb0McTTCGbn1yiCRlEkzRZfD+7uOricfd7xclNg5XX8V7K8TjPHqr3bwLo1ksSpSXesXvFeb0VofW7U1oHACKALbJ1j5+i0C0rvB35wM9uI1Af7DyyOjgKd2Hn5qiP8rJgLGluV16fiOcGuxQ=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB7743.namprd04.prod.outlook.com (2603:10b6:a03:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 13:36:27 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 13:36:27 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: bnxt devl_assert_locked warning
Thread-Topic: bnxt devl_assert_locked warning
Thread-Index: AQHZMMIG30MaWxD2EUWJ/leu2DaiuQ==
Date:   Wed, 25 Jan 2023 13:36:27 +0000
Message-ID: <Y9EwWk7jn5+VATav@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB7743:EE_
x-ms-office365-filtering-correlation-id: 9db05a68-b876-4471-65ef-08dafed9292f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zmozvmlbp9orC3CvyeaCZqV6sKUG1VoR2nNIo/on6vPpY0hHWkrKL+ZhEYh3ytOJIJTESIl+1iWgW26pDeBeJiQwaVMJ7dLUsFIPSCWS0e+rQ2S0xyCvr6dSFEaceES2m6pa62Sr6pU1/40Sd03y+A2KdBenzTM0eV96AruyO5XB04T/iyIA/h9+AoyEnbWyDPqPhmEpIxtEmLSbwOZ/Wf55WwhrXBfjpNPm8lvA//tOu7gkm+CdZgUhSF3mTjZfZIepTs4Hv2xsmUXDZqFsO51PT9McgTJh4Ucau1LCznW/U0Rj5d5g9pqOBf5ol5fM63O6YPeQyaHywF7OJT6QQAhSSGBEpKUGGgXXgkvbPkjuwx/6l+7EO48N4iD1aEZODwavr91tUVeClxs2gyReP9iIZWvHgzsWusCdOnE0F1AHIcB9snJqIAm8mU6AgN3b9Db7u0DHyEAIi+Y/pT9QsnyEV16DiiJLs8A+nwyIooDunt/LMsjg4c4oRGjn2e31ht3wNm4r0EhTlQs9czVarFUkztUqeCo1IK8G4BNeT5exDlXy/h2LA1+3liYzeX5u3uuPh1+AuSQCP9hBON3bm6urkt7le8QeFS8PfvD5csgyGryrGq8kpuCdFlTqwtXohtb6IuItnyhySjdDOG9sPqrP+OUSQQKp9PrMyLi3i+c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(86362001)(66446008)(6916009)(7116003)(76116006)(66476007)(6486002)(8676002)(66556008)(66946007)(33716001)(38100700002)(122000001)(64756008)(54906003)(38070700005)(478600001)(316002)(83380400001)(9686003)(8936002)(6512007)(84970400001)(41300700001)(26005)(71200400001)(2906002)(91956017)(6506007)(5660300002)(4326008)(186003)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 4s8o7RjqWsvQy0T8A2+hOEthTZa3y9g3dvzwveJwhUuXBnr5EEwo627TzF+5+EgWfsjODpKzRqsMdNQAjEK03FDI+mj1a5W7Hj8ycYMKE+3kaQykItMxGzU9Ea+L3I69ug04NH3GY2QU1EETe8tJRsyIkdlMZzwcq5GB66AEVUCeYtNIRejVJY7bIPY+cqiFZz0427rEKj1JcNcmHJL71NKWtJbb4ACtJiVoH6BieOP39QDATV1jR62L1yOX5cO3HSB7RKNOeWZyU0+V/JzOLw9My+T1z0qqBkxRRnVH2Ih1HITy0OFZ2fvv3KE4ofK9Icw2H+rtzaBAKYNDpJMKf1iBVW0X+bWWmQnNaB8zXpFrE4H7ugklQk9VTLTy/WBRb2xBpZc40tuyfXbyaNevgU3LC7Z9xlePK3/k5aPZ3tw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12705331AE7E3E4E9194ACE84BDEA185@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uOp1NI+NtZI9RYvsDgR/zh4TJtMdiKP1mYmA5h01lIkHIUz2mWp33Al3nTfnzHLC/VQRNZU2USZVKql1+Mp5Q+RQJ6of6MtFopg/jpiZSiCvFW4kUHoymSefQnkAiUJjUCHqziLY9jK5mdBNsR7ImTJXqqGhclL13RUpLTZfknJLMC8jYvHKcnxgqSv53ImzZ3wZ3YXhyw0QK3WhjyPVnKs5leLYleVJA6u8/SH3qz+uPZg10c7O6mWGFWJRRNpBJm6GwPQ3AwJbXkc14tU8WjTqLwyHwo5SMr+vbkuHzDW1APapUvDMq94v+9LLSXpCBMcIx90pzihcipge7xm4HQasvmTke0/4EoGPMNZtefiTFn2tdivpibHpXPrbc/YPasNZKnHVUBdhp3tEO2U7/AqbYCp/kem4sCGIh31EwKmEbQYqbG2FJiAz+bGLqw+zgPU+4Vrr3aTSt2Gzqlg+iElXf++nzkrJJCUZnszjkhgAqMtrPyzwDjdayuNCBMlRi+USCFc4h7xsPOiTNzXXeWjBXnZhkdb7TSGrA3BQrmchkEKzhdx72uhJZwkUGSK4YmTiz+QdizV6qXJVqTcJ8QBXRl9eOsM/PEiJwORhx2GFIUWDBhCeFxjIRM3EE673Pn3UaSYQrkgzWCzd16dFxeT4svLREviG8umE0w2hBK7vMZYOmavdaJ8Uew40IGrbHg1NzedeHIBz16sOpDP2o6yhpfYMKgKuVXpYn5Fovxnyb2Jy+8l3ed+uk5oQ+sVNE9B63ELDmnwfi0nlpA6D6V9pqTxdMOsqVKcN0zPxouMhXO7oMRPFZryqFSVsAQ6lWxkhADHyi8uhvWTCtnPO6q5GAmudT39l7wfdkgEgOymfHMt3OURe4xnbZYKedUXX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db05a68-b876-4471-65ef-08dafed9292f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 13:36:27.8208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5d0xtOIRxKeQUNFGtlVlzd2iVOfk9+4/Er7P5xm7QLD2BkJ0+vTOuX2/fcyyP/TSft/aFQmyCea805zI0Mqzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7743
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello there,

When testing next-20230124 and next-20230125 I get a warning about devlink
lock not being held in the bnxt driver, at boot or when modprobing the driv=
er.
See trace below.

I haven't seen this when testing just 1-2 weeks ago, so I assume that somet=
hing
that went in recently caused this.

Searching lore.kernel.org/netdev shows that Jiri has done a lot of refactor=
ing
with regards to devlink locking recently, could that be related?


Kind regards,
Niklas


[71257.565758] WARNING: CPU: 27 PID: 87838 at net/devlink/core.c:39 devl_as=
sert_locked+0x58/0x70
[71257.580972] CPU: 27 PID: 87838 Comm: sh Kdump: loaded Tainted: G        =
W          6.2.0-rc5-next-20230124+ #134
[71257.592344] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.4 0=
4/14/2022
[71257.601028] RIP: 0010:devl_assert_locked+0x58/0x70
[71257.607009] Code: 04 84 d2 75 2d 8b 05 a3 99 31 02 85 c0 75 06 5b e9 6d =
7f 40 00 48 8d bb 18 02 00 00 be ff ff ff ff e8 bc 38 3d 00 85 c0 75 e5 <0f=
> 0b 5b e9 50 7f 40 00 48 c7 c7 6c 18 90 92 e8 a4 bc 5e fd eb c5
[71257.628221] RSP: 0018:ffffc900220ef758 EFLAGS: 00010246
[71257.634684] RAX: 0000000000000000 RBX: ffff8881cb6bd800 RCX: 00000000000=
00001
[71257.643070] RDX: 0000000000000000 RSI: ffffffff90cd0d20 RDI: ffffffff90f=
f34c0
[71257.651433] RBP: ffff8881f58e5740 R08: 0000000000000001 R09: ffffffff943=
47b47
[71257.659801] R10: fffffbfff2868f68 R11: 0000000000000004 R12: 00000000000=
00028
[71257.668153] R13: ffff8881cb6bd800 R14: 0000000000000005 R15: ffff8881cb6=
bd898
[71257.676510] FS:  00007efcff4be740(0000) GS:ffff889f8ef80000(0000) knlGS:=
0000000000000000
[71257.685847] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[71257.692838] CR2: 000055933adcc268 CR3: 0000000138c5a000 CR4: 00000000003=
50ee0
[71257.701236] Call Trace:
[71257.704900]  <TASK>
[71257.708199]  devlink_param_notify.constprop.0+0x1d/0x1f0
[71257.714742]  ? __kasan_kmalloc+0xa6/0xb0
[71257.719899]  devlink_param_register+0x358/0x630
[71257.725666]  devlink_params_register+0x3b/0xa0
[71257.731318]  bnxt_dl_register+0x37a/0x4e0
[71257.736532]  ? __pfx_bnxt_dl_register+0x10/0x10
[71257.742266]  ? bnxt_init_tc+0x959/0xae0
[71257.747287]  bnxt_init_one+0x18e2/0x3070
[71257.752382]  ? __pfx_bnxt_init_one+0x10/0x10
[71257.757828]  ? mark_held_locks+0x9e/0xe0
[71257.762901]  ? _raw_spin_unlock_irqrestore+0x30/0x60
[71257.769021]  ? lockdep_hardirqs_on+0x7d/0x100
[71257.774523]  ? _raw_spin_unlock_irqrestore+0x40/0x60
[71257.780628]  ? __pfx_bnxt_init_one+0x10/0x10
[71257.786033]  local_pci_probe+0xdb/0x170
[71257.790992]  pci_device_probe+0x46a/0x740
[71257.796115]  ? __pfx_pci_device_probe+0x10/0x10
[71257.801758]  ? kernfs_create_link+0x167/0x230
[71257.807211]  ? do_raw_spin_unlock+0x54/0x1f0
[71257.812598]  really_probe+0x1e3/0xa00
[71257.817365]  __driver_probe_device+0x18c/0x460
[71257.822919]  driver_probe_device+0x4a/0x120
[71257.828178]  __device_attach_driver+0x15e/0x270
[71257.833795]  ? __pfx___device_attach_driver+0x10/0x10
[71257.839919]  bus_for_each_drv+0x114/0x190
[71257.844994]  ? __pfx_bus_for_each_drv+0x10/0x10
[71257.850579]  ? lockdep_hardirqs_on+0x7d/0x100
[71257.855985]  ? _raw_spin_unlock_irqrestore+0x40/0x60
[71257.862030]  __device_attach+0x189/0x380
[71257.867007]  ? __pfx___device_attach+0x10/0x10
[71257.872496]  ? bus_find_device+0x13e/0x1a0
[71257.877624]  ? __pfx_bus_find_device+0x10/0x10
[71257.883081]  bus_rescan_devices_helper+0xca/0x1c0
[71257.888791]  drivers_probe_store+0x30/0x60
[71257.893857]  kernfs_fop_write_iter+0x359/0x530
[71257.899278]  vfs_write+0x51c/0xc70
[71257.903594]  ? __pfx_vfs_write+0x10/0x10
[71257.908416]  ? lock_is_held_type+0xe3/0x140
[71257.913483]  ? __fget_light+0x51/0x230
[71257.918118]  ksys_write+0xe7/0x1b0
[71257.922377]  ? __pfx_ksys_write+0x10/0x10
[71257.927278]  ? syscall_enter_from_user_mode+0x22/0xc0
[71257.933193]  ? lockdep_hardirqs_on+0x7d/0x100
[71257.938405]  do_syscall_64+0x5b/0x80
[71257.942802]  ? lock_is_held_type+0xe3/0x140
[71257.947813]  ? asm_exc_page_fault+0x22/0x30
[71257.952806]  ? lockdep_hardirqs_on+0x7d/0x100
[71257.957977]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[71257.963841] RIP: 0033:0x7efcff5bc284
[71257.968217] Code: 15 b1 7b 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb =
b7 0f 1f 00 f3 0f 1e fa 80 3d 7d 03 0e 00 00 74 13 b8 01 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24 18 48
[71257.988714] RSP: 002b:00007ffe85ebbb78 EFLAGS: 00000202 ORIG_RAX: 000000=
0000000001
[71257.997224] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007efcff5=
bc284
[71258.005275] RDX: 000000000000000d RSI: 000055933adcb260 RDI: 00000000000=
00001
[71258.013335] RBP: 000055933adcb260 R08: 0000000000001000 R09: 00000000000=
00000
[71258.021408] R10: 0000000000001000 R11: 0000000000000202 R12: 00000000000=
0000d
[71258.029473] R13: 00007efcff695780 R14: 000000000000000d R15: 00007efcff6=
90a00
[71258.037572]  </TASK>
[71258.040650] irq event stamp: 17759
[71258.044970] hardirqs last  enabled at (17773): [<ffffffff8d567cee>] __up=
_console_sem+0x5e/0x70
[71258.054551] hardirqs last disabled at (17786): [<ffffffff8d567cd3>] __up=
_console_sem+0x43/0x70
[71258.064119] softirqs last  enabled at (17712): [<ffffffff8d3d48fe>] __ir=
q_exit_rcu+0xfe/0x260
[71258.073613] softirqs last disabled at (17809): [<ffffffff8d3d48fe>] __ir=
q_exit_rcu+0xfe/0x260
[71258.083099] ---[ end trace 0000000000000000 ]---=
