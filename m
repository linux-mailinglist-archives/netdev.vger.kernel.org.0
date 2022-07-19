Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C8D57A3CF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiGSP6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbiGSP6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:58:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30441550BB;
        Tue, 19 Jul 2022 08:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658246303; x=1689782303;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YVuroazK/lNrncDQWPIbM2SHI9Pny36mz3CnuBX1S3Q=;
  b=RBf6NHVDCEKj9N1Ss05RZmdOQJk5b5h+6bKOJwm8xnHAlOyVuoAM8+dV
   WsTjtA/GdiSnVHY3i0QLHK/g/77A1xsMXsWmO03fYarHy2M162Stwvq/c
   qFHxHpVLeIsqlucCNp2+0xdM/VINvio/9wHAuQLy4WFCH7LjUKKY3HWXw
   yyaljnoCoWqGnxLdlIC7+MFlmBUSQezlGXEFzpimVLjoV6SD80GX5HOd1
   c16L/epwGmGCizMMZfP9u6lBK598uQX7gzdw4c0OKe42/WGWm9wcBKMCq
   JhOcx2WGtyHczIY/oB0g3TNI5ZRdzRsL8kTL4FHI58iZSYPQhbAzpARG1
   A==;
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="165447787"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2022 08:58:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Jul 2022 08:58:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 19 Jul 2022 08:58:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pz+ikOAqx2X7GOepkJBsKE08IBsgW2aAXuwrn0W9qRT9TSwHo0bAboC3CVE4xv9h5JrLrcRQl4tcJ5hdq677IYlUAPhSBM5jIjfc/r+fbGVHT2KLVSqN9NpSIvr+W17ECyOM2aNATn2ahYySvUILBbFNoc2qYDCkCGOccOGEz5gB8AH7gKWB6KhvjC97nDqiigzIrMoe/g/umWuezC4EIm0SUPR8sIRsu17jJAQghSlQQWl2Yi1OSkSM2iO0aWmVJ+SvL+d83HBw+lCutNz7MC96zDEPEyIXIT8RkcAvtLq7D15vKZQ7IIGHq4T/F/qCpMx98y54Xs9T9HkeDR7r5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVuroazK/lNrncDQWPIbM2SHI9Pny36mz3CnuBX1S3Q=;
 b=Jw71LKNdIInKiwHtQ5wBQ84vM4ntv60C/ChhKAz+cHgYoqC+NfKj73UaejSVAusyxm+nvJbG58sVHz4RUjGEorUlHoZuXjKxyjJRZpcdCPIab7IKW/BgJUNBlaUYcBZUOF2O4o29SDSpCIaAB/jl0MWtj/rsCHuzl6zw0kBIPOOBKXZISQsFFTlNmuWadNOvDhu/Uba7wmHxA5wS3AURxtOgySyJzRGC3gXDGop+zW6iFgN4NtdqpLtB3Niki6WkoQ03JP9eI1EljVb1jIvaNXa14HI6yHQR1iBVvInpe4loY24bElFltAmOWbldALmH7qaixeXzBxw/vsesx2H9lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVuroazK/lNrncDQWPIbM2SHI9Pny36mz3CnuBX1S3Q=;
 b=bm8dnzw+Uv+P8T02cMk4HU2PtD8xzL/dtfhRpZrJyn+QVl+uZsX44GnPOd6vEQCa9einF20AK7QRV0NxAD6GfL8L/zGqszX6edH4/UZk3LAJ+q1zpJKEC6+SwDuFJLbU5M248MsyjG+U0GkyvoczURu+3EmDr6YQXCIeD0Nde9o=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SN6PR11MB2766.namprd11.prod.outlook.com (2603:10b6:805:53::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.20; Tue, 19 Jul 2022 15:58:16 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5438.014; Tue, 19 Jul 2022
 15:58:16 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next 01/10] net: dsa: microchip: lan937x: read
 rgmii delay from device tree
