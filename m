Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CC55169FF
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 06:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347902AbiEBEck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 00:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245082AbiEBEcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 00:32:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696551CB23
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 21:29:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbK7VmzGi/Fav/JbREMwjJ3MmOF5FhCdVToHwXJ3UlyYm7F9PMrkEh1gpQ/9c0VC8z7y0Gb+cy+b8dyyaYa01NJ5ho4IZAR7IkyISfL9pFpi+FGtsBt+3gmaEk5k8NOJ1dtaAj6T1RnbpsAQ+a+AiHX/Js3zR49AxavI2cDU0sNWZiMRZPp+JJfsQASbZclAFPAd01bSvzHuXUWVHc14/5rmppjYuctLvtekRNX74aS00feqw1HNeNJ0nZKXirzHHaeGet8a3g/YGmuQGdwcoCLu3navxvHAPbp8oVPCF/b/sge25LkZZTuo7bEY5BLOXCYDi/nUGBaJJJgZ1DcwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soQnKwPWT9DSbp9sYOdKb6PQnO+3Xs4Q6E2a1lem5fg=;
 b=AKzolxzGhxzobj9rdd6L3ZkcEFqmNiDNxXSZRUZWzcn1jBSd10F8RGby5KZYOH/nFa4f0mcWe/Sgd7ZuErAwNkx34gHF4L1Hmg6pVYIQK81pJlIdVDALnQezO/jWdAQFTB+YGbpeLuXXDLXWTZoO0upWfeyTkHU6eW4MsDImKFcGLmK+UuIVE3cfdbTv0fA5e6zmjH4KmfFFq3nCffVM5af+EqF5pqN5R5aD4xgMwvLxvssIs28koMWvFvj5QTGfu+L56I20K1jvgbr7XzypOnMZxlPWrEvOP/jN6WR/DQvAz3oR5pUsXRQf79FwLNUuRdufPVqGDAhNPoOmc4WS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soQnKwPWT9DSbp9sYOdKb6PQnO+3Xs4Q6E2a1lem5fg=;
 b=WT4CqQZX7y0CRPA97ZS7ZVW8sr7jSAZvGJTGjI8NvzKykSLccLeBS8C+nQbUo79Dymhn1Reuv09Vix1d/AfKkCZecbKKQk+91ZregeVI4M85IVcw/JB+7bu5LvAF5y7NsZxX34C1fT21br2iMVsMeIkiPzY83+TsG/OFxaMhygqu0VYjs0YY0OE7E2+ZMv/K+PXC1pP88PWRuMhAOyZngaqb8QrHvM5Mqmc1hvM+HB3i/liaDGSJR6x7S4IsZon9x5yFeroLkPQzYL0lAXc8+EE45ZJH/tqgiNTUCbbsg7mr2UfoCMg78HTC6ronV/nn8PtiIohVfa1lPaXrSJbZaQ==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 CY4PR12MB1687.namprd12.prod.outlook.com (2603:10b6:910:3::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Mon, 2 May 2022 04:29:10 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ec12:70ec:e591:ab6]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ec12:70ec:e591:ab6%4]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 04:29:10 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: utilizing multi queues of a net device
