Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEF8647A4A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 00:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLHXqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 18:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLHXqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 18:46:07 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FB0EA
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 15:46:01 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p24so3121591plw.1
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 15:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sm8OWFrvWQaS6H9xrHvPh1htLWtKmKkj+nrb35AKVrk=;
        b=D2e2V1iieBFHio2OsHZaVCyOeG45+/qZ+cdKD5J5/yOJB0c6+ZSxMEKPyTaPR+wPAO
         mbuHXoYELeSjFhP6JKrA61pthNzve46uS3LCf9ZRQDzAIA5Cn693fwk+6aTTdeChQbMp
         vTKC2AhdN8pKe/PqqVaAoyagMC6xqBTxKR19PmoFA52gXfIMXiMC4BN+yMhy0uDWmlU5
         Qnv1dc8n9aK1oxw8wQPuSolhIdpRQnPb5DF5tLuQTwGsi2dT8T83MyFcTH0DCN7VlZz4
         uCZYi5AMyK6kw+ulRH0Jw+fuIH41Dr6IlSU++BM/yiYKXFmVVwPZzEwZPW8sMAfacI6s
         856Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sm8OWFrvWQaS6H9xrHvPh1htLWtKmKkj+nrb35AKVrk=;
        b=g7M3YCUcdQ9n4iCM9Sw/pcNAq8pABB9abNnNp6XTXLB5Qt3dNqDV/2eJSNmlP/ySzC
         g0Js7Rn1B46+1PCPsu4pR3V1oZ75mQPxgAfExBjureiAy3EEBVG6Nsoa0svtL8IKgMJD
         tLzfVEaWFPrDw1VQioYAzem4/jlI5aUgOjgKdlkEX0yjZOiXlQcWYdPWN9CzOVEHV1Wv
         jwvirls1M+jGStrZQSlv8CHnlWjzUJxE8K8AHhJdhtErkuPnQWZjuA00X8zILlFSxku6
         9qK3UFXTF0B5AhXknXqBFkqKMdRuSJfHy/qGbS9SbjG0/LsMErwJWKywhBV1jliHGKUF
         VQ6g==
X-Gm-Message-State: ANoB5pnzoFM+6nlviWLhFjnTZ2bTRljnaC3ZdDSiJfi/X186CWe690HB
        3mBBH9iR9tPB3m48YcoaaSC+T0L9fF/iz1BvTOlMKw==
X-Google-Smtp-Source: AA0mqf71LHOqUi6G/gW4y3OPGyoVlC3ndfi32vjtlQwBVRcYyxG4dYg5Jw7MX9r9cKx78860x1sOK0N7h6XkWTZbkq0=
X-Received: by 2002:a17:90a:930f:b0:218:9107:381b with SMTP id
 p15-20020a17090a930f00b002189107381bmr97468563pjo.75.1670543161020; Thu, 08
 Dec 2022 15:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <391b9abf-c53a-623c-055f-60768c716baa@linux.dev> <CAKH8qBvfNDo-+qB-CyvCjQAcTtftWoQJTPwVb4zdAMZs=TzG7w@mail.gmail.com>
 <a5a636cc-5b03-686f-4be0-000383b05cfc@linux.dev>
In-Reply-To: <a5a636cc-5b03-686f-4be0-000383b05cfc@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 15:45:49 -0800
Message-ID: <CAKH8qBuofrVpd6PkMuZ2aSFna72Mx572ebsOEdTcQFDoHBGFiQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 2:53 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/8/22 11:07 AM, Stanislav Fomichev wrote:
> >>> @@ -102,11 +112,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >>>        if (err)
> >>>                goto err_maybe_put;
> >>>
> >>> +     prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_HAS_METADATA);
> >>> +
> >>
> >> If I read the set correctly, bpf prog can either use metadata kfunc or offload
> >> but not both. It is fine to start with only supporting metadata kfunc when there
> >> is no offload but will be useful to understand the reason. I assume an offloaded
> >> bpf prog should still be able to call the bpf helpers like adjust_head/tail and
> >> the same should go for any kfunc?
> >
> > Yes, I'm assuming there should be some work on the offloaded device
> > drivers to support metadata kfuncs.
> > Offloaded kfuncs, in general, seem hard (how do we call kernel func
> > from the device-offloaded prog?); so refusing kfuncs early for the
> > offloaded case seems fair for now?
>
> Ah, ok.  I was actually thinking the HW offloaded prog can just use the software
> ndo_* kfunc (like other bpf-helpers).  From skimming some
> bpf_prog_offload_ops:prepare implementation, I think you are right and it seems
> BPF_PSEUDO_KFUNC_CALL has not been recognized yet.
>
> [ ... ]
>
> >>> @@ -226,10 +263,17 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
> >>>
> >>>    void bpf_prog_offload_destroy(struct bpf_prog *prog)
> >>>    {
> >>> +     struct net_device *netdev = NULL;
> >>> +
> >>>        down_write(&bpf_devs_lock);
> >>> -     if (prog->aux->offload)
> >>> +     if (prog->aux->offload) {
> >>> +             netdev = prog->aux->offload->netdev;
> >>>                __bpf_prog_offload_destroy(prog);
> >>> +     }
> >>>        up_write(&bpf_devs_lock);
> >>> +
> >>> +     if (netdev)
> >>
> >> May be I have missed a refcnt or lock somewhere.  Is it possible that netdev may
> >> have been freed?
> >
> > Yeah, with the offload framework, there are no refcnts. We put an
> > "offloaded" device into a separate hashtable (protected by
> > rtnl/semaphore).
> > maybe_remove_bound_netdev will re-grab the locks (due to ordering:
> > rtnl->bpf_devs_lock) and remove the device from the hashtable if it's
> > still there.
> > At least this is how, I think, it should work; LMK if something is
> > still fishy here...
> >
> > Or is the concern here that somebody might allocate new netdev reusing
> > the same address? I think I have enough checks in
> > maybe_remove_bound_netdev to guard against that. Or, at least, to make
> > it safe :-)
>
> Race is ok because ondev needs to be removed anyway when '!ondev->offdev &&
> list_empty(&ondev->progs)'?  hmmm... tricky, please add a comment. :)
>
> Why it cannot be done together in the bpf_devs_lock above?  The above cannot
> take an extra rtnl_lock before bpf_devs_lock?

Hm, let's take an extra rtln to avoid this complexity, agree. I guess
I was trying to avoid taking it, but this path is still 'dev_bound ==
true' protected, so shouldn't affect the rest of the progs.
