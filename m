Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D865F4758
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJDQRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJDQRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:17:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020024.outbound.protection.outlook.com [40.93.198.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA2B5A838;
        Tue,  4 Oct 2022 09:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4r7uu9DnYWsdCbSVB84GJN8N2BxIWwkm8l9c9AAFGNphH7gzWvitMiIPY+DiwbGcFWhzdlOKY3VxHpf3ca7No6LR/fRIRz8yrIkxfhwc+tHrLXytiZtjh1yJ/ndW+Np838pqlRrZFm5qCZ4Pju/LIJOtgxT1VFAXzucgvUCdxhsPI7Grp313eUO38zsTS+edJQ9aluj0PMBa1x2N46Qll5TNJ+BkDjxz2O1hUmVhCLerdSLay2LkhklbSseSGSO1X1gnNG5PZGuA1dfipG3QlYFFGRSsoLM6n150ZRckEv62wwRFUIgniFkT/Nkkk4gbGkmofuQ9S5F9+1GpOUBXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bg6Q2FvSP24l+DNMUWfrfXaSp3hxy+rygEYyYPmcduQ=;
 b=QtnopO8dfpMQ2/MmCbGgRz5p4Dj521iQdS32JRGFNWkzmk+UfTfPl6kUmW2drjzTydDZgZYk2t7eSp/fdhweIvKyH/iMFNAAWvT4+0W1tSJ0rfE1ckEPpG+Iv5hGm5o0NzMiNwK7ZFFLlFqY5mvZEBWm1qDkuHJHXYH0Lpi+vd+rkk867u8fR1h6UE6IdYQFh7MJ8Q7/bUCmDdRCEVErzUUvkIgulXfWJqtLrB+vvhcUlf7tuErSsCsfcqTzdcPW9I/uzbkryeMQTEfioQdEeQ+DNSXwX0PR+Cfwt1oc7FZDfZ31Mfm6G5BsI4lDHCHTU7CbRQigEEey07XQ9A22TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bg6Q2FvSP24l+DNMUWfrfXaSp3hxy+rygEYyYPmcduQ=;
 b=ah8KA/jo5gZNUCIcHmWQS3V1HppKAMLrkrRjK0NwkrnvAuusuUbbzZdtQvEkVCQN2mhFXPRlsObkwA+Rt10x8dl9J6NBlJPpsL6YKDrQAgswN2nujfYaElw5GIFdImh6K5VvQ4vg2mI81EdGLVdXHaeETmyclP8mT7hIbAXQD7U=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN2PR21MB1485.namprd21.prod.outlook.com (2603:10b6:208:205::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.8; Tue, 4 Oct
 2022 16:17:26 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::930d:c800:6edc:ccbd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::930d:c800:6edc:ccbd%7]) with mapi id 15.20.5709.008; Tue, 4 Oct 2022
 16:17:26 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "halves@canonical.com" <halves@canonical.com>,
        "fabiomirmar@gmail.com" <fabiomirmar@gmail.com>,
        "alejandro.j.jimenez@oracle.com" <alejandro.j.jimenez@oracle.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "feng.tang@intel.com" <feng.tang@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hidehiro.kawai.ez@hitachi.com" <hidehiro.kawai.ez@hitachi.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "xuqiang36@huawei.com" <xuqiang36@huawei.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: RE: [PATCH V3 09/11] video/hyperv_fb: Avoid taking busy spinlock on
 panic path
Thread-Topic: [PATCH V3 09/11] video/hyperv_fb: Avoid taking busy spinlock on
 panic path
