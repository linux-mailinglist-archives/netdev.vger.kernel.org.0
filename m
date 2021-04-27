Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A47436CD8B
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhD0VBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239033AbhD0VBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 17:01:36 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D70C061763;
        Tue, 27 Apr 2021 14:00:52 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id c3so360181ils.5;
        Tue, 27 Apr 2021 14:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=B9O6HSSSA2HKZOCKluIOarWGuOU/V28mAm16p4AZpog=;
        b=D04IMBmMDXb6Z0W1Y9ySafEizPw3oANrBF2atbexHhUMMXIah9w/+LyNKudUBcpiOT
         JEL9dBDyiyR2NjKGl04A31Ce+hpUUJNcKing68Q1yqDwsBYm8mB1/mnRgX04SglSVgus
         9ILkvEDeXdm9QLjVrqYaJgNi9SdGy5Syvkc390HuR6tUesse0ldSmUR22AZKmZeDcck6
         t5NgwwJwMQavKI3fJkBvRnMO1AoBZVidPvzNe5q180Maim2/1hHdjW5yqKZFBDPPt+Go
         j6hVaEOfa1KBh5QDUUR6AEuxmzgYiWhL2GiT+72kf7k/QvFo8dhCkW3k/4Rvsd8r066a
         3aXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=B9O6HSSSA2HKZOCKluIOarWGuOU/V28mAm16p4AZpog=;
        b=eaQ7otF4oge8EyrK9H+sUdD8mcbBIsQ3GVnSLYl/QEZLmZ6tK95K8Kme4FZJqakf6F
         3WNSFJTdhmpAtivBUuZxGQgX9DkM8a09wGSVydFZg8+SyklLIaxI92SFF/1UTTknLlk/
         zwDejEL30w5nrWJCRfX3GmiKqwP2OKi5d9QQoYEdhTK13sHyoINXlcvyKWDd8ewYr7HN
         wyvWjzAslEeg+knlCdDFU8SrMPXpB+Zw5xOvSK34f0qIyzQanOsdOvbZ0iVljpQ5qg1R
         A7rIxd/pjuvg59Eh+uKnwYQlMNrRshPZrZF7Ag4FbBSbot0MRhkImf+99GfRRa9k47il
         K97A==
X-Gm-Message-State: AOAM531YNBWCFbx73WlKwWRkai0Tzs7kHXcLsDK+Svdj49Ct6WaZ+tKN
        /X6jNXXGbOYVU25zCZ4lNiA=
X-Google-Smtp-Source: ABdhPJzO0+9U+FL/VKs1l/V42kmY09zRexDPR8IHo2zt9zpFBADk0hAplX775josdotwPTNhlSkdgg==
X-Received: by 2002:a92:5214:: with SMTP id g20mr20724692ilb.219.1619557252439;
        Tue, 27 Apr 2021 14:00:52 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id f13sm1913311ila.62.2021.04.27.14.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 14:00:51 -0700 (PDT)
Date:   Tue, 27 Apr 2021 14:00:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <60887b7ba5bba_12319208a5@john-XPS-13-9370.notmuch>
In-Reply-To: <20210423002646.35043-11-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-11-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind()
 helper.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add new helper:
> 
> long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> 	Description
> 		Find given name with given type in BTF pointed to by btf_fd.
> 		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> 	Return
> 		Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

I'm missing some high-level concept on how this would be used? Where does btf_fd come
from and how is it used so that it doesn't break sig-check?

A use-case I'm trying to fit into this series is how to pass down a BTF fd/object
with the program. I know its not doing CO-RE yet but we would want it to use the
BTF object being passed down for CO-RE eventually. Will there be someway to do
that here? That looks like the btf_fd here.

Thanks,
John
