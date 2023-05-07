Return-Path: <netdev+bounces-734-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D59C6F9703
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 07:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A48B92811CC
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 05:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A9A17E0;
	Sun,  7 May 2023 05:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBFF17D8
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 05:23:12 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D17911D83;
	Sat,  6 May 2023 22:23:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcBS+TNPJ2eQ+HdCCn+Nrzdu3jc5uce3fq2YKKjalhmIAqGHHUYKO7Nr41EfL+UU4fSzsoa5mbgpw24Uxz+ZXWISkH6bje8rEgueP6pc8NsU7ARILH8mS/sqS48Q2vy57etAN3t/b1eOdQA4oQOKeLHcSQP/FMBUCRm0ar/jH4XZ1HZTMNtPvt1Zym/804H+lxOWr1YEnSTdddvfNQg5MOgrhNQon59+1RK6zVckXxQb8CvnXP+SdeZ5ojeGgueKFeAPmZYt5ht0NnEwnIFre8JMzHxB0w4dge0h0J0uCv5tDgIeE+b0+1wPOOTzk6cIRc0YIr+pBTy5TVYPg+M6PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brJCrP3PL/gm71bPRE3PfgvJhUBUMZ33hLqFjJeXfzw=;
 b=acfF7PurvcCdOJCq15qaRXF+WCShTWN3ow3z3JHY8nAjh04xPRyReT0r4gRDfN0vNRLSXIYUVDdBQnQYHZs6+r2B/qZMdH9hE8JYonOqY/vAlxMe28BhrGHtIOPaPihGitUls7VyZqF6YlzIDiJPyxZnTSdSuZWyKN9ofsh48yqi5PEU1rZRGm8265ptyzkOxrmriXz4ioDIei1UfptlCahImhmhCp85/86RpvTbg9xXDWN1sMZ00yod1M3OGCXLbzQL9crh2cpIs5xxdh6VyBLX0kzGl7zGDs6hsu8Ny5/v7IuzL/LzGIyqQZwbSz6ARnEyYqS1/SjCABs7/RhIvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brJCrP3PL/gm71bPRE3PfgvJhUBUMZ33hLqFjJeXfzw=;
 b=YBwxBBBKKCPvWyoo/ZR6MRiHamnB56VxnCekgSGA7AAHsnnLjXn2od/tHZZsYdl7F8V5eQRzujmw49K7Mxs/WLRJuA8+emB5OX8zxRY4T72gGoERmtvuVmQ9v1iHzOKDzUeIwlnQGD/T9K4EvPjbjlcgJXW4gNxPv6bcl5N6yn/5CAjPA3fRA+ZYysTGv+yLK6DyLWM07FSwIS3t2wHcL3Dyp6iH5t2GTUGSeHZz0pDGy6u/WPOIIMnTN9oBBle2muNHLV4RKddyGnXw7FkHanuVsDvkcpMLSOfZeDi8KG5NiokrQ8y8j45fa/wQuvlr2umj358chDqc/uesq6djsg==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 BL1PR12MB5801.namprd12.prod.outlook.com (2603:10b6:208:391::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Sun, 7 May
 2023 05:23:09 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::3bfc:e3ce:f6c0:8698]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::3bfc:e3ce:f6c0:8698%7]) with mapi id 15.20.6363.022; Sun, 7 May 2023
 05:23:09 +0000
From: Eli Cohen <elic@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Chuck Lever III <chuck.lever@oracle.com>
CC: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	linux-rdma <linux-rdma@vger.kernel.org>, "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: RE: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index:
 AQHZfVsRBH+TK4pd40qPySTJP7qIg69IF2FggAB9uYCAASSfgIAAwZkAgABM+oCAA4OxcA==
Date: Sun, 7 May 2023 05:23:08 +0000
Message-ID:
 <DM8PR12MB54004679C6E1D72E0960FFE8AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com> <ZFRB6zydIoADEMLz@ziepe.ca>
