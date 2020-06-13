Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8081F84ED
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 21:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgFMT3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 15:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgFMT3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 15:29:11 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D92C08C5C2
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 12:29:08 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id h185so5939873pfg.2
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 12:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xo8ytRHA8kMhSzgaf+vcCOJn1UirQ92SScXvh+BCUB4=;
        b=L/1yEubsRWCHrnfgf6xtbij3KIJa1Fnvz53JJOSpVq9YiCmGymxgD3wLQCsX6X63ao
         B0xS48rjEajSoNmCF7d/rhclbk0EPqpV3/tvUf87IC2FAwJp1lsO+GgAUQBbxLbdeZLl
         SbeFjUa3cap1Ju+49TeV9PH48lqJhL6M9fmw9DwdOsJDIBc95U7/Ss2gcHLUUKDJyWGy
         skT6e6GskED9pC/lurdufttvDWSCDJvjoKPuYzCKl8roKwX3jKWDuuoxDfcCezmwJ8gi
         BQu9lTrTlli7icemq5yXKUVEQ4bo9D4QSmUwY+8TnzQy6TewvmTPMDELsCiMQv+ylAEc
         kaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xo8ytRHA8kMhSzgaf+vcCOJn1UirQ92SScXvh+BCUB4=;
        b=SZ534LWCU4HlZnMfDCMOLZc77oBiFkGLGZ9iPj+uj5UmJGd7rq1r8h2TKmh2XYRYjk
         j0VsnZd3GD17UuASjz27DImVPfgFyl2ke2J7eW/+JXEDziV1pLOmNTihuX41ZZpVgz9q
         2vYOGL/KvoBRI0RIipqjmunAijilahqUYn+Uyu7U1IeHXZS1Erqir4A+LUCe1a9Ac0Yy
         Uc+AqN4BNFwFF5tcLNLm0tpoGiaq7oWxboPxI4BEEUTW8rl5TSIREGdqz+JSuGSX73JJ
         /m9ZOQ2m0CRqn7GcCsqOQUTA3zxryhW0gRxytH6BaUbDj82+Esanb5Hplb9uf0I+SXzF
         yhgw==
X-Gm-Message-State: AOAM53347wvPGfI63rFOwsm2dxjOigGFXt5oC0eNQNPnFQrdLlQsCtOG
        GR8MYjgYGayTYkG196Wm2PblJg==
X-Google-Smtp-Source: ABdhPJzK5lBTS6eJJybZBFDFzV+Je4R27TUx1fw5wg2waDHRc1M28kVvD4DdIG4PzGMG6/kz0yy3DQ==
X-Received: by 2002:a62:7f58:: with SMTP id a85mr1385838pfd.89.1592076548331;
        Sat, 13 Jun 2020 12:29:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a10sm8313289pgv.72.2020.06.13.12.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2020 12:29:07 -0700 (PDT)
Date:   Sat, 13 Jun 2020 12:28:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: Re: [RFC,net-next, 2/5] vrf: track associations between VRF devices
 and tables
Message-ID: <20200613122859.4f5e2761@hermes.lan>
In-Reply-To: <20200612164937.5468-3-andrea.mayer@uniroma2.it>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <20200612164937.5468-3-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 18:49:34 +0200
Andrea Mayer <andrea.mayer@uniroma2.it> wrote:

> +	/* shared_tables:
> +	 * count how many distinct tables does not comply with the
> +	 * strict mode requirement.
> +	 * shared_table value must be 0 in order to switch to strict mode.
> +	 *
> +	 * example of evolution of shared_table:
> +	 *                                                        | time
> +	 * add  vrf0 --> table 100        shared_tables = 0       | t0
> +	 * add  vrf1 --> table 101        shared_tables = 0       | t1
> +	 * add  vrf2 --> table 100        shared_tables = 1       | t2
> +	 * add  vrf3 --> table 100        shared_tables = 1       | t3
> +	 * add  vrf4 --> table 101        shared_tables = 2       v t4
> +	 *
> +	 * shared_tables is a "step function" (or "staircase function")
> +	 * and is increased by one when the second vrf is associated to a table
> +	 *
> +	 * at t2, vrf0 and vrf2 are bound to table 100: shared_table = 1.
> +	 *
> +	 * at t3, another dev (vrf3) is bound to the same table 100 but the
> +	 * shared_table counters is still 1.
> +	 * This means that no matter how many new vrfs will register on the
> +	 * table 100, the shared_table will not increase (considering only
> +	 * table 100).
> +	 *
> +	 * at t4, vrf4 is bound to table 101, and shared_table = 2.
> +	 *
> +	 * Looking at the value of shared_tables we can immediately know if
> +	 * the strict_mode can or cannot be enforced. Indeed, strict_mode
> +	 * can be enforced iff shared_table = 0.
> +	 *
> +	 * Conversely, shared_table is decreased when a vrf is de-associated
> +	 * from a table with exactly two associated vrfs.
> +	 */
> +	int shared_tables;

Should this be unsigned?
Should it be a fixed size?
