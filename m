Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFF36B4A8A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjCJPYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjCJPX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:23:56 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D811C10CE8A;
        Fri, 10 Mar 2023 07:13:50 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bw19so5326706wrb.13;
        Fri, 10 Mar 2023 07:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678461163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p6cuT3U1bVX5lFLnBEnZQ2hsf/k+1o4S1dIy8KAZ6uU=;
        b=GCcGuaAwjv5vZsz9kkE4JH9XJTG2vUM4Hda0vLUrMEOzwzEC+0Rik3z4N6/GSWoVC7
         3p9UY+8Ga0NUUhv2jV0EE4lc7U636mW8SjcYPOoR/mzGEk6JCsbRW+YAWdKBPqJHw2Vw
         pFHgf5oj318059UKKI3gEtubwu/QLKKSeUXcen5cHM4ywA+JsgEE9Hgs/a3juKBli5Cp
         C1LxM+AIlzf7wrpZVN1ISk796lgF6FrH9i48fR6SvxZwt/CLC83P6bn9mMsfRlBL5IFX
         nvMg2NhoYGl0YOgMxxVQFUusR6xQLSY8ZRTR68SEukTWPW6CCNr2ix7rH5T9K5MiZltg
         wAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678461163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6cuT3U1bVX5lFLnBEnZQ2hsf/k+1o4S1dIy8KAZ6uU=;
        b=N4LVe5PEh7T8pQVAVrlFw/eL4/jjWA1XJVQo1DIA2AP/pecoDIIDEwKSM2TMeKiFZ4
         +Kj/R4cIZBQb9/AbyW4y7jM3yvPiUaSBt70AVuBu8RjgMBhAbIBFGJudp8g7Qph9/r9Y
         ukR/VYV9ScjgLjsePfzLn/HgU6WyG2kXYyCZVnBE9EHfWoTXbpi8Lgrv4rLtE2bLsOpL
         7+Khn10Q6S3IYldnydUen56ZMxg0mKKfXNaZF1iVSqrHRbbM+vxBGGzqnpkjO2QH2Kss
         xo52x0/X8uBAQ5BDAobh6GY5y/5YNZcWQffkxVV+qB7rkBlQQDQ809nsA/F6sSgnsXg+
         n+Sg==
X-Gm-Message-State: AO0yUKXGsjx7YYXzfrjgRPbaGqVUBxnxj4snI6dslKu+cG/oPAXZFjuL
        JTk0AT8QS6hb86XSXRwL2Ow=
X-Google-Smtp-Source: AK7set/rPNhytHq/ODKzpjacFfo1gxTUtFdqYnJIH8Zsl3JYYluEgcQjNTFx0H3kLPqLwSpKAZ1DGQ==
X-Received: by 2002:adf:eec2:0:b0:2c7:4ec:8d79 with SMTP id a2-20020adfeec2000000b002c704ec8d79mr18689984wrp.21.1678461163427;
        Fri, 10 Mar 2023 07:12:43 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h11-20020adff4cb000000b002c70ce264bfsm30336wrp.76.2023.03.10.07.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:12:43 -0800 (PST)
Date:   Fri, 10 Mar 2023 18:12:39 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Francois Romieu <romieu@fr.zoreil.com>,
        Gencen Gan <u202011061@gmail.com>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, smatch@vger.kernel.org
Subject: Re: [PATCH] atm: he: fix potential ioremap leak of membase in he_dev
Message-ID: <1c2dae4a-554c-4e88-a27a-bc28426e500d@kili.mountain>
References: <20230310102256.1130846-1-u202011061@gmail.com>
 <20230310112850.GA424646@electric-eye.fr.zoreil.com>
 <c379d193-5408-a514-9f37-eb93585557ab@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c379d193-5408-a514-9f37-eb93585557ab@hust.edu.cn>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 09:15:43PM +0800, Dongliang Mu wrote:
> 
> 
> On 3/10/23 19:28, Francois Romieu wrote:
> > Gencen Gan <u202011061@gmail.com> :
> > > In the function he_start() in drivers/atm/he.c, there
> > > is no unmapping of he_dev->membase in the branch that
> > > exits due to an error like reset failure, which may
> > > cause a memory leak.
> > 
> > Why would he_dev->membase not be unmapped in he_stop() ?
> > 
> > he_stop() is paired with he_start() as soon a he_start() returns
> > anything different from 0 in he_init_one(). I see no other place
> > where he_start() is used.
> 
> Yes, you're right. We will check more about reports from the static checker
> Smatch.
> 
> Smatch should make a false positive here, I think it might be that, Smatch
> has an assumption about do and its paired undo functions. The do function
> should clean up its own allocation operations. And the paired undo function
> can be only called if the do function succeeds.
> 
> +cc Dan Carpenter
> 
> Maybe @Dan could tell more about this point.
> 

Yes.  Smatch is assuming that every function cleans up after itself.
Generally this is the way most functions do it.

Perhaps the best option here is to create a new warning for the double
free bug if this patch were applied.

regards,
dan carpenter

