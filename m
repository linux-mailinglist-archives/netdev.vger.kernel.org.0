Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD4C361410
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbhDOVXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbhDOVXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:23:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F119CC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 14:23:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso8129022pjg.2
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ol39MDmb57HD+IRDbZnz3tkRIQCMuTQn6jcSnc5bPg=;
        b=SfS3IiSloic6QZRvpsnQjfaVJP7MTti/bV3UOapaMJdwcbqpQbi+eYWiH5JIVe5Rxb
         P3KBHb6wCkJgCWAFpUpZofWOVyAD1CCcoFVe7IBz6e3SNPyPpY1Gx2yWLULuQfhPmwIf
         RYDyrSb7dDK/Y3x7ddqyANGby9dIAwcGfKFZaxGGzVNC0S5/bdoNbc8+dZLc3QVJO/xj
         355mcgj3SqZqf38sM+r51qcaTMqyd25BHb8TIyN7kZMwZnvGsWzY2cPRgdmjMYsm7aBq
         yHJ3jKhUBJjPLhxlwM78KRre0oSshALAJnfVFHCYXLdI1rpqK8IkOpeYzSSfBBmuT/ro
         Bd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ol39MDmb57HD+IRDbZnz3tkRIQCMuTQn6jcSnc5bPg=;
        b=JPtDAw27FrZk6+dADdXZ+QvVzyLyHLv0blcId2L14rl6LlJ7DdiG2KNjDFlLpU7mwl
         lxf+dQwqgaxfFj8ArcvS4jNqBEwIN7jPtmHzgGkGrk4ZpZBdddEbJA8epWv/kOJDeMGZ
         U+gjvt0eTVKjLP+aj9SkeZQBNxdqf74z2eMrsp5KQM/yVfQFt5cVPtLaLMGAnzPaXGOP
         gysGO/leZejwTaLIUq+gxuwNSCHl5eKmFxSe1rGDF4N2rWEFxKoxbWJrgAtmb14UhRmK
         wlesSngPRiI+9Gcr/ULdH2ih+aeiReZmKTG1JSgjjzsd7PWPkqQlJSNbH7xqhWoy+8FS
         f3hg==
X-Gm-Message-State: AOAM532GackApNudHKiMHH0AIsrUii81wuWn20+g1tVKXl6TxWYqmelp
        Bdk9bu5EOUVNCgs+A1HiF0i7CQ==
X-Google-Smtp-Source: ABdhPJxfZzbT+tzq4qRcJZb4c6Yb5z9oOz2XdKOg+LX46iPKdrM3p6ZRt/5rALLjHbhOfohTlzgaOQ==
X-Received: by 2002:a17:90a:ad84:: with SMTP id s4mr5816599pjq.153.1618521801411;
        Thu, 15 Apr 2021 14:23:21 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id l35sm3004836pgm.10.2021.04.15.14.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 14:23:21 -0700 (PDT)
Date:   Thu, 15 Apr 2021 14:23:11 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [RFC iproute2-next v2] seg6: add counters support for SRv6
 Behaviors
Message-ID: <20210415142311.4e43a637@hermes.local>
In-Reply-To: <20210415180643.3511-1-paolo.lungaroni@uniroma2.it>
References: <20210415180643.3511-1-paolo.lungaroni@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 20:06:43 +0200
Paolo Lungaroni <paolo.lungaroni@uniroma2.it> wrote:

> +	if (is_json_context())
> +		open_json_object("stats64");
> +
> +	if (tb[SEG6_LOCAL_CNT_PACKETS]) {
> +		packets = rta_getattr_u64(tb[SEG6_LOCAL_CNT_PACKETS]);
> +		if (is_json_context()) {
> +			print_u64(PRINT_JSON, "packets", NULL, packets);
> +		} else {
> +			print_string(PRINT_FP, NULL, "%s ", "packets");
> +			print_num(fp, 1, packets);
> +		}
> +	}
> +
> +	if (tb[SEG6_LOCAL_CNT_BYTES]) {
> +		bytes = rta_getattr_u64(tb[SEG6_LOCAL_CNT_BYTES]);
> +		if (is_json_context()) {
> +			print_u64(PRINT_JSON, "bytes", NULL, bytes);
> +		} else {
> +			print_string(PRINT_FP, NULL, "%s ", "bytes");
> +			print_num(fp, 1, bytes);
> +		}
> +	}
> +
> +	if (tb[SEG6_LOCAL_CNT_ERRORS]) {
> +		errors = rta_getattr_u64(tb[SEG6_LOCAL_CNT_ERRORS]);
> +		if (is_json_context()) {
> +			print_u64(PRINT_JSON, "errors", NULL, errors);
> +		} else {
> +			print_string(PRINT_FP, NULL, "%s ", "errors");
> +			print_num(fp, 1, errors);
> +		}
> +	}
> +
> +	if (is_json_context())
> +		close_json_object();


The code would be cleaner with doing if (is_json_context()) once at outer loop.
See print_vf_stats64.