Thread-Topic: utilizing multi queues of a net device
Thread-Index: Adhd2w/i6AOjpZwuS9ujOEf6zHoz5w==
Date:   Mon, 2 May 2022 04:29:09 +0000
Message-ID: <DM8PR12MB5400B7E41EB88FF4C9E0F87AABC19@DM8PR12MB5400.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 195b8776-85a5-4280-54d3-08da2bf44d9b
x-ms-traffictypediagnostic: CY4PR12MB1687:EE_
x-microsoft-antispam-prvs: <CY4PR12MB1687B1A04BBA5B4819A5D288ABC19@CY4PR12MB1687.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +iWPTXtRCoZMmlrkf+jMr59cRmlaAAAk+5iHm5tCNowEAQDE0lu7JN/cdHOblQuVkuWo+dGvGYm14zWAqfJeYSJSvEtQ1LHiV/EexqwqBWaERvZdpxXSqBws5FGLC6vgwqhU6Jg5/rDTsriYgdTj/yaJ+WgCTNquZWW+FA10u0tawJglEXBuBDN1AzV/lZAPiYEKmNit6FSyxRahZDqcDOlTzdjbT6nRhlO9Ibv/qlvF0cWFX/ExVIVA2DeNppahOjxyNqLmFFEyzddBPjjgKj/ewezyRi1v4n4RhbUN+k9la3thyq5dCH6xCnmiHudprqIoP3wPN0Ve7F4vAJkhO1/uGI42loIF1zjMa2HdgFU2fFbGPibpD/vQX2o1xPVRLwG/ktP7lfdZrPImxF6W5Vqvkzyp1aSoFks2wtdOjuA1D3xCmix17e1ZrGPaYwSr/Hiwv5BTdHWJE4nA2kcZ6Myja9yTipR+Cwy3xwCC1av3Zj7bGDlrhuG0uGws7R1qG0mS1c4OtEVJ+Q0QO41h1EBtuXR4Bki6S8lC9+yYyeMibTWsywktts6LCEa1AqgPNHoWzRw1YMj4nj2FhG/iaBXEip8xKk7feWzhA8WkT5WFdv+oVxFxFb177aPi9amPJAq635dHdacNDIgXPShU+av5e5mqaRg79fEdUvo1G7gob2Z08kkjAsm6oGRtcRaIGiC5BkUqWX2v44jjE06V4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66476007)(316002)(55016003)(5660300002)(66556008)(7696005)(186003)(2906002)(66946007)(33656002)(52536014)(83380400001)(66446008)(64756008)(8676002)(8936002)(110136005)(86362001)(71200400001)(508600001)(38100700002)(38070700005)(26005)(122000001)(9686003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGl4Z0ZDK3ExUjRMNGJIVUtZT1lDSk0randycHh1ZVB1azNnOVJQbGRzTkYy?=
 =?utf-8?B?TDlwd2I2clI1SVFOWGZUWGxjUElGQkswNy9pRnFtUyt0RVRGektWZStBZGd3?=
 =?utf-8?B?VEpIdjNVSHNja3E1TDg4Q1IrUDhEWkN4b3EzMUh2eG16a2djajRKRXNDclk5?=
 =?utf-8?B?VlVpT2pUTERrTExDUVppMEVleGx0ay9kejQvZUFmZFZNYlY5MEVCaXA5RUlD?=
 =?utf-8?B?MVd2WjZhSEZaeDhoQmJsamV2T0lQbGl5aGxmOWpSREdqeXY4ZlpBUEEvZlVn?=
 =?utf-8?B?ai9BUi9Ha3orQlE5dVhJSTRKYThyS3NUWmhVb2dKTTUwQU1oUHA3Y241UDg1?=
 =?utf-8?B?bmFqcEZneC9FcGdGODFJZmUreFlnMDBrY3R0dXpXZDhOenJpSnF0TXU4NzZj?=
 =?utf-8?B?ZDM0Ri94a2pRdWpRcVVTdnFTdjY4dmZGa1RTd2NzUWtJaitFRTBqb3lXczgr?=
 =?utf-8?B?emlnbm1PZTAvUEt3dFozSEV3dGlMcUFZem1nMU85VGRLRzZUNWZjYnBkMFdk?=
 =?utf-8?B?Q2VZMXhJeWRVMEphYlNKL0V6N0ZBVUhEMHhqVlNxU2VlY3V0NG00ZGxyUVhG?=
 =?utf-8?B?bDZDL2RTbUJ2YnNjc2pXSE5YaGVXVzhxaW5ET0lGYnEyVDZuMlQ1aWhRSCtR?=
 =?utf-8?B?WEt5VGh1YnljYjVuK3ZlOElhTFNWaVBLUnBBSDFkSkpsRXM4SVZYTlkyRXdk?=
 =?utf-8?B?VDJneU15THpyN2JITDVFRG1GSmlJbEtuWDkybEY5RkZ1cVBYUmFlR2NEeHh4?=
 =?utf-8?B?VUo2SHB4S01hQndSVUpaVzJCUEZxS0ZESHRndkUxcldLWHNoSGtwMlVub01T?=
 =?utf-8?B?YnowMDFLSWpRQ2ZFMVJrdzRSd3NoVS9Ea1JiVXFCZThlbUxpSDBCRGl2SUN6?=
 =?utf-8?B?aEtWcVBBT1ZDSUcyekc0S0N1TmJ5Nk5wUG5wUUVpTFRwM0pUWVZtR0o2eFN0?=
 =?utf-8?B?NEVtc2ZkaVo3YTdpeDVtOWlBZHhsZjIxbHg2TWdRZ1l0LzI3N2Z5V0p6ZktM?=
 =?utf-8?B?Q2hPdlU5cjhzNjA3V1FwQ2NHc3hqYzB6d1ZiT3Q5aVZCN1JnTjAvYmVHQlFt?=
 =?utf-8?B?Ynl3Nkg0NlJkWkVJYVY3Mk5NYkNsL0pjc0ZIQWI4SGZYYTh0Y09ERjJsVisz?=
 =?utf-8?B?RVhuUXFyVDRvaHJkeHBFbFdUWkJFRFFqUFNTNjNpRCtBL1dWcURmWmU5TUdX?=
 =?utf-8?B?N0p2dEZDZExIaDRMalczREh5K3RVbFY4MWM3a2ZLQ2ZvYmJqWjFTUG4vMzVJ?=
 =?utf-8?B?cWFocHErOUNJSVhxNXd2SUFxZzFRRU1EZ1ZmL29SakpYdUtmWnB5R1I3amxy?=
 =?utf-8?B?ZTl2aU1CT2lheFFmejZ0ajBNM2NnbmloenRvM20xajdMQmlWM0lwWDRWbnVW?=
 =?utf-8?B?VnFNMWlJaHFBM28rR3lsRnRyaW11T2xnMWhMTHJwNkNKNG9FTDhqd3BETU1a?=
 =?utf-8?B?aDVIV3o4NVJNVHlMSVpZQ0tWeUM5Z2syWUVob3VlR21YVTVwd1JENk5tNnNi?=
 =?utf-8?B?dnc2bE92d2NrMDhJVFNrODRYeTFUekdNVStxelR0Rjg3cGhXSGFxMWZWK2tm?=
 =?utf-8?B?NGgzWmVmQ3lZTkE4bHZoL1RXNXBLQWkrSTBDb3RlditlS00vSXhpL1FJamFs?=
 =?utf-8?B?MGpzMVViQU5KUnZ5YlNHR2xzWVZiZGFtN2hHWmFqN2VPY29ncWk0VGNiMy93?=
 =?utf-8?B?QXBGbnFicmtYcm5yTnFCWUE1ajA2SVQ4Smo4SjlDMkR1TlUyRDRoYWNwb3FO?=
 =?utf-8?B?NzNXMENIMjZRNGRCT2Nnek4yVzA1MHA2L3JiNTFvRVA4SHd4eTBmZkxzZ3J4?=
 =?utf-8?B?K1ZVSWZ3TmFsMzk1d0NjQUFRMXUzWDNZV0h6RHNDQy9jSTNJbldKWWZ2Z0Vv?=
 =?utf-8?B?THR0WGhOc0ZLTmVHdCtLTGZlUW5ta2JjZ0dHU3N3eW8xT2VjTDZlV3JMWlZR?=
 =?utf-8?B?bWZIUDNwOCs2MFh5OVBUaFkyeWNtTUxuZnJTb1BYMWhta1VjbWxuTm55RVo2?=
 =?utf-8?B?dVFkVmJPT09hOU5hSWFFNk84SFlwTHNlT2xVdHM1QWErejhxMmJzcWpDNGtn?=
 =?utf-8?B?SGRIWE1oT09vTFgzRUJjVXJpYzNpUTNObWtSZ3Bsb3FJQjlWam03Q3MraHhM?=
 =?utf-8?B?UW5pZVFpcE8vUWpjSG5Ta29CUE9DcDd4ZGFxOTJkZHJLRVZBQkp0L2ZXaDla?=
 =?utf-8?B?TjVjd0gwcUNYWDZMaTVIVkxvdHhoZW9mOE13NnpZUUhBTmFseGo3RDNyTk9Z?=
 =?utf-8?B?aURBWFM3S1NVMHpQb3p0Ym9FNWRGL2ZHMjBVVVZudVNpQXZFRE9OT1R2bXAy?=
 =?utf-8?Q?U9toDwtDnSFHZZOXR3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195b8776-85a5-4280-54d3-08da2bf44d9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 04:29:10.0230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HLubHd9jWrbbE4G4EiL7CnpCtUH6T6X2n/xAlcW0kQO04T/ptMYWP/TVjyBDkMZh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1687
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLA0KDQpJIGFtIGV4cGVyaW1lbnRpbmcgd2l0aCB2aXJ0aW8gbmV0IGRldmljZSBydW5u
aW5nIG9uIGEgaG9zdC4gVGhlIG5ldCBkZXZpY2UgaGFzDQptdWx0aXBsZSBxdWV1ZXMgYW5kIEkg
YW0gdHJ5aW5nIHRvIG1lYXN1cmUgdGhlIHRocm91Z2hwdXQgd2hpbGUgdXRpbGl6aW5nIGFsbA0K
dGhlIHF1ZXVlcyBzaW11bHRhbmVvdXNseS4gSSBhbSBydW5uaW5nIGlwZXJmMyBsaWtlIHRoaXM6
DQoNCnRhc2tzZXQgMHgxIGlwZXJmMyAtYyA3LjcuNy4yNCAtcCAyMDAwMCAmIFwNCnRhc2tzZXQg
MHgyIGlwZXJmMyAtYyA3LjcuNy4yNCAtcCAyMDAwMSAmIFwNCi4uLg0KdGFza3NldCAweDgwIGlw
ZXJmMyAtYyA3LjcuNy4yNCAtcCAyMDAwNw0KDQpTZXJ2ZXIgaW5zdGFuY2VzIHdpdGggbWF0Y2hp
bmcgcG9ydHMgZXhpc3QuDQoNCkkgd2FzIGV4cGVjdGluZyB0cmFmZmljIHRvIGJlIGRpc3RyaWJ1
dGVkIG92ZXIgdGhlIGF2YWlsYWJsZSBzZW5kIHF1ZXVlcyBidXQNCnRoZSB2YXN0IG1ham9yaXR5
IGdvZXMgdG8gYSBzaW5nbGUgcXVldWUuIEkgZG8gc2VlIGEgZmV3IHBhY2tldHMgZ29pbmcgdG8g
b3RoZXINCnF1ZXVlcy4NCg0KSGVyZSdzIHdoYXQgdGMgcWRpc2Mgc2hvd3M6DQoNCnRjIHFkaXNj
IHNob3cgZGV2IGV0aDENCnFkaXNjIG1xIDA6IHJvb3QNCnFkaXNjIGZxX2NvZGVsIDA6IHBhcmVu
dCA6OCBsaW1pdCAxMDI0MHAgZmxvd3MgMTAyNCBxdWFudHVtIDE1MTQgdGFyZ2V0IDVtcyBpbnRl
cnZhbCAxMDBtcyBtZW1vcnlfbGltaXQgMzJNYiBlY24gZHJvcF9iYXRjaCA2NA0KcWRpc2MgZnFf
Y29kZWwgMDogcGFyZW50IDo3IGxpbWl0IDEwMjQwcCBmbG93cyAxMDI0IHF1YW50dW0gMTUxNCB0
YXJnZXQgNW1zIGludGVydmFsIDEwMG1zIG1lbW9yeV9saW1pdCAzMk1iIGVjbiBkcm9wX2JhdGNo
IDY0DQpxZGlzYyBmcV9jb2RlbCAwOiBwYXJlbnQgOjYgbGltaXQgMTAyNDBwIGZsb3dzIDEwMjQg
cXVhbnR1bSAxNTE0IHRhcmdldCA1bXMgaW50ZXJ2YWwgMTAwbXMgbWVtb3J5X2xpbWl0IDMyTWIg
ZWNuIGRyb3BfYmF0Y2ggNjQNCnFkaXNjIGZxX2NvZGVsIDA6IHBhcmVudCA6NSBsaW1pdCAxMDI0
MHAgZmxvd3MgMTAyNCBxdWFudHVtIDE1MTQgdGFyZ2V0IDVtcyBpbnRlcnZhbCAxMDBtcyBtZW1v
cnlfbGltaXQgMzJNYiBlY24gZHJvcF9iYXRjaCA2NA0KcWRpc2MgZnFfY29kZWwgMDogcGFyZW50
IDo0IGxpbWl0IDEwMjQwcCBmbG93cyAxMDI0IHF1YW50dW0gMTUxNCB0YXJnZXQgNW1zIGludGVy
dmFsIDEwMG1zIG1lbW9yeV9saW1pdCAzMk1iIGVjbiBkcm9wX2JhdGNoIDY0DQpxZGlzYyBmcV9j
b2RlbCAwOiBwYXJlbnQgOjMgbGltaXQgMTAyNDBwIGZsb3dzIDEwMjQgcXVhbnR1bSAxNTE0IHRh
cmdldCA1bXMgaW50ZXJ2YWwgMTAwbXMgbWVtb3J5X2xpbWl0IDMyTWIgZWNuIGRyb3BfYmF0Y2gg
NjQNCnFkaXNjIGZxX2NvZGVsIDA6IHBhcmVudCA6MiBsaW1pdCAxMDI0MHAgZmxvd3MgMTAyNCBx
dWFudHVtIDE1MTQgdGFyZ2V0IDVtcyBpbnRlcnZhbCAxMDBtcyBtZW1vcnlfbGltaXQgMzJNYiBl
Y24gZHJvcF9iYXRjaCA2NA0KcWRpc2MgZnFfY29kZWwgMDogcGFyZW50IDoxIGxpbWl0IDEwMjQw
cCBmbG93cyAxMDI0IHF1YW50dW0gMTUxNCB0YXJnZXQgNW1zIGludGVydmFsIDEwMG1zIG1lbW9y
eV9saW1pdCAzMk1iIGVjbiBkcm9wX2JhdGNoIDY0DQoNCkFueSBpZGVhPw0KDQo=
