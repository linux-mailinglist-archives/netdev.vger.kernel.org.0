Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D592CE4A1
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgLDAz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:55:57 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726301AbgLDAz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:55:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B40pjM3019464;
        Thu, 3 Dec 2020 16:54:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=m6eO/hFVA2YpDNjX/QhlZNEXqMq7TJmb+zciqwtBOP8=;
 b=FtPX0fI8j7ymBNZypLmV9sO32F53lkGthigLvZXnGp4h1QolfPtWTKtVveTGsD17V5v9
 vep29u8z3IWshao9OCUhvHkTT1zjjz+cxWNUymuvVZ6KlbP+wwaewJ85kSnv/0nZ4zwu
 jc1nuwOcLmxyHME0XPCCDJnrLT4/cClCVRNX8NEIHb5x+g6typPOO5fjaLB30W5olUmo
 iHmSJed8jGmFMi8rGLiqmuuDFu9AsYXdx9D1jOpPD6qqGzbO4f4q+2S5/askYoGPI/Q8
 HirayU50JF1GDAWmgW5DaSkZyb3h9w4sTY10cRPcyvmmLkPKmv3zQKWKj+XFDYSmPBbO TQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jfeewb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 16:54:32 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 16:54:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Dec 2020 16:54:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuBnRfdTttQZdwl3XHI5qGWZFw5KFocI8k2h5bhj7JxWA3QxCM0uW2+BLA0h2NdaMJanCWuzbUcYW58wv7kyu7LRDXSwWkAvF7Se1BF/LEaiLALtug0A7VH5K0p701qEwL6eayLORai9vhG/wUxlqpgqb7dCN0upp5AudObg18tiQUIJmysU3mxiHL6u2eDsnDILvuJ8JAJSamCQCroHZ6qa3tVw/wbqruJSkj2mrvb0w9TIKpviqC5PvA/pk+jnXhc0Iu16s9Du79oNpgyAE86urU8ohY/rnh6giA3HNE97k8BByWFEAZfz2+i64/OBnD0/v4J35bLwfrVPLOxGgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6eO/hFVA2YpDNjX/QhlZNEXqMq7TJmb+zciqwtBOP8=;
 b=FZJBdCeVuwKI0NyE4VwCveKcMSanMxZggMK06ow5bTOcBB/VTNpiSqMPgGeKNB217Qjm2bdwAVf+euBriNfLsMaIRPJ45y9xAfT6shRPK+oDzcH71nLx6gd5vvLPT3msaYgg4p3QFEUJou+pTFMG7vNJIHDqYuJrZlqXN1wfJ5pPvWe8dlf7hDVf7ngq3oDdmTKMef5eRDwVpPZWUIA7zCLUZLO+M4PBXwM7S/iL3YdFL9BjbWFgDa2BlPSmE7TXm7nK4JX0Whd28x4Mz7uKVHyuWMzaH3kxNjJGjAbcJ+JlPGaO4KBT7ktKsfUGRUdfUptq2tvuqucqpOYWPl69sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6eO/hFVA2YpDNjX/QhlZNEXqMq7TJmb+zciqwtBOP8=;
 b=Rcw9gQtmUPOfir+ZmHtVOXVDQsr6bCt8gt534taRNYBWovJON8d1PcQQ1Oy6FX+uhylJpixNA/kdO16m51bpqueq9BUm9Xqv5sjnXEagHijBkyHcnqKHthxjpT6PQ/JQcuInUNVxpHDetH+/z+EOIqSOPut1wrBJkm6drHQ4u9c=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB1967.namprd18.prod.outlook.com (2603:10b6:301:63::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 00:54:30 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::24e2:8566:bf62:b363%6]) with mapi id 15.20.3632.020; Fri, 4 Dec 2020
 00:54:30 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "mark.rutland@arm.com" <mark.rutland@arm.com>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 7/9] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Thread-Topic: [EXT] Re: [PATCH v5 7/9] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Thread-Index: AQHWwcI7UCf8Z8jL1UuRW32Ea/eUhKnj6RKAgAJDc4A=
Date:   Fri, 4 Dec 2020 00:54:29 +0000
Message-ID: <0c56e388c18187874ff23167d6927fed97e106b7.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
         <76ed0b222d2f16fb5aebd144ac0222a7f3b87fa1.camel@marvell.com>
         <20201202142033.GD66958@C02TD0UTHF1T.local>
