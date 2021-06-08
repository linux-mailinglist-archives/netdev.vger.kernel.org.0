Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD03A0602
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhFHV3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:29:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12280 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233064AbhFHV3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:29:08 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158LHY8m025944;
        Tue, 8 Jun 2021 21:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YI0EGUrA2LrKVaiJ49PEUdYiAqg1UvgjasXITAFVLZs=;
 b=bMpMb4ke6QRec2HVc53+ry3DMSJT89rT1jcAIm2U3bvRsDeQCwHGNl8woO9R4z5obCM8
 FnpoaF3fQwvbN8fEB1XNXxrXyTTXuarWO92K3/m+YLaTHcsOS65WADuKG/0Cl9PmUbcf
 fRVL1/9OluU0/Sk61GY2tVHc5WKzauLOv/swAMdPfj/e+VkB+0i5GQNxIg6ZGCHxlCc3
 5dKLpLuVNQbOPlgbriVC7uxnDWWn2OjeI6q8VNmLDWxnkhwSVsZrQ+cknxEzJWYfNPMh
 oP5V6J07ZSCbJX/t7FiOBzy4Eg4SCyLqktGNyAFCsnn52Ea0NsemvYoeMa9t1QJQOXHV 6A== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3916m08u73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 21:26:56 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 158LLMbT181049;
        Tue, 8 Jun 2021 21:26:55 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3030.oracle.com with ESMTP id 38yxcv0hf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 21:26:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtErMQZU+yeLSIDwbbTB6z3bzsxCvmGMBhFkApu7YLkP18hJljUJ1ttmBxvddFUKZydRXD48wU6nNmOVy0mZD4NUZjkb8Y6TkzXp/e6LvNEyNHHfHuxZm3u6LrlpweQt4JBIhcl8tmrs4jG2G/zDtRpQScSUHZEFpDAon13A+WfhwJY0MkGnVQmuNXpcXeYecPYOBWWmrXQMuWsbdOUrFb4wpoDJHifSKGAAeLkztgC7vVAj4x2Pq5SA0yuVKmwCY5loUm/u0aIOKn92jyvKKyccJjBIhe2v1uSQgQuof60cHzmh2w14cNGXP10mNlJIcee75FkK20WaqmYaDre5Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI0EGUrA2LrKVaiJ49PEUdYiAqg1UvgjasXITAFVLZs=;
 b=iLN7jyv+R8BYtMJ5kx+OYJX6a+4WYsz/hPAK6VThl78uUlXoX4jEDV1mWgM1l8fR5mO1+7QATWTES6HXOEkB/UVtxhR4ph0I3vZP6gQ4H2fJin5BhaKurSSNi1NfjxvQEtef1oarOpXOzEq5i83EnikbvMJvZAa0A89v9KmquVcDbV5qaMOqQ3lzS7umeJw8jcxg30WWCQmiDSUxJTldHVMu13lV4iaM5Q2dq8KAYTPqWoXS/u5utgXn4l0E3/jecbcoKCgyATGCY/Cza2XqITlahLZNktiRnVb5f14BsIyP/nyZjtYnmFYRofS3/10GC+D5uuirRvCzGLLScZ1xQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI0EGUrA2LrKVaiJ49PEUdYiAqg1UvgjasXITAFVLZs=;
 b=w13Zhp0AthIPyyyARaxwVLrZtg8HqMvLa7tMTcQIEkPJb9956ufmuw6mQutsATNuYdytUpFYp+pw+gLqmk1W4FlyedKoaRiIlCZdHJUpW5G2HYll6UvetudeDJDsDo9ciChhuB2njQMzUyQvtfFHSS4sDb5n5NcoL7aY1PutWfA=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 8 Jun
 2021 21:26:51 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2d8b:b7de:e1ce:dcb1]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2d8b:b7de:e1ce:dcb1%3]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 21:26:51 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Alexander Ahring Oder Aring <aahringo@redhat.com>
CC:     Steve French <smfrench@gmail.com>,
        =?utf-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel@suse.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: quic in-kernel implementation?
Thread-Topic: quic in-kernel implementation?
Thread-Index: AQHXW7FlF80La5jqQ0+1BLKKAcjzR6sIwZGAgACs+YCAAEwOgIAA6AKA
Date:   Tue, 8 Jun 2021 21:26:51 +0000
Message-ID: <59FC50B0-DC25-42A9-9981-F03646BA65A8@oracle.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <87pmwxsjxm.fsf@suse.com>
 <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
 <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
