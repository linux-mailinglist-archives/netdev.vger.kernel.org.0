Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C254A5731A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFZUuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:50:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36817 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFZUuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:50:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so113763qtl.3;
        Wed, 26 Jun 2019 13:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0JIsc6upKI8LAsXQYXKRr6HIlOo8/DmHKKpGfMNZUew=;
        b=SjGNdwfNg/zcvVGN+PGBlPzER4WoOK2W/rlWgMe5EDeYvGrDCPHKp2nfZun+PStLEZ
         M7Y0HiMd2AQdt5pmBv/b4PN5sx5gtsvu1p7c/sl2xkPKEGIjX+vpoQ/fpefRgoTBNZJU
         b/q6V1NctY9VKorBH1nPg651d1aq35B9SGL5WtaK5QTjApgRRx3OuuDBICmTd1yjMxuh
         wLI5bsBAkfAoJmz0p4tjXdusElbj3ntkL7P4SH/CXsWVvLFq/7Wje6I1ANM4/x/WlW6O
         tU78+s/ses5VMjryhek9d7DiMvz8SE6oGnFGjZPZLhKYumKEXZ9qR0nnWgIpICMo8k04
         0kdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0JIsc6upKI8LAsXQYXKRr6HIlOo8/DmHKKpGfMNZUew=;
        b=Fg5BeBGj/ZmlJbzsaiMBlRk8WsBNyw5At4hDUBunHrTvroHs1XBHVarPHOqXsUv/xo
         B3f0eMml1WKg4axGjQxWWN3O/zKyw8bY8PeRJkpJ8NdmUt+FEpdWeaZ5MM4OFP5yBJl3
         obs2DMhdJNFPnUuR1tQuNwr8XO4oHkK18eQ2UOm0UjoYnNcV3GQtn+DcC85yiAyQv1oI
         A83l25fPoq0uF93G4kfzjPX2aQFTuAke/apZoH7vYGybX0N09/TD1QD7drsN4azCUqKw
         EbxuxZTSyUz5Rp6x4n0bN4lNCEn/clmTQf5dwWAAcelY0UYhImF8bC7iqx8FJc3fYNMh
         zwFA==
X-Gm-Message-State: APjAAAUq7Vxyibj0mJkoBwDjfmQp1oU0kGlK49vPtU8XXxl0g4cavLlD
        wJ14glOd2VC67LenLDbFgclMY7W39wtPuDH90Z0=
X-Google-Smtp-Source: APXvYqzg4kpaOhgH6DRsJAUX1HodpBqgBiRivJiHRugOt304HkbVCpfYd6BJiuQm5gWEfmapy8VnKuRQpNwdYxYSOeg=
X-Received: by 2002:a0c:c146:: with SMTP id i6mr5401108qvh.79.1561582233943;
 Wed, 26 Jun 2019 13:50:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 26 Jun 2019 22:50:23 +0200
Message-ID: <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com>
Subject: Re: [PATCH net-next] xdp: xdp_umem: fix umem pages mapping for 32bits systems
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 at 17:59, Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Use kmap instead of page_address as it's not always in low memory.
>

Ah, some 32-bit love. :-) Thanks for working on this!

For future patches, please base AF_XDP patches on the bpf/bpf-next
tree instead of net/net-next.

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  net/xdp/xdp_umem.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 9c6de4f114f8..d3c1411420fd 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -169,6 +169,14 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem=
)
>         }
>  }
>
> +static void xdp_umem_unmap_pages(struct xdp_umem *umem)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 0; i < umem->npgs; i++)
> +               kunmap(umem->pgs[i]);
> +}
> +
>  static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>  {
>         unsigned int i;
> @@ -210,6 +218,7 @@ static void xdp_umem_release(struct xdp_umem *umem)
>
>         xsk_reuseq_destroy(umem);
>
> +       xdp_umem_unmap_pages(umem);
>         xdp_umem_unpin_pages(umem);
>
>         kfree(umem->pages);
> @@ -372,7 +381,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct=
 xdp_umem_reg *mr)
>         }
>
>         for (i =3D 0; i < umem->npgs; i++)
> -               umem->pages[i].addr =3D page_address(umem->pgs[i]);
> +               umem->pages[i].addr =3D kmap(umem->pgs[i]);
>
>         return 0;
>
> --
> 2.17.1
>
