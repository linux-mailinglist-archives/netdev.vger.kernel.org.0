Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E664318931
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBKLOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:14:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65192 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231443AbhBKLLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:11:18 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BBAQ88015464;
        Thu, 11 Feb 2021 03:10:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=YLodZ2By8iUyXTy6CCImIjIVZsMu+CC1ju/o/DFl1G8=;
 b=aW2phhMividShxg6+SZ3LNca7gYvQWARWHsp+D2rHft4mEP4HqdhtNNnDsHKw6aSoDgk
 1lfJ6+Rag0+hqrxMCzV0VjC4qnUAsRAxu19T0dIXaJgtGMiTEanTMukdGsla3Te+ZtUV
 4TzUfU4RWPQD1R0w0QZ6pW0+02YOXd4gJgkY5lqxYl9Svt9EgfjJ10I0d2Ej0rfR3BXE
 jVPtlLopRNUavTgfbLGPFTJhQ2aM5mgtq6g8TdbxryX5OO70koR4I9vaeu4GmioHIXHO
 FAO5bK2lHWwFFiWSKp8oW6uM7AsXwAxTELUFTbjVJYKyEXLzz4corSjOy1JjUqmIJray jQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrpsbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 03:10:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 03:10:25 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.54) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 03:10:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VX5JAYVYXCqIW1FTTTPCROL2XKGMWpHdsdKyM6vJZf3xm0dIewcEMRLtFlsw/zWt0kj0z/Tq3cS03sMLfU4oGVQOpPVoSAT6qBq1MbWW2P2R9megbmvAD3sNTZm5DOei5UBUXUWrWBvooHoTi8pzR7iCeD9GQ84eQ28dttHWsGWZ2qwd6274fJa6gjiPSsCx6YAvssXfEgGr6ma8aOs0TQQ3HST+3bFB869VbJkWniz+7vIwhnXkH/kMYLzt9gJ1jmeIu2+4TN2JWRXCJDAXgPK4Ndm9Y3eSVlaMrHA8W6KYGB0b51HKZ/K0u5q//IUeGA4Vux0fuoWLU0NjCZk22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLodZ2By8iUyXTy6CCImIjIVZsMu+CC1ju/o/DFl1G8=;
 b=Gh6Kjo0c/UoS51DT7uUJ8AFk1YaEWeCyLCDmiO9CtCqKPbTbi1AH9YNumURhDvPeBiNzUSuGVQChTmmTZQcWV4XBUFW85hfHcqGRxb3hzzo2vH76Omu8WoitWDrrtqcPz+gzM20oSuudzsEQyZrnyXoygFUpWcxqVePhFq/F23uu5BwB6/gQiOnbAVhGDa/pmecNj2JDt/m/9hhwUp8Wu1CMOKXoWxF71zqsAJUC/p+4UZAS6x3/KwuxYV3OuZj+XmVCIikgJcCnbYnLjQvnEIbYYxM7ltiHnABCepCvIjvIyyQ4oB08vWwyRJZBpQ+URL1zzFf4mkxkFf6xJsSWxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLodZ2By8iUyXTy6CCImIjIVZsMu+CC1ju/o/DFl1G8=;
 b=UZaAUfLVrcjRxJ65mCFzHCs6I+jW3/9fCLVYoVc2w9b1l2VzshS5MskCkdVAP6LcqcAuSVZ6VDwl7r10+WgSqrCApm6TejmBGY41F0zU5QRSDekky/GIdezQPTyD+Ry5xcZisxxjlIvEV1lc/YRNiBD3W15kgpZL1vhXTRhBe18=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1488.namprd18.prod.outlook.com (2603:10b6:320:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 11:10:24 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Thu, 11 Feb 2021
 11:10:24 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v13 net-next 04/15] net: mvpp2: always compare
 hw-version vs MVPP21
Thread-Topic: [EXT] Re: [PATCH v13 net-next 04/15] net: mvpp2: always compare
 hw-version vs MVPP21
Thread-Index: AQHXAGPDLx0+FHN2skmP52dC0FnhKKpSy5SAgAAAS5A=
Date:   Thu, 11 Feb 2021 11:10:23 +0000
Message-ID: <CO6PR18MB3873C8DBA4B12A8E859A7598B08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-5-git-send-email-stefanc@marvell.com>
 <20210211110809.GB1463@shell.armlinux.org.uk>
