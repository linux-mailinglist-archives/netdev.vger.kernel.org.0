Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9D6C8A59
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjCYCyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCYCym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:54:42 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4F215170;
        Fri, 24 Mar 2023 19:54:40 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i5so15103146eda.0;
        Fri, 24 Mar 2023 19:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679712879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRLA3AVBBHEbXMLoaXv9UfX4+UgIZrAq1UG9X24q8oA=;
        b=UYqqbQxrYcFlwyWfoAsiljg848pmpCwLH0hEVNA96BfXUEEAOxU2eOOeNeK4626oeI
         Y39dn/yp8caxqBtGxdPRJFKnOdGW+OzuxKmglhwUraMBrRCFwkTw6idY1MEhcvvBTSQd
         3/O17kP84zwpOg+BRpmtkRCJOAmUZqKOMk1QlYh4LUGCwCKljFh/7EpDeUJfvLTb5lWG
         5AM3kIHP0cZX/fHnw7epNnOtRiT22bb13M7azFm1qJWohtDdGQw+PdTNelTPGd37OGrF
         fooNiMSl/HBfPzLi80EwGpxNINV0XiwaXSgj+Jk4uIFOQhW44T44yX018u+GoDkdQLga
         NWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679712879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sRLA3AVBBHEbXMLoaXv9UfX4+UgIZrAq1UG9X24q8oA=;
        b=kmlxxQG24eoIC9Sq0VqzRXViaf/5K5L17fhwKVx7C5Ev5faTDEs47witWM4cMo1qJz
         oAJZfKsHb0kR+8w9e0DCPvbqUZVtFatQwQXeZiiuyRQLE1JaPAlbZ9bPHwGxXy6npgvF
         7L9SMm6mrgnTSugNVVP4a5OECxg2MJrQKfom+6Q6Pa+xH7IIGJjtIwa4YCJIdoFO4p7C
         ZWMVGW+aqSulLaO2yyVemqqLBTaTxTVbp6EnhsPlWrtJGlHRSePBssTpaOY3I2JZwyMH
         o0ITlB9D+m5yT/Hnsqmt99H9N8edQwhCjw2BQ44/Ite3DtfrYEin7F+dDHHeeU1yt71q
         d3NA==
X-Gm-Message-State: AAQBX9ecWZF2oIfkG7tcNxgBU+7XCkqX4U+Nc7uWdlbQXGO9lXl8gUFA
        j9N1gSLaAy/R9jkhwrfescsYEjbhsOxWDezBPFQ=
X-Google-Smtp-Source: AKy350YyKqLq37BwTMQL1st81LQynw0UYRKshOWcpI4mo10TRiJUhC3HDWyxCxV5Du1xaOZi/rg54yF2qdwnUCxTPq0=
X-Received: by 2002:a17:907:da8:b0:877:747d:4a85 with SMTP id
 go40-20020a1709070da800b00877747d4a85mr2582166ejc.3.1679712878695; Fri, 24
 Mar 2023 19:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
 <CAADnVQLKONwKwkJMopRq-dzcV2ZejrjGzyuzW_5QX=0BY=Z4jw@mail.gmail.com>
 <b5c80613c696818ce89b92dac54e98878ec3ccd0.camel@huaweicloud.com>
 <CAADnVQJC0h7rtuntt0tqS5BbxWsmyWs3ZSbboZMmUKetMG2VhA@mail.gmail.com> <e0b828d994a8427ad48b7b514f75d751ea791b47.camel@huaweicloud.com>
In-Reply-To: <e0b828d994a8427ad48b7b514f75d751ea791b47.camel@huaweicloud.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Mar 2023 19:54:27 -0700
Message-ID: <CAADnVQJv0qWaxRD2_tmXeR9Wf=zdnvk8SwztOAorGaer0dFv3w@mail.gmail.com>
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

On Thu, Mar 23, 2023 at 6:37=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> On Wed, 2023-03-22 at 15:27 -0700, Alexei Starovoitov wrote:
> > On Wed, Mar 22, 2023 at 5:08=E2=80=AFAM Roberto Sassu
> > <roberto.sassu@huaweicloud.com> wrote:
> > > On Tue, 2023-03-21 at 19:23 -0700, Alexei Starovoitov wrote:
> > > > On Fri, Mar 17, 2023 at 7:53=E2=80=AFAM Roberto Sassu
> > > > <roberto.sassu@huaweicloud.com> wrote:
> > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > >
> > > > > A User Mode Driver (UMD) is a specialization of a User Mode Helpe=
r (UMH),
> > > > > which runs a user space process from a binary blob, and creates a
> > > > > bidirectional pipe, so that the kernel can make a request to that=
 process,
> > > > > and the latter provides its response. It is currently used by bpf=
ilter,
> > > > > although it does not seem to do any useful work.
> > > >
> > > > FYI the new home for bpfilter is here:
> > > > https://github.com/facebook/bpfilter
> > >
> > > Thanks. I just ensured that it worked, by doing:
> > >
> > > getsockopt(fd, SOL_IP, IPT_SO_GET_INFO, &info, &optlen);
> > >
> > > and accepting IPT_SO_GET_INFO in main.c.
> > >
> > > > > The problem is, if other users would like to implement a UMD simi=
lar to
> > > > > bpfilter, they would have to duplicate the code. Instead, make an=
 UMD
