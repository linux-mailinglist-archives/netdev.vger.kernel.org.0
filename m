Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1A1BB385
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgD1BkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbgD1BkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 21:40:16 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B21AC03C1A8;
        Mon, 27 Apr 2020 18:40:16 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id s30so16118055qth.2;
        Mon, 27 Apr 2020 18:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oQ1PRq8YJ6rFSjaWjcwv39nmTX0ZhCPh6qqqxXUPIzw=;
        b=OuxLdLyVX+0Qd/oYDB3qe4xREmNNbbHI6nepjMKIalwe3gT4SmR4e+Aqfq9UVhiuEp
         D5Iyzj2CyQPBugBKuZJGtuk6sGXTwZ1QS6BBnajLGMPjluTJDLr7ylOun3mWi7+iHrn+
         U14k3RvRZBUiaZap+hHE/qqs8jlFdpDQw1A1Z618yNqiv/aDdZXB+az/5Zi2n3Oyhgd3
         90j5xW46w+aSSrfCP4La3FJ/GwwQdCVio9QkfmyExoWuxDaHSRRuXQDofnpne3bTS789
         JkbZP0not8ovBH/Nr3yB70AzSpm60+yOj08fmERoo48oaVwZtcO+U8YzsJRlO4jL/+R5
         R5Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQ1PRq8YJ6rFSjaWjcwv39nmTX0ZhCPh6qqqxXUPIzw=;
        b=XLvaAXJ+3cL2WOhX2p8K4mkuHYa+304fP8oLZ9PAuWuMpl2XDGIl897GvNYVmKpBfU
         036aQ021OtVBFcQ/t8NSzb1P/vRdGUxrmreqnWrfnhLB3tZAu9zmZ6GO4CkXqa9dm720
         joCwGAIBjzqTL4TgTILo6IbNT72PP/WZWaPzs2AgPyHc8YFAHfLy84T/vZwbgvGIevUR
         f6F45mU1euwqwFZdF6kWXSj/uv3N8yfaNG34FZ64rUUoLZfIe+OpGyIUxRuscRV9C9ga
         p6j0ExtZrEX4LEdhe3sax8CY0QJCrX735J7eKiIe/al/qhNXPa5Qi4wc++T38DAxRqYn
         CRkg==
X-Gm-Message-State: AGi0Pub+7Nr9MxNxRQ/7j4cheEVFfg8TlDZC9cjNK5knuRPsgNQyytQS
        Z4nx+rtTRmc4BMI1pUBXrEF6US4xTfBSWYqvhuw=
X-Google-Smtp-Source: APiQypIOyf7y10cok83a/w9m2tXPvicgVwQo01KfjmFle3WZRK1dv6qRmH4KWuPpXYPjIMsBn/akJZrYpFgxj1sPuXo=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr25564296qtk.171.1588038015385;
 Mon, 27 Apr 2020 18:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200304204157.58695-1-cneirabustos@gmail.com>
 <CAADnVQL4GR2kOoiLE0aTorvYzTPWrOCV4yKMh1BasYTVHkKxcg@mail.gmail.com> <20200313124642.GA1309@bpf-dev>
In-Reply-To: <20200313124642.GA1309@bpf-dev>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Apr 2020 18:40:04 -0700
Message-ID: <CAEf4BzbzOqBew+kySpqNTgzXpa009KjoXOLpjZ8FvNr5Jo7gXg@mail.gmail.com>
Subject: Re: [PATCH v17 0/3] BPF: New helper to obtain namespace data from
 current task
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 5:48 AM Carlos Antonio Neira Bustos
<cneirabustos@gmail.com> wrote:
>
> On Thu, Mar 12, 2020 at 05:45:09PM -0700, Alexei Starovoitov wrote:
> > On Wed, Mar 4, 2020 at 12:42 PM Carlos Neira <cneirabustos@gmail.com> wrote:
> > >
> > > Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> > > scripts but this helper returns the pid as seen by the root namespace which is
> > > fine when a bcc script is not executed inside a container.
> > > When the process of interest is inside a container, pid filtering will not work
> > > if bpf_get_current_pid_tgid() is used.
> > > This helper addresses this limitation returning the pid as it's seen by the current
> > > namespace where the script is executing.
> > >
> > > In the future different pid_ns files may belong to different devices, according to the
> > > discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> > > To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> > > This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> > > used to do pid filtering even inside a container.
> >
> > Applied. Thanks.
> > There was one spurious trailing whitespace that I fixed in patch 3
> > and missing .gitignore update for test_current_pid_tgid_new_ns.
> > Could you please follow up with another patch to fold
> > test_current_pid_tgid_new_ns into test_progs.
> > I'd really like to consolidate all tests into single binary.
>
> Thank you very much Alexei,
> I'll start working on the follow up patch to add test_current_pid_tgid_new_ns into test_progs.
>

Hey Carlos,

Do you still plan to fold test_current_pid_tgid_new_ns into test_progs?

> Bests
