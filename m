Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC0E9F7AF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 03:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfH1BNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 21:13:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37125 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfH1BNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 21:13:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id y9so533075pfl.4
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 18:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/cYWQqNcCbuxiV+OsyVfdzyuvK/p9vbp0fj96eOdne4=;
        b=jNz5iexFkoI36kjbIpzMNkcA+tmswVa1Ul/gDzfnDHt1g2+0TPXx0rZ39GCRtM6a/3
         iWqpbIqeMuq77/qi+oH7Yh7elMzNspO8TXTzHjHDBr4h2KJdLPTT0xTqSz0zCniP55q6
         DsfbiMrF+0z7CmaEWMtzVHpN8cjmxu0Q9uNiEN3L8TShpdqf118pRv9NpZDlJ/UgvgTK
         if08ghZtAdGmfLeNE3pQ61lNSvFjvScFnoVA0gXBNt/ga08KXJMOZFEI2GPz5BX//C+f
         38LVnU3AIpbcQy03C31cL68a065ZmZDPcirP+4N20pzi90k+O8SZJ8J8moHoms5Gh5fo
         nxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/cYWQqNcCbuxiV+OsyVfdzyuvK/p9vbp0fj96eOdne4=;
        b=chpCHnqRAdi6EHOD+sd5aY94XCTsbwKW/d2bZYgnvw2PoldLWFZ97w3ZUj2XPUlsbQ
         mAriY3xiLitLAJBg5jV35DYKk/dVTe8DH/Yi0p8zi2WQ9YT/gq1SSS+iHmM8CS2c69/q
         Ht/5h9RWqAgOeLzAIM51dsnlVxm7nzzW+yw1YukJAIpUPWa60yLmvQM/hDcpvAIpGzPj
         TZozivO5M3Xwhib2AaxVxvwUGDEijKEUl33xK/qtkxsOKU7LjxdtF/AOzoT000+T25DE
         R8wsUB1ei3mxL3H8Lx16YYNkoS8ow4vxxqgDNjVq7KVbHbIOg+fh9w3zLCtlETlycdfp
         Gffg==
X-Gm-Message-State: APjAAAXHysrDqPu+3QedPL0YIWeohEcQHMek6h7y4hhgx8F3il2Jwc/B
        AANjPyAMuvrnPuQRfD+0IAIiVg==
X-Google-Smtp-Source: APXvYqwNHIR81G2gcKR7HFSUEWQ0lKv6amlnuam++kCS/2/OzzfUhFSvI6Zt8h+gEsi1SW/6SWMwRw==
X-Received: by 2002:a17:90a:eb05:: with SMTP id j5mr1654616pjz.102.1566954781651;
        Tue, 27 Aug 2019 18:13:01 -0700 (PDT)
Received: from ?IPv6:2600:1012:b004:a485:8535:78a7:b30d:25f5? ([2600:1012:b004:a485:8535:78a7:b30d:25f5])
        by smtp.gmail.com with ESMTPSA id d6sm498953pgf.55.2019.08.27.18.13.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 18:13:00 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <20190827204433.3af91faf@gandalf.local.home>
Date:   Tue, 27 Aug 2019 18:12:59 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A95DA1BC-E2A1-4CC3-B17F-36C494FB7540@amacapital.net>
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com> <20190827192144.3b38b25a@gandalf.local.home> <CALCETrUOHRMkBRJi_s30CjZdOLDGtdMOEgqfgPf+q0x+Fw7LtQ@mail.gmail.com> <20190827204433.3af91faf@gandalf.local.home>
To:     Steven Rostedt <rostedt@goodmis.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 27, 2019, at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Tue, 27 Aug 2019 16:34:47 -0700
> Andy Lutomirski <luto@kernel.org> wrote:
>=20
>>>> CAP_TRACING does not override normal permissions on sysfs or debugfs.
>>>> This means that, unless a new interface for programming kprobes and
>>>> such is added, it does not directly allow use of kprobes. =20
>>>=20
>>> kprobes can be created in the tracefs filesystem (which is separate from=

>>> debugfs, tracefs just gets automatically mounted
>>> in /sys/kernel/debug/tracing when debugfs is mounted) from the
>>> kprobe_events file. /sys/kernel/tracing is just the tracefs
>>> directory without debugfs, and was created specifically to allow
>>> tracing to be access without opening up the can of worms in debugfs. =20=

>>=20
>> I think that, in principle, CAP_TRACING should allow this, but I'm not
>> sure how to achieve that.  I suppose we could set up
>> inode_operations.permission on tracefs, but what exactly would it do?
>> Would it be just like generic_permission() except that it would look
>> at CAP_TRACING instead of CAP_DAC_OVERRIDE?  That is, you can use
>> tracefs if you have CAP_TRACING *or* acl access?  Or would it be:
>>=20
>> int tracing_permission(struct inode *inode, int mask)
>> {
>>  if (!capable(CAP_TRACING))
>>    return -EPERM;
>>=20
>>  return generic_permission(inode, mask);
>> }
>=20
> Perhaps we should make a group for it?
>=20

Hmm. That means that you=E2=80=99d need CAP_TRACING and a group. That=E2=80=99=
s probably not terrible, but it could be annoying.

>>=20
>> Which would mean that you need ACL *and* CAP_TRACING, so
>> administrators would change the mode to 777.  That's a bit scary.
>>=20
>> And this still doesn't let people even *find* tracefs, since it's
>> hidden in debugfs.
>>=20
>> So maybe make CAP_TRACING override ACLs but also add /sys/fs/tracing
>> and mount tracefs there, too, so that regular users can at least find
>> the mountpoint.
>=20
> I think you missed what I said. It's not hidden in /sys/kernel/debug.
> If you enable tracefs, you have /sys/kernel/tracing created, and is
> completely separate from debugfs. I only have it *also* automatically
> mounted to /sys/kernel/debug/tracing for backward compatibility
> reasons, as older versions of trace-cmd will only mount debugfs (as
> root), and expect to find it there.
>=20
> mount -t tracefs nodev /sys/kernel/tracing

Too many slashes :/

A group could work for v1.  Maybe all the tools should get updated to use th=
is path?

>=20
> -- Steve
>=20
>>=20
>>>=20
>>> Should we allow CAP_TRACING access to /proc/kallsyms? as it is helpful
>>> to convert perf and trace-cmd's function pointers into names. Once you
>>> allow tracing of the kernel, hiding /proc/kallsyms is pretty useless. =20=

>>=20
>> I think we should.
>=20
