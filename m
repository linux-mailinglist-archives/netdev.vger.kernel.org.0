Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5203EEF26
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbhHQP2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhHQP2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 11:28:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07566C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:27:44 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c4so9050626plh.7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HsdIQbU/3hjUWvwAm2oNJ/3VUhF0ItMLeX+m/3GrXoY=;
        b=h5fnCmXuDXzV3rh9AHCiekkvE2KSWlZsa617ysm71TYjiJEuKaQyV3QtJIfAH7K89r
         ixq5CNlTsVrBEB9oJ3ua/H0m1SLE95dGTjYPrCtEObV35+C90PP3EmbgJlgafAMcFP06
         5Xb7No/lrAtp+XU7U9GLdxAXHruuTP5Je5S/YvR/NpC2VvVZ/jn1p2ooqMwGFyqZB0+2
         /WsUE2oBpqJLZAFNc6oAQUZcVPfE8O1vRp55agSMloKj/iHe1kMyj7DFNhrvC6WyoCfC
         /BmZ+O+Jrp8Rfu/FfcEaba68JM0bvyDZam0bth7hmxjzJrvpm+VbFaQ68YK/AbIiqbXr
         mMsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HsdIQbU/3hjUWvwAm2oNJ/3VUhF0ItMLeX+m/3GrXoY=;
        b=lGdZ+yw+fAA/Wctz0nsHLEytYFuuUGKGKt6cGckx8zVcMzB94Jlb7FLkkDs3dw7V93
         4hzlTFv9jktCfFxTNBi8fq1BcluXL5r1PkPkRw+bTxInAWzfgKOae20XJAejw/PFaeju
         DBn86liCtmuhVZvtUf7deYVHZv6f7WTK2G0oR0CTDsgzBlkAyDgYrcVYLrKDa+HvOO64
         dyUPqpt7yqRe3RykkgWn8sVP6D5G0QRrt628M5MJ6m/1oD6GWdUsfTUvVKCF7B5eSgnX
         g8wP/aMC1oF8tGqQI8wNRTT2xg1XqloKGAuv/+HmWinr9QF7vVAfHKojY0+YWQ6bhL3D
         Qv1A==
X-Gm-Message-State: AOAM5306wXvNyiea9nIN9Ax948IAmT6JIMwPK47sSLvuUfPFAt6SHG0L
        A+oJRMarOyy+q/24LD0P0vA5sg==
X-Google-Smtp-Source: ABdhPJxQNqaxJdC7sK1hcKEnCs/Sm8yQNgB5gIA2JHBzvCRISlRCQd8gjCPcvdGrKbju0RN/RJPcHQ==
X-Received: by 2002:a17:90a:a42:: with SMTP id o60mr4224230pjo.191.1629214063524;
        Tue, 17 Aug 2021 08:27:43 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id s26sm3444444pgv.46.2021.08.17.08.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 08:27:43 -0700 (PDT)
Date:   Tue, 17 Aug 2021 08:27:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Gokul Sivakumar <gokulkumar792@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next v2 2/3] bridge: fdb: don't colorize the
 "dev" & "dst" keywords in "bridge -c fdb"
Message-ID: <20210817082740.6be97031@hermes.local>
In-Reply-To: <20210814184727.2405108-3-gokulkumar792@gmail.com>
References: <20210814184727.2405108-1-gokulkumar792@gmail.com>
        <20210814184727.2405108-3-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Aug 2021 00:17:26 +0530
Gokul Sivakumar <gokulkumar792@gmail.com> wrote:

> +		if (!is_json_context())
> +			print_string(PRINT_FP, NULL, "dev ", NULL);

Why not the check for is_json_context is unnecessary here.
That is what PRINT_FP does.
