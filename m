Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82E107D42
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 07:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfKWGEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 01:04:54 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45078 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfKWGEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 01:04:54 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so4459490pgg.12;
        Fri, 22 Nov 2019 22:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TsdUFXwI/NP2wCqkX0MN5IOUKQLHKe3NYK3DcrYEplg=;
        b=BarH2V7KScDfJ35roVlDpHTUNpffubJ6bLIiIV0K/HjRI+FB2siuPWtDyd7OJbpWYH
         HFPMkkGJbTYuumJXsnFEpC742yl06X6jF5nQeHj+GzXA31hDl8w2+/Xc7tR9h1RLx1zl
         3vlQEKUfgJgzyM+QzBCyoIec7HeVAGny8Qj6iKim6bb8WPaKi60pXX1K7OqaEJiZYo9n
         gtwFcy5hFhpGFcpGcn410sK+xQOupsh9q96hVagA4XqYCBXnw9OdBRLvwmK94N2u4INC
         Ex0TlnOWUfv6aJ27DtBXsMfKRM806/99WOU5FLmIUmLnKujIQE1z0uWyWEF8v0b07iLx
         ofnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TsdUFXwI/NP2wCqkX0MN5IOUKQLHKe3NYK3DcrYEplg=;
        b=oE4zFdoQclarr+M800dly9tqYTRrgH+dbTDw72IypHsJU2PUu7X+nCY5a6RXSfi4Br
         WT/APFz44pqmUQOzBE/987IhbStbBZXcjDj029lyH0eQshzqq6EfcI+iI/dsjzJ/c6dy
         xzSSWiq6MZOZaFUmLgimpVIwyhaUoweFYF6umGm4fiXM+kj/M943xhkmL4cltaCHX9jE
         x/j+W/BQg1pzD/s5vz1V/wE6mtB/4MMLwWwWAieehaM/5yaMLCtP48xRnKgEtinuQJ/V
         c+kvKt4je3VMsIvlmv+pYWzbSy9hNlLMIj67oH1kALVjFa9PozTM03dpjnlsqJQug0wA
         6pgg==
X-Gm-Message-State: APjAAAUlSZmXk3SGzlKS5EwrLS5VQGZWTzj5u20Ca7+23z3efcqYc++T
        QdoDP8WsuPENWxQun1j6Dn6Vz4mv
X-Google-Smtp-Source: APXvYqyzVoJjxeaiIH9Tlb2xf/uDwkkld0NHCsYVPG4ngmXhToskMjtYdJGXNSEWq30XVq0DDt4g+Q==
X-Received: by 2002:a63:4721:: with SMTP id u33mr20175746pga.159.1574489093359;
        Fri, 22 Nov 2019 22:04:53 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::2490])
        by smtp.gmail.com with ESMTPSA id j21sm9409603pfa.58.2019.11.22.22.04.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 22:04:52 -0800 (PST)
Date:   Fri, 22 Nov 2019 22:04:50 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191123060448.7crcqwkfmbq3gsze@ast-mbp.dhcp.thefacebook.com>
References: <cover.1574162990.git.ethercflow@gmail.com>
 <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
 <20191123031826.j2dj7mzto57ml6pr@ast-mbp.dhcp.thefacebook.com>
 <20191123045151.GH26530@ZenIV.linux.org.uk>
 <20191123051919.dsw7v6jyad4j4ilc@ast-mbp.dhcp.thefacebook.com>
 <20191123053514.GJ26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123053514.GJ26530@ZenIV.linux.org.uk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 05:35:14AM +0000, Al Viro wrote:
> On Fri, Nov 22, 2019 at 09:19:21PM -0800, Alexei Starovoitov wrote:
> 
> > hard to tell. It will be run out of bpf prog that attaches to kprobe or
> > tracepoint. What is the concern about locking?
> > d_path() doesn't take any locks and doesn't depend on any locks. Above 'if'
> > checks that plain d_path() is used and not some specilized callback with
> > unknown logic.
> 
> It sure as hell does.  It might end up taking rename_lock and/or mount_lock
> spinlock components.  It'll try not to, but if the first pass ends up with
> seqlock mismatch, it will just grab the spinlock the second time around.

ohh. got it. I missed _or_lock() part in there.
The need_seqretry() logic is tricky. afaics there is no way for the checks
outside of prepend_path() to prevent spin_lock to happen. And adding a flag to
prepend_path() to return early if retry is needed is too ugly. So this helper
won't be safe to be run out of kprobe. But if we allow it for tracepoints only
it should be ok. I think. There are no tracepoints in inner guts of vfs and I
don't think they will ever be. So running in tracepoint->bpf_prog->d_path we
will be sure that rename_lock+mount_lock can be safely spinlocked. Am I missing
something?

> > > with this number; quite possibly never before that function had been called
> > > _and_ not once after it has returned.
> > 
> > Right. TOCTOU is not a concern here. It's tracing. It's ok for full path to be
> > 'one time deal'.
> 
> It might very well be a full path of something completely unrelated to what
> the syscall ends up operating upon.  It's not that the file might've been
> moved; it might be a different file.  IOW, results of that tracing might be
> misleading.

That is correct. Tracing is fine with such limitation. Still better than probe_read.

