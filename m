Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1AB364785
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240273AbhDSPzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbhDSPzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:55:11 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A57DC061763
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 08:54:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u11so14538722pjr.0
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 08:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=duJja9qFhlLlL4LoMtIl+yX5xYury+ylhpHbGAhwQ0E=;
        b=G8/9mwR4HBm33TlMKNDcLg7l0iEfmhU/hK6X1LNe9e9REFm/Qi9PKIrp9oGFy9l7ux
         vauYRNGylEbGUJ1XaZSgyEsT3T6ODaksjQ2kvcPCHZHByqbIU4mX3wU1elNBY5+JT+CZ
         q21r1UMZZCLZ0hsT+lY1AargK9RsqF+31a6laA/tHSN9+jisRN1qEjiBAqZ9XAuF4bKD
         Q8hBU3qppYwQ2EXRfPg0Ek8PYyijqUkploPPwtsxVY8/R7d+1uFH3yO7E4Rq6UbF1pCt
         HFHrSpHsKgn0kZ6tEJePImDdZr/TQg+2XTgxsgpWxhmYxoVH/GUJlp2TgrwiUBxD1+o/
         jZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=duJja9qFhlLlL4LoMtIl+yX5xYury+ylhpHbGAhwQ0E=;
        b=X5ViasrWm77hX01Vvq+VUFquj2Drh9WWwv5Ud7n66fUAYT6ukUtHG/Bu4n2XqeQVSd
         FTOmKtdjLNZoA8BAgSbWObfm7E1Bic/f64DBm8EqpUCuzCramP0Ck+oqKKWSygPNG0sf
         rires+z/268mnEE0cDnKvm1hWySdUekI1xVUgkaMW2trdFuBN5a+IPvV0nDKQHV2occs
         i4x0JcMnV1j1KVL5a997QqFEd6O9WFEqpuzLw1QlGhYgECtLKGN/10xiKT1GkWlVrWGR
         h29vpZDdDEIWp4Qm0hvhrWo0KtYrDQofRHIEbRLl7tBR6wQJiibJ7FCqAdKIr9SAMNcG
         9lvQ==
X-Gm-Message-State: AOAM530lBCwkxgFqaWkqUsmERn1NlEoJ7JyC9KMo3hSngFJdFwssWErw
        YEuG8B50CLUKGLcYh2Mzw3fn8w==
X-Google-Smtp-Source: ABdhPJxavXAzGEe58BWYzw5ZEc+NmTGqB0zbhnZu7c0BbJ44Vw9Wn3xtMJZMf5MruH2tejQDyUlvhA==
X-Received: by 2002:a17:902:e8d5:b029:e6:cabb:d07 with SMTP id v21-20020a170902e8d5b02900e6cabb0d07mr23765754plg.3.1618847680830;
        Mon, 19 Apr 2021 08:54:40 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id l22sm15346572pjc.13.2021.04.19.08.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:54:40 -0700 (PDT)
Date:   Mon, 19 Apr 2021 08:54:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org, leon@kernel.org,
        andrew@lunn.ch, bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v8 net-next 2/2] net: mana: Add a driver for Microsoft
 Azure Network Adapter (MANA)
Message-ID: <20210419085437.081fcffb@hermes.local>
In-Reply-To: <20210416201159.25807-3-decui@microsoft.com>
References: <20210416201159.25807-1-decui@microsoft.com>
        <20210416201159.25807-3-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 13:11:59 -0700
Dexuan Cui <decui@microsoft.com> wrote:

> Add a VF driver for Microsoft Azure Network Adapter (MANA) that will be
> available in the future.
> 
> Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Co-developed-by: Shachar Raindel <shacharr@microsoft.com>
> Signed-off-by: Shachar Raindel <shacharr@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
