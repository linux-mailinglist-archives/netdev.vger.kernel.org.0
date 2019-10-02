Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0473DC86D8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 13:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfJBLAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 07:00:41 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40197 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfJBLAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 07:00:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id 7so16624632ljw.7
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 04:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YqW4lirDp6dhPL53QREOEClblGXQffbz/DGv2dLJs4Q=;
        b=ISl1taxiHeTMVMMOn0n8wcdg1xJCR1fcz2fZFt8tGPPObtsnfloz8d6yuwZ/9jaDBC
         EpdDdSIVXj2fa5iKwOBPzK1izqeisJnL+CPOwUoqWwMd4nnpL+vDOFHoSeaHcSqS4GjT
         iCUvnNTfZGkmnxxuPGn9m+87WKlq8hpi7/JB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YqW4lirDp6dhPL53QREOEClblGXQffbz/DGv2dLJs4Q=;
        b=ggLgc1CPl0caRrnsDSDu7XWwqvfUiv+ep1sRwJ/uo2LaC//2KEwFaGKWkkS9Q9KlKW
         EYnQZ73zRcomLGVHt1mwLXBa8VnIBiqRASExu46OEYflSnyIGGmJjcSJTuW3GU551naP
         QaV+SKK85N8pdiS740tIW2+R/8PnUfEeWYotS6yvbLHS+IGOwvkk97peDNesYMEyyNi4
         BEP+udbRw8VJrD+Fg+1DPiTtxoo/u5iQErO1AK9RHbDX8Ig1KvjbMEq2nztI4IJdUbIg
         5D6HJ1UWolR4NNh1+90BuepYk7sRY67ctGu+9V9WkFd1DogWPrDz3jd/7FnK1t/RTfzi
         5wAA==
X-Gm-Message-State: APjAAAXUj7YUyWhh8QpOsIFrfslNi6XXOw8Q19SvF7rtf39OzkrujzZh
        EZ/YFRgFG3k1e6I0IxALp88bjQ==
X-Google-Smtp-Source: APXvYqzu9K6EJ442RqSftT7bhnv6pnQOGABkdQlZVfOHCKr4mFhLt1GwBoceHpgFO7VessYbj9nmHg==
X-Received: by 2002:a2e:86d5:: with SMTP id n21mr1977522ljj.1.1570014037566;
        Wed, 02 Oct 2019 04:00:37 -0700 (PDT)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id y22sm4544784lfb.75.2019.10.02.04.00.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 04:00:37 -0700 (PDT)
Subject: Re: [PATCH v3] string-choice: add yesno(), onoff(),
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
References: <8e697984-03b5-44f3-304e-42d303724eaa@rasmusvillemoes.dk>
 <20191001080739.18513-1-jani.nikula@intel.com> <87eezvbgp1.fsf@intel.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <dc08714c-c76f-10f1-a5e7-7972beeb4552@rasmusvillemoes.dk>
Date:   Wed, 2 Oct 2019 13:00:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87eezvbgp1.fsf@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/10/2019 12.11, Jani Nikula wrote:
> On Tue, 01 Oct 2019, Jani Nikula <jani.nikula@intel.com> wrote:
>> While the main goal here is to abstract recurring patterns, and slightly
>> clean up the code base by not open coding the ternary operators, there
>> are also some space savings to be had via better string constant
>> pooling.
> 
> Make that
> 
> """
> While the main goal here is to abstract recurring patterns, and slightly
> clean up the code base by not open coding the ternary operators, using
> functions to access the strings also makes it easier to seek different
> implementation options for potential space savings on string constants
> in the future.
> """
> 
> to be more explicit that this change does not directly translate to any
> space savings.
> 
> Rasmus, okay with that?

It's rather fluffy, but it doesn't make unfounded claims about space
savings, so in that regard I'm fine with it.

[It's probably just my lack of imagination, but I still fail to see how
one could ever achieve better than the linker creating just 1
vmlinux-wide instance of "enabled", which I believe happens regardless
of whether one uses these helpers or not.]

Rasmus

