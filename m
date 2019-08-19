Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5B6923EF
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 14:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfHSMz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 08:55:56 -0400
Received: from mail-eopbgr00083.outbound.protection.outlook.com ([40.107.0.83]:26435
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727128AbfHSMzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 08:55:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTit1lPKdmiR6hLwfnULDmnq6BKGa9XSi6fG48Ah1Wux70YvOLCyDlqpSccqyJT3lF+7bjn60794yAmF04ygZYOuawgWqamFb2kiUAf0HJWtE2QUypv7SGG0XfxzDVA0UjS/TaT7Hdib9aLQcd8lCS9K+OWbVe9RbHBywrXzux/lrtdVmCd+AER3Jq8CDL3BrSpVHDOxnjOxmxPSf52xDaWUEtjoS89t7nu174oPopJKKHk3hSShJwXqCn2MHQ6hrfG0dLNgBAzOaS00tT7wNpcJgzOieNse9RlJU1ti/1j3WlzhXaeAXSf97FWSNlkR3/OZMuADa9X4pYK5GEpNyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyCpNWu6iy3O5DhZrV+kYhEEQozZxAmqF/+cS1/NBJw=;
 b=R0tPI5R3M5Ak8dnT3zygKWBN1UkdO8EGfa8O463kfwW1yP/fa9OiPNtJI1Af0VGXP/qRK5wk0uaHx6os5NAzui1HfsO9e49IV+aRM/wcjtOIcFUJq5FNsNEVIk1sWuOMWvzmBwZfZkG98VmAFHiLSnPQkA6gvx9v+GUV+ANaX3+eH1rrZG5G8WjxBSJgFAbKpCn1bVlN72DGLQV8PdlCQLO2lWM8tvxCAqoeB+Zj/g+nDS0W8mAcxFytNVP42WFSfSiD8WYtXJ47LqNKIMSbZAehN6pnWeSQQy74y8pd7ajXJ/fRBditLSnPnAuXb6B38vfNXc74R+2oWw0iUhyB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyCpNWu6iy3O5DhZrV+kYhEEQozZxAmqF/+cS1/NBJw=;
 b=OjlTxQb/aIvJjfWC+lHBMvBeN376dDXxCM8UHHgkhNuJ5SBny/a56gk40PScsEx6FTEQq+S6DcSuBZlwmgAUo9gHdt32zhHgyb1xblsueUpukp9N2im02kIiAjtPTAMAMSztkgqoZZLRDdga5QVu3YN9nP6KtdyaDASnFWV4pZA=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 12:55:42 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 12:55:42 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdg==
Date:   Mon, 19 Aug 2019 12:55:42 +0000
Message-ID: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [103.92.40.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56dfc88d-e9dc-47d0-0137-08d724a48b51
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4889;
x-ms-traffictypediagnostic: DB7PR04MB4889:
x-microsoft-antispam-prvs: <DB7PR04MB4889D2FE2C5316E1DE41AD4B8BA80@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(199004)(189003)(2906002)(4744005)(2351001)(25786009)(2501003)(486006)(52536014)(7736002)(53936002)(305945005)(66476007)(8676002)(99286004)(5640700003)(6436002)(74316002)(9686003)(256004)(55016002)(14454004)(81166006)(76116006)(66446008)(316002)(66946007)(64756008)(66556008)(33656002)(81156014)(1730700003)(6916009)(8936002)(86362001)(6506007)(102836004)(26005)(186003)(3846002)(6116002)(7696005)(44832011)(66066001)(71200400001)(5660300002)(476003)(71190400001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VJPVqalyTwOBfHvd9/2Al3284G7YjPZNjK0SS7ldmBtVhNnpWzDgJ05CJMpcjJo6yMHccE6VROZ9O4oKtYnu9KhWQQuPK0OzAk8Dh5gCQEXPdQX7fZ3I8WXPNWj/mQaQD8iJL6I/9F/fwVA3JkBcvBj1a0qzyxQG3gINzWq4k3mnyJ+zwQ9HL1EH3wpirckWI1xgRYZUHXMXgoLsanBK5UjxSPtS6zUEkCgUD1C4oq8bKCIFvb5JxcnUNaMWVFfmG7QYwwpsuI66aTWVnpTTvyM73IOSVOMZFTUqTEcSC92VCj9J2j4ILwzdmctJaWYtT17RJ1slns0igvsgXBFQh5NGzELlisRIM7EpWu9mwE2WvCE9AWQUj8YQ6H0Vbmzkl1Am3pMk5+HwFZkxU+TAWnh3y0Q6Uq8qpaTV9DktR+8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56dfc88d-e9dc-47d0-0137-08d724a48b51
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 12:55:42.5323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o6aYRasZ/wSklCcfUsRXmpUgZdjTcTI3pJXGFWojYgVm3yNIhZU54Z/TWBfshnFb9Mlxa5Jxeah//UE9tTXoUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

With kernel 4.14.122, I am getting a kernel softlockup while running single=
 static ipsec tunnel.
The problem reproduces mostly after running 8-10 hours of ipsec encap test =
(on my dual core arm board).

I found that in function xfrm_policy_lookup_bytype(), the policy in variabl=
e 'ret' shows refcnt=3D0 under problem situation.
This creates an infinite loop in  xfrm_policy_lookup_bytype() and hence the=
 lockup.

Can some body please provide me pointers about 'refcnt'?
Is it legitimate for 'refcnt' to become '0'? Under what condition can it be=
come '0'?

Regards
Vakul
