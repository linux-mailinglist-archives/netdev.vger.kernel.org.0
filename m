Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94D65FF18C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiJNPlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiJNPkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:40:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F302F180254
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 08:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665762039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2W9qXSAyW3i3z7Il6mhVOG/mGDmVLEb8HCxR9KXZkzI=;
        b=LvBuevDO6wUGS+4j1Yu36moxFu30udlMsGRzlWbh7WJwcV3tMja8Q+IPfpjplbZ4JDfxMR
        wr4JD5+cv9GVVY7Ytsoe3PuvgYqLFjFEoN7vCgGgg6JbHjK9cZ/I0zJiip1IzG6aqg2Pl/
        60j9kDAu4D8Au9dv4EKsS5VO8qHCh78=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-359-mdfrowqnM6eVPU7eHJDMCQ-1; Fri, 14 Oct 2022 11:40:38 -0400
X-MC-Unique: mdfrowqnM6eVPU7eHJDMCQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-3606e54636aso49123097b3.16
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 08:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2W9qXSAyW3i3z7Il6mhVOG/mGDmVLEb8HCxR9KXZkzI=;
        b=6IvZgpCsTKSnIxMakDnByQHS6MFxuFMemu53xAJ0D60M8RHhQ9qCx9PCYJfLGlapy+
         4veQCnklEw2njmYhdgwrCZUiZlb+/U6CMPQTik4tgtYqjMUZS0K2ypprv4ySQHNu63Qk
         jiXh3VbAcPMRSQWBoncuLYZR+7rlSZSudTBB2SKpbvpobrLs9E5EV4QIH8raQGzdpJDd
         lHpZlHpJDqmb7piDAjOC8db4zehA2SwL+oI8o41Q93AsFudb2ottlhfmKwEOMbyOj4Yh
         Cq/gOTbL6Oei1Qb31gFTWpeWsBeEQeI7PByySQKiMm/Vy54ICX0LGkKQo9aPplmXV8aC
         4EqA==
X-Gm-Message-State: ACrzQf01bWJXKXFp+X9zC2jpLd97899qqtduYfG6y3sVqCb1sGJUVD6f
        c6wYarOI8OK57Sqx6jmyiCEl33n+GuhlFrbxlIhcXYU/Eks6A9Q5xfUefwI0fV2t2ci3TOAL1Bw
        WMJ6ENx6BdgEpHuZuReTqRbwWdMEEoPM4
X-Received: by 2002:a81:6355:0:b0:349:ec95:9b4f with SMTP id x82-20020a816355000000b00349ec959b4fmr5036466ywb.117.1665762037691;
        Fri, 14 Oct 2022 08:40:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5wszgLE/baFAJoUPz1LarjMEkEV3m1qgdC/X7WKQPSa6LlHcRXR7rjrhLRD2E/3EYszUQaBzzIxlp0PXuApOw=
X-Received: by 2002:a81:6355:0:b0:349:ec95:9b4f with SMTP id
 x82-20020a816355000000b00349ec959b4fmr5036433ywb.117.1665762037480; Fri, 14
 Oct 2022 08:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <20221013184028.129486-1-leobras@redhat.com> <20221013184028.129486-3-leobras@redhat.com>
 <Y0kejqowLYqHIS43@hirez.programming.kicks-ass.net>
In-Reply-To: <Y0kejqowLYqHIS43@hirez.programming.kicks-ass.net>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Fri, 14 Oct 2022 12:40:26 -0300
Message-ID: <CAJ6HWG4ip+8unQ9DqZ6vk9OVV8g5jhV7EwJxDQ576xyibjQuMA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] sched/isolation: Improve documentation
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 6:03 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Oct 13, 2022 at 03:40:27PM -0300, Leonardo Bras wrote:
>
> > +/* Kernel parameters like nohz_full and isolcpus allow passing cpu numbers
> > + * for disabling housekeeping types.
> > + *
> > + * The functions bellow work the opposite way, by referencing which cpus
> > + * are able to perform the housekeeping type in parameter.
> > + */
>
> So checkpatch should have bitten your head off for this drug-indiced
> comment style :-)

Oh, my bad on this one, I will fix that now.

>
> https://lore.kernel.org/all/CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com/
>

Any comments in the text? Is that correct?

Thanks for the feedback!

Best regards,
Leo

