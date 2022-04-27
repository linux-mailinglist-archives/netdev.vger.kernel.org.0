Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548A55120AE
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbiD0Q4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243545AbiD0Qzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:55:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F24857143
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:52:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so2246354pjf.0
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vykJS+GCN4oOt/wUy0V+c72rmxebQEGqa0biVVI0j7Y=;
        b=j3R3a5/JnI6fvngAk0q+6VHP/6OI5UNIT6V+w+qj8VLfcmJqtjseEGtXfaFyizk/IX
         PU/q6OweVYApqtV+lBDouzWxtm9XMMTYRudgUBSWgiCEQeTgIfT9DYFKVpCH58w1ERBM
         7W5wA9x7X+j9QfaBRhyL2NKcYQLcxBJnX91rFinU+EE0JN6Yw0stS+Z5kOjleeuUHa2K
         JNrPLV5o8eERREFVn8dvNtQ1ddpTpcbK8yoa2y4mPAEolJ6zRBFHuOgsBd3YU6axaQCy
         LPZoUV3EUZ91yfLwtV5EQqd8BqSXjuWij1ldNudI+1JBYK35W2Fqwb/G6hIzlIzOXgYG
         kQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vykJS+GCN4oOt/wUy0V+c72rmxebQEGqa0biVVI0j7Y=;
        b=n+QHafh3MCLXMTZH3gIfnqQPgIEVPhaBGqfkcbw670nMWrCfcaH7O7tfXImmkiqWJs
         MZzlJOl0qOTxd77IYPkwewlszGUdc4uFTC+1yol2mIJntTU/mrvkFT2748YZvVtxDOxl
         i/GE5BVjNPCVCHOr8VlUfZsDGV0IRDd0gk2FEscQACqtFNhXFuyZDTJD9shlEHr2LWo+
         mdlNYbI7Qkn2icx6UpR+wGVeH3+luSHOC8XqoNlwEHJ3yeFkAUhvYjnIoA+vaTkCAFkA
         lCK3K40xWIriivbwQc8IMOdoQjasDGHMgxrI0tZaI75QJHbQnUJz29iJelh1tYrArePV
         vmBA==
X-Gm-Message-State: AOAM5338mTFMBFgPXPik2YfHYa7Dp2k3NfkhSobaMM+U1zelQcz4ZB8z
        I7cKhe7AoeqGLpwphBlt8/8h8Mm7oyLm6z4N3H0oew==
X-Google-Smtp-Source: ABdhPJynB6sYUtZFPdStewPZKGT5epF0dIPoGZdrNxMD84yqLEGZmSKWqxNKgf+xK/hNaVlFgP0oEpszN7CABQTTRVo=
X-Received: by 2002:a17:902:b094:b0:15c:dee8:74c8 with SMTP id
 p20-20020a170902b09400b0015cdee874c8mr24420474plr.6.1651078356628; Wed, 27
 Apr 2022 09:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org> <20220427140153.GC9823@blackbody.suse.cz>
In-Reply-To: <20220427140153.GC9823@blackbody.suse.cz>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 27 Apr 2022 09:52:25 -0700
Message-ID: <CALvZod6Dz7iw=gyiQ2pDVe2RJxF-7PbVoptwFZCw=sWtxpBBGQ@mail.gmail.com>
Subject: Re: [PATCH] memcg: accounting for objects allocated for new netdevice
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     Vasily Averin <vvs@openvz.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 7:01 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> Hello Vasily.
>
> On Wed, Apr 27, 2022 at 01:37:50PM +0300, Vasily Averin <vvs@openvz.org> =
wrote:
> > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> > index cfa79715fc1a..2881aeeaa880 100644
> > --- a/fs/kernfs/mount.c
> > +++ b/fs/kernfs/mount.c
> > @@ -391,7 +391,7 @@ void __init kernfs_init(void)
> >  {
> >       kernfs_node_cache =3D kmem_cache_create("kernfs_node_cache",
> >                                             sizeof(struct kernfs_node),
> > -                                           0, SLAB_PANIC, NULL);
> > +                                           0, SLAB_PANIC | SLAB_ACCOUN=
T, NULL);
>
> kernfs accounting you say?
> kernfs backs up also cgroups, so the parent-child accounting comes to my
> mind.
> See the temporary switch to parent memcg in mem_cgroup_css_alloc().
>
> (I mean this makes some sense but I'd suggest unlumping the kernfs into
> a separate path for possible discussion and its not-only-netdevice
> effects.)
>

I agree with Michal that kernfs accounting should be its own patch.
Internally at Google, we actually have enabled the memcg accounting of
kernfs nodes. We have workloads which create 100s of subcontainers and
without memcg accounting of kernfs we see high system overhead.
