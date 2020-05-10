Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABAE1CC5C1
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgEJAal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726356AbgEJAal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:30:41 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B19EC061A0C;
        Sat,  9 May 2020 17:30:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d22so2714799pgk.3;
        Sat, 09 May 2020 17:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1TnOjzAhaCG9wfDY8OdCpYMCZYj6rLcaf71uTBktBf4=;
        b=Lyr7Gu5AuMuU9rVrbGtScXaswAmFWHpkOoI4QZ+toMPsTt5F0Kp4/y/mYQXw9V+gHl
         u0HyZEVbEwyKNWo1lubWjhSJja9+c0/Lw19HEaAIo2ZskZciGNxyzV7jKkQdPNAu1JTu
         DU8CkeWdmw+LltBDqTya6D6rq8CSymECGvEMekHnBwosdFYV0w0pEG4jtuclcTcK0Lwz
         YahejnDakW9GjaDrHbi5bFwzveL6+Kr5XP4YXloCkIKFbe96lMszepmkCGcthrNr9YX9
         hQJAAqSn8GmMkDptHqK0uPUQro8hBEey+zYplYXnW4vY8K26ZmG5Xg7QwrLhm90kUHB6
         IugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1TnOjzAhaCG9wfDY8OdCpYMCZYj6rLcaf71uTBktBf4=;
        b=PiiUATMRTZOEwzSKKRu/FxoKA0R6cOmdFyvnx/PD1F0aYbBiO1IYPF06YvnJzvadYq
         NnxOOAxK1kREfIUVwCA7HUG+k3nWb/X0f0AP29oPjmpk7q0RKkDyLPXvVNA6TNTpRzJ8
         Z7rAKnTFjXG45iI6KftkS9WOlcL0qRMUnbe6dsICQDzOE74KmhRPmRbTHoBbf6TIHBh6
         NLcBT9EnATOmLVKONv5VVDPa9umB87cCUvjVoswUMj/1x9qBcJGip919N54pH4byN+cJ
         rdsVsY44lCQpilJakAW1FwC04vX/e/jVwz/6GG5ap4wP0EHA9/25A7lYlh2oKyltrgwI
         b9/Q==
X-Gm-Message-State: AGi0PuZzLDXPu5awU1p/I7pHsjl4U7n5ImIk3TzxYOmsYicq31nZNqOp
        MFy99fqxgh8IzLAvImWH5UI=
X-Google-Smtp-Source: APiQypIwMtb5CIsnCLEvtBSto/KEoPx9gGCZybIg1Zj53CflCmi6ym3m8DuiNQgxKI7Z8bLXfukNeQ==
X-Received: by 2002:a63:e602:: with SMTP id g2mr8485819pgh.380.1589070639066;
        Sat, 09 May 2020 17:30:39 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7bdb])
        by smtp.gmail.com with ESMTPSA id o9sm5926080pje.47.2020.05.09.17.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 17:30:38 -0700 (PDT)
Date:   Sat, 9 May 2020 17:30:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v4 05/21] bpf: implement bpf_seq_read() for bpf
 iterator
Message-ID: <20200510003036.3xzunae5nd75ckc2@ast-mbp>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175904.2475468-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509175904.2475468-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 10:59:04AM -0700, Yonghong Song wrote:
> +
> +		err = seq->op->show(seq, p);
> +		if (err > 0) {
> +			seq->count = offs;

as far as I can see this condition can never happen.
I understand that seq_read() has this logic, but four iterators
implemented don't exercise this path.
I guess it's ok to keep it, but may be add warn_once so we notice
when things change?
