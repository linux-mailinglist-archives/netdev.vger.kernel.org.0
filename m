Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028B165F85E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 01:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbjAFAzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 19:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjAFAzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 19:55:43 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B1A6B1B4;
        Thu,  5 Jan 2023 16:55:42 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id e10so217815pgc.9;
        Thu, 05 Jan 2023 16:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hSKndwKHKCX2Dk6a0qymAPMnu8BVPSR8eEIr2DcHqro=;
        b=6kauEsbMOggJ2IDJaxGCJTpPFf+hU3Snlk/xQmi87Y7N0RgKCi9IoHq2LW5K8FYPHZ
         dd+oz7Zrn8c20uFrh2kQfiWyI2d7JOR/Y/c71im0+UvJOicObOyReE0xw8sBp48LCD6e
         QCI6rjBF4VMW6QwUszRGzc7tYcOTledvbwlYKhTpRf/SgLekAG5vaKqjDLw7Q1uh8IWd
         DQdnua58bzVU16wvTLrp5wAYAg0+A8NZuf5af7k971cu7REml4+CwxJLN5Z+pGOhyICS
         NJsi7fYS7cti3nZD/O7+LJIrRtnANiN74oqx4T68gQ8MvNZ/7HcyUVGBEGdWUckTg/Gy
         FLiA==
X-Gm-Message-State: AFqh2kqAyiIVQ6qkQnqXFSxVPbgPYIwWmdkQLsgExSggOrvwrqM7IKh9
        CBNbIFOGLNbTTAkTtIm1yi3ACCovZOKqRtaPQXQ=
X-Google-Smtp-Source: AMrXdXurFs3p3EVKN1WkB6tznGT+7ANFx2hhdMESlo1tNjJZ7rKkBcf48TJJ8m3yRBaDtJW4/DI3q+WYmRwIFTTlwGw=
X-Received: by 2002:a63:5301:0:b0:4a4:6964:557 with SMTP id
 h1-20020a635301000000b004a469640557mr738446pgb.535.1672966541782; Thu, 05 Jan
 2023 16:55:41 -0800 (PST)
MIME-Version: 1.0
References: <20230105233420.gonna.036-kees@kernel.org>
In-Reply-To: <20230105233420.gonna.036-kees@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 6 Jan 2023 09:55:30 +0900
Message-ID: <CAMZ6RqK96DNAPO5A32i3EaDErU0C2RDtL4-JN2O8A5RBBUo3ew@mail.gmail.com>
Subject: Re: [PATCH v2] ethtool: Replace 0-length array with flexible array
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

On Fri. 6 Jan 2023 at 08:34, Kees Cook <keescook@chromium.org> wrote:
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
>
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
> ---
> v2: resend, this time without missing netdev CC. :)
> ---
>  include/uapi/linux/ethtool.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 58e587ba0450..9b97b3e0ec1f 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1183,7 +1183,7 @@ struct ethtool_rxnfc {
>                 __u32                   rule_cnt;
>                 __u32                   rss_context;
>         };
> -       __u32                           rule_locs[0];
> +       __DECLARE_FLEX_ARRAY(__u32,     rule_locs);

Can't this simply be a C99 flexible array member?

        __u32                           rule_locs[];

As far as I understand, __DECLARE_FLEX_ARRAY() is a hack to allow the
declaration of a flexible array within unions (which otherwise do not
accept flexible array members). However, ethtool_rxnfc being a struct,
I do not see the need for __DECLARE_FLEX_ARRAY() here.

Yours sincerely,
Vincent Mailhol
