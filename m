Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B355F66AAAE
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 10:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjANJsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 04:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjANJsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 04:48:40 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F504495;
        Sat, 14 Jan 2023 01:48:39 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id fy8so57417748ejc.13;
        Sat, 14 Jan 2023 01:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N9VqDq/HpqcnFXIHx4H7PMzTKm1iJJNl4ma4OWvrU9o=;
        b=ZNbmHCOoXONyOdzFpFSp6HRoOnSTaS+FDeJ9Ov1dgSdgR/RoluW1stlQpagFXfmqkV
         mKJkEj8+ogrcCwxn8Tid0gbaV5ZSkDaCrL7UXhnpX9MFsD6TaZd+2rb2I2vfGXcA8Dm2
         O39JK5K3X6Bv9Xo+afdIIo3OqO3LVmm6pSQ8wcntWPCT5H3wK2/4h/NIVe4//ek7FbFQ
         eCRVcbO3G9dqeJoTmErz0DAB15a7z8VVN11z6pjv7/iK4eiD8fgxich50lr1cIjIppG7
         L3FGwYzwVSyvC9sik+EomSk9jYgpt9DnV3fOcah3jntFTRGE6/pr6pqep7Dlzxe2PUnj
         asZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N9VqDq/HpqcnFXIHx4H7PMzTKm1iJJNl4ma4OWvrU9o=;
        b=IIShayQZmTQOpN/XFJ7ZX/qMSpCgPHxaBbHGA2F4gZXW/yp5yPjEugZ0k9PF0YK53N
         NT45EFUjX+m6R4wTod2pSMG494Prh/oPH5kGaY2cf2I8L1hIjXTAnRLkL+HiYZyYygb8
         K53lcsZyvfdO7yEWCE4zcnRZC38KzW3QP53W4WLOI1Qixu8L0JMxtl717qQkRHwsxJgh
         0set0VMJhUR2zjxJR+c772PL9R1f5BpNYhdMUjwCMrvnrdk1oCyqWhjgBCdEgBvpWbQu
         9PRSLzCBHSqoIUae9mG4CjauAp+Vd9quIKmK5fYFDiOf1mfVnV9gsB+bPeoetNdr/pbV
         mZpA==
X-Gm-Message-State: AFqh2kp2yvwjeZE1e/Pxl2yqSx3w1gZc1gJyhddZDjP8mF6Jmajw7YaW
        i5Z1syL9on66uts+m+t7WVlWX4LI678PQAhZxbU=
X-Google-Smtp-Source: AMrXdXstz6oarR9tL1sSn5vBVuBAtLDcb6WpfQRYy8xaoMrpXdRL0g85+FwSgWVVY9zeoIIdUgH23zDq6PStPh9fzn8=
X-Received: by 2002:a17:906:c0c9:b0:86d:ec8c:5b3f with SMTP id
 bn9-20020a170906c0c900b0086dec8c5b3fmr23239ejb.50.1673689718440; Sat, 14 Jan
 2023 01:48:38 -0800 (PST)
MIME-Version: 1.0
References: <20230112065336.41034-1-kerneljasonxing@gmail.com>
 <CAL+tcoB2ZpgM6HM+m=wF2EkQ5caeettcbeUQQBxpLWVuwSSxbw@mail.gmail.com> <CANn89i+W_1ux=5ixjCdf9LoGuDb6LEJ_XgWCNcYztjPQ0R4L1Q@mail.gmail.com>
In-Reply-To: <CANn89i+W_1ux=5ixjCdf9LoGuDb6LEJ_XgWCNcYztjPQ0R4L1Q@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 14 Jan 2023 17:48:02 +0800
Message-ID: <CAL+tcoBM6YkZgrRHLXXTwZw9rVNfbEk2SeXsz5Zf6ca9LartYA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 5:27 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Jan 14, 2023 at 3:15 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> >
> > So could someone please take some time to help me review the patch?
> > It's not complicated. Thank you from the bottom of my heart in
> > advance.
>
>
> Sure.
>
> Please be patient, and accept the fact that maintainers are
> overwhelmed by mixes of patches and company work.

I felt so sorry. I'm too anxious. Thanks for what you've contributed
to the net module really.

>
> In the meantime, can you double check if the transition from
> established to timewait socket is also covered by your patch ?

Yeah, I'll do that.

Thanks,
Jason
