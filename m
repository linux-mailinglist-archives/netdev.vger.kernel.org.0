Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741B024F10C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 04:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgHXCUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 22:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgHXCUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 22:20:35 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A4DC061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:20:35 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id x1so1603145oox.6
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j2fe+8euIzRFkPkX4s3PnFWaPz07CBi6PMUxm1wVYzA=;
        b=qVYzSQA6xMj3xDvEjx3Q77xNxsyoFjbWqzst6wTVo9FxhdUPGwKUmNRMvIe34iB8iK
         j/joOwxgPV0cyfjkPaKYsGfYTCRX4oVsTvn+FVMyFawETIypDNZFjWb+PdKi19Wd+Sun
         0tEKFeYqqLdfqwpbFub6QEzajMJi8r8981+YFkFdXET4os85Nb1jdGrIi4Z6RH1VeRcl
         8tx82HF19xuz3aFS2TUibBywNQa45LMiFrqetUul4QXjl0LKrSUd9dyclzqNqp8uGBo2
         vm6XK5Lidttuo1MV+ADdZw1+ko04xJ5euBNYLdOq+P76OxIvgMCd6+6JW+5c6f8sVddq
         ZuEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j2fe+8euIzRFkPkX4s3PnFWaPz07CBi6PMUxm1wVYzA=;
        b=IGxokPqWv0O6A2paVn7Hsj92lL57sdzmk2Oq5Zm5VgKTZGYRQjVahvRbjUwmv8OrV9
         69yBKQEv13+Wa8D85E0pbO7jOMZXz1MonhEuFpzMC+TaIKF0IlCSrXvKzbPIuaUc7e6i
         LuqM9B7IgdzRh4xcWYKtUPy4PbPjYcUvius1cQbRk+Y7HdUutO3yySxTsL/6UtOcOr5o
         VZdKs6L0Acorg8to1nzEZkWg98DnGiCN9BEpoQvL2rZ9U4gPSecx5pyfiLz4dhPDJZpG
         tS5ttlI1KN72ZgUpbSCdSW7H9mcapb+qc7k8t5ftRip7ku5sHh55+GLY7cDreq5E2Bun
         G0nA==
X-Gm-Message-State: AOAM531kUXqaaJFpQfhWW78AYEkjCYFuoGkZBrKbUvEE9Y/O2t8CpSye
        AzBVj4AnsAuAMDa+1yysaiU=
X-Google-Smtp-Source: ABdhPJwgfBdDD8RikzGXBjJimn3ULTVh4k0DjEZc8ljcqVEuawE1Fo3KyLy7PZENYDolgfS8ruvXkA==
X-Received: by 2002:a4a:6f45:: with SMTP id i5mr2384136oof.70.1598235633186;
        Sun, 23 Aug 2020 19:20:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:39b0:ac18:30c6:b094])
        by smtp.googlemail.com with ESMTPSA id i8sm1783411otr.59.2020.08.23.19.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 19:20:32 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next] iplink: add support for protodown
 reason
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
References: <20200821035202.15612-1-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f9a02516-f954-2b97-ed12-8fbad2f2271a@gmail.com>
Date:   Sun, 23 Aug 2020 20:20:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821035202.15612-1-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20 9:52 PM, Roopa Prabhu wrote:
> +void protodown_reason_n2a(int id, char *buf, int len)
> +{
> +	if (id < 0 || id >= PROTODOWN_REASON_NUM_BITS || numeric) {

since the reason is limited to 0-31, id > PROTODOWN_REASON_NUM_BITS
should be an error.

> +		snprintf(buf, len, "%d", id);
> +		return;
> +	}
> +
> +	if (!protodown_reason_init)
> +		protodown_reason_initialize();
> +
> +	if (protodown_reason_tab[id])
> +		snprintf(buf, len, "%s", protodown_reason_tab[id]);
> +	else
> +		snprintf(buf, len, "%d", id);
> +}
> +
> +int protodown_reason_a2n(__u32 *id, const char *arg)
> +{
> +	static char *cache;
> +	static unsigned long res;
> +	char *end;
> +	int i;
> +
> +	if (cache && strcmp(cache, arg) == 0) {
> +		*id = res;
> +		return 0;
> +	}
> +
> +	if (!protodown_reason_init)
> +		protodown_reason_initialize();
> +
> +	for (i = 0; i < PROTODOWN_REASON_NUM_BITS; i++) {
> +		if (protodown_reason_tab[i] &&
> +		    strcmp(protodown_reason_tab[i], arg) == 0) {
> +			cache = protodown_reason_tab[i];
> +			res = i;
> +			*id = res;
> +			return 0;
> +		}
> +	}
> +
> +	res = strtoul(arg, &end, 0);
> +	if (!end || end == arg || *end || res > 255)

same here: res >= PROTODOWN_REASON_NUM_BITS is a failure.

> +		return -1;
> +	*id = res;
> +	return 0;
> +}
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index c6bd2c53..df3dd531 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -75,6 +75,9 @@ ip-link \- network device configuration
>  .br
>  .RB "[ " protodown " { " on " | " off " } ]"
>  .br
> +.RB "[ " protodown_reason
> +.IR PREASON " { " on " | " off " } ]"
> +.br
>  .RB "[ " trailers " { " on " | " off " } ]"
>  .br
>  .RB "[ " txqueuelen
> @@ -1917,6 +1920,13 @@ state on the device. Indicates that a protocol error has been detected
>  on the port. Switch drivers can react to this error by doing a phys
>  down on the switch port.
>  
> +.TP
> +.BR "protodown_reason PREASON on " or " off"
> +set
> +.B PROTODOWN
> +reasons on the device. protodown reason bit names can be enumerated under
> +/etc/iproute2/protodown_reasons.d/.

we should document that 0..31 limit.

> +
>  .TP
>  .BR "dynamic on " or " dynamic off"
>  change the
> 

I wonder how well supported __builtin_ffsl is across architectures ...
would be faster than the 'for (i = 0; reason; i++, reason >>= 1) {' checks.
