Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD19126581
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLSPRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:17:32 -0500
Received: from mx0a-00273201.pphosted.com ([208.84.65.16]:12046 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726712AbfLSPRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:17:32 -0500
X-Greylist: delayed 1592 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2019 10:17:31 EST
Received: from pps.filterd (m0108157.ppops.net [127.0.0.1])
        by mx0a-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJElol7001686;
        Thu, 19 Dec 2019 06:50:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=PPS1017;
 bh=q9wl/knsR99XFzHQWCD+N4W4k9bf+GW0SMCVDJuc19Y=;
 b=r3G/CBtmIIgvg80gIRoa3CCCh6VqBx9jzEI8TsosNWW8GJpCaqPzJ84dIzSkf5/wD3AF
 Iuxm5A4BUV8PHEHx6SBpVDurCNubFdqYUkov5ubIRoBHgeMU0vYq2PmUUFHRToJ9zjA2
 NwpSgFscB1xlc+J70MOLiLL4psLsdtSFDubSGnfFDCw6xqGbyZKZzTjmsp0WraRCb1ry
 zeVYD2H+ieoXkyIm5rWaMJ78dpmAjK7tzF8zOHaEBXi+Ti2vBWwMq6Evb6KZnZSlIEPC
 TzGH/jYpu/Y0EVAcrA76jScY8CJJUgWQenQzjVkRuo79nL9QCatyRJ88CxCl26G8niES SQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00273201.pphosted.com with ESMTP id 2wypsx1wf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 06:50:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGuCR7ulJyIZ/tLsXt11vERLvdffbyY+hABa0yUFcUK9mE70Jbt+8Iw3iGQDUsbLJzEAyh6eMNNY9u/6EsbJIRGxSTjNC8wQkSmKAIp34yNB5vBsWKQGlMqYl8HIcWCKxD00Euqo1J3VFjLe8/AYDuinGOWrI+H9LHJV8evOboAl4RO4nWtIx0ASgEdFr73AY3s8ivEufFLwVeFeQCM+YNwdUni4LBimvFO9sxupDsQbdrEPGz/s0sR/DgFpSoVLNkimyDWULuugDThfvmXoDzD+TYXOgNmuBjRCtR+a8IrYtvQZZjkL1m9QmqrjSso0zt97yYc6UreehWn6ZvN21A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9wl/knsR99XFzHQWCD+N4W4k9bf+GW0SMCVDJuc19Y=;
 b=En6X6BWd/5c8Qoh1BclT4mWFUZDjhBvOS+Hx/LyLgQiKcHbzRYotWIqXghxz5oMkZVVbE7Iiy/JUqqhy4kx1qbbJcmRLoZCzMtJm8+2gFecT2JXsmeLdup7QyM+YFlC7PsCnV4pN9f5nwSeUi/1oGaKDLAt6R+4mZLxDwPINB9uoKZismHfauj92NUtnP0lEOd787gLXARXE48y0mdP1TmFqYoE3j1vI80PjgDmi7lMXEScblBiw7i4nig9LHRDazXBillBGnE8HVAJp1/61IgiFJIn38Nbfb5STm18YwngYQXq1OD5k3RS7ya5IeoAm5KdEpiFLD8u1sAb/pCd9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9wl/knsR99XFzHQWCD+N4W4k9bf+GW0SMCVDJuc19Y=;
 b=Vl1fvC9E6AQcNwdCwSwb0axoPZgPqiYCHV8My4enXC260G7Eq5v7Xs2O41GoD7BO38iBScxCM5cKHF+X7nfhYvgNGdkfZ631tf6YAi6S37le2/+oHLdIvD8h0c/3kA74l5kBsgy6Qgrm264+U4EAb1bLbZlc+ZAnrELVTidT7oY=
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com (52.132.99.143) by
 CY4PR0501MB3844.namprd05.prod.outlook.com (52.132.98.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.12; Thu, 19 Dec 2019 14:50:42 +0000
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47]) by CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47%7]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 14:50:42 +0000
From:   Edwin Peer <epeer@juniper.net>
To:     Y Song <ys114321@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Thread-Topic: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Thread-Index: AQHVtgy6x2wMuQ42JECcwOBV53W8TKfBDSIA///4BwA=
Date:   Thu, 19 Dec 2019 14:50:42 +0000
Message-ID: <69266F42-6D0B-4F0B-805C-414880AC253D@juniper.net>
References: <20191219013534.125342-1-epeer@juniper.net>
 <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
In-Reply-To: <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Enabled=true;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Name=Juniper
 Business Use
 Only;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Enabled=true;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_ContentBits=0;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Method=Standard;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_ActionId=4c60a29f-fa1a-4f9c-8881-0000083796ad;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_SetDate=2019-12-19T14:45:18Z;
