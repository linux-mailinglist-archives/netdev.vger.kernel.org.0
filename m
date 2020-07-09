Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EC621A83C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGITyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgGITyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:54:31 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F45C08C5DC;
        Thu,  9 Jul 2020 12:54:30 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 72so2562746otc.3;
        Thu, 09 Jul 2020 12:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hVmQvgceNuE9gUqdw2DsWEuHafaDdw4hAjlnC4YG72Y=;
        b=WUO7OAm/JvOW4KqGTnvLba/3moYHZm+U0elK80Kg/jIZ2sy6WupncyOA8VWFoJqDfv
         fNLS57kO0agV+2pxUCakNB8gRibz+JJKKh96mlEjgjd2MrqqHzMwDI/E6uUYMNp8mKfQ
         Hdk+r02QnRnZ4jPba7mhvgW7jOBMIAGMODpvZ96jbyapUd03KaoeUsh0X3c/TT6yjaev
         7ldr6anw0uuZ6QsX5aiiingcdRT9Ua96whnpamWVqzeUVft3LiJ9QCKWqBW/rmbqqI8D
         WW363pHnF24DgmufyI2wX/Hpn+zaVL22RHaOU0LQg72qFZXGHgA3BV/JbZ1EO2vQ3baT
         Et/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hVmQvgceNuE9gUqdw2DsWEuHafaDdw4hAjlnC4YG72Y=;
        b=tfWr0u8e5VHbdE8mdxsPbEuU9z6cYpW+NHXO+6RXSw6ymeyYPAqdtW/KLZdeG7GNVC
         41mawUUstNfFXokCkAwj0rTnlp6pWDMEY9ziZ5vhATQ9KDANwm3q+KnclTaaTE21pTmH
         VVk3/IE4rSARGWSne8HhD5XMpXXU2e/VTxVdE+3g30czJwNLUHo+T4JIV6dlBuj7sHb0
         GePcaPQ5QWN15+YsLH3KBoydZE+bU48cbDOBmegweHcHS4/TsEMYStOyNzuWqRm26XPD
         Bjxbt2Kt1lckRGH8qqomhcbZz8UYtGgrqMSUGfF4vYav9dmr/F1mkfMAN1um6ho4PXju
         nbLg==
X-Gm-Message-State: AOAM533MkNrhTIApxNWmlQ/e2Fdo4AFVbu8JJad0a/Tad1GhCSrSZZm5
        vRu85AuZ3UFYiClbcjUbsz9sP6IXRXj8OXf3PpI=
X-Google-Smtp-Source: ABdhPJxLRHXxRYPjMXMuu7fmQF2k7SyAJfy80oyydcFchNTduoj/UXX0VNfiX9z74zqibft67E/O9oKBned2Vg51NM4=
X-Received: by 2002:a05:6830:1db5:: with SMTP id z21mr41453019oti.162.1594324470006;
 Thu, 09 Jul 2020 12:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200709001234.9719-1-casey@schaufler-ca.com> <20200709001234.9719-6-casey@schaufler-ca.com>
 <CAEjxPJ4EefLKKvMo=8ZWeA4gVioH=WQ=52rnMuW5TnyExmJsRg@mail.gmail.com> <8a5a243f-e991-ad55-0503-654cc2587133@canonical.com>
In-Reply-To: <8a5a243f-e991-ad55-0503-654cc2587133@canonical.com>
From:   Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Thu, 9 Jul 2020 15:54:19 -0400
Message-ID: <CAEjxPJ69FyBKO8YrDW9Pc8Urc0q2-8db6EgEO3fYnK9MLx+Y5Q@mail.gmail.com>
Subject: Re: [PATCH v18 05/23] net: Prepare UDS for security module stacking
To:     John Johansen <john.johansen@canonical.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 12:28 PM John Johansen
<john.johansen@canonical.com> wrote:
>
> On 7/9/20 9:11 AM, Stephen Smalley wrote:
> > On Wed, Jul 8, 2020 at 8:23 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>
> >> Change the data used in UDS SO_PEERSEC processing from a
> >> secid to a more general struct lsmblob. Update the
> >> security_socket_getpeersec_dgram() interface to use the
> >> lsmblob. There is a small amount of scaffolding code
> >> that will come out when the security_secid_to_secctx()
> >> code is brought in line with the lsmblob.
> >>
> >> The secid field of the unix_skb_parms structure has been
> >> replaced with a pointer to an lsmblob structure, and the
> >> lsmblob is allocated as needed. This is similar to how the
> >> list of passed files is managed. While an lsmblob structure
> >> will fit in the available space today, there is no guarantee
> >> that the addition of other data to the unix_skb_parms or
> >> support for additional security modules wouldn't exceed what
> >> is available.
> >>
> >> Reviewed-by: Kees Cook <keescook@chromium.org>
> >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >> Cc: netdev@vger.kernel.org
> >> ---
> >
> >> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> >> index 3385a7a0b231..d246aefcf4da 100644
> >> --- a/net/unix/af_unix.c
> >> +++ b/net/unix/af_unix.c
> >> @@ -138,17 +138,23 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
> >>  #ifdef CONFIG_SECURITY_NETWORK
> >>  static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
> >>  {
> >> -       UNIXCB(skb).secid = scm->secid;
> >> +       UNIXCB(skb).lsmdata = kmemdup(&scm->lsmblob, sizeof(scm->lsmblob),
> >> +                                     GFP_KERNEL);
> >>  }
> >>
> >>  static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
> >>  {
> >> -       scm->secid = UNIXCB(skb).secid;
> >> +       if (likely(UNIXCB(skb).lsmdata))
> >> +               scm->lsmblob = *(UNIXCB(skb).lsmdata);
> >> +       else
> >> +               lsmblob_init(&scm->lsmblob, 0);
> >>  }
> >>
> >>  static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
> >>  {
> >> -       return (scm->secid == UNIXCB(skb).secid);
> >> +       if (likely(UNIXCB(skb).lsmdata))
> >> +               return lsmblob_equal(&scm->lsmblob, UNIXCB(skb).lsmdata);
> >> +       return false;
> >>  }
> >
> > I don't think that this provides sensible behavior to userspace.  On a
> > transient memory allocation failure, instead of returning an error to
> > the sender and letting them handle it, this will just proceed with
> > sending the message without its associated security information, and
> > potentially split messages on arbitrary boundaries because it cannot
> > tell whether the sender had the same security information.  I think
> > you instead need to change unix_get_secdata() to return an error on
> > allocation failure and propagate that up to the sender.  Not a fan of
> > this change in general both due to extra overhead on this code path
> > and potential for breakage on allocation failures.  I know it was
> > motivated by paul's observation that we won't be able to fit many more
> > secids into the cb but not sure we have to go there prematurely,
> > especially absent its usage by upstream AA (no unix_stream_connect
> > hook implementation upstream).  Also not sure how the whole bpf local
>
> I'm not sure how premature it is, I am running late for 5.9 but would
> like to land apparmor unix mediation in 5.10

Sorry I think I mischaracterized the condition under which this
support needs to be stacked. It seems to only be needed if using
SO_PASSSEC and SCM_SECURITY (i.e. datagram labeling), not just for
unix mediation or SO_PEERSEC IIUC.  So not sure if that applies even
for downstream.
