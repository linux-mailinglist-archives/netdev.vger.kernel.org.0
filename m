Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F156D116D92
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfLINHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:07:19 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:44686 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfLINHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:07:18 -0500
Received: by mail-vs1-f66.google.com with SMTP id p6so10146474vsj.11;
        Mon, 09 Dec 2019 05:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/vybDmWWZt0m6v/jmvE3pAWJT8MUyCcD69ScwFHht4g=;
        b=kycNNEVqK94LnIpOC4QjHxsGSZd5BiL0JBbzIqDaYhGAU+1FpbvEx4xfi3uYLbefk4
         EtE4Ne1pqrULsKWkkgPW3oECFUS9CjFfIARzE08iEyRlb6nSnfPbgPpZCI//HgQBF/Ov
         jf9tQWvIdcnXI3LvWuV+8ciS+6p6KoxPrplVaYXqfyNRZ0wW3klPAeBU/vQO1cME8myV
         GqBBsSWJ5BepqxIPaEpl/XWfj5Eul62021NsJXQeK21BPI36NYBsN4au0sH9tnyhuMHM
         lwMisqCZBcN/RNtozASaLt6m4JElFz0cwM4xqg4sDgpm2GHBYthONL9ff7CIP66mXnuV
         xiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/vybDmWWZt0m6v/jmvE3pAWJT8MUyCcD69ScwFHht4g=;
        b=YeOzDcoPtGyRktqvb2NHiySIQY75HQZIPDIAPThNwwJIvvPt9batg5JY9EfjhWNGQN
         5v2xf2/t+GNPgF0qhALKxIItzXAwHT18if7BOWTlFABEg0TrXuvnhndT3hjeh6CrXaQn
         U2amkFr/WsGDQw38kUiZF7eAqCawHQBkw6M1WbW4PC6P8aVqyjRk+gWlzzP/wL8UMtth
         bzgZxTsPgveJ5sB3b/BEIDCwogi83AfIjRo1IpLVr7WNDJAksG0oyNMJeJbx+ipLHMS2
         /FmwCPERxSkD37n57qEcZNlHwjwZcWzLtwLQcVQQegQJV7ZaTusv+LQcaKcRZUER99To
         YlfQ==
X-Gm-Message-State: APjAAAWgPOdYUXLN9r7KZrfdGGw3T0AjonU+U8FnlsdPK80LL7DNAm1M
        UmngOXVQLIy+y+0g1SGdj8vYwrkZFxBYp4MKjwE=
X-Google-Smtp-Source: APXvYqwre667574Qva3LM57Gmp8o/Yepc8XF9SXzyu8P1nOBy3Beg7CqTLewa+NoHSMIDA/6AV5FbaaILSR+lmEsOsk=
X-Received: by 2002:a67:2c50:: with SMTP id s77mr15841458vss.222.1575896837810;
 Mon, 09 Dec 2019 05:07:17 -0800 (PST)
MIME-Version: 1.0
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
 <1575878189-31860-6-git-send-email-magnus.karlsson@intel.com> <8e243b69-0642-962e-41b4-8d0107b960c6@cogentembedded.com>
In-Reply-To: <8e243b69-0642-962e-41b4-8d0107b960c6@cogentembedded.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 9 Dec 2019 14:07:06 +0100
Message-ID: <CAJ8uoz18h8qrd-w6eakW1k+ZNW=erB7wLqO9+H50iZ4J3cXg5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/12] xsk: eliminate the RX batch size
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>,
        jeffrey.t.kirsher@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 11:17 AM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
> Hello!
>
> On 09.12.2019 10:56, Magnus Karlsson wrote:
>
> > In the xsk consumer ring code there is a variable call RX_BATCH_SIZE
>
>     Called?

Yes, definitely. Will fix.

Thanks: Magnus

> > that dictates the minimum number of entries that we try to grab from
> > the fill and Tx rings. In fact, the code always try to grab the
>    ^^^^^^^^^^^^^^^^^^^^^ hm, are you sure there's no typo here?
>
> > maximum amount of entries from these rings. The only thing this
> > variable does is to throw an error if there is less than 16 (as it is
> > defined) entries on the ring. There is no reason to do this and it
> > will just lead to weird behavior from user space's point of view. So
> > eliminate this variable.
> >
> > With this change, we will be able to simplify the xskq_nb_free and
> > xskq_nb_avail code in the next commit.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> [...]
>
> MBR, Sergei
>
