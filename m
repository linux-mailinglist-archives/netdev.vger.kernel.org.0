Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDBC2A1A2B
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgJaSzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgJaSzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:55:17 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2880C0617A7
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 11:55:16 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id b129so5270242vsb.1
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ihn/9P+mI1TrpSLseBlkeoMR2PdaTo/ADbJQl9C/IIU=;
        b=nQU90Rrs9I2q8LielzG3CHQ9BdmI3+TrMcefvHN8QoZr4xUAA9khecRuhiV3s1l/XY
         1BSmdGdGwXnfpvThJrRfw6KL4Bare+f196eZ+x6MknAtRLKnI6TXai4uauwnZWAUxs3Q
         C3EOoUeHWIdfooJePelKZ7nBVDAKjxMhA0IwQuVq5+UVwopeKlly3DTT0sy1XjLZN45w
         +4jiZgwa0q05L4EDXWXZM5njJV6hvZtZkvB7a6FyILewuMrvbZSZ/AMWJpxN7VXw+Bpd
         0LtuPKXqEqz2hUgQZ7OshzvRZyYYbQNmk2wes7dj7moa3rjk+8U0jfOnID6rHFXNxxAJ
         s9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ihn/9P+mI1TrpSLseBlkeoMR2PdaTo/ADbJQl9C/IIU=;
        b=UjC1B3WH1+n7/D3D/pGPyxBx97KfpcG0j7i8p8bl/6BW+zuvfp2ckNb5wM9DlCJmNv
         pgnYndwTsZJboLboUv+uE29JvPKf1U7oIWZYAZLt3HPw9e/VEHnC4oJyoWJzTlhriNcS
         yU0tfQcK1EyPB6T4DGwNi+gX43gAFqBMMpbYwd65dtRJeW5Pt7+nwSysUmqIFNafvH3J
         1oS6Kx5WZyc2SbYVEt2zhz+pmcTUY/EbA80h6bT2rRnvRcglLFqW4oU1jzfxJu4qk5Au
         I6387p1J5ejl3hvGfW1oPZGM5VYOguE6cijnRqV/yBDcSR7tgnFNBMG75QBR5IkPuaFI
         huHw==
X-Gm-Message-State: AOAM530PYVz98HiEsOQHQElhe5i/6oupHiddiLreC0ltE/BmOcgIE+LL
        2/9t1EyaaytuO5WiizIWU+bgJQoEC9I=
X-Google-Smtp-Source: ABdhPJwMRD8wXdX2DHpNi8fJTqNcfjS92MGNoR8XnBNFn/sqjZYwsqPzVdvoiA83eZChxIjWqlyiZw==
X-Received: by 2002:a67:dc88:: with SMTP id g8mr11194433vsk.45.1604170515015;
        Sat, 31 Oct 2020 11:55:15 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id v189sm1154269vsv.26.2020.10.31.11.55.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 11:55:14 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id s144so2169272vkb.1
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 11:55:13 -0700 (PDT)
X-Received: by 2002:a1f:c149:: with SMTP id r70mr10316795vkf.1.1604170513281;
 Sat, 31 Oct 2020 11:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201028145015.19212-1-schalla@marvell.com> <20201028145015.19212-13-schalla@marvell.com>
In-Reply-To: <20201028145015.19212-13-schalla@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 31 Oct 2020 14:54:35 -0400
X-Gmail-Original-Message-ID: <CA+FuTScj_mRU0Eor2-_awn7s=AOAx_x57NOJscmmWV-BtwaFmA@mail.gmail.com>
Message-ID: <CA+FuTScj_mRU0Eor2-_awn7s=AOAx_x57NOJscmmWV-BtwaFmA@mail.gmail.com>
Subject: Re: [PATCH v8,net-next,12/12] crypto: octeontx2: register with linux
 crypto framework
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 5:43 PM Srujana Challa <schalla@marvell.com> wrote:
>
> CPT offload module utilises the linux crypto framework to offload
> crypto processing. This patch registers supported algorithms by
> calling registration functions provided by the kernel crypto API.
>
> The module currently supports:
> - AES block cipher in CBC,ECB,XTS and CFB mode.
> - 3DES block cipher in CBC and ECB mode.
> - AEAD algorithms.
>   authenc(hmac(sha1),cbc(aes)),
>   authenc(hmac(sha256),cbc(aes)),
>   authenc(hmac(sha384),cbc(aes)),
>   authenc(hmac(sha512),cbc(aes)),
>   authenc(hmac(sha1),ecb(cipher_null)),
>   authenc(hmac(sha256),ecb(cipher_null)),
>   authenc(hmac(sha384),ecb(cipher_null)),
>   authenc(hmac(sha512),ecb(cipher_null)),
>   rfc4106(gcm(aes)).
>
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  drivers/crypto/marvell/Kconfig                |    4 +
>  drivers/crypto/marvell/octeontx2/Makefile     |    3 +-
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       |    1 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       | 1665 +++++++++++++++++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |  170 ++

These files are almost verbatim copies of
.../marvell/octeontx/otx_cptvf_algs.(ch), with the usual name changes
otx_ to otx2_

Is there some way to avoid code duplication? I guess this is not
uncommon for subsequent hardware device drivers from the same vendor.

If nothing else, knowing this makes reviewing a lot easier.
