Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF571A3119
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgDIImc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:42:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41025 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIImc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:42:32 -0400
Received: from 1.general.ppisati.uk.vpn ([10.172.193.134] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1jMSlT-0000Km-Lv; Thu, 09 Apr 2020 08:42:23 +0000
Date:   Thu, 9 Apr 2020 10:42:23 +0200
From:   Paolo Pisati <paolo.pisati@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: selftests/bpf: test_maps: libbpf: Error loading .BTF into kernel:
 -22. Failed to load SK_SKB verdict prog
Message-ID: <20200409084223.GA72109@harukaze>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_maps fails consistently on x86-64 5.4.y (5.4.31 and defconfig +
tools/testing/selftests/bpf/config in this case) and dumps this output:

~/linux/tools/testing/selftests/bpf$ sudo ./test_maps
libbpf: Error loading BTF: Invalid argument(22)
libbpf: magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 780
str_off: 780
str_len: 854
btf_total_size: 1658
[1] PTR (anon) type_id=2
[2] STRUCT __sk_buff size=176 vlen=31
	len type_id=3 bits_offset=0
	pkt_type type_id=3 bits_offset=32
	mark type_id=3 bits_offset=64
	queue_mapping type_id=3 bits_offset=96
	protocol type_id=3 bits_offset=128
	vlan_present type_id=3 bits_offset=160
	vlan_tci type_id=3 bits_offset=192
	vlan_proto type_id=3 bits_offset=224
	priority type_id=3 bits_offset=256
	ingress_ifindex type_id=3 bits_offset=288
	ifindex type_id=3 bits_offset=320
	tc_index type_id=3 bits_offset=352
	cb type_id=5 bits_offset=384
	hash type_id=3 bits_offset=544
	tc_classid type_id=3 bits_offset=576
	data type_id=3 bits_offset=608
	data_end type_id=3 bits_offset=640
	napi_id type_id=3 bits_offset=672
	family type_id=3 bits_offset=704
	remote_ip4 type_id=3 bits_offset=736
	local_ip4 type_id=3 bits_offset=768
	remote_ip6 type_id=7 bits_offset=800
	local_ip6 type_id=7 bits_offset=928
	remote_port type_id=3 bits_offset=1056
	local_port type_id=3 bits_offset=1088
	data_meta type_id=3 bits_offset=1120
	(anon) type_id=8 bits_offset=1152
	tstamp type_id=10 bits_offset=1216
	wire_len type_id=3 bits_offset=1280
	gso_segs type_id=3 bits_offset=1312
	(anon) type_id=12 bits_offset=1344
[3] TYPEDEF __u32 type_id=4
[4] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[5] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=5
[6] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[7] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=4
[8] UNION (anon) size=8 vlen=1
	flow_keys type_id=9 bits_offset=0
[9] PTR (anon) type_id=23
[10] TYPEDEF __u64 type_id=11
[11] INT long long unsigned int size=8 bits_offset=0 nr_bits=64 encoding=(none)
[12] UNION (anon) size=8 vlen=1
	sk type_id=13 bits_offset=0
[13] PTR (anon) type_id=24
[14] FUNC_PROTO (anon) return=15 args=(1 skb)
[15] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[16] FUNC bpf_prog1 type_id=14 vlen != 0

libbpf: Error loading .BTF into kernel: -22.
libbpf: Error loading BTF: Invalid argument(22)
libbpf: magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 440
str_off: 440
str_len: 564
btf_total_size: 1028
[1] PTR (anon) type_id=2
[2] STRUCT sk_msg_md size=72 vlen=10
	(anon) type_id=3 bits_offset=0
	(anon) type_id=5 bits_offset=64
	family type_id=6 bits_offset=128
	remote_ip4 type_id=6 bits_offset=160
	local_ip4 type_id=6 bits_offset=192
	remote_ip6 type_id=8 bits_offset=224
	local_ip6 type_id=8 bits_offset=352
	remote_port type_id=6 bits_offset=480
	local_port type_id=6 bits_offset=512
	size type_id=6 bits_offset=544
[3] UNION (anon) size=8 vlen=1
	data type_id=4 bits_offset=0
[4] PTR (anon) type_id=0
[5] UNION (anon) size=8 vlen=1
	data_end type_id=4 bits_offset=0
[6] TYPEDEF __u32 type_id=7
[7] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[8] ARRAY (anon) type_id=6 index_type_id=9 nr_elems=4
[9] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[10] FUNC_PROTO (anon) return=11 args=(1 msg)
[11] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[12] FUNC bpf_prog1 type_id=10 vlen != 0

libbpf: Error loading .BTF into kernel: -22.
libbpf: Error loading BTF: Invalid argument(22)
libbpf: magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 1300
str_off: 1300
str_len: 907
btf_total_size: 2231
[1] STRUCT (anon) size=32 vlen=4
	type type_id=2 bits_offset=0
	max_entries type_id=6 bits_offset=64
	key_size type_id=8 bits_offset=128
	value_size type_id=8 bits_offset=192
[2] PTR (anon) type_id=4
[3] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[4] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=15
[5] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[6] PTR (anon) type_id=7
[7] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=20
[8] PTR (anon) type_id=9
[9] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=4
[10] VAR sock_map_rx type_id=1 linkage=1
[11] STRUCT (anon) size=32 vlen=4
	type type_id=2 bits_offset=0
	max_entries type_id=6 bits_offset=64
	key_size type_id=8 bits_offset=128
	value_size type_id=8 bits_offset=192
[12] VAR sock_map_tx type_id=11 linkage=1
[13] STRUCT (anon) size=32 vlen=4
	type type_id=2 bits_offset=0
	max_entries type_id=6 bits_offset=64
	key_size type_id=8 bits_offset=128
	value_size type_id=8 bits_offset=192
[14] VAR sock_map_msg type_id=13 linkage=1
[15] STRUCT (anon) size=32 vlen=4
	type type_id=16 bits_offset=0
	max_entries type_id=6 bits_offset=64
	key type_id=18 bits_offset=128
	value type_id=18 bits_offset=192
[16] PTR (anon) type_id=17
[17] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=2
[18] PTR (anon) type_id=3
[19] VAR sock_map_break type_id=15 linkage=1
[20] PTR (anon) type_id=21
[21] STRUCT __sk_buff size=176 vlen=31
	len type_id=22 bits_offset=0
	pkt_type type_id=22 bits_offset=32
	mark type_id=22 bits_offset=64
	queue_mapping type_id=22 bits_offset=96
	protocol type_id=22 bits_offset=128
	vlan_present type_id=22 bits_offset=160
	vlan_tci type_id=22 bits_offset=192
	vlan_proto type_id=22 bits_offset=224
	priority type_id=22 bits_offset=256
	ingress_ifindex type_id=22 bits_offset=288
	ifindex type_id=22 bits_offset=320
	tc_index type_id=22 bits_offset=352
	cb type_id=24 bits_offset=384
	hash type_id=22 bits_offset=544
	tc_classid type_id=22 bits_offset=576
	data type_id=22 bits_offset=608
	data_end type_id=22 bits_offset=640
	napi_id type_id=22 bits_offset=672
	family type_id=22 bits_offset=704
	remote_ip4 type_id=22 bits_offset=736
	local_ip4 type_id=22 bits_offset=768
	remote_ip6 type_id=25 bits_offset=800
	local_ip6 type_id=25 bits_offset=928
	remote_port type_id=22 bits_offset=1056
	local_port type_id=22 bits_offset=1088
	data_meta type_id=22 bits_offset=1120
	(anon) type_id=26 bits_offset=1152
	tstamp type_id=28 bits_offset=1216
	wire_len type_id=22 bits_offset=1280
	gso_segs type_id=22 bits_offset=1312
	(anon) type_id=30 bits_offset=1344
[22] TYPEDEF __u32 type_id=23
[23] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[24] ARRAY (anon) type_id=22 index_type_id=5 nr_elems=5
[25] ARRAY (anon) type_id=22 index_type_id=5 nr_elems=4
[26] UNION (anon) size=8 vlen=1
	flow_keys type_id=27 bits_offset=0
[27] PTR (anon) type_id=41
[28] TYPEDEF __u64 type_id=29
[29] INT long long unsigned int size=8 bits_offset=0 nr_bits=64 encoding=(none)
[30] UNION (anon) size=8 vlen=1
	sk type_id=31 bits_offset=0
[31] PTR (anon) type_id=42
[32] FUNC_PROTO (anon) return=3 args=(20 skb)
[33] FUNC bpf_prog2 type_id=32 vlen != 0

libbpf: Error loading .BTF into kernel: -22.
Failed to load SK_SKB verdict prog

~/linux/tools/testing/selftests/bpf$ find . -name sockmap_\*prog.o
./sockmap_verdict_prog.o
./sockmap_tcp_msg_prog.o
./alu32/sockmap_verdict_prog.o
./alu32/sockmap_tcp_msg_prog.o
./alu32/sockmap_parse_prog.o
./sockmap_parse_prog.o

$ dpkg -l | grep clang
ii  clang                            1:10.0-50~exp1                      amd64 C, C++ and Objective-C compiler (LLVM based)
ii  clang-10                         1:10.0.0-2ubuntu2                   amd64 C, C++ and Objective-C compiler
ii  libclang-common-10-dev           1:10.0.0-2ubuntu2                   amd64 Clang library - Common development package
ii  libclang-cpp10                   1:10.0.0-2ubuntu2                   amd64 C++ interface to the Clang library
ii  libclang1-10                     1:10.0.0-2ubuntu2                   amd64 C interface to the Clang library

Full log of "TARGETS=bpf run_tests" is available here: https://paste.ubuntu.com/p/MTkWD63Zgc/
-- 
bye,
p.
