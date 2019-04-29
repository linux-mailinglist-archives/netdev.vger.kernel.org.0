Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1617EE71B
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfD2QAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:00:14 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41341 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbfD2QAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:00:14 -0400
Received: by mail-ed1-f66.google.com with SMTP id m4so9591482edd.8
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 09:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCAfamZkmNrnp3NOTBhI/B1L259GPKMj7r2c0Kfbv8c=;
        b=RdXqsnaAkfVxYAJ8twpS4ZuWmw29D9ZXRY8UtvltmouhBeywKVJGx1GTSu/g7nhIf6
         S5K6VrVhvwjXHAuxb1QNyoXNSl/dtAH9vhVCoj3H3XM/9e2KCYuLx/L/K8t8aLO4wyGZ
         yq+x1xhjENHpcd6PwENybf6ar+M/Mk6BCy4L7OpeBICGPvP0+6TSTp7Na8qEOpjLoCrF
         FmjRJQ4SkjxGVSE/9GZG9e+J3qa87buPMYBpP3vRTf2P+WX9xjo8TXv7gqLBkqNr2DUe
         r50JaFCsq//STtq11C5CxMyxqo97wogo9sWe6jRlxaAEZWdd7Pl+qNjGGXXPjolf2Q/X
         +Psw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCAfamZkmNrnp3NOTBhI/B1L259GPKMj7r2c0Kfbv8c=;
        b=qaRPhL9bcrz0kadSLYBXUqK7I/LKk5DOnxrFumtkyFesvzt6FB4rIKueYOoeum9ET/
         QqYtxZSbHvvg+yQaJWcJNFtC7Wo5Blf3sG2xpRCyoAAx7tIeolIebnMBlABChYKH3u2D
         Z46/mN4PjlOcFkIyBtzS+m4QeRIa8N8rRAhJ1PBjNq0I7dcmCuAgq3Ab2uWRgn6nH7GQ
         S9XgnMSvCszatohoN2BsTflEUETPUd9F62Ss7nX8P1iTZznp5iDGkdBDBath6evQtqm2
         TscAy2x+thjWllJ6JnlyeFZZbIlsrV61UPZwvZ0mmI56OGbX+9hbielU1s2NJtqL8OgB
         wM8w==
X-Gm-Message-State: APjAAAXjkwFWYjK76K4KnWLkWllPQySbyU9jVf/xIda8Tsh3rAoQyovr
        CmZauNmxC6xEcFdCPj68BFPbl4D4SF4nXElNx6U=
X-Google-Smtp-Source: APXvYqxf0ByI0Ohmghe86CqzGzW0LyDDQIBcvkYHHUh5B+r8aCSNYZejdDUso8s5qAFy45D+WcOYRHKL1FFJ2d4HFYI=
X-Received: by 2002:a17:906:1c8c:: with SMTP id g12mr30464284ejh.97.1556553612470;
 Mon, 29 Apr 2019 09:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190429154655.9141-1-willemdebruijn.kernel@gmail.com> <b4a396b7c2f5467a97433d7c52530924@AcuMS.aculab.com>
In-Reply-To: <b4a396b7c2f5467a97433d7c52530924@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Apr 2019 11:59:36 -0400
Message-ID: <CAF=yD-Ksh0w=60v6DNFudKJvHWs0L0Da1GuSM=w0wOX-Gm+LYg@mail.gmail.com>
Subject: Re: [PATCH net v2] packet: in recvmsg msg_name return at least sizeof sockaddr_ll
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:49 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Willem de Bruijn
> > Sent: 29 April 2019 16:47
> > Packet send checks that msg_name is at least sizeof sockaddr_ll.
> > Packet recv must return at least this length, so that its output
> > can be passed unmodified to packet send.
> >
> > This ceased to be true since adding support for lladdr longer than
> > sll_addr. Since, the return value uses true address length.
> >
> > Always return at least sizeof sockaddr_ll, even if address length
> > is shorter. Zero the padding bytes.
> >
> > Change v1->v2: do not overwrite zeroed padding again. use copy_len.
> >
> > Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
> > Suggested-by: David Laight <David.Laight@aculab.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
..
>
> Looks ok to me, not tried to compile it though.

Thanks again. I did that and also ran a small recv test that verifies
namelen (but clearly did not help me see the stupid bug I made in
v1..).
