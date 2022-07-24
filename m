Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5933057F3C5
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 09:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiGXHkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 03:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiGXHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 03:40:22 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9953862FE;
        Sun, 24 Jul 2022 00:40:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m8so10381884edd.9;
        Sun, 24 Jul 2022 00:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ErnvA2IQjdYJKBN8D+WrZ3hhnVFVKrhrGOzLsDpMm3Y=;
        b=H4qz5J6tEyXWB5b4j3E75PbDiA4RFIMmB8xyvckf6GP7E4wOFlyajdYZ7vHCAJ51z0
         JCWL9PHiWIimBkCCRM/tarN1m9QWGjLBacttucueEZSXjM1IL6bPkmrOh4r9634foLTF
         +v1p65ts4KtvCjkAQnsB7S2haXz1YXyn3sflvnIP4g+AAt4sQpQ+XfEUueEgivLyuQ4G
         79GoIh91XftOjhDqYoUdOwpEUScSQNZYISzhY4ZnAfWXZg+eI9gHqrIIaOyTbFulkuUI
         coLtfBJH6ylN1GEpglxHr1fea12jS1CGAtYuCJ2925dpWK6VxsHuG1/Zm3zkOpBpLZuD
         7i7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ErnvA2IQjdYJKBN8D+WrZ3hhnVFVKrhrGOzLsDpMm3Y=;
        b=kzqasxe31zovk1v62bAaEByGHgwAJ6Ruu6Du2Vj6IM+CS8Vie7l5fAfFowTxD5iu+t
         vU5HoHSd4K18aFdVlgmkhkzQS/0ruo87oEChRtRKHLyof1gVYUOZlLavYqhMHE4VNLyu
         HCcLEjX798PhUSiwGCfYf4ahjqP8aC2zyngTjBD5SlKRqlZjiMzZNw9UK7u73Eyap4fS
         MHE0NM+oLmpagArE4dWREWg5vRpUll2xDOinX0NGeGwZxiTC2MeNL3dqRd+k7H6kAkYu
         AjI82HJgNbu1ZxnJyjv8S5O3zK4SDp70WIMt81c/HAzd1XVKcRe0pgeVbPV6EuOHvrNf
         Wx4A==
X-Gm-Message-State: AJIora/5xxjnYF7JVYeh57SBO7GySbaeoGH7KartjCPLSiu14c6NN5/u
        gr+qk2x4M4Gc46ddll4tLzypqgk1C7Ewr7rbSBM=
X-Google-Smtp-Source: AGRyM1siO5STvLpUL89q/Y4a7nrB/6SJ2OzG+9g0zd3k8VusJsoIWqFvk+oynEat1YD5fVHrzBne8dEnUU6bkVb1fwU=
X-Received: by 2002:aa7:c403:0:b0:43b:d0a3:95f with SMTP id
 j3-20020aa7c403000000b0043bd0a3095fmr7424122edq.74.1658648420140; Sun, 24 Jul
 2022 00:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
 <Ytzy9IjGXziLaVV0@kroah.com>
In-Reply-To: <Ytzy9IjGXziLaVV0@kroah.com>
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Sun, 24 Jul 2022 00:40:09 -0700
Message-ID: <CANX2M5bxA5FF2Z8PFFc2p-OxkhOJQ8y=8PGF1kdLsJo+C92_gQ@mail.gmail.com>
Subject: Re: general protection fault in sock_def_error_report
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sashal@kernel.org, edumazet@google.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
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

On Sun, Jul 24, 2022 at 12:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jul 23, 2022 at 03:07:09PM -0700, Dipanjan Das wrote:
> > Hi,
> >
> > We would like to report the following bug which has been found by our
> > modified version of syzkaller.
>
> Do you have a fix for this issue?  Without that, it's a bit harder as:

We will try to root cause the issue and provide a fix, if possible.

>
> > ======================================================
> > description: general protection fault in sock_def_error_report
> > affected file: net/core/sock.c
> > kernel version: 5.4.206
>
> You are using a very old kernel version, and we have loads of other
> syzbot-reported issues to resolve that trigger on newer kernels.

Since 5.4.206 is a longterm release kernel, we were under the
impression that the community is still accepting fixes and patches for
the same. I understand that adding another bug to the already pending
queue of syzbot reported issues is not going to help the developers
much. Therefore, we will definitely try our best to analyze the issue
and provide a fix in the coming days. Can you please confirm that it
is worth the effort for the longterm release kernels?

>
> thanks,
>
> greg k-h



-- 
Thanks and Regards,

Dipanjan
