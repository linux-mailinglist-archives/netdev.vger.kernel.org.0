Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0598030EAC7
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhBDDP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbhBDDPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:15:52 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C75C061573;
        Wed,  3 Feb 2021 19:15:12 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id i20so2059584otl.7;
        Wed, 03 Feb 2021 19:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dL2HlrenlcR0aeJ/c9YQKTZwO4wZrZX9JFm2i1Qu9X0=;
        b=VDe/o2nxsc3rMKgqLbrY/PLCZmjOwugco0SREC5xz//Wu92VuUBF/x1Y5MHlfNmPrC
         26oxzsS2J9yVwKfBlJ4qyacsmJpgxLDkjqxyydzHsSF3jl2okwPb2G7zA5dPj87PfVXK
         2pjuOiXYdvjog+xNJ940aymXGiaKlboJD22xgnZZ5PypNa+GjKC1bCyUFlA0SijjVXOO
         MHGLLOaRRXUOC0GuMUvP5Bqm3ykIxy/sJWJknq97iEOH6EVzW03IbNuVa8smNvFgAlXp
         ALAvBkvDF05JYlyisjtI0p+vadarO0DnWIPg/1ZMwgEgb9lBSfs91PUb6e+1suBXIiFg
         k7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dL2HlrenlcR0aeJ/c9YQKTZwO4wZrZX9JFm2i1Qu9X0=;
        b=pchl157aPvlKXYnMSlFf+6nIwjperzZ2sABcsnhHvDxw49p0oucmYWCSeGU673vZ/3
         n4NuCfLtQaf7a/a/UflW/XtZAZ4EyMRB+ZiISLVFrxSnExnIPZqRMPdG3fQcZnMyvUC3
         0xzuyaaJ1pIhkVz5bZ+HhDc7SYh0NumKRWNPbkIP6I7xMjYXghe1wt8OWXRO7vX5wC52
         I/3OU+1F2+kswsdHaupP9IzT8UgiBYSbV7zQA/HkQD0Rrlfix/oOCx5GRI6mpT44Pnp6
         cVePvsgP3ToKDPJ6GjjUcBhAtbYAD4349LS7RMXGuO8bqKUBIRVUq4zJRTkrobifzpPl
         J9XQ==
X-Gm-Message-State: AOAM531t3x4mZ5XSJPUUhBp8rwG4iPMJ54FcY6OQ44JLoSOQWUWpZzVb
        Z1OURWfkr52cG/t3lejb6ddGP2Wqcvo=
X-Google-Smtp-Source: ABdhPJxfyfrQDNS5yRnsk+wrf/aedgAhlP5gs+HNxp8X9uFHxOFfEQn2O0jShbkrKyG/4I0aniDuHg==
X-Received: by 2002:a05:6830:1158:: with SMTP id x24mr4075633otq.108.1612408512045;
        Wed, 03 Feb 2021 19:15:12 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id k129sm888820oib.5.2021.02.03.19.15.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 19:15:10 -0800 (PST)
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20210125104055.79882-1-socketcan@hartkopp.net>
 <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
 <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
 <586c2310-17ee-328e-189c-f03aae1735e9@gmail.com>
 <fe697032-88f2-c1f1-8afc-f4469a5f3bd5@hartkopp.net>
 <1bf605b4-70e5-e5f2-f076-45c9b52a5758@gmail.com>
 <dccf261d-6cc3-f79a-8044-f0800c88108d@hartkopp.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <aeb9d16e-e101-e2e5-d136-b48333f03997@gmail.com>
Date:   Wed, 3 Feb 2021 20:15:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <dccf261d-6cc3-f79a-8044-f0800c88108d@hartkopp.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 12:04 PM, Oliver Hartkopp wrote:
> My only fault was, that I did not send the patch for iproute2-next at
> the time when the len8_dlc patches were in net-next, right?

yes
