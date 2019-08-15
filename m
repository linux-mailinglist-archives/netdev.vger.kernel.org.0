Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB378F767
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbfHOXIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:08:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42478 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfHOXIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:08:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id i30so2074739pfk.9;
        Thu, 15 Aug 2019 16:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WUOGRc+b3FNmz2WGFq2daNWr7YqADgbIBAantoAxloM=;
        b=GRS9p4jY4AoO6/yR42WqFnWS1/AKYRrIrVOcUzjTUQrFIc76bn9aJPfDKU6BA00Jau
         REahX3rY02npYwbEKfJOhXKrWEbgcL7Nl4c4owgCDY31yYX1rkdP8Dso+lrUL0OM+kxV
         rbVX8pVU52AQ/6iJXIU2YmE3Pqv7OdMwmswYCOk5OD526rvw7WlAXkYuNYArd8uUoERY
         ijdBJc4ZYqB/NVRHw6lFohSiuHSxmh6CEGN5nF9Gkrs8I0gLNwitXDFQt5eQput5CJKw
         i0MR08+6FRHGDBKwE1crJMATklfGBhQ4qTpMAQzKsoExOtl+yTZsbBBWV+AyYy4kijgL
         mZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WUOGRc+b3FNmz2WGFq2daNWr7YqADgbIBAantoAxloM=;
        b=YoT3OFwGaR8Mta4ic11a8KZDUJZ87GERNc6b7dsgp9UXfa4NVcZ1W0ZHeYEWtpT5Od
         RsedI5kxUO0JEauDAm4s67hE0y4MsFGnEMVx49xmNXT62gJ+mVLyrv+pW7PZZkPbJh3M
         ZjqcalHuhhkGW5HoxWsKd4lc1Z/hHY9AnmHcAST9L7FtnOlPc7hsj4SYQh3GQrEamy1V
         RKNQlJZSEVXl/mmB+c/z5dU2PjS1VKKxm3ZMK/Z8+yu/EJf2fbF7b+qaDJhlV8vuTh37
         fHxgvpmnlP0sCIlP4OmuE35JHE4AghAuNCMrOsCg+qHmJ9yfFFkCzZ5ExoOvFs53rOqJ
         Xeyg==
X-Gm-Message-State: APjAAAUvCkGHB7EoMU6t8ybeo+1dYrRd0c+MkGjyU9IWNeAyQTX+9p3b
        hxnIRH+BgEFfnDXq/Przkp4=
X-Google-Smtp-Source: APXvYqwj1SaTO9I6PFG/dr61Njl0UQp747MB9uIzK3qGOaiFKI2H70E95dwD/Pj+UbDGJn4R4+kXww==
X-Received: by 2002:a63:e48:: with SMTP id 8mr5191221pgo.389.1565910492955;
        Thu, 15 Aug 2019 16:08:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::e9c1])
        by smtp.gmail.com with ESMTPSA id w2sm3068647pjr.27.2019.08.15.16.08.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 16:08:11 -0700 (PDT)
Date:   Thu, 15 Aug 2019 16:08:10 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jordan Glover <Golden_Miller83@protonmail.ch>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:36:43AM -0700, Andy Lutomirski wrote:
> On Thu, Aug 15, 2019 at 10:29 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Aug 15, 2019 at 11:24:54AM +0000, Jordan Glover wrote:
> > > systemd --user processes aren't "less privileged". The are COMPLETELY unprivileged.
> > > Granting them cap_bpf is the same as granting it to every other unprivileged user
> > > process. Also unprivileged user process can start systemd --user process with any
> > > command they like.
> >
> > systemd itself is trusted. It's the same binary whether it runs as pid=1
> > or as pid=123. One of the use cases is to make IPAddressDeny= work with --user.
> > Subset of that feature already works with AmbientCapabilities=CAP_NET_ADMIN.
> > CAP_BPF is a natural step in the same direction.
> >
> 
> I have the feeling that we're somehow speaking different languages.
> What, precisely, do you mean when you say "systemd itself is trusted"?
>  Do you mean "the administrator trusts that the /lib/systemd/systemd
> binary is not malicious"?  Do you mean "the administrator trusts that
> the running systemd process is not malicious"?

please see
https://github.com/systemd/systemd/commit/4c1567f29aeb60a6741874bca8a8e3a0bd69ed01
I'm not advocating for or against this approach.
Call it 'security hole' or 'better security'.
There are two categories of people for any feature like this.
My point that there is a demand to use bpf for non-root and CAP_NET_ADMIN
level of privileges is acceptable.
Another option is to relax all of bpf to CAP_NET_ADMIN instead of CAP_SYS_ADMIN.
But CAP_BPF is clearly better way.

> My suggestions upthread for incrementally making bpf() depend less on
> privilege would accomplish this goal.

As I pointed out countless times it would make the system overall _less_ secure.
One of the goals here is to do sysctl kernel.unprivileged_bpf_disabled=1 to
make it _more_ secure.

