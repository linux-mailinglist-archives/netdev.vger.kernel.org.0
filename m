Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2F93DD4EB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 13:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhHBLtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 07:49:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3608 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233341AbhHBLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 07:49:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 172BhEVf012380;
        Mon, 2 Aug 2021 04:48:53 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a6b46rvxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Aug 2021 04:48:53 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 172BjD3K016005;
        Mon, 2 Aug 2021 04:48:52 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a6b46rvxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Aug 2021 04:48:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtPL3lWrRFHluaBQXpneORp22o0kEidmq84dzrIwpehm9WHt7w8AKwyHEBPwjCwF3EbrBThtiFxq4FvVPYmD0fuit+M2Xf9P6isPKc3JYGg+C27JFp6CaDXkyJoirc5MW/yMKEer2qxY4NndSAjKXGew0L2VvijocJjlPXP4nKPyQ2dyP3DiiEoqJ1FraTPg4ntqHtO8VdaOweQoJUoClaXT/+qI+ZCYJlS0Z29+gCr8REBRHRXuR//5VxDLv0Y1Zi7qDNyt6VqxxCSWjWeT8Pc7TiJX9xaANMhbhfLxjPD06jM16RRztJ2RVWqoJUlfmvou2IKhXSWVdUIKrxABPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSY5kV2pM1wA0CFUouuMOl/c8ixRoKUO9T2iC3tpX/I=;
 b=TJOeUx1omIm/mPYfqPAwH5W4oGoRehobtulKTY3iqj7gfqbIgBmlEIr8RWec3CXmDTaZRfpyd2I1ikhb9NEmVCLJ/YSSqZFyBh9EOauhlDfMhFAaADB8yxqKWU86apd07RtesZy2PMqH87fag5W1de2De34MMCHZCrErUAgLO6rH79Cc1/V/lvK/07iQuVbSvXW7ZYRrpyv4yudzY183DvYXVgrJxVVLYF/TOo/aOEqbqeM5/6/iL+uSGm0Ff7YPf7srst5+if7lHlJM/qeJQmUXk4/lvWHi8hHHzZYRxZ1q7h2alLL7JNI1u9BKPQS8YiQ7Ya1yrAQN00wIn6RAXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSY5kV2pM1wA0CFUouuMOl/c8ixRoKUO9T2iC3tpX/I=;
 b=Hc8T5NcoBlSEZOtuWmRfoOPmQ1in1mjXQ0LO/pAXzAOUBicMfNVf7tDPO/N/Bk98MmMu7Y599mO0BI2UIsoALDuJqnxmk2lruKpbdNyGIET4WZKFrwQ9saRUYF40xwOabbZlO5O18Hpu+swjDTYWvcMPSfXJ9o3m9hpfLIJcF0I=
