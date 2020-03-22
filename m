Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C41018E94B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCVODw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:03:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:48430 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVODw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 10:03:52 -0400
IronPort-SDR: KYAKRXNNps0jyIhezSL5XpplwSoDTau/6bfYb0UK9wOujM7IvNnY122RXBJ8rQ1W/RExrJyILX
 czKHKY1Zn9eg==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 07:03:16 -0700
IronPort-SDR: WNTTTFcxHu1vtjxg2W6qLKUoA50bdOf0m2zwvNxVmBy8ZZQcU1Q2BcCCWK7U1HRrRJW+wZ2ldJ
 sgLz6hbJIe7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="xz'?yaml'?scan'208";a="445524135"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.3])
  by fmsmga005.fm.intel.com with ESMTP; 22 Mar 2020 07:03:12 -0700
Date:   Sun, 22 Mar 2020 22:02:56 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     yhs@fb.com, alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, lkp@lists.01.org
Subject: [bpf] a162f637b0: kernel-selftests.bpf.test_align.fail
Message-ID: <20200322140256.GV11705@shao2-debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BcZrms9gUsdgyR6a"
Content-Disposition: inline
In-Reply-To: <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

FYI, we noticed the following commit (built with gcc-7):

commit: a162f637b08577f8e843d469ec20b338853e05ca ("[RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking")
url: https://github.com/0day-ci/linux/commits/John-Fastabend/rfc-for-32-bit-subreg-verifier-tracking/20200307-081430
base: https://git.kernel.org/cgit/linux/kernel/git/bpf/bpf.git master

in testcase: kernel-selftests
with following parameters:

	group: kselftests-bpf
	ucode: 0xd6

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz with 16G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <rong.a.chen@intel.com>


