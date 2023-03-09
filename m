Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F7D6B1AB7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 06:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCIF2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 00:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCIF2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 00:28:30 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2623E608;
        Wed,  8 Mar 2023 21:28:26 -0800 (PST)
X-UUID: 34ccdf9abe3b11eda06fc9ecc4dadd91-20230309
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Q2MZarYjL1PLCCXxQu9Px1RNnn3zW1c67qm7eutMHU8=;
        b=DuGxQbcziFmAoRkQv4sWKkNMpDgycUzlPlmeeYsQwhlRQ4aXeZQq0WCW6chVA2RcIvQ4v4KphxOe/x9fSbrJgnsCsE+44TBo3rV2tDfABWYmcNe8T3kyBrePH2fVRifLqZPUApteUJrpGmJ6SPW2xooPMk9SEnmnY7nDrYr8n8E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:c5b130fd-d358-409b-93c8-295bed62aded,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:feb7afb2-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: 34ccdf9abe3b11eda06fc9ecc4dadd91-20230309
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1470448821; Thu, 09 Mar 2023 13:28:21 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 9 Mar 2023 13:28:20 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 9 Mar 2023 13:28:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtcT+rqZy8LelFEmGwAJ7Us6H9MCiVWUaIHGC0kQHOhAWAEwVGtCnTbFqlTAPkldxy4J2DOEK20663+2nv0U1QyqATZPzdnPkBFQyikgR7WwTe/jYcpd9VnnXXvQ7jLyhH1M/S8hs/vTjkrCC2Ls8bsjKwiY6QiQr9EF+VHsa5duqqzJVnPbeG2+8NSQlLGW2CLUozv8pNejQjQNrmG0vvyxTMt4Dl8k2poa5XvFoy3RzDsHUpQyelFz6jc2wChZfv/08AQuq3r1EvwsVvBG8omKS7q32NaZqlP3qkzvBEkEqqgQ4xL6W4MJxjZdswH773PuSOH6Mx7/MuxIwHAoyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2MZarYjL1PLCCXxQu9Px1RNnn3zW1c67qm7eutMHU8=;
 b=D0AOSEqWdYTXNT1YDQLwZmi/o4ythY3y95PP+iPD4JlsMX5l3y9VA5l+8M8b9LKGr3tWCkzz3HPxmPUm+89Y3+RADCJqRbfEaJcyMSaVcojgYUQflobbdu4CDBaHThyGuK534Kiw8nQC00vIIOpQ/kxx7qnCSxpE4uWBdP+vUHtxNURdpVDP4qTyskJDsW0Ry47tFbH2CLcKU7ZhrWOfVXd8VIyPiz9CF2TK0QhTyuRAszwIOVFkpDcoxag4GMCHTceuHvJXFU+MIyG9EEf+212KdnyW8l8gYssayiA6UMVIPRz5bMj/yf1a9YbqN07x3CpU/R3bn1AuaflmDAMSpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2MZarYjL1PLCCXxQu9Px1RNnn3zW1c67qm7eutMHU8=;
 b=Jv0m0jlOzaugZau11W/2e7rR/mpEcbuXR+d3VUVRVqZXfA6jK7quoN8mlgXBwp03E+fT4xyZtJGrypg+1JkFj0sSsf8Z5aYcMHoeXAXekKWNpb6RSJhrxTTV9Iq0AZ3qYaFkYmQgEp+uJJqZSSWsf72Q1XnTMHwZRltq7AFNGW8=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by KL1PR0302MB5218.apcprd03.prod.outlook.com (2603:1096:820:49::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Thu, 9 Mar
 2023 05:28:15 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 05:28:15 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "wenst@chromium.org" <wenst@chromium.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Project_Global_Chrome_Upstream_Group 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 14/19] clk: mediatek: Add MT8188 vencsys clock support
