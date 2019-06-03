Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5464133538
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfFCQuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 12:50:40 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43426 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfFCQuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 12:50:39 -0400
Received: by mail-ed1-f66.google.com with SMTP id w33so27770712edb.10
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 09:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knr8D4hkv6W6rhBQ8NuaEakh8/x/Td4aIAD4DhQpvog=;
        b=ZhrCorZvgnAJ2nwagFq9ZtZ9aDeRlXcWbMDS86OLhjUvsgrQ8J7+VQ/usZoXTANU+W
         snOic+GoBR/Ob+7OnV0TBL8BGVLk2oGxPrg2ctSWtqR+38hZ+WAxggqzhuehzQkfdjsE
         UG1ZAToTOc/dBKkEhttLdiOP5TvVpDWs3j4RxA9tdjod3XXbILUx1PidKIdhbmnRXnga
         6IL9bc0UYrOGbjPbYgr+CKxADD4Z4r5WlqH8EfWQEvjlFuikUDksR38OG90TpYMHQgqp
         FVbEY1XpFet6nIAl/I0xFgJbO8ISuaZMEhz/X9xGljJgYv0munrE25+GBV5bVrpZGpOh
         q1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knr8D4hkv6W6rhBQ8NuaEakh8/x/Td4aIAD4DhQpvog=;
        b=bNe6U9AMPzESx/Gfg4EDGQT7vqfswOb5OJsmhyMFh5QwH1EUE3OZmscbFhnsFsUMVU
         FTeVbzlODNhGxVVxJSRwtYaWBZVX0nuivuiNZWQHRJpBuVu71kRlxvH8URiikebin/Ws
         Pzzi0f0qsgoxB8P61vkEd/TLbKm0GCQwHrqJjh77jENPHZ5zrAOrXVHh4/TsOnvCjCD2
         /SWbDWynWPEaQrEKeAk8mK3AfBS/DbdHxtlpoFvp/BC6rv9aGVR6ll8yA9mZAZpIcK8R
         9Q7TNFZyULCWiRf2ukr/wTqsZ3nLRtyVmOZdmiToImUNdqtmaJTzFZO85Ev26jEEgEsO
         lAJw==
X-Gm-Message-State: APjAAAVwRUW9spB5FVit6KrCEkcVKyurKdk940ukemS2njSpC/korhtk
        PpVFK/UH7R1aL8aoq5zlqQROQSCHsWZjbqlBBjM=
X-Google-Smtp-Source: APXvYqy/lJ5Vn0eBcQj9c+FOe4hX6WAd5ElukNQQzV3ixNjPpqwhUWySXue18PkaMEOGpVGrU0f62bID/EEAs+pB/4Y=
X-Received: by 2002:a50:bdc2:: with SMTP id z2mr29951058edh.245.1559580638079;
 Mon, 03 Jun 2019 09:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com> <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net> <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
In-Reply-To: <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 3 Jun 2019 12:50:01 -0400
Message-ID: <CAF=yD-LPpDZzgW8QezvoQ=R5zykQSRvsv74YEZQz1QVqUj0riA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, weiwan@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 5:38 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/31/19 3:29 PM, David Miller wrote:
> > David, can you add some supplementary information to your cover letter
> > et al.  which seems to be part of what Alexei is asking for and seems
> > quite reasonable?
> >
>
> It is not clear to me what more is wanted in the cover letter.

A bit late and people in this thread probably already do know the context.

But for those like me that did not: a summary or pointer to the
overall goal and design would be informative. A search dug up the RFC
from last year. That definitely helped me understand the intent a bit
better.

   net: Improve route scalability via support for nexthop objects
   https://lwn.net/Articles/763950/
