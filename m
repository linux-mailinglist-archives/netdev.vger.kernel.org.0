Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F53F11ECE8
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 22:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLMVat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 16:30:49 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46218 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMVat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 16:30:49 -0500
Received: by mail-lj1-f196.google.com with SMTP id z17so177537ljk.13;
        Fri, 13 Dec 2019 13:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pMi5moIG8qddSFN8zehd51EPEpBLLmj69ce7JfgsI0s=;
        b=htkGW6s9fMYoS5CeTq5XgT7TTqVYvKI+y9g7l2qv8PfcFv/uc+48EdHuLu0KKxQOZo
         Wf4s7jsyMKpNDCt6Leo8b9fzXVXVbXZwMgE7rJBwlsVo9N2LLcBLbNn8jfHGBkK70woU
         mx2NGTJfFuboVCH7Rk0JmSkAs8NYpcTnQtWs4fNg5l5xkoYQTuubSzaphuQQ9xEEiIjf
         kOxOWIVepe4dlDeEPBpZEY7hlviH+rpnT6IDiLN/VjppaRCPQVkF9AYyML8VanPr5vjS
         Nv0mIa0vzgzlEkhSUYHkNC5gDZ0Yosg7hewfwB6yg7iHBlKscpGYCeAMXDzQ1t3RNJNW
         Hyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pMi5moIG8qddSFN8zehd51EPEpBLLmj69ce7JfgsI0s=;
        b=YGpl5CS+sLzkHmvNlGuzw4EaHD+Fn8t7GNfVkapohTia25eLQqQr1/yj5hXPbWfVtD
         DtrAhR9FNUuQZx5IttXHIYdiR8dpeCnLx9uBF9UKhptoRGthjkVvQYBiqa1ppGzrv2N+
         ePQJYPqfMykso5HHgNBPnLJ5Ee+mvjHRBkEuFnbaN+LcMk8kHaluDQO9qBwNuWe27E0x
         asr67umsssAL1gAxH4NpbdzxURgKUiFy6GCWhfzA4XQnWBXC9LtE2hpG9AOJ6n3jc9zV
         7SIQSIrxAb605XWqAwVpgAQyiBefdKcx47OYrDrwRcwzEUyfuOQDvfxkb9ERcjIbU3s0
         clKg==
X-Gm-Message-State: APjAAAV4rIqAMSPt0Brc5sHaYJ3z0U0FMTr7YjlgroDzQd9cF6CTxlAZ
        w3Tc9Zz6y/oDGD92ZoVzEbjCz5/F6Gby/bkenHA=
X-Google-Smtp-Source: APXvYqzUA28Dw1B9rwqFTXIcpROiWYPdr74HaJhqBZqTVaXZNOS8rDYEMRT28TGwRfEunhvWWzx0Fq1Sn1N2c8WJZHE=
X-Received: by 2002:a2e:99cd:: with SMTP id l13mr11001811ljj.243.1576272646759;
 Fri, 13 Dec 2019 13:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20191211175349.245622-1-sdf@google.com> <CAADnVQLAShTWUDaMd26cCP-na=U_ZVUBuWaXR7-VGV=H6r_Qbg@mail.gmail.com>
 <20191213212322.GP3105713@mini-arch>
In-Reply-To: <20191213212322.GP3105713@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 13:30:35 -0800
Message-ID: <CAADnVQKB+JafsQT4qjgECc1WzhoRvisO86NfS3D5-v-OYW5KgQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: expose __sk_buff wire_len/gso_segs to BPF_PROG_TEST_RUN
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 1:23 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 12/13, Alexei Starovoitov wrote:
> > On Wed, Dec 11, 2019 at 9:53 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > wire_len should not be less than real len and is capped by GSO_MAX_SIZE.
> > > gso_segs is capped by GSO_MAX_SEGS.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >
> > This change breaks tests:
> > ./test_progs -n 16
> > test_kfree_skb:PASS:prog_load sched cls 0 nsec
> > test_kfree_skb:PASS:prog_load raw tp 0 nsec
> > test_kfree_skb:PASS:find_prog 0 nsec
> > test_kfree_skb:PASS:find_prog 0 nsec
> > test_kfree_skb:PASS:find_prog 0 nsec
> > test_kfree_skb:PASS:find global data 0 nsec
> > test_kfree_skb:PASS:attach_raw_tp 0 nsec
> > test_kfree_skb:PASS:attach fentry 0 nsec
> > test_kfree_skb:PASS:attach fexit 0 nsec
> > test_kfree_skb:PASS:find_perf_buf_map 0 nsec
> > test_kfree_skb:PASS:perf_buf__new 0 nsec
> > test_kfree_skb:FAIL:ipv6 err -1 errno 22 retval 0 duration 0
> > on_sample:PASS:check_size 0 nsec
> > on_sample:PASS:check_meta_ifindex 0 nsec
> > on_sample:PASS:check_cb8_0 0 nsec
> > on_sample:PASS:check_cb32_0 0 nsec
> > on_sample:PASS:check_eth 0 nsec
> > on_sample:PASS:check_ip 0 nsec
> > on_sample:PASS:check_tcp 0 nsec
> > test_kfree_skb:PASS:perf_buffer__poll 0 nsec
> > test_kfree_skb:PASS:get_result 0 nsec
> > #16 kfree_skb:FAIL
> > Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> Ugh, it's probably because of '__skb->wire_len < skb->len' check.
> Let me take a look.
>
> (sorry, I'm still not running/looking at full test_progs because BTF support
> is WIP in our toolchain and some subtests fail because of that,
> generating a bunch of noise).

I thought all bpf-next developers are developing against that tree ?
Are you saying you cannot install the latest clang/pahole on your
development system?
git pull llvm;ninja;ninja install;
git pull pahole; cmake;make
why is it not possible?
Now your complains about skeleton make more sense,
but it's an issue with your particular setup.

Anyway I'm not sure that this test issue is actually an issue with your patch.
It could be that this test is flaky in a weird way. Just with and without your
kernel patch it's 100% reproducible for me and I need to keep the rest
of the patches
moving without introducing failures in my test setup.
All that will get resolved when we have kernel CI.
