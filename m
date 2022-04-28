Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0644513C2C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 21:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351465AbiD1TlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 15:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351459AbiD1TlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 15:41:18 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE44B6477
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 12:38:01 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id y19so8021188ljd.4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 12:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PviecKSNBQ9rvt14y/CLlsqQGaNe4zDSNifKgF5FE5c=;
        b=Mk/ZjIgpPO7ZjCxNJRE5W4RfcBcM9U03fLAGiHpSCx9OJwTUlKZlQFlhx+wLCTDfvD
         n4Pe7ckjUJ9CJogJ2um0a73RMV3NqhLe0fs6B+hSn1dc7FUEAtYSuVxnqaDMDdOOkmNV
         MfsNo4pco1mgdD+H5I5Vudi9U/F1WunaiWSOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PviecKSNBQ9rvt14y/CLlsqQGaNe4zDSNifKgF5FE5c=;
        b=He866YfZQYuK4vjhWGuZKtmJTlV7D0Vx5SX4vSSgiHLRLMjChXjJhfd3wDRfWuUF5v
         YN8Duhl83KvtTmBXqR7C+3WEMwrDmwysrdwmGolf+DB0YwYD6Gi7TCsUrMWL0PosPIWh
         0+2kmfs4Xz8VJgn8ukIu5lWQr0l764Jj+IWJAG42MDPTJQMZ+ZFOKj3aSXJ/weiiXr+A
         c2QNtGPHuemk/sTBoJ9fErCc75mBhsI2GTRXRJmpLrUuYZsQO9E/W/V20y1iBDrOsI6n
         GHYE60ZVsbOGQqHriW+rHSpbHcSnuWF0y26qwQS+USIJajqJuAdf8E1IG9D3Vlx7y5/1
         ykVA==
X-Gm-Message-State: AOAM530BDY592Ue73VhW07e6cE/MWEAcvwxg0KeuCAIF9o+qEKzMIg4O
        M8ECgceZbZQ1ZLkt3ofrxQltunGuNmO6a3SB92U=
X-Google-Smtp-Source: ABdhPJwFmdn8CJDVucolOgRig5A6cXmm5cyMPI5YlCyqefpm9Pi0e5UUp7JlzMAgeo4HOtDeIrFoQQ==
X-Received: by 2002:a05:651c:985:b0:24d:c36e:f600 with SMTP id b5-20020a05651c098500b0024dc36ef600mr22996411ljq.339.1651174679311;
        Thu, 28 Apr 2022 12:37:59 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id k5-20020a196f05000000b00472035deb89sm78797lfc.1.2022.04.28.12.37.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 12:37:57 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id w1so10436273lfa.4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 12:37:57 -0700 (PDT)
X-Received: by 2002:ac2:4203:0:b0:448:8053:d402 with SMTP id
 y3-20020ac24203000000b004488053d402mr24901401lfh.687.1651174677085; Thu, 28
 Apr 2022 12:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220428182554.2138218-1-kuba@kernel.org>
In-Reply-To: <20220428182554.2138218-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 Apr 2022 12:37:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wivb9faQ6Xuwfiqr6r1uHaR4a-i2oi6u142tWDppS-+gg@mail.gmail.com>
Message-ID: <CAHk-=wivb9faQ6Xuwfiqr6r1uHaR4a-i2oi6u142tWDppS-+gg@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.18-rc5
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 11:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Misc:
>
>  - add Eric Dumazet to networking maintainers

He wasn't already? Strange.

            Linus
