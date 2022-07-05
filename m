Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC84F567152
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiGEOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiGEOjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:39:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE0DA1B9;
        Tue,  5 Jul 2022 07:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657031953; x=1688567953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bwCbUaDqvMtVlN4ueDxGSnxY6sfa6e9kx0utA3eoaAw=;
  b=TbPY1FsogGXp9xd6Nvzj/0yAAuq7nQgRbNIc/K3c/uTWFx4Qf6dDGiUN
   JkaENztPG82B3qt7t8pEu2Nv8FW1Dqht/S0mozl3AGu2nudinsaFRfzKB
   fjFPE8GjnMXfW29SnNmhAzWNhDTwQN9+y9aHVbAZHwtUbPOy+d5LlKOvE
   eCO4kQU6bWysXxqIdpnw5GZW8Gg0H3g1Zf9Z4orD9SoydiL29b9iqRasj
   o4qD7xl7/iatB/LM11v7ZpYlHk2NJoX3Y8+jjCAe0yYmjDqHO2cnfEdM1
   gy3GrlCKUr13zjH5G+vDtHmNya1UXESqTE1KxbhADSlXLFvpXOrThvHFn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="283396868"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="283396868"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 07:39:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="839142776"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jul 2022 07:39:08 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 265Ed6BM016910;
        Tue, 5 Jul 2022 15:39:06 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        brouer@redhat.com, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce and use Generic Hints/metadata
Date:   Tue,  5 Jul 2022 16:38:38 +0200
Message-Id: <20220705143838.19500-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <0cd3fd67-e179-7c27-a74f-255a05359941@redhat.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com> <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk> <20220704154440.7567-1-alexandr.lobakin@intel.com> <0cd3fd67-e179-7c27-a74f-255a05359941@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Mon, 4 Jul 2022 19:13:53 +0200

> On 04/07/2022 17.44, Alexander Lobakin wrote:
> >> Agreed. This incremental approach is basically what Jesper's
> >> simultaneous series makes a start on, AFAICT? Would be nice if y'all
> >> could converge the efforts :) >
> > I don't know why at some point Jesper decided to go on his own as he
> > for sure was using our tree as a base for some time, dunno what
> > happened then. Regarding these two particular submissions, I didn't
> > see Jesper's RFC when sending mine, only after when I went to read
> > some stuff.
> > 
> 
> Well, I have written to you (offlist) that the git tree didn't compile,
> so I had a hard time getting it into a working state.  We had a
> ping-pong of stuff to fix, but it wasn't and you basically told me to
> switch to using LLVM to compile your kernel tree, I was not interested
> in doing that.

Yes and no, I only told you that I missed those build issues due to
that I use LLVM as my primary compiler, but I didn't suggest you
switch to it. Then I fixed all of the issues in a couple days and
wrote you the email on 3th of June saying that everything works
now =\

> 
> I have looked at the code in your GitHub tree, and decided that it was
> an over-engineered approach IMHO.  Also simply being 52 commits deep
> without having posted this incrementally upstream were also a
> non-starter for me, as this isn't the way-to-work upstream.

So Ingo announced recently that he has a series of 2300+ patches
to try to fix include hell. Now he's preparing to submit them by
batches/series. Look at this RFC as at an announce. "Hey folks,
I have a bunch of stuff and will be submitting it soon, but I'm
posting the whole changeset here, so you could take a look or
give it a try before it's actually started being posted".
All this is mentioned in the cover letter as well. What is the
problem? Ok, next time I can not do any announces and just start
posting series if it made such misunderstandings.

Anyway, I will post a demo-version of the series in a couple weeks
containing only the parts required to get Hints working on ice if
folks prefer to look at the pencil draft instead of looking at the
final painting (never thought I'll have to do that in the kernel
dev community :D).

> 
> To get the ball rolling, I have implemented the base XDP-hints support
> here[1] with only 9 patches (including support for two drivers).
> 
> IMHO we need to start out small and not intermix these huge refactoring
> patches.  E.g. I'm not convinced renaming net/{core/xdp.c => bpf/core.c}
> is an improvement.

Those cleanup patches can be easily put in a standalone series as
a prerequisite. I even mentioned them in the cover letter.
File names is a matter of discussing, my intention there was mainly
to move XDP stuff out of overburdened net/core/dev.c.

> 
> -Jesper
> 
> [1] 
> https://lore.kernel.org/bpf/165643378969.449467.13237011812569188299.stgit@firesoul/

Thanks,
Olek