Received: from DM5PR18MB2229.namprd18.prod.outlook.com (2603:10b6:4:b9::24) by
 DM6PR18MB3051.namprd18.prod.outlook.com (2603:10b6:5:162::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.18; Mon, 2 Aug 2021 11:48:49 +0000
Received: from DM5PR18MB2229.namprd18.prod.outlook.com
 ([fe80::a9c9:dccf:5e59:fdec]) by DM5PR18MB2229.namprd18.prod.outlook.com
 ([fe80::a9c9:dccf:5e59:fdec%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 11:48:49 +0000
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     Bill Wendling <morbo@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Shai Malin <smalin@marvell.com>
Subject: RE: [PATCH v2 2/3] bnx2x: remove unused variable 'cur_data_offset'
Thread-Topic: [PATCH v2 2/3] bnx2x: remove unused variable 'cur_data_offset'
Thread-Index: AdeHk9R53B01xuamRI2ZzYfxiphUDA==
Date:   Mon, 2 Aug 2021 11:48:49 +0000
Message-ID: <DM5PR18MB22293BEFF6CF18BC2B9700C6B2EF9@DM5PR18MB2229.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ea9d8f0-8dc2-4803-5c27-08d955ab7e71
x-ms-traffictypediagnostic: DM6PR18MB3051:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3051AEE1BF50BD3A1BEB851FB2EF9@DM6PR18MB3051.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: opCjAkGi85iHrqgL6WHuv3yFccy7maPPBfH3zKQ+iT8VVFtiL6pFgyJnAF0Tj3aV0GeIbkB9tSOAbdfeBchP/ykbqxEiXaNrflH1zlGAEDUnBSSDXsHnj9Naj6xOqsnRZwxM1VA2pisM692mM8px7nWdZwYlHbpwb+wJO9PKDv9t/UOvjGDI/OP+sZqmLEMGpYjASs+3zEWzCmlnSpbfSM+ZEeQnv35RF8CoVBogLkErehbFFXHR6697AA+XDQQZTOC0IRnMDACWfCab4KVaGiApsYrvMK1z2IZ3uyt6Xjh1g2UNSVketezGCkFG8Oa8q1lY7eZBDeEMAOVi9aU8ZiGIfGQWzZs8kgP5w1SfHfOUJGhDyyfyw7vwNqEtt8dSiarJfTUWB6ak8+frWq6wx5M2xEP3B1Ag59V1NWmqrfBQDKQVK54Ko5EcIOo4otAwJcBT8+2BU+2Kw3fcrFteTVorlfNi1SEllsWMPJ+v2HfzwYbwKisPzZLvrmpFtuiFuu/gNsafk/V9flzeBpAlx27r/A0LNKtKZ3oMB8/+lQwplvO3IKyDwU14aJJ1taUdxhwh0NZrM6bgP9x1lEBDTOUdbUwNnZIRv/MRRao5WrVsQBqBgexE/37kGdjg7UJUWI+q8PNlCZFvjaJl7czk4infB52w58FhRdwblfv+eibAfSyiosKYKZ34IE50E42c4HFu37F2EfCn2joLWJJVW9pZN1P6DyJicQZOJDj3lLw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB2229.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(38100700002)(6506007)(26005)(66946007)(76116006)(55016002)(86362001)(110136005)(316002)(186003)(122000001)(53546011)(83380400001)(5660300002)(52536014)(4744005)(2906002)(921005)(64756008)(71200400001)(33656002)(8676002)(6636002)(7696005)(66476007)(38070700005)(7416002)(66556008)(478600001)(8936002)(66446008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGxaMzFoSVJrUlA5Zm5MbDRNMXU2TjBrMXVOdEgrNm1SaGpEa2NLVXdGZXdN?=
 =?utf-8?B?cFFhK2ZiMFpaY2RMckZldmhRdnhOVTdvUCtkZlF2RHM0TENXdWRaejIrL3pQ?=
 =?utf-8?B?SnN1d0tTa2dEeTN6b2NRTkpZQkN0eEUwRnZUYVNrbTRGSDQrS2QyMWM0OFIz?=
 =?utf-8?B?SjNraHN4M3Z2NHh6eXluZ0wwbFpjeHFWd29xU3dTaVhwaW1BcDNLQmxMU0Jn?=
 =?utf-8?B?Q0xaRWRDK2hOeDd2OTROL0MyL1MzbXN1b0hNYnZWWHZ0SnV4Y1FXVHI0cXJa?=
 =?utf-8?B?b0FPNVptNjNHZ05pOFhqb0I3QXBWYWNNb0xsT0p6anZtUnpmWlpuZ0REd0NI?=
 =?utf-8?B?V2dOVCtOdXlmTFpscG12dnlOdS8vN0p5SmlsY2xiVWR6SU54YTFpRkdqV25p?=
 =?utf-8?B?T0s4cWdPTXV4Y3Z5eGlJT2I0dkdsNk1KN1dNSUdLYVlpZU5MYkgvUnNjVS95?=
 =?utf-8?B?S3lzSHRoQUJNN1dXa1paRngxeHlWM2Y0UWg1SnJTMEVOQ3dqbnUrTzczaDZE?=
 =?utf-8?B?VVFpNzJjQnNVZTY5SUVQczBMTEt6TGhHb1JhTTArbHFITVk5VnRlN285NW8z?=
 =?utf-8?B?WTJ4aHpubVlIL2RRS1paVnV1RHZMMUNDSjQ1SmdGZzIyQUJwUHh3eGk5ZGZr?=
 =?utf-8?B?Y2VwMi9RbXdxTnB6SFR5bVdEWEQxaEYvUHdUaVVmUk1LZ25IZEFGZm9EVkN2?=
 =?utf-8?B?ZjBMWC92cityQlBKN1hoWjd1ejdMTk9sYVpHQmRLcm1odTdwQ0N6eDM0a0Mz?=
 =?utf-8?B?aUp3NDEybitPMWE0UnFSRHNOc0syMllmRi81R3g1VVpOYnRZdGxuU0h0bjd0?=
 =?utf-8?B?T0FMeFlHbm4wNnh3WmErQWwvOUIwN1pJOUFSeXZWenBxVnBKSTMyM21rMjR4?=
 =?utf-8?B?N0J4Mno3STdRSCs2ZnVxeHFiNVN3cE5IaWxIbllxL05MTjZCZHcyY0txd1FG?=
 =?utf-8?B?MVYrdit0UDJwS21VNnMrV2FlSEltbDFVZXBkc2U1Q1JyTklGUUdqMnl0aFkx?=
 =?utf-8?B?R1lpcnk0MDR6ZExaOC9MdWp2eXdERzdYR0plYUlXc2h3RDRqU0NQWk4yTUFQ?=
 =?utf-8?B?RFk5OXYrdzhoYXhORVRLSW5ZU2QyUWx6aU1yUjV3NTFSQmFZZUxFemIvNFdF?=
 =?utf-8?B?MEZXQTVCWEZOU1VCRmxuNzY3NFh0Z3pTdndockRBcDRQM3lEZnFZb2o2TVNH?=
 =?utf-8?B?Q2ZRTHlZNXZGU0l4Z2pWanVueElvcWswSnVjK0xGaGFHV0JsY2luUDZhVnpp?=
 =?utf-8?B?VWFNWlJ1MXhqSkt3UHJoS3JINzdpVURQSHVMYjhHRHM5Q2pGeXY4NUwySHFu?=
 =?utf-8?B?Mk50eEhFcHVDMnhiRE83R3FWbk1ZbkxseTdrSXJoU0ErMzhKY2w4WkhIM29h?=
 =?utf-8?B?RUFndW9DcHZvd2QvMzRDejBzWDJSOGJ5R3RBalRUL1lDTDhZeng1VUg1WWpB?=
 =?utf-8?B?K2VCUmttNUxvVVpxTDFJME82OUp2YmVGQVdDUVN3MUNNR1BlREVzcFVqNW5v?=
 =?utf-8?B?OGsza0owMFlIdkNDMjFKT0VlcmJ3UkJtcDlvUlp1dTM3c2MrUjdKQVpwV3BH?=
 =?utf-8?B?MXBlZXByZVBLTFdlZjN6RXhxTEU5RUZsdStIUDJDODg2dENqdk13WlVWRFp6?=
 =?utf-8?B?UzJHWWZIZ0NvQ0htRit5RWhHbG9BVmt2WHhOVWhtaGY1OW5scnFxRlkyc281?=
 =?utf-8?B?bHhienlYLzRHdHI2RWlNdGZqelVvaUNTVTRFK0FzWkI5SFhUZnc4SlJyRXgw?=
 =?utf-8?Q?IK1B9+/Mu9hhvAvNzCTQ4i4FkQNX0qoDtYMCmrb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR18MB2229.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea9d8f0-8dc2-4803-5c27-08d955ab7e71
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 11:48:49.6783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xh+CnQuAw+NWVxThFfspU8pJqt61ZgK8kaqMWa3tJAQ45fANE/cEpFTPpDuqaONvnmEI2CU8ZJvKEYhnwMIrjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3051
X-Proofpoint-GUID: yN7tE8EKp8z8Yd619oRit2rBj8VJbANq
X-Proofpoint-ORIG-GUID: eY7z8WtprD-qoU_wbMFvil-engEn-YNN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-02_05:2021-08-02,2021-08-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJpbGwgV2VuZGxpbmcgPG1v
cmJvQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjcsIDIwMjEgMTo0OSBBTQ0K
PiBUbzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgbGludXgtDQo+IHNjc2lAdmdlci5rZXJuZWwub3JnOyBjbGFuZy1idWlsdC1saW51eEBnb29n
bGVncm91cHMuY29tOyBOYXRoYW4gQ2hhbmNlbGxvcg0KPiA8bmF0aGFuQGtlcm5lbC5vcmc+OyBO
aWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xlLmNvbT47IEFyaWVsIEVsaW9yDQo+
IDxhZWxpb3JAbWFydmVsbC5jb20+OyBTdWRhcnNhbmEgUmVkZHkgS2FsbHVydSA8c2thbGx1cnVA
bWFydmVsbC5jb20+OyBHUi0NCj4gZXZlcmVzdC1saW51eC1sMiA8R1ItZXZlcmVzdC1saW51eC1s
MkBtYXJ2ZWxsLmNvbT47IERhdmlkIFMgLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
OyBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPjsgR1ItUUxvZ2ljLQ0KPiBTdG9y
YWdlLVVwc3RyZWFtIDxHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbT47IEph
bWVzIEUgLiBKIC4NCj4gQm90dG9tbGV5IDxqZWpiQGxpbnV4LmlibS5jb20+OyBNYXJ0aW4gSyAu
IFBldGVyc2VuDQo+IDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gQ2M6IEJpbGwgV2Vu
ZGxpbmcgPG1vcmJvQGdvb2dsZS5jb20+DQo+IFN1YmplY3Q6IFtFWFRdIFtQQVRDSCB2MiAyLzNd
IGJueDJ4OiByZW1vdmUgdW51c2VkIHZhcmlhYmxlICdjdXJfZGF0YV9vZmZzZXQnDQo+IA0KPiBG
aXggdGhlIGNsYW5nIGJ1aWxkIHdhcm5pbmc6DQo+IA0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2Jyb2FkY29tL2JueDJ4L2JueDJ4X3NyaW92LmM6MTg2MjoxMzogZXJyb3I6IHZhcmlhYmxlDQo+
ICdjdXJfZGF0YV9vZmZzZXQnIHNldCBidXQgbm90IHVzZWQgWy1XZXJyb3IsLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZV0NCj4gICAgICAgICBkbWFfYWRkcl90IGN1cl9kYXRhX29mZnNldDsNCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEJpbGwgV2VuZGxpbmcgPG1vcmJvQGdvb2dsZS5jb20+DQo+IC0t
LQ0KDQpBY2tlZC1ieTogUHJhYmhha2FyIEt1c2h3YWhhIDxwa3VzaHdhaGFAbWFydmVsbC5jb20+
DQoNCg0K
