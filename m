Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B54E745A
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 14:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357713AbiCYNnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 09:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiCYNn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 09:43:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117ADD0809
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648215714; x=1679751714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xmLOP5XOVDvnWLV/aVbsLWJ13WbIADBCEJvPUC9Fyv8=;
  b=nsmWh9vAgZ7nL0mmTYRfesLxgJ5O0QAQEDtWcfe+W15/bj+ytA6NQlmy
   jgOxyEs+jzlPuONKy7NjlCcGpbhTz14k4Umr1vtQHHjdH+Ur5R4bCAiJ6
   RWZr9AZHrrYhef2L666XO7mWnqBGpxavzSi9uuwO64FAeJ+rXrjN83+gn
   WtfNzvKEbOGRJv/Vju9p8Lw8RdnAO5uPswQM03wMAwXFThINmBwRDCqjy
   5arKvv3GFtXGtKhMflUqao5OrN73HJ/vG4/bwgZd5Nr3zklzSNP/BrKcu
   lZ/OOnycotpdTI6VNZbcmOWfK4vOM+yrL5n38o835HmHVY/mxkVviNyEP
   A==;
X-IronPort-AV: E=Sophos;i="5.90,209,1643698800"; 
   d="scan'208";a="150428944"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2022 06:41:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Mar 2022 06:41:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 25 Mar 2022 06:41:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVaMoGp2dJTrG6HkNeLnWk1pike0bfXG5vahwFbzpPy1cM5i1RJpNk6bnfeNZmSijNTKe0lMc35CKkrgafYcRRFrDqoixAIQjTOd/XCUmfIIXMnqxjbrlvzaN7QKG+96Wu5GdybPpTtl9Ugc3BjcOzWJaGbGBxFyaDFmPc/2qiOfzvd6OdeEgPEXmfbqsOJdRjhGq8HFvLAFKrvxLfoCG2xpO3FCE5UV3Vr5FPjh0hzKpYbMxc/blR3zfKxYWLbohelbMtINOXKVI23wZqry6aJxSfJqO/SIaML9k48S66226Q3dKE9JCjL/+b1Iamd3CAkw4kTK0/1/jYt6x9Yj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmLOP5XOVDvnWLV/aVbsLWJ13WbIADBCEJvPUC9Fyv8=;
 b=mbTbfPcsKiWMCoo2OEGdtv2BexWO89mca0EnlzYhCZT1luo+LlQtHdN9I7MQF2p22uEe8BVZzl9k9q/OHq5fzqiHktqcq8C6KhmU49poSL+0MkX2FGi+g3hK9AnqgPZI0CZYUm82GgXqVRgff5BNRWK1G1PE+48/okCLi7uT43zUxYWBq19gQCrJvBA5gBK5wFROlSBJDz8d2IM6MHhD1Unrq6VzKRhDTAzx8WsXuI6WXt1FAD4Z87V6X+c1mJ+WCoYS4WTfg9ZKlZTn2Zybi+rfaJ+qREFYuyWsuo39GjY0jOJweqvNVyRThnYAIz4ey6MSmzOJG3mJZHvquszm7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmLOP5XOVDvnWLV/aVbsLWJ13WbIADBCEJvPUC9Fyv8=;
 b=finoGwWz9MTV3Z5q6rGrbgL1++YYcHPEPpvbssgb3MTQxfKSDO0u505rRpE3NuL8SJnbH+fgwL9effKQy1hxvD1+bGSti77XS6eTThx46Z4Oj2saoCK/J7BQlviIoA9m+zdconeLDW3RbpDRzrji0yOQtMlIdA+6w4Rpq0aKmGo=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MWHPR11MB1888.namprd11.prod.outlook.com (2603:10b6:300:10e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Fri, 25 Mar
 2022 13:41:50 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 13:41:50 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <tomas.melin@vaisala.com>, <netdev@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Thread-Topic: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Thread-Index: AQHYQCZQfBYaRO5M1UGfluJdpjZcjQ==
Date:   Fri, 25 Mar 2022 13:41:50 +0000
Message-ID: <b643b825-e68a-875e-f4ac-edddae613705@microchip.com>
References: <20220325065012.279642-1-tomas.melin@vaisala.com>
 <64feeb9e-0e28-0441-4d42-20e3f5ec7a7a@microchip.com>
 <7310fea8-8f55-a198-5317-a7ad95980beb@vaisala.com>
In-Reply-To: <7310fea8-8f55-a198-5317-a7ad95980beb@vaisala.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfcc6297-69f9-4485-786e-08da0e6536ff
x-ms-traffictypediagnostic: MWHPR11MB1888:EE_
x-microsoft-antispam-prvs: <MWHPR11MB18885EA4D891D2B714FF7C79871A9@MWHPR11MB1888.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fBemBtliU5/6778/5CqYWHG3LNMimO0mGLZ2cXT9ReswWeKB76gvH77E/1qEzZxAZ2rv9BNhnjJ4P5V5WSYS0kX1kiw4+C2IE58M9V2gRHmax0+CCu/fCv1ugUj1+Hqo8AT9FRFYJNVgxtq5pVqpm2c1jtDDXJAi8SgjGH2ImEyxSnxWPdxEn8j8RNjMOWwzjAmzYiKgNNDbkJi3jqbWzHomDANx+VYxvxYzUREm92hl8HfoMdSgUBj+YfyidpLhJcS7FfD339IfWMlbpCjBLLx4fKJiSjC1pC0Sd4vCK+1Wj8+DlTYmgXouhPPLhmKBqF6VrpnX55Iib2h3Rhoc06FPIFB/aMu4u9w4pmRqoWJ6sxDyqbjbq2wm8/87pTd8wIJcwCGB0Adqd+nbCA2aBIj4pTgCTXz891GebJXKdrNwVLIdyQNj3WTRcOlyWfCX5Td0420G6/aIK24XfhjEgqWTYIjDrVluOcW946EM6QX9Ondd8tv3cUex03zaomoI0Ph5KTWYo6i2g0CTY//+k4kQxbJkBIOZrgWa30ng2JbEZz5zAmk0/zVUQhNxm+T54WS6bXvtwg/9yyN9Bfbi7kjt6AAoLs5QRowkbtTjp1Ucvu1jSJRvNca9R0iWySeaBMyDtVKNaXHaWKZTYVCt4d3olm8IF1Se78SgAHocjK8wiPd4gM7kn8qBi0c0yxf31jM+lIYueHvgZGT31IueBIOisLVXgD0Sc/VYbfpdEhAROzqjcooqwcAOKEvSw5n2NM2vI/5JKsd1g92pjTkm+Gp0TT2opgswhKMGL2FlEEqSP7jIvFzJFOvNbhXfWzzsWkg3N4DuOJT1oTFmxk81qyI6vRK+l2oXvuAxWCrRv0GnjvwAXj0jhOiHTdJPRCZQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(316002)(45080400002)(6506007)(6512007)(508600001)(2906002)(31686004)(6486002)(38100700002)(8936002)(966005)(8676002)(4326008)(2616005)(5660300002)(66446008)(66476007)(66556008)(64756008)(31696002)(122000001)(83380400001)(86362001)(66946007)(71200400001)(110136005)(54906003)(36756003)(186003)(76116006)(26005)(38070700005)(91956017)(43740500002)(45980500001)(10090945011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVV6RDZPYXhtY2M0V2pzSUdnMU9JRVdueE1zZ1gzc3Y1NjZ1VGZWT3p5V2xF?=
 =?utf-8?B?S0pqa29ITFlPNDRMZE1yNkF3UmdBdDVySFJRR3NmaDlwT2NnU0I1c2lvY3hV?=
 =?utf-8?B?c3dNbUFJc1I5UUNCSUU0aEZCR3RlVjJpOTIvU2owbldHN1BJc3BIMTB2c1du?=
 =?utf-8?B?YmJSZnpNblUzSUt5KzN0ZEZaZTlOcWRnVHJPVjZlNGdtLyt2dFVocEY4ZmpJ?=
 =?utf-8?B?N3NOWHZzTHVTOWNYbXErTlBabWUyaGd3bm1kN3h1WHUvSitSVTRzTEJZTE44?=
 =?utf-8?B?eHRJeUZGM0kzS0pYcnhGWHlmRlJad3kzUy95UEJnUmNwaXFlRTRLait5UnV0?=
 =?utf-8?B?UlVkRUNVbEU3MUJmSlp4c01VRkNZRmM3c0JSbkxCdktuN0lQSWJ1TkdaV05y?=
 =?utf-8?B?SkdJME83Q3p0bjNyOWd1R1Y5dmxFVnhRZFIzSGI5eWxQL3l5NWQ0RXVHMFU3?=
 =?utf-8?B?aU1hODBWb015Q0JxZHdhWmpaV3pDd2kyVXY2azF4eTQrVjVPSUV6OFpFYzBZ?=
 =?utf-8?B?WG1temlnaCtBalVBOVBJWHB5VE1GdktCL2pzL1BNcmlHM01mRzBsVHRsNmRr?=
 =?utf-8?B?aktkVkV4RW9oSmZrcE9CN29oSTZJUEtkN3FkalNjNUJRSkcycVFKdmNGYVJB?=
 =?utf-8?B?N0JVWTBtd28yQkhObTBHRXdZd1NZVnQ1ODNtSkhhZjhhRmVTL3BNcUhpM291?=
 =?utf-8?B?b2ZOYWFyWnNUVGRwUlEwWG8xKyt1MGxYUHZTbStUNXZxSXRRN1NtSnRLVmY5?=
 =?utf-8?B?Vk9kc2N2YnlqZ1BtdmR2THBlbDJvNU1sT1JsSk8rUC9UUzk1MmtGU1dic0FL?=
 =?utf-8?B?Y0dJTTNIMkFlWDhWMmhaT28wT0FTQWtxb2ZZOVRVMXZVNXhOd25BeTE3blll?=
 =?utf-8?B?Q0RkQzFKanFkMWY5b2FRdGxITmFZNUpjQm1oOUl3Snhrd2xya1lNWVhMZ1BU?=
 =?utf-8?B?QUcwRE5WcUFBQ01VRytXRGJjTElPb1dRcENqYnVmSXkyU2ZCZUkzNW1TcWt0?=
 =?utf-8?B?ZXlNMFFMcmlxWlR2Yng0a0x1ZHFaRThIdHV2dEVUQ0ZqWmJ3NTVOZ1A0UmlO?=
 =?utf-8?B?ZkhJNHVYTkh4ZU9oUzkyVWgwNGV4aXBPb1hFY09HWEEyK0RBL1I0NnhEMkdV?=
 =?utf-8?B?TGVteWpxZmZ1bEpJRjU5L0owcklyYjVrdnlKSHFVZStvc0VDQVZjV2gxdCsw?=
 =?utf-8?B?Syt2WE1QTkVWNFlSd1FlUldRd2V3MlZsRktNWnZqWUlNVnpLQ2l6SEFSZmZv?=
 =?utf-8?B?SUNuTGJPY1g0QzBhTkRkNXdiaTlwSHBlSjFGMHdtRGd0MFJnNlgxWFVRMGs1?=
 =?utf-8?B?bENZeTdEcE9PQ1R4S2VURWZtUnRUVVBwaGtpNm5GSFphWGoxVEhkZzh4RG1T?=
 =?utf-8?B?RzdLaTlycTJld1BLcVUyY1Q1SEZ3bHNaZlZ6RWNOZDZ0S3V1eDVTZFFqN05U?=
 =?utf-8?B?a0ZzQXIzdFlXb0x1aUtmSWdVeUJndEc3UUdLUDNyMjFmcGM0RUNKZEkrTzlt?=
 =?utf-8?B?N1o0ekVlbVFYdzJ0eDMzUWlZbG5SYkQ2R0kwZ2xOU011NUtCdlZqMHd3NWtk?=
 =?utf-8?B?V3ZoWjlNT09wWjBQbVdwcWdKUjFBTXN3N1pERHBDbENqd28za3RhbHVtdVhB?=
 =?utf-8?B?b1BpSGtaWnppazdXbVI0c1Z5Y0k1WS9uMko4ZnBTd3FWS205b25UdUhPOFkw?=
 =?utf-8?B?aWo2bmZhQjJjc2FuK2FsQm9TNnRTN283MkVTYjJocVAxU1RCYi9ZajVNNmUy?=
 =?utf-8?B?R1dzTERwSWZzOFNLVlhaeENyUUJPa3gvVTg1L0FhRGpBc1NWSWJWaDFJVTJ6?=
 =?utf-8?B?V1JKVEVLMDJKTlVvWHJOVStqWXl0bGJNeldPNWdidTFYeHF3RWJucno4T1d6?=
 =?utf-8?B?ZDI2b0phaVhEVzcyRURVZjZhVzZOWDg5T1NpemZuc0hPekt3ZW9Ubmw3amkz?=
 =?utf-8?B?SXhxOGJ1Rll1c0o2SnNWR0QvNDRLQXpRSDRzK01rMFhPQ1IrZGhtdldsN3V6?=
 =?utf-8?B?cGNGNGRub1Q5ZlpIQ3ZJZkxwdDFhQk1FaUV3ZWhtTWVEMDNoUU1QcloyNDRy?=
 =?utf-8?B?dHN5V1ZtV1RnanRKNlpjNC9HL3VicytJcndTTnA2YmxmWWx2UFpXcUdvVGxR?=
 =?utf-8?B?ZUpPRFlMUDBKMkJsOHphd2NZbVBocEZUSzdlR3JQK0s3Zm9oREJYWFl3S1Zy?=
 =?utf-8?B?OFgwYk1MNlFaZmJjR1AwOUxSSHFzcUEyUzdrbXRlbHcwV0J0bGZHNVUzTzBw?=
 =?utf-8?B?Mk12OUZoc05PVWhQWGQzWU1McW9VUGFHNGVVRkhvdDB1a1ZEbXREL2tQb0Jh?=
 =?utf-8?B?UFVzY0pUSFQ1a2x1ZWQzcVVnMml1aEZJL2R4NkgyWDl4bHRWU2JpR0gwT0No?=
 =?utf-8?Q?UlQ/dDwY1wpIowKY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68AE5386C028B84E96AC32E0026B7D34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcc6297-69f9-4485-786e-08da0e6536ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 13:41:50.2763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0H43sg1RFfBMCDXCP2rt68FgeIV11rXmQGjKhhLNFszGKUWfPSzqllS/p2DoY25Uk/fGZUejwLe9jSqtlFQ1pwNitQHiXYO66OevhjGGago=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1888
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUuMDMuMjAyMiAxMTozNSwgVG9tYXMgTWVsaW4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlDQo+IGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGksDQo+IA0KPiBPbiAyNS8wMy8yMDIyIDEw
OjU3LCBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4gT24gMjUuMDMuMjAy
MiAwODo1MCwgVG9tYXMgTWVsaW4gd3JvdGU6DQo+Pj4gW1NvbWUgcGVvcGxlIHdobyByZWNlaXZl
ZCB0aGlzIG1lc3NhZ2UgZG9uJ3Qgb2Z0ZW4gZ2V0IGVtYWlsIGZyb20NCj4+PiB0b21hcy5tZWxp
bkB2YWlzYWxhLmNvbS4gTGVhcm4gd2h5IHRoaXMgaXMgaW1wb3J0YW50IGF0DQo+Pj4gaHR0cDov
L2FrYS5tcy9MZWFybkFib3V0U2VuZGVySWRlbnRpZmljYXRpb24uXQ0KPj4+DQo+Pj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdw0KPj4+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+Pg0KPj4+IGNvbW1pdCA1ZWE5YzA4
YTg2OTIgKCJuZXQ6IG1hY2I6IHJlc3RhcnQgdHggYWZ0ZXIgdHggdXNlZCBiaXQgcmVhZCIpDQo+
Pj4gYWRkZWQgc3VwcG9ydCBmb3IgcmVzdGFydGluZyB0cmFuc21pc3Npb24uIFJlc3RhcnRpbmcg
dHggZG9lcyBub3Qgd29yaw0KPj4+IGluIGNhc2UgY29udHJvbGxlciBhc3NlcnRzIFRYVUJSIGlu
dGVycnVwdCBhbmQgVFFCUCBpcyBhbHJlYWR5IGF0IHRoZSBlbmQNCj4+PiBvZiB0aGUgdHggcXVl
dWUuIEluIHRoYXQgc2l0dWF0aW9uLCByZXN0YXJ0aW5nIHR4IHdpbGwgaW1tZWRpYXRlbHkgY2F1
c2UNCj4+PiBhc3NlcnRpb24gb2YgYW5vdGhlciBUWFVCUiBpbnRlcnJ1cHQuIFRoZSBkcml2ZXIg
d2lsbCBlbmQgdXAgaW4gYW4gaW5maW5pdGUNCj4+PiBpbnRlcnJ1cHQgbG9vcCB3aGljaCBpdCBj
YW5ub3QgYnJlYWsgb3V0IG9mLg0KPj4+DQo+Pj4gRm9yIGNhc2VzIHdoZXJlIFRRQlAgaXMgYXQg
dGhlIGVuZCBvZiB0aGUgdHggcXVldWUsIGluc3RlYWQNCj4+PiBvbmx5IGNsZWFyIFRYVUJSIGlu
dGVycnVwdC4gQXMgbW9yZSBkYXRhIGdldHMgcHVzaGVkIHRvIHRoZSBxdWV1ZSwNCj4+PiB0cmFu
c21pc3Npb24gd2lsbCByZXN1bWUuDQo+Pj4NCj4+PiBUaGlzIGlzc3VlIHdhcyBvYnNlcnZlZCBv
biBhIFhpbGlueCBaeW5xIGJhc2VkIGJvYXJkLiBEdXJpbmcgc3RyZXNzIHRlc3Qgb2YNCj4+PiB0
aGUgbmV0d29yayBpbnRlcmZhY2UsIGRyaXZlciB3b3VsZCBnZXQgc3R1Y2sgb24gaW50ZXJydXB0
IGxvb3ANCj4+PiB3aXRoaW4gc2Vjb25kcyBvciBtaW51dGVzIGNhdXNpbmcgQ1BVIHRvIHN0YWxs
Lg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogVG9tYXMgTWVsaW4gPHRvbWFzLm1lbGluQHZhaXNh
bGEuY29tPg0KPj4+IC0tLQ0KPj4+IMKgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yl9tYWluLmMgfCA4ICsrKysrKysrDQo+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMNCj4+PiBpbmRleCA4MDBkNWNlZDU4MDAuLmU0NzViZTI5ODQ1YyAxMDA2NDQNCj4+PiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+Pj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4+IEBAIC0xNjU4LDYgKzE2
NTgsNyBAQCBzdGF0aWMgdm9pZCBtYWNiX3R4X3Jlc3RhcnQoc3RydWN0IG1hY2JfcXVldWUgKnF1
ZXVlKQ0KPj4+IMKgwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IGhlYWQgPSBxdWV1ZS0+dHhf
aGVhZDsNCj4+PiDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCB0YWlsID0gcXVldWUtPnR4
X3RhaWw7DQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgbWFjYiAqYnAgPSBxdWV1ZS0+YnA7
DQo+Pj4gK8KgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgaGVhZF9pZHgsIHRicXA7DQo+Pj4NCj4+
PiDCoMKgwqDCoMKgwqDCoMKgIGlmIChicC0+Y2FwcyAmIE1BQ0JfQ0FQU19JU1JfQ0xFQVJfT05f
V1JJVEUpDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcXVldWVfd3JpdGVs
KHF1ZXVlLCBJU1IsIE1BQ0JfQklUKFRYVUJSKSk7DQo+Pj4gQEAgLTE2NjUsNiArMTY2NiwxMyBA
QCBzdGF0aWMgdm9pZCBtYWNiX3R4X3Jlc3RhcnQoc3RydWN0IG1hY2JfcXVldWUNCj4+PiAqcXVl
dWUpDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCBpZiAoaGVhZCA9PSB0YWlsKQ0KPj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsNCj4+Pg0KPj4+ICvCoMKgwqDCoMKgwqAg
dGJxcCA9IHF1ZXVlX3JlYWRsKHF1ZXVlLCBUQlFQKSAvIG1hY2JfZG1hX2Rlc2NfZ2V0X3NpemUo
YnApOw0KPj4+ICvCoMKgwqDCoMKgwqAgdGJxcCA9IG1hY2JfYWRqX2RtYV9kZXNjX2lkeChicCwg
bWFjYl90eF9yaW5nX3dyYXAoYnAsIHRicXApKTsNCj4+PiArwqDCoMKgwqDCoMKgIGhlYWRfaWR4
ID0gbWFjYl9hZGpfZG1hX2Rlc2NfaWR4KGJwLCBtYWNiX3R4X3Jpbmdfd3JhcChicCwgaGVhZCkp
Ow0KPj4+ICsNCj4+PiArwqDCoMKgwqDCoMKgIGlmICh0YnFwID09IGhlYWRfaWR4KQ0KPj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsNCj4+PiArDQo+Pg0KPj4gVGhpcyBs
b29rcyBsaWtlIFRCUVAgaXMgbm90IGFkdmFuY2luZyB0aG91Z2ggdGhlcmUgYXJlIHBhY2tldHMg
aW4gdGhlDQo+PiBzb2Z0d2FyZSBxdWV1ZXMgKGhlYWQgIT0gdGFpbCkuIFBhY2tldHMgYXJlIGFk
ZGVkIGluIHRoZSBzb2Z0d2FyZSBxdWV1ZXMgb24NCj4+IFRYIHBhdGggYW5kIHJlbW92ZWQgd2hl
biBUWCB3YXMgZG9uZSBmb3IgdGhlbS4NCj4gDQo+IFRCUVAgaXMgYXQgdGhlIGVuZCBvZiB0aGUg
cXVldWUsIGFuZCB0aGF0IG1hdGNoZXMgd2l0aCB0eF9oZWFkDQo+IG1haW50YWluZWQgYnkgZHJp
dmVyLiBTbyBzZWVtcyBjb250cm9sbGVyIGlzIGhhcHBpbHkgYXQgZW5kIG1hcmtlciwNCj4gYW5k
IHdoZW4gcmVzdGFydGVkIGltbWVkaWF0ZWx5IHNlZXMgdGhhdCBlbmQgbWFya2VyIHVzZWQgdGFn
IGFuZA0KPiB0cmlnZ2VycyBhbiBpbnRlcnJ1cHQgYWdhaW4uDQo+IA0KPiBBbHNvIHdoZW4gbG9v
a2luZyBhdCB0aGUgYnVmZmVyIGRlc2NyaXB0b3IgbWVtb3J5IGl0IHNob3dzIHRoYXQgYWxsDQo+
IGZyYW1lcyBiZXR3ZWVuIHR4X3RhaWwgYW5kIHR4X2hlYWQgaGF2ZSBiZWVuIG1hcmtlZCBhcyB1
c2VkLg0KDQpJIHNlZS4gQ29udHJvbGxlciBzZXRzIFRYX1VTRUQgb24gdGhlIDFzdCBkZXNjcmlw
dG9yIG9mIHRoZSB0cmFuc21pdHRlZA0KZnJhbWUuIElmIHRoZXJlIHdlcmUgcGFja2V0cyB3aXRo
IG9uZSBkZXNjcmlwdG9yIGVucXVldWVkIHRoYXQgc2hvdWxkIG1lYW4NCmNvbnRyb2xsZXIgZGlk
IGl0cyBqb2IuDQoNCmhlYWQgIT0gdGFpbCBvbiBzb2Z0d2FyZSBkYXRhIHN0cnVjdHVyZXMgd2hl
biByZWNlaXZpbmcgVFhVQlIgaW50ZXJydXB0IGFuZA0KYWxsIGRlc2NyaXB0b3JzIGluIHF1ZXVl
IGhhdmUgVFhfVVNFRCBiaXQgc2V0IG1pZ2h0IHNpZ25hbCB0aGF0ICBhDQpkZXNjcmlwdG9yIGlz
IG5vdCB1cGRhdGVkIHRvIENQVSBvbiBUQ09NUCBpbnRlcnJ1cHQgd2hlbiBDUFUgdXNlcyBpdCBh
bmQNCnRodXMgZHJpdmVyIGRvZXNuJ3QgdHJlYXQgYSBUQ09NUCBpbnRlcnJ1cHQuIFNlZSB0aGUg
YWJvdmUgY29kZSBvbg0KbWFjYl90eF9pbnRlcnJ1cHQoKToNCg0KZGVzYyA9IG1hY2JfdHhfZGVz
YyhxdWV1ZSwgdGFpbCk7DQoNCi8qIE1ha2UgaHcgZGVzY3JpcHRvciB1cGRhdGVzIHZpc2libGUg
dG8gQ1BVICovDQpybWIoKTsNCg0KY3RybCA9IGRlc2MtPmN0cmw7DQoNCi8qIFRYX1VTRUQgYml0
IGlzIG9ubHkgc2V0IGJ5IGhhcmR3YXJlIG9uIHRoZSB2ZXJ5IGZpcnN0IGJ1ZmZlcg0KKiBkZXNj
cmlwdG9yIG9mIHRoZSB0cmFuc21pdHRlZCBmcmFtZS4NCiovDQoNCmlmICghKGN0cmwgJiBNQUNC
X0JJVChUWF9VU0VEKSkpDQoJYnJlYWs7DQoNCg0KPiANCj4gR0VNIGRvY3VtZW50YXRpb24gc2F5
cyAidHJhbnNtaXNzaW9uIGlzIHJlc3RhcnRlZCBmcm9tDQo+IHRoZSBmaXJzdCBidWZmZXIgZGVz
Y3JpcHRvciBvZiB0aGUgZnJhbWUgYmVpbmcgdHJhbnNtaXR0ZWQgd2hlbiB0aGUNCj4gdHJhbnNt
aXQgc3RhcnQgYml0IGlzIHJld3JpdHRlbiIgYnV0IHNpbmNlIGFsbCBmcmFtZXMgYXJlIGFscmVh
ZHkgbWFya2VkDQo+IGFzIHRyYW5zbWl0dGVkLCByZXN0YXJ0aW5nIHdvbnQgaGVscC4gQWRkaW5n
IHRoaXMgYWRkaXRpb25hbCBjaGVjayB3aWxsDQo+IGhlbHAgZm9yIHRoZSBpc3N1ZSB3ZSBoYXZl
Lg0KPiANCg0KSSBzZWUgYnV0IGFjY29yZGluZyB0byB5b3VyIGRlc2NyaXB0aW9uIChhbGwgZGVz
Y3JpcHRvcnMgdHJlYXRlZCBieQ0KY29udHJvbGxlcikgaWYgbm8gcGFja2V0cyBhcmUgZW5xdWV1
ZWQgZm9yIFRYIGFmdGVyOg0KDQorICAgICAgIGlmICh0YnFwID09IGhlYWRfaWR4KQ0KKyAgICAg
ICAgICAgICAgIHJldHVybjsNCisNCg0KdGhlcmUgYXJlIHNvbWUgU0tCcyB0aGF0IHdlcmUgY29y
cmVjdGx5IHRyZWF0ZWQgYnkgY29udHJvbGxlciBidXQgbm90IGZyZWVkDQpieSBzb2Z0d2FyZSAo
dGhleSBhcmUgZnJlZWQgb24gbWFjYl90eF91bm1hcCgpIGNhbGxlZCBmcm9tDQptYWNiX3R4X2lu
dGVycnVwdCgpKS4gVGhleSB3aWxsIGJlIGZyZWVkIG9uIG5leHQgVENPTVAgaW50ZXJydXB0IGZv
ciBvdGhlcg0KcGFja2V0cyBiZWluZyB0cmFuc21pdHRlZC4NCg0KPiANCj4+DQo+PiBNYXliZSBU
WF9XUkFQIGlzIG1pc3Npbmcgb24gb25lIFRYIGRlc2NyaXB0b3I/IEZldyBtb250aHMgYWdvIHdo
aWxlDQo+PiBpbnZlc3RpZ2F0aW5nIHNvbWUgb3RoZXIgaXNzdWVzIG9uIHRoaXMgSSBmb3VuZCB0
aGF0IHRoaXMgbWlnaHQgYmUgbWlzc2VkDQo+PiBvbiBvbmUgZGVzY3JpcHRvciBbMV0gYnV0IGhh
dmVuJ3QgbWFuYWdlZCB0byBtYWtlIGl0IGJyZWFrIGF0IHRoYXQgcG9pbnQNCj4+IGFueWhvdy4N
Cj4+DQo+PiBDb3VsZCB5b3UgY2hlY2sgb24geW91ciBzaWRlIGlmIHRoaXMgaXMgc29sdmluZyB5
b3VyIGlzc3VlPw0KPiANCj4gSSBoYXZlIHNlZW4gdGhhdCB3ZSBjYW4gZ2V0IHN0dWNrIGF0IGFu
eSBsb2NhdGlvbiBpbiB0aGUgcmluZyBidWZmZXIsIHNvDQo+IHRoaXMgZG9lcyBub3Qgc2VlbSB0
byBiZSB0aGUgY2FzZSBoZXJlLiBJIGNhbiB0cnkgdGhvdWdoIGlmIGl0IHdvdWxkDQo+IGhhdmUg
YW55IGVmZmVjdC4NCg0KSSB3YXMgdGhpbmtpbmcgdGhhdCBoYXZpbmcgc21hbGwgcGFja2V0cyB0
aGVyZSBpcyBoaWdoIGNoYW5jZSB0aGF0IFRCUVAgdG8NCm5vdCByZWFjaCBhIGRlc2NyaXB0b3Ig
d2l0aCB3cmFwIGJpdCBzZXQgZHVlIHRvIHRoZSBjb2RlIHBvaW50ZWQgaW4gbXkNCnByZXZpb3Vz
IGVtYWlsLg0KDQpUaGFuayB5b3UsDQpDbGF1ZGl1IEJlem5lYQ0KDQo+IA0KPiB0aGFua3MsDQo+
IFRvbWFzDQo+IA0KPiANCj4+DQo+PiDCoMKgwqDCoMKgIC8qIFNldCAnVFhfVVNFRCcgYml0IGlu
IGJ1ZmZlciBkZXNjcmlwdG9yIGF0IHR4X2hlYWQgcG9zaXRpb24NCj4+IMKgwqDCoMKgwqDCoCAq
IHRvIHNldCB0aGUgZW5kIG9mIFRYIHF1ZXVlDQo+PiDCoMKgwqDCoMKgwqAgKi8NCj4+IMKgwqDC
oMKgwqAgaSA9IHR4X2hlYWQ7DQo+PiDCoMKgwqDCoMKgIGVudHJ5ID0gbWFjYl90eF9yaW5nX3dy
YXAoYnAsIGkpOw0KPj4gwqDCoMKgwqDCoCBjdHJsID0gTUFDQl9CSVQoVFhfVVNFRCk7DQo+PiAr
wqDCoMKgwqAgaWYgKGVudHJ5ID09IGJwLT50eF9yaW5nX3NpemUgLSAxKQ0KPj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBjdHJsIHw9IE1BQ0JfQklUKFRYX1dSQVApOw0KPj4gwqDCoMKgwqDC
oCBkZXNjID0gbWFjYl90eF9kZXNjKHF1ZXVlLCBlbnRyeSk7DQo+PiDCoMKgwqDCoMKgIGRlc2Mt
PmN0cmwgPSBjdHJsOw0KPj4NCj4+IFsxXQ0KPj4gaHR0cHM6Ly9ldXIwMy5zYWZlbGlua3MucHJv
dGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZ2l0Lmtlcm5lbC5vcmclMkZw
dWIlMkZzY20lMkZsaW51eCUyRmtlcm5lbCUyRmdpdCUyRnRvcnZhbGRzJTJGbGludXguZ2l0JTJG
dHJlZSUyRmRyaXZlcnMlMkZuZXQlMkZldGhlcm5ldCUyRmNhZGVuY2UlMkZtYWNiX21haW4uYyUy
M24xOTU4JmFtcDtkYXRhPTA0JTdDMDElN0N0b21hcy5tZWxpbiU0MHZhaXNhbGEuY29tJTdDMmZl
NzJlMmE2YTg3NGI1Mjc5YTcwOGRhMGUzZDc4NTIlN0M2ZDczOTNlMDQxZjU0YzJlOWIxMjRjMmJl
NWRhNWM1NyU3QzAlN0MwJTdDNjM3ODM3OTU0NDM0NzE0NDYyJTdDVW5rbm93biU3Q1RXRnBiR1pz
YjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFXd2lM
Q0pYVkNJNk1uMCUzRCU3QzMwMDAmYW1wO3NkYXRhPWhpamNmajNUbk94ajEyZGhHMFE4ZDBBSk5G
TkJKU3h0RWpPVGtDb1pUaEklM0QmYW1wO3Jlc2VydmVkPTANCj4+DQo+Pg0KPj4+IMKgwqDCoMKg
wqDCoMKgwqAgbWFjYl93cml0ZWwoYnAsIE5DUiwgbWFjYl9yZWFkbChicCwgTkNSKSB8IE1BQ0Jf
QklUKFRTVEFSVCkpOw0KPj4+IMKgIH0NCj4+Pg0KPj4+IC0tIA0KPj4+IDIuMzUuMQ0KPj4+DQo+
Pg0KDQo=
