Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DFC6D722E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 03:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbjDEBvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 21:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDEBvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 21:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4CE30EB;
        Tue,  4 Apr 2023 18:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F055639DB;
        Wed,  5 Apr 2023 01:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2A4C433EF;
        Wed,  5 Apr 2023 01:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680659508;
        bh=RYPgLkJHExZDJAdqdJW/2937qBmlTH/dWyqjpzJOEEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q6inJe/8gpnmcppfA5R3kWUUIjQE/pU20HD/UHLIjZRsg1Is1Ukq7Kw6zTrRL0vAM
         VkVkOjxWr/cPfPWHaJiHSNKBZ0kZWG1vBHjoyBAoBR4ZqDZ5IzwJY8DY37JOLR+6s3
         xxzWpXpDGk71xQls7mVu6xWAsB4e88EkSNaAAssNvuun04jYfuBknOgrkqBZWZtIfe
         /UUd58Cvk6vNyCVBPbuyPIVL9R9YJar1H7KW8W9KtZgYNN/C5nN+NGbR4BWkCQK1Le
         xKpE2owXXBsFdJvTAyWyNJkXd9bwDFkGf7KuXSyJ3sM7XyQbPoiAhu/eS/t1Y6S9hZ
         RMaStlTzs+RNQ==
Date:   Tue, 4 Apr 2023 18:51:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
Message-ID: <20230404185147.17bf217a@kernel.org>
In-Reply-To: <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
        <20230404145131.GB3896@maniforge>
        <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
        <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 17:16:27 -0700 Alexei Starovoitov wrote:
> > Added David's acks manually (we really need to teach pw-apply to do
> > this automatically...) and applied.  
> 
> +1
> I was hoping that patchwork will add this feature eventually,
> but it seems faster to hack the pw-apply script instead.

pw-apply can kind of do it. It exports an env variable called ADD_TAGS
if it spots any tags in reply to the cover letter.

You need to add a snippet like this to your .git/hooks/applypatch-msg:

  while IFS= read -r tag; do
    echo -e Adding tag: '\e[35m'$tag'\e[0m'
      git interpret-trailers --in-place \
          --if-exists=addIfDifferent \
          --trailer "$tag" \
          "$1"
  done <<< "$ADD_TAGS"

to transfer those tags onto the commits.

Looking at the code you may also need to use -M to get ADD_TAGS
exported. I'm guessing I put this code under -M so that the extra curl
requests don't slow down the script for everyone. But we can probably
"graduate" that into the main body if you find it useful and hate -M :)