In-Reply-To: <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samba.org; dkim=none (message not signed)
 header.d=none;samba.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e47b5afc-e3a1-4d68-a3fe-08d92ac421b0
x-ms-traffictypediagnostic: BYAPR10MB3383:
x-microsoft-antispam-prvs: <BYAPR10MB338308D7B19D7BE0F4194EBB93379@BYAPR10MB3383.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iuTZBtfOGgnnPZWOIIrNif8/YBf5cqBUvfGKBsjkw6VNjJnryMZSyzzVxuR+IiVZrpTnLjMKiyxAk5cNLt97vFUHbdF2Q6mHPcav6n1ObHVW+g5c2QPQGiIHDa0WnPDfZycT/Htt79FQW9ZgAoI6LXrnRGK+Kxou/SPshwoQPlkCkswAgCm4fl+iVn8S+oSLW/IE+Ms46tUmTen76YZi2QG/LTHHIJ0jQ58IIQMsks7auYuIIm+O1f6AT+ZU/6OMNsvRDsGbg70Bw6iKzlYwoUv78OdrBL4a7xmh7V8xdDrNWgt6GUreAssPxpEKXyojSWJLRnXrkwHxVh/waaszxyl8Fk4jRo+2ULt+gGqgOPphYrDSE2rvOjSU64wHBlrCblfA9YMSMkes707zpvCv2fc2zP/5ziXgVZb1ZC/Nqr/EdswUsWVMX2olncPkF1ZQPmstzE2jpg6ttEU/8IGUTbsy5CnuXUycqTQKtfR5Qvy4SPYnSSw1A9F7NTmZ91lBX+pCNJzCYJAQqy5Orf3qQIukq7FsjA1qH0nfqHT9LR5Q8UNPOpH53KCFzIcF9rE5hyLaWAY5BnDbZ9QjdrEydGhvgkd19HJvKIFEtuz9zwHxZy1inUJ3kbV6bMf0CFB2H3qSxkeXlyb7xTHyEFDLTgIO+RaM+S02aheZb97fXUvzaMdjy13uPrdNwiP2Z4iRYSCt9odsL7mLE0aSLj7FkU2eTyGRsEQz59QUS8omNQP4BlnCfCyiO4vFlfYPIcZ0BqcDckBu793XP39GDmVDTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39840400004)(396003)(366004)(136003)(316002)(110136005)(2906002)(54906003)(86362001)(478600001)(5660300002)(71200400001)(966005)(38100700002)(6506007)(36756003)(53546011)(122000001)(33656002)(6486002)(64756008)(66446008)(3480700007)(186003)(8676002)(8936002)(26005)(4326008)(66476007)(66556008)(91956017)(2616005)(83380400001)(76116006)(6512007)(66946007)(45080400002)(66574015)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3ZJNXlsc2JTRjFYdlpMTU51eU91anFyWXBxOEc2WTRPd0RJZXpTb09OSlJN?=
 =?utf-8?B?djU0MDNHcS8xckgzUDg4ZmZSQVgwNyttV1lwaXFRbmhaQ3NobjA4TmNzMldi?=
 =?utf-8?B?VFRuaXBrd2src1NMSUF5SXZkRDhzdlRsS1g2L2E0cVZxTHNoVEEvc2RyWkxG?=
 =?utf-8?B?M1kzcnE1SWZISnZITVdQU2tvYXpqRWRHQzRZMkswdm1QaHJEVFIyQ0tPeFRj?=
 =?utf-8?B?Wkl4a2dxbkdneVlWNUI4NVBRU2RuelVFa2MxbFNuWnZLU0tOaVJYZEM1ODlm?=
 =?utf-8?B?S21iTWpReGFXY2NmR3h3RU5XbTJ4U0NPdTFrM2FjNFY5YjVVZUt1blZnTFFI?=
 =?utf-8?B?TUJUOWJySXRFUU1tMHBHSFhqTGRQd1dqakYxbWF3Njk4TFNvMzNIUCtlcy9R?=
 =?utf-8?B?S25KTmVKbzhPNnFodHgzSWEyRWlQYlVvQnlRRXVTYzN6ZVRiQ2dJeUdsVDBV?=
 =?utf-8?B?R0hvcTlPU3kvSjJrMnZPWkZWUW9GZ0hkdlJyeTMxUmhFUnllN1JxUGpyY0JU?=
 =?utf-8?B?SmlzZ0FYMHFsMGc1M3UrRzNBeWx5eW1MbEpxUWVvY3dXTmJnZzh6RjNHQWlC?=
 =?utf-8?B?UlQyd1Vna2pIeUIwT2krOVJZZkhpYU16Vno4QkFZYlpkVUxNSEdBcjI1aVkx?=
 =?utf-8?B?dmRDMC9qdzRjY2hNZjhCWlNaazdLSGtBMHZPR1ZFTm11Q0pPc3dySFUzS2t6?=
 =?utf-8?B?cEZ1UjA1Q3hHZVFlZG1YTlNqS3pXc0p4Z0txWStaaHhnbFMvbENPbFN6YlZL?=
 =?utf-8?B?aElwanp6QzB1djBHVGdQWUlGdXNHcENmTFdFcWxlNUdKSlJ0eEhtdEJDc2tR?=
 =?utf-8?B?anlHMWdQVXppSjQ3dG1jZXJSaUFhb1NHZCtWV0pWTnpGMCthTkh0YklzTkYv?=
 =?utf-8?B?OVQ1Z1RYRkZWRFdybXcvVWRIVCtSbFF1ay9XaStzMFZaYnVJczdsd1RhdWNE?=
 =?utf-8?B?SU90dnduUVBGOElkN2M1M0NKKy9McllqWlp6TmltQk9xcGl3UGhEQnUveUxV?=
 =?utf-8?B?NTVjVU5sOHNWYzBIVHJaZTJJMktCSFE2NUg3VGIwUTNwSEh4MXlvOStDT1hv?=
 =?utf-8?B?UmltV0h6eGwwa0s0WWMzbmtsdDZkUFlvclRUMjROM2IwVFpwYUp2eDVKRnhm?=
 =?utf-8?B?dHhTblJ4aWJ5OWhGTjZqVUxnQ1dQL3B2SUFuclkrT1Nkc0tyZVJlWHdmaGk3?=
 =?utf-8?B?aUgrYk5HZ0lPbERFMXV3OUNqdnhZMzg1M3lUNU01N1JZRVY2YlpHSUgweTdO?=
 =?utf-8?B?WUhpMi9CSVR3ZzdFSDdYNTJldHltVFFqR01xcHIrQm1USWx4T21YOWVDUUhs?=
 =?utf-8?B?d2VCa2UwSXVoQTNNYm5hVmdMdXJUZW5mYk5UakJuSVB0NEI1aU03cGRtSmVi?=
 =?utf-8?B?Mi8xYTIvd1FiMlBrVHZ0Q3MvN3I3V1JBYU0vWXhCMzdXdTJLZlBTcTFDV1Ni?=
 =?utf-8?B?d21VL3BSNW1DcDZuQVcwZk1lT1VWenB1ekNtVjBUWWR1d3A1dnJMYTJFZmNl?=
 =?utf-8?B?a1ZaZ29VK2lUZ3F2ZEtGNlZUYnByK3VzMFQxeUN6eHV1Z1Z0MndmTmc0Nldy?=
 =?utf-8?B?RVMzK1RDUVl0RWZEaDVTU205VmoxZlFaY2dodENBZEYyUTFtK1piY1VhODJs?=
 =?utf-8?B?REpkMk0yaGRFSW91YUE4cHI0djJkMG1zT1o3UDY3eEc3VlhKb1gxSHRRUW1z?=
 =?utf-8?B?dnF3R0NDQm1EWVV5VGVZSXFqeHVmM1RSaFRvazlaMjVjZmZ0NmpBSjdKOXEr?=
 =?utf-8?Q?b2SETeOeqkH7Fs16dXODda7ghOcGVgNBIZujppI?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <37D2FB8074130C40B05A497B4BAD7BC2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e47b5afc-e3a1-4d68-a3fe-08d92ac421b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 21:26:51.5711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: px26PMuNnk8aLY4cgEorTaBsxR377JSWOKMgItV5MlzO4kQ17/ZIWBNaEDqahQPBcRYehrEwv8Lw2wpyLKBoew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080136
