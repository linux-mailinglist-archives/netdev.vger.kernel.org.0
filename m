Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667FD6BEE6B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCQQfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjCQQfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:35:10 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FC55615F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:35:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so22635846ede.8
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679070906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwwFe9XoORdWYnr1GggJwexbAEqzdO4e3QsgeG37W0s=;
        b=PSwfDeGmoGf53YXvvbgEBU9SHVCvS2HIXjOztvpHNopnO4YDwtrT/fBntlsqqF5dwq
         sNVHjzRtK44yikjtw4P1lwtC8pHAWeIdWqp1lI9h+8eRplzxtIp+TIheAV5YI+Kp8Mjy
         LFxbbDSmTTPeQRQL4Q4OwYL2whHg3pBW1y5DE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cwwFe9XoORdWYnr1GggJwexbAEqzdO4e3QsgeG37W0s=;
        b=FhvaX2JF3GQ5anAkDmc/zoIqQmtOVLcdZ39VttSQm3PcFfbO7hol+ErWv6UYYPjMTz
         fuej91okpKR5WSDzy0Hwc7lKRp8DTwdfa89xRwFHK5nCYGBQgvWQ65o9L1IP30jl0qcY
         tfl+q3WjnRTBaK7+J3lGMVZ5enGR0Ikl9lTNRI7Z7k2YEIJBmHjyfhPf8NslU+DYJgwQ
         uwkRmsbghFndrzr1YPKFVf2+ND4LKUZLWyEiQ+qe5+/szG9RidBtJX6CQycKzSmHQH7Z
         /oSiQBYsqa1qZ5t7be6fxbiemlSVKdgmiAWBn7H1HnvYSGjUf8OlwifACP4Ki04NjzsZ
         Ywbg==
X-Gm-Message-State: AO0yUKUSvIdQ/2AEbcTPAn407aqbv+u0rAHP0vsfxnQTBU1+RbAeHUqg
        sqVAnf8Lt7u/c2CGjiDRf9Vd3Mxk8xc+KY6+wDR3Cw==
X-Google-Smtp-Source: AK7set+cs6GDrJ3KsU5Sn3jJwVozgNJ2crRM60wKX/ZpKwwj4WJ72P8ffdqWA6ZhV8L0uxwgfmjb9Q==
X-Received: by 2002:a17:907:d389:b0:84d:4e4f:1f85 with SMTP id vh9-20020a170907d38900b0084d4e4f1f85mr16758670ejc.59.1679070906624;
        Fri, 17 Mar 2023 09:35:06 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id g5-20020a170906394500b0092fb818127dsm1158310eje.94.2023.03.17.09.35.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:35:04 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id eg48so22547470edb.13
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:35:03 -0700 (PDT)
X-Received: by 2002:a17:907:a40e:b0:8b0:7e1d:f6fa with SMTP id
 sg14-20020a170907a40e00b008b07e1df6famr7325815ejc.15.1679070902628; Fri, 17
 Mar 2023 09:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230317053152.2232639-1-kuba@kernel.org> <20230317093129.697d2d6d@kernel.org>
In-Reply-To: <20230317093129.697d2d6d@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 Mar 2023 09:34:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgxEH_4v3wBJJqJJsR7dWqh-xdRLW=CrbPK+bYZ-RN1Sw@mail.gmail.com>
Message-ID: <CAHk-=wgxEH_4v3wBJJqJJsR7dWqh-xdRLW=CrbPK+bYZ-RN1Sw@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.3-rc3
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 9:31=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Sorry, please drop this one if it's not a hassle. I'll send a v2.

No problem. Dropped.

                 Linus
