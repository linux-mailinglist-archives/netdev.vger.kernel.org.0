Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C0272EFA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfGXMg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:36:56 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44425 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfGXMgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:36:55 -0400
Received: by mail-qk1-f193.google.com with SMTP id d79so33548140qke.11;
        Wed, 24 Jul 2019 05:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cr3Q+ZHw4lMq4Sf6IZcwSWjhUrK2QSEQ3FOJZ1/dzVE=;
        b=GpklJqAti/GMFYmD25zTK/DC/dNjgguhJQ/xHJWvmyHheSEu9PhjfoPGDRujZUkxCl
         bVuWfZOGX+n+eDaASw0bk6hXD0VgpzuteKkevVJcXbx2ZJSjn6U430WWVbjo8tLT02ju
         uS3uX9YmpL3KKyM+aMYawFmot5oCi0fsrOJHxIGTnTIu5deB3HAfuwwngE+z9CiZ0IvN
         xoZrQRV2tz0Kd0lF4IlV++LWxy69miiHLIkWmK9r79sshUkHNOuxkU4/7Itu7vPvvSl0
         BGmTiv6Iu5RMbEMJXcWQvVZUIALuDgPxaHnRaFq8J2ko8nh/Z9Y/ImjooBQkdQYmI9mu
         IpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cr3Q+ZHw4lMq4Sf6IZcwSWjhUrK2QSEQ3FOJZ1/dzVE=;
        b=E+fgWDZZrpYJbgrTtYm+yR919GLuGvqNk+r81wSI6yGO1u59ZXaPA1lRHhA1a8l4KW
         mSb3KhTh6UiM3faZd+OgtqOkJDT8r6GZ257nQtgXsQpvjDsmv7g4qBw6wZNnNJddNJpm
         byBQQEY1U2A0NrdNz5/5rzfT8fE0nfoNPJi4w4BbeLhMRjZQk2p0od/auSDKUwYL271w
         +ex2WXqdZrW7vgDW0ODXcdwguB21qfvsQT/6kVz23b+5/uebtGW80GgzKxPYlv9CHYkN
         /jAuE5vfJpJO0Rs1jOo5NdzwMZT7ZJs0dLFJk4NOv07zDlYmdBJTuBslZXDskydcpRfh
         seKw==
X-Gm-Message-State: APjAAAX/7WatE7K97Qp06RvpiTubu3T8suSJfNv5vnwhxi5wW8+sXTSk
        k/2qBMoBTlY29WkIIf44a00=
X-Google-Smtp-Source: APXvYqz2AOvGVbGDkIwcz2qGg3tnlGybL6bxv1dBWPgp283jgoGuA3kL4LgEc1Kw+NZgqm3VE0LULQ==
X-Received: by 2002:a37:c408:: with SMTP id d8mr38150678qki.18.1563971814305;
        Wed, 24 Jul 2019 05:36:54 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.45])
        by smtp.gmail.com with ESMTPSA id q9sm19175968qkm.63.2019.07.24.05.36.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 05:36:53 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DEBE7C0AAD; Wed, 24 Jul 2019 09:36:50 -0300 (-03)
Date:   Wed, 24 Jul 2019 09:36:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size
 in __sctp_setsockopt_connectx
Message-ID: <20190724123650.GD6204@localhost.localdomain>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <20190723152449.GB8419@localhost.localdomain>
 <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
 <20190724112235.GA7212@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724112235.GA7212@hmswarspite.think-freely.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 07:22:35AM -0400, Neil Horman wrote:
> On Wed, Jul 24, 2019 at 03:21:12PM +0800, Xin Long wrote:
> > On Tue, Jul 23, 2019 at 11:25 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> > > > Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> > > > sctp_inet_connect(), the latter has done addr_size check with size
> > > > of sa_family_t.
> > > >
> > > > In the next patch to clean up __sctp_connect(), we will remove
> > > > addr_size check with size of sa_family_t from __sctp_connect()
> > > > for the 1st address.
> > > >
> > > > So before doing that, __sctp_setsockopt_connectx() should do
> > > > this check first, as sctp_inet_connect() does.
> > > >
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > ---
> > > >  net/sctp/socket.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > index aa80cda..5f92e4a 100644
> > > > --- a/net/sctp/socket.c
> > > > +++ b/net/sctp/socket.c
> > > > @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
> > > >       pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
> > > >                __func__, sk, addrs, addrs_size);
> > > >
> > > > -     if (unlikely(addrs_size <= 0))
> > > > +     if (unlikely(addrs_size < sizeof(sa_family_t)))
> > > I don't think this is what you want to check for here.  sa_family_t is
> > > an unsigned short, and addrs_size is the number of bytes in the addrs
> > > array.  The addrs array should be at least the size of one struct
> > > sockaddr (16 bytes iirc), and, if larger, should be a multiple of
> > > sizeof(struct sockaddr)
> > sizeof(struct sockaddr) is not the right value to check either.
> > 
> > The proper check will be done later in __sctp_connect():
> > 
> >         af = sctp_get_af_specific(daddr->sa.sa_family);
> >         if (!af || af->sockaddr_len > addrs_size)
> >                 return -EINVAL;
> > 
> > So the check 'addrs_size < sizeof(sa_family_t)' in this patch is
> > just to make sure daddr->sa.sa_family is accessible. the same
> > check is also done in sctp_inet_connect().
> > 
> That doesn't make much sense, if the proper check is done in __sctp_connect with
> the size of the families sockaddr_len, then we don't need this check at all, we
> can just let memdup_user take the fault on copy_to_user and return -EFAULT.  If
> we get that from memdup_user, we know its not accessible, and can bail out.
> 
> About the only thing we need to check for here is that addr_len isn't some
> absurdly high value (i.e. a negative value), so that we avoid trying to kmalloc
> upwards of 2G in memdup_user.  Your change does that just fine, but its no
> better or worse than checking for <=0

One can argue that such check against absurdly high values is random
and not effective, as 2G can be somewhat reasonable on 8GB systems but
certainly isn't on 512MB ones. On that, kmemdup_user() will also fail
gracefully as it uses GFP_USER and __GFP_NOWARN.

The original check is more for protecting for sane usage of the
variable, which is an int, and a negative value is questionable. We
could cast, yes, but.. was that really the intent of the application?
Probably not.

> 
> Neil
> 
> > >
> > > Neil
> > >
> > > >               return -EINVAL;
> > > >
> > > >       kaddrs = memdup_user(addrs, addrs_size);
> > > > --
> > > > 2.1.0
> > > >
> > > >
> > 
