Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BAA59EA9D
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiHWSMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiHWSL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:11:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5E359263;
        Tue, 23 Aug 2022 09:23:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id c24so12701529pgg.11;
        Tue, 23 Aug 2022 09:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=LjdOkoj/iIqWIrTcTlb26yqTsDM1G4uHJ+m78pSllzU=;
        b=fr83FdYT1XmOH6+SfbhdHVyHMBXYkO245C27ol8qF7gLxPEu/8SZmZ1re4dAba3aME
         1CZ/EVWvK706veHt6UZhjK4rN4KBLLn5L2u7i9q0/2BdRVOwky+dO57/yDlt47Af8QQt
         VbkRdGlhJoT+awNbm7dIpyj3Kmt/SoopgDaPDxidf2BEwCjrudAybwqqQ/V+XD+EU4Ad
         +GAVeROy3+szX2tL1CjBWLDeKR4Z3MWL8+F7YecgfdBhJ+lAhUwtH3M49EhSmob9ICr1
         OBpHBN74cqPAH87EfbASkI0bJ7LHN2TOFUPkzeMASULii/l/NScGzYf8ueKYQif2KHp/
         Lg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=LjdOkoj/iIqWIrTcTlb26yqTsDM1G4uHJ+m78pSllzU=;
        b=3P01GbRK+gH3CBBJXYkqARszAcdhYQ13ghKeuBwmO7ie3CIC4OgOSMK7jZKMVgP/XK
         0IKDAaO9+XZImA1JleejyNas+0J/t4QKbfy0KAiwEG3BeM5L92xpwlTWtjlmOLZv6xZp
         ///cTUmiMWlo8SU3wMumXXlZBEd4uKRtRT3B1mLCIx015ekCTxAWqdB1Bqs/oKIMf+Z1
         IH+2UUEneaWa95B/HJ2k+rfVw+KvaP1TVnMHtNWTCCyEtPEDBPKs5s1xhRPZkdsXiFwd
         cfc0ytEkFc6bGOtM1TNb/D0Yz39KTNegMJpH8O3kEvThD2t8n2WJcIowt9cwiD7+DGmP
         ILKQ==
X-Gm-Message-State: ACgBeo0MmdYYc/fkH82qwckgIwmTWh+JUo2/ai2XOkBVeENBRhwbO3EI
        1xxuMIsI/KwyiFXMBSsJcjfx8ojvIq8GCDvARMU=
X-Google-Smtp-Source: AA6agR5cnh+fT7bPQ6maMa1z26oLeVjVE2OHEmxmDptmHUD3BCrrvUhebXFBYlMd9GESyGOtQl3N5In/ByRqcaQ1eeM=
X-Received: by 2002:a63:2148:0:b0:427:17f6:7c05 with SMTP id
 s8-20020a632148000000b0042717f67c05mr21049767pgm.200.1661271794081; Tue, 23
 Aug 2022 09:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com>
 <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com>
 <CADxym3Yxq0k_W43kVjrofjNoUUag3qwmpRGLLAQL1Emot3irPQ@mail.gmail.com>
 <20220818165838.GM25951@gate.crashing.org> <CADxym3YEfSASDg9ppRKtZ16NLh_NhH253frd5LXZLGTObsVQ9g@mail.gmail.com>
 <20220819152157.GO25951@gate.crashing.org> <CADxym3Y-=6pRP=CunxRomfwXf58k0LyLm510WGtzsBnzjqdD4g@mail.gmail.com>
 <871qt86711.fsf@oldenburg.str.redhat.com>
In-Reply-To: <871qt86711.fsf@oldenburg.str.redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 24 Aug 2022 00:23:02 +0800
Message-ID: <CADxym3Z7WpPbX7VSZqVd+nVnbaO6HvxV7ak58TXBCqBqodU+Jg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        Nick Desaulniers <ndesaulniers@google.com>, kuba@kernel.org,
        miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Aug 22, 2022 at 4:01 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Menglong Dong:
>
> > /*
> >  * Used by functions that use '__builtin_return_address'. These function
> >  * don't want to be splited or made inline, which can make
> >  * the '__builtin_return_address' got unexpected address.
> >  */
> > #define __fix_address noinline __noclone
>
> You need something on the function *declaration* as well, to inhibit
> sibcalls.
>

I did some research on the 'sibcalls' you mentioned above. Feel like
It's a little similar to 'inline', and makes the callee use the same stack
frame with the caller, which obviously will influence the result of
'__builtin_return_address'.

Hmm......but I'm not able to find any attribute to disable this optimization.
Do you have any ideas?

Thanks!
Menglong Dong

> Thanks,
> Florian
>
