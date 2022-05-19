Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F4A52DB5F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbiESReN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238504AbiESReM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:34:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6CBB10B2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 10:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652981650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=10sfS9a5N8Q2t4x19dXmDFP5qz/jBxO35dvovp46vwg=;
        b=H+/GjK4cp4qk3/pwdZ7baZDBqxLOO75Y73aQ5dkj+i1a8YWpkKZkIQgVRl8x2MYVc0w07m
        ZFL5b8dptQqULOUsS7eKFrrY2YQDgAy0Mux+xx+BDtLuKoLFWaaRxONPmeHnd1fUd48cw3
        cMAnugi8j7hS+jn50VLRVU8suldmb6A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-6rvxpv91MzuRNPuLk_dXSA-1; Thu, 19 May 2022 13:34:07 -0400
X-MC-Unique: 6rvxpv91MzuRNPuLk_dXSA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FE68395AFED;
        Thu, 19 May 2022 17:34:06 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B5C9C27E8E;
        Thu, 19 May 2022 17:34:02 +0000 (UTC)
Date:   Thu, 19 May 2022 19:33:59 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in
 kprobe_multi.addrs
Message-ID: <20220519173359.GA7786@asgard.redhat.com>
References: <cover.1652772731.git.esyr@redhat.com>
 <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <YoNnAgDsIWef82is@krava>
 <20220517123050.GA25149@asgard.redhat.com>
 <YoP/eEMqAn3sVFXf@krava>
 <7c5e64f2-f2cf-61b7-9231-fc267bf0f2d8@fb.com>
 <YoTXiAk1EpZ0rLKE@krava>
 <20220518123022.GA5425@asgard.redhat.com>
 <CAEf4BzbRYT4ykpxzXKGQ03REoVRKm_q8=oVEVCXfE+4zVDb=8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbRYT4ykpxzXKGQ03REoVRKm_q8=oVEVCXfE+4zVDb=8A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 04:48:59PM -0700, Andrii Nakryiko wrote:
> Not sure how you can do that without having extra test_progs variant
> that's running in compat mode?

I think, all bpf selftests are to be run in compat mode as well,
now is a good time to enable this as any.

