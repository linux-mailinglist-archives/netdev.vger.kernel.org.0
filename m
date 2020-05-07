Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08E91C8702
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEGKhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726467AbgEGKhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:37:11 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A7EC061A41
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 03:37:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x4so5911331wmj.1
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 03:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xNBtuAL7sLh2yugT8pt2RsLeMgaeOsR548PH1XS3X6g=;
        b=P0KfJJ2qYaO4hu3V0dqbKoJ7dM+loGZAH1bCy+sHSfup2mRckyEjMwF5JVzCNrvjv2
         6bEYWYZcMWrJbFy5RRMTh3yKlfakziWN3X6/YIvAwFeZAwviQjHOv+J4hFlUiO7Tq2qu
         6iKGdO/lMzv+CAH1wB1lGUMHe+lzFDPuXM8e8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xNBtuAL7sLh2yugT8pt2RsLeMgaeOsR548PH1XS3X6g=;
        b=ks2cw39RlqgeAbkGurxpfdmhnr0EjRdo7E1u9yu581LvkOrv1xODKebrXI8KuhRg34
         yBBF4nrGxw5jJywE9WrThWotPWQ9QhAqlWRhixjkp+aZ1Oi+dBaXIg9HBsa66NfE+zvP
         qMC/lKyUAsQPWz0ArEokdMa6eXsB2JwaJ9k2W1IeTZ57PUIFRSI27gVDR0xQ/15CmAZ/
         jygExAJjX47MkgTCz+m18PNv98YJDh+yELSwMhzWhMlJ4KxOdE/4BngMHv4XKFscuACj
         JAJoNn8Y/Cs63J4yQEYipTgkjFhMAim4rpEcXYQ+bU3qg6mhD/iOiVJ7D5ykVHssJ8D8
         AB0w==
X-Gm-Message-State: AGi0PuaKNn1fIrFDFaaCBgVW5so/z8cb9D7RUFrTW6N5efI2lbqyGj/B
        TGaeKdJFHU6KiG6BEan4NB/xhw==
X-Google-Smtp-Source: APiQypIabltafW3/eC3x1JpuisQ2nUoG7QPWZfnJB8iw3zmE2kMllxRUxoU4syaP7VYg2F7ChffWwQ==
X-Received: by 2002:a1c:3985:: with SMTP id g127mr9861780wma.102.1588847829813;
        Thu, 07 May 2020 03:37:09 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e9sm3081094wrv.83.2020.05.07.03.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:37:09 -0700 (PDT)
Date:   Thu, 7 May 2020 12:37:07 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     lmb@cloudflare.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org
Subject: Re: [bpf-next PATCH 00/10] bpf: selftests, test_sockmap
 improvements
Message-ID: <20200507123707.4b4a0fe1@toad>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 May 2020 13:49:36 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Update test_sockmap to add ktls tests and in the process make output
> easier to understand and reduce overall runtime significantly. Before
> this series test_sockmap did a poor job of tracking sent bytes causing
> the recv thread to wait for a timeout even though all expected bytes
> had been received. Doing this many times causes significant delays.
> Further, we did many redundant tests because the send/recv test we used
> was not specific to the parameters we were testing. For example testing
> a failure case that always fails many times with different send sizes
> is mostly useless. If the test condition catches 10B in the kernel code
> testing 100B, 1kB, 4kB, and so on is just noise.
> 
> The main motivation for this is to add ktls tests, the last patch. Until
> now I have been running these locally but we haven't had them checked in
> to selftests. And finally I'm hoping to get these pushed into the libbpf
> test infrastructure so we can get more testing. For that to work we need
> ability to white and blacklist tests based on kernel features so we add
> that here as well.
> 
> The new output looks like this broken into test groups with subtest
> counters,
> 
>  $ time sudo ./test_sockmap
>  # 1/ 6  sockmap:txmsg test passthrough:OK
>  # 2/ 6  sockmap:txmsg test redirect:OK
>  ...
>  #22/ 1 sockhash:txmsg test push/pop data:OK
>  Pass: 22 Fail: 0
> 
>  real    0m9.790s
>  user    0m0.093s
>  sys     0m7.318s
> 
> The old output printed individual subtest and was rather noisy
> 
>  $ time sudo ./test_sockmap
>  [TEST 0]: (1, 1, 1, sendmsg, pass,): PASS
>  ...
>  [TEST 823]: (16, 1, 100, sendpage, ... ,pop (1599,1609),): PASS
>  Summary: 824 PASSED 0 FAILED 
> 
>  real    0m56.761s
>  user    0m0.455s
>  sys     0m31.757s
> 
> So we are able to reduce time from ~56s to ~10s. To recover older more
> verbose output simply run with --verbose option. To whitelist and
> blacklist tests use the new --whitelist and --blacklist flags added. For
> example to run cork sockhash tests but only ones that don't have a receive
> hang (used to test negative cases) we could do,
> 
>  $ ./test_sockmap --whitelist="cork" --blacklist="sockmap,hang"
> 
> ---

These are very nice improvements so thanks for putting time into it.

I run these whenever I touch sockmap, and they do currently take long to
run, especially on 1 vCPU (which sometimes catches interesting bugs).

I've also ran before into the CLI quirks you've ironed out, like having
to pass path to cgroup to get verbose output.

Feel free to add my:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
