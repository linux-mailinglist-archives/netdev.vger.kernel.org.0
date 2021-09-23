Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A58416003
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhIWNft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241486AbhIWNfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 09:35:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E70C061768
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 06:34:09 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id y89so13026378ede.2
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 06:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mKBdQkxQIOMeRRADD+iGZvqKnqiJ6RXJ6xVlw9Ze2F0=;
        b=K5BdS0Z8/xGyZ8RaYMdMKcc7tEPyLYF35P9RXkc6RkY8NcDkVzvHf8f3ZbazcrPomu
         U/H7jky86HVy7L2Q2M+Ixo3oZySI6017vEg80wWQBnKk0H+ozufeXxoL5yaLOltZGBm9
         iNVs21dUAHI0IKusRk/2WR3R/a9xH5JpItnkWNmJx6wE8gGki31XCk6sj66e1liwkCop
         7xVlnGq/b00yyFBkN7vqCdyeyjm/ILcYxSVgFnLrJpvyU7hOL3J9nl2sZKAsFWdDsESd
         wePicuxEldARKXAxtaJEDl2NVirGOCY4sa7iqAQeyDueoV18sVIMHf/f8xTCQoTlCYWj
         6cbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mKBdQkxQIOMeRRADD+iGZvqKnqiJ6RXJ6xVlw9Ze2F0=;
        b=2s/MzzVRtMMnidc5WDfEyw7BLjn4JyZTQmfI/VzxPzPmcWuUXXys6m8FTTlzRYpN++
         gZvbY7SFaS0MyJAWsTShtBUE5EPKP7aXokgUDQdsbH0l6j9xHPGOZwm9qsDPftwpyoOe
         W0MQUQdH8DOQeRwum7KyT88SnC/n0nbXNNzeC39k2bMa5by/uuuIALoqtOViY5iMRoaP
         t/btzfCui8v76pbtlMUrUv9ZeLcHOGXUkHMnJ2OfArayyVW8SYcsvzYq7XK4pJ08wA1B
         u1D2r9zmW+vNq8CJo7iaHGZ7zKdgIPBp4nwNAy+QQW5AEUKIxkRkcrCG4LVyAWtwhq9l
         TgPQ==
X-Gm-Message-State: AOAM531Z6j5tpkrZdGGlSb+MrQIhhxZ+zSxh4lpl6a5yIIOR1gCi4pFV
        ijkt1ZbfwwCUOJiqFwfAf/f9rvATNi7rAMz9hvtzXu06q3C0vXhmgH4=
X-Google-Smtp-Source: ABdhPJx2uNnEdysW+Sa6TWajKuZA+GBpKAXau42+cXhbjYlawD1laVhiVq8nc9P8vPgUQwq3r0xdkcAe0EB3jgX9UwU=
X-Received: by 2002:a50:e081:: with SMTP id f1mr5594341edl.65.1632404048208;
 Thu, 23 Sep 2021 06:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev> <20210916200041.810-3-felipe@expertise.dev>
 <YUuTKVdtAV73OjVu@t14s.localdomain>
In-Reply-To: <YUuTKVdtAV73OjVu@t14s.localdomain>
From:   Felipe Magno de Almeida <felipe@sipanda.io>
Date:   Thu, 23 Sep 2021 10:33:57 -0300
Message-ID: <CAAPEopiv8pUHkHgh=WzkEyS-ZNxMnywxpDNLcdZDwTk9YYpyUQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 2/2] net/sched: Add flower2 packet classifier
 based on flower and PANDA parser
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        boris.sukholitko@broadcom.com, vadym.kochan@plvision.eu,
        ilya.lifshits@broadcom.com, vladbu@nvidia.com, idosch@idosch.org,
        paulb@nvidia.com, dcaratti@redhat.com, amritha.nambiar@intel.com,
        sridhar.samudrala@intel.com, Tom Herbert <tom@sipanda.io>,
        Pedro Tammela <pctammela@mojatatu.com>, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marcelo,

On Wed, Sep 22, 2021 at 7:32 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Sep 16, 2021 at 05:00:41PM -0300, Felipe Magno de Almeida wrote:
> > +int fl2_panda_parse(struct sk_buff *skb, struct fl2_flow_key* frame)
> > +{
> > +     int err;
> > +     struct panda_parser_big_metadata_one mdata;
> > +     void *data;
> > +     size_t pktlen;
> > +
> > +     memset(&mdata, 0, sizeof(mdata.panda_data));
> > +     memcpy(&mdata.frame, frame, sizeof(struct fl2_flow_key));
> > +
> > +     err = skb_linearize(skb);
>
> Oh ow. Hopefully this is just for the RFC?

Yes, this is just for the RFC. Our focus was showing how PANDA
can easily replace flow dissector by using a useful and complex
use-case (flower) and extending it easily. A proper submission
would not linearize, but first we need feedback on how this
submission should look like.

Kind regards,
--
Felipe Magno de Almeida
Developer @ SiPanda
Owner @ Expertise Solutions
www: https://expertise.dev
phone: +55 48 9 9681.0157
LinkedIn: in/felipealmeida
