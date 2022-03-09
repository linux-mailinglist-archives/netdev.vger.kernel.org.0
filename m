Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60EE4D3D83
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 00:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiCIXX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 18:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiCIXX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 18:23:58 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1784BC0843;
        Wed,  9 Mar 2022 15:22:57 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id p8so3571792pfh.8;
        Wed, 09 Mar 2022 15:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YNhHbb3+/uYO1XTMyhS6NJGke3f5J2bnOX9YxcnbDuc=;
        b=cahan3ZYoiUAJAROJFOfYf5chU/3gW/8kdVfTK/ioGDLkCBX+3IA0hbJnerCKWsqtr
         bgttukNmu8Zkohin84A3a2T9XZcBuFqt7G7lH9wDn38B39FEbPoaMVeO4LTyfcgy4Xzw
         FOkgwfsPoRMM3bq6vJrixyQFVNorr9X3mwLf94gHLjsim4NlpOl/LIOBakGSqnTXEPUq
         ntA5xHKRdTDzyBBpVQfnTXkPrvXuMnDtjvCpOsEnxzU2QznwadegDiBfjNbnuxjhPSul
         sW6MuCza13umEElGMdLpv2Ih2pcNxcxfUAR1HcOVJhQwYjjU3p1MaJTgmAV9KpokLzMg
         vSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YNhHbb3+/uYO1XTMyhS6NJGke3f5J2bnOX9YxcnbDuc=;
        b=tiwSdA9nHFg+tjqU5m4Gp8/CnlJH1A7XkOZNI3bfjtel7Bi6HIN7uFMy40KZRULfF8
         nhY0SoFo8RjxvOrA1i91D6TTVJRzhTbC5LY+S2O3tFcl+wzWHPi11QM4TVtX34LPTWlx
         PFJa/KHs1lNb/7vvzGYdZUWiKL9uALarh/+3USxQ++XGfY9qIfOrabJuR9iGtSTK5HkW
         mhq/HFJhtlnOVW9fmVwcXHsZbxJXVsHv1oVUO2pBG3IGhd8smdJSPQhJZOaIaRjRyDJw
         0kLPxUsrHden27reRlig+Xp5Urx70tMIpTaI2TZWUQ8YDyHI9ymZbcN3BLU+IfstJ4j0
         u51A==
X-Gm-Message-State: AOAM530/YYFtfl2unQvqEm0/TUo6Os9Yqz6GtGstXK5UT9UnIh/1M2Eh
        y5AK/aURQ6le6XBFgfk2xxLqK/RH3Ko=
X-Google-Smtp-Source: ABdhPJzVJ3LUoEGORQZI66OhbqTkVfhpQP6YchkzjnBjpke2jj/vDMgHZkdkXqoin+R/c0Q65g3xpQ==
X-Received: by 2002:a63:1d56:0:b0:380:437a:be68 with SMTP id d22-20020a631d56000000b00380437abe68mr1704459pgm.208.1646868177429;
        Wed, 09 Mar 2022 15:22:57 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::2:db4e])
        by smtp.gmail.com with ESMTPSA id s9-20020a056a00194900b004e1583f88a2sm4308332pfk.0.2022.03.09.15.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 15:22:57 -0800 (PST)
Date:   Wed, 9 Mar 2022 15:22:53 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/4] bpf: Fix net.core.bpf_jit_harden race
Message-ID: <20220309232253.v6oqev7jock7vm7i@ast-mbp.dhcp.thefacebook.com>
References: <20220309123321.2400262-1-houtao1@huawei.com>
 <20220309123321.2400262-4-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309123321.2400262-4-houtao1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 08:33:20PM +0800, Hou Tao wrote:
> It is the bpf_jit_harden counterpart to commit 60b58afc96c9 ("bpf: fix
> net.core.bpf_jit_enable race"). bpf_jit_harden will be tested twice
> for each subprog if there are subprogs in bpf program and constant
> blinding may increase the length of program, so when running
> "./test_progs -t subprogs" and toggling bpf_jit_harden between 0 and 2,
> jit_subprogs may fail because constant blinding increases the length
> of subprog instructions during extra passs.
> 
> So cache the value of bpf_jit_blinding_enabled() during program
> allocation, and use the cached value during constant blinding, subprog
> JITing and args tracking of tail call.

Looks like this patch alone is enough.
With race fixed. Patches 1 and 2 are no longer necessary, right?

