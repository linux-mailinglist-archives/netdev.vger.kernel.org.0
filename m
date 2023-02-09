Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E526F691103
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 20:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBITJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 14:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBITJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 14:09:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840206953A;
        Thu,  9 Feb 2023 11:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675969785; x=1707505785;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m1j5zsNUICXWo52wlMGR2TFpL9esa8heC1JKG50N+Ac=;
  b=gt8V0UNZ84fBbqDtuPpvBotY8ubq5MZS7/K2jKgZiBaA1tce01laYaBv
   /4LXX+jETZcBU+PNPJr6JVmjds09dzI1OdU0JbxZowLlWDZKZiBAz7LmL
   8itNgzsKK/MmDsasP9RSLn8koHTrRL8qJ2E2euSAOsCIzY9I49zMHLESK
   uPA8FhPIg8kT4CfT0CBHsvjfPVAVKtKplJxQe4/xakKPh6eJiSLKOFxV0
   k47ceMeI2/duN+ZMHfq4CzqVntBgbk59tm7qd0NeWxQvfTRPyfnQflVJA
   f6TJosiuAo1iiFWkRxVir1sra3hskbeljbyhgTT1tqQOnVmNLxiYH82i6
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,284,1669100400"; 
   d="scan'208";a="211318631"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2023 12:09:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 12:09:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 12:09:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl/opcPrQXMfTAZBlRPnAO9vHOUQNGCrENV7zCgOM9fnpcBfG5IGZidnFj/cxIy28tUFvHCZajrwt+q57DsiYBuZSYzCAd/KwaVurQqk7uv7qRyDDMy4mssKMjyc1a9ZMMuDG/r+Vv6lPiRm8LQmOfh/E7r+lwqGZhg4xOO5IlIBOJByqzgVHHEMoI11QNgtI+J5Q9kecDlGqmcV14HHviPGgVcjnZ524psNpHp2OkrtQxMZ1VAkt4TaWIYl77aaD/IEvHKoEX7cAk9LZx4oWUCqd/1LWyltSQ44HwOcqg1ttCqiVcFFzSwFRM67XA/EFT6O9S/wabh2fZ6TkwTl3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1j5zsNUICXWo52wlMGR2TFpL9esa8heC1JKG50N+Ac=;
 b=gRLwinQZWM7UBA8eApQE5Qv7qC9N3iZRJU/QIHZJex3C5+kNz8i9Y0zz3HI9zwBhnnWo+pr6NKchpWF4lityP4i/lw89yLWwqjRqW9M7Y5Va4hN32xn4JCi4NrJkFfi4FiSfgQ/AF8uu8YJiote/E9aols/577y9bJXjo3OdjkDI53s/Lpgf1NnDtb1GDsxWakqgZI7t28o/b1FKU3K8ihYsXtC6Ta/dXrAexCoeBfUljSpERqZmfgXhQTjaqW0IGGQz1MJrfEYZcD7EHMn1EsTIkyEKdcfbTODnZZ/Fo2HVE1b6auv5u8Y+lgPXZhk98lMC1iYTQLXQXyvYC6do4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1j5zsNUICXWo52wlMGR2TFpL9esa8heC1JKG50N+Ac=;
 b=JRdxDB09zouTURoZTWfLHsXO01IEiP/nPbUU4Noe0sIYgSeIIHRU2u/z1T3vJSusxUDwtRRbs4ZZPzN4p55Sr0h6HoE+OxPLycqC+V1bfCtse2jMdrUTrd8lFoF02waQL2yhbrVYlp3S+XkxgO1FkgBho9nARdJcN9AQTDWbkz8=
Received: from PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5)
 by DM6PR11MB4658.namprd11.prod.outlook.com (2603:10b6:5:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 19:09:40 +0000
Received: from PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0]) by PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0%5]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 19:09:40 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <heiko.thiery@gmail.com>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@kernel.org>,
        <linux-wireless@vger.kernel.org>, <michael@walle.cc>,
        <netdev@vger.kernel.org>, <Amisha.Patel@microchip.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Topic: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Index: AQHZO8ksXzruIoRs50KxNC39W3lrs67G3K6AgAAXpACAAAg4gA==
Date:   Thu, 9 Feb 2023 19:09:39 +0000
Message-ID: <d6d0da01-9314-2e00-e82b-d2d42276bbf4@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
 <CAEyMn7YnqhbmOnKQkks5OkGwuKoBPkQkfuWWJ2s_GAEY9WP4Wg@mail.gmail.com>
