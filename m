Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E805CE694
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfD2Pcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:32:47 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:44858 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbfD2Pcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:32:46 -0400
Received: by mail-ed1-f47.google.com with SMTP id b8so437919edm.11
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 08:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WGxmUuK/iKGgz/VPYSyDdbdql9h9vFR3WwDYTYbXWgA=;
        b=HbtWwUzbVs3fgxgrEa5QKrEMnTsFFNd7uzKMH74lQCQpA8ESxfzpMyqLTqgg9PPkVS
         4qdB8HmIlakYFEbp8zk/jBoVfsFvkV0S0UHbIwOAr94ED9feiVnGXoTBwv7mR2hoplBf
         JFG2YNkUGRcsLHu+406iqYbFKYpMhAjfDma2O8d+O/5jVNvbiN4ciL/tQlnnMnlbGtIe
         vkUsqbdJNBjz88bJwdJ3tJam4iX1KZSiwT8berkoJ1O/W57vpNMpQNIKwMoWZJCdNnLS
         qMENApcyn+GnMutX6xxPnMFuiCI1gQw7BuzCalX69qAo+W5Oda5hYQ2ch0BoxZsRW1KW
         OvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WGxmUuK/iKGgz/VPYSyDdbdql9h9vFR3WwDYTYbXWgA=;
        b=U0rzoVZWCTup+vBdDsAMTPSnEg614WpJARrCxdZyc6JrePJhiH7cXfSzurhWzazZND
         T+1DNP/1yVZnFrSaWAu+RZeZnhbLg58IfStPrTpO7IXCm5LPhUbHQS07mvHSBa1oM5Ds
         I9enqeJkgOlbjcafBsP8Zug9LZBKVtZiuo40MDvKsasE+dyeUxr24flt243XirW7inli
         ycLbAOA3lxxmI/E0Rp8lW52sJXFHko+Sfg0Bk4NAyafx7WtJ+RU78zIAEVaDAfbANQsv
         qEyZWLHYQUb+Pte+m1iN+8SKyDjJ/A0mtHTM7/w1Lm02WscX2ysw8AkOGSAk4KJumBm0
         5/nw==
X-Gm-Message-State: APjAAAWIO5VEm31tbOhACLUNsgSukyaKFOclO6c8DcbPhbdVHmhclMIq
        GLe8zb1ckk/A5GpIKqJddlBKWHpDp9uoHbDAakkqig==
X-Google-Smtp-Source: APXvYqyY5KCnlZr8c7jHDf8mbng7ImbTLVgjQytlpf3CurEzW7n8NGOIVP4IVMooTCtbVx8yhtYPCBraUL40raH8vrg=
X-Received: by 2002:a50:adda:: with SMTP id b26mr26084817edd.2.1556551964849;
 Mon, 29 Apr 2019 08:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190428054521.GA14504@stephen-mallon> <20190428151938.njy3ip5szwj3vkda@localhost>
 <CAF=yD-JLcmyoJ6tq1osgrQbXs6+As0R+J-ofU+XwQWcvaW+LBg@mail.gmail.com> <20190429150242.vckwna4bt4xynzjo@localhost>
In-Reply-To: <20190429150242.vckwna4bt4xynzjo@localhost>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Apr 2019 11:32:08 -0400
Message-ID: <CAF=yD-+EdbxnSa1SUqPamdxeDN_oPd4-kXAEF6yV1o_Zwj+LUw@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: Fix updating SOF_TIMESTAMPING_OPT_ID when
 SKBTX_HW_TSTAMP is enabled
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Stephen Mallon <stephen.mallon@sydney.edu.au>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:02 AM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Sun, Apr 28, 2019 at 10:57:57PM -0400, Willem de Bruijn wrote:
> > It is debatable whether this is a fix or a new feature. It extends
> > SOF_TIMESTAMPING_OPT_ID to hardware timestamps. I don't think this
> > would be a stable candidate.
>
> Was the original series advertised as SW timestamping only?

I did not intend to cover hardware timestamps at the time.

> If so, I missed that at the time.  After seeing it not work, I meant
> to fix it, but never got around to it.  So to me this is a known
> issue.

Understood. I certainly understand that view. I never use hw
timestamps, so it is a bit of a blind spot for me. If this is a safe
and predictable change, I don't care strongly about net vs net-next. I
don't think it meets the bar for stable, but that is not my call.

> > More importantly, note that __ip6_append_data has similar logic. For
> > consistency the two should be updated at the same time.
>
> +1
>
> Thanks,
> Richard
