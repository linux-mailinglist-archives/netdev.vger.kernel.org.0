Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B90F88C85
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfHJRqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 13:46:55 -0400
Received: from mail-eopbgr820081.outbound.protection.outlook.com ([40.107.82.81]:64512
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726048AbfHJRqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 13:46:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3H1Sw/fYBhU1GV35QYyZvsC8sBKsYAi5kKwCHor6qSRKbD7Kd7yN3K1DELM27I41ZrbSBGFq7gYt8DK11n8/L5Xi9hrhaLbvJvNlo/3S7cKtrT48i0nQ7qkKg2HnJNAVXdiOqvrbngSuQP5codx4nZPEtCW4ctiNt0f2lAqkOjCRYpbmGyswj01bRum6XWL9YqiGOihP44Y07JUIQ6jF19P4vVS9xfllknMv1RFRHjgWrFoIhVXualo2QMENR6VNr08zINNSvgD6PnCjJBzow44IhsP+dJd4rDxIXfCfnFZPypIZwGFixEbjO5cT9ml7SpdvZu6pz5BCYP+ekPIEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UD4ZutWy5HWbFYCzdbZSJV/o/vBuwDFF5jUj9mSMej0=;
 b=ebXr/mDzQ1S9PgxPA5uUOxLBeEXNs//lDSNvVJoD9byl3KoEC8OVP6y5zOwrSKNaEn7BtsZ2gGZvfjWFBHK6KO7yVSMxgAOglF2EbWzq+QJ1mwpEhIB+vrijeKnfh18xri/+3NpzwvGWNONxWmc9Bw+3k1IKav0wM3Dvf649QJ4B9fYqls0LHy16h02RnhXJV6DW7ON80614G1X/KbVk+iR2Sucwlcd95S3l3NXEchzpWAp7mXh+p02H/pnfS+k+u333nBL7pWlzvCQ/JU785/T3GspwkOTwd58gUULQRa/S8Fiqhy2tnBhXKsNH8aiIDETDNBqL1zvCZXB7v/2Cew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UD4ZutWy5HWbFYCzdbZSJV/o/vBuwDFF5jUj9mSMej0=;
 b=peP1RLXAFCC4R4emfaG5wBzdO3I0yWjlwaDyKmzEWdox2nEccEBDvU5PhGFOagoonSLirRg4UWqoCAdCRu6c7CaGiJTywrgChtS5qsKudalz9JtMjkpSgkU6WubiThl9180VOrU9MMnjq2vArWH8Nrqk5oxXsMVLlmTNAyeDBcU=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2PR15MB3637.namprd15.prod.outlook.com (52.132.231.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Sat, 10 Aug 2019 17:46:49 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::49b5:cc04:ec33:c7c2]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::49b5:cc04:ec33:c7c2%7]) with mapi id 15.20.2157.021; Sat, 10 Aug 2019
 17:46:49 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] tipc: initialise addr_trail_end when setting node
 addresses
Thread-Topic: [PATCH v2] tipc: initialise addr_trail_end when setting node
 addresses
Thread-Index: AQHVTk0Yw1fWCdXpz0COXP7OMd9Hsab0omhQ
Date:   Sat, 10 Aug 2019 17:46:48 +0000
Message-ID: <CH2PR15MB35751C0AA17673A100E646839AD10@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <20190809005451.18881-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20190809005451.18881-1-chris.packham@alliedtelesis.co.nz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7e19fb9-16d1-4743-7650-08d71dbab877
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3637;
x-ms-traffictypediagnostic: CH2PR15MB3637:
x-microsoft-antispam-prvs: <CH2PR15MB3637C49060568465F77851B39AD10@CH2PR15MB3637.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 012570D5A0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(199004)(189003)(13464003)(5660300002)(446003)(8936002)(11346002)(66066001)(476003)(486006)(44832011)(7736002)(305945005)(74316002)(2501003)(4326008)(14454004)(25786009)(6246003)(53936002)(71200400001)(256004)(71190400001)(478600001)(86362001)(2201001)(3846002)(316002)(186003)(229853002)(6436002)(8676002)(81166006)(81156014)(2906002)(26005)(6116002)(110136005)(9686003)(54906003)(55016002)(99286004)(102836004)(33656002)(66446008)(64756008)(66556008)(66476007)(52536014)(76176011)(76116006)(53546011)(6506007)(66946007)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3637;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zAS6GaaYN+eGqWca4VPM4XM4zSDyhYVzYyOtelDv7QJQk4QvCjtxElJvQGbAA2XmF076BqmboCplne67R3O7kZeyV7+B0bpCWLQWzU+VI+P89/uzxHVr/ZjHv8Bf/KHOH5ziJLgTTGj4WUTK5nfpK8hfRI05EuiAFKwA1/lJn3gIkcMwZyJTm2rZ4hx7/WF2xywt+NFnGm2B/h14O+MitmQLFD8yTH3+mv1Nmc0jkGN4QSF/db6aBcjV8u4m3rnHJnnwuhDx96SDJWaDXN2ssNsX7huhIGLlkXazZgYgJAhOEXwIT8yKLWWhsyLB8ex4OIlWvhjalHRxiMt0wWEe/lOtHDAfgVcBKITlwH6TQwo5dZcJLzPX9djxWmRGVlccb6cYe6sSh75N0IquwSEPQi0TxbWl6GL9m+JdTo4aU2c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e19fb9-16d1-4743-7650-08d71dbab877
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2019 17:46:49.0005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1MwiKXivKbTHgHJH5GO1962x5g8Bdy+QGONJzFVbttRXM2eIqUADvNoEdfATDoRCCyGWdzUwiwxNaJA6EYfjYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I would re-phrase this a little:
We set the field 'addr_trial_end' to 'jiffies', instead of the current valu=
e 0,  at the moment the node address is initialized.=20
This guarantees we don't inadvertently enter an address trial period when t=
he node address is explicitly set by the user.

Acked-by: Jon Maloy <jon.maloy@ericsson.com>


> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Chris Packham
> Sent: 8-Aug-19 20:55
> To: Jon Maloy <jon.maloy@ericsson.com>; ying.xue@windriver.com;
> davem@davemloft.net
> Cc: netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net; linux-
> kernel@vger.kernel.org; Chris Packham <chris.packham@alliedtelesis.co.nz>
> Subject: [PATCH v2] tipc: initialise addr_trail_end when setting node add=
resses
>=20
> Ensure addr_trail_end is set to jiffies when configuring the node address=
. This
> ensures that we don't treat the initial value of 0 as being a wrapped. Th=
is isn't a
> problem when using auto-generated node addresses because the
> addr_trail_end is updated for the duplicate address detection phase.
>=20
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> Changes in v2:
> - move setting to tipc_set_node_addr() as suggested
> - reword commit message
>=20
>  net/tipc/addr.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/tipc/addr.c b/net/tipc/addr.c index
> b88d48d00913..0f1eaed1bd1b 100644
> --- a/net/tipc/addr.c
> +++ b/net/tipc/addr.c
> @@ -75,6 +75,7 @@ void tipc_set_node_addr(struct net *net, u32 addr)
>  		tipc_set_node_id(net, node_id);
>  	}
>  	tn->trial_addr =3D addr;
> +	tn->addr_trial_end =3D jiffies;
>  	pr_info("32-bit node address hash set to %x\n", addr);  }
>=20
> --
> 2.22.0

