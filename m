Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F624EE1AE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 21:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240678AbiCaT31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 15:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiCaT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 15:29:24 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E51DFDE4;
        Thu, 31 Mar 2022 12:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648754856; x=1680290856;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TRQtemiCmSPiRE+OLaaMiZ1EEVqMTWlOqDLFNj47CUU=;
  b=dU1CNnFiqTX20CuwuVCk8ICZi0yl4C4yBUroxBbFqSRHZb1zZRutFQs7
   io0sYpQqMiylyXHfCnOnFbspbitE9yxxWNgbnIErgqtGJ+1VbFKOKaGle
   UztNfdKnzsA/qO5JTxbjZrB3UMm2azCsWC/KUkSQlLIFXfWQRIzJby4Rs
   8UchjaAAaaFp16vsEggZrkw9+T3H4ebh61BIDLIYaL7pLA7qXyxPlTnIb
   ldA1Cy7dfYJjGb8x9S0MkgpljSoJTwFRzdKXt4azPWAJzaSIL92/nrbyM
   c6qH+fDKyxBjSOfGPPLG4bo58XV3/NiPbkH2N+U+jOMaVOSXfIE5/yl/d
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="320625879"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="320625879"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 12:27:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="586559170"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 31 Mar 2022 12:27:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 12:27:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 31 Mar 2022 12:27:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 31 Mar 2022 12:27:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjUol4fL7/it/8yB2yxYffcnAKvwf/ahA9ktqElmxStqHVWh7NUDCKbkOkZvToK/gnUWj+u+MWC8aE31O5kYVVWj0McuTbl+ezL2Xe6BrrKXByTKQ8yxuriwSx3gIivi+Im5KU0qTNwTjLqwdOJHFxqN2pwcvY+bJroC6mRLuVktIcCFRtOSCtI92zMe9TJlsB1AIQeFSBZgPeqYDZs4tMB9u9fegFWNveFn9bb+tw7JfrEcQ6RJvN74g8Y9xF8DivsC7ll69l1SqaUbmLyaaid3sMQ6KYMbqEzyJwsI6h9CvX9HcKcd4mqx0j+PjPFbyGufTb+jMHM6DEhj77zQhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRQtemiCmSPiRE+OLaaMiZ1EEVqMTWlOqDLFNj47CUU=;
 b=fmUGqdNVKI3+pBz8S6XX4BKJqJFv6xK+s99IjVmmgu06CB6qCqvU6XIpI0f2gVpQ/k4fqSLGBBdQfaKZO4wPI+ngelmcwAd1KLhtG6mvUrSEBDrSZfsRPm/NJiz62oxNTikkF0oj2XuOZaB3ilVAkyKB7vvQSmHXURuVt5HN2Bd5dSYvO3oCLZsrIWka2oTRjhJFWDR9Rc2Jp/1fDIXZWMjSm61VaQLAldfIVRaCgKlrk6vfVVoqi2l0TyZQNoRRhs8wrO968ovkqEqHRE7T2HohR/ZNWF7YrbcnUhJoqM+5slDVHyhtwHvwsNXM2+j8khDlZ5DWu7mBI4qI4iBXtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BY5PR11MB4434.namprd11.prod.outlook.com (2603:10b6:a03:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Thu, 31 Mar
 2022 19:27:29 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::a833:61cb:3c40:6df]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::a833:61cb:3c40:6df%7]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 19:27:29 +0000
From:   "Moore, Robert" <robert.moore@intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?utf-8?B?QmVuamFtaW4gU3TDvHJ6?= <benni@stuerz.xyz>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "linux@simtec.co.uk" <linux@simtec.co.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "3chas3@gmail.com" <3chas3@gmail.com>,
        Harald Welte <laforge@gnumonks.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "mike.marciniszyn@cornelisnetworks.com" 
        <mike.marciniszyn@cornelisnetworks.com>,
        "dennis.dalessandro@cornelisnetworks.com" 
        <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm Mailing List" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        "linux-atm-general@lists.sourceforge.net" 
        <linux-atm-general@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH 05/22] acpica: Replace comments with C99 initializers
Thread-Topic: [PATCH 05/22] acpica: Replace comments with C99 initializers
Thread-Index: AQHYQTLw0CnWOb6Cm06gV2rlVTnV06zTqA0AgAY//BA=
Date:   Thu, 31 Mar 2022 19:27:29 +0000
Message-ID: <BYAPR11MB3256D71C02271CD434959E0187E19@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-5-benni@stuerz.xyz>
 <CAHp75VeTXMAueQc_c0Ryj5+a8PrJ7gk-arugiNnxtAm03x7XTg@mail.gmail.com>