> > > > > management library and API from the existing bpfilter and sockopt=
 code,
> > > > > and move it to common kernel code.
> > > > >
> > > > > Also, define the software architecture and the main components of=
 the
> > > > > library: the UMD Manager, running in the kernel, acting as the fr=
ontend
> > > > > interface to any user or kernel-originated request; the UMD Loade=
r, also
> > > > > running in the kernel, responsible to load the UMD Handler; the U=
MD
> > > > > Handler, running in user space, responsible to handle requests fr=
om the UMD
> > > > > Manager and to send to it the response.
> > > >
> > > > That doesn't look like a generic interface for UMD.
> > >
> > > What would make it more generic? I made the API message format-
> > > independent. It has the capability of starting the user space process
> > > as required, when there is a communication.
> > >
> > > > It was a quick hack to get bpfilter off the ground, but certainly
> > > > not a generic one.
> > >
> > > True, it is not generic in the sense that it can accomodate any
> > > possible use case. The main goal is to move something that was runnin=
g
> > > in the kernel to user space, with the same isolation guarantees as if
> > > the code was executed in the kernel.
> >
> > They are not the same guarantees.
> > UMD is exactly equivalent to root process running in user space.
> > Meaning it can be killed, ptraced, priority inverted, etc
>
> That is the starting point.
>
> I suppose you can remove any privilege from the UMD process, it just
> needs to read/write from/to a pipe (and in my case to use socket() with
> AF_ALG to interact with the Crypto API).
>
> Also, as I mentioned, you can enforce a very strict seccomp profile,
> which forces the UMD process to use a very limited number of system
> calls.
>
> For the interactions of the rest of the system to the UMD process, you
> could deny with an LSM all the operations that you mentioned. The rest
> of the system would not be affected, only operations which have the UMD
> process as target are denied.
>
> > > > > I have two use cases, but for sake of brevity I will propose one.
> > > > >
> > > > > I would like to add support for PGP keys and signatures in the ke=
rnel, so
> > > > > that I can extend secure boot to applications, and allow/deny cod=
e
> > > > > execution based on the signed file digests included in RPM header=
s.
> > > > >
> > > > > While I proposed a patch set a while ago (based on a previous wor=
k of David
> > > > > Howells), the main objection was that the PGP packet parser shoul=
d not run
> > > > > in the kernel.
> > > > >
> > > > > That makes a perfect example for using a UMD. If the PGP parser i=
s moved to
> > > > > user space (UMD Handler), and the kernel (UMD Manager) just insta=
ntiates
> > > > > the key and verifies the signature on already parsed data, this w=
ould
> > > > > address the concern.
> > > >
> > > > I don't think PGP parser belongs to UMD either.
> > > > Please do it as a normal user space process and define a proper
> > > > protocol for communication between kernel and user space.
> > >
> > > UMD is better in the sense that it establishes a bidirectional pipe
> > > between the kernel and the user space process. With that, there is no
> > > need to further restrict the access to a sysfs file, for example.
> >
> > If a simple pipe is good enough then you can have a kernel module
> > that creates it and interacts with the user space process.
>
> Few points I forgot to mention.
>
> With the UMD approach, the binary blob is embedded in the kernel
> module, which means that no external dependencies are needed for
> integrity verification. The binary is statically compiled, and the
> kernel write-protects it at run-time.
>
> Second, since DIGLIM would check the integrity of any executable,
> including init, the PGP signature verification needs to occur before.
> So, the PGP UMD should be already started by then. That is not going to
> be a problem, since the binary is copied to a private tmpfs mount.
>
> > Out-of-tree bpftiler can do that, so can you.
>
> As far as I can see, the out-of-tree bpfilter works exactly in the same
> way as the in-tree counterpart. The binary blob is embedded in the
> kernel module.
>
> > PGP is not suitable for kernel git repo either as kernel code or as UMD=
.
>
> Well, the asymmetric key type can be extended with new parsers, so this
> possibility was already taken into account. The objection that the PGP
> parser should not run in kernel space is fair, but I think the UMD
> approach fully addresses that.
>
> Also, I agree with you that we should not just take any code and
> pretend that it is part of the kernel. However, in this particular
> case, the purpose of the PGP UMD would be simply to extract very few
> information from the PGP packets. The asymmetric key type and the
> signature verification infrastructure already take care of the rest.
>
> PGP keys and signatures would act as an additional system trust anchor
> for verifying critical system data (for DIGLIM, which executables are
> allowed to run), similarly to how X.509 certificates are used for
> verifying kernel modules. RPM headers, executables digests are taken
> from, are signed with PGP, so there is no other way than adding this
> functionality.
>
> And unfortunately, especially for features impacting the entire system,
> out-of-tree drivers are not really an option:

I think you have to start out of tree and prove that the PGP thing
is worth considering at all.
Only then we can talk about merits of UMD and generalization
of pipe interface if it's applicable.

DIGLIM and everything else you mentioned above doesn't add weight
to the decision. PGP work should be acceptable on its own.
Out-of-tree is a method to prove that it works and later argue
for inclusion as in-tree either as kernel module or UMD.
Generalization of current bpfilter is out of scope here.
