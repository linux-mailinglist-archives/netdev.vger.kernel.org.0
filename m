Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFD4107CF1
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 06:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKWFT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 00:19:26 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37318 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfKWFT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 00:19:26 -0500
Received: by mail-pf1-f195.google.com with SMTP id p24so4628236pfn.4;
        Fri, 22 Nov 2019 21:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wbVNh4nY4m20xaygscQgN6RCfW7Ty50zZgXpDPj6YY4=;
        b=cTMxTE9XNmY90IWwreSLmBFOFVNvsktmfBA9Fp8Ujc9S+VPA20pL9YG0GrmP/Qwk70
         RC/L+Mj8fNeGBrGU9fPyyRdXp7Ha1+aji5aMV5j3sloHneJmjAroZKo7QgdgtVlBOcmG
         WmyQ6dWx7IB3yMQPXTR31SSujhNFL5357k7fCY4s6Q4zXO50mojPsFcEdv1EOhSBywn1
         F8nccgv4ghqoESoF8CQSWXGNVtqEw15D+nT9XgkDvYNqjv8+BjN2u+3N3Kk0JQ1vmx50
         gCa/+P58HVE00qZVdZs4ovirhtGMX1pq4zT993b1X/UvHBiU2PqFBjp0KL3pNcCnFi02
         qtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wbVNh4nY4m20xaygscQgN6RCfW7Ty50zZgXpDPj6YY4=;
        b=na+Rp/vBek/pYtk2v8ZRcbMHjYYUUmJ849c24VN//MGjOae+2mWayVpxK8QvFgAxXN
         X6O/SHlj8KLZSerwPY+ZeTh709f7K9OqD7SfcXtbQFkHn4emtBh9SHdt0zKkBw8jcge3
         Cf9Uw0RTL6bGToBrCThcAoT8ek/1yH6hBkVYNyre7UMclCKlXI0/JJf2sMNGSvVw3Ova
         wB256h3k+RZWrC+CuuEK8GKZ2OTwUN0GlZ/K9+U7CxIiMFrRoc4EDT6K3xfHKp30FMPW
         QtWKD99LabKTvicrMcE0R+7KA9GWRHKpjMcP6BSCo8FhNGo+pA09AZel/c9KN/LTXlpS
         64hg==
X-Gm-Message-State: APjAAAWUZwukoB5+RWzfMFqYDNyGmLEhtIUTjDzVpYRlTXxbJSFGYWui
        jMV0EE7g9SinrDHqRTiVaiQ=
X-Google-Smtp-Source: APXvYqxZ/bv/60++5Ec5oIcBBFFQ5LOGfzyURIEi8D2Gn+PdLNIyuM5jt48g1oh6kTh6ovmMr2wQ9A==
X-Received: by 2002:a62:53c6:: with SMTP id h189mr21634847pfb.93.1574486363942;
        Fri, 22 Nov 2019 21:19:23 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::2490])
        by smtp.gmail.com with ESMTPSA id fh11sm615691pjb.2.2019.11.22.21.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 21:19:22 -0800 (PST)
Date:   Fri, 22 Nov 2019 21:19:21 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191123051919.dsw7v6jyad4j4ilc@ast-mbp.dhcp.thefacebook.com>
References: <cover.1574162990.git.ethercflow@gmail.com>
 <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
 <20191123031826.j2dj7mzto57ml6pr@ast-mbp.dhcp.thefacebook.com>
 <20191123045151.GH26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123045151.GH26530@ZenIV.linux.org.uk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 04:51:51AM +0000, Al Viro wrote:
> On Fri, Nov 22, 2019 at 07:18:28PM -0800, Alexei Starovoitov wrote:
> > > +	f = fget_raw(fd);
> > > +	if (!f)
> > > +		goto error;
> > > +
> > > +	/* For unmountable pseudo filesystem, it seems to have no meaning
> > > +	 * to get their fake paths as they don't have path, and to be no
> > > +	 * way to validate this function pointer can be always safe to call
> > > +	 * in the current context.
> > > +	 */
> > > +	if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname)
> > > +		return -EINVAL;
> 
> An obvious leak here, BTW.

ohh. right.

> Depends.  Which context is it running in?  In particular, which
> locks might be already held?

hard to tell. It will be run out of bpf prog that attaches to kprobe or
tracepoint. What is the concern about locking?
d_path() doesn't take any locks and doesn't depend on any locks. Above 'if'
checks that plain d_path() is used and not some specilized callback with
unknown logic.

> Anyway, what could that be used for?  I mean, if you want to check
> something about syscall arguments, that's an unfixably racy way to go.
> Descriptor table can be a shared data structure, and two consequent
> fdget() on the same number can bloody well yield completely unrelated
> struct file references.

yes. It is racy. There are no guarantees on correctness of FD.
The program can pass arbitrary integer into this helper.

> IOW, anything that does descriptor -> struct file * translation more than
> once is an instant TOCTOU suspect.  In this particular case, the function
> will produce a pathname of something that was once reachable via descriptor
> with this number; quite possibly never before that function had been called
> _and_ not once after it has returned.

Right. TOCTOU is not a concern here. It's tracing. It's ok for full path to be
'one time deal'. Right now people use bpf_probe_read() to replicate what
d_path() does.
See https://github.com/iovisor/bcc/issues/237#issuecomment-547564661
It sort of works, but calling d_path() is simpler and more accurate.
The key thing that bpf helpers need to make sure is that regardless of
how they're called and what integer is passed in as an FD the helper
must not crash or lockup the kernel or cause it to misbehave.
Hence above in_interrupt() and other checks to limit the context.

