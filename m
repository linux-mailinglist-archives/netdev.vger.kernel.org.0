Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CF465FAFC
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjAFFru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAFFrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:47:49 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD9948CD4;
        Thu,  5 Jan 2023 21:47:46 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso4223678pjp.4;
        Thu, 05 Jan 2023 21:47:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3YubsmjlT8gvaUNIbLlS2Rx5IGQKnpyKadMDjv71G7c=;
        b=LLZwZOxnXI8avDE5Jt5cMfQKBijAwnEfmOvuGAezu362nWzKMSDE6mQZg7lYISvZGL
         XqQprTfizgiPktFO192lrlMiTVwAwCG9ifwUr87xO0/hZRPaBv85kDOfRbK5OeR760JD
         Ju5MAZ9RVMGVlhC7vy8tpLoUbJliTh0CPpezrF6T7aRipBR2Dp1ArK5BDqloL2ugzoWn
         YEiehB45nLVb6beRTny2BGz71J6pcwXoGofHySWUqpewTk5g0KRZ5q8+Z5nnmzrfMpuA
         oUAIxJOA6OWkbbh7Phdptjt0vJZ3kjOxIVyf57+vfB+hoB8f9bS/6k3D207fe+bnrzHG
         /TTw==
X-Gm-Message-State: AFqh2krlbnvXcdWKIZoyVfkNWu4rFaTM2yosDpSDBLpdL5SCBeQJWn8Y
        aD64WFsAJDfoaH8FBGsnLBQPwxyqcUT26+QP9fk=
X-Google-Smtp-Source: AMrXdXuDUVBnGhwZoxjcV0kodG3U5wRj+DXUQMWLdzEIhmGty+QTS7CeirNo2kTS3VxHb9HveTW1MqzR8K9BNMEtcGk=
X-Received: by 2002:a17:902:ef87:b0:192:5cb3:b01a with SMTP id
 iz7-20020a170902ef8700b001925cb3b01amr2832255plb.95.1672984066101; Thu, 05
 Jan 2023 21:47:46 -0800 (PST)
MIME-Version: 1.0
References: <20230106042844.give.885-kees@kernel.org>
In-Reply-To: <20230106042844.give.885-kees@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 6 Jan 2023 14:47:35 +0900
Message-ID: <CAMZ6RqKghb-YqQuWGiEn8D-CQgvecBxsxUz_2XYE0m3hs752gQ@mail.gmail.com>
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
> v3: don't use helper (vincent)

v1: https://lore.kernel.org/all/20230105214126.never.757-kees@kernel.org
                                               ^^^^^
> v2: https://lore.kernel.org/lkml/20230105233420.gonna.036-kees@kernel.org
                                                  ^^^^^
v3: https://lore.kernel.org/netdev/20230106042844.give.885-kees@kernel.org
                                                  ^^^^

Seriously... :)

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