In-Reply-To: <ZFRB6zydIoADEMLz@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR12MB5400:EE_|BL1PR12MB5801:EE_
x-ms-office365-filtering-correlation-id: 32449f79-4cc3-4ace-b633-08db4ebb24ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 koc3oj10v0q+wCB7w57HkmuajAgZ9TiKertv6VnbuNAF7fvOd1RytmbmtdNcEQe5nixjQJ83Bw1OI3fBpehWCwK2c3NXg6or1gva3MwK28mGONCxHZTaEcQSopnX6+ub0IMJCNFz2M5mIi2BpensMAp8NZoeq7VBtqpeABH7JYV5KgV1O623kK3BI87zPcMNqW42T4l09AV+HBUYsxJrKijprdgcGdVi9VkNGqmnAXTZ5afxRMQS7/PqmWZmuU1Ixk9LRozxrouECdbUoJc4eCMWXhZ8fiTWWmFkbyKqr5wuHupI/A6VvpUcAb8nQirUL8B6SbRPWWkutMRBkDKLdwAnatPMkcQOMbetOH0hYv+1VDmszimEK8tt9sCZH+yiMhMgj1NcKMwf5kDi4AgUXGbbHNaKocwl9BtUqeajIoDy8LVTT0y8pYrJPLlC6YeS1S3ZJqDEImx2l91DN9sb+shYI4Sv6w7zSYz4bxJxb9Yb2QnCCzCqdd/KNQOu2J0w7CgoMJPZV62f2Y1J8rorjWoaJ3ZESHjEg5lzh89zmKDSK4n9M/XS4mWiJjGYmt2IlaPvuzVK3y9swgN+pfdV4Z4y7Z7Hnt32W9qCFvyYERBBOdOVmSJWDL7g+4+BmkcM
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(2906002)(54906003)(478600001)(52536014)(41300700001)(8676002)(8936002)(316002)(71200400001)(110136005)(4326008)(66556008)(66476007)(66446008)(64756008)(5660300002)(66946007)(76116006)(7696005)(9686003)(53546011)(26005)(6506007)(186003)(55016003)(83380400001)(38070700005)(33656002)(38100700002)(86362001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UVNsZzhuU1F2RVcvcVNZMHdzelU3c1ZvZmhLejZ3T3FSZWREb24ySzA5RllZ?=
 =?utf-8?B?L3pBQi9HQ2FHVDZqWHA0ZDB6ZnQ1MU5OMVhDZ0M2OWtJbDhrZTEwOXpFLyt2?=
 =?utf-8?B?ajl3TVc3NUMyYmVDN0VmR2ljRnlQQ3duQXpVYWlmSDlIcHVIT0cvWW1jQzRC?=
 =?utf-8?B?WXlTbXU4TWt3N3padVJIQWdHVzcrQlVRV1Z4T1FieG5TMDNMVjI3cmxIaVJC?=
 =?utf-8?B?WDFNd3VCY29jVlFDc00vQzRHTlRNWjFNc1V2TTZiTnFUZUh2bjd5bjR5YVFn?=
 =?utf-8?B?Tkc0TFFNTFZZVUtDR2kvcWR6SEFLRFQ1QTQrT2pINjdwYVlnUGJEMVlOb1V6?=
 =?utf-8?B?aExiNlppSktqWUdGOFpqUnBNaXZyVTJuM1M4eGZEOU5EMFowdkNpVWZ3UmVl?=
 =?utf-8?B?eGhrOEk4TS9CYjhFU0pML1ZqK3crQms2bGZacUZJbmRyTDNSa1JYYmVPM09X?=
 =?utf-8?B?Yi9VMVc0cXpjOE9NZHdacHA5cHVpM0JpM3ZIMktLL0RKUWxycHRNRGpYQ1Vl?=
 =?utf-8?B?SE9TV0VrK0wzWjZtWlNxUXhyYUF6NTRzSFUrMW44OUdDUkhYUWtxVElKdkU4?=
 =?utf-8?B?YVZQd2tkWTVKRlV5WE15OGxNbTd3eUp4OXJ5enpVRGZISCtzSXRuQ1FVQ2dX?=
 =?utf-8?B?S0cwUnhaODRSb1g3ZURRYW1rOXB4WW8vRzdEajl4MVJkRUwxVVI3ek9mcldO?=
 =?utf-8?B?RmFpdk5icUNuNzdmNEFWQUo1Rmg1OVd2TU5xUGdTTjY1TEFGNlVUMWtWdDZX?=
 =?utf-8?B?eU43TVRJMDcwVC93WEMweXRpdm55eGVKNEYyTWRiY2Z4bzdESmppZ295NWlY?=
 =?utf-8?B?L1ppNklCY3VxMWRuVHdaQldWSkhocFUxMUhwT0J6Q3UyWWZ4UzhDV0ZZK1Nr?=
 =?utf-8?B?ekdNV2kzQVE2Q2lGaERyWVlNUFFVMSt2WlZUdTYrVmU0aFpiTEtpUVRPbGtF?=
 =?utf-8?B?ZTF3U0xrK3daYXR4Zk4wNWxVNVZDY29ZSy9qN280N1FEekUwWkpJMWNURDM5?=
 =?utf-8?B?elZNTjN5STVhZ085eXBzZk9IeDI4cDJNNHlydmh4WU5DNWxnVG5TRFVxbmpF?=
 =?utf-8?B?RFpKeUQxSUg4c3FDbFJVUVdyNnBkNHNISk9OVnp2dFRHUnpqWGNxTWszVWRB?=
 =?utf-8?B?eFdPWnQ0eHRUOUQ3d1ZYbUJYYUpHZUhrdTlkMlE1eE5DcCt1bHJVa0Q4SVhn?=
 =?utf-8?B?MWFNRzZoWVpOUzVPVG5iTTdZcWVxZnNHeThwRDh4Wi94Q2Uva0d6NkxHQnY2?=
 =?utf-8?B?NlRMaHJiWkZIVklUc1NGNnMyRlBXbGhFeHV4c0M3RGZORnorTkNQdE9HdFFl?=
 =?utf-8?B?bWUwTmVzUnRYYkpvbmhFVHBkdEVEMHQ0b0E1Vll6S0MyZjZEanVZNnl5MEVp?=
 =?utf-8?B?bXN6bmRWTzZERUlxdWpYQTVBZ3NJSmxPQWpReHZzT3diRTZnQ01iQ0xKNDVF?=
 =?utf-8?B?WDhXcWNsb1NqaWxHWUdQYzhnVXd0RmErSmd0VE5tb2poNkpUSDkxQ0RnOUMx?=
 =?utf-8?B?eEpoOVh2VWZZbXpHZHlST2dwdjB4V1ZJWmJNcTZPNGJpbTgvbzYyNllTMk5q?=
 =?utf-8?B?N2cwc0RuU3Z0alZvUGkrWGR4WmdkZVVCcTdWc2xqWngrTVExOVM0a1E0VTFX?=
 =?utf-8?B?bVJQSkFlcVhWWkpSdHN5UGU1aXhPWTUvVUphSkRoMlRVWlRWaFNKOUtmRGFL?=
 =?utf-8?B?b28xSGRoY0NPWUplVmNNZUVodlowYitjMzROVkVGb3lmZE1nMHNaa1dudjdO?=
 =?utf-8?B?L282MDJ4KzBjTUorR1dOSDNrVzNDaDE1YnRMZ3ZQOUNHQzdlY0FXNnpPWkRh?=
 =?utf-8?B?YVYxQ1pGN0RQVUduTVUwbG5neFdyVDdBQm5zMy9LMTdyOFFzRU0reEdyY1Vp?=
 =?utf-8?B?KzRRTlNQK3laSUtPYTZMTUZNeFMzM09BWXdvQ1g1L0tFSml0VXNGQzRsbStK?=
 =?utf-8?B?NEFLSTI0MHhiZlFLTHJqV3pCM1h0N2dEZzdTNytmM2pkM3NSZEdaTnpGeVdt?=
 =?utf-8?B?amF5ZDVWZjlRMFdOODV0d1U2NFFaUVhUZTFjMjMxZEtYczN1SkliNi83VE54?=
 =?utf-8?B?VjBIbVA4SUdKS2pTS3kycDJ6RGpTbWw0NVpIaktvaFk5YzUzUi9iZktxN044?=
 =?utf-8?Q?e3MQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32449f79-4cc3-4ace-b633-08db4ebb24ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2023 05:23:08.9512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cp6HJCSWMdixezbdAR+G9/3+AkkOQJt2nyWGBJyvyb4YpIG6TAXHFDrj1VQVnFeP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5801
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

TWF5YmUuIEFuZCBtYXliZSB0aGUgcHJvYmxlbSBpcyB0cmlnZ2VyZWQgZHVlIHRvIHRoZSB1c2Fn
ZSB3ZSBtYWtlIG9mIHRoYXQgaW5mcmFzdHJ1Y3R1cmUuIElmIEkgYW0gbm90IG1pc3Rha2VuLCBt
bHg1X2NvcmUgaXMgdGhlIGZpcnN0IGFuZCBvbmx5IGRyaXZlciB0byBtYWtlIHVzZSBvZiB0aGlz
IGluZnJhc3RydWN0dXJlLg0KIA0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9t
OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gU2VudDogRnJpZGF5LCA1IE1heSAy
MDIzIDI6MzgNCj4gVG86IENodWNrIExldmVyIElJSSA8Y2h1Y2subGV2ZXJAb3JhY2xlLmNvbT4N
Cj4gQ2M6IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPjsgRWxpIENvaGVuIDxlbGlj
QG52aWRpYS5jb20+OyBTYWVlZA0KPiBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+OyBsaW51
eC1yZG1hIDxsaW51eC0NCj4gcmRtYUB2Z2VyLmtlcm5lbC5vcmc+OyBvcGVuIGxpc3Q6TkVUV09S
S0lORyBbR0VORVJBTF0NCj4gPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJl
OiBzeXN0ZW0gaGFuZyBvbiBzdGFydC11cCAobWx4NT8pDQo+IA0KPiBPbiBUaHUsIE1heSAwNCwg
MjAyMyBhdCAwNzowMjo0OFBNICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6DQo+ID4NCj4g
Pg0KPiA+ID4gT24gTWF5IDQsIDIwMjMsIGF0IDM6MjkgQU0sIExlb24gUm9tYW5vdnNreSA8bGVv
bkBrZXJuZWwub3JnPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBPbiBXZWQsIE1heSAwMywgMjAyMyBh
dCAwMjowMjozM1BNICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6DQo+ID4gPj4NCj4gPiA+
Pg0KPiA+ID4+PiBPbiBNYXkgMywgMjAyMywgYXQgMjozNCBBTSwgRWxpIENvaGVuIDxlbGljQG52
aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4+Pg0KPiA+ID4+PiBIaSBDaHVjaywNCj4gPiA+Pj4NCj4g
PiA+Pj4gSnVzdCB2ZXJpZnlpbmcsIGNvdWxkIHlvdSBtYWtlIHN1cmUgeW91ciBzZXJ2ZXIgYW5k
IGNhcmQgZmlybXdhcmUgYXJlDQo+IHVwIHRvIGRhdGU/DQo+ID4gPj4NCj4gPiA+PiBEZXZpY2Ug
ZmlybXdhcmUgdXBkYXRlZCB0byAxNi4zNS4yMDAwOyBubyBjaGFuZ2UuDQo+ID4gPj4NCj4gPiA+
PiBTeXN0ZW0gZmlybXdhcmUgaXMgZGF0ZWQgU2VwdGVtYmVyIDIwMTYuIEknbGwgc2VlIGlmIEkg
Y2FuIGdldA0KPiA+ID4+IHNvbWV0aGluZyBtb3JlIHJlY2VudCBpbnN0YWxsZWQuDQo+ID4gPg0K
PiA+ID4gV2UgYXJlIHRyeWluZyB0byByZXByb2R1Y2UgdGhpcyBpc3N1ZSBpbnRlcm5hbGx5Lg0K
PiA+DQo+ID4gTW9yZSBpbmZvcm1hdGlvbi4gSSBjYXB0dXJlZCB0aGUgc2VyaWFsIGNvbnNvbGUg
ZHVyaW5nIGJvb3QuDQo+ID4gSGVyZSBhcmUgdGhlIGxhc3QgbWVzc2FnZXM6DQo+IA0KPiBPaCBJ
IHdvbmRlciBpZiB0aGlzIGlzIGNvbm5lY3RlZCB0byBUaG9tYXMncyByZWNlbnQgaW50ZXJydXB0
IGFuZCBNU0kNCj4gcmV3b3JrPyBNaWdodCBuZWVkIHRvIGJpc2VjdGlvbiBzZWFyY2ggYXJvdW5k
IHRob3NlIGJpZyBzZXJpZXMNCj4gDQo+IEphc29uDQo=

