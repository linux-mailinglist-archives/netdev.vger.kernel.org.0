Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA221A0522
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 05:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDGDIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 23:08:41 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38679 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgDGDIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 23:08:40 -0400
Received: by mail-lf1-f68.google.com with SMTP id l11so1172770lfc.5;
        Mon, 06 Apr 2020 20:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zsYSND37d1WovY/AysD3q0aS8AHErV9kM3MhhA7w89s=;
        b=sDtu4jkQ/UmTekhQ6pgYwCbOFPgBt29BSd0K7ac4LNlGULAyXx9mPoeDOTS/r5NxV8
         1FEmgL5SLAHX4vtfAPIDp5wv3clDmC6hZ1l+TmbD7AyvAmh4y32jNaEuZ+D2k0bP9Htw
         pQdy96rdHOi0T8k7gGXxRhZ1A/O+pBsdJq7OA+RoUhi+GJ4ZAiRJSzVImPgRhwmCgs2m
         45RcoHwkQcPMwmhrwbU6mguNP2uEZIdd62qj63r9Fxvhfurg3dV8WIvDmGl1LUmKJirj
         AOIH2g9bSzAPp5T2HIn8VkGPjErXO4XVoPcSJin5wuoIYziHQErrpZgfIOqYHFLS/qhp
         pcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zsYSND37d1WovY/AysD3q0aS8AHErV9kM3MhhA7w89s=;
        b=Zdb6qoxFSdxYGWB1o7mejIq8GEysXkJAYDhi5l07DYTf8DrMBqnA79OgCQF0MmMpk0
         n9rP/TaO/8TswBukfFwN+c2+e0rNzlCnNCrkNJL9+A+SCfiY+PbX+g8Qm0oiwQezUjgr
         15/UgmGNtwo4pZ/SD3gU3j/coHWFqw9YK1jVEjk8+EgzwXXwOPaRyD8KmVBiX1RvRmR0
         whi2gnWxxEQI1z+gZjbtKhcN3kS6BM0AJSo0xGkYzNr0YRCrhzfWnbiJg8SnpmKrnjit
         cg1Zfax79qeRR/Y0qCA1YOcXpAl64tgjUIX3S1rvwuwCdyg6Ib8b/44CfNCh4ILdVpQ0
         uXWQ==
X-Gm-Message-State: AGi0PuYmmUrFJZQ0aI7KrRxr9lQKgKe7LKCxEzso4HilSsold6SKsfcJ
        hinUEPPL5mAttHeZVfRLf0pIpU7yhkhfR/FCQAM=
X-Google-Smtp-Source: APiQypKQsKIwrun7isv16dKPq2dYtfOpYBlBKq04m2Ce1IGWQdUMNqb1kr8dKw+ktwBbvz8Mtc8cX85Rz0UDTu8d2T0=
X-Received: by 2002:ac2:4426:: with SMTP id w6mr87310lfl.8.1586228918428; Mon,
 06 Apr 2020 20:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200310174711.7490-1-lmb@cloudflare.com> <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
 <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
 <20200312175828.xenznhgituyi25kj@ast-mbp> <CACAyw98cp2we2w_L=YgEj+BbCqA5_3HvSML1VZzyNeF8mVfEEQ@mail.gmail.com>
 <20200314025832.3ffdgkva65dseoec@ast-mbp.dhcp.thefacebook.com>
 <CACAyw99HC70=wYBzZAiQVyUi56y_0x-6saGkp_KHBpjQuva1KA@mail.gmail.com>
 <5e711f6ed4f6c_278b2b1b264c65b4bd@john-XPS-13-9370.notmuch> <CACAyw9_J2Nc74hA6tQrWrvQ1Q61994YRaQUPu_2=rKYr9LUFYQ@mail.gmail.com>
In-Reply-To: <CACAyw9_J2Nc74hA6tQrWrvQ1Q61994YRaQUPu_2=rKYr9LUFYQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 6 Apr 2020 20:08:26 -0700
Message-ID: <CAADnVQKigRAAhhfTwT+QZ0P_TJKTLSiVGpnr_Su8mcyEcvM19Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 8:12 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> Another way around this might be to add a way to go from socket cookie to
> socket, and not touch sockmap. I suspect that is an even steeper hill to climb,
> especially if it means adding a new syscall.

I think receiving socket FD from socket cookie would be much better approach.
It's clean layering and security folks will enforce that bit of api
individually.
New syscall is not hard to add.
man pages, docs are needed regardless.
