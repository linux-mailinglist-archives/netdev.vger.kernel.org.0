Return-Path: <netdev+bounces-4461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BED0370D06F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 740FD2810C1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC9A1860;
	Tue, 23 May 2023 01:23:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639D1112;
	Tue, 23 May 2023 01:23:03 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F995;
	Mon, 22 May 2023 18:23:01 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso3985812b3a.1;
        Mon, 22 May 2023 18:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684804981; x=1687396981;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rD1Da0CBFPxqy+Dmx687Py4nO3BrxWEMb5HNIT20xI=;
        b=mUPDPYC+gOA3tBnXjNkT8Lw9nlIkQmVf0id/rb963zeid0ABOsSJd2ZGtAnA5g6bM8
         lAckTTHMlUiQEQYb+lOG/HR1+gvF6MRvpwzHg2p1hQB2f70Etje3MiMkubYOJtnSokw5
         MgIZ2VEcGPLBpyLh7WGB5W6f8Oe4EbKow+GB0gk7YozVfqmA0vQrAA8rEok9+fixW9pY
         RKC1I1j9jQftonisXK4xLpWbtvzmKQDxWb6IG8o9faM/aw5cedw4u5jD7PleYDkumvI5
         tEgzuwbW2AqYm+e0lKbbmoBcULkB3S+QV2bytvtYHQUcpBnALzALCA6ydC89NRdsva71
         fi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684804981; x=1687396981;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9rD1Da0CBFPxqy+Dmx687Py4nO3BrxWEMb5HNIT20xI=;
        b=cK1cBO+OSeWd3FR9pDzll5JhLKPYPQahg4JB/fcX5z47oSalQq9hrWyncN+hgZyiLm
         9NyEVB/pi6/6zAw5G0GYgitapNaI9RY4hXYP6XjsufinB2PGh2bDF2brza+N7rhq61Vd
         pEY82Z8ez7QrDxVG7jumW4ae9XdeGWkbBjoMdTzCKWv4xDp1HfyHaO9N1bRxcNhJDkIy
         B2tr+O3TTZdPBx5DdvZOTJbVHsJCQ7ir8lRB8uKfrceHIVI+Htu/l5TyNck62YHB+Qt9
         EO0RXuR3y2B/lvo2DieBYgli1UGe1SoVFsbTHImVmdhW/QCxTYCs1QlUUrXHqeO/2CLo
         CTIw==
X-Gm-Message-State: AC+VfDywYCi+eWgiXKcSYw7QfTUr6SxnE7qyOqz+Cv0qr/iiAsqQCPyl
	LrhJ5VILJWBUHNGwol6h1Zs=
X-Google-Smtp-Source: ACHHUZ7++1ajukB/Pte1ceCwuwO2eTjG25ne6xhxfSlr3W/6i5COLzKgEebBCNvqCN/znSx5S2WWWg==
X-Received: by 2002:a05:6a00:24d4:b0:64d:2c61:4b1 with SMTP id d20-20020a056a0024d400b0064d2c6104b1mr16076620pfv.11.1684804980640;
        Mon, 22 May 2023 18:23:00 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id t23-20020aa79397000000b0064d4d11b8bfsm4368001pfe.59.2023.05.22.18.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 18:23:00 -0700 (PDT)
Date: Mon, 22 May 2023 18:22:58 -0700
From: John Fastabend <john.fastabend@gmail.com>
To: John Fastabend <john.fastabend@gmail.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 jakub@cloudflare.com, 
 daniel@iogearbox.net
Cc: john.fastabend@gmail.com, 
 bpf@vger.kernel.org, 
 netdev@vger.kernel.org, 
 edumazet@google.com, 
 ast@kernel.org, 
 andrii@kernel.org, 
 will@isovalent.com
Message-ID: <646c1572c0d3f_a9a7208f1@john.notmuch>
In-Reply-To: <646c14a5bd4f8_260e20865@john.notmuch>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
 <646c14a5bd4f8_260e20865@john.notmuch>
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
> John Fastabend wrote:
> > v9, rebased which resulted in two additions needed. Patch 14
> > to resolve an introduced verifier error. I'll try to dig into
> > exactly what happened but the fix was easy to get test_sockmap
> > running again. And then in vsock needed similar fix to the
> > the protocols so I folded that into the first patch.
> 
> [...]
> 
> Guess we need yet another build CI seems to be upset building
> this.
> 
> 2023-05-22T17:37:37.7500703Z In file included from /tmp/work/bpf/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:17:
> 2023-05-22T17:37:37.7501506Z /tmp/work/bpf/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h:240:18: error: use of undeclared identifier 'VMADDR_CID_LOCAL'
> 2023-05-22T17:37:37.7501950Z         addr->svm_cid = VMADDR_CID_LOCAL;
> 2023-05-22T17:37:37.7503213Z                   
> 
> Interestingly clang version (latest) here is fine with it. Anyways
> will fix we should put define near where its used. :/

Sorry bit noisy but the reason is I don't need the define here I have
new enough headers. I typically install kernel headers with the src.

