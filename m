Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36752801F4
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437056AbfHBUsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:48:35 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45182 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbfHBUsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 16:48:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so55914474qkj.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 13:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3C1N+8al+z8dckErSeTZDQFc+/4xHZvV9/+jO4kOCfo=;
        b=JPEpRufvssNWF/1v71nFs+nw36s4b9uY7mUZ/LP6aS2+JTo5zker4G64kMupkuFseK
         9xBItysnnMzDNPq10elghZCv69jFFf2c23E9rqm2fTBwMVyBrtvzw1OXxLBp887Yu7W0
         44DiNeCYJRieM48RUpletoBlwI3AjHLaM0VWD4nmm7d2QpmIhhTe1pLIPXowExWi7EvT
         4QbOdcfCAfH4KFaiuqs7LUPumSqNU6J4Bwi70bAlLW/7REUls0SjfFH9Z7m5efS5B+Il
         DGYKy54IbzQTAQKp0vSdfhHdo7bfGnlVRbM3NZRCNPkDoNHp2kjjsbgvS9zHuCotQFNK
         Ufog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3C1N+8al+z8dckErSeTZDQFc+/4xHZvV9/+jO4kOCfo=;
        b=PfqMuAUoeIPFVyn0C9me1/VynbehSdZiDgaLNwnM8rLFnHlsa65np4CSddxcqeUEZ0
         ZQT9JidMOQZcXSZ0LDcVSCrQzqamyaaUWW6ymSNcJcidmaO+wSKNw8ls5Yz19Lg9y9Bz
         RFKcU0jVd7FnSZYHZZ/rOXYBr3Cb/tFTuw5nxynoxwterb3CPJab3BGw1BLLdxDRYSlX
         tNU+gLKwJV8uZYQVOOaDu5LRIGDRBtDoksQ7rEGafp6No6sa+rC9G1+ORurnts1XJIEc
         /mqf3o+rsinmWDJbmhWxrtgrnB366PIix0gmFgqJvkbNGNHXtEMZHXDy6wiiQCVwkttk
         +0Sw==
X-Gm-Message-State: APjAAAWW+mGgnb3mf71DyYrPeg00YfAP0ZfZKDUgdz8CCR/eQjs/jOop
        ZsKOWPLkupa/LiZVQ0kXwHy3IhrO5zA=
X-Google-Smtp-Source: APXvYqzGwSNqjTCo+ua02rFB8itAsSzhYGKzDBv0Ients45tjeJ2c4CZCeqGolM7S6kNr6rktyJM8w==
X-Received: by 2002:a05:620a:705:: with SMTP id 5mr32923371qkc.330.1564778914410;
        Fri, 02 Aug 2019 13:48:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j19sm29957359qtq.94.2019.08.02.13.48.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 13:48:34 -0700 (PDT)
Date:   Fri, 2 Aug 2019 13:48:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com, wenxu@ucloud.cn,
        gerlitz.or@gmail.com, paulb@mellanox.com
Subject: Re: [PATCH net-next 0/3,v2] flow_offload hardware priority fixes
Message-ID: <20190802134816.05ccbac6@cakuba.netronome.com>
In-Reply-To: <20190802132846.3067-1-pablo@netfilter.org>
References: <20190802132846.3067-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Aug 2019 15:28:43 +0200, Pablo Neira Ayuso wrote:
> v2: address Jakub comments to not use the netfilter basechain
>     priority for this mapping.

Hardly.
