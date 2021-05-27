Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952543924DA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 04:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhE0C3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 22:29:39 -0400
Received: from mail.loongson.cn ([114.242.206.163]:41348 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231470AbhE0C3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 22:29:38 -0400
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxL0OoA69gvvcEAA--.4497S3;
        Thu, 27 May 2021 10:27:52 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [QUESTION] BPF kernel selftests failed in the LTS stable kernel
 4.19.x
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Message-ID: <2988ff60-2d79-b066-6c02-16e5fe8b69db@loongson.cn>
Date:   Thu, 27 May 2021 10:27:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxL0OoA69gvvcEAA--.4497S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XF4fXrW3CF13Kw4kKF18Grg_yoWxAr1xpa
        9agF4jkFWaqFy7Aw1Iq397Aw1vk395Cr48W3s8Cry0vwnY9F47Xr4jgFWxWa47ArsIya1F
        yr98ZwnrW3yjqFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Cb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I
        8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
        xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
        AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
        cIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07beIDcUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

When update the following LTS stable kernel 4.19.x,
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y

and then run BPF selftests according to
https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html#q-how-to-run-bpf-selftests

$ cd tools/testing/selftests/bpf/
$ make
$ sudo ./test_verifier
$ sudo make run_tests

there exists many failures include verifier tests and run_tests,
(1) is it necessary to make sure that there are no any failures in the LTS
stable kernel 4.19.x?
(2) if yes, how to fix these failures in the LTS stable kernel 4.19.x?
(3) if no, how to test BPF in the LTS stable kernel 4.19.x, just use 
test_bpf.ko?


Here are some verifier tests failures:

#165/u PTR_TO_STACK store/load - out of bounds low FAIL
Unexpected error message!
     EXP: invalid stack off=-79992 size=8
     RES: 0: (bf) r1 = r10
1: (07) r1 += -80000
invalid stack off=-80000 size=1
R1 stack pointer arithmetic goes out of range, prohibited for !root

0: (bf) r1 = r10
1: (07) r1 += -80000
invalid stack off=-80000 size=1
R1 stack pointer arithmetic goes out of range, prohibited for !root
#165/p PTR_TO_STACK store/load - out of bounds low OK

#194/u unpriv: adding of fp FAIL
Failed to load prog 'Numerical result out of range'!
0: (b7) r0 = 0
1: (b7) r1 = 0
2: (0f) r1 += r10
R1 tried to add from different maps, paths, or prohibited types
#194/p unpriv: adding of fp OK


#423/u bounds checks mixing signed and unsigned FAIL
Unexpected error message!
     EXP: unbounded min value
     RES: 0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0x0
5: (85) call bpf_map_lookup_elem#1
6: (15) if r0 == 0x0 goto pc+7
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
7: (7a) *(u64 *)(r10 -16) = -8
8: (79) r1 = *(u64 *)(r10 -16)
9: (b7) r2 = -1
10: (2d) if r1 > r2 goto pc+3
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1=inv(id=0) R2=inv-1 
R10=fp0,call_-1
11: (65) if r1 s> 0x1 goto pc+2
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1=inv(id=0,smax_value=1) 
R2=inv-1 R10=fp0,call_-1
12: (0f) r0 += r1
R1 has unknown scalar with mixed signed bounds, pointer arithmetic with 
it prohibited for !root


0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0x0
5: (85) call bpf_map_lookup_elem#1
6: (15) if r0 == 0x0 goto pc+7
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
7: (7a) *(u64 *)(r10 -16) = -8
8: (79) r1 = *(u64 *)(r10 -16)
9: (b7) r2 = -1
10: (2d) if r1 > r2 goto pc+3
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1=inv(id=0) R2=inv-1 
R10=fp0,call_-1
11: (65) if r1 s> 0x1 goto pc+2
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1=inv(id=0,smax_value=1) 
R2=inv-1 R10=fp0,call_-1
12: (0f) r0 += r1
R1 has unknown scalar with mixed signed bounds, pointer arithmetic with 
it prohibited for !root
#423/p bounds checks mixing signed and unsigned OK


#439/u subtraction bounds (map value) variant 2 FAIL
Unexpected error message!
     EXP: R0 min value is negative, either use unsigned index or do a if 
(index >=0) check.
     RES: 0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0x0
5: (85) call bpf_map_lookup_elem#1
6: (15) if r0 == 0x0 goto pc+8
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
7: (71) r1 = *(u8 *)(r0 +0)
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
8: (25) if r1 > 0xff goto pc+6
9: (71) r3 = *(u8 *)(r0 +1)
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) 
R1=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R10=fp0,call_-1
10: (25) if r3 > 0xff goto pc+4
11: (1f) r1 -= r3
12: (0f) r0 += r1
R1 has unknown scalar with mixed signed bounds, pointer arithmetic with 
it prohibited for !root


