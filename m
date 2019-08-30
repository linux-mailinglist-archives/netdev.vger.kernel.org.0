Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84606A40CD
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfH3XMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:12:05 -0400
Received: from mail-eopbgr680115.outbound.protection.outlook.com ([40.107.68.115]:19431
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728143AbfH3XMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 19:12:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jC9uC2r98jx3IkYBFHl0SveYmN3KeZ2KpP1q7rD7pFedDPH3AnS0/XGGV5M6As4o96NAVogRLMRB2XT17XfVVedcC0O+KtmOW0t1LDNLUfg61zc7IhFoXFEtOBRx9IxXAR8HVj3lzo9EolQhslqT3MSrmZOJznH961TOieBg3qCCIGLz/3w1CCNZoACVBSjhOdYSrE+wkmK44UERAhkMrZQcgOQfE3sA0a1p/IX+5OETP6FDToqovpoPI9ScJkcRvuzSHaOCMrCRvOdcGhWYH5q3uqIK93oC2e9y+ixEWeH0K7+1cMuuTQnU4m6nfRvyqOgP1j+Esoc0yEYdJJR4XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIF0tsi3+r7Ueh14bJmSM/MQEXzObJu7TnL2W3CK2ok=;
 b=I4GPETq9nd646r4lXPHEMYGJHh+cxNz2vSEDMRLeVrSVQPU5zbhmBJX6/7s2ShwCq+cAzheOXdFXOyYl3fpjJB3b2vylHD+bAWyhFca33Z/v/hB3vE8igVa10Q0Lb/mVGofaKzdEq0lnmBGMRtw4rEHbd17PAc7I4SqV5Lawfb04TzEnu07uxqrfhzNwReL8/5aehHOGHl6wr2eD8GkRX0zJo4xJsmt2XFi/SBEGxqDIzY1/nNQoMwrv4oCTf134BBcxmPHh8uypZh0ANMqiVzGmcnOdMzWxQYQTQ61WqVTIz/DqgcJKuqE7tFu4SSXrA2PkG8ppqmxEqk7ra3Shlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIF0tsi3+r7Ueh14bJmSM/MQEXzObJu7TnL2W3CK2ok=;
 b=By/09ie1+c1jOwvBqhTeKdxQXpdGH3/TB23mNAjIq2HkoNF8KZS2HtawkJwiZ/uVubE4beZb3BZeVeM9N2JBAAPaivLm10t+D5Mw6yq3YuBRu7yOwUimSYVFRwsGtN4oZfrqMRm+SffUWVP34P5QmOh5M27AerHhoo4WAP67wGA=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1417.namprd21.prod.outlook.com (20.180.21.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.9; Fri, 30 Aug 2019 23:12:01 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Fri, 30 Aug 2019
 23:12:01 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: RE: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to VF
 NIC
Thread-Topic: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to VF
 NIC
Thread-Index: AQHVXuVjZEYmBu9A80OagVmDV3gGfqcUUN2AgAAB2gA=
Date:   Fri, 30 Aug 2019 23:12:01 +0000
Message-ID: <DM6PR21MB13377EA9E315E7A5AEEB2BB5CABD0@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
        <1567136656-49288-3-git-send-email-haiyangz@microsoft.com>
 <20190830160451.43a61cf9@cakuba.netronome.com>
In-Reply-To: <20190830160451.43a61cf9@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-30T23:11:59.4825663Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=77108b9b-e507-4b4f-a99a-af7675992fe5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [2001:4898:80e8:8:8f:1cae:476:aa38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfd28e99-ef6e-4757-99e9-08d72d9f76ed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1417;
x-ms-traffictypediagnostic: DM6PR21MB1417:|DM6PR21MB1417:|DM6PR21MB1417:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB14172660D12A724D7F460711CABD0@DM6PR21MB1417.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(189003)(199004)(13464003)(6916009)(7696005)(74316002)(316002)(22452003)(86362001)(76176011)(8676002)(54906003)(53546011)(25786009)(102836004)(52536014)(5660300002)(99286004)(4326008)(4744005)(66446008)(33656002)(66556008)(66476007)(64756008)(6506007)(66946007)(486006)(10090500001)(76116006)(446003)(476003)(11346002)(186003)(71200400001)(71190400001)(6116002)(229853002)(14454004)(478600001)(53936002)(305945005)(55016002)(81166006)(81156014)(9686003)(8936002)(10290500003)(46003)(8990500004)(7736002)(2906002)(256004)(6436002)(6246003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1417;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZJj5A68ShccpLbKkgmoptdH4djju/xICwd+nvNReJFvxcs7cVfrqc6Xzx1TXLp5NQ8EoB1MJmPNhcjJlK5cV6bD2FMbsrj9ggRfqM0zU9u6SHBQllFNW/o7IXFYvW3DiXbx38A9jwXfr3ug/UNJasicTx2Y4YErNuJ6Rp1+f8KBGIpCddHNNhBALIjlVtx3Kr2zHLsH7G2FDL85HMsqR6JpZN7q2Hzk9n/9aKvKcPijnfv0pCsU+4HRdwOF1DYbgFjZiPok8yov1vm+/nkOLmb18ZvQ4Fo0hRxKQKsRmjrfurr5xVm4XFEO8Cd/ebEAkV+qjWDG8aePRZfwAxGhgplzTNzDnt0iZSfW9W1aXx+0mZbhaq52gjvbh9ho+07gdg0/XAD9aDUbGyxc+sJE6mQSI+l04b8UgDFRB+KpYfiE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd28e99-ef6e-4757-99e9-08d72d9f76ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 23:12:01.3870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjAB3+5q3JnnR/tL6G8+nY2cwZ2L7/FwwisF3PwHzHtzCXbKWDYW/oTlsJ/gylaMVsAfjjqEExbM+Pav/+1TMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1417
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Friday, August 30, 2019 4:05 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-
> kernel@vger.kernel.org; Mark Bloch <markb@mellanox.com>
> Subject: Re: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to=
 VF
> NIC
>=20
> On Fri, 30 Aug 2019 03:45:38 +0000, Haiyang Zhang wrote:
> > VF NIC may go down then come up during host servicing events. This
> > causes the VF NIC offloading feature settings to roll back to the
> > defaults. This patch can synchronize features from synthetic NIC to
> > the VF NIC during ndo_set_features (ethtool -K), and
> > netvsc_register_vf when VF comes back after host events.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: Mark Bloch <markb@mellanox.com>
>=20
> If we want to make this change in behaviour we should change net_failover
> at the same time.

I will check net_failover. Thanks.
