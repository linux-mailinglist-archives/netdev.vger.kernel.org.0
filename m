Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791CC5FF238
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJNQZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiJNQZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:25:27 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1175789C
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:25:25 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 63so6204842ybq.4
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NcdIdCoD13PsVdF7VemIWCKC21xbZgC+dlVWP2DevsU=;
        b=0XzxQYtHFbIrXn8AS8vsoqDTkWCOBrHLEQFRujV8atSDmeImDUO47FOUArU55vzqNA
         moMrG/7iYJbwyioQ7slGp1rAYns2UOfNyN8xtPsP9ZvQkF8+sFK+bH1W2Cnuzy4l6tny
         n0XJmGsvSBeHB50i30Vo7KKjsyS3ZnsvUqBZQUH5Ta/m5YjDbLiwlJuW37qfRIdd6asi
         JVBMNr5PUIuRElKOVHzDZb9UPTRMclwFFDpSI1E0th8GiBX9BNpXbbj3r+KE9v3xhG65
         3Bs5ADQcT2I8MrYHafd6NHU4zxo8MNAjyGNRvzc/Jhsr1yY9J9eThlJ0mg8ypzRFcZ9X
         HaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NcdIdCoD13PsVdF7VemIWCKC21xbZgC+dlVWP2DevsU=;
        b=HXQiPLIpg0xle7rbN5luSZJgFqOTUwgVgK8mTm0HJRgp0ArosyQ+e8p6nnTqgtdCjk
         zueLfb5PAQonlyEa/+zaqi1/BvUSJ8253zMHd4qDEBjRWPSAf5EihiCkLmMzP3KQnzwU
         TI9CmPtGg/W+RMACYgHY8lZLZy0SuLkTV0ZkWJWFfz8iBb8SW4aUJIMa5bDmAvvg9hXP
         IMJcUSNLInnF3j5WUKlRGIWOViyQPBetuxqS3S8kYYex71DUZOn5fy4rayd10UI2+WUk
         8+zNmEJqk1/TSqUkfNQkYuI+eDaw92Q6h7r3ZieeNsuaXxXv1Bs60ifY0bh4Fw9kqKbz
         W5kg==
X-Gm-Message-State: ACrzQf2JFBtQMe913kGiUEVAcb3y+KyPZ/Y4Ws76xlGbzB9H0lrDY6jQ
        ujlid2Z6iXN03nMlpWYzzbQCE1RbA1G43sOESidr
X-Google-Smtp-Source: AMsMyM6ady9Wb/I8bWW9rB+anqAQUZjNjnrqoCisyeI5hegnDjV4ximcDWV1xI5TfdzL4x9FJGsT6gLoO0Pu/Uib5Fo=
X-Received: by 2002:a25:9a88:0:b0:6b9:c29a:2f4b with SMTP id
 s8-20020a259a88000000b006b9c29a2f4bmr5348869ybo.236.1665764724292; Fri, 14
 Oct 2022 09:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <166543910984.474337.2779830480340611497.stgit@olly>
 <20221013085333.26288e44@kernel.org> <CAHC9VhT5A6M27PO1_NKgqaRJXkTyZv_kjfPF=VNSLZ1nx5GFrA@mail.gmail.com>
 <CAADnVQ+1RZWuvjCEAro0OW9+1w12U2R6v3+kTR5T7pWvPC7gLg@mail.gmail.com>
In-Reply-To: <CAADnVQ+1RZWuvjCEAro0OW9+1w12U2R6v3+kTR5T7pWvPC7gLg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 14 Oct 2022 12:25:12 -0400
Message-ID: <CAHC9VhRModyV8B9o7_DqkanWf79GzPGMtirw=xCt2wexp5RJ6w@mail.gmail.com>
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t safe
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 11:51 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Thu, Oct 13, 2022 at 8:59 AM Paul Moore <paul@paul-moore.com> wrote:
> >
> > On Thu, Oct 13, 2022 at 11:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 10 Oct 2022 17:58:29 -0400 Paul Moore wrote:
> > > > Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > > sockptr_t argument") made it possible to call sk_getsockopt()
> > > > with both user and kernel address space buffers through the use of
> > > > the sockptr_t type.  Unfortunately at the time of conversion the
> > > > security_socket_getpeersec_stream() LSM hook was written to only
> > > > accept userspace buffers, and in a desire to avoid having to change
> > > > the LSM hook the commit author simply passed the sockptr_t's
> > > > userspace buffer pointer.  Since the only sk_getsockopt() callers
> > > > at the time of conversion which used kernel sockptr_t buffers did
> > > > not allow SO_PEERSEC, and hence the
> > > > security_socket_getpeersec_stream() hook, this was acceptable but
> > > > also very fragile as future changes presented the possibility of
> > > > silently passing kernel space pointers to the LSM hook.
> > > >
> > > > There are several ways to protect against this, including careful
> > > > code review of future commits, but since relying on code review to
> > > > catch bugs is a recipe for disaster and the upstream eBPF maintainer
> > > > is "strongly against defensive programming", this patch updates the
> > > > LSM hook, and all of the implementations to support sockptr_t and
> > > > safely handle both user and kernel space buffers.
> > >
> > > Code seems sane, FWIW, but the commit message sounds petty,
> > > which is likely why nobody is willing to ack it.
> >
> > Heh, feel free to look at Alexei's comments to my original email; the
> > commit description seems spot on to me.
>
> Paul,
>
> The commit message:
> "
> also very fragile as future changes presented the possibility of
> silently passing kernel space pointers to the LSM hook.
> "
> shows that you do not understand how copy_from_user works.
>
> Martin's change didn't introduce any fragility.
> Do you realize that user space can pass any 64-bit value
> as 'user pointer' via syscall, right?
> And that value may just as well be a valid kernel address.
> copy_from_user always had a check to prevent reading kernel
> memory. It will simply return an error when it sees
> kernel address.
>
> Your patch itself is not wrong per-se, but it's doing
> not what you think it's doing.
> Right now the patch is useless, but
> if switch statement in sol_socket_sockopt() would be relaxed
> the bpf progs would be able to pass kernel pointers
> to security_socket_getpeersec which makes little sense at this point.
> So the code you're adding will be a dead code without a test
> for the foreseeable future.
> Because of that I can only add my Nack.

Oh don't worry, I've already registered your NACK because the patch
has a three line diff in net/core/sock.c and it's going in via the LSM
tree.  I'll CC you on the pull request and mention your NACK to Linus,
you can feel free to make whatever argument you believe justifies your
objection at that point in time.

However, just so I'm clear on your new objection, you are basically
saying that copy_to_sockptr() shouldn't exist?  If you honestly
believe that, and you aren't just picking on this patch because of a
grudge, I would encourage you to submit a patch removing
copy_to_sockptr() and friends from the kernel and let's see what
happens; please CC me on the patch(es) as I think the discussion for
that would be very interesting :)

-- 
paul-moore.com
