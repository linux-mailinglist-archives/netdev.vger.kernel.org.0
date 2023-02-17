Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7BC69B1F0
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBQRk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBQRk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:40:57 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8970872E19
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 09:40:56 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id f11so1139363pfj.11
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 09:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ubunDlU9msRDy+3uOkSF8XjE+wanE2T00XUNyd5oMi4=;
        b=n7JsjgktBMNQx/ldOcn9KJaPpxJY8SsZEOiU4Xo1R4zL6ExHCOj0Yj94XdW0J66mvc
         USpev9GnAFcZtOZrFrFbEKgWVItPVm6PYkyYUJRLjORlAKa83SlKVotqPfp8WaG9cIUx
         qXAxZkqcTRxCov0aQFpciyQLpCEcMzRXRNlL83ghhehWjmdfdXorYwDUcmx7oa9gRVPT
         siLvPyM+Zin7onvBc/X/dw4d8P3VJ1OQdX2VxRshwJRPM1xgejIi1lPHsk8IvhG/+orq
         ux52+anRax9gUa37WsbHP4ux/5sqBgefE8Wbf/igMNI/iC3pKuxoqaE1StOSuiq0dcqC
         RPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubunDlU9msRDy+3uOkSF8XjE+wanE2T00XUNyd5oMi4=;
        b=YVZktB0cn6jcV7aVRdpC5Ngkuj8CV+kDwTHZt/SoRsXbv+WBxXD2DpaffR/Zw8Qw0G
         H28ivzoFeQAbmPwX5fKWH0JxCAfyPeFj+MmhxarZA3ZhGB7ET3KaEA2mFMX2BSQHlisR
         uDTL8Kq3b6xxSR4HcBGB8t/QDcqflmdPOguGErSkTiMISvLmor1/PRkG1pY2Mzu2lt64
         46yl/XCF7qawK8ShiiIasBEVBVzb84s4HZ7u91A3/fEyksfQPQoihSFw/80QA1hQT9om
         1jdk38QwZP7DvzrytVhwFq7tUOzs9v5/Ot7BiJVcNh7Sfv1i475jXFkpic2hsa5l5q1P
         uqrA==
X-Gm-Message-State: AO0yUKWEs9pLpHcq0pBOnlXGGsfBC0Xbb769Qjre/enppYBWGiB7BnBT
        gXe6+8m4aDuPd/KiZoPJ2K2FeP6hn1caG31Dp9/TjQ==
X-Google-Smtp-Source: AK7set9SoDrlXc7kV0zAOGDzQwuHDlEYDM53FMBDlAsUKbE7egGCacsLce+wVUlPMffrnZ2XuTtPYBwCiEM8EXodpG4=
X-Received: by 2002:aa7:8642:0:b0:5a9:c941:43d2 with SMTP id
 a2-20020aa78642000000b005a9c94143d2mr579538pfo.16.1676655655824; Fri, 17 Feb
 2023 09:40:55 -0800 (PST)
MIME-Version: 1.0
References: <167663589722.1933643.15760680115820248363.stgit@firesoul>
 <Y++6IvP+PloUrCxs@google.com> <514bb57b-cc3e-7b7e-c7d4-94cdf52565d6@linux.dev>
In-Reply-To: <514bb57b-cc3e-7b7e-c7d4-94cdf52565d6@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 17 Feb 2023 09:40:44 -0800
Message-ID: <CAKH8qBujK0RnOHi3EH_KwKamEtQRYJ6izoYRBB2_2CQias0HXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2] xdp: bpf_xdp_metadata use NODEV for no device support
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, martin.lau@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 9:39 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 2/17/23 9:32 AM, Stanislav Fomichev wrote:
> > On 02/17, Jesper Dangaard Brouer wrote:
> >> With our XDP-hints kfunc approach, where individual drivers overload the
> >> default implementation, it can be hard for API users to determine
> >> whether or not the current device driver have this kfunc available.
> >
> >> Change the default implementations to use an errno (ENODEV), that
> >> drivers shouldn't return, to make it possible for BPF runtime to
> >> determine if bpf kfunc for xdp metadata isn't implemented by driver.
> >
> >> This is intended to ease supporting and troubleshooting setups. E.g.
> >> when users on mailing list report -19 (ENODEV) as an error, then we can
> >> immediately tell them their device driver is too old.
> >
> > I agree with the v1 comments that I'm not sure how it helps.
> > Why can't we update the doc in the same fashion and say that
> > the drivers shouldn't return EOPNOTSUPP?
> >
> > I'm fine with the change if you think it makes your/users life
> > easier. Although I don't really understand how. We can, as Toke
> > mentioned, ask the users to provide jited program dump if it's
> > mostly about user reports.
>
> and there is xdp-features also.

Yeah, I was going to suggest it, but then I wasn't sure how to
reconcile our 'kfunc is not a uapi' with xdp-features (that probably
is a uapi)?
