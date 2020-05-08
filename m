Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD661CB2DB
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgEHPbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgEHPbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:31:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCFCC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:31:47 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q7so1933732qkf.3
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 08:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNqvoYYRnTYqOUWPuygDgES37vmYEhoFVoiOHHlEWQ0=;
        b=tbtuOX1l9vd+TS/UTRrjo30/ntUCwwqvZLFVNSxlPIQe2qnJo9BvdEkHB2NTWGDd1E
         EEP67dayOQY2X49egVlhdPX5U4WLHV1EYx/0rbayts4JV2YmxYdgu668qnZFUoefhaJO
         GO7VTkvR+L0N0VVpJRXHehsLjt/9pGWeM+oyfr1/KpswzjW4Okl3Kv0dmGnTD43vTain
         8Ki9mOxBsDo4aAxP4V/Sg9MAXTwhLfoHHpfu5Wj4/dN3lzaDIspoHRg3Qk1Qo0FPe8oz
         pjTV9amPbYgRbYjf59omZ4daL/nBDSj3YVm5jiWAQ6utA/hvaMC4wMCQmxsT0hXabIDL
         BnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNqvoYYRnTYqOUWPuygDgES37vmYEhoFVoiOHHlEWQ0=;
        b=GbujPiHSAipRunLxJkkcKkxnlelI2O9oZFNnqcSlwNUNC5v3MTacte9HtfMxb2icAi
         xoTl50eyfiTfslX34vr1n5jRWx8JrNUgSrcRHlaS50Z819C/k85l7Qf1zYybGC9Qt2hS
         g/UluuMQT7u5r5t9eNCmvoATCfp6i/Jgt2EvyPJ8003x4FLGTU7AEKsFtmhQbpS33HVw
         PYKCtqElknJ5Vf1zBUR7eQWb/Njm/1clOIVLvdsOKFqOjjPtNFz9FAYOUXUk4jloLWNo
         +culMXw5rGisO0xMUO+kXLAg9qB9Ilqfrcpe7/64TaURyQoDAr+0GpkhJ2a0i7VhqCrx
         KpyQ==
X-Gm-Message-State: AGi0PuZrPDxm/524jUoilSIdRDcHLMEBqjywXJHLhQI+EEwz/ltrqFjg
        +zY/aHl8dEJSK2Oo7Ap1Zydxzk37
X-Google-Smtp-Source: APiQypKvONGlew+T52GB2xkzDNP9p2plh9bDMbLx7O+AZj30OdEUcilSiRZ0wPsoHjszrzkHKYPM5Q==
X-Received: by 2002:ae9:e418:: with SMTP id q24mr3242169qkc.69.1588951906613;
        Fri, 08 May 2020 08:31:46 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id b126sm1361096qkc.119.2020.05.08.08.31.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 08:31:45 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id c2so1123895ybi.7
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 08:31:44 -0700 (PDT)
X-Received: by 2002:a25:b841:: with SMTP id b1mr5688225ybm.492.1588951904191;
 Fri, 08 May 2020 08:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
 <20200508142309.11292-1-kelly@onechronos.com> <ec871922-bf92-32cf-c004-846974eed947@gmail.com>
 <CACSApvaWRxgx_Q1ku=vXbArZc5EJHWhLhCQbzH0+-R3Pzmcf+A@mail.gmail.com>
In-Reply-To: <CACSApvaWRxgx_Q1ku=vXbArZc5EJHWhLhCQbzH0+-R3Pzmcf+A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 8 May 2020 11:31:07 -0400
X-Gmail-Original-Message-ID: <CA+FuTSchhmY90pd1cdjUpaX+RE20L5QsTLM=9mpYNp1uTJgajA@mail.gmail.com>
Message-ID: <CA+FuTSchhmY90pd1cdjUpaX+RE20L5QsTLM=9mpYNp1uTJgajA@mail.gmail.com>
Subject: Re: [PATCH v3] net: tcp: fix rx timestamp behavior for tcp_recvmsg
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kelly Littlepage <kelly@onechronos.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Iris Liu <iris@onechronos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Mike Maloney <maloney@google.com>,
        netdev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 10:58 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> On Fri, May 8, 2020 at 10:45 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 5/8/20 7:23 AM, Kelly Littlepage wrote:
> > > The stated intent of the original commit is to is to "return the timestamp
> > > corresponding to the highest sequence number data returned." The current
> > > implementation returns the timestamp for the last byte of the last fully
> > > read skb, which is not necessarily the last byte in the recv buffer. This
> > > patch converts behavior to the original definition, and to the behavior of
> > > the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
> > > SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
> > > behavior.
> > >
> > > Fixes: 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
> > > Co-developed-by: Iris Liu <iris@onechronos.com>
> > > Signed-off-by: Iris Liu <iris@onechronos.com>
> > > Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
> > > ---
> > > Reverted to the original subject line
> >
> >
> > SGTM, thanks.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Willem de Bruijn <willemb@google.com>
