Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BE162CD3E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiKPV5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiKPV5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:57:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5248A3E098;
        Wed, 16 Nov 2022 13:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 023B4B81EBF;
        Wed, 16 Nov 2022 21:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D44BC433C1;
        Wed, 16 Nov 2022 21:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668635850;
        bh=zgfbVo/6Bo4fpPeHCBf3LJifxnzj6sKBZyzoePN5L7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l+ux4JXoMlNwwvLddQzzQOJGvLyUMaQN7gZBv0fQ6Rec/aMGkC+hfp/5iQwoYWaG1
         ZhZE87J9oDzAtTwBVr7MZE1gJVfQUDiba27RhRur5SldfbJrFIXnh45Lo5563Vad5Y
         pbHLjlMPLdp2igLLi36nGGT+9ktsAiBVLhaI24HOXE2UC1Spiv2JD017yPwC65BfmE
         HT8rxAJ2SoDPxf5tcD7yguAjsQAx6TK4280LFsQgAJFWea3I+0XHAdCKS4au2tfdaK
         tsuJXqB7GRAy9fxFV2TnA0qy57ljghlxCzWoa35w83j7nzW/U5AQsYx4bQpBG+kXTJ
         SbcCVl5XvqyfQ==
Date:   Wed, 16 Nov 2022 13:57:29 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, andrii@kernel.org, mykolal@fb.com,
        ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        Daniel =?iso-8859-1?Q?M=FCller?= <deso@posteo.net>
Subject: Re: [PATCH v2 1/2] selftests/net: fix missing xdp_dummy
Message-ID: <Y3VcyRoZ3OQvv309@x130.lan>
References: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
 <1668507800-45450-2-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1668507800-45450-2-git-send-email-wangyufen@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 18:23, Wang Yufen wrote:
>After commit afef88e65554 ("selftests/bpf: Store BPF object files with
>.bpf.o extension"), we should use xdp_dummy.bpf.o instade of xdp_dummy.o.
>
>In addition, use the BPF_FILE variable to save the BPF object file name,
>which can be better identified and modified.
>
>Fixes: afef88e65554 ("selftests/bpf: Store BPF object files with .bpf.o extension")
>Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>Cc: Daniel Müller <deso@posteo.net>
>---
> tools/testing/selftests/net/udpgro.sh         | 6 ++++--
> tools/testing/selftests/net/udpgro_bench.sh   | 6 ++++--
> tools/testing/selftests/net/udpgro_frglist.sh | 6 ++++--
> tools/testing/selftests/net/udpgro_fwd.sh     | 3 ++-
> tools/testing/selftests/net/veth.sh           | 9 +++++----
> 5 files changed, 19 insertions(+), 11 deletions(-)
>
>diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
>index 6a443ca..a66d62e 100755
>--- a/tools/testing/selftests/net/udpgro.sh
>+++ b/tools/testing/selftests/net/udpgro.sh
>@@ -5,6 +5,8 @@
>
> readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
>
>+BPF_FILE="../bpf/xdp_dummy.bpf.o"
>+
> # set global exit status, but never reset nonzero one.
> check_err()
> {
>@@ -34,7 +36,7 @@ cfg_veth() {
> 	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
> 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
> 	ip -netns "${PEER_NS}" link set dev veth1 up
>-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
>+	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
> }
>
> run_one() {
>@@ -195,7 +197,7 @@ run_all() {
> 	return $ret
> }
>
>-if [ ! -f ../bpf/xdp_dummy.o ]; then
>+if [ ! -f ${BPF_FILE} ]; then
> 	echo "Missing xdp_dummy helper. Build bpf selftest first"

nit: I would improve the error message here to print  ${BPF_FILE}.
There are 3 more spots in the rest of this patch.