0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0x0
5: (85) call bpf_map_lookup_elem#1
6: (15) if r0 == 0x0 goto pc+8
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
7: (71) r1 = *(u8 *)(r0 +0)
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
8: (25) if r1 > 0xff goto pc+6
9: (71) r3 = *(u8 *)(r0 +1)
  R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) 
R1=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R10=fp0,call_-1
10: (25) if r3 > 0xff goto pc+4
11: (1f) r1 -= r3
12: (0f) r0 += r1
R1 has unknown scalar with mixed signed bounds, pointer arithmetic with 
it prohibited for !root
#439/p subtraction bounds (map value) variant 2 OK


#452/u bounds check map access with off+size signed 32bit overflow. 
test2 FAIL
Unexpected error message!
     EXP: pointer offset 1073741822
     RES: 0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0x0
5: (85) call bpf_map_lookup_elem#1
6: (55) if r0 != 0x0 goto pc+1
  R0=inv0 R10=fp0,call_-1
7: (95) exit

from 6 to 8: R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
8: (07) r0 += 536870911
  R0_w=map_value(id=0,off=536870911,ks=8,vs=8,imm=0) R10=fp0,call_-1
invalid access to map value, value_size=8 off=536870911 size=1
R0 min value is outside of the array range
R0 pointer arithmetic of map value goes out of range, prohibited for !root

0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0x0
5: (85) call bpf_map_lookup_elem#1
6: (55) if r0 != 0x0 goto pc+1
  R0=inv0 R10=fp0,call_-1
7: (95) exit

from 6 to 8: R0=map_value(id=0,off=0,ks=8,vs=8,imm=0) R10=fp0,call_-1
8: (07) r0 += 536870911
  R0_w=map_value(id=0,off=536870911,ks=8,vs=8,imm=0) R10=fp0,call_-1
invalid access to map value, value_size=8 off=536870911 size=1
R0 min value is outside of the array range
R0 pointer arithmetic of map value goes out of range, prohibited for !root
#452/p bounds check map access with off+size signed 32bit overflow. test2 OK


#462/u direct stack access with 32-bit wraparound. test3 FAIL
Unexpected error message!
     EXP: fp pointer offset 1073741822
     RES: 0: (bf) r1 = r10
1: (07) r1 += 536870911
invalid stack off=536870911 size=1
R1 stack pointer arithmetic goes out of range, prohibited for !root

0: (bf) r1 = r10
1: (07) r1 += 536870911
invalid stack off=536870911 size=1
R1 stack pointer arithmetic goes out of range, prohibited for !root
#462/p direct stack access with 32-bit wraparound. test3 OK


#531/u check deducing bounds from const, 1 FAIL
Unexpected error message!
     EXP: R0 tried to subtract pointer from scalar
     RES: 0: (b7) r0 = 1
1: (75) if r0 s>= 0x1 goto pc+0
2: (1f) r0 -= r1
R0 tried to sub from different maps, paths, or prohibited types

0: (b7) r0 = 1
1: (75) if r0 s>= 0x1 goto pc+0
2: (1f) r0 -= r1
R0 tried to sub from different maps, paths, or prohibited types
#531/p check deducing bounds from const, 1 OK

