Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEC55803CE
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiGYSJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiGYSJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:09:37 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021027.outbound.protection.outlook.com [52.101.57.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEFF1EED9;
        Mon, 25 Jul 2022 11:09:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgL6fsMz9uTOWvxzy7Nuxsz01HH7FvXaYOJY6033FPO2pSukY3YaIUENSRZ6JL2XjHq/2KWUdrna+eYqU/Nb8KsEmGlPDU2Epz90KM72BPGFgBTdP3liqz6Q6rMS9qfhUyHZvANFVjtQw3mauG41DwoLQCBS0ai0450wO9yXD7mjG3ZNbGAsLIdl9PohbXQs6ezuswYcThAKxCD32YOCg8xX47suUK+xqkq70OFVTthkl6aGPzd5XW73v6J5nWVmslD+FjSu07s4IZt2LkGgnT7f/e26HGjKHxYU+u4awbTrsDxUM/W0dn73HgfJteqjotC8MAeVTGVSHY3ym+ugiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVTj4d0PIpyQIm6ct7HgBykBbuSTzMESNqhhJFeLmS8=;
 b=Sow2Kbn2jK7ZJV0nwwax76JBbujG6THSl0R3vPWKXCqOnIJn59Znq0tfVWCFX6D+wLzewF5XmGrYZBMlRbz8RrGH7t8ALsLvkGGdhqCqW6GExQMQ1kKDfr1zOb/wBCOuOMfsMmTGkxOsisU5gstdVtLYEw2cTsghvzola4iOeko72cgCvmEdtI3EcIs0UMTA5Acq8DqB00zihU3f5JNZSSDxaFD6pHdaOaH1Z5d+cryrfIlb+7VxXjxj0Ft8w0LMdgGjbqVm10TFfhn2zyrQAtSSm/o8SupmE4zIDSV/eOdpe1FGGxi0u5q4v9vQ+Mp7ObRmg2tbwDq7fPUEOZGzsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVTj4d0PIpyQIm6ct7HgBykBbuSTzMESNqhhJFeLmS8=;
 b=aHVrP37v1LQQWGsoYnyk6I72ru19VErToBdhLeq7KFV3OhHxlBUk6Ru+ZJIt8sZPC62Hkcq7ThKsMvsQcnsHUTDJTCuj8JLZXO35UqxROq49+Ug5tSMljt3psvjJ0IEpmqLIvZLjcD5c8lpnEjkgucOb/ZLoA2PbAvyfYdqpyIg=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by LV2PR21MB3229.namprd21.prod.outlook.com (2603:10b6:408:174::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.1; Mon, 25 Jul
 2022 18:09:28 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ddda:3701:dfb8:6743]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ddda:3701:dfb8:6743%4]) with mapi id 15.20.5504.001; Mon, 25 Jul 2022
 18:09:28 +0000
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
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: RE: [PATCH v2 11/13] video/hyperv_fb: Avoid taking busy spinlock on
 panic path
Thread-Topic: [PATCH v2 11/13] video/hyperv_fb: Avoid taking busy spinlock on
 panic path
