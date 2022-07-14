Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C754E57512F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbiGNO4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbiGNO4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:56:21 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E44558C6;
        Thu, 14 Jul 2022 07:56:20 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v16so2883011wrd.13;
        Thu, 14 Jul 2022 07:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YiFGeAkkoyUDBbqYS+lTvRX8RLtgLJYYOG6AuD0v2Sg=;
        b=XbZQ3LynpgAInXGE5CMF61nFeboY4yiYUQ0NkqwoJqHVEqvzl6AolAPurcpSMgDXo9
         oSHd6FhAQjTTa66NxBrKijiDGUz3Ij8a2eYY75tWHx9VZOxwvb/R7XYMYQp3DoHBQ405
         g0wXT8qcLic57Hf/pqER+BHOPoVeyUjPreaQFJHj9NsaO0lM/nd99Us1HK8rHDtUC5wX
         E9jHNnbV9Y7NNTxDXwm9i59DbrI+6juCKrTnWueDIM+sHKwj7BpOXJMgywrjruU6ukSG
         DhlGhSRvIRv06a196necui55od59V2tADH7KrmzfpkXzpnX2hzbDMCbKWibgzz4jfMjb
         XgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YiFGeAkkoyUDBbqYS+lTvRX8RLtgLJYYOG6AuD0v2Sg=;
        b=KZjhSy6ot/6I4Gh44AUxiaj1xvqI/JtYwQ7kABO2KgsX90idXadMr07OyEpe0FOg27
         glG9VeJH5TaQr+OG0No+ud5DVuIhJtkaQtb+mTbGJxuMPllncdFVGiPWmwRaotcD96Dw
         /4yF4Ti3NvmQLHj2IW5+bmU3RjTOdbbYyHk65hfcmpqpzwqqnvdfsqPNZm7Yh34qrG7r
         j2YgBnxaK3IF3VxntrszFMrkGsKuFTi4CJR1I2hMcMBmsKBUsqE2eyBgdpnRsD5IB5Gi
         gId0nyWM/MLC35sapyMEBAUq0kh1Oct9LdVVHPHA4DVtro89898ou0JgwLnjcnY0gMsg
         ivMg==
X-Gm-Message-State: AJIora+f9pgZ32nzJ/FW1gGvqqxydC5CmOoA0jxj/FptUpWKNaf4ZEzL
        4kcmDGS048phqb587VppoUjahO7vGAGTGjjR9MY=
X-Google-Smtp-Source: AGRyM1tlg/h0WsBI56pr2Kq4o7tacTNpaW6a2zJYr+sERc+hfUkU9zvYj2NMABMiSADbXcgHIbhOq5d6a3JKJORVQB0=
X-Received: by 2002:a5d:4f0b:0:b0:21d:705c:caf with SMTP id
 c11-20020a5d4f0b000000b0021d705c0cafmr8782265wru.55.1657810578734; Thu, 14
 Jul 2022 07:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <CAM0EoM=Pz_EWHsWzVZkZfojoRyUgLPVhGRHq6aGVhdcLC2YvHw@mail.gmail.com>
In-Reply-To: <CAM0EoM=Pz_EWHsWzVZkZfojoRyUgLPVhGRHq6aGVhdcLC2YvHw@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 14 Jul 2022 07:56:05 -0700
Message-ID: <CAA93jw7SsxOqOE8YJOLikkzSsNQuBqdkGLreoD-DDgQM4n-9sg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling capabilities
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
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

In general I feel a programmable packet pacing approach is the right
way forward for the internet as a whole.

It lends itself more easily and accurately to offloading in an age
where it is difficult to do anything sane within a ms on the host
cpu, especially in virtualized environments, in the enormous dynamic
range of kbits/ms to gbits/ms between host an potential recipient [1]

So considerations about what is easier to offload moving forward vs
central cpu costs should be in this conversation.

[1] I'm kind of on a campaign to get people to stop thinking about
mbits/sec and about intervals well below human perception, thus,
gbits/ms - or packets/ns!
