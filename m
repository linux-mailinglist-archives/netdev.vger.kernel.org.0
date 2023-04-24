Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD896EC826
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 10:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDXIyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 04:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjDXIyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 04:54:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B34E66
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 01:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682326451; x=1713862451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kukKpm/aPcDbASzXaAX1/qewdhVlTTfSueTkOYSMRq4=;
  b=NWaXjGT6p5OcLV3frEXvDWLhDUQafl1K2DMfNtIVZD66sWJTU1Ig/g/1
   N3e3pyA2A8aTWz0SOLCOmMIAQ7+chmy6KNF1sm1S5KhEH5+5fZJdeWWEF
   kgD6XY4oiiE8tu58+776Z9joAlnWZ6vAAhGM0tnu/wh6DF5PxBLJFuzeh
   aOKVvxyEg4YoLhrGUEg/uF/zlLubMpKIboE08ILub+bcDrQ8WYO/m2rg/
   gXXibWP9MF+5HYUb7nMke38Iz88t0HTJbcUG0ah6JEEXXRi9nhzihkC48
   L0xUd69JSPZCafk5rQ7xLPU9OoPlvs1o0ybyZ5ywSADG8KUhDyED88Trp
   A==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677567600"; 
   d="scan'208";a="207945506"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2023 01:54:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 24 Apr 2023 01:54:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 24 Apr 2023 01:54:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtSnAnpIHmFjp1cf+Ljc1LlQC4wM2JPS7vhjv4sYU9vfltmeQ7tYOZPQ1jvUJfO6bt72IcXGoxWrhBuShygx7HzPYltE0J/h8DlMYXnNhD2g0oMYk63d8KOawQ5vDE+vut/drc5oKeos3bXNzPdw9AJI7VwWQnaF/xTre9/5LJJQQf7hNkooR4CvfK0KF3lJWe3TwKvhLhmA6b7A7QTqiStZiWx3GwHtVAAGLzVAffay7y7FJEmGTpC46w6nQseB0urZP5kKHDr2VH2XxcMSrNSut3rsw9w1vWwof3juugxoschtw0VtoAt6z9Z6WqEZjpvqf1XuU4sQkUHERHCbEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kukKpm/aPcDbASzXaAX1/qewdhVlTTfSueTkOYSMRq4=;
 b=OfynPHOfSDYY2qqlOaPiDk1Abh90MWya6qIeZtM1+90qGK6ca4bMGb5vjIvCUA8qNnivcNVQ8EwIOZcEGYWPNlJBsuVaIupWwlUGZzB5OqdDPGDud2oxIfWt6UXofPqv2DnjE5qlylcleSFjGTMFGEgx1GjQTciwu9yUUcl8IlErziRye2y6aufOBI1S5tCRVXYzfotgkUE8uHnLDCQ/yZNpj5w2E7XXZmCdqGte9WuNNzA63BM2WVW2bBieYxKQN4TKCSQqXx13NH/HYD6e0rAtEsOPQBVv3XzM4cm4bxF4JLOh6K6czmpiVvIw8g+h60TDKuQj/SrQ5LcYOd7hDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kukKpm/aPcDbASzXaAX1/qewdhVlTTfSueTkOYSMRq4=;
 b=U4MHwoX/+DNLi5J7wQj/uJD5a7X4y3dnGiiFZq706n16v4h7nHi6egoVoAVhreJyNvZ8BnybL6nj2QMntznErJtFqK4vVp/ytrG5ED5/RbhZu9kDqKcFr6HkB1vsQXNVcVkAifXkKOBDwi35HHNmcURGJvVOoKpx0qb7wl2FdVM=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by DS0PR11MB7852.namprd11.prod.outlook.com (2603:10b6:8:fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 08:54:02 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%3]) with mapi id 15.20.6319.022; Mon, 24 Apr 2023
 08:54:02 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <ingo.rohloff@lauterbach.com>, <robert.hancock@calian.com>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <tomas.melin@vaisala.com>
Subject: Re: [PATCH 0/1] Alternative, restart tx after tx used bit read
Thread-Topic: [PATCH 0/1] Alternative, restart tx after tx used bit read
Thread-Index: AQHZdopQh/TXxrR1U0++IK9VN/PgXg==
Date:   Mon, 24 Apr 2023 08:54:02 +0000
Message-ID: <0ceb7ed6-2535-aa40-52a4-c6a8e99dafdc@microchip.com>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
 <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
