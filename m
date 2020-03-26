Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04C193869
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgCZGOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:14:50 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:62855 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgCZGOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:14:50 -0400
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 02Q6ERNC010464;
        Thu, 26 Mar 2020 15:14:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 02Q6ERNC010464
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585203268;
        bh=9JvGFXDbXf0WHwUuU/6/XuO+PW6RcH+NvJKjNlcv4ZM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=De9gZQ+3D+HbdIRAHlgDjfw4T2JvNYMxXm9IlpEJy1cYv/ooP/3e8iMk2RZdOc2x4
         mLD92alU8mMLzIEt/ceThq8ZNHs6RiiEaszrxCC0LcLDXGGVc+0Wcd5VO+es2m5EXl
         Ci71pbZZQzNnfaOHVNB2RkH8dighd+JP4B48cHPkTaq5iPnYTFuZjtAQWfPj56/bC3
         xN6/rnG9V2/ZBgoyJUJA7zXkWMI8alq+0W94adSNYqQLmln/ZTnMGDK8dpFBdsFqaw
         USQF4J4/ArsRS/f29dOdyzBGHm+B5qynMmscRX6HBi3iqHLtW9q26/HvbQagwftIlX
         neFkPfwtjpvRw==
X-Nifty-SrcIP: [209.85.221.181]
Received: by mail-vk1-f181.google.com with SMTP id p123so1400484vkg.1;
        Wed, 25 Mar 2020 23:14:27 -0700 (PDT)
X-Gm-Message-State: ANhLgQ285ry1bZZ69SW2N9QpArMN5/EL0PGSwfCVbX0GmSjJGrT8HMRB
        B6fGqXGNyh1cZv6vnco4qvEJ+ELM8Wfl9CoF9bQ=
X-Google-Smtp-Source: ADFU+vtR1PkThEG5fof0BkpvSUODBLIJyFZ5IQflhtz2NMxdF8WuPUa/n0iZ8kRCvUgyaSGgVqW4CH7K0FGWSteFi80=
X-Received: by 2002:a1f:3649:: with SMTP id d70mr3829330vka.12.1585203266653;
 Wed, 25 Mar 2020 23:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200324161539.7538-1-masahiroy@kernel.org> <20200324161539.7538-3-masahiroy@kernel.org>
 <CAKwvOdkjiyyt8Ju2j2O4cm1sB34rb_FTgjCRzEiXM6KL4muO_w@mail.gmail.com> <CAKwvOdmWqAUhL5DRg9oQPXzFtogK-0Q-VZ=FWf=Cjm-RJgR4sw@mail.gmail.com>
In-Reply-To: <CAKwvOdmWqAUhL5DRg9oQPXzFtogK-0Q-VZ=FWf=Cjm-RJgR4sw@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 26 Mar 2020 15:13:50 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS+3gq-uL6HF=o2NbZ2udkr+dqAhsvs-XxFs0M9wShJbw@mail.gmail.com>
Message-ID: <CAK7LNAS+3gq-uL6HF=o2NbZ2udkr+dqAhsvs-XxFs0M9wShJbw@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: remove AS variable
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nick,


On Wed, Mar 25, 2020 at 4:59 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Tue, Mar 24, 2020 at 12:38 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> > consistent in this regard (and not using the compiler as the driver),
>
> Ah, the preprocessor; we need to preprocess the .S files, .s files are
> fine (though we have .lds.S files that are not `-x
> assembler-with-cpp`)


Right, there is no '*.s' source file in the kernel tree.

If we want to de-couple $(AS), we must the compilation
before the assemble stage   ( $(CC) -S ), but
doing so does not buy us.

So, $(CC) always works as the front-end
for compiling both .c and .S files.


You can see the internal database by
'make --print-data-base'.

I see the following for  *.S -> *.o rule.

# default
COMPILE.S = $(CC) $(ASFLAGS) $(CPPFLAGS) $(TARGET_MACH) -c


So, using $(CC) is the right thing.


Even if we keep AS, we cannot do like AS=llvm-as
since llvm-as is a different kind of tool
that processes LLVM assembly (.ll) .


-- 
Best Regards
Masahiro Yamada