Thread-Topic: [RFC Patch net-next 01/10] net: dsa: microchip: lan937x: read
 rgmii delay from device tree
Thread-Index: AQHYlgkOPPBLc+aR9kKiVyf/3L28ga2FiGUAgABcPoA=
Date:   Tue, 19 Jul 2022 15:58:16 +0000
Message-ID: <2b1c9bec6824eeea8f9099482a7d762fc32edb15.camel@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
         <20220712160308.13253-2-arun.ramadoss@microchip.com>
         <20220719102806.3v7s3metdgo4tmmp@skbuf>
In-Reply-To: <20220719102806.3v7s3metdgo4tmmp@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 145459cb-69f6-40a8-b057-08da699f7e2a
x-ms-traffictypediagnostic: SN6PR11MB2766:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gbHqiw1urJqjKf8Gy1xmQjCFaRQWrLvWZDuU36GxYMmKJVnkHg/QITkoO2ithx0BZrZ1j2IGDpXIQFCv2Eva4dQks4XNfWaOQtKLgLMFY++G/ANeanckXNcmDz8Tcmja9UrvAYlIxTk7m7UPFNWUPb0B0YUVS4DDFjZ9PLW35g8YxVPniKh5r1nd+nnWYNxM4Di9NjXwbMyH36PGhd/Org4jAUknZGG0U2D+X1hDXmK4HkJcev89LPx4SOjD9uRkUET25u5x7i+dE6N+XhWa1HLDlg34EVyNjNwtgPxLcx1o/XN013wpoBeyA2DZIgU14JLSuDTMr26mTrJk+wPz8zLf3nMxb7UK9/PuHMG0gS3QNFrnwwgECefQVnIidjtenAMDpvdotnsLXw0mu4Tv53ExZXge2hrA5MMOXk4dcdrBGYHIAKk5/atoV5kbymuM9BsMZxhWYGbxBshCNaL+yqOH3dSmMlAMQJSoexFJ+rbvuO3W5LVz5zKUkF07SXGx1HjNnx+hyk3C9jqbam6RDcP/2UjRNhACfhNxq0gdN1jxSMLBh2+CyNChDAzhAHH1PpZAQKZx7mfxPF20PsDX7Dxd2n0wGxyqs8f6LgDMFF6MdeE19nY89Dem3g30AkM+31sceTsIPBok/o8+BjlKGP6PKGIihPtI1wV9ndmw1DCIeV9BMxZQ1nSoOlBqK6yimj8Dzg3hVizUcdaBwpVJxR2WBUE0X/CZsPaofZn1M/G8GYlolCk475tyYxirAKsX8KF90BDKDLtO73XXr6AwjiJYA+hfj3NeM2RTceNypWfWevgfljudTWweajraY+2ctfzVyElZxYHGlBPWzzFr8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(366004)(136003)(396003)(6512007)(38100700002)(86362001)(38070700005)(36756003)(71200400001)(478600001)(2616005)(186003)(6486002)(6506007)(41300700001)(66556008)(6916009)(64756008)(316002)(5660300002)(2906002)(8936002)(66476007)(4326008)(76116006)(66946007)(54906003)(122000001)(7416002)(66446008)(8676002)(91956017)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWR4MCswZ2FsNFdES0hKRDMwOVlXRzhCSGgwU2s4cWo1ZkFCYXEzYW5ZYXd1?=
 =?utf-8?B?Y2k5S3pnNlFaWE5rSCsrQjNiOTZ0cVVzOWo1UTkvMFZGSVNtT3drejE3ZUFa?=
 =?utf-8?B?a1FObWhONklSVE93ZDF0d2FOWDBGR3VibnQwU0Fld2tNY3pXMUtiSERoMTQ2?=
 =?utf-8?B?NzZib0FMUnlXZXI0c2M2WFRiaHJtcWpILzlqT1ByZ2F1OHhicmNEQkdzdTNE?=
 =?utf-8?B?a3BLWnUydU82dVhzN2NxeEVKa0lpN3QyMVZDb2RLVW9jRlFBVS9pV1lmK1Vy?=
 =?utf-8?B?dWVRbWZJTXpPVXNSUUJyWHlzR3FaNmc3RFV2clRMMUFYOXJ2VlB2VG1yM1dl?=
 =?utf-8?B?SW5TS1JSWjlmTWU3Tzk3YllYQTB4cUtLNFB1UzQ1TkZRZkdkMnVUaFFkTHhi?=
 =?utf-8?B?TjhDeEFiVEFHMnc2bEhQRERjNklvcGFUbU4ydnptdU9tQ0p5OWx4Rm50Mlg1?=
 =?utf-8?B?T1dRbU9FQ044V1ZWdmF6OFR0WCtWRlJ1TUYvZWp6VXl6T1BlVVAzVHVKY3RJ?=
 =?utf-8?B?TzBSSkl4M2RCU3lCaDB2c0pMUUpsUmhCLzJrNkNwNno2cDRZbStJOTIzZXBX?=
 =?utf-8?B?Z05VY0l4dkw4WFNMOXZQeGhXZnY3Mmw5ZGR2TnlUNGU3MndVYytaaXptNEtx?=
 =?utf-8?B?eDBJWGZwV1ZWOWZQSW5Rdmd2ek9NQjBnRkZ4MFZuMUxNajQxQjZQbUphVzds?=
 =?utf-8?B?TzdkVXdrbGU4cHgzUWpkWW1nTkxnQThweGt0TXYvSGk2S0NPOHlpdFRHVlIz?=
 =?utf-8?B?Mm5XMzB4enc2UlJjcGRkVjFJcXdzYXBiSlpIVGVkRFh3MmREYXhEd1Roc1hX?=
 =?utf-8?B?b2tBeWlBdXRwKzNtcERkZzluYTRLdlRKdjBBc1ZuS3RNcG1Dd2I4OHYrcTQ2?=
 =?utf-8?B?YnZmazJMMnVXeXVac3lzcDVFWEV6Q1FRQWlhdmxhaGV1Nmd6bzA3QlRlcExO?=
 =?utf-8?B?K0o1bmVlOWpiYmN5ektzNVRXNzZMaXNRWjA0TlVVYTdFSjNvZFZLUWMyL3Zm?=
 =?utf-8?B?eVVjTFVDTllHUm5LaUE3aVRjWTc2VHdWVGNrcDhYbkdlTnp5ckFuV2FINUUr?=
 =?utf-8?B?N21KT1RtTUxGV2JNVXc4WThBMWFMeTQ3amtPWFIwU25GMUtQRUE1cmxySm1z?=
 =?utf-8?B?ZXN6OXNvZkdnazVQazYyejlBQndWRmhOMDByUCtQdUd6NDYvL1MyREhoQlN2?=
 =?utf-8?B?OXpoVEQwZ1FVaXVLdEprME1UMnUzMFdtcGI5OXBGVVB0ZnV4UnoyaGZ3UXNI?=
 =?utf-8?B?dWM0QTNnZlFhNTFmUEpwS2RtaUI4K3ZNdG8xSnpDWEp1ems0YndBMWpmbEdv?=
 =?utf-8?B?QldUaTUrUFQ0MzhPdUdIbmdzRVdlQUlHT3NScW5ETFQvc0NWdnlZSzMwNWcr?=
 =?utf-8?B?RlRINU1SMFRSem9WOG45cjByQ1FKMnJLeGhZaTdnNWpKTTBTN3hXWG56WlF5?=
 =?utf-8?B?QmZTQjB3OVlzREFjWUVEcnhsb25Oa01HRWRidFR2VDZCQXFHWEdXa0hXc29j?=
 =?utf-8?B?VjR2REtnRnk0M2J0VXVFcmQ0WkJldHVMSUs5VHh0VTNTOENMVnBtRXo5YnJU?=
 =?utf-8?B?UU1lQm0zTytISUpGc3dsMXAyUjV6M2pPcVZQbXhtWDVRTTd3bjlvbzd4YzBp?=
 =?utf-8?B?bUloYmNEQllGWlh4eVpwL1NMendIcS9EOGNaMFl0S1F2RzkyWnNwbFlITDBC?=
 =?utf-8?B?K1BPZG92Y1Erb21ydFMyOGROVGM1dnYxMVhJRWxuNzNaSjdveCs0cEQ5bVVF?=
 =?utf-8?B?QmpNNGZDTW1jMG5RakpCbFFUcFdFdjBoREE4azQ4MXlLZ2ZtemZRMmpWN1U2?=
 =?utf-8?B?cWUwWmxseDZZL1JtM0tvdk52KzAwY0VsbWZVU3BCck91UHVpa2p5SU1LK3Qr?=
 =?utf-8?B?TmVnZFV5WU1STVZob2oxMXpBVjZIY2ZqSm1JMTFiT2xRb1E2elc5OHBSdHVT?=
 =?utf-8?B?QlQzZktTaklWdXpraXZhbWNwTmpzOW9pdFJuSXRZalFvL3NaR1FGd0NvTXpm?=
 =?utf-8?B?MlIvUVEvK3hoVEI3U0hXTDFrcU0rbldOalNRc1pFaXFWaGJ2Vm1qd01veG5B?=
 =?utf-8?B?dEVuQXZXcnN0UWNxa2crRmhlbnhtZHpEUExCZWFNU0FSU1N1MkUrVE04Mm8x?=
 =?utf-8?B?Y2R4MUVmWVd3N2VuOWk0NzFwK0tKT2xHNHJDc2k4OFZmR1RnVFBNUC8vRWtR?=
 =?utf-8?B?VWxNTHhacVhIWTVselRJbFBJNkYxQlhtM1ErY3Zwa1JvTEtVUEkrMWo3TjdG?=
 =?utf-8?Q?cU7iZboEKRa7tvpDWTov1HQ9xSuqgEcdPgi9sv6ZuY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BA8CC6BC9266F4FA9689971FEA6A19D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 145459cb-69f6-40a8-b057-08da699f7e2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 15:58:16.3633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qny8gga5VT2Fnbf2IOV30CjEBZarNSAKzA+eyatzXdDMHagf0GNu/bBCikZvBtBpD+Zgl8/DFeyhIODAwHvhIf3gdOq3R0jViYFGKaC5O6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2766
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA3LTE5IGF0IDEzOjI4ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVHVlLCBK
dWwgMTIsIDIwMjIgYXQgMDk6MzI6NTlQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBUaGlzIHBhdGNoIHJlYWQgdGhlIHJnbWlpIHR4IGFuZCByeCBkZWxheSBmcm9tIGRldmljZSB0
cmVlIGFuZA0KPiA+IHN0b3JlZCBpdA0KPiA+IGluIHRoZSBrc3pfcG9ydC4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBBcnVuIFJhbWFkb3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+
DQo+ID4gLS0tDQo+IA0KPiBJIHRoaW5rIHRoaXMgcGF0Y2ggc2hvdWxkIGJlIHNxdWFzaGVkIGlu
dG8gdGhlIGNoYW5nZSB0aGF0IGFjdHVhbGx5DQo+IHVzZXMNCj4gdGhlIHBhcnNlZCB2YWx1ZXMu
DQoNCk9rLCBJIHdpbGwgU3F1YXNoIHRoaXMgcGF0Y2guDQoNCj4gDQo+ID4gIGRyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jIHwgMTYgKysrKysrKysrKysrKysrKw0KPiA+ICBk
cml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaCB8ICAyICsrDQo+ID4gIDIgZmls
ZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+IGIvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiBpbmRleCAyOGQ3Y2IyY2U5OGYuLjRiYzYyNzdi
NDM2MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21t
b24uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+
ID4gQEAgLTE0OTksNiArMTQ5OSw3IEBAIGludCBrc3pfc3dpdGNoX3JlZ2lzdGVyKHN0cnVjdCBr
c3pfZGV2aWNlDQo+ID4gKmRldikNCj4gPiAgICAgICBzdHJ1Y3QgZGV2aWNlX25vZGUgKnBvcnQs
ICpwb3J0czsNCj4gPiAgICAgICBwaHlfaW50ZXJmYWNlX3QgaW50ZXJmYWNlOw0KPiA+ICAgICAg
IHVuc2lnbmVkIGludCBwb3J0X251bTsNCj4gPiArICAgICB1MzIgKnZhbHVlOw0KPiA+ICAgICAg
IGludCByZXQ7DQo+ID4gICAgICAgaW50IGk7DQo+ID4gDQo+ID4gQEAgLTE1ODksNiArMTU5MCwy
MSBAQCBpbnQga3N6X3N3aXRjaF9yZWdpc3RlcihzdHJ1Y3Qga3N6X2RldmljZQ0KPiA+ICpkZXYp
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIG9mX2dldF9waHlfbW9kZShwb3J0LA0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmZGV2LQ0KPiA+ID5wb3J0c1twb3J0X251
bV0uaW50ZXJmYWNlKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aWYgKCFkZXYtPmluZm8tDQo+ID4gPnN1cHBvcnRzX3JnbWlpW3BvcnRfbnVtXSkNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ICsNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWx1ZSA9ICZkZXYtDQo+ID4gPnBvcnRzW3Bv
cnRfbnVtXS5yZ21paV9yeF92YWw7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aWYgKG9mX3Byb3BlcnR5X3JlYWRfdTMyKHBvcnQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJyeC0NCj4gPiBpbnRlcm5hbC1kZWxh
eS1wcyIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHZhbHVlKSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICp2YWx1ZSA9IDA7DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHZhbHVlID0gJmRldi0NCj4gPiA+cG9ydHNbcG9ydF9udW1dLnJnbWlpX3R4X3ZhbDsNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAob2ZfcHJvcGVydHlfcmVhZF91MzIocG9y
dCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgInR4LQ0KPiA+IGludGVybmFsLWRlbGF5LXBzIiwNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsdWUpKQ0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKnZhbHVlID0gMDsNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgfQ0KPiA+ICAgICAgICAgICAgICAgZGV2LT5zeW5jbGtvXzEyNSA9IG9m
X3Byb3BlcnR5X3JlYWRfYm9vbChkZXYtPmRldi0NCj4gPiA+b2Zfbm9kZSwNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIm1pY3JvY2hp
cCxzDQo+ID4geW5jbGtvLTEyNSIpOw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2Ev
bWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmgNCj4gPiBpbmRleCBkNWRkZGI3ZWMwNDUuLjQxZmU2Mzg4YWY5ZSAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gQEAgLTc3LDYg
Kzc3LDggQEAgc3RydWN0IGtzel9wb3J0IHsNCj4gPiAgICAgICBzdHJ1Y3Qga3N6X3BvcnRfbWli
IG1pYjsNCj4gPiAgICAgICBwaHlfaW50ZXJmYWNlX3QgaW50ZXJmYWNlOw0KPiA+ICAgICAgIHUx
NiBtYXhfZnJhbWU7DQo+ID4gKyAgICAgdTMyIHJnbWlpX3R4X3ZhbDsNCj4gPiArICAgICB1MzIg
cmdtaWlfcnhfdmFsOw0KPiA+ICB9Ow0KPiA+IA0KPiA+ICBzdHJ1Y3Qga3N6X2RldmljZSB7DQo+
ID4gLS0NCj4gPiAyLjM2LjENCj4gPiANCg==
