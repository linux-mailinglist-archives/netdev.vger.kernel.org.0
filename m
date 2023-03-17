Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F966BDFDB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCQD5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCQD5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:57:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD98556153;
        Thu, 16 Mar 2023 20:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679025468; x=1710561468;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s9FdIvhlfdQ5dgThs3yKaPtfIwMYw9d+oxc3FGsdlNQ=;
  b=ShOAzAiq/dtJxR5rDAhdm4PUa3ooGqgscmlRSd2h6K84PLAnj7nhuniS
   0HBAR5WWlHk3F70f9rCxM/+1qgCE0Z9QvSVF+yFOmzf9oTHD97n0356xg
   ZkERe0qyi8HulvhkXYTNySdWphXpn1tkM1jvd6xyac+1XPT5dpSbL1ef3
   hGvcQH7ZMTM3XIXYBMLoJl5rhRZK0CfVQdJD+4RS3RcyhUYK/w5Ds5cZi
   /N12MGlnEsM17b19pwxBJnRV51kM+RhQTZc5bgg/Z73tVo4grzg+rJqAI
   1RSMYQRlY3DhasGbW1ywtzs7SzbGya0ZRTz/v/BnrqKqQgkLn7V7gKrZU
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,267,1673938800"; 
   d="scan'208";a="202084955"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 20:57:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 20:57:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 16 Mar 2023 20:57:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKmn77lBXdVInAv5ictSOuIqEznJVb2voV8AfrV84YSf9pdbRPnA61EetY1MSg8xZe5zH/mp2bmKEpVCBrUEmj3Ew+pcvAQcPoSy+DhtLLn6pgJPLEGTWCgYoV2NjviAztWHfQIy5RJ6cGlgzRtxlDz2Gro2ZQzfxuSaXeD0SkzP64fThAr33KRizW264fCjuYxNSlOXmloWvKch9xdS9HJCbMXUvHJAr1m7gB+Y/wgktBhA89VEM0go7Zj2fS/B1nh/8rpUNb9kCKPfdhHfmKw9ZdAlUDkgFBZiLS5nXkqGReMJKPD/8yankiysIfAhgUOF64jyA3iDGf577A9Tbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9FdIvhlfdQ5dgThs3yKaPtfIwMYw9d+oxc3FGsdlNQ=;
 b=KRRot2zhU3uEXOA+8Lmezc4AuZR/QNrUpAnU2ieutuagGN4rJXBhUTBzUQC6zstnlRz2kW14IJkK+HwHj/ddNJ4O8E+Zs5h0uyvbfjagsNVrKm+xeD+ttuLXIc8IzSIl6YJ2lC+hfegVQPTsnAH6jf/h4QUJzk3AtDRyj9F1GAPu2PtOu6I7l8Bl8/pN4yNjJi+hEnaLjZqA3olqoydcEQjliWYo6EfHcAMs1SBxf8xC2OiHV5QRcBfY1GPA8Qmwi+uSA1BxHKCmv9mbRmhfiuS64Pb/dzpK5zySMf7hTrXpjlOXd485SdLls5UCdgGljo4ml9ecvOUUR6RzZrOC4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9FdIvhlfdQ5dgThs3yKaPtfIwMYw9d+oxc3FGsdlNQ=;
 b=f4Kl7quUNsecFe6S59B/XGmM5xAc0TcmvMWmP0fel5AWS2VLw6lXpxWVDgXGMOco4/GMkMAvjuIE7sF6b05EbmGU1E0qHbdBSIZSbF57JE3I9hGElyhmvMQhooixvLrWXttmV71CBJgsEbo7mV/sVGGGGcrZOGq4NYb+MPNNlcY=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Fri, 17 Mar 2023 03:57:44 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.025; Fri, 17 Mar 2023
 03:57:44 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <vladimir.oltean@nxp.com>
CC:     <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>, <marex@denx.de>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux@rempel-privat.de>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [RFC/RFT PATCH net-next 0/4] KSZ DSA driver: xMII speed
 adjustment and partial reg_fields conversion
Thread-Topic: [RFC/RFT PATCH net-next 0/4] KSZ DSA driver: xMII speed
 adjustment and partial reg_fields conversion
