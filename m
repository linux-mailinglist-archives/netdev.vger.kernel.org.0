Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447BD2D3332
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbgLHUQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731059AbgLHUNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:13:01 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66531C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 12:12:15 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id v67so4810806ybi.1
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 12:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQYt/4VgCiEwd3op5jlCPhHU8pQtIJ/B1ftm9vhFDbM=;
        b=elBXLPE9EtSolehwqod4JujVxpIlOQ+VeIEW8OSE9jod4LBKN1G7JgblBCuMqt7Z9I
         J+5q4Ho+3/TnxKhBIQY8EwD0ZAN0G5fghei/Lr9fI40OVHw+jPBMqhdNUcRyokZrO3y0
         WgzXG3aRwasbIiezVdjhx/D6QCe1aFXa90IBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQYt/4VgCiEwd3op5jlCPhHU8pQtIJ/B1ftm9vhFDbM=;
        b=Yddf8kuz7eQc5gD8VIPHkxIe2duf8qZpoQxfLNY6ySJzA3h6qHwVOM7jIYILZ+jwMI
         L62fXtTPVF9mVHIOcmYzuY8ddSV3rbdvIpWDRBDDe/GHXBP44sBVovScC0D8lgcs+4Y5
         oixS6uA9yjKsCGDedBYfI4376w7rLMPgJa1Vnl6UHfg0/fNx4rKLJl5+oTXrBO8qnfd7
         2EWgb6G+n/QhjvCLi3AHC7euvUBE6jcRKZeFA58mqF0J7JS/zUkk1e/hDEA6cZt6Uidx
         oTOsc9xAuYoL2A4NDpZI2oMr6+xiyMQ7m/hjdeMoBRqF8R6BoL1u6Zeu/ZrEhK6iHlrF
         ig2A==
X-Gm-Message-State: AOAM531M5Io7VwVkJvs+WtPXbhGzHsRAa7dN+4+AsBO+69Hgn4SJPMpP
        PEsi9YtMTGxcFIFI3oLN7Yg9cGoIOlqe5Q==
X-Google-Smtp-Source: ABdhPJz5D7XOWgwaAwK52fTXqfmRDS7A1/kt4Ng7A7H2Os4UDqQ/Y44ZyEba16jo9vtWd8+H0+f0HQ==
X-Received: by 2002:a05:6830:22d3:: with SMTP id q19mr10840741otc.115.1607453803702;
        Tue, 08 Dec 2020 10:56:43 -0800 (PST)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com. [209.85.167.173])
        by smtp.gmail.com with ESMTPSA id u130sm3845992oib.53.2020.12.08.10.56.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 10:56:42 -0800 (PST)
Received: by mail-oi1-f173.google.com with SMTP id k2so20494223oic.13
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 10:56:42 -0800 (PST)
X-Received: by 2002:aca:c443:: with SMTP id u64mr3807625oif.117.1607453801518;
 Tue, 08 Dec 2020 10:56:41 -0800 (PST)
MIME-Version: 1.0
References: <20201208154343.6946-1-ruc_zhangxiaohui@163.com>
In-Reply-To: <20201208154343.6946-1-ruc_zhangxiaohui@163.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 8 Dec 2020 10:56:29 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPiY5AQDu2snHSqBDA0BYi79_hmNAjsKmXm1cFrgoxo4Q@mail.gmail.com>
Message-ID: <CA+ASDXPiY5AQDu2snHSqBDA0BYi79_hmNAjsKmXm1cFrgoxo4Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_uap_bss_param_prepare
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(FWIW, this author's mail has been routed to my spam mailbox. That's
partly my fault and/or my "choice" of mail provider, but that's why I
only see these once Kalle replies to them.)

On Tue, Dec 8, 2020 at 8:03 AM Xiaohui Zhang <ruc_zhangxiaohui@163.com> wrote:
>
> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>
> mwifiex_uap_bss_param_prepare() calls memcpy() without checking
> the destination size may trigger a buffer overflower,
> which a local user could use to cause denial of service or the
> execution of arbitrary code.
> Fix it by putting the length check before calling memcpy().
>
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> index b48a85d79..937c75e89 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> @@ -502,7 +502,8 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
>                 ssid = (struct host_cmd_tlv_ssid *)tlv;
>                 ssid->header.type = cpu_to_le16(TLV_TYPE_UAP_SSID);
>                 ssid->header.len = cpu_to_le16((u16)bss_cfg->ssid.ssid_len);
> -               memcpy(ssid->ssid, bss_cfg->ssid.ssid, bss_cfg->ssid.ssid_len);
> +               memcpy(ssid->ssid, bss_cfg->ssid.ssid,
> +                      min_t(u32, bss_cfg->ssid.ssid_len, strlen(ssid->ssid)));

This strlen() check makes no sense to me. We are *writing* to
ssid->ssid, so its initial contents are either zero or garbage --
strlen() will either give a zero or unpredictable value. I'm pretty
sure that's not what you intend.

On the other hand, it's hard to determine what the proper bound here
*should* be. This 'ssid' struct is really just a pointer into
mwifiex_cmd_uap_sys_config()'s uap_sys_config (struct
host_cmd_ds_sys_config), which doesn't have any defined length -- its
length is only given by way of its surrounding buffers/structs.
Altogether, the code is hard to reason about.

Anyway, this patch is wrong, so NAK.

Brian

>                 cmd_size += sizeof(struct mwifiex_ie_types_header) +
>                             bss_cfg->ssid.ssid_len;
>                 tlv += sizeof(struct mwifiex_ie_types_header) +
> --
> 2.17.1
>
