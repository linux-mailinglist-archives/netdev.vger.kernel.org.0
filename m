Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FA395AEC
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfHTJZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:25:42 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42487 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfHTJZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:25:42 -0400
Received: by mail-qk1-f193.google.com with SMTP id 201so3899730qkm.9;
        Tue, 20 Aug 2019 02:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/gsH+dfEW5u9I/gchzYd4l4FC9dGn13yx8QcZtSkqj8=;
        b=ZONOz5cXxmNkjNnhlbKqH9kBQdaM3XxHWfzVwm3y2enBWKCved7YkmcIX6VB2gW8cS
         qHn1mtRNPD5CmXiy2sG+7+oSLHMtZq0hUPnrVdsljuGRy10pvjl0nzcY+bpavVz3e1v2
         3DoSE/KY3ZHzFvDKl2xtGSzi71CprS77bp6tH04T7IVtXkJZHdj9SJ3EyOZgAjW6Epxu
         1S8IAx/5MgHHN4VFJw7HUtBmXvm0uTWSlXbCmKohsgvICXduVuGVGnW3yfUdfh579VMg
         AMAYKi7Kx11uNtBG+anC/5VzL14vE+aALGHUOMZh6uo2dUNmE5IDH3dLrZrUFwm2CFe/
         zyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/gsH+dfEW5u9I/gchzYd4l4FC9dGn13yx8QcZtSkqj8=;
        b=bPFdVcAJjPLZl2GrBWkf4dIFZsLcBSUUYXXzUBhxU6HIr7jL+bmeJSN/MeK6BKa+Yd
         BHOq40WbF9prCNC3NTNEytQXn8uF6Es2hoXJabqXe/ZABfWXXLhyXftyKPoFObSBlFZn
         rCskJ5h2EfZXGjI9lYnuPFvqGrvXopsaOmpjOf9qAiktQHJ/BY2C478rgpoEZx/dmPHq
         pVuD/J2LW/e/WwUmhsfRhnfHd7uTfwrcMkebPI8QytX1rHhZ0/jAF7XTV86ivWmDJ7AM
         ncwdV3w8OeL/ONQEU1RLnt49MZJsOGua6q+vncliD7IxzW4IDnLvdmDVwfaJ0lS7zqnl
         em+Q==
X-Gm-Message-State: APjAAAVtjcj9wLaoOgPQm2HHB61I024MNxLug9LFVMAl0SVvEAyW2Y9D
        WQW/vuLhtTheX8Kk4WraxFYwUtEbGqi4XNplLxs=
X-Google-Smtp-Source: APXvYqxVZTjLcHNjKfCuSkuqeezUOfy5FYqZW3hb8OKOls13r24TSyVDWvsrLzcl7Ok+FNKCtplTt87BSR5Ti8Dpct0=
X-Received: by 2002:a37:640e:: with SMTP id y14mr24615884qkb.333.1566293141010;
 Tue, 20 Aug 2019 02:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190820013652.147041-1-yuehaibing@huawei.com>
 <93fafdab-8fb3-0f2b-8f36-0cf297db3cd9@intel.com> <20190820085547.GE4451@kadam>
In-Reply-To: <20190820085547.GE4451@kadam>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 20 Aug 2019 11:25:29 +0200
Message-ID: <CAJ+HfNhRf+=yN6eOOZ1zp8=VicT-k6nHLO6r+f__O5X3M+N=ug@mail.gmail.com>
Subject: Re: [PATCH -next] bpf: Use PTR_ERR_OR_ZERO in xsk_map_inc()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 at 10:59, Dan Carpenter <dan.carpenter@oracle.com> wrot=
e:
>
> On Tue, Aug 20, 2019 at 09:28:26AM +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > For future patches: Prefix AF_XDP socket work with "xsk:" and use "PATC=
H
> > bpf-next" to let the developers know what tree you're aiming for.
>
> There are over 300 trees in linux-next.  It impossible to try remember
> everyone's trees.  No one else has this requirement.
>

Net/bpf are different, and I wanted to point that out to lessen the
burden for the maintainers. It's documented in:

Documentation/bpf/bpf_devel_QA.rst.
Documentation/networking/netdev-FAQ.rst

> Maybe add it as an option to get_maintainer.pl --tree <hash> then that
> would be very easy.
>

Yes, improved tooling would help.


Cheers,
Bj=C3=B6rn

> regards,
> dan carpenter
>
