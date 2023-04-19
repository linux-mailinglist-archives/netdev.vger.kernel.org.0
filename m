Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC636E7505
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjDSI10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjDSI1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:27:24 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8586E5FFB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:27:22 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id kt6so41369535ejb.0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681892841; x=1684484841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JaX87YPsYXJs9yetXS9/VPDsgjTkVIsThQCtlqJLjKI=;
        b=ojIVeou1T9txfO/m2H/MS+ChlMKIBqR1L3oe4TTFZdG8szGqx3fE1lxn6EwuaoiajA
         VFV3ALhhhH+c3Kq+sYdqu3aSY8xFurhgwbsgZcrzccwrvznu7gWshGxyO05QFsZnSDCo
         FASP5q6KatAPgjsabguhCLZUp4yPP1w7R/Ycy1Baydt4c6s7dJmCZpzT5S0nhG2vHglK
         sqfx1sPKhFtdsZ8CNLZaHHBBt+BgMj4EOIY1on2NlOaD5oEZqF+BGuabV7nMh3XpQa7g
         WS7xkKIjMHWpj+BmBDgJgp0SIzcSQeE6HYuFWe5pYbmh0IQIsaGylp3rAmBqbzPcwhZI
         afPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681892841; x=1684484841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JaX87YPsYXJs9yetXS9/VPDsgjTkVIsThQCtlqJLjKI=;
        b=QEfd7LuzPpESlgsnGbFjfDd260r0ERDtf+/fK2X62r05X06bvDLPaNR21x8rjqM1Pd
         AAipi+aV1D/Jmsy8mcOFTfXYDQd6gTynZxdLd2Xro3nqqK68Wz8ASflGxaKicFuTkv+W
         g305U3h4SaakhC0XNipgT0+OtzkDLndia3q8usATXCl4RJg6tsANdL8ikieaoXi8u6PE
         ME2cEhDEiXvHm9PsoLVO8yRbKij2T9ASz+kweaaAAhTmd/jYuw2XdHNdRh4dmCwpGyhl
         J5Wm2PjfdYmAxTGPDar+6E4SZsO7XiuVhQupQdkNSj2TlxeMVsUjlQNrogbrMjVzH4Tu
         IOmQ==
X-Gm-Message-State: AAQBX9c+LFtglqnhBs+9DMeE1GhfT9Mz4xojvb3mBhlqGOD7fjmOheOi
        yvkEQISb65SsuVO7c0YEaaAjhA==
X-Google-Smtp-Source: AKy350ZzTOQ/09tmhw5xoXnB7H32TRrIwfceh3BliiWG7NcpRv7Pqhg0rDMUIp47Oc/gsFG1Ynm/Fw==
X-Received: by 2002:a17:906:f6c3:b0:94f:17b7:c4b9 with SMTP id jo3-20020a170906f6c300b0094f17b7c4b9mr13707037ejb.42.1681892840852;
        Wed, 19 Apr 2023 01:27:20 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:62f5:eb43:f726:5fee? ([2a02:810d:15c0:828:62f5:eb43:f726:5fee])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090625d900b0094e62aa8bcesm9028400ejb.29.2023.04.19.01.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 01:27:20 -0700 (PDT)
Message-ID: <3fdcb223-14c0-dd51-bbb8-d6f193482e87@linaro.org>
Date:   Wed, 19 Apr 2023 10:27:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] net: nfc: nci: fix for UBSAN: shift-out-of-bounds in
 nci_activate_target
Content-Language: en-US
To:     Anup Sharma <anupnewsmail@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linma@zju.edu.cn, dvyukov@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ZD9A5Krm+ZoFEFWZ@yoga>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZD9A5Krm+ZoFEFWZ@yoga>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 03:16, Anup Sharma wrote:
> syzbot found  UBSAN: shift-out-of-bounds in nci_activate_target [1],
> when nci_target->supported_protocols is bigger than UNIT_MAX,
> where supported_protocols is unsigned 32-bit interger type.
> 
> 32 is the maximum allowed for supported_protocols. Added a check
> for it. 
> 
> [1] UBSAN: shift-out-of-bounds in net/nfc/nci/core.c:912:45
> shift exponent 4294967071 is too large for 32-bit type 'int'
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x136/0x150 lib/dump_stack.c:106
>  ubsan_epilogue lib/ubsan.c:217 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x221/0x5a0 lib/ubsan.c:387
>  nci_activate_target.cold+0x1a/0x1f net/nfc/nci/core.c:912
>  nfc_activate_target+0x1f8/0x4c0 net/nfc/core.c:420
>  nfc_genl_activate_target+0x1f3/0x290 net/nfc/netlink.c:900
>  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
> 
> Reported-by: syzbot+0839b78e119aae1fec78@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=19cf2724120ef8c51c8d2566df0cc34617188433
> 
> Signed-off-by: anupsharma <anupnewsmail@gmail.com>

Also, no blank lines between tags.

Best regards,
Krzysztof

