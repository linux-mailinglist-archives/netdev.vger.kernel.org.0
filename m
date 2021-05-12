Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286FC37B708
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 09:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhELHoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 03:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhELHoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 03:44:23 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784D8C061574;
        Wed, 12 May 2021 00:43:14 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id z1so11571861ils.0;
        Wed, 12 May 2021 00:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DuWBwlDsefrf4S9a6oo2pYhK/oY4KgdhJBcztegdoEE=;
        b=H4psUUmWArhMiXkO1++Oequf5JPw4cZmjRGM2grThysFLq2SkPDF+KCE/EjOJLy3n1
         SPm0RJgxEris5djHsMszC3dO1lQcaF+MxGoV/EZCfGIAnzjNOicDbDUkhq7A/5rjIeMB
         7v8KaBjdlDSsv0Q9nw7A8CWHG+I6XPXidPV/bkIqQuWUm4Slgg6XGcGr8XkJ/7jHlodQ
         SZsGbh75LpZRi+Nw4IcrMTYOCam9fHSW0I5lgf+52GA1x0NJr77ha7WyV4Djq9vGkcKN
         eecNkVrKdwxV4OB2aDcjb4AH+TGMjsbqiIm3dwOuZru/MsVBu4YenUDnwSuLy+Ufx52V
         xM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DuWBwlDsefrf4S9a6oo2pYhK/oY4KgdhJBcztegdoEE=;
        b=mFtt6NCdL7mNWW75BE3htanc6+ucGxMKzD2ktkVX3EpVxIo0SS8TCR79tEGoVhOiYk
         SvTcM5pyIwIXtQDCXDz2QV/o1/IuOWtLpmkAStRBRE79E6FUpJhoDcffRd2xNYDmTMky
         8+DyNWzEWUaFnfIcFjfzgpsdQmvrUO/xreSnPx8s4xi24Hk/5zDf9nvgrASmKVBFwYHk
         G8omNl5EYWFJHRgXu2PKBWUyWBOVULwWIW51OGfau46Xqc/YSfI20KU/QZZq/QL9+S81
         NcCyjC5HZt4U2ZgI4voeIh4ssCHaHQoIoN9ODB9QlP4DvXI9O1UeU0HqomuCPweS0vEt
         hrNA==
X-Gm-Message-State: AOAM532GjBJHVfUpkAllBVW6y1LJDn51LhWp+p00Qq9T5xDO1601NByY
        L0rIPOC2EPWGiThQzrn9GWSYWH8s0BPUVn+P9Q==
X-Google-Smtp-Source: ABdhPJwGa9XAoX9Rp7RqiEgPYFPExIeuNVFLvk9s+i0XvHSx7oyYfXOjxvatK4PMsYW1wvyWdqU/5MOLk4wQ+CkO4OQ=
X-Received: by 2002:a05:6e02:13d0:: with SMTP id v16mr509001ilj.168.1620805393913;
 Wed, 12 May 2021 00:43:13 -0700 (PDT)
MIME-Version: 1.0
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Wed, 12 May 2021 15:43:03 +0800
Message-ID: <CAA-qYXi-znXVt_8KuMwEpbqmeWVQJZX9ixnOLs22fPM7HKmmtA@mail.gmail.com>
Subject: Fwd: A missing check bug in __sys_accept4_file()
To:     axboe@kernel.dk, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, jmorris@namei.org, serge@hallyn.com
Cc:     shenwenbosmile@gmail.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

hi, our team has found and reported a missing check bug on Linux
kernel v5.10.7 using static analysis.
We are looking forward to having more experts' eyes on this. Thank you!

> On Fri, May 7, 2021 at 1:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 6 May 2021 15:44:36 +0800 Jinmeng Zhou wrote:
> > hi, our team has found a missing check bug on Linux kernel v5.10.7 using static analysis. There is a path calls sock_alloc() after checking LSM function security_socket_create(), while another path calls it without checking.
> > We think there is a missing check bug in __sys_accept4_file() before calling sock_alloc().
>
> Perhaps the semantics for listening sockets is that only the parent
> sockets get the LSM check. Could you please circulate the report more
> widely? I'd be good to have LSM experts' eyes on this at least.
> CCing the mailing list should help get more opinions. Thank you!
>
> > Function sock_create_lite() uses security_socket_create() to check.
> > 1.    // check security_socket_create() ///////////////////////
> > 2.    int sock_create_lite(int family, int type, int protocol, struct socket **res)
> > 3.    {
> > 4.      int err;
> > 5.      struct socket *sock = NULL;
> > 6.      err = security_socket_create(family, type, protocol, 1);
> > 7.      if (err)
> > 8.        goto out;
> > 9.      sock = sock_alloc();
> > 10.   ...
> > 11.   }
> >
> > However, __sys_accept4_file() directly calls sock_alloc() without the security check.
> > 1.    // no check ////////////////////////////////////
> > 2.    int __sys_accept4_file(struct file *file, unsigned file_flags,
> > 3.          struct sockaddr __user *upeer_sockaddr,
> > 4.          int __user *upeer_addrlen, int flags,
> > 5.          unsigned long nofile)
> > 6.    {
> > 7.      struct socket *sock, *newsock;
> > 8.      struct file *newfile;
> > 9.      int err, len, newfd;
> > 10.     struct sockaddr_storage address;
> > 11.     if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
> > 12.       return -EINVAL;
> > 13.     if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
> > 14.       flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
> > 15.     sock = sock_from_file(file, &err);
> > 16.     if (!sock)
> > 17.       goto out;
> > 18.     err = -ENFILE;
> > 19.     newsock = sock_alloc();
> > 20.   ...
> > 21.   }
> >
> > This no-check function can be reached through syscall.
> > syscall => __sys_accept4 => __sys_accept4_file
> >
> > SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
> > int __user *, upeer_addrlen, int, flags)
> > {
> > return __sys_accept4(fd, upeer_sockaddr, upeer_addrlen, flags);
> > }
> >
> > Thanks!
> >
> >
> > Best regards,
> > Jinmeng Zhou
>


Best regards,
Jinmeng Zhou
