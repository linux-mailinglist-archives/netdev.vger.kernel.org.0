Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42BF215E86
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgGFShs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729788AbgGFShr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:37:47 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3D7C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:37:47 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a14so12739262pfi.2
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2FZeY64QcbfaGtbTW+KwgE5AZJ3OZwfFimhViA6SZ1o=;
        b=BojvYEehmI3rHolkbG1AEXmolSraVyI/DbWNQFgIIlfXe9UsiAmd3xNBeHMd7Su0xO
         BqpDqQpeNYg/nTQQSQrF9TNqQTlmmiRNXQQDxu8AFN2dVjR7ms1AgWGLWzE3Z3lEXCTV
         7ma0p+xHb/aetJGnZvbw+QkTzN5+0cwmaZ38cRx6TycXpKhjh5UmMxkm6KDMAq1JQWIf
         eNO/JoIJScqfyjuwAsYdtPGuRILTmooI2HU4pCWGNh8un4DUFd6QH99/qA+fb1dOb0C4
         Xndf4K8A4bg9XGyAbY8N4RRYJzP9B/mL4yKwVeGtIQq3wm/KaP1D8FeC7qOVxEWS+Gt6
         UScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2FZeY64QcbfaGtbTW+KwgE5AZJ3OZwfFimhViA6SZ1o=;
        b=fQ9gwGzcyP6VGDkYHozfkT5U39L41WX6KznKqZujUyvx0tDVOsMYQ7g3cdPCCTEgJ+
         8FfZ5+R+N36G9nPHAt7Z05JEZOSqvil/8rXvqd2ZHTRWfeXHRYxPdmLuhtweB69cYqZ2
         L6UrZIGyfI6qKmixBIyz4M73oT5sNK86X04KuDvKcthlbFjno/oim9zd5r2Xuhs6vqFX
         8nScXajDc3I25P+HupYBvPBXIsiN5PvU7miHvHANZDrnZDWwYHiWl6/AdWUfEMFP6DZJ
         sjvPVzKzBgOzTKdmlqlQsrAk+pBdjM4IZ76pbxWAjrCXjGXYrD4z4gU11GUhsuRzQ7bE
         2ekw==
X-Gm-Message-State: AOAM530WmLV9EDnsF0xkkX843u46xhblX6W5jimyFhhZiqH5c0NiITrd
        Az4w8M26ThGP3PbTt5JrEcag8w==
X-Google-Smtp-Source: ABdhPJwddne+S2xUtkp7lS6wQmPKYCe2kiYrBU/Ycgkyvek690Ip+ew9wjygaUxmxn7Rv26uSBGcqg==
X-Received: by 2002:a63:6c49:: with SMTP id h70mr41230850pgc.150.1594060666694;
        Mon, 06 Jul 2020 11:37:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f3sm157939pju.54.2020.07.06.11.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:37:46 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:37:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
Message-ID: <20200706113738.5a5fdf7d@hermes.lan>
In-Reply-To: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jul 2020 02:08:13 +0800
"YU, Xiangning" <xiangning.yu@alibaba-inc.com> wrote:

> +static inline int ltb_drain(struct ltb_class *cl)
> +{
> +	typeof(&cl->drain_queue) queue;
> +	struct sk_buff *skb;
> +	int npkts, bytes;
> +	unsigned long now = NOW();
> +	int cpu;
> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
> +	struct ltb_pcpu_sched *pcpu_q;
> +	s64 timestamp;
> +	bool need_watchdog = false;
> +	struct cpumask cpumask;
> +
> +	npkts = 0;
> +	bytes = 0;

It would be safer to use unsigned int for npkts and bytes.
These should never be negative.
