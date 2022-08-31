Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01745A81C7
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiHaPlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiHaPkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:40:35 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178D931EC9;
        Wed, 31 Aug 2022 08:40:08 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id y3so29222921ejc.1;
        Wed, 31 Aug 2022 08:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=RI5Jd0reULzH/XZm3oQspXKu9mvMmvypuiqt8hJonY4=;
        b=nxgHwUPlg/yjW1zL0lg4RClk5IM0kOyxpQSzegtF1NJUs4YVSjYxZQlqQYTm9x57UE
         OPYxTm5pHwVGt+38YIpPXDAsTt2Nef8Tifb8/a793P3Q6auzSVbspEZwcA6tov1jiAhN
         fN2mP9oMeLUp1pHswdfCkd82Pn/qlnJtw1FflhLSg1/1QRuylW0W1X3G4l3SVb5PrATD
         feac3XMiIPI7WlUlQxBhN++sI7B8gt4JIJLfSZoRtPnw0m68eXjGzKrm2Q1Ggj8ikiO3
         kBm4hxc2ww06tqCg9o6L5DX2gX8LkrPSEbFpFDk3JQowHuO9cJpCs01Z4ZmD+hRplpZp
         xXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=RI5Jd0reULzH/XZm3oQspXKu9mvMmvypuiqt8hJonY4=;
        b=0tRAuLDNL1QHhhgcJAQ2pUMw2aA1MzfiksrnTWBgMfEPRSrZlCzrJtuLeESrBC2Jun
         IobkQhrPvL1zMboY3ghuy9UrKTKqoj81Ro83fmyE5Ha0zl5hrcvgmiu8s21BxLPYpsOp
         VcIRKL5zy9xU4pfqdRn0XfuiBqW0ptr7KTugWzjQFX+XTy5XIIbb/WGE/GoxRZtJ6HBX
         abpwIqqbR1ApNpAXy3j8Moh156XzEifhJhq2CT5QdJjwHg6tCkV2lseEtHo/vfIu7uhq
         uO0k/OfUPIMCqQ0aJgB+Wpbha03igD0gQfvIgu9JxX/5Jw9+7Bfx1M6aCDGZ8KlzoxRa
         Xhmg==
X-Gm-Message-State: ACgBeo3r3xRSIZTYHLAYaKS6P0EZIR2LQ310Y68dGHN6HzkzaUGATBNh
        8NAxvrQHPnCcgccGvKeRXMjqJ6AB0blw3pHncgw=
X-Google-Smtp-Source: AA6agR4buKfxjtkpr1Ihx4S3ZcEi2f5hEXdSBd9PfStZ/Ydlpru7bA5LQbdH7tZQOctsbKvj2u2Sh3yarcSV3FnNiMU=
X-Received: by 2002:a17:906:dc93:b0:742:133b:42c3 with SMTP id
 cs19-20020a170906dc9300b00742133b42c3mr6682721ejc.502.1661960385106; Wed, 31
 Aug 2022 08:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk> <20220831152624.GA15107@breakpoint.cc>
In-Reply-To: <20220831152624.GA15107@breakpoint.cc>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 31 Aug 2022 08:39:33 -0700
Message-ID: <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 8:31 AM Florian Westphal <fw@strlen.de> wrote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
> > > Same with a 'nft list ruleset > /etc/nft.txt', reboot,
> > > 'nft -f /etc/nft.txt' fails because user forgot to load/pin the progr=
am
> > > first.
> >
> > Right, so under what conditions is the identifier expected to survive,
> > exactly? It's okay if it fails after a reboot, but it should keep
> > working while the system is up?
>
> Right, thats the question.  I think it boils down to 'least surprise',
> which to me would mean useable labels are:
>
> 1. pinned name
> 2. elf filename
> 3. filter name
>
> 3) has the advantage that afaiu I can extend nft to use the dumped
> id + program tag to query the name from the kernel, whereas 1+2 would
> need to store the label.
>
> 1 and 2 have the upside that its easy to handle a 'file not found'
> error.

I'm strongly against calling into bpf from the inner guts of nft.
Nack to all options discussed in this thread.
None of them make any sense.
