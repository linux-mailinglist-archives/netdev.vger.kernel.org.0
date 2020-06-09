Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308801F35F4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 10:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgFIIMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 04:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgFIIL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 04:11:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66977C05BD43
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 01:11:58 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x14so20189928wrp.2
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 01:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q8DAJtYz7gOythokjolokFTN1usdBfwvBMaSNa//VR8=;
        b=SNHu/6Cjunfxcr2sLmpfTuwTTFr0RcoP6fFauDT25yAkSBEDleM1Rdl7qvKWTaLm1I
         patNIKuygCnp3PTHV2mahcsJCqMGBSdAwL7GueOX4by3l5wtVyo5IVNgfV+T5LCB7SWu
         i2SwnpSuLtqXv7GiHWHj0GZ3puzTTs0ESjgDy1pHsEUcWpLTb222r6t788ZbRMu8RF8g
         D0butNa2IKuKXGqkdVdWfe5kn5PnHKB77y6Jbx+UYGFF5m8/HBQeDgOa4gDFwGykb+P5
         Ip2UcQF6oZtQtb/DK81lau6Qj8tzQ6T88DZVjgUzW0GkUZhH4GnTTQz/oVb3m5XvBvVc
         ivtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q8DAJtYz7gOythokjolokFTN1usdBfwvBMaSNa//VR8=;
        b=rfzh69nssX+NRxRMOc6/G+hMmFHuCplh+CWUNx4lJcZg8ETdfHq27XSEKgQaHTRiO9
         0IOUotSwSZsY7vN85OeGRSwriIgQnEdDm1zJTA+3Ia7WXeQWaxxp3TA0kkX/7+W7xw/i
         Obdw0eUjfsjoJ+qePzRAgYGxjXYknq+GTUsZlRuJKPa9SdKD9sg5fJCIso82GtrV4luQ
         2aHlbxp8r/cUDHuR/ishrU/eX4yKvkaVq8zS8YcbYL8l1HljGVRIKrXZ4Hdq3aDHuScf
         7G8oxrrEAAhlUDFmMlYS8NkBKaWSEnTzUBH0UpTDVrOBQzqKaz2ZPznYRoDPzgGHGmMW
         Kh2g==
X-Gm-Message-State: AOAM5336TQElDh1yb/qdp5lQYO/hcTdcx1r/xMe7PZMQEjK53CjWFiyI
        z6VFz0FW/TB4mCxkSEfXwNIPbdyyXym9RldyrX4=
X-Google-Smtp-Source: ABdhPJz8m3C8XVLH5i4RJnx+NNkBL3hLZCTdIMwLJn9CK3Kg06b8olhWRJt+0ws3hUSr8Pec1Ex2i0TnFReMlaqer2A=
X-Received: by 2002:adf:a34d:: with SMTP id d13mr2916009wrb.270.1591690316914;
 Tue, 09 Jun 2020 01:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
 <70458451-6ece-5222-c46f-87c708eee81e@strongswan.org>
In-Reply-To: <70458451-6ece-5222-c46f-87c708eee81e@strongswan.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 9 Jun 2020 16:19:57 +0800
Message-ID: <CADvbK_cw0yeTdVuNfbc8MJ6+9+1RgnW7XGw1AgQQM7ybnbdaDQ@mail.gmail.com>
Subject: Re: [PATCHv2 ipsec] xfrm: fix a warning in xfrm_policy_insert_list
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Yuehaibing <yuehaibing@huawei.com>,
        Andreas Steffen <andreas.steffen@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 a, .

On Mon, Jun 8, 2020 at 8:02 PM Tobias Brunner <tobias@strongswan.org> wrote:
>
> Hi Steffen, Xin,
>
> This change could be problematic.  Actually, it's not really this one
> but the original one that causes the issue:
> > Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
>
> However, because the code in xfrm_policy_mark_match() treated policies
> with the same mark/mask equal without considering the priority before
> this change, it wasn't apparent.  The problem is that the code can now
> lead to duplicate policies, which can not correctly be removed or queried.
It's a problem that can't be removed, but not for being queried.

>
> That's because the priority is sent only in xfrm_userpolicy_info, which
> XFRM_MSG_NEWPOLICY and XFRM_MSG_UPDPOLICY expect, but not in
> xfrm_userpolicy_id, which is used to query and delete policies with
> XFRM_MSG_GETPOLICY and XFRM_MSG_DELPOLICY, respectively (the mark is
> sent with a separate attribute, which can be supplied to all commands).
>  So we can only query/delete the duplicate policy with the highest
> priority.  Such duplicates can even be created inadvertently via
> XFRM_MSG_UPDPOLICY if the priority of an existing policy should be
> changed, which worked fine so far.
priority doesn't exist in xfrm_userpolicy_id, and we can add
XFRMA_PRIORITY like XFRMA_MARK to fix it.
since we also take priority to make a policy unique, we can't update
this attribute.

>
> The latter currently happens when strongSwan e.g. replaces a trap or
> block policy with one that has templates assigned (those we install with
> a higher priority, by default), which uses XFRM_MSG_UPDPOLICY that
> doesn't update the existing policy anymore but creates a duplicate
> instead.  Since only one XFRM_MSG_DELPOLICY is sent later when the
> policy is deleted, a duplicate policy remains (and we couldn't even
> delete the exact policy we wanted - the trap might be removed by the
> user before the regular policy - due to the missing priority field in
> xfrm_userpolicy_id).
I see.

>
> I guess we could workaround this issue in strongSwan by installing
> policies that share the same mark and selector with the same priority,
> so only one instance is ever installed in the kernel.  But the inability
> to address the exact policy when querying/deleting still looks like a
> problem to me in general.
>
For deleting, yes, but for querying, I think it makes sense not to pass
the priority, and always get the policy with the highest priority.

We can separate the deleting path from the querying path when
XFRMA_PRIORITY attribute is set.

Is that enough for your case to only fix for the policy deleting?