# selftests: bpf: test_align
# Test   0: mov ... PASS
# Test   1: shift ... PASS
# Test   2: addsub ... PASS
# Test   3: mul ... PASS
# Test   4: unknown shift ... Failed to find match 7: R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r0 = r2
# 3: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (07) r0 += 8
# 4: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (3d) if r3 >= r0 goto pc+1
#  R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: (95) exit
# 6: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 6: (71) r3 = *(u8 *)(r2 +0)
# 7: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 7: (67) r3 <<= 1
# 8: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=510,var_off=(0x0; 0x1fe),var32_off=(0x0; 0x1fe)) R10=fp0
# 8: (67) r3 <<= 1
# 9: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 9: (67) r3 <<= 1
# 10: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=2040,var_off=(0x0; 0x7f8),var32_off=(0x0; 0x7f8)) R10=fp0
# 10: (67) r3 <<= 1
# 11: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=4080,var_off=(0x0; 0xff0),var32_off=(0x0; 0xff0)) R10=fp0
# 11: (61) r2 = *(u32 *)(r1 +76)
# 12: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=inv(id=0,umax_value=4080,var_off=(0x0; 0xff0),var32_off=(0x0; 0xff0)) R10=fp0
# 12: (61) r3 = *(u32 *)(r1 +80)
# 13: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 13: (bf) r0 = r2
# 14: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 14: (07) r0 += 8
# 15: R0=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R10=fp0
# 15: (3d) if r3 >= r0 goto pc+1
#  R0=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R10=fp0
# 16: R0=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R10=fp0
# 16: (95) exit
# 17: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R10=fp0
# 17: (71) r4 = *(u8 *)(r2 +0)
# 18: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 18: (67) r4 <<= 5
# 19: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=8160,var_off=(0x0; 0x1fe0),var32_off=(0x0; 0x1fe0)) R10=fp0
# 19: (77) r4 >>= 1
# 20: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4080,var_off=(0x0; 0xff0),var32_off=(0x0; 0xff0)) R10=fp0
# 20: (77) r4 >>= 1
# 21: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=2040,var_off=(0x0; 0x7f8),var32_off=(0x0; 0x7f8)) R10=fp0
# 21: (77) r4 >>= 1
# 22: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 22: (77) r4 >>= 1
# 23: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=510,var_off=(0x0; 0x1fe),var32_off=(0x0; 0x1fe)) R10=fp0
# 23: (b7) r0 = 0
# 24: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=510,var_off=(0x0; 0x1fe),var32_off=(0x0; 0x1fe)) R10=fp0
# 24: (95) exit
# processed 25 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
# FAIL
# Test   5: unknown mul ... Failed to find match 7: R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r0 = r2
# 3: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (07) r0 += 8
# 4: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (3d) if r3 >= r0 goto pc+1
#  R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: (95) exit
# 6: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 6: (71) r3 = *(u8 *)(r2 +0)
# 7: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 7: (bf) r4 = r3
# 8: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 8: (27) r4 *= 1
# 9: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 9: (bf) r4 = r3
# 10: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 10: (27) r4 *= 2
# 11: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=510,var_off=(0x0; 0x1fe),var32_off=(0x0; 0x1fe)) R10=fp0
# 11: (bf) r4 = r3
# 12: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 12: (27) r4 *= 4
# 13: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 13: (bf) r4 = r3
# 14: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 14: (27) r4 *= 8
# 15: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=2040,var_off=(0x0; 0x7f8),var32_off=(0x0; 0x7f8)) R10=fp0
# 15: (27) r4 *= 2
# 16: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=4080,var_off=(0x0; 0xff0),var32_off=(0x0; 0xff0)) R10=fp0
# 16: (b7) r0 = 0
# 17: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R4_w=inv(id=0,umax_value=4080,var_off=(0x0; 0xff0),var32_off=(0x0; 0xff0)) R10=fp0
# 17: (95) exit
# processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# FAIL
# Test   6: packet const offset ... Failed to find match 10: R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r5 = r2
# 3: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 3: (b7) r0 = 0
# 4: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 4: (07) r5 += 14
# 5: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=14,r=0,imm=0) R10=fp0
# 5: (bf) r4 = r5
# 6: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=0,off=14,r=0,imm=0) R5_w=pkt(id=0,off=14,r=0,imm=0) R10=fp0
# 6: (07) r4 += 4
# 7: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=0,off=18,r=0,imm=0) R5_w=pkt(id=0,off=14,r=0,imm=0) R10=fp0
# 7: (3d) if r3 >= r4 goto pc+1
#  R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=0,off=18,r=0,imm=0) R5_w=pkt(id=0,off=14,r=0,imm=0) R10=fp0
# 8: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=0,off=18,r=0,imm=0) R5_w=pkt(id=0,off=14,r=0,imm=0) R10=fp0
# 8: (95) exit
# 9: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=0,off=18,r=18,imm=0) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 9: (71) r4 = *(u8 *)(r5 +0)
# 10: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 10: (71) r4 = *(u8 *)(r5 +1)
# 11: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 11: (71) r4 = *(u8 *)(r5 +2)
# 12: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 12: (71) r4 = *(u8 *)(r5 +3)
# 13: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 13: (69) r4 = *(u16 *)(r5 +0)
# 14: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=65535,var_off=(0x0; 0xffff),var32_off=(0x0; 0xffff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 14: (69) r4 = *(u16 *)(r5 +2)
# 15: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=65535,var_off=(0x0; 0xffff),var32_off=(0x0; 0xffff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 15: (61) r4 = *(u32 *)(r5 +0)
# 16: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 16: (b7) r0 = 0
# 17: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=18,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5=pkt(id=0,off=14,r=18,imm=0) R10=fp0
# 17: (95) exit
# processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
# FAIL
# Test   7: packet variable offset ... Failed to find match 8: R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r0 = r2
# 3: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (07) r0 += 8
# 4: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (3d) if r3 >= r0 goto pc+1
#  R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: (95) exit
# 6: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 6: (71) r6 = *(u8 *)(r2 +0)
# 7: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 7: (67) r6 <<= 2
# 8: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 8: (bf) r5 = r2
# 9: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=0,r=8,imm=0) R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 9: (07) r5 += 14
# 10: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=14,r=8,imm=0) R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 10: (0f) r5 += r6
# last_idx 10 first_idx 0
# regs=40 stack=0 before 9: (07) r5 += 14
# regs=40 stack=0 before 8: (bf) r5 = r2
# regs=40 stack=0 before 7: (67) r6 <<= 2
# regs=40 stack=0 before 6: (71) r6 = *(u8 *)(r2 +0)
# 11: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=1,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 11: (bf) r4 = r5
# 12: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=1,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 12: (07) r4 += 4
# 13: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 13: (3d) if r3 >= r4 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 14: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 14: (95) exit
# 15: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=18,r=18,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=14,r=18,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 15: (61) r4 = *(u32 *)(r5 +0)
# 16: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5=pkt(id=1,off=14,r=18,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 16: (bf) r5 = r2
# 17: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=0,off=0,r=8,imm=0) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 17: (0f) r5 += r6
# 18: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=2,off=0,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 18: (07) r5 += 14
# 19: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 19: (bf) r4 = r5
# 20: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 20: (07) r4 += 4
# 21: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 21: (3d) if r3 >= r4 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 22: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 22: (95) exit
# 23: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=18,r=18,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=14,r=18,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 23: (61) r4 = *(u32 *)(r5 +0)
# 24: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5=pkt(id=2,off=14,r=18,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 24: (bf) r5 = r2
# 25: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=0,off=0,r=8,imm=0) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 25: (07) r5 += 14
# 26: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=0,off=14,r=8,imm=0) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 26: (0f) r5 += r6
# 27: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=3,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 27: (07) r5 += 4
# 28: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=3,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 28: (0f) r5 += r6
# 29: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 29: (bf) r4 = r5
# 30: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 30: (07) r4 += 4
# 31: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=4,off=22,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 31: (3d) if r3 >= r4 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=4,off=22,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 32: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=4,off=22,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 32: (95) exit
# 33: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 33: (61) r4 = *(u32 *)(r5 +0)
# 34: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 34: (b7) r0 = 0
# 35: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc),s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 35: (95) exit
# processed 36 insns (limit 1000000) max_states_per_insn 0 total_states 3 peak_states 3 mark_read 1
# FAIL
# Test   8: packet variable offset 2 ... Failed to find match 8: R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r0 = r2
# 3: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (07) r0 += 8
# 4: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (3d) if r3 >= r0 goto pc+1
#  R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: (95) exit
# 6: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 6: (71) r6 = *(u8 *)(r2 +0)
# 7: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 7: (67) r6 <<= 2
# 8: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 8: (07) r6 += 14
# 9: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 9: (bf) r5 = r2
# 10: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=0,r=8,imm=0) R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 10: (0f) r5 += r6
# last_idx 10 first_idx 0
# regs=40 stack=0 before 9: (bf) r5 = r2
# regs=40 stack=0 before 8: (07) r6 += 14
# regs=40 stack=0 before 7: (67) r6 <<= 2
# regs=40 stack=0 before 6: (71) r6 = *(u8 *)(r2 +0)
# 11: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 11: (bf) r4 = r5
# 12: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 12: (07) r4 += 4
# 13: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 13: (3d) if r3 >= r4 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 14: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 14: (95) exit
# 15: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R10=fp0
# 15: (61) r6 = *(u32 *)(r5 +0)
# 16: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R10=fp0
# 16: (57) r6 &= 255
# 17: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 17: (67) r6 <<= 2
# 18: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 18: (0f) r5 += r6
# last_idx 18 first_idx 13
# regs=40 stack=0 before 17: (67) r6 <<= 2
# regs=40 stack=0 before 16: (57) r6 &= 255
# regs=40 stack=0 before 15: (61) r6 = *(u32 *)(r5 +0)
# 19: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 19: (bf) r4 = r5
# 20: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 20: (07) r4 += 4
# 21: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 21: (3d) if r3 >= r4 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 22: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 22: (95) exit
# 23: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 23: (61) r6 = *(u32 *)(r5 +0)
# 24: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R10=fp0
# 24: (b7) r0 = 0
# 25: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R10=fp0
# 25: (95) exit
# processed 26 insns (limit 1000000) max_states_per_insn 0 total_states 2 peak_states 2 mark_read 1
# FAIL
# Test   9: dubious pointer arithmetic ... Failed to find match 6: R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (b7) r0 = 0
# 3: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (bf) r5 = r3
# 4: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (1f) r5 -= r2
# 5: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=inv(id=0,var32_off=(0x0; 0xffffffff)) R10=fp0
# 5: (67) r5 <<= 2
# 6: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc),s32_max_value=2147483644,u32_max_value=-4,var32_off=(0x0; 0xfffffffc)) R10=fp0
# 6: (07) r5 += 14
# 7: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=inv(id=0,var_off=(0x2; 0xfffffffffffffffc),var32_off=(0x2; 0xfffffffc)) R10=fp0
# 7: (75) if r5 s>= 0x0 goto pc+1
#  R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=inv(id=0,umin_value=9223372036854775810,umax_value=18446744073709551614,var_off=(0x8000000000000002; 0x7ffffffffffffffc),s32_min_value=2,u32_min_value=2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R10=fp0
# 8: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=inv(id=0,umin_value=9223372036854775810,umax_value=18446744073709551614,var_off=(0x8000000000000002; 0x7ffffffffffffffc),s32_min_value=2,u32_min_value=2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R10=fp0
# 8: (95) exit
# 9: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R10=fp0
# 9: (bf) r6 = r2
# 10: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R6_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 10: (0f) r6 += r5
# last_idx 10 first_idx 9
# regs=20 stack=0 before 9: (bf) r6 = r2
#  R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_rw=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_rw=invP(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R10=fp0
# parent didn't have regs=20 stack=0 marks
# last_idx 7 first_idx 0
# regs=20 stack=0 before 7: (75) if r5 s>= 0x0 goto pc+1
# regs=20 stack=0 before 6: (07) r5 += 14
# regs=20 stack=0 before 5: (67) r5 <<= 2
# regs=20 stack=0 before 4: (1f) r5 -= r2
# regs=24 stack=0 before 3: (bf) r5 = r3
# regs=c stack=0 before 2: (b7) r0 = 0
# regs=c stack=0 before 1: (61) r3 = *(u32 *)(r1 +80)
# regs=4 stack=0 before 0: (61) r2 = *(u32 *)(r1 +76)
# 11: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R5=invP(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R10=fp0
# 11: (bf) r4 = r6
# 12: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=invP(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R10=fp0
# 12: (07) r4 += 4
# 13: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=invP(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R10=fp0
# 13: (3d) if r3 >= r4 goto pc+1
#  R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=invP(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R10=fp0
# 14: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=invP(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R10=fp0
# 14: (95) exit
# 15: R0=inv0 R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=0,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=invP(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_max_value=-2,u32_max_value=-2,var32_off=(0x2; 0xfffffffc)) R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R10=fp0
# 15: (61) r4 = *(u32 *)(r6 +0)
# invalid access to packet, off=0 size=4, R6(id=1,off=0,r=0)
# R6 offset is outside of the packet
# processed 16 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
# FAIL
# Test  10: variable subtraction ... Failed to find match 9: R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r0 = r2
# 3: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (07) r0 += 8
# 4: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (3d) if r3 >= r0 goto pc+1
#  R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: (95) exit
# 6: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 6: (71) r6 = *(u8 *)(r2 +0)
# 7: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 7: (bf) r7 = r6
# 8: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 8: (67) r6 <<= 2
# 9: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 9: (07) r6 += 14
# 10: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 10: (67) r7 <<= 2
# 11: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 11: (1f) r6 -= r7
# 12: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc),var32_off=(0x2; 0xfffffffc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 12: (75) if r6 s>= 0x0 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R6=inv(id=0,umin_value=18446744073709550610,umax_value=18446744073709551614,var_off=(0xfffffffffffffc02; 0x3fc),u32_min_value=-1006,u32_max_value=-2,var32_off=(0xfffffc02; 0x3fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 13: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R6=inv(id=0,umin_value=18446744073709550610,umax_value=18446744073709551614,var_off=(0xfffffffffffffc02; 0x3fc),u32_min_value=-1006,u32_max_value=-2,var32_off=(0xfffffc02; 0x3fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 13: (95) exit
# 14: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 14: (bf) r5 = r2
# 15: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=0,r=8,imm=0) R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 15: (0f) r5 += r6
# last_idx 15 first_idx 12
# regs=40 stack=0 before 14: (bf) r5 = r2
# regs=40 stack=0 before 12: (75) if r6 s>= 0x0 goto pc+1
#  R0_rw=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_rw=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_rw=invP(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc),var32_off=(0x2; 0xfffffffc)) R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# parent didn't have regs=40 stack=0 marks
# last_idx 11 first_idx 0
# regs=40 stack=0 before 11: (1f) r6 -= r7
# regs=c0 stack=0 before 10: (67) r7 <<= 2
# regs=c0 stack=0 before 9: (07) r6 += 14
# regs=c0 stack=0 before 8: (67) r6 <<= 2
# regs=c0 stack=0 before 7: (bf) r7 = r6
# regs=40 stack=0 before 6: (71) r6 = *(u8 *)(r2 +0)
# 16: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 16: (bf) r4 = r5
# 17: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 17: (07) r4 += 4
# 18: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 18: (3d) if r3 >= r4 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 19: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 19: (95) exit
# 20: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),var32_off=(0x2; 0x7fc)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 20: (61) r6 = *(u32 *)(r5 +0)
# 21: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=1,off=4,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 21: (95) exit
# processed 22 insns (limit 1000000) max_states_per_insn 0 total_states 2 peak_states 2 mark_read 1
# FAIL
# Test  11: pointer variable subtraction ... Failed to find match 10: R6_w=inv(id=0,umax_value=60,var_off=(0x0; 0x3c))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r0 = r2
# 3: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (07) r0 += 8
# 4: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (3d) if r3 >= r0 goto pc+1
#  R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: (95) exit
# 6: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 6: (71) r6 = *(u8 *)(r2 +0)
# 7: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 7: (bf) r7 = r6
# 8: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 8: (57) r6 &= 15
# 9: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=15,var_off=(0x0; 0xf),var32_off=(0x0; 0xf)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 9: (67) r6 <<= 2
# 10: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umax_value=60,var_off=(0x0; 0x3c),var32_off=(0x0; 0x3c)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 10: (07) r6 += 14
# 11: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 11: (bf) r5 = r2
# 12: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=0,off=0,r=8,imm=0) R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 12: (1f) r5 -= r6
# last_idx 12 first_idx 0
# regs=40 stack=0 before 11: (bf) r5 = r2
# regs=40 stack=0 before 10: (07) r6 += 14
# regs=40 stack=0 before 9: (67) r6 <<= 2
# regs=40 stack=0 before 8: (57) r6 &= 15
# regs=40 stack=0 before 7: (bf) r7 = r6
# regs=40 stack=0 before 6: (71) r6 = *(u8 *)(r2 +0)
# 13: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff),var32_off=(0x0; 0xff)) R10=fp0
# 13: (67) r7 <<= 2
# 14: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc),var32_off=(0x0; 0x3fc)) R10=fp0
# 14: (07) r7 += 76
# 15: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 15: (0f) r5 += r7
# last_idx 15 first_idx 0
# regs=80 stack=0 before 14: (07) r7 += 76
# regs=80 stack=0 before 13: (67) r7 <<= 2
# regs=80 stack=0 before 12: (1f) r5 -= r6
# regs=80 stack=0 before 11: (bf) r5 = r2
# regs=80 stack=0 before 10: (07) r6 += 14
# regs=80 stack=0 before 9: (67) r6 <<= 2
# regs=80 stack=0 before 8: (57) r6 &= 15
# regs=80 stack=0 before 7: (bf) r7 = r6
# regs=40 stack=0 before 6: (71) r6 = *(u8 *)(r2 +0)
# 16: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7_w=invP(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 16: (bf) r4 = r5
# 17: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R4_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7_w=invP(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 17: (07) r4 += 4
# 18: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7=invP(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 18: (3d) if r3 >= r4 goto pc+1
#  R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7=invP(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 19: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7=invP(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 19: (95) exit
# 20: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6=invP(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c),var32_off=(0x2; 0x7c)) R7=invP(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 20: (61) r6 = *(u32 *)(r5 +0)
# 21: R0=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) R2=pkt(id=0,off=0,r=8,imm=0) R3=pkt_end(id=0,off=0,imm=0) R4=pkt(id=2,off=4,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc),s32_min_value=0,s32_max_value=0,u32_max_value=0,var32_off=(0x0; 0x0)) R6_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff),var32_off=(0x0; 0xffffffff)) R7=invP(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc),var32_off=(0x0; 0x7fc)) R10=fp0
# 21: (95) exit
# processed 22 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
# FAIL
# Results: 4 pass 8 fail
not ok 7 selftests: bpf: test_align # exit=1

