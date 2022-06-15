Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8699154CEF4
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiFOQpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbiFOQpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:45:44 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF0B37BFE;
        Wed, 15 Jun 2022 09:45:43 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-313a8a8b95aso67305477b3.5;
        Wed, 15 Jun 2022 09:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=4BoGoYL/hQwqQHt/e6uyTXhiyZO4K0k4ufMSQdDzzyU=;
        b=nBfYqDdGnV2+1cdagPVZJWmCVvra5folpIaRRtVtc8u9HOsqiYpCIMSMs4DzR1fLwS
         l9VS73LxN6Z0VCaXVlw7bYMXauJ35n9zG0VG3MOTHIlRo7QE1KxHSc5Fhl/7tJJb/mEL
         /BZXBMldL5Q+cDCVYvy9JzQqFcvF5hoM2wjo0znGf0vfJU6mTmUkkzuXRh1/i69fH2x9
         zdJmqDHmLmefxlMAIc+6E4uyr3MXRMjBsoicS61B9npo1B5ocoarqc8+sm5w1BsqzuS9
         +2rXn5bkR3DUt1l+5p7epRXweKiX9g0Iu6WILuwDi20/Q3r+tQj0PEdu3Wgf0iM+2lvp
         3lMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4BoGoYL/hQwqQHt/e6uyTXhiyZO4K0k4ufMSQdDzzyU=;
        b=c+K1ZsNHzYLnAIwGK2QAeF31K5epjx0h0fvVXkvEyyPO8egf1sgptdDU31g/NJbIO5
         BcgATqQKzr2VUFryaeFB13NHaKNCDhhZh23CRzcTtLgcCriVMG55SRwXlYjFlBw+KebD
         hRXXJEs1Dyx6I2r7CWgwJ29MnhSI1rGzv9D097XdccSBcuU7PISXW3o4ruXCM9eR6MoG
         4hkYPEIBvXAgkRlaxHLJZ7TnShL4NLGWz083RBFutGI6CWoa7n2lS/QbwMzM5keMAkJw
         J9Y3Dt9YsCUwmY6DYiBlBtP2WrPnJoKxMDgg1sLFtA6SBl/JuF0+XhI5/XRZyxKatpCs
         fagg==
X-Gm-Message-State: AJIora+etrgTpXzHfyKd8FxNHQ5WEs10RctUFSHWP2N2D+wkzuA39wt7
        dQhu9LIebqu/yXZRJinj8RPwHYqDLt/VOXZG93uGkA9nioY=
X-Google-Smtp-Source: AGRyM1tP/F/OhvpaDWEhXE4P0i0ZHlSSh4iOlQuWM9SeM31Z9F31hbjYKaYyh9bV8u5SdVAoIKer3kZjN0pmhcP5Fbs=
X-Received: by 2002:a81:920e:0:b0:30c:201e:b3d1 with SMTP id
 j14-20020a81920e000000b0030c201eb3d1mr604811ywg.374.1655311541958; Wed, 15
 Jun 2022 09:45:41 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 15 Jun 2022 09:45:31 -0700
Message-ID: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
Subject: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Are you folks aware that:

'bpf: Move rcu lock management out of BPF_PROG_RUN routines'

fixes a weird regression where sendmsg with an egress tc bpf program
denying it was returning EFAULT instead of EPERM

I've confirmed vanilla 5.18.0 is broken, and all it takes is
cherrypicking that specific stable 5.18.x patch [
710a8989b4b4067903f5b61314eda491667b6ab3 ] to fix behaviour.

This was not a flaky failure... but a 100% reproducible behavioural
breakage/failure in the test case at
https://cs.android.com/android/platform/superproject/+/master:kernel/tests/net/test/bpf_test.py;l=517
(where 5.18 would return EFAULT instead of EPERM)

---

A non standalone but perhaps useful (for reading) simplification of
the test case follows.

I was planning on reporting it, hence why I was trying to trim it down
and have this ready anyway, only to discover it's already been fixed.
But the commit message seems to be unrelated...  some sort of compiler
optimization shenanigans?  Missing test case opportunity?

Note: that I run this on x86_64 UML - that might matter??

#!/usr/bin/python
# extracted snippet from AOSP, Apache2 licensed

