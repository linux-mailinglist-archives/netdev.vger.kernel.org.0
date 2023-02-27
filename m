Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E316F6A415C
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjB0MFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0MFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:05:18 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2053.outbound.protection.outlook.com [40.107.212.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D2510264
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 04:05:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsrwR4+nYBQ+ao2DvK+quBSe2b1MoC/FysP5xDcvMFq9D1oOohNK1NV3bCf7PpbjCPCQQKrJFv7EYxPRJPSbwj1qQhQDCcBbGAmRfgs0MzOOdGZodECdI7+u3NawdYW6WS/xEB+fGCJwkLiWvasUkjNC38udX44TXyYU8qcT6ZI48Z5VEu2rzfAfx3QsMN2t1shZasfiDzVXDeD5Hup3gMhNdhb+APkOQ7mnDMPwOyIcgXzwOQ8OO+MEht6izPeM06B7p9HPhg3jReKmxZHTCAb7XDBnyLbGhEpxOtJN2HR8imybfkwTDOmg6AhzLVWi4WqaYgwd6zk90VNQK+IiYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DjOZbAbmCNHPn/6cqDpLdnWG5ja1Wf6SQ5pCiwVtMM=;
 b=PrU+tJBBuz0eZoXahhsGAK6Ochi7gaM9l30O1ksv8sMNtglMydKXh8/ghqogAPfWL/EQGQUQov+6o/jCRX6gh+m13r4LRDvgp7MRbd3kDuD+pxCQLcycJohiBNZUmd2XGovL4Xd2x9jZTesgGgXmW2mIYhNjTfA/Tki1hldKXmARvlwZyrXZuJF5ocFmmsxghGS06KcJtOUUzCaw+fcpNAh8vbnItOcKKPqJVWm/pgdeUYUQDxd4alJU4pFFDqDv4w2yCimD8f9NU6V5kDIObJZnuWOvVM8GacluYdZzeaxc3sj7c3NVOoe/sOOC/WnXntbpxvxr+t144hhTLbnv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DjOZbAbmCNHPn/6cqDpLdnWG5ja1Wf6SQ5pCiwVtMM=;
 b=djrDjnmLKG8Yzd942Ye2dlLQ5nFnWvpSrvibeksa20Bc6UXDqDCMZUX37ud0VfmQ7njL5s5UABWYl3+ItF3yRaaQrMid2iFA4e3dLIDQPDH1+yF9XWGH5cA8u6X20ATVu0PXBFHFRdKU3btyzqG3xM8biMsUJPjOZY0/9pynyAw=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by BN9PR12MB5178.namprd12.prod.outlook.com (2603:10b6:408:11b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 12:05:15 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%8]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 12:05:14 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: devink dpipe implementation
Thread-Topic: devink dpipe implementation
Thread-Index: AQHZSqO2ZNI87MVqAUW5fJ4H0JyxhQ==
Date:   Mon, 27 Feb 2023 12:05:14 +0000
Message-ID: <DM6PR12MB42021C6149409933958BE777C1AF9@DM6PR12MB4202.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4314.namprd12.prod.outlook.com
 (15.20.6156.000)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|BN9PR12MB5178:EE_
x-ms-office365-filtering-correlation-id: 0309d7b5-a90a-45e1-7e0f-08db18bae2b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tur3Uea5IUynL8qh5jNg0nRim8UeCbCYGRcSoMgJsiufGD7Nsoz1wMrR/V/T9iQQ0N5TLKLgJ4+ROSvBU9B1dxxYRu8DB8SPb6V4rxJfHRI5eLZYkcbZZBS9+oLGhr1/I7umke5GBpqJk61l9bwG6PC8zEYVTRhZlBubdNnQZLlPhDcyG1KlQun32BHzKNV42tU1gX1XaBnLAZrs4zdNQnKoVtUniEAATOz5+t9AhN/5/ulo2EBjWtgXUidmte4rldzSkMJgQGcLkf5uX2hM/hLyVUzlnF1aMR3SE+hejC5DHc4IJjJw4Au2pCBW8fkYgjGF7OWj9gfPnT7G2+w7BUVmKFslkc6um9mfeOu4IdJholOjKpuG9VRV2YJ6NjuYdELubRn6qBfr0dpJ993SiSRNQCDBqRhGnsUL7E2hujgI2CBmCrWS5ST3xPSniuE1qMY2Dp5lhcrxSilIVxtgn8RUBzd+/SIQg/8by7Z8hSR+XZj0/wBZJ2nXTC7M/qLu07dLhLlaoOPOA5s50xkMs/6CJs6+1K+Y37//S+HkwYa/qmZCBmMlr2SDriBNcaLRtLtMNFhEn9ajv2Wu2T1lugk+0+Eck4yyboge9hS0la+VIkJ5Gr9m6MzIjNb7Txn0U/3gzkghyUCvLlX1o405LovbBqRxqeZjEqumMtpfLeQRYMdbP8hix6DMPkBt6aF/jRpJzprAlIcNIPgDLxruo7bbNCntgAyxobHHwmVwF1jsY1w5RC+vgRv5uOYIiAYyTXTlyzLdWG8ICV4uB89lMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199018)(33656002)(316002)(110136005)(52536014)(478600001)(71200400001)(5660300002)(2906002)(8936002)(7116003)(7696005)(66476007)(76116006)(66446008)(64756008)(66946007)(66556008)(4744005)(8676002)(41300700001)(122000001)(3480700007)(55016003)(38100700002)(9686003)(26005)(38070700005)(83380400001)(6506007)(186003)(133083001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L29Ndk1Wa0xpSncreTV4Y3VFNjFwbm5zRi9Xcjh3N2NYRk1TRkIwOVVhbFhP?=
 =?utf-8?B?YzF6MWlrTXpQVVVWZHloR2gvWEZRY0ZsMXI5Rkg2bU5EamhIdnVkSXFVZDU1?=
 =?utf-8?B?RDZOQkhJRnlVaFI0ZFprMHNiMmpLUmlITklCVkdtOHQ0TkRYamdEb0d6TUZo?=
 =?utf-8?B?UTUzOGxrN213SUUvVXFjYXQwV1Zqd29VZmswNWdJNkpXTUtYSHVvSWdITEJO?=
 =?utf-8?B?cWlTNWRZakRMSDNoYi9rWm9waHo3SHRaOExHQlRoUHFlaENWTEJScXIzL2sz?=
 =?utf-8?B?THRiUWlGQzRLanlubC9tejYvR3A1V1o3V3Z3bzlxK2lIelRPdjRZUU5mNjVm?=
 =?utf-8?B?QjNKMjZVSHJBUG4wbXVvZEFvNXg0S09tMkN2bXE5eUxsdGpPQnMxS3grSS9X?=
 =?utf-8?B?U3pqVTBPNHFXSjZUNTgxSGJ2MlJza25idVV5Ri96ZWFxUnFYNFFKSE81bnkw?=
 =?utf-8?B?YnFBY0pPdGtjZlFZRDluZkljZ0xlUTNQY2VMQnhxK1RvaG1aNEVCc01NR0hV?=
 =?utf-8?B?bnZzYmlSL20wcFJHYmo5ZHArVUdQeWZaQWNEK1RHR0tsMWkyRENyQkp6UHUy?=
 =?utf-8?B?aDhCYnpBYmg3QjFIcFBESU9xTHBncEQ3RjBRRkl0ZDdSWHJyeXF1SkxraWYr?=
 =?utf-8?B?ZThPVFNCa3NqTGtITE9MZGlCaW5iWFBQS0JIQkc4TVJDL1dFSDVobWZndGor?=
 =?utf-8?B?YlhJLzR4K2pyVG9EcDh4czdYbTFDRHlBK28rUkdtVHhLdGN3Qi84U0ZWRWwz?=
 =?utf-8?B?K2R5MEZDZVJKbnFkejQvQ0IxcHB3dWRKMEp3S2diWU9YNG5RWVVVU2JvQlk1?=
 =?utf-8?B?OFlFM2pKbUVCWE83YmNjQk94bGJOYWJMb2dvMkwxbjBpbEU4dWEreGpVajNR?=
 =?utf-8?B?MFNhODdwelZyazZGNUFmZHVKMWY4eExiMnNRQU9ORzNuckVNd1UzcTJ2LzhV?=
 =?utf-8?B?NXhRcnpVeU1pQnZONTF2MHQ4dFpGN1pVZU0rSk5NT1B1aUhxRmsvS29MMG81?=
 =?utf-8?B?a2JVNmVObTVvRGVZS0tXUENybFlpQ0dJczlTNWhubjRKS0RHS1J3WmdyRFVD?=
 =?utf-8?B?cVF5YmJnbkFiZnB5THhuOEZMdzAzdVNwcXV5bi9XNXlpYTFJN293MWM5WGox?=
 =?utf-8?B?S1REWG1rTUFHRVNxK2F4L3VmU2xvNkdLbExmZThJVUQrd0VscVljYjI0UDBE?=
 =?utf-8?B?ZlZrNGd3cUVQa0xhTk8rYmZSR3NoUTlsUUFneGtVYWVkUytJY1p2S25nTWM4?=
 =?utf-8?B?L05kSFZwQnY0Wjd5TkJrTER1cUV3Z1RHZGRSZnQvL3hGQTJSRGM2a0RrNFFx?=
 =?utf-8?B?emF4UFExSzB6M0V2b3VuZTZ2Nkk3U0U0VHlSSUpFK0NsRnJKRWJMcW9vZjJ2?=
 =?utf-8?B?Yk1PMHhheTdEQ1hKZGFEeEkvZGM5b2RIUWJadm1JWnNqb0VDR2RTb1dkVGFB?=
 =?utf-8?B?VFE3aUp3RlhmK1lDa2wxc090Tlh3MXEwTW5wNGZybGw3M2hxcVBJdFVJYW01?=
 =?utf-8?B?ZjQ2QVhLU1VqNjN5N0NYMEtQYmdGaHdjSG1rckJYV3N1ZjVRbkc0VzlYVUtW?=
 =?utf-8?B?N0psclh3RVZnLzR4Z2Y0dzZVaE5tZUw1U0d3NHE4SjBWRVozVXNKUEZVVG81?=
 =?utf-8?B?R3VrQ1FaYWo0ZHZBKzJTNmdad0MzT3VxODlkS2dOQ1V3QVR0NWRrajZCMlJ0?=
 =?utf-8?B?K3JhSGdZRUtEdERCQml0NlZ1RkswRzFVc25EcjNiZitmY1RRajZralRJR1Jx?=
 =?utf-8?B?Zm9XdmtTclI3QWVORG9qbkw2V0JQOVpuV2VYdGZadTZ5WUtxWmROYklzS0JT?=
 =?utf-8?B?RmpZMXNDMW44Y1Vnd3JBOTlwYkFLRXRzWkFLdzJ5dEVVd3JoRDhGYmduZURr?=
 =?utf-8?B?cGh3MlRraERFTGdJTzlSSk1zdVN0RFA4c0pTZFJJZVJlMmVIY0ZaaHJWblZj?=
 =?utf-8?B?ZmZCdmxzcUpsaUJRSmllZ0wvVXBKMzZSSldHcHVJNCtJN291MWtobUJqNHpi?=
 =?utf-8?B?dndJNi8vNkZUaVpBcDFINlk4dGpjM29aUndXZURKbGlQS0s2Y3FyUmt5ZlFK?=
 =?utf-8?B?SHE5VTdEdTdmOTh2bUZNRFk4L1BzNk1wL28vNkJJbjEzTzhHMTZ6cnNYVTNx?=
 =?utf-8?Q?9GxY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7266F3C8134154B850C54DD906770C1@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0309d7b5-a90a-45e1-7e0f-08db18bae2b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 12:05:14.9051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUuUPQk1OpV+4egjmuoJC4TQOYUFC25GUzep795FZCeNkyEmEgqgutVCiAl6jbQ/RWMelFvv8stz5Nhghyr9Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5178
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkknbSBsb29raW5nIGF0IHRoZSBkZXZsaW5rIGRwaXBlIGZ1bmN0aW9uYWxpdHkgZm9y
IGNvbnNpZGVyaW5nIHVzaW5nIGl0IA0Kd2l0aCBBTUQgZWYxMDAuDQoNClRoZXJlIGlzIGp1c3Qg
b25lIGRyaXZlciB1c2luZyBpdCwgTWVsbGFub3ggc3BlY3RydW0gc3dpdGNoLCBhcyBhIA0KcmVm
ZXJlbmNlIGFwYXJ0IGZyb20gdGhlIGRldmxpbmsgY29yZSBjb2RlLg0KDQpJIHdvbmRlciBpZiBk
dWUgdG8gdGhpcyBsaW1pdGVkIHVzYWdlIHRoZSBpbXBsZW1lbnRhdGlvbiBpcyBub3QgY292ZXJp
bmcgDQpvdGhlciBuZWVkcyBvciBtYXliZSBJJ20gbWlzc2luZyBzb21ldGhpbmcuDQoNCkZvciBl
eGFtcGxlOg0KDQplbnVtIGRldmxpbmtfZHBpcGVfbWF0Y2hfdHlwZSB7DQogwqDCoCDCoERFVkxJ
TktfRFBJUEVfTUFUQ0hfVFlQRV9GSUVMRF9FWEFDVCwNCn07DQoNCkl0IHNlZW1zIG9idmlvdXMg
b3RoZXIgbWF0Y2hlcyBzaG91bGQgYmUgc3VwcG9ydGVkLCBhdCBsZWFzdCBmb3IgDQpzdXBwb3J0
aW5nIG1hdGNoaW5nIGJhc2VkIG9uIG1hc2tzLiBJcyB0aGlzIGJlY2F1c2Ugc3BlY3RydW0gc3dp
dGNoIGRvZXMgDQpvbmx5IGhhdmUgQkNBTXM/DQoNCg0KT3RoZXIgZXhhbXBsZXM6DQoNCmVudW0g
ZGV2bGlua19kcGlwZV9maWVsZF9ldGhlcm5ldF9pZCB7DQogwqDCoCDCoERFVkxJTktfRFBJUEVf
RklFTERfRVRIRVJORVRfRFNUX01BQywNCn07DQoNCmVudW0gZGV2bGlua19kcGlwZV9maWVsZF9p
cHY0X2lkIHsNCiDCoMKgIMKgREVWTElOS19EUElQRV9GSUVMRF9JUFY0X0RTVF9JUCwNCn07DQoN
CkFnYWluLCBJIGd1ZXNzIG90aGVyIGZpZWxkcyBzaG91bGQgYmUgc3VwcG9ydC4NCg0KSWYgdGhp
cyBpcyBiZWNhdXNlIG9ubHkgdGhhdCBuZWVkZWQgYnkgdGhlIG9ubHkgZHJpdmVyIHVzaW5nIGl0
IHdhcyANCmFkZGVkLCBJIGd1ZXNzIHVzaW5nIGRwaXBlIGZvciBlZjEwMCB3b3VsZCBuZWVkIHRv
IGFkZCBtb3JlIHN1cHBvcnQgdG8gDQp0aGUgZGV2bGluayBkcGlwZSBjb3JlLg0KDQpDYW4gc29t
ZW9uZSBjbGFyaWZ5IHRoaXMgdG8gbWU/DQoNClRoYW5rcy4NCg0K
