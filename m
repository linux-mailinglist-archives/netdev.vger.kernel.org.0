Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298516B3D6C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjCJLNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCJLNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:13:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956022332C
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678446806; x=1709982806;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=B6/UxYfyvkPaa/QYU3JbA9OQ+3g5KY8mRJ/mighHzfE=;
  b=C6IXFXt4w8peJY++bG4rX9VSSDeuSSm3UsZZbnuBCc3S7Y6hyaUcv77Z
   hzpkTTbI5Qg8xxUVsCpC++v3tMMEQNgfJBXYbmafkDvJh6nUVhr2I1WFH
   j+FJ4+gRIu8CNQCB6cqjJo0bVH3Gd8GmFbNKafFPZLlA5+9Th5LK+xIkf
   /fPPyhzp5iaJAsLfcIU24u6e3EsWokef51I2IClAVu0ghb9MhHMoSHtLo
   kw5Doo/HErBlysQZu1s/4B2KizJUNyEs10ki0Y4BzyQsiJ+7ZH9uxnZgS
   ZRvYtFYv55NBBQ6BQ8ye5PTicIlRgYKyJeyr6pUvYW6T1Qr3uJeBjfP+h
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,249,1673938800"; 
   d="scan'208";a="204175821"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2023 04:13:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Mar 2023 04:13:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Mar 2023 04:13:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djFWows5zomvSu1bX3cTw1VrcdTnBhUYhahinsSgcRn9LKA0P0UgvOHmk81aZClLciry1XD1NJ5CDnHX6iHc0porxyi9c4S3Ome/J2QAwvltAWzOGdABuYRazFJkyLcH6cAbXJeDeyZs1psJOI0z3VS/50y9TmOWzu9lsG7Cew2yBJUoiW4VaHM+Pnc1UA+h5quANo1KHC3Xiqah3EzYvNefOGiKU0Fire9yo0WpAzcCQDqSDg0n1XVKKqVPgfOmfzWQ+T2iynPL5bUYxUPgeH8nioUqS/KfgW6LR502pKKlwnunIr7O6mRBvnBvGfm2noYJqKRTm0oUcSkzlZODUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6/UxYfyvkPaa/QYU3JbA9OQ+3g5KY8mRJ/mighHzfE=;
 b=eNCaukdnlyOvR2to+kR88mWKqG9DBrnlfmHBVMMdIflqszfyJNn67RPwuspS8BLfW9eGzLw+mYk3WMWw5QQ7tUbMTcVn0XPIJP1vP5wykn1FVqQKMUzwsn5x4v6fybGcgoaAGT3OsgKTJacAqYXl/N85ZK8XGxf0DEUYNDb2fW+TZBGQa5WaCmMNf68x3GZMSwfBU4tTNvvVlzOwqFdzVLmPa2TB7EeSIRPLrZ3TfL2jjp+KA7OxO9DodZGFald0jorkkFYYoWiGgQviMd3uTbfvumrLgR51MDx2dgIwcrGlurONAxIdKs43/7+NZLXklUsgRL8sDZlWMb7nwm01RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6/UxYfyvkPaa/QYU3JbA9OQ+3g5KY8mRJ/mighHzfE=;
 b=LiCPOPO28W4KuWD5uzDwQTcntrXk8Z7Fmd3Cdv2y4g7fkSUDMOHwE+rbmc6cm+et2eNnVy3oBovm1Rze8mHCCF9+GFOPTZdm0YqTlVzTR+o/EqoRzUiHnk+IsacJiblmzcSkR8R1HAx904UzC/X9hvMMqRRsqZ0d3TTwEOgJpXo=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 BL1PR11MB5399.namprd11.prod.outlook.com (2603:10b6:208:318::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 11:13:23 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::3b71:50e4:3319:f0af]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::3b71:50e4:3319:f0af%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 11:13:23 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Jan.Huber@microchip.com>, <Thorsten.Kummermehr@microchip.com>
Subject: RFC: Adding Microchip's LAN865x 10BASE-T1S MAC-PHY driver support to
 Linux
Thread-Topic: RFC: Adding Microchip's LAN865x 10BASE-T1S MAC-PHY driver
 support to Linux
