Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF73638B3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfGIPeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:34:25 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45239 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfGIPeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:34:24 -0400
Received: by mail-lf1-f66.google.com with SMTP id u10so13716557lfm.12;
        Tue, 09 Jul 2019 08:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XldrumkAgmzEzxgr2Bcv/W7MnrtFEO21Trg6QIY5k84=;
        b=BVh3b0bBJ8vh+cbfAE1PPxlD2zb/+DWuI9G4Wtyh3ITaGL2D9FqMGozHfb1aaI02WV
         ZTlXfMRbRIaF9f3x4uz3kUZHECth7ftSAK7Jrerx5Psp6tVSStd+0UCW41LnbUREBKxt
         vAhywaDHaaHaItpu7fXme4HVUKJtcQz2fS0CmcRab8SfYlBpHCejckEK0GeSFZgasyQQ
         CYyZoLpkS4Fn93kNK4uw7bxmnbbkpLAl99vL2A3vkrh5cQbCjK6iI0RicvAie7ayQJKY
         EywTtOe5759BFFnumbj2P+z7DQYnU2QfTF/wqyJjbEDl1b0gsje/3phHX/QKj6QugLwA
         FZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XldrumkAgmzEzxgr2Bcv/W7MnrtFEO21Trg6QIY5k84=;
        b=cgmvdi0OO7tCcVOHicu0WvZADhDtZ5ld8O8MvoJcxzPTs1u1gm5riYY0S3LjsGk4i4
         4g0Bo2ILNkN58wZIIydrH1JSBjQ49y7qMUACqmSWk9Qy7kMxN9Cm9GPhuZOVi+3OXUaO
         Iwu1VP7dz8SoBgGw+J4UjP10mBhAeJ2xBvOZFogsL25SFIg3JU9zTg2fQ0ayFTXYEupz
         kNgacxO6WrAV28iUg/5xZndlceB3GD436Nw5b3MnkAoFS8Ce7+KrWEM2U8S9Drnh7IZv
         vnao1ijSOV6UPpI47fxfJa6R4I7E1HY4Df3OGFmJFhLWyHChPQeZQd6OGT/mvFg6DPrZ
         nu0g==
X-Gm-Message-State: APjAAAXfaPoXg4S3IuUC/Ieo7nNoHTBZnj6iIugwLHSJJhhBvIJLlQkX
        /B7wYflJM8l4BJLxPqrnWkGuyc1jHrCxvYr+UrM=
X-Google-Smtp-Source: APXvYqzRxvwVIQVCdYryBBCbyZSV+GA8BjIWzect/o4kWLCLUJtoHLajB5JkQJAcIVflMA6QTClU8Xt3pMYR+CHnCbo=
X-Received: by 2002:a19:6b0e:: with SMTP id d14mr11779539lfa.174.1562686462634;
 Tue, 09 Jul 2019 08:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190703170118.196552-1-brianvv@google.com> <20190703170118.196552-3-brianvv@google.com>
 <CAH3MdRU505Er44m460c7y5nxtZxmDmVY4jDrWOYt2=OdP2d5Ow@mail.gmail.com>
In-Reply-To: <CAH3MdRU505Er44m460c7y5nxtZxmDmVY4jDrWOYt2=OdP2d5Ow@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Tue, 9 Jul 2019 08:34:11 -0700
Message-ID: <CABCgpaU=H+qOUAx+yRHJjBMqmeAtp5iQL_yv9cXB6HTqB0jXcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC v3 2/6] bpf: add BPF_MAP_DUMP command to dump
 more than one entry per call
To:     Y Song <ys114321@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Maybe you can swap map_fd and flags?
> This way, you won't have hole right after map_fd?

Makes sense.

> > +       attr->flags = 0;
> Why do you want attr->flags? This is to modify anonumous struct used by
> BPF_MAP_*_ELEM commands.

Nice catch! This was a mistake I forgot to delete that line.

> In bcc, we have use cases like this. At a certain time interval (e.g.,
> every 2 seconds),
> we get all key/value pairs for a map, we format and print out map
> key/values on the screen,
> and then delete all key/value pairs we retrieved earlier.
>
> Currently, bpf_get_next_key() is used to get all key/value pairs, and
> deletion also happened
> at each key level.
>
> Your batch dump command should help retrieving map key/value pairs.
> What do you think deletions of those just retrieved map entries?
> With an additional flag and fold into BPF_MAP_DUMP?
> or implement a new BPF_MAP_DUMP_AND_DELETE?
>
> I mentioned this so that we can start discussion now.
> You do not need to implement batch deletion part, but let us
> have a design extensible for that.
>
> Thanks.

With a additional flag, code could be racy where you copy an old value
and delete the newest one.
So maybe we could implement BPF_MAP_DUMP_AND_DELETE as a wrapper of
map_get_next_key + map_lookup_and_delete_elem. Last function already
exists but it has not been implemented for maps other than stack and
queue.

Thanks for reviewing it!
