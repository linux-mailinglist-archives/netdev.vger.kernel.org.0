Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F0836D07A
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 04:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbhD1CLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 22:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhD1CLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 22:11:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E8FC061574;
        Tue, 27 Apr 2021 19:10:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p17so4039116pjz.3;
        Tue, 27 Apr 2021 19:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zcsDC9Mw8JIr79BrdQ+rOkT4hbkqTfsC+ofCHV93cV8=;
        b=VlUWOHN0t/FnWnvoXyxxwle1pbAmjAYzYzNzOcDI0rteQ4gSdBIjconQoPVJuqgvez
         N/6SMbHxEBQZzqbzHGLfTQtIL/cydW9l/PKjKfNqv8y0C0Q6NeX2LTuwdZRKFmvqyFxI
         97IMHY0zJzIjuM1UXlSN44admD9qX7stOy2HG6cUwelvT1eItG1QN0cCyBSR0g8BiQ6e
         o06ap34dX/7uLCYIWMUUr5n6Ult9tja0Mujhm7Doz8xQyTfo20UuObL0ZEZy8CKuPKlt
         2B9lPj9ayA6mgHhLlRVBBbx+CYnBahW1/uRKkQFE6qwYfyVg1HbD568I2/9Inos+rumS
         Pr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zcsDC9Mw8JIr79BrdQ+rOkT4hbkqTfsC+ofCHV93cV8=;
        b=QsAd/UdV67L3nihgL3i5KxnqQSYFTtPQtdHhOYLrNc2RTRZle7gZasejP2sV7EwybZ
         cWlHveuAsD/D93ExlI3CCPRQGOuQhGk/RTjgzaPKTGDsyMJQzMAyiz+5M+gPwbOaRUdV
         9YBiztkWhLnSHHIpBSzOmlRBa20pOJ4IXK1HgaEfRpX9KNP6rHa16RTdkxMuKNgG0LG/
         rSxNIQmZhUBoNWLbzptwID62CM2X0X+XyG5N3cH+PajiG+BTYynaVhtn20QckHlYWjUt
         9vR4Y7epUeBpEsTTycdpoe5tyEWdM445Ci9iBAcgAQ4aN8aG1QL5KNZr5jIROTnDchCo
         3RFQ==
X-Gm-Message-State: AOAM531HY8EsZLu+PaP7RgsImzOZLhiercEsnPYFNF9To0LjHvGdc+BE
        pDzkq5O1XShoA68EN2RDYQY=
X-Google-Smtp-Source: ABdhPJzYnNQ8OQjCsmw1cVsjtPxl6eOnzg6eNXPdSPaasl7YpuWsORuWWG7bohybX/5AGBPhiNhsVg==
X-Received: by 2002:a17:902:9f88:b029:ed:2b48:3a2c with SMTP id g8-20020a1709029f88b02900ed2b483a2cmr14542695plq.45.1619575824882;
        Tue, 27 Apr 2021 19:10:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2e71])
        by smtp.gmail.com with ESMTPSA id j24sm3392237pjy.1.2021.04.27.19.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 19:10:24 -0700 (PDT)
Date:   Tue, 27 Apr 2021 19:10:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind()
 helper.
Message-ID: <20210428021022.h3ihowtncydpsahp@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-11-alexei.starovoitov@gmail.com>
 <60887b7ba5bba_12319208a5@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60887b7ba5bba_12319208a5@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 02:00:43PM -0700, John Fastabend wrote:
> Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > Add new helper:
> > 
> > long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> > 	Description
> > 		Find given name with given type in BTF pointed to by btf_fd.
> > 		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> > 	Return
> > 		Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> 
> I'm missing some high-level concept on how this would be used? Where does btf_fd come
> from and how is it used so that it doesn't break sig-check?

you mean that one that is being returned or the one passed in?
The one that is passed in I only tested locally. No patches use that. Sorry.
It's to support PROG_EXT. That btf_fd points to BTF of the prog that is being extended.
The signed extension prog will have the name of subprog covered by the signature,
but target btf_fd of the prog won't be known at signing time.
It will be supplied via struct bpf_prog_desc. That's what attach_prog_fd is there for.
I can remove all that stuff for now.
The name of target prog doesn't have to be part of the signature.
All of these details are to be discussed.
We can make signature as tight as we want or more flexible.

> A use-case I'm trying to fit into this series is how to pass down a BTF fd/object
> with the program. 

I'm not sure I follow.
struct bpf_prog_desc will have more fields that can be populated to tweak
particular prog before running the loader.

> I know its not doing CO-RE yet but we would want it to use the
> BTF object being passed down for CO-RE eventually. Will there be someway to do
> that here? That looks like the btf_fd here.

I've started hacking on CO-RE. So far I'm thinking to pass spec string to
the kernel in another section of btf.ext. Similar to line_info and func_info.
As an orthogonal discussion I think CO-RE should be able to relocate
against already loaded bpf progs too (and not only kernel and modules).
