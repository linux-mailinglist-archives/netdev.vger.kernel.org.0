Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C3A6C596B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 23:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCVW1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 18:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVW1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 18:27:48 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAFC23A50;
        Wed, 22 Mar 2023 15:27:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b20so46137863edd.1;
        Wed, 22 Mar 2023 15:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679524065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/Wjm0b8Ik7+X2MQf3m3hky1zdDJvNFJ4agRqoB9mA0=;
        b=JQUJQb9gDALwd6Y7wgUsxJSfzD42gRcFCBl+E45QH5FnfzpRHlivPXbtU6vl/Go/yc
         z/o6VwbUuEs2rsAmGDsfIRwoKU+G5hvXOOKpjvk8mm9iCZFfAHNkwtfyM+9CuOZ8ZYV1
         z2ef2J+von7Wvbkr+dMh4qaRJmRq6pXhDiFs/Dyol8PVYRTOR86kWd1gtPPFAfo/JkPd
         2ug/1DAdmXCXrcsot3W+oG9URJn506AB14fh6d557cKSfBI2lrpeL1CcmC2fuNKhbBcO
         xkcCKNHzFsfSFqsudAw2cKVs5sNkhqp+gLSQhsmdQXfA7NnfZCPXZ+DZeia6spYkSrFV
         OKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679524065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e/Wjm0b8Ik7+X2MQf3m3hky1zdDJvNFJ4agRqoB9mA0=;
        b=aBNdNFfRGByk9hTTMREUP1rj0JCdMvFjiJ77nwlv+VhpNxG7zk0nTtwAtq5lUMnkI3
         Oyh6o3gj58CPpDJtm27C4NAdWRSRgzqCHbKc1GsE3CpN37MpLrs2uhYqjo2vX7xGdeT0
         Fi6ZzEpeVlhb/wUt7vTYonnZs0V++GQQ0GeEW8rUxryBLeNlje7zbBQHA+eL7Rggt0Uw
         ldKaXxtsW++f20lzAfe77kU2z2hHcWIEkRiJGrH6Q3sHYmFdQ6vMmokpR1PnmGcfGbOo
         k+E3/q0KrbVFLByubSzuVoUbaOFOsHiU2uoVpcXR9cmsT1JdrJlqiKPWS2DKhwkjEcwp
         PPQw==
X-Gm-Message-State: AO0yUKVcHMeYqM9Z2WcB3KsJIjrIt//U1jAv7TZQ8luZm/ckRRAT6QmB
        Plc7fHxZYz/7BUBTuS/OplYvII7MIzM/GP9kzS4=
X-Google-Smtp-Source: AK7set8gUyy1sCqRru6eNQSGWAYy+Eqil0jvDXyYXA+sgAPfrL/BhDbBOzzjpcL26JACm1NBn4cQczKuSSkzdJN/AzA=
X-Received: by 2002:a50:c3cf:0:b0:4fb:2593:846 with SMTP id
 i15-20020a50c3cf000000b004fb25930846mr4193269edf.3.1679524064488; Wed, 22 Mar
 2023 15:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
 <CAADnVQLKONwKwkJMopRq-dzcV2ZejrjGzyuzW_5QX=0BY=Z4jw@mail.gmail.com> <b5c80613c696818ce89b92dac54e98878ec3ccd0.camel@huaweicloud.com>
In-Reply-To: <b5c80613c696818ce89b92dac54e98878ec3ccd0.camel@huaweicloud.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Mar 2023 15:27:33 -0700
Message-ID: <CAADnVQJC0h7rtuntt0tqS5BbxWsmyWs3ZSbboZMmUKetMG2VhA@mail.gmail.com>
Subject: Re: [PATCH 0/5] usermode_driver: Add management library and API
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 5:08=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> On Tue, 2023-03-21 at 19:23 -0700, Alexei Starovoitov wrote:
> > On Fri, Mar 17, 2023 at 7:53=E2=80=AFAM Roberto Sassu
> > <roberto.sassu@huaweicloud.com> wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > >
> > > A User Mode Driver (UMD) is a specialization of a User Mode Helper (U=
MH),
> > > which runs a user space process from a binary blob, and creates a
> > > bidirectional pipe, so that the kernel can make a request to that pro=
cess,
> > > and the latter provides its response. It is currently used by bpfilte=
r,
> > > although it does not seem to do any useful work.
> >
> > FYI the new home for bpfilter is here:
> > https://github.com/facebook/bpfilter
>
> Thanks. I just ensured that it worked, by doing:
>
> getsockopt(fd, SOL_IP, IPT_SO_GET_INFO, &info, &optlen);
>
> and accepting IPT_SO_GET_INFO in main.c.
>
> > > The problem is, if other users would like to implement a UMD similar =
to
> > > bpfilter, they would have to duplicate the code. Instead, make an UMD
> > > management library and API from the existing bpfilter and sockopt cod=
e,
> > > and move it to common kernel code.
> > >
> > > Also, define the software architecture and the main components of the
> > > library: the UMD Manager, running in the kernel, acting as the fronte=
nd
> > > interface to any user or kernel-originated request; the UMD Loader, a=
lso
> > > running in the kernel, responsible to load the UMD Handler; the UMD
> > > Handler, running in user space, responsible to handle requests from t=
he UMD
> > > Manager and to send to it the response.
> >
> > That doesn't look like a generic interface for UMD.
>
> What would make it more generic? I made the API message format-
> independent. It has the capability of starting the user space process
> as required, when there is a communication.
>
> > It was a quick hack to get bpfilter off the ground, but certainly
> > not a generic one.
>
> True, it is not generic in the sense that it can accomodate any
> possible use case. The main goal is to move something that was running
> in the kernel to user space, with the same isolation guarantees as if
> the code was executed in the kernel.

They are not the same guarantees.
UMD is exactly equivalent to root process running in user space.
Meaning it can be killed, ptraced, priority inverted, etc

> > > I have two use cases, but for sake of brevity I will propose one.
> > >
> > > I would like to add support for PGP keys and signatures in the kernel=
, so
> > > that I can extend secure boot to applications, and allow/deny code
> > > execution based on the signed file digests included in RPM headers.
> > >
> > > While I proposed a patch set a while ago (based on a previous work of=
 David
> > > Howells), the main objection was that the PGP packet parser should no=
t run
> > > in the kernel.
> > >
> > > That makes a perfect example for using a UMD. If the PGP parser is mo=
ved to
> > > user space (UMD Handler), and the kernel (UMD Manager) just instantia=
tes
> > > the key and verifies the signature on already parsed data, this would
> > > address the concern.
> >
> > I don't think PGP parser belongs to UMD either.
> > Please do it as a normal user space process and define a proper
> > protocol for communication between kernel and user space.
>
> UMD is better in the sense that it establishes a bidirectional pipe
> between the kernel and the user space process. With that, there is no
> need to further restrict the access to a sysfs file, for example.

If a simple pipe is good enough then you can have a kernel module
that creates it and interacts with the user space process.
Out-of-tree bpftiler can do that, so can you.
PGP is not suitable for kernel git repo either as kernel code or as UMD.