In-Reply-To: <CAHp75VeTXMAueQc_c0Ryj5+a8PrJ7gk-arugiNnxtAm03x7XTg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c4c014a-a248-43cc-3951-08da134c7ef4
x-ms-traffictypediagnostic: BY5PR11MB4434:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB44347E2B37E4457B39814AAD87E19@BY5PR11MB4434.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u+u3AnVEttCpBQaqF4LgujPzZqjW9MP/As7L7nltcwfgO6DCKmIVv2h/kAmYCDaB6nMAwJbkyBf6FAvg5acHU+FUgRcoU4sAsnDcIBwPsPzpjCozlyTyjZSv34VpOIy1l35nyOuVY1qFNaOlTlZT2AKIYAeKNnQl2mjoXykBiWTCuHP/1EVKjlVTj0//ooLZJjYpOWWwdgz15kywScet8kIp4h5zql3MGdxAERLH54yxERb1765h00Z8O8fe7TfZnI5LQYh8h1LrubUsnd+i1AAa2Hu4L+pxLhEABMgtGWUUg1a/3aBLkshIACImxYMpchRuB4ZVr9B43TVvkVN6Wbl96ZgwQFw+dSONFz7X6DCUdmZuTOk8GJoycN8jdRyuEi+Omsovuu0y+6hVtDs/q5XBE3buEueL1zDiIauvT6IjzfVuVH5QCLrNc9+3GIBLNZyuGDwkQLCXMEwEE8m4ya3bzl0xYxYGXeEf7SyojwKrET5jufiJx9x9KzX7tp9cKlgeRwYObKTd1S4xGVTGfBTnMiFHb0gk00mmpG0kDj2TdNLW3BA1UsEPT9fTJ6tR9msKGcaERyuCPZQM3TeEauRB+pFScwsDhslFcZpMZKq9Q+1hYO/v2+KwgbAPfZnccq2IygO/X1hMpEaUquTypnbZbau6GoSlF0jUeZiPIm0CxrQuxtU3Poazu91bg3p6OG1SELwGV2mBwNQzUNs9JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(83380400001)(9686003)(33656002)(7406005)(7416002)(2906002)(7366002)(6506007)(53546011)(7696005)(5660300002)(86362001)(52536014)(38100700002)(55016003)(54906003)(82960400001)(71200400001)(110136005)(122000001)(186003)(26005)(76116006)(316002)(38070700005)(4326008)(66446008)(8936002)(8676002)(66946007)(66556008)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2h5WCtjNWFVa3lJY0RqWDQ1dE4xbFA5MWhScm5hclM4MkVyUlNVU0ZUSWhN?=
 =?utf-8?B?S0gxWHFncVRMQ2dHMllCb3NqTTdaM0NubnUwYlVJR05CMERSSlBEcEtBeFRX?=
 =?utf-8?B?UklzTkRsZGw3NEFWK05LSTZNT3k4TGlRcDF3cXRjalVnU29Qem9PbGZPV3kw?=
 =?utf-8?B?UTBNTGFNN01tbVBtajc0WE9wMi9lbDdmdmtSK1lzQ3RXZzBBSCtDcm1qaWRT?=
 =?utf-8?B?YjBOTDV2YXl2eTFWK29aS3lmNXJ3TlZNODI1bHVBQXRFUnpmcXJpSU55S3VJ?=
 =?utf-8?B?L3ZlYjNoZWM0QVVPSG5LR3ZSNUIwUDRqM01NdEMyb2J0eUV2SjVyR0RMSnNM?=
 =?utf-8?B?SHJXUlpQaFlBVWUzNXdaYTRHR1IxK2YvaU5yMU11V01Rc3NHR3VhVmV6RWJs?=
 =?utf-8?B?ZXZaZnZvTGRqMDFlV01DT0RSM3FsWGxrUTFPS2R3SEtjYnVmVDY3T0Z3MnlR?=
 =?utf-8?B?ZSt6SXdhV1lxb2tJQ2pHSGlCZmRHSlRtcXlLbktRdG9qS1FmaHVkc1d1SURi?=
 =?utf-8?B?QlN3SG01ek1BWm90d0lHSnU4QmlPd0VQUnNxeEVzWUViWEdwa2l6VnhNMys0?=
 =?utf-8?B?K2RIWjZ4YVJXa2lTM3p3dEFkMnArNVByWVQrMm1nM3luQ1FSVSt2T1JRaTJ2?=
 =?utf-8?B?NENYdmxEVDZWeEpTVDNneW1SYUlJTjZJMlcyNUpicUtHTTVjVjlkTGtLV3l1?=
 =?utf-8?B?U1ozSXZNVHJRdk95Rm04WGpRWVpiMmFFQjlvK2lXdk51MzJBa04vQnNwUTVu?=
 =?utf-8?B?emRqUk1QNGlWckcvQjdleHk5YVFWN1U1dlBkOUlIT2VVeXZ3d3U0bms3N3RL?=
 =?utf-8?B?R0wxdGx6Y3RMb1hYY3c2enBrVWRmSkZxQUREakVnL0FOWTFxWkVwRTNJbEk5?=
 =?utf-8?B?clptREorU0dlcG5BRnBHU0ZKRCtydXM5UnYrUWltMkhIY0lBaFFoZ1JqNHQ3?=
 =?utf-8?B?VGRWc25JT01zVlJ4ak9BdVVUNHd0ZzRCeHFkb0hXWS9wSjZlSVhJS0ZPOFhC?=
 =?utf-8?B?QlJPTXZkMGJ4WUxuQUh0Q0t6WW9wU000blA2aS80dFYxWnI4VmRzNndaTWQ5?=
 =?utf-8?B?dC82SHMrYjIxQVVJU2xnNWtXNjkyMEdaOVkxS3ZyLzMwR2RJM2FvRGdHQ0VJ?=
 =?utf-8?B?NlhUc0ZPNzVBV0pFZC92TGFxeG1WL3ZqcmsrWm1GZ0dBaEFrMzlJUUJGUEJ0?=
 =?utf-8?B?Q0tVeDhQNHI2OG03QkU0VjB4NXhCczNoZTdyYkdVVFRnN3ZRcXhkcURoNW5y?=
 =?utf-8?B?cE10QzBRS2w1QnduWFIvY2xWSUF4aEpJUnlnYUVNbGEydVNBamZxbmRlZEUy?=
 =?utf-8?B?eGNvdWhyYkxnaHBSRlFxRTgrZ2dOeE4zc0JuMFR6Y1JWeVlNRncvREFyT2Nm?=
 =?utf-8?B?THRhbHhEU0xmdlRUUUpIdk5hNFpkQXFlSkppdFRTYm5rdTgxdEZ1WGswZksy?=
 =?utf-8?B?VFFCd1NJZHpWRitraUJ0d21qUzNWTlNJUVZ2cUhiR2V5NWZxS0tBUHJwWGhm?=
 =?utf-8?B?Mlg4QTdUL0Ric3JyUUxuMy9PbHYzMW83bXZja0I0R25rV0dWYmxLUktnZ1J0?=
 =?utf-8?B?Z0s5OGRjZDdBTjJraCtqOTNXSGt3aFBYcW40NFM3LzZVM0VibVpUbXVpNldl?=
 =?utf-8?B?WGdxaUVLbzNjK2tMN3BzNmdDNmRCdUlKQTN1REpFV2NtL3loYnlxdFdDbzdN?=
 =?utf-8?B?MURNdkpwRWE4N2YzLzFXN0FGeUhxNXB5QitkbFZqcXUvUXFDcjdkRGYyTEtM?=
 =?utf-8?B?RC9aZnVUbHlKRVQ4V0hxTmpLVkdWUjJ5Q1ppd3JCd2gwNnBWdC9qVUJVMHpK?=
 =?utf-8?B?VmVYdEVSVEd2dEdjNFZoaFdVVVpKRXRhZUFjenY3cVM1cUVWeEUyRGZBT0pp?=
 =?utf-8?B?TU9VYXFaOUoyY2dvd3BOYzlDMmN6MEZYOEVxT2I5NkJydzVrSHBSSnVPQU1m?=
 =?utf-8?B?c1B6TUI1TTBDSDY1VHp2T2IyMUFManZCZTZIdWtBYmNTWkNoNzBodWlWWEpK?=
 =?utf-8?B?UHkvN3JTdVZodE5CNVovbi8rcHIyZmt6OGhXMXJHLzBqbUs0ZGdIRzBJUTZv?=
 =?utf-8?B?ODNGaDNXNGxTRkZtemxIZFVoT1NNakpUbEFIaFc3WGhUK3phNWY2bWliUjFL?=
 =?utf-8?B?NUc2UnlxNVhpeGx4ZFZ4Z05PVmFUWVRtRUcwd2NZTmM5N3J2d1E4WDdld0lr?=
 =?utf-8?B?M2liU3E1alRnRWlKTkhndjZvbWhyTVMzOVREV3hnOE9SR0svUmRyWTIreVRP?=
 =?utf-8?B?akhiN2ZIQ0gva2lFUTFnbnB2VEpDWU1POURJT3Y4ZlNXSEFxaktLVWdEVTF5?=
 =?utf-8?B?QVlYYWlYN3M5N2EzNUsraFN0VXJONXJaWU5mR2V3WVRVZkp2ZGVJdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4c014a-a248-43cc-3951-08da134c7ef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 19:27:29.2692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5uTajmqGxt7mTQiV9pD0/aTkOD6vBuxotIMgcct863pCyakfNv9AmCvB/G17XGBrhrghCqbRLmyRCdb3gzcyEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4434
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBBbmR5IFNoZXZjaGVua28gPGFu
ZHkuc2hldmNoZW5rb0BnbWFpbC5jb20+IA0KU2VudDogU3VuZGF5LCBNYXJjaCAyNywgMjAyMiAx
OjAwIFBNDQpUbzogQmVuamFtaW4gU3TDvHJ6IDxiZW5uaUBzdHVlcnoueHl6Pg0KQ2M6IEFuZHJl
dyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFNlYmFzdGlhbiBIZXNzZWxiYXJ0aCA8c2ViYXN0aWFu
Lmhlc3NlbGJhcnRoQGdtYWlsLmNvbT47IEdyZWdvcnkgQ2xlbWVudCA8Z3JlZ29yeS5jbGVtZW50
QGJvb3RsaW4uY29tPjsgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4IDxsaW51eEBhcm1saW51eC5v
cmcudWs+OyBsaW51eEBzaW10ZWMuY28udWs7IEtyenlzenRvZiBLb3psb3dza2kgPGtyemtAa2Vy
bmVsLm9yZz47IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT47IFRob21hcyBH
bGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPjsgSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhhdC5j
b20+OyBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT47IERhdmUgSGFuc2VuIDxkYXZlLmhh
bnNlbkBsaW51eC5pbnRlbC5jb20+OyBILiBQZXRlciBBbnZpbiA8aHBhQHp5dG9yLmNvbT47IE1v
b3JlLCBSb2JlcnQgPHJvYmVydC5tb29yZUBpbnRlbC5jb20+OyBXeXNvY2tpLCBSYWZhZWwgSiA8
cmFmYWVsLmoud3lzb2NraUBpbnRlbC5jb20+OyBMZW4gQnJvd24gPGxlbmJAa2VybmVsLm9yZz47
IDNjaGFzM0BnbWFpbC5jb207IEhhcmFsZCBXZWx0ZSA8bGFmb3JnZUBnbnVtb25rcy5vcmc+OyBB
cm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsgR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hA
bGludXhmb3VuZGF0aW9uLm9yZz47IE1hdXJvIENhcnZhbGhvIENoZWhhYiA8bWNoZWhhYkBrZXJu
ZWwub3JnPjsgTHVjaywgVG9ueSA8dG9ueS5sdWNrQGludGVsLmNvbT47IEphbWVzIE1vcnNlIDxq
YW1lcy5tb3JzZUBhcm0uY29tPjsgUm9iZXJ0IFJpY2h0ZXIgPHJyaWNAa2VybmVsLm9yZz47IExp
bnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz47IEJhcnRvc3ogR29sYXN6ZXdz
a2kgPGJyZ2xAYmdkZXYucGw+OyBtaWtlLm1hcmNpbmlzenluQGNvcm5lbGlzbmV0d29ya3MuY29t
OyBkZW5uaXMuZGFsZXNzYW5kcm9AY29ybmVsaXNuZXR3b3Jrcy5jb207IEphc29uIEd1bnRob3Jw
ZSA8amdnQHppZXBlLmNhPjsgUGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz47IERtaXRyeSBU
b3Jva2hvdiA8ZG1pdHJ5LnRvcm9raG92QGdtYWlsLmNvbT47IEthcnN0ZW4gS2VpbCA8aXNkbkBs
aW51eC1waW5naS5kZT47IEJlbmphbWluIEhlcnJlbnNjaG1pZHQgPGJlbmhAa2VybmVsLmNyYXNo
aW5nLm9yZz47IEZyZWRlcmljIEJhcnJhdCA8ZmJhcnJhdEBsaW51eC5pYm0uY29tPjsgQW5kcmV3
IERvbm5lbGxhbiA8YWpkQGxpbnV4LmlibS5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJl
bmkgPHBhYmVuaUByZWRoYXQuY29tPjsgTmljb2xhcyBQaXRyZSA8bmljb0BmbHV4bmljLm5ldD47
IExvaWMgUG91bGFpbiA8bG9pYy5wb3VsYWluQGxpbmFyby5vcmc+OyBLYWxsZSBWYWxvIDxrdmFs
b0BrZXJuZWwub3JnPjsgUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBCam9ybiBI
ZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPjsgbGludXgtYXJtIE1haWxpbmcgTGlzdCA8bGlu
dXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnPjsgTGludXggS2VybmVsIE1haWxpbmcg
TGlzdCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IExpbnV4IFNhbXN1bmcgU09DIDxs
aW51eC1zYW1zdW5nLXNvY0B2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1pYTY0QHZnZXIua2VybmVs
Lm9yZzsgQUNQSSBEZXZlbCBNYWxpbmcgTGlzdCA8bGludXgtYWNwaUB2Z2VyLmtlcm5lbC5vcmc+
OyBvcGVuIGxpc3Q6QUNQSSBDT01QT05FTlQgQVJDSElURUNUVVJFIChBQ1BJQ0EpIDxkZXZlbEBh
Y3BpY2Eub3JnPjsgbGludXgtYXRtLWdlbmVyYWxAbGlzdHMuc291cmNlZm9yZ2UubmV0OyBuZXRk
ZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1lZGFjQHZnZXIua2VybmVsLm9yZzsg
b3BlbiBsaXN0OkdQSU8gU1VCU1lTVEVNIDxsaW51eC1ncGlvQHZnZXIua2VybmVsLm9yZz47IG9w
ZW4gbGlzdDpIRkkxIERSSVZFUiA8bGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1p
bnB1dCA8bGludXgtaW5wdXRAdmdlci5rZXJuZWwub3JnPjsgb3BlbiBsaXN0OkxJTlVYIEZPUiBQ
T1dFUlBDIFBBIFNFTUkgUFdSRklDSUVOVCA8bGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmc+
OyBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc7IHdjbjM2eHhAbGlzdHMuaW5mcmFkZWFkLm9y
ZzsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBsaW51eC1wY2lAdmdlci5rZXJuZWwu
b3JnDQpTdWJqZWN0OiBSZTogW1BBVENIIDA1LzIyXSBhY3BpY2E6IFJlcGxhY2UgY29tbWVudHMg
d2l0aCBDOTkgaW5pdGlhbGl6ZXJzDQoNCk9uIFNhdCwgTWFyIDI2LCAyMDIyIGF0IDc6MzkgUE0g
QmVuamFtaW4gU3TDvHJ6IDxiZW5uaUBzdHVlcnoueHl6PiB3cm90ZToNCj4NCj4gVGhpcyByZXBs
YWNlcyBjb21tZW50cyB3aXRoIEM5OSdzIGRlc2lnbmF0ZWQgaW5pdGlhbGl6ZXJzIGJlY2F1c2Ug
dGhlIA0KPiBrZXJuZWwgc3VwcG9ydHMgdGhlbSBub3cuDQoNCkRvZXMgaXQgZm9sbG93IHRoZSBj
b252ZW50aW9ucyB3aGljaCBhcmUgYWNjZXB0ZWQgaW4gdGhlIEFDUEkgQ0EgcHJvamVjdD8NCg0K
Tm8sIGl0IGRvZXNuJ3QuIEFDUElDQSBtdXN0IHdvcmsgd2l0aCBtYW55IGNvbXBpbGVycywgc29t
ZSBvZiB3aGljaCBhcmUgcmF0aGVyIG9sZC4gU28sIHdlIGRvbid0IHN1cHBvcnQgdGhlc2UgaW5p
dGlhbGl6ZXJzLg0KQm9iDQoNCi0tDQpXaXRoIEJlc3QgUmVnYXJkcywNCkFuZHkgU2hldmNoZW5r
bw0K
