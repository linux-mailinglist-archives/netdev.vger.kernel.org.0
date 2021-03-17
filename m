Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3197133ECDE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCQJTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhCQJTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:19:38 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35644C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:19:38 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id c131so39770348ybf.7
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=CB64RjoeHkWbTbDmEpLfvASKJ5TMh/DWmIC435xLH08=;
        b=AODRkfyrsOYmZtEbczfwohNLWiKtfGZwG8sO2U4gBS/cjnEETeTr9pfyALU/pn5lNV
         TC4f/1qB7QEzxuvjM4ZILvKyHns20chIwr3vqzqpNCk1LLEGjhiNkwmrMXzAcXA7Nism
         zwu/42RXi2/httLGT5hlAmYYN0J8HcVZ18gx+OouqqulC/PKBlQD0oSYSi5LY/jBldHY
         O74oY677VTMrNyBqKPFegPWQNEi7r4k8fQpLL22jBOclKixeunbzwiVGPXvjOMfZxo9k
         JdR0LIgNCc0dpm3FRYy0+5DAHIaINlas5M1eiW1fb5pKvwxAubI+upV66Ojcskr+Mkl+
         OPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CB64RjoeHkWbTbDmEpLfvASKJ5TMh/DWmIC435xLH08=;
        b=GcqYmlkbK1Ons3P4EtkBYnwPaWqLlU9Pq3HtJ/uXcQbBLRVHm7i9GCXxFI9G6G34OQ
         OiSDcjxs2j/1vUV0QhVoIC3N0P4KtppvA+m/WRwesltN937hXJL2lZ7ndpc6wFW6t5bs
         pKDPJwVFLKEkx86ly7Mwa0IArRbeuB8FmvwWfR8XhnW2nUwkwSUrKxgknJAIguI4FSER
         AvsJo4r01wf2jtGuMfPrquSgaoavNDqEp7AF7RCxZdSXdxdKPpiEGjMfory6EgwbDo3p
         nfZqSWBXazsC19YXO9Gm6an6D0gUiri0+asiRfV9aBOdTb0pfvKpKTWqn2mZSz3ILt/4
         bmeQ==
X-Gm-Message-State: AOAM533XNSpbaXREUwLM6IB/pvBx83qfFBDZZb12YpFxdUc14hHzEPWA
        iRVTzDlapleOVAhIgVx3j1LHkICCG0z+nbBIepxM3nvjgWFlBzle
X-Google-Smtp-Source: ABdhPJx4NsW2UdZgolGdMMnGjB7XKfpqP5gJoF4zvlk2C6NwxblzSkFrabGkZ5HQqIOSOaQmyDJQ/bBIAo89BOHdqZY=
X-Received: by 2002:a25:b682:: with SMTP id s2mr3116791ybj.407.1615972777398;
 Wed, 17 Mar 2021 02:19:37 -0700 (PDT)
MIME-Version: 1.0
From:   Belisko Marek <marek.belisko@gmail.com>
Date:   Wed, 17 Mar 2021 10:19:26 +0100
Message-ID: <CAAfyv37z0ny=JGsRrVwkzoOd3RNb_j-rQii65a0e2+KMt-YM3A@mail.gmail.com>
Subject: set mtu size broken for dwmac-sun8i
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm hunting an issue when setting mtu failed for dwmac-sun8i driver.
Basically adding more debug shows that in stmmac_change_mtu
tx_fifo_size is 0 and in this case EINVAL is reported. Isaw there was
fix for similar driver dwmac-sunxi driver by:
806fd188ce2a4f8b587e83e73c478e6484fbfa55

IIRC dwmac-sun8i should get tx and rx fifo size from dma but seems
it's not the case. I'm using 5.4 kernel LTS release. Any ideas?

Thanks and BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
