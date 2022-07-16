Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97CA576B08
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiGPAIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiGPAIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:08:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2178713D50
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:08:47 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z23so11541576eju.8
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yF0qYkuNUhOMnwb9sHzODwkBW5iHpEMQMtEm7GeRBIA=;
        b=BS6oH5L2ejQrjFIcp4AzXd6YcaSkbptMyBqZLLMeKwDpYPko8vPRFEtEht99LRRGGT
         K6iWrq2PRnSy6EK3Q6IswNuhFhDDeTW9LEYpyAmJ3eWeP20JyqGdYfmmFBmqy7vzoGsy
         Ze25JNbCPxNTNh1V3Hg36j33yANMIkxQblFLcYR4Y0+89yuK8cBYflOFjIbpcAsfLShD
         C4Qn+01ennW2EjDyRAxA7i4761Zq0ImawDtDmXMpnWR5jq0YsGAk9oRjf97EM/XXda/4
         u/3p/ziM3tmYOFOC0fvL5WOrzjNa4MiRpYucWBIrWUP8OjOnOK4IHPAsJenq75fg+Yy3
         GhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yF0qYkuNUhOMnwb9sHzODwkBW5iHpEMQMtEm7GeRBIA=;
        b=jNWQ/2+viZrYpGReKz/152tqa5zWu5agj0DjI7OULIquOMvVgGRW/AP7nYmQgYIAca
         u4zKh3trcTC030T7e9p8W6LFJoff6qmlnnBV0uiDz7h5tmEwBIA4TORB8qTsNDndWvDH
         N4qrUiNLtCvpR6gIxltuGe/RbFWZR8UE7kaewnN/f4D6dh1whAwGt2PY2RwI14KbEBXe
         wdfll8QO4MyGvUhFLIGwu+O7/fraJ2HlZ2JF5wHtaC/uFW7o/z1BRtEx8gydz9wbZ2S5
         0ilWhqElzpwV0mtl4KMTms/g+jWmFSpHLbWCXRLNL/LHDdZgH3zjRRkWoXeTw/9rejYl
         SEzw==
X-Gm-Message-State: AJIora+YQ8KiKe9OJ8tynT/MIqdBuQzup508QaVMghTucPuCjrbRBVMy
        M/dTeQ3PoRkUJHgp8xqKupjXA2FuQakSflIzXL2nGg==
X-Google-Smtp-Source: AGRyM1spC6JwR89kxZwG4nhVeU6bfHjOmE3IEYDMJtJEYU9x3nVNTSOepK3dhEdseTGM80Ow8f/gWmafk1TI1WvUpZ0=
X-Received: by 2002:a17:906:5a67:b0:72b:610d:4aa4 with SMTP id
 my39-20020a1709065a6700b0072b610d4aa4mr16444194ejc.294.1657930125539; Fri, 15
 Jul 2022 17:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220711212932.1501592-1-justinstitt@google.com> <84e873c27f2426ce003e650004fe856bf72c634b.camel@perches.com>
In-Reply-To: <84e873c27f2426ce003e650004fe856bf72c634b.camel@perches.com>
From:   Justin Stitt <justinstitt@google.com>
Date:   Fri, 15 Jul 2022 17:08:34 -0700
Message-ID: <CAFhGd8pJyRYq-3VrKM+6+k0AysfYbVJEJm3FMFt9eAysAKDUpQ@mail.gmail.com>
Subject: Re: [PATCH] mediatek: mt7601u: fix clang -Wformat warning
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 11:33 PM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2022-07-11 at 14:29 -0700, Justin Stitt wrote:
> > When building with Clang we encounter this warning:
> > > drivers/net/wireless/mediatek/mt7601u/debugfs.c:92:6: error: format
> > > specifies type 'unsigned char' but the argument has type 'int'
> > > [-Werror,-Wformat] dev->ee->reg.start + dev->ee->reg.num - 1);
> >
> > The format specifier used is `%hhu` which describes a u8. Both
> > `dev->ee->reg.start` and `.num` are u8 as well. However, the expression
> > as a whole is promoted to an int as you cannot get smaller-than-int from
> > addition. Therefore, to fix the warning, use the promoted-to-type's
> > format specifier -- in this case `%d`.
>
> I think whenever a sizeof(unsigned type) that is less than sizeof(int) is
> emitted with vsprintf, the preferred format specifier should be %u not %d.

I believe the standard recommends using the promoted-to-type's format
specifier, in this case integer. I agree, though, that it is quite
bizarre to represent unsigned types with signed types. I'd be
interested in hearing more opinions on the matter.

> > diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> []
> > @@ -88,7 +88,7 @@ mt7601u_eeprom_param_show(struct seq_file *file, void *data)
> >                  dev->ee->rssi_offset[0], dev->ee->rssi_offset[1]);
> >       seq_printf(file, "Reference temp: %hhx\n", dev->ee->ref_temp);
> >       seq_printf(file, "LNA gain: %hhx\n", dev->ee->lna_gain);
> > -     seq_printf(file, "Reg channels: %hhu-%hhu\n", dev->ee->reg.start,
> > +     seq_printf(file, "Reg channels: %hhu-%d\n", dev->ee->reg.start,
> >                  dev->ee->reg.start + dev->ee->reg.num - 1);
>
> And this is not a promotion of an argument to int via varargs.
> The arithmetic did the promotion.

Right, I noted in my patch message that the type promotion was due to addition.

>
> I suggest s/%hh/%/ for all the uses here, not just this one.

I also contemplated this change but I think it might be a bit out of
scope for https://github.com/ClangBuiltLinux/linux/issues/378  -- What
do you think?
It could be argued that every single instance of %hh[dux] should be
replaced with %[dux].

> checkpatch could do this somewhat automatically.
> Of course any changes it suggests need human review.
>
> $ ./scripts/checkpatch.pl -f drivers/net/wireless/mediatek/mt7601u/debugfs.c --show-types --types=unnecessary_modifier --fix-inplace
> $ git diff --stat -p drivers/net/wireless/mediatek/mt7601u/debugfs.c
> ---
>  drivers/net/wireless/mediatek/mt7601u/debugfs.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> index 20669eacb66ea..b7a6376e3352e 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> @@ -83,28 +83,28 @@ mt7601u_eeprom_param_show(struct seq_file *file, void *data)
>         struct tssi_data *td = &dev->ee->tssi_data;
>         int i;
>
> -       seq_printf(file, "RF freq offset: %hhx\n", dev->ee->rf_freq_off);
> -       seq_printf(file, "RSSI offset: %hhx %hhx\n",
> +       seq_printf(file, "RF freq offset: %x\n", dev->ee->rf_freq_off);
> +       seq_printf(file, "RSSI offset: %x %x\n",
>                    dev->ee->rssi_offset[0], dev->ee->rssi_offset[1]);
> -       seq_printf(file, "Reference temp: %hhx\n", dev->ee->ref_temp);
> -       seq_printf(file, "LNA gain: %hhx\n", dev->ee->lna_gain);
> -       seq_printf(file, "Reg channels: %hhu-%hhu\n", dev->ee->reg.start,
> +       seq_printf(file, "Reference temp: %x\n", dev->ee->ref_temp);
> +       seq_printf(file, "LNA gain: %x\n", dev->ee->lna_gain);
> +       seq_printf(file, "Reg channels: %u-%u\n", dev->ee->reg.start,
>                    dev->ee->reg.start + dev->ee->reg.num - 1);
>
>         seq_puts(file, "Per rate power:\n");
>         for (i = 0; i < 2; i++)
> -               seq_printf(file, "\t raw:%02hhx bw20:%02hhx bw40:%02hhx\n",
> +               seq_printf(file, "\t raw:%02x bw20:%02x bw40:%02x\n",
>                            rp->cck[i].raw, rp->cck[i].bw20, rp->cck[i].bw40);
>         for (i = 0; i < 4; i++)
> -               seq_printf(file, "\t raw:%02hhx bw20:%02hhx bw40:%02hhx\n",
> +               seq_printf(file, "\t raw:%02x bw20:%02x bw40:%02x\n",
>                            rp->ofdm[i].raw, rp->ofdm[i].bw20, rp->ofdm[i].bw40);
>         for (i = 0; i < 4; i++)
> -               seq_printf(file, "\t raw:%02hhx bw20:%02hhx bw40:%02hhx\n",
> +               seq_printf(file, "\t raw:%02x bw20:%02x bw40:%02x\n",
>                            rp->ht[i].raw, rp->ht[i].bw20, rp->ht[i].bw40);
>
>         seq_puts(file, "Per channel power:\n");
>         for (i = 0; i < 7; i++)
> -               seq_printf(file, "\t tx_power  ch%u:%02hhx ch%u:%02hhx\n",
> +               seq_printf(file, "\t tx_power  ch%u:%02x ch%u:%02x\n",
>                            i * 2 + 1, dev->ee->chan_pwr[i * 2],
>                            i * 2 + 2, dev->ee->chan_pwr[i * 2 + 1]);
>
> @@ -112,8 +112,8 @@ mt7601u_eeprom_param_show(struct seq_file *file, void *data)
>                 return 0;
>
>         seq_puts(file, "TSSI:\n");
> -       seq_printf(file, "\t slope:%02hhx\n", td->slope);
> -       seq_printf(file, "\t offset=%02hhx %02hhx %02hhx\n",
> +       seq_printf(file, "\t slope:%02x\n", td->slope);
> +       seq_printf(file, "\t offset=%02x %02x %02x\n",
>                    td->offset[0], td->offset[1], td->offset[2]);
>         seq_printf(file, "\t delta_off:%08x\n", td->tx0_delta_offset);
>
>
