Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1065E670B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiIVP12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiIVP11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:27:27 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055FEF275E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:27:27 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id jm5so8118378plb.13
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=7BXEMVJesmzOR2yUt5WbUjJFb5AL5aagqfi32GjxN1w=;
        b=BP5MGKx5OMvYPmjrhRmu97hO5Ny85TmirhE/xO0/5zBGfkqeoBXNHoJ8UhBPowes7Y
         6WI8WCABxSjY0htSvGowExyFtLskOHq2rrXcxW0FnaWx0oi7G/y/0HcLrlNNZw2Y5WXV
         78PhxgvmAvp8EEykW/lFUVy4OStgOtUC0uqi00CskEG9DA3pV5wlKXFCrkDKxm0r2Ric
         fUeoproW4MJ6FJMDkB5A+UQfire8vg462479+PVO7KByP4W6ruE+FNmNjfkknOUIQh0C
         NgGABAZtOykEkjms4DWYZ9fbFyYW1iY387K8v+ylmkbZd/Po3UkZnkzkf5Pg741CCh5n
         uY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7BXEMVJesmzOR2yUt5WbUjJFb5AL5aagqfi32GjxN1w=;
        b=5AcFjM2uFM+UZParQisThXQI+e1TTGT26bRuUhQiBvCxo/RwVJWHrmg+g0HPn72OeZ
         J3+fLgxsQB+f/vdSAbnGYVfW0byneTcc/1lZHT6KkkRMrQGRuexbTP6aAPYQX0D4dm9j
         xGZddVXE9r/Y7uYG50Xca9VuPVyufb/6mmyDEy2w7naOcar80kqm9t/8QtCuttCD+tM4
         JvJHfiPh1SQPvK8Bfiu8COABj0L19YdbRMxdWseZjvoejUyMb08mEYGBUZwICS9imiP8
         6vg64m0sUIAx2uZNwK6NM3XgQBOn7gogIVHKx0FgvhPmRqVIajcWEBv/cb8HPEwM2ydH
         oYlQ==
X-Gm-Message-State: ACrzQf0JLFMjW2+y1lsrdLon9vSifPCMo9jumLVmGk+joolqf3rWsjmd
        NShEOiI0NIcyskc7H5N3HPMVjQ==
X-Google-Smtp-Source: AMsMyM4Boi6XIY88yBeZTjvGicJT1ufLyOCLf3iNjJ2/tX1w/DVT+/MXOGVh6eJ5gj23gIFCPRjQDA==
X-Received: by 2002:a17:90b:4ad1:b0:202:5f15:39fa with SMTP id mh17-20020a17090b4ad100b002025f1539famr15503627pjb.19.1663860446515;
        Thu, 22 Sep 2022 08:27:26 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902e88700b0017685f53537sm4257356plg.186.2022.09.22.08.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:27:26 -0700 (PDT)
Date:   Thu, 22 Sep 2022 08:27:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220922082724.7abb328a@hermes.local>
In-Reply-To: <20220922062405.15837cfe@kernel.org>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
        <20220921154107.61399763@hermes.local>
        <Yyu6w8Ovq2/aqzBc@lunn.ch>
        <20220922062405.15837cfe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 06:24:05 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 22 Sep 2022 03:30:43 +0200 Andrew Lunn wrote:
> > Looking at these, none really fit the concept of what the master
> > interface is.
> > 
> > slave is also used quite a lot within DSA, but we can probably use
> > user in place of that, it is already somewhat used as a synonym within
> > DSA terminology.
> > 
> > Do you have any more recommendations for something which pairs with
> > user.   
> 
> cpu-ifc? via?

I did look at the Switch Abstraction Layer document which
started at Microsoft for Sonic and is now part of Open Compute.

Didn't see anything there. The 802 spec uses words like
aggregator port etc.