In-Reply-To: <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|DS0PR11MB7852:EE_
x-ms-office365-filtering-correlation-id: 63b70123-1311-4e07-917c-08db44a17374
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /mgLa01nh3mQ7aKjoId4MYRpPFhBCimt2Fs0UIALdZ9oITi7V+kudRAlXATvNVJAbaziYJUtnJb0lHZNjHjm65g6hwGiYdJu8yymCuzNVdWAOTiM0kLl09wWdlxK80IBo8NHoR56U2dWl/gZE1dciNoXplXmmJq5oUcj4HI3nBNH+98mIHoIER7iO622hhqBXD6EuhD8ZBtjI/GbCly7A99APAO19qOjEG1JiAoeuYLgC78QTean6KkvJMhICc3oYgjvkR0abGS+DnAZRZuUalhoJQPivYeFROlG3gfG0tu91mHvimyNMqGEOlGKTWRjc0kGN24iGZNKoIazSlMEXwS1Dsc08K8g/mYmY96EUNwsN/tRJ/awaNBQsxLl8nhYNLOnRdEte+SP2fX3hlCW5hlxd4YpgUg0/Dkeph+iQZFObIoinOakAlrFfOAnTlIFidoVRaBqgTGrd+VnZh9idQtkDhidZIlxnat4HldeOt+sf9URe2bmXpDi1uKD8ojvZD3xX6E+NctT61SYo7ms/Pp4yXxF4L9VeyTX7dQFxp+OqezoUtTXIlPyj9bGSJTlq1kPmo4gbBunBEMHN4Xsd555OCgQBlZeNEXR+PIPSt/eXM8MyaYxIrj/SNy+xRm+uCm+DkrgUYUsLFVPH7vnBL9SSVNfwuZgzEgJ18bu8Zc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(2906002)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(316002)(4326008)(8676002)(8936002)(5660300002)(38070700005)(41300700001)(36756003)(31696002)(86362001)(6512007)(26005)(186003)(122000001)(71200400001)(53546011)(38100700002)(478600001)(6486002)(966005)(83380400001)(31686004)(2616005)(6506007)(110136005)(54906003)(91956017)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFM5S0JncmRQcXNzMVRDOFJDcE9sU1BpamM5aWtJTDQxRDVsTmdkUEdGd3pG?=
 =?utf-8?B?UVVFa09uNy94MDVCM1UvQ1dtVVExRzBhZUY2SGpQbzl5b2x3bE5vZ2I5dU9k?=
 =?utf-8?B?V3NJd1pjbXFhc09IbklLN3FqRFJ4WFJkVklkd3gzK0Y2eFJXcmltcVEraWti?=
 =?utf-8?B?R2tSQnZ4Nml3Ym1UUVpxYkQrYzJ6NTBDRys4aC9sRlprRDVsQ2U1QksxS3d1?=
 =?utf-8?B?NFROSTR6SUI3RXVIQ0FSMEg2eHgzYUk3ZGphLzc1UnlWNHFRK3BzWThwWUdj?=
 =?utf-8?B?a1pjSGErZlpBTnMwL1h5REY2Qzg4VGg1RFdLQmt4RTJRUURTdmdJMGZKcmtR?=
 =?utf-8?B?VHZHcmNncExRa0xWeWtncUlxT2RmSm8rdnBtNmwyS3dwODJxSEpOZkRVWjdj?=
 =?utf-8?B?UmFRVnIzVjd1UUVBbURlcFJheE1SWHAvWGVlVkZTeExoRVI4N3hTc2R5MThJ?=
 =?utf-8?B?U1VNcWYveUdWQU5CZ1llcjBkZWxHc1A0MnV3MUNLOUlUTXMydTFrbUJDMXFH?=
 =?utf-8?B?SmpVS1UxMEtUUi8wUzl6Z0JQRHdqZEp2QkEwcVNINlFNRUlhN2J6UVFGcTVN?=
 =?utf-8?B?V0JYc2I1QWJnLzdFK3paQ0hDK1RzZ2tUeTI3Qk9BR2k4eE1TZXhBOFdqc1hn?=
 =?utf-8?B?V292MW5kMWNoTjI2d1hTdlBtNnFzSXZPMVBMZFQwaTBxellrRzh5a1FEUjlZ?=
 =?utf-8?B?NXFrWUt4YmF3SU9MajFxV0dMbS84UDJkVWF6cU9BS1IrazZkeVZSOXhpU0NC?=
 =?utf-8?B?Z21YNGgvMElxbHUrbFpqbVF0QWJUcGJlT0FncXZuenlWU2NBZ2tiQWhndmxE?=
 =?utf-8?B?WTlzb0Vub2dmZXhLNDFnKzBuaGNuSlErUDlFejhYUVFSTzJ2cGROMUd6SldP?=
 =?utf-8?B?ZW9GVDFnM011YjIrUFhObnk5YVptQ2Y3SzRFN3IxQ0dGb3hBTHAxd0pGN3ZS?=
 =?utf-8?B?bUdmWTdySUpESDZVNDZWc0htcjJSWk81YytLU1JrYlg0RzJZWlhnUXF0RXVP?=
 =?utf-8?B?RzJsWTRIaHhLcVo5TXgwcVRHZTdkUi9KeUFPY1ZtZzdkSzlUQUdaVGVoSklQ?=
 =?utf-8?B?NHM1VGJ1MExNY05CZkdRSmlNUTd1eUFUNkh4RTV2cnhLaTZRSGdHUkhnRVNh?=
 =?utf-8?B?eWFIMGNDS3k1SGxLSFRlcXh1MS9iMm9oN01OZzN5c2FscFZuZnd5Vjd0a3Ns?=
 =?utf-8?B?eGh5VHA3MzkwMStaQU9BV1lySU1DVHMzay9qcnNnbUpTaStUUFMvWUR0VUFF?=
 =?utf-8?B?NTNaUFI1K0VpNWZVQkJkbUk5aXVDSkJRTVNKR05rUERhR3ZqNC9WVWtESWJD?=
 =?utf-8?B?dm13SmNlQlNIdXhMdWVuczE1ZjcvTm4rOTM4SmRlSGdyZVYzOHovZHJUbCtQ?=
 =?utf-8?B?NnF5b3htK2Rjd3FhUWNCbE5VbnByN3FYZEFGcnFqajh1cFVNZmlNeVBTVmIr?=
 =?utf-8?B?Qm5Cc3NqL3ZxWXE4MHpzKzZPbEVod1Eyc01POEwxaTZHcUJFZlE1YjNSbUZj?=
 =?utf-8?B?MzMyN2ZNbTBhZmxSSTZaSnhheEhkWmh6ZFhEVkdTa3NqWmFYcmJlR1AyelB0?=
 =?utf-8?B?STg2UFRabVErbkhBbDBVanZwUHJvVWVpcTVsSkRNQkR5M1hzbDBqTHN0Z0Z0?=
 =?utf-8?B?Q0ZoZks4bUJQRFREcXdnSTRtS1VZS1N0M09RL1QwazlxNTZMMmFJVGlWRjBa?=
 =?utf-8?B?TGlYaTd5N1pwRXQ2dGN6eSsveG1DMzJJdithNFVpWUUvSExna0VYMVJWSFg5?=
 =?utf-8?B?cUg3N3hqZ040cEFBYUVHcVVEUVhUcXd4a3cvUlIyZ25rZzJlMUdVNU15bWhO?=
 =?utf-8?B?RmlxM2Q4a1RiekpuVGNkOWEzS1gzbDJ1ZnBPS1FiY0ZnUnJtSjA1U1dXa3Fx?=
 =?utf-8?B?b0FOaXhWQUtabldkUE5PbkY2ekl0QVZvU3RRWHl3T2IzT2NJc1crREl0cjNv?=
 =?utf-8?B?MnNkTnR5TzYrUnpsQjgwN1JHcCtIL21zRVp2eC8zS2FNa0VnVkFrRmlqYmFs?=
 =?utf-8?B?c0NSUlNVdk4zQzFEdm9KR2RtWWg1d1g3NS80T1dqUVB6OHBUaW1WcFhveUR5?=
 =?utf-8?B?VkRQYVlJT2FRWk03QjViUFdKNEZaN1RVcElqVDByOEFVQndaOXZtanlKNng3?=
 =?utf-8?Q?C1pL//vaDzn4vKXv6Nd1MIlwH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2884DB43261CD43B01FB5AB689AAF02@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b70123-1311-4e07-917c-08db44a17374
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 08:54:02.0176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AFlbSh5Xqk31Hk/NfAHxolBOZR+7vPcSzsYfe12f9Ac7zBBlxW9Mw+NT/qvbOCKKpD9EslYjc54Hu5jzdNFDrX26gkNxYt6b+6zxmZ4RhJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7852
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDguMDQuMjAyMyAwMDozMywgSW5nbyBSb2hsb2ZmIHdyb3RlOg0KPiBbWW91IGRvbid0IG9m
dGVuIGdldCBlbWFpbCBmcm9tIGluZ28ucm9obG9mZkBsYXV0ZXJiYWNoLmNvbS4gTGVhcm4gd2h5
IHRoaXMgaXMgaW1wb3J0YW50IGF0IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVu
dGlmaWNhdGlvbiBdDQo+IA0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4g
DQo+IEkgYW0gc29ycnk7IHRoaXMgaXMgYSBsb25nIEUtTWFpbC4NCj4gDQo+IEkgYW0gcmVmZXJy
aW5nIHRvIHRoaXMgcHJvYmxlbToNCj4gDQo+IFJvYmVydCBIYW5jb2NrIHdyb3RlOg0KPj4gT24g
V2VkLCAyMDIyLTAzLTIzIGF0IDA4OjQzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+
PiBPbiBXZWQsIDIzIE1hciAyMDIyIDEwOjA4OjIwICswMjAwIFRvbWFzIE1lbGluIHdyb3RlOg0K
Pj4+Pj4gRnJvbTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+
DQo+Pj4+Pg0KPj4+Pj4gT24gc29tZSBwbGF0Zm9ybXMgKGN1cnJlbnRseSBkZXRlY3RlZCBvbmx5
IG9uIFNBTUE1RDQpIFRYIG1pZ2h0IHN0dWNrDQo+Pj4+PiBldmVuIHRoZSBwYWNoZXRzIGFyZSBz
dGlsbCBwcmVzZW50IGluIERNQSBtZW1vcmllcyBhbmQgVFggc3RhcnQgd2FzDQo+Pj4+PiBpc3N1
ZWQgZm9yIHRoZW0uDQo+Pj4+PiAuLi4NCj4+Pj4gT24gWGlsaW54IFp5bnEgdGhlIGFib3ZlIGNo
YW5nZSBjYW4gY2F1c2UgaW5maW5pdGUgaW50ZXJydXB0IGxvb3ANCj4+Pj4gbGVhZGluZyB0byBD
UFUgc3RhbGwuICBTZWVtcyB0aW1pbmcvbG9hZCBuZWVkcyB0byBiZSBhcHByb3ByaWF0ZSBmb3IN
Cj4+Pj4gdGhpcyB0byBoYXBwZW4sIGFuZCBjdXJyZW50bHkgd2l0aCAxRyBldGhlcm5ldCB0aGlz
IGNhbiBiZSB0cmlnZ2VyZWQNCj4+Pj4gbm9ybWFsbHkgd2l0aGluIG1pbnV0ZXMgd2hlbiBydW5u
aW5nIHN0cmVzcyB0ZXN0cyBvbiB0aGUgbmV0d29yaw0KPj4+PiBpbnRlcmZhY2UuDQo+Pj4+IC4u
Lg0KPj4+IFdoaWNoIGtlcm5lbCB2ZXJzaW9uIGFyZSB5b3UgdXNpbmc/ICBSb2JlcnQgaGFzIGJl
ZW4gd29ya2luZyBvbiBtYWNiICsNCj4+PiBaeW5xIHJlY2VudGx5LCBhZGRpbmcgaGltIHRvIEND
Lg0KPj4gLi4uDQo+PiBJIGhhdmVuJ3QgbG9va2VkIGF0IHRoZSBUWCByaW5nIGRlc2NyaXB0b3Ig
YW5kIHJlZ2lzdGVyIHNldHVwIG9uIHRoaXMgY29yZQ0KPj4gaW4gdGhhdCBtdWNoIGRldGFpbCwg
YnV0IHRoZSBmYWN0IHRoZSBjb250cm9sbGVyIGdldHMgaW50byB0aGlzICJUWCB1c2VkDQo+PiBi
aXQgcmVhZCIgc3RhdGUgaW4gdGhlIGZpcnN0IHBsYWNlIHNlZW1zIHVudXN1YWwuICBJJ20gd29u
ZGVyaW5nIGlmDQo+PiBzb21ldGhpbmcgaXMgYmVpbmcgZG9uZSBpbiB0aGUgd3Jvbmcgb3JkZXIg
b3IgaWYgd2UgYXJlIG1pc3NpbmcgYSBtZW1vcnkNCj4+IGJhcnJpZXIgZXRjPw0KPiANCj4gSSBh
bSBkZXZlbG9waW5nIG9uIGEgWnlucU1QIChVbHRyYXNjYWxlKykgU29DIGZyb20gQU1EL1hpbGlu
eC4NCj4gSSBoYXZlIHNlZW4gdGhlIHNhbWUgaXNzdWUgYmVmb3JlIGNvbW1pdCA0Mjk4Mzg4NTc0
ZGFlNjE2OCAoIm5ldDogbWFjYjoNCj4gcmVzdGFydCB0eCBhZnRlciB0eCB1c2VkIGJpdCByZWFk
IikNCj4gDQo+IFRoZSBzY2VuYXJpbyB3aGljaCBzb21ldGltZXMgdHJpZ2dlcnMgaXQgZm9yIG1l
Og0KPiANCj4gSSBoYXZlIGFuIGFwcGxpY2F0aW9uIHJ1bm5pbmcgb24gdGhlIFBDLg0KPiBUaGUg
YXBwbGljYXRpb24gc2VuZHMgYSBzaG9ydCBjb21tYW5kICh2aWEgVENQKSB0byB0aGUgWnlucU1Q
Lg0KPiBUaGUgWnlucU1QIGFuc3dlcnMgd2l0aCBhIGxvbmcgc3RyZWFtIG9mIGJ5dGVzIHZpYSBU
Q1ANCj4gKGFyb3VuZCAyMzBLaUIpLg0KPiBUaGUgUEMga25vd3MgdGhlIGFtb3VudCBvZiBkYXRh
IGFuZCB3YWl0cyB0byByZWNlaXZlIHRoZSBkYXRhIGNvbXBsZXRlbHkuDQo+IFRoZSBQQyBnZXRz
IHN0dWNrLCBiZWNhdXNlIHRoZSBsYXN0IFRDUCBzZWdtZW50IG9mIHRoZSB0cmFuc2ZlciBnZXRz
DQo+IHN0dWNrIGluIHRoZSBaeW5xTVAgYW5kIGlzIG5vdCB0cmFuc21pdHRlZC4NCj4gWW91IGNh
biByZS10cmlnZ2VyIHRoZSBUWCBSaW5nIGJ5IHBpbmdpbmcgdGhlIFp5bnFNUDoNCj4gVGhlIFBp
bmcgYW5zd2VyIHdpbGwgcmUtdHJpZ2dlciB0aGUgVFggcmluZywgd2hpY2ggaW4gdHVybiB3aWxs
IGFsc28NCj4gdGhlbiBzZW5kIHRoZSBzdHVjayBJUC9UQ1AgcGFja2V0Lg0KDQpGcm9tIHRoZSBt
b21lbnQgSSd2ZSBiZWVuIHdvcmtpbmcgb24gdGhpcyBJIHJlbWVtYmVyIHBpbmcgd2FzIGFsc28N
CnJlc3RhcnRpbmcgdGhlIFRYIGZvciBtZSAod2hpY2ggaXMgZXhwZWN0ZWQgYXMgaXQgZW5xdWV1
ZXMgbW9yZSBkZXNjcmlwdG9ycw0KYW5kIGlzc3VlIFRTVEFSVCkuIEF0IHRoZSB0aW1lIEkgd29y
a2VkIG9uIHRoaXMgdGhlIGhhcmR3YXJlIHByZWZldGNoIHdhcw0Kbm90IGltcGxlbWVudGVkIGlu
IHNvZnR3YXJlIChhbmQgSSB0aGluayB0aGUgaGFyZHdhcmUgSSBoYWQgdGhlIGlzc3VlIHdpdGgN
CmRpZG4ndCBzdXBwb3J0IGl0KS4NCg0KPiANCj4gVW5mb3J0dW5hdGVseSB0cmlnZ2VyaW5nIHRo
aXMgcHJvYmxlbSBzZWVtcyB0byBiZSBoYXJkOyBhdCBsZWFzdCBJIGFtDQo+IG5vdCBhYmxlIHRv
IHJlcHJvZHVjZSBpdCBlYXNpbHkuDQoNCkl0IHdhcyB0aGUgc2FtZSBvbiBteSBzaWRlLg0KDQo+
IA0KPiBTbzogSWYgYW55b25lIGhhcyBhIG1vcmUgcmVsaWFibGUgd2F5IHRvIHRyaWdnZXIgdGhl
IHByb2JsZW0sDQo+IHBsZWFzZSB0ZWxsIG1lLg0KPiBUaGlzIGlzIHRvIGNoZWNrIGlmIG15IHBy
b3Bvc2VkIGFsdGVybmF0aXZlIHdvcmtzIHVuZGVyIGFsbCBjaXJjdW1zdGFuY2VzLg0KPiANCj4g
SSBoYXZlIGFuIGFsdGVybmF0ZSBpbXBsZW1lbnRhdGlvbiwgd2hpY2ggZG9lcyBub3QgcmVxdWly
ZSB0byB0dXJuIG9uDQo+IHRoZSAiVFggVVNFRCBCSVQgUkVBRCIgKFRVQlIpIGludGVycnVwdC4N
Cj4gVGhlIHJlYXNvbiB3aHkgSSB0aGluayB0aGlzIGFsdGVybmF0aXZlIG1pZ2h0IGJlIGJldHRl
ciBpcywgYmVjYXVzZSBJDQo+IGJlbGlldmUgdGhlIFRVQlIgaW50ZXJydXB0IGhhcHBlbnMgYXQg
dGhlIHdyb25nIHRpbWU7IHNvIEkgYW0gbm90IHN1cmUNCj4gdGhhdCB0aGUgY3VycmVudCBpbXBs
ZW1lbnRhdGlvbiB3b3JrcyByZWxpYWJseS4NCj4gDQo+IEFuYWx5c2lzOg0KPiBDb21taXQgNDA0
Y2QwODZmMjllODY3ZiAoIm5ldDogbWFjYjogQWxsb2NhdGUgdmFsaWQgbWVtb3J5IGZvciBUWCBh
bmQgUlggQkQNCj4gcHJlZmV0Y2giKSBtZW50aW9uczoNCj4gDQo+ICAgICBHRU0gdmVyc2lvbiBp
biBaeW5xTVAgYW5kIG1vc3QgdmVyc2lvbnMgZ3JlYXRlciB0aGFuIHIxcDA3IHN1cHBvcnRzDQo+
ICAgICBUWCBhbmQgUlggQkQgcHJlZmV0Y2guIFRoZSBudW1iZXIgb2YgQkRzIHRoYXQgY2FuIGJl
IHByZWZldGNoZWQgaXMgYQ0KPiAgICAgSFcgY29uZmlndXJhYmxlIHBhcmFtZXRlci4gRm9yIFp5
bnFNUCwgdGhpcyBwYXJhbWV0ZXIgaXMgNC4NCj4gDQo+IEkgdGhpbmsgd2hhdCBoYXBwZW5zIGlz
IHRoaXM6DQo+IEV4YW1wbGUgU2NlbmFyaW8gKFNXID09IGxpbnV4IGtlcm5lbCwgSFcgPT0gY2Fk
ZW5jZSBldGhlcm5ldCBJUCkuDQo+IDEpIFNXIGhhcyB3cml0dGVuIFRYIGRlc2NyaXB0b3JzIDAu
LjcNCj4gMikgSFcgaXMgY3VycmVudGx5IHRyYW5zbWl0dGluZyBUWCBkZXNjcmlwdG9yIDYuDQo+
ICAgIEhXIGhhcyBhbHJlYWR5IHByZWZldGNoZWQgVFggZGVzY3JpcHRvcnMgNiw3LDgsOS4NCj4g
MykgU1cgd3JpdGVzIFRYIGRlc2NyaXB0b3IgOCAoY2xlYXJpbmcgVFhfVVNFRCkNCj4gNCkgU1cg
d3JpdGVzIHRoZSBUU1RBUlQgYml0Lg0KPiAgICBIVyBpZ25vcmVzIHRoaXMsIGJlY2F1c2UgaXQg
aXMgc3RpbGwgdHJhbnNtaXR0aW5nLg0KPiA1KSBIVyB0cmFuc21pdHMgVFggZGVzY3JpcHRvciA3
Lg0KPiA2KSBIVyByZWFjaGVzIGRlc2NyaXB0b3IgODsgYmVjYXVzZSB0aGlzIGRlc2NyaXB0b3IN
Cj4gICAgaGFzIGFscmVhZHkgYmVlbiBwcmVmZXRjaGVkLCBIVyBzZWVzIGEgbm9uLWFjdGl2ZQ0K
PiAgICBkZXNjcmlwdG9yIChUWF9VU0VEIHNldCkgYW5kIHN0b3BzIHRyYW5zbWl0dGluZy4NCg0K
SSB0aGluayB5b3UgY2FuIGNoZWNrIFRCUVAgcmVnaXN0ZXIgdG8gc2VlIGlmIGhhcmR3YXJlIHBv
c2l0aW9uIGluIFRYIHF1ZXVlDQppcyBhaGVhZCBvZiBzb2Z0d2FyZSB0byB2YWxpZGF0ZSBhZ2Fp
bnN0IGhhcmR3YXJlIHRoaXMgcHJlZmV0Y2ggc2NlbmFyaW8uDQoNCj4gDQo+PkZyb20gZGVidWdn
aW5nIHRoZSBjb2RlIGl0IHNlZW1zIHRoYXQgdGhlIFRVQlIgaW50ZXJydXB0IGhhcHBlbnMsIHdo
ZW4NCj4gYSBkZXNjcmlwdG9yIGlzIHByZWZldGNoZWQsIHdoaWNoIGhhcyBhIFRYX1VTRUQgYml0
IHNldCwgd2hpY2ggaXMgYmVmb3JlDQoNCkZyb20gd2hhdCBJIGtub3csIHllcywgVFVCUiBpcyBy
YWlzZWQgd2hlbiBIVyBUWCBsb2dpYyByZWFjaGVzIGEgZGVzY3JpcHRvcg0Kd2l0aCBUWF9VU0VE
IHNldC4NCg0KPiBpdCBpcyBwcm9jZXNzZWQgYnkgdGhlIHJlc3Qgb2YgdGhlIGhhcmR3YXJlOg0K
PiBXaGVuIGxvb2tpbmcgYXQgdGhlIGVuZCBvZiBhIHRyYW5zZmVyIGl0IHNlZW1zIEkgZ2V0IGEg
VFVCUiBpbnRlcnJ1cHQsDQo+IGZvbGxvd2VkIGJ5IHNvbWUgbW9yZSBUWCBDT01QTEVURSBpbnRl
cnJ1cHRzLg0KPiANCj4gQWRkaXRpb25hbGx5IHRoYXQgbWVhbnMgYXQgdGhlIHRpbWUgdGhlIFRV
QlIgaW50ZXJydXB0IGhhcHBlbnMsIGl0DQo+IGlzIHRvbyBlYXJseSB0byB3cml0ZSB0aGUgVFNU
QVJUIGJpdCBhZ2FpbiwgYmVjYXVzZSB0aGUgaGFyZHdhcmUgaXMNCj4gc3RpbGwgYWN0aXZlbHkg
dHJhbnNtaXR0aW5nLg0KPiANCj4gVGhlIGFsdGVybmF0aXZlIEkgaW1wbGVtZW50ZWQgaXMgdG8g
Y2hlY2sgaW4gbWFjYl90eF9jb21wbGV0ZSgpIGlmDQo+IA0KPiAxKSBUaGUgVFggUXVldWUgaXMg
bm9uLWVtcHR5ICh0aGVyZSBhcmUgcGVuZGluZyBUWCBkZXNjcmlwdG9ycykNCj4gMikgVGhlIGhh
cmR3YXJlIGluZGljYXRlcyB0aGF0IGl0IGlzIG5vdCB0cmFuc21pdHRpbmcgYW55IG1vcmUNCj4g
DQo+IElmIHRoaXMgc2l0dWF0aW9uIGlzIGRldGVjdGVkLCB0aGUgVFNUQVJUIGJpdCB3aWxsIGJl
IHdyaXR0ZW4gdG8NCj4gcmVzdGFydCB0aGUgVFggcmluZy4NCj4gDQo+IEkga25vdyBmb3Igc3Vy
ZSwgdGhhdCBJIGhpdCB0aGUgY29kZSBwYXRoLCB3aGljaCByZXN0YXJ0cyB0aGUNCj4gdHJhbnNt
aXNzaW9uIGluIG1hY2JfdHhfY29tcGxldGUoKTsgdGhhdCdzIHdoeSBJIGJlbGlldmUgdGhlDQo+
ICJFeGFtcGxlIFNjZW5hcmlvIiBJIGRlc2NyaWJlZCBhYm92ZSBpcyBjb3JyZWN0Lg0KPiANCj4g
SSBhbSBzdGlsbCBub3Qgc3VyZSBpZiB3aGF0IEkgaW1wbGVtZW50ZWQgaXMgZW5vdWdoOg0KPiBt
YWNiX3R4X2NvbXBsZXRlKCkgc2hvdWxkIGF0IGxlYXN0IHNlZSBhbGwgY29tcGxldGVkIFRYIGRl
c2NyaXB0b3JzLg0KPiBJIHN0aWxsIGJlbGlldmUgdGhlcmUgaXMgYSAodmVyeSBzaG9ydCkgdGlt
ZSB3aW5kb3cgaW4gd2hpY2ggdGhlcmUNCj4gbWlnaHQgYmUgYSByYWNlOg0KPiAxKSBIVyBjb21w
bGV0ZXMgVFggZGVzY3JpcHRvciA3IGFuZCBzZXRzIHRoZSBUWF9VU0VEIGJpdA0KPiAgICBpbiBU
WCBkZXNjcmlwdG9yIDcuDQo+ICAgIFRYIGRlc2NyaXB0b3IgOCB3YXMgcHJlZmV0Y2hlZCB3aXRo
IGEgc2V0IFRYX1VTRUQgYml0Lg0KPiAyKSBTVyBzZWVzIHRoYXQgVFggZGVzY3JpcHRvciA3IGlz
IGNvbXBsZXRlZA0KPiAgICAoVFhfVVNFRCBiaXQgbm93IGlzIHNldCkuDQo+IDMpIFNXIHNlZXMg
dGhhdCB0aGVyZSBzdGlsbCBpcyBhIHBlbmRpbmcgVFggZGVzY3JpcHRvciA4Lg0KPiA0KSBTVyBj
aGVja3MgaWYgdGhlIFRHTyBiaXQgaXMgc3RpbGwgc2V0LCB3aGljaCBpdCBpcy4NCj4gICAgU28g
dGhlIFNXIGRvZXMgbm90aGluZyBhdCB0aGlzIHBvaW50Lg0KPiA1KSBIVyBwcm9jZXNzZXMgdGhl
IHByZWZldGNoZWQsc2V0IFRYX1VTRUQgYml0IGluDQo+ICAgIFRYIGRlc2NyaXB0b3IgOCBhbmQg
c3RvcHMgdHJhbnNtaXNzaW9uIChjbGVhcmluZyB0aGUgVEdPIGJpdCkuDQo+IA0KPiBJIGFtIG5v
dCBzdXJlIGlmIGl0IGlzIGd1YXJhbnRlZWQgdGhhdCA1KSBjYW5ub3QgaGFwcGVuIGFmdGVyIDQp
LiAgSWYgNSkNCj4gaGFwcGVucyBhZnRlciA0KSBhcyBkZXNjcmliZWQgYWJvdmUsIHRoZW4gdGhl
IGNvbnRyb2xsZXIgc3RpbGwgZ2V0cyBzdHVjay4NCj4gVGhlIG9ubHkgaWRlYSBJIGNhbiBjb21l
IHVwIHdpdGgsIGlzIHRvIHJlLWNoZWNrIHRoZSBUR08gYml0DQo+IGEgc2Vjb25kIHRpbWUgYSBs
aXR0bGUgYml0IGxhdGVyLCBidXQgSSBhbSBub3Qgc3VyZSBob3cgdG8NCj4gaW1wbGVtZW50IHRo
aXMuDQo+IA0KPiBJcyB0aGVyZSBhbnlvbmUgd2hvIGhhcyBhY2Nlc3MgdG8gaGFyZHdhcmUgZG9j
dW1lbnRhdGlvbiwgd2hpY2gNCj4gc2hlZHMgc29tZSBsaWdodCBvbnRvIHRoZSB3YXkgdGhlIGRl
c2NyaXB0b3IgcHJlZmV0Y2hpbmcgd29ya3M/DQoNClNvbWUgcGFydCBvZiBpdCBjb3VsZCBiZSBm
b3VuZCBoZXJlOg0KaHR0cHM6Ly93dzEubWljcm9jaGlwLmNvbS9kb3dubG9hZHMvYWVtRG9jdW1l
bnRzL2RvY3VtZW50cy9NUFUzMi9Qcm9kdWN0RG9jdW1lbnRzL0RhdGFTaGVldHMvU0FNQTdHNS1T
ZXJpZXMtRGF0YS1TaGVldC1EUzYwMDAxNzY1QS5wZGYjX09QRU5UT1BJQ19UT0NfUFJPQ0VTU0lO
R19kMTcwMjNlNzc4NTgyDQoNClRoYW5rIHlvdSwNCkNsYXVkaXUNCg0KPiANCj4gc28gbG9uZw0K
PiAgIEluZ28NCj4gDQo+IA0KPiBJbmdvIFJvaGxvZmYgKDEpOg0KPiAgIG5ldDogbWFjYjogQSBk
aWZmZXJlbnQgd2F5IHRvIHJlc3RhcnQgYSBzdHVjayBUWCBkZXNjcmlwdG9yIHJpbmcuDQo+IA0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmggICAgICB8ICAxIC0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCA2NyArKysrKysrKystLS0t
LS0tLS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwgNDQgZGVs
ZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjE3LjENCj4gDQoNCg==