In-Reply-To: <20210211110809.GB1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 367e0795-c1f3-4f69-3787-08d8ce7da100
x-ms-traffictypediagnostic: MWHPR18MB1488:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB14881CC8EF2024838CA528AFB08C9@MWHPR18MB1488.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: baqkC4UT1GqXrsRTE4bwXe31ZSiEP5j1BWNWbxBLSnvrjvei5gugxw+Re20nhRKEfP7NR7s06aEjZWhJKe0uEeACHiIVQnVu/RR9UAkQ4H49Lmbq9Szwc1gSbOYZJSUajLT5e8Op8tTxHAIwjkwMZWhQFHTCls6XSYnDVREKM9+8fMW1QLdYncUE/DiS7tkW3MIcYmwE0uRSgzK+SCLvuDVrY9twYKJWiPQy9ODf8tsHyZr+u28hKyWe5abUCwQaBdRxuZ+VlbclPotnlHcxZsm9gQBgz7X2zHNT5brQMdlTXo33Txyg9G9HxJiAHrDxKhfyPLHVnKtFocDVfHYSGeHXkZcTbFbmN4TZrSIKUC2NTF6TTc17Qp01cUWmJOKJrSxSGSkiNsKy2UjkOQdVAqZZHW4rTOuuyB7Yud/PVLTjhrkW9Xd6vhM7KBlxokjBLcS/8xXZXUG2kZbvOvMLcxbomSTlzpahi07zGZg7AJZ4YwT1a3pwtxeXTyHCZPcQodd+pF5WYN4CydDgSDzkzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(26005)(4326008)(7416002)(8936002)(66476007)(54906003)(83380400001)(66556008)(316002)(52536014)(8676002)(66446008)(66946007)(76116006)(64756008)(86362001)(5660300002)(55016002)(478600001)(71200400001)(33656002)(186003)(7696005)(6916009)(2906002)(9686003)(6506007)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7DKWNBHjU1JOOU2mvmM99SHurz01N3TbXRgbfUyXXXdcB+7NPOL75ayX7Ncm?=
 =?us-ascii?Q?AncxVca//w4d3396jXI12m8hWVc5i9Haorjo+8zm8uJ8oDs7ayQg0jNlN1ey?=
 =?us-ascii?Q?gFgesQq1tR1EKbLz/7JbN7MGuCqGNRqqwPkF/sXCQYNNlUCNAdwfm0BaNtN1?=
 =?us-ascii?Q?7uHC5uoIk0Fy4wkJAzJlxKGe04Ef69mmBVHM670LgafsbPkMoZXRwk9cuZNe?=
 =?us-ascii?Q?67aPEH1Wggl2wQbER9jQOC8zVSrhUFhVfhaAxQr/XM0/WBdolLyqe58b4bh1?=
 =?us-ascii?Q?9RR4aGaN7WEn8SswkKGufNqS1TjgTLJ+zG23iGm5sByPMNT1Chh4lZaerV0q?=
 =?us-ascii?Q?iR2Q9wGAgC7LfYJNMPuxj3KLlluQO8nfPPosp35sJVssfc41kIBk+if3eQNU?=
 =?us-ascii?Q?gnIAcZ9+75reWOTZdO1+T9qXnVEarUTN4yZAfMy/VFgnO3e6G28K17QnizTJ?=
 =?us-ascii?Q?g0lEwBKbmeFek31pUlD4DRydSd63K0y+PWb5qEsL9yKd/WZZ6T32KP91KHRm?=
 =?us-ascii?Q?0LRi7/yBrwI7KOKCZ+QDSET6uGMaSryLE3qpgdudXjo0NZM1aIzF6wp3bfcL?=
 =?us-ascii?Q?/aAYb8KQ2geAw0Pyn82dv9qJa2Inq9+J2VDeNHSsmqME9CKYvyAPXxmoLVsz?=
 =?us-ascii?Q?Rx8rOu6O/EAwPteSQ5ACl+r3P3n8BMQ2XTubpMrsq79GL9NN6ObaFvg2XBjz?=
 =?us-ascii?Q?1nCZk6xrl6T2qH8TSg/kQ9StFETkcjxa3th0G0PBUW7fDxMLrYKZKKp+HL9k?=
 =?us-ascii?Q?QBBaNLd0xrNFUvZ2d/6ag+WFSkcXHdV4E+W0z+0ND9icYFWtSbFhrY++2WO/?=
 =?us-ascii?Q?4vZ8IoO0TvTwB+POOpl3fY2GNDNkFuydnGBXWFDgr+nqUC+EoBu5puTwOots?=
 =?us-ascii?Q?rNyA6A1DxNiN3go9HSdt+2YZq5pQgjgatX5OH+3XJwoPU006tN9xjbRcPlbe?=
 =?us-ascii?Q?CCItJM8Fvjj9PtXcv2NgxR+ExL53x3bm1zSD9LOHtUhD+f/8jg7CrM60I5kA?=
 =?us-ascii?Q?LRnJB80AvB94w+XnOzxpShV4oSvvXvAK0rr+xGV+Ku3Za09LEyymqX/w6/sU?=
 =?us-ascii?Q?htfsV7uum9Dqrh/O+GFpoGgfTW7JBTpV7l2GCndudE2UoCOy5Gf59bJ4hTtE?=
 =?us-ascii?Q?Wwbl2DWwozaIC+x889o8MZJ7hckfW0oVT2JF7XWWFUmh2hmTsTXIGkkwl0Ff?=
 =?us-ascii?Q?GbFPeGNZ7U1IDedO5QcELHu8yImYQblVEvtcXHMEBW9xlGIQakyOvHnW37hJ?=
 =?us-ascii?Q?OuKKA1g/NS8DbmnUBF+vArKTTGEmemRk/25lg4FTt280mrAqq+GZwrjxu6yL?=
 =?us-ascii?Q?tN8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367e0795-c1f3-4f69-3787-08d8ce7da100
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 11:10:23.9269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PN31iiREet/Ts1ctJWenz0Ckoeq4RWWEfh4E2EDjrsyoaoARWok1XH2KYKTc2p+LTHlqUveWooBPY4yllRzBUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1488
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Feb 11, 2021 at 12:48:51PM +0200, stefanc@marvell.com wrote:
> > @@ -1199,7 +1199,7 @@ static bool mvpp2_port_supports_xlg(struct
> > mvpp2_port *port)
> >
> >  static bool mvpp2_port_supports_rgmii(struct mvpp2_port *port)  {
> > -	return !(port->priv->hw_version =3D=3D MVPP22 && port->gop_id =3D=3D =
0);
> > +	return !(port->priv->hw_version !=3D MVPP21 && port->gop_id =3D=3D 0)=
;
>=20
> I'm still very much of the opinion (as raised several revisions back) tha=
t using
> > MVPP21 or >=3D MVPP22 would be a lot better - especially when we have
> situations like this. Having negatives within negatives does not help
> readability.


Ok, I would update in next series.

Thanks,
Stefan
