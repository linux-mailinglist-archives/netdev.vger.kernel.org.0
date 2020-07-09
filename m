Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012B72198B5
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgGIGdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGIGdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:33:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9030C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 23:33:14 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u185so593142pfu.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ASyABw7/LeIWt6xZQU9j/A9LrD0CY3X+I23w3SZ/Ew=;
        b=HyNbU6wF/U+nMNQBiad43bGJm/cZhSok6kxGlDPfmtVHiSdux9Xcwjq/KijpCBG4LS
         rNINr0YwzSuxEfjj/fedS3svhwoZaDvEv32X9gU6mMmqU91asWsqQ4+dvChXBNhWhe2n
         oxGYrEItmY+3BJXANb/UKsqLcTIK+ebrRDgGAwVfoEAuuxqN/efL3VSfe8M+YgdOdN0j
         bLtsRkLAjs1vGotBh1J6Rhr4NZWiR4ee4mFo758hR4dQEY6PLFNvUGKP98sHjRgIzAXI
         41Rocwh84ydTRo8GGcOIRuf1Ru5ie0QWCgVBdpPJEr06oNMlWM3/clHyRK39kIHKbpoL
         3jyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ASyABw7/LeIWt6xZQU9j/A9LrD0CY3X+I23w3SZ/Ew=;
        b=XMadv+9b/ojMrra+Yb56V8ACU1aFWbPhkC5qm/vEcR7cZjqJE5BPBlrAXViWvJ4DCq
         cvvhQ4puZ647aOo9V+Gc0gJjl21pDg52ls3m9L2pj4Qt5nu2T+AW5d+4mE2VEozXbUA3
         /YPaowsFGMXzSE4n5nAHzJQZp5V5FdyX8srw+8SpAVAPihdEAXPqiUX1PBDtu0Gr8UQf
         Ed2yjPRUeL+Ys8PPY+D44Oxb5zdYj8Tlr+q9868lMZHgBIV/mfDERipvnms0Qwe5Viw6
         co4ck8Y9HZ1iruTlCl9IajIZSIAwJoAgq/cEXmYm1JvfC0PnOl7g1dbejdd7tOwrXcyD
         bvgg==
X-Gm-Message-State: AOAM533yq3vPH81Yy6K2CDW909W2Wa/8M7sedXn0BcTPsYFlu3jsx70m
        Rf0QwruTnONI0H+WA4L4OsTqog==
X-Google-Smtp-Source: ABdhPJzcHzc8xHxBHhvEDXpG+k08WluqSHl6CzOiDASFu959kwdWuXIdhl6ClmbP0mB02vGX/vQDAw==
X-Received: by 2002:a05:6a00:14ce:: with SMTP id w14mr58835092pfu.121.1594276394455;
        Wed, 08 Jul 2020 23:33:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k92sm1342645pje.30.2020.07.08.23.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 23:33:14 -0700 (PDT)
Date:   Wed, 8 Jul 2020 23:33:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next v2] iproute2 Support lockless token bucket
 (ltb)
Message-ID: <20200708233305.07b53f8a@hermes.lan>
In-Reply-To: <2a2b2cc9-eeba-4176-198f-fab74ebe4a33@alibaba-inc.com>
References: <2a2b2cc9-eeba-4176-198f-fab74ebe4a33@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Jul 2020 00:38:27 +0800
"YU, Xiangning" <xiangning.yu@alibaba-inc.com> wrote:

> +static int ltb_parse_class_opt(struct qdisc_util *qu, int argc, char **argv,
> +			       struct nlmsghdr *n, const char *dev)
> +{
> +	struct tc_ltb_opt opt;

If you use empty initializer in C it will make everything 0 and save you some pain.

	struct tc_ltb_opt opt = { };


> +		fprintf(f, "rate %s ", sprint_rate(rate64, b1));
> +		fprintf(f, "ceil %s ", sprint_rate(ceil64, b1));
> +		if (show_details) {
> +			fprintf(f, "measured %llu allocated %llu highwater %llu",
> +				lopt->measured, lopt->allocated,
> +				lopt->high_water);


All output has to be in JSON. Any use of fprintf(f, ...) directly
is a indication to me of code that is not supporting JSON correctly.
