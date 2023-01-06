Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2165FB6A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjAFGZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjAFGZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:25:34 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB9F654D
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:25:33 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gq18so447822pjb.2
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 22:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YayHG7lExe8amFBKiiDo3qeuO6fzGOFyXNJRlTndIyE=;
        b=Y29z1GWtlyZLdfJyfGvzO3zxWqYuBWudOWfkzJiIV7d/AhpRS27ZH6IAN+aoHBCvaz
         B6ah7v1oIewCmGcQ0IZjDKZk8Hwrn7x17NB+36FoWZOCeHVbzd/PqDl85MrFEi3WL1eu
         EiylNkCc5tCsaYipJ5iRd0nx59HJqmV02fhHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YayHG7lExe8amFBKiiDo3qeuO6fzGOFyXNJRlTndIyE=;
        b=X10BdWPuNcBJtNSTKh80YcmIfzNmiepS/IVRI+akkZqMl0ZDR7o/+epNS6ueVC8kg4
         47HzY03zCRgGSebUO/XHEFTpMyJJ597sIH6qsGwL9whrhDToX85kpgtqJuVKUv9V1M/v
         uuuBRVMMrSL0eie+3L7tfGu3aZ9rocqeomAEZFVfy4SSNbAFZriO8csShStvxTTT8gch
         3Ss5rOuL/KQo6GM/hDSbDADounJFFuroeaCk+O0H5ShF0ZtW8B4DB9KRRHYXlBRxNIXE
         3K0EAGB/fkVh71vi8eef0Bzxru++DwRkoMAhdvcPzmGk45HHxUN/gg9Lw/o9guhbcwo9
         tC/Q==
X-Gm-Message-State: AFqh2kodYmbd7t2hWqDbUFzNBitqFLiefIMyJfIyndj+lYPAb/mA5jMQ
        hyy3lTT5cy9Zd4LU+cnobulR8A==
X-Google-Smtp-Source: AMrXdXsJR0Jp0gvO8YvY12mJU7b2mREhu4mq2+p7jeRBSbkqkTeWPoVzJ58HtbpMMkv6mkmDI2j1LQ==
X-Received: by 2002:a05:6a20:939a:b0:af:9539:a29e with SMTP id x26-20020a056a20939a00b000af9539a29emr65774366pzh.16.1672986332761;
        Thu, 05 Jan 2023 22:25:32 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h3-20020aa796c3000000b005609d3d3008sm309232pfq.171.2023.01.05.22.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 22:25:32 -0800 (PST)
Date:   Thu, 5 Jan 2023 22:25:31 -0800
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
Subject: Re: [PATCH v3] ethtool: Replace 0-length array with flexible array
Message-ID: <202301052224.D2569E38@keescook>
References: <20230106042844.give.885-kees@kernel.org>
 <CAMZ6RqKghb-YqQuWGiEn8D-CQgvecBxsxUz_2XYE0m3hs752gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKghb-YqQuWGiEn8D-CQgvecBxsxUz_2XYE0m3hs752gQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 02:47:35PM +0900, Vincent MAILHOL wrote:
> On Fri. 6 Jan 2023 at 13:28, Kees Cook <keescook@chromium.org> wrote:
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
> 
> v1: https://lore.kernel.org/all/20230105214126.never.757-kees@kernel.org
>                                                ^^^^^
> > v2: https://lore.kernel.org/lkml/20230105233420.gonna.036-kees@kernel.org
>                                                   ^^^^^
> v3: https://lore.kernel.org/netdev/20230106042844.give.885-kees@kernel.org
>                                                   ^^^^
> 
> Seriously... :)

Hurray! Someone noticed and it's not even April yet. :) *celebrate*

-Kees

-- 
Kees Cook
