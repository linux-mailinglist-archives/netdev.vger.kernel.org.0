Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE333E0421
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbhHDPZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239004AbhHDPZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:25:34 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656E0C06179A
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 08:25:19 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so1994004oti.0
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MkEko+eP/PGh5rhZzM/ZP1ek45RS+C6XNFHuSGRDE64=;
        b=E1cVbgPgKU42fiCfcMytMdN/6hXRzK2/H0/NAj/x7DwnjHkB5F+RJngZts0/ucxBMM
         SWS44zRpozVGPJsy7xSSvajn1+3bSnMY/quZrdA3HpUHxIHv/mhQqfaZsDMy1bhRBjll
         ktb+QAJZ5o0RGCMPiMuQj1+xyzJ2FVeiLIkMfjbwHQZAw5GZmpYVUoGLnDLZJDGikcPc
         +oNUmE3SlA4NvMmfFknpEmvWpTC6x1QrITHE9zhHMdnFV6+GwYoOyGiqTCbsw3nbzFxY
         V+OuI6bgqOHltHIK4ONuF3DsTsTG56NFum6lb8Tt7eT0UVAjRCQQ4L/NFyRjFtEUx6cQ
         +6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MkEko+eP/PGh5rhZzM/ZP1ek45RS+C6XNFHuSGRDE64=;
        b=YGXALefZ4+/2F/gjcQ0TvZsRywoWP2KcqYNAUmNEqoL3EdZtVGAFmZWQEzHYI0SeOD
         inVgGnuZP1oAwKwmahE2+yimBZUQDsdDXCBRlZMnWpKGz+RLooCcjXp5F9eEq2C1KzA9
         8CZGtb7CZPOuIxndSIMyd7qZpvKhICFELVhpvMQ6SxrliVDLH5V8Nw9pXz0xRrm3ZL03
         N2whmRjm0Of9ZXXVkhE2wdzL9G1NXDcT/OpyHG8MmSfRD4aedUH2KlHZD64EBGvjJawD
         YxEWwQAexdPdqxtvAMLboJtSEcDn9Iok7SKW0I6/mzUD61l6gAJnQ2L+NilRD02Q0Kwn
         QmYA==
X-Gm-Message-State: AOAM530eITD0ADKIEIW2qvRB3wSG5nGDs7W1vpAvAlgFWjgv4XwUOIJP
        KRv+xm7A2YAxdCbUdS6qHXw=
X-Google-Smtp-Source: ABdhPJyq6qToX2isKgpXrWhJZRzT/kWeX6htfKRTuIGwNg0Cf7iZcaNtgCFzNmc3NAccheqrHr0sVw==
X-Received: by 2002:a9d:7310:: with SMTP id e16mr176925otk.215.1628090718859;
        Wed, 04 Aug 2021 08:25:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id f23sm384220oou.5.2021.08.04.08.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 08:25:18 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] tc/skbmod: Introduce SKBMOD_F_ECN option
To:     Peilin Ye <yepeilin.cs@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
References: <20210721232053.39077-1-yepeilin.cs@gmail.com>
 <20210802175452.7734-1-yepeilin.cs@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fddc1d80-4d2f-2890-4b46-159f00599943@gmail.com>
Date:   Wed, 4 Aug 2021 09:25:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802175452.7734-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 11:54 AM, Peilin Ye wrote:
> There will be a conflict next time you merge iproute2 into iproute2-next
> because of this commit:
> 
> "tc/skbmod: Remove misinformation about the swap action"
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c06d313d86c1acb8dd72589816301853ff5a4ac4
> 
> Please just ignore its code change since it is now superseded by this v2.

thanks for the heads up about the conflict, but let's not duplicate that
removal in this patch.

I just merged main into next. Please fix up this patch and re-send. In
the future, just ask for a merge in cases like this.
