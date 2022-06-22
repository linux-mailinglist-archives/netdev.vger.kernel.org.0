Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6CD5550A0
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358806AbiFVQBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359804AbiFVQBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:01:15 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B923FDBD;
        Wed, 22 Jun 2022 09:00:20 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s1so24045511wra.9;
        Wed, 22 Jun 2022 09:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IMqEg+MXjVlXo4CUDeioy1RvlNBop/mVtJHjGP191vc=;
        b=EYXa3VrKQrJ2gjRV7Tb0GlPZbHMPcRIkrXPTtMadh9E5IQ389ITh25QlfD6AZsfwKE
         7gvE7StorBQqEtpf6wvnWdoBJLnmxoiIyxIJoAzWQQdwRon27MiYAGV1Lb8ykh33A0k7
         UeRV/M0mnr3CrTCZyo43t/ncNR4nvo3tIHM3ku3FG9xgEXinG2/ZG+PzYBOUy6ZsaQW5
         fZUNYr+lO2Nvj+dyrshuUfPqJBG/IxBYT6X009DqgkzjNAlhnxpswox5m4T9tfzF9rl5
         sKXkqKiaqxxZVXE/T774xr+ClJbNEg6lnp7SswM4h34r65WIcXxD3N5A6ofbs3lg7yw/
         803g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IMqEg+MXjVlXo4CUDeioy1RvlNBop/mVtJHjGP191vc=;
        b=HvPFPS7PkMIa3pR4Tjie5qVe+07iUXGO0r0btIxs6qN1Sva4PJ7DEiFB7tCjxs11Y4
         kj/qm+inkR3M+AaWHyWUEI8s+oZ0X2VvLGK2MtiF0Hff5s1hFq0mYhudQsgi5PAXplWP
         Wgbg2nIL+8vGEFRE6j+K7L4jyGvRBDauKYiyf0dIn71x0WS46Dw750M/isw+X/G4C2pK
         ctLNJzWu/qbjzCNFdfbFBFIIg8XLUC5Z3x5fYfNtXNiAsgED4GY7wMdVlVjm3YhcGuZj
         ld3JRjfh59ut6NhhqOxFKitgTYMXMRKwm3ugVuMY1coLpTIERFZssoX3yJ22+IJStG2X
         egnQ==
X-Gm-Message-State: AJIora/li9E5d/PqegxAyeqoiKKCJsf3/IUtN0oU90vqv36iFm5FkEMA
        8fDSBrJGbid55XV8oXghgoo=
X-Google-Smtp-Source: AGRyM1uBWSVYi5Tm56MtKv5+IEt76OKNP2hYeV7pSyiX5vg9PphDfxT92oC8xNmcMqEREYJEAUbrpA==
X-Received: by 2002:adf:ead2:0:b0:21a:7603:7371 with SMTP id o18-20020adfead2000000b0021a76037371mr3910418wrn.560.1655913618996;
        Wed, 22 Jun 2022 09:00:18 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05600c3d8b00b0039c362311d2sm1892981wmb.9.2022.06.22.09.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 09:00:18 -0700 (PDT)
Date:   Wed, 22 Jun 2022 17:00:16 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang
 support")
Message-ID: <YrM8kC5zXzZgL/ca@debian>
References: <YrLtpixBqWDmZT/V@debian>
 <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
 <YrMwXAs9apFRdkVo@debian>
 <CAHk-=wjmREcirYi4k_CBT+2U8X5VOAjQn0tVD28OdcKJKpA0zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjmREcirYi4k_CBT+2U8X5VOAjQn0tVD28OdcKJKpA0zg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 10:19:31AM -0500, Linus Torvalds wrote:
> On Wed, Jun 22, 2022 at 10:08 AM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Yeah, true. I had to check to find out its from the memcpy() in check_image_valid().
> 
> Funky but true - I can reproduce it, and just commenting out that
> memcpy fixes the warning.
> 
> And I see nothing wrong with that code - it's copying a 'struct
> fw_section_info_st' between two other structs that seem to have arrays
> that are appropriately sized.

imho, there is no check for 'i' and it can become more than MAX_FW_TYPE_NUM and
in that case it will overwrite.

This fixes the error for me and I think will also address the concern that
clang is raising.

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index 60ae8bfc5f69..bc4b3ec15925 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -41,7 +41,7 @@ static bool check_image_valid(struct hinic_devlink_priv *priv, const u8 *buf,
                return false;
        }

-       for (i = 0; i < fw_image->fw_info.fw_section_cnt; i++) {
+       for (i = 0; i < fw_image->fw_info.fw_section_cnt && i < MAX_FW_TYPE_NUM; i++) {
                len += fw_image->fw_section_info[i].fw_section_len;
                memcpy(&host_image->image_section_info[i],
                       &fw_image->fw_section_info[i],


--
Regards
Sudip
