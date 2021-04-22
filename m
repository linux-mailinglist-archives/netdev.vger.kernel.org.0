Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B979368568
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhDVRCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbhDVRCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 13:02:16 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86469C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 10:01:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r7so33521146wrm.1
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 10:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0xQrGUJMQ0tmAAho/ICoAo494yHdtqwY0aAjVAdlJlc=;
        b=P6ACLkysuXCv+qzEk5qa6Xlz+hudz6YWUo1CF27gQqloEvmct+8aTDc/3EtwNYL9WS
         9cxc7VnLybAbF9X03wXYh2feW7N7o7+kP9pvb0NAzLKoqQnrpci4EABjQZqi1/LGieAS
         uphzJnz/hQ4usJ/mBt82+uztQAm9Msblg5m23plz5KRP4HrTek45R97Y5IPdHzFV0kAB
         X+9+4ZHF3jZPokcQqIsQicMoywXA2ExOo77d9Fxiv72IRDFbxrtEE5sBPwBXc+WbaMNA
         CMSakNqcl0kkW3uDlBZTkql7/iBbtY5o3/MnbeJWgT3zZMNP3HDkV1m+v+pOafxTVe19
         VVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0xQrGUJMQ0tmAAho/ICoAo494yHdtqwY0aAjVAdlJlc=;
        b=IS1ryRhCzelSGlfHbDxfhx4TPgYECFjIWeGLLgfV6i3wM4xOXbvpnNKWPFXiKaUQX+
         vKHrhFi9Xi/gkmOYe4rILim/OQJb3hhAB9oY/d6JZoBoefQvzHJIzSURIMM3JaFC7dgp
         uVJM9NM8QEJ1aLyfZPJl4Lgso9WFZDrokXzUjaDb9RC/PBGzhLUkXMjAflIOrA0lSDwe
         bDhh9EOcnzHx30A256GJ5nVU9KUgm3nS0fZ4yoFaX/Me+mGWv8s9qZGLAVKTFvjcD/Ks
         KaV7Q84nyoshykK3wmpEbnamqriYlfdvI5atkopu5Hq6GvuYXRIUiVLRtOaKko8ShroJ
         TxrQ==
X-Gm-Message-State: AOAM533Oo3q6Zfx8q5YfGaAf9j8KHgUi9PtUthp7BfVER7iSiKAnSoEK
        IgR11PARujDKsIF3g/VPjkmvaU2hG5iRZwyda9eZgRKLMTM=
X-Google-Smtp-Source: ABdhPJy0Wt22BhjpDVLeiGQX1cYKsn8NMoS0zVlB2EW2t2tjxPYjtc/0iPFEuHPDktfgvz3s9/SOV9CWkdTf44ctunY=
X-Received: by 2002:adf:a3c4:: with SMTP id m4mr5278595wrb.217.1619110900333;
 Thu, 22 Apr 2021 10:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210420213517.24171-1-drt@linux.ibm.com> <CAOhMmr5XayoXS=sJ+9zm68VF+Jn+9qiVvWUrDfq0WGQ6ftKdbw@mail.gmail.com>
 <49b3b535-3b81-6ffd-44b7-6226507859fa@linux.vnet.ibm.com>
In-Reply-To: <49b3b535-3b81-6ffd-44b7-6226507859fa@linux.vnet.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 22 Apr 2021 12:01:30 -0500
Message-ID: <CAOhMmr6S2gZX9RSTVRhx-qS7QdeB4QAGCAVf3AyxpkP5ndOhAQ@mail.gmail.com>
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down failed
To:     Rick Lindsley <ricklind@linux.vnet.ibm.com>
Cc:     Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 2:07 AM Rick Lindsley
<ricklind@linux.vnet.ibm.com> wrote:
>
> On 4/21/21 10:30 PM, Lijun Pan wrote:
> >> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> >> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> >> Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
> >> Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> >
> > One thing I would like to point out as already pointed out by Nathan Lynch is
> > that those review-by tags given by the same groups of people from the same
> > company loses credibility over time if you never critique or ask
> > questions on the list.
> >
>
> Well, so far you aren't addressing either my critiques or questions.
>
> I have been asking questions but all I have from you are the above
> attempts to discredit the reputation of myself and other people, and
> non-technical statements like
>
>      will make the code very difficult to manage
>      I think there should be a trade off between optimization and stability.
>      So I don't think you could even compare the two results
>
> On the other hand, from the original submission I see some very specific
> details:
>
>      If ibmvnic abandons the reset because of this failed set link
>      down and this is the last reset in the workqueue, then this
>      adapter will be left in an inoperable state.
>
> and from a followup discussion:
>
>      We had a FATAL error and when handling it, we failed to
>      send a link-down message to the VIOS. So what we need
>      to try next is to reset the connection with the VIOS. For
>      this we must ...
>
> These are great technical points that could be argued or discussed.
> Problem is, I agree with them.
>
> I will ask again:  can you please supply some technical reasons for
> your objections.  Otherwise, your objections are meritless and at worst
> simply an ad hominem attack.

Well, from the beginning of v1, I started to provide technical inputs.
Then I was not
allowed to post anything in the community about this patch and VNIC
via ljp@linux.ibm.com except giving an ack-by/reviewed-by.
