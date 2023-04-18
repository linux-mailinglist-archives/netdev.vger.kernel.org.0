Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DFF6E5611
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjDRAyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjDRAyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:54:08 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172FB19A4;
        Mon, 17 Apr 2023 17:54:07 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a68d61579bso6522495ad.1;
        Mon, 17 Apr 2023 17:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681779246; x=1684371246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IA/HwtcM7Zy6wN8He0TmRxUfOHXjEruLmNGo1GrwrKc=;
        b=sMz9Qso4Ofd080LVdOCpGVzoML2jyFxDEnv+6yS0fw4dPjcrnUiooMT7ySHVsMrWdI
         2xMyPFpnPLkVnCC3oLuBXPi8je+iDtdZBKJMF1xhWKi336aMRflYYGN0TcT4OfPzOT9Y
         4Do3QNhlz4iHoN4DclgRiU2q2yaO2fMcMqLG85zw9U/m4wpDb7MQiAfRaxC+03uuI8JM
         EVHOxxQZCBi5wfrGrlcyr+tzzo4vC1jWrUaA1tv2xg708TFK0/CEKA/zVZNGqPdCYTDq
         0TqAZ7t+m4I4UQuPFQ+w9YXThiEkeE9ylp33rOgWFYKQB4x2HkRyhDMqOlJ2rtr0gkNC
         fEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681779246; x=1684371246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IA/HwtcM7Zy6wN8He0TmRxUfOHXjEruLmNGo1GrwrKc=;
        b=RL6amWcD1nyqTtwuD4hWbinV5UWHQLdLeGEaO6vj43EMKi6Hw2IVzM0H2IkPXLhaV6
         GDGxm4maKQ7FOy4JNzK9krabwMy1wdspsLoUFw5YcpI0ZDNofjNV2KmeeA3TRAYqDsBa
         Onu9eKs8I+6LPqdM5ZKtVM3bOcrZA5d4knZ/amYhX0sIGi8XEwX4JOwrl2VfJj0mwq6o
         JGJvIDKmePDgAT7IvdwcZPqvoZb/k6O3vLLwpCVjih/Cb3pG48kd3l9dwXt2dnJANlxo
         M9vBtpJhXNwXGaQjREgXhVkINIoghbj91SAbvbf9/5vXEcd9Xzo3rkyrCgLXzbsa8F04
         nuaQ==
X-Gm-Message-State: AAQBX9eKUnSwHvRB141IrFBiUkTRRaxV/YRKghr6hucy2OwY7MG1stzN
        7qJxQ5g5IZcMWTqE9mD339o=
X-Google-Smtp-Source: AKy350YE0HWEHMmsS57vty8G6fGdp3N81yKNlogHtKngt7TQXWG+/fz22C2EH7/aTVT1VdEWpqCIdA==
X-Received: by 2002:a17:903:11c4:b0:1a6:45e5:a26a with SMTP id q4-20020a17090311c400b001a645e5a26amr481829plh.27.1681779246245;
        Mon, 17 Apr 2023 17:54:06 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902c21300b001a1d553de0fsm8327113pll.271.2023.04.17.17.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 17:54:05 -0700 (PDT)
Date:   Mon, 17 Apr 2023 17:51:54 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
Message-ID: <ZD3l6FBnUh9vTIGc@yury-ThinkPad>
References: <20230415050617.324288-1-yury.norov@gmail.com>
 <20230417111137.GI83892@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417111137.GI83892@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 01:11:37PM +0200, Peter Zijlstra wrote:
> 
> 
> Something went wrong with sending your patches; I only have 0/n.

Indeed. Thanks for pointing. I'll resend shortly.
