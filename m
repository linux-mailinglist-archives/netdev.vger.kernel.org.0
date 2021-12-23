Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2773A47DEFB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 07:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346587AbhLWGQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 01:16:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:31185 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhLWGQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 01:16:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640240183; x=1671776183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GVitA5QEbF0ZrjzHTrpIDFbkATDtvbvoZTe2RFkotgc=;
  b=EyQO47C19uKXD5EQVKidmCIqPioF1aNzik8e+zZeZQZu4Z+9zyyYQjoz
   69PRE2Ntu/JTnBvxTbWGO6ntn1nWurcZEPXtW1TMKWB91Wc32Tq+ugFUq
   6FgiirJGiWzJQAGYz3IK9u74McgadA+uutMvtS6oJ+Bq/cQk34mhF4iG2
   +DPYesKifEbjBGA7iWfebmtsZ4uykev1oRtPIK0DeK1FnDatB+YI7LeG3
   OHs806iEo4FGIHHXZSbIy5MrGV4mhGEVxBNwbi2gVpmKZnAwTi3u/niMe
   z2V3EEvhQbTLEtz/kbgsw0cpk77Rgwpq9tUDO8S+Yi+9IusPdobWcnB62
   A==;
IronPort-SDR: AIvBnlg/+UQsFWn1ul1vXdCtZjsNxCAHFfFNsYCutgc9sADiECXApaaOFVl9hm3d2yx7GkHkKM
 xNqCBfa9NN34wMndbIQ4O9qUlP6o+q5NDQnPJx7pFULjPVdj1aauRgCbEnZMKcntVkWY4u3y3e
 NYWp0TtrCbutx/dazaEyyg/IuKIYCS2xNm3ILnjeMwcN0K6bN8AYn5rboapm5ISLX54COS8MZP
 c5sRpxp8bT8HXm4liFYA+ShEiACT23wnkhc2Rwx2GSGkAyG5+744icxEKEn2a5FkzpfVrPqRk9
 6XdyjiKd5o2S6qnK9PaZ2R/2
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="140676230"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Dec 2021 23:16:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Dec 2021 23:16:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 22 Dec 2021 23:16:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPlIz/5GroDYL10PhZpZJ1fWyLck2zLN5JIwfhizHwP0k6+bpBF11utQ6wgH7deWO/MWLvc2Zl5eWfCfTQyRIgoDgJer8DRrrZaLvQJCI2lKWhFnw24zQaXYgVhlfGzkfDfFf/eyDZf4lxJc9dFgFKIn8KY7lWpDJjy/VQIkocljLbPbS8HnkKJWBcOWwtBMO8ygXKgrsfkQSSYxE2UE6tCVIDiRTM7U55k7AKk8VByjJpMOF6u/sf642GU3uk9UdeI9Npm+foyZYv8wj+8XltAl4VrSnTxEYoWyvjIzHUhXAXgYrPGZ1ZO0JknS8FrruOc4fmaLlXc7MINaMQpn4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVitA5QEbF0ZrjzHTrpIDFbkATDtvbvoZTe2RFkotgc=;
 b=J9ncdIU+eZALuBnzT3iGM4NiP3V2VCVMF2sCvcu4Y7wzIm/d0HUwl4q/cEzDVfAAJK4vqXkZ4Ko4OxacBn7DJk9Imt6HCSDhjMSNC3ztKjJ2GDVtcGAby2VpzUorwSmQ783QVB4b9xKGYfDVlv7eqcclj2R62zm0UO5qWCNqx8FtOGHcfVrZgGIBv8NyAlmZB7phiUYLcGmGE+a8RxosUoArWGLOgjOf/MK1WA0EyKddSn98Ms+hvZYfWBGT6uvTBV0JXP5Ds3V0KtJsoY2HOxULDN2Oe52PGLr3HQwclfAT0El40k90SZCnSeq5dikXhYqsFikmQ47342uih4b6RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVitA5QEbF0ZrjzHTrpIDFbkATDtvbvoZTe2RFkotgc=;
 b=DJvy8DGZpdL1uKeHFpHJEbfdCWu1TWkjy5i1CtrxSJ5smnQV8uB9J10acTbAopp+Xi1cnzOI1Zmbgeq8U+trdm8cCyg5HL1mrEWnNb6WZx8f03UbnOLTLbkJzJ3FFgqXDlK90/mMI9YbHgNAS3jCmjJvKYPXuHscFzg6oZ3kISM=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by BY5PR11MB4276.namprd11.prod.outlook.com (2603:10b6:a03:1b9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 06:16:17 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0%8]) with mapi id 15.20.4801.020; Thu, 23 Dec 2021
 06:16:17 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <davidm@egauge.net>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/50] wilc1000: rework tx path to use sk_buffs
 throughout
