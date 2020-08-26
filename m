Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA882537F4
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHZTNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgHZTNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:13:05 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410B3C061574;
        Wed, 26 Aug 2020 12:13:04 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id t6so3627899ljk.9;
        Wed, 26 Aug 2020 12:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZiXOO5FpngiYweKJgzDa8Z+wo7f+rbji0luwABt9fiU=;
        b=uoh/yV1KiL17KBpuqqT/Pg8KYgKHJgyRt8QI9gtULhHPZpMsNqAFx0Y1HJ068heVn+
         b13VqwcGRSSRC89hxZI79yDFD1Mk3jeYx0JIIHzAnMU1zAGMIoW5beDoIIxf8vvlpWZQ
         6GBsjUrjq37gcTof624cNMqDA6ll4tcaJ38yBJ4QLrJz0/DAGXbYBRVMBJetAhlUeZV/
         Gb2YCo3791tw+r2G1f1zMW5ag/KX2ruXq5+nrqldOL+unnm0lSx4swjwqleMMP7v+23J
         rWqoxv0STOWfSPP3kC6yhu22HniAkPourpfeFICL9HZwNxaZYqW/yJ/ejbt/zfgU+MBp
         i7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZiXOO5FpngiYweKJgzDa8Z+wo7f+rbji0luwABt9fiU=;
        b=seXry+Kpc8QyxTpY9dLsslgUqvR1RmhvqAStaWgzU2n3PSrm9H3YJUfQrge3nc8YFL
         G0Gvz72rv+y7DaRTPsAxD91CObAkZ+JvIQIU1Uc5NhTpg4DZhfulNgZiKie6Bw0mFBJl
         qXp3lptisupmITOotF4hCZL8XvnI9wMSNSqGPSkmyqlnWL3t53NZUN/I1nSWq1k6Nplv
         NyfC9Tcx6guNb54AqI1C8a5XM4uSXCHDNyC5R9XgdtONWhpQdCyTYT/0eSyPTAJfCvwS
         tpUFGP54lKTg6xhN1DnGCQruioIkphkBpuyNNZDC66h1H3acMbWgoBN8sSi62TRX/NL6
         VtDQ==
X-Gm-Message-State: AOAM531PEUXeanfvxSANbONjVP76OrMACcLyCVZN3G9CfcHOxvdcUwbu
        q9GlokNUwPjAed+mCfVsMRHbcgkh2KE0VhZ5pWS/Y7bNFuI=
X-Google-Smtp-Source: ABdhPJzNhmbE7y+d0PydrNDvqHITPKb/PEnqf5BTksJSC/rfjR1CsNym3Gvvxvif5V+4YAkOtSKa2POe2BCY0yfGkt0=
X-Received: by 2002:a2e:9e4e:: with SMTP id g14mr378990ljk.450.1598469182328;
 Wed, 26 Aug 2020 12:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
 <20200824220100.y33yza2sbd7sgemh@ast-mbp.dhcp.thefacebook.com> <CACXrtpQCE-Yp9=7fbH9sB7-4k-OO12JD18JU=9GL_sYHcmnDtA@mail.gmail.com>
In-Reply-To: <CACXrtpQCE-Yp9=7fbH9sB7-4k-OO12JD18JU=9GL_sYHcmnDtA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Aug 2020 12:12:50 -0700
Message-ID: <CAADnVQL1O3Ncr5iwmZx_5FgVrwbXmEWZfGm_ASrTcu0j6YGbiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] bpf: add MPTCP subflow support
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        mptcp@lists.01.org, Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 11:55 AM Nicolas Rybowski
<nicolas.rybowski@tessares.net> wrote:
>
> Hi Alexei,
>
> Thanks for the feedback!
>
> On Tue, Aug 25, 2020 at 12:01 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Aug 21, 2020 at 05:15:38PM +0200, Nicolas Rybowski wrote:
> > > Previously it was not possible to make a distinction between plain TCP
> > > sockets and MPTCP subflow sockets on the BPF_PROG_TYPE_SOCK_OPS hook.
> > >
> > > This patch series now enables a fine control of subflow sockets. In its
> > > current state, it allows to put different sockopt on each subflow from a
> > > same MPTCP connection (socket mark, TCP congestion algorithm, ...) using
> > > BPF programs.
> > >
> > > It should also be the basis of exposing MPTCP-specific fields through BPF.
> >
> > Looks fine, but I'd like to see the full picture a bit better.
> > What's the point of just 'token' ? What can be done with it?
>
> The idea behind exposing only the token at the moment is that it is
> the strict minimum required to identify all subflows linked to a
> single MPTCP connection. Without that, each subflow is seen as a
> "normal" TCP connection and it is not possible to find a link between
> each other.
> In other words, it allows the collection of all the subflows of a
> MPTCP connection in a BPF map and then the application of per subflow
> specific policies. More concrete examples of its usage are available
> at [1].
>
> We try to avoid exposing new fields without related use-cases, this is
> why it is the only one currently. And this one is very important to
> identify MPTCP connections and subflows.
>
> > What are you thinking to add later?
>
> The next steps would be the exposure of additional subflow context
> data like the backup bit or some path manager fields to allow more
> flexible / accurate BPF decisions.
> We are also looking at implementing Packet Schedulers [2] and Path
> Managers through BPF.
> The ability of collecting all the paths available for a given MPTCP
> connection - identified by its token - at the BPF level should help
> for such decisions but more data will need to be exposed later to take
> smart decisions or to analyse some situations.
>
> I hope it makes the overall idea clearer.
>
> > Also selftest for new feature is mandatory.
>
> I will work on the selftests to add them in a v2. I was not sure a new
> selftest was required when exposing a new field but now it is clear,
> thanks!
>
>
> [1] https://github.com/multipath-tcp/mptcp_net-next/tree/scripts/bpf/examples
> [2] https://datatracker.ietf.org/doc/draft-bonaventure-iccrg-schedulers/

Thanks! The links are certainly helpful.
Since long term you're considering implementing path manager in bpf
I suggest to take a look at bpf_struct_ops and bpf based tcp congestion control.
It would fit that use case better.
For now the approach proposed in this patch is probably good enough
for simple subflow marking. From the example it's not clear what the networking
stack is supposed to do with a different sk_mark.
Also considering using sk local storage instead of sk_mark. It's arbitrary size.
