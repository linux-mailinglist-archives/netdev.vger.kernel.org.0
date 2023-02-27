Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684956A4C57
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjB0Uir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0Uiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:38:46 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ED1BBB4;
        Mon, 27 Feb 2023 12:38:44 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v16so4763507wrn.0;
        Mon, 27 Feb 2023 12:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hE1FHM1U2zm1erfLjZRxZpbmVUkLBg3sA/DLB4dzuBo=;
        b=qj4arBGe+jk9mWesxN2xwdEoJ6DAJDdkL4ptrKn8esZCMAbN95b4ax50iWLja43blW
         zwy5fZF4ncEeD9WSs5Hmj+ikaGqh3ET88l0Rsd1/MFpgUfTe5c1kscjJ5S2JveA/QgB3
         wZRg/PHlUv15pMlCr838F+NcvSQvWFB3d/oSxvvzrKZsnyUGaLwmTd3cGfwVPFUqa2UM
         b3L2oydkQgj6LfZTlOkDBX4QbkkVHbl03L6f+sKweTxhfM1dJodOWiXkozWihNe8X1K6
         FVqBA+MdbrMQZyt70TOD9mbYwwNkXJdftUiy1evANJNa3LVdviNhVu4NBBsl+9gX9/Tu
         Dncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hE1FHM1U2zm1erfLjZRxZpbmVUkLBg3sA/DLB4dzuBo=;
        b=nuvF9WSDHgcttmXJ2hVQnP1D2arcatkkoZyAtn6qM5qE8ilf9LRiJ0VJDJik6EESxG
         PqCnXkS9Jgh7EsO1JBT2y2pnr5PSFXu6VshFU8Yxelp0pj7aTZxOP7irjLz4c0ZNv3Vq
         2BjdaLeWQGQDATtgc3oNGArgpTA/euILlD+PNDJ80soU6JPc8tz8thbdGiz92HoDgcDJ
         8Ju/1SqEJgVhk+NMDCYNDgrpdF1i7O57jwRYLfBEs+d5OXfc4kjON0t1GRA3a+HuB8Lw
         gtorFl37m8/vd3eSFS2MhHJiU4o8N7hiXuJ5Vm2gGYC6fBLDX7/e/TZ4BwHGmOCB83Ts
         hh/w==
X-Gm-Message-State: AO0yUKXz3Th5xnfS/COVRKYwjFyIUBCSyg2fEjLTg8pw7NGPSC41lF+c
        WxBgraBHIbfFLirenEaGyQIccZa6JYQ=
X-Google-Smtp-Source: AK7set9V3tdK/RYak+pa1dRZ1YYwxGzKCQiX+KQ3sP4NGLhdDLjKb6HD//k7/hhgNrsfda6ZAV1btQ==
X-Received: by 2002:a5d:4cc7:0:b0:2bf:94ea:67ca with SMTP id c7-20020a5d4cc7000000b002bf94ea67camr369325wrt.25.1677530322739;
        Mon, 27 Feb 2023 12:38:42 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d55ce000000b002c559405a1csm7849754wrw.20.2023.02.27.12.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 12:38:42 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in
 BPF
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1677526810.git.dxu@dxuuu.xyz>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <cf49a091-9b14-05b8-6a79-00e56f3019e1@gmail.com>
Date:   Mon, 27 Feb 2023 20:38:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cover.1677526810.git.dxu@dxuuu.xyz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/02/2023 19:51, Daniel Xu wrote:
> However, when policy is enforced through BPF, the prog is run before the
> kernel reassembles fragmented packets. This leaves BPF developers in a
> awkward place: implement reassembly (possibly poorly) or use a stateless
> method as described above.

Just out of curiosity - what stops BPF progs using the middle ground of
 stateful validation?  I'm thinking of something like:
First-frag: run the usual checks on L4 headers etc, if we PASS then save
 IPID and maybe expected next frag-offset into a map.  But don't try to
 stash the packet contents anywhere for later reassembly, just PASS it.
Subsequent frags: look up the IPID in the map.  If we find it, validate
 and update the frag-offset in the map; if this is the last fragment then
 delete the map entry.  If the frag-offset was bogus or the IPID wasn't
 found in the map, DROP; otherwise PASS.
(If re-ordering is prevalent then use something more sophisticated than
 just expected next frag-offset, but the principle is the same. And of
 course you might want to put in timers for expiry etc.)
So this avoids the need to stash the packet data and modify/consume SKBs,
 because you're not actually doing reassembly; the down-side is that the
 BPF program can't so easily make decisions about the application-layer
 contents of the fragmented datagram, but for the common case (we just
 care about the 5-tuple) it's simple enough.
But I haven't actually tried it, so maybe there's some obvious reason why
 it can't work this way.

-ed
