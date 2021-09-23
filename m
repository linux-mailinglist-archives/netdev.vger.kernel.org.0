Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C31F416072
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhIWOAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241585AbhIWOAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:00:12 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F64DC06175F;
        Thu, 23 Sep 2021 06:58:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l6so4049701plh.9;
        Thu, 23 Sep 2021 06:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dQ8E3Q2MW2Z7vutmUFNwZYSQmicIbTKeivLQcbQesU0=;
        b=ct6hKJttmu6yiOsaHjQjNcuS2q9iC0hRMBp2m0MIsR8BC51/S8EaIuLaOx8VL0eNLf
         sOLnbctL8ctPMfH3SNw4lMztvSyVR98r9YrSnbHVsrIw3py8hA2uL6pKUNmQ/3s/mQ87
         SA9NPw+2YRaJWrSlTwGMUtDHhfCRPA7o2HX9O6oEGZfXlNsNSZPXiu1YMiYr29uZlqQu
         1Kh1A8cu9kenQFT99944iVYIB9ByUHCOEm20mDhI0HB+mY3pcb6LabpRucEG4kPOOB8R
         g/JbUik5PGbtHMWsaMnMP0kZLgyiUUSvABqMFkmljEme32OYC9FNN3AUG9ZxCC+m9SLD
         c3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQ8E3Q2MW2Z7vutmUFNwZYSQmicIbTKeivLQcbQesU0=;
        b=sUcoK5CeUf1tW6X1o6dcR9ybrfiRPAF+gY4+jmp+nBFxAx8NjIABegImgQikbCSe9F
         kgjb3PS3EJ1tSchCAht+SqcqFJ1WPeMTIA5ncgyd9HfghKuVdsXhodxr6sbjIomXtmWx
         3r8yw6Fh36dv1IA1x2NNzrPnYeg8LZeZJ+XKvuwDbWXoYMCHz8m9omjOgslJNW55i2Gw
         6SvZhCp9HzV4anIwJf2nlpebe4A508nJ5WponwE9VwSy9JdPVZ7V+CQ/x+LnCRfOl+rU
         gS1jl9rh2v5Bsj+IXD8flAyA9g2Upl/tdPovf7pO9Dla+ajR0HqR1Bb1tE73bftm9b8E
         sqkQ==
X-Gm-Message-State: AOAM533m4xHF2/WGzGTq84u1gp8DNZx9beaGnpyvgVx0DujvhHP9wqv1
        l7xHpLHUULKTRo4Hq+HFaGY=
X-Google-Smtp-Source: ABdhPJyV9qPubCpR7s9+BmL+zOFcEbtjOIctoJZFlUiPSY+rkgaiDApQHahPoPaD1e5UPo9hW2m/Fw==
X-Received: by 2002:a17:902:7e05:b0:13b:7282:957f with SMTP id b5-20020a1709027e0500b0013b7282957fmr4015079plm.50.1632405520724;
        Thu, 23 Sep 2021 06:58:40 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n9sm8712920pjk.3.2021.09.23.06.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 06:58:40 -0700 (PDT)
Subject: Re: kernel BUG in __pskb_pull_tail
To:     Hao Sun <sunhao.th@gmail.com>, davem@davemloft.net,
        kuba@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
References: <CACkBjsbWBPD5qRBUNsGo0pURPs95sHLBqxf3Ueyqe72iVeLJEw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6837b784-9105-e2f2-252c-f5f7f451f128@gmail.com>
Date:   Thu, 23 Sep 2021 06:58:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsbWBPD5qRBUNsGo0pURPs95sHLBqxf3Ueyqe72iVeLJEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/21 3:51 AM, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 92477dd1faa6 Merge tag 's390-5.15-ebpf-jit-fixes'
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1f2RLLaRmVwV9ffKgoHvMuXGSs-730rdm/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1KgvcM8i_3hQiOL3fUh3JFpYNQM4itvV4/view?usp=sharing
> 
> Sorry, I don't have a reproducer for this crash, hope the symbolized
> report can help.
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> 
>

This has been reported many times and we (Vasily, Jakub, ...) are on it.
A bit slow to review V8 because of LPC conference.


