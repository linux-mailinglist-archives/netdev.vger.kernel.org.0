Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5B434797
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJTJHv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Oct 2021 05:07:51 -0400
Received: from mail-ua1-f43.google.com ([209.85.222.43]:36863 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhJTJHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:07:50 -0400
Received: by mail-ua1-f43.google.com with SMTP id e10so5271428uab.3;
        Wed, 20 Oct 2021 02:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bCLgItGTD/ncNi56tmQD8uBfcIL7GrQePrlemPpXCP4=;
        b=aEWFeFC0bE6j/AYa3WZ8bYBIJ8vPCQZ8auNDuceDDF1tifTU+zxBjzjWbwUoeEasbe
         TOnwv8c+9PAf7WXYpPMrcdDbJnu/LDQ5eX8J+vSNxzSTCc+OMG+hirbjaqv6WIHNufQ5
         kfY04CmJteybdSB9WEutq68DOW74ZrAVzyzBmC2ycDRFY5E6Ks8L+Dgc7wpo7VaIwJRG
         ozeJEeDJASjHiaQ+BhuOs0/BIDk88JVIKB8AhKafhr7fs3WYj7YqWgI4Zvvug9yBErt3
         CBcmapBfaZUvLc/WY0ucaDO+K9NktFJOUScRut0urrKErutknF21zDCma6WxQeK4020c
         4l/Q==
X-Gm-Message-State: AOAM532tnT6/ysDVdyjGt5/duW74tMue+hfwqGzRCZFdLsCnv+2D/HeX
        z3d5IsiYW/qNUvyYw59cqU7q/oiBMUbjVA==
X-Google-Smtp-Source: ABdhPJyxXSGAsgBflTc3gLjU5RmcWwye8aDxHGrBu74tVkVOe153uYi2jowk0/fLVlpVvuZL4EiL2w==
X-Received: by 2002:a9f:2438:: with SMTP id 53mr5419331uaq.116.1634720735541;
        Wed, 20 Oct 2021 02:05:35 -0700 (PDT)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id l64sm952068vki.40.2021.10.20.02.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 02:05:34 -0700 (PDT)
Received: by mail-ua1-f48.google.com with SMTP id a17so5170874uax.12;
        Wed, 20 Oct 2021 02:05:34 -0700 (PDT)
X-Received: by 2002:ab0:2bd2:: with SMTP id s18mr5627914uar.78.1634720734621;
 Wed, 20 Oct 2021 02:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
 <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
 <20211019173520.0154a8cb@kmaincent-XPS-13-7390> <YW7nPfzjstmeoMbf@lunn.ch>
 <20211019175746.11b388ce@windsurf> <CAMuHMdXiMhpU0vDV3KaOg4DY59cszAtoG1sDOgnTRY6C6cyitQ@mail.gmail.com>
 <20211020105328.411a712f@kmaincent-XPS-13-7390>
In-Reply-To: <20211020105328.411a712f@kmaincent-XPS-13-7390>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 20 Oct 2021 11:05:22 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW5SF+MXmUO+ydS7XzHxXiF3=6Zj+q_Gu=hOUyQ5Q9Gfg@mail.gmail.com>
Message-ID: <CAMuHMdW5SF+MXmUO+ydS7XzHxXiF3=6Zj+q_Gu=hOUyQ5Q9Gfg@mail.gmail.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
To:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Köry,

On Wed, Oct 20, 2021 at 10:53 AM Köry Maincent
<kory.maincent@bootlin.com> wrote:
> On Tue, 19 Oct 2021 22:05:41 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > The current driver is backwards-compatible with the legacy/wrong DTB.
> > The current DT bindings (as of v5.10-rc1), using "[rt]x-internal-delay-ps"
> > are correct.
> > Or am I missing something here?
>
> You are correct.

Thanks for confirming!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
