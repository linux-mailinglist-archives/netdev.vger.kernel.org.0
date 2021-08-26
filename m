Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F49F3F8078
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 04:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237821AbhHZCaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 22:30:06 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:49430 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236341AbhHZCaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 22:30:05 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 17Q2T2HF007418;
        Thu, 26 Aug 2021 11:29:03 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 17Q2T2HF007418
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1629944943;
        bh=nhsNDBtebvHsUPUvr/G9QvWMQeecme+7wcswpepJRZg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rQ+lyNmFM5eaAxgStAoXTmP6Y6h+8ewkmnRP9nC51jxmPAjaOq4ogzUkJpDBZTaNF
         HA7l/zpAHFMOvsY6L+ZSE6/YfJ9onLbz3yzUVmWw932gRGp0BwaXVgxz0CLz7PJSdd
         KKVC/0AjOP8JfH9Yxr+ilaBql0RBQZoIw9yrazYn/W3j/tEM8AlZycUZxrJx0csJik
         2f9D346PSR342NLYkB0D/xR5Wm9Wd9JtpuDTZ1aaRagFSZfsRn/iHsO7KEkgGE22pD
         +mIFrBEPxM8kQnBB/ZqCRjx388o3KyvknvnacVQn94rRkFTajYfVfI1we/K2KK4wpH
         GSclM8U3uyUHQ==
X-Nifty-SrcIP: [209.85.210.179]
Received: by mail-pf1-f179.google.com with SMTP id j187so1393498pfg.4;
        Wed, 25 Aug 2021 19:29:03 -0700 (PDT)
X-Gm-Message-State: AOAM530/i0tv0FLJrFLNgxur/YPyXBgCb6PIlSVlY+MXV1O5roRhYVvn
        BIFLKC0IasqutLDjaVp38BooiyjnQ+2P2YP/xjM=
X-Google-Smtp-Source: ABdhPJwwlP7PCNjslmyo5yR609R7WW/wRzQQGe7mqFLUz3FdVmlyPiGja/E6H9UbwHCjku2hsLeSB2jltn/jv1aaFCY=
X-Received: by 2002:aa7:98da:0:b029:3e0:8b98:df83 with SMTP id
 e26-20020aa798da0000b02903e08b98df83mr1335775pfm.63.1629944942299; Wed, 25
 Aug 2021 19:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210825041637.365171-1-masahiroy@kernel.org> <9df591f6-53fc-4567-8758-0eb1be4eade5@gmail.com>
In-Reply-To: <9df591f6-53fc-4567-8758-0eb1be4eade5@gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 26 Aug 2021 11:28:24 +0900
X-Gmail-Original-Message-ID: <CAK7LNATDMzR1DnwwAcQFHaKZeGVYDZ1oDKL-QOe_7DaB_yByAA@mail.gmail.com>
Message-ID: <CAK7LNATDMzR1DnwwAcQFHaKZeGVYDZ1oDKL-QOe_7DaB_yByAA@mail.gmail.com>
Subject: Re: [PATCH] kconfig: forbid symbols that end with '_MODULE'
To:     =?UTF-8?Q?P=C3=A9ter_Ujfalusi?= <peter.ujfalusi@gmail.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 8:59 PM P=C3=A9ter Ujfalusi <peter.ujfalusi@gmail.c=
om> wrote:
>
> Hi,
>
> On 25/08/2021 07:16, Masahiro Yamada wrote:
> > Kconfig (syncconfig) generates include/generated/autoconf.h to make
> > CONFIG options available to the pre-processor.
> >
> > The macros are suffixed with '_MODULE' for symbols with the value 'm'.
> >
> > Here is a conflict; CONFIG_FOO=3Dm results in '#define CONFIG_FOO_MODUL=
E 1',
> > but CONFIG_FOO_MODULE=3Dy also results in the same define.
> >
> > fixdep always assumes CONFIG_FOO_MODULE comes from CONFIG_FOO=3Dm, so t=
he
> > dependency is not properly tracked for symbols that end with '_MODULE'.
> >
> > This commit makes Kconfig error out if it finds a symbol suffixed with
> > '_MODULE'. This restriction does not exist if the module feature is not
> > supported (at least from the Kconfig perspective).
> >
> > It detected one error:
> >   error: SND_SOC_DM365_VOICE_CODEC_MODULE: symbol name must not end wit=
h '_MODULE'
> >
> > Rename it to SND_SOC_DM365_VOICE_CODEC_MODULAR. Commit 147162f57515
> > ("ASoC: ti: fix SND_SOC_DM365_VOICE_CODEC dependencies") added it for
> > internal use. So, this renaming has no impact on users.
> >
> > Remove a comment from drivers/net/wireless/intel/iwlwifi/Kconfig since
> > this is a hard error now.
> >
> > Add a comment to include/linux/kconfig.h in order not to worry observan=
t
> > developers.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > ---
> >
> >  drivers/net/wireless/intel/iwlwifi/Kconfig |  1 -
> >  include/linux/kconfig.h                    |  3 ++
> >  scripts/kconfig/parser.y                   | 40 +++++++++++++++++++++-
> >  sound/soc/ti/Kconfig                       |  2 +-
> >  4 files changed, 43 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/w=
ireless/intel/iwlwifi/Kconfig
> > index 1085afbefba8..5b238243617c 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> > +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> > @@ -70,7 +70,6 @@ config IWLMVM
> >         of the devices that use this firmware is available here:
> >         https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmw=
are
> >
> > -# don't call it _MODULE -- will confuse Kconfig/fixdep/...
> >  config IWLWIFI_OPMODE_MODULAR
> >       bool
> >       default y if IWLDVM=3Dm
> > diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
> > index 20d1079e92b4..54f677e742fe 100644
> > --- a/include/linux/kconfig.h
> > +++ b/include/linux/kconfig.h
> > @@ -53,6 +53,9 @@
> >   * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
> >   * otherwise.  CONFIG_FOO=3Dm results in "#define CONFIG_FOO_MODULE 1"=
 in
