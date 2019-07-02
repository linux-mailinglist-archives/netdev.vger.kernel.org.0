Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509505CD87
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfGBK0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:26:37 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46715 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfGBK0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 06:26:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id z15so10962030lfh.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 03:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DeZFKcL+XG2c5ZKWW0w2NnGzf6Xq9dHYkXwDwQU346Y=;
        b=PQZ6k6eJltTW4GNNymgmXPZNfvpbvCvSs034QHf+ziKAA/v9+JeYiYHhZBwM9/Xcu9
         Z5A/tGYJ0ItnWOlc8G4iVZsSccInbQ7nub+28M3IfjdOyQ+fUhakYZOI+ssD2OcqDdUe
         +MXzUnQpUllp8pvDZ+s8F2gW9thObT4VKovvnBCvgWZmlzq5u12WoGwFIZnD3WmgsPj2
         NbcnBez1+ZFfJ8shYa6FIA8Ooi72NYC9XWCiSw9jmxP2J3Rl8JR9VDjjcXUJy/jhw/UV
         60lxc/mEJM7qC4u/16MDCYzv7t4NgYJpDXwNT12lOdXkZT5nNyooTdhVWA4rgJHElOZe
         sNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DeZFKcL+XG2c5ZKWW0w2NnGzf6Xq9dHYkXwDwQU346Y=;
        b=GF1dMwiwQE9IRQiphTJXyV97iaqO2QW3V/owYYVhkAg8AGd/CnxVx36Rq2jVy1bKk8
         6kiJPoOAJXC2EpEo4BUwWmPN6grvBMVvF45K0gDEhseIL9AZtYPehC66hl2vMSS0Mzhd
         Cu2OiSS/jlDdql4NboB22kzYIK5BEJKvE38C9FQ6i07lU6gmoCLPKeLwro7u2o2hTHOU
         oBOlAs5tKkngSkGFefhPKQb9aS40jMb2tiQFo/qSyKzeH1fVkauox2Fv6nNq3RzjeSVd
         DDj/hP8O35zHGEhjqPXA6c+bK2BbQacEiRFEgMJpcMVylLVWE8mtUuN2xShHsep0WUiz
         1Fdg==
X-Gm-Message-State: APjAAAWaw3lHcOyoz7lFCzq0UW9fO2cMuphIoEO0vQiI/FwHYpM0DzND
        ke7XDgufuXhbp5r+yfe9U+Rny19sGkbj3bDIAg27P+t8f/E=
X-Google-Smtp-Source: APXvYqy1PU3kGSPpJ8rYZcQcXhszY6LVElHCYFYM7aU4T+Ik3a/7EECzjUolK7gfdjp0MoPnRtt9uC67rwFQ6Rude9M=
X-Received: by 2002:ac2:5212:: with SMTP id a18mr14126163lfl.50.1562063194689;
 Tue, 02 Jul 2019 03:26:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAGWhr0AOApbf4-4RJHibUaKa8MmOfGS+uH6Rx4x1PQGZXRbCOQ@mail.gmail.com>
In-Reply-To: <CAGWhr0AOApbf4-4RJHibUaKa8MmOfGS+uH6Rx4x1PQGZXRbCOQ@mail.gmail.com>
From:   Ji Jianwen <jijianwen@gmail.com>
Date:   Tue, 2 Jul 2019 18:26:23 +0800
Message-ID: <CAGWhr0Bg3mnaddCg=RexXgUGeP5EyqiU63n_c9NAgyfx-wpJ2Q@mail.gmail.com>
Subject: Re: [iproute2] Can't create ip6 tunnel device
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, maheshb@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems this issue was introduced by commit below, I am able to run
the command successfully mentioned at previous mail without it.

commit ba126dcad20e6d0e472586541d78bdd1ac4f1123 (HEAD)
Author: Mahesh Bandewar <maheshb@google.com>
Date:   Thu Jun 6 16:44:26 2019 -0700

    ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds

On Tue, Jul 2, 2019 at 2:53 PM Ji Jianwen <jijianwen@gmail.com> wrote:
>
> Hello  there,
>
> I got error when creating ip6 tunnel device on a rhel-8.0.0 system.
>
> Here are the steps to reproduce the issue.
> # # uname -r
> 4.18.0-80.el8.x86_64
> # dnf install -y libcap-devel bison flex git gcc
> # git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
> # cd iproute2  &&  git log --pretty=oneline --abbrev-commit
> d0272f54 (HEAD -> master, origin/master, origin/HEAD) devlink: fix
> libc and kernel headers collision
> ee09370a devlink: fix format string warning for 32bit targets
> 68c46872 ip address: do not set mngtmpaddr option for IPv4 addresses
> e4448b6c ip address: do not set home option for IPv4 addresses
> ....
>
> # ./configure && make && make install
> # ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2
> local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1   --->
> please replace eno1 with the network card name of your system
> add tunnel "ip6tnl0" failed: File exists
>
> Please help take a look. Thanks!
>
> Br,
> Jianwen
