Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FACF515112
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379250AbiD2QqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376610AbiD2QqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:46:01 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F31956427;
        Fri, 29 Apr 2022 09:42:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiRnmDCv6QXvKP6MuSaJUsvdzjZ3+bKaim7DUV10U2RiYluMwndhB0+g8eo922omk91MoEzA5kDdABC/GDoEv3leu6fH3rTynjbp8ShDwocs6lESLqrQOBe45W94OtVawEoGRoYT04sxfBK5UmK+jhWXC37iVR1y1ZfAA5nND1Bq2a3KpDt3+MSKVXZfTh40yd142ycwEhIUhQj1RRHwAG9bbggAYPj8giZffS8/E9zWXF5crw0TpK8RjJyZDWuLBELTkv4p05hsHHu0xUmzL6krU9rVi2NQNWDazBYiV+5Mniw+4AfTVmsrGQ6jt+fcMCab43DLOIl+vtEQ2gAhGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuwI3s0/uzAI4p0El6C+ADHa0t+3Aw9/kpVyepipcnA=;
 b=l9uL7cPI8dCubco6QGE8scXjG37TX2AlQuD6kVVSaJZHZiAoJyZaqg8RLI40iqDR0GyF38DTpURbAfKZuoKeLOnm6j3tzS2gL3IBYVV5Fx33SE2OAHyunm21z8JXr16QveJjzaMoX7Va/kf1Ap/vSk7+95TCHIktVFjpQIwtOZ6OqsNW9S0SpPO2GbxB4nguU2r26VDfGrx7BamF5XBhdTpmjPbxYyKhuAyTSo6N3QUdY2DgRmT4bocM0soKQaLPi/R2qfUZ/mGo3jy2ehlbqu5bH2qggAjnGaWXMifxsuGnZPwoaRDw4a3jK8Y2fsgK0I0JhR9+67RoL/3ALtY24A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuwI3s0/uzAI4p0El6C+ADHa0t+3Aw9/kpVyepipcnA=;
 b=VzDdgrQMZRKbNdrTfG4H0EgQQZm9srzi3KTcMWDcx0QMyQJjlYJUETWoCvFt03HvABO693gAaXqwwB+XZny5SSYqYwbMqlCORP1fIwl6HwwCA6DE776swKqJM8h0Rupd24eO8rdzvEprRQHh+mJyC65QdQbRnylWrYA9BefsKuI=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by CH2PR21MB1525.namprd21.prod.outlook.com (2603:10b6:610:5f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.6; Fri, 29 Apr
 2022 16:27:43 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%6]) with mapi id 15.20.5227.006; Fri, 29 Apr 2022
 16:27:43 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "coresight@lists.linaro.org" <coresight@lists.linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
        <openipmi-developer@lists.sourceforge.net>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
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
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Xiaoming Ni <nixiaoming@huawei.com>
Subject: RE: [PATCH 18/30] notifier: Show function names on notifier routines
 if DEBUG_NOTIFIERS is set
Thread-Topic: [PATCH 18/30] notifier: Show function names on notifier routines
 if DEBUG_NOTIFIERS is set
