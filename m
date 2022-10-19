Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93F7604D07
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiJSQTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiJSQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:19:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7EB1D331
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:19:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ot12so41266409ejb.1
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oMpul0HS3FSF+fhAdRCiYLkKUFe1L4nLM8pv7QwNRZw=;
        b=bLuhZcodzW8fNTUn/qisGy5RJxSO2z8KLhAphbEhCCJJ5tiUPzjLHhmTQ2T6XXJFEI
         9fijYHhdM3Z600EBsTqb5gLqLU7Lvh2EESvRWornyrUOxl3MuJBaEqf6HUGfKuEMpg0w
         q2DksSdhGe/DlGe5DbuJOLzAHj5c1sWboJYK+9oMzBxHLwZjsbAis1nBE9Zytb8olPf6
         gE64K1lnvEHrHMa8FsUAezfWZrvUdS6g/DeIVcVp/yrvXCPr5BAye103uIYOfI9kOSAC
         0hQNibp76Nh3Em51592LrXnYw8XelT2soNmR8IYyXjbH3mBewZY6Se/qzO1DGZ8um5bC
         M/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oMpul0HS3FSF+fhAdRCiYLkKUFe1L4nLM8pv7QwNRZw=;
        b=j2DDZc28CCTTOsO1MvkZSNpZu0I4OruZcxKhxSfjpjnpNY1i+OQubwL8+enMZ7ZhWY
         8sZ2rV8l0eQiTPWL4a+cQFUQg3bsXK6wINlUYWlifTV1S7M1VKDfg6WeLDOYNr3LT8ka
         PgW+iyzGcJEA/Y0llSOv61sOHYpf8ep0cRE/oNYFl15Yh32yblkAPTRb2DVjpzhKwqjB
         kw3QMKSMBWIbLqpIyhqFshlNWGIeJmpStoBw7wdwI+c/4drjqiOziDlcOdnmgTYzq0/T
         RH86WR6DmNjIiPuPvpuOUjIBy/EbXXxyFBy9m8HCKe4kE4kRm4sSFBBg9lZvDBcN4YnM
         OSiA==
X-Gm-Message-State: ACrzQf2ROL8A6PvBPkZLowq7eNDlA0YxVIddG/buQCnpDquzlclA/gbo
        pZeA7qtAbkac5s41taQ1ZxyE3o9hcCVjw4u1NJ0=
X-Google-Smtp-Source: AMsMyM5h9/CaDGODL0svcaauU8P2eogi7OwSfvoIMFGT3SnyVSZ1t0hFjRaBwgtCGO5vdzN7fbJ0cEBYnBbHxsJHCOU=
X-Received: by 2002:a17:906:ef8c:b0:78d:96b9:a0ad with SMTP id
 ze12-20020a170906ef8c00b0078d96b9a0admr7570237ejb.529.1666196362497; Wed, 19
 Oct 2022 09:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221013155724.2911050-1-saproj@gmail.com> <20221017155536.hfetulaedgmvjoc5@skbuf>
In-Reply-To: <20221017155536.hfetulaedgmvjoc5@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 19 Oct 2022 19:19:11 +0300
Message-ID: <CABikg9zmmSysguNTXmM7cG8KqKBoEKshLKUCb5o_kpNqFm2KRA@mail.gmail.com>
Subject: Re: [PATCH v3 net] net: ftmac100: support frames with DSA tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 at 18:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> 6. Actually implement the ndo_change_mtu() for this driver, and even though you
>    don't make any hardware change based on the precise value, you could do one
>    important thing. Depending on whether the dev->mtu is <= 1500 or not, you could
>    set or unset the FTL bit, and this could allow for less CPU cycles spent
>    dropping S/G frames when the MTU of the interface is standard 1500.

Can I do the mtu>1500 check and set FTL in ndo_open() (which is called
after ndo_change_mtu())? I am submitting a v4 of the patch, and your
feedback to it would be helpful. I got rid of all mentions of DSA
tagging there, so patch description and a code comment are new. Thanks
for clearing things up regarding EtherType 0800.

> With these changes, you would leave the ftmac100 driver in a more civilized
> state, you wouldn't need to implement S/G RX unless you wanted to, and
> as a side effect, it would also operate well as a DSA master.

What does S/G stand for?