To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install job.yaml  # job file is attached in this email
        bin/lkp run     job.yaml



Thanks,
Rong Chen


--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.6.0-rc3-00213-ga162f637b0857"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.6.0-rc3 Kernel Configuration
#

#
# Compiler: gcc-7 (Debian 7.5.0-5) 7.5.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=70500
CONFIG_CLANG_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_WARN_MAYBE_UNINITIALIZED=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_XXL=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
CONFIG_XEN_PV=y
CONFIG_XEN_PV_SMP=y
# CONFIG_XEN_DOM0 is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_512GB=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_DPTF_POWER is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_AMD_SEV=y
CONFIG_KVM_MMU_AUDIT=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
CONFIG_VHOST=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
# CONFIG_DEVICE_PRIVATE is not set
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_NET_FOU=m
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_ESP_OFFLOAD is not set
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_ESP_OFFLOAD is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_FOU=m
CONFIG_IPV6_FOU_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_MPTCP_IPV6=y
# CONFIG_MPTCP_HMAC_TEST is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
# CONFIG_NF_LOG_NETDEV is not set
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
# CONFIG_NF_TABLES_SET is not set
# CONFIG_NF_TABLES_INET is not set
# CONFIG_NF_TABLES_NETDEV is not set
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
# CONFIG_NFT_CONNLIMIT is not set
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
# CONFIG_NFT_TUNNEL is not set
# CONFIG_NFT_OBJREF is not set
CONFIG_NFT_QUEUE=m
# CONFIG_NFT_QUOTA is not set
CONFIG_NFT_REJECT=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
# CONFIG_NFT_XFRM is not set
# CONFIG_NFT_SOCKET is not set
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_FO is not set
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
# CONFIG_NF_TABLES_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_DUP_IPV4=m
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
# CONFIG_NF_TABLES_IPV6 is not set
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
# CONFIG_NF_TABLES_BRIDGE is not set
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y
# end of DCCP CCIDs Configuration

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# end of DCCP Kernel Hacking

CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
CONFIG_6LOWPAN_NHC=m
CONFIG_6LOWPAN_NHC_DEST=m
CONFIG_6LOWPAN_NHC_FRAGMENT=m
CONFIG_6LOWPAN_NHC_HOP=m
CONFIG_6LOWPAN_NHC_IPV6=m
CONFIG_6LOWPAN_NHC_MOBILITY=m
CONFIG_6LOWPAN_NHC_ROUTING=m
CONFIG_6LOWPAN_NHC_UDP=m
# CONFIG_6LOWPAN_GHC_EXT_HDR_HOP is not set
# CONFIG_6LOWPAN_GHC_UDP is not set
# CONFIG_6LOWPAN_GHC_ICMPV6 is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_DEST is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
# CONFIG_NET_SCH_DEFAULT is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
# CONFIG_NET_ACT_BPF is not set
CONFIG_NET_ACT_CONNMARK=m
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_CT is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=m
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_MCBA_USB is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_SELFTEST is not set
CONFIG_BT_DEBUGFS=y

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTUSB_AUTOSUSPEND is not set
CONFIG_BT_HCIBTUSB_BCM=y
# CONFIG_BT_HCIBTUSB_MTK is not set
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_MTKSDIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_BW is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_PCI_PF_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_AR7_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
CONFIG_BLK_DEV_FD=m
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_PVPANIC=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC & related support
#
# CONFIG_INTEL_MIC_BUS is not set
# CONFIG_SCIF_BUS is not set
# CONFIG_VOP_BUS is not set
# end of Intel MIC & related support

# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# end of Misc devices

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
# CONFIG_SCSI_UFS_BSG is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
CONFIG_TCM_QLA2XXX=m
# CONFIG_TCM_QLA2XXX_DEBUG is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_QEDI is not set
# CONFIG_QEDF is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
# CONFIG_DM_WRITECACHE is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
# CONFIG_DM_INTEGRITY is not set
# CONFIG_DM_ZONED is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_ISCSI_TARGET_CXGB4=m
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=m
CONFIG_GENEVE=m
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
CONFIG_NET_VRF=y
CONFIG_VSOCKMON=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# Distributed Switch Architecture drivers
#
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_ENA_ETHERNET=m
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=m
CONFIG_PCNET32=m
CONFIG_AMD_XGBE=m
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_AQTION=m
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
CONFIG_NET_VENDOR_AURORA=y
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BCMGENET is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=y
CONFIG_TIGON3_HWMON=y
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=m
CONFIG_BNXT_SRIOV=y
CONFIG_BNXT_FLOWER_OFFLOAD=y
CONFIG_BNXT_DCB=y
CONFIG_BNXT_HWMON=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_VENDOR_CADENCE=y
CONFIG_MACB=m
CONFIG_MACB_USE_HWSTAMP=y
# CONFIG_MACB_PCI is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
CONFIG_LIQUIDIO=m
CONFIG_LIQUIDIO_VF=m
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
CONFIG_BE2NET_BE2=y
CONFIG_BE2NET_BE3=y
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=y
CONFIG_I40E_DCB=y
CONFIG_IAVF=m
CONFIG_I40EVF=m
# CONFIG_ICE is not set
CONFIG_FM10K=m
# CONFIG_IGC is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_MLX4_CORE_GEN2=y
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MICROSEMI=y
# CONFIG_MSCC_OCELOT_SWITCH is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NFP=m
CONFIG_NFP_APP_FLOWER=y
CONFIG_NFP_APP_ABM_NIC=y
# CONFIG_NFP_DEBUG is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=m
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_HWMON=y
CONFIG_NETXEN_NIC=m
CONFIG_QED=m
CONFIG_QED_SRIOV=y
CONFIG_QEDE=m
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_ROCKER=m
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
CONFIG_SFC_FALCON=m
CONFIG_SFC_FALCON_MTD=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_SOCIONEXT=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
CONFIG_TLAN=m
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
# CONFIG_MDIO_BCM_UNIMAC is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set
CONFIG_PHYLINK=m
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_SFP is not set
# CONFIG_ADIN_PHY is not set
CONFIG_AMD_PHY=m
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM84881_PHY is not set
CONFIG_CICADA_PHY=m
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=m
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_LXT_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_MARVELL_10G_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=m
# CONFIG_NXP_TJA11XX_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_ATH_COMMON=m
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
# CONFIG_ATH9K is not set
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
CONFIG_IWLEGACY_DEBUGFS=y
# end of iwl3945 / iwl4965 Debugging Options

CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_OPMODE_MODULAR=y
# CONFIG_IWLWIFI_BCAST_FILTERING is not set

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# end of Debugging Options

CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_RTL_CARDS is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_VMXNET3=m
CONFIG_FUJITSU_ES=m
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
CONFIG_ISDN=y
CONFIG_ISDN_CAPI=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_HDLC=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_NVM=y
# CONFIG_NVM_PBLK is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_MSM_VIBRATOR is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SPI is not set
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
# CONFIG_NULL_TTY is not set
CONFIG_LDISC_AUTOLOAD=y
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=m
# CONFIG_PINCTRL_BROXTON is not set
CONFIG_PINCTRL_CANNONLAKE=m
# CONFIG_PINCTRL_CEDARFORK is not set
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=m
# end of USB GPIO expanders

CONFIG_GPIO_MOCKUP=y
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CLOCK_THERMAL is not set
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=y
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_SERIAL is not set
# CONFIG_IR_SIR is not set
# CONFIG_RC_XBOX_DVD is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_DVB_CORE=m
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_DIB3000MC=m
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
# CONFIG_DVB_USB_CXUSB_ANALOG is not set
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_USB_DVBSKY is not set
# CONFIG_DVB_USB_ZD1301 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_FB_IVTV_FORCE_PAT is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_DVB_DDBRIDGE_MSIENABLE is not set
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# end of Texas Instruments WL128x FM driver (ST based)

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
# CONFIG_SMS_SIANO_DEBUGFS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_RJ54N1 is not set

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=m
# CONFIG_VIDEO_I2C is not set
# end of I2C Encoders, decoders, sensors and other helper chips

#
# SPI helper chips
#
# end of SPI helper chips

#
# Media SPI Adapters
#
# CONFIG_CXD2880_SPI_DRV is not set
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MSI001 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
# CONFIG_MEDIA_TUNER_MXL301RF is not set
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
# CONFIG_DVB_ZD1301_DEMOD is not set
CONFIG_DVB_GP8PSK_FE=m
# CONFIG_DVB_CXD2880 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
# CONFIG_DVB_MN88443X is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
# CONFIG_DVB_LNBH29 is not set
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
# CONFIG_DVB_HORUS3A is not set
# CONFIG_DVB_ASCOT2E is not set
# CONFIG_DVB_HELENE is not set

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
# CONFIG_DVB_SP2 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m
# end of Customise DVB Frontends

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_TTM_DMA_PAGE_POOL=y
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#
# end of ACP (Audio CoProcessor) Configuration

# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_SPIN_REQUEST=5
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=m
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_PCM_ELD=y
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_SEQUENCER_OSS=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# end of HD-Audio

CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=m
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER=y
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
CONFIG_SND_USB_LINE6=m
CONFIG_SND_USB_POD=m
CONFIG_SND_USB_PODHD=m
CONFIG_SND_USB_TONEPORT=m
CONFIG_SND_USB_VARIAX=m
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
CONFIG_SND_ISIGHT=m
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_FIREWIRE_MOTU is not set
# CONFIG_SND_FIREFACE is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
CONFIG_SND_SOC_ACPI=m
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_I2S_HI6210_I2S is not set
# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SST_IPC=m
CONFIG_SND_SST_IPC_ACPI=m
CONFIG_SND_SOC_INTEL_SST_ACPI=m
CONFIG_SND_SOC_INTEL_SST=m
CONFIG_SND_SOC_INTEL_SST_FIRMWARE=m
CONFIG_SND_SOC_INTEL_HASWELL=m
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=m
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=m
CONFIG_SND_SOC_INTEL_SKYLAKE=m
CONFIG_SND_SOC_INTEL_SKL=m
CONFIG_SND_SOC_INTEL_APL=m
CONFIG_SND_SOC_INTEL_KBL=m
CONFIG_SND_SOC_INTEL_GLK=m
CONFIG_SND_SOC_INTEL_CNL=m
CONFIG_SND_SOC_INTEL_CFL=m
# CONFIG_SND_SOC_INTEL_CML_H is not set
# CONFIG_SND_SOC_INTEL_CML_LP is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_FAMILY=m
CONFIG_SND_SOC_INTEL_SKYLAKE_SSP_CLK=m
# CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_COMMON=m
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_INTEL_MACH=y
# CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES is not set
CONFIG_SND_SOC_INTEL_HASWELL_MACH=m
# CONFIG_SND_SOC_INTEL_BDW_RT5650_MACH is not set
CONFIG_SND_SOC_INTEL_BDW_RT5677_MACH=m
CONFIG_SND_SOC_INTEL_BROADWELL_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=m
# CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH is not set
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=m
CONFIG_SND_SOC_INTEL_SKL_RT286_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_SSM4567_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_DA7219_MAX98357A_GENERIC=m
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_COMMON=m
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_BXT_RT298_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_MAX98927_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_RT5514_MAX98927_MACH=m
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98357A_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98927_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_RT5660_MACH is not set
# CONFIG_SND_SOC_MTK_BTCVSD is not set
# CONFIG_SND_SOC_SOF_TOPLEVEL is not set

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# CONFIG_SND_SOC_XTFPGA_I2S is not set
# CONFIG_ZX_TDM is not set
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_ADAU7118_HW is not set
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
# CONFIG_SND_SOC_CS42L42 is not set
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CX2072X is not set
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA7219=m
CONFIG_SND_SOC_DMIC=m
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES8316=m
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDMI=m
# CONFIG_SND_SOC_INNO_RK3036 is not set
# CONFIG_SND_SOC_MAX98088 is not set
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98357A=m
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
CONFIG_SND_SOC_MAX98927=m
# CONFIG_SND_SOC_MAX98373 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_RK3328 is not set
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RL6347A=m
CONFIG_SND_SOC_RT286=m
CONFIG_SND_SOC_RT298=m
CONFIG_SND_SOC_RT5514=m
CONFIG_SND_SOC_RT5514_SPI=m
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_RT5645=m
CONFIG_SND_SOC_RT5651=m
CONFIG_SND_SOC_RT5663=m
CONFIG_SND_SOC_RT5670=m
CONFIG_SND_SOC_RT5677=m
CONFIG_SND_SOC_RT5677_SPI=m
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
CONFIG_SND_SOC_SSM4567=m
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X is not set
CONFIG_SND_SOC_TS3A227E=m
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731 is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
# CONFIG_SND_SOC_WM8804_I2C is not set
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_ZX_AUD96P22 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_MT6660 is not set
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=m
CONFIG_SND_SOC_NAU8825=m
# CONFIG_SND_SOC_TPA6130A2 is not set
# end of CODEC drivers

# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_X86=y
CONFIG_HDMI_LPE_AUDIO=m
CONFIG_SND_SYNTH_EMUX=m
# CONFIG_SND_XEN_FRONTEND is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_PRODIKEYS=m
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=y
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_REDRAGON=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTI is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
# end of USB HID support

#
# I2C HID support
#
CONFIG_I2C_HID=m
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=y
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
# CONFIG_USB_CDNS3 is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IDXD is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_IMG_ASCII_LCD is not set
# CONFIG_PARPORT_PANEL is not set
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=y
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES_DEFAULT=y
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_HAVE_VPMU=y
# end of Xen driver support

# CONFIG_GREYBUS is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
# CONFIG_RTL8723BS is not set
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16240 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7816 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set
# end of Analog to digital converters

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set
# end of Analog digital bi-direction converters

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Direct Digital Synthesis
#
# CONFIG_AD9832 is not set
# CONFIG_AD9834 is not set
# end of Direct Digital Synthesis

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set
# end of Network Analyzer, Impedance Converters

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set
# end of Active energy metering IC

#
# Resolver to digital converters
#
# CONFIG_AD2S1210 is not set
# end of Resolver to digital converters
# end of IIO staging drivers

# CONFIG_FB_SM750 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# end of Speakup console speech

# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
CONFIG_ION=y
CONFIG_ION_SYSTEM_HEAP=y
# CONFIG_ION_CMA_HEAP is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
# CONFIG_MOST is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# end of Gasket devices

# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
# CONFIG_STAGING_EXFAT_FS is not set
CONFIG_QLGE=m
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACERHDF=m
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=m
CONFIG_DCDBAS=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
CONFIG_DELL_SMBIOS_SMM=y
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_WMI_LED is not set
CONFIG_DELL_SMO8800=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_RBU=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
# CONFIG_LG_LAPTOP is not set
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_SURFACE3_WMI is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
CONFIG_INTEL_WMI_THUNDERBOLT=m
# CONFIG_XIAOMI_WMI is not set
CONFIG_MSI_WMI=m
# CONFIG_PEAQ_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_PMC_CORE=m
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_HUAWEI_WMI is not set
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