Thread-Index: AQHYWonZ3NInIg4txEiT4R4E8VEqwq0HFqRA
Date:   Fri, 29 Apr 2022 16:27:42 +0000
Message-ID: <PH0PR21MB302584B93A9F44AF5BA016EAD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-19-gpiccoli@igalia.com>
In-Reply-To: <20220427224924.592546-19-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=581a9fba-2d25-46d7-8cfa-60e93c53f88c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-29T16:26:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7493ad1-6244-43f8-39f8-08da29fd2fb9
x-ms-traffictypediagnostic: CH2PR21MB1525:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CH2PR21MB1525388946C29048BEA6F12AD7FC9@CH2PR21MB1525.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EEuDxsnbcRtf/919apm2/HjD95AM6NKjKok91cmfnIdnCg31LBsDlsrydGEeQlMiyweum3K6/Ly/NmiL4TQt7P1hnFHiUWCIgywMxqj3LADrC/6/WTfHQsH9Lc2Kct8tqHmrrjTLHoX4semApWXgeTaAEyaH4i0n9HfleXSNeVY/uIWb95ED0+P63tPZvfTg4eTtGjhkzXpfLsOxKZBCIafYyBpcZEpiiZL+CM7I0x3qlrx+rX4O666DNfjNzu8fv6ClykGAOfMahCE+x8OGw3zF3uaVipnSwWlXOheAUa9FMg6SGUWEh+OYTfVxb/iRE+rrtNAIpZDLK8wdr2KBfdoDajAEiRaquPXxuPzT1L4NooHKU/hmtVp/ukS8qYko61xnqZo+pADQqK/pEu1QvQ5+PXt7AIG5I+wvOLE2Jb0ygAGq6fSAojZlIMBdivpP0KFAycBK1gvaujZpHqn9hvVDk/yGEQs7Ij/38uh4M1fRildvQeDsxwvaJVItQNlb88fzUTbCqjnlZw1BA1PpACi22ntrdOJyKyHyjj4C+dOuZQmHJp3XkSEkoJUcYCch4rb+il7Lb2UCDjJtlhwKVrPmWY7fm5h3KaK3VvUU6ICntxH/UKuJ6R/lMXQJIUuXcvIQWMVmgIjlNu2y31aOdvZb9imBJV+zqwxDqpU0CaiCSqh05Isosw7BA/AnzY06OSlybAnHSf5bCSAOw4hq2VJU74vlUrrurzmRL6esy6IuYCGIkFkWCghKw5aFflP7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(10290500003)(86362001)(26005)(54906003)(2906002)(83380400001)(186003)(316002)(38100700002)(38070700005)(33656002)(8936002)(55016003)(5660300002)(110136005)(8990500004)(64756008)(4326008)(52536014)(8676002)(82960400001)(82950400001)(122000001)(7406005)(6506007)(508600001)(7696005)(76116006)(9686003)(66446008)(7366002)(7416002)(66946007)(66556008)(66476007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gccw+CTOC+7AOYb6PGUwR7Aqrl2d5R/okQD/abZi31DrunoEdaPhnaHNsDzE?=
 =?us-ascii?Q?Nnx4slwru0hCszBG8DTL4D8DdtQKgazWJk2v3DtnXRF0tqUq2SYf2/1mrjef?=
 =?us-ascii?Q?YxDTimGr0QqcG2ms9jnyPzWUZuUVOplpWwuA/aN9hxwPHGCdFF2KkdeaRiH6?=
 =?us-ascii?Q?BLP8a6gBt448eRKGiWvzKUJMqmWd4Ohps0NkGVYKuW4qM1F1mYFE7bQ1lwLO?=
 =?us-ascii?Q?0GGrtymGgORtukcPOVP3yEa4eT7lmvlFEviAI3m9QNXH7z7mbnTugre8KYOq?=
 =?us-ascii?Q?XybIsUit9tu+R3s45WkINtZVCquyFSTQiSL651l4OEaabKJ2wJy97vr2kgEh?=
 =?us-ascii?Q?b0XZKuFeRU2OeeUV68VA2mPnXymBTwcwHWu7CLL2z2yot1h1tn2szTf6MmwD?=
 =?us-ascii?Q?ok6nw2a3uztUvwqr5TfgyPixi3BZ17QXUcytA9WYvyKPjQf6ccvSstlljnlw?=
 =?us-ascii?Q?J0NkwIxgLQdEkkILXV8lc3P42/a8jF8gkbvg5aZuOUAspLNIFEWNKbJW4arx?=
 =?us-ascii?Q?YminuCMEciitH3ciZsuKHv+kZblXd6X1DJNf3QxqnRy1See9yv6gfHwf7Tq9?=
 =?us-ascii?Q?IFdrmELmjyzs31muu4qVz7nRx9BLw1uVDcDu4SjVKsRW87Q+VuvFvRMUl1f8?=
 =?us-ascii?Q?JKQnSS9XEFUZXA554pWaVfnXyon4AWXbHYsinX6QSxUcD1TLA1c7BB7m+55m?=
 =?us-ascii?Q?W3CBeLcRwx2yvgmUfXmF+SlvjyE6G7Y7lklGfjOYwCz9s1k7Dc0JUUBps3ch?=
 =?us-ascii?Q?sLoHPPJdrfvJl1UjbvjY9UQDyYOC8rsBWlaQKJ/vdV+UMb2Xcmz/m6Dcow2T?=
 =?us-ascii?Q?OjHeb1cJ39GUANrBr4MrOU0cT3CpKN0ZyGjm0O2iIp/gbEYM048d+dnIhO+v?=
 =?us-ascii?Q?yeY9Hk3VFfEx3IybE9nLgmI7X6DMNSfumpbXB3wd8IGaiz9uoIvW3V28rE2+?=
 =?us-ascii?Q?jWojKELW/Insfki3aOHwKuBdA5wjxl/aU6CmrZAjsr7IyvQ6XHi6xi1GF9dj?=
 =?us-ascii?Q?CVlkJMeAaleGor8PGEeIQE6Iz/M5e98ytxB6GLdJUAOgAAyyjo6kK8ybTr6W?=
 =?us-ascii?Q?rIGXJ0St74v6eOfp4MxTNawtCoaXpmn9C8u2QcM3kmoT/tE4V4L3q3DX1SAR?=
 =?us-ascii?Q?MfmdxkLpHMgGKmqlhSTtfRo09idix97FrwCBMapUtP0jNLG0WgcAMKVKd0zM?=
 =?us-ascii?Q?gjd17WlW1JZ7Fifxcr4TIdyDkRwSc/Pt8mQOFskRcI7wh0tGnd+ThtebmQw0?=
 =?us-ascii?Q?ImM/GS/FqYE0/Ap1Ha5/KtRRe3/4wotgGsjmcbsF4eaemW0NbbCHabp9kTu9?=
 =?us-ascii?Q?T0DKvT9y9cjZE3XTCziaVp69hZSKwvOfmAROqwWMQkVVA1/TDkGv+caV+Yvm?=
 =?us-ascii?Q?i7Pu68XE0QvA1B7UWuKzlVqL9m1wqPz2JguQMWPuzvzGFoKR42O8/JL8MV/0?=
 =?us-ascii?Q?NC2cE/EzeGx8KRqr0VgKRCZ4k0oKuw+Kpw4gDShftCnn5hdN0fPpsEo8V/jV?=
 =?us-ascii?Q?gH20+Ya1YGBSnW+vstXbDJRpdpVpO4FTaPIV0ccrEmg4Ts1ZFQpw7u+e279b?=
 =?us-ascii?Q?K0IsRjWLxni8JwljD8euR9NG4Ue8ePkX7kvm1Kuqbx4hu58PIN054JsMkIVJ?=
 =?us-ascii?Q?WN+ME2m1G8X4ECEsW3kFp8DQpZ/VIizw8cuJdO3zwQ7ziJp6x6Ir3F+jdlv/?=
 =?us-ascii?Q?mDTGyPH1M7FIsYDyFlONUTDF57vbxtSJP23uR7dYIz1T4UkrorpVnyKny55L?=
 =?us-ascii?Q?SLhFyajMwu3jezZKui9sF5w6gqe8VqM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7493ad1-6244-43f8-39f8-08da29fd2fb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 16:27:42.9879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qv5pQigZxtVKekUCXVeuIxlpJfXwibvP1dG2GPswXH69jjb0KEcwAGhQTpo9IA+UdAubLUWTSa32lRHN32wrD/QH0hF726uOqqNa6DjTmNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1525
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Wednesday, April 27,=
 2022 3:49 PM
>=20
> Currently we have a debug infrastructure in the notifiers file, but
> it's very simple/limited. This patch extends it by:
>=20
> (a) Showing all registered/unregistered notifiers' callback names;
>=20
> (b) Adding a dynamic debug tuning to allow showing called notifiers'
> function names. Notice that this should be guarded as a tunable since
> it can flood the kernel log buffer.
>=20
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: Xiaoming Ni <nixiaoming@huawei.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>=20
> We have some design decisions that worth discussing here:
>=20
> (a) First of call, using C99 helps a lot to write clear and concise code,=
 but

s/call/all/

> due to commit 4d94f910e79a ("Kbuild: use -Wdeclaration-after-statement") =
we
> have a warning if mixing variable declarations with code. For this patch =
though,
> doing that makes the code way clear, so decision was to add the debug cod=
e
> inside brackets whenever this warning pops up. We can change that, but th=
at'll
> cause more ifdefs in the same function.
>=20
> (b) In the symbol lookup helper function, we modify the parameter passed =
but
> even more, we return it as well! This is unusual and seems unnecessary, b=
ut was
> the strategy taken to allow embedding such function in the pr_debug() cal=
l.
>=20
> Not doing that would likely requiring 3 symbol_name variables to avoid
> concurrency (registering notifier A while calling notifier B) - we rely i=
n
> local variables as a serialization mechanism.
>=20
> We're open for suggestions in case this design is not appropriate;
> thanks in advance!
>=20
>  kernel/notifier.c | 48 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 46 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index ba005ebf4730..21032ebcde57 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -7,6 +7,22 @@
>  #include <linux/vmalloc.h>
>  #include <linux/reboot.h>
>=20
> +#ifdef CONFIG_DEBUG_NOTIFIERS
> +#include <linux/kallsyms.h>
> +
> +/*
> + *	Helper to get symbol names in case DEBUG_NOTIFIERS is set.
> + *	Return the modified parameter is a strategy used to achieve
> + *	the pr_debug() functionality - with this, function is only
> + *	executed if the dynamic debug tuning is effectively set.
> + */
> +static inline char *notifier_name(struct notifier_block *nb, char *sym_n=
ame)
> +{
> +	lookup_symbol_name((unsigned long)(nb->notifier_call), sym_name);
> +	return sym_name;
> +}
> +#endif
> +
>  /*
>   *	Notifier list for kernel code which wants to be called
>   *	at shutdown. This is used to stop any idling DMA operations
> @@ -34,20 +50,41 @@ static int notifier_chain_register(struct notifier_bl=
ock **nl,
>  	}
>  	n->next =3D *nl;
>  	rcu_assign_pointer(*nl, n);
> +
> +#ifdef CONFIG_DEBUG_NOTIFIERS
> +	{
> +		char sym_name[KSYM_NAME_LEN];
> +
> +		pr_info("notifiers: registered %s()\n",
> +			notifier_name(n, sym_name));
> +	}
> +#endif
>  	return 0;
>  }
>=20
>  static int notifier_chain_unregister(struct notifier_block **nl,
>  		struct notifier_block *n)
>  {
> +	int ret =3D -ENOENT;
> +
>  	while ((*nl) !=3D NULL) {
>  		if ((*nl) =3D=3D n) {
>  			rcu_assign_pointer(*nl, n->next);
> -			return 0;
> +			ret =3D 0;
> +			break;
>  		}
>  		nl =3D &((*nl)->next);
>  	}
> -	return -ENOENT;
> +
> +#ifdef CONFIG_DEBUG_NOTIFIERS
> +	if (!ret) {
> +		char sym_name[KSYM_NAME_LEN];
> +
> +		pr_info("notifiers: unregistered %s()\n",
> +			notifier_name(n, sym_name));
> +	}
> +#endif
> +	return ret;
>  }
>=20
>  /**
> @@ -80,6 +117,13 @@ static int notifier_call_chain(struct notifier_block =
**nl,
>  			nb =3D next_nb;
>  			continue;
>  		}
> +
> +		{
> +			char sym_name[KSYM_NAME_LEN];
> +
> +			pr_debug("notifiers: calling %s()\n",
> +				 notifier_name(nb, sym_name));
> +		}
>  #endif
>  		ret =3D nb->notifier_call(nb, val, v);
>=20
> --
> 2.36.0

