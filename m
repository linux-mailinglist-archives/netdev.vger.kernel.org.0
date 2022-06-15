Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFDE54C1FA
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244265AbiFOGgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiFOGgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:36:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219EC424A4;
        Tue, 14 Jun 2022 23:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655275000; x=1686811000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SjOe5NBnX0/UhDX7dByTMSSVlOVVsuarqaVRhnBai/Q=;
  b=BSFZTLbID2zQXTomCxDCxetxOU6dlRrCMgE0fWiiXNUW2uwCMt2z/hPr
   q4zDbXv7wUWfTLRcXuw1q+YimDgnlW4IOx3BfeFCExpfYRVLWekp6yCaz
   /ky+Fd2cqtNHQ4ZZVBknieFB2eLaxpSiiObu/qkx1pnXXPlCfM28JoJRi
   KpFpwkIMRTx69tsvfYb82KT9BeageCyiVEXESsczd0WYetysQlh/MnLR1
   stMlIbWW54xNB9CTOqtcIUzQ3KknWkVrv4h47KdJfbCamPmrOtp4Z+8DK
   L+AS5R+3HiwPExc3xDGkdd0EeH3PhsE6QrpC1mtm0fXtYVTIa/3aH33u0
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="178011740"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 23:36:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 23:36:39 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 14 Jun 2022 23:36:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaJ3NGb+dintroT2LpnFwoyw6ckAv4alalJlazqXLhhsbAQDuECpLj8NdiUh532/MYK6U3gWc+XzbxGrAJGPN8WaoZuZwalARwN6CgQYwC3KzXc9AFNhbYn3/lb8TeSKVkwz6MBW/N5jlHl+25P6kq/Cjzvp3JTcoogBdLk01GIYgrLzw8yVzQziYK/ohz/9t93/y+Ha6RT+kzLds9W3+vfcwIrRtd8jfavmAKSjpkJim3+M3Csh/vAnl+2M9DIoRpHKqHnHpIgy4BpbjveqzZKxJfT6Bc/KsRFU8SLB5uYpWD69J9Zmb4pYOfkJosLRcSuhwVUDTBgb1bYPA7sP+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjOe5NBnX0/UhDX7dByTMSSVlOVVsuarqaVRhnBai/Q=;
 b=iUZeQXCzA3DNIRA+LyzngWLoStmS7bxKLOBLtsUTcgqqyqVXR+JGNQkhgUdNZI0QxwMzRH88X/BEFnvu4G0gVF0Yxnpj3NtJppwrKzJebf7v0stgGeOEwlEu+4xXgg9ZcrzCZxeeTmkEp9IML79yQ3vS6g+SitzxdFJl6acRi5whxAczODR/OjDDjStiO0eBGhJRlQ8LBDcQFPKBniuxhpzMKKtSD5TrYZY68eVH9yR/w6oY4I3UAcrLmGVkkmTmvBB2rHvqwNOMrA6/nTorrQ2SqzsFX9wRgoXIDxdB8G2A60qxSIzfzMKOVhrBj8s0Q9xM910w+zoPdT474ohQDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjOe5NBnX0/UhDX7dByTMSSVlOVVsuarqaVRhnBai/Q=;
 b=tDfA5gIfFnYOWs67SI26g79UkbD7fog43aE7KU+TLAGsK6qF80+l0vtAsvz9oLfQL/fujJPuFo93SpCZML7/0gZBHhfXWpfvU7HeEd6Tqpu72OPT4WTEwX7mZHCJG6lWltiFgCRQdZ/gKrvLiaJBySp7tumfcCaSjtxdeIQ70dk=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM6PR11MB3228.namprd11.prod.outlook.com (2603:10b6:5:5a::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.13; Wed, 15 Jun 2022 06:36:37 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5332.020; Wed, 15 Jun 2022
 06:36:37 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 03/15] net: dsa: microchip: move
 tag_protocol & phy read/write to ksz_common
Thread-Topic: [RFC Patch net-next v2 03/15] net: dsa: microchip: move
 tag_protocol & phy read/write to ksz_common
Thread-Index: AQHYdBI1k7NiadCXsU2lS51ytiTT361NJikAgAL2PwA=
Date:   Wed, 15 Jun 2022 06:36:37 +0000
Message-ID: <cb39cfd69441955a40a0b9cd08b2595771cca5cf.camel@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
         <20220530104257.21485-4-arun.ramadoss@microchip.com>
         <20220613092250.jx6fonocr6pudppn@skbuf>