# CONFIG_SYSTEM76_ACPI is not set
CONFIG_PMC_ATOM=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# end of Common Clock Framework

# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Aspeed SoC drivers
#
# end of Aspeed SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=m
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7091R5 is not set
# CONFIG_AD7124 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7292 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2496 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_VIPERBOARD_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog Front Ends
#
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# end of Amplifiers

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SPS30 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# end of Hid Sensor IIO Common

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8801 is not set
# CONFIG_DS4424 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_HDC100X is not set
# CONFIG_HID_SENSOR_HUMIDITY is not set
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_FXOS8700_I2C is not set
# CONFIG_FXOS8700_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9960 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_JSA1212 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR501 is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML6030 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Digital potentiometers
#
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_BMP280 is not set
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_HP03 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VL53L0X_I2C is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_LTC2983 is not set
# CONFIG_MAXIM_THERMOCOUPLE is not set
# CONFIG_HID_SENSOR_TEMP is not set
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX31856 is not set
# end of Temperature sensors

CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
CONFIG_NTB_AMD=m
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
CONFIG_NTB_PERF=m
CONFIG_NTB_TRANSPORT=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_INTEL_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
CONFIG_PM_OPP=y
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=m
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
# CONFIG_IMA_ARCH_POLICY is not set
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m
CONFIG_CRYPTO_ENGINE=m

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=m
# CONFIG_CRYPTO_USER_API_AEAD is not set
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
# CONFIG_CRYPTO_DEV_NITROX_CNN55XX is not set
CONFIG_CRYPTO_DEV_CHELSIO=m
CONFIG_CRYPTO_DEV_VIRTIO=m
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SGL_ALLOC=y
CONFIG_IOMMU_HELPER=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_BTF is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_FS=y
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_UBSAN_ALIGNMENT=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=1
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_WW_MUTEX_SELFTEST=m
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
CONFIG_RCU_PERF_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=m
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export need_memory='2G'
	export need_cpu=2
	export kernel_cmdline='erst_disable'
	export job_origin='/lkp/lkp/.src-20200316-115832/allot/cyclic:p1:linux-devel:devel-hourly/lkp-skl-d01/kernel-selftests.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-skl-d01'
	export tbox_group='lkp-skl-d01'
	export submit_id='5e76609248b0475d516bb240'
	export job_file='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-bpf-ucode=0xd6-debian-x86_64-20191114.cgz-a162f637b08577f8e843d469ec20b338853e05ca-20200322-23889-xmpj8t-3.yaml'
	export id='55d8c0d36a8b1745285eb5020c818b098dc382b3'
	export queuer_version='/lkp-src'
	export model='Skylake'
	export nr_cpu=8
	export memory='16G'
	export nr_hdd_partitions=1
	export hdd_partitions='/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part1'
	export swap_partitions='/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part3'
	export rootfs_partition='/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part2'
	export brand='Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz'
	export cpu_info='skylake i7-6700'
	export bios_version='1.2.8'
	export commit='a162f637b08577f8e843d469ec20b338853e05ca'
	export need_kconfig_hw='CONFIG_E1000E=y
CONFIG_SATA_AHCI'
	export ucode='0xd6'
	export need_kernel_headers=true
	export need_kernel_selftests=true
	export need_kconfig='CONFIG_BPF_EVENTS=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_BPF_SYSCALL=y
CONFIG_CGROUP_BPF=y
CONFIG_IPV6_SEG6_LWTUNNEL=y ~ v(4\.1[0-9]|4\.20|5\.)
CONFIG_LWTUNNEL=y
CONFIG_MPLS_IPTUNNEL=m ~ v(4\.[3-9]|4\.1[0-9]|4\.20|5\.)
CONFIG_MPLS_ROUTING=m ~ v(4\.[1-9]|4\.1[0-9]|4\.20|5\.)
CONFIG_NET_CLS_BPF=m
CONFIG_RC_LOOPBACK
CONFIG_TEST_BPF=m'
	export kconfig='x86_64-rhel-7.6'
	export compiler='gcc-7'
	export enqueue_time='2020-03-22 02:44:37 +0800'
	export _id='5e76609648b0475d516bb242'
	export _rt='/result/kernel-selftests/kselftests-bpf-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca'
	export user='lkp'
	export head_commit='f464157e09bc161b12e299bf3614d5f503e7e938'
	export base_commit='2c523b344dfa65a3738e7039832044aa133c75fb'
	export branch='linux-devel/devel-hourly-2020031221'
	export rootfs='debian-x86_64-20191114.cgz'
	export result_root='/result/kernel-selftests/kselftests-bpf-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/3'
	export scheduler_version='/lkp/lkp/.src-20200320-113654'
	export LKP_SERVER='inn'
	export arch='x86_64'
	export max_uptime=3600
	export initrd='/osimage/debian/debian-x86_64-20191114.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-bpf-ucode=0xd6-debian-x86_64-20191114.cgz-a162f637b08577f8e843d469ec20b338853e05ca-20200322-23889-xmpj8t-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.6
branch=linux-devel/devel-hourly-2020031221
commit=a162f637b08577f8e843d469ec20b338853e05ca
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/vmlinuz-5.6.0-rc3-00213-ga162f637b0857
erst_disable
max_uptime=3600
RESULT_ROOT=/result/kernel-selftests/kselftests-bpf-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/3
LKP_SERVER=inn
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/modules.cgz'
	export bm_initrd='/osimage/deps/debian-x86_64-20180403.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/lkp_2019-08-05.cgz,/osimage/deps/debian-x86_64-20180403.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/kernel-selftests_20200313.cgz,/osimage/pkg/debian-x86_64-20180403.cgz/kernel-selftests-x86_64-92cfe326-1_20200310.cgz,/osimage/deps/debian-x86_64-20180403.cgz/hw_2020-01-02.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/linux-selftests.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='4.20.0'
	export repeat_to=8
	export schedule_notify_address=
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/vmlinuz-5.6.0-rc3-00213-ga162f637b0857'
	export dequeue_time='2020-03-22 03:11:49 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-bpf-ucode=0xd6-debian-x86_64-20191114.cgz-a162f637b08577f8e843d469ec20b338853e05ca-20200322-23889-xmpj8t-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='kselftests-bpf' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--BcZrms9gUsdgyR6a
