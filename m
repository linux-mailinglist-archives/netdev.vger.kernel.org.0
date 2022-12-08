Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85185647766
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLHUlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLHUlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:41:37 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5D084B49;
        Thu,  8 Dec 2022 12:41:36 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id t15-20020a4a96cf000000b0049f7e18db0dso406955ooi.10;
        Thu, 08 Dec 2022 12:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kn6pAPyh7GVd4yH8ZcVetJ6KHkFeBkaGTE995AlcjFw=;
        b=OgRFSxxKU/XYW75jfxIfe2MfQbklXKHvxUOmEBipoUobgiLU1dSoroxxBEl80631+b
         PyfzEZBfcqSASDlIh/jsUchLCUq9MfiehjbD7dB2JEVb0NK3W43FBKFuyFh2VQ0sAO1C
         G9f9tXxLqd8AhZgIQNYvqgRXUlNVHpHzUrd4Q9FBHX9TeDiGAWdk/0jZzVI1l/3Gt9Hr
         wkLwCMGhMKhk7Camqpa4+s/kdtOUdS0YPSJAJrWcMUkjgB0ZyuqkK+oyHPU2wtATBeKo
         3loLg1RnDie2HI1kW6lxIragcixGM0Swq7NqhD/CogH0UyepiehKUjzdGN5Sn6cI71vs
         1hoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kn6pAPyh7GVd4yH8ZcVetJ6KHkFeBkaGTE995AlcjFw=;
        b=6oVdSh2hFW6L9bM5Ty82akDZ+WkHZMBPZHmNGCv90VXNlYDU4th3j14qW9NCFCN0Lj
         qhV246kj2EItrWys5tYtsE7zKrUeHDvNgNIKaJ85DMdKT88MkK9XggEoU2+T7O8aj6v7
         58fEw/y5kEGHJNknPC1WIV4OtRjMqaS6smbFRQWSwUNJq0HdeqU3WaLPIXiCEc6u6D/B
         waiPCcfkD4fDaD96Stp0n/BL2cEGQzDMD/d24TMqZU7GWKMmJigZ89hHqERcJJy3UlH3
         0zWpSSFyEDXQLhU8FBHAaxg7+dbL1GMM3lpg563Iow0FWPU7iGtI8Fz1sGhE441PH4W1
         LMMg==
X-Gm-Message-State: ANoB5pn6VCNLJYDDUNcn/0jWyhLMui5xjXVwDucPMcwdoKUG26l4Y4mz
        mDVqt9HAv6fXaRfQOUqjZjc=
X-Google-Smtp-Source: AA0mqf70R0QQ/wCK7uiugWelDJDoVzwW91xBAtjTwhILf09JL4bMpPB6FKRTSaXw8Um9MH57paktXg==
X-Received: by 2002:a4a:dc8c:0:b0:4a0:c270:2f3f with SMTP id g12-20020a4adc8c000000b004a0c2702f3fmr1887940oou.3.1670532095338;
        Thu, 08 Dec 2022 12:41:35 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id j2-20020a4a9442000000b0049f0671a23asm10308930ooi.9.2022.12.08.12.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 12:41:34 -0800 (PST)
Date:   Thu, 8 Dec 2022 12:41:33 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 5/5] lib/cpumask: reorganize cpumask_local_spread()
 logic
Message-ID: <Y5JL/YqlxoC/4j4A@yury-laptop>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
 <20221208183101.1162006-6-yury.norov@gmail.com>
 <KQCC2QYXZ6BtFjiUQO-XQNUO5Ub3kGfpKzjfIeUfCQEvMUEMKiZ7ofEMqoZElMYxYFtuRqW6v3UzCpDzDR-QYZk-tpMDVLl_HSl8BEi1hZk=@n8pjl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KQCC2QYXZ6BtFjiUQO-XQNUO5Ub3kGfpKzjfIeUfCQEvMUEMKiZ7ofEMqoZElMYxYFtuRqW6v3UzCpDzDR-QYZk-tpMDVLl_HSl8BEi1hZk=@n8pjl.ca>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 08:17:22PM +0000, Peter Lafreniere wrote:
> > Now after moving all NUMA logic into sched_numa_find_nth_cpu(),
> > else-branch of cpumask_local_spread() is just a function call, and
> > we can simplify logic by using ternary operator.
> >
> > While here, replace BUG() with WARN().
> Why make this change? It's still as bad to hit the WARN_ON as it was before.

For example, because of this:

  > Greg, please don't do this
  > 
  > > ChangeSet@1.614, 2002-09-05 08:33:20-07:00, greg@kroah.com
  > >   USB: storage driver: replace show_trace() with BUG()
  > 
  > that BUG() thing is _way_ out of line, and has killed a few of my machines
  > several times for no good reason. It actively hurts debuggability, because
  > the machine is totally dead after it, and the whole and ONLY point of
  > BUG() messages is to help debugging and make it clear that we can't handle
  > something.
  > 
  > In this case, we _can_ handle it, and we're much better off with a machine
  > that works and that you can look up the messages with than killing it.
  > 
  > Rule of thumb: BUG() is only good for something that never happens and
  > that we really have no other option for (ie state is so corrupt that
  > continuing is deadly).
  > 
  > 		Linus
