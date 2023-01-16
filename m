Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4667D66BC91
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjAPLNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjAPLNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:13:17 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D011C33B
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:13:15 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d2so6998411wrp.8
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nmj5GlePH1m1v4jjTuyZYeEMUXxnTC/9kTjujEoJMs0=;
        b=d6H8HAsNEMGyEdrbdLq7DiHkcwqesRiEn5ysZDwwRCpvMePhphV208q/GxUktf/l/a
         pAPAJpBi2EYQtR/teF0VrCWW/JVIkblu4eZ4CW7kcosBFsUTIcRYkOsSk1JrX6J/Kjdw
         Q6ZzBEdHw6SeVbjiHHSS17E4NfTaYUesBXXD4+xnuiGEYa2FUka7vgBLzgjeUfkSDEjO
         INV7b1K9dn6XnyCJIKQjc1auZSWGNSbYNRCluxTRjLkgvLf549SAR/61/Mtn5sd1/kT0
         M6ivyuZAHGo54jRlaOHwx+HULdbHGvNcujBWXQnceg4hB2wcTgp5/fTRRDzHD1dJnUls
         CqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmj5GlePH1m1v4jjTuyZYeEMUXxnTC/9kTjujEoJMs0=;
        b=wXYjzdeMcJQoYKWpZsDMRuH6vCIyJJuLfb/0V1wazfSWwXyPDAqciPRFRmf8nyUcqM
         Zyatl2h+waqlqYop6IDrdlmO+3v0dym0rOS/2J2Q8v1FGpthma7PylhM3eBy5SyyAGo7
         x8otW2izIzsgG8bXXIP9Tm5x0dW0XKj1Hqg9HTlqR6WDlePBYnJPfpfPn8eK6KEKHl1k
         +5c0WXlkpxRqAnXPIMkWY6lbIlvol73xcUuRrQKxzokH5i3Yq5tI/zM0Hbqq7d2A2xc5
         YFmSp2BnuE2Zv50gDUlSy1QXK4pAzPhOvJZ6YmzfPvoX8DyHynparkoNsncH7XXOq4I/
         ld9A==
X-Gm-Message-State: AFqh2krXO4RpAZsiY5Z/1JKXBx3wCqAkTEdbpEubbaQQUgXHPH/4h8O5
        ciRaOCwctD0L9ddPlNssI/I=
X-Google-Smtp-Source: AMrXdXuKN4rVrN2BmOdoxS7iAkhLVDXr8ESjJSdhLJh8rGn/DGc6pF+Xk2X4luvYiYo481YVXrNvsw==
X-Received: by 2002:adf:e911:0:b0:2bd:da56:230c with SMTP id f17-20020adfe911000000b002bdda56230cmr10385772wrm.40.1673867593953;
        Mon, 16 Jan 2023 03:13:13 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l1-20020adfe9c1000000b00289bdda07b7sm25392040wrn.92.2023.01.16.03.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 03:13:13 -0800 (PST)
Date:   Mon, 16 Jan 2023 14:13:10 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     oe-kbuild@lists.linux.dev, netdev@vger.kernel.org, lkp@intel.com,
        oe-kbuild-all@lists.linux.dev, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Subject: Re: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots
 when cloning a listener
Message-ID: <Y8UxRmxdqGv92Szw@kadam>
References: <20230113-sockmap-fix-v1-1-d3cad092ee10@cloudflare.com>
 <202301141018.w4fQc4gd-lkp@intel.com>
 <87sfgayeg9.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfgayeg9.fsf@cloudflare.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 11:09:02AM +0100, Jakub Sitnicki wrote:
> Hi Dan,
> 
> On Sat, Jan 14, 2023 at 11:04 AM +03, Dan Carpenter wrote:
> > Hi Jakub,
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Sitnicki/bpf-sockmap-Check-for-any-of-tcp_bpf_prots-when-cloning-a-listener/20230113-230728
> > base:   e7895f017b79410bf4591396a733b876dc1e0e9d
> > patch link:    https://lore.kernel.org/r/20230113-sockmap-fix-v1-1-d3cad092ee10%40cloudflare.com
> > patch subject: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
> > config: i386-randconfig-m021
> > compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> >
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> >
> > smatch warnings:
> > net/ipv4/tcp_bpf.c:644 tcp_bpf_clone() error: buffer overflow 'tcp_bpf_prots' 2 <= 2
> >
> > vim +/tcp_bpf_prots +644 net/ipv4/tcp_bpf.c
> >
> > 604326b41a6fb9 Daniel Borkmann 2018-10-13  634  
> > e80251555f0bef Jakub Sitnicki  2020-02-18  635  /* If a child got cloned from a listening socket that had tcp_bpf
> > e80251555f0bef Jakub Sitnicki  2020-02-18  636   * protocol callbacks installed, we need to restore the callbacks to
> > e80251555f0bef Jakub Sitnicki  2020-02-18  637   * the default ones because the child does not inherit the psock state
> > e80251555f0bef Jakub Sitnicki  2020-02-18  638   * that tcp_bpf callbacks expect.
> > e80251555f0bef Jakub Sitnicki  2020-02-18  639   */
> > e80251555f0bef Jakub Sitnicki  2020-02-18  640  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
> > e80251555f0bef Jakub Sitnicki  2020-02-18  641  {
> > e80251555f0bef Jakub Sitnicki  2020-02-18  642  	struct proto *prot = newsk->sk_prot;
> > e80251555f0bef Jakub Sitnicki  2020-02-18  643  
> > c2e74657613125 Jakub Sitnicki  2023-01-13 @644  	if (tcp_bpf_prots[0] <= prot && prot < tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)])
> >                                                                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > What?  Also I suspect this might cause a compile error for Clang builds.
> 
> Can't say I see a problem B-)
> 
> tcp_bpf_prots is a 2D array:
> 
> static struct proto tcp_bpf_prots[TCP_BPF_NUM_PROTS][TCP_BPF_NUM_CFGS];
> 
> ... so tcp_bpf_prots[0] is the base address of the first array, while
> tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)] is the base address of the
> array one past the last one.
> 
> Smatch doesn't seem to graps the 2D array concept here. We can make it
> happy by being explicit but harder on the eyes:
> 
> 	if (&tcp_bpf_prots[0][0] <= prot && prot < &tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)][0])
> 		newsk->sk_prot = sk->sk_prot_creator;

Huh.  I can silence this false positive in Smatch...  It never even
occured to me that this was a two dimensional array (I only have the
information in the email).

> 
> Clang can do pointer arithmetic on 2D arrays just fine :-)

Heh.  I must have an older version of Clang.

  CC      net/ipv4/tcp_bpf.o
net/ipv4/tcp_bpf.c:644:41: warning: array index 2 is past the end of the array (that has type 'struct proto[2][4]') [-Warray-bounds]
        if (tcp_bpf_prots[0] <= prot && prot < tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)])
                                               ^             ~~~~~~~~~~~~~~~~~~~~~~~~~
net/ipv4/tcp_bpf.c:544:1: note: array 'tcp_bpf_prots' declared here
static struct proto tcp_bpf_prots[TCP_BPF_NUM_PROTS][TCP_BPF_NUM_CFGS];
^
1 warning generated.

regards,
dan carpetner
