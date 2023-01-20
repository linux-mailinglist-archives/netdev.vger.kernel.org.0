Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04759675A5A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 17:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjATQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 11:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjATQpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 11:45:09 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B483A83
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 08:45:04 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id g12so1481233uae.6
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 08:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=boZ0dqIpKAH785rpqEYhFf53N8uHdCYZGulaRtCPwlg=;
        b=TVQaI7HiHCVIlj6zEGYEbXX+XKuoYNwYTOjzlPportjxZHOiU8e5jpWfQxleHEBVB5
         632Ngvuxn8DoeTwBHIPaWkPqRF0Iq4Eu4DjeOfVczVi693CAaxS8LSWFc+ERadDDNtgG
         jE14vqARySpLV9TPULDCx8yp1gwGWL6WOHhVxE+lROv5gCYao17Th9jX+BrQ3tcWCLm3
         m1zcBYJ8HZ0sNauOQprbj0e+V8FPRz3wiN8WtLCiFfpBzIhwCjg++r6eKwHMe5HBtWZr
         eOLB/aQ1R6IjPzQH1KYR88Ogs5bZix2WxQC66BV5fbtpz2JB6jleb/sQMPH+yBdrPZY+
         T+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=boZ0dqIpKAH785rpqEYhFf53N8uHdCYZGulaRtCPwlg=;
        b=0v+FlcUbsTs8LMS0G8AjqrL6DRzRToLzPn9UwNEGVu0ohrEUp/q4Ch49eZHnbnFChJ
         lNHqXKFcLQiSI3Qd4qXTaieE+9m7Zp63N+Zwiw1eRqISxuvQ2WZOhCCiWV17X6RLfL+G
         /DxxBmYYYNr5DwY+A8XDgqXfD9WIVUvCMxvx43+guOrQLeYbny1ZB5EifRQJ8q4nBEcC
         LvUGKU4+SG9KGey20l1Q55tm7zmc/SIbK+RYDKmUNJ2QR98W/mF3wgOcvnONZ+MpYGMy
         8xfHTvEXRyCY+Piy1a2njGeQVpec+Cx28fHeP03dkBtNrkTdxzPTLVcFB1+vV5VgGoV+
         /wrQ==
X-Gm-Message-State: AFqh2kqgaojFz28chZPCUiE+EqNqcB68iaEPpXR7Bgz3tanUDGeZdBuA
        1uJvxDF1syA9e1JrJINnYnY3UR0rcUpCDMNSEfESgQ==
X-Google-Smtp-Source: AMrXdXtdwU7/czYs54x51aVYHuClvYtp579EFc9KBin2CLEyM75ufjP4aaw03DcsrfcymIFQkppReTzHyVcdsmzZNFE=
X-Received: by 2002:ab0:6c54:0:b0:424:e8b8:7bcb with SMTP id
 q20-20020ab06c54000000b00424e8b87bcbmr1985318uas.123.1674233103918; Fri, 20
 Jan 2023 08:45:03 -0800 (PST)
MIME-Version: 1.0
References: <20221221-sockopt-port-range-v3-0-36fa5f5996f4@cloudflare.com>
In-Reply-To: <20221221-sockopt-port-range-v3-0-36fa5f5996f4@cloudflare.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 20 Jan 2023 11:44:47 -0500
Message-ID: <CADVnQy=GCiBHDu0PYETh2nbaAeMtCwGgSG00wyJ8ezRgRBbABQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/2] Add IP_LOCAL_PORT_RANGE socket option
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

)On Fri, Jan 20, 2023 at 6:53 AM Jakub Sitnicki <jakub@cloudflare.com> wrot=
e:
>
> This patch set is a follow up to the "How to share IPv4 addresses by
> partitioning the port space" talk given at LPC 2022 [1].
>
> Please see patch #1 for the motivation & the use case description.
> Patch #2 adds tests exercising the new option in various scenarios.
>
> Documentation
> -------------
>
> Proposed update to the ip(7) man-page:
>
>        IP_LOCAL_PORT_RANGE (since Linux X.Y)
>               Set or get the per-socket default local port range. This
>               option  can  be used to clamp down the global local port
>               range, defined by the ip_local_port_range  /proc  inter=E2=
=80=90
>               face described below, for a given socket.
>
>               The option takes an uint32_t value with the high 16 bits
>               set to the upper range bound, and the low 16 bits set to
>               the lower range bound. Range bounds are inclusive.

IMHO it would be nice for this text to document whether the port
numbers are in host order or network order, and perhaps whether "high"
and "low" here refer to host or network order. Key parts of the
sockets API express port numbers in network order, but this new API
seems to express port numbers in host order, so it seem worth (a)
deciding carefully, and (b) documenting explicitly in the man page
text (here in the cover letter) and commit message for the patch
(patch #1).

thanks,
neal
