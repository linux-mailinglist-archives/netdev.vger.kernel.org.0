Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDBC49F232
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345947AbiA1D66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiA1D66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:58:58 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF52C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 19:58:57 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id x7so9230574lfu.8
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 19:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ec/OG3+0FjSBMqkwdO9yEjbQ5QWOW2zGfBHaoDO8CyU=;
        b=bvbIY3dzFgNXuZ+FFcYrUmeRLpMQeOheVoUvqy7LBKoQxb1O/EOA+jATJM4CbAXzbW
         IcMLCe+ZtMHEYmHXr/VQPTzQ5VTG0JzEFSJFzEnJY4F1LYhrJIvF24+JbR6RSIwDgTw+
         jw+RaA53i38xxtuXGcuoPwn7SZngaZq8SsiqT8kKpZR0JPYbPulgVs+GDfZPamPuSlr+
         IvH7R3KSdV5FXEnYKd2nxvqa8uZ3vXZpMPwQK4U6w5VGOwD0qcppgJX8LBNsMXK4iE8/
         LSKkl7ETKobeb287cE8pZwIBP6oWJNR9pFcRSUY2CxalpE4S49BJrG7806JywIfGFVQz
         EiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ec/OG3+0FjSBMqkwdO9yEjbQ5QWOW2zGfBHaoDO8CyU=;
        b=QHshU+meKKjM/D7oLaMa1FEenbltwNACwqE4csO5BHdQlI2ipXV2ObCmgIaoKTvmpj
         83giPDibb0GQ1TPFj7ycHi/ztHOJCM8r4/Gvo44+M17oNmyIUM4THIJK2SDimsQp0biO
         j8DBD2jlD5ai8voMnUh0rL8DLsXgMi1PkAnsSmGEPlGfDuIQRjGokZ/PCBF+9lJW4sgf
         YWizn2Pi8bt0+CipilIFWbYTM8IJjnDF9YkuHrzntJKCv9BIPpjjplqyB6BRj+adhZqe
         T98Ib5piRN6Vq5LFz2SsGBbgyovpzIp0+OHVmliU7D7Bgtvi7jriaeXXISokbnhf3DKs
         5Wsg==
X-Gm-Message-State: AOAM530KwYtG+O/u5F/4GoTP8TVuCt//RGotweEJBr/pXsHmEcBqhnce
        2PCRJ7T3HrHXfvBGUiggaWwUeCpwasXHRLFWsBawasg8Q3E=
X-Google-Smtp-Source: ABdhPJxem20DrJ2w3dbB5VcNO+MgnKInqA+yKxOnuO6PwXIheCySuH79ogDu/B0dqmEVa29wQK1tuH8U7atN3158DRU=
X-Received: by 2002:a05:6512:2289:: with SMTP id f9mr4630437lfu.537.1643342336102;
 Thu, 27 Jan 2022 19:58:56 -0800 (PST)
MIME-Version: 1.0
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
 <CALHRZuqE3z27wq58a=xdRbjEXLfufN7mkVxANgnSqB0EEFnd3Q@mail.gmail.com> <20220127072450.00143146@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220127072450.00143146@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 28 Jan 2022 09:28:43 +0530
Message-ID: <CALHRZurcqkTW+q3bbincPrCYEh8Lw-+LsHRVVRMvgrRHP9=Mig@mail.gmail.com>
Subject: Re: [net PATCH 0/9] Fixes for CN10K and CN9xxx platforms
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jakub and David.

Sundeep

On Thu, Jan 27, 2022 at 8:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 27 Jan 2022 19:02:30 +0530 sundeep subbaraya wrote:
> > Hi David and Jakub,
> >
> > Any comments on this patchset ?
>
> This appears to be merged to netdev/net as commit 03c82e80ec28 ("Merge
> branch 'octeontx2-af-fixes'"), and should be on its way up downstream
> to Linus. Sorry for the lack of notification the patchwork bot must
> have had a hiccup.
