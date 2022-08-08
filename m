Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4068A58CE7B
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244425AbiHHTQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244345AbiHHTQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:16:30 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6777E105
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 12:16:28 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-10bd4812c29so11573701fac.11
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 12:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=tTjklP3N0xHZTapO1AHhc2qFb7IfKSUYUkpCWo6nNBY=;
        b=ZSOKztoCgboaGeteudYq4N3KYqQ8UIgYnji3gooMEzV5IRLYEh+XF1ZRfuD0EGQrGF
         /E5OcSx0xKOH11XrTJPWF+sWMQaMqK/KIw2Gn/HV+UkLhhIPbxsCiCVYwrHYOygGXOwp
         ysmzW9/YW9ZTCzsJ5xmf0IynMV0hA+2Wlu3q79QKSXFYtbzcxOixwKNLFB0KJirPHRAL
         NLod93cpmJ39y5iOiEmfdQlJoAQMc9YkzV6IaGtgO7QtNR6QLA8ZVCKk3n3rzMOb0QFT
         gp0dVQ7ArUGhq7F2E/q+wXMZN5JYN2YUZY594kavlTlFPRiqBWRKPPywn8ogyCZaDdmL
         JOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tTjklP3N0xHZTapO1AHhc2qFb7IfKSUYUkpCWo6nNBY=;
        b=so2U9/ybpHBJxW4DvcrWLRAjqekqHHeSiSmvdNZl0dEX072KVGwfVvMJzf3jbY3wNs
         fXZpUFkz1qmCh3ydHLVs/2qbtjqhAoSlEbAz1341NaZKn3VQk19aufXjFt2bjq69e129
         HoO5uFQ9MV0vCrqznXcBwMrZF3k4p0vbS58hLvxpjq2cNSFflALViGByiK2hxbBAzrTp
         FmzaWu7xDsjKGesfo9/0wnH5NsJ1QHXDITEjQOpCTKfpUvjXo4smWK9arVZ940pBOf0h
         L41keDfefPL+k6HKo3NoY22xyfkGAxWh4s45XIutlea/pXDt3k36w7p9/uWuN5TqOpqC
         TNag==
X-Gm-Message-State: ACgBeo3gaR55kX2osP4sh2o2gLl+adt0vnVzENqZMag3K9P0aJDj0lNl
        QQOf8hEE8kPzNgApic3g5Gk0tYe9iuB7T5x7KySDE7NN9w==
X-Google-Smtp-Source: AA6agR7Aw2cmXn+MTX3OJNveQNvS7hRoJuqGGAJUvFdZ+o5Hkr7Sb0J1aD17Nf+ppmZUi+oakuDbzPdW9LVLREpdZNw=
X-Received: by 2002:a05:6870:9588:b0:101:c003:bfe6 with SMTP id
 k8-20020a056870958800b00101c003bfe6mr12980423oao.41.1659986187604; Mon, 08
 Aug 2022 12:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com> <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 8 Aug 2022 15:16:16 -0400
Message-ID: <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 8, 2022 at 2:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Paul Moore <paul@paul-moore.com> writes:
> > On Mon, Aug 1, 2022 at 10:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Frederick Lawler <fred@cloudflare.com> writes:
> >>
> >> > While creating a LSM BPF MAC policy to block user namespace creation, we
> >> > used the LSM cred_prepare hook because that is the closest hook to prevent
> >> > a call to create_user_ns().
> >>
> >> Re-nack for all of the same reasons.
> >> AKA This can only break the users of the user namespace.
> >>
> >> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >>
> >> You aren't fixing what your problem you are papering over it by denying
> >> access to the user namespace.
> >>
> >> Nack Nack Nack.
> >>
> >> Stop.
> >>
> >> Go back to the drawing board.
> >>
> >> Do not pass go.
> >>
> >> Do not collect $200.
> >
> > If you want us to take your comments seriously Eric, you need to
> > provide the list with some constructive feedback that would allow
> > Frederick to move forward with a solution to the use case that has
> > been proposed.  You response above may be many things, but it is
> > certainly not that.
>
> I did provide constructive feedback.  My feedback to his problem
> was to address the real problem of bugs in the kernel.

We've heard from several people who have use cases which require
adding LSM-level access controls and observability to user namespace
creation.  This is the problem we are trying to solve here; if you do
not like the approach proposed in this patchset please suggest another
implementation that allows LSMs visibility into user namespace
creation.

-- 
paul-moore.com
