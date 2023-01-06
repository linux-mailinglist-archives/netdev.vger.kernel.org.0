Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C340166020E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbjAFOZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjAFOZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:25:28 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C857BDCA;
        Fri,  6 Jan 2023 06:25:27 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id z7so1131153pfq.13;
        Fri, 06 Jan 2023 06:25:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZnhpvIy2ZsoQIvjxqkh6LV97wMF7pwAzJclzOI/EkUA=;
        b=gJpZEqK8J9iUXg6/NaMcM7g+hrm6Idxwqlmg2b1oNBbzs6/lK/Loxi/Aw5Qxq0QDSL
         Wzp5ZdvcMC4ujm8MnXlIKhlnF8ZUjqHI9TH5AiZQCCNsNoap4tu6GunKKk2qjR9HqW4u
         J8ghWWq4JwmMmYkbOBsS0ok57pIMsqzoE1eL+gu9TQ/GvYMfgTCZ3WS8K0VTnen/BsOz
         IOFqTOn25Q3HJoK9P6IJtl2knqLE86CIWndu/O6NDO83G/uhQPltF5L8o531fSzkeM2g
         9oT9VV09XCANxxPLCJrBuhnGbPQxclXN1S079dOK5hzQ5PI8+k39fAOhRvDnuH1PoWTf
         dWsw==
X-Gm-Message-State: AFqh2koRrzxuFn0EPfhR9C0HyGBKOJMf9T2VMmVWRQZn8W0lbSysSCzL
        x34QhEVBo7gsiSewxncoEuIKxMqnO4m9/mggJlY=
X-Google-Smtp-Source: AMrXdXupE8sC+Y3fGN3ty9aij7GdI5lL4SimVP4vcqOWquE7YENA7c1nv0MwPYafQUD94503z2yComXmE17v1S9TlPc=
X-Received: by 2002:a63:2106:0:b0:483:f80c:cdf3 with SMTP id
 h6-20020a632106000000b00483f80ccdf3mr2608100pgh.70.1673015126142; Fri, 06 Jan
 2023 06:25:26 -0800 (PST)
MIME-Version: 1.0
References: <20230106042844.give.885-kees@kernel.org> <CAG48ez0Jg9Eeh=RWpYh=sKhzukE3Sza2RKMmNs8o0FrHU0dj9w@mail.gmail.com>
In-Reply-To: <CAG48ez0Jg9Eeh=RWpYh=sKhzukE3Sza2RKMmNs8o0FrHU0dj9w@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 6 Jan 2023 23:25:14 +0900
Message-ID: <CAMZ6RqJXnUBxqyCFRaLxELjnvGzn9NoiePV2RVwBzAZRGH_Qmg@mail.gmail.com>
Subject: Re: [PATCH v3] ethtool: Replace 0-length array with flexible array
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kernel test robot <lkp@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 6 Jan 2023 at 22:19, Jann Horn <jannh@google.com> wrote:
> On Fri, Jan 6, 2023 at 5:28 AM Kees Cook <keescook@chromium.org> wrote:
> > Zero-length arrays are deprecated[1]. Replace struct ethtool_rxnfc's
> > "rule_locs" 0-length array with a flexible array. Detected with GCC 13,
> > using -fstrict-flex-arrays=3:
> >
> > net/ethtool/common.c: In function 'ethtool_get_max_rxnfc_channel':
> > net/ethtool/common.c:558:55: warning: array subscript i is outside array bounds of '__u32[0]' {aka 'unsigned int[]'} [-Warray-bounds=]
> >   558 |                         .fs.location = info->rule_locs[i],
> >       |                                        ~~~~~~~~~~~~~~~^~~
> > In file included from include/linux/ethtool.h:19,
> >                  from include/uapi/linux/ethtool_netlink.h:12,
> >                  from include/linux/ethtool_netlink.h:6,
> >                  from net/ethtool/common.c:3:
> > include/uapi/linux/ethtool.h:1186:41: note: while referencing
> > 'rule_locs'
> >  1186 |         __u32                           rule_locs[0];
> >       |                                         ^~~~~~~~~
> >
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: kernel test robot <lkp@intel.com>
> > Cc: Oleksij Rempel <linux@rempel-privat.de>
> > Cc: Sean Anderson <sean.anderson@seco.com>
> > Cc: Alexandru Tachici <alexandru.tachici@analog.com>
> > Cc: Amit Cohen <amcohen@nvidia.com>
> > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > v3: don't use helper (vincent)
> > v2: https://lore.kernel.org/lkml/20230105233420.gonna.036-kees@kernel.org
> > ---
> >  include/uapi/linux/ethtool.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > index 58e587ba0450..3135fa0ba9a4 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -1183,7 +1183,7 @@ struct ethtool_rxnfc {
> >                 __u32                   rule_cnt;
> >                 __u32                   rss_context;
> >         };
> > -       __u32                           rule_locs[0];
> > +       __u32                           rule_locs[];
>
> Stupid question: Is this syntax allowed in UAPI headers despite not
> being part of standard C90 or C++? Are we relying on all C/C++
> compilers for pre-C99 having gcc/clang extensions?

The [0] isn't part of the C90 standard either. So having to choose
between [0] and [], the latter is the most portable nowadays.

If I do a bit of speleology, I can see that C99 flexible array members
were used as early as v2.6.19 (released in November 2006):

  https://elixir.bootlin.com/linux/v2.6.19/source/include/linux/usb/audio.h#L36

This is prior to the include/linux and include/uapi/linux split, but
believe me, this usb/audio.h file is indeed part of the uapi.
So, yes, using C99 flexible array members in the UAPI is de facto
allowed because it was used for the last 16 years.

An interesting sub question would be:

  What are the minimum compiler requirements to build a program using
the Linux UAPI?

And, after research, I could not find the answer. The requirements to
build the kernel are well documented:

  https://docs.kernel.org/process/changes.html#changes

But no clue for the uapi. I guess that at one point in 2006, people
decided that it was time to set the minimum requirement to C99. Maybe
this matches the end of life of the latest pre-C99 GCC version? The
detailed answer must be hidden somewhere on lkml.


Yours sincerely,
Vincent Mailhol
