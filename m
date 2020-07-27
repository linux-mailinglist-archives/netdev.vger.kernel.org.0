Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3875922F559
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732203AbgG0Qak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730408AbgG0Qah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:30:37 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB70C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:30:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t6so8315018plo.3
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KUpzsNFAUYUsEYZFksnW8AKVT4wUecVtRHNQYMCJ0g0=;
        b=vPWFeoZWIHSCp+FRriNRL1G3Gyl+DgVuDTzlzHyXFEpphHl+WN9xArjHy2NscZ6U4t
         BCiKNqpvOoOqj5jFYN4VyHu9QVmX/njkcUvYrhRpwmgBO95uSpvbC0qgstw75ZMhyQ9L
         jn8RNXVOZfFHdTAtw+au+nDl5xOADj3GyFtB9mmFpa1Xfx3ZHMxI5vogdoWepF44MXh9
         iUdBuqasmGut1+enOl7ddCDwQ8AeErNaEHXUiOaRo9bxcX9myixSBrrpqGX1w8/71zlW
         rwqbROJ616tL4MifariJXKNwxSVLgXRp9JK68pS0nPZBAacBKcy7d1axFQv+vhWc0zG4
         9DJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUpzsNFAUYUsEYZFksnW8AKVT4wUecVtRHNQYMCJ0g0=;
        b=fVAqk99zq4wDwvoSAcvpTg8cihJuH3nWxUcbENUjtMBE5zG0Wp/2k1cOZi/Bf8Nq+/
         XNvI8rT3CENjZZM59xnTl5R44dcx601OaJF6TLABsjw9gG1DU73R8X8R1SiUnIsAldwI
         FZ9VYeG5XmqeWcrxL/LsZfxXlD2vJMR+Z6qSvP/JD9ZuaJeFbaDXEn2sopPFONKUgtVX
         nESMAOCRR0jLW8vT8I7Ti18atLJXRxmrYYxjSyaAqMeCZE+tlxYMVAydHMgMVpBo5SXI
         C+Dky296sjecVoZzn8Mj1SHCQpQhPbaHhSZ4Ka5+kC41VJrgkTy14iWm5WR08+X3yM0B
         kANg==
X-Gm-Message-State: AOAM5316hgmW3c1sAd0pw56IQnK6H6LeuLiAxK9xFIZew0/OkE10d6d2
        lt4iPEyR0yzN1am3O4LqZjQuAw==
X-Google-Smtp-Source: ABdhPJz63EHIaG1LRsloWgoIpWgusAQ+Nuzd59ShSTC0Gunx1jis1RU1uliIv0s2QewVFxHxrplyTQ==
X-Received: by 2002:a17:90b:24a:: with SMTP id fz10mr146816pjb.36.1595867436407;
        Mon, 27 Jul 2020 09:30:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j36sm15644206pgj.39.2020.07.27.09.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:30:36 -0700 (PDT)
Date:   Mon, 27 Jul 2020 09:30:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Julien Fortin <julien@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2-next master v2] bridge: fdb show: fix fdb entry
 state output (+ add json support)
Message-ID: <20200727093027.467da3a7@hermes.lan>
In-Reply-To: <20200727162009.7618-1-julien@cumulusnetworks.com>
References: <20200727162009.7618-1-julien@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 18:20:09 +0200
Julien Fortin <julien@cumulusnetworks.com> wrote:

> diff --git a/bridge/fdb.c b/bridge/fdb.c
> index d1f8afbe..765f4e51 100644
> --- a/bridge/fdb.c
> +++ b/bridge/fdb.c
> @@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
>  	if (s & NUD_REACHABLE)
>  		return "";
>  
> -	sprintf(buf, "state=%#x", s);
> +	if (is_json_context())
> +		sprintf(buf, "%#x", s);
> +	else
> +		sprintf(buf, "state %#x", s)

Please keep the "state=%#x" for the non JSON case.
No need to change output format.