> >   * autoconf.h.
> > + * CONFIG_FOO_MODULE=3Dy would also result in "#define CONFIG_FOO_MODU=
LE 1",
> > + * but Kconfig forbids symbol names that end with '_MODULE', so that w=
ould
> > + * not happen.
> >   */
> >  #define IS_MODULE(option) __is_defined(option##_MODULE)
> >
> > diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
> > index 2af7ce4e1531..b0f73f74ccd3 100644
> > --- a/scripts/kconfig/parser.y
> > +++ b/scripts/kconfig/parser.y
> > @@ -475,6 +475,37 @@ assign_val:
> >
> >  %%
> >
> > +/*
> > + * Symbols suffixed with '_MODULE' would cause a macro conflict in aut=
oconf.h,
> > + * and also confuse the interaction between syncconfig and fixdep.
> > + * Error out if a symbol with the '_MODULE' suffix is found.
> > + */
> > +static int sym_check_name(struct symbol *sym)
> > +{
> > +     static const char *suffix =3D "_MODULE";
> > +     static const size_t suffix_len =3D strlen("_MODULE");
> > +     char *name;
> > +     size_t len;
> > +
> > +     name =3D sym->name;
> > +
> > +     if (!name)
> > +             return 0;
> > +
> > +     len =3D strlen(name);
> > +
> > +     if (len < suffix_len)
> > +             return 0;
> > +
> > +     if (strcmp(name + len - suffix_len, suffix))
> > +             return 0;
> > +
> > +     fprintf(stderr, "error: %s: symbol name must not end with '%s'\n"=
,
> > +             name, suffix);
> > +
> > +     return -1;
> > +}
> > +
> >  void conf_parse(const char *name)
> >  {
> >       struct symbol *sym;
> > @@ -493,8 +524,15 @@ void conf_parse(const char *name)
> >
> >       if (yynerrs)
> >               exit(1);
> > -     if (!modules_sym)
> > +
> > +     if (modules_sym) {
> > +             for_all_symbols(i, sym) {
> > +                     if (sym_check_name(sym))
> > +                             yynerrs++;
> > +             }
> > +     } else {
> >               modules_sym =3D sym_find( "n" );
> > +     }
> >
> >       if (!menu_has_prompt(&rootmenu)) {
> >               current_entry =3D &rootmenu;
> > diff --git a/sound/soc/ti/Kconfig b/sound/soc/ti/Kconfig
> > index 698d7bc84dcf..c56a5789056f 100644
> > --- a/sound/soc/ti/Kconfig
> > +++ b/sound/soc/ti/Kconfig
> > @@ -211,7 +211,7 @@ config SND_SOC_DM365_VOICE_CODEC
> >         Say Y if you want to add support for SoC On-chip voice codec
> >  endchoice
> >
> > -config SND_SOC_DM365_VOICE_CODEC_MODULE
> > +config SND_SOC_DM365_VOICE_CODEC_MODULAR
>
> This Kconfig option is only used to select the codecs needed for the
> voice mode, I think it would be better to use something like
>
> SND_SOC_DM365_SELECT_VOICE_CODECS ?


I do not have a strong opinion.
I am fine with any name unless it ends with _MODULE.


The sound subsystem maintainers and Arnd,
author of 147162f575152db800 are CC'ed.

If they suggest a better name, I'd be happy to adopt it.



--=20
Best Regards
Masahiro Yamada
