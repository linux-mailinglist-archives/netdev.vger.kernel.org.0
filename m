Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6AA386FA3
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346146AbhERBw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhERBw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:52:57 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FCAC061573;
        Mon, 17 May 2021 18:51:40 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so7288153otp.11;
        Mon, 17 May 2021 18:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ebYii6yxZdGOE9fNuJlx8HcBbxNiPlHJSbNeKrp7/gU=;
        b=KRmwnG3rT7gt4wgZ/nt+alRYkn1unPJSYxUJiaq/it10Epf53H8+7Cmd/szDA0NQRZ
         JzHnwYJ1rBulCwOGnpYpdFzll0jqHf7E+BVyp9baf5QAL2DPFFETJv8Ho0xip05o0Szf
         pA/5mxATNH7XF2Oq7k1ZbqeNQnzRDhs244FB+Nvz1fBtLoP+5w9xGrdnVfysp+QuNRAH
         9yALnrqOhqevAwZu3w3pmOhML4R37vbS/NgpEuXEycemQ4l1CQdQksEdMjyK1HA2zWkQ
         63yCAfoEO5e3AuRhR9vlQKor1zJ191AoTl//XrDdjitJkWv6GfVpTrTzBYWppjqNClXK
         xWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ebYii6yxZdGOE9fNuJlx8HcBbxNiPlHJSbNeKrp7/gU=;
        b=BlGx/5mZZHOUQwORrQfnrJyDVoo7RuYbce6iiETbzXBG1zLVhiFWsytS2HuSz9xRIj
         siWNyWLuOGh5879iR6DiPnVdWv/KU7dfVZ8SXkmSfHF7b8cOzqUTtLJElwnc0Xs/otny
         MU9//ux76mtZBMqVRoms5ZpjYVeuUDXSCyRUuLiQQGX7QCYys77l6+xE4NRvXaKqo55V
         RGMObK55mUB/ZJ2DFQYw+obUK9nSFXf9z6kmjvLJzC+QTM0PsYwJlbZfw0Vkq/Kqe4fU
         K2+7vP3wT/1duDbJCJ77U8W4OD3oug+G8F+yKgXUprsaIG88MR/WNwZdoDe0UEwSXG/q
         uc+g==
X-Gm-Message-State: AOAM532tO1Rg/Ccbn85zDfXpjs3jWeG2CcE4YITW79KAyC0qBNeuvE1s
        svzCCaP6MptGcBGuEweUNkCHkel8AY7IpQ==
X-Google-Smtp-Source: ABdhPJz1TTEcXuEQIF2YAPTFKrCaYNeJjVmrZCQG8iVCGXoip/wF3eh2p5IC4ZgEpjHbVjo8swUrrQ==
X-Received: by 2002:a9d:5e8c:: with SMTP id f12mr2152646otl.18.1621302699518;
        Mon, 17 May 2021 18:51:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id u27sm3453304oof.38.2021.05.17.18.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:51:39 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Petr Vorel <petr.vorel@gmail.com>
Cc:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
 <fcd869bc-50c8-8e31-73d4-3eb4034ff116@gmail.com> <YKKprl2ukkR7Djv+@pevik>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <800a8d8d-e3f0-d052-ece4-f49188ceb6c6@gmail.com>
Date:   Mon, 17 May 2021 19:51:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKKprl2ukkR7Djv+@pevik>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 11:36 AM, Petr Vorel wrote:
> I guess, it'll be merged to regular iproute2 in next merge window (for 5.14).
> 

Let's see how things go over the 5.13 dev cycle. If no problems, maybe
Stephen can merge this one and the config change to main before the release.