In-Reply-To: <20220613092250.jx6fonocr6pudppn@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cc832bd-4a2a-415a-3e7c-08da4e9965f1
x-ms-traffictypediagnostic: DM6PR11MB3228:EE_
x-microsoft-antispam-prvs: <DM6PR11MB3228B0B48CDE7A3D157D1199EFAD9@DM6PR11MB3228.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ISrjKZzGEmA5MMiNDa+x/dGmNmNrwR+SIrLzCusL3CVNdmC3c4Ee2XXDwQYJ1oJOhbhZOaGNq+f32xaJyb6p/L82Iws+CAXemT6pZx6eWY7faLMvsHiGANJS9lIq4LnA1tdooyW8HaW+qYugckLExRVEW6I8ZkrFqTcBdmaAcueKiH5j+dzFUg2+AVzF1xecavXuqmSywTDBTl3zd/GZ4Ue2vLar7yF67kG3Vp0t49l8FKCeM/msfBrakxiAmcw2xfUzFSZNr/haiuqn8gDAIFJjIQN9kexEG27xas1rCNMMy41iSKd4ArlSWEWqKicKx8mwxvmNeeWGOT4nw+wuip/ZrukzpQ0gjIWreFs+awjOvPEH0u9I+wUfn/3zX2UYW1L9YFC2v5e721FgYjam3DTm5rm6hbz4O0pqIl/jpAM1ixSK9BDCgHvEJr8nY3TTnpsDvXhW9mPnPICVkvy4rl5IRmTRlgrzWIHgOxBdmSx6xNWueGnKNBHIBxCRzpfZyhaEq+yHHZYmf5Of/6JMdRkpXRHFfBPz+GKIG/UhAXUvA7PZzXQLQJ1/9SEeHbHUeQQa8sPnq5eeB9bYDmtJQcUAAs+ci/hSoKqOUJXhxtlSK8roDMjbzf/aaVzN+XzNWpnDqKWJSv4Fq4juUxwJT7tC+nZTuK++Lsu4a94/NfasCZlnBULYMBaLwn0KxwuyI4/uHnjchzdGaUUWxcz/359fQiCBTXs8QdGFYtmRHM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66556008)(5660300002)(8676002)(66476007)(4326008)(38100700002)(36756003)(66946007)(316002)(6916009)(8936002)(54906003)(76116006)(83380400001)(66446008)(64756008)(7416002)(71200400001)(2906002)(6486002)(508600001)(91956017)(122000001)(6512007)(26005)(86362001)(2616005)(186003)(6506007)(38070700005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WThOcGpoUFk3Z29Ud29MTzZ0MFk5UHZjckdnKzhCWGN6eGFOMmJIcEZUaXVa?=
 =?utf-8?B?dGtxVko2N2lBQmtrUnMvRXlQSzgwMzhwNnU5dnFxZWNENGlYNDN1NDRGQitQ?=
 =?utf-8?B?MzJaVVpwVUFrUC9wdXJMY3pwK1g1cU9sZDlTdTlGY1BZMUxTT1VUMkxRelZJ?=
 =?utf-8?B?dDkycnYxb2F3VHU1cStNR2YvbVl3c1hZNnBYZG1kUm02UTNGcEN6RldxSjFa?=
 =?utf-8?B?SFkvVnJKdkx5MzZXaHJNQ01HZmJwOWQyWVB2ZlNRdndPSEthMTc5OWRPVk9w?=
 =?utf-8?B?UDRKUVFqaXJpckZDY0NhTGlneFpYUHhrSFI2T3czRFYvZDhncGZoTlBwWGJX?=
 =?utf-8?B?QTltZlo5MlQ1blhhSlN3MU5qNXM5eXg0VGl3dEgzSUgybXNDN0NCTjlqMlBj?=
 =?utf-8?B?OHBSQmZkblUyTXpkcHptNDZ6RW93eVVBNVIwaVQ4Tk1xQ3ZGcWl6ZHlwR1lG?=
 =?utf-8?B?WUZqaDBhcXlGMUFCUVNRSjltWCtmRktqeTkyS1RVUExVeW01TFdnWHhwNC90?=
 =?utf-8?B?MXdZK0ZneWVkVG50U3grSDFvU0NTWk5YL3BJckdDQjJTMlhlWStCbW5BMTRB?=
 =?utf-8?B?bVZWNTBDVm0zcFUyTVREQ2o3cklxWTFPZDBROEx3cTZxQlhXNTZQZzFCNTdl?=
 =?utf-8?B?QktSQ2h5akRqemZmRGJCY3ppZCtwKzltYUNDUzd4M1BxSkcrZjhiVWwwangx?=
 =?utf-8?B?RE5LUnVJam42NTdKUzhzL2Q2ZzB0OERzWFJxQVllTnlneXhteXpUUE8wMEhv?=
 =?utf-8?B?blhCZ2Vic0VkaG4vNE43TnVkaUFVVnUxTXJRbTM5dVkxWHIrV3BVdUtENFJu?=
 =?utf-8?B?dGZKNENDT1lwU2V5ZXkzdnM5cTZQOXNtcmhIaVJvcG1nbEpHUFBJNHlvZ1dX?=
 =?utf-8?B?VkhxeVRGL2xjVXZ2MUtjbkUwRWRaU2ZrZk9VYlNraDFRRDdvbXUrWGFrb0FC?=
 =?utf-8?B?UFA2TEd3anVLU2VJdXpndlhGdUs4QkhXTGpuSTNHSFBLVkd1Q3dDSVNXRi9Y?=
 =?utf-8?B?Unh2b0F6aUE4Y2dQTzQyK1UxZ0hYMjdCWWZiZ3pBTi9BMG1ncE1iZ3lrWFNx?=
 =?utf-8?B?cHJManJUSis3a3ZXNjVYTjJ0Vm9MQTlUVTB5TnZkN0o5QklYcWxQUnVxeGpt?=
 =?utf-8?B?alVNTGdNWW1OTWN0cm9PMzJDQ2t1Q2RhbVYyUDR4YVhnVDVDNlc1dUNDMVpJ?=
 =?utf-8?B?M2l3cWZ3SzVaT2k1UlJUeTRxOU0xVUpsbytWMC9MRW1JZDdOckRuMHV5OHlD?=
 =?utf-8?B?eHBaeCtTcEd6RGQzZGNVK1ArT1hNZ0xjbFBuMEhFSzRUa083b3FRWURkZWFv?=
 =?utf-8?B?QlBxbm9SMHlqWlVPUE9aakI2K3hQRUhqS0xBRnUzd0JUSmNXYlpRaUpyZ2ly?=
 =?utf-8?B?cHd2V2Q4cXVMRGNuQ1g3UkhKN1NPMXdpZitDNHdabGV4dTB6RGMzVFp2RDc0?=
 =?utf-8?B?T283MkhadU05OUljWFErWEdlZnZ3OHdlQzRRUElPK3dOa25URWZvam0rdnlD?=
 =?utf-8?B?WURWelB0cTFROHYvdlZhbjA3aHdmMWpIcExpblN2TkRJQ21GVUVRVGkvdGRo?=
 =?utf-8?B?Y1Q3TldqRGlDbStzamhoczMrdFN6ZU1rUXV3T3grbUlnUzNRMDNwaE9Sb0FU?=
 =?utf-8?B?dnBnODQ2V1R3S1MveDZpVTNac3I0MnJPUmh2TTl5WXhGWWo4UTNMQ2tDR0t0?=
 =?utf-8?B?bXdUK05UbktNM2VMRlZBVldqYkp4VS9TaitaSkRVZ2tNYVdpTlRPOGZmdDRa?=
 =?utf-8?B?ZXdQVzlVdVEvcDhBVEhZRWRlK1FTSGMxZ3RQVk5HVHBjSklIa3NNSUZuTktZ?=
 =?utf-8?B?QmxOSGhPeEJnQlJDNTJwUytmZWhuZVVzOU5MOWJXSUlyU20rWFFFUGFsdmRu?=
 =?utf-8?B?NHZnaHh4dmMyZlVWR1FLY0hJcE5TVlR2S20xRnp6VG81RzF6QkRyOEtsZUE2?=
 =?utf-8?B?ODZBRUJhRUxXZmJ6M1J6Qm9LU1VtM3FxdUJYaFRGWEdWRmQrbERMMml2djVx?=
 =?utf-8?B?S1lPMWNyOG16dTFQMmhUY2xkMkdnMmxtTnYwY0NIa1hUK0NQNjhPYVVKRGll?=
 =?utf-8?B?Y0JVdSt1OFE2YXh0WCtsV1J4a0pLejFYVmdDcWdnQ2F5VGg3dUxqSFdWSWVx?=
 =?utf-8?B?UllnYjRrdjFiN09kcGxPc2lVV0loYjJzYllic3pwV1BJRXZpbVRCZnA3WHoy?=
 =?utf-8?B?VGMzQndOUEJ0YWZrS05majJmemN3ckJVREpMTlRDM1Q4ZmN3aWhiR2Y5dEs4?=
 =?utf-8?B?SGJGVW0zVmtESGs5TkplUVY2NEp0dGc3dVpremNxbjZZN0k1Skd1SkJZQ0Ns?=
 =?utf-8?B?VWhqcnZSa1ZPTElzVExQazBMeUR4ei9xZlg4REVPUzNscjVYVkdsT0g4c3Va?=
 =?utf-8?Q?3NtiUQ9K7HjcIk7OAilqBFhRog9sf1Hhc5NwW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF8189E3D4A8184F8E74E44C89430A30@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc832bd-4a2a-415a-3e7c-08da4e9965f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 06:36:37.3305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o8YBaVkXqWGmSD/yMhZIMsUcoYDWXu60ttLSyk/zbc/B5/1ISs/PG8VNG6pPnPl/J3AYKlEN3rrnSG9miT8eu8WOCPN0dVB3InRW4L/bHJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3228
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA2LTEzIGF0IDEyOjIyICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBN
YXkgMzAsIDIwMjIgYXQgMDQ6MTI6NDVQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBUaGlzIHBhdGNoIG1vdmUgdGhlIGRzYSBob29rIGdldF90YWdfcHJvdG9jb2wgdG8ga3N6X2Nv
bW1vbiBmaWxlLg0KPiA+IEFuZA0KPiA+IHRoZSB0YWdfcHJvdG9jb2wgaXMgcmV0dXJuZWQgYmFz
ZWQgb24gdGhlIGRldi0+Y2hpcF9pZC4NCj4gPiBrc3o4Nzk1IGFuZCBrc3o5NDc3IGltcGxlbWVu
dGF0aW9uIG9uIHBoeSByZWFkL3dyaXRlIGhvb2tzIGFyZQ0KPiA+IGRpZmZlcmVudC4gVGhpcyBw
YXRjaCBtb2RpZmllcyB0aGUga3N6OTQ3NyBpbXBsZW1lbnRhdGlvbiBzYW1lIGFzDQo+ID4ga3N6
ODc5NSBieSB1cGRhdGluZyB0aGUga3N6OTQ3N19kZXZfb3BzIHN0cnVjdHVyZS4NCj4gPiANCj4g
PiBTaWduZWQtb2ZmLWJ5OiBBcnVuIFJhbWFkb3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5j
b20+DQo+ID4gLS0tDQo+IA0KPiBJdCB3b3VsZCBiZSBlYXNpZXIgdG8gcmV2aWV3IGlmIHlvdSB3
b3VsZCBzcGxpdCB0aGUNCj4gcGh5X3JlYWQvcGh5X3dyaXRlDQo+IGNoYW5nZSBmcm9tIHRoZSBn
ZXRfdGFnX3Byb3RvY29sIGNoYW5nZS4NCkluIHRoZSBSRkMgdjEsIHRoZXNlIHR3byBhcmUgaW4g
c2VwYXJhdGUgcGF0Y2guIEJ1dCBwYXRjaHdvcmsgZXJyb3JlZA0KbGlrZSBtYXhpbXVtIHBhdGNo
IGluIHRoZSBzZXJpZXMgc2hvdWxkIGJlIDE1LiBTbyBJIG1lcmdlZCB0aGVtIGludG8NCm9uZS4g
SXMgaXQgb2sgaWYgdGhlIHBhdGNoIHNpemUgaW5jcmVhc2VkIGJleW9uZCAxNSBvciBzaG91bGQg
SSBzcGxpdA0KdGhpcyBwYXRjaCBzZXJpZXMgaW50byB0d28uDQo+IA0KPiA+ICBkcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYyAgICB8IDEzICstLS0tLS0tLQ0KPiA+ICBkcml2ZXJz
L25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyAgICB8IDM3ICsrKysrKysrLS0tLS0tLS0tLS0t
DQo+ID4gLS0tLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5j
IHwgMjQgKysrKysrKysrKysrKysrKysNCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmggfCAgMiArKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDM4IGluc2VydGlvbnMo
KyksIDM4IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9k
c2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3o4Nzk1LmMNCj4gPiBpbmRleCA5MjdkYjU3ZDAyZGIuLjZlNWY2NjVmYTFmNiAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ID4gQEAgLTg5OCwxNyArODk4LDYg
QEAgc3RhdGljIHZvaWQga3N6OF93X3BoeShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LA0KPiA+IHUx
NiBwaHksIHUxNiByZWcsIHUxNiB2YWwpDQo+ID4gICAgICAgfQ0KPiA+ICB9DQo+ID4gDQo+ID4g
LXN0YXRpYyBlbnVtIGRzYV90YWdfcHJvdG9jb2wga3N6OF9nZXRfdGFnX3Byb3RvY29sKHN0cnVj
dA0KPiA+IGRzYV9zd2l0Y2ggKmRzLA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBpbnQgcG9ydCwNCj4gPiAtICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZW51bQ0KPiA+IGRzYV90YWdfcHJvdG9jb2wgbXAp
DQo+ID4gLXsNCj4gPiAtICAgICBzdHJ1Y3Qga3N6X2RldmljZSAqZGV2ID0gZHMtPnByaXY7DQo+
ID4gLQ0KPiA+IC0gICAgIC8qIGtzejg4eDMgdXNlcyB0aGUgc2FtZSB0YWcgc2NoZW1hIGFzIEtT
Wjk4OTMgKi8NCj4gPiAtICAgICByZXR1cm4ga3N6X2lzX2tzejg4eDMoZGV2KSA/DQo+ID4gLSAg
ICAgICAgICAgICBEU0FfVEFHX1BST1RPX0tTWjk4OTMgOiBEU0FfVEFHX1BST1RPX0tTWjg3OTU7
DQo+ID4gLX0NCj4gPiAtDQo+ID4gIHN0YXRpYyB1MzIga3N6OF9zd19nZXRfcGh5X2ZsYWdzKHN0
cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQpDQo+ID4gIHsNCj4gPiAgICAgICAvKiBTaWxp
Y29uIEVycmF0YSBTaGVldCAoRFM4MDAwMDgzMEEpOg0KPiA+IEBAIC0xMzk0LDcgKzEzODMsNyBA
QCBzdGF0aWMgdm9pZCBrc3o4X2dldF9jYXBzKHN0cnVjdCBkc2Ffc3dpdGNoDQo+ID4gKmRzLCBp
bnQgcG9ydCwNCj4gPiAgfQ0KPiA+IA0KPiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGRzYV9zd2l0
Y2hfb3BzIGtzejhfc3dpdGNoX29wcyA9IHsNCj4gPiAtICAgICAuZ2V0X3RhZ19wcm90b2NvbCAg
ICAgICA9IGtzejhfZ2V0X3RhZ19wcm90b2NvbCwNCj4gPiArICAgICAuZ2V0X3RhZ19wcm90b2Nv
bCAgICAgICA9IGtzel9nZXRfdGFnX3Byb3RvY29sLA0KPiA+ICAgICAgIC5nZXRfcGh5X2ZsYWdz
ICAgICAgICAgID0ga3N6OF9zd19nZXRfcGh5X2ZsYWdzLA0KPiA+ICAgICAgIC5zZXR1cCAgICAg
ICAgICAgICAgICAgID0ga3N6OF9zZXR1cCwNCj4gPiAgICAgICAucGh5X3JlYWQgICAgICAgICAg
ICAgICA9IGtzel9waHlfcmVhZDE2LA0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3pfY29tbW9uLmMNCj4gPiBpbmRleCA5MDU3Y2RiNTk3MWMuLmE0M2IwMWMyZTY3ZiAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gQEAg
LTkzMCw2ICs5MzAsMzAgQEAgdm9pZCBrc3pfcG9ydF9zdHBfc3RhdGVfc2V0KHN0cnVjdCBkc2Ff
c3dpdGNoDQo+ID4gKmRzLCBpbnQgcG9ydCwNCj4gPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwo
a3N6X3BvcnRfc3RwX3N0YXRlX3NldCk7DQo+ID4gDQo+ID4gK2VudW0gZHNhX3RhZ19wcm90b2Nv
bCBrc3pfZ2V0X3RhZ19wcm90b2NvbChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgcG9ydCwgZW51bQ0KPiA+IGRz
YV90YWdfcHJvdG9jb2wgbXApDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3Qga3N6X2RldmljZSAq
ZGV2ID0gZHMtPnByaXY7DQo+ID4gKyAgICAgZW51bSBkc2FfdGFnX3Byb3RvY29sIHByb3RvOw0K
PiANCj4gUGxlYXNlIGNob29zZSBhIGRlZmF1bHQgdmFsdWUgaW4gY2FzZSB0aGUgZGV2LT5jaGlw
X2lkIGRvZXMgbm90IHRha2UNCj4gYW55DQo+IG9mIHRoZSBicmFuY2hlcywgb3IgYXQgbGVhc3Qg
ZG8gc29tZXRoaW5nIHRvIG5vdCByZXR1cm4gdW5pbml0aWFsaXplZA0KPiB2YXJpYWJsZXMgZnJv
bSB0aGUgc3RhY2suDQoNCk9rLiBJIHdpbGwgdXBkYXRlIHRoZSBkZWZhdWx0IHZhbHVlLiANCg0K
PiA+ICsNCj4gPiArICAgICBpZiAoZGV2LT5jaGlwX2lkID09IEtTWjg3OTVfQ0hJUF9JRCB8fA0K
PiA+ICsgICAgICAgICBkZXYtPmNoaXBfaWQgPT0gS1NaODc5NF9DSElQX0lEIHx8DQo+ID4gKyAg
ICAgICAgIGRldi0+Y2hpcF9pZCA9PSBLU1o4NzY1X0NISVBfSUQpDQo+ID4gKyAgICAgICAgICAg
ICBwcm90byA9IERTQV9UQUdfUFJPVE9fS1NaODc5NTsNCj4gPiArDQo+ID4gKyAgICAgaWYgKGRl
di0+Y2hpcF9pZCA9PSBLU1o4ODMwX0NISVBfSUQgfHwNCj4gPiArICAgICAgICAgZGV2LT5jaGlw
X2lkID09IEtTWjk4OTNfQ0hJUF9JRCkNCj4gPiArICAgICAgICAgICAgIHByb3RvID0gRFNBX1RB
R19QUk9UT19LU1o5ODkzOw0KPiA+ICsNCj4gPiArICAgICBpZiAoZGV2LT5jaGlwX2lkID09IEtT
Wjk0NzdfQ0hJUF9JRCB8fA0KPiA+ICsgICAgICAgICBkZXYtPmNoaXBfaWQgPT0gS1NaOTg5N19D
SElQX0lEIHx8DQo+ID4gKyAgICAgICAgIGRldi0+Y2hpcF9pZCA9PSBLU1o5NTY3X0NISVBfSUQp
DQo+ID4gKyAgICAgICAgICAgICBwcm90byA9IERTQV9UQUdfUFJPVE9fS1NaOTQ3NzsNCj4gPiAr
DQo+ID4gKyAgICAgcmV0dXJuIHByb3RvOw0KPiA+ICt9DQo+ID4gK0VYUE9SVF9TWU1CT0xfR1BM
KGtzel9nZXRfdGFnX3Byb3RvY29sKTsNCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQga3N6X3N3aXRj
aF9kZXRlY3Qoc3RydWN0IGtzel9kZXZpY2UgKmRldikNCj4gPiAgew0KPiA+ICAgICAgIHU4IGlk
MSwgaWQyOw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9j
b21tb24uaA0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4g
PiBpbmRleCBkMTZjMDk1Y2RlZmIuLmYyNTNmM2YyMjM4NiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gQEAgLTIzMSw2ICsyMzEsOCBAQCBpbnQg
a3N6X3BvcnRfbWRiX2RlbChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludA0KPiA+IHBvcnQsDQo+
ID4gIGludCBrc3pfZW5hYmxlX3BvcnQoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwg
c3RydWN0DQo+ID4gcGh5X2RldmljZSAqcGh5KTsNCj4gPiAgdm9pZCBrc3pfZ2V0X3N0cmluZ3Mo
c3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gPiAgICAgICAgICAgICAgICAgICAg
dTMyIHN0cmluZ3NldCwgdWludDhfdCAqYnVmKTsNCj4gPiArZW51bSBkc2FfdGFnX3Byb3RvY29s
IGtzel9nZXRfdGFnX3Byb3RvY29sKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBwb3J0LCBlbnVtDQo+ID4gZHNh
X3RhZ19wcm90b2NvbCBtcCk7DQo+ID4gDQo+ID4gIC8qIENvbW1vbiByZWdpc3RlciBhY2Nlc3Mg
ZnVuY3Rpb25zICovDQo+ID4gDQo+ID4gLS0NCj4gPiAyLjM2LjENCj4gPiANCj4gDQo+IA0K