Thread-Topic: [PATCH v5 14/19] clk: mediatek: Add MT8188 vencsys clock support
Thread-Index: AQHZLAR2kJV7uPGptkC6OYiXmhx1ca686WYAgDVOdQA=
Date:   Thu, 9 Mar 2023 05:28:15 +0000
Message-ID: <29f5fc4cb7f85a574e7a5869784a2c80aa0a01e3.camel@mediatek.com>
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
         <20230119124848.26364-15-Garmin.Chang@mediatek.com>
         <CAGXv+5ECLKewj1_sU9WzJA9Z8pRyKBo6fxBLrogoBH76Y5f32w@mail.gmail.com>
In-Reply-To: <CAGXv+5ECLKewj1_sU9WzJA9Z8pRyKBo6fxBLrogoBH76Y5f32w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|KL1PR0302MB5218:EE_
x-ms-office365-filtering-correlation-id: 56b13018-49ae-4f57-5e28-08db205f1569
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qNFBwrTQJvl9gCZ/bGCdMeCLc0rq7UOOjJnEh8lBmW9b8uEBsmsJj8N4KKtugKMLH9HF4FKh4eoc70v8RmkwUuOhzuHIK7YhvvMNcUKdeTsIoedqllFrFOGgSHpLM+IBzA4zbGasz36ZlDVcwy1gArQUN4+ArOta2Y0wUqk9tAEkSIvYP+Nh8uIMLo5TI+2Myvts3rxsvtKN+51ElnuqqsnoZZAg2Fa+aQFxigCdM78iU1hppRq35WxaJQHFwCXO5Z5teLChi4cH3CpV1MkDPYjJ45FBQdbwfUDFEoedcyCbz7iXGzpHOuwPnjIX/hRslfKo/7FKmf6VGYcvYOjeAMqUbV6ehEBxoRVQ4yBe0TUjKxuJNbv++loXY/SEsGnSXcFEWuv1fkG145o0TD7qXX0iP29aD3c3oW2JG3uO1l2G17NFZt2PBXHg//yeVQP9XsIrKgepTnW4O33fanATXDp8zz86FsM6VDg1wiJNNDJidJqKQkof7WkcrcHZYEWPMy2qf5djnH/Y0qSrtSCeqnMiF7wcok1/RqVB9cy585lQUuppj0TxmcdYVC3txSw0jdYnO5pIozZ/Fe0tfpeFD2ggilwSgHnPZQHLgifzNWNoORkstozdY2VoyedKovYV/tWAOhl+tO1sgBPBlRRrZuUpqkc5ueHIZjFspS59ul4J4SmtIKtE+a+baY+LDWdqAHCkHpWsf9ReAt3I/gp+Cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(451199018)(54906003)(316002)(36756003)(85182001)(38070700005)(86362001)(6506007)(122000001)(6512007)(83380400001)(53546011)(26005)(186003)(2616005)(5660300002)(7416002)(38100700002)(6486002)(478600001)(71200400001)(8936002)(4326008)(41300700001)(91956017)(2906002)(66446008)(64756008)(66946007)(66556008)(6916009)(8676002)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmM5dHdQTTdJS2xKVU5jQTBFWks3VC9ZUnZhUFgzTGc2Rm9XVG9KenZWaU5M?=
 =?utf-8?B?Mkd2V0ErODFxNmJ3ZVZuUDNnSWl5d25RRHJBbHFSNW1udXc1QmZ2N29ac3dY?=
 =?utf-8?B?cWNrSWlnT0c2Vm9Gbm0wQk9kalBkTW1VL1l2aEtZTmlQOWFLdkZQbnlqQ1NK?=
 =?utf-8?B?Zkp5bDNXYVMrSGxiSklUTjFWVkpsRjRNTThGaG1lak5ydFdrZXJPV2c0Y05F?=
 =?utf-8?B?WktrcmdyUWRQaGVlK2hMaXBUcGg3MXA3VXV6U3QwTjFSQ05DWkZXVUlKdnA5?=
 =?utf-8?B?MVZRWG1vYnhkOHdVcHZ2VHNldXFUUW9HTUFicThqejM4QWdZM3VCajRCdTNn?=
 =?utf-8?B?VzY3T0dMN2pBZFN2UFQxSWpRa3poU04zNkhiSG9QT0dNRlNZWmI1QjJLT0F1?=
 =?utf-8?B?RXBXZUhkeEYyZHNCaW1YblZRbXRRMFgvZ1NNMTBOanEzVVhZZzdTaGIvekNR?=
 =?utf-8?B?WGZlUUlmdnZBVDQ0WGR1ZUxiazEyVUtRUnFZd2tEN21xOFc3QmlJMVhrbGEv?=
 =?utf-8?B?SG54MXBxQXJnRWlMQ2VzUGNTZkhkVy9BY0VRU0dzTEhadkhZd0VnY3paLzNk?=
 =?utf-8?B?dVZBS0NhcVp4YllrbHRSZThkNml6WmtBS2tvcnhPRHVxbjJVaEZJNDV6amg2?=
 =?utf-8?B?ZjNQTjRyQitTcU95SHhhelNzY1RIdUU1M2ozVGdoNytYbGgrL2dLVGp2MXRN?=
 =?utf-8?B?WnN6ajBtall2NkVRMVhqNm5PMUttdGg1T2RCSDdCWUhkT1NKZU1LdUpXT1Bs?=
 =?utf-8?B?U0FnYXNlN2s3UlRFVkYxcEFmeUFDNmdUS1hXRjFwL3dIMWhTalJRMWJJTGlh?=
 =?utf-8?B?YjRzSFgxY3p5Zm9KYnB4TVVoRXc0VXpEUVR4Z1VtR2hTYkVHbCs4WlozeXVw?=
 =?utf-8?B?dmNYY3NjWXlIbHhzQldoSFFycjZLNFF5WEZoSGhTbHJRb3hNbWxmTXdUUmRZ?=
 =?utf-8?B?T3crS1drdnc5d05ydHdlRHpncDExdHVBSnBkUkZpR0ZxakxXcXl5dVRDVzMr?=
 =?utf-8?B?OEZ1bFpna2JQU2EzRXNRNG00dDJOQlpWbmtDSFhURm5XVmhVMFcyaUdzTEw0?=
 =?utf-8?B?N000NmhoNFhXcGJEUkdNMHdNN0ovQjFCckRLVkJWRGVUekRRVi80QlJUZHYx?=
 =?utf-8?B?NEkzc3U1WC83OUxTOHBVcHlyTkRmeHF1NTl6elFsbzFlNUl1emM4ZytjRk55?=
 =?utf-8?B?dEZmOHY2RFo5REJNWTI4eENlUy9URjRCdXhMTHlzckpoelRxaGFEb0s5bERV?=
 =?utf-8?B?Ym1XeXBGZzIzb2dSbVEzTGlEU0V1OXFJSTJXVVVLS2t1UE9nRVlxRmZIYWFa?=
 =?utf-8?B?S280eHgybXhPZWd3bStNSXlHKzJCWFpSSUM1VnF4b1Yyai8zNHI0cVNmMHc4?=
 =?utf-8?B?K1RSSnE3WFRnWTF6Mk95RWdLNUwyVVQ5UDlXVkdudFFtMVFTcm0yZ0ZUdUsx?=
 =?utf-8?B?Qks4RXZiK2ZWTitJNGJKZStyU1ZYc0tLTk9tdDYrNW9IMVJiZEZMaUwzZGlp?=
 =?utf-8?B?ZzNnZkRwc0VmL0pTTm0zelJ4MlNuMk1oVUlzdGYrUUJxWm5NUFltKzhESW01?=
 =?utf-8?B?eHhXbDY4cVFMdWFBd04xRVUzanhtMk0vNWxzbXp5SUlycElrNnA3bzFxMHVy?=
 =?utf-8?B?aVYxOHZPdzJRd2pURUVCeUJvdnE1WWZRblNDRFVIOVI0R3hNOFI4SENCSDBG?=
 =?utf-8?B?RHNWaTlkbUsyUGlKRDRaWm5KWmFWVTJzcXVHR1RlcWs1aGlreVFVYXVlUXRY?=
 =?utf-8?B?WE8yR1YrY2dIT0hIb1dxMGoySlA0dHIxYmpaMk01QzZENm5idWpQYXo1T1RK?=
 =?utf-8?B?K09wWlhPUk4yeS9wOTlRQmxkTHB4dDlDWnNkN2gzSkl6ZG83dzVxWVFQY09E?=
 =?utf-8?B?QXdYNkhUMFA5UCtYemsxTEJEWTlxTGltSExrM2V0WlRUL2dEM3VrdUF0WEtO?=
 =?utf-8?B?TFR6WUNKTDlTVFNwbFBvazkvNmcxU3EvSCtwZjRaajlFNW9LZWRwaDhHQVEz?=
 =?utf-8?B?VGhKSnNQNHl2UytSUDVUVUZFeTJ3Z2wvQklsZHExUkdMWFFOenIvS2FkbCs2?=
 =?utf-8?B?bzVscUVwUCtTT2VFdjB1ZCtYYmVBa0hrWFA1SUZ4azM5OGZMSWp0S2ZtL25j?=
 =?utf-8?B?SXQ1Z1E3a3R5V3ZiVlRwYUhHRG1SV2V4V3c3ZnlDTGRxMEhhNDV5U2ovMm1F?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <866DC5AC622F2748A54A842E06F5AB0B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b13018-49ae-4f57-5e28-08db205f1569
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 05:28:15.5641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9yYjwyJYMhne/VAmXcBPUdrVPJY0cZkuO51q1i60Hn1f/vX/IYAbMu3mYkZvoRQ9Q/Sswb6YoFfSkJvhM0a81ocURW2bvCYuFWsMp7SM9mA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0302MB5218
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDE1OjI1ICswODAwLCBDaGVuLVl1IFRzYWkgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDE5LCAyMDIzIGF0IDg6NTUgUE0gR2FybWluLkNoYW5nIDwNCj4gR2FybWlu
LkNoYW5nQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIE1UODE4OCB2ZW5jc3lz
IGNsb2NrIGNvbnRyb2xsZXJzIHdoaWNoIHByb3ZpZGUgY2xvY2sgZ2F0ZQ0KPiA+IGNvbnRyb2wg
Zm9yIHZpZGVvIGVuY29kZXIuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogR2FybWluLkNoYW5n
IDxHYXJtaW4uQ2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2Nsay9t
ZWRpYXRlay9NYWtlZmlsZSAgICAgICAgICB8ICAyICstDQo+ID4gIGRyaXZlcnMvY2xrL21lZGlh
dGVrL2Nsay1tdDgxODgtdmVuYy5jIHwgNTINCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgt
dmVuYy5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2Vm
aWxlDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+IGluZGV4IGM2NTRm
NDI4OGUwOS4uMjJhMzg0MDE2MGZjIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvY2xrL21lZGlh
dGVrL01ha2VmaWxlDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4g
PiBAQCAtODcsNyArODcsNyBAQCBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxODgpICs9IGNs
ay1tdDgxODgtDQo+ID4gYXBtaXhlZHN5cy5vIGNsay1tdDgxODgtdG9wY2tnZW4ubw0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xrLW10ODE4OC1wZXJpX2FvLm8gY2xr
LW10ODE4OC0NCj4gPiBpbmZyYV9hby5vIFwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGNsay1tdDgxODgtY2FtLm8gY2xrLW10ODE4OC0NCj4gPiBjY3UubyBjbGstbXQ4
MTg4LWltZy5vIFwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsay1t
dDgxODgtaXBlLm8gY2xrLW10ODE4OC0NCj4gPiBtZmcubyBjbGstbXQ4MTg4LXZkZWMubyBcDQo+
ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGstbXQ4MTg4LXZkbzAubyBj
bGstbXQ4MTg4LQ0KPiA+IHZkbzEubw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY2xrLW10ODE4OC12ZG8wLm8gY2xrLW10ODE4OC0NCj4gPiB2ZG8xLm8gY2xrLW10ODE4
OC12ZW5jLm8NCj4gPiAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyKSArPSBjbGstbXQ4
MTkyLm8NCj4gPiAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyX0FVRFNZUykgKz0gY2xr
LW10ODE5Mi1hdWQubw0KPiA+ICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJfQ0FNU1lT
KSArPSBjbGstbXQ4MTkyLWNhbS5vDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlh
dGVrL2Nsay1tdDgxODgtdmVuYy5jDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4
MTg4LXZlbmMuYw0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAw
MDAwLi4zNzVlZjk5ZTIzNDkNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9j
bGsvbWVkaWF0ZWsvY2xrLW10ODE4OC12ZW5jLmMNCj4gPiBAQCAtMCwwICsxLDUyIEBADQo+ID4g
Ky8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiArLy8NCj4gPiAr
Ly8gQ29weXJpZ2h0IChjKSAyMDIyIE1lZGlhVGVrIEluYy4NCj4gPiArLy8gQXV0aG9yOiBHYXJt
aW4gQ2hhbmcgPGdhcm1pbi5jaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gKw0KPiA+ICsjaW5jbHVk
ZSA8bGludXgvY2xrLXByb3ZpZGVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9k
ZXZpY2UuaD4NCj4gPiArI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4
OC1jbGsuaD4NCj4gPiArDQo+ID4gKyNpbmNsdWRlICJjbGstZ2F0ZS5oIg0KPiA+ICsjaW5jbHVk
ZSAiY2xrLW10ay5oIg0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZV9y
ZWdzIHZlbjFfY2dfcmVncyA9IHsNCj4gDQo+IExpa2UgdGhlIHZkZWNzeXMgcGF0Y2gsIHBsZWFz
ZSBjaGFuZ2UgInZlbiIgdG8gInZlbmMiIHRvIGJlDQo+IGNvbnNpc3RlbnQNCj4gd2l0aCB1c2Fn
ZXMgZWxzZXdoZXJlLg0KDQoNClRoYW5rIHlvdSBmb3IgeW91ciBzdWdnZXN0aW9ucy4NCk9LLCBJ
IHdpbGwgbW9kaWZ5IHRoaXMgc2VyaWVzIGluIHY2Lg0KPiANCj4gPiArICAgICAgIC5zZXRfb2Zz
ID0gMHg0LA0KPiA+ICsgICAgICAgLmNscl9vZnMgPSAweDgsDQo+ID4gKyAgICAgICAuc3RhX29m
cyA9IDB4MCwNCj4gPiArfTsNCj4gPiArDQo+ID4gKyNkZWZpbmUgR0FURV9WRU4xKF9pZCwgX25h
bWUsIF9wYXJlbnQsIF9zaGlmdCkgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICAgIEdBVEVf
TVRLKF9pZCwgX25hbWUsIF9wYXJlbnQsICZ2ZW4xX2NnX3JlZ3MsIF9zaGlmdCwNCj4gPiAmbXRr
X2Nsa19nYXRlX29wc19zZXRjbHJfaW52KQ0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVj
dCBtdGtfZ2F0ZSB2ZW4xX2Nsa3NbXSA9IHsNCj4gPiArICAgICAgIEdBVEVfVkVOMShDTEtfVkVO
MV9DS0UwX0xBUkIsICJ2ZW4xX2NrZTBfbGFyYiIsICJ0b3BfdmVuYyIsDQo+ID4gMCksDQo+ID4g
KyAgICAgICBHQVRFX1ZFTjEoQ0xLX1ZFTjFfQ0tFMV9WRU5DLCAidmVuMV9ja2UxX3ZlbmMiLCAi
dG9wX3ZlbmMiLA0KPiA+IDQpLA0KPiA+ICsgICAgICAgR0FURV9WRU4xKENMS19WRU4xX0NLRTJf
SlBHRU5DLCAidmVuMV9ja2UyX2pwZ2VuYyIsDQo+ID4gInRvcF92ZW5jIiwgOCksDQo+ID4gKyAg
ICAgICBHQVRFX1ZFTjEoQ0xLX1ZFTjFfQ0tFM19KUEdERUMsICJ2ZW4xX2NrZTNfanBnZGVjIiwN
Cj4gPiAidG9wX3ZlbmMiLCAxMiksDQo+ID4gKyAgICAgICBHQVRFX1ZFTjEoQ0xLX1ZFTjFfQ0tF
NF9KUEdERUNfQzEsICJ2ZW4xX2NrZTRfanBnZGVjX2MxIiwNCj4gPiAidG9wX3ZlbmMiLCAxNiks
DQo+ID4gKyAgICAgICBHQVRFX1ZFTjEoQ0xLX1ZFTjFfQ0tFNV9HQUxTLCAidmVuMV9ja2U1X2dh
bHMiLCAidG9wX3ZlbmMiLA0KPiA+IDI4KSwNCj4gPiArICAgICAgIEdBVEVfVkVOMShDTEtfVkVO
MV9DS0U2X0dBTFNfU1JBTSwgInZlbjFfY2tlNl9nYWxzX3NyYW0iLA0KPiA+ICJ0b3BfdmVuYyIs
IDMxKSwNCj4gDQo+IElzIGNrZU4gaW4gYm90aCB0aGUgbWFjcm8gbmFtZSBhbmQgY2xvY2sgbmFt
ZSBuZWNlc3Nhcnk/IFdlIGRvbid0DQo+IHJlYWxseQ0KPiBjYXJlIGFib3V0IHRoZSBpbmRleC4N
Cj4gDQo+IENoZW5ZdQ0KDQpPSywgSSB3aWxsIG1vZGlmeSBpdCBpbiB2Ni4NCj4gDQo+ID4gK307
DQo+ID4gKw0KPiA+ICtzdGF0aWMgY29uc3Qgc3RydWN0IG10a19jbGtfZGVzYyB2ZW4xX2Rlc2Mg
PSB7DQo+ID4gKyAgICAgICAuY2xrcyA9IHZlbjFfY2xrcywNCj4gPiArICAgICAgIC5udW1fY2xr
cyA9IEFSUkFZX1NJWkUodmVuMV9jbGtzKSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBj
b25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIG9mX21hdGNoX2Nsa19tdDgxODhfdmVuMVtdID0gew0K
PiA+ICsgICAgICAgeyAuY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDgxODgtdmVuY3N5cyIsIC5k
YXRhID0NCj4gPiAmdmVuMV9kZXNjIH0sDQo+ID4gKyAgICAgICB7IC8qIHNlbnRpbmVsICovIH0N
Cj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyIGNsa19t
dDgxODhfdmVuMV9kcnYgPSB7DQo+ID4gKyAgICAgICAucHJvYmUgPSBtdGtfY2xrX3NpbXBsZV9w
cm9iZSwNCj4gPiArICAgICAgIC5yZW1vdmUgPSBtdGtfY2xrX3NpbXBsZV9yZW1vdmUsDQo+ID4g
KyAgICAgICAuZHJpdmVyID0gew0KPiA+ICsgICAgICAgICAgICAgICAubmFtZSA9ICJjbGstbXQ4
MTg4LXZlbjEiLA0KPiA+ICsgICAgICAgICAgICAgICAub2ZfbWF0Y2hfdGFibGUgPSBvZl9tYXRj
aF9jbGtfbXQ4MTg4X3ZlbjEsDQo+ID4gKyAgICAgICB9LA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAr
YnVpbHRpbl9wbGF0Zm9ybV9kcml2ZXIoY2xrX210ODE4OF92ZW4xX2Rydik7DQo+ID4gK01PRFVM
RV9MSUNFTlNFKCJHUEwiKTsNCj4gPiAtLQ0KPiA+IDIuMTguMA0KPiA+IA0KPiA+IA0K
