Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4634E1BEFC7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgD3FeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3FeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:34:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E76C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:34:12 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s8so2247900pgq.1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cksbbpKZVYHV/B1fLCyz7Z2qd92ih/346Nvk+vNILFs=;
        b=c/lE4UWwdwYJ8JJF1q5suq2KPUONp2hoDFXYpM4DsVcKbuY4DM9SiTbTDJxkvBDFbo
         yR8AZtAUJethBPYugOQRQ7UHXd2aqqg7vW2fpZrnXjUkdORw6bXYMI2rKdNsLB7ruLEM
         sg+YZtHnxO0II1ysxz9N0kEvIXVZHtFB8SGfWzWNvw28mz/L1MsBk8r5SccCNeWzCnZP
         kMGPD6YAECtUV6DJUphtRFFjen3A5iXzpifLj3DQH16ajNrOSP/CO02DNg/O2HrMwtSO
         q10OHhSwPTxiXdALmBwjOlFUGcyk3XDXSFxTkIohcaJxvMCw+YT3jjZEutVgnpJoURTg
         BphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cksbbpKZVYHV/B1fLCyz7Z2qd92ih/346Nvk+vNILFs=;
        b=sxElCKWAbMq59max/eDihiGhIJFuPWg373ypfloSPr0pWLejoWTmGUhjAtSsKbsvqb
         NOTu9yYyf45K16IH2AwywA/7nmnhTORZth7TR2sqZJm1cTP8z47raE9pjPEZloVQrmG3
         NTFYg1R4jpqlWjh3GUkhaLkfvuFWI/dlO+T47CmpbYMWLLKO7Xp02DqAv3GGXw+zqtn/
         vskuCpsUjlPr8qdjKR4Qrgr7emX5oiAq3hyKlKh9xAyK8wvs2BmhtFHEW8T0P28IZrfI
         ad7PtgLSRNOwqAKSiELMtc/63IBh3RqRGI5G7Top7sfoQp77LZccYCvxJ0IqsIMBrAld
         Hpnw==
X-Gm-Message-State: AGi0Pua39cMfEFHnDGuQg/4BDvusr4r0CLu6/KFSDtQuQSN9bd2qqNnJ
        PphH9lmImlpJmqDYJGXKfm87Sg==
X-Google-Smtp-Source: APiQypL2I3i3YKfR8EmgYnkY6FdsRRsT8T9+mXh79YDzsXfP7tMwzxiz8uAJwyCQdLn7AQudXOXPkw==
X-Received: by 2002:a62:75d1:: with SMTP id q200mr1813564pfc.238.1588224852018;
        Wed, 29 Apr 2020 22:34:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t9sm1976526pge.21.2020.04.29.22.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 22:34:11 -0700 (PDT)
Date:   Wed, 29 Apr 2020 22:33:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH iproute2] tc: fq_codel: add drop_batch parameter
Message-ID: <20200429223348.13c91068@hermes.lan>
In-Reply-To: <20200427175155.227178-1-edumazet@google.com>
References: <20200427175155.227178-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 10:51:55 -0700
Eric Dumazet <edumazet@google.com> wrote:

> Commit 9d18562a2278 ("fq_codel: add batch ability to fq_codel_drop()")
> added the new TCA_FQ_CODEL_DROP_BATCH_SIZE parameter, set by default to 64.
> 
> Add to tc command the ability to get/set the drop_batch
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Both fq and fq_codel batch applied.
