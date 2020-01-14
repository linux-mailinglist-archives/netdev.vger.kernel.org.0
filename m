Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA38139FCE
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgANDQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:16:39 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40259 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbgANDQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 22:16:38 -0500
Received: by mail-io1-f67.google.com with SMTP id x1so12199949iop.7;
        Mon, 13 Jan 2020 19:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=a2cE0aiUkLgijP5s+tQgiPgZihWeGsNZvYu+mRTQO5c=;
        b=j1EnbZLTmv7AghJQR5h4T47JuNa1FjuqIlYkgcdmLYN1al7iRudKLVK4Sm2dylgZYy
         r/ygLu9cCMiVIOqHuU2LNoH8VVVty039v2vAQvKPSGlaVQSqskG7Samg3a76VT6lxiEt
         MtIalCbdYcuGi4tsCDjZShOgsNQ2nhm1DAIt23CrD0TzgmIjo8pbooYES1VQ4my5Ilu/
         kcEpKGenAGR7Juhs6oeTmxw1TtBvlnwvdVV+KzLKqeURI87ovtXGFjhGLxKm+N2kkmtH
         n8n38DS53G9liNWBjcnmblu4Drn53SnZ/1GcTmlJ/iDweKbJFNp1yUp/ZlNzuYWsGg7r
         IcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=a2cE0aiUkLgijP5s+tQgiPgZihWeGsNZvYu+mRTQO5c=;
        b=jEWbAPjR3U32BNrPkQMzjTs4kcRrRoMie5Zfc9WQIPSGM11mSbb1Hk0FGan/oeKWwi
         hH6JNj1jaCKyxYh7UeQPk7jDQxQjS60ubwv/3sk3d/uPRb2RlqPpWK35yOqGcxTRMD3W
         teQ2ELFs/rO//MZIONu1CeOiPooRvlVWOLOwd+yQPdoJDsEsbKh1I39XA9bsw+al9Oo5
         FEFvPDVPuwTfRWVuwgahqKTCtl4R00LQTmOaOL/xFvuk1vbYc6L4PHXotNGninxa8XKL
         5YSe/ycalSOJ9SiQ9KXfRL7Z3fMaA09+EpaU0pSiS3ULwwo3ibbAY6nhaHVx/w2c2Nuq
         8+sQ==
X-Gm-Message-State: APjAAAWIPLXg5Wg15lSecQUaw31rQGpHAOpB3Qp9n5ne0j5c04c0P/Dp
        +4sflwEbD5cgRPw+Vh7EGAEeg0/h
X-Google-Smtp-Source: APXvYqw7fMaiac6S6K7HWRAUYwuDDuICw4gWSgO19Qa/22PEC9D3Gg0Ns+b5N4L+TPJQxcKZ65exqg==
X-Received: by 2002:a5d:8952:: with SMTP id b18mr15285114iot.40.1578971798073;
        Mon, 13 Jan 2020 19:16:38 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p65sm4459615ili.71.2020.01.13.19.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 19:16:37 -0800 (PST)
Date:   Mon, 13 Jan 2020 19:16:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin Lau <kafai@fb.com>, Jakub Sitnicki <jakub@cloudflare.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <5e1d328d760e_78752af1940225b4b7@john-XPS-13-9370.notmuch>
In-Reply-To: <20200113231223.cl77bxxs44bl6uhw@kafai-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-8-jakub@cloudflare.com>
 <20200113231223.cl77bxxs44bl6uhw@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next v2 07/11] bpf, sockmap: Return socket cookie on
 lookup from syscall
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau wrote:
> On Fri, Jan 10, 2020 at 11:50:23AM +0100, Jakub Sitnicki wrote:
> > Tooling that populates the SOCKMAP with sockets from user-space needs a way
> > to inspect its contents. Returning the struct sock * that SOCKMAP holds to
> > user-space is neither safe nor useful. An approach established by
> > REUSEPORT_SOCKARRAY is to return a socket cookie (a unique identifier)
> > instead.
> > 
> > Since socket cookies are u64 values SOCKMAP needs to support such a value
> > size for lookup to be possible. This requires special handling on update,
> > though. Attempts to do a lookup on SOCKMAP holding u32 values will be met
> > with ENOSPC error.
> > 
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---

[...]
 
> > +static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
> > +{
> > +	struct sock *sk;
> > +
> > +	WARN_ON_ONCE(!rcu_read_lock_held());
> It seems unnecessary.  It is only called by syscall.c which
> holds the rcu_read_lock().  Other than that,
> 

+1 drop it. The normal rcu annotations/splats should catch anything here.

> Acked-by: Martin KaFai Lau <kafai@fb.com>
