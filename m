Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCE5555258
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 19:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359294AbiFVR0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 13:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiFVR0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 13:26:09 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DB3289AF;
        Wed, 22 Jun 2022 10:26:08 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r7-20020a1c4407000000b003a02cc49774so67648wma.1;
        Wed, 22 Jun 2022 10:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gx8MHjBKLUDJNFsntdrDoHFHXszbdB+MLB7TwASONiA=;
        b=CeIyY61ktnfWz5ZbciV0WOC5VFw8HGSJ+5WUxqk65+0qibR3nxZpsCHGt+0uY/W6YG
         aVCLgfoBrS8qPA0lAjeyCnF4l+Dn63W6qPg9e/RQMPZ1xno+OFhTG1z1USQYjhZK0A84
         yFOIrl6+lT2aSQnuKCZB/3ZHaBCzPi/7PZFq7bS+/81ZQv9mZ2az7KE1gTk6RbfO5xpb
         WHjx2mDimZ9lV3WsC+ofhxJ6OuKamj+DjaIwQWb9YBP2FaszDDKfsJm1Muhux9Wto2Ww
         heCbY7CG1/C4a8UUfKLjRsWkiQn17wuFNQo5FPa5Z2MSndckB9DnXZVkLoA4/ddOX43c
         YgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gx8MHjBKLUDJNFsntdrDoHFHXszbdB+MLB7TwASONiA=;
        b=OcGXQZOWxVz1Z7rcYGP0AvmmyKltykzMPTk29ep1Ze+6HK/LMoyUaA/EwKjuhNyhJQ
         BYnUsUSMZDG9metb/OYUTPyEPa6FM9Qaklwc6W9917sApZhJW0u3nMbKOfGwKz2ddZsF
         q5Zqeg2Q0fAVLcQCtisYBKPaAmNBwIgqXT90DWcGV+S5gXxvc+BraGs7meB4jhgHC5Bc
         53IkFM3TQRt4NkP2TQ2Rx/rk5XpR+LeFq/mfjpltZdkSxfCHiojArtQg3gvp17wwi3sa
         5CTFJkIA4f4R3qFvXbAmUfNV1DQFJUAeAjZPT3VOTzPaW7zhWLhje5pyDiOTRn1vypxD
         OuUQ==
X-Gm-Message-State: AOAM5325dvCXjpT0t9GLZMqLU8e2Y0OZ0uySq3kAcDR6MXi2LAm+QhY1
        b3lTHvQ4eePPnDUXTlQL4FzF2Vsm5So=
X-Google-Smtp-Source: ABdhPJw92zzWDOf4nX5co4h+yOaYfpvSE1lqWrAWyMnVuVIbDMJBNV5Z9nVcUfk7df9Z0MwcebHBGQ==
X-Received: by 2002:a05:600c:2194:b0:39c:419c:1a24 with SMTP id e20-20020a05600c219400b0039c419c1a24mr47332513wme.186.1655918767173;
        Wed, 22 Jun 2022 10:26:07 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id t5-20020a05600001c500b0020d106c0386sm11482007wrx.89.2022.06.22.10.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 10:26:06 -0700 (PDT)
Date:   Wed, 22 Jun 2022 18:26:04 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang
 support")
Message-ID: <YrNQrPNF/XfriP99@debian>
References: <YrLtpixBqWDmZT/V@debian>
 <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
 <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X>
 <CAHk-=wjTS9OJzggD8=tqtj0DoRCKhjjhpYWoB=bPQAv3QMa+eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjTS9OJzggD8=tqtj0DoRCKhjjhpYWoB=bPQAv3QMa+eA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:21:09AM -0500, Linus Torvalds wrote:
> On Wed, Jun 22, 2022 at 10:02 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Right, we are working on a statically linked and optimized build of LLVM
> > that people can use similar to the GCC builds provided on kernel.org,
> > which should make the compile time problem not as bad as well as making
> > it easier for developers to get access to a recent version of clang with
> > all the fixes and improvements that we have made in upstream LLVM.
> 
> So I'm on the road, and will try to see how well I can do that
> allmodconfig build on my poor laptop and see what else goes wrong for
> now.

Tried it after applying your patch. There was no build failure, but some warnings:

fs/reiserfs/reiserfs.o: warning: objtool: leaf_copy_items_entirely+0x7fd: stack state mismatch: cfa1=4+240 cfa2=4+232
arch/x86/kvm/kvm.o: warning: objtool: emulator_cmpxchg_emulated+0x705: call to __ubsan_handle_load_invalid_value() with UACCESS enabled
arch/x86/kvm/kvm.o: warning: objtool: paging64_update_accessed_dirty_bits+0x39e: call to __ubsan_handle_load_invalid_value() with UACCESS enabled
arch/x86/kvm/kvm.o: warning: objtool: paging32_update_accessed_dirty_bits+0x390: call to __ubsan_handle_load_invalid_value() with UACCESS enabled
arch/x86/kvm/kvm.o: warning: objtool: ept_update_accessed_dirty_bits+0x43f: call to __ubsan_handle_load_invalid_value() with UACCESS enabled
drivers/video/fbdev/smscufx.o: warning: objtool: ufx_ops_write() falls through to next function ufx_ops_setcolreg()
drivers/video/fbdev/udlfb.o: warning: objtool: dlfb_ops_write() falls through to next function dlfb_ops_setcolreg()
drivers/soc/qcom/qcom_rpmh.o: warning: objtool: rpmh_rsc_write_ctrl_data() falls through to next function trace_raw_output_rpmh_tx_done()
drivers/scsi/mpi3mr/mpi3mr.o: warning: objtool: mpi3mr_op_request_post() falls through to next function mpi3mr_check_rh_fault_ioc()
drivers/gpu/drm/radeon/radeon.o: warning: objtool: sumo_dpm_set_power_state() falls through to next function sumo_dpm_post_set_power_state()
drivers/net/ethernet/wiznet/w5100.o: warning: objtool: w5100_tx_skb() falls through to next function w5100_get_drvinfo()
drivers/net/ethernet/wiznet/w5100.o: warning: objtool: w5100_rx_skb() falls through to next function w5100_mmio_probe()
vmlinux.o: warning: objtool: __startup_64() falls through to next function startup_64_setup_env()
vmlinux.o: warning: objtool: sync_regs+0x24: call to memcpy() leaves .noinstr.text section
vmlinux.o: warning: objtool: vc_switch_off_ist+0xbe: call to memcpy() leaves .noinstr.text section
vmlinux.o: warning: objtool: fixup_bad_iret+0x36: call to memset() leaves .noinstr.text section
vmlinux.o: warning: objtool: __sev_get_ghcb+0xa0: call to memcpy() leaves .noinstr.text section
vmlinux.o: warning: objtool: __sev_put_ghcb+0x35: call to memcpy() leaves .noinstr.text section

The build took 16 minutes 6 seconds on the build machines in my office (Codethink).


--
Regards
Sudip
