Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515C265FAB4
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 05:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjAFEWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 23:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjAFEWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 23:22:20 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC71222
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 20:22:19 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b2so532761pld.7
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 20:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CGWD+jfRiKeIQRhUlYhv18AOK19GA0uVfO6DJ6wW9xo=;
        b=Qx/Sc6eBGD1WS+NYhJg3ZkIWz+KNeDpe7i6MTHZyT8u+OIs3wWnMY1FXUutDo1Hrr0
         eEEIgS0CugsgWmq2tsY1L5OXMgikwU4dvu3B9xWf9FW17vulbRljYIEu1aHtcfzyCBJ7
         f/RAc7UJhNuY8syPOjs9JGQ3d2ynAdgWY89Jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGWD+jfRiKeIQRhUlYhv18AOK19GA0uVfO6DJ6wW9xo=;
        b=2JjJSTuR3VXtBPgAy4aILvdYYAyZAjK9e2YuKftBPeFzD47rVywSKsrt4syAMlxXcr
         i05YGFujoMav074zo4KsuJBdsvj5IRqmpJzcwuo5GAb9GzPUY3nxwDsewkKe21QdjLSa
         PRlPUyhjXjSOE60XzvHQQOZf1WG4MdZxq5Vzt7sA7PMRryU2Ey5Yk4DAX50Agt7hBHQu
         HdrxnG7EF8Z6jCWYZkPSqWGDSUQlbIayKcnY6pLq5XBS3xKLDYrS1fjaqQ59R/l8uxxT
         Zy842GxoCdNVcwD/JKuaYZRQBcaNQReEvF5IuYGt5LuzyfP7f0+yP67/hSWItsY3KOAu
         zZOQ==
X-Gm-Message-State: AFqh2kr125m9bMdZywm9Fk2T/x6TPDEPESrqVM3dIJVBSoCgHRAKh2kJ
        dQt8WR+XS0QF8uBWgEDjfzkmUg==
X-Google-Smtp-Source: AMrXdXuaPp8teht4jYnNx8xph4n3y4KgWAziqnyhVLFUe0joH+LWYntfx/GZhFy1gnunTYAAGzDgXA==
X-Received: by 2002:a17:902:ebca:b0:191:117a:414f with SMTP id p10-20020a170902ebca00b00191117a414fmr64827715plg.27.1672978938888;
        Thu, 05 Jan 2023 20:22:18 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o13-20020a63e34d000000b004a3510effa5sm78223pgj.65.2023.01.05.20.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 20:22:18 -0800 (PST)
Date:   Thu, 5 Jan 2023 20:22:17 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kernel test robot <lkp@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] ethtool: Replace 0-length array with flexible array
Message-ID: <202301052021.5AEF89CB@keescook>
References: <20230105233420.gonna.036-kees@kernel.org>
 <CAMZ6RqK96DNAPO5A32i3EaDErU0C2RDtL4-JN2O8A5RBBUo3ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK96DNAPO5A32i3EaDErU0C2RDtL4-JN2O8A5RBBUo3ew@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 09:55:30AM +0900, Vincent MAILHOL wrote:
> On Fri. 6 Jan 2023 at 08:34, Kees Cook <keescook@chromium.org> wrote:
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
> > v2: resend, this time without missing netdev CC. :)
> > ---
> >  include/uapi/linux/ethtool.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > index 58e587ba0450..9b97b3e0ec1f 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -1183,7 +1183,7 @@ struct ethtool_rxnfc {
> >                 __u32                   rule_cnt;
> >                 __u32                   rss_context;
> >         };
> > -       __u32                           rule_locs[0];
> > +       __DECLARE_FLEX_ARRAY(__u32,     rule_locs);
> 
> Can't this simply be a C99 flexible array member?
> 
>         __u32                           rule_locs[];
> 
> As far as I understand, __DECLARE_FLEX_ARRAY() is a hack to allow the
> declaration of a flexible array within unions (which otherwise do not
> accept flexible array members). However, ethtool_rxnfc being a struct,
> I do not see the need for __DECLARE_FLEX_ARRAY() here.

Good point -- I think my eyes scanned through the "union" above and I
just jumped at using __DECLARE_FLEX_ARRAY. I'll send a v2. Thanks!

-- 
Kees Cook
