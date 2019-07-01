Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA75C5B2CE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 03:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfGABrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 21:47:55 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45719 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfGABry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 21:47:54 -0400
Received: by mail-yb1-f195.google.com with SMTP id j133so2762183ybj.12
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 18:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJdhgoJVyBjF6y56Yz8SfH5+EirvCctGgGTdf5tw12o=;
        b=ayWlfH8wR/hkxs/e5c6soPlhZ/Qswp6lMHQgqt5UTq+EkCM7EplobHcPRq3JrTvQF3
         eJ/yndyaIe5sFVcCgP51xFTtXSoc8XzumIv2dSQbtzTyl+j2SN4xzzQYiPEOR7p0TzGV
         DqBAAG6ysbkqHk9/0Ra6Sx9wQ9rgTS62KATgRaCbp2guI0MNv1tiqblVOz4oVFAqs3Qq
         3IcazZymYG4uJXpOz0h5EUsjlE9jMUApQkboXzhIXUpfArsrLVyA0C0UtzVZmtuGANvb
         H0zUXKip4S/xabpB8A1LuzLmYNddq4GqXL5wiQNrfJQjGttAnW16ycw+ak0pXIJd9hRk
         FANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJdhgoJVyBjF6y56Yz8SfH5+EirvCctGgGTdf5tw12o=;
        b=JeFdkKX2O1g+oyLUjg+vrhuiqsqx7YKCRd/JeqiC68o8v2/nFAGACXOP0TRHzwkVuw
         +gZdKYMhsXG0gjuyca6qyQwBhvqFr/cAlcTUmPo4WMvHvgzaF7rOUofxd2v/t4qJJxLj
         oOTWofcNyqKzkSWUQC0H/KZHb/JU3/rnGW9voY4YrDioASJSFS28gOZu8bNmPpRqztDj
         CkVnEZd1+HqWEUpp15idVMTOg1MVrlvkgD9Fo3Q/CPnHYcT6oQilSyhFzbSFVYLaRSjv
         CuLBhNe0BJ6W9grz6giGvKlwYe94aiwN/PWryKoU4RrYdudgzEWxKiTe8seJGll3/iLC
         SUEg==
X-Gm-Message-State: APjAAAUvL1C4QV6g6T6DJluW25HV7cbtVZXbnb+tywOztxN8X0USyNM0
        zy0mC4yU6Tno0BxeISdNgbB2OiuM
X-Google-Smtp-Source: APXvYqwrJluumEHrDO35tdNeHOF/lq97E3tzLv7EMnf6jnNGCm+I3ocmJMh/Gsl9x+jB6yVIdzva4Q==
X-Received: by 2002:a25:3c03:: with SMTP id j3mr8657439yba.479.1561945673823;
        Sun, 30 Jun 2019 18:47:53 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id b63sm2161397ywb.12.2019.06.30.18.47.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 18:47:53 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id t126so7703412ywf.3
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 18:47:52 -0700 (PDT)
X-Received: by 2002:a81:6a05:: with SMTP id f5mr13708560ywc.368.1561945672387;
 Sun, 30 Jun 2019 18:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <1250be5ff32bc4312b3f3e724a8798db0563ea3c.camel@domdv.de>
In-Reply-To: <1250be5ff32bc4312b3f3e724a8798db0563ea3c.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 30 Jun 2019 21:47:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdzM3AFFrvANczVzXeRP0TVZ06K--GkmTZVAk-6SKQGxA@mail.gmail.com>
Message-ID: <CA+FuTSdzM3AFFrvANczVzXeRP0TVZ06K--GkmTZVAk-6SKQGxA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] macsec: fix checksumming after decryption
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
>
> Fix checksumming after decryption.
>
> Signed-off-by: Andreas Steinmetz <ast@domdv.de>
>
> --- a/drivers/net/macsec.c      2019-06-30 22:14:10.250285314 +0200
> +++ b/drivers/net/macsec.c      2019-06-30 22:15:11.931230417 +0200
> @@ -869,6 +869,7 @@
>
>  static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len, u8 hdr_len)
>  {
> +       skb->ip_summed = CHECKSUM_NONE;
>         memmove(skb->data + hdr_len, skb->data, 2 * ETH_ALEN);
>         skb_pull(skb, hdr_len);
>         pskb_trim_unique(skb, skb->len - icv_len);

Does this belong in macset_reset_skb?
