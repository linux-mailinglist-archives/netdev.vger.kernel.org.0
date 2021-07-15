Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129BC3CAD1C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344005AbhGOTxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 15:53:24 -0400
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:35676 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243234AbhGOTw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 15:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1154; q=dns/txt; s=iport;
  t=1626378602; x=1627588202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z6m6Un9/zaXrP4lVmGsllunr2/WG+XxGyhhXGuMXXxE=;
  b=OvdGa4N+mqZmo5WMJNOMuOZ95Nw9Rqqt+iaKoxG/QOHW2G1lUHACWxGh
   6cKaidMD0AC4USkGyxG8bTc+ifZZwKN3KN4e0nSsFDmU+gJR09rSEV145
   lJDqk6NvnaIF70wyACuW4ZnS2paarZMK+Atzh/bG5TsEFUOWRspuXNN+A
   g=;
IronPort-PHdr: =?us-ascii?q?A9a23=3A3S1mgxYof+tv033UpLlxJCf/LTAxhN3EVzX9o?=
 =?us-ascii?q?rIkhqhIf6Dl+I7tbwTT5vRo2VnOW4iTq/dJkPHfvK2oX2scqY2Av3YPfN0pN?=
 =?us-ascii?q?VcFhMwakhZmDJuDDkv2f/3ndSo3GIJFTlA2t32+OFJeTcD5YVCaq3au7DkUT?=
 =?us-ascii?q?xP4Mwc9Jun8FoPIycqt0OXn8JzIaAIOjz24MttP?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AoVV/oquZ+382Ll8BX4c5ehau7skCIIAji2?=
 =?us-ascii?q?hC6mlwRA09TyXGraGTdaUguyMc1gx/ZJh5o6H+BEGBKUmskqKceeEqTPSftX?=
 =?us-ascii?q?rdyRWVxeZZnMnfKlzbam3DH4tmtZuIHJIOc+EYYWIK6PoSpTPIb+rIo+P3tZ?=
 =?us-ascii?q?xA592utUuFJDsCA8oLgmsJaXf4LqQ1fng6OXNTLuv72iMznUvZRZ1hVLXDOp?=
 =?us-ascii?q?BqZZmmm/T70LbdJTIWDR8u7weDyRmy7qThLhSe1hACFxtS3LYL6wH+4kjEz5?=
 =?us-ascii?q?Tml8v+5g7X1mfV4ZgTssDm0MF/CMuFjdVQAinwizyveJ9qV9S5zXcISaCUmR?=
 =?us-ascii?q?AXeev30k8d1vdImijsl6aO0EHQMjzboW8TArnZuAKlaDXY0JDErXkBert8bM?=
 =?us-ascii?q?piA2vkAgwbzY5BOGYh5RPJi3KRZimwwhgVruK4JS2D3CCP0AkfuP9WgHpFXY?=
 =?us-ascii?q?QEbrhN6YQZ4UNOCZ8FWDn38YY9DYBVfY7hDdttAB6nhkrizyVSKR2XLz0ONw?=
 =?us-ascii?q?bDRlJHtt2e0jBQknw8x0wExNYHlnNF8J4mUZFL6+nNL6wtzdh1P44rRLM4AP?=
 =?us-ascii?q?1ETdq8C2TLTx6JOGWOIU7/HKVCP37WsZb47Lg8+envcp0Vy5k5nojHTTpjxC?=
 =?us-ascii?q?APUlOrDdfL0IxA8xjLTmn4VTPxyttG75w8obH4TKqDC1zIdLnvqbrqnxw7OL?=
 =?us-ascii?q?ysZx+eAuMjPxbTFxqnJW8S5XyKZ3B7EwhobPEo?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CpCQBckPBg/5BdJa1aHgEBCxIMQIF?=
 =?us-ascii?q?OC4FTUQd3WjcxhEiDSAOFOYhZmjCBLhSBEQNUCwEBAQ0BATUMBAEBhFQCF4J?=
 =?us-ascii?q?kAiU2Bw4CBAEBARIBAQUBAQECAQYEcROFaA2GRgIEEhERDAEBNwEPAgEIGgI?=
 =?us-ascii?q?mAgICMBUQAgQOBSKCSwQBglUDLwEOmyIBgToCih96gTKBAYIHAQEGBASFQhi?=
 =?us-ascii?q?CMgmBECqCe4QOhmInHIFJRIE8HIIyMD6CSxcDgSoBEgEhgxc2gi6CLIIqAQG?=
 =?us-ascii?q?BaY0hiBYBRqd9CoMkijSNJIZeBSaFKqExojiYVwIEAgQFAg4BAQaBYgMxDVx?=
 =?us-ascii?q?wcBVlAYI+CQk+GQ6OHzeDOoUUhUpzAjYCBgoBAQMJiUIGgWJfAQE?=
