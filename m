Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC5B372D77
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhEDQCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:02:12 -0400
Received: from mx0b-00169c01.pphosted.com ([67.231.156.123]:9442 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230501AbhEDQCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 12:02:11 -0400
Received: from pps.filterd (m0048188.ppops.net [127.0.0.1])
        by mx0b-00169c01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144FrkHe002695
        for <netdev@vger.kernel.org>; Tue, 4 May 2021 09:01:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paloaltonetworks.com;
 h=mime-version : references : in-reply-to : from : date : message-id :
 subject : to : cc : content-type; s=PPS12012017;
 bh=oCB3IkQ3TYGvA20YsI503iJ5bd3eGWKxc/zU8U986IM=;
 b=G5/8inZgMoDdD4fffJBD3QKSLwRLaGIY3DEBXPVDVDSf8hxEyBcUm2NR4BnM+afrI10I
 uXgaagf1e0Of9kWu+YbK20R4mJHZP78t4r1WqrJjFhCV/zh7FKGSbCAtrA52BtbmP9bl
 bZprF72Ex0go/3TkEp9mCte14wu/CHjaLUT6pS44AZmffHabwNm+n0jmgLnJH+IggyCG
 iaeIBLw8QSxjRvSccIMfBR2uWWJ7mQOYinp9wXAaWjSy7DzLlJzca9gzyUhv90NuhJNE
 EGUwQVC9pCQyVTmyr0BpF7jxq8l3tuBT1K9LeznY18ZkjEIwDde2wSUIEyoUJwDZSyVc Cw== 
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        by mx0b-00169c01.pphosted.com with ESMTP id 38aaycqv2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 09:01:14 -0700
Received: by mail-ej1-f70.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso3323543ejc.7
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 09:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paloaltonetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCB3IkQ3TYGvA20YsI503iJ5bd3eGWKxc/zU8U986IM=;
        b=Z7TF74cSdaPuB1h5xvshtnOsJTRj3PvjQaiCdfPKPWYQG/gNjOLo2ZwQMG6mbuSwol
         ZLIvkNouP4uRSibCUxsuHq5MB7sQG1c0+S08oF2Fxze2jC+wO2Sxr8sFdjNwBDVvkmRs
         tmixqmaMQKCn/j+RYSIk49i5bL0xyfFmQahcDEVXstToPQETQCdM8IeBy7k3FL57pDdn
         7Kdk3GSotUfdzYFKXmzm90aDQOpxPJM+x0XlzL0vskBH3lDvIuP7yhBrQXueHc8ne8ht
         RmBFx589cQGsICJ1UA4XZvskYHR5UkZwGv2ZOGcQA9S3GnjWZ31FsZd987NxMFYGnrah
         9MbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCB3IkQ3TYGvA20YsI503iJ5bd3eGWKxc/zU8U986IM=;
        b=eTZjXMwFGYgNWQFe6YDFCmZUbNDgNDbcqoD6jfvWFsNhTwRMwD17UprcWU2o5dgtMl
         AAUx+EJL8uugK9H77kcQJbWyg24JQ1bmkVbK7zFTp7h4T2e0dYH/RQ4WrwokiEzn2yfp
         Df8oQZHb3vqhEzujPrW1JMidx8w5MEJDxb8TYgH8NQ1vlzzMUImbaGgbkHH5Qr+vS56V
         Tc+QCj3YtS5WEuZH00YG9G/NPdTvCIL7OfBXLuf8oChdMMP+VVkZhJ499DPM8Pwfw55L
         aI8iEFAN/rCf/Srs13s3BN8o3uIiIbeNhPCtsdizRdOiQhOVjE3VUU5Wi9HNI6goGURt
         X0IQ==
X-Gm-Message-State: AOAM531jAH8VlNdVGPbSqjhjVSZu1+Omti5I08fs97Sqy8NO0ju+GhPc
        kUELY13U/P/W3xrcxb4k5bQDV/zQMnX7dqWgKNs6KBKpPDRTm+5vXM7TrcONfhFaU+kRWLmNpav
        GmcM32VKbJ2QGhelyywGQPTu5OGFE/wVE
X-Received: by 2002:a50:fe19:: with SMTP id f25mr12157899edt.341.1620144072640;
        Tue, 04 May 2021 09:01:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycLpjR7SRpStJ+oPZmWi/NY1c7ZXlU1lIAlEZGfVT0nqPxcsIVTCJ4fHJlE3qRVAlJYk0RVoGn/gQM1qbhM/Q=
X-Received: by 2002:a50:fe19:: with SMTP id f25mr12157869edt.341.1620144072358;
 Tue, 04 May 2021 09:01:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210504071525.28342-1-orcohen@paloaltonetworks.com> <YJEB6+K0RaPg8KD6@unreal>
In-Reply-To: <YJEB6+K0RaPg8KD6@unreal>
From:   Or Cohen <orcohen@paloaltonetworks.com>
Date:   Tue, 4 May 2021 19:01:01 +0300
Message-ID: <CAM6JnLe=ZoHrpX8_i=_s5P-Q4h=mZxU=RN5pQuHbxq8pdZhYRQ@mail.gmail.com>
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Xiaoming Ni <nixiaoming@huawei.com>,
        matthieu.baerts@tessares.net, mkl@pengutronix.de,
        Nadav Markus <nmarkus@paloaltonetworks.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-ORIG-GUID: 3epGxsILb1tKKNVpF0pbFPHzRJysMqFD
X-Proofpoint-GUID: 3epGxsILb1tKKNVpF0pbFPHzRJysMqFD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_09:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, can you please elaborate?

We don't understand why using kref_get_unless_zero will solve the problem.

On Tue, May 4, 2021 at 11:12 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, May 04, 2021 at 10:15:25AM +0300, Or Cohen wrote:
> > Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
> > and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> > fixed a refcount leak bug in bind/connect but introduced a
> > use-after-free if the same local is assigned to 2 different sockets.
> >
> > This can be triggered by the following simple program:
> >     int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
> >     int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
> >     memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
> >     addr.sa_family = AF_NFC;
> >     addr.nfc_protocol = NFC_PROTO_NFC_DEP;
> >     bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
> >     bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
> >     close(sock1);
> >     close(sock2);
> >
> > Fix this by assigning NULL to llcp_sock->local after calling
> > nfc_llcp_local_put.
> >
> > This addresses CVE-2021-23134.
> >
> > Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
> > Reported-by: Nadav Markus <nmarkus@paloaltonetworks.com>
> > Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> > Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
> > ---
> >
> >  net/nfc/llcp_sock.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> > index a3b46f888803..53dbe733f998 100644
> > --- a/net/nfc/llcp_sock.c
> > +++ b/net/nfc/llcp_sock.c
> > @@ -109,12 +109,14 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
> >                                         GFP_KERNEL);
> >       if (!llcp_sock->service_name) {
> >               nfc_llcp_local_put(llcp_sock->local);
> > +             llcp_sock->local = NULL;
>
> This "_put() -> set to NULL" pattern can't be correct.
>
> You need to fix nfc_llcp_local_get() to use kref_get_unless_zero()
> and prevent any direct use of llcp_sock->local without taking kref
> first. The nfc_llcp_local_put() isn't right either.
>
> Thanks
