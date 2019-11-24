Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D38108157
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKXBUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:20:05 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40623 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXBUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:20:05 -0500
Received: by mail-io1-f66.google.com with SMTP id b26so10338870ion.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 17:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IcN7qN/axiT/anQqvUgOgObBoJ7jeG1dmpaltuOnysE=;
        b=IrEhRwuBNYpjmtDK0lprN6TSaevfI0yd5Uqy5xCVgZsSXhSFvKGLvufHTfkE+HQpUU
         LE01IYoO8/Zatpzb+T2kZo+uMISMCymCHIumy8DjSvv7sD+Al6YifbLMp+/IMmanHA8F
         WqfEu/kZ0Eqhnk65wH50hjU4IRZRpNn0gsVOEb2IGUaBXWW+fWzKHiiI8WkIQjrZZ7jH
         oKDupDTkDG2RepohJYgrDeHPQ5CA+TELaqf/FSFnYASgqvSO5gHxzWn2SymQD7wML7rO
         aduU8VJ2PGunwgdQuFy01fdcQ/3t7bapOLdSo+ALLqEFnCK5wPJtRQxLCmGBmMa+tC4A
         kKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IcN7qN/axiT/anQqvUgOgObBoJ7jeG1dmpaltuOnysE=;
        b=JpoOcvkMtbFv0ULuJuBa1frcgde/opAckWoHhb4RlAJGP+Jz2RplMLEZMba1XyIlE+
         i4MN4ryYgIi3cENn+pz1s0cU1JarQfEzlQvK97/x5e08yV2+W2OYnvAfuuiAEs0n0uYD
         NnSz3lQK8cTFBIX9LlqXmwG5dvWGlFpbveTMByfytbwqSGP25U9CtmCZ0j4aDql1rFIj
         eDBYu2uB/q3exJOSXQaIPVWOhNMxznP9fYnQerQjQZljV7MajNQOLM2OgQ1RLMylTFEN
         nviLSKQgajzybeRf63F/c3t7jmGK26f0HAQMpK9+4j9AQez7Ll1MD48J7izNKop+2ZUy
         LYng==
X-Gm-Message-State: APjAAAXyHcuA3g/nfvyb2d8SvjW3oL2PIuV7RcQWfaeq9c0TGQD13w22
        SbQTib16wvNm63aM+cbg67A=
X-Google-Smtp-Source: APXvYqzptq12AFk58e5pes1fbOwD6X1J/1Y9lOTKoVx5uI2Ev1BQoaAaVz8zBXvx9gwpzLikstaTQQ==
X-Received: by 2002:a6b:cf0f:: with SMTP id o15mr4152558ioa.229.1574558404640;
        Sat, 23 Nov 2019 17:20:04 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c435:ff27:4396:2f9f])
        by smtp.googlemail.com with ESMTPSA id w2sm774131ilg.51.2019.11.23.17.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 17:20:03 -0800 (PST)
Subject: Re: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
From:   David Ahern <dsahern@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20191122224126.24847-1-saeedm@mellanox.com>
 <20191122224126.24847-2-saeedm@mellanox.com>
 <20191123165655.5a9b8877@cakuba.netronome.com>
 <bb598347-bfe3-4e39-2e69-5db3b3188c7b@gmail.com>
Message-ID: <9d46e1e4-aa34-01a0-b0ad-712bbb372746@gmail.com>
Date:   Sat, 23 Nov 2019 18:20:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bb598347-bfe3-4e39-2e69-5db3b3188c7b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/19 6:10 PM, David Ahern wrote:
> On 11/23/19 5:56 PM, Jakub Kicinski wrote:
>>> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
>>> index 205fa7b1f07a..de9004da0288 100644
>>> --- a/include/linux/netlink.h
>>> +++ b/include/linux/netlink.h
>>> @@ -62,6 +62,7 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
>>>  
>>>  /* this can be increased when necessary - don't expose to userland */
>>>  #define NETLINK_MAX_COOKIE_LEN	20
>>> +#define NL_EXTACK_MAX_MSG_SZ	128
> 
> This makes extack use a lot of stack. There are a number of places that
> are already emitting warnings about high stack usage.
> 

It also adds unnecessary overhead since initialization 0's out the
entire buffer (most sites declare with {}; a few use memset).
