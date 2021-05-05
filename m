Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E775373BA8
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhEEMqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:46:54 -0400
Received: from mx0a-00169c01.pphosted.com ([67.231.148.124]:65424 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230034AbhEEMqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 08:46:53 -0400
X-Greylist: delayed 4521 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2021 08:46:53 EDT
Received: from pps.filterd (m0048493.ppops.net [127.0.0.1])
        by mx0a-00169c01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145BQ5f8020501
        for <netdev@vger.kernel.org>; Wed, 5 May 2021 04:30:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paloaltonetworks.com;
 h=mime-version : references : in-reply-to : from : date : message-id :
 subject : to : cc : content-type : content-transfer-encoding;
 s=PPS12012017; bh=rwYfyngqP9AVg99ir4kUARqe7BGAG17ajRsR7qsLqc8=;
 b=IqznPDne0LBl0RVt6y69eyGWrI7t6VXUdfec59Bns6DNQqYtiYUSv1olooGrGoWhcOi8
 pxJJH8wV/CXBKqBrpHPIDdtH9Lyc7kPrnk3XoAzPrB1q1l4DqhmhutuhxccgPWPCcwTo
 sfjnRB6076SBzfV2G+MPs1SXoMtWypO50Qwh1k0pP4KlwdrvrsQfQPhhnjQnVOpOkA5K
 ZbG5emsY01Fb6HOv6avEG9foXhqekoWE2OgrJMtYwxHMd0R9AtjL2ll8tRSO1RAv+b9k
 g2oHZ3BCG62gqIfORCym2XuUOvg47491TURWBBaV8zxbn/q/UUcGLVDk+klPLoO13L65 YA== 
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        by mx0a-00169c01.pphosted.com with ESMTP id 38bebbv06r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 04:30:36 -0700
Received: by mail-wm1-f71.google.com with SMTP id o18-20020a1ca5120000b02901333a56d46eso1494254wme.8
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 04:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paloaltonetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rwYfyngqP9AVg99ir4kUARqe7BGAG17ajRsR7qsLqc8=;
        b=dQ9hmxlAPtp99pdX7bL6juVpy/FGwPFHBt9FCu0Pfphxc0wWzMBTrlIzU2olB82XYt
         WiIoMfY06CQ0HT22EO2vaMpzT7jju4s+77ohkgn2YXH5vs51xTYYcEk06hLEUmpT/CnF
         VlLECYAFjBQt6DA5rvj6NejaKDaOy59PGgkGOWGWeQkZTy+ruGQdoSlNX8sWqbDkFd+4
         R5kTS4HBMofXmd7/XAH3gZtt0TqtAcMHfhEtlLZd2mQ/r9BAE7pdGhl24d+R3KKPgwpQ
         zA857POiJpM9ogtdqsrd1hdx091YpZsI1gfVhHn9un8fRUNGEO/SdpqtLSKvrfOdKlXk
         HZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rwYfyngqP9AVg99ir4kUARqe7BGAG17ajRsR7qsLqc8=;
        b=X2g++oIVmyOA43GkplA2zqkmn0Lfvy1KSVIHnp+f+MgdXJNQte21EFE3AFQZNXcNYS
         +6xHGYpk57SFeXi/hP55AUdykGI/DJgfZLz/7/59AWen0Valahag7V6B3s1/WjJAJ8an
         ihAv4LcyUkF7xSppmbeGVSmNULAJi0ZWO6IbW3dznEourQFtZbBOmO0IC0ouQ3RAwEXM
         k1NFangUw4ly6YmieHdAIgjMDqq1YONz+toFOHcKnSa17W9XOLdlwyptdgfxkib5+Gwg
         FjBhxLJxhxXOo0imtWGeGxLIRp9YHOFn1Qy2u120+vZ9m5qgPF0PoEORpAXNI/rygp+h
         yiVg==
X-Gm-Message-State: AOAM5306Sg0rf0xcr1w5NPgIg3fIddmqs47OVF0eeRcwzGp35C1Cgg0a
        yGN54GMGCBH8m4nyLEP74x/JWTWZqvpUlOjI9h455l44iv9WDMQABc3mp01EjF5i3W33ffrIczN
        8U9lSvepal/vc0SvQn4rFIeWK6az+DuuU
X-Received: by 2002:a1c:cc0b:: with SMTP id h11mr9468328wmb.87.1620214234217;
        Wed, 05 May 2021 04:30:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4r/d5P1Ye2Cm7CbINexMkAuEEHm4Inr7+l5TKr96OZhvD2+HLMOeuOVzYBdk2Kj7VG3sanK9DRF+ilvxnjNs=
X-Received: by 2002:a1c:cc0b:: with SMTP id h11mr9468289wmb.87.1620214233791;
 Wed, 05 May 2021 04:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210504071525.28342-1-orcohen@paloaltonetworks.com>
 <YJEB6+K0RaPg8KD6@unreal> <CAM6JnLe=ZoHrpX8_i=_s5P-Q4h=mZxU=RN5pQuHbxq8pdZhYRQ@mail.gmail.com>
 <YJIjN6MTRdQ7Bvcp@unreal> <CABV_C9OJ6v1deEknc+V3cJaT+CPjmzg6Wb06_Rsey3AXqOBNYg@mail.gmail.com>
In-Reply-To: <CABV_C9OJ6v1deEknc+V3cJaT+CPjmzg6Wb06_Rsey3AXqOBNYg@mail.gmail.com>
From:   Nadav Markus <nmarkus@paloaltonetworks.com>
Date:   Wed, 5 May 2021 14:30:23 +0300
Message-ID: <CABV_C9PBdCunuSXQUqULXUCR8+Ymq9i=_A6+KSNF95F34xZBEA@mail.gmail.com>
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Or Cohen <orcohen@paloaltonetworks.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        Xiaoming Ni <nixiaoming@huawei.com>,
        matthieu.baerts@tessares.net, mkl@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: uRW3qzWvGFUtX-Mv5rL-MtlwDXBFgssD
X-Proofpoint-GUID: uRW3qzWvGFUtX-Mv5rL-MtlwDXBFgssD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_06:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050086
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 12:35 PM Nadav Markus
<nmarkus@paloaltonetworks.com> wrote:
>
>
>
> On Wed, May 5, 2021 at 7:46 AM Leon Romanovsky <leon@kernel.org> wrote:
>>
>> On Tue, May 04, 2021 at 07:01:01PM +0300, Or Cohen wrote:
>> > Hi, can you please elaborate?
>> >
>> > We don't understand why using kref_get_unless_zero will solve the prob=
lem.
>>
>> Please don't reply in top-posting format.
>> ------
>>
>> The rationale behind _put()/_get() wrappers over kref is to allow
>> delayed release after all consumers are gone.
>>
>> In order to make it happen, the developer should ensure that consumers
>> don't have an access to the kref-ed struct. This is done with
>> kref_get_unless_zero().
>>
>> In your case, you simply increment some counter without checking if
>> nfc_llcp_local_get() actually succeeded.
>
>
> Hi Leon - as far as we understand, the underlying issue is not incrementi=
ng the kref counter without checking if the function nfc_llcp_local_get suc=
ceeded or not. The function itself increments the reference count.
>
> The issue is that the nfc_llcp_local_put might be called twice on the llc=
p_sock->local field, however only one reference (the one that was gotten vi=
a nfc_llcp_local_get) is incremented. llcp_local_put will be called in two =
locations. The first one is just inside the bind function, if nfc_llcp_get_=
local_ssap fails. The second one is called unconditionally, at the socket d=
estruction, at the function nfc_llcp_sock_free.
>
> Hence, our proposed solution is to prevent the second nfc_llcp_local_put =
from attempting to decrement the kref count, by setting local to NULL. This=
 makes sense, as we immediately do so after decrementing the single ref cou=
nt we took when calling nfc_llcp_local_get. Since we are under the sock loc=
k, this also should be race safe, as no one should access the llcp_sock->lo=
cal field without this lock's protection.
>>
>>
>> For example, what protection do you have from races between llcp_sock_bi=
nd(),
>> nfc_llcp_sock_free() and llcp_sock_connect()?
>
>
> As we replied, the llcp_sock->local field is protected under the lock soc=
k, as far as we understand.
>>
>>
>> So in case you have some lock outside, it is unclear how use-after-free
>> is possible, because nfc_llcp_find_local() should return NULL.
>> In case, no lock exists, except reducing race window, you didn't fix any=
thing
>> and didn't sanitize lcp_sock too.
>
>
> We don't quite get what race are we talking about here - our trigger prog=
ram doesn't even utilize threads. All it has to do is to cause nfc_llcp_loc=
al_get to fail - this can be seen clearly in our original trigger program. =
To clarify, the two sockets that are created there point to the same nfc_ll=
cp_local struct (via their local field). The destruction of the first socke=
t causes the reference count of the pointed object to drop to zero (since t=
he code increments the ref count of the object from 1 to 2, but dercements =
it twice). The second socket later attempts to decrement the ref count of t=
he same (already freed) nfc_llcp_local object, causing a kernel crash.
>>
>>
>> Thanks
>>
>> >
>> > On Tue, May 4, 2021 at 11:12 AM Leon Romanovsky <leon@kernel.org> wrot=
e:
>> > >
>> > > On Tue, May 04, 2021 at 10:15:25AM +0300, Or Cohen wrote:
>> > > > Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
>> > > > and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
>> > > > fixed a refcount leak bug in bind/connect but introduced a
>> > > > use-after-free if the same local is assigned to 2 different socket=
s.
>> > > >
>> > > > This can be triggered by the following simple program:
>> > > >     int sock1 =3D socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP =
);
>> > > >     int sock2 =3D socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP =
);
>> > > >     memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
>> > > >     addr.sa_family =3D AF_NFC;
>> > > >     addr.nfc_protocol =3D NFC_PROTO_NFC_DEP;
>> > > >     bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_=
nfc_llcp) )
>> > > >     bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_=
nfc_llcp) )
>> > > >     close(sock1);
>> > > >     close(sock2);
>> > > >
>> > > > Fix this by assigning NULL to llcp_sock->local after calling
>> > > > nfc_llcp_local_put.
>> > > >
>> > > > This addresses CVE-2021-23134.
>> > > >
>> > > > Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
>> > > > Reported-by: Nadav Markus <nmarkus@paloaltonetworks.com>
>> > > > Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
>> > > > Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
>> > > > ---
>> > > >
>> > > >  net/nfc/llcp_sock.c | 4 ++++
>> > > >  1 file changed, 4 insertions(+)
>> > > >
>> > > > diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
>> > > > index a3b46f888803..53dbe733f998 100644
>> > > > --- a/net/nfc/llcp_sock.c
>> > > > +++ b/net/nfc/llcp_sock.c
>> > > > @@ -109,12 +109,14 @@ static int llcp_sock_bind(struct socket *soc=
k, struct sockaddr *addr, int alen)
>> > > >                                         GFP_KERNEL);
>> > > >       if (!llcp_sock->service_name) {
>> > > >               nfc_llcp_local_put(llcp_sock->local);
>> > > > +             llcp_sock->local =3D NULL;
>> > >
>> > > This "_put() -> set to NULL" pattern can't be correct.
>> > >
>> > > You need to fix nfc_llcp_local_get() to use kref_get_unless_zero()
>> > > and prevent any direct use of llcp_sock->local without taking kref
>> > > first. The nfc_llcp_local_put() isn't right either.
>> > >
>> > > Thanks

I am resending this as the original contained HTML by mistake.
