Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88C840AA0D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhINI72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:59:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22846 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229656AbhINI71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:59:27 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E8gfVG017980;
        Tue, 14 Sep 2021 08:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qoFonkgEGVlyYBCmC1aKpY218+3mTWU468b4HHy3dFg=;
 b=fkwwoQFtXlKUzXbSVekL3tdxeKrf11eQmjpsVDIlfbPwI9qkF0pru05ceYVZepS9W3Fn
 UtGO/8MecMNnXg2j6zEfYsPuIBudh+ozm+daPGYlqZstyBlJFxy/OBD0oeFK8sKdcE+M
 BLo0ONlODH29GAfAXw+UkpvVrYKH7tKTGBA1TC3S4bY8aj48xmDbMXeEz+srzEC/Shac
 3oTTPGELi5umwb/zJJkClWUA9f6ciKndTEyCrFjnphxwJDNEwS/5ec5wORLdRlV73cgP
 JZP80+2WOmEtxdxHQBWnUqRAUcl+WeVukyBnmjxGEMHMUV5lP7ZdJA4rw3huGcZsiMYW FA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qoFonkgEGVlyYBCmC1aKpY218+3mTWU468b4HHy3dFg=;
 b=xQALr79OMOjsjfSsfwb5q8J3U4YOhvyL23w85/SR67HWTS3S+7qQNGN87bxFd/5LWspF
 kLu920wws2aYJQM+YCTnno/N6QOlXFG5BxKKAhm000eEpwhKtWq+pkD4kwgNVtS+26DW
 1dZcaFK6tvzSeUHzXPjJA937zP3PGVgafWBlM7zV0p7FFER1G06jh5KhOwde0EFMTnwa
 JyDjLZRTcgHl0q/H8G8ejkfgacZ+/ycwor27T7g26+UvmyqJHFycL5IYDT+BpHdl2tvq
 bO5INam+9kZ/g3GHx4MtkTOmsw9Pm8Sy+xwALB82AjVqaj+EFEsTY24TBcOQAwJJVclN Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2kj5s0sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:58:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E8uMBp140344;
        Tue, 14 Sep 2021 08:58:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3020.oracle.com with ESMTP id 3b0m960c6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuJkihgp6UMt17O8eFr8gamV2N3fRnDHUuwZC2wkz/CoRnYdOjWcLXJQA4WcrJbxHuxS2dLgvK5QtAKFq8Mw94A8uL61cJ2aWiZXhiPGxZF/OzWJgEN4v57V47KH8BS/FJRmYUcEv2K7v5HPmozP+Ywj+Wzlp4ABWJSiyhh1C19yd3cceAeJgWu2YjkoF4UGTcmKjGzNQR6Ln6ZxJVMSktN47OFKqdeVZzvgmV/gq/0cnFpGRaLCJ4oN/IivpE7TrMQS/PwoS1RtTHsPFWph4Ti+q8/Mj3Cu5iqeMcuiE/GcIo2xqrzup6ShQOPNJmFUHCsi1/6qlf8NQsWbaa/5VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qoFonkgEGVlyYBCmC1aKpY218+3mTWU468b4HHy3dFg=;
 b=SjHUkNnndDWWgI56kTVrd60VNlC6SX1UVa2J2nntpmOBPVPIoDBf6qCPy1P9WrqcincMHXlqYItIDpEtaZavvKP3BO8Ip0At0UQJhWz+47XQCwt46kQpDq7WsgW1c/Q5m2sYMtEuOjqRS84boi54eH7euNfBFod2AfHjG1dsg973GjMRVK0XGm4fHcVdgiDaXWbzrpxsPfbjZDJNY70mjXKhI3IhAjZtfPQA3Y5jkpvJOygXhbgdkhQZjVSEdqToehWh9PG/Rmq+mgBkzz+c3PD/PKLTL+qV0nDwFArclBxWjVzqfCZ78SpgpiPqW3HD+0Tvk5boD7wje7cAvVei6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qoFonkgEGVlyYBCmC1aKpY218+3mTWU468b4HHy3dFg=;
 b=h0Kr6s5+pqUyywv3D0JrI77u5f3OWelZBEaBTdPzru1j/qHzJpBtkqwBfH5dRyFDK9lxSIXnq22ZVSEjH7tNod5dPqNuSWyB5OZacitSzj5LpXTeBHL8RKpN5zMxq388o+ElaX1nL54XvwusnHX/vldzNTl/3F4+G62hQ8Mwg24=
