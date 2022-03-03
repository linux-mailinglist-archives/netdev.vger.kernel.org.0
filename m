Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A074CC93F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbiCCWke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbiCCWkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:40:33 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1653B1533A7;
        Thu,  3 Mar 2022 14:39:47 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t14so5945750pgr.3;
        Thu, 03 Mar 2022 14:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eWDKJRYY6oFHnn34EJL4pDVUO+3dJRu5ycnBE7hvdes=;
        b=AkhtvnwAqD27ux5bXVvk0MLcX5a1fieqcywUeIsJJLTtPW1wTcmKUfWWup/0XyUZyB
         tyy8NXFcZCVVONQZnGmiY7HOEx+mLa7KY24aLknoh6adS03prOaEDJSqugK2/asB2ads
         gkliC/omB/xF9qNKjqxkjDcJrHfCsH2hs2XuwensYsXGooDm+lOgZBm0+hgrgqDwUOPU
         xXi+tKFg6yxyonhnNXZcPU8PPzvkptfnd57CnBZwC93wEENXFWzmkcWINhC87CdZ5ycA
         tMEtY6sZf+a/YcYar71kkAM1uC6XIwUIwdm6sFaU0bnh9818K0c74zTwUJRTXKxN1Gtg
         tM0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eWDKJRYY6oFHnn34EJL4pDVUO+3dJRu5ycnBE7hvdes=;
        b=AUgRVBP+0b1iTVltrNk+Cd1oOOznx7F2KsW5/sUlkytUsU58pRQwNty87wleMT9xCn
         Z75O0bGLTBctX/46j+17/jo7l4kqAwuaMiBTRCqTGYvnbA3wq2AlUbHgC8Lt6Q/OFKyl
         OulwI0n0v1Z2hV5HHneWWBnf0KbC7NptC0HFJIVju9V8Pwep3E99GWKXLadm+wxWZ7IF
         jIWR3ogPa8+hd9JqpDxsUWTF3ADRutKgCILW3fg65jmj4gNwtISaYa/oa+UNwe4OkAyK
         G+4a1zz22Rz29RgT0cPjJb3ZZKifE6CSq3I+ukPZpHiFPHVwe4p2xdAPAccZxRCPy53/
         k79w==
X-Gm-Message-State: AOAM532o6p2Vmo7A7o7TKeBeo2hAK0kt0FxpeU/J6OfWjZIejFSN2aCL
        ohWTwZDcZz8i8vyVVpDUQ5dXiIpm0NptIBf2nE0=
X-Google-Smtp-Source: ABdhPJzfIILGrDAUb4PgBCLExnCATh8xb3uP0X+L+S7XB9RvY14Y9Xzz1WzFDUu+/9NXgaaJtCTV9ZBHJQF/7RJuvBk=
X-Received: by 2002:a65:5386:0:b0:375:ec6f:667f with SMTP id
 x6-20020a655386000000b00375ec6f667fmr29590342pgq.543.1646347186560; Thu, 03
 Mar 2022 14:39:46 -0800 (PST)
MIME-Version: 1.0
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
 <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
 <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
 <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com>
 <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
 <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com> <b6bf8463c1b370a5b5c9987ae1312fd930d36785.camel@linux.ibm.com>
In-Reply-To: <b6bf8463c1b370a5b5c9987ae1312fd930d36785.camel@linux.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Mar 2022 14:39:35 -0800
Message-ID: <CAADnVQKfh3Z1DXJ3PEjFheQWEDFOKQjuyx+pkvqe6MXEmo7YHQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     KP Singh <kpsingh@kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florent Revest <revest@google.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 11:13 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Thu, 2022-03-03 at 19:14 +0100, KP Singh wrote:
> >
> > Even Robert's use case is to implement IMA policies in BPF this is still
> > fundamentally different from IMA doing integrity measurement for BPF
> > and blocking this patch-set on the latter does not seem rational and
> > I don't see how implementing integrity for BPF would avoid your
> > concerns.
>
> eBPF modules are an entire class of files currently not being measured,
> audited, or appraised.  This is an integrity gap that needs to be
> closed.  The purpose would be to at least measure and verify the
> integrity of the eBPF module that is going to be used in lieu of
> traditional IMA.

Mimi,

. There is no such thing as "eBPF modules". There are BPF programs.
They cannot be signed the same way as kernel modules.
We've been working on providing a way to sign them for more
than a year now. That work is still ongoing.

. IMA cannot be used for integrity check of BPF programs for the same
reasons why kernel module like signing cannot be used.

. This patch set is orthogonal.
