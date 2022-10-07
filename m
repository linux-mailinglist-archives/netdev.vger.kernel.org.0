Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E0F5F7DAA
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 21:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJGTNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 15:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJGTNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 15:13:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27807E1E;
        Fri,  7 Oct 2022 12:13:03 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g27so8278381edf.11;
        Fri, 07 Oct 2022 12:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c7k/YoIsegpB+bQihpvDOfUljohshFNfvjpr6UlJYnA=;
        b=o3sVYmHPnJ4B/nBplzmGbJFp6zNHfDR+6pR6fJOmy2XGgwUTedtloeELLGNTHXszAl
         Zk5yr03UgHnL5VE8lzqYoBaCukZqat5zTDoUaamirf/8jebymnkzq/ZxQchsoRDChjhB
         D21LIZfLvqIFIZqoqo6G4B6QzH4r4w/QmnyYp9Sj9yhN0Ba66nuoTQgsYX/hRvw81Tfb
         GgM/kFMGsKZ9lT8ljTnaTvkteHxT08R104WaN66XvDUXPNFIKB4mZsvrD7BVvKf1k9Rl
         LOpg/OoH0AFTsAlunduzFCTXlf79rWXRXtbLHAm7Bw78TOJ00LtI/ZiMUOX1K6tTp0dI
         KERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c7k/YoIsegpB+bQihpvDOfUljohshFNfvjpr6UlJYnA=;
        b=StG37bbkQ81qPWzsubzfzcfuy8FBPSZHoo2yylSBTzk+oln/QCb0rax59VXqDRMuyZ
         bh0cx+3I15GBdDwtokQ2k1kUKpanoOaow53aZrifPGOxtgLE+b4ApTfv2eKwZdgkzotM
         s9nJiqAodixhp7RPJ6f43g14wd4KfdGE9e0dJy2S25M/NqY6ijtjFlhxKol6HEtpiuaF
         3banK3IodHajBk+sEqQaKVYs8vFCVZkO2xq1VAC/mJ5qDlbD2o4Ihb1utJGN9APrg1gp
         Ne/EmVIrxgzfzDOvj5+dvTX/sea2fD0CX8PhmHZFXq7+lexCVs7vEsutsP51/ARK1VN8
         aESg==
X-Gm-Message-State: ACrzQf36RFSd1ax6LWsGUc4ZIiVsVkXvmoI2FvlfctXtKxDuFZwzSjPy
        0OnARbXn5QGLm/KSIyh6haAJKmwPmaK9ExM6HRam4r00
X-Google-Smtp-Source: AMsMyM5U4+1YT22ltVCYc7N/hbjPqWRxOJPMBLxMLAvYnZDhaymWBZ3YFzgA/M4WmDnMPslToDdCozruaEhucx7lRUw=
X-Received: by 2002:a05:6402:22ef:b0:458:bfe5:31a3 with SMTP id
 dn15-20020a05640222ef00b00458bfe531a3mr5940270edb.6.1665169981553; Fri, 07
 Oct 2022 12:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
In-Reply-To: <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 7 Oct 2022 12:12:50 -0700
Message-ID: <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     Paul Moore <paul@paul-moore.com>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
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

On Fri, Oct 7, 2022 at 10:43 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> >
> > Hi Martin,
> >
> > In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > sockptr_t argument") I see you wrapped the getsockopt value/len
> > pointers with sockptr_t and in the SO_PEERSEC case you pass the
> > sockptr_t:user field to avoid having to update the LSM hook and
> > implementations.  I think that's fine, especially as you note that
> > eBPF does not support fetching the SO_PEERSEC information, but I think
> > it would be good to harden this case to prevent someone from calling
> > sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> > something like this?
> >
> >   static int sk_getsockopt(...)
> >   {
> >     /* ... */
> >     case SO_PEERSEC:
> >       if (optval.is_kernel || optlen.is_kernel)
> >         return -EINVAL;
> >       return security_socket_getpeersec_stream(...);
> >     /* ... */
> >   }
>
> Any thoughts on this Martin, Alexei?  It would be nice to see this
> fixed soon ...

'fixed' ?
I don't see any bug.
Maybe WARN_ON_ONCE can be added as a precaution, but also dubious value.
