Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934C32B07BF
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgKLOqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLOqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 09:46:31 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A5AC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 06:46:30 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id b6so6278200wrt.4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 06:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6zx5VG+w350L0aBaDTEjKxbDXvVSoQiFTo4w5SMmtbc=;
        b=MkeDhkcrJsywnKiUs76V44rpJfM8sZUqgACh3odS/U30Z+MUmfoHjA9582c0uLZBEU
         K8L/A/Xkqr2vbSJ7tnXkrBoKDBl101C9x3WSsfCGdQPEBviwAQaJHq4CyQZT7/JjdwQF
         eBzFlT1KaQwyHJsINVMDKRDaHQbjChECOzKKXArMwNvPLaP4CXzJtR66MkmjT5/4MOEX
         Ih+Uwe2tl2QH+4KgG0Bu1HUcZkVo6egB0cZvi0pTTLzXONGPDro3Hqe/1D4JcsCuCERE
         hVyFCmH2DKKr4eq31y7bwcGl1QNlkEC7yO946XkNSOycKqE2KPen17rLM+A3CxTfa21d
         SxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6zx5VG+w350L0aBaDTEjKxbDXvVSoQiFTo4w5SMmtbc=;
        b=tqSJjDyZbven7sNcTKLAJAsPrQ0dJJFeyR91+YUZyPA1qbUalqNiqzuY6vqvVCxwMf
         RKobNUBGKA7BM5ppUUKmarXdpOLJ7fExfG7a1dDAJICG1ZgNAlj/mP6w63yEDIVX8Sog
         A8QgzcT2t0tmL9D4HjCFsAogp1QG8qUXmd8ugCImvv4j0BnLNviV7Ccy6w3lP3V/Rvbk
         8H9aFyCMCVZD3ZNGf6Gy/dRNWLY8cf0eCKSceEowLJI7tO6E04HduHv2ODIPNElMdtZg
         77Zu96hReIj61NEPvOWWO7557wvEsuMyJr3TDguZJKYmOXbU5aafzWaXZHjIuQuphn0f
         EI1w==
X-Gm-Message-State: AOAM531uouv3taioWHxY3CT/IK/EEL+QTM7OdxToV1fOa28DWnC9Q8W4
        Mrb7TUJmRTtft2SGz1TwtUER0Qqi1VE=
X-Google-Smtp-Source: ABdhPJxS7Z8puBcUvJBLEG2pMXoBE6p38jvGympiG4vZ5KCyjxg+MA/Qo4E+K8Q1GsQIqGHY1bdFqw==
X-Received: by 2002:adf:f846:: with SMTP id d6mr19582315wrq.128.1605192389474;
        Thu, 12 Nov 2020 06:46:29 -0800 (PST)
Received: from [192.168.8.114] ([37.173.54.223])
        by smtp.gmail.com with ESMTPSA id c2sm6834793wmf.47.2020.11.12.06.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 06:46:28 -0800 (PST)
Subject: Re: net: fec: rx descriptor ring out of order
To:     Kegl Rohit <keglrohit@gmail.com>,
        David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
 <CAMeyCbhFfdONLEDYtqHxVZ59kBsH6vEaDBsvc5dWRinNY7RSgA@mail.gmail.com>
 <ba3b594f-bfdb-c8d6-ea1e-508040cf0414@gmail.com>
 <a3caa320811d4399808b6185dff79534@AcuMS.aculab.com>
 <CAMeyCbhG7-dCr4bVWP=kNuwLa6CNB9h=SwN_kK7VbJ7YFCY2Ow@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a2659a6b-ce03-6df7-0017-8f49fd502555@gmail.com>
Date:   Thu, 12 Nov 2020 15:46:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAMeyCbhG7-dCr4bVWP=kNuwLa6CNB9h=SwN_kK7VbJ7YFCY2Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/20 12:56 PM, Kegl Rohit wrote:

> Our kernel already has some patches like the wmb() for the rx path and
> the rmb() for the tx path applied.

Well, please do not claim you use 3.10.108 then. :/

Really, there is no point for us trying to guess if one of your local change
went wrong.

I will stop trying to help right there.
