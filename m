Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43612C9410
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgLAAgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgLAAgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:36:37 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5CAC0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:35:51 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id l11so132513plt.1
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7B9TZXdU4gOJK6hSgjiMONny1ZIgtRsaHIZHu26XHig=;
        b=c1U3E8CYeoLrEoz2cv3XL4nIklsZMjip2VgVDH0lJjuKq3wUTKKB+Nix/NcsT+eWNY
         VzwDw9xdZsbJegEC20vEATNrRMiYWAem3+MNXqA34GpjErnljhXHjNnK4BdQVIDV+9Rx
         DVrAbBpVSOPT18pC+vqE4xD4k/IL5OOmBwE+vlaJplGiSAafSsDlwhPBZaU6otOGkT4H
         W2+JKulKw1gtn68MdDzPgWXYcsh3OfueToP3d7pzTqZEMjeQNwQuugm2mL22hNZHOGHx
         pXNGAUPu0I0zUgJb3oMF81XtUc+6ZcSs/IAQJkxN8m0hNHYXpWHgYRrALbxW7PMq8KiL
         Nr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7B9TZXdU4gOJK6hSgjiMONny1ZIgtRsaHIZHu26XHig=;
        b=V0MucTnub5imBh6SuSDlX62YAhyX4M/txUxdyD1MEEO9yhSgk3gHiCdvTYy6fBDV1y
         oHlmVkhAIKoxn7Mb3SEou7bZV8KM8xFR+DTjNP99YY5z8oYXHkzXOBqC0FkiOoYOk1OQ
         NxUSMkuuDnwVjTWV05vTSbSDLsAf572m6idM6LvM47NeqfnbV/06rn2c8B0QA3Ok5LjV
         tnUBvzbJK+7g+kXhHV8TTgacvkQjTaUKF5gcMNkzaDMuDhMTmDe341OpQD0pbflo768N
         UiAmb/bIPlt1+zDzxTRl7Ys40NO3eZIyc/Iz/Tz4weMWQNRxlAenSfdBFpW1ck9Muvcf
         qBDw==
X-Gm-Message-State: AOAM532PrisPvSp3ejzDT6P2U5ziKXAG4gxOrgi0LoW3AppplZal0K4N
        wOC6w1SI/F90c61HEb+2Y2TRUg==
X-Google-Smtp-Source: ABdhPJwHNy+7LPpOm7ctkCji1Tcq4AcRjEIikvTu1kz7/YLKC8eI9CjqOZHvU2RQsHMC7GRulWD89g==
X-Received: by 2002:a17:90b:1b0b:: with SMTP id nu11mr435607pjb.143.1606782950755;
        Mon, 30 Nov 2020 16:35:50 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id ev12sm70459pjb.22.2020.11.30.16.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 16:35:50 -0800 (PST)
Date:   Mon, 30 Nov 2020 16:35:47 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, Po.Liu@nxp.com,
        toke@toke.dk, dave.taht@gmail.com, edumazet@google.com,
        tahiliani@nitk.edu.in, vtlam@google.com, leon@kernel.org
Subject: Re: [PATCH iproute2-next 2/6] lib: Move print_rate() from tc here;
 modernize
Message-ID: <20201130163547.23a06e79@hermes.local>
In-Reply-To: <f2dd583ef64b64b95571b317c94802ff155ebc5d.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
        <f2dd583ef64b64b95571b317c94802ff155ebc5d.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 23:59:38 +0100
Petr Machata <me@pmachata.org> wrote:

> The functions print_rate() and sprint_rate() are useful for formatting
> rate-like values. The DCB tool would find these useful in the maxrate
> subtool. However, the current interface to these functions uses a global
> variable use_iec as a flag indicating whether 1024- or 1000-based powers
> should be used when formatting the rate value. For general use, a global
> variable is not a great way of passing arguments to a function. Besides, it
> is unlike most other printing functions in that it deals in buffers and
> ignores JSON.
> 
> Therefore make the interface to print_rate() explicit by converting use_iec
> to an ordinary parameter. Since the interface changes anyway, convert it to
> follow the pattern of other json_print functions (except for the
> now-explicit use_iec parameter). Move to json_print.c.
> 
> Add a wrapper to tc, so that all the call sites do not need to repeat the
> use_iec global variable argument, and convert all call sites.
> 
> In q_cake.c, the conversion is not straightforward due to usage of a macro
> that is shared across numerous data types. Simply hand-roll the
> corresponding code, which seems better than making an extra helper for one
> call site.
> 
> Drop sprint_rate() now that everybody just uses print_rate().
> 
> Signed-off-by: Petr Machata <me@pmachata.org>
> ---
>  include/json_print.h | 10 ++++++++++
>  lib/json_print.c     | 32 ++++++++++++++++++++++++++++++++
>  tc/m_police.c        |  9 ++++-----
>  tc/q_cake.c          | 28 ++++++++++++++++------------
>  tc/q_cbq.c           | 14 ++++----------
>  tc/q_fq.c            | 25 +++++++++----------------
>  tc/q_hfsc.c          |  4 ++--
>  tc/q_htb.c           |  4 ++--
>  tc/q_mqprio.c        |  8 ++++----
>  tc/q_netem.c         |  4 +---
>  tc/q_tbf.c           |  7 ++-----
>  tc/tc_util.c         | 37 +++++++------------------------------
>  tc/tc_util.h         |  4 ++--
>  13 files changed, 95 insertions(+), 91 deletions(-)
> 
> diff --git a/include/json_print.h b/include/json_print.h
> index 096a999a4de4..b6c4c0c80833 100644
> --- a/include/json_print.h
> +++ b/include/json_print.h
> @@ -86,4 +86,14 @@ _PRINT_NAME_VALUE_FUNC(uint, unsigned int, u);
>  _PRINT_NAME_VALUE_FUNC(string, const char*, s);
>  #undef _PRINT_NAME_VALUE_FUNC
>  
> +int print_color_rate(bool use_iec, enum output_type t, enum color_attr color,
> +		     const char *key, const char *fmt, unsigned long long rate);
> +
> +static inline int print_rate(bool use_iec, enum output_type t,
> +			     const char *key, const char *fmt,
> +			     unsigned long long rate)
> +{
> +	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
> +}
> +

Overall this looks good, but is there any case where color output
makes sense for this field? If not then why do all the color wrappers.

