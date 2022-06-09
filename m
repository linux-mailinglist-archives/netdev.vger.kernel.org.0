Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6754F544FEB
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 16:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343649AbiFIOz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 10:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343489AbiFIOzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 10:55:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DDF37F906;
        Thu,  9 Jun 2022 07:55:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4BFC121FA9;
        Thu,  9 Jun 2022 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654786551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OP+FCzdv75xf3AHqKnJ+4LChpmPuksRBqF0JcYhkehA=;
        b=SQObC06khT/SS84YZt1lyljm9Cr5+NeogHGlZxt5pxfF9ZvnQLukKnj55bh+5fUCYBr7Yi
        NlraG861F/YQs96MkzjDx/3/U+FfUtp5HlV7liTe3y13/Ld9SWoy9qp1WgypBmB1npDRMw
        KIkohhqcvxF2/4K0d+30WALHcLZjlZg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E70FD13A8C;
        Thu,  9 Jun 2022 14:55:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OFs0N/YJomK9fAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Thu, 09 Jun 2022 14:55:50 +0000
Date:   Thu, 9 Jun 2022 16:55:49 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        0day robot <lkp@intel.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        lkp@lists.01.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Subject: Re: [cgroup] 3c87862ca1:
 WARNING:at_kernel/softirq.c:#__local_bh_enable_ip
Message-ID: <20220609145549.GA28484@blackbody.suse.cz>
References: <20220609085641.GB17678@xsang-OptiPlex-9020>
 <b39cdb9c-aa2a-0f49-318b-8632b2989433@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b39cdb9c-aa2a-0f49-318b-8632b2989433@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tadeusz.

On Thu, Jun 09, 2022 at 07:30:41AM -0700, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
> Are you interested in fixing this at syzbot issue all?

The (original) syzbot report is conditioned by allocation failure that's
unlikely under normal conditions (AFAIU). Hence I don't treat it extra
high urgent.
OTOH, it's interesting and it points to some disparity worth fixing --
so I try helping (as time permits, so far I can only run the reproducers
via the syzbot).

> Do you have any more feedback on this?

Ad the patch v2 with spinlock per css -- that looks like an overkill to
me, I didn't look deeper into it.

Ad the in-thread patch with ancestry css_get(), the ->parent ref:
  - is inc'd in init_and_link_css(),
  - is dec'd in css_free_rwork_fn()
and thanks to ->online_cnt offlining is ordered (child before parent).

Where does your patch dec these ancestry references? (Or why would they
be missing in the first place?)

Thanks for digging into this!
Michal
