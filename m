Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791141927B0
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgCYMEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:04:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59632 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727301AbgCYMEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:04:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PC1mLq021714;
        Wed, 25 Mar 2020 05:04:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=5TBxrK4G/qUd7MvabjLZy/0prUWGUNaFwhGOMA77Nh0=;
 b=HEimoWkHYFrNJbQViKavUCvg0K9h6z14TB7iHnQSPLJphPLgmb7NUhzYA5j03yCdN9Pw
 LttMAhscPTuUgTlLne9mBbbbl6hXKYVvAbSaWe0liiwQVGlfvU6N9xHTmWs62bGkmojw
 3zl5KmuJxB86oGYeSm7DJUJxdkxCnTcFuTgjEIZWL/MmxJXYa3+An1Dw1JwQ3GG+ajlD
 dgNb3w82c3UNy4fVKhWBmY5Vp+dNtycx+yQAcWl0xgnR6qZnPJ3TVI7Jj8fVvul4USYR
 DAP5DE/Jk47PciZOP48jE6KZUNGzx7OAl6mJ/v0w9Es34QyNYQ5PcXeSRvSSwfkD+YTL ow== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3006xkr0hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:04:24 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:04:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 25 Mar 2020 05:04:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaM/LJi7+fGJETr3VeAVgGlaZKdgjv1pxsgdr+jVIpUkKoUPlHVGLUxt9jfiA7MkZy6Vzp1h6A1KHcYuKjXex/EGXUIaiOPodGJmXIrctM03yHzV3gMTk2cnPaWfGJxfdUfbSJ3h5YeLFzgf8rBMP77+EaQKHFTuh/wvrLjiCW2chAiyxetIVj8S2sfxyfrnwuNUKeByDs5buoi35pQrn7YFzEF28SBZ+IMAd+tZ9SWmoLdF9SuaGIPTbzpdInnkxCUubR5qkGt+qBr5KqmoTMeAHejCLk4gNVp8/kE1i2uA0UKkP38YZJsZEIoNBni1tv5L1qTg0QJyt0ATUvKUlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TBxrK4G/qUd7MvabjLZy/0prUWGUNaFwhGOMA77Nh0=;
 b=RzQmO6/tTIlqXj2VDKjmZpftyRJu9lGBFwA6v/QNKZGQZNCqx31gcH3RdtsSm03Kka1d/A9wCiq7Pc6tC3ZuOUI6h4T+oOsGvucZeovVIqNhlBQm7jJBQCMa+DcXjruhvyLHyLWBfYTjsWIShBTlNBSALwRlUvXx9XTPHaMv0el8HZPOtszutG7LzU5bG4vMelchlHRAlaxLRLf7aGGqnXCuaEjkYiSDIwg7GUKUbPRweiPhC+0a5dfceHxek0rquirHObtkBWlsWXfQp4tFgup84/3VQ3CJzuN7ybINdBNsGRgxkuMvRPBlkCk9u9rp6gXl3p+W5evkTCbbSLkPJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TBxrK4G/qUd7MvabjLZy/0prUWGUNaFwhGOMA77Nh0=;
 b=q8t/o7Lks3+E+VEfEIyrowFMtJnYTnYy4P151/p1hoC1Wb0edvuDXqA0xmjaHBJ6PziGzxQa9Gu93EcwsUzSFkVoA2vTQqVdwI3Mo1c236QzvHDwuZeO9SNI+Pu2HKyVaVywC0muXQQDSph6MUIsEU1CCnGqapGcnc2unJlBnm8=
