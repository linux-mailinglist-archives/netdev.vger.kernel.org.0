Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2745A441261
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 04:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhKADc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 23:32:26 -0400
Received: from mail-bn7nam10on2137.outbound.protection.outlook.com ([40.107.92.137]:37804
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230222AbhKADcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 23:32:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAHwUXRQ5pcX3+AfIvcwvqPvbQrn79nFYFgwUHw7KQRDSKbx5l+O7WibyyqOMh+g634RTObalCDERJsYQ+g86uRhjbsjl6qtBH24yFbpWNmz3H46JMnodTMQk9TgYxQkQ/a1xN/2DwlCBGZ4R7375+4EbhQnPCDM2EgCJ8BpLDZMWLDcbUN0E5skqzGe6K+/jMAdLUOK3Nq6UZzonjCwdBdUyKUby4zBUa0HpEkSRJ40VBPnAMF3UggmkX4PWIbY+4o+c6wgomAsCkDIE3Qu+vCOE43uH+SdVJ1dQ1AJj4srLbjxxTWumVB+zCdUvWRmSCmmaUjAJ4lP4EBEtEhz1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIascKDfTGpoB/juUkC8MSCYvPl/h64ZxpMgu3/o0lU=;
 b=gFtsUzgG8hlfhvu51KP36Hj7TkJhUZt+JZbDChBxwJhqNC/6RdwQyfeKF+Fb1WUkHNhBb75BMdaTni6ZZekaztYFmyRvtgq9ot6/MR3ReNcJtrHUEaUcoGX2/arcTkJBOEAVx42qzwspQjNnGz+kjOBvhRzMJk2Sxvsi2DloeYGYYCg45Jtr0LKjk6AZGBmW83njpst1p2/7A6huUj9dszS7nYRthuSXLq72JpfBDW2eZdmGzRRvbZYv2dgiHkEMzllKwlygvP8jnnlLpa3Cp+9HA+TlqU+AYhejD8Y7r7PXis60lVFbcdec22p94aZWVdyAasw003k29t1UaGTuBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIascKDfTGpoB/juUkC8MSCYvPl/h64ZxpMgu3/o0lU=;
 b=kQvvXerobhez8H1BwdmlQUKMludqrUE3XtmOxqE/hC/+HaFTOhPVIwlyN39cj3c2vmtoWvx8k6E0zwFdQ3yKwOxkzRlyF+YKjglh23GUnWapBUVzb3z01xv6mYbZSpY5pmp5+dMGobqEy2vJBwZZHKB0aSBOlbtVoH/9Rwon/as=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB0970.namprd13.prod.outlook.com (2603:10b6:3:73::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.9; Mon, 1 Nov
 2021 03:29:49 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4649.014; Mon, 1 Nov 2021
 03:29:49 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Topic: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAEbH4CAAECyAIAAv3npgAC92QCAAOYhwA==
Date:   Mon, 1 Nov 2021 03:29:49 +0000
Message-ID: <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
In-Reply-To: <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f74699b1-8b9b-41aa-e50c-08d99ce7dc52
x-ms-traffictypediagnostic: DM5PR13MB0970:
x-microsoft-antispam-prvs: <DM5PR13MB09704F622341922ED9E14FA4E78A9@DM5PR13MB0970.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JmpInBiG980hdRZSOsxmzOrm7SJ2n/FLlTNJ0dVcxqR33RiNYKN0FG2DkdsU1SQhrk1AtWLG4zPbHAjZ8IOQiKCJmElFF0vp2JELbXJm7Gt5oCejuPH2tU+HXrHc7vYeLOM3EBLw4RIW05gihvGHuCZcHyIgzb6HL2W5fp6YcHafq7+pl7eEVuc8g78FP+CGLxKZ5XpMk9GfrIPpsh8DtroM8/x5c9aIayi3e8bweCikIPZb8goSCLypBKGaX8xiHwp8H25+N0VWrSOdxXo7JLufe7hdlNRFiiAhHxH3b6ur62kC4E0T0i5k/DdnntcdPQ7ASPUR8MCZwb7I2ntdMU9e7WgsM+HG1RxuaBhuLSJzNiTzPjqU4iGFWpImKgHRTGM05d2E6R6AE5Zt4bzAwtd3PZ/bRpHcXADijynNzhgvBVlyj+qLa5cgpKIxe0HbnZeZM/1W7ro0jXMJBHkYMoMIQfWq0XrnphvZC2d0wrDQCJ96cNFZ9oKA53rlhDzYnL37fJr7G+4t/im9oo6uLX+DPnDaJqixrjDCtGzctG10Bt/OADkovOXE7XxR0MZOhtlJIask5GVfdXpys7V0fwy3jT6wKLiZmA7tvqfwaUY/dyqm5AjREs3uG4uI5jW72j7JPYrZgqzaLAvhs48k7FzaAfxIwQjI6haGmNAQj3rN1Spp+Ruie3yWPtoIflMStiAHbwpXSFpiSbQq4GL5Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39830400003)(396003)(366004)(54906003)(66446008)(64756008)(66556008)(33656002)(38070700005)(15650500001)(4001150100001)(44832011)(71200400001)(107886003)(55016002)(9686003)(76116006)(66946007)(66476007)(53546011)(6506007)(86362001)(38100700002)(122000001)(508600001)(8936002)(26005)(8676002)(186003)(4326008)(52536014)(83380400001)(5660300002)(7696005)(2906002)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2I3UkRxamNqRzIrMjRvb2JjNGE1OXJMM0tGNjJUWlI2MjUrS3JBVXdIQ2Fi?=
 =?utf-8?B?RzdJRURmSDlkOFFBS1k0b0FuUFYyWFRnRWJuTTRLR0daalBIb3p4L2MxSlZW?=
 =?utf-8?B?b0VvMytEV1owRE5HL1BHUkk2alRjMUhOcmk2cDF1ajNPeXFaZ2h1TllzdXBO?=
 =?utf-8?B?RSszd3BFcDdkblFVai9uQlFtWGwwanJHZ0RVYWJHenMzOWVkNWhjVWkwNzFV?=
 =?utf-8?B?SmE2RGZ4R0krRWhxd1lHVlNCSWtJZVg4MWxSWEZWaG9LQ2pLWks5dTNWTGpL?=
 =?utf-8?B?M3VqMUo2aFUyYi9lNTk2TWFpdHJzMTNic2VVTzk2Tk1pMW5RMTFDeXdJZ1VJ?=
 =?utf-8?B?cWo5K1A0eEREUk9BVklHd3dYUXFZY0FjMXMyN0FNVWJBaFgzZ0lUZnozS281?=
 =?utf-8?B?OWRxR3YxNVVwc2UzK1BFc1NTY01PWlBRZkxJZ0NjNzVEaU9ZdVMyeTJlOTRt?=
 =?utf-8?B?TXlrVkY1eTVnWlU1RVB2TnIwb1luNVpYL1BRbmJWNVVIK255dUQ4dWxVSUh2?=
 =?utf-8?B?Yjd5aEZHSDZkNmNpL0lhVWN4RXB3ZlJmTHozZnh2MWdpOGZhRjBKVjJIZDlU?=
 =?utf-8?B?djNJNTJuR0hOVTJWWEllUjcvODZReWxZbEtTK01saHhkcS9wa1lzOFArc01r?=
 =?utf-8?B?Y0FFaExkWVBwRW4yUDE1dnhWa2dOazBkWGlIbVNTMGVaT2kxR1dmanh0MWNE?=
 =?utf-8?B?Y2hUdC9tRC9NeTVqTnVIT21DTXJtMXVwc0t2d2tIM2dudDNlTU1HaTlpUXk3?=
 =?utf-8?B?VHp4dzNIS1k3b3I5QlJBMDFsSkxFZEJBU04yeGNmS3FxaXJFMmFnNFlMSFFD?=
 =?utf-8?B?b1dtSU1Eai9tcDd4MWhyTVlhOGdZeWQzOWZteEtsS0lnVkJrcDhkWFZXcUxR?=
 =?utf-8?B?RGVvb2RXTUJhbklyYVdidW9mS3lReS93dEU1R0lVb2JtL09DSjhPMDNjenBX?=
 =?utf-8?B?MXhCSFg2UktGSExBUTB3eE5BSllvN08zNFBZdUhOdmlqRStDc2JGaW1VWjBR?=
 =?utf-8?B?RDJCYzZFT2ttREJESXVKTE0vZExsaHl2L21Nd1NMZnYraHdxU1BLeGNYNnRQ?=
 =?utf-8?B?QXBxcThScWtYK3E1S09DR3JKMUtBd2s1bkI1eG9aV3A3bWJtRVd6WUh1bzEv?=
 =?utf-8?B?NXhzSUNYMWI5MWdWVTZxSXg1SkZmeTZZSldEY3NRUUNYVlFlL05KV3JTeW1F?=
 =?utf-8?B?ZzkxOG5qb1ZDSFJRejZ2OURWc2dKK2FIS3NCTmxSalJpWHhEcUxwNTNoTWQ0?=
 =?utf-8?B?MDE3UERJc2J4dlY2QjZCRjdZcjhPQk5pVnhhNGlIb3plV2Q1Mm83UGtyMTU2?=
 =?utf-8?B?M3l1NXl4bm02dVprOENiUVlRd3FUTGk0eFBrM0Q3QWJCbDcrTmRndENXR082?=
 =?utf-8?B?T3FzQkpwbDZ6ZzA3SHlCWnlUR0N2OE80aTBvMWZQZXlnODM3di9GN21vU1pr?=
 =?utf-8?B?UitTS2VVdStJMFp4d2srd0lKTENiRWVQQWxCU05KRzRQdkRhbXZjbk93dk1I?=
 =?utf-8?B?Q3pZbGdONDc0NHpIRlRpTHZ2MDJvT2w2VjRmeXIrK3RaSlF6WW92VklMQmtL?=
 =?utf-8?B?bEJjVERZeXlTSkc4Q3hqRk9KQkI1NHNpeHNwbkxPUFZESHRscFhYZ2M5Tk1O?=
 =?utf-8?B?Wll0aVpKTmUySk9BMzJvTXVrUWw4OGdYSFBNaFBxQ1ljWWJFT1hKZG1uc1F1?=
 =?utf-8?B?VlJkelB6eWdyazdjTHU2bGNBOHV2QUg3UTd0a2FDMFFuc0I5MzVPdFRtcExh?=
 =?utf-8?B?RjUvcWlnM3hPdlRwWk5DZTVNUTAwbXd5WjMxTmR6VHc5dFpjZWJsL09BdVUr?=
 =?utf-8?B?cmtBVWJkd0V6Y0NtVmhkWEZ5b2hRRUVvUlpGL3o3ME5EUDM2ZVg4R29VTEN4?=
 =?utf-8?B?cFUyOE1hS3ZWMVRyMkpRcTVRaGU5WFJhajY5c2tKYWlsS2tKQTZCclJHa3R6?=
 =?utf-8?B?SVRTZDdJbXNaVE9oN2Q3Z1VIM3Y2TDh0ajE1YU4rL2p3WW5UbnJLdmpJMTM3?=
 =?utf-8?B?YVVVSUZ1ZWxNSFplRDFMLy9qTXY3TER0cUx4bGRRUEZtZXZsVUNqOE9YQUtj?=
 =?utf-8?B?cGx2QVBLdldBb1VFT3FldHE1c28yNWJzQ0pqYk94STJzOUh5Vk5DVTc3cGxs?=
 =?utf-8?B?N1pKd1pWajFTemhidEk2M0NheTBOYlhWWXJmVy9UZmNmTC9FdGtCRXFnTVdW?=
 =?utf-8?B?VndZVlhJbWViSGdFMnR0ZWNlakdCOVQyK0FDTkNzY1hRWW12ekFPNVMvVUxy?=
 =?utf-8?B?Qlk2VUZ4NEJJMGtRakdEbjVlZlZ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74699b1-8b9b-41aa-e50c-08d99ce7dc52
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 03:29:49.5845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v5Opst67Wk2qNq2A5pAbCL2RtNip7vw7chVpCsYfq01NCnXGPY0HAKUiW7soAiQdI0UR/CdTB1g/SsDMI6oPTK4qqvaQbZmkzDxYR0/jHOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB0970
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAyMS0xMC0zMSA5OjMxIFBNLCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPk9uIDIwMjEt
MTAtMzAgMjI6MjcsIEJhb3dlbiBaaGVuZyB3cm90ZToNCj4+IFRoYW5rcyBmb3IgeW91ciByZXZp
ZXcsIGFmdGVyIHNvbWUgY29uc2lkZXJhcmlvbiwgSSB0aGluayBJIHVuZGVyc3RhbmQgd2hhdA0K
PnlvdSBhcmUgbWVhbmluZy4NCj4+DQo+DQo+Wy4uXQ0KPg0KPj4+Pj4gSSBrbm93IEphbWFsIHN1
Z2dlc3RlZCB0byBoYXZlIHNraXBfc3cgZm9yIGFjdGlvbnMsIGJ1dCBpdA0KPj4+Pj4gY29tcGxp
Y2F0ZXMgdGhlIGNvZGUgYW5kIEknbSBzdGlsbCBub3QgZW50aXJlbHkgdW5kZXJzdGFuZCB3aHkg
aXQgaXMNCj5uZWNlc3NhcnkuDQo+Pj4+DQo+Pj4+IElmIHRoZSBoYXJkd2FyZSBjYW4gaW5kZXBl
bmRlbnRseSBhY2NlcHQgYW4gYWN0aW9uIG9mZmxvYWQgdGhlbg0KPj4+PiBza2lwX3N3IHBlciBh
Y3Rpb24gbWFrZXMgdG90YWwgc2Vuc2UuIEJUVywgbXkgdW5kZXJzdGFuZGluZyBpcw0KPj4+DQo+
Pj4gRXhhbXBsZSBjb25maWd1cmF0aW9uIHRoYXQgc2VlbXMgYml6YXJyZSB0byBtZSBpcyB3aGVu
IG9mZmxvYWRlZA0KPj4+IHNoYXJlZCBhY3Rpb24gaGFzIHNraXBfc3cgZmxhZyBzZXQgYnV0IGZp
bHRlciBkb2Vzbid0LiBUaGVuIGJlaGF2aW9yDQo+Pj4gb2YgY2xhc3NpZmllciB0aGF0IHBvaW50
cyB0byBzdWNoIGFjdGlvbiBkaXZlcmdlcyBiZXR3ZWVuIGhhcmR3YXJlDQo+Pj4gYW5kIHNvZnR3
YXJlIChkaWZmZXJlbnQgbGlzdHMgb2YgYWN0aW9ucyBhcmUgYXBwbGllZCkuIFdlIGFsd2F5cyB0
cnkNCj4+PiB0byBtYWtlIG9mZmxvYWRlZCBUQyBkYXRhIHBhdGggYmVoYXZlIGV4YWN0bHkgdGhl
IHNhbWUgYXMgc29mdHdhcmUNCj4+PiBhbmQsIGV2ZW4gdGhvdWdoIGhlcmUgaXQgd291bGQgYmUg
ZXhwbGljaXQgYW5kIGRlbGliZXJhdGUsIEkgZG9uJ3QNCj4+PiBzZWUgYW55IHByYWN0aWNhbCB1
c2UtY2FzZSBmb3IgdGhpcy4NCj4+IFdlIGFkZCB0aGUgc2tpcF9zdyB0byBrZWVwIGNvbXBhdGli
bGUgd2l0aCB0aGUgZmlsdGVyIGZsYWdzIGFuZCBnaXZlDQo+PiB0aGUgdXNlciBhbiBvcHRpb24g
dG8gc3BlY2lmeSBpZiB0aGUgYWN0aW9uIHNob3VsZCBydW4gaW4gc29mdHdhcmUuIEkNCj4+IHVu
ZGVyc3RhbmQgd2hhdCB5b3UgbWVhbiwgbWF5YmUgb3VyIGV4YW1wbGUgaXMgbm90IHByb3Blciwg
d2UgbmVlZCB0bw0KPj4gcHJldmVudCB0aGUgZmlsdGVyIHRvIHJ1biBpbiBzb2Z0d2FyZSBpZiB0
aGUgYWN0aW9ucyBpdCBhcHBsaWVzIGlzIHNraXBfc3csIHNvIHdlDQo+bmVlZCB0byBhZGQgbW9y
ZSB2YWxpZGF0aW9uIHRvIGNoZWNrIGFib3V0IHRoaXMuDQo+PiBBbHNvIEkgdGhpbmsgeW91ciBz
dWdnZXN0aW9uIG1ha2VzIGZ1bGwgc2Vuc2UgaWYgdGhlcmUgaXMgbm8gdXNlIGNhc2UNCj4+IHRv
IHNwZWNpZnkgdGhlIGFjdGlvbiBzaG91bGQgbm90IHJ1biBpbiBzdyBhbmQgaW5kZWVkIGl0IHdp
bGwgbWFrZSBvdXINCj4+IGltcGxlbWVudCBtb3JlIHNpbXBsZSBpZiB3ZSBvbWl0IHRoZSBza2lw
X3N3IG9wdGlvbi4NCj4+IEphbWFsLCBXRFlUPw0KPg0KPg0KPkxldCBtZSB1c2UgYW4gZXhhbXBs
ZSB0byBpbGx1c3RyYXRlIG15IGNvbmNlcm46DQo+DQo+I2FkZCBhIHBvbGljZXIgb2ZmbG9hZCBp
dA0KPnRjIGFjdGlvbnMgYWRkIGFjdGlvbiBwb2xpY2Ugc2tpcF9zdyByYXRlIC4uLiBpbmRleCAy
MCAjbm93IGFkZCBmaWx0ZXIxIHdoaWNoIGlzDQo+b2ZmbG9hZGVkIHRjIGZpbHRlciBhZGQgZGV2
ICRERVYxIHByb3RvIGlwIHBhcmVudCBmZmZmOiBmbG93ZXIgXA0KPiAgICAgc2tpcF9zdyBpcF9w
cm90byB0Y3AgYWN0aW9uIHBvbGljZSBpbmRleCAyMCAjYWRkIGZpbHRlcjIgbGlrZXdpc2Ugb2Zm
bG9hZGVkDQo+dGMgZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXAgcGFyZW50IGZmZmY6IGZs
b3dlciBcDQo+ICAgICBza2lwX3N3IGlwX3Byb3RvIHVkcCBhY3Rpb24gcG9saWNlIGluZGV4IDIw
DQo+DQo+QWxsIGdvb2Qgc28gZmFyLi4uDQo+I05vdyBhZGQgYSBmaWx0ZXIzIHdoaWNoIGlzIHMv
dyBvbmx5DQo+dGMgZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXAgcGFyZW50IGZmZmY6IGZs
b3dlciBcDQo+ICAgICBza2lwX2h3IGlwX3Byb3RvIGljbXAgYWN0aW9uIHBvbGljZSBpbmRleCAy
MA0KPg0KPmZpbHRlcjMgc2hvdWxkIG5vdCBiZSBhbGxvd2VkLg0KPg0KPklmIHdlIGhhZCBhZGRl
ZCB0aGUgcG9saWNlciB3aXRob3V0IHNraXBfc3cgYW5kIHdpdGhvdXQgc2tpcF9odyB0aGVuIGkg
dGhpbmsNCj5maWx0ZXIzIHNob3VsZCBoYXZlIGJlZW4gbGVnYWwgKHdlIGp1c3QgbmVlZCB0byBh
Y2NvdW50IGZvciBzdGF0cyBpbl9odyB2cw0KPmluX3N3KS4NCj4NCj5Ob3Qgc3VyZSBpZiB0aGF0
IG1ha2VzIHNlbnNlIChhbmQgYWRkcmVzc2VzIFZsYWQncyBlYXJsaWVyIGNvbW1lbnQpLg0KPg0K
SSB0aGluayB0aGUgY2FzZXMgeW91IG1lbnRpb25lZCBtYWtlIHNlbnNlIHRvIHVzLiBCdXQgd2hh
dCBWbGFkIGNvbmNlcm5zIGlzIHRoZSB1c2UNCmNhc2UgYXM6IA0KI2FkZCBhIHBvbGljZXIgb2Zm
bG9hZCBpdA0KdGMgYWN0aW9ucyBhZGQgYWN0aW9uIHBvbGljZSBza2lwX3N3IHJhdGUgLi4uIGlu
ZGV4IDIwDQojbm93IGFkZCBmaWx0ZXI0IHdoaWNoIGNhbid0IGJlICBvZmZsb2FkZWQNCnRjIGZp
bHRlciBhZGQgZGV2ICRERVYxIHByb3RvIGlwIHBhcmVudCBmZmZmOiBmbG93ZXIgXA0KaXBfcHJv
dG8gdGNwIGFjdGlvbiBwb2xpY2UgaW5kZXggMjANCml0IGlzIHBvc3NpYmxlIHRoZSBmaWx0ZXI0
IGNhbid0IGJlIG9mZmxvYWRlZCwgdGhlbiBmaWx0ZXI0IHdpbGwgcnVuIGluIHNvZnR3YXJlLA0K
c2hvdWxkIHRoaXMgYmUgbGVnYWw/IA0KT3JpZ2luYWxseSBJIHRoaW5rIHRoaXMgaXMgbGVnYWws
IGJ1dCBhcyBjb21tZW50cyBvZiBWbGFkLCB0aGlzIHNob3VsZCBub3QgYmUgbGVnYWwsIHNpbmNl
IHRoZSBhY3Rpb24NCndpbGwgbm90IGJlIGV4ZWN1dGVkIGluIHNvZnR3YXJlLiBJIHRoaW5rIHdo
YXQgVmxhZCBjb25jZXJucyBpcyBkbyB3ZSByZWFsbHkgbmVlZCBza2lwX3N3IGZsYWcgZm9yDQph
biBhY3Rpb24/IElmIGEgcGFja2V0IG1hdGNoZXMgdGhlIGZpbHRlciBpbiBzb2Z0d2FyZSwgdGhl
IGFjdGlvbiBzaG91bGQgbm90IGJlIHNraXBfc3cuIA0KSWYgd2UgY2hvb3NlIHRvIG9taXQgdGhl
IHNraXBfc3cgZmxhZyBhbmQganVzdCBrZWVwIHNraXBfaHcsIGl0IHdpbGwgc2ltcGxpZnkgb3Vy
IHdvcmsuIA0KT2YgY291cnNlLCB3ZSBjYW4gYWxzbyBrZWVwIHNraXBfc3cgYnkgYWRkaW5nIG1v
cmUgY2hlY2sgdG8gYXZvaWQgdGhlIGFib3ZlIGNhc2UuIA0KDQpWbGFkLCBJIGFtIG5vdCBzdXJl
IGlmIEkgdW5kZXJzdGFuZCB5b3VyIGlkZWEgY29ycmVjdGx5LiANCg0K
