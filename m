Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FB7207A6C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405545AbgFXRi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405507AbgFXRi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:38:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2454C061573;
        Wed, 24 Jun 2020 10:38:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 35so1336927ple.0;
        Wed, 24 Jun 2020 10:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mis/DfE6WiK98NOncM/rO1hvergEoD0PamjT2G68eSg=;
        b=gBV38wvExd0Vp/6cIiCn8ZHT6x3gMnMruo3kZ43qtELkHgSnQ4arX+ASUgFEiQAa9H
         QAaoW/zksAFbq42B0ZZY7uUDhWxyXrjQRXvfd6MgOD0CPI8oMw0qxxBxQZEQ9gfdgohq
         RoAO8zFO+F0X1reD8f+2dRB9F+otvYz3n3li4th/0pXtkPB4Zwh8x05Nt7CxhzgorZ7Z
         zGoxcqRwEO/UTJzUCYtXp7zdZMgxqNYu/yR8S2xKZoHbh39uODHpeNgDWkVoNHsMNISv
         /4NB1zYaYDIX1HkUT9zt12mpwG6ViCYaEB77B/p84YyFtkfSiK3iZ1wlIP4XsjsXDmMt
         ZysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mis/DfE6WiK98NOncM/rO1hvergEoD0PamjT2G68eSg=;
        b=H5/IJv9p/M0fRms3yXlMYkpHzdKyAGG/GPotJ/YR3AYQOnrhoKLqvxeDjq1TDAuuOx
         MLZOm34l/4HcQ3cNivMZPPrCoIc2VxWkY72ifbEipln9XDbuLMbcMDXnvAdmGYqqJugb
         ddaSJuQilhrw+PPa57KC7kBm0YKuxhgbUFvLOueZAqoM6GMUA4wZiHGNWTkzH4QMYauR
         /iYghBj2FkhNBRBHAhXqkSrm76V9N6wYfgoEZskcZ4F646a6++SGloEp3QdFrWg2yQsp
         qEr1RhMP31Muv9VQJ++miX0410KkVG5+k+jcpxJM2ZQuE7YavnzBk/boX5zM8DcoTys1
         hbGg==
X-Gm-Message-State: AOAM5305H3x+fOeRdkM8knoR/x9/rY5hsfdiXvmFb7O3c1BfJPHJTpqr
        zkg2+RRDAQ9Q9eIOsKZxCWw=
X-Google-Smtp-Source: ABdhPJyZKRJyBdSekBbsRIUchhlOsxo8BMKNYvKg23lVBM3zERKP/AqB86+RrpTt7QIyowEstJf8nw==
X-Received: by 2002:a17:902:8508:: with SMTP id bj8mr27594864plb.231.1593020337040;
        Wed, 24 Jun 2020 10:38:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d17e])
        by smtp.gmail.com with ESMTPSA id r7sm16029541pfc.183.2020.06.24.10.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:38:56 -0700 (PDT)
Date:   Wed, 24 Jun 2020 10:38:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: add debug message for each created
 program
Message-ID: <20200624173854.xrnsbrjmrft7orus@ast-mbp.dhcp.thefacebook.com>
References: <20200624003340.802375-1-andriin@fb.com>
 <CAADnVQJ_4WhyK3UvtzodMrg+a-xQR7bFiCCi5nz_qq=AGX_FbQ@mail.gmail.com>
 <CAEf4BzYKV=A+Sd1ByA2=7CG7WJedB0CRAU7RGN6jO8B9ykpHiA@mail.gmail.com>
 <20200624145235.73mysssbdew7eody@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bzay9fErW5wooMBkmrHPK9T=e8O82cJc5NNq+wmugTznjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzay9fErW5wooMBkmrHPK9T=e8O82cJc5NNq+wmugTznjQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 09:34:52AM -0700, Andrii Nakryiko wrote:
> 
> Just yesterday (or two days ago, maybe), having those CO-RE relocation
> logs, which I fought to keep when I added CO-RE relocs initially,
> immediately shown that a person doesn't have bpf_iter compiled in its
> running kernel, despite the claims otherwise.
...
> of the time, but sometimes even these ELF parsing logs are important.

Prints for reloc make sense to me because that's libbpf's job.
Whereas info about elf sections could have been received by asking
that remote person to do objdump or llvm-objdump on the .o
Printing elf data from libbpf is an indication that libbpf itself
is not sure whether it has bugs in elf parsing. If that's the case
still after those years in production it just sad state of libbpf.
There could be an elf parsing bug there, of course, but keeping
all of that verbosity for likely rare bug is just not right.
