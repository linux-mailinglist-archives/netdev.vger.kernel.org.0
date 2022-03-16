Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446F44DB3DA
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbiCPPEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiCPPEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:04:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2942719C
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:02:54 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id w27so4225517lfa.5
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=jtHkXdxbxWXHKD5rdP6nM1QkeT2vkJpBRGPpLY6uAjs=;
        b=PPBGjRJSN7CRorCjB6lrzB8a3MoejhiCBCKMx1WfbkJjbJiFjTbHBWcY1Vb+1mdYjZ
         DKWA8BuNsrwPgfz99RZS116IN4E4vodgmk1MP0DQkSdPjmNeTPFCUKYHu7KxBpkFC3xI
         r99cnoFuAdIrOZIt2U2035S8x3HaEKeKaivD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=jtHkXdxbxWXHKD5rdP6nM1QkeT2vkJpBRGPpLY6uAjs=;
        b=7pXZyV1XJCGBisZ0xziVjs2E9cZMBYTB9eQxoRhtl/20wckI+WcHaWHohTxgSF9cdT
         JtZK1Ngw3/a4JoDIymy36tdS91YIrvZP9LWByosUAS93YJnRWQ4dbqN5NO0p19kBHsHE
         Edrp7kkTDCoLAzImBOtRV4XT+M1JlFSbf0mILuusvXyuCPTYF13W0CBt2LDjDeookyBL
         PL68QqExE0AtgAYBtZx7o+/XFXgxRz95XPJC93Ju4wXRdK8B5zii84Tyuf68zCOoMDAm
         aVjXdKehMw1M/tLe7fVW0x62CJPDw6V5TV12+r2TdnOvQM7F7qhsfQ4OpwiDJbL42g0v
         BlGw==
X-Gm-Message-State: AOAM530tcfV6iD1iGG3afX2ue4KqdSVy2bRM3WePrio2bxkdY2gCbp5g
        Abb0hrjU88jcMEXwyYjk0dHSHQ==
X-Google-Smtp-Source: ABdhPJxRPKV24bj9n5oMYGPQe0VmdBPsBQXhifImBm+Cbd9ORgxvh5K9ZfHVzlf+wX7W6GegttrUKA==
X-Received: by 2002:a05:6512:1382:b0:445:9536:903 with SMTP id p2-20020a056512138200b0044595360903mr56999lfa.89.1647442971825;
        Wed, 16 Mar 2022 08:02:51 -0700 (PDT)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0f9c.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id e13-20020ac2546d000000b0044827065453sm198889lfn.169.2022.03.16.08.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:02:51 -0700 (PDT)
References: <20220314124432.3050394-1-wangyufen@huawei.com>
 <87sfrky2bt.fsf@cloudflare.com>
 <ff9d0ecf-315b-00a3-8140-424714b204ff@huawei.com>
 <87fsnjxvho.fsf@cloudflare.com>
 <79281351-b412-2c54-265b-c0ddf537fae1@iogearbox.net>
 <f5a45e95-bac2-e1be-2d7b-5e6d55f9b408@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        john.fastabend@gmail.com, lmb@cloudflare.com, davem@davemloft.net,
        kafai@fb.com, dsahern@kernel.org, kuba@kernel.org,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf, sockmap: Manual deletion of sockmap
 elements in user mode is not allowed
Date:   Wed, 16 Mar 2022 15:57:07 +0100
In-reply-to: <f5a45e95-bac2-e1be-2d7b-5e6d55f9b408@huawei.com>
Message-ID: <87bky6ey91.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 11:42 AM +08, wangyufen wrote:

[...]

> I'm not sure about this patch. The main purpose is to point out the possible problems
>
> when the socket is deleted from the map. I'm sorry for the trouble. 

No problem at all. Happy to see sockmap gaining wider adoption.