x-originating-ip: [66.129.242.14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a196ae7-9f36-454c-341b-08d78492d264
x-ms-traffictypediagnostic: CY4PR0501MB3844:
x-microsoft-antispam-prvs: <CY4PR0501MB3844841D2321CCCB17575F6EB3520@CY4PR0501MB3844.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(39860400002)(376002)(189003)(199004)(66946007)(66556008)(66476007)(64756008)(66446008)(76116006)(71200400001)(6916009)(6486002)(186003)(91956017)(33656002)(54906003)(6506007)(6512007)(2616005)(4744005)(53546011)(316002)(8676002)(4326008)(26005)(86362001)(81166006)(2906002)(5660300002)(81156014)(478600001)(8936002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR0501MB3844;H:CY4PR0501MB3827.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: juniper.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6xSu/K2CTSp3jppjZu0T8oez7+DPxQ8uKFatRCy/+hh7iwuOCjuqyUuBXVFRYLiG54PnDGTbZc/6U7S7o+cMcAWAhPK2q6P7igM5Y/eCk+9eI40MHWQeiuWcnctqu+zXN5A/AlyrqdV2doLUF2ho2cy9L7DMT6702HFL4Y8CdH2vuLdW1FsIxGRWiXqxrc35efww2nB8ojuJAx+FMuyPI9oikZHx/+upPX0IpAhG/bJUz6R2jZ1mcy0CgeGqJcuoGvfuk7VKWTQdcB/4bpgXRlOLYiwC0Z5L2ar8tmimAPMCg95WaID6dUOqRZpoOZBs9qPcdOHOcpPdDoTElZclknLuOLwbQWTKTsMWKee2vLBiLd0hhaE/cFYIkv3KL8c+JC8REeajAFeORLSFp/mQjR7MxPIyW/he7k4IUgw0PGwurYvenGlmPYoo7ax7U0HV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <58152E6557FA3444B115F2A926EFE5A5@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a196ae7-9f36-454c-341b-08d78492d264
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 14:50:42.4626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tc8nRJ6HypZ0mcN5iH2UdY0Gsz3M6ZLexnvJEaybto0KZcQHqiABXPQqSkZJrkxNpcKkwJY5itW1mGShYgK6GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3844
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_03:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0
 clxscore=1011 bulkscore=0 impostorscore=0 mlxlogscore=773 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTgvMTksIDIzOjE5LCAiWSBTb25nIiA8eXMxMTQzMjFAZ21haWwuY29tPiB3cm90ZToN
Cg0KPiAgQWRkZWQgY2MgdG8gYnBmQHZnZXIua2VybmVsLm9yZy4NCiAgICANClRoYW5rIHlvdSwg
SSB3aWxsIHJlbWVtYmVyIHRvIGRvIHRoaXMgbmV4dCB0aW1lLg0KDQo+IEhhdmUgeW91IHRyaWVk
IHlvdXIgcGF0Y2ggd2l0aCBzb21lIGJwZiBwcm9ncmFtcz8gdmVyaWZpZXIgYW5kIGppdCAgcHV0
IHNvbWUNCj4gcmVzdHJpY3Rpb25zIG9uIHVucHJpdiBwcm9ncmFtcy4gVG8gdHJ1ZWx5IHRlc3Qg
dGhlIHByb2dyYW0sIG1vc3QgaWYgbm90IGFsbCB0aGVzZQ0KPiByZXN0cmljdGlvbnMgc2hvdWxk
IGJlIGxpZnRlZCwgc28gdGhlIHNhbWUgdGVzdGVkIHByb2dyYW0gc2hvdWxkIGJlIGFibGUgdG8N
Cj4gcnVuIG9uIHByb2R1Y3Rpb24gc2VydmVyIGFuZCB2aWNlIHZlcnNlLg0KDQpBZ3JlZWQsIEkg
YW0gYXdhcmUgb2Ygc29tZSBvZiB0aGVzZSBkaWZmZXJlbmNlcyBpbiB0aGUgbG9hZC92ZXJpZmll
ciBiZWhhdmlvciB3aXRoIGFuZCB3aXRob3V0DQpDQVBfU1lTX0FETUlOLiBJbiBwYXJ0aWN1bGFy
LCB3aXRob3V0IENBUF9TWVNfQURNSU4gcHJvZ3JhbXMgYXJlIHN0aWxsIHJlc3RyaWN0ZWQgdG8g
NGssIHNvbWUgaGVscGVycyBhcmUgbm90IGF2YWlsYWJsZSAoc3BpbiBsb2NrcywgdHJhY2UgcHJp
bnRrKSBhbmQgdGhlcmUgYXJlIHNvbWUgZGlmZmVyZW5jZXMgaW4gY29udGV4dCBhY2Nlc3MgY2hl
Y2tzLg0KDQpJIHRoaW5rIHRoZXNlIGNhbiBiZSBhZGRyZXNzZWQgaW5jcmVtZW50YWxseSwgYXNz
dW1pbmcgZm9sayBhcmUgb24gYm9hcmQgd2l0aCB0aGlzIGFwcHJvYWNoIGluIGdlbmVyYWw/DQoN
ClJlZ2FyZHMsDQpFZHdpbiBQZWVyDQogDQoNCg==
