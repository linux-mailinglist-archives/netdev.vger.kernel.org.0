Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F3A4D8839
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbiCNPg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiCNPg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:36:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5F7443C2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:35:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICnJUzXpVIuxYhjCLal8yz58DxdMOygLx/xoiBuj0tmitkWW8UnTKqV43BvSMbIbXKasoIWd41WOkK4q+JfQLjoo3OfdCfk+7wrsG84Az1/ZwEq6V9Vkh8YNOd/aqQFHVV0B+rUxzdycTCqfFlGPaN9nDxEQ/aTd7+/1z0QlU64M6SYWpa9laS+ncOUvoGM0voZK6Z7lkjqD5uG3xa8C+qvV83FWv6MWv8+NOPDNgsvNcmRelheBtrdjhUGE00+AUAEGC4mA7uOLSTRvHXYMxbHv4K7Y4BVu4plHabeYfKd0y4DatDS8sCiASYfz9jpVTELc0fEztQ/l/rpV1ZRGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MViQEgNaf0fItO6ReD9mcRj2/7d+0aMur0Zkh0YuFlA=;
 b=SrEZ/3WO1cKiEP533vnoEmfs7VY/+KxJSohGSQPOv1z9U4EwRc07SJGwRSwcwJS/7lttAwooMahaEMVmspwT98ib0t7g+7FwdOgaU10zFPxuhmjY1l4e+NR6WR5YKRy8QNWJElO98LbSFA+3E55CgcKJ41/LwNTAYgIy6yI5rWCYZVWQKzsRL3+waHdY/TR+n2H5/POxKesySAA8FgtoPFIM18UZ7sUP+ASYxAh2i1ETZ1zTDsMhtg15KWJ+3LDoU4bI2WumZjYSd1owwgDiRgAIsM7U3Dtzvxt3DHNTSyny+TfGe0tiud1pyn2m5bF2h//VmRcx5w4GniWox5jlfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MViQEgNaf0fItO6ReD9mcRj2/7d+0aMur0Zkh0YuFlA=;
 b=j0gHk7mu2+BBYPTA+/FE75HAmOsKcWHQbYZDJTl6K8JoJhDqjH+p+u8xIn6ecNRLyhZXNpwOVQYLKY8h8/87yxmZxo8mlMWgYI8b9L9Qe8BJ4Xnlist1n1o9LCitKgsGU3boSeELU3Egt40WC5cP/wuktIHxIRcPQ5dIB66LHIm7X084dqSitbVTqqtr3xT3yQO9Vov35IMm4j2cHvI0oQ5ALhYkGE02qV+ffguSvwJlvh5GCOXghipNYZ/M3u8YyARWeJuiNgH4ZtvPht6NKrR9lRhnQU2PoDGyNQPmrx+E4Vkn5NCh6B3+XjPRrNOwJpubC7KDTcvg25A/K/UOMw==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 BL0PR12MB2417.namprd12.prod.outlook.com (2603:10b6:207:45::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Mon, 14 Mar 2022 15:35:47 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%6]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 15:35:47 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH v7 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Topic: [PATCH v7 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Index: AQHYNv2LN/8GLIMU7kW3y9RiVsKR1ay+/OUAgAAHRgA=
Date:   Mon, 14 Mar 2022 15:35:46 +0000
Message-ID: <DM8PR12MB5400C9467A4EA3895CAB1AD9AB0F9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-4-elic@nvidia.com>
 <6d9e4118-ee4d-0398-0db5-bd3521122734@kernel.org>
In-Reply-To: <6d9e4118-ee4d-0398-0db5-bd3521122734@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 928d4f1e-6ce4-4563-170a-08da05d04f78
x-ms-traffictypediagnostic: BL0PR12MB2417:EE_
x-microsoft-antispam-prvs: <BL0PR12MB2417F96AD55C097EBA225960AB0F9@BL0PR12MB2417.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kpq4Dmky8Mknshf9kvD6DjPfkgyovrAPvdxXkaii7CkgU2WKXllW1FCiszMNibGm4+epD5MpwhRWt7u2goDPVRU3zzW7WvToeeup/LP2EnGKhZyZfaaGm5uLkb75WS0VJsORXaCKUUD07RtW22J4CoCrpgXxklqROA1JJpFgnm6ZZxeHLRm0AAQ5BH14hGTHo8CfxP3xRhd6jPgWJGQQV3pZlMoQ2ikZwmnrzyaE5xUeluTQFQCImuQ/gBCh9zuHu31Bxj6FdXqr4h+YmIMziJDp2746Ro4/Zk/NXT1lMkZJ2rNwmQbV1GT/SxEuhqkZbYiqAuNxigGWZoxDrjRrKYBhMA2k0HNRufFf5dVsoTvGDtsLhxZ8wugqoarxTfc0BFPhIAc6aaSXmD9wYs2xixi2vCZdGk7VWvg4wFOxMktbJu19xkiUA7u4r8tvYA5s8Io9SMPIvv4qzrMmF9WZYq9qxZwK+it0blNe+0gdVBgQcgnp0rRhWSe4TXbR2YA4zqvdLg4oixk03QqaWaBFFKFowzaHuDCtPQNvkG0FenbG3ymKM8P0Bd4+jRknnCtXZ4DziYPwDdkgk+pFqSTA1zwbhewQQfe7gjaNtOJ6d8C4WChQTWKizl1zRh5BbggUzeGdRksBA+uJ70kvEQM94qozsI3teIUuPMPhKMZVOpE6JLgQl0USt9gzs1mMYx5mO3ljErn/c3d0/YI8fkjYmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(52536014)(86362001)(5660300002)(8936002)(33656002)(508600001)(9686003)(4744005)(6506007)(7696005)(53546011)(2906002)(122000001)(55016003)(38100700002)(26005)(83380400001)(186003)(110136005)(38070700005)(64756008)(66446008)(66476007)(66946007)(66556008)(316002)(4326008)(54906003)(8676002)(71200400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmhQcnFROHZsSlczRlpKZkxSSGhMVVhiVDRlUXN1SndOTGpQbWlDdzlLeUN4?=
 =?utf-8?B?cXV1RWNaTStKMEtuQlBPVE1KNFdRS2tzdUtsR2RDa0l6UE9nOWdDQmh1YVN3?=
 =?utf-8?B?a2k2NndUSCtPdVJhUEVaTXp5dm11Vzg0VWIvekhvTEFhMEwwRWNhNkttcDFz?=
 =?utf-8?B?SE1jQ1RrM2xzN3l4T0IwSWVuQU03ak84K3htcjd0NDZscVYzc2F1UmNRbStE?=
 =?utf-8?B?dnltS0JpTDRjdnN6MGNYdC9PbCsvc2NjdlIrNVEzbnRndUgyaG9rR21jb0NQ?=
 =?utf-8?B?VHE4ZEdnVkpzK1RPVGlIcDNTWW5lQndvK2dRelZxb1U2TnJ2Zi9tU09qL1BD?=
 =?utf-8?B?TUNhVjNNQTQrblJRSUpNMENTbXFJRFc5SC9aVXhudzBUR0k3R2xsQzR1ZlNV?=
 =?utf-8?B?NVp6Ym4wWXNESlFwaUJLTWh1N3orc2ZTNHpOYVVhMER5UENtR0R3TVZqTXVC?=
 =?utf-8?B?RnZKZDJTMFBoeHA4NFRublYwTk1BM3FpeUl5M3JXUStmZUJXdEYyVUZuTXVS?=
 =?utf-8?B?MDhjZm5talRlQ25kVDhRR0FuRlhKRmxTTGJpdWlHRjBucjZyUmlYcXk0ZU1i?=
 =?utf-8?B?RjFMYlRPbjVBSWxXTHdXdUgvYS9kaExXSlJzRTd3cWhVbmF6VUZiUlNOb2pl?=
 =?utf-8?B?aW1iVTRLVkNDUlJ0N1pVMXNSZC90U1dGbmd5RjBLZ2dma2VxdEQ5VkVlVnZI?=
 =?utf-8?B?SndLdHhuWHBOTEFteTRFQjhmY3N0Mnk5WTBSQVlBTFBINlFXLzZZaDd6QUVj?=
 =?utf-8?B?MkpXRUxtN0VXckNqVTdEQmJCMlExYWYxOHExL2VxKy8vZDJzeTFVdElMeStN?=
 =?utf-8?B?UXIxT3QzYk5hd1h6VE1ScHlCM0tlcnhDT0NDRk5hci90aE1HWkxPYzhKV21l?=
 =?utf-8?B?WWI0RFZnZnZKNml3OStONkp2dnQ3cXBsaDBEeEFSVlIzSHlQU0NyaHBOYmYw?=
 =?utf-8?B?V0JzVWkyR2MveHZ4WW55SmNuNWlUY2hsdncxZ3FzSHRoMWhmMWRxRTlyUHhK?=
 =?utf-8?B?VFJVVWpFbFExZjAwYUZUV0QvdTIvTTZXNXBoeWE1ZlEwWFcwYzUvcGZlQnZh?=
 =?utf-8?B?aWFmaXZQR3BvNUxjOGVoTXVhdUt4TlZXWWdkdzhRZjZIT1JqbzVuVkx6aFR6?=
 =?utf-8?B?WVJKZDlkRm9LNVRrVGpxYkJOaXlmTUpQcHExd3BTbWVVVHp3WkNkYkFPajls?=
 =?utf-8?B?cDRZWVZSZUJGVkVNbW81eVFFY3cvbHNoT0F3NEp4SXhXUDJwWFl4c1pqcW9U?=
 =?utf-8?B?Vkk0NFlLdk9MWFJKRytlSjJLMFBhT084MThsYzZPczI2ZFpmenJsWk1XeU03?=
 =?utf-8?B?NSsxcnZYSms0UXhhVVhNQ1FqY1luaXptYlFsTy9xTGYvQVpGallpVUJ6cGlC?=
 =?utf-8?B?alVTL1dqUHVJYWk2K2Q1R2FaWnlZN01yYmtOWmw3bXhHclJKWVNnbDVXWG5h?=
 =?utf-8?B?bXB3MWtXbXE5VUVCMTA5TWJlTHByckFaa3FROUJyQWdOZVl4OEtGWkpOSmRX?=
 =?utf-8?B?a2VrNSsyTllCak1NcmNvNzVXV0NhdndoWEpFV0hUbVh4blplRjBFRVZNZWJI?=
 =?utf-8?B?SUt1ZDMrTXJQK2NodUFlRm5wWTNIdlJSbTNKZ0FPWERGSm9pcWthYk41bTNC?=
 =?utf-8?B?VlRWcStvOTFMT2J5VktQYmdqK0pNNENLTk9TVjN0Tmc0ODZOaFZIS2dOTGJr?=
 =?utf-8?B?Tzg4LzlsZ1M0QldzdmlzRm03WVdIS1ZGaFhtb2RURHM3aWRVdkF3Z0JyWmE3?=
 =?utf-8?B?NjR2TGtMVlkwcjU5blpOd01ZR2FtekdpQ0lRcHFLVWZ5eXhmbkRZS2p4UE43?=
 =?utf-8?B?ekZLQk1XdnJYY0lyV2lvSFB2TTJuT2N5bmxjWHJSWmo5MlUxc1Q1cVJlVGtI?=
 =?utf-8?B?a2hOcGFDbzFLd2FIVzRzdW9MOFdOMnpDK1NvTm5OQk9vMXA4ZTFMcGF1SlJ5?=
 =?utf-8?Q?R6lCsoYBLh4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 928d4f1e-6ce4-4563-170a-08da05d04f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 15:35:46.9860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4qwhF0rE06M58O/MNCfcczVwBi2X1QTDDx7PoAUsFH4PvdEsrlbG8kiPRKBWYW8G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2417
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gMy8xMy8yMiAxMToxMiBBTSwgRWxpIENvaGVuIHdyb3RlOg0KPiA+IEBAIC0yOTAs
NiArMjk1LDE0IEBAIHN0YXRpYyBpbnQgdmRwYV9hcmd2X3BhcnNlKHN0cnVjdCB2ZHBhICp2ZHBh
LCBpbnQgYXJnYywgY2hhciAqKmFyZ3YsDQo+ID4NCj4gPiAgCQkJTkVYVF9BUkdfRldEKCk7DQo+
ID4gIAkJCW9fZm91bmQgfD0gVkRQQV9PUFRfVkRFVl9NVFU7DQo+ID4gKwkJfSBlbHNlIGlmICgo
bWF0Y2hlcygqYXJndiwgIm1heF92cXAiKSAgPT0gMCkgJiYgKG9fb3B0aW9uYWwgJiBWRFBBX09Q
VF9NQVhfVlFQKSkgew0KPiA+ICsJCQlORVhUX0FSR19GV0QoKTsNCj4gPiArCQkJZXJyID0gdmRw
YV9hcmd2X3UxNih2ZHBhLCBhcmdjLCBhcmd2LCAmb3B0cy0+bWF4X3ZxcCk7DQo+ID4gKwkJCWlm
IChlcnIpDQo+ID4gKwkJCQlyZXR1cm4gZXJyOw0KPiA+ICsNCj4gPiArCQkJTkVYVF9BUkdfRldE
KCk7DQo+ID4gKwkJCW9fZm91bmQgfD0gVkRQQV9PUFRfTUFYX1ZRUDsNCj4gPiAgCQl9IGVsc2Ug
ew0KPiA+ICAJCQlmcHJpbnRmKHN0ZGVyciwgIlVua25vd24gb3B0aW9uIFwiJXNcIlxuIiwgKmFy
Z3YpOw0KPiA+ICAJCQlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+IG5ldyBvcHRpb25zIHJlcXVpcmUg
YW4gdXBkYXRlIHRvIHRoZSBtYW4gcGFnZS4gVGhhdCBzaG91bGQgaGF2ZSBiZWVuDQo+IGluY2x1
ZGVkIGluIHRoaXMgc2V0LiBQbGVhc2UgbWFrZSBzdXJlIHRoYXQgaGFwcGVucyBvbiBmdXR1cmUg
c2V0cy4NCg0KT0ssIHNpbmNlIHlvdSBhbHJlYWR5IGFza2VkIHRvIHNlbmQgYSBuZXcgdmVyc2lv
biwgSSB3aWxsIGluY2x1ZGUuDQo=
