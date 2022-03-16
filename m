Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C264DA926
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiCPEBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiCPEBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:01:30 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6915B4832A;
        Tue, 15 Mar 2022 21:00:17 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id n16so786063ile.11;
        Tue, 15 Mar 2022 21:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=rSzgmk+B5Ar8ei69IOGqcC1Qk1yUbI7eByB01Wx0p6I=;
        b=pP5JYTkoc1Y3kyWz0sEb7RMEKSR9QwoKjSSgKdF7oKCLUkEqxztDffUqt7ULe9JuqQ
         DvY85KTODVlRhWEKwGnEKeN33CQEDzKnBxiJoWvJ1ttrih/Q9bNTWGXQFqS1Vo/pkn8R
         tFPgWZXfB/2gNSagNbmUMKrXII7XOh7ufEFnvLWmrDn6w45r/ZLAHFIqBvxMfNL1GWts
         RR2f4TztVYWFotKToGRQtFMT8TL9+ZLOsyvF97rSckWJXDIIjjRw5E7Vme4BPSyPt+ET
         UfINMbqGGQE2JIigkNROI8lfvALNfPWe2XyMsIstLE2NrTwwVwdvOItV20cfTECJPyJz
         GHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=rSzgmk+B5Ar8ei69IOGqcC1Qk1yUbI7eByB01Wx0p6I=;
        b=SgI6qPRLvep36QyE61/1ey/xnOuKgsE6Ebfq/382rMGx2TXtM9RLvIINfluQRKD0TS
         pHTDzVkd0rraEMC59Oju0tTBLI8Rx2qmpJE/RixUy4I728KnTttQeNAgt8X9yW+uWYDl
         fyvoulBV1HGhuOJmj3aKUK6pqGlbcqa8mOVvMSpIxXMGzc8iszB+6t3Wx6Nn4KEkvz5B
         hXpsddERHsr/0x2EmG3OrIwFx0fR70NV8oRfqdTZEDkvazmwuQ4R55pPX8tFreViaoGy
         rBQ8xzxbZ2Hx46PvrqwCNMTKW8U8RrfzR6Iux811SFgiVDRylnBXvbv4ZPK9oFwkx8MF
         VHSg==
X-Gm-Message-State: AOAM532hu63R01PMdF9kr1SLVkltXhzrr4tm4s04KeJPXQdjKDfaHojh
        D8htqNvXT2NEaFMBcC3uPXU=
X-Google-Smtp-Source: ABdhPJzcQtEEU6gs4sIbbvZZqOiXwIIa8EE8ZqemjxybuOlWxKZK73jsohn2CtnA0MnNCtAmZLtl/Q==
X-Received: by 2002:a92:130b:0:b0:2c5:66a6:cad8 with SMTP id 11-20020a92130b000000b002c566a6cad8mr22375500ilt.285.1647403216754;
        Tue, 15 Mar 2022 21:00:16 -0700 (PDT)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id q197-20020a6b8ece000000b00648d615e80csm426357iod.41.2022.03.15.21.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 21:00:16 -0700 (PDT)
Date:   Tue, 15 Mar 2022 21:00:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "liujian (CE)" <liujian56@huawei.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Message-ID: <623160c966680_94df20819@john.notmuch>
In-Reply-To: <4f937ace70a3458580c6242fa68ea549@huawei.com>
References: <20220315123916.110409-1-liujian56@huawei.com>
 <20220315195822.sonic5avyizrufsv@kafai-mbp.dhcp.thefacebook.com>
 <4f937ace70a3458580c6242fa68ea549@huawei.com>
Subject: RE: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

liujian (CE) wrote:
> 
> 
> > -----Original Message-----
> > From: Martin KaFai Lau [mailto:kafai@fb.com]
> > Sent: Wednesday, March 16, 2022 3:58 AM
> > To: liujian (CE) <liujian56@huawei.com>
> > Cc: ast@kernel.org; daniel@iogearbox.net; andrii@kernel.org;
> > songliubraving@fb.com; yhs@fb.com; john.fastabend@gmail.com;
> > kpsingh@kernel.org; davem@davemloft.net; kuba@kernel.org;
> > sdf@google.com; netdev@vger.kernel.org; bpf@vger.kernel.org
> > Subject: Re: [PATCH bpf-next] net: Use skb->len to check the validity of the
> > parameters in bpf_skb_load_bytes
> > 
> > On Tue, Mar 15, 2022 at 08:39:16PM +0800, Liu Jian wrote:
> > > The data length of skb frags + frag_list may be greater than 0xffff,
> > > so here use skb->len to check the validity of the parameters.
> > What is the use case that needs to look beyond 0xffff ?

> I use sockmap with strparser, the stm->strp.offset (the begin of one
> application layer protocol message) maybe beyond 0xffff, but i need
> load the message head to do something.

This would explain skb_load_bytes but not the other two right? Also
if we are doing this why not just remove those two checks in
flow_dissector_load() I think skb_header_pointer() does duplicate
checks. Please check.
