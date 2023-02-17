Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CB969B22A
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 19:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBQSBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 13:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBQSBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 13:01:53 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCB42CC71
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 10:01:53 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b20so1047128pfi.9
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 10:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6SRhPAA13aLvtcISjEh7UNd45/KaCXdcpSYC0/o7Tko=;
        b=fdGbWL0JuTEOclQuBV2JDCcz0weSJGNcRgguRpKPNklY/BdiEbwNBF0IhT41oRQaQS
         5rAR9TO2DViX53mqj9/G6g5xonhnNCrCRFn1XiH0qGpdKZLI6IT7Ed6qF7yrsQwjRp0B
         GgPF/YG36JvZAsjBxlFgS5LqY49VSD7vgQoFlyfsJPsFoYrz7wZ67llYS7gdgsFru8yT
         Z3eYvhfyzASEEBlTmaeBvcaBZ2A20LnjZCgPOct1V31wL8svEfTcNujSHsDgS5R3HtAo
         sYUBHkspNwh46hbgOjeGiNV+HTKp/S/yRQkX3RTFSNOLqZrUdRM4OS/HfEteMSPw1Vgc
         +Hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6SRhPAA13aLvtcISjEh7UNd45/KaCXdcpSYC0/o7Tko=;
        b=A7Qi4zh/KEVWmJUPtiS4h/tT0o7qwSNQPt41kRBQ91AQjVdfOKN/kmPgViMdjBZapt
         2WHvzA6G/XPGMIOcQxKDSS3JPr29ay6CqmPKll+iKdJeFRyo1doh/doPkrxhHuSD0mbU
         5jmkiLBP2cyuJLhkbt8XHYRhhhnlKPpcO62ZNN23Qy+x7RzQPfqFORmHYXjiUZdOY2vg
         JvGQi3n06BG/KSw8HbAF1NVo5+sOkLa6qCgWeVO01JYKou6f7DfkPQVGXKXV22T9him/
         OjROT5zRhSFjoU1j4OY7fDb4OIRMz4ZZ/tKEJqB/06eQ2ETLbtbCzLSrwGTNZqKO3tEq
         8QEg==
X-Gm-Message-State: AO0yUKWIPh3XADjcqid+hDgSiPWq9AF4b13R8bZpBp2U5LN4fVb8vf0w
        EwT4AOCTiBsH7TGnMg3v2vC6lYRDp+PHF4YuIwPU5w==
X-Google-Smtp-Source: AK7set8RB8tCn0RLfyoUEz55zl/eOunKJ0SjnWLmsTgX0hArxXzp9JM0TPyn/3jcShUR9vTgPkQDPzaETF1RFPDb7Mo=
X-Received: by 2002:a63:3644:0:b0:4ce:caaa:2696 with SMTP id
 d65-20020a633644000000b004cecaaa2696mr298227pga.1.1676656912332; Fri, 17 Feb
 2023 10:01:52 -0800 (PST)
MIME-Version: 1.0
References: <167663589722.1933643.15760680115820248363.stgit@firesoul>
 <Y++6IvP+PloUrCxs@google.com> <514bb57b-cc3e-7b7e-c7d4-94cdf52565d6@linux.dev>
 <CAKH8qBujK0RnOHi3EH_KwKamEtQRYJ6izoYRBB2_2CQias0HXA@mail.gmail.com> <eed53c45-84c4-9978-5323-cede57d9d797@linux.dev>
In-Reply-To: <eed53c45-84c4-9978-5323-cede57d9d797@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 17 Feb 2023 10:01:40 -0800
Message-ID: <CAKH8qBvwPA_VaHfwqzPN4SNFqCTgVFWH9zMj0LXio_=8Dg3TOw@mail.gmail.com>
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

On Fri, Feb 17, 2023 at 9:55 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 2/17/23 9:40 AM, Stanislav Fomichev wrote:
> > On Fri, Feb 17, 2023 at 9:39 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >>
> >> On 2/17/23 9:32 AM, Stanislav Fomichev wrote:
> >>> On 02/17, Jesper Dangaard Brouer wrote:
> >>>> With our XDP-hints kfunc approach, where individual drivers overload the
> >>>> default implementation, it can be hard for API users to determine
> >>>> whether or not the current device driver have this kfunc available.
> >>>
> >>>> Change the default implementations to use an errno (ENODEV), that
> >>>> drivers shouldn't return, to make it possible for BPF runtime to
> >>>> determine if bpf kfunc for xdp metadata isn't implemented by driver.
> >>>
> >>>> This is intended to ease supporting and troubleshooting setups. E.g.
> >>>> when users on mailing list report -19 (ENODEV) as an error, then we can
> >>>> immediately tell them their device driver is too old.
> >>>
> >>> I agree with the v1 comments that I'm not sure how it helps.
> >>> Why can't we update the doc in the same fashion and say that
> >>> the drivers shouldn't return EOPNOTSUPP?
> >>>
> >>> I'm fine with the change if you think it makes your/users life
> >>> easier. Although I don't really understand how. We can, as Toke
> >>> mentioned, ask the users to provide jited program dump if it's
> >>> mostly about user reports.
> >>
> >> and there is xdp-features also.
> >
> > Yeah, I was going to suggest it, but then I wasn't sure how to
> > reconcile our 'kfunc is not a uapi' with xdp-features (that probably
> > is a uapi)?
>
> uapi concern is a bit in xdp-features may go away because the kfunc may go away ?

Yeah, if it's another kind of bitmask we'd have to retain those bits
(in case of a particular kfunc ever going away)..

> May be a list of xdp kfunc names that it supports? A list of kfunc btf id will
> do also and the user space will need to map it back. Not sure if it is easily
> doable in xdp-features.

Good point. A string list / btf_id list of kfuncs implemented by
netdev might be a good alternative.