X-Proofpoint-ORIG-GUID: c_bJBveZmIRsJlHe2t1vc8ObKV1jwS86
X-Proofpoint-GUID: c_bJBveZmIRsJlHe2t1vc8ObKV1jwS86
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVuIDgsIDIwMjEsIGF0IDM6MzYgQU0sIFN0ZWZhbiBNZXR6bWFjaGVyIDxtZXR6
ZUBzYW1iYS5vcmc+IHdyb3RlOg0KPiANCj4gQW0gMDguMDYuMjEgdW0gMDU6MDQgc2NocmllYiBT
dGV2ZSBGcmVuY2g6DQo+PiBPbiBNb24sIEp1biA3LCAyMDIxIGF0IDExOjQ1IEFNIEF1csOpbGll
biBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPiB3cm90ZToNCj4+PiANCj4+PiBBbGV4YW5kZXIgQWhy
aW5nIE9kZXIgQXJpbmcgPGFhaHJpbmdvQHJlZGhhdC5jb20+IHdyaXRlczoNCj4+Pj4gYXMgSSBu
b3RpY2UgdGhlcmUgZXhpc3RzIHNldmVyYWwgcXVpYyB1c2VyIHNwYWNlIGltcGxlbWVudGF0aW9u
cywgaXMNCj4+Pj4gdGhlcmUgYW55IGludGVyZXN0IG9yIHByb2Nlc3Mgb2YgZG9pbmcgYW4gaW4t
a2VybmVsIGltcGxlbWVudGF0aW9uPyBJDQo+Pj4+IGFtIGFza2luZyBiZWNhdXNlIEkgd291bGQg
bGlrZSB0byB0cnkgb3V0IHF1aWMgd2l0aCBhbiBpbi1rZXJuZWwNCj4+Pj4gYXBwbGljYXRpb24g
cHJvdG9jb2wgbGlrZSBETE0uIEJlc2lkZXMgRExNIEkndmUgaGVhcmQgdGhhdCB0aGUgU01CDQo+
Pj4+IGNvbW11bml0eSBpcyBhbHNvIGludGVyZXN0ZWQgaW50byBzdWNoIGltcGxlbWVudGF0aW9u
Lg0KPj4+IA0KPj4+IFllcyBTTUIgY2FuIHdvcmsgb3ZlciBRVUlDLiBJdCB3b3VsZCBiZSBuaWNl
IGlmIHRoZXJlIHdhcyBhbiBpbi1rZXJuZWwNCj4+PiBpbXBsZW1lbnRhdGlvbiB0aGF0IGNpZnMu
a28gY291bGQgdXNlLiBNYW55IGZpcmV3YWxsIGJsb2NrIHBvcnQgNDQ1DQo+Pj4gKFNNQikgZGVz
cGl0ZSB0aGUgbmV3ZXIgdmVyc2lvbiBvZiB0aGUgcHJvdG9jb2wgbm93IGhhdmluZyBlbmNyeXB0
aW9uLA0KPj4+IHNpZ25pbmcsIGV0Yy4gVXNpbmcgUVVJQyAoVURQIHBvcnQgNDQzKSB3b3VsZCBh
bGxvdyBmb3IgbW9yZSByZWxpYWJsZQ0KPj4+IGNvbm5lY3Rpdml0eSB0byBjbG91ZCBzdG9yYWdl
IGxpa2UgYXp1cmUuDQo+Pj4gDQo+Pj4gVGhlcmUgYXJlIGFscmVhZHkgbXVsdGlwbGUgd2VsbC10
ZXN0ZWQgQyBRVUlDIGltcGxlbWVudGF0aW9uIG91dCB0aGVyZQ0KPj4+IChNaWNyb3NvZnQgb25l
IGZvciBleGFtcGxlLCBoYXMgYSBsb3Qgb2YgZXh0cmEgY29kZSBhbm5vdGF0aW9uIHRvIGFsbG93
DQo+Pj4gZm9yIGRlZXAgc3RhdGljIGFuYWx5c2lzKSBidXQgSSdtIG5vdCBzdXJlIGhvdyB3ZSB3
b3VsZCBnbyBhYm91dCBwb3J0aW5nDQo+Pj4gaXQgdG8gbGludXguDQo+Pj4gDQo+Pj4gaHR0cHM6
Ly9naXRodWIuY29tL21pY3Jvc29mdC9tc3F1aWMNCj4+IA0KPj4gU2luY2UgdGhlIFdpbmRvd3Mg
aW1wbGVtZW50YXRpb24gb2YgU01CMy4xLjEgb3ZlciBRVUlDIGFwcGVhcnMgc3RhYmxlDQo+PiAo
Zm9yIHF1aXRlIGEgd2hpbGUgbm93KSBhbmQgd2VsbCB0ZXN0ZWQsIGFuZCBldmVuIHdpcmVzaGFy
ayBjYW4gbm93IGRlY29kZSBpdCwgYQ0KPj4gcG9zc2libGUgc2VxdWVuY2Ugb2Ygc3RlcHMgaGFz
IGJlZW4gZGlzY3Vzc2VkIHNpbWlsYXIgdG8gdGhlIGJlbG93Og0KPj4gDQo+PiAxKSB1c2luZyBh
IHVzZXJzcGFjZSBwb3J0IG9mIFFVSUMgKGUuZy4gbXNxdWljIHNpbmNlIGlzIG9uZSBvZiB0aGUg
bW9yZSB0ZXN0ZWQNCj4+IHBvcnRzLCBhbmQgYXBwYXJlbnRseSBzaW1pbGFyIHRvIHdoYXQgYWxy
ZWFkeSB3b3JrcyB3ZWxsIGZvciBRVUlDIG9uIFdpbmRvd3MNCj4+IHdpdGggU01CMy4xLjEpIGZp
bmlzaCB1cCB0aGUgU01CMy4xLjEga2VybmVsIHBpZWNlcyBuZWVkZWQgZm9yIHJ1bm5pbmcgb3Zl
cg0KPj4gUVVJQw0KPiANCj4gSW5zdGVhZCBvZiB1c2luZyB1c2Vyc3BhY2UgdXBjYWxscyBkaXJl
Y3RseSwgaXQgd291bGQgYmUgZ3JlYXQgaWYgd2UgY291bGQgaGlkZQ0KPiBiZWhpbmQgYSBmdXNl
LWxpa2Ugc29ja2V0IHR5cGUsIGluIG9yZGVyIHRvIGtlZXAgdGhlIGtlcm5lbCBjaGFuZ2VzIGlu
IGZzL2NpZnMgKGFuZCBvdGhlciBwYXJ0cykNCj4gdGlueSBhbmQganVzdCByZXBsYWNlIHRoZSBz
b2NrZXQoQUZfSU5FVCkgY2FsbCwgYnV0IGNvbnRpbnVlIHRvIHVzZSBhDQo+IHN0cmVhbSBzb2Nr
ZXQgKGxpa2VseSB3aXRoIGEgZmV3IFFVSUMgc3BlY2lmaWMgZ2V0c29ja29wdC9zZXRzb2Nrb3B0
IGNhbGxzKS4NCj4gDQo+IEl0IHdvdWxkIGFsc28gYWxsb3cgdXNlcnNwYWNlIGFwcGxpY2F0aW9u
cyBsaWtlIFNhbWJhJ3Mgc21iY2xpZW50IGFuZCBzbWJkDQo+IHRvIHVzZSBpdCB0aGF0IHdheSB0
b28uDQoNClRoYXQncyBpbnRlcmVzdGluZyBhcyBhIGRldmVsb3BtZW50IHNjYWZmb2xkLg0KDQpI
b3dldmVyLCBJTU8gdGhlIGludGVyZXN0aW5nIHBhcnQgb2YgUVVJQyBmb3IgdXMgaXMgdHJhbnNw
b3J0DQpsYXllciBzZWN1cml0eS4gTkZTIGFscmVhZHkgaGFzIFRMUyB2aWEgUlBDLW92ZXItVExT
LCBhbmQgd2UNCmludGVuZCB0byBoYXZlIGEgZnVsbCBpbi1rZXJuZWwgaW1wbGVtZW50YXRpb24g
c29vbi4gVXNpbmcgYQ0KdXNlci1zcGFjZSB0cmFuc3BvcnQgcHJvdG9jb2wgaW1wbGVtZW50YXRp
b24gaXMgbGlrZWx5IHRvIGJlDQphbiB1bmFjY2VwdGFibGUgc3RlcCBiYWNrd2FyZHMgaW4gdGVy
bXMgb2YgcGVyZm9ybWFuY2UgZm9yIHVzLg0KTkZTIGNvbm5lY3Rpb25zIGFyZSBsb25nLWxpdmVk
LCBubyBiZW5lZml0IGF0IGFsbCBmcm9tIHRoZQ0Kc3BlY2lhbCAwLVJUVCBtZWNoYW5pc21zLg0K
DQpJIGhvcGUgdGhlIGVuZCBnb2FsIGlzIHRvIGhhdmUgYSBmdWxsIGluLWtlcm5lbCBpbXBsZW1l
bnRhdGlvbg0Kb2YgUVVJQyBhdCBzb21lIHBvaW50LCBvdGhlcndpc2UgSSBkb24ndCBzZWUgTGlu
dXggUVVJQyBldmVyDQpiZWluZyBvbiBwYXIgd2l0aCBjdXJyZW50IFRDUCBwZXJmb3JtYW5jZSBm
b3IgYSBrZXJuZWwNCmNvbnN1bWVyLg0KDQoNCj4+IDIpIHRoZW4gc3dpdGNoIGZvY3VzIHRvIHBv
cnRpbmcgYSBzbWFsbGVyIEMgdXNlcnNwYWNlIGltcGxlbWVudGF0aW9uIG9mDQo+PiBRVUlDIHRv
IExpbnV4IChwcm9iYWJseSBub3QgbXNxdWljIHNpbmNlIGl0IGlzIGxhcmdlciBhbmQgZG9lc24n
dA0KPj4gZm9sbG93IGtlcm5lbCBzdHlsZSkNCj4+IHRvIGtlcm5lbCBpbiBmcy9jaWZzICAoc2lu
Y2UgY3VycmVudGx5IFNNQjMuMS4xIGlzIHRoZSBvbmx5IHByb3RvY29sDQo+PiB0aGF0IHVzZXMg
UVVJQywNCj4+IGFuZCB0aGUgV2luZG93cyBzZXJ2ZXIgdGFyZ2V0IGlzIHF1aXRlIHN0YWJsZSBh
bmQgY2FuIGJlIHVzZWQgdG8gdGVzdCBhZ2FpbnN0KT4gMykgdXNlIHRoZSB1c2Vyc3BhY2UgdXBj
YWxsIGV4YW1wbGUgZnJvbSBzdGVwIDEgZm9yDQo+PiBjb21wYXJpc29uL3Rlc3RpbmcvZGVidWdn
aW5nIGV0Yy4NCj4+IHNpbmNlIHdlIGtub3cgdGhlIHVzZXJzcGFjZSB2ZXJzaW9uIGlzIHN0YWJs
ZQ0KPiANCj4gV2l0aCBoYXZpbmcgdGhlIGZ1c2UtbGlrZSBzb2NrZXQgYmVmb3JlIGl0IHNob3Vs
ZCBiZSB0cml2aWFsIHRvIHN3aXRjaA0KPiBiZXR3ZWVuIHRoZSBpbXBsZW1lbnRhdGlvbnMuDQoN
CkFsdGhvdWdoIHN3aXRjaGluZyBRVUlDIGltcGxlbWVudGF0aW9ucyBpcyBhIGNvb2wgdHJpY2sg
Zm9yDQpyYXBpZCBwcm90b3R5cGluZywgSSdtIHVuY2xlYXIgb24gdGhlIGV2ZW50dWFsIHVzZXIg
YmVuZWZpdA0Kb2YgaXQuDQoNCg0KPj4gNCkgT25jZSBTTUIzLjEuMSBvdmVyIFFVSUMgaXMgbm8g
bG9uZ2VyIGV4cGVyaW1lbnRhbCwgcmVtb3ZlLCBhbmQNCj4+IHdlIGFyZSBjb252aW5jZWQgaXQg
KGtlcm5lbCBRVUlDIHBvcnQpIHdvcmtzIHdlbGwgd2l0aCBTTUIzLjEuMQ0KPj4gdG8gc2VydmVy
cyB3aGljaCBzdXBwb3J0IFFVSUMsIHRoZW4gbW92ZSB0aGUgcXVpYyBjb2RlIGZyb20gZnMvY2lm
cyB0byB0aGUgL25ldA0KPj4gdHJlZQ0KPiANCj4gVGhlIDR0aCBzdGVwIHdvdWxkIHRoZW4gZmlu
YWxseSBhbGxvY2F0ZSBhIHN0YWJsZSBQRl9RVUlDIHdoaWNoIHdvdWxkIGJlDQo+IEFCSSBzdGFi
bGUuDQo+IA0KPiBtZXR6ZQ0KDQotLQ0KQ2h1Y2sgTGV2ZXINCg0KDQoNCg==
