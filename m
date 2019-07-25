Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E537428B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGYAXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:23:07 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42500 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfGYAXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 20:23:07 -0400
Received: by mail-yb1-f196.google.com with SMTP id f195so17925247ybg.9
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 17:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHEEeqS0RIWwnIW9ubiumtEUJKwAyh7PaxD3THhSDLs=;
        b=a5uQ7T/AThp/yOiDQnavmrBn2evsIkMtlevlYaBERR6CnsUN6xjqJ0DkmLTLuSjSRs
         Q3OHfrr9G+JI8UZ14JcxLq3tzbJDUu2e4flfeDLO4D1cbN5iiZdMOEbe3u6lbib3C77F
         ZJCUp8DqgRWCfFH3sa8M8fGhOtCW8BryCeK8aABvPi7hB/49+52DtHS7zOvsi5+ENtII
         8XglpzEoxYWHjPMfePUZljODvjy4G6SRUHS8JSYpeUEb95ErN+Xk0PhRgi6EBD3aQPPn
         ZRjSd6pI5ylqiyb+uNwl0tYReRFGsl6NhikpzSAilZeiE8YecoCLJzJVSwn5j3P/3alO
         BhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AHEEeqS0RIWwnIW9ubiumtEUJKwAyh7PaxD3THhSDLs=;
        b=BVtwBSfYb8bEV4e6Cu9onpfuPiS6fadBIJ7eaqJZOsDj88XtPrqvGwqQ/XKi2jh8my
         Y7OTV4vMh/YHN4SW1jFUlh/gcWTq3oqqjCWI4CCA9IDyq05bFRI+3gwd1hc05fR7dkWC
         x9/PMCoy3Nq380BR32b6IN1x8LYUKiGD04odNsqgpldjIYswM8+gSl3emgSrHmmpajQ0
         DOPLsZjSnTe6X5yzdCxJuD6GY4n/MBn+UCS8ai5a43iNoFG/a0gVk+tsbbdN1H+5YLp3
         KJktBBidDLrCv4bKbJsKXrvtomr/Qqfwfy/OO9M7xVgK9yMQw320aIEH2lvfStRk40ek
         a7Hw==
X-Gm-Message-State: APjAAAUsFn2CGU1uD+7i9yCfn5MblCh1UTvMzg0MXWBny9+xYVKYEBR9
        manK5ZrHaEcn0B+gAFnVQZoM0EfS
X-Google-Smtp-Source: APXvYqwDZpS0Dej0Wqdyk8s4Q2lYiQsfzu4RL4LnXUcmOVkDquSjnP136IqXv8Uwe3FhLHoqCrYT0g==
X-Received: by 2002:a25:cfcd:: with SMTP id f196mr54429492ybg.344.1564014185719;
        Wed, 24 Jul 2019 17:23:05 -0700 (PDT)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id v77sm11690410ywc.25.2019.07.24.17.23.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 17:23:04 -0700 (PDT)
Received: by mail-yw1-f42.google.com with SMTP id l79so18672898ywe.11
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 17:23:03 -0700 (PDT)
X-Received: by 2002:a81:6a05:: with SMTP id f5mr53051661ywc.368.1564014183505;
 Wed, 24 Jul 2019 17:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190725000714.10200-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190725000714.10200-1-jakub.kicinski@netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 24 Jul 2019 20:22:27 -0400
X-Gmail-Original-Message-ID: <CA+FuTSek+Rb4o5ogKZh=3CQgyzXNMV=pq4iM7u5RknMEYL-vnw@mail.gmail.com>
Message-ID: <CA+FuTSek+Rb4o5ogKZh=3CQgyzXNMV=pq4iM7u5RknMEYL-vnw@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: add missing gitignores (ipv6_flowlabel)
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 8:07 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> ipv6_flowlabel and ipv6_flowlabel_mgr are missing from
> gitignore.  Quentin points out that the original
> commit 3fb321fde22d ("selftests/net: ipv6 flowlabel")
> did add ignore entries, they are just missing the "ipv6_"
> prefix.
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks Jakub