Received: from DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17)
 by DS7PR10MB5054.namprd10.prod.outlook.com (2603:10b6:5:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 08:58:00 +0000
Received: from DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489]) by DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489%7]) with mapi id 15.20.4500.018; Tue, 14 Sep 2021
 08:58:00 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux-Net <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: Please add 2dce224f469f ("netns: protect netns ID lookups with
 RCU") to LTS
Thread-Topic: Please add 2dce224f469f ("netns: protect netns ID lookups with
 RCU") to LTS
Thread-Index: AQHXpXwB9uiZyfI9lkyCqWjXsXAVU6ubssmAgAGg04CABFgRgIABlpUA
Date:   Tue, 14 Sep 2021 08:58:00 +0000
Message-ID: <1158D253-0B41-46F5-A1D2-8F49136B3C20@oracle.com>
References: <7F058034-8A2B-4C19-A39E-12B0DB117328@oracle.com>
 <YToMf8zUVNVDCAKX@kroah.com>
 <756E20E4-399D-45ED-AA9A-BB351C865C65@oracle.com>
 <YT8PBf0FiniWR0zm@kroah.com>
In-Reply-To: <YT8PBf0FiniWR0zm@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 502aee69-6570-48b6-ab8f-08d9775dc114
x-ms-traffictypediagnostic: DS7PR10MB5054:
x-microsoft-antispam-prvs: <DS7PR10MB5054795E052675D93B26C578FDDA9@DS7PR10MB5054.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ruw4GZ9tS/iuMYkocVuq8IVQ8jF/dMdgc6IYxA0FuVIWzMtCo/pM5Ar2xsiTlPPf6yPc80PkZ6rVJOuBPzlbcHjcbhNfWh7HUDd3j2bLSXG89edYiSbClqBeZWPzb5UGAVEw+0TOM5QXDPN9B2x3IJz2G3ttWU8EhdYG6fePn70qHAaAkx0jywdx7P0etRiL/djsym1Lv99Gw3PKr9n07URiDsvbvZo3YRx5Ub4uYF8cCiShOSjHS1Z/MtKI17Okvg35pKBsywN+EJ0gM/t9UQrwGFMjZTekyEqmP528vTzsDqdcu0gHGtbiT7z9blhZ1sFiXAByX/0dOv/H9h6vgpMzYwSJr+DOqYAKZHF6LwDLBMaOPPqSeNxzE+1vah5UJsHWk2wTk94yOCfwlWBL7szhEbdRgaZKLXYst19z2oo0t/JSHcxW+DlT6t+HInM/9AVKH0jTslICb5U8vMWEzQccxMffuCa7EKk6ixwyGuJ9XOIHA8dZyn+7zfkWI3K4VFjWLvzjoVYlabjXUJ2xqPXF8rlY/LOC/yHvem+tlEhBwoAIW1tO2oDFuZJqGve5iEsAzZDPgXatO6dgJnCQbrvD0dBxkXi5JZcb2e9K0GUP2x+nYMkmtAlGmNfaS4frdpZa/dYA1vQOaJdYyElHpWtuDmFBNy3shhU3r/ABdJTWwWQUk96HNFGTYhpbQLrSR2tDLY+iuf2LdLwx/Bc6f+ZTuGMJ8uNz45+iFPRfKztIsKD8cGL1G9pMDhc2oZpo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4863.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(376002)(39860400002)(66574015)(83380400001)(6486002)(6506007)(38070700005)(44832011)(6512007)(53546011)(186003)(5660300002)(36756003)(8676002)(38100700002)(2616005)(66946007)(66476007)(64756008)(66556008)(66446008)(54906003)(122000001)(478600001)(8936002)(7416002)(2906002)(316002)(71200400001)(6916009)(91956017)(76116006)(86362001)(33656002)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTFxQzhDeUFCMitUV09rcjByNXpiOFVKTEJXUXI3Qkt0aXF3R1VSeEo4clBx?=
 =?utf-8?B?aFNwbnY3NW5FNGwxVnV6KzVWeGZkaEtTRUhGc0h6NHJXaVdmTlpCUlBRa0NN?=
 =?utf-8?B?S3k5ZktKYSszU0dtRG0xS2lrY1dtNGFOYjZBU08rUEhBbnZiazFGZXQ5NG85?=
 =?utf-8?B?QSsyRGRwSndnMnBMMnF2a1dqUXlnZzhhbFRBeDVKb2hIdnd0YW8zWWd1NDZj?=
 =?utf-8?B?NU1USHNwb3pEMDBxMXprZHVVSHBmV05TT1JSNURUckNyK09FVGVaVjJtd0JC?=
 =?utf-8?B?NFV5OUh4RE5rN2psb2xOdVBxUnhsQmZ4RDZ2VERZLzRHZFFsc3dXWDdIVjdn?=
 =?utf-8?B?VkJQNURlb2dxUituanl5QSt3R3I3YmxRK2dUY2JBeEMzeFp3WkZuMHFiR2Zo?=
 =?utf-8?B?bi9VWUMwMG9OVlovalZJK0VJeHFMbGtUeVJOZGlNRnpkajVaNkF5am90c09h?=
 =?utf-8?B?RTdXdTBLenc5NHpHU3loQ3dYbFdHS2dhcCt1ZHlDemVtdmVEa3Q0WmZrTEV3?=
 =?utf-8?B?ZWs0UW4wSllXWUlWVTJOOVRTbURmZzJwSjV2YmZ0Qi9MMkM5VTZXSHhybVVm?=
 =?utf-8?B?aHFORU9pQ1lxRUtwRVViS3lPU29BV29PaHg1NktBc3pvRm0zZ2ExeG94SGhG?=
 =?utf-8?B?UTBINnJKNis5T1BKRjZpRk54MkphYURNd0lkUFNlenZpUGhHMXU2emlBaURE?=
 =?utf-8?B?clNrZ0JtMGFrYzVHSjdmdlFsMVN2dURNZHRVT0lTVjhUODRjY05nK05vQ0ZU?=
 =?utf-8?B?V055eS9qdHIzL3owSmwwcUp4QkNsTkRwWjF3UDNzUzl3RXVuNFEwSFZ4WXVj?=
 =?utf-8?B?ckY0bytaaythSkFNOXBWM2FMeHpMYzdyZzRucTNFclVsdEhHRXU1YXBGcjU0?=
 =?utf-8?B?NlhPcWJ2b0NCSU9Jcm9IQ2FoMUNYTFIzQnNWSm5TZ0phUTlqd3VZUjZYMkJU?=
 =?utf-8?B?R2ROdy9WYTdWUzdtcS9JYU5QeGdWeVlIeTk1K0FObWZuYTcrQmdvbGtVVzdu?=
 =?utf-8?B?WDc4U2ttSTRscGMvZEFqYW1QcCtMa3IwYk4vWEJEdHdMdGgvR0lITGhxSVNm?=
 =?utf-8?B?OVRWV2xTblh3K0MzQ1NianZRaG9DcVRnenJPbTVzbS9uVXBaV1Y5eWRpNkdU?=
 =?utf-8?B?cm5pb0tVajAzOWFSSUVSeGlzbjVsR3loWXBsVkZ2aGJnUEJkSjhvNDYzbHhw?=
 =?utf-8?B?QTdoNXVRTnpaU045RmRtQXVobGdTUlpidlVEdGVsdkIxaVN1VXNZdUNJTjZO?=
 =?utf-8?B?bStJM1VYQjhBOW1CcG5YUVpaR0ptUWdQa0ZwSmk4ZVFiNHMzVjBzMkNITzVs?=
 =?utf-8?B?WksvMEZ6MFFjRHA4WVJqOE5qUEFyaDFkcFRSNUtFdkR6VHNpRU9NckFFMmVK?=
 =?utf-8?B?MHR5ZFJ4Q0l4a1pJTmJVZGFEZC9JTmVSOUFNemNjU2o1Q3puUmJxVjNZZlNL?=
 =?utf-8?B?SEhDOFMvL3BhNVlQVU5FSzFiNzFJTWhyRUZYem90RGcrLzRBODg0K3IwaDdP?=
 =?utf-8?B?aUZPUDJVRWFLREN3NUJocjNEcWtwRFRma0YwdklMN1JlSlplWW9SR0JqaEJG?=
 =?utf-8?B?bGhQNy9WZHhFTkJqdFlhY2VhRGx0S3hMbHJ6a0ROdkNaTUU0L3podUxFcDNG?=
 =?utf-8?B?SzB5bWtPcFJSTEV3NTRDZXJpKzVqOWZUT3dOTEhZWXYrbVIxaGZMdUdBNDJC?=
 =?utf-8?B?bmpja3NnYkZ5U0sybzhXQzJpcVphamdWR2gxcnZrNHZXckFqNThrS21Sd1pC?=
 =?utf-8?B?b0FSYmxTMTAxSStrbDI3dmYzRGNTMHNiRTcxMDhnTUt2THlRMDdQako3Snd6?=
 =?utf-8?B?d2JWVXl5bWplSER5ZXU1TzlHQUNKcStqRHRYMVQ5VlpKS0JkeENEUTV4Z0lm?=
 =?utf-8?B?UFRrQ2ZCQ21hSVlKV1NGczRpZWkzTEJ6RW5mQWRlT1JVQ2c9PQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4141A463C67A424ABAE386F0F2ACF507@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4863.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502aee69-6570-48b6-ab8f-08d9775dc114
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 08:58:00.3910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sdKUA9QIGfbYUt8QukEQSftloHUQ1nbBjOZO48mcLPdgjWxSyGaVX+k7pDz3KDl17XCpsmoaIt3fExRNR8knTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140054
X-Proofpoint-ORIG-GUID: wzDFAzOh8yc18nLjwijkcp_LxcjifLhT
X-Proofpoint-GUID: wzDFAzOh8yc18nLjwijkcp_LxcjifLhT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTMgU2VwIDIwMjEsIGF0IDEwOjQyLCBHcmVnIEtIIDxncmVna2hAbGludXhmb3Vu
ZGF0aW9uLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIFNlcCAxMCwgMjAyMSBhdCAwMjoyMjoz
MlBNICswMDAwLCBIYWFrb24gQnVnZ2Ugd3JvdGU6DQo+PiANCj4+IA0KPj4+IE9uIDkgU2VwIDIw
MjEsIGF0IDE1OjMwLCBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6
DQo+Pj4gDQo+Pj4gT24gVGh1LCBTZXAgMDksIDIwMjEgYXQgMDE6MTA6MDVQTSArMDAwMCwgSGFh
a29uIEJ1Z2dlIHdyb3RlOg0KPj4+PiBIaSBHcmVnICYgU2FzaGEsDQo+Pj4+IA0KPj4+PiANCj4+
Pj4gdGw7ZHI6IFBsZWFzZSBhZGQgMmRjZTIyNGY0NjlmICgibmV0bnM6IHByb3RlY3QgbmV0bnMg
SUQgbG9va3VwcyB3aXRoDQo+Pj4+IFJDVSIpIHRvIHRoZSBzdGFibGUgcmVsZWFzZXMgZnJvbSB2
NS40IGFuZCBvbGRlci4gSXQgZml4ZXMgYQ0KPj4+PiBzcGluX3VubG9ja19iaCgpIGluIHBlZXJu
ZXQyaWQoKSBjYWxsZWQgd2l0aCBJUlFzIG9mZi4gSSB0aGluayB0aGlzDQo+Pj4+IG5lYXQgc2lk
ZS1lZmZlY3Qgb2YgY29tbWl0IDJkY2UyMjRmNDY5ZiB3YXMgcXVpdGUgdW4taW50ZW50aW9uYWws
DQo+Pj4+IGhlbmNlIG5vIEZpeGVzOiB0YWcgb3IgQ0M6IHN0YWJsZS4NCj4+PiANCj4+PiBQbGVh
c2UgcHJvdmlkZSBhIHdvcmtpbmcgYmFja3BvcnQgZm9yIGFsbCBvZiB0aGUgcmVsZXZhbnQga2Vy
bmVsDQo+Pj4gdmVyaXNvbnMsIGFzIGl0IGRvZXMgbm90IGFwcGx5IGNsZWFubHkgb24gaXQncyBv
d24uDQo+PiANCj4+IEkndmUgZG9uZSB0aGUgYmFja3BvcnRzLiA0LjkgaXMgYWN0dWFsbHkgbm90
IG5lZWRlZCwgYmVjYXVzZSBpdCB1c2VzIHNwaW5fe2xvY2ssdW5sb2NrfV9pcnFzYXZlKCkgaW4g
cGVlcm5ldDJpZCgpLiBIZW5jZSwgd2UgaGF2ZSBhbiAib2ZmZW5kaW5nIiBjb21taXQgd2hpY2gg
dGhpcyBvbmUgZml4ZXM6DQo+PiANCj4+IGZiYTE0M2M2NmFiYiAoIm5ldG5zOiBhdm9pZCBkaXNh
YmxpbmcgaXJxIGZvciBuZXRucyBpZCIpDQo+PiANCj4+IFdpbGwgZ2V0J20gb3V0IGR1cmluZyB0
aGUgd2Vla2VuZC4NCj4gDQo+IEFsbCBub3cgcXVldWVkIHVwLCB0aGFua3MuDQoNClRoYW5rcyBm
b3IgaGVscGluZyBtZSBvdXQgaGVyZSwgR3JlZyENCg0KDQpBcHByZWNpYXRlZCwgSMOla29uDQoN
Cj4gDQo+IGdyZWcgay1oDQoNCg==
