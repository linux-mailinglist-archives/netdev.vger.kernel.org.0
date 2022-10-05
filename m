Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480205F4CF8
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJEAQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJEAQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:16:49 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020021.outbound.protection.outlook.com [40.93.198.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14986F249;
        Tue,  4 Oct 2022 17:16:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzXJrQZ7Da8nXoo3ADcvcP7NaAxaAm2Cdp/HtL01P3WX5Jq1m1LRPncW69+QjfaQ8tDO+ce0o3lEq0pgxEJUR6j5sCOWEyJraMN/ItgDguZJ1fKvBT3kn+9K20sNJL6tKO1w3GyZuFkH//H1VCpUPtKrLEhpKoUzEPDg5C+CTYysCxSV0WxahUiyFaspLfzO/RsjiODSvDXc7sM8MRiqSCBG5gz3KIL28hI4h1A5zdcLKfEPZsstj0Ichb4h0orl7NrRqa+BdRJng08iTdOwBtuWvY7d8fXVtXb3o1rpNmHQthY25DvE5JGZUIa5kNYbpy9uR3zxb9i9KSsUkKO9CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dVXS7mvTIjC41+0EZpKR6C688QSVGBINM8QrDkE7fTI=;
 b=VKklvPIqjiNR6IVyvIx7HAi9tuKegG9My0EXL/NWDBoFdeNO/x+EI3s6Wr7TQLQ2vpAvEUw/NfZmFOEakrrpbKsn+4WL7pNhla7GLBt1y/PmGlK5cuBIg1eIt8PB5fyR7TmaQL5qJ4K1jM7Gncl0NlAPz1nAkQ8xoc7bS5zaDD5qqiG2jZmJbY/abcYTq232y0Ttf1F+vQQ+YK8387zzmFLiI4gLxkH3l1sWbVBV0SHtIF7JY9EwpuE6RFytPF1U7klMES8V3+dG2lJs1m7vGIFhJ6LsJvKp8Es9KQCFCRGsB3/2TK2ueql0zGvoS9cOJGA7qTnf99yfDO8t83kD6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVXS7mvTIjC41+0EZpKR6C688QSVGBINM8QrDkE7fTI=;
 b=R+OFPHV3HqXbPXsjAk/XFOj30O6XLmZ/roobByia3gDLP/UNvtHqU6iuXs1D7BL5oYoQpQIypZQb9XU2NwZHN4INQYy98Fux86SfA+qeZJP7YFePAgS0gVPNYB7SskX7+jKWQGRdIjr3Eu5Z1rBSD28Qy6V4S74p/2rUCVARSVk=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by SJ1PR21MB3529.namprd21.prod.outlook.com (2603:10b6:a03:453::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.7; Wed, 5 Oct
 2022 00:16:46 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::f37:a401:d104:7fe]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::f37:a401:d104:7fe%7]) with mapi id 15.20.5723.008; Wed, 5 Oct 2022
 00:16:46 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Avihai Horon <avihaih@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gavi Teitz <gavi@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        Long Li <longli@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: mlx5_init_fc_stats() hits OOM due to memory fragmentation?
