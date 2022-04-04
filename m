Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA92D4F150A
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347229AbiDDMnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347199AbiDDMnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:43:07 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA432F3BC
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 05:41:11 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id v2so7527368qtc.5
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 05:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bZDEahXLRWYwQFxc1wC9D31LOaNoTZwJzclaEmRXmng=;
        b=jSutBD0Ho9b5CHvnZvqr6MBnsaaWSWi+PUnDEfw4WVQo6K8HnOwMd+e0+F2ICCBP2d
         lWOIRXtGg1heDxR0O2tx7TP/uZsUrf4XwUCsmZvXmteQMPNYDuqAYrMNJ7JwNHq63MMB
         8MbkbNgnBbmTLh4APvhSat0kj40My+MZxOE5LAL9SVfZHOzGDhUoQi4tgYW1m6SlKgsG
         MNuA6ObxdT73OtjZq4CJdXlj4Rtd/sgdmA2D1IAgDiuyszzK+izB09LY5MzgWTDbm+xT
         AjPIeQaJyElIREetLom7fkeeE/ohu6Yf+u4V57WkJ5paMTv3raeWfmB4ZNNvB8QU5kWj
         5/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bZDEahXLRWYwQFxc1wC9D31LOaNoTZwJzclaEmRXmng=;
        b=NV/wP+fW1mKTNaAhiElnojZM7pVW6nAw3vcWD5uyBtGNCmw1lC/dfgWBBfcoQ2TuJs
         rbouzSTGCuoObjfZ/9gc5yC4TNXElmv9D5arSINwJf1IBmm8FdEqnoqF07811spFQa0a
         zaovyk43WBt7f7b8uUw3Y2ZVr+GCih3Ud8AOs3tTNVkRlI0npyIMBPYk/2cFSYWdr2Oc
         5SNWYuAJkqZlx9TILz+WyDmm1jVms+tkswFH5GFZr70jGvu6lNN865A8/Ded844e8z6E
         LgfOOkKWb44sjKx/j5YDUeHENju9pM0Vq9jZeCvz0bZhfGLuqcYuSK3M1j/FEoBDz7fL
         CWQw==
X-Gm-Message-State: AOAM532dpwdKG36J77lNdKeea3iOiaW9wzswkv86iA+AACRyoIDp/Duz
        CYhKlluU5to6IwufpdBsfUZuGT4zwg==
X-Google-Smtp-Source: ABdhPJy5DQLbnkEnIImj2ucg/RzL+Wd5VhwlhCZVZApOnIMJFMeeAC2FxLvfsqS89FvcUWb2C0DuFQ==
X-Received: by 2002:ac8:5a4a:0:b0:2e2:27e5:141b with SMTP id o10-20020ac85a4a000000b002e227e5141bmr17111529qta.661.1649076070595;
        Mon, 04 Apr 2022 05:41:10 -0700 (PDT)
Received: from EXT-6P2T573.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id d26-20020a05620a159a00b0067d4f5637d7sm6189149qkk.14.2022.04.04.05.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 05:41:10 -0700 (PDT)
Date:   Mon, 4 Apr 2022 08:41:04 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Matching unbound sockets for VRF
Message-ID: <20220404124104.GA18315@EXT-6P2T573.localdomain>
References: <20220324171930.GA21272@EXT-6P2T573.localdomain>
 <7b5eb495-a3fe-843f-9020-0268fb681c72@gmail.com>
 <YkBfQqz66FxYmGVV@ssuryadesk>
 <2bbfde7b-7b67-68fd-f62b-f9cd9b89d2ad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bbfde7b-7b67-68fd-f62b-f9cd9b89d2ad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 03, 2022 at 10:24:36AM -0600, David Ahern wrote:
> On 3/27/22 6:57 AM, Stephen Suryaputra wrote:
> > 
> > The reproducer script is attached.
> > 
> 
> h0 has the mgmt vrf, the l3mdev settings yet is running the client in
> *default* vrf. Add 'ip vrf exec mgmt' before the 'nc' and it works.

Yes. With "ip vrf exec mgmt" nc would work. We know that. See more
below.

> Are you saying that before Mike and Robert's changes you could get a
> client to run in default VRF and work over mgmt VRF? If so it required
> some ugly routing tricks (the last fib rule you installed) and is a bug
> relative to the VRF design.

Yes, before Mike and Robert's changes the client ran fine because of the
last fib rule. We did that because some of our applications are:
1) Pre-dates "ip vrf exec"
2) LD_PRELOAD trick from the early days doesn't work

On the case (2) above, one concrete example is NFS mounting our images:
applications and kernel modules. We had to run less than full-blown
utilities and also the mount command uses glibc RPC functions
(pmap_getmaps(), clntudp_create(), clnt_call(), etc, etc.). We analyzed
it back then that because these functions are in glibc and call socket()
from within glibc, the LD_PRELOAD doesn't work.

From the thread of Mike and Robert's changes, the conclusion is that the
previous behavior is a bug but we have been relying on it for a while,
since the early days of VRFs, and an upgrade that includes the changes
caused some applications to not work anymore.

I'm asking if Mike and Robert's changes should be controlled by an
option, e.g. sysctl, and be the default. But can be reverted back to the
previous behavior.

Thanks,
Stephen.
