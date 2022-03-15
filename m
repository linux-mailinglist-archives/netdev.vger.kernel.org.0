Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0601C4D9FB2
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbiCOQMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbiCOQMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:12:06 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E20456740
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:10:54 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2db2add4516so208528717b3.1
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xjNYbTpjH+jLMprjYI2RkAH9AKvlZTly6IvJIGl2R/Y=;
        b=SQ32U3bPOeHkVr/kuWK6QPAafYUr1do2R3zP5qfnPFeGgxd7wnwgBSCpT/vFHGEt+a
         1rbdCOtJyLg5+PIxBoFZcU9dq1wIj9JAUcA/Pe1O7RHTrDorajnxDllU4YcKiJycIEKe
         YN8rBhnSblU92i4Pqku1WUkq/nRjS3n1dRexjRdZdDiaL/URXSy/dlz8DnSqD8HB49gy
         T2hcBjdVIAf4gTFsOST2l7S34H4RmWxJ1TtYtBASRhi7rpJ64Rc8aqPZ5YSxuECAa3SH
         6alivDlF3StG81/8duENnUg1asL+4mmeCLZoV6iG34kEDVg1op39sjlbvvNG3x4FtevN
         a4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xjNYbTpjH+jLMprjYI2RkAH9AKvlZTly6IvJIGl2R/Y=;
        b=zopuG5XMgI7+jXt3dHEjKRdX0G3qMNop1pi5FfZdNCkt44f03NLdLMEz0jD4lw4zbS
         piRs+K+SA6TOPCO/++v0N7L8TamKVc8xwvX4L0gfz/CZKIvxQ7NsFOxuvuJItKwMV4Ww
         E//WXDUpz+66GG4cwLtPc4Whfw/IVa0/zaw8R2FDIObX1IxvrnKzTpONhTOQsL48ETu4
         l74AT/J7AhaJ5BhE9NfTv3h8kV6nKC+uHexQj+I0iGUXEMAhLS7HGWmVP3/v7OX7lYLV
         5rEtdI3SqX3ZJ+Q/gAEqfDd5l4+rNwTel5LdXCyn5YlnliLRPtGQ9fuIw2w3Np7hb+t2
         B7vA==
X-Gm-Message-State: AOAM532xE7AcqDSLUaqsbqg71CirOeJzrGy3KxdyF+R3W0ybUOUmu9eO
        +bZ/14ylX0BKZhwuFUqbp14pUjpqOvoa7d+zJleMsQ==
X-Google-Smtp-Source: ABdhPJzOSQABn8cpZX0btOyh3beRlJ/Uq1qrPnrcLLYkENPnwXptApfcEYH5B2Q2CWm75NP/W3F5OVc5+TxYdrpvPR8=
X-Received: by 2002:a0d:dd85:0:b0:2dc:5589:763a with SMTP id
 g127-20020a0ddd85000000b002dc5589763amr25312864ywe.278.1647360653142; Tue, 15
 Mar 2022 09:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
 <20220310054703.849899-7-eric.dumazet@gmail.com> <bd7742e5631aee2059aea2d55a7531cc88dfe49b.camel@gmail.com>
 <CANn89iJOw3ETTUxZOi+5MXZTuuBqRtDvOd4RwVK8mGOBPMNoBQ@mail.gmail.com> <MW5PR15MB51215DDB0EF5F5046EF86E37BD109@MW5PR15MB5121.namprd15.prod.outlook.com>
In-Reply-To: <MW5PR15MB51215DDB0EF5F5046EF86E37BD109@MW5PR15MB5121.namprd15.prod.outlook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Mar 2022 09:10:41 -0700
Message-ID: <CANn89iLv-t6EKDfVdbSpU=627yqD-k1VVzRrhddUr6wf-k0=Dw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo header
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 9:04 AM Alexander Duyck <alexanderduyck@fb.com> wro=
te:
>
>
>
> > -----Original Message-----
> > From: Eric Dumazet <edumazet@google.com>
> > Sent: Tuesday, March 15, 2022 9:02 AM
> > To: Alexander H Duyck <alexander.duyck@gmail.com>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>; David S . Miller
> > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; netdev
> > <netdev@vger.kernel.org>; Alexander Duyck <alexanderduyck@fb.com>;
> > Coco Li <lixiaoyan@google.com>
> > Subject: Re: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary
> > HBH/jumbo header
> >
> > On Fri, Mar 11, 2022 at 8:24 AM Alexander H Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> > > > From: Eric Dumazet <edumazet@google.com>
> > > >
> > > > Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
> > > > BIG TCP ipv6 packets (bigger than 64K).
> > > >
> > >
> > > This looks like it belongs in the next patch, not this one. This patc=
h
> > > is adding the HBH header.
> >
> > What do you mean by "it belongs" ?
> >
> > Do you want me to squash the patches, or remove the first sentence ?
> >
> > I am confused.
>
> It is about the sentence. Your next patch essentially has that as the tit=
le and actually does add GRO_IPV6_MAX_SIZE. I wasn't sure if you reordered =
the patches or split them. However as I recall I didn't see anything in thi=
s patch that added GRO_IPV6_MAX_SIZE.


I used "Following patch will", meaning the patch following _this_ one,
sorry if this is confusing.

I would have used  "This patch is ..." if I wanted to describe what
this patch is doing.

Patches were not reordered, and have two different authors.
