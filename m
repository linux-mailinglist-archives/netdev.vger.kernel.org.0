Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE683A0EC2
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 02:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfH2A6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 20:58:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32789 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH2A6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 20:58:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so898014pfq.0
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 17:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HCu9GxKna/uq7gKa9s14Sv2OjTD6YUF4iS2Qub5oG9Q=;
        b=A/b0mZPCuCZ0+yZ5B1ZDDH3FBsg5PH+aIZHT5TTam3sKPpZnX8Xci7elVgUzCDq2uG
         5UdViTmoXZwPI6tpvtcnAPo8uI/p28yZs/CfTiKgfYRxIIF12KQ5CmPypyjZsTePlfG2
         7O68jorQ7f3Ntm9mZckv98/rfACRVD79xS+psxSmnMKG5J2T2fBZ5yW9PXFpX2PaUt8n
         bAVXd4zrxBVr4iwA6p7UnCFsRPWbMlFJQMxIaCOj2lMJxeD62Lu+3sxqLu6NyzrymwWj
         0yFkFl5QAKeP42zcKV9dJUC7Fzd9/MJQljcZpfO1l211rl9Sxq9R6aBrAsmTSxCCUmnd
         YgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HCu9GxKna/uq7gKa9s14Sv2OjTD6YUF4iS2Qub5oG9Q=;
        b=nwOzgKCOVrJqtQdJbNOY3S7jPTiIYYGLrETfFA5zRCM7NvvJJuzy8qeW19aE6XZLAL
         uVhaWBNsr2XrVoWqsUJarg6hfEnUmoKgIhoy3h8OzuQLnKQC0IcYr6/+jMwhZZSS0A1x
         4ZzugekNa+G4kHjQ5cXWXs0HZE8tHjt2jrau6im4/rvdfg8ncScSCJif1PtM7wtKIzvK
         9rRNKlmozUwGBCa/oQOumQkFqTJhBfjE3moHXbTn77uisjzhxIAKWzXrw3+QHqQFI4TE
         jjIYvihGoxduAW0ShhyioUC5XmJJJTqcV6Aqfu7TJiGyCUtSOoAMdv9xy9d9Dte/xAMp
         K0WQ==
X-Gm-Message-State: APjAAAUQ59uh3R5ILu61YWjN4lnLyFrPFxbSZCTDwvqZg73VW9CqzN15
        rS81VsFqj5EUro9S81YSO+g3mw==
X-Google-Smtp-Source: APXvYqwExxgHxqVlV8wOamSNqpOY8/PTR//jv1jEK9C6+n0BnhBf7kvocV2uwd5BL9TtgdeFCrm3rQ==
X-Received: by 2002:a62:3145:: with SMTP id x66mr8155519pfx.186.1567040312675;
        Wed, 28 Aug 2019 17:58:32 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:9437:f332:3e4c:f05b? ([2601:646:c200:1ef2:9437:f332:3e4c:f05b])
        by smtp.gmail.com with ESMTPSA id 4sm695379pfe.76.2019.08.28.17.58.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 17:58:31 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <20190828233828.p7xddyw3fjzfinm6@ast-mbp.dhcp.thefacebook.com>
