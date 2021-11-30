Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9B4462F4F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhK3JNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 04:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhK3JNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 04:13:16 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47DDC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 01:09:57 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id b1-20020a5d6341000000b001901ddd352eso3415381wrw.7
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 01:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W8jbV8uR0irmQJZ7XSBwWnCVGf+O5EBe0lK8t0Ctz0g=;
        b=OalF+pDck24HiZlPvBX5uQQCtALURyBZVdTGythcwDykvLg0kVCdUCSNiKLxTNE4iI
         WEN2y8D+l8ZjcO0UCf1QGJZjkc6s68Xz8sHZcVZaD0cwStdC++TK5bQZMPrYaP0C1W2L
         +R8t3X6SIICqG6MwlP0tUs5MurbEzXbI/X+G66bEWzUiHxxFQHNyEJjA21bV2vbXz8DR
         9eLZDXhPHNedn9jF6CXML4t0peKeD08aSnmL5ao2h7NLa8/hq1ljB8E+v+rT+Ti+wH9i
         Skd8zgICnwoj+Rk8We6C1E6UjNK5vNxt/3M1cHJOFEMY/iOJvSOn93fALjXqxEcAIxLS
         UIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W8jbV8uR0irmQJZ7XSBwWnCVGf+O5EBe0lK8t0Ctz0g=;
        b=PctBMeTmsGcas93n4X2IX5d8Exw4/Gg3ix5etV3I4G+4gijD1+d//S95ifQYi97Om2
         k4AOFPl9QDdnD9PHQ6rFKixpeuLW3+vQjoE9H6yirCg3y2+IecqJ5WryTjZArkyMvQRv
         4zACLW5tPYhfXkgoECTHH7cFa6mgpjXetf6Z9ahy40AZR/klnToPep8jkO8DjFyC2YYG
         BJNSvU+lttB0DT6w4RhGZlSfxzQBQVCsVx+yJfzDhGlvNo9HTVxg7NG6tuBULpj85hLG
         dY+6XcT4CXnFq3HyFTteEQvvr4UWLaq7Lem12/bAO0VeUb4ZNIhlQno2jAiJi+QcF7iz
         tQRA==
X-Gm-Message-State: AOAM533wsninBtu2dN7tiMrEkdOASdbKR0ty/2R3mefnURq8fePtJTuI
        ypc7HaNGyTOYfamhFpEEsfwgZ7mUFf/T
X-Google-Smtp-Source: ABdhPJx352IZmH1efU047AiFh62rid6tJ8SQroycJmeGfa+YuP6PfkVdTheLFbzoL2SqLc5y1wXo0NlFLmUP
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:15:13:1e84:81dc:2c2c:50e2])
 (user=dvyukov job=sendgmr) by 2002:a5d:6d06:: with SMTP id
 e6mr4964384wrq.330.1638263396198; Tue, 30 Nov 2021 01:09:56 -0800 (PST)
Date:   Tue, 30 Nov 2021 10:09:52 +0100
In-Reply-To: <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com>
Message-Id: <20211130090952.4089393-1-dvyukov@google.com>
Mime-Version: 1.0
References: <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
From:   Dmitry Vyukov <dvyukov@google.com>
To:     eric.dumazet@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric, Jakub,

How strongly do you want to make this work w/o KASAN?
I am asking because KASAN will already memorize alloc/free stacks for every
heap object (+ pids + 2 aux stacks with kasan_record_aux_stack()).
So basically we just need to alloc struct list_head and won't need
quarantine/quarantine_avail in ref_tracker_dir.
If there are some refcount bugs, it may be due to a previous use-after-free,
so debugging a refcount bug w/o KASAN may be waste of time.

