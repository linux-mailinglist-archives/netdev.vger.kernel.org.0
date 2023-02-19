Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E4B69C23E
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 21:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjBSUXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 15:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjBSUW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 15:22:59 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0CDB756;
        Sun, 19 Feb 2023 12:22:58 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id bj25so835619oib.7;
        Sun, 19 Feb 2023 12:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T/lG1r/TbyB2QAMQC7qmr8BereB2Nt3IrsNpg8phS4g=;
        b=jSmj+cXuN1LvCHr5ar1NNtxkiQcA//ACdciA3jS0KEuAHav3RyM6E6P1baFTXS8IYh
         kCwiDrkxl02LFFbLGXFqSnUy0OARTjumqeCTmW5sSE/QTXokCyBz8zcQlThqD52ELaTF
         Q6xBMECYEtLw3LbV+7h/0mUWz0FPx+MBcHH4ErzVtF0s+dZCdPtYgTJMvmEdyx0yOjfv
         Uq2OqBQ9iYWCkZfvQvstEuvtVyxhd8z+NaffEUhsS8CbTx70ktbGouZMuQpMWlFJovOe
         NLaMW9aGMHGVIIJTif9FyXOBWxR9qkwUx7zZ9hmQIgoroOv8+rK/qjGSufVjiuMRcyFb
         WZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/lG1r/TbyB2QAMQC7qmr8BereB2Nt3IrsNpg8phS4g=;
        b=50GIRgimzoYr7DTtSCyAfAkW4VwwxxCYDA/fX62Zy7VGq+VNr6h271FfJDHnvQE11r
         zwC0MbYqnXUeHOyvwIj0D9gre/qmSUCLUZ9Wjh/Ti8PS3ykTLwiYhR5ek1UbUrTCn+gb
         jr5VVXzav0/7aZ/zWfS459ri3OfaXtgRBn1OguSFjDP6qM0Hmcb85W9zigO30vFPYCbF
         Dd1iLQxNDcC5QqnSS+f+4/E+mUKUYdIjOF6YH1NGfy5PDdo7bA2Oq+rn3N3KKj9I0Ymn
         Q261/CPjGIa7Yrou5TaQyj9bSMHDmWf8ZRCY1e4WmFGgBKTVwHtukClv7Iao51kZxYSI
         swLA==
X-Gm-Message-State: AO0yUKWB2+iPVEnoGPpDJXI+HDl/yvqiJBpJnnhMQrYZYdVHbwoJVwsY
        MXHuxb46TTf/6s5//JyABSFR/FTfw6g=
X-Google-Smtp-Source: AK7set9nCvvp3LLgIWdut9vtnQO4cbDdcgUHBkWfxrycIxa7oIRLZo3EA4gc7Q2ZsbbCjtSgUO/RMg==
X-Received: by 2002:aca:2106:0:b0:378:94c4:a912 with SMTP id 6-20020aca2106000000b0037894c4a912mr3623918oiz.24.1676838178085;
        Sun, 19 Feb 2023 12:22:58 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:c829:c422:d5dc:95ba])
        by smtp.gmail.com with ESMTPSA id y21-20020a056830109500b0068bb73bd95esm4278400oto.58.2023.02.19.12.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 12:22:57 -0800 (PST)
Date:   Sun, 19 Feb 2023 12:22:56 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Yonghong Song <yhs@meta.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch net-next] sock_map: dump socket map id via diag
Message-ID: <Y/KFIBLicHQ+Am5R@pop-os.localdomain>
References: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
 <32ab89e1-84e9-75f1-18c1-81db9a40d0bb@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32ab89e1-84e9-75f1-18c1-81db9a40d0bb@meta.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 10:29:11PM -0800, Yonghong Song wrote:
> 
> 
> On 2/11/23 12:19 PM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > 
> > Currently there is no way to know which sockmap a socket has been added
> > to from outside, especially for that a socket can be added to multiple
> > sockmap's. We could dump this via socket diag, as shown below.
> > 
> > Sample output:
> > 
> >    # ./iproute2/misc/ss -tnaie --sockmap
> >    ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1
> > 
> >    # bpftool map
> >    1: sockmap  flags 0x0
> >    	key 4B  value 4B  max_entries 2  memlock 4096B
> > 	pids echo-sockmap(549)
> >    4: array  name pid_iter.rodata  flags 0x480
> > 	key 4B  value 4B  max_entries 1  memlock 4096B
> > 	btf_id 10  frozen
> > 	pids bpftool(624)
> > 
> > In the future, we could dump other sockmap related stats too, hence I
> > make it a nested attribute.
> 
> Have you considered to implement a sockmap iterator? This will be

I think you understand it wrong, I don't want to dump the map, please
double check the above requirement.

Thanks.
