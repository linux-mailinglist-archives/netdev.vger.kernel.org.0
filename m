Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B543F7B02
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhHYQ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:58:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14966 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229791AbhHYQ62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:58:28 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PGs7n9026997;
        Wed, 25 Aug 2021 09:57:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EMmubK/Diwfqxqr6eDjc5qrOUqc/ZEg85I8WYRLJc4k=;
 b=PtBfWAOAVgnAan+vyn31XHSMUb+K6uSvVlJ1Ptzay6F/b+FCHkwlIPqFcK/ium9KkoRm
 A6JmkfojgbpOra7vgIMZxMw22q6QsL5TLfwc+N9C/iW+dNASKLEFZvvdeJ6J/1sHIUfI
 +5/QDU1iSu6/Sz8fmLoYDub47w2Jy/R6xE8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3an3pc8959-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Aug 2021 09:57:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 09:57:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=al4qWtY2V6ISILQ7zBagxIdeXLMQLHZleUxTVD9V3qSn16JLyBljjx3vxFYTxagDrrqWezZf2qvkc1LjinDFMjaFxVMInhjhyNrQSjsTG4Xy6NLPZawmbjL337y6zUwd90nVBeoNM0rO7LS1YtS+kwRrthWgirD4mkEytb2A7Ue0D72wyAgANx84k4bK3jC2M6cEM7i6wkVE9JUgdzrXmDD1WVxvlBcUPwb3AV0uXB+XLplmpodl9yrtSE56qvQaeE9lzrzDFgUbNPRocsfiqI7SKadhvRM/iFGv0tX72F6TX6XOJxQbp9MXOBXF+ZN+HwTepa4ERa9rwET1YbHpzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFwI3tOWE/OYUBFEG8qO2OFncp1fy3YCriX+xPZBJqE=;
 b=i4ab8dMgwCczU8IBB1DXNilWxev9fnAjw8S+EtMPF0n+bwt0OJNCPhOf9rbf5mJBR2bqQPdRpZshLo3kq5c+g3zauarV4uXq9/iI3utmrsudJ6jnH0Qyxbcfvau8CoV2eZIWUR4gQw67TY0k/PvbitjPaXPjZ6qOZK4lLGxjI8I8arKvU5M7a9SZ9YHHHrUF0+tylIaMbLYHKYRtEPwPNJMLATvYw0puts+Imz8E4aIdRTmKVaYW6oVneGLY7u5iIcIKkeCY30sTm5pl8Q8spJBqLRLKYK/yp6uudaRgG7huOcWJdYYTEPDdqpSfz8/PJyyOYH3LVCRSEs06KdDMDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2518.namprd15.prod.outlook.com (2603:10b6:a03:157::25)
 by SJ0PR15MB4599.namprd15.prod.outlook.com (2603:10b6:a03:37c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Wed, 25 Aug
 2021 16:57:31 +0000
Received: from BYAPR15MB2518.namprd15.prod.outlook.com
 ([fe80::e4ab:a5a3:304e:63a4]) by BYAPR15MB2518.namprd15.prod.outlook.com
 ([fe80::e4ab:a5a3:304e:63a4%3]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 16:57:31 +0000
From:   Neil Spring <ntspring@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "ycheng@google.com" <ycheng@google.com>
Subject: Re: [PATCH net-next v2] tcp: enable mid stream window clamp
Thread-Topic: [PATCH net-next v2] tcp: enable mid stream window clamp
Thread-Index: AQHXlTQfKFkAskglpkOVK0EMsm2wlauDi9OAgADaGdc=
Date:   Wed, 25 Aug 2021 16:57:30 +0000
Message-ID: <BYAPR15MB251818EA80E5569A768F0EC5BAC69@BYAPR15MB2518.namprd15.prod.outlook.com>
References: <20210819195443.1191973-1-ntspring@fb.com>
 <6070816e-f7d2-725a-ec10-9d85f15455a2@gmail.com>
In-Reply-To: <6070816e-f7d2-725a-ec10-9d85f15455a2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ecd3637-a1df-48ce-e8b3-08d967e96d66
x-ms-traffictypediagnostic: SJ0PR15MB4599:
x-microsoft-antispam-prvs: <SJ0PR15MB45994F28A2FF790BC32573C5BAC69@SJ0PR15MB4599.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XhYBlcQSCl0NaAYDTliX4lh/Q8sGyAVDlUXoiBO8SDic4X8b3p46wyXTYHMDHCTyQd4TcmFfZNr2Af4Pd7Gl/MUqswKqWtvuwFgUe36WI9aGjU6fLjg3PLQuQg+oSX+SNaewKflalOLdf1n+3vkOfujuWTgTMcJGe5e5FKVlY97msyt0BbcifJIptY2ExxzCwKCUP8gbFJVG97H1ysGgyxHdoCIzFu8EI2GUOK7FAdJm204qSFGwVL2ga5+dlJGHUa+jJtAGC05/XLadr9Mr2YynZe9HeKMWnyLQE1CiXh6GkobPcMIgMAvgp7vWCAOw78veFeGdzgeADf2dX9/6rekuybN9B5qM7JcTXM2bMxSeNhziV4+uXGWwloFn6HKz0K9LZbvF/fc5XLoxS5QyFM8nlsMAGS5OBe+WN3uuAsftSXEsLHQBVmcppG0blWYybCCALuSU3hNsp8hT7C+8emhiEgtoQNhTnNgjrZSbV6jM/qBs2VyZXASw+rbDyWlQPG4rnpI24vca7a5DE3TnMDtLQNeCbtwSKVjAPQuIO2nptkB6oHV3Ovl5yOPWyUvme+XGI3042R1E1HAohbEd2dGxBAahK9JTB9EvyAsSGTp1u8LURyXJ31ISRYqlQbMKWmC0oVKNrfUuSIkSmd+MtV3XMvWrx2ZKCBHW0k5z2b/IGUhukYS2d5p893W7K/x9njmAfk6vRz0DjL4TRj+6GOf7n5Kw70uB5o/tlXQ3VjIC/h2DSzc14TuQGcrkNqrByqWqRq/2+MqN/pGtjMa64gX4AAk7Jdpfjyd7e443Uo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2518.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(5660300002)(53546011)(6506007)(4326008)(8676002)(8936002)(54906003)(110136005)(86362001)(83380400001)(38070700005)(66476007)(55016002)(66946007)(9686003)(7696005)(66446008)(52536014)(33656002)(64756008)(66556008)(186003)(122000001)(76116006)(966005)(71200400001)(38100700002)(2906002)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?eswnXQqNBiSsGojd+ES9r9IAg6hEGAvzB5ZKf1fSwGismNuDYqNXESpI3r?=
 =?iso-8859-1?Q?zw2PDUNG5RmQTfg+k4aWK1uOkOCSymQXU1r01pw9WnpThJf7DvZPelDSCl?=
 =?iso-8859-1?Q?rQqv9Tzunf+U1r6zdUAJIXyzLwxRmUmmwRsN8iJaCCithlCLap+gC968tp?=
 =?iso-8859-1?Q?1ro6LAef10Q3FQIzFtVJH+TxxugbLlK1Q5XTbTpfNUNimRoq0W6yMnafFG?=
 =?iso-8859-1?Q?7Gz6Ig0gvx56u8zPAOq31/j+OwPJX8hkEumtyM9JR2TeVVqkhM2BdmqfWl?=
 =?iso-8859-1?Q?euftvGLPbdqj3Efa69VZCfy4m/k6N6Vd4LfcK8h7zv83hh8rb12pvz30Ih?=
 =?iso-8859-1?Q?kiPeJOl++v9xBma2DLVdFflSbu4Ffw9dwhKWcyAMdU1m+uUnaE968G7VQD?=
 =?iso-8859-1?Q?Ry/hsm7PIqEhOp8giXWJpxkmTKGjBTWGnzg9HjRxa9ua6gEuYgtwDi/JbC?=
 =?iso-8859-1?Q?oP9azAf7wQkL7fUusouRsWgPEuY9n/OCCZlpeJkUyXtvPdxDAOdPoEM+2f?=
 =?iso-8859-1?Q?mYhF/4M1dMY9GzIE7KS79zgIlZx+yO1gFC6g/XXE5bp+IbLQcFcmPom4SH?=
 =?iso-8859-1?Q?Q5iYkkts5VP92lUfUcU/oJl8pklP8adZAi/M5UohqRV4JWMbEmuTP9jSEB?=
 =?iso-8859-1?Q?9Pjw8pLA+qvs9t+1CBWL0AQNl4fuyMmWOAsycuLAgW/3AUF98w6rvg8EKI?=
 =?iso-8859-1?Q?PZSIcO8aiZF2STvyDH8gvWur8PPb7scteM3Ee1xAbwp0EhlnI8DPV++jSd?=
 =?iso-8859-1?Q?frxGJA6QgB3T3oYt6AHt5FfADxo5xuW4Br+phj6jcG8dVr5Jt2aZbQtVTV?=
 =?iso-8859-1?Q?Y22TXlKKrbT8ukjOvjO7y55l2QTtaGKCzqs2dhLfPzWCs2ijhRPwRPvca5?=
 =?iso-8859-1?Q?gseSI1+i9rwJN6UG/YEmdPO8HpSdKXIvpY6iyE7IsHXPBf0oy1XGkd2aO/?=
 =?iso-8859-1?Q?BrViRNAPbkKfll0u93J9CP4tCkrxFPVoBBmfM/yoyyEUxTLWeLxP4g+Ch/?=
 =?iso-8859-1?Q?ZhiFbS3tsbdvyTvV/bla1ut19EsLbmp6Zf/+Ly+FgcTnWr1Qo9fXf3pBGN?=
 =?iso-8859-1?Q?1hRdnzKsK3ITvPDnaDsPcYDPIlamPHJxjXOHg9hxFWMwe0remfxCCzt+wG?=
 =?iso-8859-1?Q?igQLB7X5Jr2bRLOLTZ38PVrG8ZcpCvuKBvhCxVWlvR/kSurIEP2y1lQvih?=
 =?iso-8859-1?Q?JUqZnXHo0rXj+JzZQK7sY4gq9ADb783T3o+5M/JqO7BASTuiJuei5k/FBM?=
 =?iso-8859-1?Q?AJgjv1FfHPa66agT5oMg+t7o2MvCVuIiJQb5zaIjI2MOqEGQM8pjqnH6u6?=
 =?iso-8859-1?Q?I+yyOEDQX1TPv9CDTZvctX4d381UoVK9S7LYiJB7C89/BjvPuDN+PbNjW8?=
 =?iso-8859-1?Q?R+aAj2e4Ago1HExU2n15nTL1awwYGm+A=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2518.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ecd3637-a1df-48ce-e8b3-08d967e96d66
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2021 16:57:30.8548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: luDS4u0Ykany1OI3h1VWC28qrDFXcXXVwIavfJRmG1TopnYh7QsgExLMTue6J1sd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4599
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: gub5MoI8PtGW7BYKRZ58jToIzmcRWV95
X-Proofpoint-GUID: gub5MoI8PtGW7BYKRZ58jToIzmcRWV95
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet wrote:
> On 8/19/21 12:54 PM, Neil Spring wrote:
> > The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the s=
ize of
> > the advertised window to this value."=A0 Window clamping is distributed=
 across two
> > variables, window_clamp ("Maximal window to advertise" in tcp.h) and rc=
v_ssthresh
> > ("Current window clamp").
> >
> > This patch updates the function where the window clamp is set to also r=
educe the current
> > window clamp, rcv_sshthresh, if needed.=A0 With this, setting the TCP_W=
INDOW_CLAMP option
> > has the documented effect of limiting the window.
> >
> > Signed-off-by: Neil Spring <ntspring@fb.com>
> > ---
> > v2: - fix email formatting
> >
> >
> >=A0 net/ipv4/tcp.c | 2 ++
> >=A0 1 file changed, 2 insertions(+)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index f931def6302e..2dc6212d5888 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -3338,6 +3338,8 @@ int tcp_set_window_clamp(struct sock *sk, int val)
> >=A0=A0=A0=A0=A0=A0=A0 } else {
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tp->window_clamp =3D val <=
 SOCK_MIN_RCVBUF / 2 ?
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SO=
CK_MIN_RCVBUF / 2 : val;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tp->rcv_ssthresh =3D min(tp->rcv_=
ssthresh,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tp->window_clamp);

> This fits in a single line I think.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tp->rcv_ssthresh =3D min(tp=
->rcv_ssthresh, tp->window_clamp);

I'll fix in v3 in a moment, thanks!

> >=A0=A0=A0=A0=A0=A0=A0 }
> >=A0=A0=A0=A0=A0=A0=A0 return 0;
> >=A0 }
> >

> Hi Neil
>=20
> Can you provide a packetdrill test showing the what the new expected beha=
vior is ?

Sure.  I submitted a pull request on packetdrill -
https://github.com/google/packetdrill/pull/56 - to document the intended be=
havior.

> It is not really clear why you need this.

The observation is that this option is currently ineffective at limiting on=
ce the
connection is exchanging data. I interpret this as a result of only looking=
 at=20
the window clamp when growing rcv_ssthresh, not as a key to reduce this=20
limit.=20=20

The packetdrill example will fail at the point where an ack should have a r=
educed
window due to the clamp.

> Also if we are unable to increase tp->rcv_ssthresh, this means the follow=
ing sequence
> will not work as we would expect :

> +0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [10000], 4) =3D 0
> +0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [100000], 4) =3D 0

The packetdrill shows that raising the window clamp works:
tcp_grow_window takes over and raises the window quickly, but I'll add
a specific test for this sequence (with no intervening data) to confirm.

> Thanks.

Thanks Eric!

-neil=
