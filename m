Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF1D511957
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbiD0Nt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbiD0Ntz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:49:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D4D3FD24F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 06:46:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so3121316pjb.3
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 06:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0AbKJoO2wiDmt7769SER7UcnTbySJrbCSG5C3/zXwG4=;
        b=BDvd4ScJgrB4UZZAQaSqmp6tSepGsGxiUVdlS+Ft+ODuEZkAuMT36oTp7MH/fqXVSh
         bg3EAEynqwaHsnZE2MemYgC4MLax7RUoxxAh3cWNesSLN2R2f8mBxBu5rCjmTtiAEQfA
         FYrHD+rXiLQTpipTlfAqSEPYYg+rxkVb+S/vdAQ3FH6gsmg6xwS8SMdyqezIFv7Zpmok
         WHZOg5h1+6zSgeqDwnZ0VRaVidFvP7d/UBKNluTiHHSaYwDpZQCxs1+VwHjhB19Dse8Y
         ppgw4YWYcGwtHBzJ+nlMe6lvhQDBiEWxSPhnDzQpzo8Q1iK3n/xyW9qAnmk4uaXGvaCb
         CdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0AbKJoO2wiDmt7769SER7UcnTbySJrbCSG5C3/zXwG4=;
        b=XqGwmAMgKCa4ZgS48l0ZeLJ+JMJgqJ2vKvx88b/OAbDFBYEQouSxdmI8DhSK30ES60
         Wp6wyFxJRRKIkcOtt+8vMm4qxk4qzuOt7LjgzUkBWvoxsMsoeLOiAUKJWzVOND05wUj+
         a9kVtI8n1+UYPnHA1Jzna2zcKMD6fM0sDNv81BOoNX5ESc4XEP17Ew1CdqtR3KX+rgkr
         1T0AVVySzIuxcFuh85XyUG8MvU+QFI0d8a90fOHNxr6kVCTfsq5ivS3lT0DsAB23EbnK
         vC2a7LlzXL3TaLGtaL56lEK4w9cfN2Sb94WvB+7T9NIKKq1vzmR573gfenZKZB+pN6F1
         +LOw==
X-Gm-Message-State: AOAM533JHtEZiACcmNZNK88mD4ETr/xRJMcIBDH+Q4GSMRVy85E9Dpf4
        GMh6qR9Y3K3t6vRiIgl3J+PIQ4/oR2Vs70fbi5o=
X-Google-Smtp-Source: ABdhPJyEi/bqIzPXkhvkOp5VqWjYFXcyWOc8pB3ALnsBctqJWUjHoev/D2wKGfk/Ks5E83Z0+0Zhxz5vbcktvJhNIGA=
X-Received: by 2002:a17:902:a581:b0:154:8c7d:736a with SMTP id
 az1-20020a170902a58100b001548c7d736amr28834395plb.74.1651067203259; Wed, 27
 Apr 2022 06:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220421084646.15458-1-huangguangbin2@huawei.com> <20220421084646.15458-3-huangguangbin2@huawei.com>
In-Reply-To: <20220421084646.15458-3-huangguangbin2@huawei.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 27 Apr 2022 19:16:31 +0530
Message-ID: <CALHRZupJSiwAVzsvRvQiwBDSOaykLLJYKWbHQZjweHd0mrUvtA@mail.gmail.com>
Subject: Re: [PATCH ethtool-next v2 2/2] ethtool: add support to get/set tx
 push by ethtool -G/g
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     mkubecek@suse.cz, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lipeng321@huawei.com, Subbaraya Sundeep <sbhatta@marvell.com>
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

Hi Guangbin,

On Thu, Apr 21, 2022 at 3:47 PM Guangbin Huang
<huangguangbin2@huawei.com> wrote:
>
> From: Jie Wang <wangjie125@huawei.com>
>
> Currently tx push is a standard feature for NICs such as Mellanox, HNS3.
> But there is no command to set or get this feature.
>
> So this patch adds support for "ethtool -G <dev> tx-push on|off" and
> "ethtool -g <dev>" to set/get tx push mode.
>
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> ---
>  ethtool.8.in    | 4 ++++
>  ethtool.c       | 1 +
>  netlink/rings.c | 7 +++++++
>  3 files changed, 12 insertions(+)
>
> diff --git a/ethtool.8.in b/ethtool.8.in
> index 12940e1..a87f31f 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -199,6 +199,7 @@ ethtool \- query or control network driver and hardware settings
>  .BN rx\-jumbo
>  .BN tx
>  .BN rx\-buf\-len
> +.BN tx\-push
>  .HP
>  .B ethtool \-i|\-\-driver
>  .I devname
> @@ -573,6 +574,9 @@ Changes the number of ring entries for the Tx ring.
>  .TP
>  .BI rx\-buf\-len \ N
>  Changes the size of a buffer in the Rx ring.
> +.TP
> +.BI tx\-push \ on|off
> +Specifies whether TX push should be enabled.
>  .RE
>  .TP
>  .B \-i \-\-driver
> diff --git a/ethtool.c b/ethtool.c
> index 4f5c234..4d2a475 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5733,6 +5733,7 @@ static const struct option args[] = {
>                           "             [ rx-jumbo N ]\n"
>                           "             [ tx N ]\n"
>                           "             [ rx-buf-len N]\n"
> +                         "             [ tx-push on|off]\n"
>         },
>         {
>                 .opts   = "-k|--show-features|--show-offload",
> diff --git a/netlink/rings.c b/netlink/rings.c
> index 119178e..a53eed5 100644
> --- a/netlink/rings.c
> +++ b/netlink/rings.c
> @@ -47,6 +47,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>         show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO], "RX Jumbo:\t");
>         show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
>         show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");
> +       show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
>
>         return MNL_CB_OK;
>  }
> @@ -105,6 +106,12 @@ static const struct param_parser sring_params[] = {
>                 .handler        = nl_parse_direct_u32,
>                 .min_argc       = 1,
>         },
> +       {
> +               .arg            = "tx-push",
> +               .type           = ETHTOOL_A_RINGS_TX_PUSH,
> +               .handler        = nl_parse_u8bool,
> +               .min_argc       = 0,

Why min_argc is 0 ? Thanks for syncing kernel headers. I have patch for adding
cqe-size command and will send after these are merged.

Sundeep
> +       },
>         {}
>  };
>
> --
> 2.33.0
>
