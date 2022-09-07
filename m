Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B675B09BF
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiIGQIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiIGQIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:08:25 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1583AE7F;
        Wed,  7 Sep 2022 09:08:21 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 50B395C0150;
        Wed,  7 Sep 2022 12:08:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 12:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662566898; x=1662653298; bh=09XcLY+Oh89nxAbOdZB+wq/xVi9I
        kY5d9sAv3nm7+vU=; b=S+2VagZcRJa0df0SXZoltSC5mTxQ2CJMLQbGS+ADdHeb
        6GkHCYghhu6pQnr7fny4YGaX/Yce6RLfhEqLSiBT+AUaNN50TaUtBwQRJ7MC1SmQ
        Q7aaJFrZ/+GwZ+SNNjwG1X9GlAOT/zkiVm7GD6fw7kC6WwE6pI7aeK2TF2AtTyud
        e9BG7W3tQG0aUUlNMTl+tA+skmheYcf6Ir/dKwhZ8btyFXYAGik/A+YgJ+lpQ2pR
        PTZI3soXAa4BAnKghj63bdVjjMTs3hq1Qh7DzwkwjE/D3EACsAgNJch4ydfcZSF4
        K/8QkNh+XUceApvbG9kiyEVU6nTj3LHrnE6xdtncRA==
X-ME-Sender: <xms:8cEYY8Mo99YOk85-NRX0cy2LFdqOmW0Pd4eG1z8avUKe3n8A50wPJA>
    <xme:8cEYYy-plYsm4M_CZK7B0HtP5dSsZJcoYjKqESg61_kD7603opVArBAkOIHSOseCY
    LAwHrpInoM1RXU>
X-ME-Received: <xmr:8cEYYzSbbZVxXSY0KkJXrtsu6mCQGRvpApk4HqVW5RMl7PwDnbg2n8OkrIntx805cJKR3UpgFsYFroQaRH-meOk1KcdKIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepfeehffeggeffueffheeitdfhkedtfeelffffjeegtedtffegieejjeeuteej
    teevnecuffhomhgrihhnpehofhhflhhorggurdhphienucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:8cEYY0s574npuVmYzJvedy1Yu5t-t5SZaQ7qQV4isikwv2QTzw8LBQ>
    <xmx:8cEYY0eLvL8_qBZs6c1d6L16JBKoF2QVityTgEhKcPWxJdtTX8W3lQ>
    <xmx:8cEYY42zw4BLGYFAtgoF4QyrpVtVonW2PQsx9Xg4Xd_ZxJ4hOtM70A>
    <xmx:8sEYYz-XXd8EynQ6tmnN6sEV7OTbM-5p3JEML7n-JKmnG5OyzfWK0A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:08:17 -0400 (EDT)
Date:   Wed, 7 Sep 2022 19:08:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>, kuba@kernel.org
Cc:     "andrii@kernel.org" <andrii@kernel.org>,
        "mykolal@fb.com" <mykolal@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed
Message-ID: <YxjB7RZvVrKxJ4ec@shredder>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
 <Yxg9r37w1Wg3mvxy@shredder>
 <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 08:51:56AM +0000, Zhou, Jie2X wrote:
> What is the output of test_offload.py?

This output [1], but requires this [2] additional fix on top of the one
I already posted for netdevsim. Hopefully someone more familiar with
this test can comment if this is the right fix or not.

Without it, bpftool refuses to load the program [3].

[1]
# ./test_offload.py
Test destruction of generic XDP...
Test TC non-offloaded...
Test TC non-offloaded isn't getting bound...
Test TC offloads are off by default...
[...]
test_offload.py: OK
# echo $?
0

[2]
diff --git a/tools/testing/selftests/bpf/progs/sample_map_ret0.c b/tools/testing/selftests/bpf/progs/sample_map_ret0.c
index 495990d355ef..91417aae6194 100644
--- a/tools/testing/selftests/bpf/progs/sample_map_ret0.c
+++ b/tools/testing/selftests/bpf/progs/sample_map_ret0.c
@@ -17,7 +17,8 @@ struct {
 } array SEC(".maps");
 
 /* Sample program which should always load for testing control paths. */
-SEC(".text") int func()
+SEC("xdp")
+int func()
 {
 	__u64 key64 = 0;
 	__u32 key = 0;
diff --git a/tools/testing/selftests/bpf/progs/sample_ret0.c b/tools/testing/selftests/bpf/progs/sample_ret0.c
index fec99750d6ea..f51c63dd6f20 100644
--- a/tools/testing/selftests/bpf/progs/sample_ret0.c
+++ b/tools/testing/selftests/bpf/progs/sample_ret0.c
@@ -1,6 +1,9 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause) */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
 
 /* Sample program which should always load for testing control paths. */
+SEC("xdp")
 int func()
 {
 	return 0;
diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 6cd6ef9fc20b..0381f48f45a6 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -235,7 +235,7 @@ def tc(args, JSON=True, ns="", fail=True, include_stderr=False):
 def ethtool(dev, opt, args, fail=True):
     return cmd("ethtool %s %s %s" % (opt, dev["ifname"], args), fail=fail)
 
-def bpf_obj(name, sec=".text", path=bpf_test_dir,):
+def bpf_obj(name, sec="xdp", path=bpf_test_dir,):
     return "obj %s sec %s" % (os.path.join(path, name), sec)
 
 def bpf_pinned(name):

[3]
# bpftool prog load /home/idosch/code/linux/tools/testing/selftests/bpf/sample_ret0.o /sys/fs/bpf/nooffload type xdp                                                 
Error: object file doesn't contain any bpf program                                    
Warning: bpftool is now running in libbpf strict mode and has more stringent requirements about BPF programs.                                                                
If it used to work for this object file but now doesn't, see --legacy option for more details.