Received: from MW2PR18MB2282.namprd18.prod.outlook.com (2603:10b6:907:f::19)
 by MW2PR18MB2155.namprd18.prod.outlook.com (2603:10b6:907:12::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Wed, 25 Mar
 2020 12:04:21 +0000
Received: from MW2PR18MB2282.namprd18.prod.outlook.com
 ([fe80::1891:ade2:175e:b885]) by MW2PR18MB2282.namprd18.prod.outlook.com
 ([fe80::1891:ade2:175e:b885%4]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 12:04:21 +0000
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     Joe Perches <joe@perches.com>
CC:     Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 13/17] net: atlantic: MACSec ingress
 offload HW bindings
Thread-Topic: [EXT] Re: [PATCH net-next 13/17] net: atlantic: MACSec ingress
 offload HW bindings
Thread-Index: AQHWARUg3YERDLlsYEiKGr5T17oz2KhWb/wAgALHHRA=
Date:   Wed, 25 Mar 2020 12:04:21 +0000
Message-ID: <MW2PR18MB2282EAA0B0F3CC9B2BE60027D3CE0@MW2PR18MB2282.namprd18.prod.outlook.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
         <20200323131348.340-14-irusskikh@marvell.com>
 <df5c9ad7a5684e3ee0998559aebd9755cf70ee96.camel@perches.com>
In-Reply-To: <df5c9ad7a5684e3ee0998559aebd9755cf70ee96.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.161.221.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbf2a625-a6fe-4a02-4f19-08d7d0b4a734
x-ms-traffictypediagnostic: MW2PR18MB2155:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2155914B0EBF29F19DD53EFDD3CE0@MW2PR18MB2155.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(5660300002)(316002)(86362001)(6916009)(64756008)(33656002)(4744005)(55016002)(52536014)(76116006)(9686003)(8936002)(6506007)(2906002)(186003)(4326008)(26005)(66946007)(71200400001)(66556008)(66476007)(66446008)(54906003)(81156014)(81166006)(478600001)(8676002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:MW2PR18MB2155;H:MW2PR18MB2282.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n7EvPPjREo3S4+/avk0FQexQWfhDc5TGXcmwIlAU2YAyfU3ARMIK/G7rOfXFU1ReI5mdvKUSbn2uzjAMuG34a6CvyFQJ7zr1/455WrqU6DTcPTpCMBc5dCRcIUhU46y+r9a9FCKtE3PLthWj2YI4/bNr9jBZ1dOp/EN4Prl561EOoOFJUJD/isjnS5w7LmP1xggF50/k835auQy8/dNUD3oNaIJVRybPCRGik671eDqt57htmoy5NcPmEXMEJe75fn98Cl5LKVhT6ZAShnKmnRKujSI/5eig9EqYMNk2Oq9y0wYrCNnfRSNwXx7JiihKZMZx1l6LjymNuPJYicsjtfDxPtYvjXknSLURpEpCveRDyGS5wMhPrpXp4UcdR+03x4Hi0H97mVy09A/E6/EOTfbkAZV1917VS/v89oke4Dl5IzRHv2hg9s3fZu8RT45j
x-ms-exchange-antispam-messagedata: m+vAf32rF/sLVjqW0S5EWzl2EF1UsQN21q0xQYrARncq6p58gqRSWIIErXig2b5Zquczf80k06oG3Le2G/820bLQEhlhAEsf9v3ztW0tfoSKnp+WcbdcfmYH5dpHskXqgztwRdwB/UShz8Wj+51eVw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf2a625-a6fe-4a02-4f19-08d7d0b4a734
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 12:04:21.3278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YKcDYdvXPjRxN4HTH8QGkN+FA9YE2IfbrLSOl8nNd7bB0m3ViCgjQIUV34cHh+yD1C0cLDgunk/hixPfy80deoHFjQl05uqzv8j63G2KHEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2155
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

Thanks for your review. These comments will be fixed in the next version of=
 the patch (along with the ones you've shared for patches 14, 16 as well).

Best regards,
Mark.

-----Original Message-----
From: Joe Perches <joe@perches.com>=20

This sort of code is not very readable.

Using val & 0x0000 is silly.

Using >> 0 and << 0 is pretty useless.

Masking a u16 with 0xffff is also pretty useless.

It seems a lot of this patch does this unnecessarily.


