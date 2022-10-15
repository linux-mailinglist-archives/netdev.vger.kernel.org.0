Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23B35FF7E5
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 03:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJOBil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 21:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJOBik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 21:38:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C0A895DA;
        Fri, 14 Oct 2022 18:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43C87B82486;
        Sat, 15 Oct 2022 01:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE41C43143;
        Sat, 15 Oct 2022 01:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665797917;
        bh=ZjS+xMNSlpvu1zyJXPazkr7R5rfqNNFR9uxlQHaxDsE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sZJXGp6SrjJIO9l34zTRNWzM4kTD44QTn543wLrAPYqL01z6JXWE1hWUY6q2duH6e
         aS9b69bxyIrjDzXKV1Jkm7vL7UOGcW7zvspQ0LXz0E5YdTU8dKkbWYriiawbB9uYMS
         24GoryYcJSo9pfQJVo56E0luIiVyd7v00Z5ph63iDvKopZwypRALTPcCEsIOr/9sOD
         VF+zGeqkS3wtO+y64krgLfXrJSaI0AH/OALGXN5S3GkcGmh/NLWc90x4afTlX/hIgf
         +N+X+S0Ee4hUcoXv8sxtbVkoYZLndQP13LhX8N5YhQnwnTqu77/XZv67kal9FOrb4d
         5agliUqM2N3PA==
Received: by mail-oi1-f170.google.com with SMTP id g130so6796708oia.13;
        Fri, 14 Oct 2022 18:38:36 -0700 (PDT)
X-Gm-Message-State: ACrzQf2Gd6zH1hdDCncMhQCxZZJ27YDZuJ/MN5+/9N4QreZVaoiLCFb2
        l3Pm7zt6C/K8GfPiLGh91j5spI/DL5JXI5eiN+0=
X-Google-Smtp-Source: AMsMyM6B/sjQViEnCU0rQQ1CtugSua/MQXf19M8zrTaSx6fTy6/clBFPhm0KZ8eepVAFQut0I40wcPZpDsuV9XPCvL8=
X-Received: by 2002:a05:6808:10c3:b0:354:db1e:c4a8 with SMTP id
 s3-20020a05680810c300b00354db1ec4a8mr7945001ois.112.1665797916031; Fri, 14
 Oct 2022 18:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-2-guoren@kernel.org>
 <20221013203544.110a143c@kernel.org> <CAJF2gTQyMHNHLizeU-gvUdA5hRLUWxvHXuVVqSoPg3M_WxPPdw@mail.gmail.com>
 <20221014085219.635d25cd@kernel.org>
In-Reply-To: <20221014085219.635d25cd@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Sat, 15 Oct 2022 09:38:24 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQtZOHgN7eJ-nhwF3RMUzJUC=ZjOnRzoR11Fso2b3z3gQ@mail.gmail.com>
Message-ID: <CAJF2gTQtZOHgN7eJ-nhwF3RMUzJUC=ZjOnRzoR11Fso2b3z3gQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 11:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 14 Oct 2022 14:38:56 +0800 Guo Ren wrote:
> > > This does not look equivalent, have you tested it?
> > >
> > > nr_ids is unsigned, doesn't it mean we'll never enter the loop?
> >
> > Yes, you are right. Any unsigned int would break the result.
> > (gdb) p (int)-1 < (int)2
> > $1 = 1
> > (gdb) p (int)-1 < (unsigned int)2
> > $2 = 0
> > (gdb) p (unsigned int)-1 < (int)2
> > $4 = 0
> >
> > So it should be:
> >  -     for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
> >  -          j < nr_ids;) {
> >  +     for (j = -1; j < (int)nr_ids;
> >  +          j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {
> >
> > Right? Of cause, nr_ids couldn't be 0xffffffff (-1).
>
> No. You can't enter the loop with -1 as the iterator either.
> Let's move on.
Oops, how about the below:
     for (j = netif_attrmask_next_and(-1, online_mask, mask, nr_ids);
j < (int)nr_ids;
          j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {


-- 
Best Regards
 Guo Ren
