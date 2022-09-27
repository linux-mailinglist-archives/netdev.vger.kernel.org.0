Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF55B5EC6CC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiI0Otc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiI0OtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:49:07 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D68A5E335
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 07:46:21 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1318443dbdfso2200610fac.3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=UVJ0zli5rqphXpZyzoquxRevsa1rbXVSCDH5DfGXxSA=;
        b=K1o602WGt/SnXMUB2M17Ee7/BzYiGokgDH54qAUN6rrLhg7/P/cvX61ibIknUZN5X2
         fhna5MMF3TQ/nuzaKwFn96F6aM/PXmP7yQ26CsAItnGo6buZvjiJ8DWhyJW7mK2ohgsS
         Ii5nnQbdTzlKTPe8elpHzPuFzLcqVduTTjlZzT6LwGY3YntcuoFisPcdRrByRuebs1aI
         wQZaxIhx2Vuk3m6nq2uJ0IpQOxfylkGrvwfL9C4+LfEIB72+un3Jeqdsnou4ms1tk1r5
         8WdYeUg0E+YeeBzJu9JoKLXD72bOXQWrVLHsgCjwklKnz38+x5aBqbd/TZp2fK11ekm7
         XMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=UVJ0zli5rqphXpZyzoquxRevsa1rbXVSCDH5DfGXxSA=;
        b=bBsjwbXOkUVKDxk2Hsz2tqv2DRx0e1ib7hs5amfxJ9TEtOqPnqjUVrCpqD9jqnAS8n
         n18HGXQ8afo3UbrHiVJOl2Qfizezt2GNNWTUIxqIMdgrdGDKuQ9RnoXG0XGgOAk0IOC8
         /8J1GtcWUpDNGTYhECM78t17tOyHWXUGM+ge5BFg/a/EpMAh+aS0zxnAwy0wGPEfHsR1
         fY6gTbr8MjZw2LP+eu5xS31BVf9EFWdLte+QQ3LaEtX7AAWBq/T2taYLFbSfxUWOHs/S
         As44nKWEwGRxOMHO97V0D5s6nBTPZthxEMdqnr/rVmqLCDQrknCG3SfoBGx/KojfWDXx
         CUcQ==
X-Gm-Message-State: ACrzQf3DhKNRCX3uBruQ9DO1pRY+Cqi0y2SmUV/UicBKQOLusKHy2jOL
        uMSgeLdqlTGogwTv0tDNsVzGJ2etNJ89XF/Zz20=
X-Google-Smtp-Source: AMsMyM4ZIe7kp/ex6h+1O+3IM9lBz77nRqzeEMmy8invYUZJzbSBSiBMuy9fcG3hG7lGDwyu40Vc3n4SGJuL8wqzZwE=
X-Received: by 2002:a05:6870:523:b0:131:2d50:e09c with SMTP id
 j35-20020a056870052300b001312d50e09cmr2493183oao.129.1664289980967; Tue, 27
 Sep 2022 07:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663946157.git.lucien.xin@gmail.com> <208333ca564baf0994d3af3c454dc16127c9ad09.1663946157.git.lucien.xin@gmail.com>
 <5a7a07d34b68b36410aa42f22fb4c08c5ec6a08c.camel@redhat.com>
In-Reply-To: <5a7a07d34b68b36410aa42f22fb4c08c5ec6a08c.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 27 Sep 2022 10:45:39 -0400
Message-ID: <CADvbK_dyOapTEOzOrAJM9GXAG8quR+ZeV6QYY0p2KrA6Z-Hk_g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: sched: fix the err path of tcf_ct_init
 in act_ct
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 8:43 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Fri, 2022-09-23 at 11:28 -0400, Xin Long wrote:
> > When it returns err from tcf_ct_flow_table_get(), the param tmpl should
> > have been freed in the cleanup. Otherwise a memory leak will occur.
> >
> > While fixing this problem, this patch also makes the err path simple by
> > calling tcf_ct_params_free(), so that it won't cause problems when more
> > members are added into param and need freeing on the err path.
> >
> > Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> I think it's better if you re-submit this patch for -net explicitly, as
> it LGTM and makes sense to let it reach the affected kernel soon.
If so, I will have to wait until this patch is merged on net-next,
then post the other one for net-next, right?

>
> Thanks!
>
> Paolo
>
>
