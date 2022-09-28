Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365105EE831
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiI1VS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbiI1VSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:18:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7476C140E4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:14:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bq9so21664224wrb.4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=fQQwmz593NiF2fSZtXm+WsePY6yvWZaiZJYMVZxRURY=;
        b=cp8LkHtGGVvRHvW1+waHcwBWKhYXGE5lLL6NYiV4+kNdO/JzL99EaQ47mVM8cIMMM6
         D0ca0ouIbmYiZVztG1h6D1HTvybvKKnUKQPED2R2QELI2tB/LRT/8tlNFWtjJ5P5x+no
         cN+/lVxsAU6du+ipRs7mzuO59wve3l9rHGFhAuP3UqY487IIEgOPjNQLiwqeSS0ODLXd
         KegQXLLrysTTLq8N332HjLcKIwV+iG/FdREZflKSGH9IJ4um/GHleI6uWQxyItXk99md
         McZGVMK25fNVLEc4dKWWwUnjxnR59vnLeNahfuHlLO59ASzF74SmOuAEHcdyVrgn9iYU
         oTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=fQQwmz593NiF2fSZtXm+WsePY6yvWZaiZJYMVZxRURY=;
        b=5XbtJhJV1uzkXXojv4LJpywEBv8bqouK/upoW0oyHsixfUX1f04KHaCfuJrBPo+pf6
         dK64ETABsBHaniSVKslojzCGNptLKRfXL1ssYDSwRLhjmuI1tnZzEqASBVg4CG8V+eBJ
         h1ii4+r4JAkxJ7dcdf1TtNzs6CX4w4uVrh6R3GnO60vwTjxG27rnbMYckmtx0QkcxNU5
         JwyYwwAcIwFZXL2/P/cJuUQDU4XJPuvFvF2eg+qjyYgesOU4RFqn5HPviiK4HE0iTAjI
         NV2jJCIds1w1Tv42tlmRFU4JSPdSYhRA1TQT3aa6zL2IREtp/dRc5Ya7pnpdd0cneQ5g
         FMdQ==
X-Gm-Message-State: ACrzQf0s03lEos757cnBV7Lz5MS0KH+pw7LlPyGighCXuyMTB3Mn1Lvk
        xg41x56dXD/CPpjlScSDZWk=
X-Google-Smtp-Source: AMsMyM5ofohSRmVzwAJnjtgGZ65VzyVo1I2I9J9zuv1+ZU7bGR0XlWa3qI4nq4Itjjh1IYujyLwODg==
X-Received: by 2002:adf:eb4c:0:b0:22b:24d5:3786 with SMTP id u12-20020adfeb4c000000b0022b24d53786mr21635197wrn.550.1664399678468;
        Wed, 28 Sep 2022 14:14:38 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id g14-20020adff3ce000000b0022af9555669sm5929118wrp.99.2022.09.28.14.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 14:14:38 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
 <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
 <20220928104426.1edd2fa2@kernel.org>
 <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
 <20220928113253.1823c7e1@kernel.org>
 <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
 <20220928120754.5671c0d7@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bc338a78-a6da-78ad-ca70-d350e8e13422@gmail.com>
Date:   Wed, 28 Sep 2022 22:14:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220928120754.5671c0d7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 20:07, Jakub Kicinski wrote:
> Let's solve practical problems first :) The cases with multiple devices
> offloading are rare AFAIK.

I know of someone who is working on such a use-case for the Alveo U25N
 and running into Interesting difficulties with the same rule getting
 offloaded twice; they probably would care about getting both devices'
 error messages.  I know the plural of anecdote is not data; but I
 think it's not so rare that we can completely ignore it.

> It's just a buffer on the stack, in the struct, the extack is
> transformed into netlink attrs in the same way regardless.
> Stack use is the only concern, no other impact on those not using it.

Okay, I'd probably go with this approach then.

>> Should I rustle up an RFC patch for one of these, or post an RFD to
>>  the list to canvass other vendors' opinions?
> 
> Would be great! Maybe also grep the archive, cause this came up before.
> Someone was against this in the past, perhaps, perhaps even me :)
> But if it wasn't me we should CC them.

Possibly I'm searching for the wrong magic words, all I can find is
 https://lkml.org/lkml/2021/8/9/747 which is vaguely related at best.

-ed
