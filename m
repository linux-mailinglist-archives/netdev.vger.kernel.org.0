Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4289373DB5
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 16:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhEEOdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 10:33:05 -0400
Received: from mx0b-00169c01.pphosted.com ([67.231.156.123]:15814 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229763AbhEEOdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 10:33:03 -0400
Received: from pps.filterd (m0048189.ppops.net [127.0.0.1])
        by mx0b-00169c01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145EH9S1012247
        for <netdev@vger.kernel.org>; Wed, 5 May 2021 07:32:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paloaltonetworks.com;
 h=mime-version : references : in-reply-to : from : date : message-id :
 subject : to : cc : content-type; s=PPS12012017;
 bh=0HjMTIXKgbXf3IlRD7n6EC1SiHtk6KogUkVJIGWeHyY=;
 b=aXoYMBcxsRGoYHKoF3LpuHmTjWm7AFE1jxLO4oBNcAZjH5tCqd7UteaPssUGvDkf0xd4
 2XA6jpg4bxRYDsNAB6QWxylFf7+XMkb7eWXobO4qjfiwFxnwNh+5rSJm5RhRhPe9kGeJ
 jh7aaG4MupoK1omqQiAQY8+NGyTXp7Y4ZOJSqzFg0crlTdmzPmuovpbsOTa6pb06cbzb
 fXGUZd5dYwV351/c66D8plkwM3Ir+VrluROWNlsP/1l2cYVjHwpzNGbuljUbxHYvoENn
 Ne7sQ8C/hAYKR7TO0hzOq/Ge+tWnOX2UuNC18k6+PXOASB9qYhyB+QLhxpwwqwUmLxzQ cQ== 
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        by mx0b-00169c01.pphosted.com with ESMTP id 38becsk8je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 07:32:05 -0700
Received: by mail-ed1-f69.google.com with SMTP id z12-20020aa7d40c0000b0290388179cc8bfso928879edq.21
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 07:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paloaltonetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0HjMTIXKgbXf3IlRD7n6EC1SiHtk6KogUkVJIGWeHyY=;
        b=JSXDPi6BhlPYlRj/mmT4rgcD/PdvG0EOJEAso1ifkziCusqGB6xjdhbExe15DM7qH4
         XQsQaS/tWSqNguR1h5OvdbUszXeZS4qeRRcji1A7PogdSwj+N5PdvJEPlJiokHsR5ajc
         4NjYjXuPnaF3iEs60ERwkChmUYpNj15VKdkxQTXxswcoIp4PGK4vD+xYeaf6YEwpeZR/
         ptO69ssCqia/RqZFjBMtBiIVNHZ+wh4uCR6dwGZgKQdytq21dv4sYEtMa0wBcwRa2XDI
         ekBqg/MEZZHYziGErTs2VbTvKksWmKNgU+F7wOemD6J/2sHhSVvDvFNKdSrpDqLkOYh2
         VhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0HjMTIXKgbXf3IlRD7n6EC1SiHtk6KogUkVJIGWeHyY=;
        b=SATHGNdADClfqVa7x69+7fbtufbIvllbui/xbH8FlnKSFoCypKHtrb2oD2L4EcWP4i
         9fOCN1ELSdPy52i2R6l0kHnsx55EwYAd5U7LLBlSFmZXqlmJFsTkRldwXTsz9se9o+Mr
         GUY1tJH+u6q1csdSWG5eWeUXlx4gWOUaU/TVVWLH4PMm8PsJxbUIi3kxnha3AkR1V2M6
         HiNkqGiLvSItZpZopvhtFSCAsFXQKIwh9DQAStW/j36URNKJxzbIwlzmVFfN/xCeY9x3
         LB8rYcpwZUBeG+TbOjLt6pjcef4QqOYR/aj/HMrQQDFL+BPBAEW4Vdhm9zz03uWyfGGy
         sdyw==
X-Gm-Message-State: AOAM530X0r1cZpxrqiE8MTOPgP40clyUKxTZXRmYBQfoFj3vLrBIVpbA
        bW008TIOTfHhy+dZBc7bfrQbiXGNNP8Dtx0Icw0TqD9FXHbT5u2caqNkk6KWaaGTkl5Lcd3+his
        rPcfwHB02jX/sZbmOPyVuMI3/e6Jzs9yJ
X-Received: by 2002:a05:6402:781:: with SMTP id d1mr33999395edy.32.1620225123531;
        Wed, 05 May 2021 07:32:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweXi5VZgbMc4SuGOddySB8RI2N9bYaxgpGybmTX4h2VVj+niYZJylh40dxpeZlZoftXXs1I+g8Lo97hOa1egI=
X-Received: by 2002:a05:6402:781:: with SMTP id d1mr33999353edy.32.1620225123175;
 Wed, 05 May 2021 07:32:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210504071525.28342-1-orcohen@paloaltonetworks.com>
 <YJEB6+K0RaPg8KD6@unreal> <CAM6JnLe=ZoHrpX8_i=_s5P-Q4h=mZxU=RN5pQuHbxq8pdZhYRQ@mail.gmail.com>
 <YJIjN6MTRdQ7Bvcp@unreal> <CABV_C9OJ6v1deEknc+V3cJaT+CPjmzg6Wb06_Rsey3AXqOBNYg@mail.gmail.com>
 <YJKEC6/AsN5dVClk@unreal> <CABV_C9PscjqNPTbK0JuNGsgCAX-xYg9=GG1KNyOh3hQU1TuzWQ@mail.gmail.com>
 <YJKo7IWyBk3PK2oS@unreal>
In-Reply-To: <YJKo7IWyBk3PK2oS@unreal>
From:   Or Cohen <orcohen@paloaltonetworks.com>
Date:   Wed, 5 May 2021 17:31:52 +0300
Message-ID: <CAM6JnLf2k95iidDqhYQSFOgiUn1EQHTvw=6kgihyehb5RASN8w@mail.gmail.com>
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Nadav Markus <nmarkus@paloaltonetworks.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        Xiaoming Ni <nixiaoming@huawei.com>,
        matthieu.baerts@tessares.net, mkl@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-GUID: iqW8OVbbaqnXFvh5VVc7lSglQ93SrL0r
X-Proofpoint-ORIG-GUID: iqW8OVbbaqnXFvh5VVc7lSglQ93SrL0r
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_07:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 5:17 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, May 05, 2021 at 04:36:05PM +0300, Nadav Markus wrote:
> > On Wed, May 5, 2021 at 2:40 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Wed, May 05, 2021 at 12:35:48PM +0300, Nadav Markus wrote:
> > > > On Wed, May 5, 2021 at 7:46 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > > On Tue, May 04, 2021 at 07:01:01PM +0300, Or Cohen wrote:
> > > > > > Hi, can you please elaborate?
> > > > > >
> > > > > > We don't understand why using kref_get_unless_zero will solve the
> > > > > problem.
> > > > >
> > > > > Please don't reply in top-posting format.
> > > > > ------
> > > > >
> > > > > The rationale behind _put()/_get() wrappers over kref is to allow
> > > > > delayed release after all consumers are gone.
> > > > >
> > > > > In order to make it happen, the developer should ensure that consumers
> > > > > don't have an access to the kref-ed struct. This is done with
> > > > > kref_get_unless_zero().
> > > > >
> > > > > In your case, you simply increment some counter without checking if
> > > > > nfc_llcp_local_get() actually succeeded.
> > > > >
> > > >
> > > > Hi Leon - as far as we understand, the underlying issue is not
> > incrementing
> > > > the kref counter without checking if the function nfc_llcp_local_get
> > > > succeeded or not. The function itself increments the reference count.
> > > >
> > > > The issue is that the nfc_llcp_local_put might be called twice on the
> > > > llcp_sock->local field, however only one reference (the one that was
> > gotten
> > > > via nfc_llcp_local_get) is incremented. llcp_local_put will be called in
> > > > two locations. The first one is just inside the bind function, if
> > > > nfc_llcp_get_local_ssap fails. The second one is called
> > unconditionally, at
> > > > the socket destruction, at the function nfc_llcp_sock_free.
> > > >
> > > > Hence, our proposed solution is to prevent the second nfc_llcp_local_put
> > > > from attempting to decrement the kref count, by setting local to NULL.
> > This
> > > > makes sense, as we immediately do so after decrementing the single ref
> > > > count we took when calling nfc_llcp_local_get. Since we are under the
> > sock
> > > > lock, this also should be race safe, as no one should access the
> > > > llcp_sock->local field without this lock's protection.
> > > >
> > > > >
> > > > > For example, what protection do you have from races between
> > > > > llcp_sock_bind(),
> > > > > nfc_llcp_sock_free() and llcp_sock_connect()?
> > > > >
> > > >
> > > > As we replied, the llcp_sock->local field is protected under the lock
> > sock,
> > > > as far as we understand.
> > > >
> > > > >
> > > > > So in case you have some lock outside, it is unclear how
> > use-after-free
> > > > > is possible, because nfc_llcp_find_local() should return NULL.
> > > > > In case, no lock exists, except reducing race window, you didn't fix
> > > > > anything
> > > > > and didn't sanitize lcp_sock too.
> > > > >
> > > >
> > > > We don't quite get what race are we talking about here - our trigger
> > > > program doesn't even utilize threads. All it has to do is to
> > > > cause nfc_llcp_local_get to fail - this can be seen clearly in our
> > original
> > > > trigger program. To clarify, the two sockets that are created there
> > point
> > > > to the same nfc_llcp_local struct (via their local field). The
> > destruction
> > > > of the first socket causes the reference count of the pointed object to
> > > > drop to zero (since the code increments the ref count of the object
> > from 1
> > > > to 2, but dercements it twice). The second socket later attempts to
> > > > decrement the ref count of the same (already freed) nfc_llcp_local
> > object,
> > > > causing a kernel crash.
> > >
> > >
> > > So at the end, we are talking about situation where _get()/_put() are
> > > protected by the lock and local can't disappear. Can you please help me
> > to find
> > > this socket lock? Did I miss it in bind path?
> >
> > The lock we are talking about is the lock_sock - lock_sock(sk). It appears
> > near the start of the function.
> >
> > >
> > >
> > > net/socket.c:
> > >   int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
> > >     sock->ops->bind(..)
> > >      llcp_sock_bind(..)
> > >
> > > And if we put lock issue aside, all your change can be squeezed to the
> > following:
> > >
> > > diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> > > index a3b46f888803..cc9ee634269d 100644
> > > --- a/net/nfc/llcp_sock.c
> > > +++ b/net/nfc/llcp_sock.c
> > > @@ -99,7 +99,6 @@ static int llcp_sock_bind(struct socket *sock, struct
> > sockaddr *addr, int alen)
> > >         }
> > >
> > >         llcp_sock->dev = dev;
> > > -       llcp_sock->local = nfc_llcp_local_get(local);
> > >         llcp_sock->nfc_protocol = llcp_addr.nfc_protocol;
> > >         llcp_sock->service_name_len = min_t(unsigned int,
> > >                                             llcp_addr.service_name_len,
> > > @@ -108,13 +107,11 @@ static int llcp_sock_bind(struct socket *sock,
> > struct sockaddr *addr, int alen)
> > >                                           llcp_sock->service_name_len,
> > >                                           GFP_KERNEL);
> > >         if (!llcp_sock->service_name) {
> > > -               nfc_llcp_local_put(llcp_sock->local);
> > >                 ret = -ENOMEM;
> > >                 goto put_dev;
> > >         }
> > >         llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
> > >         if (llcp_sock->ssap == LLCP_SAP_MAX) {
> > > -               nfc_llcp_local_put(llcp_sock->local);
> > >                 kfree(llcp_sock->service_name);
> > >                 llcp_sock->service_name = NULL;
> > >                 ret = -EADDRINUSE;
> > > @@ -122,6 +119,7 @@ static int llcp_sock_bind(struct socket *sock, struct
> > sockaddr *addr, int alen)
> > >         }
> > >
> > >         llcp_sock->reserved_ssap = llcp_sock->ssap;
> > > +       llcp_sock->local = nfc_llcp_local_get(local);
> > >
> > >         nfc_llcp_sock_link(&local->sockets, sk);
> > >
> > >
> > > Thanks
> >
> > While your suggested fix will work for the bind path (it implicitly makes
> > sure that the 'local' field is always NULL, up until the point that
> > everything is initialized properly), we have a problem in the 'connect'
> > path.
>
> It is a mess.
>
> >
> > If we try to take the same approach inside the function llcp_sock_connect,
> > there is a call to nfc_llcp_send_connect, which requires the local field to
> > be set inside the socket. We thought about changing its interface to just
> > accept the 'local' as an argument, but this function is exported in the .h
> > file, and we are afraid of breaking external interfaces. Therefore, we
> > think that we should take a consistent approach of explicitly setting the
> > local field to NULL in all paths. Note that this explicit assignment should
> > achieve the same result as your approach, of implicitly letting it stay
> > NULL up until we can safely assign to it.
> >
> > Please let us know WDYT.
>
> It is in-kernel API with only one user, I would personally use that
> opportunity and cleaned nfc_llcp_send_connect() from ridiculous checks.
>
> This is always false:
>   401         local = sock->local;
>   402         if (local == NULL)
>
> Always true:
>   405         if (sock->service_name != NULL)
>
> However the more I look on that code the more I come to the conclusion that it
> is not worth to change it.
>
> Thanks

Yes, seems like.
So I guess the path is correct.
