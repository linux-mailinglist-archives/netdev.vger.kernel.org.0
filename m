Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0655F25C832
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgICRnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICRnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:43:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14337C061244;
        Thu,  3 Sep 2020 10:43:50 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t16so3559401ilf.13;
        Thu, 03 Sep 2020 10:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vYFQYSTb/+17+Uuu6516MdUuM986Y6u14DKyOKGcWYc=;
        b=lDIe7CF5KDUMWGocKm7G/UyV8gRmhYQGDRCGTIRYgdBTWVP2fg0DSI64zyl1Yz3HkQ
         zZWprpbGlgiLAhJ0Cj/FVEMcDQDo/2a/18ft6tpgWCivMWuEFKVIqqsQm45BWgLsVAAg
         VO+5qHy5uw0D4m8fLee46jmvFtq4FsPhV3wicZevOT+Fylc1KSGW2ZbYn3KqWl4kQq+3
         9zj4maCKAJ1vxn1TTIM7yKmFX9ofN+p7Rzhxc6EzLUkZLn7v7q2V5eVpCZjtggAOw8q2
         ZJ+irFc04GnA1cr4U17yqm8gbatsuwQwuJ0F9KGkn+WPyT9+ZfB4OwLNPIFn5V1d+nXG
         TKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vYFQYSTb/+17+Uuu6516MdUuM986Y6u14DKyOKGcWYc=;
        b=p4zqLcCpNrTQ8Qv8JtieTmdGvgOHxe5o8RIkhyF2yyu1tVLN4VflDpnpd8cqmurb/z
         LEu435feT4dci3RlIH+YtniFmhthwS5ryLMBe5Uglqez+nvPg69CIx7ZWNOO9jVLxg1D
         BIMdnJVp81SDd1znP2ZaMp6sYn8HBMOJyf8EvfQqCxrLnluabI9Iz5efepUR6sIlTQPi
         VYqwNkHxJK7ZSsWeIvkYtH5RKaShGF0CzzRyHMpLnQHcaBfz6T1xAenvRmg2DdVppGHG
         g4yimHJsZ/IqOt9PBYlAnEk9syZMJiMD6EC0l8iVEHKy2saH+PSrEtMAKItV93Uxfr7Y
         urOw==
X-Gm-Message-State: AOAM530FWGaTzbpPl+zpbpOUjPlMdHixnb/oHeGodeAc3LOrctMeD7Uc
        JIJARrHUmMb1AFftTOCVV1oVIwcmxpnNqhceyw4=
X-Google-Smtp-Source: ABdhPJx0zkJhJo3i54QacP+Oa+oDBL1udk+DNdAoRc0FIBWni3OthGQzgu/4UVLEGNHGQu1+46yOMMXqiGNlx9lWZKk=
X-Received: by 2002:a92:9145:: with SMTP id t66mr4170348ild.305.1599155030104;
 Thu, 03 Sep 2020 10:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com> <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
In-Reply-To: <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 3 Sep 2020 10:43:38 -0700
Message-ID: <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 1:40 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2020-09-02 at 22:01 -0700, Cong Wang wrote:
> > Can you test the attached one-line fix? I think we are overthinking,
> > probably all
> > we need here is a busy wait.
>
> I think that will solve, but I also think that will kill NOLOCK
> performances due to really increased contention.

Yeah, we somehow end up with more locks (seqlock, skb array lock)
for lockless qdisc. What an irony... ;)

>
> At this point I fear we could consider reverting the NOLOCK stuff.
> I personally would hate doing so, but it looks like NOLOCK benefits are
> outweighed by its issues.

I agree, NOLOCK brings more pains than gains. There are many race
conditions hidden in generic qdisc layer, another one is enqueue vs.
reset which is being discussed in another thread.

Thanks.
