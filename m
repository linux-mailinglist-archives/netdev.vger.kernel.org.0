Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084DA3F7D55
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242616AbhHYUuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 16:50:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64950 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239932AbhHYUt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 16:49:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PKjLbr013376
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 13:49:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GcTSi841fh5reSbkrICPRLJMTw2B/HyLVuMNZSHsK1o=;
 b=LSY31QU0Doup1JXAU+LDOlc3uKyzbItD8fKmIGGa9tILrAQqw+qvDxgv2qiQB1WET9Yc
 MRqT/vrlTOIJPv6bh9bgxOX+jWfJbBcGntlFgQS7LKwNsSftHSb1sryG6jb0zg3B9Haz
 ckhdmSC8SIgHGf+SWWBi4p0YQkkoUtizkMg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3an5sm8jec-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 13:49:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 13:49:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TU5EIYoQlMGFzZazJEhxQrOhC0qwzagrAKIO8PyVO8H2sQRa59FdJlYKYl1/AGW2/JTxOImqOxErlg4j8d8n8Yu16Tc60q2FwaGw90221OzJPQZl+J/up+Odj1ATaZUC1KDeoCztZvWY5PbXk6Oa0XlaJKVvi8rq2jq4lVg3L0fpNueMmcJd1Fab9IpGKLUARM2CmOu9qjPMorSV/4vSNyshhGYIe1iQnTOYB9LWySJGl0px8vud/FhAWG4ZBseR2b1qHCzlgOer72FGfZ2eVi4wYa4rwSSxbPi9kGxINYqliSZSZbI7oGqOAmScQOJTiU2aWEut3/Ga1hqxlUilTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQJph9wGS9tJGhyNXHfinL40dXoQhTetZnwaJFQzAmM=;
 b=iom39A5x6KyLnFIGn+lwk8JRrSo9+YLOQCRax+A8tlILHJY1P7RNGNYBIcc5bP4oW87/bDxxtIJV0E7xs9hb58qwnihOEqZNFm4huVDauGu15E7TXiXMZnpa8t1VoKTAYyy2tdXJCMaOVdRDXFOtgZbDChTNipTNJG8JQ0bg/D/XGXZKwz5Yydj2jFeEnUueaYoIteLoqmFVPE2+quDgnrBTd8DXHkihh0Zrw75VlJeP44Q/PoaWdm/1qMYVuGqcnAtlD01Lz/jHSFiBCnTlaMiPkISSRIALdT066c6Mo2yUg837OXbOcuyph007VqsSSuwOfkrJe4TVp5eS8xKmXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2518.namprd15.prod.outlook.com (2603:10b6:a03:157::25)
 by BYAPR15MB2807.namprd15.prod.outlook.com (2603:10b6:a03:15a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Wed, 25 Aug
 2021 20:49:07 +0000
Received: from BYAPR15MB2518.namprd15.prod.outlook.com
 ([fe80::e4ab:a5a3:304e:63a4]) by BYAPR15MB2518.namprd15.prod.outlook.com
 ([fe80::e4ab:a5a3:304e:63a4%3]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 20:49:07 +0000
From:   Neil Spring <ntspring@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "ycheng@google.com" <ycheng@google.com>
Subject: Re: [PATCH net-next v2] tcp: enable mid stream window clamp
Thread-Topic: [PATCH net-next v2] tcp: enable mid stream window clamp
Thread-Index: AQHXlTQfKFkAskglpkOVK0EMsm2wlauDi9OAgADaGdeAAB17AIAAA6Zr
Date:   Wed, 25 Aug 2021 20:49:07 +0000
Message-ID: <BYAPR15MB25187B02A7CEDF097081445ABAC69@BYAPR15MB2518.namprd15.prod.outlook.com>
References: <20210819195443.1191973-1-ntspring@fb.com>
 <6070816e-f7d2-725a-ec10-9d85f15455a2@gmail.com>
 <BYAPR15MB251818EA80E5569A768F0EC5BAC69@BYAPR15MB2518.namprd15.prod.outlook.com>
 <CANn89iLjeY6PBACwb0CetwUC3Pn-rryAqsCNytCrcFRwtwC6GA@mail.gmail.com>
In-Reply-To: <CANn89iLjeY6PBACwb0CetwUC3Pn-rryAqsCNytCrcFRwtwC6GA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 282b47ba-6da4-4296-4f08-08d96809c83c
x-ms-traffictypediagnostic: BYAPR15MB2807:
x-microsoft-antispam-prvs: <BYAPR15MB28077566E8F1F45035E355D1BAC69@BYAPR15MB2807.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hHqwr3i+DEknqNbnh6C4/20ePEh34NzIY5fLYSqZ8jWn7kpIko4JChlJsQ+v8iUsSzN4KYRdz4wvxYvt/nTe65a9W7FyketxHs7o0vjc9cRqamqpa59Q12qQwDjGHRuli/MdMgSPDd0/rqrbiXTtRJYjgjNFn1ycq35y7r5C7Hg1JLZ5dZU4A/MXoT/DMl7FT5Cl7qQ+RqQU9lUdhIqE5ERcOk7bAeJPAEum2rJopxww0iX41yPnk5YGRayy3TslZKDmgI/6WQ3oh0Bk5jsL/+pNHvkyAQNAarZiaim2MdsZwxYfsm3SsVUp3N7tqzcm7JvrFDD0bqpzchjX51iWee1XQVjuO0VwkWEpc+XC3vp/TDbJllOeb1VEEs6qYh98ah1/bA/wvEUVHKomQZqmvAkjYDxWjaDcrOKrLuRSUbJ8Z9nSoETxAwbHFkLG2WTVpa+ZWjmQrIucmVQZxT/WyJSGJEiobMVOz5Ffp3b42GjmP2OCayGhKFEj281gyX7TnAqCyztx/hOTrDTlgVQYO7k6jwSkhF2BhWVep2Wt8ThSmKY7olLdHHwZ1vnJ2WO8cidlqd/lhnoXSo7G189nJmk20s+zQmOQzbhUQLKPbLH4l39qNvwGw5jCJnGAQE5cuECwmNp7nDG0ky2ZmjXzpOQoW4OiHqymNFtaHEvbtbNTCdDUvll6gjhobMPYLkryjHDmY2DDHZvDY/zBrMoNtyC32+Pkw1g6vkR6NDhdfvFJBSEX4CpBtMmGUxO3pTSkU7oTiambF5HRmvbasWG9D149DLBgmLrio8Wf1D5nLwY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2518.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(4326008)(33656002)(5660300002)(6506007)(966005)(8676002)(83380400001)(38070700005)(122000001)(2906002)(8936002)(66946007)(66556008)(66476007)(186003)(66446008)(64756008)(478600001)(54906003)(53546011)(38100700002)(86362001)(9686003)(316002)(55016002)(7696005)(6916009)(71200400001)(52536014)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bVe2llLafiADLeOEdAlkArKbxP8CTciI/tYWry8dZyWK00pA9nkDus0YVB?=
 =?iso-8859-1?Q?R3W6hM53/YVomLzdus7hp8N+8wZ+dQIoxGjNp1LVc1vTajWD4gtl7g0A8T?=
 =?iso-8859-1?Q?CyD3T7KjgGau/HGAOg2C6PjuBhmDZFlSH0WOiw68jwwVwV6kVnDjQ1+jmN?=
 =?iso-8859-1?Q?cIlm6lcJiLkEbQcTuCAt49Y7b+CD8lQKWS3ZBH7SRqm3HvxU5JRqsGF8tU?=
 =?iso-8859-1?Q?bj6yizj7bwMFa6qOl6TjyCnvX7tOlA+xmMoUSVeGxv8Rg/8EKIyL2ZVxCs?=
 =?iso-8859-1?Q?QFXM7vVEQ2I6Tej8m+3VLPm16udpHmt5lmWh5opMhd3yqr6/RX+4jm5++a?=
 =?iso-8859-1?Q?Math2V6ISdTwnwmH5fwUQZHz8ppYMlfpzL7dr3uDVWNFQW0PqiITLS6J+X?=
 =?iso-8859-1?Q?ydTJKcz2CJznenYXXs5t51q1SNKNImAjgVTBkpMjE1wtIIJwvWkcfXThOm?=
 =?iso-8859-1?Q?I6tKAFTsU7lJ6Nrq4TlQ3qU4+K8oWCFzNH1imnVkApiUsDjACw+Ef7gaTv?=
 =?iso-8859-1?Q?8wfX13CxcPBr6upb/sKSwsPLKzCSkYCxNk6sz4NYw/ehqaqqk9y/+a43Zv?=
 =?iso-8859-1?Q?AUmJUlSbL5Z9dhQJHc+oGC1pQ0hYGmhWfq3/R25Kw0UFHSFeF9fC2vhiHe?=
 =?iso-8859-1?Q?wkA8CoiUSTNZlLkrQ09SKHOKJZ7a82fstbaLQAQyX/cZkpRiyvnBjSXJs5?=
 =?iso-8859-1?Q?iUzoP+zXW8oKM7psPNMQXRPtvEoahbHGpzfQn9WfwFden0CPQiqGk0319D?=
 =?iso-8859-1?Q?ytjO5GBs0/GSsKWHDMbqEh1xCMiJ0J8ERNXcHTHXZEHqByHK9agOxn/PWC?=
 =?iso-8859-1?Q?7xNzjzMRTxpzsuMUQrDZL+Bcx5rUc2BoHnnSl1yesWfvYEvzJPrlAhSdil?=
 =?iso-8859-1?Q?0QmWfcCdqPqYe/b9S6kZp16ccllnqmSx2i8xbCq7Ak6DVvo/8hokP7hPiH?=
 =?iso-8859-1?Q?xdH/5fS+gNoBF4GccSsAgQdonGobKePlIZQXwNG+wlle3KXw5Kbvp4Pb0a?=
 =?iso-8859-1?Q?C9/Cl1uU7w/gTAsVculKYm1v5rFyuFYtMkBiydtiyzbmgW4f1M58KIQRqG?=
 =?iso-8859-1?Q?GobYcq+a4+eDoKc3r7wQ2NXycf9fs0o35vE1E52IQ4t4dVhXtJd0XyH+D0?=
 =?iso-8859-1?Q?xM/r+WXbPId9coEbRUv1mwLhC4qXT2dQhRAqS3FrgoWCEsOzKA6MGqIf/+?=
 =?iso-8859-1?Q?56i2wdxuT40YFUD9+ZnatgtiANZ5hhAY2VjaOWBQHVDfignXdw/P9ey/+M?=
 =?iso-8859-1?Q?4bR87Mk7M+T0uIFjzm7/fW1ve8GxYatO5UDc9HCMngT1lL/Do22oXlEChD?=
 =?iso-8859-1?Q?Kx6f4JDYJO13czioTU5UsHtNacLFKXaWT0rRTY2Ew01PXTo5qGSEoSmjdU?=
 =?iso-8859-1?Q?9HnG4FrJUjRW3Ra7W74K7HMGw10mIafw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2518.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282b47ba-6da4-4296-4f08-08d96809c83c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2021 20:49:07.1326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CGIldIHdEvoUaRHfD75oNp14BNi2qsP5IddFbUI7BZg2/+n8Y0VCSlgYQAIrP21c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2807
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: lqDPycLG63-UI7XrENtZjoJMkPB19dQU
X-Proofpoint-ORIG-GUID: lqDPycLG63-UI7XrENtZjoJMkPB19dQU
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet wrote:
> On Wed, Aug 25, 2021 at 9:57 AM Neil Spring <ntspring@fb.com> wrote:
> >
> >
> > Eric Dumazet wrote:
> > > On 8/19/21 12:54 PM, Neil Spring wrote:
> > > > The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound t=
he size of
> > > > the advertised window to this value."  Window clamping is distribut=
ed across two
> > > > variables, window_clamp ("Maximal window to advertise" in tcp.h) an=
d rcv_ssthresh
> > > > ("Current window clamp").
> > > >
> > > > This patch updates the function where the window clamp is set to al=
so reduce the current
> > > > window clamp, rcv_sshthresh, if needed.  With this, setting the TCP=
_WINDOW_CLAMP option
> > > > has the documented effect of limiting the window.
> > > >
> > > > Signed-off-by: Neil Spring <ntspring@fb.com>
> > > > ---
> > > > v2: - fix email formatting
> > > >
> > > >
> > > >  net/ipv4/tcp.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > index f931def6302e..2dc6212d5888 100644
> > > > --- a/net/ipv4/tcp.c
> > > > +++ b/net/ipv4/tcp.c
> > > > @@ -3338,6 +3338,8 @@ int tcp_set_window_clamp(struct sock *sk, int=
 val)
> > > >        } else {
> > > >                tp->window_clamp =3D val < SOCK_MIN_RCVBUF / 2 ?
> > > >                        SOCK_MIN_RCVBUF / 2 : val;
> > > > +             tp->rcv_ssthresh =3D min(tp->rcv_ssthresh,
> > > > +                                    tp->window_clamp);
> >
> > > This fits in a single line I think.
> > >                 tp->rcv_ssthresh =3D min(tp->rcv_ssthresh, tp->window=
_clamp);
> >
> > I'll fix in v3 in a moment, thanks!
> >
> > > >        }
> > > >        return 0;
> > > >  }
> > > >
> >
> > > Hi Neil
> > >
> > > Can you provide a packetdrill test showing the what the new expected =
behavior is ?
> >
> > Sure.  I submitted a pull request on packetdrill -
> > https://github.com/google/packetdrill/pull/56 - to document the intende=
d behavior.
> >
> > > It is not really clear why you need this.
> >
> > The observation is that this option is currently ineffective at limitin=
g once the
> > connection is exchanging data. I interpret this as a result of only loo=
king at
> > the window clamp when growing rcv_ssthresh, not as a key to reduce this
> > limit.
> >
> > The packetdrill example will fail at the point where an ack should have=
 a reduced
