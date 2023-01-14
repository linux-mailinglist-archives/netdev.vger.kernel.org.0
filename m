Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E02966AA07
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 09:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjANIEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 03:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjANIEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 03:04:40 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D012104
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 00:04:38 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id r9so166843wrw.4
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 00:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lHZQ2hGE5tQqLLlrk57f+PWvOdohWM9w0ISXr/YQTJc=;
        b=Rp96LEhjTK+z5jwJsA+7KkIDJBpo7Do/IKJP03oTAFtrtY8xnGKoGXUuBe0LYIfzx6
         uaDMoKOdIXsYYDAjBP07hdcKUHig+9kHCRG5+LIs+cEHppviJlc0jcvyRvvx2MMBDjzb
         DAdX9y8dlIBiHijmmjM0n0NzeqSMbsSzln1MvRROg/eevrM1wfa61BXEiCoBizEDU9tX
         T14deYfFEDgaLzZMnZxtZVt78Lxz/Ii4+ww6HAFIr0FUbj/U1oAHNNAFvcz/uGf/X9YJ
         r8FqL0sMeF9asXJo19GjPmARdoX3JKgAUhxYpdV9qKEO2Ax60QP6Dwq31GkmIwiuaVGI
         +EPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lHZQ2hGE5tQqLLlrk57f+PWvOdohWM9w0ISXr/YQTJc=;
        b=IlNkSYsjApKAfD5yhEg6mG4aACZJ9tzJ1TRzsRQs2iU0ewJOA/O991pHWl0a7WRYHY
         35t7yvAcyI2ngOZFFPc7Tf+uytth+0vw8ed8kkp64BA6sxAe9SPDlTFWG4YxtUoWeIaW
         bZMxHPE4/ewZA9MMTqr89qNgs2el1N7HCg1k/vSSNImKIkRL5GZBZttIFflr10kx8Awm
         MxklTcEIc/XdWXA/uaHIdvw6x1NnFrUN8praVTj4YGlDVa/7wATS03hrH0xAif+/IT72
         ayDPMxwdU8Nqje4u7FW9oUh4xVRFxATkm+YUIL98sL81a0w8yvN6MTi4urenBzMMLtme
         iqZA==
X-Gm-Message-State: AFqh2kobZgtF2ZXRfXMEuQvJ8/Qu8VBxm90ZAPq/BnejXSiaM6Q2Yex9
        IrZmFZ1z7yANSB2vU8aXbIQ=
X-Google-Smtp-Source: AMrXdXt0naN/ojcZur1ITIamzJ2KdLIy1fmO7i0+dcJvZ+yKx9Bw0fAVWBylcu5iiuv5oMLQvZsKGg==
X-Received: by 2002:a5d:488b:0:b0:242:5563:c3b with SMTP id g11-20020a5d488b000000b0024255630c3bmr51055844wrq.59.1673683477382;
        Sat, 14 Jan 2023 00:04:37 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w4-20020a5d4b44000000b002366dd0e030sm20571606wrs.68.2023.01.14.00.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 00:04:36 -0800 (PST)
Date:   Sat, 14 Jan 2023 11:04:30 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, Jakub Sitnicki <jakub@cloudflare.com>,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Subject: Re: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots
 when cloning a listener
Message-ID: <202301141018.w4fQc4gd-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113-sockmap-fix-v1-1-d3cad092ee10@cloudflare.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Sitnicki/bpf-sockmap-Check-for-any-of-tcp_bpf_prots-when-cloning-a-listener/20230113-230728
base:   e7895f017b79410bf4591396a733b876dc1e0e9d
patch link:    https://lore.kernel.org/r/20230113-sockmap-fix-v1-1-d3cad092ee10%40cloudflare.com
patch subject: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
config: i386-randconfig-m021
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>

smatch warnings:
net/ipv4/tcp_bpf.c:644 tcp_bpf_clone() error: buffer overflow 'tcp_bpf_prots' 2 <= 2

vim +/tcp_bpf_prots +644 net/ipv4/tcp_bpf.c

604326b41a6fb9 Daniel Borkmann 2018-10-13  634  
e80251555f0bef Jakub Sitnicki  2020-02-18  635  /* If a child got cloned from a listening socket that had tcp_bpf
e80251555f0bef Jakub Sitnicki  2020-02-18  636   * protocol callbacks installed, we need to restore the callbacks to
e80251555f0bef Jakub Sitnicki  2020-02-18  637   * the default ones because the child does not inherit the psock state
e80251555f0bef Jakub Sitnicki  2020-02-18  638   * that tcp_bpf callbacks expect.
e80251555f0bef Jakub Sitnicki  2020-02-18  639   */
e80251555f0bef Jakub Sitnicki  2020-02-18  640  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
e80251555f0bef Jakub Sitnicki  2020-02-18  641  {
e80251555f0bef Jakub Sitnicki  2020-02-18  642  	struct proto *prot = newsk->sk_prot;
e80251555f0bef Jakub Sitnicki  2020-02-18  643  
c2e74657613125 Jakub Sitnicki  2023-01-13 @644  	if (tcp_bpf_prots[0] <= prot && prot < tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)])
                                                                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
What?  Also I suspect this might cause a compile error for Clang builds.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