Thread-Index: AQHZWCI+Vi2wSYfnU0yxtpbpUvwnta7+WQKA
Date:   Fri, 17 Mar 2023 03:57:44 +0000
Message-ID: <c121b180198a0d51bcbb6e17e8e0a3da2a2206e8.camel@microchip.com>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|CO1PR11MB4963:EE_
x-ms-office365-filtering-correlation-id: 2c8440e1-3ee0-435c-b3ad-08db269bc381
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 816Vlj98GzhQhouLYngslxe3WoKO6IaBzAOW2liPNJWqsKNvJJFQUl/PKq/GaA0kyD8Q9Zz9MqqocC5Hm/9LnVQ2EQi4TkA64M4Q9jLqDH60kvz2HhRIq/8lCa4aKFIAqN7XkkqFDInZNUNr2rY1gqGk2YgugrtcWiobthFO9qd8kmdOpmJx64fyPfBLxYsNs1jd3IcKDLdluEM1oZwxVwGzuVJCg4W7EjgIIjvF4hg7nw3gFWKxZXrZ4X6DwZY/Qb9zQLO7eGABTph+aS2VCsgF1tRi0HJ/tKOb7DPbflZJTK9SLs79413PEq4q1i802yfYudnRFDdIC3ewFNjZbtQHofUUuDD6O14jgcBtwD0tqE5Ru2mJFUFrty9oqtn5GSGH0oc/xFJtoMtsfRnuG9NjrcQFiegMjHFh1aVxgLiwSi2qTvPmCSECZUvx4PW7pOr4XEP7OgTOIcFJZ8NSCOiNB36wvhhiIgC3ZjHwBN+8e+0xXxOV7faYX0b1LePyJ1KEm78vgeXkIjbz4AORJMCGVuHh+0D7TCOBX9r5hwQf9fDhjMHVKmXxbNH5u13KXy4MdGgEBdFdhJQ1c0AZpRwaH+I4KvSiNpnOpVgfkKMRDeq+bnpf9CDuVLigE7YbwHoDAVkg20OXyaTrM+DBiY+sWn+71gO70itlhXmz8BL2wYQ+/o9HAkhBw1z+crfT7HdUbr4/2d90o32uPAaORcX1aVdp1LoqkUwrqKF2TQ0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199018)(8936002)(36756003)(5660300002)(26005)(66556008)(64756008)(2906002)(2616005)(66946007)(83380400001)(38100700002)(186003)(122000001)(6486002)(86362001)(54906003)(91956017)(41300700001)(66476007)(4326008)(6506007)(110136005)(316002)(71200400001)(7416002)(6512007)(8676002)(478600001)(38070700005)(66446008)(76116006)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHlsYzE4blZyRGJYUmRFUnl4QU02ZjYzeWtzbHF2WUtJMzN1NEZmSHgvT2RH?=
 =?utf-8?B?dW5NMlRrRityOS9FWHJzWFdFNC9yYVE0ZWV2U1ZLKzF4M2hUak9pR0JZM1hW?=
 =?utf-8?B?TXRIVUNNZWJRQWFRZWsxYnc5Y1dwd3VwV3ZIZDlXYlFTenV2K0dMdXZEY0Ey?=
 =?utf-8?B?MG1CR29sQ2hPR0ZRZGNpZzZKZ1BraTFGUjNZT0pmaE54c3oyTWprZm50WkdD?=
 =?utf-8?B?Y0J1NG1XQ09CTm5halgyZ3cwU1EyTGx2YUxrbDNWZmlhc0tLOG9ZYU53OEt2?=
 =?utf-8?B?ZDRWQldSSHYzVGF4ZFFDSmhKbjB4NkV1cFBqMkRKbVJKWTBPbmNxKzAyYWFt?=
 =?utf-8?B?N1d3V1BCclo1SldjUDZEK09mZEV2aXlYNS9iVVhKci8zWDdlMkZQU3ljL1Zv?=
 =?utf-8?B?TDB6elliMHVYRlc3dXZzQ0xHSWZxdFg1WGJ2eVlENEo3amxMZkhsbjU3OE40?=
 =?utf-8?B?SzBhMTNvTEZuYm95eW1zeGpVb0VUQXMrWUlhUGhNS3FXeXc3VmlTS25sVktH?=
 =?utf-8?B?SXhXSENqVXdxZ2duWnJXWnR1ZzRFMmduQUV2enc0TVpqVEVjNWltSGxCVlFL?=
 =?utf-8?B?KytsZTZmZDA5dlhHV2phWXRiNGw2cGFaUHNyNUxkU3d3cVZhbFR6bVJJRWVm?=
 =?utf-8?B?WTZMc2VySHlTRjVkS1U4dUQybTZ3SXJEMEFScW5PVmhEQk9FNll6cmpmcmxM?=
 =?utf-8?B?c2lMdTE3aklnOVUwWHlldnMxSWtRYzhmK1pCOXdwYlRXSWl4cytZRCtmSGlT?=
 =?utf-8?B?Y2ZPbG15YVdxRGxxYmlWZ2hsd2NPd2l4QWVoVHRXUG5iWWw5ZEQ4aFRDR3pi?=
 =?utf-8?B?a1pMb1llOURtdEhHL285WEpCUFZvSUhaNC9vN2dKMjlFRkJpM29oSTRwZ202?=
 =?utf-8?B?ZTcvK3NCL1ZHZDBvRkNvbTFyeEpTcURlSy9MeFErc1NDRUFsclpCZ1AvbWFG?=
 =?utf-8?B?NGdrMmMydzlzeXdvNmwxMURqUHhrdHZ6VEF4SlhPTTZCV2tRd1Q0WGs0TmJp?=
 =?utf-8?B?aVJBOExsVHdUVEhTdUVDejB5bk1mVjkrOVpzLzcxbnZqTFl0eFBOeVY5a0ZT?=
 =?utf-8?B?TC93QThzTlhPR0F0VmdpcDRrZVZYLzR0ZnorMWRXN2tOL1VoL2xoSmlsVGNs?=
 =?utf-8?B?K0pUaktMMVFmUGJCeDJoSlYyWGhxTnYyOVQ4STVoY2dJWnM3SllYTVF6SXg5?=
 =?utf-8?B?aWRDNGpncmorRzBYS2pkRGxQQkFKcUQzaW91UlRTVE9ycllVZVJTRXZLR2hz?=
 =?utf-8?B?bVdLK0w0dmk0VStZcFBxbWhadktRWnI3UkpnTThZZ1d6b1hXK21aeHR5SU9U?=
 =?utf-8?B?TFRDc1IyLytPb0FMTUdIeU1VNDB0OHhLYU4yK3lPYzRHWmRUd0VIRW1rRnMz?=
 =?utf-8?B?SktiYzlNM2FrVlA0dnUzc1QwdjhselhLS29ZaXZrWGx5SDFLR0xQdjRTYjRV?=
 =?utf-8?B?dEF3SDlLT3M2NmVrS0ZEKzZ4dFNIckZRZUxFR29QaXNQVGlSMmpqY1EySXU3?=
 =?utf-8?B?VWpjM2hYUXJTMXU3L2lYRFZINXp3WldDWmdFZXV5M0hPRWlhamZXcUFZYjJt?=
 =?utf-8?B?UC9yL3dQSXlsSmNVY2tadlc2NlZnOW5aY2pZcFVmT1ZNamFnNStSekhlTnJ1?=
 =?utf-8?B?VzJmck5HRlNvSHE0eXV3aHFPQkZMdUtBRmViYXdWZUlpaVZTa0xTNWM3UWpa?=
 =?utf-8?B?eUhSM2lmVTRKL2VwSWc4MHQ1VkltZmNNUWtVZEl1dE5FeXlSV1NmZXhKUWJE?=
 =?utf-8?B?U2NUSjhIMUVRZ1cwUzFvTjVmQ09jWUxVMmNUcjJpZzYwNEF1dWU2aUR1VlhV?=
 =?utf-8?B?SlB0UkVLWHhDMTZDbHhWZGZGTi9HeG56TDdFenlmbllvMEp1N0NGRDNCblZV?=
 =?utf-8?B?T1JJN0thc2FGZjRoTkUrc0RhRHpWelpKMEFHRVFyKzFCYTF0dkYrZXQ3WHlT?=
 =?utf-8?B?UXUyS1ZLNEtsUmlnSG5PZXJNV3E3MVloTnduajg3QmtwMTR1MjVCbHh1VDdY?=
 =?utf-8?B?WkZ6Um5XaisrV2RQZnB2TmF6YTVIaGNGNkg1eEl5VXJpNzB6cjBxQzl2MU1X?=
 =?utf-8?B?eDd2SVREc0tnRlE0elVRditiV2FTdEdKdG4wenVESklCL2JZVVNVZm4vK1I0?=
 =?utf-8?B?UUlZNnl5cWhmUElmSE5IdXpWZm4vYnZwNzZydVl1akNaTzBoNHM4cjNwVTEr?=
 =?utf-8?Q?LVtr6BYE7nbP8Qv3kcXYvok=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <091F2B79F4AAD449B2CE8122787CA05D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8440e1-3ee0-435c-b3ad-08db269bc381
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 03:57:44.4432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yQFay7H8jXgiSW4KXFpG4mklLLHJYU03qEkX2fuCaNTUC8EN/K1APDjKrdSsMwizCg2VkSlCrDshluAf5RjjE0fFHY9nY+cncwUTxo/rkkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpPbiBUaHUsIDIwMjMtMDMtMTYgYXQgMTg6MTIgKzAyMDAsIFZsYWRpbWly
IE9sdGVhbiB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiANCj4gQUJTT0xVVEVMWSBOTyBURVNUSU5HIFdBUyBET05FLiBJIGRvbid0IGhhdmUgdGhl
IGhhcmR3YXJlLg0KPiANCj4gVEhJUyBCUkVBS1MgRVZFUllUSElORyBFWENFUFQgRk9SIEtTWjg3
OTUuIEFueSB0ZXN0ZXJzIHNob3VsZCB0ZXN0IG9uDQo+IHRoYXQgaWYgcG9zc2libGUgKGR1ZSB0
byBib3RoIHBhdGNoZXMgMi80LCBhbmQgMy80KS4NCg0KSSBkb24ndCBoYXZlIEtTWjg3eHggYW5k
IEtTWjg4eHggc2VyaWVzIG9mIGJvYXJkcy4gSSBjYW4gYWJsZSB0byB0ZXN0DQpvbmx5IG9uIEtT
Wjk0NzcgYW5kIExBTjkzN3ggc2VyaWVzIG9mIGJvYXJkcy4gSSB3aWxsIHdhaXQgZm9yIG5leHQN
CnZlcnNpb24gb2YgcGF0Y2ggdG8gZG8gc2FuaXR5IHRlc3Qgb24gdGhpcyBLU1o5NDc3IGFuZCBM
QU45Mzd4IHNlcmllcw0Kb2YgYm9hcmRzLg0KDQo+IA0KPiBWbGFkaW1pciBPbHRlYW4gKDQpOg0K
PiAgIG5ldDogZHNhOiBtaWNyb2NoaXA6IGFkZCBhbiBlbnVtIGZvciByZWdtYXAgd2lkdGhzDQo+
ICAgbmV0OiBkc2E6IG1pY3JvY2hpcDogcGFydGlhbCBjb252ZXJzaW9uIHRvIHJlZ2ZpZWxkcyBB
UEkgZm9yDQo+IEtTWjg3OTUNCj4gICAgIChXSVApDQo+ICAgbmV0OiBkc2E6IG1pY3JvY2hpcDog
YWxsb3cgc2V0dGluZyB4TUlJIHBvcnQgc3BlZWQvZHVwbGV4IG9uDQo+ICAgICBLU1o4NzY1L0tT
Wjg3OTQvS1NaODc5NQ0KPiAgIG5ldDogZHNhOiBtaWNyb2NoaXA6IHJlbW92ZSB1bnVzZWQgZGV2
LT5kZXZfb3BzLQ0KPiA+cGh5bGlua19tYWNfY29uZmlnKCkNCj4gDQo+ICBkcml2ZXJzL25ldC9k
c2EvbWljcm9jaGlwL2tzejg3OTUuYyAgICAgIHwgIDQ1ICsrLS0NCj4gIGRyaXZlcnMvbmV0L2Rz
YS9taWNyb2NoaXAva3N6ODg2M19zbWkuYyAgfCAgMTEgKy0NCj4gIGRyaXZlcnMvbmV0L2RzYS9t
aWNyb2NoaXAva3N6OTQ3Ny5jICAgICAgfCAgMjQgKy0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzejk0NzdfaTJjLmMgIHwgIDExICstDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uYyAgIHwgMjU2ICsrKysrKysrKysrKystLS0tLS0NCj4gLS0tLQ0KPiAg
ZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmggICB8IDExMCArKysrKysrLS0t
DQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9zcGkuYyAgICAgIHwgICA2ICstDQo+
ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2xhbjkzN3hfbWFpbi5jIHwgICA4ICstDQo+ICA4
IGZpbGVzIGNoYW5nZWQsIDI5OSBpbnNlcnRpb25zKCspLCAxNzIgZGVsZXRpb25zKC0pDQo+IA0K
PiAtLQ0KPiAyLjM0LjENCj4gDQo=
