Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA4E5FF1BA
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiJNPvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiJNPvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:51:48 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1331C5E08;
        Fri, 14 Oct 2022 08:51:46 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id q19so7400099edd.10;
        Fri, 14 Oct 2022 08:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GnPyAzKnqwGBpumOO6cXYlhgLeRhbEWMzQG5nkMG3ME=;
        b=g2n3Ej0xMnrv3N+XsXCGzV8WUM7jFJBeUTO+XEmoq62mLsKRdHm8gp0J+IycF9nEz1
         gSVBU2UgqnT+JkLjlsksXO/uuS6GZOyWF59WeGBV8GZ1X6buyO2cJ6BnENcDSzv08M8Z
         ToPru+fdgMIlq5Vvuwl8uF/9DVSGqlIWYL0ujBp//MFt/6THeWuJHxziTpT3Uawt9jSF
         zsv78QKVGRjrqH5o7qmsteWIFnooffJHXH4J/9d3gz3Vjv6wzRO9lJZ1/beZhCYc4kFs
         uVdrlhmeom3vNlnfV8lSc0vauqYrpZ7gX2Oq4PzCPTZqUlukuXoAjhVSyvgtnCw9OKHc
         zLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnPyAzKnqwGBpumOO6cXYlhgLeRhbEWMzQG5nkMG3ME=;
        b=yUugC3I2ZGjy0eor/I9AqGAIEDFhVv2z0BHYX9rfRyoovDhznmbAwYe+Fl2lXOFSKT
         vOcLjYpeWuPd9eel9Wf1Gk4Skdm7y075ToHyFJuwzC2f9BY4vIypu/h5qYv4KuiY21Hv
         ZiuzVTH5H+4O4mb0bpFijBIqMV2yOcu+BObL4SG88CRp8vmuoV0mK7XPrk3OLm8jLgSF
         lSE1VluN1EOCxemb+0HFqfm+izABBBD7pCQokQRarYxMWbL+UhjZ3FS3XsqE4OIByMNR
         TMCp1uXsJrM1ycVNZuKIJ8MT2/Clh7Yx15jUOxidSXYKOhfYvq/NMvO+Au6yQTCjFCTy
         EDVg==
X-Gm-Message-State: ACrzQf1bE7Bo8HMT7kAGC6udnSXFUiipl+XUVSMVYBd1PMO2lRMI1ECt
        aQBfYV2S5ugAKy7pls6cZxtT3EaJCoX0OSSR4OcEgwR5334RCg8W
X-Google-Smtp-Source: AMsMyM6ZVjfkVC8mxxh+6X5NrpSP7wTXCy0GOTyyzeeO1Ci4AjZvTZ5cNFkRatLQy5DXmjgs//msm+MassRXh/MlFl4=
X-Received: by 2002:a05:6402:22ef:b0:458:bfe5:31a3 with SMTP id
 dn15-20020a05640222ef00b00458bfe531a3mr4795523edb.6.1665762704507; Fri, 14
 Oct 2022 08:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <166543910984.474337.2779830480340611497.stgit@olly>
 <20221013085333.26288e44@kernel.org> <CAHC9VhT5A6M27PO1_NKgqaRJXkTyZv_kjfPF=VNSLZ1nx5GFrA@mail.gmail.com>
In-Reply-To: <CAHC9VhT5A6M27PO1_NKgqaRJXkTyZv_kjfPF=VNSLZ1nx5GFrA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Oct 2022 08:51:32 -0700
Message-ID: <CAADnVQ+1RZWuvjCEAro0OW9+1w12U2R6v3+kTR5T7pWvPC7gLg@mail.gmail.com>
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t safe
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
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

On Thu, Oct 13, 2022 at 8:59 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Thu, Oct 13, 2022 at 11:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 10 Oct 2022 17:58:29 -0400 Paul Moore wrote:
> > > Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > sockptr_t argument") made it possible to call sk_getsockopt()
> > > with both user and kernel address space buffers through the use of
> > > the sockptr_t type.  Unfortunately at the time of conversion the
> > > security_socket_getpeersec_stream() LSM hook was written to only
> > > accept userspace buffers, and in a desire to avoid having to change
> > > the LSM hook the commit author simply passed the sockptr_t's
> > > userspace buffer pointer.  Since the only sk_getsockopt() callers
> > > at the time of conversion which used kernel sockptr_t buffers did
> > > not allow SO_PEERSEC, and hence the
> > > security_socket_getpeersec_stream() hook, this was acceptable but
> > > also very fragile as future changes presented the possibility of
> > > silently passing kernel space pointers to the LSM hook.
> > >
> > > There are several ways to protect against this, including careful
> > > code review of future commits, but since relying on code review to
> > > catch bugs is a recipe for disaster and the upstream eBPF maintainer
> > > is "strongly against defensive programming", this patch updates the
> > > LSM hook, and all of the implementations to support sockptr_t and
> > > safely handle both user and kernel space buffers.
> >
> > Code seems sane, FWIW, but the commit message sounds petty,
> > which is likely why nobody is willing to ack it.
>
> Heh, feel free to look at Alexei's comments to my original email; the
> commit description seems spot on to me.

Paul,

The commit message:
"
also very fragile as future changes presented the possibility of
silently passing kernel space pointers to the LSM hook.
"
shows that you do not understand how copy_from_user works.

Martin's change didn't introduce any fragility.
Do you realize that user space can pass any 64-bit value
as 'user pointer' via syscall, right?
And that value may just as well be a valid kernel address.
copy_from_user always had a check to prevent reading kernel
memory. It will simply return an error when it sees
kernel address.

Your patch itself is not wrong per-se, but it's doing
not what you think it's doing.
Right now the patch is useless, but
if switch statement in sol_socket_sockopt() would be relaxed
the bpf progs would be able to pass kernel pointers
to security_socket_getpeersec which makes little sense at this point.
So the code you're adding will be a dead code without a test
for the foreseeable future.
Because of that I can only add my Nack.
