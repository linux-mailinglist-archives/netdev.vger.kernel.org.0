Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE8F542F08
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbiFHLRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbiFHLRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:17:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D5A397B8C;
        Wed,  8 Jun 2022 04:17:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 652F521BED;
        Wed,  8 Jun 2022 11:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654687057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a6bf/XKIswMmhT0/MxqBFChdpkZvDy8EKPj+RsAd1+M=;
        b=fBte7kUPCjB2wXrYzPa9lBNyOS1Uqd5BrWTaIy5APcQPd676v4dk9jugTV1GTK9et//N67
        n6/XIeuOiXycHc+0OvVgNJ7gXBnlvz6672DsZUmJvRhPu3IRAqVx8bIQzg2HzobuOb2/m9
        u0DQh0SfHOB6vkc72pxxKqfn1iJbDII=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED6F713AD9;
        Wed,  8 Jun 2022 11:17:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HMT0OFCFoGLTGgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 08 Jun 2022 11:17:36 +0000
Date:   Wed, 8 Jun 2022 13:17:35 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Message-ID: <20220608111735.GE8747@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com>
 <20220603162339.GA25043@blackbody.suse.cz>
 <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
 <20220606123222.GA4377@blackbody.suse.cz>
 <CAJD7tkbi7Gnnf4NiUt-J61G7185NsRcySvP6qOQsFKMou7qZJg@mail.gmail.com>
 <20220607121237.GC31717@blackbody.suse.cz>
 <CAJD7tkYa3u52c77cnRxZ6D_4u5fkDG545r5a9SdK3Ys9Uuorig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkYa3u52c77cnRxZ6D_4u5fkDG545r5a9SdK3Ys9Uuorig@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 10:43:35AM -0700, Yosry Ahmed <yosryahmed@google.com> wrote:
> memory_cgrp_id is defined in "vmlinux.h" (generated from BTF) which is
> included through "bpf_iter.h". If the kernel is not compiled with
> CONFIG_MEMCG then this enum value will not be defined and the bpf prog
> should not compile.

Cool. Then it works as I would have expected.

Michal
