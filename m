Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EAF57BBD4
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiGTQtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiGTQtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:49:32 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8156043E6B;
        Wed, 20 Jul 2022 09:49:31 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id v28so12530753qkg.13;
        Wed, 20 Jul 2022 09:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IdX8x8KuGDrmo8OdGWM+s2IhO+yiRKLdL7Zo2PMSFN4=;
        b=fA5ACjYebGmyEbnpk02ZADGgZyXfWD24l6R1c/JewiQtUFSI+d/VO9w9T9n2DLJCQL
         uDHO6rwgTDLos9QvjWc6uIFsSu2vb5u2IkHWlFs8aJhQFN905lEkcykvEsUEg7CFx1la
         paGTn68cRr5oM9979v5iJMWGeYVFK48gHFQYJgGqX34fdeYgMtseWc3hbipbm46vtoyf
         t/nVdVBlhdE/sYfEJWwn21va2JYE9h3LwLkJQv+s9PszAUimQvBLaAOikOs6KkgnyGnm
         4Rdc8QIncAZkw37fTFY3vGGoGGWsjBHbV4NlO7IcfMAMJVRtdkE8lvHUm65n7q5zkobl
         slhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IdX8x8KuGDrmo8OdGWM+s2IhO+yiRKLdL7Zo2PMSFN4=;
        b=1ti+/FNnJgNZHSQuUhDcsqIc1XOlitvkuDRIGFewGkT6a//GeuV6ZNPWbljQ8yzYf8
         H32PPNcnVlMlZ7mU/yOrIHc5+3yzlcY/jWux28C3UXx2NW6r0W9KfRZjxuj7JLUz7w7x
         rDsLfWIi/NtFQlPkbiXPL42XXVlIz7OQL86eitfJHiNx3RjAu4Pqi1c6iOFUV1hgA6oC
         TUw0zsXwVUSP0mBYz9uZv4zv5g7/byZXPDXB26jAlX4te/rR0U1t5fy+b9GAS1ctho7Z
         aNEn1DxHtKKjBMe3Zjn6A1xgOXwvSx0L2bnPZkOEVjO0ZFjLkHM2QqkPg1/3KKjTFS5l
         efsQ==
X-Gm-Message-State: AJIora9wkarYGq5phZjvTB/gRWGzlTBvX/d75x+3GVsAW0mQoD29iilM
        27VVyu+ug7zCgpg1FQA3KKg=
X-Google-Smtp-Source: AGRyM1vCLnpaxRkOkmGAaj5Gy/KHt7mi0Q8MAJNokH4bRQpyU8kddgCKya3XL7eTcmHXXFWfReqHnA==
X-Received: by 2002:a05:620a:4090:b0:6b6:14ec:b6c6 with SMTP id f16-20020a05620a409000b006b614ecb6c6mr1897228qko.733.1658335770556;
        Wed, 20 Jul 2022 09:49:30 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:8a38:8fe4:50f8:8b83])
        by smtp.gmail.com with ESMTPSA id r11-20020ac8794b000000b0031ee918e9f9sm7579839qtt.39.2022.07.20.09.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 09:49:30 -0700 (PDT)
Date:   Wed, 20 Jul 2022 09:49:30 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 16/16] lib: create CONFIG_DEBUG_BITMAP parameter
Message-ID: <YtgyGvlhHsVMyXcv@yury-laptop>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-17-yury.norov@gmail.com>
 <YtXS9hySEY+BokvI@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtXS9hySEY+BokvI@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 12:39:02AM +0300, Andy Shevchenko wrote:
> On Mon, Jul 18, 2022 at 12:28:44PM -0700, Yury Norov wrote:
> > Create CONFIG_DEBUG_BITMAP parameter to let people use
> > new option. Default is N.
> 
> Even if a separate, it should follow immediately the implementation.

If it follows the 1st patch immediately, and becomes enabled, it will
generate a lot of noise for those who bisect and occasionally jumps
into a mid of the series.

There are quite a lot of patchsets that create a feature in many
patches, and explicitly enable it in the very last patch.
