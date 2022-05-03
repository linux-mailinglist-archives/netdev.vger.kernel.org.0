Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE3518B4C
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240590AbiECRry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiECRru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:47:50 -0400
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.57.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EDE3B3F8;
        Tue,  3 May 2022 10:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbijhHt7DvBA3OPHj5t3ISIXnYrTgZbDSRSHY/XkvVdsezGq0sD81iZ//y42Fi2Hm7oEIw1H8MDO35AWd9+dF5auopwSIzFPe74YuKNP1Oz83tgle2Aq1+PBTM7yyQtPdPg8dBbkObOOfdcHgPQwCYlcKGuWJ4R156bFid/pLdBUkpw8ikAC6TwUDIHN2W7gUY/PlWHAT3ycgAIsFpuAIVIlReaxm4w8jPPJRfFHTDrwfikPx+q0M2KAr4BP+Mkr2WGz6Mo0WABvgcYmWGlqDonrI6A0W3sVJYI01Hwlyz83gHMY/7BNmBCbcS7mV6SQ4sjfr4xbKlH5do/EEq/TuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4f7/UQ5vrJT1CcOWidK1fYhaFM8aZiWH/zdIuOdIqFI=;
 b=dqXqNwHhYIB0ER3lhh/rWVNm4ZKERdEz94orJ80nKUJUfttp/wnfqSikyK7yKt7iYkc6ldUXEJma4nPZMqUqXLWeqBqYn3BdE2tOa/aMKvNt9gj8PT3QNHIdWaLn8iw/avUa7KnRHtq2eRRYGwyR7FuPyrdomPVLH2oCaEXcOUnrjeVd/oiCqcnnAd/up+tug/xBARgpdJCDI/9XQpeIX67uH77GUYwgNe77hWgiQhX7h5Bo1kYMNhBf7E0pbeQS5Uw18UPkTEbTw5p8eddfnQ5xc5RmwbnOWVCy1bs9vErVywk/hlTEcX9LIiT7Ea0jg2aEKuPewehmuyrotSaXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4f7/UQ5vrJT1CcOWidK1fYhaFM8aZiWH/zdIuOdIqFI=;
 b=ibLxKWCEZr87+e1ghS/3cQWdAu21T6pLKpXb8f8XpZMMGm6EnkQk6xvpbhjPJde4vXJnb/vlh+izkRcTyaQ3oc0/MfDh6ustPJ68hRUYdoknL67CjcRfYkt2JoVm3CTCbqOVt2GOpFlK+kEynFerKUIBO0QTVxV0uZ6if6XeVIo=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by LV2PR21MB3087.namprd21.prod.outlook.com (2603:10b6:408:17b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.6; Tue, 3 May
 2022 17:44:03 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%5]) with mapi id 15.20.5250.006; Tue, 3 May 2022
 17:44:03 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Evan Green <evgreen@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Julius Werner <jwerner@chromium.org>,
        Justin Chen <justinpopo6@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Scott Branden <scott.branden@broadcom.com>,
        Sebastian Reichel <sre@kernel.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: RE: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Thread-Topic: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Thread-Index: AQHYWonjjKMtrubrvUiw63ryI2yC7q0HJOjggAANHwCABkBo0A==
Date:   Tue, 3 May 2022 17:44:03 +0000
Message-ID: <PH0PR21MB30257E4E6E16BB8FFDE8F312D7C09@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com>
 <PH0PR21MB30256260CCF4CAB713BBB11ED7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <0147d038-571b-0802-c210-ccd4d52cd5dd@igalia.com>