Thread-Index: AQHYm6nhxD3vCNgXDkaqQNF/QdvErK2PaFrg
Date:   Mon, 25 Jul 2022 18:09:28 +0000
Message-ID: <PH0PR21MB30252061CD7F2FD15BD77F7ED7959@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-12-gpiccoli@igalia.com>
In-Reply-To: <20220719195325.402745-12-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ae7ebccc-db95-447a-9683-4ffcff5d64b9;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-25T17:56:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c0944d6-3045-424b-a98e-08da6e68d098
x-ms-traffictypediagnostic: LV2PR21MB3229:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KovVjc6I2VDImi0AOuGG6JEpYG7geqh58rISYn3tOctmQHdYqlqi/Rxa/lR2hQ3KwuyArJ4RnkNh1o2uzbxMtu+xkZGEC964lm045rxqxn/DG9ZJ/s9QGFhQNqHktTZt5bKGrhkuWAn0r7KaYsqMsscDPGobnyd+dLtGYguOA7YUdsvhyQthrQj3mH5AI4/m8iZlNuEMNxx0tiXyfcvYHncsn+FvKEvysr3wJK5UXVp3RDL0wgYSOnBP1D9J+2CBmJLhc28RrSSpsRZjFLIfNaeLInznFUiB2dJaRVF0W5Z0GBCNEMYC+5J8Tz/yRFowwTqCDMi95ShuG9Xk/gWjqZsQhRZ/EHt4w4wAxubAaPuASC4cUk+z6//7O+YCngCw6ynX5QVQqznFqcgghCKZqZUYk/7kvusFMxU+8UUyfInXQ6DA4PXXjS/UermJmehdwXxQmFP13/qhezx0moCi5T0g6GjpJkm9KvOf53/mAxGXBBvUtYA/zbvuhUf6xEDoXr6U/PhwuWYj2keO+dwTUPHL1SkTauqxjbN7Et6R3ZxbYJMvJzo4sjXLuxNB+zvozVR+S+Fmd9kuZrUH0UdYdFtZ/KBd3EYTUc2QkhvAT846a4KK7UqibLEPAybdhqoWB6YzI9t9zpDwriCGXeVWNZ4n3eYo3U1xJ9EEUgFXGdt2MJn8cf7nb4OsCK3/Rlkg6caOu3G1RqyaQBOQ9v6orOUwoNhXrCY8JXHw59rvvMlBEjtMu9YaKyUv8MXpOT/s7DBD/ZGFw/uN3zgusz3VXzp0Wl9/kjn0m0YhjgPbyCDtyW777ogOz7TExDs/SWG58CnygOLoTmx1+TYomnyQoF0dSRzMkR5sPbYjk9fYXWpR5GfgPpH1W+TqwIFkqrGK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199009)(66946007)(4326008)(66556008)(76116006)(66446008)(64756008)(71200400001)(41300700001)(66476007)(55016003)(7696005)(52536014)(26005)(8676002)(5660300002)(10290500003)(8936002)(7406005)(83380400001)(7416002)(86362001)(2906002)(33656002)(54906003)(186003)(122000001)(82960400001)(38100700002)(9686003)(82950400001)(316002)(110136005)(478600001)(6506007)(966005)(8990500004)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?otKPG2cvIajyqGsTEjBNKyvkL5ZTL8Rd365UjHBX8WT0SZ/25/hU+GIQUU4t?=
 =?us-ascii?Q?gNmQON/cxVlXZKNmnAzZ4umXmBRS9DZyXuk2J+jr+wCAV0F7cA7Ev19lKaJF?=
 =?us-ascii?Q?IQ6F/4TfQzS6o9EGvwY9AJM8ISvYpD+E8sVFfaRWhS1nRyRhcFP7//zo4Y8x?=
 =?us-ascii?Q?GKYX1wc703TT7E/BskPKiKWG4DBj0c/A4o4gPAh35CXqc5exY57ktPMCwXab?=
 =?us-ascii?Q?QrAylc1u0DzrkHRQgjIsfwtuVx9I+iEA0fhMfVqnJiHygAMzj9sGjJ7SgNK4?=
 =?us-ascii?Q?5EIW4zcyvCtt2h1lJgctlbL/LJm3XtLbuDEFqzStyDiLzVBR7hLwmri0HXhW?=
 =?us-ascii?Q?N6451gBXye0WqD0yE0MMK/Vl3ZZgDzbiyOOvrIM3e9WLjfJt2GZAJ9ZnU1Jg?=
 =?us-ascii?Q?favLSXL1E38c0mkemKp/pXTGQxUgIctWThhH5XToJhs/xOP/bgRfWLA9A0do?=
 =?us-ascii?Q?zG+sb+YT3fJ13gkuVOCpMu6gk19FYzgQt5PmTCkq18HZcQ2KDUFDHnds15Pv?=
 =?us-ascii?Q?YTz7FwVmX2lu24OLlbBJn0IikljUwDfD8q59uKb7Etl3dh+NF6FfBcm348N3?=
 =?us-ascii?Q?G9MouHxn+zdJbeSHoYENmYMUqqlduOyyAi7hLwlojOOtpmiwJy43swMldcPo?=
 =?us-ascii?Q?4aJCI01q+xDkZRzxto1UhzKGeNXSMSdfD8v9PQrZ34YCqU2ZDDYGy+moAce9?=
 =?us-ascii?Q?TVYdtfc3tKVITEPTWaZbImM+YlCsMKLC0QAQrgVqNddeTI3XdUqNHFY3mmnc?=
 =?us-ascii?Q?4Smcu4vqF7cw1CsJ2dosGI7lfj3QbrklXe5f/cWgzSXHBsn5NF3tnkLsYjz5?=
 =?us-ascii?Q?BWbx9VJasC+xyUB0VgqO4w7hESY7ESpUDA1B6VoY0t9BmiEMX+0pWD+pHSnK?=
 =?us-ascii?Q?glbhWFxa5umoJ8t1WLNJh6E5fXqyW9op5y8ItY+KVojNiSHt73AVsD7UH11W?=
 =?us-ascii?Q?w1RpNKRYVcWdBuOsDDijC/3c/FGxX7HD8bF9V6sgIG+Hbm7IGELrlqWa5Nb5?=
 =?us-ascii?Q?GrF9TlGdG4kQFd9UNo51wOG2KDshStmW4OWTJApXDaGu/mC27+Gh5yDxte9V?=
 =?us-ascii?Q?VzNxRcf3ew0JWrRmE/tZyn8s4OtUNLtcmeCvnigLmUTzKFka+YfCAqxU0TPq?=
 =?us-ascii?Q?lFoMCICXWg2r/SVgil55Sn75bmADI9Dm9pTeOvaQs5rdws7+8q88PnCD01cS?=
 =?us-ascii?Q?jw/GbpX41bjQlwJXzxEYLX0f++ilKB1NrvGuea+ZehYvU2mWuJtLPOXB+gM7?=
 =?us-ascii?Q?OCuWMoF0IrXiQRI/dMaPwFdv+UmByxiPkNMeUAmR7740rgMDhnv/WI2/HZyW?=
 =?us-ascii?Q?502uThB/3NGf28WvP4GswpBpdC+INXZiBMeDEmjWDw81rH59pYEE2p9jFGSP?=
 =?us-ascii?Q?tL0fBbGBBPJ+5Qps/l/MnzSVSf21ksAyBy3wqIJi8oZMNA9cNtqRhLxCV3Yn?=
 =?us-ascii?Q?ldy5W7XkHqbZB46Us6hVIwAP89b6J7yPm4hl0MX/NlOihwl9ji7AOv2Yi4ee?=
 =?us-ascii?Q?Tjls1W+xOfnfWLY4qNoPTP0k3pR0cAfJCmW2qPdE2U1ZGpMwE5aWlG20sA0w?=
 =?us-ascii?Q?fapkAaNC3v5pj0XzvOEueFAWcE3Ub/BQNYjo+dp7hRiO/LbGOUe6gII4tRzA?=
 =?us-ascii?Q?Ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0944d6-3045-424b-a98e-08da6e68d098
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 18:09:28.1197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rBq6wrLJkpA3uHTYypcRxdrruDnIoQeMKoz5hNlFu059lPzJxu8yJQNvSAWtACj3HusD58h4TrbzsUpQvueHdZnU9b0SS2hDxclC/zVPqg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3229
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Tuesday, July 19, 20=
22 12:53 PM
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
> V2:
> - new patch, based on the discussion in [0].
> [0] https://lore.kernel.org/lkml/2787b476-6366-1c83-db80-0393da417497@iga=
lia.com/
>=20
>  drivers/hv/ring_buffer.c        | 16 ++++++++++++++++
>  drivers/video/fbdev/hyperv_fb.c |  8 +++++++-
>  include/linux/hyperv.h          |  2 ++
>  3 files changed, 25 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 59a4aa86d1f3..9ceb3a7e8d19 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -280,6 +280,22 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_inf=
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
> +	if (spin_is_locked(&rinfo->ring_lock))
> +		return true;
> +
> +	return false;

Could simplify the code as just:

	return spin_is_locked(&rinfo->ring_lock);

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
> 2.37.1

