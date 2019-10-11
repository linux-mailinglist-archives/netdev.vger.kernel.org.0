Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338E0D4513
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 18:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfJKQKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 12:10:11 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:35674 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfJKQKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 12:10:10 -0400
Received: by mail-qt1-f179.google.com with SMTP id m15so14645333qtq.2
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 09:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbuki-mvuki-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OquxSxy8DcF7GXOhT4Q0zOJdtlC529htpB8iD01eQAw=;
        b=kHZPVYqbzSufogm+6hHjMpMs394dQtjUj7TFFiaZRycjrEYm1ZiAG0yfHDzfwmLpOS
         ISmZNJ3rPKCHbWXfjtlGjVNjsCEJIROM6onqLuUoRvoYv7d1R4Ct94m9A+wxpVWQZGAl
         6D5WlqPPqD3a4Pr9YM4yVZzFJ7+riQgpQ8Lc1+AO3B/A8gFo5VTx1HKPqaqcRButfKmj
         dQ3+Hc4vvVPRSFCoztsOOhwyPXZyavNVVlXahFAwxt6QnOtsQimfmzBA9OjCgEg5PHrl
         Ktsr4Mr8wHZtpmR/wv8wSMLjCrqPtFGeVCPDd3niMdxC/C4g6j29Sx+TLJrGt39FFlqZ
         pBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OquxSxy8DcF7GXOhT4Q0zOJdtlC529htpB8iD01eQAw=;
        b=G3+CQRWFE0X+379Gn44z7KDd/317Qt3OoWvUon+PaWIU7BsldxvD1Zf7XhkAz/02C1
         bLPfUFEI08Tjw7IfQf9U3fiP6seZSjJ03ekS4WCitfoEsrHx0b15Ot76tPCi6tZpR59X
         IGy1EUd4q6u+iaFQA3xJL0HYf3KjROljwazh5Bj3XkpUhe0yVxWXgA0Q/Czhnjg9nRqx
         wj8OCryuIBSGrfFd4Q2ZbPgiK8iLuTeUOsnToGGEevHP4+lPLL9c+VwrQNtRb2VkejY1
         5b7HweBkLPDroNM2qi3Xi+M1xZFx3tmxVckiS7tvrx2KuZu3DRUNDd/7ip8ABJn8VGoi
         ohSQ==
X-Gm-Message-State: APjAAAX0sKm74lqGeH2s0rEzFte22i1O0hWyhnfu8dNiGVPP7EM1LgeF
        tM2PAwekztJ6TvB3rqGXc3kk5A4XZAZCZj6k39pR+Q==
X-Google-Smtp-Source: APXvYqy6O7464Mx2dIJY5QWVGDo8oyPgz1tloXBvdw/gXoZSooZhuFhDNaWnzvgtB5+ewpxFmaUBE59ikvRoRNu4QCk=
X-Received: by 2002:a0c:d610:: with SMTP id c16mr16422017qvj.229.1570810209510;
 Fri, 11 Oct 2019 09:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter> <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
In-Reply-To: <20191011154224.GA23486@splinter>
From:   Jesse Hathaway <jesse@mbuki-mvuki.org>
Date:   Fri, 11 Oct 2019 11:09:58 -0500
Message-ID: <CANSNSoXA1PhbGAzTP9K8FkGxL0tgT13+uLG3hJgesuUysWjC1Q@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     Ido Schimmel <idosch@idosch.org>
Cc:     weiwan@google.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 10:42 AM Ido Schimmel <idosch@idosch.org> wrote:
> Do you remember when you started seeing this behavior? I think it
> started in 4.13 with commit ffe95ecf3a2e ("Merge branch
> 'net-remove-dst-garbage-collector-logic'").

Unfortunately, our data on when the problem started is a bit fuzzy, but we
definitely started experiencing this issue after upgrading our routers to
4.19.18. We were previously running 4.9 on our routers and we don't believe we
saw the issue on 4.9, but we also do not have definitive data to confirm.
