Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBB192790
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgCYLwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:52:13 -0400
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:34627
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726658AbgCYLwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 07:52:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlIB8VGfSZDFivPjQyJf8VvL4/y/uyDtZtPKYvFDoDaaOCiqpZ0BRtn1hxPNyAXwcEo4OI1e+cSDGmv4nwIcLiXrRm/nDN/EKuRxVJYb3YJeLWCuvJwn/znP3zsRZRVOB/jVsgFIIcwYWd0MCQ13WhWdg7d8MZ1VpXBARLKG436xX6bPCb0IMwSHX558G4ytJMTYzID+lzCj0f8K1s7pLhYeONsDSFrQvElxOliHgVy48UZq/5It2jNExQ/hPbNSrWmm2xvRTgqpPxx2BQcjtJ176yoFQX3hbkSjCJ3jQ9FG5Oo32i8MhObjB0tEnAnvMKQsOSypewkPJW23tMiNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qF6LgzV/S6iPBdHZlaO5uqB1rhJvasRXjIrr3iCMDZ8=;
 b=TcYwE+I0WjKnfD13avcPJLQ7mtsIf6KLHeybK4czT8y7f7E9jgMoN9ZYDaUXPp09EZj1SKPvlBQkGsQui0uF/UY9OY27MQUjt7FkRJTzsPb1UfRSjuoO8EOrp3dJ10sGvG5+VyIWS3jdo1YL4Ns1S77q4lVpVSWmgZpqwZYFOY5WRbf5MaCoLkWIT8sx+z94iPu+vTXnbgu6ZrIUtT+PkHMcqB2b9jPuxRjBWrhow0aFv0dn9KbOOl3vlrEcfvsVKvcGfGwO0z0oW/DNtIoQiRw5IfWp7PLkU+IDtOiUI5vyrT89rUrv+86xz1ZjXtqUVHp7Noq1o5RIASq83OHBWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qF6LgzV/S6iPBdHZlaO5uqB1rhJvasRXjIrr3iCMDZ8=;
 b=YIBQpfNW2h8SvFyc6KibyaMF41G29cefQf5yQgMW6ShQdRkqAop9BjFRMu4OPn+z/5UM1oOnbFXwPR4tbJVU6arpxCR8F4/zGm7Wr+X4xAmOh0tk4V9/jLvJ+jJ71fWyOprH/2ahNqedbL+vNIidP2RudVbcHIC4+JUtq1cdh04=
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5813.eurprd05.prod.outlook.com (20.178.94.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Wed, 25 Mar 2020 11:52:09 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 11:52:09 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Oz Shlomo <ozsh@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] netfilter: flowtable: Fix accessing null dst
 entry
Thread-Topic: [PATCH net-next] netfilter: flowtable: Fix accessing null dst
 entry
Thread-Index: AQHWApOmQ6Cdxq/toEK6NfDhtcgdr6hZIpWAgAAP2iY=
Date:   Wed, 25 Mar 2020 11:52:09 +0000
Message-ID: <AM6PR05MB5096B0ACD2A2B4A7E1B75935CFCE0@AM6PR05MB5096.eurprd05.prod.outlook.com>
References: <1585133608-25295-1-git-send-email-paulb@mellanox.com>,<20200325105517.exoasd3vbzx2r3qh@salvia>
In-Reply-To: <20200325105517.exoasd3vbzx2r3qh@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-originating-ip: [5.29.240.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b9462d7c-acaa-4869-5e50-08d7d0b2f324
x-ms-traffictypediagnostic: AM6PR05MB5813:|AM6PR05MB5813:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5813D328E5C6305A711030F2CFCE0@AM6PR05MB5813.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(55016002)(26005)(9686003)(4326008)(2906002)(6916009)(186003)(6506007)(33656002)(53546011)(86362001)(5660300002)(316002)(4744005)(7696005)(66946007)(478600001)(966005)(71200400001)(66446008)(64756008)(76116006)(66556008)(66476007)(8936002)(52536014)(54906003)(81166006)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5813;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +vlluEMjAV41SLOW5KmtK95YCBmerpbdWjN7O5ZQN4Q+iaQJoAVAHwXEbzJN7wfDrXMQTxUJ0kpz4DKz+qX9/6mJ3DUJ2/EdJyXbgDVuKRdmxN8DofLESg+pxPzKJq81xm9nE/x83qAABm/CCSMuaWO0BdcL2QqRke3rKN0UBahSKeWGbGAOdxGb8pujAbUs1EWNxNuHmZiO4fMSpvkESMxA+h3eMl5mhBTFUAOf+uN373OJfN3e2muKs51yQE7hQt9Ki32WJXQ7LcWZ99aXOZP32jjOGJUmv6g881Xf7RwdHgQDW2RSyANa9OkOb3OJviEt+/gaF01p7jiLNz3hUdRl9FvW4f9H6VMtWA7MQ9C1yWy+r5wEMhQoG17FuFhsNcoB54qwBAA6Kjui7wYRGHYMYmgKL0eTOf/Ybm0jlEBUUkGWhctZH+qQ7cfqPbG8uYqOOb73/+8xjWtacUJXHHaIBCQMqdFTBV/leajWuDyRYqdY7NPOVJEV9+O3XqfpJsjYVkQSTp8VwJl3/jm88A==
x-ms-exchange-antispam-messagedata: ctmAFOFNPFzneKOkqHKLS2g818DPwImsZ9sEPCvnogIUm7JSjvLiDuyYgFY+f5c/7zl6/x1HJir8h/IWtqq6dVaQH57jcCXEuc9TNo+wymfatTi2swS2xIBtfyzYWzW5VneMDUtrINPGJmA1+OoTfg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9462d7c-acaa-4869-5e50-08d7d0b2f324
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 11:52:09.7398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /DinIQ2eKpmkOUULWCTVBPq2oMdk6HwIoHVhpCcbvAa3dhyTGR8hTS72Nm/OvgJMVPX2Co8wfWYO8SvGIKr61A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pending patch seems fine.

________________________________________
From: Pablo Neira Ayuso <pablo@netfilter.org>
Sent: Wednesday, March 25, 2020 12:55 PM
To: Paul Blakey
Cc: Oz Shlomo; Majd Dibbiny; Roi Dayan; netdev@vger.kernel.org; Saeed Maham=
eed; netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: flowtable: Fix accessing null dst =
entry

On Wed, Mar 25, 2020 at 12:53:28PM +0200, Paul Blakey wrote:
> Unlink nft flow table flows, flows from act_ct tables don't have route,
> and so don't have a dst_entry. nf_flow_rule_match() tries to deref
> this null dst_entry regardless.
>
> Fix that by checking for dst entry exists, and if not, skip
> tunnel match.

This is fixed in nf-next:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/

I'll get this merged into net-next asap.
