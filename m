Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8340560E4B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 02:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiF3Aux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 20:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiF3Auw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 20:50:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0942403ED;
        Wed, 29 Jun 2022 17:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6FCB827B6;
        Thu, 30 Jun 2022 00:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5E0C34114;
        Thu, 30 Jun 2022 00:50:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Rio6hS73"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656550239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lAj+UsLxPeGR3JIzKkMAY3UQ4Fc7rVtE34gVa7F5Mk0=;
        b=Rio6hS73DikBrANqdWBHqlvUAZr9HeM3Tw2P2RT7GwzMWfx1mEoPnAX9y2tYS3dnyLa61K
        G9F/AphVS3+hx/JuleNTfayYZfXj8oeQUQ6MZ4LtXRluQmG0UQvBPWFw0KqujncUNs3GUB
        +IL/7OeJsmgFDXKFSsmPdhgTbsSjW5k=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c29fd627 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 00:50:39 +0000 (UTC)
Date:   Thu, 30 Jun 2022 02:50:34 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Joe Perches <joe@perches.com>
Cc:     Kalesh Singh <kaleshsingh@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, rcu <rcu@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sultan@kerneltoast.com,
        android-kernel-team <android-kernel-team@google.com>,
        John Stultz <jstultz@google.com>,
        Saravana Kannan <saravanak@google.com>, rafael@kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <YrzzWmQ9+uDRlO5K@zx2c4.com>
References: <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com>
 <Yryic4YG9X2/DJiX@google.com>
 <Yry6XvOGge2xKx/n@zx2c4.com>
 <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
 <YrzaCRl9rwy9DgOC@zx2c4.com>
 <CAC_TJvcEzp+zQp50wtj4=7b6vEObpJCQYLaTLhHJCxFdk3TgPg@mail.gmail.com>
 <306dacfb29c2e38312943fa70d419f0a8d5ffe82.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <306dacfb29c2e38312943fa70d419f0a8d5ffe82.camel@perches.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 05:36:57PM -0700, Joe Perches wrote:
> > > +static ssize_t pm_userspace_autosleeper_show(struct kobject *kobj,
> > > +                               struct kobj_attribute *attr, char *buf)
> > > +{
> > > +       return sprintf(buf, "%d\n", pm_userspace_autosleeper_enabled);
> 
> This should use sysfs_emit no?

Probably, yea. Note that I just copy and pasted a nearby function,
pm_async_show, `:%s/`d the variable name, and then promptly `git diff |
clip`d it and plonked it into my email. Looking at the file, it uses
sprintf all over the place in this fashion. So you may want to submit a
cleanup to Rafael on this if you're right about sysfs_emit() being
universally preferred.

Jason
