Return-Path: <netdev+bounces-4132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DF170B309
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 04:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CAFD280E69
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 02:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21701A47;
	Mon, 22 May 2023 02:07:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C25A31;
	Mon, 22 May 2023 02:07:56 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904ABB7;
	Sun, 21 May 2023 19:07:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-510d92184faso9071618a12.1;
        Sun, 21 May 2023 19:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684721274; x=1687313274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz0Spj8dzzse1twdFWxs7Pr1GkJdyy1KzKMZwqhjwYw=;
        b=Z5mVGUMcyUthgWsbJz4jMz783W9DnClIAhVXFPkO3Sl1PZ84kkTS+St3Nm+j37fulr
         sX3mOzNAPu0+dKIhT/h8nzaEofGKN0yqBGudut32cHrc+E3dvf2d7wx578LjgttU8t4s
         O7EwM4brfMFhEMTdmaD5MyMs6SHBMdFND9VEzZa0pHOUqoirMERGER/wGBo1KoN53BCY
         T+iMnMZ036ZPnRQFAqeaotfKFAlx8nP7Elw06lTsg6bnJjq5C1f9CPAf/He3V1HuWKVt
         I2rKlbUzVCasktWwlPlOWr8Zj4b89yC0EVwhecTwlzbZwO909AtW1rPq6CaKmfACWwfE
         8THw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684721274; x=1687313274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sz0Spj8dzzse1twdFWxs7Pr1GkJdyy1KzKMZwqhjwYw=;
        b=FSfwtzGOxHK2XjVYZP06Q4c8RopfWhIBk43JwZXwsPzSmHdGmhgRB+eUqJiMGBAtnx
         cufK2N8rmDt2B2tqxFzjePkfxQE4SQhtO9jZKaBWHlVCZDDe4TDlAp5BpMeXpe+UX8D/
         YQXooLySIJAbuq5YJ53BlMbWQ6ucn783j9KydYHiqRbc9ENclPQQvrG4tXNSnrFMimud
         wMXUWEtMh3/6irD4IzmpSEjfXYTPozXt5oiHZ1fgUXzXAHalHJkISUqKdhgFd/6whHMp
         85jKpdfekyT+el9YVSFtLzVYZ2ZrXL+n4Jp0d7cY1kVAUgd1leXJ2C0kN4RcsaW1sn/M
         Rf8A==
X-Gm-Message-State: AC+VfDyA8qrU4hpOG/66UNoJV5EA6NYZX7DW1wY6zRBOTEIBXohi7Ewi
	qW1jL2YBqV2xcaXA6cZwrMf7TknUq7DEDhQZVQM=
X-Google-Smtp-Source: ACHHUZ4wrOhEYShKyW/O1eY1HmQbKQKS6rz1bi7T5GEPQgCb9egPC4yZhclR5xQE+XYa5cZMmp8Cwd8iFnqTUqJgR/g=
X-Received: by 2002:aa7:d80b:0:b0:50b:fe20:1c7f with SMTP id
 v11-20020aa7d80b000000b0050bfe201c7fmr7110715edq.33.1684721273786; Sun, 21
 May 2023 19:07:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220515203653.4039075-1-jolsa@kernel.org> <20230520094722.5393-1-zegao@tencent.com>
 <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com> <CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
 <ZGp+fW855gmWuh9W@krava>
In-Reply-To: <ZGp+fW855gmWuh9W@krava>
From: Ze Gao <zegao2021@gmail.com>
Date: Mon, 22 May 2023 10:07:42 +0800
Message-ID: <CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
Subject: Re:
To: Jiri Olsa <olsajiri@gmail.com>
Cc: Yonghong Song <yhs@meta.com>, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
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

Oops, I missed that. Thanks for pointing that out, which I thought is
conditional use of rcu_is_watching before.

One last point, I think we should double check on this
     "fentry does not filter with !rcu_is_watching"
as quoted from Yonghong and argue whether it needs
the same check for fentry as well.

Regards,
Ze

