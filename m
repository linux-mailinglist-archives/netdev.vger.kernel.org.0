Return-Path: <netdev+bounces-4460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74EA970D05F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 501581C20C12
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56065185F;
	Tue, 23 May 2023 01:19:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC4C1847;
	Tue, 23 May 2023 01:19:39 +0000 (UTC)
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799FF92;
	Mon, 22 May 2023 18:19:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-253e0f1e514so2288736a91.1;
        Mon, 22 May 2023 18:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684804776; x=1687396776;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnTORRvOFq+sivOwL+B1qEmMhdymNJCC9ta7K6PY5OA=;
        b=EudPK8xEqqtrDRS5A2DPD8O9S+WK+I/qYtrXeOGuoiIVEfm1wunt+0spc6Fwhx84Om
         ZfbVJsMoLCpBeOe+LqoEkth3nUgkwkL+TwWvqexicgvruJXLp/KWtfzOnF8I5VXsCskI
         i6htg0uBzmTFAKiV+/TVH9ozn8dnpWSSN+2tzzNUmlFINxgjI3KnoYprDfcH1CN+38KR
         KKzIqt4FjgmyV2qaUfH63FtOA8XoriKiCzUehkqLDz47T1i6lGxKaD4FgIHCPA1t07ru
         rMD1ZfOjUNE3r0PlvKeT5Nexu/ZWDPqAaYq7nr6PGZLfqB7rk5B0xl5RR8ssjinY4UlQ
         K/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684804776; x=1687396776;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qnTORRvOFq+sivOwL+B1qEmMhdymNJCC9ta7K6PY5OA=;
        b=APG+P6t3kFhHx5gyd1+wuYleQUE0hTRMZnozQF08hzR6oq0SVoMzhgG8SA42Bk1/15
         e2Bztbo96gj7QhWblJFLQ1Btoh8hwvXWBqHAzXViD4uWlmXrtaUL55K6Ehbnty2nPn8w
         5PtmerhJaoldsTFDd27GzRYQE9lE0W73wHr+eOwIkeepBN5c3dCIbmRsj9F3L+hNe1Ra
         Cpfptpb92QHckjIZWf2qnkIGZLB/2pranKPGEyxkbOYx9DSiSI2zOhS09U9+y/jPk2Z2
         HzP/PcTX5bEZaPWmOOZcD5rurbAP9LLnAdGe9P6JLSzunHTfW7p29e5ocw8fDPFfKwYm
         TaYA==
X-Gm-Message-State: AC+VfDzMJY6c72YnBm+tmpZyrBEpikeqHovOwfiuHbY+kyCUGz22HUin
	89cnTsHzlobYwb2NCrdDZoU6vUnpYgQ=
X-Google-Smtp-Source: ACHHUZ6kHYl5wwSKwjC4x0juWspfzQyRaohwF3p706NiCkulAgkbJjDiOnhBRp172fzZkUDsZzIqSQ==
X-Received: by 2002:a17:903:443:b0:1ae:403f:d838 with SMTP id iw3-20020a170903044300b001ae403fd838mr11798254plb.27.1684804775836;
        Mon, 22 May 2023 18:19:35 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id e8-20020a170902744800b001ab0d815dbbsm5406546plt.23.2023.05.22.18.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 18:19:35 -0700 (PDT)
Date: Mon, 22 May 2023 18:19:33 -0700
From: John Fastabend <john.fastabend@gmail.com>
To: John Fastabend <john.fastabend@gmail.com>, 
 jakub@cloudflare.com, 
 daniel@iogearbox.net
Cc: john.fastabend@gmail.com, 
 bpf@vger.kernel.org, 
 netdev@vger.kernel.org, 
 edumazet@google.com, 
 ast@kernel.org, 
 andrii@kernel.org, 
 will@isovalent.com
Message-ID: <646c14a5bd4f8_260e20865@john.notmuch>
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
Subject: RE: [PATCH bpf v9 00/14] bpf sockmap fixes
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

John Fastabend wrote:
> v9, rebased which resulted in two additions needed. Patch 14
> to resolve an introduced verifier error. I'll try to dig into
> exactly what happened but the fix was easy to get test_sockmap
> running again. And then in vsock needed similar fix to the
> the protocols so I folded that into the first patch.

[...]

Guess we need yet another build CI seems to be upset building
this.

2023-05-22T17:37:37.7500703Z In file included from /tmp/work/bpf/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:17:
2023-05-22T17:37:37.7501506Z /tmp/work/bpf/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h:240:18: error: use of undeclared identifier 'VMADDR_CID_LOCAL'
2023-05-22T17:37:37.7501950Z         addr->svm_cid = VMADDR_CID_LOCAL;
2023-05-22T17:37:37.7503213Z                   

Interestingly clang version (latest) here is fine with it. Anyways
will fix we should put define near where its used. :/

Thanks,
John

