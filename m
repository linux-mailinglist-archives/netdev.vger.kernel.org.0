Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52CD6790B6
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbjAXGPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjAXGPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:15:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA2B2CC41;
        Mon, 23 Jan 2023 22:15:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwtpwqr93O6xRNasTVBgW2oF8FsRn9CtKSshN2mNIC8EqShkIDMFeHogif+ZrNvtGIbPPpgpKSFQnuRcrthU1YSXhbZXf1sVS5JvD6bDVAvQM+bWwlU+5zuZeri+rWvyRYH5KHEVLBlrwkOrPlVDI+WrM1z7mnOaA0/50YOHwGt/AAeaestuyjk+JF0cq8zCgx3GSnADD7jLZWWI4jgW3clXtu8K9WdKNZb8nh460iFgHZ4lB0xsXacQ83uzUonE1bFLc9m09GGRQhfkQ+Vl5u8jn5nKBnob6KZABxgPMnZw4El91GaQh1JG3HHyHQnP+gC98HXbr60Zt2y72xiL8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bu2Nex2cIEfNsT0o2G25HNrMCHBP376sWYWQA60xJDM=;
 b=lRqCWmxoejpqr7zxh7HvO98ifT3U4IygS8kl6+mFnacHp5sEsEnb0UaoiU1edwtRZ8OwdMVFSpKcb1Rlili3/820ZJvI6jnliJvYSYMVYxiQu0UnQwUwQIIHr7xMgCA7wp1ddFW4OgMmHBpPJrDuAdOZQwW6ZdOPi6Lu1gUDxk/pXWu/mGuYgMFlhJ6iUuXkjoaqDqjIavAXZ+fE/+pvcfjUNlJiJRiHwD2QP+d1KWHRJ6FwGhuHwIEsBZoH8WWvJJo1f0oyQzQS0w4xQe/L3koqhDhy4FD/EdXu14aFtikEPZp5ZzpsJTrXO71NnWk3PwpCb9j0o72Y99nxE27SYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu2Nex2cIEfNsT0o2G25HNrMCHBP376sWYWQA60xJDM=;
 b=RYI84IDw7fx8E6z9JuCUtuRQ4qvjmYBPvA/Yp6gFNtkeusMNCdzWHmW+epNaUVbOCCzMqwtsdHAhUNyIdXhNNHZV7D2to8WZmRsvWa4nnGMUX/QD56Q9AN63u8JRa8nKZq39xhVxFW8WgC7dffRZXM9pEZiyr31tvswlHuAVdZ5kY2NN4pjTzgrgznudAh488WiIth3jEPnLw7hnEHWe82YqHFcjt1IToV4dJhhcbSU+Qi2aYNrW/UCCH5G5vHWMvSWxhphW7N7EXg3nQ6wtn1bXceDAeMLqriQFMPRYOdhHDk4Go+ErGTk5KaILtQexZH05Fc5FON3dBFdHv57aYQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB8013.namprd12.prod.outlook.com (2603:10b6:510:27c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 06:15:18 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 06:15:18 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
Thread-Topic: [LSF/MM/BPF proposal]: Physr discussion
Thread-Index: AQHZLamA3iTNPLXsDkOaW3tA+bsD5q6rbS2AgACZLACAAGVZgIAAr3EA
Date:   Tue, 24 Jan 2023 06:15:18 +0000
Message-ID: <bcd58332-c9ba-2c5e-71bb-3dabfa068856@nvidia.com>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <Y84OyQSKHelPOkW3@casper.infradead.org> <Y86PRiNCUIKbfUZz@nvidia.com>
 <771236a2-b746-368d-f15f-23585f760ebd@acm.org>
In-Reply-To: <771236a2-b746-368d-f15f-23585f760ebd@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB8013:EE_
x-ms-office365-filtering-correlation-id: c834c03d-2766-4dce-66c4-08dafdd25dd4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vAZEFNdscJjKVTDcbHdwjE0Yx8sbVXyUZRIavUXkA6XGw3lbbFwb434VGMsJ0GReFGsNIEGosHjhfLbqmCoRXdw+cs7tLKsh/q1fscJUF2kAlZyA1pByqeEwIsKuNPVsfxvg9rnE2S+TcwGwyKTYpdq60hoZT+ujAgnSuyUm6ld46JV6aDBUx1cKr/++nAb8SuuyRJQUMjl+8UYYP60oWvfV2U7oZIHxTZV38ikqcYgAV7+8rUBcbgeN1DtHUW3xSl/7OIsai3ccEdnN5EX+1f4exB9033vjsWX+ts0OUt7/t1h+5XUemuaZSbdHotNSzVbfWXQIVYpNTIEVHCNFprrIL3kC6bSub06fZ1wRefGOPVtDwHdF3whS6ReZmtBIHv2jIjBrAoQDXkGyuBDejlNrezQIFoDyZbSL2KpchR7Q5xcwNZU7xUQriQ3ryRNNbR0elvPB5wNBpxwPsqkdWqhBR2ReATY2yCN0Y82PByiOeuPVcscbaq4ho7XOJBECTquVDEyQ1xps0SQyVP+ZA8vV6bJ2ie8n7e1HQGX5u3Fc1/4dxXz++FWMnjVLNyxjsUeOP73q2NXHyA2OTeW6351kq2QONxNAcHgqBF5cNPqhTLFZly45xmBvZsPyPYUcd3KUejOU6mCPDruDB0x+KIwXpeg9fB4DaiJresYaIN5qi/L2zMNLtG9+ZT9x3Knoyr1NktxslWAv1VKlD06TjzliGn3jc7xBHY3w2L7FVo09qyH5jNVldTgGLaj7f8hBCNuIzH9WJdMN/NcHi7nPkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199015)(122000001)(83380400001)(38100700002)(31696002)(86362001)(38070700005)(2906002)(4744005)(5660300002)(41300700001)(8936002)(7416002)(4326008)(186003)(66446008)(8676002)(6512007)(26005)(6506007)(316002)(76116006)(66556008)(64756008)(53546011)(2616005)(66476007)(54906003)(66946007)(478600001)(71200400001)(6486002)(110136005)(91956017)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OC9aMldNc1lNMnFYSEhpV3ZER3lkRXJWcEJjM1V2dkt4STQ2M1dsRk5mWVQ1?=
 =?utf-8?B?OUdPZ3NRWWZlVmQrem16blRXMnlKWnZ2a1REL1dmRjZpR3ZCeEVkbkVidkZj?=
 =?utf-8?B?QzREUjdlQkk5c2trb2ZZc2I5ZEFMdjM2UVdxdUd3K1B5UW8wS0VTLzZzNFJk?=
 =?utf-8?B?QlFaVGlUdFIwQkRDZTg0d3diRWdRSmVqeHUrZ09mKzBiRE0wK1lxTmNDTWZV?=
 =?utf-8?B?VTJJK1JmRmwvMlA1UWNYLzFhQnVNbk0yOHpRRmFqaU4zL1hzekpKc0RydldO?=
 =?utf-8?B?QWhEUFBTN3FFbjdrWEQwNW5tVjBjc0xZc3hUODRld1pSUGNKVTFRcXhrcHZo?=
 =?utf-8?B?UHZidEc5U3BMZjdaUVp0NWl1ZUxpY1FXTWExNlppZ1hMa3lSM0R0S2dEek9P?=
 =?utf-8?B?SUNrazFSeVJTZzlMdEdWd2lJaGthQmN2dGFMaFJHWC9lV0lqWGJzRzJnWW5n?=
 =?utf-8?B?RVU3OGNlTTV3YnhvaTVjRklJYWdCYkxPeUdEM1pFSnc0RW5HaFRQQTdYcElZ?=
 =?utf-8?B?R3E1VWVTcm9vOEtYbU5UVnFBSzA2aXd6S2EreFgxSGRKY2NVVUxtTC9iRFlj?=
 =?utf-8?B?V1I4YWNPYkpnMGgzSVdTWmVzeXdLZndOa1BDaEVkRSs4S0lhQkFKNG5YdHNu?=
 =?utf-8?B?U3lJUzVncEtHZG5HWGpLdkcwTXVTUFRCaTMrNnM2V2tyYWIrRHFDVzkzaFY3?=
 =?utf-8?B?RTh4bzVrclNJZ21GZlZnbkhWak9xWjlReGcyQk5RVDZCZC8vQmlzNzlva0Fj?=
 =?utf-8?B?M0RJSzZSYVQwNXUxU29rM0xyZzFtQk54QTIrV1I1OEtmUXpjckZNSGh3T3g4?=
 =?utf-8?B?ZGFWWUxnMUZYWWpyZC9BYVNUa0E3Z0VVMk94U3lYcklzdFlYdlVod3lnVjVu?=
 =?utf-8?B?cFQ3V0EyL3kwcDB5N2R1aDZ0elM3VEpoOGZjL1R1MnkwYUJoTkRjWExFZ214?=
 =?utf-8?B?OFZBMS91ZkE4YjlvMS9MRW5iVXg4a0xnUHphNU1IeGRSeThVbTJ2WFlEOHln?=
 =?utf-8?B?MUtUU2JZVHhtTjhMUTVndFBldjVqY0JHWDhpVldyVUVOSHp2QlVwc3JrRnZC?=
 =?utf-8?B?OFlGOUZ3bVM3YVFneUZEWFRnTDZ5SkV3dE80aDlwQk9WaWtyeVpaQi95WWpZ?=
 =?utf-8?B?cGVSV3hRSFhubWl4L2lDUGdBVGJrZENCb0x5dTR1MjZxVCtnaUc3MllIS2wy?=
 =?utf-8?B?bWVxSzRrU1dSS1h6N1NMeVMwLzlLYWxOS2tiWmxOWEF3WGpwSS9yajBXYldH?=
 =?utf-8?B?WXE2NUVKcEViaktaSFdTQ2UzV3NhQUI3N0dabFlKc2wvekpzcnpUaWM4VDVu?=
 =?utf-8?B?aVJzblZKc2F4RVV2QXJIRk5yQVA2WDczd2xXUHB4aGNZY3AxekJVdmJIRHRz?=
 =?utf-8?B?MTZuWXBydzVqQ2QvSnQ3NFIxWnpZQkZwNGVCa3c3OEI0Z3VwbEtlT21KYXpH?=
 =?utf-8?B?c2lNVk0zdnYxVEdiSjRtU0d6UjErT3RNMGJHN2htYlBJb1dGVm45Z2RiTHBu?=
 =?utf-8?B?Tjdpd3lFYjVmYkREY2VuVVZFdXMyZ2YzSlFEcVNIbk80RDRSS3pRRis1eURG?=
 =?utf-8?B?eGRtY3NvTnJrNGgzM3A4NFEramVOaXhKZ1M4VGVyS2k5Y2lMYU5OcENsSkEy?=
 =?utf-8?B?VGdhWXNzOXpkTVlPVGxrNDVWU1h4NlJmcGl4V0ZSUklEeDExR0VIK2dkOHN2?=
 =?utf-8?B?UTM4ZHdmS1AyOFAzU3A2bXlGK05JcHhSU2Z4RS9YRlNhZnFlUS9GaVZJenVt?=
 =?utf-8?B?Q2h1ZVR3Mys3TzZQM0hqOXlUejg5MUJFOCtqRDJDbnd3cXB4YWI5V0xpcTN4?=
 =?utf-8?B?OXBFV0huT3FGN2YybGVBNXExZXV3b2JjV3BIOG9qbHRYYTZ0MUFHWVZCZ3Fu?=
 =?utf-8?B?a3lnZ1NRUFk1RnlmY1dmTHlsSW9xMVMyTXpZd2hqelY4bmF1dTVJakxtb2lr?=
 =?utf-8?B?MUU4RjVhOFA2WHduNldIamloRFNVOUJOMk9ZeFhVTDY1eHpEZ0ZUSkRZQjdt?=
 =?utf-8?B?R0pmK1h2ZTNiNmo3bytoTkxMMWdRUUZmemxvMlQ2ek1pNjZGZytPWmNCZEdK?=
 =?utf-8?B?MzZoY0VyM2pXZVBCRDBtdGo5RmNWQVlMc3MzV3pNdk8wWno5dnJJSkpDM28y?=
 =?utf-8?Q?EStqts3Clr1rD39rR1JJWUkRs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABD20B45826F23438CA133533E8AB1DF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c834c03d-2766-4dce-66c4-08dafdd25dd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2023 06:15:18.5194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Sfbl0l3FSPXFsSalKgqyYXrJv4JuFUjwSZLLvJtPwIBSb6jJL8XiUA3HJAgcquw80JaZB/Rw4vufJJOEP/R9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8013
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8yMy8yMyAxMTo0NywgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiBPbiAxLzIzLzIzIDA1
OjQ0LCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+PiBJJ3ZlIGdvbmUgZnJvbSBxdWl0ZSBhIGRp
ZmZlcmVudCBzdGFydGluZyBwb2ludCAtIEkndmUgYmVlbiB3b3JraW5nDQo+PiBETUEgQVBJIHVw
d2FyZHMsIHNvIHdoYXQgZG9lcyB0aGUgZG1hX21hcF9YWCBsb29rIGxpa2UsIHdoYXQgQVBJcyBk
bw0KPj4gd2UgbmVlZCB0byBzdXBwb3J0IHRoZSBkbWFfbWFwX29wcyBpbXBsZW1lbnRhdGlvbnMg
dG8gaXRlcmF0ZS9ldGMsIGhvdw0KPj4gZG8gd2UgZm9ybSBhbmQgcmV0dXJuIHRoZSBkbWEgbWFw
cGVkIGxpc3QsIGhvdyBkb2VzIFAyUCwgd2l0aCBhbGwgdGhlDQo+PiBjaGVja3MsIGFjdHVhbGx5
IHdvcmssIGV0Yy4gVGhlc2UgaGVscCBpbmZvcm0gd2hhdCB3ZSB3YW50IGZyb20gdGhlDQo+PiAi
cGh5ciIgYXMgYW4gQVBJLg0KPiANCj4gSSdtIGludGVyZXN0ZWQgaW4gdGhpcyB0b3BpYy4gSSdt
IHdvbmRlcmluZyB3aGV0aGVyIGVsaW1pbmF0aW5nIA0KPiBzY2F0dGVybGlzdHMgY291bGQgaGVs
cCB0byBtYWtlIHRoZSBibG9jayBsYXllciBmYXN0ZXIuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBC
YXJ0Lg0KPiANCg0KSSB0aGluayBpdCB3aWxsIGJlIHZlcnkgaW50ZXJlc3RpbmcgdG8gZGlzY3Vz
cyB0aGlzIGluIGdyZWF0IGRldGFpbA0KYW5kIGNvbWUgdXAgd2l0aCB0aGUgcGxhbi4NCg0KKzEg
ZnJvbSBtZS4NCg0KLWNrDQoNCg==