Thread-Index: AQHYtBqA/Se8pENZtEGCK7VWV8beLa3+sMxg
Date:   Tue, 4 Oct 2022 16:17:25 +0000
Message-ID: <BYAPR21MB1688B387DBA6FD68B8FE0903D75A9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-10-gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-10-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2e8d84c9-e899-42f4-8c02-af268eb92942;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-04T16:15:21Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN2PR21MB1485:EE_
x-ms-office365-filtering-correlation-id: 71fb5875-dddc-4598-de71-08daa623ed27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4NU65mkihAZXvg0ObScYSMOOoH8/SvzFNX4Rh046UZ2u7CfE9UqofJiBxnaP/xM8lVdZU1C9KzGFvRFRtlyCUeWfhdTX+vozedgyKaP2faCWOV4kmDtd+VJBDbt1C796NDUPVWCyW/e/bM4v1KzQiBGio2C+p236Pjh1kGmdV2TPey36SeEL9mxcqgNUpmZG/3lwIaIM64ngBScthY3WkxSGvzb2pxZKqZxPRmSCx/aKSauW+eYy2RmquSw+r5Bu++yXnEVx/tqg5/u0MP9K0rZNWm1vTWMzylReJWfi6p0bZ52D3+1zDPaqGNjvkOF+VWQt2SDrDIchb1OC3F4pq7USDLhm1/YEdBUQ12iWXYm6BxukvObFHe+hOUdc4SqOCs+RldJ/O8VKQHppLt0mQXlMoEa/gMzJgzrs9cTRFZterAT3PBDoOZerisTG6xUQL3vtVtcBPO9AISUPCHBoj8ZrEuZs9tU0TMF/OmwZaznP1FoAxKm1iRA63VPykT/cfmkQXI7SZ/OcwBMV8qmPwgOxgrH+wAHRzX6JYBR01r7Y6j0N2xwly4C/LtFO6NTG113HkAjewRNnmFfCfzyonQuJ4YUh6VGUWsIjg0tggCjnFRWmoeR0CnMeOtua9vHBtBsMmlaaahjqLATj0xaW/MUlELa55qTFsR6neppOitzGAQJDt+zzFc+LW0CeESuYB5GHWifHIs+wSY/Yik7IjhKbrtacH05dNW+nXz4VUCf5Nuoj1U9PNJOAdbQ8DfcJM/SwGzJsjKjUchHHVW43lF7NjQfw+e5IjHAt/BXoPOrisgCX0VnrIFmQqR6yzxeKQ+Xsu+eNqi1zRsNgHP62fA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(82960400001)(7696005)(38100700002)(82950400001)(41300700001)(54906003)(8676002)(316002)(110136005)(122000001)(76116006)(66946007)(66476007)(64756008)(66446008)(33656002)(10290500003)(83380400001)(66556008)(4326008)(55016003)(186003)(6506007)(71200400001)(86362001)(478600001)(966005)(26005)(9686003)(38070700005)(8990500004)(7406005)(2906002)(8936002)(52536014)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sCzz5x2m5LR29UWUlifxGZvM7UPX7AMmAmackJ/HUdgZhgUi3oPURkZx52aZ?=
 =?us-ascii?Q?U/89ylmqpL40vB6mqDm0RH1f9KrS9tueiKrpuVHm36WZF0JRnwz1QxN7Hl5K?=
 =?us-ascii?Q?6VKID/n/ntnnyE5HB00A8BM6CAHVLamAkgEnkOh+vY9RMdFIqYR5LgnSMGvb?=
 =?us-ascii?Q?bwYUu6z/AMlVm1nIlbsdSqeDha09tk86tqE2k/qvOuss6uAI0BLxv2JmC/pR?=
 =?us-ascii?Q?hlWVB2EFk7zn4CB6q+PlZ3CI1ItX1rMSheSDxpcYsjcrKOk8iSlJddvFp4DZ?=
 =?us-ascii?Q?Io1K+H6KGl1sE8/uA7XPOZecLBy14aQhdVmRx0QZc57y3H41Q93ypbtNtKCG?=
 =?us-ascii?Q?Ba/5uwtfQVtFHYCz5596R1wHMjNtnBVssi7m7AAfkCjR+xzuUjisGhClZbET?=
 =?us-ascii?Q?4OiLEqaSA4lZ2IBvzy4Mv/mubW/KDpL9g8MOaLHOvnuzx6eklI+ZBldOTuwm?=
 =?us-ascii?Q?ywzJ84BomtA63/kVSVgAFKgEYTNu987tQHKaSbuAGezz9fKSARtVPwBoDA6k?=
 =?us-ascii?Q?H1y96HUAON7kv+VxJSBQ7IIwRPP+N35ih8v/E3snCp0TxIKWcbR+FR76e6jK?=
 =?us-ascii?Q?zplkum+Umw1okQ7+7p9u8hACYh88RRlbAfTChPNCsVLiHFU7rXxqCoMb3050?=
 =?us-ascii?Q?ei3jfUF3TqSMOCjniRLIDeY7VLeRC8juh013zevNo5WAg+cji9Jv5FriKz0G?=
 =?us-ascii?Q?WhlHUjqA0F+XmIqeI6uMIaj/OSGbWf02xiPKNYnRFRjBu8ciEbHXFfjkskA+?=
 =?us-ascii?Q?kHRzl+dV5zsGa1NGge44L2qs1Y1WHcJvDayGbnL5nUWAqvA0v4fVZi5TF1ld?=
 =?us-ascii?Q?DW6OY68aWnU8lqwtunWrSLzerQBLVnslpuB74VIKSiS8P3djO3VoUCO9r99S?=
 =?us-ascii?Q?VfsAV38I+KPMGZssnzRXnwHgdxjJC6z1Cgyamys69+4LFujpp9WceYnFBJyK?=
 =?us-ascii?Q?Iy7mfxp048/ytpvW3RiNlYp6yE/FfnQlz3BNfUFChfQTQDC6OR1oWUTdTZxC?=
 =?us-ascii?Q?2iXxnQbc4/cLtzPbZaU/HbsLgY8j1XstcopDUXaW4sg+zfh3DOwkMF3R7Si8?=
 =?us-ascii?Q?GvHpREFxIQ8x3im8uWVh9Lj0f9LWF7xGi8qSTAHn7Clkx+EfeFRwqQudU8/W?=
 =?us-ascii?Q?MFTT8Igw7DGNsBn4DqcVe/KwSNI6KsVIa7E/fAS9qevuUsqPYiJcUqMjWlzX?=
 =?us-ascii?Q?wzUpQCKWViELt5jIwdOSbEcqz7dqnRkUqKq4eSCykS9KkNNtnnjaDlJo6mvk?=
 =?us-ascii?Q?/E0pOGaIuda1KLRC3m+QlaU8tZT2hGLTKm7oat2iJ6B+Py31AuTR0L9N/I8q?=
 =?us-ascii?Q?Afg111FVBetymTuzTBQK7NkIfpr0Ia+y4jM4QyJV5iasAXxY1rxm3WBKqsHR?=
 =?us-ascii?Q?61yRbxHH0+GUc5/YZ1GL8vF/7g2x0h7dldROxXWSSYYDTaMf7Il+R1cyeQrC?=
 =?us-ascii?Q?z7Xe4uN4sCdgNYjqaeh2m0NSAgnhvhih/oGCkQrvWu5w0sq6kBRc+NLPmHpN?=
 =?us-ascii?Q?twzM2Zo+P+iauOG4ZM1jLJBFRkue14EbBUnHIxh6EN0GQoFRiYm7qWIzpdWF?=
 =?us-ascii?Q?Kjgvz1FCWDSQ7Z9o8qT3h/jkHFchmHAeNP7PStNA/bjjONh5KIrKIvs+26TZ?=
 =?us-ascii?Q?AA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fb5875-dddc-4598-de71-08daa623ed27
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 16:17:25.8600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qDkb8t9pNRTY9LvxxOkbUPLEzfUTCafpJIW5bfKKjS/Dq6lC2pjeAstiBkGgktgjVFD8z3o4Ph2aJ0bisQgLBZZQB0/s39Bxk8PTxeMtm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1485
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Friday, August 19, 2=
022 3:17 PM
>=20
> The Hyper-V framebuffer code registers a panic notifier in order
> to try updating its fbdev if the kernel crashed. The notifier
> callback is straightforward, but it calls the vmbus_sendpacket()
> routine eventually, and such function takes a spinlock for the
> ring buffer operations.
>=20
> Panic path runs in atomic context, with local interrupts and
> preemption disabled, and all secondary CPUs shutdown. That said,
> taking a spinlock might cause a lockup if a secondary CPU was
> disabled with such lock taken. Fix it here by checking if the
> ring buffer spinlock is busy on Hyper-V framebuffer panic notifier;
> if so, bail-out avoiding the potential lockup scenario.
>=20
> Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Michael Kelley <mikelley@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>=20
> ---
>=20
> V3:
> - simplified the code based on Michael's suggestion - thanks!
>=20
> V2:
> - new patch, based on the discussion in [0].
> [0] https://lore.kernel.org/lkml/2787b476-6366-1c83-db80-0393da417497@iga=
lia.com/
>=20
>=20
>  drivers/hv/ring_buffer.c        | 13 +++++++++++++
>  drivers/video/fbdev/hyperv_fb.c |  8 +++++++-
>  include/linux/hyperv.h          |  2 ++
>  3 files changed, 22 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 59a4aa86d1f3..c6692fd5ab15 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -280,6 +280,19 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_inf=
o
> *ring_info)
>  	ring_info->pkt_buffer_size =3D 0;
>  }
>=20
> +/*
> + * Check if the ring buffer spinlock is available to take or not; used o=
n
> + * atomic contexts, like panic path (see the Hyper-V framebuffer driver)=
.
> + */
> +
> +bool hv_ringbuffer_spinlock_busy(struct vmbus_channel *channel)
> +{
> +	struct hv_ring_buffer_info *rinfo =3D &channel->outbound;
> +
> +	return spin_is_locked(&rinfo->ring_lock);
> +}
> +EXPORT_SYMBOL_GPL(hv_ringbuffer_spinlock_busy);
> +
>  /* Write to the ring buffer. */
>  int hv_ringbuffer_write(struct vmbus_channel *channel,
>  			const struct kvec *kv_list, u32 kv_count,
> diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv=
_fb.c
> index 886c564787f1..e1b65a01fb96 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -783,12 +783,18 @@ static void hvfb_ondemand_refresh_throttle(struct
> hvfb_par *par,
>  static int hvfb_on_panic(struct notifier_block *nb,
>  			 unsigned long e, void *p)
>  {
> +	struct hv_device *hdev;
>  	struct hvfb_par *par;
>  	struct fb_info *info;
>=20
>  	par =3D container_of(nb, struct hvfb_par, hvfb_panic_nb);
> -	par->synchronous_fb =3D true;
>  	info =3D par->info;
> +	hdev =3D device_to_hv_device(info->device);
> +
> +	if (hv_ringbuffer_spinlock_busy(hdev->channel))
> +		return NOTIFY_DONE;
> +
> +	par->synchronous_fb =3D true;
>  	if (par->need_docopy)
>  		hvfb_docopy(par, 0, dio_fb_size);
>  	synthvid_update(info, 0, 0, INT_MAX, INT_MAX);
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 3b42264333ef..646f1da9f27e 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1341,6 +1341,8 @@ struct hv_ring_buffer_debug_info {
>  int hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
>  				struct hv_ring_buffer_debug_info *debug_info);
>=20
> +bool hv_ringbuffer_spinlock_busy(struct vmbus_channel *channel);
> +
>  /* Vmbus interface */
>  #define vmbus_driver_register(driver)	\
>  	__vmbus_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
> --
> 2.37.2

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
