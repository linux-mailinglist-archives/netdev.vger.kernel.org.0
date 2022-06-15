Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8681554D436
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346194AbiFOWGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 18:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbiFOWGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 18:06:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99B6563A3
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 15:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFBMO0Z9Dc32zx3nWhozIwBRtUF8JqDUOqU5px2/In3hvnEDWRNTQ2Crl0zOdudQEnWt2SG5wt+yodMDmVVzdsHcc+pfdJMlT8MsVlc02fASH5ozmrFRncx9E/BBgisnzSh30bpzvTOF7vauxjVhOvLYFS5jovcCgUTiIridnLzsKdqFXScTcISOnh9dsPG5e2YKjiTXrbpVeaYGV/ttzXjdjqJzt8GiJ9gxll5iszpChhSbTN+3igomY65orHGX06tRGQpUeNQ17Q+ul11tmshKzWOyRat8APHKbXb1wTXmLX6sQyB7Sh6dQ6DKOaHJZtlNB61fT2ib/ZrsZWjYGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QATCt0puhG5zQF6PACl0dX1c37s8DvSz5jo6qN1+0jw=;
 b=NilsAv3HxlWd69dc5smTDKxAMP1F9korDCsjOVyNm0i5yWpeOlEEAIQf4hYGbJYkYcHQOAXIuZVu09Ebb/v58vxMJnbJ2/WlxaVXmRJVp/80mdbLFE6mhOtIeZ0grFhPCDXgLzPaZzzJ4uBg4C/Eqc+VUQyl49QdYRsfuj/qlmPIoaFsUn32AvtFJbPlQKKue3BwU5zHFfahTMhToopH6RinXz5DCF0qzDkkSxhJqwHvCrabdhZKwAGZj9qFr1rGXLHSaxOhzm6AtxW1X5jforOAEA+elKrY8T+8yg2V6xdGRQ2XJvv1GRtR7PSKXBUbxhkaptl3Wx5lc/N6WzM44w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QATCt0puhG5zQF6PACl0dX1c37s8DvSz5jo6qN1+0jw=;
 b=C6tE6yRjufr6HnWBPxUVInTmx0p2kL29xPJnx1pLeXQtBC3agL4LVqn8FUMpXPW4nBSd8DolaDK0UdTu6oiRoJExswuUF/UFVPKGiivRAGkN4KJz4hXUBKtkGg5OBl7ROaTePZAig6stRBpqlarfTqY3d3qWWP/DMxx/AvHz+Qb0/gB1FVOSVQ8wZzf+OLGSjyr52mw/7W/Jw3uUp6WUKvqvSdm/DI2HKFDtdtHJubpBM8T+OtWmziZRBizsuwrIoUZjVMeOiFmEM5BuLrzSPKzY73TlSDOjz181faeYJVE3sTlmU5t4hvPaeFs8L/3vrQkKwcm+35HM7MCiIianRA==
Received: from BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24)
 by DM6PR12MB4809.namprd12.prod.outlook.com (2603:10b6:5:1f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Wed, 15 Jun
 2022 22:06:27 +0000
Received: from BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::e948:b801:9977:e44f]) by BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::e948:b801:9977:e44f%5]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 22:06:27 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [patch net-next RFC v1] mlxsw: core: Add the hottest thermal zone
 detection
Thread-Topic: [patch net-next RFC v1] mlxsw: core: Add the hottest thermal
 zone detection
Thread-Index: AQHWVkkqSdM07BxbjES5xPl1/Nc0ga1VQUSAgAANQ2A=
Date:   Wed, 15 Jun 2022 22:06:27 +0000
Message-ID: <BN9PR12MB53814C07F1FF66C06BCDC5FAAFAD9@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <20190529135223.5338-1-vadimp@mellanox.com>
 <f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org>
