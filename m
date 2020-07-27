Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4A522F7DC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgG0Six (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:38:53 -0400
Received: from mail-eopbgr1320122.outbound.protection.outlook.com ([40.107.132.122]:47133
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729243AbgG0Siw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 14:38:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TawBk1AR9IpX/J95SNpvSSz5sMcF1yurD3Trt7ciFTOv25ofCnJkVuo4Yjka91jYRs3zACdxGtvCzCLDT75ZRlH29xmlMNzU9r4mUetAfPWXnsVSxGYElfFZTPfl5mbSovGW1/rNfcvlqFGXuPjm9bmWnmDzvYKuKs4NfrPDIxljIwW0R46WhZHDvOxt4CXLk9rPVHQ+2VlaNsXqRKZBKZi+wqGFIu16rBaVcqXgZns3H/9hFGLt05LgVB5qvYz9IUgVOWIajRZRGjnmOfbJcLWrirlJIBvhHgaUjq84imXzE7PexugV0RbnwVuApsyybbp7eAK891UQsfaw2QBzow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlK79LFa5hTcPIEp6zbSSRGa+VF8t9R4YoYtmUxeLfo=;
 b=lFqbTMnBD5ZkAyD+GFgkiJnQnb9YSSW5UnR2NfJ0wG7e9RJfHSOTiaSsf71f/OKY/p2FXuVYNtN7Wq3H5Rrhf04Yb0vNGo6cmY9SlSVrujULnDGvx+klFWfBSVOufnWUw8CnjP7C7oUaKgUbRFfkj02jr66JCqGoTXfgoObfnlV07SjkHZFHwultPVXykaTX+yu6eriSxIPKwxZ5x+BHLAhZLy8auzQK+0TyT6djjq4Lq4JsB+Kf+SgbAKU9p0YobYg8QemXQJ44FqrO/KgSnemTT+j+7vJ9ie42W0Bb5P9B3O4T8RWoYcJ/Pg+MTO7KEAJIJ/lEd8yf+wGnFV3lRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlK79LFa5hTcPIEp6zbSSRGa+VF8t9R4YoYtmUxeLfo=;
 b=ImWg6FpzJiE+g/2ciVqGIkROhdO/9gA6RC1W3UOzsu99KWDIcagKcmtfQnjnUHpQ0YZH30uaK6DA0bvdtfAG5JE/X3a6LzIuAhBloBDXqZ2f+/I5cI+TT+4XeRTv5We/R9uzp9+RkRQP1OFDx0T/fgHeK2c/r07NiCUdz1wzx20=
Received: from KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM (2603:1096:820:10::19)
 by KL1P15301MB0247.APCP153.PROD.OUTLOOK.COM (2603:1096:820:8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.0; Mon, 27 Jul
 2020 18:38:39 +0000
Received: from KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
 ([fe80::819:688c:f8fe:114d]) by KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
 ([fe80::819:688c:f8fe:114d%9]) with mapi id 15.20.3239.015; Mon, 27 Jul 2020
 18:38:39 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Greg KH <greg@kroah.com>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        'Eric Dumazet' <edumazet@google.com>,
        'Willy Tarreau' <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: UDP data corruption in v4.4
Thread-Topic: UDP data corruption in v4.4
Thread-Index: AdZiJnBIPDXmVtR1R7+R+22vR2xKPAAIjTAAAH8LFZA=
Date:   Mon, 27 Jul 2020 18:38:39 +0000
Message-ID: <KL1P15301MB02800FAB6F40F03FD4349E0ABF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
References: <KL1P15301MB028018F5C84C618BF7628045BF740@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
 <20200725055840.GD1047853@kroah.com>
In-Reply-To: <20200725055840.GD1047853@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-27T18:38:37Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f4f0be8d-f5a8-4b6e-b521-7d33b69e56a4;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:9dd4:7c1:bb91:342a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 416a90fd-627c-41c6-7ad2-08d8325c47d4
x-ms-traffictypediagnostic: KL1P15301MB0247:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KL1P15301MB0247F615DD33C43BF3923926BF720@KL1P15301MB0247.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TDzeLpTjULb1Cs0ChaSB896pQQsHnUV6Yb0Ds6TSRh7izZP5kTcu36cH1W6kphJ1DoxK/wN3FngejR9tT9UiXExIw+DnBgxES7FyPAxv3cYxcOit03sXlM2hVmzOLCSzU8rcmPbJCP9AzKAV/xz1P+IJ/a9LGRBBcJXppLD8vq4nNu/Xu4WEjYYPQhGsfPkTG5VYQGPUeUn712iKo/s7e3wHHDGlVHbK9u3w34iitXEx5gHVyixAEQXzaY08DZrfshMwk9Qc0r+Kvfo3MfnjIrQ+B2LIV2XZHwIHsC/EzEpUwC0tLxMm9EyFsPP9lTMAeOuI7Y+TaHqOiZk+L0V0Zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(4744005)(8990500004)(6506007)(478600001)(66946007)(6916009)(33656002)(186003)(66476007)(66446008)(64756008)(66556008)(71200400001)(4326008)(10290500003)(2906002)(86362001)(55016002)(107886003)(9686003)(76116006)(316002)(54906003)(82950400001)(5660300002)(52536014)(8936002)(8676002)(83380400001)(7696005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RlMoeMtKRq9RFVMI3Gjj7GVyGgtQg0WkHo0Mci8kq2e7Ysqr63iaQV9Kwja7mlvz+TmSgfCo7zi/xQkig1zvhrqZkVjN0AV1SNBI6fMq25eF8iLbO4SCwBjrJ61pGcDyGHaSgE4m26l3MjHwrYymtrFIEUL5M4zPH8gP2KYjuT+sI1IZkWvot0l84AnVzGpMLtb5rXy8EkTOTR7Ljht0LglxkKEpvy8siSfDTcX4osXmdcyyaPXTbfjjUxcHdWi21qJQSn42hcNDuYing+wkwO0e06kUQdnzxnR55n15mlUE5M7cdg5aEead0y1/xAde9WbGdK2HNzTjPgr6bDLntwog0gMEwvSwrtCBA48mKXU29yTpGVuJUKlxO8VkEK4jBqYpzobwzIDinmp0HGtELCqZjrFQiKGq9MdfqqFIW2AAVxmu8X08s31jO+v3qEGj6jl+HwBlmvWzMSwhv9kRQU/2pbx3X31aW9A+LzO0pr5gltSBfibVZrR8ukSDZ0f3fn4sAFK7UQGOI1qJI/Rls4n6cccfyMbUSnRYaHwvSatFdZbRYuvypNbU6FylftLNp1/tlKQgdUxveDbScaMCR0X/+voktVINEYMhrpyk9osn/J2VBxLUTvszJ8Fo5Q5HwPDLV1orSRQUf4WHtI90eMhRnU+vFTcqbi+0AlWMWQpxiUg4DkDlNGjodeFGwJW6tck7/eXxfTlTlbngLf5DsA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 416a90fd-627c-41c6-7ad2-08d8325c47d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 18:38:39.2085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NYXayYFd88R9kBE77q0fopjDnNgq3BDJhOir4jQR6ytf4nyS9TYMXEL34SWJ5T8Czp8dNtLMzVwNhQ22j0sc0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Greg KH <greg@kroah.com>
> Sent: Friday, July 24, 2020 10:59 PM
> > [...]
> > Eric Dumazet made an alternative that performs the csum validation earl=
ier:
> >
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct
> > sk_buff *skb)
> >                 }
> >         }
> >
> > -       if (rcu_access_pointer(sk->sk_filter) &&
> > -           udp_lib_checksum_complete(skb))
> > +       if (udp_lib_checksum_complete(skb))
> >                 goto csum_error;
> >
> >         if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
> >
> > I personally like Eric's fix and IMHO we'd better have it in v4.4 rathe=
r than
> > trying to backport 327868212381.
>=20
> Does Eric's fix work with your testing? =20

Yes, it worked in my testing overnight.

> If so, great, can you turn it
> into something I can apply to the 4.4.y stable tree and send it to
> stable@vger.kernel.org?
>=20
> greg k-h

Will do shortly.

Thanks,
Dexuan