Content-Type: application/x-xz
Content-Disposition: attachment; filename="kmsg.xz"
Content-Transfer-Encoding: base64

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
t6y9CgAB24QJlI9nugEVF7HEZ/sCAAAAAARZWg==

--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/kernel-selftests.yaml
suite: kernel-selftests
testcase: kernel-selftests
category: functional
need_memory: 2G
need_cpu: 2
kernel-selftests:
  group: kselftests-bpf
kernel_cmdline: erst_disable
job_origin: "/lkp/lkp/.src-20200316-115832/allot/cyclic:p1:linux-devel:devel-hourly/lkp-skl-d01/kernel-selftests.yaml"

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-skl-d01
tbox_group: lkp-skl-d01
submit_id: 5e76548c48b0475c63ac966b
job_file: "/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-bpf-ucode=0xd6-debian-x86_64-20191114.cgz-a162f637b08577f8e843d469ec20b338853e05ca-20200322-23651-1xhmeau-0.yaml"
id: 553eea2760db4f7daaf082d5a799bc5d4a798d2c
queuer_version: "/lkp-src"

#! hosts/lkp-skl-d01
model: Skylake
nr_cpu: 8
memory: 16G
nr_hdd_partitions: 1
hdd_partitions: "/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part1"
swap_partitions: "/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part3"
rootfs_partition: "/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part2"
brand: Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz
cpu_info: skylake i7-6700
bios_version: 1.2.8

#! include/category/functional
kmsg: 
heartbeat: 
meminfo: 

#! include/queue/cyclic
commit: a162f637b08577f8e843d469ec20b338853e05ca

#! include/testbox/lkp-skl-d01
need_kconfig_hw:
- CONFIG_E1000E=y
- CONFIG_SATA_AHCI
ucode: '0xd6'

#! include/kernel-selftests
need_kernel_headers: true
need_kernel_selftests: true
need_kconfig:
- CONFIG_BPF_EVENTS=y
- CONFIG_BPF_STREAM_PARSER=y
- CONFIG_BPF_SYSCALL=y
- CONFIG_CGROUP_BPF=y
- CONFIG_IPV6_SEG6_LWTUNNEL=y ~ v(4\.1[0-9]|4\.20|5\.)
- CONFIG_LWTUNNEL=y
- CONFIG_MPLS_IPTUNNEL=m ~ v(4\.[3-9]|4\.1[0-9]|4\.20|5\.)
- CONFIG_MPLS_ROUTING=m ~ v(4\.[1-9]|4\.1[0-9]|4\.20|5\.)
- CONFIG_NET_CLS_BPF=m
- CONFIG_RC_LOOPBACK
- CONFIG_TEST_BPF=m

#! default params
kconfig: x86_64-rhel-7.6
compiler: gcc-7
enqueue_time: 2020-03-22 01:53:19.522760762 +08:00
_id: 5e76548c48b0475c63ac966b
_rt: "/result/kernel-selftests/kselftests-bpf-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca"

#! schedule options
user: lkp
head_commit: f464157e09bc161b12e299bf3614d5f503e7e938
base_commit: 2c523b344dfa65a3738e7039832044aa133c75fb
branch: linux-devel/devel-hourly-2020031221
rootfs: debian-x86_64-20191114.cgz
result_root: "/result/kernel-selftests/kselftests-bpf-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/0"
scheduler_version: "/lkp/lkp/.src-20200320-113654"
LKP_SERVER: inn
arch: x86_64
max_uptime: 3600
initrd: "/osimage/debian/debian-x86_64-20191114.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-bpf-ucode=0xd6-debian-x86_64-20191114.cgz-a162f637b08577f8e843d469ec20b338853e05ca-20200322-23651-1xhmeau-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-7.6
- branch=linux-devel/devel-hourly-2020031221
- commit=a162f637b08577f8e843d469ec20b338853e05ca
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/vmlinuz-5.6.0-rc3-00213-ga162f637b0857
- erst_disable
- max_uptime=3600
- RESULT_ROOT=/result/kernel-selftests/kselftests-bpf-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/0
- LKP_SERVER=inn
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/modules.cgz"
bm_initrd: "/osimage/deps/debian-x86_64-20180403.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/lkp_2019-08-05.cgz,/osimage/deps/debian-x86_64-20180403.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/kernel-selftests_20200313.cgz,/osimage/pkg/debian-x86_64-20180403.cgz/kernel-selftests-x86_64-92cfe326-1_20200310.cgz,/osimage/deps/debian-x86_64-20180403.cgz/hw_2020-01-02.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/linux-selftests.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20200316-115832/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
last_kernel: 4.20.0
schedule_notify_address: 

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-7.6/gcc-7/a162f637b08577f8e843d469ec20b338853e05ca/vmlinuz-5.6.0-rc3-00213-ga162f637b0857"
dequeue_time: 2020-03-22 02:30:25.146195291 +08:00

#! /lkp/lkp/.src-20200320-113654/include/site/inn
job_state: finished
loadavg: 1.21 1.33 0.87 1/176 25830
start_time: '1584815477'
end_time: '1584816097'
version: "/lkp/lkp/.src-20200320-113724:1acb4486:0c7d3e98b"

--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

 "sed" "-i" "s/default_timeout=45/default_timeout=300/" "kselftest/runner.sh"
 "make" "-C" "../../../tools/bpf/bpftool"
 "make" "install" "-C" "../../../tools/bpf/bpftool"
 "make" "run_tests" "-C" "bpf"

--BcZrms9gUsdgyR6a--
