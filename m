Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9DD65FAF0
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjAFFif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjAFFie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:38:34 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9D34D714;
        Thu,  5 Jan 2023 21:38:30 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id c4so679752plc.5;
        Thu, 05 Jan 2023 21:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aUTX3hQ31eJpmnwwb1UwPf65sW8fJfvo/kP6nw0krfk=;
        b=Au8MT65ShOqUOwsDx16LrkDeCk5efrIoen7LvirJXU6fMqO1Zvq2n5nwsrwWlTFNVm
         wfvy/bl/b7bvsJ0iIe64y9Df4aTEsG4iGopokx/Sd3CNUmam23iM+Tz+UrqbdxikcrFx
         T94HD3Uf/gYqIaZWgXMsgEjHIFLRQSDiF+v6DNnMjZymFb7TQDwytF4u69/oZgg4R0V0
         oqaB9vfmqDhRogRLC+rdGT2oyYWB/Ua4v8o6RJbrjD/XGjEIe9+MvOxPTst4gTS05D/C
         6PMeIp0UkoWpeRu0ifIHq13QKEhrCLPMCRG7Fig6dh4LwPwrNHDhDvCQeLD0VOLkJAnZ
         mM0g==
X-Gm-Message-State: AFqh2kpGTzKePPEgj5bRqTZdJl1gzClX/n8wv40lGlBMdOBvgSMv1C3k
        HtRYbs8r5q7jUM6V/ZfAH3pqkMOi63ULv+PYGC9o5bx4nBxNkA==
X-Google-Smtp-Source: AMrXdXvNcd1XCRKiDs4wrb/kT3sZVAPRhrj+XsEx75wOAoiyXJLo18ALcvUzv4IcoSSBZ0xxms6K2S0SDMBD9Aqcf5E=
X-Received: by 2002:a17:90b:2483:b0:226:412e:2ddf with SMTP id
 nt3-20020a17090b248300b00226412e2ddfmr1633082pjb.19.1672983509489; Thu, 05
 Jan 2023 21:38:29 -0800 (PST)
MIME-Version: 1.0
References: <20230106042844.give.885-kees@kernel.org>
In-Reply-To: <20230106042844.give.885-kees@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 6 Jan 2023 14:38:18 +0900
Message-ID: <CAMZ6RqKyvGwh7iOVvtONGYA21==Lj6p9JECstCBFSWRRCPAVZQ@mail.gmail.com>
Subject: Re: [PATCH v3] ethtool: Replace 0-length array with flexible array
To:     Kees Cook <keescook@chromium.org>
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

On Fri. 6 Jan 2023 at 13:28, Kees Cook <keescook@chromium.org> wrote:
> Zero-length arrays are deprecated[1]. Replace struct ethtool_rxnfc's
> "rule_locs" 0-length array with a flexible array. Detected with GCC 13,
> using -fstrict-flex-arrays=3:
>
> net/ethtool/common.c: In function 'ethtool_get_max_rxnfc_channel':
> net/ethtool/common.c:558:55: warning: array subscript i is outside array bounds of '__u32[0]' {aka 'unsigned int[]'} [-Warray-bounds=]
>   558 |                         .fs.location = info->rule_locs[i],
>       |                                        ~~~~~~~~~~~~~~~^~~
> In file included from include/linux/ethtool.h:19,
>                  from include/uapi/linux/ethtool_netlink.h:12,
>                  from include/linux/ethtool_netlink.h:6,
>                  from net/ethtool/common.c:3:
> include/uapi/linux/ethtool.h:1186:41: note: while referencing
> 'rule_locs'
>  1186 |         __u32                           rule_locs[0];
>       |                                         ^~~~~~~~~
>
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Side comment, this link does not mention the __DECLARE_FLEX_ARRAY().
It could be good to add a reference to the helper here. But of course,
this is not a criticism of this patch.

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: kernel test robot <lkp@intel.com>
> Cc: Oleksij Rempel <linux@rempel-privat.de>
> Cc: Sean Anderson <sean.anderson@seco.com>
> Cc: Alexandru Tachici <alexandru.tachici@analog.com>
> Cc: Amit Cohen <amcohen@nvidia.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> ---
> v3: don't use helper (vincent)

You may want to double check your other patches as well. At least this
one is also using the helper when not needed:

  https://lore.kernel.org/netdev/20230105223642.never.980-kees@kernel.org/T/#u

> v2: https://lore.kernel.org/lkml/20230105233420.gonna.036-kees@kernel.org
> ---
>  include/uapi/linux/ethtool.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 58e587ba0450..3135fa0ba9a4 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1183,7 +1183,7 @@ struct ethtool_rxnfc {
>                 __u32                   rule_cnt;
>                 __u32                   rss_context;
>         };
> -       __u32                           rule_locs[0];
> +       __u32                           rule_locs[];
>  };
>
>
> --
> 2.34.1
>
