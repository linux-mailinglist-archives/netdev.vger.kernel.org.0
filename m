Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB2F5990A3
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiHRWkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241929AbiHRWkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:40:13 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404D3D805C;
        Thu, 18 Aug 2022 15:40:13 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11c9af8dd3eso3032155fac.10;
        Thu, 18 Aug 2022 15:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=2an3KXPew/OqEauIR1CsNmpNXfaK7XRjdWqKYm2SujE=;
        b=cubs4ebu7YGHsevfT6xBOvrOySw1nCcX3bGMQVHcT8rRE3WAebeVaRfdHlcN/H0gAy
         TTwmtKw/OWzPjCJGAf8z/sB9fcq5rEOsXZS3k74ZwAshP+3kGgVlLnIlU6zSZi82Ia2P
         E+ofyozblVMipsx1CJbVno16Q2SRAGdpdY+j6dqhdBQZhYEEENG5iAe9OHOAgVhT5hy4
         Xr0Idw3bkwRk0ZAdhcaJ6gfO7JMzD97vNrrF9CJ8ms2cUhNwjMzJJwGzqVDCdjKc44Aj
         zqG9s9+6Yws2oncUeKrTX0JSW4qm7Nu1HYYKIHwl/+oCSi+gDFECvVGuy0V4+MRAQGvM
         iZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=2an3KXPew/OqEauIR1CsNmpNXfaK7XRjdWqKYm2SujE=;
        b=CE4tmU22MoZp9CWACySkGAX7O2FDXmY2YJbHofqdy4fG/Qi+ULLemtj+DHTeZ1Qefk
         eLpIZwf1g04a/OuMd2t5lKkwuNeiIDQygfk+owYVjgL3B1RbWMss1eTcDfS9BaTwTomH
         UGjPtkk5EPu5wZaPOx/NEDFjk6X1U8u6AU8026e5TyBMqAl8ylcS0/0r/iSkLnxGA2mx
         NlItmTd9U51BQUjM90IpyKTbUJB7/N/sDqujQcmwF8fiozPwaj0tmSofaSo6xKc2gFn1
         EfRUWBo5fH5ngZHTu/5W2Fd2pUG67frP8iSA5/0UBNpPsQeb57HVF9VySx82pydntxGw
         7PYw==
X-Gm-Message-State: ACgBeo3ryUaqlIWNErZvhcfLrV6poyqyEDrSbeMTMYOmBXsPnnK/alA5
        hPmOWWB9WWCg3DwdFVED9Jw=
X-Google-Smtp-Source: AA6agR5sYonHELfFjG9sbNNFEDmx3kLjtWDYD+KlWZBQ8o4jYM/b2rhHvPGdD5xkOibnzoLDC/BUPQ==
X-Received: by 2002:a05:6871:85:b0:fe:29a0:4a2c with SMTP id u5-20020a056871008500b000fe29a04a2cmr5495036oaa.249.1660862412137;
        Thu, 18 Aug 2022 15:40:12 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id t27-20020a0568301e3b00b00636ed80eab8sm724802otr.4.2022.08.18.15.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 15:40:11 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:38:00 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH v2 2/5] cpumask: Introduce for_each_cpu_andnot()
Message-ID: <Yv6/SAj6kQ/UIKvu@yury-laptop>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <20220817175812.671843-3-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817175812.671843-3-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 06:58:09PM +0100, Valentin Schneider wrote:
> for_each_cpu_and() is very convenient as it saves having to allocate a
> temporary cpumask to store the result of cpumask_and(). The same issue
> applies to cpumask_andnot() which doesn't actually need temporary storage
> for iteration purposes.
> 
> Following what has been done for for_each_cpu_and(), introduce
> for_each_cpu_andnot().
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>

I'm concerned that this series doesn't give us real examples and tests
for the new API. If we take it as-is, we'll end up with a dead code for
a while, quite probably for long.

Can you please submit a new code with a real application for the new API?
Alternatively, you can rework some existing code.

Briefly grepping, I found good candidate in a core code: __sched_core_flip(),
and one candidate in arch code: arch/powerpc/kernel/smp.c: update_coregroup_mask.
I believe there are much more.

Regarding the test, I don't think it's strictly necessary to have it as soon as
we'll have real users, but it's always good to backup with tests.

Thanks,
Yury
