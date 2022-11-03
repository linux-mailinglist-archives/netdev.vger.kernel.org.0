Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC5A61873F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiKCSPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiKCSPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:15:20 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F34167D0;
        Thu,  3 Nov 2022 11:15:13 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u24so4270273edd.13;
        Thu, 03 Nov 2022 11:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hpUWD+YhtOzA0jc8BXPLurYBvg3g1SF91WdxaY8kuSg=;
        b=piOPI/2n64inWAd4dAPDDYloRLYd4EcEp85U48/4ASGi/fj5jLAoJs32492KPRdgBW
         dp3qOcUzC1fhFBYTokF/8FHd2rTYlT1r0LmVISULPSs+nnjtgAzlLwRIn9KcjLc4lKB5
         wdFHeDQiF20z5fGWlJYNSl+VyQqga7HpIoYQxfSCorbdwv+YSlLZTkhQVlVxFJhqW0fO
         AUUuSIUldQomKkzcyJLDPcBuL4zBVVgRNYqssM8uJT5CbzSlIlbfrPI23iT8b+eDUVnb
         syJh32pyHKqdCCAIWPoTJjoCxPAez1viTiZnVd8As9aSq2IFsCTx7LeFGcyifa9irud9
         7aUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hpUWD+YhtOzA0jc8BXPLurYBvg3g1SF91WdxaY8kuSg=;
        b=xWtFah68RbXMo6eOiZF/ZJ7jc/9N4CQ9kRaYmuGZPFmqWrdMY/qG/jrGj15Ttt5Co4
         cSNJ1ZSCSrJ3GBqRCsJlFsEnnzx3LYKsNRQ0rYZycnRpTh4AebuD7seZ26Kd6WZw46ik
         ridV1jE5mB1p92NF3u4Edts6MKRdlZWcfT70kfxGQsZKm/J0lGiFQgWKw2y7hvIMobvP
         Beijf8QkS2NWtNLuX5n+4f7PwUdkEMCPinaksDQpBRu4IYI9+TlC/qgPqjR3RWevbIH2
         LEncqSSDLUwFnqFNm+ouOO/QpSUrW60m5JzPFWVOtgCo27QV6gtVcjls5efiEOpWYvMa
         DhVg==
X-Gm-Message-State: ACrzQf1OyGwdMTn5BuewxLAdLwvCeY5Kim//FswUP2S5MEHhutU2bFFT
        a+vt88GepwW1v5itXmrlG1sUGpH8pzvJBMPL3I8=
X-Google-Smtp-Source: AMsMyM4NHmB3buGFso/OgW21idkxjVoJccMg+7Bxc1FmyjmDmcOUiQ1ODXhYJIBD1KoquMzlA/bpmG0Tw05sgFG0mXk=
X-Received: by 2002:aa7:c6c1:0:b0:460:f684:901a with SMTP id
 b1-20020aa7c6c1000000b00460f684901amr31666662eds.6.1667499311857; Thu, 03 Nov
 2022 11:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-3-yangjihong1@huawei.com> <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
In-Reply-To: <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Nov 2022 11:15:00 -0700
Message-ID: <CAADnVQ+gX8Xc57K2hSG5ZNfU1RtKBFgEp2yOWq08X68bWjMqsg@mail.gmail.com>
Subject: Re: [PATCH bpf RESEND 2/4] bpf: Remove size check for sk in
 bpf_skb_is_valid_access for 32-bit architecture
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Yang Jihong <yangjihong1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>,
        Artem Savkov <asavkov@redhat.com>, bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 4:23 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Thu, Nov 03, 2022 at 05:21:16PM +0800, Yang Jihong wrote:
> > The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
> > This is because bpf_object__relocate modifies the instruction to change memory
> > size to 4 bytes, as shown in the following messages:
> >
> > libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
> > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
> > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
> >
> > As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
> > unnecessary checks need to be deleted.
>
> Isn't the purpose of this check to ensure that the entire pointer is
> written, and BPF can't write half of it?
>
>
> >       case offsetof(struct __sk_buff, sk):
> > -             if (type == BPF_WRITE || size != sizeof(__u64))
> > -                     return false;
>
> Wouldn't "(size != sizeof(struct bpf_sock *) && size != sizeof(__u64))"
> be more appropriate here, so 32-bit can only write the 32-bit pointer
> or the full 64-bit value, and 64-bit can only write the 64-bit pointer?
> Or is there a reason not to? bpf folk?

You're correct. The patch is completely wrong.
The bug is elsewhere.
