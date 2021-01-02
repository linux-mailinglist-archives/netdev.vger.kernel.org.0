Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC132E8826
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 18:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbhABRfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 12:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbhABRfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 12:35:13 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A5CC061573
        for <netdev@vger.kernel.org>; Sat,  2 Jan 2021 09:34:33 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 15so16060697pgx.7
        for <netdev@vger.kernel.org>; Sat, 02 Jan 2021 09:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yDBeRBrNReQc5c1nnJVczMWeq8Own/mS+4n26dE9mtg=;
        b=jijcjE0wt7yvBxzn3sB4L3wkJmZ9yaBYOg/uEMLeIUYKOm0/Xf7SfseT8QxZgJJIVC
         AJI+bXxSjk6EVJVJ4SyKygMiVb55vPVrsDAvfB9FpgO4h73deuS+zgMme8xCcQcLdLLl
         njedDmzssYlo86EgNwEZ7jSs/vcM+do4hZj1KEwLNumQ56DHUl6KTJaJ5wI1w+2+fYeH
         lDxQ0X1NtFCsBy4LR+QVugKuZiqRJ66tBlA0MuZ6REaE714sQ3i5JZxAI91Y6cDnbj+P
         bR9hPB30xPTYeCMZITHIKusbN3ZjCdoytv5Yy5hGA+tWxZzQ3N3H8fR08jkSFw7y8LKs
         ZvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDBeRBrNReQc5c1nnJVczMWeq8Own/mS+4n26dE9mtg=;
        b=MuexPnD2jNVXLxCjZ8IjsgVs7RTNqXNU97X8fRhVazIOw23M5whJeILt+rMKEEe2pq
         CE4wWM4vJwg1PAIAJ/QS4qawqI26CmItV19T3RcqjHRyTyY9ZlBTY+PAzJxIIcyiDzm7
         zhef7xwcDM5X0N9qwn8XtLwYmUBIgJ3293M5jgBSED+QlAtzEb2ZJlQ3uSgYgf19bbtQ
         Rfwz8ZUSaM58lIdRPAKOcVOGKt6m1v5RHmtHOMjo2WfkTRinHEmhCIcjHv5opbNSt2YX
         LGrBTUh4uoYfv13ymHWirlMiVXeM4BYmz4uHo6rNOj8oDWmN/YdcZzC3scYKAz8iSsK4
         ZbkQ==
X-Gm-Message-State: AOAM533K+3a7pPT4B9dBbNZF6KxaMQKaXGWrxmsfUhCB4JOpl1U0HwRP
        pDMXCJHO/FKoZJuaVDaTEatM4w==
X-Google-Smtp-Source: ABdhPJxBswld6tpa12DVTJOMgoGTvO3GaVzJICjtIgLxaIQzAWxT39/CMZn3PqTawJ1nIB9MduD9oQ==
X-Received: by 2002:a62:8205:0:b029:19e:717c:d647 with SMTP id w5-20020a6282050000b029019e717cd647mr59469409pfd.50.1609608872021;
        Sat, 02 Jan 2021 09:34:32 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a13sm51302897pfr.59.2021.01.02.09.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 09:34:31 -0800 (PST)
Date:   Sat, 2 Jan 2021 09:34:23 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2 1/3] dcb: Set values with RTM_SETDCB type
Message-ID: <20210102093423.2033de6a@hermes.local>
In-Reply-To: <61a95beac0ea7f2979ffd5ba5f4a08f000cc091a.1609543363.git.me@pmachata.org>
References: <cover.1609543363.git.me@pmachata.org>
        <61a95beac0ea7f2979ffd5ba5f4a08f000cc091a.1609543363.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 Jan 2021 00:25:50 +0100
Petr Machata <me@pmachata.org> wrote:

> dcb currently sends all netlink messages with a type RTM_GETDCB, even the
> set ones. Change to the appropriate type.
> 
> Signed-off-by: Petr Machata <me@pmachata.org>
> ---
>  dcb/dcb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/dcb/dcb.c b/dcb/dcb.c
> index adec57476e1d..f5c62790e27e 100644
> --- a/dcb/dcb.c
> +++ b/dcb/dcb.c
> @@ -177,7 +177,7 @@ int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *da
>  	struct nlattr *nest;
>  	int ret;
>  
> -	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, DCB_CMD_IEEE_SET);
> +	nlh = dcb_prepare(dcb, dev, RTM_SETDCB, DCB_CMD_IEEE_SET);
>  
>  	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE);
>  	mnl_attr_put(nlh, attr, data_len, data);

Should I add fixes tag to this?
