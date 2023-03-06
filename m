Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DD16AC196
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjCFNk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjCFNkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:40:25 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159222B2AE;
        Mon,  6 Mar 2023 05:40:14 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id nf5so6586512qvb.5;
        Mon, 06 Mar 2023 05:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678110013;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CstgUg7aG6yg8aUxm1vyvHuLEgWrP1vADEualkSSvu4=;
        b=ADDjj/pdPi+gfkBe0ZMJXOicEGNZJRP5cVlTKF0nCWuexMOGg+FiY+Bf570/o4hndv
         X7w3i/ct3nJRrxpLXUtDB+LLPh5/Dsf6729pslSY7nMKtGjwqrJrnLH/dV7l/f7W/3IE
         YUMXo+7jLNQesS4eWeda2blK+otJtwispj4S1405QFR+5vWYAw64KOaTSvMBDhsx8qGu
         ejdiKLAtRKebmUXkH1xUARY6aXKnkgL4o4GSg6e3xsBx2sTddsTzn9e8jaK2MmIJt2jr
         pFL2l+Te/rLjX1eWrSnsgYo6HRn2eF/NUpt2/MPxk7V2qnqyE5Xnbu2XJmRUIX33BSvi
         CznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678110013;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CstgUg7aG6yg8aUxm1vyvHuLEgWrP1vADEualkSSvu4=;
        b=qjjV1rrAtLtzCDfZO/43+YItrXqXE+2V7usIqrTPW4QgWywGRJskVUnIUPIcU1V+QH
         2HQfHzdJsuDM8SvGRMlMgKUXlM5KIQAQv+v8aLkvfcR2Ewd1NHH7COpPVzXsJZkfSpdc
         +gd3mqJD0nofXrZDM9eWRnK7Unx5u7UjkCkK6SIIb99WSV/5bZwio8EJk9E0iH5k1HPH
         q0fRSQ3TCiQYuXUXl6p5J/gF1nO93XH4w4ivUJCG0CoQPhqA+SYPpRxR/b4IlXyLNg6i
         lkaPUr0tSr1Qo74orFCTScZat0M/47uSRPLO103jHEGlLy4QvyUthM6K/1LF+ZRpMEZZ
         wspA==
X-Gm-Message-State: AO0yUKXW+/ZcvtpmDpazvI7EgRHRBLfPxJlvFbIhUcC6OF/gFim19l2V
        GDRmHWFwxbQngWogw0BBo0A=
X-Google-Smtp-Source: AK7set8CvsD5p/ueCl2SyiYzUScbeTCRQmhkqPzcx7gHlJrsra0wbvR+GBS8LE+eqk9BHxevatpuPg==
X-Received: by 2002:a05:6214:234d:b0:570:bf43:47a with SMTP id hu13-20020a056214234d00b00570bf43047amr18885831qvb.1.1678110013125;
        Mon, 06 Mar 2023 05:40:13 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 11-20020a37060b000000b00742663a2019sm7492344qkg.76.2023.03.06.05.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 05:40:12 -0800 (PST)
Date:   Mon, 06 Mar 2023 08:40:12 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Alejandro Colomar <alx.manpages@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-man@vger.kernel.org
Cc:     pabeni@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Message-ID: <6405ed3c64fee_b9a692088@willemb.c.googlers.com.notmuch>
In-Reply-To: <c78f6a59-dac4-e5ce-cef6-533ad0cdbcac@gmail.com>
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
 <d204f477-2655-57f6-c44c-cbe15f991933@gmail.com>
 <c78f6a59-dac4-e5ce-cef6-533ad0cdbcac@gmail.com>
Subject: Re: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alejandro Colomar wrote:
> 
> 
> On 3/6/23 14:30, Alejandro Colomar wrote:
> > Hi Willem,
> > 
> > On 3/2/23 16:48, Willem de Bruijn wrote:
> >> From: Willem de Bruijn <willemb@google.com>
> >>
> >> UDP_SEGMENT was added in commit bec1f6f69736
> >> ("udp: generate gso with UDP_SEGMENT")
> >>
> >>     $ git describe --contains bec1f6f69736
> >>     linux/v4.18-rc1~114^2~377^2~8
> >>
> >> Kernel source has example code in tools/testing/selftests/net/udpgso*
> >>
> >> Per https://www.kernel.org/doc/man-pages/patches.html,
> >> "Describe how you obtained the information in your patch":
> >> I am the author of the above commit and follow-ons.
> >>
> >> Signed-off-by: Willem de Bruijn <willemb@google.com>
> >>
> > 
> > It doesn't apply.  Can you please rebase on top of master?
> 
> Oops, sorry, I tried to apply 1/2 twice, instead of 1/2 and 2/2 :-)
> Ignore that.

Great. Thanks for applying, and for fixing up the cmsg references, Alex.