X-IronPort-AV: E=Sophos;i="5.84,243,1620691200"; 
   d="scan'208";a="895542083"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 15 Jul 2021 19:49:58 +0000
Received: from mail.cisco.com (xbe-rcd-006.cisco.com [173.37.102.21])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 16FJnwPq025349
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 15 Jul 2021 19:49:58 GMT
Received: from xfe-rcd-001.cisco.com (173.37.227.249) by xbe-rcd-006.cisco.com
 (173.37.102.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 15 Jul
 2021 14:49:58 -0500
Received: from xfe-rcd-003.cisco.com (173.37.227.251) by xfe-rcd-001.cisco.com
 (173.37.227.249) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 15 Jul
 2021 14:49:58 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xfe-rcd-003.cisco.com (173.37.227.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15
 via Frontend Transport; Thu, 15 Jul 2021 14:49:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZj4Lg8xfVw1//cWfq48HZ1DC/Rgxs/DLzn4IRtH52igPrx4GRTYG8e79/Fq6o2CAwsdmE5XbkwsNwuKcZvFkTqYkxYNKHipYbTFqOPJ9FHSMEbTjtwEBzUq9XgtezB7HyzHthUw+8tuSl+nnAdsQOwN4ihd49U0yrNvMoufbZNUwiXuCdPxZdZZW7k5pyg5EvAbBTxM7ylt9pb5IVkMNYWIoMjGTBF2nP3bHP0HeI0tv6/zrfRtigviIKVpSo0jH2a61Vc0L17/BLemaGFRwuHZI40t6MvkVuPl+fkRP1dq8vvSIJcLl5FR3QZdjL66EbCxZGkmMa/eAfH8fvYICg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6m6Un9/zaXrP4lVmGsllunr2/WG+XxGyhhXGuMXXxE=;
 b=hSCnRFGxsNTRMoVVjwPh6mQTLoo9nsOmSPcfk0RGrBQ6X/3jQxeGGHTp3QejsYX6Kb49ss8ZsBYhkDzm5ulmyH7Xp0TBkTDwmQHj66PF1xYWV3ukwEKZkzT4Avd4cxqLDfBN4b8vFPALGCNcdpLpgEreEhaTRpqWDAg564G/G0PP61Dy1SZO7rU+gQs7/pIlN376CuJZvV92mZLDef9mNELr2YqnoDgJGczBatrBDK6RopugEd5vS/nc3V6KwV6j5hv312ztcpm+kHdSp+aHfeeT+LuSH2a/l0xJwT2izNiAnzg5VUdGSFI18DvzWqy8ZrvzCK98SlrEPLmyuyMPrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6m6Un9/zaXrP4lVmGsllunr2/WG+XxGyhhXGuMXXxE=;
 b=O+oq+BkmeFeNGrViKHvx3G2PrJsRXiFYb3j1fFiTnDT2202NABusNv0ev0lAFciYuurDTCScw8ZoMQM/9sXfrhAhssQUYFqcIEeS1yDeYQoTkT1rm5V6tWq9po+9dwxIxV0M6WLQHC6mYWMvgJ9OhW48KxN9e3YiyVijiU19w1g=
Received: from BYAPR11MB3527.namprd11.prod.outlook.com (2603:10b6:a03:8b::26)
 by BYAPR11MB3384.namprd11.prod.outlook.com (2603:10b6:a03:75::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.25; Thu, 15 Jul
 2021 19:49:56 +0000
Received: from BYAPR11MB3527.namprd11.prod.outlook.com
 ([fe80::8805:aed5:fbfa:e02a]) by BYAPR11MB3527.namprd11.prod.outlook.com
 ([fe80::8805:aed5:fbfa:e02a%4]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 19:49:56 +0000
From:   "Billie Alsup (balsup)" <balsup@cisco.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guohan Lu <lguohan@gmail.com>,
        "Madhava Reddy Siddareddygari (msiddare)" <msiddare@cisco.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sergey Miroshnichenko <s.miroshnichenko@yadro.com>
Subject: Re: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
Thread-Topic: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
Thread-Index: AQHXeYB6FVfPjF670EajPRVp4GveDatEEn+AgAATp8qAACBqAP//mwIAgACBwoD//5l9gA==
Date:   Thu, 15 Jul 2021 19:49:56 +0000
Message-ID: <0480940E-F7B9-4EE3-B666-5AD490788198@cisco.com>
References: <545AA576-42A5-47A7-A08A-062582B1569A@cisco.com>
 <20210715185649.GA1984276@bjorn-Precision-5520>
In-Reply-To: <20210715185649.GA1984276@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.51.21071101
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cisco.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57ea2201-e1e5-4963-2a9a-08d947c9b8ea
x-ms-traffictypediagnostic: BYAPR11MB3384:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB33844AB4B79C0F9B20BE5AB5D9129@BYAPR11MB3384.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DtEwb4ikaahUp6wHluo5yj/KZfPuJjH+NJdiMA3Rn8H3mbPAMxGjOeBhGf9A9IaR6SstPRySWEbIIzQ86rr8MEjGbCJ1U1ZU+Mvgk6IXlgybmchx3X6HEiTIJCMLMmPEWZ/ry0DxrjVUUGUosHq2wU4Rb4m6QnKsTT5IDOOzgxD4V2Mr8pneZ9iM6aWD4m5UJCXv2AASqsDKV24kEGmXn6DDC2/OVlHOpqNe4Tgr/MMaVu+ZhyMjrVGX7zOvojJZjJpsjfrVH4mK8YRgS4PcJk4PBiMB1ZQiWfCcBNyI9YPgw41JakwOuBNRfGlVUx+1ojRk1B+m1A+ohrvQwF5u7+mFgwN/ofrcP9ZY0B694/2adTDB/eL/IQpbaxDray1qNfcWR+IfXbjQgTCpFwmT5RgYKppZOkgHyFKpTHDzTbEOYp9A2xLjYi/CN8B5sQdxM9+JZDm/xNpcMjnSJm+wgr5BlCKKB9cfUD6OIe3pKpuIbkzF5aqnn6sk0Hap29HR99NovB9PvsCPHL+JiHBE9Af8I8tozuJglWdYGV1cs5ZLBsEteUAKLu8LYRM2oAhwloiIMJDZ+WvKj6linivwOonx6/leqysBFji6v64S9xfnpUlrnBfOj7VGajjbpC4VONMbEXVmuugdQlKmcm736JZ5gfXyiqMqAxNx2vQFYBBo0JxRtrlh40rW24drF1A79gfJd9/0mKfgwv8gX60GjxiObwQlwKkyP73iCq8NFTCQG7pK9tS18Vk6OnunT3CHrUhGRUxaTdbzTxL19/MZmF4Tdi8Wib2HhK94Cz/BQUdKjUafQ2YSzoEDhfB1PIKb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3527.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(39860400002)(346002)(6512007)(66446008)(64756008)(66556008)(54906003)(66476007)(8936002)(316002)(4326008)(33656002)(8676002)(6916009)(76116006)(66946007)(36756003)(38100700002)(2906002)(122000001)(83380400001)(4744005)(2616005)(7416002)(45080400002)(6506007)(5660300002)(86362001)(6486002)(71200400001)(478600001)(186003)(38070700004)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWx3VjdURTRBdysxcVNkSkxNQmJxa0xjNEk5cit5Z3BaeElTREZmTkFaQXBD?=
 =?utf-8?B?Z1lPQ0lrNXJ2ZTlVeXhQNGhuQVVYN2pSbWMvRTVvamxpODJ0UUJsM2Vnbmp3?=
 =?utf-8?B?VkZZTGx4bU9OV0ZkR002SldETWJ3ZjR6Sk1sWFV1SzZKSEpxZERuTkwwdG9V?=
 =?utf-8?B?SDVvZXBDTlpOSExkaTJPaVRlRFFEQWhJT3RxR3Rlek5VT2NCQUxYai9wcWRl?=
 =?utf-8?B?c2g1d3duY0wxRlpXVmpJRUtDZFFwSWVSMFNOVVRRL0NCckxxa0c3bXRhaWJK?=
 =?utf-8?B?QmRCbFZOa0p3eWdRMzBUc0QwZzdlUU1mdUF6dG9VeHJabXBsaFZOVDE5REd1?=
 =?utf-8?B?K0FneWFud3ZpajM4dlQ5cndIQkZJRlAxR1F6S3pUYzFHVGlablgzZjUzSkYr?=
 =?utf-8?B?cng3ZzhXcGE3UmdBU1RJdnlYWlJKRVJ6dStaS0RmQisxZDErYUh4dHN6aWo0?=
 =?utf-8?B?Wm03VUo0U1gwRjk2MHFTZ0Rad3hTZlNOMWJJMkFmRjVSTGZWcENwdUQvN1VQ?=
 =?utf-8?B?WDA3V3N2VTEwMS8wdVZwQnNha1hLSVU0UWdkMndVeC95TGtxejZuWkFrbmNX?=
 =?utf-8?B?SEhKaU5rSm9xZVpPNU5WTU0wclVaalNCOFkyYUx4WGoyQjRaVjZGbFY3Qkgy?=
 =?utf-8?B?a0l0WGRLQWM1NDVDMm8yMFdMQVM0UU5pSHpqem9XK0ZyL3RFN1plMXFoQ3lE?=
 =?utf-8?B?dCtndm96QXNPLzczaFEyeDhBOHZzdWVqMWxKMHppSDhZOXZnUTlVQXAxaFVt?=
 =?utf-8?B?RVZOd0ZYRWt1Sm5wUWlMSFNhcEMwSjc0ZkVZRHZMZ1VWeTFyblF2TkpBL1hs?=
 =?utf-8?B?U3hRbm96ZXprK2VZOEE2a0tIOHphTFJwQmpDZExTYWNVMkNLclR2UGhxVzU1?=
 =?utf-8?B?Nm5lQm4yMVVSaVkvOW1vb1dWVzUxaDFLU3Y2Tk1CMVRsRStqTUM0UWE2NHV2?=
 =?utf-8?B?SUs5NXJCNGRNNzhwUENpUkpBSEQ2Mm9sZC9ZVFh3UURIOXNXc29DNzkyeXQ4?=
 =?utf-8?B?K25UTnZQVDZ1T1JsWDFVVXpTakEyT25OTHMvZzhOUUVsYkxYSkNiWUljVjJ1?=
 =?utf-8?B?UjZaNCs3b2o4VHFBT2hKM0FUdHZDZnpOa0kxWnIrbkxNS09lQ3dkQ3pTYjlw?=
 =?utf-8?B?dFhZQ29BWC9uSkRyUXJ4TkF3RGUwc0JxMlZqWTNHemNSS0pXUFBXSTZrOHJv?=
 =?utf-8?B?SjllSzN6dzkyZFhteCtHQnZEaUUwSzAxYU5SVDVXK1c0YmNERmZFTVdRSitX?=
 =?utf-8?B?UUlYdDBDVXUzNU1uVldmSFJWU1lxZzYvNlg3S2U1ZmI4YnpHWGZHY1g5VEdS?=
 =?utf-8?B?ZnI1dnRxT1g2ZndVK2pqb05vWVJnSCtMZGh1aWtuSHRWZHp4UEsyZjhJQ05F?=
 =?utf-8?B?SXlKOFZEY2tFQWYzbVBYa1krOHZISG0xOW1SaHo3TFdnMmh6UStMeTd2cmVK?=
 =?utf-8?B?YXByS29zQ0Q5b25KdXVJRjQyaFFrVW83NGlGUk5VaWxPT1h1b2hXQVlaWW51?=
 =?utf-8?B?RVNDZDA1Skx1czU0dDFGUk5SaDAzREpzR29lU3NWVnRRdGZBblRHOVUxSmFs?=
 =?utf-8?B?TnhwY1g5aVpFTGJpMVdic2JUOUJPcFZZVklmaVA1OXRrQlk2dnJKeC9XTnEx?=
 =?utf-8?B?bmVzNjcya0xzdUZxdXYwMW9nUDUwakJmOWMybEJ5K29xcEVsdEIrWnVYNDd2?=
 =?utf-8?B?VUMraWNDdy9KeFg1Y3BwRG91L1FMTVJlWXhTVXFYS0d0ejlJRUZVUDg2b0Js?=
 =?utf-8?B?MTNvUU42MVN6TGdUdFU2SDQ2cnZuVFAxOTNyWmZabXU4Zk8reWppNmxPUzd2?=
 =?utf-8?B?OUhJaVFCcE1NVjltcGlFeTQ1YVpKUTZjUlk2U2Fza3lNTUVjSXRETlBPQ1hw?=
 =?utf-8?B?Rm9YYjErQWRhRDB2N21sMEdQUUNGK3NUakRFV2ZZTVBBM2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6765426F0EBD1449F2CC5AFCA1915D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3527.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ea2201-e1e5-4963-2a9a-08d947c9b8ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 19:49:56.5168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4dzBiWLVjm21eXLcIESZDwz25lhBmkW+aAzKU0VhftwNEtX4QOjk7fW4Ow88X7Sgas0DVfxFHbNdTRnHRkI7hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3384
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.21, xbe-rcd-006.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCiAgICA+T24gNy8xNS8yMSwgMTE6NTcgQU0sICJCam9ybiBIZWxnYWFzIiA8aGVsZ2Fhc0Br
ZXJuZWwub3JnPiB3cm90ZToNCg0KICAgID5TaW5jZSB5b3UndmUgZ29uZSB0byB0aGF0IG11Y2gg
dHJvdWJsZSBhbHJlYWR5LCBhbHNvIG5vdGUNCiAgICA+aHR0cDovL3ZnZXIua2VybmVsLm9yZy9t
YWpvcmRvbW8taW5mby5odG1sIGFuZA0KICAgID5odHRwczovL3Blb3BsZS5rZXJuZWwub3JnL3Rn
bHgvbm90ZXMtYWJvdXQtbmV0aXF1ZXR0ZSANCg0KTXkgYXBvbG9naWVzLiBJIHdhcyBqdXN0IGNj
J2Qgb24gYSB0aHJlYWQgYW5kIGJsaW5kbHkgcmVzcG9uZGVkLiAgDQpJIGRpZG4ndCByZWFsaXpl
IG15IG1pc3Rha2UgdW50aWwgcmVjZWl2aW5nIGJvdW5jZSBtZXNzYWdlcyBmb3IgdGhlIGh0bWwg
Zm9ybWF0dGVkIG1lc3NhZ2UuDQoNCiAgICA+QlRXLCB0aGUgYXR0cmlidXRpb24gaW4gdGhlIGVt
YWlsIHlvdSBxdW90ZWQgYmVsb3cgZ290IGNvcnJ1cHRlZCBpbg0KICAgID5zdWNoIGEgd2F5IHRo
YXQgaXQgYXBwZWFycyB0aGF0IEkgd3JvdGUgdGhlIHdob2xlIHRoaW5nLCBpbnN0ZWFkIG9mIA0K
ICAgID53aGF0IGFjdHVhbGx5IGhhcHBlbmVkLCB3aGljaCBpcyB0aGF0IEkgd3JvdGUgYSBoYWxm
IGRvemVuIGxpbmVzIG9mDQogICAgPnJlc3BvbnNlIHRvIHlvdXIgZW1haWwuICBMaW51eCB1c2Vz
IG9sZCBza29vbCBlbWFpbCBjb252ZW50aW9ucyA7KQ0KDQpJIHdpbGwgcGF5IGNsb3NlciBhdHRl
bnRpb24gbmV4dCB0aW1lLiAgQWdhaW4sIG15IGFwb2xvZ2llcy4NCk91dGxvb2sgcmVhbGx5IGlz
IGEgYmFkIGNsaWVudCBmb3IgdGhlc2UgdHlwZXMgb2YgZW1haWxzIQ0KDQo=
