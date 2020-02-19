Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F0164AA0
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 17:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgBSQhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 11:37:40 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33055 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgBSQhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 11:37:39 -0500
Received: by mail-lf1-f66.google.com with SMTP id n25so652611lfl.0;
        Wed, 19 Feb 2020 08:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iu8Su62Lx6G7NQ7VTXQB00i29wr5tuhT9NpagmWKkGs=;
        b=rnCJByyiPYNjDhjdfTZp5+OjAkMgvmj/vL+JE4lRnGBxTjAClFJyXErfVglS/EsHej
         Oqr/vzk62telFtUak6fnwIA0C7MrM0/M4ay8jT6k7KKJF5OGqUKaaxSKYG8JoJzaFygm
         xhX09nbLseabDhp7kDci5Nb5VXDi8MgKI4zQFsqGmCEyNnGVy8GY30xah450ETBlw16k
         ikX4kCQi7Fa8ZGHL9G1l7CnV6DfKtaF6Jil+wiG9udbu3zP6j3cZK908bgRkvQiKuisu
         UJL05LixhhyZBWzGptIP9iw7c8hU+XzPS+ZDXFXXaycvtMQlqwD7oJHh03eyl19WH555
         pUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iu8Su62Lx6G7NQ7VTXQB00i29wr5tuhT9NpagmWKkGs=;
        b=YnxOX3zpluOnMh+8Ll44o1wwc6v3KX+eTlmfzLdnTKFmsc1yNZQEteXuB/vGTU5mwe
         aVNqWkSRVvvEfJR04fzbF3N94xVUMJHow+8KFtbs7yk9WgOmH+pzyFBEahfViEgxtlHO
         adeK0CP24ue1ZN54NZVhPUlLBCc1klsKTVTrOSO6hjGyUAO5/z/ac0kqMdg2YmXT4xAD
         JdUw5KdDKrvll2MCGpdb7sfzY+F1A6zhRQDWhHyEeNBGnOIGR+ozB46YzAGpjcHSHw4e
         mYi9nsHUwrR3ofTskdr7PhMrWMnCy/i6d5iQ5E58i1FC/QhI65n2rJCqzeb5/EVsZiik
         CZSA==
X-Gm-Message-State: APjAAAXF5QhAdnWdEcBx6JL82KwsrwmizJQA4+AN2P+IdcRe0Tf8PAks
        Um9r/Pnqou/TDkoIduBejJPosVShVTSU46gM0l56cg==
X-Google-Smtp-Source: APXvYqyZXXgGUsrmB7smOwrThCKSrBFcNYDQijyrqFmYfRiO/UeECbjs/x+Qj5rKUxiIW1iHEOBmCPU0Dz2L7rg/HF8=
X-Received: by 2002:ac2:515b:: with SMTP id q27mr13400289lfd.119.1582130257014;
 Wed, 19 Feb 2020 08:37:37 -0800 (PST)
MIME-Version: 1.0
References: <20200218190224.22508-1-mrostecki@opensuse.org>
 <CAADnVQJm_tvMGjhHyVn66feA3rHLSXTdzqCCABu+9tKer89LVA@mail.gmail.com> <06ae3070-0d35-df49-9310-d1fb7bfb3e67@opensuse.org>
In-Reply-To: <06ae3070-0d35-df49-9310-d1fb7bfb3e67@opensuse.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Feb 2020 08:37:25 -0800
Message-ID: <CAADnVQLhEaV=dWMZC83g5QHit7Qvu4H84Dh--K3aOTiUNeEd4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] bpftool: Allow to select sections and filter probes
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 4:33 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> On 2/19/20 4:02 AM, Alexei Starovoitov wrote:
> > The motivation is clear, but I think the users shouldn't be made
> > aware of such implementation details. I think instead of filter_in/out
> > it's better to do 'full or safe' mode of probing.
> > By default it can do all the probing that doesn't cause
> > extra dmesgs and in 'full' mode it can probe everything.
>
> Alright, then I will send later v2 where the "internal" implementation
> (filtering out based on regex) stays similar (filter_out will stay in
> the code without being exposed to users, filter_in will be removed). And
> the exposed option of "safe" probing will just apply the
> "(trace|write_user)" filter_out pattern. Does it sound good?

yes. If implementation is doing filter_in and applying 'trace_printk|write_user'
strings hidden within bpftool than I think it should be good.
What do you think the default should be?
It feels to me that the default should not be causing dmesg prints.
So only addition flag for bpftool command line will be 'bpftool
feature probe full'
