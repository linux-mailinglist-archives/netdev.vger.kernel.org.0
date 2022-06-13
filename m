Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B60549C2F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343611AbiFMSwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245616AbiFMSwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:52:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDB83CFDC
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 08:53:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so6329269pjb.3
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 08:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2GbAzwYBGIAdGpmUitTP78WCtQDJfOSlirBrPIPUJV8=;
        b=m3ONiZU+Rou5uFM8Eo43NO6t1p7xohN4UsrO9zzqfd2t5DSYZF6aCyNo1PAEp4wGy4
         mGb30oww3a1gWPumw6dGcs+YAvtJSUSawhqQyB4TG+Gy0c8AmMEnVCl4g0gBqBTpFYHr
         hplz9lwGhl6cXOpvxYPhhEgk8QIhI6pLJ/vVDf+s7QNuXGSrPUm9CubDqvm1eaJ+n9pY
         aIKfqoNmGg66euRy4TPmYoGq044fdfvFQVAVvyJXRiG2S4+aS2w8Fq1mE+KKD5PJovGl
         2w5DZWherj/mZ1dVBZUeGojVIPIjXSsiBotJL8ltyJycwKBhruNHmOyPm+H0lA1wm/6c
         j31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GbAzwYBGIAdGpmUitTP78WCtQDJfOSlirBrPIPUJV8=;
        b=Yh8RDHXw1RflLsUM93Y+Ek2PZE5W8M8EiEknio/aCy5toW6bvyXZYKfdyOBwGvPSoS
         cB2yTGTxAjyp8tRUX1HLKXEIGMTUEDtSAQmQmcb15wzq498WjyMXbLDyyCPpkcXJBp19
         QbdX7Y6Ro9ruRxaEjEab445z+aw+ld1Wa8pLLNO+Qo+VOvxGDfP1s7XOE3iJksdrGaJD
         G0c/0jYcrvFzj6qf8dHSieZL337ULs1XiIKOsvQfXtdFBGJ4U6g/quDFvd8A5iTPbYGu
         IDQP7e8SwXi4J7Z+/Ze3G/6XH51d11UH5qv+yQseWJ7wyZiD51HcaWtUVAEZjRFyn43N
         s2eA==
X-Gm-Message-State: AOAM532FTh43ZBIQkUMMS5gkpsDCdhFsB21b11DtSOaPIf2ScF5HtahW
        TVQN0cE+Ptes3N7yFIdThLqz6O+cYieriLqhQ2zscaPlXCs=
X-Google-Smtp-Source: ABdhPJwLvjhNA4wdh9PO/0kLpiWDSG4Sg8BkodLfb2uzxEvf+kazkBVqDJpJmcve/BAAaS7b4YKa91joEJt/KhvkX5U=
X-Received: by 2002:a17:90b:380b:b0:1e6:67f6:f70c with SMTP id
 mq11-20020a17090b380b00b001e667f6f70cmr16244566pjb.120.1655135635925; Mon, 13
 Jun 2022 08:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com> <20220610165803.2860154-10-sdf@google.com>
 <a0ebf40e-6c21-435e-0d87-bca7a2113241@isovalent.com>
In-Reply-To: <a0ebf40e-6c21-435e-0d87-bca7a2113241@isovalent.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 13 Jun 2022 08:53:44 -0700
Message-ID: <CAKH8qBudovmLGuBiTBXXu_TZkev-mBbTtz1fqdsqsk61uMAWiQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 09/10] bpftool: implement cgroup tree for BPF_LSM_CGROUP
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 5:08 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-06-10 09:58 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> > $ bpftool --nomount prog loadall $KDIR/tools/testing/selftests/bpf/lsm_cgroup.o /sys/fs/bpf/x
> > $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_alloc
> > $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_bind
> > $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_clone
> > $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_post_create
> > $ bpftool cgroup tree
> > CgroupPath
> > ID       AttachType      AttachFlags     Name
> > /sys/fs/cgroup
> > 6        lsm_cgroup                      socket_post_create bpf_lsm_socket_post_create
> > 8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind
> > 10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security
> > 11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone
> >
> > $ bpftool cgroup detach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_post_create
> > $ bpftool cgroup tree
> > CgroupPath
> > ID       AttachType      AttachFlags     Name
> > /sys/fs/cgroup
> > 8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind
> > 10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security
> > 11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
> The changes for bpftool look good to me, thanks!
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thank you for the review!

> > ---
> >  tools/bpf/bpftool/cgroup.c | 80 +++++++++++++++++++++++++++-----------
> >  1 file changed, 58 insertions(+), 22 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
> > index 42421fe47a58..6e55f583a62f 100644
> > --- a/tools/bpf/bpftool/cgroup.c
> > +++ b/tools/bpf/bpftool/cgroup.c
>
> > @@ -542,5 +577,6 @@ static const struct cmd cmds[] = {
> >
> >  int do_cgroup(int argc, char **argv)
> >  {
> > +     btf_vmlinux = libbpf_find_kernel_btf();
> >       return cmd_select(cmds, argc, argv, do_help);
> >  }
>
> This is not required for all "bpftool cgroup" operations (attach/detach
> don't need it I think), but should be inexpensive, right?

Good point, let's move it close to the place where we use it
regardless of whether it's expensive or not.
