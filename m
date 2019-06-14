Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89804696E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfFNUai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:30:38 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33964 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfFNUah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 16:30:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id m29so4037537qtu.1;
        Fri, 14 Jun 2019 13:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AurvGG5md8kdmEphcGq2SiHYTXdU1Fp3TGMe3JSDOo0=;
        b=ponl8/TKF4625A5i4nwix1bf/BKuWpdnWdsbj1AYGUJeoO6YwVASh4cXNfVx9IvaZa
         CFwxikzqVVjimctDR05UE41qDDK4m4UYGGq6lT/dI8Ixp9oxQCdYqc2Z3XtJrBBoXrBq
         umOejNZ+ajnJrFU8/luWxLTc7Lm3AgFpFjiX5f8hfTa03/nmo8RpqMAR3V/rc21lr+pO
         P0+G+E4MVXjXkkNwPVaW1x6EO7L4vXqTBB1608iq6Bbm2erdxjqToEzmht7mQ7XHe7Ki
         LsXMlWNkp0G6rLPcPPR+KhweE4x8FfhIUl4x1cZTqJy/9LML7BZbbD8ApalUlsrWEJMI
         TxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=AurvGG5md8kdmEphcGq2SiHYTXdU1Fp3TGMe3JSDOo0=;
        b=hmaoyJeeNEhOBOKwg9knm4EQnvki0SP+Cww6MkRFwddDnPnw30mE9gLX2kDBZuL4No
         mMDyxpoY+8HQgnUxrWE46yVVXHK02+62v53rOPwFCimspnFtaNesk22Mm30tTlq5BMKV
         S5LoDSd7/DsNMPCWA2Ki7TVeRQqbe2mvWjJlLZ8a8H4C3hCzdtX4k9Gvq+QdTnduLXdf
         jU+4FWV9qyTMkGvKa/1X37yzNoyFBTMvp2z+uHNvQLXQ4aFjyumXNbzwSYqKHbAaEbu9
         OYnGtRWMmSSCsaIUOXBfbKuFcdTA4UVIXUmZh71ZPMVS4tFrNNSwQ5H1Nuu+E4iu5OsF
         wKJw==
X-Gm-Message-State: APjAAAWo8hlOEMfzT7Pbw05EyYd3W7tF0awUE8K8PzyTlBbrmdZW4cPd
        iLWE8GGv8Axb3NPIN5qX3kk=
X-Google-Smtp-Source: APXvYqzw+5pIEwdgx1vf8nomOEwKyVQrAuLI6zJPGXYa+IhlGCCOm1m2SixssVwluHArEdFBBF2Wxg==
X-Received: by 2002:ac8:1a39:: with SMTP id v54mr83461557qtj.21.1560544236029;
        Fri, 14 Jun 2019 13:30:36 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::6bab])
        by smtp.gmail.com with ESMTPSA id e8sm2215252qkn.95.2019.06.14.13.30.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 13:30:35 -0700 (PDT)
Date:   Fri, 14 Jun 2019 13:30:33 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v4 05/28] docs: cgroup-v1: convert docs to ReST and
 rename to *.rst
Message-ID: <20190614203033.GD657710@devbig004.ftw2.facebook.com>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
 <c1dd623359f44f05863456b8bceba0d8f3e42f38.1560361364.git.mchehab+samsung@kernel.org>
 <20190614141401.48bfb266@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614141401.48bfb266@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 02:14:01PM -0600, Jonathan Corbet wrote:
> On Wed, 12 Jun 2019 14:52:41 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
> > Convert the cgroup-v1 files to ReST format, in order to
> > allow a later addition to the admin-guide.
> > 
> > The conversion is actually:
> >   - add blank lines and identation in order to identify paragraphs;
> >   - fix tables markups;
> >   - add some lists markups;
> >   - mark literal blocks;
> >   - adjust title markups.
> > 
> > At its new index.rst, let's add a :orphan: while this is not linked to
> > the main index.rst file, in order to avoid build warnings.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> This one, too, has linux-next stuff that keeps it from applying to
> docs-next.  Tejun, would you like to carry it on top of your work?

Applied to cgroup/for-5.3.

Thanks.

-- 
tejun
