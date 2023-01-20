Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3676752BD
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjATKrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjATKrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:47:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A6610D1;
        Fri, 20 Jan 2023 02:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674211657; x=1705747657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q4+1o05pX03uDwR9uXiI5+uCXQWUarTFnmLL0s81bCc=;
  b=gsqfxk9dwe3TfvrFnGylklglV3ahw/N3SOWLq91GJsaYMCrb8Vi4dSg2
   K3JV0iz6QCkbo/cNS+ptTPvvkfy+ATb/gaE9gZZq/mWXqNJBtm8D9TMVu
   ECkbmJ3x1a3CKHoMIcg4QI4Ilb3+52kV5VJD7b7bAQtaOHqFd9avX/V5y
   ZcSm7B/ip5J5wBKu2BdzRPSZJOBMYxcveEkGUg09wNl+CZIawhbeoXLhi
   kQbXi9ZiVzX3tsfsH209/XiwRduk70pZE87KyakdlxHzINYN8gs4fBzjj
   jGQUoyG9BegjZRMehQFo+1IY96q2aISLugM1ctoFYdtuvTxMrK4XONUPV
   w==;
X-IronPort-AV: E=Sophos;i="5.97,232,1669100400"; 
   d="scan'208";a="208617019"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 03:47:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 03:47:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 20 Jan 2023 03:47:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVHbvJQyu29a169Sxv/j8O/HsVSFP99lP7S3OI3fDHuJm3P9wVP0F0mwCcsGZ2t5GYXmEIXRXuRLhuF3SZ+EBoMwJ7Qqz6ZqsHQJ9hdXkJto2iAMb8CB84pyeUtzmkyKqJkDqyHAcsxs5FkWlLWCkZBN39qNkhKBDyFN78b3HxMUM+9EHd0aIv+WvNdgwMdc1qhTQnvqWG/iIUEF5y6z9desmtPmR7+JbEHYSmUc26ru6v3tiypO8+sFAT3ujl9Mf9aJNIeIq7mRzeUlFZ2pAKvUrIx6y0jEPQ3Ql4aHd1MaxdPuPuBZ6GYx0gbCywysxTh5oxJ/RBlRlT5cYl5Ndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4+1o05pX03uDwR9uXiI5+uCXQWUarTFnmLL0s81bCc=;
 b=AgO3QGJ+MydgsnZCNbGrKDR49wL87Gvev0zUikF6OwVDIeW9eLQwcf9ClM7q09K9bgQDn8SpKkA/iF+el83FdVyLPrM4QRbGeeNNpeFuUHkcoo6gVryMidqzYBvdUPHB5oLyG6a+v02omay4Ny0aF7Lrn0dLh67nQypisr3axstlRe1mYRFs3maRhOjQH9C7kXutsUDpHQUTmULmTPADexVaoX8gDWAJUaV5S/DopBom+02w3a/gU4ISp6kTGaxy36X1Nz+TJ3NOkGZiT1nK6LJlpYWw6KM9zOkebBCxcVywvnswRQxBNJYHo9ivQwekK3yB+uIAu97lX95SVCOElw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4+1o05pX03uDwR9uXiI5+uCXQWUarTFnmLL0s81bCc=;
 b=o3Cu5pFjWCtHQC7C/JeR8b0rSmUFi52cBr4btGKSO8QkyDJrybCbJ6LA+oPKRrPrgVds8s6J20O2uilXJgWpTbw9IEs5fSKzx2L96sbC81GjdfKGOb7mGHPLsR3230ef4QhHtQ73hP04xY/nwR5Iw5JeeplspbK52Rbf0pKpVdg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM6PR11MB4674.namprd11.prod.outlook.com (2603:10b6:5:2a0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24; Fri, 20 Jan 2023 10:47:35 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 10:47:35 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <a.fatoum@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <pabeni@redhat.com>, <ore@pengutronix.de>,
        <edumazet@google.com>
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Topic: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Index: AQHZLAhN1bL1NvCdeUO6Em39hgWKCK6m4ewAgAAPk4CAAC0dgIAAAQSAgAABg4A=
Date:   Fri, 20 Jan 2023 10:47:35 +0000
Message-ID: <2f97cd592d188c71ebab796cc6eaf77654a43c17.camel@microchip.com>
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
         <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
         <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
         <a453da7bd4e1a0ea1da7cb1da4fa9b2c73a10a44.camel@microchip.com>
         <55b34928-e5b0-7ab7-fa40-5ae73d05a269@pengutronix.de>
In-Reply-To: <55b34928-e5b0-7ab7-fa40-5ae73d05a269@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM6PR11MB4674:EE_
x-ms-office365-filtering-correlation-id: d0e03240-74e8-40a2-4d3b-08dafad3bdcd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZgUm+6YExHhs6VJH4P7LkD1uqDmas4NUr0X4zyG/ZP3zPyNu7yQHAJYOJqhA18EZoWbdhGuk43DLQvBOfuCtvBE5SRsgREQjv6BdCaOExx64NG5ba87dI7US4nF9l42dNQ9vBj9bA2BTNRFG2kMkXDAIIpHOUFVrN+98zAN+IEAdaw6LpNbcinpPu5A96T6BUrS7DjBMhf6ggUJgGvBEXTBrlv+XQRgyC0ZFvdaX3+a412380qTTH9HPu7TpBlpNup2CnmrvPb/EPf/mJ+8w16F3Wc9CNJ4V/f65YWt9FUAw3XptMfVh/2xhcb/mdW4mR0WGG4kUlTUyg02D5H69jxUAZDKAvus/kDfWXTc52Yoc0W+VXyubgFf6nYoeSRLujTXj4ZdbHyyZyLrcbSvtfuV4xKHqus8GlkelyhEa3obXNYy1yCeJ0CdvSdfZbNQkz6X/Eunb36540RxYu7CFEHxUpS+9h10J0EhUsaBwb5lVoYQlT8AIOpa3aJZehzy78iJqISi+bHoKOhjmv+vwFZnPVsDhvNfSgfx0inZjVxPOJ3x7MBfZYDAYCJt7nry6oJWvHzdx4ip3vsAkTnbEo1fth7V82rturoy3DZJdO7zSVHQqfoR4GpN5c1k1ZrFKr/HBXSwqD93qSCI+poEp6BFQCZjRBkyq1mbneNYmZGRlGDtJ0WwYGSxwndrMzha3OuW+BL2qCXRbfw0nIvDqrhRYvpYYaef6q7Dgz3YGEVvDNOpjigbmAB5PvkW7LF+D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(38100700002)(66556008)(76116006)(122000001)(478600001)(86362001)(5660300002)(8936002)(66476007)(91956017)(7416002)(66946007)(966005)(2906002)(316002)(64756008)(4326008)(66446008)(41300700001)(8676002)(26005)(2616005)(186003)(6512007)(83380400001)(71200400001)(53546011)(54906003)(110136005)(38070700005)(6506007)(36756003)(6486002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2o1WTV3dGVsTFBjR1JQbkd6VEtKVkJ1bGRIUytlTTJYSjZqdmIyVmtPZTJJ?=
 =?utf-8?B?djNQb2xOVCtyMGlWeFkzZ3dIRG9rTE93VXpyNm5JZmtBMU5SdU5JdVkwSFkz?=
 =?utf-8?B?TFJsMlIySUtEYXpYT2tjRDZJOTN2VUc5UHRhem1wL0xqcTBnT0dVOXhlTjhr?=
 =?utf-8?B?cmVVa003VTRaOU1BRkkwMW0wUG5DZERDSFN4M2RLamdNVDVwb3ZxZHE1MmNz?=
 =?utf-8?B?eURtQXRjYURTWS9vWnl2QXlPbDIvT2N1VTFncHFXdHN0N1BqZVZ3czZmV0ZN?=
 =?utf-8?B?U0JSTlhrTXp5VitQT21DWWFjRnJPSE1BWG8zdXJiVmQxMWFIaFNZU3J4S1hx?=
 =?utf-8?B?Nm0zSkg0VGtkRTJua2t6dit2NjFXVXNpZXlOeTh6OW9vcGxicTJXT2ZhdzRR?=
 =?utf-8?B?MU5IQ21WcnN1V1plb0oxZm1EQTQ0bTR4bTdZTmMvV1dNQ3RoRVFWU200RXRP?=
 =?utf-8?B?ZGxKQncwWVhxUWFMZTBVYmRhUS9ZRjYrMzFUZ1kxM1lFMzhRUERmYUVOa1hN?=
 =?utf-8?B?MGkrS0NRN3ppNlg4N2dOQ01vWjN3azhESUtMVE9NUHpncEo1eTFTNWtOOUpI?=
 =?utf-8?B?azZ5R28wUENCdUliRXh3SldtT2Y0UzBUYkpMdkQvMjZPbEwzNGUyemdTUWps?=
 =?utf-8?B?aXVVNmxnNGY5eUVlUUYwclk5dnZDZEJzc1hNYjFqc1drWENTQjM2ZzMxdWo4?=
 =?utf-8?B?aU9laWlQUmRHbUdkSG9adm4xaTU1SitWUGxyekh4ckNOekh1YTF3RWttUmFG?=
 =?utf-8?B?aUg1dnY1L2xkNUZTajFRN2FqdUtxUlVlSGZwVXpzdGtjYU1sRjl0K1JIbVNa?=
 =?utf-8?B?QUphdkg3bnpvTDdMaDNKaUd1Q2JOVFFyQm1Ub1JDcjhjQmptS0hmeDhFY2dE?=
 =?utf-8?B?VHV0ZEFUbjBmdDIydFJYTU43UlFxS3ZtTnpHOVFKTTVJU2tKRnlNb3NsL29w?=
 =?utf-8?B?WE5UV2tpVzJkdjdiYUtIYk9xTU40QjdqaCtVNVdvQlFWTktWaDlJcjAwanNT?=
 =?utf-8?B?dnAvTVJ4YjNzV2Jnb1JrWDZTTW5mc0JoaHk5cVVYbE9USWYwZ2NFRjZCcFZP?=
 =?utf-8?B?cWdpd2FjbWo3L3gySmhSM3NlRGdtYkNBVXp5VE5UNndiZGxJcWZ0M1NOUzgv?=
 =?utf-8?B?VEY4RXJyeHpIQVdXYkVEbUhXSEtNemEvejk2elJ1ZE4vV2xIdFMwQ0xEb0Rr?=
 =?utf-8?B?ajZta3NpRTdTelU3blZwK3NLVnd1NW9OV0pwWEpFdkFwREdueFZ6SVNpRFZk?=
 =?utf-8?B?ZWpReTBjclRQSGJSdkoxR1VuTzhXTXc4ZXdoSjJlNUZCakhwaVVuREltMVpH?=
 =?utf-8?B?QWUzTEZGWmVxalgzQ0t6YUkwaVNhWkRwKzc1eDBpc25aSTg3aUlRcjBQWC9s?=
 =?utf-8?B?WlF6ZUM2dGdJdFl1VXJMcDcza3BCRFo3c0F3aEFjN28zeFQ1clJQL21QYUZN?=
 =?utf-8?B?YzgySXNGTkNidkU4RGUxa0pFdzFNKzloRXd6anZnU25OYitDOWJoUnpPZWU3?=
 =?utf-8?B?N0owL2ZMc0crMnAva1JFTmJlUzJ3VnpIVU1ldmpLYUFRWElQOTN5Y2VUZ2dH?=
 =?utf-8?B?RFh2NUk2UXJ5c1NOOVBFMzJrWllRV3lHSmFGUEtuZ1ArMkdSZDRVUlFhVTVG?=
 =?utf-8?B?Skw4WUpZbzZGNFpPMGpqZEJHc2c5RnV1UGtPajZ4TTh3SHBuREdFUUJiWVVH?=
 =?utf-8?B?L0M5Ync1S2lCMTlUSWZFOFMrWG83aHRkTkl1d2ZGdzNhVDI4Q3NnWEJwalMx?=
 =?utf-8?B?aGpXcXFVWFJXbDZyOXByTW1OSkVCeFdtVk5OcHg5aFhGQi83UGhBRXp5SDBI?=
 =?utf-8?B?UjRCOWtRK1dPbG9PVEM3N2pCOElYMHpGQ0VwWE5QMlkwZ0M0Wm1xeFpGcHlJ?=
 =?utf-8?B?MVEvWjhLSEdFV2ZySjdCVlh5eFIxTmowaC81MVRuVzYvOEVSckZ3RHJDZ2pB?=
 =?utf-8?B?bU5KMUVWNFRwZFJYZnpuUnZsRWF0anFZNXFhbXNzV1ZCYllwREZWMUZMYmcy?=
 =?utf-8?B?N1oyMmZDNDM2NDRPWlh0dEZEOWFzdldNQVd5RFJOdHZ5QXBDa1QzZC9HeklB?=
 =?utf-8?B?OFZsSzZFaCtZeitWaFlFMDdZOFdZK2FvcGxtZjlaazNZeGx4aGdVWVpheXlN?=
 =?utf-8?B?TXZpNnFsL3lKeldOa2FkUkF5V2YvK2xPQ3lWUTNlZDg0eCtGOEJMSExEajV1?=
 =?utf-8?Q?mcExCPSw/kqKDJDZoi5BgQ8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E149C8620ED674E974C5BE3D5A11CC8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e03240-74e8-40a2-4d3b-08dafad3bdcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 10:47:35.5582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cVk7Iz/o/0i5/MaJ/Dc0L6/lVNromIHJFGO3NZxH0rm+IassjTVnpXcDBBocwnYEYnBw6vMnmd5y9AxX8QF88DlZsa0m/snQbbvXwd3nRls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4674
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTIwIGF0IDExOjQyICswMTAwLCBBaG1hZCBGYXRvdW0gd3JvdGU6DQo+
IFtTb21lIHBlb3BsZSB3aG8gcmVjZWl2ZWQgdGhpcyBtZXNzYWdlIGRvbid0IG9mdGVuIGdldCBl
bWFpbCBmcm9tDQo+IGEuZmF0b3VtQHBlbmd1dHJvbml4LmRlLiBMZWFybiB3aHkgdGhpcyBpcyBp
bXBvcnRhbnQgYXQgDQo+IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNh
dGlvbiBdDQo+IA0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+
IE9uIDIwLjAxLjIzIDExOjM4LCBBcnVuLlJhbWFkb3NzQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+
ID4gT24gRnJpLCAyMDIzLTAxLTIwIGF0IDA4OjU3ICswMTAwLCBBaG1hZCBGYXRvdW0gd3JvdGU6
DQo+ID4gPiA+IEluIHRoaXMgY29tbWl0LCB0aGVyZSBpcyBubyBLU1o4NTYzIG1lbWJlciBpbiBz
dHJ1Y3QNCj4gPiA+ID4ga3N6X3N3aXRjaF9jaGlwcy4NCj4gPiA+ID4gV2hldGhlciB0aGUgZml4
ZXMgc2hvdWxkIGJlIHRvIHRoaXMgY29tbWl0ICJuZXQ6IGRzYToNCj4gPiA+ID4gbWljcm9jaGlw
Og0KPiA+ID4gPiBhZGQNCj4gPiA+ID4gc2VwYXJhdGUgc3RydWN0IGtzel9jaGlwX2RhdGEgZm9y
IEtTWjg1NjMiIHdoZXJlIHRoZSBtZW1iZXIgaXMNCj4gPiA+ID4gaW50cm9kdWNlZC4NCj4gPiA+
IA0KPiA+ID4gSSBkaXNhZ3JlZS4gZWVlMTZiMTQ3MTIxIGludHJvZHVjZWQgdGhlIGNoZWNrIHRo
YXQgbWFkZSBteSBkZXZpY2UNCj4gPiA+IG5vdCBwcm9iZSBhbnltb3JlLCBzbyB0aGF0J3Mgd2hh
dCdzIHJlZmVyZW5jZWQgaW4gRml4ZXM6LiBDb21taXQNCj4gPiA+IGI0NDkwODA5NTYxMiBzaG91
bGQgaGF2ZSBoYWQgYSBGaXhlczogcG9pbnRpbmcgYXQgZWVlMTZiMTQ3MTIxDQo+ID4gPiBhcyB3
ZWxsLCBzbyB1c2VycyBkb24ndCBtaXNzIGl0LiBCdXQgaWYgdGhleSBtaXNzIGl0LCB0aGV5DQo+
ID4gPiB3aWxsIG5vdGljZSB0aGlzIGF0IGJ1aWxkLXRpbWUgYW55d2F5Lg0KPiA+IA0KPiA+IFRo
ZSBLU1o5ODkzLCBLU1o5NTYzIGFuZCBLU1o4NTYzIGFsbCBoYXMgdGhlIHNhbWUgY2hpcCBpZA0K
PiA+IDB4MDA5ODkzMDAuDQo+ID4gVGhleSBiZWxvbmcgdG8gMyBwb3J0IHN3aXRjaCBmYW1pbHku
IERpZmZlcmVudGlhdGlvbiBpcyBkb25lIGJhc2VkDQo+ID4gb24NCj4gPiAweDFGIHJlZ2lzdGVy
LiBJbiB0aGUgY29tbWl0IGVlZTE2YjE0NzEyMSwgdGhlcmUgaXMgbm8NCj4gPiBkaWZmZXJlbnRp
YXRpb24NCj4gPiBiYXNlZCBvbiAweDFGLCBkZXZpY2UgaXMgc2VsZWN0ZWQgYmFzZWQgb24gY2hp
cCBpZCwgYWxsIHRoZSB0aHJlZQ0KPiA+IGNoaXBzDQo+ID4gd2lsbCBiZSBpZGVudGlmaWVkIGFz
IGtzejk4OTMgb25seS4gQWZ0ZXIgdGhlIGNvbW1pdCBiNDQ5MDgwOTU2MTIsDQo+ID4gS1NaODU2
MyBjaGlwcyBpcyBpZGVudGlmaWVkIGJhc2VkIG9uIDB4MUYgcmVnaXN0ZXIuDQo+IA0KPiBUaGFu
a3MgZm9yIHRoZSBlbGFib3JhdGlvbi4gSSBzZWUgaXQgbm93LiBJIHdpbGwgc2VuZCBhIHYyDQo+
IHdpdGggcmV2aXNlZCBjb21taXQgbWVzc2FnZXMgYW5kIEZpeGVzOi4gU2hvdWxkIEkgaW5jbHVk
ZQ0KPiB5b3VyIFJldmlld2VkLWJ5OiB3aXRoIHRoZSBjb21taXQgbWVzc2FnZSByZXdyaXR0ZW4/
DQoNCkkgdGhpbmssIEkgY2FuIGFkZCBteSBBY2stYnk6IGFmdGVyIHlvdSBwb3N0IHYyIHZlcnNp
b24uDQoNCj4gDQo+IENoZWVycywNCj4gQWhtYWQNCj4gDQo+ID4gDQo+ID4gPiANCj4gPiA+IENo
ZWVycywNCj4gPiA+IEFobWFkDQo+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4gY2hpcA0KPiA+
ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEFobWFkIEZhdG91bSA8YS5mYXRvdW1AcGVuZ3V0cm9uaXgu
ZGU+DQo+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6OTQ3N19pMmMuYyB8IDIgKy0NCj4gPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19pMmMuYw0KPiA+ID4gPiA+IGIvZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X2kyYy5jDQo+ID4gPiA+ID4gaW5kZXggYzFh
NjMzY2ExZTZkLi5lMzE1ZjY2OWVjMDYgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEvZHJpdmVycy9u
ZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X2kyYy5jDQo+ID4gPiA+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X2kyYy5jDQo+ID4gPiA+ID4gQEAgLTEwNCw3ICsxMDQs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZA0KPiA+ID4gPiA+IGtzejk0Nzdf
ZHRfaWRzW10NCj4gPiA+ID4gPiA9IHsNCj4gPiA+ID4gPiAgICAgICAgIH0sDQo+ID4gPiA+ID4g
ICAgICAgICB7DQo+ID4gPiA+ID4gICAgICAgICAgICAgICAgIC5jb21wYXRpYmxlID0gIm1pY3Jv
Y2hpcCxrc3o4NTYzIiwNCj4gPiA+ID4gPiAtICAgICAgICAgICAgICAgLmRhdGEgPSAma3N6X3N3
aXRjaF9jaGlwc1tLU1o5ODkzXQ0KPiA+ID4gPiA+ICsgICAgICAgICAgICAgICAuZGF0YSA9ICZr
c3pfc3dpdGNoX2NoaXBzW0tTWjg1NjNdDQo+ID4gPiA+ID4gICAgICAgICB9LA0KPiA+ID4gPiA+
ICAgICAgICAgew0KPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAuY29tcGF0aWJsZSA9ICJtaWNy
b2NoaXAsa3N6OTU2NyIsDQo+ID4gPiA+ID4gLS0NCj4gPiA+ID4gPiAyLjMwLjINCj4gPiA+ID4g
PiANCj4gPiA+IA0KPiA+ID4gLS0NCj4gPiA+IFBlbmd1dHJvbml4DQo+ID4gPiBlLksuICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+
ID4gU3RldWVyd2FsZGVyIFN0ci4gMjEgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiA+IGh0
dHA6Ly93d3cucGVuZ3V0cm9uaXguZGUvZS9lLyAgfA0KPiA+ID4gMzExMzcgSGlsZGVzaGVpbSwg
R2VybWFueSAgICAgICAgICAgICAgICAgIHwgUGhvbmU6ICs0OS01MTIxLQ0KPiA+ID4gMjA2OTE3
LQ0KPiA+ID4gMCAgICB8DQo+ID4gPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiAg
ICAgICAgICAgfCBGYXg6ICAgKzQ5LTUxMjEtDQo+ID4gPiAyMDY5MTctDQo+ID4gPiA1NTU1IHwN
Cj4gPiA+IA0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXgNCj4gZS5LLiAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gU3RldWVyd2FsZGVy
IFN0ci4gMjEgICAgICAgICAgICAgICAgICAgICAgIHwgDQo+IGh0dHA6Ly93d3cucGVuZ3V0cm9u
aXguZGUvZS8gIHwNCj4gMzExMzcgSGlsZGVzaGVpbSwgR2VybWFueSAgICAgICAgICAgICAgICAg
IHwgUGhvbmU6ICs0OS01MTIxLTIwNjkxNy0NCj4gMCAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRl
c2hlaW0sIEhSQSAyNjg2ICAgICAgICAgICB8IEZheDogICArNDktNTEyMS0yMDY5MTctDQo+IDU1
NTUgfA0KPiANCg==
