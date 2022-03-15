Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0E84DA496
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243078AbiCOV1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbiCOV1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:27:31 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9445B3F8;
        Tue, 15 Mar 2022 14:26:19 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m22so605042pja.0;
        Tue, 15 Mar 2022 14:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AgiufUcNSkqSYjEMYoVF1eFnNJ5bJbQWk4kq/nS0YKs=;
        b=nhwGDm/qv2kweSS2ESjtlnDLeLPwCNiXfuSQK21JvDNH5aAl264dy58dXEv+Qp9xy3
         3TM7S4w0uzic57e6OehdILxj9ErYNrartsdAgSrEysc7JaJZNhTg4iPbM2OdLT2i1UW7
         s/tkW98RZR8ujS1oU6FZTZpZpOIDuWz4Q19lt9iGs5xpPw6lJVvK2oXpkotDKtcFO0KU
         q5azdvnkbliL6CIgLY1JoIqPC4yKmlhWzRxUe5u6u6WhGDJM01G+yKPyLDMzQjcxqDQP
         x2NfHQPckc19lrdNCPVJbpEdGSa3kaTtNWeRvgwbUastuzIdbOYvAjFYH6gCK+DuBINY
         aHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AgiufUcNSkqSYjEMYoVF1eFnNJ5bJbQWk4kq/nS0YKs=;
        b=rAkwr4g1VvQ0qQcHges0peMg9nB5qhxjebunRY3iWIxbqN3A7SSpXcddTeRW6pYsUZ
         FF0KJicm22gxLC0HLj8SpFmFhUGpsHmEdN0Qq8cwsqbOHKh7eSrw8kVrvAvMg5fsXSmi
         8Rr8gC303RKCiY2aTq+cTzpBFai/6Z9WpRPkghgmjdO8pFyF/VJFOKJ5bQS40ZarbZsy
         X8Vi8laQ3moQI+iazpOXMoRuj1UBUaEeCIoi5pv4tj1NCTQjNwcn6CRUMBiZJ8So7GT8
         wiaEwviGEU+tJrDb9WE/M5aI6tP+UWVib69H26/WZE4M3zCJXoVqOBBZAoiAmsPAXAND
         j/dw==
X-Gm-Message-State: AOAM532jFUQFCDp+BHcXFEbmvuvbzMoDvtg8MYm1fzyVw7Rj+faDVmmi
        i/VI4LN7iQ4KoEMJGWbBehe9PCxGPZ2/dLIYPRs=
X-Google-Smtp-Source: ABdhPJxlBlhTpnj8c1670gIqMf33cVd9YblzgqSo0nAQy04YjHVVL06wRmgbQfccow3jJQR0vJ/HoqXW8FMMLZypxn8=
X-Received: by 2002:a17:90b:4a82:b0:1c6:13fa:6210 with SMTP id
 lp2-20020a17090b4a8200b001c613fa6210mr6704706pjb.117.1647379578503; Tue, 15
 Mar 2022 14:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220222105156.231344-1-maximmi@nvidia.com> <DM4PR12MB51508BFFCFACA26C79D4AEB9DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
 <CAADnVQKwqw8s7U_bac-Fs+7jKDYo9A6TpZpw2BN-61UWiv+yHw@mail.gmail.com> <DM4PR12MB51501E2FEDF409170BEA3AF3DC0F9@DM4PR12MB5150.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB51501E2FEDF409170BEA3AF3DC0F9@DM4PR12MB5150.namprd12.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Mar 2022 14:26:07 -0700
Message-ID: <CAADnVQKasn7ZDM8FYu67FM8FzMyQPqyP=1gYvqaYQBfMkM3pbA@mail.gmail.com>
Subject: Re: [PATCH bpf v3] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 10:49 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> > -----Original Message-----
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> >
> > On Fri, Mar 11, 2022 at 8:36 AM Maxim Mikityanskiy <maximmi@nvidia.com>
> > wrote:
> > >
> > > This patch was submitted more than two weeks ago, and there were no new
> > > comments. Can it be accepted?
> >
> > The patch wasn't acked by anyone.
> > Please solicit reviews for your changes in time.
>
> Could you elaborate? I sent the patch to the mailing list and CCed the
> relevant people. That worked for v1 and v2, I received comments,
> addressed them and sent a v3. What extra steps should I have done to
> "solicit reviews"? What shall I do now?

cloudflare folks are original authors of this helper and
de-facto owners of this piece of code.
They need to ack it.
So you have to rebase, resubmit and solicit reviews.
