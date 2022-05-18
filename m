Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EBB52BA2E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbiERMfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbiERMew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:34:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A42019CEC7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652877036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2LCFQ3BaiAODg52eVM1mGg1zRamZE6jNoZ6Ptxb2fNI=;
        b=ffpxCupGAOe+3PakjMO1sXMNeH7tg7qw/O+CRZHPvyTy3E6AvPQAmrhArLI/yFDwoO3DvL
        YrRmvcXfsVHqCYfHCx5YUI2rkfbvaz/Qmeg+oHvqt7z4POoLC+5HtoxUysCv+KecMV1lHW
        ZfKq8J4HAAGPHd2oQeDNoIkwiXeT2vs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-YxyU2fNjOvaFcC_5G4hFKw-1; Wed, 18 May 2022 08:30:32 -0400
X-MC-Unique: YxyU2fNjOvaFcC_5G4hFKw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 235FD86B8A2;
        Wed, 18 May 2022 12:30:31 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5779C7C2A;
        Wed, 18 May 2022 12:30:25 +0000 (UTC)
Date:   Wed, 18 May 2022 14:30:22 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in
 kprobe_multi.addrs
Message-ID: <20220518123022.GA5425@asgard.redhat.com>
References: <cover.1652772731.git.esyr@redhat.com>
 <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <YoNnAgDsIWef82is@krava>
 <20220517123050.GA25149@asgard.redhat.com>
 <YoP/eEMqAn3sVFXf@krava>
 <7c5e64f2-f2cf-61b7-9231-fc267bf0f2d8@fb.com>
 <YoTXiAk1EpZ0rLKE@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoTXiAk1EpZ0rLKE@krava>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 01:24:56PM +0200, Jiri Olsa wrote:
> On Tue, May 17, 2022 at 02:34:55PM -0700, Yonghong Song wrote:
> > On 5/17/22 1:03 PM, Jiri Olsa wrote:
> > > On Tue, May 17, 2022 at 02:30:50PM +0200, Eugene Syromiatnikov wrote:
> > > > On Tue, May 17, 2022 at 11:12:34AM +0200, Jiri Olsa wrote:
> > > > > On Tue, May 17, 2022 at 09:36:47AM +0200, Eugene Syromiatnikov wrote:
> > > > > > With the interface as defined, it is impossible to pass 64-bit kernel
> > > > > > addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> > > > > > which severly limits the useability of the interface, change the ABI
> > > > > > to accept an array of u64 values instead of (kernel? user?) longs.
> > > > > > Interestingly, the rest of the libbpf infrastructure uses 64-bit values
> > > > > > for kallsyms addresses already, so this patch also eliminates
> > > > > > the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().
> > > > > 
> > > > > so the problem is when we have 32bit user sace on 64bit kernel right?
> > > > > 
> > > > > I think we should keep addrs as longs in uapi and have kernel to figure out
> > > > > if it needs to read u32 or u64, like you did for symbols in previous patch
> > > > 
> > > > No, it's not possible here, as addrs are kernel addrs and not user space
> > > > addrs, so user space has to explicitly pass 64-bit addresses on 64-bit
> > > > kernels (or have a notion whether it is running on a 64-bit
> > > > or 32-bit kernel, and form the passed array accordingly, which is against
> > > > the idea of compat layer that tries to abstract it out).
> > > 
> > > hum :-\ I'll need to check on compat layer.. there must
> > > be some other code doing this already somewhere, right?
> 
> so the 32bit application running on 64bit kernel using libbpf won't
> work at the moment, right? because it sees:
> 
>   bpf_kprobe_multi_opts::addrs as its 'unsigned long'
> 
> which is 4 bytes and it needs to put there 64bits kernel addresses
> 
> if we force the libbpf interface to use u64, then we should be fine

Yes, that's correct.

> > I am not familiar with all these compatibility thing. But if we
> > have 64-bit pointer for **syms, maybe we could also have
> > 64-bit pointer for *syms for consistency?
> 
> right, perhaps we could have one function to read both syms and addrs arrays

The distinction here it that syms are user space pointers (so they are
naturally 32-bit for 32-bit applications) and addrs are kernel-space
pointers (so they may be 64-bit even when the application is 32-bit).
Nothing prevents from changing the interface so that syms is an array
of 64-bit values treated as user space pointers, of course.

> > > > > we'll need to fix also bpf_kprobe_multi_cookie_swap because it assumes
> > > > > 64bit user space pointers
> 
> if we have both addresses and cookies 64 then this should be ok
> 
> > > > > 
> > > > > would be gret if we could have selftest for this
> 
> let's add selftest for this

Sure, I'll try to write one.

