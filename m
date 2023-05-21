Return-Path: <netdev+bounces-4109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9B270AE6F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECD731C20935
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD4746B4;
	Sun, 21 May 2023 15:10:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A3C46AC;
	Sun, 21 May 2023 15:10:34 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA61FBD;
	Sun, 21 May 2023 08:10:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-510d6b939bfso8668510a12.0;
        Sun, 21 May 2023 08:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684681828; x=1687273828;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RWRScIQ7TtRSX51KwV4NjzRGVME0l4RZnUO62hqp1V8=;
        b=PGlJRxqT3caE+l7AfDazwuZcJn6LcttOZoEzrlwEObi2GHWp0ABdUopFQpNGFeKoW0
         wqBz6ACTLsTw6QXHXxBYtRc0q8NylXPUPLsJzMrgRehGzMbOoPAMOun4gDX/CRrNfwgH
         CWt19nJrBW/6f1sgLf0bpwUgJY+0oR70J3STiFRWtG2Nl99mB2HEvjA/mxht/g68PHVo
         KsrMs31jXEAM+/duPlWz3XuAsUin+7WJDTymcG6OhfmENSHJ2Hlasstykt/JmFUOvOtp
         g9qDvLzBucL0aiSyVl9JW7l/AHn63s8aRFocVwYt7WUhBXHhk6NaOEyBnfCgLw5SOiWH
         U9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684681828; x=1687273828;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RWRScIQ7TtRSX51KwV4NjzRGVME0l4RZnUO62hqp1V8=;
        b=B2LbQpJDlhs6KSQph5LEbqoWq785q2acEO172pn1Cq94bd9dahQX1ot34HUjE5A71g
         rxeFZe2yKBSgVvor+Uc8q7L+sSU9O7+nz1hxBFDspEWL0bVw2vgWnxQyb8MRtgBRhVux
         ctpNZKESKgGeBvpamDSlfkiF3GQBjFrnN8M8QCpo8/r4v2GVyvYNZsVPEMeEBrNj7Lt9
         uPMTNNbiLJ4sDipAQpvqEo0Q4hw0QzteTwRSqhCTgklxKBgw9OgdvDfGcRybAM7H7oEa
         2zN/vPuswWRw3+49VEiMuN1Ew7VVGYJHaJWjZ88MPIiIJVDSW3ZB20uSp+Zt+TAfPzSl
         F2PQ==
X-Gm-Message-State: AC+VfDy3e69N+1WsCpUN5mOZQVquTZQLuSv3eQeLo6VVh46zuQS0ko4M
	1iRzVcT/O9RPL8z7Ry7eIy8siD+bVvF0u7CIHZs=
X-Google-Smtp-Source: ACHHUZ6dbu1B0FaRBW/nKEH9yrfQk+Hr45en4wmrqOwMF22vlPKinBGqYRGOOUNTh2sTkmhlNE0BfVlmEP67wx/Y3I8=
X-Received: by 2002:aa7:d0c7:0:b0:50b:caae:784 with SMTP id
 u7-20020aa7d0c7000000b0050bcaae0784mr6408547edo.20.1684681827923; Sun, 21 May
 2023 08:10:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220515203653.4039075-1-jolsa@kernel.org> <20230520094722.5393-1-zegao@tencent.com>
 <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
In-Reply-To: <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
From: Ze Gao <zegao2021@gmail.com>
Date: Sun, 21 May 2023 23:10:16 +0800
Message-ID: <CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
Subject: Re:
To: Yonghong Song <yhs@meta.com>
Cc: jolsa@kernel.org, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Steven Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	kafai@fb.com, kpsingh@chromium.org, netdev@vger.kernel.org, 
	paulmck@kernel.org, songliubraving@fb.com, Ze Gao <zegao@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> kprobe_multi/fprobe share the same set of attachments with fentry.
> Currently, fentry does not filter with !rcu_is_watching, maybe
> because this is an extreme corner case. Not sure whether it is
> worthwhile or not.

Agreed, it's rare, especially after Peter's patches which push narrow
down rcu eqs regions
in the idle path and reduce the chance of any traceable functions
happening in between.

However, from RCU's perspective, we ought to check if rcu_is_watching
theoretically
when there's a chance our code will run in the idle path and also we
need rcu to be alive,
And also we cannot simply make assumptions for any future changes in
the idle path.
You know, just like what was hit in the thread.

> Maybe if you can give a concrete example (e.g., attachment point)
> with current code base to show what the issue you encountered and
> it will make it easier to judge whether adding !rcu_is_watching()
> is necessary or not.

I can reproduce likely warnings on v6.1.18 where arch_cpu_idle is
traceable but not on the latest version
so far. But as I state above, in theory we need it. So here is a
gentle ping :) .