import csocket
import cstruct
import ctypes
import errno
import os
import platform
import socket
import unittest

__NR_bpf = {  # pylint: disable=invalid-name
    "aarch64-32bit": 386,
    "aarch64-64bit": 280,
    "armv7l-32bit": 386,
    "armv8l-32bit": 386,
    "armv8l-64bit": 280,
    "i686-32bit": 357,
    "i686-64bit": 321,
    "x86_64-32bit": 357,
    "x86_64-64bit": 321,
}[os.uname()[4] + "-" + platform.architecture()[0]]

LOG_LEVEL = 1
LOG_SIZE = 65536

BPF_PROG_LOAD = 5
BPF_PROG_ATTACH = 8
BPF_PROG_DETACH = 9

BPF_PROG_TYPE_CGROUP_SKB = 8

BPF_CGROUP_INET_EGRESS = 1

BPF_REG_0 = 0

BPF_JMP = 0x05
BPF_K = 0x00
BPF_ALU64 = 0x07
BPF_MOV = 0xb0
BPF_EXIT = 0x90

BpfAttrProgLoad = cstruct.Struct(
    "bpf_attr_prog_load", "=IIQQIIQI", "prog_type insn_cnt insns"
    " license log_level log_size log_buf kern_version")
BpfAttrProgAttach = cstruct.Struct(
    "bpf_attr_prog_attach", "=III", "target_fd attach_bpf_fd attach_type")
BpfInsn = cstruct.Struct("bpf_insn", "=BBhi", "code dst_src_reg off imm")

libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)


def BpfSyscall(op, attr):
  ret = libc.syscall(__NR_bpf, op, csocket.VoidPointer(attr), len(attr))
  csocket.MaybeRaiseSocketError(ret)
  return ret


def BpfProgLoad(prog_type, instructions, prog_license=b"GPL"):
  bpf_prog = "".join(instructions)
  insn_buff = ctypes.create_string_buffer(bpf_prog)
  gpl_license = ctypes.create_string_buffer(prog_license)
  log_buf = ctypes.create_string_buffer(b"", LOG_SIZE)
  return BpfSyscall(BPF_PROG_LOAD,
                    BpfAttrProgLoad((prog_type, len(insn_buff) / len(BpfInsn),
                                    ctypes.addressof(insn_buff),
                                    ctypes.addressof(gpl_license), LOG_LEVEL,
                                    LOG_SIZE, ctypes.addressof(log_buf), 0)))


# Attach a eBPF filter to a cgroup
def BpfProgAttach(prog_fd, target_fd, prog_type):
  attr = BpfAttrProgAttach((target_fd, prog_fd, prog_type))
  return BpfSyscall(BPF_PROG_ATTACH, attr)


# Detach a eBPF filter from a cgroup
def BpfProgDetach(target_fd, prog_type):
  attr = BpfAttrProgAttach((target_fd, 0, prog_type))
  return BpfSyscall(BPF_PROG_DETACH, attr)


class BpfCgroupEgressTest(unittest.TestCase):
  def setUp(self):
    self._cg_fd = os.open("/sys/fs/cgroup", os.O_DIRECTORY | os.O_RDONLY)
    BpfProgAttach(BpfProgLoad(BPF_PROG_TYPE_CGROUP_SKB, [
        BpfInsn((BPF_ALU64 | BPF_MOV | BPF_K, BPF_REG_0, 0,
0)).Pack(),  # Mov64Imm(REG0, 0)
        BpfInsn((BPF_JMP | BPF_EXIT, 0, 0, 0)).Pack()                    # Exit
    ]), self._cg_fd, BPF_CGROUP_INET_EGRESS)

  def tearDown(self):
    BpfProgDetach(self._cg_fd, BPF_CGROUP_INET_EGRESS)
    os.close(self._cg_fd)

  def testCgroupEgressBlocked(self):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, 0)
    s.bind(("127.0.0.1", 0))
    addr = s.getsockname()
    # previously:   s.sendto("foo", addr)   would fail with EPERM, but
on 5.18+ it EFAULTs
    self.assertRaisesRegexp(EnvironmentError,
os.strerror(errno.EFAULT), s.sendto, "foo", addr)

if __name__ == "__main__":
  unittest.main()