Date:   Wed, 28 Aug 2019 17:58:31 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <63F74C1D-F061-41D6-A3CA-02EE640FEA8D@amacapital.net>
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com> <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com> <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com> <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com> <20190828044903.nv3hvinkkolnnxtv@ast-mbp.dhcp.thefacebook.com> <CALCETrX-bn2SpVzTkPz+A=z_oWDs7PNeouzK7wRWMzyaBd4+7g@mail.gmail.com> <20190828233828.p7xddyw3fjzfinm6@ast-mbp.dhcp.thefacebook.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 28, 2019, at 4:38 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
>> On Tue, Aug 27, 2019 at 11:20:19PM -0700, Andy Lutomirski wrote:
>> On Tue, Aug 27, 2019 at 9:49 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>>=20
>>>> On Tue, Aug 27, 2019 at 07:00:40PM -0700, Andy Lutomirski wrote:
>>>>=20
>>>> Let me put this a bit differently. Part of the point is that
>>>> CAP_TRACING should allow a user or program to trace without being able
>>>> to corrupt the system. CAP_BPF as you=E2=80=99ve proposed it *can* like=
ly
>>>> crash the system.
>>>=20
>>> Really? I'm still waiting for your example where bpf+kprobe crashes the s=
ystem...
>>>=20
>>=20
>> That's not what I meant.  bpf+kprobe causing a crash is a bug.  I'm
>> referring to a totally different issue.  On my laptop:
>>=20
>> $ sudo bpftool map
>> 48: hash  name foobar  flags 0x0
>>    key 8B  value 8B  max_entries 64  memlock 8192B
>> 181: lpm_trie  flags 0x1
>>    key 8B  value 8B  max_entries 1  memlock 4096B
>> 182: lpm_trie  flags 0x1
>>    key 20B  value 8B  max_entries 1  memlock 4096B
>> 183: lpm_trie  flags 0x1
>>    key 8B  value 8B  max_entries 1  memlock 4096B
>> 184: lpm_trie  flags 0x1
>>    key 20B  value 8B  max_entries 1  memlock 4096B
>> 185: lpm_trie  flags 0x1
>>    key 8B  value 8B  max_entries 1  memlock 4096B
>> 186: lpm_trie  flags 0x1
>>    key 20B  value 8B  max_entries 1  memlock 4096B
>> 187: lpm_trie  flags 0x1
>>    key 8B  value 8B  max_entries 1  memlock 4096B
>> 188: lpm_trie  flags 0x1
>>    key 20B  value 8B  max_entries 1  memlock 4096B
>>=20
>> $ sudo bpftool map dump id 186
>> key:
>> 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> 00 00 00 00
>> value:
>> 02 00 00 00 00 00 00 00
>> Found 1 element
>>=20
>> $ sudo bpftool map delete id 186 key hex 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00
>> [this worked]
>>=20
>> I don't know what my laptop was doing with map id 186 in particular,
>> but, whatever it was, I definitely broke it.  If a BPF firewall is in
>> use on something important enough, this could easily remove
>> connectivity from part or all of the system.  Right now, this needs
>> CAP_SYS_ADMIN.  With your patch, CAP_BPF is sufficient to do this, but
>> you *also* need CAP_BPF to trace the system using BPF.  Tracing with
>> BPF is 'safe' in the absence of bugs.  Modifying other peoples' maps
>> is not.
>=20
> That lpm_trie is likely systemd implementing IP sandboxing.
> Not sure whether it's white or black list.
> Deleting an IP address from that map will either allow or disallow
> network traffic.
> Out of band operation on bpf map broke some bpf program. Sure.
> But calling it 'breaking the system' is quite a stretch.
> Calling it 'crashing the system' is plain wrong.
> Yet you're generalizing this bpf map read/write as
> "CAP_BPF as you=E2=80=99ve proposed it *can* likely crash the system."
> This is what I have a problem with.

Well, after I sent that email, firewalld on my laptop exploded and the syste=
m eventually hung.  I call that broken, and I really made a minimal effort h=
ere to break things.

>=20
> Anyway, changing gears...
> Yes. I did propose to make a task with CAP_BPF to be able to
> manipulate arbitrary maps in the system.
> You could have said that if CAP_BPF is given to 'bpftool'
> then any user will be able to mess with other maps because
> bpftool is likely chmod-ed 755.
> Absolutely correct!
> It's not a fault of the CAP_BPF scope.
> Just don't give that cap to bpftool or do different acl/chmod.

I see no reason that allowing a user to use most of bpftool=E2=80=99s functi=
onality necessarily needs to allow that user to corrupt the system. It obvio=
usly will expand the attack surface available to that user, but that should b=
e it.

I=E2=80=99m trying to convince you that bpf=E2=80=99s security model can be m=
ade better than what you=E2=80=99re proposing. I=E2=80=99m genuinely not try=
ing to get in your way. I=E2=80=99m trying to help you improve bpf.
