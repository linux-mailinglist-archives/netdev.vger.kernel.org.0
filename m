Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC9001509C
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfEFPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:47:29 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44666 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfEFPr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 11:47:29 -0400
Received: by mail-qk1-f194.google.com with SMTP id w25so2045503qkj.11;
        Mon, 06 May 2019 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E/XjEjFJHTNXNUvCeIBTVGrT6CD0tFJQfkjcnYeMhDY=;
        b=WFo86atePse5UmQK+FdjsQtdOQVjO6JrWLd1xYEi2IMozqnr1cQ3J6vuxd3K5gctkU
         XsHuazRLDKDlGNx+rMgrPMRCPJ6oBDmOOlutFuDcLwMPw4scj7kpqzMv7cl6hg35vWEY
         5Jo6jnIk5CH1m9lNzIXjTixLiTU77ECI7aUU/JbALWp0cMUgMEwkMgZ7hD3uN9i6ImhW
         2a3f1jij5WKh6ZVyp1ZYKiNoBS3PgNo3b11OoMZftLmzMwIrn3ULeWrJwifkleo4h6d6
         bKGMiQvOOvCNzRjOGOOP6O5nxYth83P/miVp9QGwck0+wEWuGrwwA1wlrLAfhekoHQTn
         pYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=E/XjEjFJHTNXNUvCeIBTVGrT6CD0tFJQfkjcnYeMhDY=;
        b=NTNWAM4SS7AOFuCA0Kiu3c+b8LmjB+xLCrDGUkba+mYj5LDMBfA9GhBRQCuLy3TuH4
         jCVgt7gjD7QS1cDdm2zmsoNUFzIK1LNgN8i1rZSzswEK4NWUCAb36sGYGmopXgtFSfO9
         ikD6c4W9gVejNPrfKHGR1cCnCmHnmzHvlNeYOPEq7GOlL1YbZNvn2nMCV0+SUcXvG/6v
         DSoFpBYZpRbj2hnlpCR9RhUVchEkDlZ8C1AfVIJsVSum89XBoYNFJRj+Wyq1N5AhIVyQ
         EgFBVIC1YudFsjxGm/UQX2D94YjSwE+ViJtcROsW4RoH4DFR4rJBmBJ7/H2xYC+4RaTb
         98Ug==
X-Gm-Message-State: APjAAAWTFqphWOk4BKHRdouGRrmAfFyNou0+amEv8C1obHttu3S6c0Hj
        nk5EMp6Mhyx+loATAA3xtXs=
X-Google-Smtp-Source: APXvYqyGWKd+xSOSpvNfUpsvwC4L227cvwkKiLHI1zuDfWsdmprNrmz8KfFvHgA6pkY4TuPO96A4Rg==
X-Received: by 2002:a37:de16:: with SMTP id h22mr19541559qkj.306.1557157647429;
        Mon, 06 May 2019 08:47:27 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::3:34f3])
        by smtp.gmail.com with ESMTPSA id i23sm8328331qtc.18.2019.05.06.08.47.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 08:47:26 -0700 (PDT)
Date:   Mon, 6 May 2019 08:47:25 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH v2 08/79] docs: cgroup-v1: convert docs to ReST and
 rename to *.rst
Message-ID: <20190506154725.GS374014@devbig004.ftw2.facebook.com>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
 <c6e79690c038fc6bbf9265a065c1f861d6e156fa.1555938375.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6e79690c038fc6bbf9265a065c1f861d6e156fa.1555938375.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 22, 2019 at 10:26:57AM -0300, Mauro Carvalho Chehab wrote:
> Convert the cgroup-v1 files to ReST format, in order to
> allow a later addition to the admin-guide.
> 
> The conversion is actually:
>   - add blank lines and identation in order to identify paragraphs;
>   - fix tables markups;
>   - add some lists markups;
>   - mark literal blocks;
>   - adjust title markups.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route with other patches in the series.

Thanks.

-- 
tejun
