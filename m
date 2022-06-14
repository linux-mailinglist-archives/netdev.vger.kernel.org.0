Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181FD54A8DE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiFNFrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiFNFrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:47:51 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B253D2E9C9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 22:47:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIf47SQQJ3VI7l6mo9YuGySAuunXsUeTwWO5OMlI+ySe+MEE8hA5Tps+7KKWxielxrfYBTVBx8ZXp1nMupo2hDSStVguW0zdKdiy1WpNQUfJ/kpffuqE7su0+/o16REE1NIPhGlaJIWpWJaBx4CVWN0CPI7ivsBAamtNZqZxVCiySq4meqTvRd6LNoO2pELCnHj2TQeQxTJb3Rpr/KDYehpMfNCVBqg0CUW1/qlySXVMsTgFLOkNz9ErCTp+I2H2XYxUC5zKsOWZPrImalmD7/4JBqG0GpB52REC+AV0qHzcFCH1ao7oAoUVBhOQ6hS5i/6AUBz8ByfeVLqfXt/ZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=takR7k5Q9fUox+8qYv7W+/0wXzrmZn40qim7dnWh9po=;
 b=D3r6QHhegbMQrIq7ngggoz0ncHYfrZuKYYHKD5476m1/AKHtr/NKaL77N/4rmDuk143SSipXHPFxdsmo4n93tKvZT3b8KWDdMh1Cn86cAKjK2XxspUdsHmFpXWNscPNBONWmVrPUun5LF9WBcdEkKsle5XQfBLOVhD45ay16IettF6pU4y9C2bNvow94jj9pf8y6uXufBV4+J5oeCQ7/wubCkWmL2yo6P2m9Kv48cTp2gDsuGiBw9Y06cHM1QIGkI4Orcc/4Bm9s6QQ/U2DLtrDKeF0KcM0OeqbO7e3UwEtMjApYJ8z3MAshxTu46IgqH0l39l5VF0Z1Z1pCbNdBpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=takR7k5Q9fUox+8qYv7W+/0wXzrmZn40qim7dnWh9po=;
 b=nZdCSGsL0ob5zgtL88uFuTqBXNtfQ4C2slznZQy3o1ZWU6KgebM+XkCaATNdCWWM7QoDvRTn2c/fCpItFu7Y7iE75CHhid5ZxQe5CHypsmCs5pInUMb0qk1nbhpgq8HTBCFWx9/Eex9xwH5BRmL+Rsebbdp/p4QfiT5ymR7FTyU=
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BLAPR03MB5377.namprd03.prod.outlook.com (2603:10b6:208:285::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Tue, 14 Jun
 2022 05:47:47 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%5]) with mapi id 15.20.5332.013; Tue, 14 Jun 2022
 05:47:47 +0000
From:   Lukasz Spintzyk <Lukasz.Spintzyk@synaptics.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     PPD-POSIX <PPD-POSIX@synaptics.com>
Subject: RE: [PATCH 2/2] net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm module
 parameters
Thread-Topic: [PATCH 2/2] net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm
 module parameters
Thread-Index: AQHYfvwGB+WKsheLIUCrO3aRJ5CLD61NbPCAgAD056A=
Date:   Tue, 14 Jun 2022 05:47:47 +0000
Message-ID: <SJ0PR03MB6533EB9ECD41DDA3B87FC371E1AA9@SJ0PR03MB6533.namprd03.prod.outlook.com>
References: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
 <20220613080235.15724-3-lukasz.spintzyk@synaptics.com>
 <99a069df-6146-a85c-5fed-acffc4c4d2d3@suse.com>
