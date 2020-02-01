Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2FF14F8D7
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgBAQYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:24:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57552 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726622AbgBAQYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:24:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580574288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rVA1xvyvgyakVVp4hFUV7KOikNj3zE1qxsDSM6eeL9k=;
        b=DnTQc1mm+CHY5CnKWDa0L8T9hWfaoEMaXmsrC7LKebAwLlOTSpv1hmApA8sGrdq58YByRG
        zjXjeKacU61N+Jk2WQpMnGZO1hLYUiUogMHU1BsFiGsmvAZcG2w5aOOpwi2fZk1hIk8Wg+
        AM8XKta5tBE8EQ9qdaUVy5Tg6wEJx+8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-zEQZsF3qNKSQkAwNPHmcJw-1; Sat, 01 Feb 2020 11:24:46 -0500
X-MC-Unique: zEQZsF3qNKSQkAwNPHmcJw-1
Received: by mail-lf1-f70.google.com with SMTP id j193so1724582lfj.9
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rVA1xvyvgyakVVp4hFUV7KOikNj3zE1qxsDSM6eeL9k=;
        b=GTMv2SzxoC9nEwRkDouunyAe22D4kPVPdBoSz81DbbzyraROaJOnPhJvJQRaAJVffs
         4bOP8O4pa4nx/sefwXE0DwwoTN6PgaY45ZwjJkK3fnZc2/wuPbBqLAwqgScvI4QZodWB
         M3wINU9i+MZFIMaywv0APxw6qUB1wvna3YOQPgOe4rMtDvQn0EiAnzpd/sICF1vgOgX1
         tsP0/vHnoYNyYtgAWo1zZujXq6gUlD+upw2fwt/HNH27XJBj30UsqD8/r84sSgXZB2Qf
         3K1uBWc+gIOuo1ZPjXryswiAPIPHzIKLnHzEMwjZN8clL2jhOMNGCoWjL3eqmjwtV7Id
         wUnw==
X-Gm-Message-State: APjAAAXU+BMyLI95TEnU4L5mHL/x17HxyJkbJlFroEy7euLbFvCDlxd6
        SRNEXUID4A5gK330AJEAvSiiHmlgg7FablbfjdJiexP5wKnx1gp2sbQ466Ne688KL8gvm90/jm6
        u1EbdEmLhiYqucH6H
X-Received: by 2002:a2e:7e11:: with SMTP id z17mr9177512ljc.279.1580574284877;
        Sat, 01 Feb 2020 08:24:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6ldcko3EJxW/8Z861I0HUJBXFWmXKYV3DZFPoz5EmjPIifk68Mi/kkLdXta9lqupvd1orbA==
X-Received: by 2002:a2e:7e11:: with SMTP id z17mr9177490ljc.279.1580574284605;
        Sat, 01 Feb 2020 08:24:44 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id 14sm6221745lfz.47.2020.02.01.08.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:24:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 57A311800A2; Sat,  1 Feb 2020 17:24:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200128055752.617aebc7@cakuba>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <20200126141141.0b773aba@cakuba> <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com> <20200127061623.1cf42cd0@cakuba> <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com> <20200128055752.617aebc7@cakuba>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 01 Feb 2020 17:24:39 +0100
Message-ID: <87ftfue0mw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ skipping the first part to just comment on the below: ]

> I'm weary of partially implemented XDP features, EGRESS prog does us
> no good when most drivers didn't yet catch up with the REDIRECTs.

I kinda agree with this; but on the other hand, if we have to wait for
all drivers to catch up, that would mean we couldn't add *anything* new
that requires driver changes, which is not ideal either :/

> And we're adding this before we considered the queuing problem.
>
> But if I'm alone in thinking this, and I'm not convincing anyone we
> can move on :)

I do share your concern that this will end up being incompatible with
whatever solution we end up with for queueing. However, I don't
necessarily think it will: I view the XDP egress hook as something that
in any case will run *after* packets are dequeued from whichever
intermediate queueing it has been through (if any). I think such a hook
is missing in any case; for instance, it's currently impossible to
implement something like CoDel (which needs to know how long a packet
spent in the queue) in eBPF.

-Toke

