Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205F1AC975
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbfIGVnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:43:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbfIGVnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:43:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Ld51v149085;
        Sat, 7 Sep 2019 21:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=ctPsnIujgzWrohKWFCNGfO0OQlGium6QMRD9+NVqngo=;
 b=TokQdDV8I1XVlUCpVhb/tdsEBJL6epHimtbjxSdWPu6NcGHNFemi3rMgycwcbDPm+UTz
 +uSbsKHG9eMKRpgG74Q9hR5BEEozo3aQV5UPUaTVjJTsdL//Dqhon11FTJT9S/uglByD
 jpEidqx7lACyS7qDEYHmr6sKLnL0EpxTlDJ4RVeXTnIROXV9TP1PNGM50Paqo5CG3dAL
 aj5tt1UoXCWj2b+hwaxUCNaVbmC3gshwoYoSLeTF0VSNNARwXbwgCDDrtSXmbD0kMw9R
 dt9oE6HJsrl8Cefkj5n5HXTyzPn/Th4wQPFqOPE5IviKZ58pXAQXKb5SkUI1ikRC/rX9 ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uvmet80ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:41:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LcdIC035691;
        Sat, 7 Sep 2019 21:41:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2uv3wjnmm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:41:39 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87LfYG9006104;
        Sat, 7 Sep 2019 21:41:34 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:41:34 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        quentin.monnet@netronome.com, rdna@fb.com, joe@wand.net.nz,
        acme@redhat.com, jolsa@kernel.org, alexey.budankov@linux.intel.com,
        gregkh@linuxfoundation.org, namhyung@kernel.org, sdf@google.com,
        f.fainelli@gmail.com, shuah@kernel.org, peter@lekensteyn.nl,
        ivan@cloudflare.com, andriin@fb.com,
        bhole_prashant_q7@lab.ntt.co.jp, david.calavera@gmail.com,
        danieltimlee@gmail.com, ctakshak@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 0/7] bpf: packet capture helpers, bpftool support
Date:   Sat,  7 Sep 2019 22:40:37 +0100
Message-Id: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packet capture is useful from a general debugging standpoint, and is
useful in particular in debugging BPF programs that do packet processing.
For general debugging, being able to initiate arbitrary packet capture
from kprobes and tracepoints is highly valuable; e.g. what do the packets
that reach kfree_skb() - representing error codepaths - look like?
Arbitrary packet capture is distinct from the traditional concept of
pre-defined hooks, and gives much more flexibility in probing system
behaviour. For packet-processing BPF programs, packet capture can be useful
for doing things such as debugging checksum errors.

The intent of this RFC patchset is to initiate discussion on if and how to
work packet capture-specific capabilities into BPF.  It is possible -
and indeed projects like xdpcap [1] have demonstrated how - to carry out
packet capture in BPF today via perf events, but the aim here is to
simplify both the in-BPF capture and the userspace collection.

The suggested approach is to add a new bpf helper - bpf_pcap() - to
simplify packet capture within BPF programs, and to enhance bpftool
to add a "pcap" subcommand to aid in retrieving packets.  The helper
is for the most part a wrapper around perf event sending, using
data relevant for packet capture as metadata.

The end result is being able to capture packet data in the following
manner.  For example if we add an iptables drop rule, we can observe
TCP SYN segments being freed at kfree_skb:

$ iptables -A INPUT -p tcp --dport 6666 -j DROP
$ bpftool pcap trace kprobe:kfree_skb proto ip data_out /tmp/cap &
$ nc 127.0.0.1 6666
Ncat: Connection timed out.
$ fg
^C
$ tshark -r /tmp/cap
Running as user "root" and group "root". This could be dangerous.
...
  3          7    127.0.0.1 -> 127.0.0.1    TCP 60 54732 > ircu [SYN] Seq=0 Win=65495 Len=0 MSS=65495 SACK_PERM=1 TSval=696475539 TSecr=0 WS=128
...

Tracepoints are also supported, and by default data is sent to
stdout, so we can pipe to tcpdump:

$ bpftool pcap trace tracepoint:net_dev_xmit:arg1 proto eth | tcpdump -r -
reading from file -, link-type EN10MB (Ethernet)
00:16:49.150880 IP 10.11.12.13 > 10.11.12.14: ICMP echo reply, id 10519, seq 1, length 64
...

Patch 1 adds support for bpf_pcap() in skb and XDP programs.  In those cases,
the argument is the relevant context (struct __sk_buff or xdp metadata)
from which we capture.
Patch 2 extends the helper to allow it to work for tracing programs, and in
that case the data argument is a pointer to an skb, derived from raw
tracepoint or kprobe arguments.
Patch 3 syncs uapi and tools headers for the new helper, flags and associated
pcap header type.
Patch 4 adds a feature test for libpcap which will be used in the next patch.
Patch 5 adds a "pcap" subcommand to bpftool to collect packet data from
BPF-driven perf event maps in existing programs.  Also supplied are simple
tracepoint and kprobe programs which can be used to attach to a kprobe
or raw tracepoint to retrieve arguments and capture the associated skb.
Patch 6 adds documentation for the new pcap subcommand.
Patch 7 tests the pcap subcommand for tracing, skb and xdp programs.

Alan Maguire (7):
  bpf: add bpf_pcap() helper to simplify packet capture
  bpf: extend bpf_pcap support to tracing programs
  bpf: sync tools/include/uapi/linux/bpf.h for pcap support
  bpf: add libpcap feature test
  bpf: add pcap support to bpftool
  bpf: add documentation for bpftool pcap subcommand
  bpf: add tests for bpftool packet capture

 include/linux/bpf.h                                |  20 +
 include/uapi/linux/bpf.h                           |  92 +++-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/trace/bpf_trace.c                           | 214 +++++++++
 net/core/filter.c                                  |  67 +++
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   1 +
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   1 +
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |   1 +
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   1 +
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |   1 +
 tools/bpf/bpftool/Documentation/bpftool-pcap.rst   | 119 +++++
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |   1 +
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   1 +
 tools/bpf/bpftool/Documentation/bpftool.rst        |   1 +
 tools/bpf/bpftool/Makefile                         |  39 +-
 tools/bpf/bpftool/main.c                           |   3 +-
 tools/bpf/bpftool/main.h                           |   1 +
 tools/bpf/bpftool/pcap.c                           | 496 +++++++++++++++++++++
 tools/bpf/bpftool/progs/bpftool_pcap_kprobe.c      |  80 ++++
 tools/bpf/bpftool/progs/bpftool_pcap_tracepoint.c  |  68 +++
 tools/build/Makefile.feature                       |   2 +
 tools/build/feature/Makefile                       |   4 +
 tools/build/feature/test-libpcap.c                 |  26 ++
 tools/include/uapi/linux/bpf.h                     |  92 +++-
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |  11 +
 .../testing/selftests/bpf/progs/bpftool_pcap_tc.c  |  41 ++
 .../testing/selftests/bpf/progs/bpftool_pcap_xdp.c |  39 ++
 tools/testing/selftests/bpf/test_bpftool_pcap.sh   | 132 ++++++
 29 files changed, 1549 insertions(+), 12 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-pcap.rst
 create mode 100644 tools/bpf/bpftool/pcap.c
 create mode 100644 tools/bpf/bpftool/progs/bpftool_pcap_kprobe.c
 create mode 100644 tools/bpf/bpftool/progs/bpftool_pcap_tracepoint.c
 create mode 100644 tools/build/feature/test-libpcap.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpftool_pcap_tc.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpftool_pcap_xdp.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_pcap.sh

-- 
1.8.3.1