Thread-Index: AQHZU0FTEZHSNZuyO0uD/AKM9obf7w==
Date:   Fri, 10 Mar 2023 11:13:23 +0000
Message-ID: <076fbcec-27e9-7dc2-14cb-4b0a9331b889@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|BL1PR11MB5399:EE_
x-ms-office365-filtering-correlation-id: fdc77bec-75d0-48b8-2eea-08db2158766f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ZHHmM1BC79bH6DZrbDEdtvO25fzSM6jZBGqSAB6GSeQ0U2dpJtudEYFA18E15cJtXi8mL8Xs6ztcdCjWoHRzp4ZOZbrf07UcAMx4s4UZOoKAznq2kvQIC+4aQ/oPOwL6bu0Q3f8ngrV7pPFi6gC8yYu4IoSqEWwtWKuHBFEURlnFMAbvlxcYm9/PAcoIyKRwEFaGiNnrdf6cbCe69cu+564nwEGPLBGAqVJ0xE/kyyzHpmhcCb5qWl/nU1ZdFlTe9gqmq5PC+HOG3S8CS1I+j5fRFSEZ8FhY0DMqn6f6vb/dHT+EdJK1DR+UHZo0z+74asbtzPLRz8JuZ8rw7xqvfT1ixXUnvJW6hU3/zEwyGOrAhh76G4HM8CbEx/1wpH9hG4QqYG/GrFs4HUqD78SuXzJdsbkmN8PwSjAi0R/EdYd/ODYGbX8KoBZeo9xZ5Drnp1CLAVsGOxIA+KcWojv0FsXBKZS3JbVwpYaBPpEu+4QH+VUmdFTTbVq7AOAtgUu6+trlWeHUhdzGbtAQxyc2wF5RFi/P/U0h0WxVm1tldRl97atWh5JZAKhSFMNoqtBTOqvzQ1fMpcqVYRGGLSwtJNPTd2bo/e6XGtjjmZpe+GmLwuMWdacnCTU0MCS4wGX6rS8QcRly+yTsd+tQdQ76mcjG9RTYmGOIsbunKLOh+j2iQUGWVpXD9zK12Mw99806lpGveuEcURsYtgu1s3oKg8RaaPPFHEXjlmuP0wJ5EN0jKyxyHNfhxpxrwU6e6Z+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199018)(31686004)(107886003)(83380400001)(36756003)(478600001)(91956017)(54906003)(122000001)(38070700005)(316002)(38100700002)(71200400001)(6486002)(966005)(2616005)(6506007)(6512007)(186003)(26005)(76116006)(5660300002)(2906002)(64756008)(66476007)(66556008)(8936002)(66446008)(6916009)(8676002)(41300700001)(31696002)(66946007)(86362001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MW5pejJQNjBDbEVNczRkK25xTStUVVlmWXJLcUNRdVorSW14NzJsMHhnc21m?=
 =?utf-8?B?VTVXZE0xUlFRdy9IK0EzbTJQbEtqMVBGRDNzcXovWWtRSnNzaDVPaFhPWGUw?=
 =?utf-8?B?cWljSlZSRk40cVhuSjVNMGxXeUFDdTZtblVRb1V1OTIxTXVtN1RmUTZXTG1r?=
 =?utf-8?B?WkJGQS9BdDk0SEZ5WVlmSUluaGFUYktPdVBrZGR2Z2diUk9TRjhLR2dhYUxV?=
 =?utf-8?B?RlE5TlQ4QzkwY2hMVnE4MzVtV3ZWd0lJQWZTd01ZSkJuTGZyd28rWWkvZ0hm?=
 =?utf-8?B?b1hxenNEcklrRWJtcTNwUWthVmt5YW5TU1d0Q0hpYzNxZlpOYTNLWkVXcjRx?=
 =?utf-8?B?VzFpUndWYUVXcEVFMmZ5TTNZYUF3Rkp5eHlLNUxvLzVzVUQ4REEzZFBXS3l2?=
 =?utf-8?B?dmVQM3FTY2VpVE9SaTRCLzVkYmFqV2VvSTFxZWdmbTB6VGF4cGlrZ2dPUW9G?=
 =?utf-8?B?SjJXZ2YvY0JlUm02Nk53SlE5Z3BtdElCUlVaeFJ2eXJHdDhPZDlhbUxIYmNw?=
 =?utf-8?B?RVE3cXdhN3c0MnFZVnduRVNDMkJOWFRNckFDQVRZOXppTGkySXBIOEpUenBL?=
 =?utf-8?B?cU5tQzRxSlFMU0htdk1mL0lZUEhWMXJ1SmF5b09aelhIY0tuKzlFNm1rWEN4?=
 =?utf-8?B?QnR1NXVHbUxOQ2dTbTdSaHlDbWc2U29GaGVKWkIxUGZGVFlwNmgzVC9GTCtZ?=
 =?utf-8?B?VThQQUFpbWQybkJtMUFrdHMzQXg1UDlYWTYvc2RNalJiV0ZXUlNabVZKWWZr?=
 =?utf-8?B?dnBuMkQ4bEFoU2dsZmNZNjBpMDAva1dQOHZ5UCtFQ3pqb01JU1d3cTQvVnRH?=
 =?utf-8?B?RHB3SFZEaGt3TjZxOWpEUUM5VWZyc2RvUGMzbitpK2tHMEdTOElHTEYrL3oz?=
 =?utf-8?B?ZklXcVBTSU1mbG5FVFFraU5oYzdLUFFoTUhJZnZvVVZJMmVJRm5yN2hTK1JX?=
 =?utf-8?B?NFZqOUlvbHdFV1lUZzR2Q1JKOXpxWjJyRVEwWTRjNStYblVvVHlveVRJcUcz?=
 =?utf-8?B?dzNFMFRzd2xZR2lKV29MazNNVlFUbXBlZlVUemJ0YmJHakxPTGZmcHhtY0Zi?=
 =?utf-8?B?UmpMcUFabTc3UXdmbERuL0x6MXU2K0w4dmdVejRWeHJxYTVkdFc3V3lFLy93?=
 =?utf-8?B?U21Yc01OdUQzc01nblA4cG5icnJZTHk5bFdyS01JY3o0WWV1YTlWRjVTYmh2?=
 =?utf-8?B?QWtyYkc5VjdZY0gvejIxQ0s2ZlpkdVF1OW52aTFybXpKVjNNL2ZBdW1Udmlm?=
 =?utf-8?B?SURyaVhZbXZpUUgyY0pOYVc1b3dVWFI5ZzlPbzVzZEFaS2QwSEtXZnRMUG1X?=
 =?utf-8?B?OFJnSnViSTY5b0FISU14Yzd6V3JEenhFSHNaaDdLWHk3QkM2bk1OOFI4R0VO?=
 =?utf-8?B?bGdDWUVDQThkejkrbm1RdVkraU1GYnN6QkVrZVpHbSs3U0NyeEhXQXYvd1My?=
 =?utf-8?B?V1g2cXRpRzN2SXllenJNTU5nRk1mQkErQXlaSi9aZi9GbWJIR2dVQ1h4cTU0?=
 =?utf-8?B?Rzh1SjFGQnYzOHZGMkdOVUlCT2E4UEF0Z2ppWWNaNjAvNjNabzRjeS8rTUpw?=
 =?utf-8?B?TzIvWDRLTUNYQ0RBbWFwNERaSWg2clVOVDFvQ3JMeUNiY3hVb3p6S1pDTkp6?=
 =?utf-8?B?UUROdVU4c21QbURCSFdNMktEd2RxZmJLRjAvTmZRYlBmcDE1c2ppWFNoZFA0?=
 =?utf-8?B?MmF6Tk55TDlnRjBBVkZnWkRxSkp5WGxQQjlFK3NmRnhZNFl3bzRkd3dHRkc2?=
 =?utf-8?B?dUs1Rk5UYWx0NGpVSUJmY041WlRkaWVjRjhVM01UaVZnd3hsamJVZFVYa1ZU?=
 =?utf-8?B?azVOaSthbGFXMmxkZGluUUJ4SGQzZS9XYjJxSGR1OEd0dUFsMVloSTA4NzhP?=
 =?utf-8?B?OEp1NmszOTNncFJ4QVVkVkthNlFDZVhjVGx3cjZ1M016TTkwS1lOZ0JwakM1?=
 =?utf-8?B?eDcxUXVhQ1BURmRKUXlJejhVSWZDbElQdHF4bXZwalBURjZwV3djclZydzda?=
 =?utf-8?B?Qi9MQ1R4NmdJTFE0ZnJGdFpXNW9KeEFPbVdjaExBdTlBN05RanVFbkpUajRY?=
 =?utf-8?B?bzVVUFhQKyt6Z25XUkYvenRTbnVPbUx5QlRLcE1pSVdEanNlR0tSang0VEVv?=
 =?utf-8?B?UnoxYnphTGJLWWRqeksvcVhVd0o4YWNPV1QwdWJPcjJhTzJIcnJlaUJGc0kv?=
 =?utf-8?Q?h0LvEkRFoWPrmGyHYve11NQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2190A0C62C6B64D9E685EE18C9F3EA6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc77bec-75d0-48b8-2eea-08db2158766f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 11:13:23.0268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0cru1j+TeOQIH9Zbunq+o1TciYe/VY598ePWb8j8bUebFbEHGbzWG888TyMD7VYLeRZJ6zbJrtFAqiFCccnFY7GAng/IyrMt5pknwpCnzQE8meWmwxQndixzubU/jvfa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5399
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsLA0KDQpJIHdvdWxkIGxpa2UgdG8gYWRkIE1pY3JvY2hpcCdzIExBTjg2NXggMTBCQVNF
LVQxUyBNQUMtUEhZIGRyaXZlciANCnN1cHBvcnQgdG8gTGludXgga2VybmVsLg0KKFByb2R1Y3Qg
bGluazogaHR0cHM6Ly93d3cubWljcm9jaGlwLmNvbS9lbi11cy9wcm9kdWN0L0xBTjg2NTApDQoN
ClRoZSBMQU44NjUwIGNvbWJpbmVzIGEgTWVkaWEgQWNjZXNzIENvbnRyb2xsZXIgKE1BQykgYW5k
IGFuIEV0aGVybmV0IFBIWSANCnRvIGFjY2VzcyAxMEJBU0XigJFUMVMgbmV0d29ya3MuIFRoZSBj
b21tb24gc3RhbmRhcmQgU2VyaWFsIFBlcmlwaGVyYWwgDQpJbnRlcmZhY2UgKFNQSSkgaXMgdXNl
ZCBzbyB0aGF0IHRoZSB0cmFuc2ZlciBvZiBFdGhlcm5ldCBwYWNrZXRzIGFuZCANCkxBTjg2NTAg
Y29udHJvbC9zdGF0dXMgY29tbWFuZHMgYXJlIHBlcmZvcm1lZCBvdmVyIGEgc2luZ2xlLCBzZXJp
YWwgDQppbnRlcmZhY2UuDQoNCkV0aGVybmV0IHBhY2tldHMgYXJlIHNlZ21lbnRlZCBhbmQgdHJh
bnNmZXJyZWQgb3ZlciB0aGUgc2VyaWFsIGludGVyZmFjZQ0KYWNjb3JkaW5nIHRvIHRoZSBPUEVO
IEFsbGlhbmNlIDEwQkFTReKAkVQxeCBNQUPigJFQSFkgU2VyaWFsIEludGVyZmFjZSANCnNwZWNp
ZmljYXRpb24gZGVzaWduZWQgYnkgVEM2Lg0KKGxpbms6IGh0dHBzOi8vd3d3Lm9wZW5zaWcub3Jn
L0F1dG9tb3RpdmUtRXRoZXJuZXQtU3BlY2lmaWNhdGlvbnMvKQ0KVGhlIHNlcmlhbCBpbnRlcmZh
Y2UgcHJvdG9jb2wgY2FuIHNpbXVsdGFuZW91c2x5IHRyYW5zZmVyIGJvdGggdHJhbnNtaXQgDQph
bmQgcmVjZWl2ZSBwYWNrZXRzIGJldHdlZW4gdGhlIGhvc3QgYW5kIHRoZSBMQU44NjUwLg0KDQpC
YXNpY2FsbHkgdGhlIGRyaXZlciBjb21wcmlzZXMgb2YgdHdvIHBhcnRzLiBPbmUgcGFydCBpcyB0
byBpbnRlcmZhY2UgDQp3aXRoIG5ldHdvcmtpbmcgc3Vic3lzdGVtIGFuZCBTUEkgc3Vic3lzdGVt
LiBUaGUgb3RoZXIgcGFydCBpcyBhIFRDNiANCnN0YXRlIG1hY2hpbmUgd2hpY2ggaW1wbGVtZW50
cyB0aGUgRXRoZXJuZXQgcGFja2V0cyBzZWdtZW50YXRpb24gDQphY2NvcmRpbmcgdG8gT1BFTiBB
bGxpYW5jZSAxMEJBU0XigJFUMXggTUFD4oCRUEhZIFNlcmlhbCBJbnRlcmZhY2UgDQpzcGVjaWZp
Y2F0aW9uLg0KDQpUaGUgaWRlYSBiZWhpbmQgdGhlIFRDNiBzdGF0ZSBtYWNoaW5lIGltcGxlbWVu
dGF0aW9uIGlzIHRvIG1ha2UgaXQgYXMgYSANCmdlbmVyaWMgbGlicmFyeSBhbmQgcGxhdGZvcm0g
aW5kZXBlbmRlbnQuIEEgc2V0IG9mIEFQSSdzIHByb3ZpZGVkIGJ5IA0KdGhpcyBUQzYgc3RhdGUg
bWFjaGluZSBsaWJyYXJ5IGNhbiBiZSB1c2VkIGJ5IHRoZSAxMEJBU0UtVDF4IE1BQy1QSFkgDQpk
cml2ZXJzIHRvIHNlZ21lbnQgdGhlIEV0aGVybmV0IHBhY2tldHMgYWNjb3JkaW5nIHRvIHRoZSBP
UEVOIEFsbGlhbmNlIA0KMTBCQVNF4oCRVDF4IE1BQ+KAkVBIWSBTZXJpYWwgSW50ZXJmYWNlIHNw
ZWNpZmljYXRpb24uDQoNCldpdGggdGhlIGFib3ZlIGluZm9ybWF0aW9uLCBraW5kbHkgcHJvdmlk
ZSB5b3VyIHZhbHVhYmxlIGZlZWRiYWNrIG9uIG15IA0KYmVsb3cgcXVlcmllcy4NCg0KQ2FuIHdl
IGtlZXAgdGhpcyBUQzYgc3RhdGUgbWFjaGluZSB3aXRoaW4gdGhlIExBTjg2NXggZHJpdmVyIG9y
IGFzIGEgDQpzZXBhcmF0ZSBnZW5lcmljIGxpYnJhcnkgYWNjZXNzaWJsZSBmb3Igb3RoZXIgMTBC
QVNFLVQxeCBNQUMtUEhZIGRyaXZlcnMgDQphcyB3ZWxsPw0KDQpJZiB5b3UgcmVjb21tZW5kIHRv
IGhhdmUgdGhhdCBhcyBhIHNlcGFyYXRlIGdlbmVyaWMgbGlicmFyeSB0aGVuIGNvdWxkIA0KeW91
IHBsZWFzZSBhZHZpY2Ugb24gd2hhdCBpcyB0aGUgYmVzdCB3YXkgdG8gZG8gdGhhdCBpbiBrZXJu
ZWw/DQoNCkkgYW0gdmVyeSBpbnRlcmVzdGVkIHRvIGhlYXIgeW91ciBvcGluaW9uIG9uIHRoaXMg
dG9waWMuIFBsZWFzZSBsZXQgbWUgDQprbm93IGluIGNhc2UgeW91IG5lZWQgbW9yZSBpbmZvcm1h
dGlvbiBvbiB0aGlzLg0KDQpCZXN0IFJlZ2FyZHMsDQpQYXJ0aGliYW4gVg0K
