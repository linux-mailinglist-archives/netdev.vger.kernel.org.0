Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7686A309EAD
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 21:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhAaUKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 15:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhAaTqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 14:46:11 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C67C0613ED
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 09:26:25 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id y21so349365oot.12
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 09:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dajXDHXzRN/sXtrgmkBdHHW6Sjy8LSjMZHP54o3/2ps=;
        b=lIuxirfyrBOIKG0aE40V9LqRNApilgTSC0j2CCRnIIbeC24H0LXFj0gNQUkLz5rCDc
         1Hj4VMFtwjKgF5Tu7FWXMvllQYqwIpx5IAbQF+1QHl8laSVwcp5QQ1tDpKT8NH0b+jk9
         FVsl8VOPTua354MXjYSEhdpih81gXeXtTDOXmS6vjhHotYUlpAKxz9ZOsHYjRjeAGTA9
         vwNRvK5Q5in9+xS1G9KGYOhv60okUNca4eK7NFrsa+E5kC5LASg0a3Nf2FsOmYO6VAlN
         RK763giYRAQNNRKVVyf/TJj3BDv43/QJrTiQPLu7HdVpovt2oMWufn8qG5VN4PB+Sws5
         AHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dajXDHXzRN/sXtrgmkBdHHW6Sjy8LSjMZHP54o3/2ps=;
        b=QMj6PxDvb89OIo4HNiad6enpbPudu+MBmeKiFPDIyQV7wJqW9ZDfKaqAjRRdcFwnkJ
         hDM3XDQ66jpvzFGxKRHdPByxsHZh24RbHwGZvE6wV9AuhQ51gAEXXJUZvl2MvObLXd+9
         PWlcJ1PcOeYBel1PgEZG5FfnwHgdk2Swtvrq2cgKddMGkqcxL/KIBrnm2ZP6d5xqvIrv
         UR5Es9j2Ate32Kb2VFbX5phkK8HzkQSt5lLvAy58C+OrT5J4GsmsC7ruIdWVvYyybZVz
         Gd3AUxSRX9oBt4ZyPGHf2f9gELFLJ7lcgDUcxy8Eim2qRwhGFaU6ZlA9qlVHYzykNU0f
         nr2A==
X-Gm-Message-State: AOAM532QOuKourVSo9qwwxYJcmYl+ePj5SgtDJ3ft5+i4+Pb1mTT70Ag
        htSWiy+FmhoJwX+nLZOVXLg=
X-Google-Smtp-Source: ABdhPJwX8Z7zaIJmJvBH1X2vRa53zLPZouMXTesTnZg7Y5NOKjzhjA0HZCMOoqeEg/tE/hA0r5FZng==
X-Received: by 2002:a4a:cb87:: with SMTP id y7mr9594623ooq.1.1612113984624;
        Sun, 31 Jan 2021 09:26:24 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id a188sm3879766oif.11.2021.01.31.09.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 09:26:23 -0800 (PST)
Subject: Re: [PATCH iproute2-next 3/5] devlink: Supporting add and delete of
 devlink port
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
 <20210129165608.134965-4-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <81d8561c-a9a2-f61f-6e84-414779147e60@gmail.com>
Date:   Sun, 31 Jan 2021 10:26:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210129165608.134965-4-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/21 9:56 AM, Parav Pandit wrote:
> @@ -1383,6 +1389,37 @@ static int reload_limit_get(struct dl *dl, const char *limitstr,
>  	return 0;
>  }
>  
> +static int port_flavour_parse(const char *flavour, uint16_t *value)
> +{
> +	if (!flavour)
> +		return -EINVAL;
> +
> +	if (strcmp(flavour, "physical") == 0) {
> +		*value = DEVLINK_PORT_FLAVOUR_PHYSICAL;
> +		return 0;
> +	} else if (strcmp(flavour, "cpu") == 0) {
> +		*value = DEVLINK_PORT_FLAVOUR_CPU;
> +		return 0;
> +	} else if (strcmp(flavour, "dsa") == 0) {
> +		*value = DEVLINK_PORT_FLAVOUR_DSA;
> +		return 0;
> +	} else if (strcmp(flavour, "pcipf") == 0) {
> +		*value = DEVLINK_PORT_FLAVOUR_PCI_PF;
> +		return 0;
> +	} else if (strcmp(flavour, "pcivf") == 0) {
> +		*value = DEVLINK_PORT_FLAVOUR_PCI_VF;
> +		return 0;
> +	} else if (strcmp(flavour, "pcisf") == 0) {
> +		*value = DEVLINK_PORT_FLAVOUR_PCI_SF;
> +		return 0;
> +	} else if (strcmp(flavour, "virtual") == 0) {
> +		*value = DEVLINK_PORT_FLAVOUR_VIRTUAL;
> +		return 0;
> +	} else {
> +		return -EINVAL;
> +	}
> +}
use a struct for the string - value conversions; that should have been
done for port_flavour_name so it can be refactored to use that kind of
relationship. This function is just the inverse of it.