In-Reply-To: <20201202142033.GD66958@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34a97b3b-038c-4e28-af9b-08d897ef283f
x-ms-traffictypediagnostic: MWHPR1801MB1967:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB19670D5955E249030603C59EBCF10@MWHPR1801MB1967.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: knkNgc1zUHPYsPZWUnVzGpUesG7/TyAKY8FizbNteLBMZmKRqMxI7CB2Wzsg809m0X7bJjn//kObbXTmuzG1xDYRgfAYq0CwOygnztoQ/YfUkNYhVzyZfwsy1lW0UCMXwYmC2R1M3uUWBXNYRO2h4TiywAYE0SJCGvzLNfW2lor7Got/dIi8kSIqoLz3CN+qa9HysKLrSuiRavmArjDUekX7AU5NaiXNMaz3GPlCbvz/kO3ug2+IclgJjo4+RD2kEeu9xIhPyPZG7WPqaClHtxDlnKmHYmNgS903EWISY1HXFWBFM6VXEQeQI95HG0eG2xgYmYbkshw/GcW2dGfAGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(6512007)(66556008)(66946007)(64756008)(6916009)(5660300002)(36756003)(6506007)(83380400001)(86362001)(91956017)(2616005)(186003)(26005)(66476007)(4326008)(316002)(71200400001)(66446008)(6486002)(8936002)(478600001)(7416002)(8676002)(76116006)(54906003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RXdEM3h1WVNxV3RMZ3B2d015MUFXVkhtZ0t0aXBtNVZoQmJBQ3hNRWgzZ1RE?=
 =?utf-8?B?NmJ6Qi9BWVpFNDZtT2dIdEwrV2pjUjVHQUtFdDhrSVhyd3ZkdC9NSTJseFdp?=
 =?utf-8?B?WGZpUkM2UFVuT0QzbHVTSlNBVXNWd1VUU0dOYkZUdHVOR0Vubys5NS9yQjBm?=
 =?utf-8?B?a2t6b1pjN1ZBaEIzZjFOcEhTckZqN1ovVDN3clpZYkRDbFVCcDhncnBML2VO?=
 =?utf-8?B?WXJMY1ZhVVZvb2Y0blI1ejE4STVoamxUenlEMFZUYWRUenJVK0dBQjNBb2I2?=
 =?utf-8?B?VkhBSnFRcjl3WUFpRENoNVNyR1phWVZPZWRzandPSit6a3NUSmZyRmJRcmRW?=
 =?utf-8?B?bHlCeWFZT2FFcU94Q1EzUXFvWksvazRBWGFoUDg4akJ3NTdwakc0SUhyYVFx?=
 =?utf-8?B?QUdjWERsdy92YVcyTEs4M2lVYmV6M01FUVkxcTExT05sME1kd3ZhR3VjRHFh?=
 =?utf-8?B?SG9QVFZrTzdyejQrYVNMNDdOZDhwTXJZdWJNc1BxYkJIOUg2TDFPYnJqM0lT?=
 =?utf-8?B?UmpFUzR5eHREbWdOTmhZNVpvNGtZWHZEU0h0ZmNkY09mdXhLZm44UGpJaVQx?=
 =?utf-8?B?eVFsVFVxOXNFVDl1V3QyVUhoaWZUNTVwWjN0ZG5DOUtML0d5aFQzMCtjemdh?=
 =?utf-8?B?bmdnTmFGcmhGNENrRk94TEcrSlkvaWJpS0VGY3MwamM0TVRSQkgvZU5veTlq?=
 =?utf-8?B?YVA2T29CcndubXkwcTRvbzJMdkhWenYrMFBMNUp4WGtLY3h2UHE4bXF2SW15?=
 =?utf-8?B?V0doQTAyZENZd0wyckpSYWpiWGh2UkIvVjBJZ0huMEJDSkhqemo1ZEViUFh1?=
 =?utf-8?B?LytVRS81cHQxMmpNdDFRSiswL0F1SlR5S1dEV1VXMnR2WElXYURqMnJGMWZD?=
 =?utf-8?B?a3hRSlhCa21OemdxY29lbGU1MEh2N1JpT0ZEYjZMZUw0cmxtWmFYTmF0Z3k1?=
 =?utf-8?B?SWZlbkNvODRDOEdJN1NuU0hENjNuSHJ3OGF2V0h4N3FPSXVLNmM0ak5nQk1J?=
 =?utf-8?B?YlR1a3BzNVVuQUg3UTlGVW5xOGNNQnNINU05OGI2ZXZQQ2N2RUh4YzJqdkxI?=
 =?utf-8?B?cC8rNGVyblY4ZnBhUTRPU1JDS09SWGUrcGZmaUNqS2JOWEhCYjVQOHBXVVp1?=
 =?utf-8?B?UVJUOFM0L2M4aVEzMCtJazVkU3VZT3ZldFEweU9sdHJuZVU3bStpRHJwNU9B?=
 =?utf-8?B?YTMycEVDSG9XR1o5cDl4YjA2ZURYd3ZSOE93YkdLczdHd010NTg5SWNWUVBj?=
 =?utf-8?B?NmhJbDd2ZHJleFVhTGpLclRKOElvZTJxR1BtQkR0Ukt0eFl4MFdEYmNyeExP?=
 =?utf-8?Q?9NIHyHJzrZgSm4tDdPIOMM/NHV5nBcBaPE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6657F20FD545E340B4845A5BDC34EF8D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a97b3b-038c-4e28-af9b-08d897ef283f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 00:54:29.9386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NQJoS6rPR9guKEVqFKSPFpqOypfL9UNmyzX+udkTYRI6rYdNvqflPNGSfzBN3OEbC9TaIUXeZUOnavYZCrR80w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1967
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQsIDIwMjAtMTItMDIgYXQgMTQ6MjAgKzAwMDAsIE1hcmsgUnV0bGFuZCB3cm90ZToN
Cj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gLS0tDQo+IE9uIE1vbiwgTm92
IDIzLCAyMDIwIGF0IDA1OjU4OjIyUE0gKzAwMDAsIEFsZXggQmVsaXRzIHdyb3RlOg0KPiA+IEZy
b206IFl1cmkgTm9yb3YgPHlub3JvdkBtYXJ2ZWxsLmNvbT4NCj4gPiANCj4gPiBGb3Igbm9oel9m
dWxsIENQVXMgdGhlIGRlc2lyYWJsZSBiZWhhdmlvciBpcyB0byByZWNlaXZlIGludGVycnVwdHMN
Cj4gPiBnZW5lcmF0ZWQgYnkgdGlja19ub2h6X2Z1bGxfa2lja19jcHUoKS4gQnV0IGZvciBoYXJk
IGlzb2xhdGlvbiBpdCdzDQo+ID4gb2J2aW91c2x5IG5vdCBkZXNpcmFibGUgYmVjYXVzZSBpdCBi
cmVha3MgaXNvbGF0aW9uLg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBjaGVjayBmb3IgaXQu
DQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29t
Pg0KPiA+IFthYmVsaXRzQG1hcnZlbGwuY29tOiB1cGRhdGVkLCBvbmx5IGV4Y2x1ZGUgQ1BVcyBy
dW5uaW5nIGlzb2xhdGVkDQo+ID4gdGFza3NdDQo+ID4gU2lnbmVkLW9mZi1ieTogQWxleCBCZWxp
dHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQo+ID4gLS0tDQo+ID4gIGtlcm5lbC90aW1lL3RpY2st
c2NoZWQuYyB8IDQgKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL3RpY2stc2No
ZWQuYyBiL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KPiA+IGluZGV4IGEyMTM5NTI1NDFkYi4u
NmM4Njc5ZTIwMGYwIDEwMDY0NA0KPiA+IC0tLSBhL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0K
PiA+ICsrKyBiL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KPiA+IEBAIC0yMCw2ICsyMCw3IEBA
DQo+ID4gICNpbmNsdWRlIDxsaW51eC9zY2hlZC9jbG9jay5oPg0KPiA+ICAjaW5jbHVkZSA8bGlu
dXgvc2NoZWQvc3RhdC5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvc2NoZWQvbm9oei5oPg0KPiA+
ICsjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9tb2R1
bGUuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L2lycV93b3JrLmg+DQo+ID4gICNpbmNsdWRlIDxs
aW51eC9wb3NpeC10aW1lcnMuaD4NCj4gPiBAQCAtMjY4LDcgKzI2OSw4IEBAIHN0YXRpYyB2b2lk
IHRpY2tfbm9oel9mdWxsX2tpY2sodm9pZCkNCj4gPiAgICovDQo+ID4gIHZvaWQgdGlja19ub2h6
X2Z1bGxfa2lja19jcHUoaW50IGNwdSkNCj4gPiAgew0KPiA+IC0JaWYgKCF0aWNrX25vaHpfZnVs
bF9jcHUoY3B1KSkNCj4gPiArCXNtcF9ybWIoKTsNCj4gDQo+IFdoYXQgZG9lcyB0aGlzIGJhcnJp
ZXIgcGFpciB3aXRoPyBUaGUgY29tbWl0IG1lc3NhZ2UgZG9lc24ndCBtZW50aW9uDQo+IGl0LA0K
PiBhbmQgaXQncyBub3QgY2xlYXIgaW4tY29udGV4dC4NCg0KV2l0aCBiYXJyaWVycyBpbiB0YXNr
X2lzb2xhdGlvbl9rZXJuZWxfZW50ZXIoKQ0KYW5kIHRhc2tfaXNvbGF0aW9uX2V4aXRfdG9fdXNl
cl9tb2RlKCkuDQoNCi0tIA0KQWxleA0K