In-Reply-To: <f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb08cc07-f570-4fb5-c491-08da4f1b4b7b
x-ms-traffictypediagnostic: DM6PR12MB4809:EE_
x-microsoft-antispam-prvs: <DM6PR12MB4809505A533E60CF9088575BAFAD9@DM6PR12MB4809.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JQubLmHzzJZWuP6NKlnxmmcFZ9KkA4HJ95rMaRaaT4Bb89yVKTUDfrLo/sbpPWZOxO/ql6ZT6vnDsPjUupKSGqr3j6g4y9pQgq0Xtz7oGl6SSdEtjxr7GfrA36PVgHHxLEgI8jFh4slVY1JJxKBfenGAxKOOG06SmwKbYS40/g2jd8rqmRXkyFD9ayQwfDLnyUr2o6KjOzJNkMkyL4a55SUlWL00kWZ0yBmHcPyfXdp3RCZRUc7jDT4lPEeI98hMCt0EtPzgXjA+HcMc/XWqn/2mJHBwev99C+l7LZvO2+sDoH7pm8WB/btKxFKKTbpHINYB40X4jhrTZ8kmdmSO5idb0/YNrC2pr64mbulSJhI0m5uCKntKp2dIRdAT5d0IZPKzeKE+cWuvkbYU94lgEt9bRwrfMQzBMqEjsdmL9NEfimaAodH3UbPleIDjTTEnC2H8fbMjMb+fInPSowTW5wQ/YP2fdHqIcxVXWa6PkcsGxriej1/HEyi2hvDAhKkHDQMJweiX+eHVXf8G6vkUpCXx+a86SEFIijv/ReF2xSMzNRQChcAg4TS+fyubqLfdn2VNQg9pIHFWPFd1n6RfXG23hjAq/vll83GwQK+VV7n3/LXLLeMDOkeFWFlnWRQlTZoiKmnAc9ofgY9y19ukgWARcVDBUuax32pjFvH9c2kHbe9MB8a2WNqbNvTKiVamJwm4VgJ6nQ3c0wF4/8MzrXisMoClht/GQUXG0aFCKVuYNrgUigUsoOEMTabv/5bLtjshwM+CcXaOGA+B1ich2M24Aw+odrdeOqofg0dpJ3iY0MKGRZd7kd4tXDcdarCofxI7Y8F4eT30N+hJV1Rq8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8936002)(26005)(186003)(66476007)(76116006)(64756008)(33656002)(52536014)(66946007)(38100700002)(71200400001)(66446008)(107886003)(508600001)(966005)(8676002)(66556008)(316002)(4326008)(2906002)(83380400001)(110136005)(86362001)(55016003)(53546011)(6506007)(9686003)(7696005)(5660300002)(54906003)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVNyZEJJZzZGcDhzS3dEY0hZR3pjdFdiN2ZUSG4xZWJUQUMwWXFqeGdUV0lk?=
 =?utf-8?B?UzZUQkhnV29iVFJERHZYUk1tZnZZMFN6Ui9aRm5VczVFa2lPK3Y3TGgzU3Bu?=
 =?utf-8?B?VTV2WHhOb1creDRhOTJmOVJucE9OcjZqRHRjdDB6dXRQVTlOcGgyL0xTSFFN?=
 =?utf-8?B?Y3N3MThGQlg1ZEl5d1hHSWdRQ3QwMHkyT0pqd281NWVBRGtTOHNPV3pLcnRr?=
 =?utf-8?B?NFp6QUF6VFUyVGZIRnNDb2U5Sk96KzMxa09VdDlKeWhZaTN2NVVVUnV2djZC?=
 =?utf-8?B?ZC9yeVVObk94UWFqYm1DVGZkQkY0ZTNZS25uZ0RxTkVDcWJkQ2d1UGpvYVZi?=
 =?utf-8?B?OWdqTHFZTHZza25XTGRBRUcxRENFZzEyUVlPQ09Uc1dYTmJ6dXdFUE1ObUE2?=
 =?utf-8?B?c21VNE4vdWVDU0lTdzB1YUdYRStJd05UT1hMODJGRzRXbmpZRW1MVmYyWHNr?=
 =?utf-8?B?RlZlbkpPWExNV2NCNDRZeTdmR3M4OEZUbnNhMk9nVlR3ZVBvdE9hNG9VbWt3?=
 =?utf-8?B?ek11UkErUGlCajg5dmFUZVNmWEU4NG9OazRPTHNzTTllcCtZNit0QTQ1bS9R?=
 =?utf-8?B?akZaQVc1SkdNR2tDM0VwM3dRQWsxMk5Va3FkT0loWjZHUTRCMjUyWXU3amta?=
 =?utf-8?B?Q1ljd0krUmZSejQvRmFpcGdIK3F4QTZxVTdMdGVGMGhhcWNwaUR4RHNUcS9u?=
 =?utf-8?B?QnBwVXBoMjd2Y1hvaHEzbjB1WFQrOEdOVTlJcUR0MXZqa3pGdEZoZzN5UUVo?=
 =?utf-8?B?eHZLWjBYelRCeEtySGVLNDBuVGNvaWxKK3NLQXRXTlZIellHaHBvZjcyMGt0?=
 =?utf-8?B?NFdzN3VvRzQyc3FzNW5tUDR6VDhoTzhhbDBvRnlPRU5xanVLSEE1b3dNZEJZ?=
 =?utf-8?B?Tm9YWEorTzQzOExGWm81YVZrWUJVOWVRK1NPcnR0dnkwS3ArdkJCb2VkREV3?=
 =?utf-8?B?S2ZKYTU5MUVXMWhVUXZSbXJVUTlxVjFEajA1RkVUeFZmOHRJN3hmTFdyUVJF?=
 =?utf-8?B?ZEFSem14b0d1NjJ4RFZiOVU1YUljMnIxVzhkbE13VjlvSytITjFOeEM1OGNZ?=
 =?utf-8?B?cGRnR0RUbTZleDkvaG1pSHZoV2FJdkZ3cEtNd1IvNkNZQVFlS1hkdmJMa0ZU?=
 =?utf-8?B?TXc4RlNzaU5wa1Vmb3ZoMk0weWl0S1NKZE9lOEZibG1VRkJhbDMwMjJMT1U5?=
 =?utf-8?B?b0kzbFMrVTdJRTc0d3Q5Vkk4c1lDeGxzM1dHbE5GVTFFeG40aDJnRG5rWnQx?=
 =?utf-8?B?dml4MDh6aUwwREQ2UHlLYUNTWVRBUDZIaHIzV1NvN1BBOTJrQTkwaC9hRkhC?=
 =?utf-8?B?R1diRFczVEpDSWlHWlRqUUlXVlIzK0Mzb0laSjN0TlJRa2prR21Hd2V3azZT?=
 =?utf-8?B?bHdYRzRmY1B1TzJhVEN5TThjTXRSUUkwMEtGd0RvV1g4YzY1c2dXZXdWcXpM?=
 =?utf-8?B?cFk3UWh3cjJGTzZBdlNnZ1NyclkrRDNyR1EvaWZhZm9QRVVGN3E3eUplV0Zl?=
 =?utf-8?B?M0EvT3VtOUJuT1c3SEhuQ25SaTcva0pXQ0lpYlRVSEExVkRPdThTM1VwbVB6?=
 =?utf-8?B?N09pcG9FOVBac1JFSTBNQ3NZbjluNGVCTnY3WTE0ZVcxa2h5NHJvamxaemJ1?=
 =?utf-8?B?NEpyYXdIbU1FaDQ4V0ZZc2dZUUMza2VoT2syazNacTZWYTJ1VGhmNE1yb3p4?=
 =?utf-8?B?MUs4K2VJdEtncERTOThHeWFwUzRZaktVcUkwVUV6Wkt2ZCtXRlhocVZiQWxy?=
 =?utf-8?B?bm5PL1IwMHhnM2JzeHpXeUNER2lEMTNhNHgxWTlJT05iMkVuNHhyS081TGx5?=
 =?utf-8?B?dXNXdzdZQWhTVGFZbFd5OFQ4VW80T09MOGtaUXhvSjhmS2ZJMTFNQlRZcTBj?=
 =?utf-8?B?VE8zeXNyUzdDV1F6LzJ2cGtSbVBxS21aUUpTTXZXU0R5eE1GK3J0UVd0VERE?=
 =?utf-8?B?OWJ5UFpwUjN0VHlJOHFkUkF0YzdKeEhJM2NUSG4xY2I2K2VMeXNmTFEwcmFw?=
 =?utf-8?B?SWFiVnFRYTBoTEwwRkJ3WWtzV2FoS21KTGFCUlBqR2F6dzB5WGQ2Snk2Q0FL?=
 =?utf-8?B?b1k0OXZPU0pWVTZpL0t3WE1leE1wSVBVYWNkMzdkVWVTOGRtZUxrZ3h4VnM4?=
 =?utf-8?B?a3kxMnZhNjZHcEVPcFcvMnJmTU11eU1OTXh1bk9KcnFkUnBBTkoyZFdHYWVL?=
 =?utf-8?B?eXBYUHhoSkRsL1ZZY2lyVE1Ob0tGWGF4ZDdKbGZSL2ZZVThKeWZacGpxcXNu?=
 =?utf-8?B?TENUbmhId0xUZnlHaG91ZFpWYnF3bElnMzJ0YUhFL2JSVUhJa1VYaUdwdklq?=
 =?utf-8?B?aUl0T3ZJeklTSXY3UVBTQS9FS243K0EwckJrR3NlejVEV0tnRmJWdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb08cc07-f570-4fb5-c491-08da4f1b4b7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 22:06:27.5147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eFeygvD9RSUBW/Nr9Lzzy4uqWrtnkTlhS8dZcmwnG8E5EcknOp7DvaGfvnKYsks11ChoWrGrIBsiZf3J3iWzqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4809
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGFuaWVsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERhbmll
bCBMZXpjYW5vIDxkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXks
IEp1bmUgMTUsIDIwMjIgMTE6MzIgUE0NCj4gVG86IFZhZGltIFBhc3Rlcm5hayA8dmFkaW1wQG52
aWRpYS5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBsaW51eEByb2Vjay11cy5uZXQ7IHJ1aS56aGFuZ0BpbnRlbC5jb207DQo+IGVkdWJlenZh
bEBnbWFpbC5jb207IGppcmlAcmVzbnVsbGkudXM7IElkbyBTY2hpbW1lbCA8aWRvc2NoQG52aWRp
YS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbcGF0Y2ggbmV0LW5leHQgUkZDIHYxXSBtbHhzdzogY29y
ZTogQWRkIHRoZSBob3R0ZXN0IHRoZXJtYWwNCj4gem9uZSBkZXRlY3Rpb24NCj4gDQo+IA0KPiBI
aSBWYWRpbSwNCj4gDQo+IE9uIDI5LzA1LzIwMTkgMTU6NTIsIFZhZGltIFBhc3Rlcm5hayB3cm90
ZToNCj4gPiBXaGVuIG11bHRpcGxlIHNlbnNvcnMgYXJlIG1hcHBlZCB0byB0aGUgc2FtZSBjb29s
aW5nIGRldmljZSwgdGhlDQo+ID4gY29vbGluZyBkZXZpY2Ugc2hvdWxkIGJlIHNldCBhY2NvcmRp
bmcgdGhlIHdvcnN0IHNlbnNvciBmcm9tIHRoZQ0KPiA+IHNlbnNvcnMgYXNzb2NpYXRlZCB3aXRo
IHRoaXMgY29vbGluZyBkZXZpY2UuDQo+ID4NCj4gPiBQcm92aWRlIHRoZSBob3R0ZXN0IHRoZXJt
YWwgem9uZSBkZXRlY3Rpb24gYW5kIGVuZm9yY2UgY29vbGluZyBkZXZpY2UNCj4gPiB0byBmb2xs
b3cgdGhlIHRlbXBlcmF0dXJlIHRyZW5kcyB0aGUgaG90dGVzdCB6b25lIG9ubHkuDQo+ID4gUHJl
dmVudCBjb21wZXRpdGlvbiBmb3IgdGhlIGNvb2xpbmcgZGV2aWNlIGNvbnRyb2wgZnJvbSBvdGhl
cnMgem9uZXMsDQo+ID4gYnkgInN0YWJsZSB0cmVuZCIgaW5kaWNhdGlvbi4gQSBjb29saW5nIGRl
dmljZSB3aWxsIG5vdCBwZXJmb3JtIGFueQ0KPiA+IGFjdGlvbnMgYXNzb2NpYXRlZCB3aXRoIGEg
em9uZSB3aXRoICJzdGFibGUgdHJlbmQiLg0KPiA+DQo+ID4gV2hlbiBvdGhlciB0aGVybWFsIHpv
bmUgaXMgZGV0ZWN0ZWQgYXMgYSBob3R0ZXN0LCBhIGNvb2xpbmcgZGV2aWNlIGlzDQo+ID4gdG8g
YmUgc3dpdGNoZWQgdG8gZm9sbG93aW5nIHRlbXBlcmF0dXJlIHRyZW5kcyBvZiBuZXcgaG90dGVz
dCB6b25lLg0KPiA+DQo+ID4gVGhlcm1hbCB6b25lIHNjb3JlIGlzIHJlcHJlc2VudGVkIGJ5IDMy
IGJpdHMgdW5zaWduZWQgaW50ZWdlciBhbmQNCj4gPiBjYWxjdWxhdGVkIGFjY29yZGluZyB0byB0
aGUgbmV4dCBmb3JtdWxhOg0KPiA+IEZvciBUIDwgVFo8dD48aT4sIHdoZXJlIHQgZnJvbSB7bm9y
bWFsIHRyaXAgPSAwLCBoaWdoIHRyaXAgPSAxLCBob3QNCj4gPiB0cmlwID0gMiwgY3JpdGljYWwg
PSAzfToNCj4gPiBUWjxpPiBzY29yZSA9IChUICsgKFRaPHQ+PGk+IC0gVCkgLyAyKSAvIChUWjx0
PjxpPiAtIFQpICogMjU2ICoqIGo7DQo+ID4gSGlnaGVzdCB0aGVybWFsIHpvbmUgc2NvcmUgcyBp
cyBzZXQgYXMgTUFYKFRaPGk+c2NvcmUpOyBGb2xsb3dpbmcgdGhpcw0KPiA+IGZvcm11bGEsIGlm
IFRaPGk+IGlzIGluIHRyaXAgcG9pbnQgaGlnaGVyIHRoYW4gVFo8az4sIHRoZSBoaWdoZXIgc2Nv
cmUNCj4gPiBpcyB0byBiZSBhbHdheXMgYXNzaWduZWQgdG8gVFo8aT4uDQo+ID4NCj4gPiBGb3Ig
dHdvIHRoZXJtYWwgem9uZXMgbG9jYXRlZCBhdCB0aGUgc2FtZSBraW5kIG9mIHRyaXAgcG9pbnQs
IHRoZQ0KPiA+IGhpZ2hlciBzY29yZSB3aWxsIGJlIGFzc2lnbmVkIHRvIHRoZSB6b25lLCB3aGlj
aCBjbG9zZXIgdG8gdGhlIG5leHQgdHJpcA0KPiBwb2ludC4NCj4gPiBUaHVzLCB0aGUgaGlnaGVz
dCBzY29yZSB3aWxsIGFsd2F5cyBiZSBhc3NpZ25lZCBvYmplY3RpdmVseSB0byB0aGUNCj4gPiBo
b3R0ZXN0IHRoZXJtYWwgem9uZS4NCj4gDQo+IFdoaWxlIHJlYWRpbmcgdGhlIGNvZGUgSSBub3Rp
Y2VkIHRoaXMgY2hhbmdlIGFuZCBJIHdhcyB3b25kZXJpbmcgd2h5IGl0IHdhcw0KPiBuZWVkZWQu
DQo+IA0KPiBUaGUgdGhlcm1hbCBmcmFtZXdvcmsgZG9lcyBhbHJlYWR5IGFnZ3JlZ2F0ZXMgdGhl
IG1pdGlnYXRpb24gZGVjaXNpb25zLA0KPiB0YWtpbmcgdGhlIGhpZ2hlc3QgY29vbGluZyBzdGF0
ZSBbMV0uDQo+IA0KPiBUaGF0IGFsbG93cyBmb3IgaW5zdGFuY2UgYSBzcGFubmluZyBmYW4gb24g
YSBkdWFsIHNvY2tldC4gVHdvIHRoZXJtYWwgem9uZXMNCj4gZm9yIG9uZSBjb29saW5nIGRldmlj
ZS4NCg0KSGVyZSB0aGUgaG90dGVzdCB0aGVybWFsIHpvbmUgaXMgY2FsY3VsYXRlZCBmb3IgZGlm
ZmVyZW50IHRoZXJtYWwgem9uZV9kZXZpY2VzLCBmb3IgZXhhbXBsZSwgZWFjaA0Kb3B0aWNhbCB0
cmFuc2NlaXZlciBvciBnZWFyYm94IGlzIHNlcGFyYXRlZCAndHpkZXYnLCB3aGlsZSBhbGwgb2Yg
dGhlbSBzaGFyZSB0aGUgc2FtZSBjb29saW5nIGRldmljZS4NCkl0IGNvdWxkIHVwIHRvIDEyOCB0
cmFuc2NlaXZlcnMuDQoNCkl0IHdhcyBhbHNvIGludGVudGlvbiB0byBhdm9pZCBhIGNvbXBldGl0
aW9uIGJldHdlZW4gdGhlcm1hbCB6b25lcyB3aGVuIHNvbWUgb2YgdGhlbQ0KY2FuIGJlIGluIHRy
ZW5kIHVwIHN0YXRlIGFuZCBzb21lICBpbiB0cmVuZCBkb3duLg0KDQpBcmUgeW91IHNheWluZyB0
aGF0IHRoZSBiZWxvdyBjb2RlIHdpbGwgd29yayBmb3Igc3VjaCBjYXNlPw0KDQoJLyogTWFrZSBz
dXJlIGNkZXYgZW50ZXJzIHRoZSBkZWVwZXN0IGNvb2xpbmcgc3RhdGUgKi8NCglsaXN0X2Zvcl9l
YWNoX2VudHJ5KGluc3RhbmNlLCAmY2Rldi0+dGhlcm1hbF9pbnN0YW5jZXMsIGNkZXZfbm9kZSkg
ew0KCQlkZXZfZGJnKCZjZGV2LT5kZXZpY2UsICJ6b25lJWQtPnRhcmdldD0lbHVcbiIsDQoJCQlp
bnN0YW5jZS0+dHotPmlkLCBpbnN0YW5jZS0+dGFyZ2V0KTsNCgkJaWYgKGluc3RhbmNlLT50YXJn
ZXQgPT0gVEhFUk1BTF9OT19UQVJHRVQpDQoJCQljb250aW51ZTsNCgkJaWYgKGluc3RhbmNlLT50
YXJnZXQgPiB0YXJnZXQpDQoJCQl0YXJnZXQgPSBpbnN0YW5jZS0+dGFyZ2V0Ow0KCX0NCg0KPiAN
Cj4gQUZBSUNTLCB0aGUgY29kZSBoaWphY2tlZCB0aGUgZ2V0X3RyZW5kIGZ1bmN0aW9uIGp1c3Qg
Zm9yIHRoZSBzYWtlIG9mDQo+IHJldHVybmluZyAxIGZvciB0aGUgaG90dGVyIHRoZXJtYWwgem9u
ZSBsZWFkaW5nIHRvIGEgY29tcHV0YXRpb24gb2YgdGhlIHRyZW5kDQo+IGluIHRoZSB0aGVybWFs
IGNvcmUgY29kZS4NCg0KWWVzLCBnZXRfdHJlbmQoKSByZXR1cm5zIG9uZSBqdXN0IHRvIGluZGlj
YXRlIHRoYXQgY29vbGluZyBkZXZpY2Ugc2hvdWxkIG5vdCBiZQ0KdG91Y2hlZCBmb3IgYSB0aGVy
bWFsIHpvbmUsIHdoaWNoIGlzIG5vdCBob3R0ZXN0Lg0KDQo+IA0KPiBJIHdvdWxkIGxpa2UgdG8g
Z2V0IHJpZCBvZiB0aGUgZ2V0X3RyZW5kIG9wcyBpbiB0aGUgdGhlcm1hbCBmcmFtZXdvcmsgYW5k
IHRoZQ0KPiBjaGFuZ2VzIGluIHRoaXMgcGF0Y2ggc291bmRzIGxpa2UgcG9pbnRsZXNzIGFzIHRo
ZSBhZ2dyZWdhdGlvbiBvZiB0aGUgY29vbGluZw0KPiBhY3Rpb24gaXMgYWxyZWFkeSBoYW5kbGVk
IGluIHRoZSB0aGVybWFsIGZyYW1ld29yay4NCj4gDQo+IEdpdmVuIHRoZSBhYm92ZSwgaXQgd291
bGQgbWFrZSBzZW5zZSB0byByZXZlcnQgY29tbWl0IDZmNzM4NjJmYWJkOTMgYW5kDQo+IDJkYzJm
NzYwMDUyZGEgPw0KDQpJIGJlbGlldmUgd2Ugc2hvdWxkIHJ1biB0aGVybWFsIGVtdWxhdGlvbiB0
byB2YWxpZGF0ZSB3ZSBhcmUgT0suDQoNClRoYW5rcywNClZhZGltLg0KDQo+IA0KPiBUaGFua3MN
Cj4gDQo+ICAgIC0tIERhbmllbA0KPiANCj4gWzFdDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RoZXJtYWwvbGludXguZ2l0L3RyZWUvZHJpdmUNCj4g
cnMvdGhlcm1hbC90aGVybWFsX2hlbHBlcnMuYyNuMTkwDQo+IA0KPiANCj4gWyAuLi4gXQ0KPiAN
Cj4gDQo+IC0tDQo+IDxodHRwOi8vd3d3LmxpbmFyby5vcmcvPiBMaW5hcm8ub3JnIOKUgiBPcGVu
IHNvdXJjZSBzb2Z0d2FyZSBmb3IgQVJNIFNvQ3MNCj4gDQo+IEZvbGxvdyBMaW5hcm86ICA8aHR0
cDovL3d3dy5mYWNlYm9vay5jb20vcGFnZXMvTGluYXJvPiBGYWNlYm9vayB8DQo+IDxodHRwOi8v
dHdpdHRlci5jb20vIyEvbGluYXJvb3JnPiBUd2l0dGVyIHwNCj4gPGh0dHA6Ly93d3cubGluYXJv
Lm9yZy9saW5hcm8tYmxvZy8+IEJsb2cNCg==
