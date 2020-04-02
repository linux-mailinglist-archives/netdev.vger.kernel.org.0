Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34119C04C
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388108AbgDBLkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:40:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59132 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgDBLkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:40:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 032BYsE3014357;
        Thu, 2 Apr 2020 04:40:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=H0PyYP3DtXoemFw8VPX1ih54nVMlz40IxhJVVdYGRmM=;
 b=UedZUC7Rva7xigfM/TotIVPdn47SNx2Yigzq6rXU3G8zwDEXCln3jt/5OccOrbCQAEnC
 nvs6uiBQxCq5K2qDNfQBy2k0lIrLFDjSVtxgv0EtfRZnqqhdmU7C3bFJbUxk8mhGOhGX
 vC7EpitWV4Alwom/Qq50Tr7BX+G3fRe/PO6q4mR+WEJx0TTLTYcZmcQ9Lum6s2UL9eBK
 qXJAQ/EMuHyXOAMEt5OIxfYGARW3bkQP2rYLgDk7BMR61Q0qPN6UP/482H71gLdTxfty
 dIpLcA5N8ULM8YW/GdUjQEe0DeyB9kk1LKm+GLiLShaQcHeWVxNchMRm83RRITL/UhHp dg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3046h621c5-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Apr 2020 04:40:20 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Apr
 2020 04:40:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 2 Apr 2020 04:40:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BE2IqYdCpJDrUMltnms44uSsRgpmSGq8rUhcniqMcXOl5lK/SaPhOO8G7yDGsQfRP2BB2lDqIFM6G7WKqOHDeNd7/rqp2zQWoklJyr0A/cQSZzJpGFqqOwKUUjhBa5WC2MVs2WeuZMYdzoNW2nt0aJbv7zFkD7xUSGklTVd174YM1EtkW4KACA+fZF9nwaSlPz+9QwxfIsWwmi9IO0+lr98XnOYbO7YvgnLHEVvhiIkE5me/ANV5RDDndbh6fPv30MLQ810mLgyXNBd2rkt3wLUsQqWb2pKuwHy9vJydMLkUqy0H+aM4oh5cPMuuneKTwQc31cu6fqL1nImfQgbt6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0PyYP3DtXoemFw8VPX1ih54nVMlz40IxhJVVdYGRmM=;
 b=W725KJJax8+05LSbF+7cWPH8TncaxIPlXjBRnrJpaP7/oGCsewSOPfOFZqvcr99ThHO0jepsnlGy8h2zt409RArTtTayn9woVH3z4yGY+dQOlfHTZG8/EVZ18dFzDgyaJ1tXZc1w7ZbGKWZhxcOJTDlhBv8gAg4+Po3fzHWzxeAfFibkF47OHickgqC/0oBpBA92zzD0HwPK1FPz9X76gQKwz425n0zWaFZkDPkwVqre9u4O/lsu5KFXgMCN7LyLgw7TMP2EMsC3xhlmTGKEtDzJB8SHfVAkD5njbapFLZvmFBb8KDGxTHwkg1b1AMjMTZDVE0st/cWNT8ggk63GWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0PyYP3DtXoemFw8VPX1ih54nVMlz40IxhJVVdYGRmM=;
 b=kJ4TJFUWaEt2ERmB587HidyOAubV+D2x1J0eGCeBT9wd1x9HBKxryN51MzvOaspdzJEzpM83UmdpNs4RlvsptgPq688MWwIwZJuh8RRpdxes7ikF/OxekIP8q6rHsyleuvQ25+0eV8UKJttMst430UkrSjSOPluHwFW+6zHEVBQ=
