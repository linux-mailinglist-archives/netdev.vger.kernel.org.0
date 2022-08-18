Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A150D598C52
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343987AbiHRTEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiHRTEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:04:41 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2BC8A1FC;
        Thu, 18 Aug 2022 12:04:39 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id l18so1841442qvt.13;
        Thu, 18 Aug 2022 12:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nX5kZmoj9p73LSdvjfbhbZUq4ZnpvLi6/MC0mtc9D0M=;
        b=oqibi37FPnZI3Pu0tNhInuUW8/oJVzWJD3X2LCD/7fjFR8WD6b6d6XmqWVEIZS9rEn
         Yke7v/D2Pk5cu0PJpVxN6GGdQt45ChetQv1AqfDjv4B5N7eHme8oIROn3XQCzZvRjcKK
         9v10gxPr8MnGlVZe6ylFL5XGzIzSbsxyyihCmsL6J5lmkepwcFC51QB1GjntU8baoECZ
         KwLOcF1EFIlwRyo9ek0dqwjHrXF67/rrv+jPmNHNIWaCXi949yYW3pnLdRSpwTB3Te39
         9VJDmCbnug/2rmZdysP6psMO2QFl/yWpMX8msM1jWnSUXYf11z7aMBwV3GhmvyISAnN/
         CsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nX5kZmoj9p73LSdvjfbhbZUq4ZnpvLi6/MC0mtc9D0M=;
        b=6W0DH/FLbDmxMEJOeVIHcCRfmc4xrtx018BJrNU+6yPG3H6aj1C72tS+HwoO9uxdLW
         AOMsxF7qJpV+8vQjxYE9cO7cFXRnufCtdAcJIS7zPgVUn4dVr2Vq0yBwRjQ5v4+4Yxno
         SK2JwGzmrz2O7vckwWbW1gDj3ftsTkFETNssGtN6XXOdLd+yBaof73n42HJbm1MckbEu
         bCTtCkblQV/wa/dF3QXTcWaWeF1zyVm7L4l2jGOR0motn2PVE22+0+n7i2GSonV2Meus
         px1unzgQ6uWBGdw/28rbyu0BJiiz9XhDmXTWbr7oJ0U2ArhzedCNwcdRSiLHI0A/XI1l
         UzBg==
X-Gm-Message-State: ACgBeo05gJ3PpHiTwqQQ6sWeATUU3+5mylVfgg3zlP8OzePvxjPkBqVK
        9sBDnfR3WopPd6rcEqsUISmDgi6gJqScWOI6xM8=
X-Google-Smtp-Source: AA6agR6fKUEhV/fg8HheOm3MKcS51tDj4hrn3SawVAOKe5szVEnjJq37JG0WrPnyLbK2yKpifS5kr3wELkD+/zj0cWU=
X-Received: by 2002:a05:6214:d07:b0:476:c32f:f4f4 with SMTP id
 7-20020a0562140d0700b00476c32ff4f4mr3782049qvh.11.1660849478391; Thu, 18 Aug
 2022 12:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220817175812.671843-1-vschneid@redhat.com> <20220817175812.671843-2-vschneid@redhat.com>
 <20220818100820.3b45808b@gandalf.local.home> <xhsmh35dtbjr0.mognet@vschneid.remote.csb>
 <20220818130041.5b7c955f@gandalf.local.home>
In-Reply-To: <20220818130041.5b7c955f@gandalf.local.home>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 18 Aug 2022 22:04:01 +0300
Message-ID: <CAHp75VcaSwfy7kOm_d28-87QKQ5KPB69=X=Z9OYUzJJKwRCSmQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] bitops: Introduce find_next_andnot_bit()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Valentin Schneider <vschneid@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 8:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 18 Aug 2022 17:26:43 +0100
> Valentin Schneider <vschneid@redhat.com> wrote:
>
> > How about:
>
> >
> >   find the next set bit in (*addr1 & ~*addr2)
>
> I understand the above better. But to convert that into English, we could
> say:
>
>
>   Find the next bit in *addr1 excluding all the bits in *addr2.
>
> or
>
>   Find the next bit in *addr1 that is not set in *addr2.

With this explanation I'm wondering how different this is to
bitmap_bitremap(), with adjusting to using an inverted mask. If they
have something in common, perhaps make them in the same namespace with
similar naming convention?

-- 
With Best Regards,
Andy Shevchenko
