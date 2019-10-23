Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2D61E227F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389156AbfJWSaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:30:13 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:42593 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731579AbfJWSaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:30:13 -0400
Received: by mail-pg1-f171.google.com with SMTP id f14so12614175pgi.9
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 11:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EdT1qTSy3oEG6Iz96MfPfmwBEa9WF1hTFGc/Xyv32ZY=;
        b=oHekSrX824VYrZgM6PbT9E4wOEehhV+ejM5hnftDZZrnzPW1EqI25fYrS7x6x4fWlk
         XowgaHBZHr+tVLaLMq2fnQ5XTv+sOjcxeLha6zipGseJZfYlyQkX6ou7kcojWKYglqQK
         bVhXfAOzq4jaXAMqO6heoj9yLbZoHloYXRDUVerqYj0zqo0PCqh+9Zr5Y8HcM+ayKoVt
         CjVgIwuh/TSAkxzOGGKIgW8+YsgY5I0Jqz36PXVvAeEHvhPJCZm+HRm1CfGoWNgUcyC4
         CloXfpoqv3UyeSCnKcTYEYchPo9ixBp5CC01qnZEoMKqgPZ3v4wTg5bVdD9PubHFHNv/
         rPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EdT1qTSy3oEG6Iz96MfPfmwBEa9WF1hTFGc/Xyv32ZY=;
        b=IHK57IVn2RQb6P/ogijM/+Q6yTqRn7A6UbmzOpTsIRTcEkwo/u0I8K7HVha03NHI5x
         /dkM88CpP+Z9JoLe2fb5ipo3jvAX6N/WoJ+hoW+RfWGbA5YGGf/P0+7pNtZmI2usUI9Q
         b5Da/281DvCpcgvSsYsgzMlcuOMl6OgnD8mNhLYhN+JsaOjHsOIuRYeOpYzVoV4oFG56
         2AhKNSkKSGYnfPPJ8sTl8f2NRyBSNx5mrN2L5cai4j5cEwJqRN7hoxb4e7Sq14W6zwmK
         QunRj3POvXHCkJMf/OMpAOcwTdcv2fMUUsVogtzGdK9CIDWftIhoe6ANmQ6bRr0rejjf
         C/Pw==
X-Gm-Message-State: APjAAAVH3G+RempoLo+YuqkGA4MkVEpoDjcTHDJc4bYmU+aSAMyb2ZHz
        8aIoYkG02jpm4UnwSkU+tfzP+xQqRjW0ryXFaVo=
X-Google-Smtp-Source: APXvYqyuDssfAi5GUkFe1MoDlCTXjGd49zilZcrSMcAVVm5IRRFdpxvj/b5OsBx8ajf40NMVVzKUMcr6Ai0gNFmLd9I=
X-Received: by 2002:a17:90a:b78d:: with SMTP id m13mr1797406pjr.70.1571855412495;
 Wed, 23 Oct 2019 11:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191022231051.30770-4-xiyou.wangcong@gmail.com> <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
 <CAM_iQpWxDN7Wm_ar7cStiMnhmmy7RK=BG5k4zwD+K6kbgfPEKw@mail.gmail.com>
 <CANn89i+Q5ucKuEAt6rotf2xwappiMgRwL0Cgmvvnk5adYb-o0w@mail.gmail.com>
 <CAM_iQpWah2M2tG=+eRS86VtjknTiBC42DSwdHB8USpXgRsfWjw@mail.gmail.com> <CANn89iKNAg9gwe-ZLSoknwG6-XS44aRZrEv4pDeiON50uXv-0A@mail.gmail.com>
In-Reply-To: <CANn89iKNAg9gwe-ZLSoknwG6-XS44aRZrEv4pDeiON50uXv-0A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 23 Oct 2019 11:30:01 -0700
Message-ID: <CAM_iQpUyMjdDO9gbrzqS3f3A2LW9dFJRuZfcm=EsJwDAdZdMxA@mail.gmail.com>
Subject: Re: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 11:14 AM Eric Dumazet <edumazet@google.com> wrote:
> > In case you misunderstand, the CPU profiling I used is captured
> > during 256 parallel TCP_STREAM.
>
> When I asked you the workload, you gave me TCP_RR output, not TCP_STREAM :/
>
> "A single netperf TCP_RR could _also_ confirm the improvement:"

I guess you didn't understand what "also" mean? The improvement
can be measured with both TCP_STREAM and TCP_RR, only the
CPU profiling is done with TCP_STREAM.

BTW, I just tested an unpatched kernel on a machine with 64 CPU's,
turning on/off TLP makes no difference there, so this is likely related
to the number of CPU's or hardware configurations. This explains
why you can't reproduce it on your side, so far I can only reproduce
it on one particular hardware platform too, but it is real.

If you need any other information, please let me know.

Thanks.
