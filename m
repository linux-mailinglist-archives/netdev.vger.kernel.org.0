Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB70151DF65
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 20:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380836AbiEFTAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiEFTAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:00:32 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A66A562D0;
        Fri,  6 May 2022 11:56:48 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id 126so6547071qkm.4;
        Fri, 06 May 2022 11:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7TVfcjFfQqNMO3KwSJPN5gTh1q1K60Aibk0I6QPU0fk=;
        b=G/y1pP0aKorkzYMNAluYjNDyIvdlykpw7xhpiCa5/aXDC0MXPV8Lmrb/919f5/a95g
         ayGCig/Ij5XfwUUcUZATtVztxZSTg/vEdIOTln/Ts1fXs3OmUVndiMzJzw6MpCMej4gC
         /rE/RtX7OIfEbbsFQxmges976pP4xA/LXXkA6RtovILG+KEHZPKuezS7DVx3DAcV/u6w
         f4kn9jvp8oihqKT2RsahwOksgSksEuje2akv765D3pXE7lFJLicsJOZsCaQi4GBoRpUO
         NqYaeSYxlokIgWk8AptZzfNLXKwXaDkxtG3zl/hXBUqw1hHs2vXzk1GnL5PR9CZxBKAh
         YIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7TVfcjFfQqNMO3KwSJPN5gTh1q1K60Aibk0I6QPU0fk=;
        b=ZdaWW1uBL7MtUgtUoPH78Pk9t+Np6AV4MdEUKtwYb++DO5TQqa0Q8871RJZ7DBXusF
         CTFjw5EWmZN1sA7QVZF0itKiwjb3UIabU6UHEgGIOowyd+b+MM6GMxfFS8ck8lHdSvYN
         3dUqKceL5M2fY04HlYKH94pAA2RHBo51ADXrhRUvMY8Bf2Xi8v6foA33Y8Yaj4HAkRPH
         O1iE7DZyAFSW2YIOpn4rkGfpde+vkxw7SOhsENAl6nwMOn+lBcyI132toqEDQ+dvN9cJ
         dtpuUP0sVef7MN0JQkeBoTNKSjDIkfhw8csEYuPovqKnUTrUBBEGTrJzDiqI9te7Tzjo
         ieEA==
X-Gm-Message-State: AOAM5337cE+c9GVhJxVUJcDbI83Vyxj1BkqreYBSlpJHeMtchec7Aijr
        +QaJSygmRwsYuSZi0SPAfw==
X-Google-Smtp-Source: ABdhPJz8KQlQb51Q5VdS8/meaV8Za7TTMu6C9b/O648T2dLxDu7QSWM/KHlPnbxW7M6jvnlh0z3zqg==
X-Received: by 2002:a05:620a:4708:b0:6a0:42da:a46f with SMTP id bs8-20020a05620a470800b006a042daa46fmr3331169qkb.469.1651863406898;
        Fri, 06 May 2022 11:56:46 -0700 (PDT)
Received: from bytedance (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id l12-20020ac8148c000000b002f39b99f67dsm2919332qtj.23.2022.05.06.11.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 11:56:46 -0700 (PDT)
Date:   Fri, 6 May 2022 11:56:41 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     kerneljasonxing@gmail.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>
Subject: Re: [PATCH net-next] net: use the %px format to display sock
Message-ID: <20220506185641.GA2289@bytedance>
References: <20220505130826.40914-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505130826.40914-1-kerneljasonxing@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Thu, May 05, 2022 at 09:08:26PM +0800, kerneljasonxing@gmail.com wrote:
> -		pr_err("Attempt to release TCP socket in state %d %p\n",
> +		pr_err("Attempt to release TCP socket in state %d %px\n",

I think we cannot use %px here for security reasons?  checkpatch is also
warning about it:

WARNING: Using vsprintf specifier '%px' potentially exposes the kernel memory layout, if you don't really need the address please consider using '%p'.
#21: FILE: net/ipv4/af_inet.c:142:
+		pr_err("Attempt to release TCP socket in state %d %px\n",
 		       sk->sk_state, sk);

Thanks,
Peilin Ye

