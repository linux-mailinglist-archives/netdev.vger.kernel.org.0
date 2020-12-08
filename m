Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3592A2D33B7
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgLHUYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLHUYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:24:03 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5B3C0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 12:23:22 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id l207so17902446oib.4
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 12:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lne4PvkhK9agYEgzjS9te6vCuHKM3HSi40k8tH/cnbg=;
        b=O8u/LFMGaD05T4BW7FSwj5ut69kES9sL7RktfTp/Kctwu7Qu3IDWfHWwoCzdQUwKkB
         iPBi/ikRSki7CqX2rs6D3nhpsb6/0YwPfYMrUBvAul6Mo1rBT88gheiHANmH+pABQXiY
         eD+26TUCkFqW3zQpFUD++8m0ykl0h8VMaV5yI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lne4PvkhK9agYEgzjS9te6vCuHKM3HSi40k8tH/cnbg=;
        b=WJLOkPo9HWvZCqBlz73HbAi+f1hrXI9DFlJCmRKgwcwH3avBw3HYmuOSo1uqFIR9JX
         V6/26IedAdcS3s+Wi4KeK6qfWX0n+gj+rZ6RbUfcDJywJqOt1ac/RuAWwEPkHIevo2ZK
         6m5HU4RqhF17nQeGKNgFMI7iH5JAz0zy94LjCIZm4+UvtqnVbfJjQNSbBuBJEpFiEZvb
         Zl0kUu5HmDv5d0cvaNOokimaiX0DkwNep5seVAIMiqwJ1LnpErcJZvI7t6iKRDMR+o5z
         5qxGUIsc8juuV3268bVlOZWbMEqIoJEVFAa+MsmYMYKINsI9OcN3PN55kBh5APxLlZ9g
         LUJw==
X-Gm-Message-State: AOAM533OVg7rG7mdEGHSkozvMJZwzpAHhszhyoez5Y5LqOTMDQupX/Pt
        2n6iJxxrIeqUccATfk7MJCX0v+lLeBJIHQ==
X-Google-Smtp-Source: ABdhPJx8OVukJG+7VHVgcazGZ0+wrgziDuaey6e0+IS0AiccldhE5+cp9NnclJHPS/cpTeQQ/9MADQ==
X-Received: by 2002:aca:d706:: with SMTP id o6mr3975347oig.28.1607454734209;
        Tue, 08 Dec 2020 11:12:14 -0800 (PST)
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com. [209.85.210.43])
        by smtp.gmail.com with ESMTPSA id x12sm592330oic.51.2020.12.08.11.12.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:12:12 -0800 (PST)
Received: by mail-ot1-f43.google.com with SMTP id d8so8917461otq.6
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 11:12:12 -0800 (PST)
X-Received: by 2002:a9d:7394:: with SMTP id j20mr12995977otk.229.1607454732130;
 Tue, 08 Dec 2020 11:12:12 -0800 (PST)
MIME-Version: 1.0
References: <20201208150951.35866-1-ruc_zhangxiaohui@163.com>
In-Reply-To: <20201208150951.35866-1-ruc_zhangxiaohui@163.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 8 Dec 2020 11:12:00 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPVu5S0Vm0aOcyqLN090u3BwA_nV358YwkpXuU223Ug9g@mail.gmail.com>
Message-ID: <CA+ASDXPVu5S0Vm0aOcyqLN090u3BwA_nV358YwkpXuU223Ug9g@mail.gmail.com>
Subject: Re: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_config_scan
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

On Tue, Dec 8, 2020 at 7:14 AM Xiaohui Zhang <ruc_zhangxiaohui@163.com> wrote:
>
> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>
> mwifiex_config_scan() calls memcpy() without checking
> the destination size may trigger a buffer overflower,
> which a local user could use to cause denial of service
> or the execution of arbitrary code.
> Fix it by putting the length check before calling memcpy().

^^ That's not really what you're doing any more, for the record. But
then, describing "what" is not really the point of a commit message
(that's what the code is for), so maybe that's not that important.

> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index c2a685f63..34293fd80 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -931,7 +931,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>                                 wildcard_ssid_tlv->max_ssid_length = 0xfe;
>
>                         memcpy(wildcard_ssid_tlv->ssid,
> -                              user_scan_in->ssid_list[i].ssid, ssid_len);
> +                              user_scan_in->ssid_list[i].ssid, min_t(u32, ssid_len, 1));

This *looks* like it should be wrong, because SSIDs are clearly longer
than 1 byte in many cases, but you *are* right that this is what the
struct is defined as:

struct mwifiex_ie_types_wildcard_ssid_params {
...
    u8 ssid[1];
};

This feels like something that could use some confirmation from
NXP/ex-Marvell folks if possible, but if not that, at least some
creative testing. Did you actually test this patch, to make sure
non-wildcard scans still work?

Also, even if this is correct, it seems like it would be more correct
to use 'sizeof(wildcard_ssid_tlv->ssid)' instead of a magic number 1.

Brian

>
>                         tlv_pos += (sizeof(wildcard_ssid_tlv->header)
>                                 + le16_to_cpu(wildcard_ssid_tlv->header.len));
> --
> 2.17.1
>
