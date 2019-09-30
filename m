Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79286C234E
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbfI3ObI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:31:08 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44922 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731509AbfI3ObH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 10:31:07 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so9692242ljj.11
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 07:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zBL7epC00p9U9++zGccJDAwUuYYIfHYJAHuYq0NGhKI=;
        b=Ke+Nx55iXZQfZSHRoqDLY786VnrQjJgoe/GD/uOlYu8+tDQ9EAUgLcqHGlUm6BTKpb
         WX5654MwqqZ+4GZEY92XR6gll89SPNvhOQD60cXDcMBMQxuvCBnI/oi+9OcSMb9YhvVR
         U2f3yCuw6i91i3dKrEsYVFk1FGdpYawZKGy0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zBL7epC00p9U9++zGccJDAwUuYYIfHYJAHuYq0NGhKI=;
        b=CXQFiFGsbAnjSwIbBV6GCvYkuajVPHvcXsuQJ6Hx01P3IFgDEGzAA7IFHHEaZpfdf6
         X922tuWdyNTerDUJZA98flnksWdGOjXEkzRhcMS/cE9VwtSkLJ+31tYndY3BQjdm+ONs
         SWXBbn1y4pKZjTJWDxAacOWzBzmJfhG2Bj3shMvC5354HMpPNzSQ46UNTa8zI4gaOLRr
         w6RFEeJKJozWowDj8TCBjeO+vKk7BZ6bYVvI6og9TCdanErAkt3ypPhypiRTLlIl6JQK
         kAG8IdL/wVJoUSZDLqjXr41OtBniUWJddbLSwNbU7WMy/2VR3xsnGNaqVpYjXK2+KzMM
         bmbQ==
X-Gm-Message-State: APjAAAVfttigh56ohKOjHhu5rvyvRGdBVyZIVTE14gwNcSQ13o0Is8M3
        s1uXgkUD6Qpwp2ICxTiLVSLEsA==
X-Google-Smtp-Source: APXvYqyIcLy55HB3x/wsB1A7V+gCME1VE6tR84DBLqOOAZkx1QX/h9HdcAKeuQHRVXy8LcRSx7k+/A==
X-Received: by 2002:a2e:8ec6:: with SMTP id e6mr12257813ljl.231.1569853864490;
        Mon, 30 Sep 2019 07:31:04 -0700 (PDT)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id q11sm3301932lje.52.2019.09.30.07.31.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 07:31:03 -0700 (PDT)
Subject: Re: [PATCH v2] lib/string-choice: add yesno(), onoff(),
 enableddisabled(), plural() helpers
To:     Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
References: <20190930141842.15075-1-jani.nikula@intel.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <8e697984-03b5-44f3-304e-42d303724eaa@rasmusvillemoes.dk>
Date:   Mon, 30 Sep 2019 16:31:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190930141842.15075-1-jani.nikula@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2019 16.18, Jani Nikula wrote:
> The kernel has plenty of ternary operators to choose between constant
> strings, such as condition ? "yes" : "no", as well as value == 1 ? "" :
> "s":
> 
> 
> ---
> 
> v2: add string-choice.[ch] to not clutter kernel.h and to actually save
> space on string constants.
> 
> +EXPORT_SYMBOL(enableddisabled);
> +
> +const char *plural(long v)
> +{
> +	return v == 1 ? "" : "s";
> +}
> +EXPORT_SYMBOL(plural);
> 


Say what? I'll bet you a beer that this is a net loss: You're adding
hundreds of bytes of export symbol overhead, plus forcing gcc to emit
actual calls at the call sites, with all the register saving/restoring
that implies.

Please just do this as static inlines. As I said, the linker is
perfectly capable of merging string literals across translation units
(but of course not between vmlinux and modules), so any built-in code
that uses those helpers (or open-codes them, doesn't matter) will
automatically share those literals.

Rasmus

