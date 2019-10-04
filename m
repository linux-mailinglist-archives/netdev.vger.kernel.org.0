Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B76CBE28
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389489AbfJDOzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:55:24 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33913 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389453AbfJDOzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:55:24 -0400
Received: by mail-io1-f66.google.com with SMTP id q1so14231562ion.1;
        Fri, 04 Oct 2019 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lySVyY6S/EXogGChREznd5exFANJjYqJuJ60CrXFHhU=;
        b=il1pSjwPu6Ex2mNYPcg8np45Bg/98GF6sR5oUYqR2Jk0RdRk8BDZlN7JOuV4eJIsh8
         SiSuC0BoiMhbsr5BGqi4uZ8Gb73VZrFyDCRTuQB5WgU2auf4Y/PnjGT3BR/XjgIo9B8g
         XBkdxnkhbbLiW5VHi+k47b2hfn+NbEcDYeNe5imOmxUTrgFEpLYSV0qdT0wBJi9RN7hv
         ytmV4xoIfnTxbRAW6HDAMvWS9sVsx7zeXzidkSPp36Pg8/1PPEeEoWazWjZB246sKzAt
         S5zp7Ni0KvirgT0SSWjgL40EVn9MBTmrUAGzPepY/zI6ynk0Gk5KXASKFlhyhvieCip9
         /6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lySVyY6S/EXogGChREznd5exFANJjYqJuJ60CrXFHhU=;
        b=XYlpZ/XZsW4MZV0mvzrR8liyriUQ7tsW8jyezmL7HvqWHsLBgiLId5OzVMR/HKfqyl
         IkCmw8+HQtEmsU2frKuOeqqhrRtt9iqMXvHhyBicvZxdKj13/u6WsJ8mlzd2KQUOCkCp
         2N44/xHam0EKfiQ77+UKdQF3VfRtrHAypJOrJ/j5cf6IpP/ar5MAWWB3FJ8QGGWa2LJt
         4Bl9JPI5Cebd1z21srZhc1E4NvQSqZU/0nuzOn/XldTm7XXtRKbXCfD2sLrRnBsUdTjd
         XGwWFAHpGkdiH7kTMiCLaRKKFTy6C/5a0Ub8tKDLahZNaFxywasscX71dyigrdTcgrCF
         SMCQ==
X-Gm-Message-State: APjAAAUKoZV53JYJ0FZNLJ1MPJUd/QL35UGLxUe2OiQTD/sjZDm0hT3j
        tft8uzzxzTUC8u1RSeSKR0k=
X-Google-Smtp-Source: APXvYqzUm5SAYR8M4/F/Dueg8eXd1NVITnxbIvZWbuZIBRU3spHNOmRQZBWX5rV+sSkwh/4uoOfgUA==
X-Received: by 2002:a92:16da:: with SMTP id 87mr15915664ilw.211.1570200923346;
        Fri, 04 Oct 2019 07:55:23 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p16sm2854026iln.35.2019.10.04.07.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 07:55:22 -0700 (PDT)
Date:   Fri, 04 Oct 2019 07:55:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Message-ID: <5d975d54abdfc_35a52afafc1345bcdb@john-XPS-13-9370.notmuch>
In-Reply-To: <fb67f98a-08b4-3184-22f8-7d3fb91c9515@fb.com>
References: <20191004030058.2248514-1-andriin@fb.com>
 <20191004030058.2248514-2-andriin@fb.com>
 <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
 <CAEf4BzbP=k72O2UXA=Om+Gv1Laj+Ya4QaTNKy7AVkMze6GqLEw@mail.gmail.com>
 <fb67f98a-08b4-3184-22f8-7d3fb91c9515@fb.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version,
 populate it for users
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On 10/4/19 7:32 AM, Andrii Nakryiko wrote:
> >> If we are not going to validate the section should we also skip collect'ing it?
> > Well, if user supplied version, we will parse and use it to override
> > out prepopulated one, so in that sense we do have validation.
> > 
> > But I think it's fine just to drop it altogether. Will do in v3.
> > 
> 
> what about older kernel that still enforce it?
> May be populate it in bpf_attr while loading, but
> don't check it in elf from libbpf?

Yeah, guess I wasn't thinking clearly this morning. The way my BPF progs
are currently written we use the version section to populate the kver.
Easy enough to change though if we think its cleaner to use an attribute
to set it. Actually, seems better to pass via bpf_attr IMO because
currently we use defines to populate the version which is a bit ugly.