Thread-Topic: [PATCH v2 00/50] wilc1000: rework tx path to use sk_buffs
 throughout
Thread-Index: AQHX95pt5gQke/CIVkahHDmyKBCK26w/mfoA
Date:   Thu, 23 Dec 2021 06:16:17 +0000
Message-ID: <adce9591-0cf2-f771-25b9-2eebea05f1bc@microchip.com>
References: <20211223011358.4031459-1-davidm@egauge.net>
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c30daa07-9a56-4db5-ac3a-08d9c5dbbaf2
x-ms-traffictypediagnostic: BY5PR11MB4276:EE_
x-microsoft-antispam-prvs: <BY5PR11MB42768D9B50ADBD82FFB31A46E37E9@BY5PR11MB4276.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q0TRBn4YpbvdH70t6N7t/ibT01YFGjFg4ZkzMEj6FlhAYw3h30B67INdbpIWywx6rxpadJTO3TQeg6CezCWOKrk9xOf/orMlZZcasSWvv6AloNy2+4lcYQ4JzzVN6VuNXweMZl4IFDrb/QAisJKPxhfLMXbfYyhaQ6k9TNbTkYfxGhe9hRzCfF47aIlE9D/AZ0iDYNbE8PlmcisTyoBtVVPVjIQnF08eaC8EZhs1tb8R4gHcBh9YsH3v1FXYGeSkcfwb3doyZ4Mk6mOW1lzP3B1978sq1ZcXlnHVMQsmSbMxiy/ZNH6SNjuMk8hXwqNtBy9Omt8QehHQWVOBJ7og1kjUzoEp0yiGUpfCDkSwYh9OA4amr8E0YnmPV8gHowVSijCdl/E9+et2bYCizHVVE8Suf6HF7LTXRfxmwB3Jq8NgPcJk4B/UsFCFIly+zRGeyZyiAfKgDX4fQOkCDVe48dve/6IxLRCOI7j+e63DHVAMVq8682qPyYxkyvu7YroiZPZPkMguGWi8fImioe3HDfGOnlSiQcK4pTzP5V2nHxyopNbJq8gqEq8GZRTPZ8zvOh7j8YbfHRrSbpeg50sTc1WB6amUL3eUJGlAPEF2v+jP0LqFkfub/OGQkqh/Scy/Mqh+TOBolHdOvlXTVlAqrdUzD42BwUps/zIzce7EQnorYuqM26JDy4v2iDDUxTTN05qJ/GS2DTXd4xlwsphkDihntJYwCEk3n3bUoe9ab67R0FMK5fKOsu/XO54lISDNZ9CqZ7wRIOPC0roMS61JtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(6486002)(6506007)(55236004)(38070700005)(53546011)(2906002)(122000001)(31696002)(6916009)(36756003)(38100700002)(316002)(2616005)(5660300002)(4326008)(8676002)(6512007)(76116006)(86362001)(186003)(66946007)(66556008)(66476007)(91956017)(54906003)(508600001)(8936002)(26005)(31686004)(71200400001)(64756008)(66446008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3FQVkVXQzg5dGZqNGhhNjZhOC9sMlZFbU5IcHJJaFB6V2hFR3JnbVJ3QTR3?=
 =?utf-8?B?NWxXVVZpbWZrVGd2RXRDcnZCTmM3N0Y2QWxjUzdVWWhVUnBBYXN5RjVDWVpW?=
 =?utf-8?B?R2ZRV1BvTWd0N1B3ZXBCRXV1RkpWNjU0MDJYcElWOTVwNnVTWDJBdnNnY1Zw?=
 =?utf-8?B?cFk3MU01OExkR2NQU1ZaWFRUZk1YL2JhcVFmNGtIeEROeG03WHBqSHNaaDlK?=
 =?utf-8?B?cUl0TGFiK3d3citkeUF1a29XSTU4R2lhOGxyWThBVmRGM3dweUZKK0FuYXlk?=
 =?utf-8?B?cVYwV2RDMS80bUNoNW5RaFJuMlpTcVJUa21OZCt4YkpUUDk4aDEzZmVFRTFJ?=
 =?utf-8?B?aXRIV1RrY0xiZFpmbXJmVU5NZnB4ZjVySDNXQjFCTHc4S3ErNFF6TkpHNlMr?=
 =?utf-8?B?V2RSbHJwZFd1bXVmUzR3bDFueEtXY251VlgyU3NYTzBFcnp1LzY2dzR1SUw5?=
 =?utf-8?B?bWJBRU9kQ2h1MFBvYmNkeFh0Q2gyZjAzaXh3am1adHRNbTlwZDg4K01LR1Fn?=
 =?utf-8?B?bzFDZTdJbFZRVG11KytZZldjSjZPd2MyQVVkbTQ2d3pKUEJqYmgyOFdCYnEw?=
 =?utf-8?B?T0YxS1cxWnQzUHVsN2IxaGdhTUs3eExnbmg5T2JwMHVXMm1BeFYwMnJFbkdM?=
 =?utf-8?B?ckZabm1tczE3Smo5cTNpZGxFaVFoL0dLOG03Y2pLTXpwQm9MZW9EenJkUnlJ?=
 =?utf-8?B?dG01VDYyNzBpWWdUeU1NU05zSjN2RndlMWU2UzNueTJodXp4azY4NUZ5Skti?=
 =?utf-8?B?R0g5dGp3MWdXVXVQdDFyZkgvWUl5TksyTDFDTnE5QUROdHdnVXlkNW05NWdJ?=
 =?utf-8?B?aWtHRkV5OThBdkowUzFIT2lKYkdBdC9BdU9NWXZLakl0SmZYb0RPR1hqUnZB?=
 =?utf-8?B?ZGVweElydUtYUnJQOEdwbkdoVmhXeUQzSWJlQUdieXZHU3pzekpXeklEYzQ1?=
 =?utf-8?B?TTRFSXRvaytqR2ZoSnM1aXBDNHl1VG9IOW9mZmhSRnR2RktIRVB1cFIzUS9I?=
 =?utf-8?B?MFl3WkFNMWhHTU1STG84OW40di95OXQ2UEZNOVVma1gva2c2QUtzYVArQ2JY?=
 =?utf-8?B?M1M1S1lFa1lFdG40Zk9GQlJZMk5scWpGdHFNbjlsZWpJSDJtZmNCcEJkVWl2?=
 =?utf-8?B?QlQ0MkNUZmwyeWlMOXJVL1hSTHBtQXJHUnJSTDUxdUYvOXdwUWRMSFRsWUFR?=
 =?utf-8?B?TmpYNGlYbzhhWEhJSlFRb3I3eVdUK3hXTXlSUzYwY1liRTlhNE1lRUFWVWxn?=
 =?utf-8?B?M01hTnVnMnZMeTVoUUE2MW5BQldlNWZUdnluTGkvMGtQbU5WT2diUHJsNXZK?=
 =?utf-8?B?T0RDaU5RZTNCOFhyT3VhM0J0VC9rR2tEQ2lOWXlxcjh2VGZRQ2JkajBTbTlN?=
 =?utf-8?B?WnV0bjVuVzNRZFV1V0VSK25Bb3dOUFE0SEpydi9KY1gvdUwvYWxZbFkrU0VZ?=
 =?utf-8?B?RFFiZUFuWGVEUTVPUDRVNDZtVDhtTWJiZjN1a3Z0eHkzaTAwTWlPRVF2TnF0?=
 =?utf-8?B?VHl5WGx4SHVzZmVENG9CYVplNm12U0RmaHFraTU5L1AwTU9KSGo0N2Naa2Zo?=
 =?utf-8?B?am5wREh5VzMwTjhOT0svSnh0L0VJWW02QnFsRE1BL01Pa3BpRm1LWG1GZW5a?=
 =?utf-8?B?T2JOQktOWWF3dm5jWjNYY2w0Szd3czAyMFNLdDlHb1U0WTNmbWVCQnF0STJo?=
 =?utf-8?B?ZzhzT3dvdE1FUFF4bDkxZ2dMOGhpT29WVDFyV1ZnWXUwK3BIQlQ5L0g4SCth?=
 =?utf-8?B?VWNpQUtMMVdQWVBkQXh2WTFhVHVjZjVFV1JpRHJuOVlISmd4S0Q5aWxlNng4?=
 =?utf-8?B?Snk2WHZYVm5mL1F3cGdOWDNVNEVhR2JxMlYyU3BUb0dqRkQ1ak04ajFPcmlI?=
 =?utf-8?B?ZHN6bHFGU3BoVWQrSmV0NmViTlJpVjlRdWZ4bDE2Qlppd1duV3NwTDFmNnRG?=
 =?utf-8?B?eVd1WE5ESnRyTUkrbE5uZnBkdG5oSDFyelI4L3lpcUFlYkRpaWhrY2J2NFJL?=
 =?utf-8?B?cVhsaTVaVW5qeEdzVDA5T01UL3ZYcjU5TEZRMFE4SWhlRXpNSjcvQzlCaVU4?=
 =?utf-8?B?dXRLdExwK3IxTWVQMXJCYms3ZWU3Mkt6cEw3OWhKS3licjZmNjJSYlFhdzRK?=
 =?utf-8?B?dG9GZmF1Tm44Z0lSR1MzaWdKNVBLeG5vbTBJY28wTlZXcld6ZytBWGRBTUVI?=
 =?utf-8?B?dllsVUZmcFlCRUZUanNCOXd1TDJtRWpQSWxnOVhqUnFpNnZxMkhiK3Z0WWJL?=
 =?utf-8?B?RTREVU1acitEdEZ2akNyOHdiODV3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52830BB48CD00043AC02DB6A615C68B4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c30daa07-9a56-4db5-ac3a-08d9c5dbbaf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2021 06:16:17.3247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DhXVzMYqmGCKJuoufz5K4o1Ytm8oU035S/wg6UQZP0snXkW9oeNDRY5RqrGHisqHYyS2ddBMwAvXb1AK7kHf2ZdgGfo6FIw72dBt9g1AH+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4276
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjMvMTIvMjEgMDY6NDQsIERhdmlkIE1vc2Jlcmdlci1UYW5nIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gT0ssIHNvIEknbSBuZXJ2b3VzIGFib3V0
IHN1Y2ggYSBsYXJnZSBwYXRjaCBzZXJpZXMsIGJ1dCBpdCB0b29rIGEgbG90DQo+IG9mIHdvcmsg
dG8gYnJlYWsgdGhpbmdzIGRvd24gaW50byBhdG9taWMgY2hhbmdlcy4gIFRoaXMgc2hvdWxkIGJl
IGl0DQo+IGZvciB0aGUgdHJhbnNtaXQgcGF0aCBhcyBmYXIgYXMgSSdtIGNvbmNlcm5lZC4NCg0K
DQpUaGFua3MgRGF2aWQgZm9yIHRoZSBlZmZvcnRzIHRvIGJyZWFrIGRvd24gdGhlIGNoYW5nZXMu
IEkgYW0gc3RpbGwgDQpyZXZpZXdpbmcgYW5kIHRlc3RpbmcgdGhlIHByZXZpb3VzIHNlcmllcyBh
bmQgZm91bmQgc29tZSBpbmNvbnNpc3RlbnQgDQpyZXN1bHRzLiBJIGFtIG5vdCBzdXJlIGFib3V0
IHRoZSBjYXVzZSBvZiB0aGUgZGlmZmVyZW5jZS4gRm9yIHNvbWUgDQp0ZXN0cywgdGhlIHRocm91
Z2hwdXQgaXMgaW1wcm92ZWQofjFNYnBzKSBidXQgZm9yIHNvbWUgQ0kgdGVzdHMsIHRoZSANCnRo
cm91Z2hwdXQgaXMgbGVzcyBjb21wYXJlZCh+MU1icHMgaW4gc2FtZSByYW5nZSkgdG8gdGhlIHBy
ZXZpb3VzLiANClRob3VnaCBub3Qgb2JzZXJ2ZWQgbXVjaCBkaWZmZXJlbmNlLg0KDQpOb3cgdGhl
IG5ldyBwYXRjaGVzIGFyZSBhZGRlZCB0byB0aGUgc2FtZSBzZXJpZXMgc28gaXQgaXMgZGlmZmlj
dWx0IHRvIA0KcmV2aWV3IHRoZW0gaW4gb25lIGdvLg0KDQpJIGhhdmUgYSByZXF1ZXN0LCBpbmNh
c2UgdGhlcmUgYXJlIG5ldyBwYXRjaGVzIHBsZWFzZSBpbmNsdWRlIHRoZW0gaW4gDQpzZXBhcmF0
ZSBzZXJpZXMuIEJyZWFraW5nIGRvd24gdGhlIHBhdGNoIGhlbHBzIHRvIGlkZW50aWZ5IHRoZSBu
b24gDQpyZWxhdGVkIGNoYW5nZXMgd2hpY2ggY2FuIGdvIGluIHNlcGFyYXRlIHNlcmllcy4gVGhl
IHBhdGNoZXMoY2hhbmdlKSBtYXkgDQpiZSByZWxhdGVkIHRvIFRYIHBhdGggZmxvdyBidXQgY2Fu
IGdvIGluIHNlcGFyYXRlIHNlcmllcy4NCg0KDQpSZWdhcmRzLA0KQWpheQ0KDQo=