In-Reply-To: <0147d038-571b-0802-c210-ccd4d52cd5dd@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9d743df4-32f4-4832-b2bd-4bac7169537f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-03T17:32:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acdb6465-6bb9-4403-84f7-08da2d2c8350
x-ms-traffictypediagnostic: LV2PR21MB3087:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <LV2PR21MB3087CC37EFCB6B5E523F1E04D7C09@LV2PR21MB3087.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wLED0P0VxujV/NW5LEmwON60/vs9aWjhxc2SvH76GRzH9ukteke/LYW3Yu4t0Qc2EbxzckRYOK1czaMQT+TCBICWOjI6ITHKMiozSJLgS9hQFU5D46+CvmFm/io9aBdtA0Xav0jItj7kAOY/7tKKA8c26IAbmlY0ktpg15mMulNY4n+A7iUKB1NwGgOIJ8oYqbmomBEGepyAxu/y2LKJklw01ZAV2iUCJTrVU5AKYn/kWBNnmJdLrMEh8bwSV10itp4b4fsO6rsYg+Mbcytw7AQce9am850chhQ+WAgda/wrMZiQBO8p86jPtVzHRjJMPYMKtwd0rrVEm/rC6JNgmuYhW8yknC+VyZUi6OjMjhn+uh9twn8sq9L6OWqLkh+x7v72U9HqKAj8CUZoxDuREWKpfaZRsa5KgNg8/HkfmjiCGoQzF9oXyg+mRaouRi57PQ1YtcJ9opqi3qFcpUR/HTgzcMVGX/KIWaSeWtBcdSK6+Sq5bPxmxJRP79DTIFg7VV14SuSkzWyicHoFB377vDjqJZmLdGXd/fcwOLdylL5z2YOcb+163LArbXK3SUeBspcxp3f8eKCsjV2e8uesRaZwHbKLLXlxmyTSDEYrF12HtJItVs6NA+uFJxCWqmOBNh7oyvvEvKtZiIvwM1ypQhy+0nUG36ALgFNdrBC2OyWauW3EhCekOjoCgDpMdhWtEktU3YOGCh1vmWRYm6tsTzCdGFqvcAI/mfhz9DuBuEqeJc2/YP+UtGZb3VI1T/4B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(6506007)(7416002)(7406005)(7366002)(54906003)(5660300002)(7336002)(86362001)(8676002)(186003)(82960400001)(82950400001)(52536014)(8936002)(122000001)(110136005)(508600001)(26005)(2906002)(53546011)(8990500004)(55016003)(9686003)(83380400001)(66556008)(10290500003)(76116006)(38100700002)(64756008)(66946007)(38070700005)(316002)(66476007)(7696005)(66446008)(33656002)(71200400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uzg5MGZMaWFBaXRQZWs0N2FJVkVzalo1cjhyVUVtc3VYMHV6MTZLc1ZTUWhO?=
 =?utf-8?B?dFcvNHpaaWVSZFZZWG1xSkRZTW1QbTRubzczcHZnM05Db2ZZN2s5ODBOaXdM?=
 =?utf-8?B?cHRvOGVrZXRoV2txMXZOVzUwaHRRMk1OVVl5VnhnTXF6bFFwMW5INDZvRkdF?=
 =?utf-8?B?RU9CS3N5TENPV1kxeHBwbFR3bmFXaUwrTVpGampQSUk5b0xQbDZZQ0t6bXBW?=
 =?utf-8?B?ZWtFTE91OVM1NTFmTi9qSzdCVHhsMTkrcWVETUR4SS9nQk9lN3NBV2o2cDk2?=
 =?utf-8?B?WUNBYU9tcit6WTUwQUNXV0hZbWJKV05hemgyTGYxM2ZGL3I0dVVHOWdObFlr?=
 =?utf-8?B?ZTQzU0ZCZjF0S0ZMcmJ5V2FLeEJwKzQyUitzVVJXZ1lOeWtCdHhlbHduL2dD?=
 =?utf-8?B?b0g5ZjZNZFhWQWw4Z3EwWDZXcjVNZjY1ZVdMbTUwN3lVaFRPUWlqUDNlTU5v?=
 =?utf-8?B?VHpGWkI5VU1uWWtZS2ppeURhZEE2cllIMmc3ZmhnbUFpRFNuZElLeWk4cDZn?=
 =?utf-8?B?MzdwNmhqazczdVlMcytiVDVGa00ybGhZOGRkNzlhUUkyRFArQjdKaVh3TENl?=
 =?utf-8?B?WjMvN0d2SUEzVUMzSzV2TlNTb0FKU3RBZkg5STFibGxNNWdNdXlVVjhXQkFO?=
 =?utf-8?B?TitFUVFPMktXeEsxV1VJbjRvNkIxTURtaWhQS3hKQUdhYXRrc1V3cVhSUkxq?=
 =?utf-8?B?aURsL0p2M0JTenJzQkdLeGdyaTFTTDBueVRveGJRYXc4R1k1Q3dyampkd0pz?=
 =?utf-8?B?VUxzSFVwaC90MHJySlZvWFNmVlV2QTRCbnVnQUE2L1BtSHI5WENoQU9XcTlM?=
 =?utf-8?B?TUdhWmx6dkJETTk2QVNwMjFreDRWQUlObnFJRjByQ0dueHdsYTN4eWdDTjJt?=
 =?utf-8?B?K0haTjNxSU9nMkxiZUduUmJVMGJzSXBzNTF1V0NWK2ZCblpqd29GQzRKYjZW?=
 =?utf-8?B?blFxZEVNV0tjYnV2S2hNR2hOa2JYQnc3U0JYalJIeVR6bFRBL3NZcWtwZ0M2?=
 =?utf-8?B?ZkdMQkNZUzcvb3VIM0lVQUNEa3NyOVJsM21NNjQyQ2N0ZW01T3V1bXJJblBx?=
 =?utf-8?B?VjA4LzRnRnIwSXhXcnc1R0lrRlZ4SXFrTE14TFh5STU1dHR3eHp5QVpDdUJY?=
 =?utf-8?B?Z1Y5c21QVHRva1dBUUtpTW1lVTA5blNLTW1PL3FoczZMS3VmWCtUSHh1b3hl?=
 =?utf-8?B?K3pLRGIyem5HZFFndFQ1bVg0YTl6cjV0OHdKcGJxdnNjVHdtQlN4TjJqQ1BL?=
 =?utf-8?B?QXBBRmhTK2ZadHE1ZEJlaXNVU2dqa1dscmtZTitJTitlck1CZFk3dkhqMVJq?=
 =?utf-8?B?cnlXQVZVT05VTlhlbmg5ZktBZmsvSk5iTUw1UGJSSHZRZUR3cnNkYkdRV0Vn?=
 =?utf-8?B?SW9DUnNHTW5JdFhVbHFLU25yem1jWVEzckRjT1EwWjJEWVVUT0ZCSXBWSHpR?=
 =?utf-8?B?MUhLYTdzbmoreHJJdkpTWmp4T3oyTEZOWkRJY2JPLzV0cWdiRDRTMWloZEV5?=
 =?utf-8?B?NUhncGdEMjFQRzJKclMzU3JBbjVZY1BJY25FSzZBOXh1dEFaS1FRRjVMQ2Vt?=
 =?utf-8?B?RW9jV3B2RkhZWnN4MkJLNk9QemcrRHFnVklFWTVRQ2ZjOFp2QzY4RnBVMUwr?=
 =?utf-8?B?VGpzb1pPeUdCYTBNeFRoTlV2RlhUZjlOdGV2aGxvVjVHT3JqVUZmNmhiWGxH?=
 =?utf-8?B?c0s4ODdXNjNVWWVkVHYyY1BZamRvbW1YSkV2UUxjNU5nckJXUU90NStrc2Vy?=
 =?utf-8?B?SjFFSWkybm1sVTdaZGd5T1B3aTZOdDRHUEU3TzNwSTF3Z1YrbWN6VUQwR01S?=
 =?utf-8?B?eURFQU9YbWpnOHYwSzFwbENWTmN4UU5WbVJEMi9QZ1BvTlRDNzJ3SlZHVFo2?=
 =?utf-8?B?aElITDZ6eDI1dnExSVhrTS9POEFUREtrVGFlRkxla2pFRmFVL1FhYk1GTk1Z?=
 =?utf-8?B?YXRmODdxa1NXNHFNT1o4Qzd6U0VZQ3dTeWpTaGxHdFVMRjBqTkNPVjBDWm9y?=
 =?utf-8?B?QmFTd3NEQkJyZk9jRFlEQkQ1eHd0YnAzclpLV2lEWmVkK1E1VjgxR0x3Nkg0?=
 =?utf-8?B?dEMyQ3FDakl2d1BNT0lxQWNVODNEdllqdGFRdE9TTlp0b1hjTjdGYVpYSzFk?=
 =?utf-8?B?NndteitmL1BIOEZLdVdZcWFxVTg0dFJEUmRoZEs5bGdYanI2Y0ovN0Vra1FF?=
 =?utf-8?B?Qms0aE1nem41YmRFRS9RUjVEZjc4MlVMUFFFbnZ6YU1GckFDMW5MNnBsWllG?=
 =?utf-8?B?MG41cnVmUUo0Nk9mM1dlZmtEcEprNTdIRVBabFUxVEJrbytiNEJHSTdYM21w?=
 =?utf-8?B?L2tFV1pSUUpNckZraGpUUkR5b2U3Q3Mzbnp2UFc0ZkE1TDZnM0pWQ21PRUF2?=
 =?utf-8?Q?7+E0ENSNTCQZpn7M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acdb6465-6bb9-4403-84f7-08da2d2c8350
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 17:44:03.1149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkMuoF21r2OIcMVUlulc+xEK2JKXdV4gyeFO5gANWyhUxAZ+FPx2yDzOdgj8vVPwcFsCzNZAmP8P2j9v7c0hX+2ZzXGXg1AyIjkDrrZmEI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3087
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3VpbGhlcm1lIEcuIFBpY2NvbGkgPGdwaWNjb2xpQGlnYWxpYS5jb20+IFNlbnQ6IEZy
aWRheSwgQXByaWwgMjksIDIwMjIgMTE6MDQgQU0NCj4gDQo+IE9uIDI5LzA0LzIwMjIgMTQ6MzAs
IE1pY2hhZWwgS2VsbGV5IChMSU5VWCkgd3JvdGU6DQo+ID4gRnJvbTogR3VpbGhlcm1lIEcuIFBp
Y2NvbGkgPGdwaWNjb2xpQGlnYWxpYS5jb20+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjcsIDIw
MjINCj4gMzo0OSBQTQ0KPiA+PiBbLi4uXQ0KPiA+Pg0KPiA+PiBAQCAtMjg0Myw3ICsyODQzLDcg
QEAgc3RhdGljIHZvaWQgX19leGl0IHZtYnVzX2V4aXQodm9pZCkNCj4gPj4gIAlpZiAobXNfaHlw
ZXJ2Lm1pc2NfZmVhdHVyZXMgJiBIVl9GRUFUVVJFX0dVRVNUX0NSQVNIX01TUl9BVkFJTEFCTEUp
IHsNCj4gPj4gIAkJa21zZ19kdW1wX3VucmVnaXN0ZXIoJmh2X2ttc2dfZHVtcGVyKTsNCj4gPj4g
IAkJdW5yZWdpc3Rlcl9kaWVfbm90aWZpZXIoJmh5cGVydl9kaWVfcmVwb3J0X2Jsb2NrKTsNCj4g
Pj4gLQkJYXRvbWljX25vdGlmaWVyX2NoYWluX3VucmVnaXN0ZXIoJnBhbmljX25vdGlmaWVyX2xp
c3QsDQo+ID4+ICsJCWF0b21pY19ub3RpZmllcl9jaGFpbl91bnJlZ2lzdGVyKCZwYW5pY19oeXBl
cnZpc29yX2xpc3QsDQo+ID4+ICAJCQkJCQkmaHlwZXJ2X3BhbmljX3JlcG9ydF9ibG9jayk7DQo+
ID4+ICAJfQ0KPiA+Pg0KPiA+DQo+ID4gVXNpbmcgdGhlIGh5cGVydmlzb3JfbGlzdCBoZXJlIHBy
b2R1Y2VzIGEgYml0IG9mIGEgbWlzbWF0Y2guICBJbiBtYW55IGNhc2VzDQo+ID4gdGhpcyBub3Rp
ZmllciB3aWxsIGRvIG5vdGhpbmcsIGFuZCB3aWxsIGRlZmVyIHRvIHRoZSBrbXNnX2R1bXAoKSBt
ZWNoYW5pc20NCj4gPiB0byBub3RpZnkgdGhlIGh5cGVydmlzb3IgYWJvdXQgdGhlIHBhbmljLiAg
IFJ1bm5pbmcgdGhlIGttc2dfZHVtcCgpDQo+ID4gbWVjaGFuaXNtIGlzIGxpbmtlZCB0byB0aGUg
aW5mb19saXN0LCBzbyBJJ20gdGhpbmtpbmcgdGhlIEh5cGVyLVYgcGFuaWMgcmVwb3J0DQo+ID4g
bm90aWZpZXIgc2hvdWxkIGJlIG9uIHRoZSBpbmZvX2xpc3QgYXMgd2VsbC4gIFRoYXQgd2F5IHRo
ZSByZXBvcnRpbmcgYmVoYXZpb3INCj4gPiBpcyB0cmlnZ2VyZWQgYXQgdGhlIHNhbWUgcG9pbnQg
aW4gdGhlIHBhbmljIHBhdGggcmVnYXJkbGVzcyBvZiB3aGljaA0KPiA+IHJlcG9ydGluZyBtZWNo
YW5pc20gaXMgdXNlZC4NCj4gPg0KPiANCj4gSGkgTWljaGFlbCwgdGhhbmtzIGZvciB5b3VyIGZl
ZWRiYWNrISBJIGFncmVlIHRoYXQgeW91ciBpZGVhIGNvdWxkIHdvcmssDQo+IGJ1dC4uLnRoZXJl
IGlzIG9uZSBkb3duc2lkZTogaW1hZ2luZSB0aGUga21zZ19kdW1wKCkgYXBwcm9hY2ggaXMgbm90
IHNldA0KPiBpbiBzb21lIEh5cGVyLVYgZ3Vlc3QsIHRoZW4gd2Ugd291bGQgcmVseSBpbiB0aGUg
cmVndWxhciBub3RpZmljYXRpb24NCj4gbWVjaGFuaXNtIFtodl9kaWVfcGFuaWNfbm90aWZ5X2Ny
YXNoKCldLCByaWdodD8NCj4gQnV0Li4ueW91IHdhbnQgdGhlbiB0byBydW4gdGhpcyBub3RpZmll
ciBpbiB0aGUgaW5mb3JtYXRpb25hbCBsaXN0LA0KPiB3aGljaC4uLndvbid0IGV4ZWN1dGUgKmJ5
IGRlZmF1bHQqIGJlZm9yZSBrZHVtcCBpZiBubyBrbXNnX2R1bXAoKSBpcw0KPiBzZXQuIFNvLCB0
aGlzIGxvZ2ljIGlzIGNvbnZvbHV0ZWQgd2hlbiB5b3UgbWl4IGl0IHdpdGggdGhlIGRlZmF1bHQg
bGV2ZWwNCj4gY29uY2VwdCArIGtkdW1wLg0KDQpZZXMsIHlvdSBhcmUgcmlnaHQuICBCdXQgdG8g
bWUgdGhhdCBzcGVha3MgYXMgbXVjaCB0byB0aGUgbGlua2FnZQ0KYmV0d2VlbiB0aGUgaW5mb3Jt
YXRpb25hbCBsaXN0IGFuZCBrbXNnX2R1bXAoKSBiZWluZyB0aGUgY29yZQ0KcHJvYmxlbS4gIEJ1
dCBhcyBJIGRlc2NyaWJlZCBpbiBteSByZXBseSB0byBQYXRjaCAyNCwgSSBjYW4gbGl2ZSB3aXRo
DQp0aGUgbGlua2FnZSBhcy1pcy4NCg0KRldJVywgZ3Vlc3RzIG9uIG5ld2VyIHZlcnNpb25zIG9m
IEh5cGVyLVYgd2lsbCBhbHdheXMgcmVnaXN0ZXIgYQ0Ka21zZyBkdW1wZXIuICBUaGUgZmxhZ3Mg
dGhhdCBhcmUgdGVzdGVkIHRvIGRlY2lkZSB3aGV0aGVyIHRvDQpyZWdpc3RlciBwcm92aWRlIGNv
bXBhdGliaWxpdHkgd2l0aCBvbGRlciB2ZXJzaW9ucyBvZiBIeXBlci1WIHRoYXQgDQpkb27igJl0
IHN1cHBvcnQgdGhlIDRLIGJ5dGVzIG9mIG5vdGlmaWNhdGlvbiBpbmZvLg0KDQo+IA0KPiBNYXkg
SSBzdWdnZXN0IHNvbWV0aGluZz8gSWYgcG9zc2libGUsIHRha2UgYSBydW4gd2l0aCB0aGlzIHBh
dGNoIHNldCArDQo+IERFQlVHX05PVElGSUVSPXksIGluICpib3RoKiBjYXNlcyAod2l0aCBhbmQg
d2l0aG91dCB0aGUga21zZ19kdW1wKCkNCj4gc2V0KS4gSSBkaWQgdGhhdCBhbmQgdGhleSBydW4g
YWxtb3N0IGF0IHRoZSBzYW1lIHRpbWUuLi5JJ3ZlIGNoZWNrZWQgdGhlDQo+IG5vdGlmaWVycyBj
YWxsZWQsIGl0J3MgbGlrZSBhbG1vc3Qgbm90aGluZyBydW5zIGluLWJldHdlZW4uDQo+IA0KPiBJ
IGZlZWwgdGhlIHBhbmljIG5vdGlmaWNhdGlvbiBtZWNoYW5pc20gZG9lcyByZWFsbHkgZml0IHdp
dGggYQ0KPiBoeXBlcnZpc29yIGxpc3QsIGl0J3MgYSBnb29kIG1hdGNoIHdpdGggdGhlIG5hdHVy
ZSBvZiB0aGUgbGlzdCwgd2hpY2gNCj4gYWltcyBhdCBpbmZvcm1pbmcgdGhlIHBhbmljIG5vdGlm
aWNhdGlvbiB0byB0aGUgaHlwZXJ2aXNvci9GVy4NCj4gT2YgY291cnNlIHdlIGNhbiBtb2RpZnkg
aXQgaWYgeW91IHByZWZlci4uLmJ1dCBwbGVhc2UgdGFrZSBpbnRvIGFjY291bnQNCj4gdGhlIGtk
dW1wIGNhc2UgYW5kIGhvdyBpdCBjb21wbGljYXRlcyB0aGUgbG9naWMuDQoNCkkgYWdyZWUgdGhh
dCB0aGUgcnVudGltZSBlZmZlY3Qgb2Ygb25lIGxpc3QgdnMuIHRoZSBvdGhlciBpcyBuaWwuICBU
aGUNCmNvZGUgd29ya3MgYW5kIGNhbiBzdGF5IGFzIHlvdSB3cml0dGVuIGl0Lg0KDQpJIHdhcyB0
cnlpbmcgdG8gYWxpZ24gZnJvbSBhIGNvbmNlcHR1YWwgc3RhbmRwb2ludC4gIEl0IHdhcyBhIGJp
dA0KdW5leHBlY3RlZCB0aGF0IG9uZSBwYXRoIHdvdWxkIGJlIG9uIHRoZSBoeXBlcnZpc29yIGxp
c3QsIGFuZCB0aGUNCm90aGVyIHBhdGggZWZmZWN0aXZlbHkgb24gdGhlIGluZm9ybWF0aW9uYWwg
bGlzdC4gIFdoZW4gSSBzZWUNCmNvbmNlcHR1YWwgbWlzbWF0Y2hlcyBsaWtlIHRoYXQsIEkgdGVu
ZCB0byB3YW50IHRvIHVuZGVyc3RhbmQgd2h5LA0KYW5kIGlmIHRoZXJlIGlzIHNvbWV0aGluZyBt
b3JlIGZ1bmRhbWVudGFsIHRoYXQgaXMgb3V0LW9mLXdoYWNrLg0KDQoNCj4gDQo+IExldCBtZSBr
bm93IHlvdXIgY29uc2lkZXJhdGlvbnMsIGluIGNhc2UgeW91IGNhbiBleHBlcmltZW50IHdpdGgg
dGhlDQo+IHBhdGNoIHNldCBhcy1pcy4NCj4gQ2hlZXJzLA0KPiANCj4gDQo+IEd1aWxoZXJtZQ0K
