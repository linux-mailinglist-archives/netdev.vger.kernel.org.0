Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D2E5845AD
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiG1SMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiG1SMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:12:42 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6693633E34
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:12:37 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a89so3159938edf.5
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=dM/Vi43aVzMV0NHy7B8BOmd94SpUKEsA7t0X1H+vJTk=;
        b=b+2nn8XXC/HdHTqy5fDGWJwa+Ny1ItxxclD1M+tZy0TlCKqOGV+/UxbQs6QU+ZIIXP
         8BUHNkO7jZkuypDDr6tPAXomQcRJ1QK8iuXZJayw2nAK+n0GT2kzGUkNgHpzoZ4ad544
         VD0ZI7QKJ0utn93x13nOdARjg8eqO8CZ9LlCb0ZXLuu1jj6hewT+QMwuRc/YMNLDLvGJ
         fslZp9edz1vse4M1x0BdMA8dMnlCgGq2u555c/YJRDhGE0buallUoQcA025yY5cTBSk8
         ju4pp5XJD12EPuXdZLvtP0UqjSYx4LQrOE0rXEPpLZ9UazMdQ4SXFv8bCpy9IdPIRTEn
         jPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=dM/Vi43aVzMV0NHy7B8BOmd94SpUKEsA7t0X1H+vJTk=;
        b=PVvGS4iSqqFS5Wtgv6mPBNeNsM5ecWSBCQw2MrZcaRqskotIjNCYFzJDTGIkEUjSXX
         05KRuEtd2LNBGjmFzhgk9nTUtpH0k2RWTAskPc9qANmBLg+GmBrVlzI/xANbU+GJTker
         +Cne/veObCZm8ZmIkKCdU7DNH5XrVrhN6V1QWq37TfwB07O1Qcb6Hm0I1yeKHWCSpAnJ
         iEdjTEmDG2N2uRBXa3WySQ+g/M+4Khrszf6xsw5WDl+RgIHBgLOPNR2icqrGweob85X+
         nUF/ny351ih1E+i41OoVm9pdIQVJ1T5slTrXx0wgY9DhTGkyZP9wPRkIKOVVm/x3YysL
         +brg==
X-Gm-Message-State: AJIora+AipAmyPEVdPz0NzSlGUiiSxSSS0LY9Bh1X0z2cwNHJww4v5IR
        tXNI3o4DPlSCrohmOOhe8OwUT1Vp/14=
X-Google-Smtp-Source: AGRyM1v3fuojLcuxa2awlYpZpRXSDyGKMXvNO1khNeUx0BGkIQrqByYOUG7GikyfzM+Zo4+ks2p3PQ==
X-Received: by 2002:a05:6402:4cc:b0:43c:cd5c:dcfb with SMTP id n12-20020a05640204cc00b0043ccd5cdcfbmr146708edw.277.1659031955832;
        Thu, 28 Jul 2022 11:12:35 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id sy13-20020a1709076f0d00b00722d5b26ecesm653096ejc.205.2022.07.28.11.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 11:12:35 -0700 (PDT)
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
 <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
 <20220727201034.3a9d7c64@kernel.org>
 <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
 <20220728092008.2117846e@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <8bfec647-1516-c738-5977-059448e35619@gmail.com>
Date:   Thu, 28 Jul 2022 19:12:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220728092008.2117846e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2022 17:20, Jakub Kicinski wrote:
> It's set thru
> 
>  devlink port function set DEV/PORT_INDEX hw_addr ADDR
> 
> "port functions" is a weird object representing something 
> in Mellanox FW. Hopefully it makes more sense to you than
> it does to me.
Hmm that does look weird, looks like it acts on a PCI device
 (DEV is a PCI address) and then I'm not sure what PORT_INDEX
 is meant to mean (the man page doesn't describe it at all).
 Possibly it doesn't have semantics as such and is just a
 synthetic index into a list of ports…
I can't say it makes sense to me either :shrug:

We did take a look at what nfp does, as well; they use the
 old .ndo_set_vf_mac(), but they appear to support it both on
 the PF and on the VF reprs — meaning that (AFAICT) it allows
 to set the MAC address of VF 0 through the repr for VF 1.
(There is no check that I can see in nfp_app_set_vf_mac()
 that the value of `int vf` matches the caller.)

Our (SN1000) approach to the problem of configuring 'remote'
 functions (VFs in VMs, PFs on the embedded SoC) is to use
 representors for them all (VF reps as added in this & prev
 series, PF reps coming in the future.  Similarly, if we
 were ever to add Subfunctions, each SF would have a
 corresponding SF representor that would work in much the
 same way as VF reps).  At which point you should always be
 able to configure an object through its associated rep,
 and there should never be a need for an 'index' parameter
 (be that 'VF index' or 'port index').
While .ndo_set_mac_address() might be the Wrong Thing (if
 we want to be able to set VF and VF-rep addresses
 independently to different things), the Right Thing ought
 to have the same signature (i.e. just taking a netdev and
 a hwaddr).  Devlink seems to me like a needless
 complication here.

Anyway, since the proper direction is unclear, I'll respin
 the series without patches 10-13 in the hope of getting
 the rest of it in before the merge window.

-ed