> > window due to the clamp.
> >
> > > Also if we are unable to increase tp->rcv_ssthresh, this means the fo=
llowing sequence
> > > will not work as we would expect :
> >
> > > +0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [10000], 4) =3D 0
> > > +0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [100000], 4) =3D 0
> >
> > The packetdrill shows that raising the window clamp works:
> > tcp_grow_window takes over and raises the window quickly, but I'll add
> > a specific test for this sequence (with no intervening data) to confirm.
>=20
> Sure, raising the window clamping is working (even before your patch)
>=20
> But after your patch, rcv_ssthresh will still be 10000, instead of
> something maybe bigger ?

Ahh, I think I see, thanks for your patience in repeating the idea.
I'll alter the patch to set rcv_ssthresh to:

  rcv_ssthresh =3D min(rcv_wnd, window_clamp)

Walking through your example, assuming the host just advertised 50000 bytes,
it will raise rcv_ssthresh immediately to 50000 when raising the window_cla=
mp field
from 10000 to 100000.=20=20

I think this is consistent with what rcv_ssthresh is meant to do, but
I could see a case for eagerly increasing to anywhere between rcv_wnd
+ rcv_mss to rcv_wnd * 2.  Happy to update again if that seems useful.

I've updated the packetdrill pull request with the new behavior.

> >
> > > Thanks.
> >
> > Thanks Eric!
> >
> > -neil