In-Reply-To: <CAEyMn7YnqhbmOnKQkks5OkGwuKoBPkQkfuWWJ2s_GAEY9WP4Wg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5176:EE_|DM6PR11MB4658:EE_
x-ms-office365-filtering-correlation-id: c18868e7-6a35-4323-724c-08db0ad1314e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BmSu1tB/OmPz2yUWtx1i9+9LvwmgFEQv2Pfxl0Wbc4jj5bns/bI2pJ6QnpYG7UugGyOfkPywBbKxs+T1q6mHYR8V7N/qE+OfqMrPThcSMBqGTjsUmfowOah8VFr6a1CNJk4Smod6ocvaM5zHiQ7cX6ePGmNShvOJsAtnQSRvg8oLq8djRcdIG7j9hgl8T0BeLcb7LmuiBtGgxOrdKERKpOo5P0vVUpH+b9SdeW7lBlZ+R7MSYDjvQ1wXgNyopbq9Zlu9+lkjweRS0Q6algxqOC9sNZ6FOT3Li8cIFNLHrcF/c4fY7qb3O2uOeSgyLzdsjXQwJU0sYm067ggz8S2Qbk9GjAP/9R81JCMVRaw97jcgY7VyEEeJmmLFO9xcmVtmSArFzBgzjASi9gXk2RAq+gPwVjdGLHm/kVcJ0+KKLew/4jR1VqM5NONUmKgqnh6/FVNseyTJ1QYj7vHmW+Y4pxfj3mCLQr733AUM3O+fbQHhEcKga2U9GXd8S5vk81ccXssWrGkWGz/5Cdu7Oe8dyCYkSCQrFKiYImjuxMWZsXRLHpUhWYqqh0m47adKGGcFq1yl/CjjfgjtCuIrYeYRRrvsSUO60qXl/T79MQqdhDwzCabg32xSqXtJ8kdBjtM6fgvln2EZnbHqjVvEMT/YbV6TR1+GhPajxi58FfYocHkDLG9g5CfbJtW+Ixka88MznGIgZMIVOdRCrudBD9E3SuxCvSe2o1+v+4lb6RoasebKD/NbgQFBomg2hC3e8abfBNtQ/ceaPi2PUORkLdXucA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5176.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199018)(31686004)(31696002)(107886003)(186003)(6506007)(26005)(6512007)(53546011)(86362001)(66476007)(38070700005)(36756003)(66446008)(66556008)(64756008)(38100700002)(316002)(76116006)(66946007)(8676002)(71200400001)(54906003)(478600001)(6486002)(6916009)(217773002)(4326008)(41300700001)(2906002)(122000001)(2616005)(5660300002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUxXclUwTEtRZVVrZUNwYnZJWGx1S2lsWUpiejBmVUZUZ2NqM1RSMkh3OFZx?=
 =?utf-8?B?YmxqNmY4MDZyQjFyS2FLTit3OEN5RjljTVhrbTJaSDVlTjRCalBWdWYzMVZ2?=
 =?utf-8?B?VHFRVHpvWm81Yi8yN1ZYbEhQbDhaWjd2TTdBd1JndFB4dHJtdkZGUkF5UXVx?=
 =?utf-8?B?YUtEMXdiaFlxUnhQcEZlWjAwTk90YndXT2YxTmZNYzhxVVhRMndRdnpjaFYx?=
 =?utf-8?B?NVFqMXNFK3JLekdtdy9pVjBHZnRrTnZrbUlWQnlSb2NMcjZMMXJQUjJsVlA2?=
 =?utf-8?B?NHRZOUxqbVlHTFZiZ0d0Nzl0VHlzLytSRWlrVGpGWldOK0FSTmtwbzc0d1FO?=
 =?utf-8?B?dW9nVUxwUVN4TVA3QkhoajlweTN5TWpRMmJkQUJncFd0MDNIaVBkRDFLc2ZM?=
 =?utf-8?B?OFlXaE9rd1VzNWo4aE9mUFJXRTFBTk5kVnRkSGhYVEZ3b2VsNmpxOEk2STFC?=
 =?utf-8?B?Y1dNWHJZS0hDRVhrdFJOQ1crUEVsampUZnJ4RERtSURZYWpSWjEyWGk1ZU1Y?=
 =?utf-8?B?K3docmhiTDVyZUVZTXIvVGRMU1JQTUVqYWRnN3NJd3ovQ003cmJRN0lNQTRK?=
 =?utf-8?B?Q0E3V3orcFcyVG9JLy85NUJWM21XNHhCQjNtbmkxUEtrbjBkSUtTL09UMDh0?=
 =?utf-8?B?Z3dFdmR5T2hXQ1E2MUI3NjBoMkhxSjZYMlRDUDhONWZaTEhZM3IxQzhHSkFa?=
 =?utf-8?B?dzY0QVVuSTZkUGpyTFltZEM0MDJuc3ZwWWcwcUYvbXRGL2lZZUxxY2ErL3JR?=
 =?utf-8?B?TlJZaVpNVkw5cU04a2JabDlCYnBsdldITkhTdU5UektLam9JcEcyY2F0R3o2?=
 =?utf-8?B?TEdpUlcrVHZTcFp4MzRhTWg4K2pTbzRJYUc5VVZHdUQxeC8zRENlYm8zdllG?=
 =?utf-8?B?STVKaXVqaDNlWCt3bG90WGRHVUdoSUxRNHV6Yzg2d09uWDJ0NnkvQ2dzVmNB?=
 =?utf-8?B?V3FrTUVuc2Z2c3JvUmxnVGxFSzY2djRzSVRPcGFxWExzNWJuMVpoZi9OdGZo?=
 =?utf-8?B?d2RybGxxTUxIYjYyVE5oeldGd2tJWVdRY0hpNy9yVEg0VUFMYnJTNW1UV1Zi?=
 =?utf-8?B?MC9yT0FmRHFCQW5UT0IwSDA1TmtpdnFYSm80U1ZFemhJQS90SHMrajEyS2lC?=
 =?utf-8?B?a2ZDYTg5SlNYQzNhUEFsMDNGR3JjQmVhSStBNVhYWEdRU3VZcDNpemRwcUlw?=
 =?utf-8?B?TXh1L2lIRnZSVFVzWmVOd2pkdndzRnRhcmxSdGhxMmJpTjI2eXRJaXJQTita?=
 =?utf-8?B?eGI0YnA1RjdtWVk0YWhaendldWNQQksvY3grZmh4enkrMzg4MVRSclJBaWRz?=
 =?utf-8?B?ZG5RQkVCSDBtSEp2UGFFaXo5Smxka3dJWGxOYmU1UEFoN2p1U3V4N3JTNjJD?=
 =?utf-8?B?TElQakhHVUhHb2NsMVc3S2N2bFpBV1N1WXhNMzVJRG1IcjMzUVpqMnNyWUJB?=
 =?utf-8?B?T3hrYTJvM0UzTXJXclExQnQ2N3VhcGRmQisyUkVYZktsRWE0RlUrN0xsMHVX?=
 =?utf-8?B?S0JJL2h4a29TazhQdngvTnpWOGo2d1R6a216d2lXZ0dhZE80RU42aU1TbzR6?=
 =?utf-8?B?eWlDc0JlVW5memJEYmZsVzJobnJrVnBOZkNiejB0LzllbzNXVXRnQ2ZjaTU1?=
 =?utf-8?B?RmNHZExMZ0FheGlaNDlGeTl6eE43WjZrWm02ZFNLdjh2RkpWSnI0QzJRaFNQ?=
 =?utf-8?B?MVBLVU1DVGh4dDgrd3N3VE9VMUVNNCtwRDZ0NTZnbGM0RkFOeFRvVVgzMStw?=
 =?utf-8?B?Ykp0S1pkT2IvcktvdVdtL29pTHYyMWlmWkxKQTlacmtjNHZFRzU3M1VsTDd0?=
 =?utf-8?B?N3ZIays4b0lybDczcXI3YjhWdlpSbm40aGpSeEVqRUwxYmdFNW1KSy9xNGwv?=
 =?utf-8?B?ZHZ0ZHdadnh3bGRyUlU3SHpQVEJGeEVhUTNtOFY4bktRK1BmclpTTlZSOWJY?=
 =?utf-8?B?M0xHeGI4eDU2bWQrS1NaUXNuM2VXc3BSd3d5N1pYQWNWSmk5Q2NzMS9DVlVk?=
 =?utf-8?B?NGthVWI5d0wrRXdQdTJuSnRTeFNZTHJUcWVuMVBNR1Fld20vbzhRZFVvb05J?=
 =?utf-8?B?bGxmQ09DVWNZQ2RnVThFMkVTdXZWb2dxWkQ1TEgxdWlMV01aSFFnaVJCdnZN?=
 =?utf-8?Q?p6AOyjHRTunNntHuw1YrEzeaZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3691DDA1F073846A10059B6E8CF7F9D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5176.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18868e7-6a35-4323-724c-08db0ad1314e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 19:09:39.4568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SPOlntHRsEWDu53QuNBdS1kZlnaCPv4FBfh2Y/66thPkv9f8lNErSYaNKWXoYmSDtC2YCq5lmLy9vc2eu2DFHaI3JhissfA5ta897J4fnf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4658
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMi85LzIzIDExOjQwLCBIZWlrbyBUaGllcnkgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhl
IGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGksDQo+IA0KPiBBbSBEby4sIDkuIEZlYi4gMjAyMyB1
bSAxODoxNSBVaHIgc2NocmllYiA8QWpheS5LYXRoYXRAbWljcm9jaGlwLmNvbT46DQo+Pg0KPj4g
SGkgSGVpa28sDQo+Pg0KPj4gT24gMi84LzIzIDA3OjI0LCBIZWlrbyBUaGllcnkgd3JvdGU6DQo+
Pj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+Pj4NCj4+PiBIaSwNCj4+Pg0K
Pj4+IEknbSB1c2luZyB0aGUgV0lMQzEwMDAgd2lmaSBhbmQgd2l0aCBOZXR3b3JrTWFuYWdlciBb
MV0gSSBzZWUgaXNzdWVzDQo+Pj4gaW4gY2VydGFpbiBzaXR1YXRpb25zIEkgc2VlIHByb2JsZW1z
Lg0KPj4+DQo+Pj4gSSB3YXMgYWJsZSB0byByZWR1Y2UgdGhlIHByb2JsZW0gYW5kIGhhdmUgbm93
IGZvdW5kIG91dCB0aGF0IHRoZSBjYXVzZQ0KPj4+IGlzIHRoYXQgdGhlIGludGVyZmFjZSBoYXMg
dGhlIEhXIE1BQyBhZGRyZXNzIGlzIDAwOjAwOjAwOjAwOjAwIGFmdGVyDQo+Pj4gc3RhcnR1cC4g
T25seSB3aGVuIHRoZSBpbnRlcmZhY2UgaXMgc3RhcnR1cCAoaXAgbGluayBzZXQgZGV2IHdsYW4w
DQo+Pj4gdXApLCB0aGUgZHJpdmVyIHNldHMgYSAidmFsaWQiIGFkZHJlc3MuDQo+Pj4NCj4+DQo+
PiBJSVVDIG5ldHdvcmsgbWFuYWdlcihOTSkgaXMgdHJ5aW5nIHRvIHJlYWQgdGhlIE1BQyBhZGRy
ZXNzIGFuZCB3cml0ZSB0aGUNCj4+IHNhbWUgYmFjayB0byB3aWxjMTAwMCBtb2R1bGUgd2l0aG91
dCBtYWtpbmcgdGhlIHdsYW4wIGludGVyZmFjZSB1cC4gcmlnaHQ/DQo+IA0KPiBBcyBmYXIgYXMg
SSB1bmRlcnN0YW5kLCBuZXR3b3JrLW1hbmFnZXIgd2lsbCByZWFkIHRoZSAicmVhbCIgSFcNCj4g
YWRkcmVzcy4gVGhlbiBpdCBzZXRzIGEgcmFuZG9tDQo+IGdlbmVyYXRlZCBIVyBmb3Igc2Nhbm5p
bmcgYW5kIGFmdGVyIHRoYXQgc3dpdGNoZXMgYmFjayB0byB0aGUgInJlYWwiIEhXIGFkZHJlc3Mu
DQo+IA0KPiBUaGVyZSBzZWVtcyB0byBiZSBjaXJjdW1zdGFuY2VzIHdoZXJlIHRoZSB3cm9uZyBI
VyBhZGRyZXNzDQo+ICgwMDowMDowMDowMDowMDowMCkgaXMgcmVhZCBhbmQgc3RvcmVkIGZvcg0K
PiBsYXRlciByZXNldCBhZnRlciB0aGUgc2Nhbm5pbmcuDQo+IA0KDQpBY3R1YWxseSwgdGhlIHNj
YW4gb3BlcmF0aW9uIGlzIGFsbG93ZWQgb25seSBhZnRlciB0aGUgaW50ZXJmYWNlIGlzIHVwLg0K
UHJvYmFibHkgdGhlIGFkZHJlc3Mgd2FzIHN0b3JlZCBiZWZvcmUgYW55IHdsYW4gb3BlcmF0aW9u
Lg0KDQoNCj4+IE5vdCBzdXJlIGFib3V0IHRoZSByZXF1aXJlbWVudCBidXQgaWYgTk0gaGFzIGEg
dmFsaWQgTUFDIGFkZHJlc3MgdG8NCj4+IGFzc2lnbiB0byB0aGUgd2xhbjAgaW50ZXJmYWNlLCBp
dCBjYW4gYmUgY29uZmlndXJlZCB3aXRob3V0IG1ha2luZw0KPj4gaW50ZXJmYWNlIHVwKCJ3bGFu
MCB1cCIpLiAiaXAgbGluayBzZXQgZGV2IHdsYW4wIGFkZHJlc3MgWFg6WFg6WFg6WFg6WFgiDQo+
PiBjb21tYW5kIHNob3VsZCBhbGxvdyB0byBzZXQgdGhlIG1hYyBhZGRyZXNzIHdpdGhvdXQgbWFr
aW5nIHRoZSBpbnRlcmZhY2UNCj4+IHVwLg0KPj4gT25jZSB0aGUgbWFjIGFkZHJlc3MgaXMgc2V0
LCB0aGUgd2lsYzEwMDAgd2lsbCB1c2UgdGhhdCBtYWMgYWRkcmVzcyBbMV0NCj4+IGluc3RlYWQg
b2YgdGhlIG9uZSBmcm9tIHdpbGMxMDAwIE5WIG1lbW9yeSB1bnRpbCByZWJvb3QuIEhvd2V2ZXIs
IGFmdGVyDQo+PiBhIHJlYm9vdCwgaWYgbm8gTUFDIGFkZHJlc3MgaXMgY29uZmlndXJlZCBmcm9t
IGFwcGxpY2F0aW9uIHRoZW4gd2lsYzEwMDANCj4+IHdpbGwgdXNlIHRoZSBhZGRyZXNzIGZyb20g
aXRzIE5WIG1lbW9yeS4NCj4+DQo+Pj4gSXMgdGhpcyBhIHZhbGlkIGJlaGF2aW9yIGFuZCBzaG91
bGRuJ3QgdGhlIGFkZHJlc3MgYWxyZWFkeSBiZSBzZXQNCj4+PiBhZnRlciBsb2FkaW5nIHRoZSBk
cml2ZXI/DQo+Pj4NCj4+DQo+PiBPbmx5IHdoZW4gdGhlIGludGVyZmFjZSBpcyB1cChpZmNvbmZp
ZyB3bGFuMCB1cCksIGRyaXZlciBsb2FkcyB0aGUNCj4+IGZpcm13YXJlIHRvIHdpbGMxMDAwIG1v
ZHVsZSBhbmQgYWZ0ZXIgdGhhdCB0aGUgV0lEIGNvbW1hbmRzIHdoaWNoIGFsbG93cw0KPj4gdG8g
c2V0L2dldCB0aGUgbWFjIGFkZHJlc3MgZnJvbSB0aGUgd2lsYzEwMDAgd29ya3MuDQo+IA0KPiBJ
cyB0aGVyZSBhIGhhcmQgdGVjaG5pY2FsIHJlYXNvbiBub3QgdG8gbG9hZCB0aGUgZmlybXdhcmUg
YW5kIHNldCB0aGUNCj4gSFcgYWRkcmVzcyB3aGVuDQo+IHRoZSBkcml2ZXIgaXMgaW5pdGlhbGl6
ZWQgYW5kIG5vdCBvbmx5IHdoZW4gaXRzIG9wZW5lZC4NCj4gDQoNCkFGQUlLLCB3aWxjMTAwMCBm
bG93IGlzIGRlc2lnbmVkIHRoYXQgd2F5IHRvIGxvYWQgdGhlIGZpcm13YXJlIHN0YXJ0DQp3aGVu
IHRoZSBpbnRlcmZhY2UgaXMgdXAgKGJlZm9yZSB3bGFuIG9wZXJhdGlvbiBhcmUgcGVyZm9ybWVk
KS4NClNpbWlsYXJseSB3aGVuIHRoZSBpbnRlcmZhY2UgaXMgZG93biBpdCB3aWxsIG5vdCBleGVj
dXRlIHRvIHNhdmUgcG93ZXIuDQoNClJlZ2FyZHMsDQpBamF5DQoNCg==
