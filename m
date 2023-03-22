Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01556C49EB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCVMIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVMIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:08:21 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A077CEB71;
        Wed, 22 Mar 2023 05:08:19 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4PhRpY0Y3Fz9v7Nc;
        Wed, 22 Mar 2023 19:59:17 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwBn6QSL7xpkVHG9AQ--.51830S2;
        Wed, 22 Mar 2023 13:07:54 +0100 (CET)
Message-ID: <b5c80613c696818ce89b92dac54e98878ec3ccd0.camel@huaweicloud.com>
Subject: Re: [PATCH 0/5] usermode_driver: Add management library and API
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Date:   Wed, 22 Mar 2023 13:07:37 +0100
In-Reply-To: <CAADnVQLKONwKwkJMopRq-dzcV2ZejrjGzyuzW_5QX=0BY=Z4jw@mail.gmail.com>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
         <CAADnVQLKONwKwkJMopRq-dzcV2ZejrjGzyuzW_5QX=0BY=Z4jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwBn6QSL7xpkVHG9AQ--.51830S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF47uw1rWFyrGFWUZw4DXFb_yoWrGF18pF
        4YkFW7K3WkJF17Crn7Zw48Ca4I9397J3y3Grn3try5Zwn0kFySkr1IvF13uF1DGr4fKw1a
        qrW5X34jg34DZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAkuxUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAEBF1jj4bRvQACsb
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-21 at 19:23 -0700, Alexei Starovoitov wrote:
> On Fri, Mar 17, 2023 at 7:53 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > A User Mode Driver (UMD) is a specialization of a User Mode Helper (UMH),
> > which runs a user space process from a binary blob, and creates a
> > bidirectional pipe, so that the kernel can make a request to that process,
> > and the latter provides its response. It is currently used by bpfilter,
> > although it does not seem to do any useful work.
> 
> FYI the new home for bpfilter is here:
> https://github.com/facebook/bpfilter

Thanks. I just ensured that it worked, by doing:

getsockopt(fd, SOL_IP, IPT_SO_GET_INFO, &info, &optlen);

and accepting IPT_SO_GET_INFO in main.c.

> > The problem is, if other users would like to implement a UMD similar to
> > bpfilter, they would have to duplicate the code. Instead, make an UMD
> > management library and API from the existing bpfilter and sockopt code,
> > and move it to common kernel code.
> > 
> > Also, define the software architecture and the main components of the
> > library: the UMD Manager, running in the kernel, acting as the frontend
> > interface to any user or kernel-originated request; the UMD Loader, also
> > running in the kernel, responsible to load the UMD Handler; the UMD
> > Handler, running in user space, responsible to handle requests from the UMD
> > Manager and to send to it the response.
> 
> That doesn't look like a generic interface for UMD.

What would make it more generic? I made the API message format-
independent. It has the capability of starting the user space process
as required, when there is a communication.

> It was a quick hack to get bpfilter off the ground, but certainly
> not a generic one.

True, it is not generic in the sense that it can accomodate any
possible use case. The main goal is to move something that was running
in the kernel to user space, with the same isolation guarantees as if
the code was executed in the kernel.

> > I have two use cases, but for sake of brevity I will propose one.
> > 
> > I would like to add support for PGP keys and signatures in the kernel, so
> > that I can extend secure boot to applications, and allow/deny code
> > execution based on the signed file digests included in RPM headers.
> > 
> > While I proposed a patch set a while ago (based on a previous work of David
> > Howells), the main objection was that the PGP packet parser should not run
> > in the kernel.
> > 
> > That makes a perfect example for using a UMD. If the PGP parser is moved to
> > user space (UMD Handler), and the kernel (UMD Manager) just instantiates
> > the key and verifies the signature on already parsed data, this would
> > address the concern.
> 
> I don't think PGP parser belongs to UMD either.
> Please do it as a normal user space process and define a proper
> protocol for communication between kernel and user space.

UMD is better in the sense that it establishes a bidirectional pipe
between the kernel and the user space process. With that, there is no
need to further restrict the access to a sysfs file, for example.

The UMD mechanism is much more effective: the pipe is already
established with the right process, whose code was integrity-checked
because embedded in the kernel module.

In addition to that, I'm using seccomp to further restrict what the
user space process can do (read, write, exit, ...). That process cannot
open new communication channels, even if corrupted. It is expected to
send to the kernel simple data structures, that the kernel can
effectively sanitize.

The last step to achieve full isolation would be to deny ptrace/kill on
the user space process created by the UMD management library so that,
in lockdown mode, not even root can interfer with that process.

Roberto