In-Reply-To: <99a069df-6146-a85c-5fed-acffc4c4d2d3@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbHNwaW50enlrXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctODFiOTY3NmUtZWJhNS0xMWVjLTk4M2MtYjAzNTlmZmI1ZjUzXGFtZS10ZXN0XDgxYjk2NzcwLWViYTUtMTFlYy05ODNjLWIwMzU5ZmZiNWY1M2JvZHkudHh0IiBzej0iMTMyNCIgdD0iMTMyOTk2NTkyNjQ2MDc1MzQ1IiBoPSJGb0tHWDRkVFhhNkt0dnFrWEJHODh4RkdRV2c9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69851b43-a322-49cb-0faf-08da4dc96907
x-ms-traffictypediagnostic: BLAPR03MB5377:EE_
x-microsoft-antispam-prvs: <BLAPR03MB53771E38CCEA75EE683E18EDE1AA9@BLAPR03MB5377.namprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cczv94YGzw9rbEl1SNsjbHxHqtsaEC0o9vZixh7Zekpqhe6PP9/twlFtaHhY+stbrOWxiDfefLgT638Kj/b4LI2RTcuIoSouR0Z8a/D3ekjwGJXdZHYadms9anpbvy8603k82fFca42ODq978KRVYN5sV71jNdEh+G1zXrT9vxaipT9jCTNAYjveUPafDb0ZjK5zVhmFiZGiY4ZzKg419/ugdznUY7lYf0EvP7GIiirsgjUs+2hLzOz0BV6WBtBnPI6NE3sVAZkLfpoTrombsyOJxyqqd3s8iCGtBf8Eg36kjYQukMn+n3DuE2UDDOYn15JFYj3t3VcBGdwfqN1qRdQbyo0EhoGvx0ue/IcO5vTUbbTRVWvBrhL08ND4G3EC8bt4AHUraY1mPxIreKwRIi6vXpVpO8PAARGOzzHx7XD3CgjQOurmDKfWIk7nQ/fRo68GpvBGQgmkOVURO6YeM6DKmwXtzyvWzIO/6w7+nsBskHgpEOvOb8uT6X5SKTFih8R3cf3H5kJc9I8ZHTr6vRujp2qRNTa99YpMMOKZIF5pFK33A+USLzD+vbU/Iu3BF3eRHVUCenW1UmyEEbKbBI7lTnue2cBGJQCrRoV0v5gi1t7Spp9lr5DKKK4SxP1H6yCVR9/Jc4vRy5Jir6BWwQb4jYMa2fAi0h36prroKd99c19v0Vua2dq66/MBjnO8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(76116006)(64756008)(66946007)(66556008)(66446008)(4326008)(8676002)(110136005)(2906002)(316002)(38100700002)(86362001)(66476007)(122000001)(7696005)(6506007)(53546011)(9686003)(55016003)(26005)(186003)(33656002)(8936002)(52536014)(83380400001)(508600001)(71200400001)(5660300002)(107886003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1JNUGJ5aEtDUHpNbGVHY3FXb3p6RUFaS3F5VGcxQk12WVNUbHJWSzNMekt2?=
 =?utf-8?B?SFBTS2tFTXFZcUl6TlJKN1ZHdThiVlFMZ2ttckF0WUpQb3cvY3FBT3RFaWdt?=
 =?utf-8?B?cmpVYWQzYzVqYUk4eFBrY0FVRFo2QzdPR1JtNEgwZytFUER1Ty9tRTZtdGxO?=
 =?utf-8?B?SFVwOWttZUM5NUhIR1NZbldRQmh0LzJhOGQ0dlNWd3pjVHdJVkVONzhLVklw?=
 =?utf-8?B?bDcvZEdRRklJZXE1V0lzUDI4c0tlVEN2dGJuYzJ1QlFTQ2lUTTBYaUxDcnNu?=
 =?utf-8?B?RHN5dENzbERiL2NGZTNDOHlDaFVicjdqbkRNR0Fmd0RMRFhveER4bWk3OUcx?=
 =?utf-8?B?M1BvMExPWFc4MnYyZWMvN0NEOC9WWHJSQjZGRHAyRTZEOWQ2Tlk5MHZrSnpo?=
 =?utf-8?B?U2NGRUVPeXhTVmlIRXRYandjSkhGejhGSy9sVFVTU2I0YXlRdGJXczNOcmlo?=
 =?utf-8?B?TE5ZWU1sbjVBWGFNT0FBcDVWazFxOGY4R21aRkZFRTR4SEdWNVlxdExIakRr?=
 =?utf-8?B?NHRkRTFNWjc3U2tzbnVnRDFiY2pERWVSTHMrSFo0SGpYQ2NLUFpGVmMyM3Zi?=
 =?utf-8?B?d0Y4WmdEUnI0RjlGYlU2SDZsY3MxQXpEbjc1dU50WHVJczVJNDFjc1p0Q1Yz?=
 =?utf-8?B?QWZUQysxRDViV0VaUC9pR0NSNzRyK2ZjaGYvWjY4NWtZZStjdnFBamhSMHVw?=
 =?utf-8?B?U2VkVld2STlTRzVJMUFWdGgrYjZ5ZTM4dURXc2NSKzN4cVMxUEZYemk3WGtT?=
 =?utf-8?B?OE9TL3V6V0YxZTYwL0lIc2VWWlRuLzdrMVpDWWxYRUxpWGhXN0ZiaHlmY081?=
 =?utf-8?B?Wk1LbW15UmtUWVc1SExzM0RBSHB4ZXdiUDJrTno1bnI5NkxCQksreWZpcnFj?=
 =?utf-8?B?d2JGempHZmVjczlQeTVUM2ZUaTdHNEMvdlJtclJuWGtDUElKL2xlMUd2MThC?=
 =?utf-8?B?ZjJKSGpBaXVZMjFSM0tLR2Q3QkxiVjAxUDViamRYdDlKcVQ0NEJESnhDYXhV?=
 =?utf-8?B?SDlZajY1Vis0V3BPSXVoU0xqaFJTQ1l1cmxVKy9TOWIxNlRINlVURVhhSlZ0?=
 =?utf-8?B?YUZVWXpSUURyYStYdW1zTk1HOE43L2laZXFZcGlVYzQ4bE1MdUhEdzQ1Njcx?=
 =?utf-8?B?U1R0Q1hBR29JcWpaamF4bC83d0tHbjUzejFqTkVBc3dYWGljZjA2eWo3eklB?=
 =?utf-8?B?NjEzWmp2YW1pdXdYVVdySnZyMVRKa1VnSmhPUVJXeER3bzZJUlRCL1NBTmt1?=
 =?utf-8?B?U2xsbjhaTm9oVDB6ZjdQemJ4Tm9KUDVZbXg0NHhyampFeS9TTkFQYVFrcDVE?=
 =?utf-8?B?NmtsRVBoYXJwZVA5N0FQbXBFeHZaTzhiRDB3NnFGckk5L2U5T0RYV3pQTklq?=
 =?utf-8?B?K1h2NHROMDkxMk5yM1Z0OFZRdXB3TWN2dnYyZDRObUhvKzFiTjlLTmc4TlFU?=
 =?utf-8?B?V0VBR2RtS2c1Zk5DWlE1eklIY0cvbURWU1BTUk0zaHVZQ0kxUGVERlVtWTFG?=
 =?utf-8?B?M01yNGQyZXEwVHlhU3dYcUZja0ZDVnhsRTRrV2pFOVdLaXFuYnZVamp0THJv?=
 =?utf-8?B?ZkdaWE5KajBCUHRueHhSa2M5ZTkzNFREMjBTdjBrQS9QSmdrUzdUS2pQSmlQ?=
 =?utf-8?B?RnZzd0szOVBrdWdvSERZRTV3d2Z2Qjc5b3ZTYnY2K2RLVi8xZE53Q0JCZWhu?=
 =?utf-8?B?NE1SS3hPRTAwMnRBU2txSzJ0ZkNibjc0MjJJUitxeVhpekpVZ2pEOUpSZFpN?=
 =?utf-8?B?TFF4YkdsSkk0aFBwRUhTOUpFYllwcVkvcEwzbGI5U2RhbFJVcmtmU2Rjbkha?=
 =?utf-8?B?dGN6RGtNckhFU21TbS9BOEhibU4ycGpSemhvSTJoOWxnUUlFeTBFMHBsSDRl?=
 =?utf-8?B?d01MYlhWZmNmZ2tHQ3FUUHZIeEI2UGsycXVBdGxNTnhuWU9UbkxDZnM3MUhn?=
 =?utf-8?B?QnRFVDRnTjRNZjBVNXU0YTdiOVhyVXVZSVFJNHJ0Y282a3FvUGdqTXZDR2hD?=
 =?utf-8?B?bWJEUkhGNUVFZDVTc3hBVWRWcTJVekEwZ09nZXFGanRnZTUyZUo2YjYzdElG?=
 =?utf-8?B?eWxXVzNMZUt5NWRZSlhpUEsxNHhJMjdYbXRiTmFDNEcwZnV6bENCKzVpcTBs?=
 =?utf-8?B?N3hKdC9KOFAydmkwam1CNmFqOUN0NHhPYzBuQmRnY3Q5OUFtaWNKRmF1TUV2?=
 =?utf-8?B?Q1U5VnZOa1hMK0ZyY010MTlXOHo1a1hMMERlakdLYjVqNTk1UzdPNUJLc3NI?=
 =?utf-8?B?ZVNlbmwwZHpUZ2d6NG9OWVgrZm1Zd3JjRGVsc2VDZGIxRTR5M0NRbFI5TzVQ?=
 =?utf-8?B?TzBoZEt5QWRuZm1yTlJSSGR4NlNWbGV6eXp2WGFGMU9aMzZnTWx4Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69851b43-a322-49cb-0faf-08da4dc96907
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 05:47:47.1557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IMMm1yq9WFIIiG3pDPVGxjsJv58uGhPezNR0FZubrXnv7aMBAmvqCVs5Y9LC8YI5IUoi8OSOUb3RgFk/jTZ9Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR03MB5377
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBJcyB0cnVlLCANClNvbWUgb2YgU3luYXB0aWNzIFVTQiBldGggZGV2aWNlcyByZXF1aXJl
IHZhbHVlcyBvZiBUWCBhbmQgUlggTlRCIHNpemUgaGlnaGVyIHRoZW4gMzJrYiBhbmQgdGhpcyBp
cyBtb3JlIHRoZW4gQ0RDX05DTV9OVEJfTUFYX1NJWkVfVFgvUlgNCkkgd2FudGVkIHRvIGJlIGNh
cmVmdWwgYW4gbm90IGluY3JlYXNlIGxpbWl0IG9mIE5UQiBzaXplIGZvciBhbGwgZGV2aWNlcy4g
IEJ1dCBpdCB3b3VsZCBhbHNvIGJ5IG9rIHRvIG1lIGlmIHdlIGNvdWxkIGluY3JlYXNlIENEQ19O
Q01fTlRCX01BWF9TSVpFX1RYL1JYIHRvIDY0a2IuDQoNClJlZ2FyZHMNCkx1a2Fzeg0KDQoNCi0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1
c2UuY29tPiANClNlbnQ6IE1vbmRheSwgSnVuZSAxMywgMjAyMiA0OjU0IFBNDQpUbzogTHVrYXN6
IFNwaW50enlrIDxMdWthc3ouU3BpbnR6eWtAc3luYXB0aWNzLmNvbT47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCkNjOiBQUEQtUE9TSVggPFBQRC1QT1NJWEBzeW5hcHRpY3MuY29tPg0KU3ViamVj
dDogUmU6IFtQQVRDSCAyLzJdIG5ldC9jZGNfbmNtOiBBZGQgbnRiX21heF9yeCxudGJfbWF4X3R4
IGNkY19uY20gbW9kdWxlIHBhcmFtZXRlcnMNCg0KQ0FVVElPTjogRW1haWwgb3JpZ2luYXRlZCBl
eHRlcm5hbGx5LCBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IHJlY29nbml6ZSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUuDQoN
Cg0KT24gMTMuMDYuMjIgMTA6MDIsIMWBdWthc3ogU3BpbnR6eWsgd3JvdGU6DQo+IFRoaXMgY2hh
bmdlIGFsbG93cyB0byBvcHRpb25hbGx5IGFkanVzdCBtYXhpbXVtIFJYIGFuZCBUWCBOVEIgc2l6
ZSB0byANCj4gYmV0dGVyIG1hdGNoIHNwZWNpZmljIGRldmljZSBjYXBhYmlsaXRpZXMsIGxlYWRp
bmcgdG8gaGlnaGVyIA0KPiBhY2hpZXZhYmxlIEV0aGVybmV0IGJhbmR3aWR0aC4NCj4NCkhpLA0K
DQp0aGlzIGlzIGF3a3dhcmQgYSBwYXRjaC4gSWYgc29tZSBkZXZpY2VzIG5lZWQgYmlnZ2VyIGJ1
ZmZlcnMsIHRoZSBkcml2ZXIgc2hvdWxkIGdyb3cgaXRzIGJ1ZmZlcnMgZm9yIHRoZW0gd2l0aG91
dCBhZG1pbmlzdHJhdGl2ZSBpbnRlcnZlbnRpb24uDQoNCiAgICAgICAgUmVnYXJkcw0KICAgICAg
ICAgICAgICAgIE9saXZlcg0K
