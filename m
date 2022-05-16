Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2126B528A20
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343533AbiEPQSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiEPQSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:18:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67638184;
        Mon, 16 May 2022 09:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652717889; x=1684253889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+l+W5AAGJYF9POu96DFeN42Yp1wDBbNs2cT6ebzm1Q4=;
  b=gE3JndFmb3MVc+y8k0MigjEzVzCqGvTnKuZFhE4DjcCYaU4+iqRdm1YK
   P0DDqVHBLoq7VKipOO0hdvZYV9pVTZG1CN68yC4Fs1ioVILwIZ3Q2SrMn
   sSdjpODOS6uWQjCqGoSIJu1pba5omJEmL1FQURGDTGfZUlS1TXhoGF22j
   h0UKzl3D3f9Sw7CU71YSSLPCDk1YAxt17+ONuVJQaBsvQLE0imNdebkVK
   Q0O82ERRbpa9leBWTCKvYYiIIzee1lVvNZNkYwosdrYyHDA3KJBcn4HGB
   Wc7wLsviGum79vhrgzLiyhyPVYTFfrQj6/p9kQjA+0ss/R8t28ygKVZCy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="357293807"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="357293807"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 09:18:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="596591798"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 16 May 2022 09:18:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 16 May 2022 09:18:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 16 May 2022 09:18:04 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 16 May 2022 09:18:04 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Petr Mladek <pmladek@suse.com>,
        Dinh Nguyen <dinguyen@kernel.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
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
        "Tang, Feng" <feng.tang@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mikelley@microsoft.com" <mikelley@microsoft.com>,
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
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "will@kernel.org" <will@kernel.org>, Alex Elder <elder@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Zankel <chris@zankel.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Corey Minyard" <minyard@acm.org>,
        Dexuan Cui <decui@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Heiko Carstens" <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        James Morse <james.morse@arm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Matt Turner" <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        "Richard Weinberger" <richard@nod.at>,
        Robert Richter <rric@kernel.org>,
        "Stefano Stabellini" <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>, Wei Liu <wei.liu@kernel.org>
Subject: RE: [PATCH 21/30] panic: Introduce the panic pre-reboot notifier list
Thread-Topic: [PATCH 21/30] panic: Introduce the panic pre-reboot notifier
 list
Thread-Index: AQHYWooLnXaT7guJw0OCpuGv/IkEoK0iJCSAgAAZuAD//40QkA==
Date:   Mon, 16 May 2022 16:18:04 +0000
Message-ID: <bed66b9467254a5a8bafc1983dad643a@intel.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-22-gpiccoli@igalia.com> <YoJgcC8c6LaKADZV@alley>
 <63a74b56-89ef-8d1f-d487-cdb986aab798@igalia.com>
In-Reply-To: <63a74b56-89ef-8d1f-d487-cdb986aab798@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTbywgbXkgcmVhc29uaW5nIGhlcmUgaXM6IHRoaXMgbm90aWZpZXIgc2hvdWxkIGZpdCB0aGUg
aW5mbyBsaXN0LA0KPiBkZWZpbml0ZWx5ISBCdXQuLi5pdCdzIHZlcnkgaGlnaCByaXNrIGZvciBr
ZHVtcC4gSXQgZGVlcCBkaXZlcyBpbnRvIHRoZQ0KPiByZWdtYXAgQVBJICh0aGVyZSBhcmUgbG9j
a3MgaW4gc3VjaCBjb2RlKSBwbHVzIHRoZXJlIGlzIGFuIChNTSlJTyB3cml0ZQ0KPiB0byB0aGUg
ZGV2aWNlIGFuZCBhbiBBUk0gZmlybXdhcmUgY2FsbC4gU28sIGRlc3BpdGUgdGhlIG5hdHVyZSBv
ZiB0aGlzDQo+IG5vdGlmaWVyIF9maXRzIHRoZSBpbmZvcm1hdGlvbmFsIGxpc3RfLCB0aGUgX2Nv
ZGUgaXMgcmlza3lfIHNvIHdlIHNob3VsZA0KPiBhdm9pZCBydW5uaW5nIGl0IGJlZm9yZSBhIGtk
dW1wLg0KPg0KPiBOb3csIHdlIGluZGVlZCBoYXZlIGEgY2hpY2tlbi9lZ2cgcHJvYmxlbTogd2Fu
dCB0byBhdm9pZCBpdCBiZWZvcmUNCj4ga2R1bXAsIEJVVCBpbiBjYXNlIGtkdW1wIGlzIG5vdCBz
ZXQsIGttc2dfZHVtcCgpIChhbmQgY29uc29sZSBmbHVzaGluZywNCj4gYWZ0ZXIgeW91ciBzdWdn
ZXN0aW9uIFBldHIpIHdpbGwgcnVuIGJlZm9yZSBpdCBhbmQgbm90IHNhdmUgY29sbGVjdGVkDQo+
IGluZm9ybWF0aW9uIGZyb20gRURBQyBQb1YuDQoNCldvdWxkIGl0IGJlIHBvc3NpYmxlIHRvIGhh
dmUgc29tZSBnbG9iYWwgImtkdW1wIGlzIGNvbmZpZ3VyZWQgKyBlbmFibGVkIiBmbGFnPw0KDQpU
aGVuIG5vdGlmaWVycyBjb3VsZCBtYWtlIGFuIGluZm9ybWVkIGNob2ljZSBvbiB3aGV0aGVyIHRv
IGRlZXAgZGl2ZSB0bw0KZ2V0IGFsbCB0aGUgcG9zc2libGUgZGV0YWlscyAod2hlbiB0aGVyZSBp
cyBubyBrZHVtcCkgb3IganVzdCBza2ltIHRoZSBoaWdoDQpsZXZlbCBzdHVmZiAodG8gbWF4aW1p
emUgY2hhbmNlIG9mIGdldHRpbmcgYSBzdWNjZXNzZnVsIGtkdW1wKS4NCg0KLVRvbnkNCg==
