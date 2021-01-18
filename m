Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905F62F9863
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 04:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbhARDyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 22:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731813AbhARDyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 22:54:15 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0276CC061574
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 19:53:35 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id s75so16434816oih.1
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 19:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bk+LfTAg3VLb4VOFtskJufw1ZApwQHgoaC8n0nQ5frI=;
        b=A3El7NfXc4Drj6NkcxE9CDshLvM1dbA0dNHRkUDUH0700pm3Qv5WE8PV6GYh4bD6vq
         W1KiORpWt7w48mUIrH+92WOouwCc5btYiFtJyS6VzCvn8dEAJNQvNZitRYsA6Re8GdLl
         n+OGSmi83I079Tl+FdLBLQ4VSz0VTsLCKetO7Y8KIyAQWT5nOrnGangTuiLVEWMp63B+
         lL60rjCRy9JoH/u5MveXfkGM+dZMzkAaUttEGOxJ09aASyZf4+A0dMwJY7H8ka4JP5nA
         +6PHorYa2Ws4iTiJf1bRHxoAxeC3Kaw/X/T12u8K+V2cJzHHZN9huQxfbG/ZcbaQ+cCJ
         kJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bk+LfTAg3VLb4VOFtskJufw1ZApwQHgoaC8n0nQ5frI=;
        b=L3vBvqETyVu1Oozdlfk+DVP8uFmNgMamvPvrVAbL0Jhu8Aw9cCl/FYdYGxsKqzl+PI
         ldCn0KKyqtFaqlkKOLNrrDGlwXqLZQjkeGgEhkuBbYx1aXvFmn7y8YeLvcGtV36uLu15
         35UdXHH/Am+xzru9q7aIR7QNT7jJHIeW8u8lTZQZGaw7ondfXS24j+WDxT9Lt9f1iLoQ
         q8NrE0AC3NhicDJ+RjgcI+qir5gBKSf/vZ1XSVgzcRZSDWilVubX5mEweWR9fEQekbu9
         YQdGXXtUL9aU+K3YIkb0E74tjavPVwsBBoMuH6/TGFb+cBebLvGcJQtrgZ3QFnACqaT0
         asqg==
X-Gm-Message-State: AOAM530b2y9xqJmuSewR+ebOwu4YeH6cwTe2Rq/sux9CpbaENzmC7/PF
        y29PpJgIYKiqIO3It7+H8Nk=
X-Google-Smtp-Source: ABdhPJw/rgu19ZKCCHtrUHeglzFqIeWsA9l4X9bsnKc6aywNHSHdTDzuu/wEmf50fU6uDGylVmjHmA==
X-Received: by 2002:aca:ab53:: with SMTP id u80mr2970212oie.49.1610942014480;
        Sun, 17 Jan 2021 19:53:34 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.202])
        by smtp.googlemail.com with ESMTPSA id f145sm3571932oob.18.2021.01.17.19.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 19:53:34 -0800 (PST)
Subject: Re: [PATCH iproute2 1/2] vrf: print BPF log buffer if
 bpf_program_load fails
To:     Luca Boccassi <bluca@debian.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210117225427.29658-1-bluca@debian.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <82157115-ae31-4ec9-a4c5-a71dd414c68a@gmail.com>
Date:   Sun, 17 Jan 2021 20:53:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210117225427.29658-1-bluca@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/21 3:54 PM, Luca Boccassi wrote:
> Necessary to understand what is going on when bpf_program_load fails
> 
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
>  ip/ipvrf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