Received: from DM5PR18MB1418.namprd18.prod.outlook.com (2603:10b6:3:bc::7) by
 DM5PR18MB1307.namprd18.prod.outlook.com (2603:10b6:3:b2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.16; Thu, 2 Apr 2020 11:40:07 +0000
Received: from DM5PR18MB1418.namprd18.prod.outlook.com
 ([fe80::645c:11c1:6e45:2323]) by DM5PR18MB1418.namprd18.prod.outlook.com
 ([fe80::645c:11c1:6e45:2323%6]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 11:40:07 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH][next] net: atlantic: fix missing | operator when
 assigning rec->llc
Thread-Topic: [EXT] [PATCH][next] net: atlantic: fix missing | operator when
 assigning rec->llc
Thread-Index: AQHWCH0mj8mRw42JIE2naWFBBJnpMKhltTBA
Date:   Thu, 2 Apr 2020 11:40:06 +0000
Message-ID: <DM5PR18MB14189BD4043BE8974C9AC001B7C60@DM5PR18MB1418.namprd18.prod.outlook.com>
References: <20200401232736.410028-1-colin.king@canonical.com>
In-Reply-To: <20200401232736.410028-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.126.46.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b972329-364b-4e0f-36e8-08d7d6fa97b9
x-ms-traffictypediagnostic: DM5PR18MB1307:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1307342272B3064D4E1EF4F5B7C60@DM5PR18MB1307.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB1418.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(5660300002)(81156014)(81166006)(8676002)(110136005)(9686003)(26005)(478600001)(52536014)(33656002)(186003)(2906002)(86362001)(4744005)(66556008)(66476007)(64756008)(66446008)(7696005)(6506007)(76116006)(66946007)(8936002)(54906003)(71200400001)(316002)(55016002)(4326008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /VswkEd52akOsMhDn3qfW6NCAnYa90Kgc6M+HWUi+ZbauxUdw+L+JNixlXR2G0Fw4rXZpxubV4LLWtuy1p0Kc/2C45X8VmixUbFd/Ioo+I1fkKA9jba4iwO0P58H5gLNlAiDD/HZ1Bloy3QVQ/tkceZ3NGm0GXxYF8JfNl9/9YuRI5QwVEbYTtjcBMBGvH9EO+rIW/ZlRLtmpquK3bSu29/LwmqJIEcFcajSHKLVPNCFEF+FCxGmqOT7s0pFBOVVKfP3kcyQVmNY5R+B68MiyPCsiwOA5QAIxnwdvFrE0roT0tfMGyHTRBBwJMYlq45kW4XZFKCWa1wGoMCNMnFxrHVFIfF+0R/mbkRjIKACIBYuafSumQQkMO6mqzDhfBzWsg4E/FQX5BEI91iiDV3WpCAvmT+Q6YUYsyGG0xlg91c+hd6YpEsjDbzSc4pM5+PZ
x-ms-exchange-antispam-messagedata: YZ59FdMY3H/k4rIpcoLzA6BYh8GeuRz6K/dDoZYbW+eCgej+A557//sUP0TCXg8jVzVUZkVAuutXLTX2whk5/OK6WLuZFMwwEyU4fFXdbMTdYWXElqRHCKZb3YcxWf7ptVeLRefonhKKH76q4EP00A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b972329-364b-4e0f-36e8-08d7d6fa97b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 11:40:07.0011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qn9SzLS03qVN0aZWJKgnUguj/XWZHm05uY6Fv4Yz/W7MIneYPXpLd8tT3WFTv9zR3XGTn4HA4ISVSLqDPmwPxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1307
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_01:2020-03-31,2020-04-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIENvbGluLA0KDQpXZSBhbHNvIGZvdW5kIHRoaXMgdHlwbyByZWNlbnRseSwgYnV0IHlv
dSB3ZXJlIGFoZWFkIG9mIHVzICkNCg0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2lu
Z0BjYW5vbmljYWwuY29tPg0KPiByZWMtPmxsYyBpcyBjdXJyZW50bHkgYmVpbmcgYXNzaWduZWQg
dHdpY2UsIG9uY2Ugd2l0aCB0aGUgbG93ZXIgOCBiaXRzDQo+IGZyb20gcGFja2VkX3JlY29yZFs4
XSBhbmQgdGhlbiByZS1hc3NpZ25lZCBhZnRlcndhcmRzIHdpdGggZGF0YSBmcm9tIHBhY2tlZF9y
ZWNvcmRbOV0uICBUaGlzIGxvb2tzIGxpa2UgYSB0eXBlLA0KPiAgSSBiZWxpZXZlIHRoZSBzZWNv
bmQgYXNzaWdubWVudCBzaG91bGQgYmUgdXNpbmcgdGhlIHw9IG9wZXJhdG9yIHJhdGhlciB0aGFu
IGEgZGlyZWN0IGFzc2lnbm1lbnQuDQoNCj4gQWRkcmVzc2VzLUNvdmVyaXR5OiAoIlVudXNlZCB2
YWx1ZSIpDQo+IEZpeGVzOiBiOGY4YTBiN2I1Y2IgKCJuZXQ6IGF0bGFudGljOiBNQUNTZWMgaW5n
cmVzcyBvZmZsb2FkIEhXIGJpbmRpbmdzIikNCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtp
bmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCg0KQWNrZWQtYnk6IElnb3IgUnVzc2tpa2gg
PGlydXNza2lraEBtYXJlbGwuY29tPg0K