Thread-Topic: mlx5_init_fc_stats() hits OOM due to memory fragmentation?
Thread-Index: AdjYTuisHoBneYtURaipjhj2oD9KAg==
Date:   Wed, 5 Oct 2022 00:16:46 +0000
Message-ID: <SA1PR21MB133523FF1DC8DC92FD281EB6BF5D9@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=97fec1f9-fe86-47c0-ad09-876410ba7fba;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-05T00:05:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|SJ1PR21MB3529:EE_
x-ms-office365-filtering-correlation-id: b51d12e2-f021-493c-91fb-08daa666e3d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jH5KvStWRGgBfckjjro90GqDTqHoIgWCMTHuon5D71CcqSEvQm7PASpNkAVb6Vi1uv0Fs+kwOVjrjdTabjiEaRn3YF2A0t5L9tLuGCulyTZ6227BYIf4Dn084HH7xbhk3VE7DfzH4wBJd7PwwKL+zzUcdt6m22+1bvj/D7Ejrllx8GxNm1kZrbJnwe7ji0LyDhneqMKdWOScXi4Hmls2neXzsN4rpFPXp2nr/zwqAdFaeARwK6gQ/IgUF8hbG5uwUC5WGCDKOtUBsMEtFQ2AYmR8iQ7JI5ufF43t4XbydoB5+oe2AHrrcv86ygukWrueD2rEWo48/gscPwWkNYmCjkOhXxkpPlsds086jQSTehS6IMuPhswUt5vRb29etoy9D9k+RoxAukofIjK+wfFDKuLZAt3VsxBKAFV8ysEp8e6IgThllWF0wrw460MHPX/ZFytVRXyZjKfCLoD2HNmLUx99EVzenV/FPyJB30hDGi8w4yjk0XODTyzSgcKZU3n+FmHY3hlkXXxGunoa+A5ZKRZ+1NKWa3BJSwUUknVryPmeiMlkkfrLI4hQxPFbO+IUseM13+QtvVhFYnK5xeIQTSfPulkVIJcZ3k8GgH3dzVcp0nf0L961E2ESjk4Kr+/LaUwEnE5XSALH0QHNhjY9v6QhdsEhz/U+u/puf8lTU2PdNFCnInWmqlLpzuYoBhFkeDSi/+Cg6erAmnZfulA2ilhqvKZJFE7O5C+Ake6xxZjRb9f4zUwAOBGIMtgA/48ZBw+SrEX1awXQxu63o1AQyub4QihZcmbasdWrvScidGaQHwIGi+/UWpHmZG/AS4Qg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199015)(66556008)(66446008)(54906003)(8676002)(66476007)(10290500003)(316002)(7696005)(9686003)(110136005)(26005)(4326008)(478600001)(76116006)(71200400001)(55016003)(122000001)(6506007)(82960400001)(38100700002)(64756008)(86362001)(82950400001)(186003)(38070700005)(33656002)(66946007)(83380400001)(8990500004)(52536014)(8936002)(41300700001)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vtMVFksyMRsPX1PJjK640QDPe+63+A8GgpylIMm55c0S3kul77sR6jigBld8?=
 =?us-ascii?Q?pzs/I/86BmNV5pDBzZINebK6qUcBCG9w18BizEzFxpQF/cVYV2iY5yzG0NLm?=
 =?us-ascii?Q?O/vsxsCgt0CDTr4bXd3b4VMFt45/+VwZ1RssiJiEtakH3Q5Bt8Bb/nNNk7es?=
 =?us-ascii?Q?3NLkG0fkM53jPEm/aRV8qUa/6HQxOm4jeAeeD+LvIBZ0UsnMEeJUxa0oEEt3?=
 =?us-ascii?Q?vV4p7qwfn6X5dGk5jCsaWWZvGHfPXwVftZkral7+p4STNRovn2V0rk8hM7/X?=
 =?us-ascii?Q?fon2alE9Bh/td5HXqEsKdge5M/PUJrYrwaiTroT2ljIGWemIhF55RKQf5Y2U?=
 =?us-ascii?Q?2xbah552iepHtFCL26yHoKLgiNm27keD8GKusqdekSwS8y3kyd/5WscBEAW6?=
 =?us-ascii?Q?b0K2wLJQT+tz8Oy5tK2wwUFHufFGuyGdqdl5xF0q6MPdjzAVfYBrOSG4fE1u?=
 =?us-ascii?Q?jMimGPNwPXoHOnQO1cwOBWlX+tn/aK6OjaRM9aPLR5djn2O9MMlitiayfNOB?=
 =?us-ascii?Q?1++qB8erbnJcGhguGabgoBnMNvNC2H6fkx5RKo2YSKlrgr/MkhrJ8ccLFsQs?=
 =?us-ascii?Q?IIPpHMNP2/v17oe47q9yH7rSY9TktI/YScba9m5KRYC3hBi7hr/LdpgeeP02?=
 =?us-ascii?Q?ioh/6tY1YW1d8Br8ULL2OLPzAF4IOMsrHrY/AyBpgLo+X6nbFOKFGb80ZjCs?=
 =?us-ascii?Q?dMMuc86phVEIdt6gONF2W74hTixnkpA77+qmVv8zpW7d9K8qGfHqiVRK4U1f?=
 =?us-ascii?Q?VNk9uYvWSZXfcoJu/x7smPe8sL3Y7ptKVgip6MPPRMCrjU5zF4jtRrroeFs8?=
 =?us-ascii?Q?IITz2/AlNnc5vIJy0xUMMo8ioanMSCtxRFE6Fxpm9bxxDq24PtA4jNANgtuA?=
 =?us-ascii?Q?CW3oQsMMXwT2tnnOCmaLsw/ZfdTq8o8hJv2cpa4hvCYEXMOuz4oVACVOoClB?=
 =?us-ascii?Q?VDhkFF+0jJGDlsHYmcPmyrAaFZitWWq3Ld3NWTjGqkpGHSQizZUO4JPcEgSv?=
 =?us-ascii?Q?g/ViKQRO/Xsubazijsjg0RaljC/3AK0A/osKtZlCYv3iJnGFKJlS8ww0Jwxz?=
 =?us-ascii?Q?xSaof7ndnI3+zQVAuDyd45dRP3bQT0kDDGRRxNyfrqlyO8qX/kH5GXbS9/rI?=
 =?us-ascii?Q?y22mJYSnH9A5hiosYYpdMKr/iflkjT9K40PM8EQihQ9gsvQJwMKeExzLdtlS?=
 =?us-ascii?Q?trWCeQD8kESiQ3ZVtWvOIYkjIITHeltZsSkpbie1r4Y1ZMi30ejhBOgdg8Pv?=
 =?us-ascii?Q?Kvana7G5pxREXCBg4AbC4ln40UFfLpo1ej1OXAcM2LAtQs+e5T04YhSJifHI?=
 =?us-ascii?Q?e77QoIK+8mLrGfYrii7B1r7PfsdOV9MzqkTcmwJEvhBu5rb0TePIoE7Zfse8?=
 =?us-ascii?Q?cHll/GI5uKge/cDB9muMSRVin4SajvKAC2PqfvjdUCcMP78qc0sroDNI0XCq?=
 =?us-ascii?Q?zlJ4CqF2LRKDMxee9TdEYY0QYh7QA5wc162EdP/VmQDJGhNpSQUAzU/zxiJj?=
 =?us-ascii?Q?Ap8yFIotl6SDolFmKJaVhNhSp5mqPYJR5ReEiztRf18/440PW5Mro4sFVKo2?=
 =?us-ascii?Q?WlIxUFAdbjlddoYYqF+7ETnCqvaqjqPvEXfXcbZj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b51d12e2-f021-493c-91fb-08daa666e3d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 00:16:46.4980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0u0j4Ambo5lOSh5ANob2/vPR0h1FzbVz1igiu/drqFf/jvWsS0GDtD7KQenVNBOjftaGP47J3MeuUwWmc+Y3pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3529
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, mlx5 folks,
I got the call-trace from a RHEL 7 VM. It looks like mlx5_init_fc_stats() -=
> kzalloc()
hits OOM due to memory fragmentation:

// This is the code from RHEL 7: linux-3.10.0-1160.53.1.el7.x86_64
int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
{
        struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
        int max_bulk_len;
        int max_out_len;

        spin_lock_init(&fc_stats->counters_idr_lock);
        idr_init_ext(&fc_stats->counters_idr);
        INIT_LIST_HEAD(&fc_stats->counters);
        init_llist_head(&fc_stats->addlist);
        init_llist_head(&fc_stats->dellist);

        max_bulk_len =3D get_max_bulk_query_len(dev);
        max_out_len =3D mlx5_cmd_fc_get_bulk_query_out_len(max_bulk_len);
        fc_stats->bulk_query_out =3D kzalloc(max_out_len, GFP_KERNEL);
        if (!fc_stats->bulk_query_out)
                return -ENOMEM;
...

I think the latest mainline kernel has the same issue.
Can this kzalloc() be changed to vzalloc()?

[10266192.131842] kworker/8:1: page allocation failure: order:8, mode:0xc0d=
0
[10266192.138260] CPU: 8 PID: 62790 Comm: kworker/8:1 Kdump: loaded Tainted=
: P            E  ------------   3.10.0-1160.62.1.el7.x86_64 #1
[10266192.179718] Hardware name: Microsoft Corporation Virtual Machine/Virt=
ual Machine, BIOS Hyper-V UEFI Release v4.1 10/27/2020
[10266192.191089] Workqueue: hv_pri_chan vmbus_add_channel_work [hv_vmbus]
[10266192.196217] Call Trace:
[10266192.197944]  [<ffffffffbb1865a9>] dump_stack+0x19/0x1b
[10266192.201866]  [<ffffffffbabc4bd0>] warn_alloc_failed+0x110/0x180
[10266192.206103]  [<ffffffffbabc976f>] __alloc_pages_nodemask+0x9df/0xbe0
[10266192.210484]  [<ffffffffbac193a8>] alloc_pages_current+0x98/0x110
[10266192.214644]  [<ffffffffbabe5fc8>] kmalloc_order+0x18/0x40
[10266192.218723]  [<ffffffffbac24d76>] kmalloc_order_trace+0x26/0xa0
[10266192.222715]  [<ffffffffbab4ff8e>] ? __irq_put_desc_unlock+0x1e/0x50
[10266192.227915]  [<ffffffffbac28d01>] __kmalloc+0x211/0x230
[10266192.231529]  [<ffffffffc07294d6>] mlx5_init_fc_stats+0x76/0x1d0 [mlx5=
_core]
[10266192.236498]  [<ffffffffc072831d>] mlx5_init_fs+0x2d/0x840 [mlx5_core]
[10266192.242089]  [<ffffffffc070c823>] mlx5_load_one+0x7e3/0xa30 [mlx5_cor=
e]
[10266192.247841]  [<ffffffffc070cf11>] init_one+0x411/0x5c0 [mlx5_core]
[10266192.252484]  [<ffffffffbadd704a>] local_pci_probe+0x4a/0xb0
[10266192.256825]  [<ffffffffbadd8799>] pci_device_probe+0x109/0x160
[10266192.261383]  [<ffffffffbaebbe75>] driver_probe_device+0xc5/0x3e0
[10266192.265771]  [<ffffffffbaebc190>] ? driver_probe_device+0x3e0/0x3e0
[10266192.270080]  [<ffffffffbaebc1d3>] __device_attach+0x43/0x50
[10266192.274260]  [<ffffffffbaeb9af5>] bus_for_each_drv+0x75/0xc0
[10266192.278270]  [<ffffffffbaebbcb0>] device_attach+0x90/0xb0
[10266192.282110]  [<ffffffffbadcbbaf>] pci_bus_add_device+0x4f/0xa0
[10266192.286277]  [<ffffffffbadcbc39>] pci_bus_add_devices+0x39/0x80
[10266192.290873]  [<ffffffffc04d0d9b>] hv_pci_probe+0x9cb/0xcd0 [pci_hyper=
v]
[10266192.295872]  [<ffffffffc00b5b81>] vmbus_probe+0x41/0xa0 [hv_vmbus]
[10266192.300110]  [<ffffffffbaebbe75>] driver_probe_device+0xc5/0x3e0
[10266192.304084]  [<ffffffffbaebc190>] ? driver_probe_device+0x3e0/0x3e0
[10266192.311115]  [<ffffffffbaebc1d3>] __device_attach+0x43/0x50
[10266192.315732]  [<ffffffffbaeb9af5>] bus_for_each_drv+0x75/0xc0
[10266192.319919]  [<ffffffffbaebbcb0>] device_attach+0x90/0xb0
[10266192.357015]  [<ffffffffbaebaed8>] bus_probe_device+0x98/0xd0
[10266192.362323]  [<ffffffffbaeb877f>] device_add+0x4ff/0x7c0
[10266192.366081]  [<ffffffffbaeb8a5a>] device_register+0x1a/0x20
[10266192.370472]  [<ffffffffc00b65a6>] vmbus_device_register+0x66/0x100 [h=
v_vmbus]
[10266192.377896]  [<ffffffffc00b9e5d>] vmbus_add_channel_work+0x4cd/0x640 =
[hv_vmbus]
[10266192.383035]  [<ffffffffbaabdfdf>] process_one_work+0x17f/0x440
[10266192.390842]  [<ffffffffbaabf0f6>] worker_thread+0x126/0x3c0
[10266192.395841]  [<ffffffffbaabefd0>] ? manage_workers.isra.26+0x2a0/0x2a=
0
[10266192.405465]  [<ffffffffbaac5fb1>] kthread+0xd1/0xe0
[10266192.408804]  [<ffffffffbaac5ee0>] ? insert_kthread_work+0x40/0x40
[10266192.413519]  [<ffffffffbb199df7>] ret_from_fork_nospec_begin+0x21/0x2=
1
[10266192.418317]  [<ffffffffbaac5ee0>] ? insert_kthread_work+0x40/0x40
[10266192.423137] Mem-Info:
[10266192.425127] active_anon:16322977 inactive_anon:2861111 isolated_anon:=
0
[10266192.767489] mlx5_core 1727:00:02.0: Failed to init flow steering
[10266192.963381] mlx5_core 1727:00:02.0: mlx5_load_one failed with error c=
ode -12
[10266192.969663] mlx5_core: probe of 1727:00:02.0 failed with error -12

Thanks,
-- Dexuan
