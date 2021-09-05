Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9326401019
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 16:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhIEOLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 10:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhIEOLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 10:11:45 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A612C061575;
        Sun,  5 Sep 2021 07:10:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so2976295wmq.0;
        Sun, 05 Sep 2021 07:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ESbKLeNsLnxks8j4gUKa9N22AZupbWMMz8A0h0s8pbs=;
        b=aFa/WFKPa8FTj7sMuJX3RV1hGn05T1Ty2QYLB17FTdW70TCep3QGBjksWIOAYhs/Jm
         GUVMlxDE0TfiYgoHn7meKhFo5Yg7pVObLM9c8tVx4LZf16vPqCbzHrvN5WbkpFgtfRA2
         SzatcjoqNVtT8QnCSS4r9J/C7vBe5Vijb6jjrdu7AoeLNVzd0Nf44BKbOc04LM5vUu9b
         KIfm1VQ4/7K/rIME4zQfZMbElpKBJKmgxSDG/0M9IUz4qGtxtTqBFIz0HEP+uPzFW/TH
         xDVdq49t2Oxtqe8O56Gi0v4wnWzRrnBkYya2hiBZNP3eLaR4Wzm0ViiBZFnRnc2jez1R
         yMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESbKLeNsLnxks8j4gUKa9N22AZupbWMMz8A0h0s8pbs=;
        b=LTku1cd6x7uT2iMcxAYMC2xsmYF3Si3jH9uxD2yDeY3NLIdfCxRj7mZkr4VLyOChP/
         6eMOUt1ngeSbGx30viQkAj18UBC02mX3CghLwHuqfYfeJ0Es5oWJqmOOo/erNaEOnge+
         gRS3s0OxGd37gA6tHbM0gh9VFowLRY5n/fR17s0M+Y9fcT0qP+21T4s2TQbMk1/6tJbu
         hTUdgRnzyyrfihwfb39PuQk5i+DNuRYKTo2yN2xr5Q8e0wDa82s1K1HKF/aw4aPjkqBY
         HqwZDhb/h7jl1k1JXf3T+lRMjVVJqAzDhRxrDlum/Ov5lFw1yEKWTdrDo6iQryV6nUTl
         eQQQ==
X-Gm-Message-State: AOAM533tAMGGZVa3MfJzi+j3PYgK34elYWyNvJBiHNm17z0qkQOOiSZ7
        cKLGUFo1sOhQwn++sbxcm0Q=
X-Google-Smtp-Source: ABdhPJyGuae+vRDbUtx/y9ysoOjF8UFtVqRRuiZGTgJhrqqniTg5gQKF3hxLeGC9w5EzIHoCsMIjpw==
X-Received: by 2002:a1c:2705:: with SMTP id n5mr7167229wmn.176.1630851040576;
        Sun, 05 Sep 2021 07:10:40 -0700 (PDT)
Received: from curtine-ThinkPad-P1-Gen-3.Home (bl9-74-29.dsl.telepac.pt. [85.242.74.29])
        by smtp.gmail.com with ESMTPSA id f20sm4602376wmb.32.2021.09.05.07.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 07:10:40 -0700 (PDT)
From:   Eric Curtin <ericcurtin17@gmail.com>
To:     vfedorenko@novek.ru
Cc:     aahringo@redhat.com, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, lsahlber@redhat.com,
        netdev@vger.kernel.org, smfrench@gmail.com, swhiteho@redhat.com
Subject: Re: quic in-kernel implementation?
Date:   Sun,  5 Sep 2021 15:09:31 +0100
Message-Id: <20210905140931.345774-1-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <9ce530f5-cfe7-b1d4-ede6-d88801a769ba@novek.ru>
References: <9ce530f5-cfe7-b1d4-ede6-d88801a769ba@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guys,

Great idea, something I have been hoping to see in the kernel for a
while. How has your implementation been going @Vadim? I'd be interested
in a non-encrypted version of QUIC also in the kernel (may not be
supported in the spec but possible and I think worth having), would be
useful for cases where you don't care about network ossification
protection or data-in-transit encryption, say a trusted local network
where you would prefer the performance and reliability advantages of
going plaintext and you don't want to figure out how to deploy
certififcates. Something that could be used as a straight swap for a
TCP socket.

