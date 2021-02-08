Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135D8313DDA
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhBHSmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbhBHSm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:42:27 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213A1C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 10:41:47 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u143so4053959pfc.7
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 10:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Xm/qvFs4/70pTQDZyKkVYeeOfhYWvle4ZoxP8OF/L8=;
        b=iP+JeCeS2wfxyX+w88gwvUc8n0yhKl2/QkMZTPaGPzrrp3+FhHxHGm1sNwX070FMbR
         ML0imNz5bxugMNFIJgXxXEKUUD9hS6cDTywmNfVAa3mDTRHMWV3yLd1HkD/DKT4UjTvB
         gHn8QDYNBzR/YlrZCIP7fHeD4zvsmmMcK3zHRedFXxGFXuO8h/x4zGE3G3KANB9Hde1P
         KoicQnpyvVqaVYcjXNYbCVoxA+URYQTvLC0T5MTcgj+SdQCE+JpbNoRBrZusstkbYa2u
         BSnh9CClaUpiIqyiZSxokKO2jMTUZGLb47aVFSy+B62SZ5bnIAqV4DaEnIFA4jFMTRAY
         ROJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Xm/qvFs4/70pTQDZyKkVYeeOfhYWvle4ZoxP8OF/L8=;
        b=lM3dmAOs80CPUsDvqbuFML2NgRAVw31PpG0alD/TposQ034ApqTH33JQHehsvg1dJo
         /cJ/6KRRKPjKudPJGzNC5sMedo5fYXaCrUoiTcsCbY6FnigzgsisL9TPPCuOmxojjGqz
         JjGhOwJmZ3y8cwLxZIPyeLwrgS2VOBii1hY9WXimO3+hojj7gHMUclKsJ3pCeUI/+ANz
         ItHCC25+Rb/SwWmwTivGF6bQidSpyKNPdlXpqEjZsrzBNRAcboj6Dy/5keOq+8AzSlSP
         nlL06Blkmp6E47Sh+3Gn8L8Mjzp+dtl34VVWz/XKMu6sqZHg9Z8ufEGck9HdkS2XY3k5
         4r6g==
X-Gm-Message-State: AOAM530oHh8T44tXzgYaGBQ+YL5rJosMuS8aO+tB42lg+GLUwWC3bekL
        NsJ4kYgELU/FC+4w+IrOP2LX2VojezJkYJRGZMehCNar42iTvQ==
X-Google-Smtp-Source: ABdhPJyNEI1T98kDg4hajSWYUL1EGWPawtX+i7I4PbPVtApMWfUhgy90Cl6wG71/pVE0bTjTUdkMbgAQrzBfHRAxuAE=
X-Received: by 2002:a63:3c4e:: with SMTP id i14mr17876112pgn.266.1612809706734;
 Mon, 08 Feb 2021 10:41:46 -0800 (PST)
MIME-Version: 1.0
References: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 10:41:35 -0800
Message-ID: <CAM_iQpXojFaYogRu76=jGr6cp74YcUyR_ZovRnSmKp9KaugBOw@mail.gmail.com>
Subject: Re: [PATCH net v4] net/sched: cls_flower: Reject invalid ct_state
 flags rules
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, mleitner@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 9:26 PM <wenxu@ucloud.cn> wrote:
> +       if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
> +               NL_SET_ERR_MSG_ATTR(extack, tb,
> +                                   "ct_state no trk, no other flag are set");
> +               return -EINVAL;
> +       }
> +
> +       if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +           state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
> +               NL_SET_ERR_MSG_ATTR(extack, tb,
> +                                   "ct_state new and est are exclusive");

Please spell out the full words, "trk" and "est" are not good abbreviations.
