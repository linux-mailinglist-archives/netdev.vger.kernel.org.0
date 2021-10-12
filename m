Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A21C42A8B8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhJLPqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237258AbhJLPqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 11:46:07 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656E1C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 08:44:05 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j21so71888684lfe.0
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=itOGc6T0aqO0wugMIpHlzBw7R8tHrlRAgp+SiTxE8BI=;
        b=nmbZEfEme8knbIeTxZzit6UxfZrBNBcLh7ijHsy6FFIY0QG9swfuy0oR+8+BYO+jeJ
         O0Ui8HAz+KPGmBdGZvTDhs6NZom2DttD/+b1wjG4hTkRKXzKeIUSH9VQNT7RMxqFveR6
         wfmDLiHUA+TSwerNx6MtwB+4xmzshDJlCAeClqKnmG0IpDdVB0PHcumglH4Jo2sAB0WX
         3ZL3roaktNKHm/KE0q2+M1kEiMQQv205QQot0wLpNSALZ0ndiFi0aLOLBuSfxTbca9cq
         oJFvs6FBL+EINI31kOYpOfl62TMNcPssHfewfb39Wizkuvt8bI/G1AZ1N6llD87t1Fnk
         tibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=itOGc6T0aqO0wugMIpHlzBw7R8tHrlRAgp+SiTxE8BI=;
        b=1hMmksa2iRv13zQS1R0YjBacdKCCZrAiWPwuf6VLmOD7W2TLMEcA6dd2r3jD44nloi
         btQnQJX3zIz7EYNjWYHAlu0UFb8DAoH5to8PFSVNJ2MgDJsL4Nz81duZ/x0pFbhPlYqP
         sJ5AkiccCv+fjnA8EijI2KJM/ERWeSnT9jSqqNDJqBmZ4n7bAMmJBce+6y8zLYbWO9GV
         5VLEKhtdpC+xKIk88UfdMqCxQHHePvcNKuX9VexkP+jQtSAvES6/C/NBkiz7SVnil/Dc
         j0xIDLwvgCYzBXvmNikh+WBe/q+xsAVVbamOGJbGBj9zbaJfhTc0CZf9RA2nxUjCZz+z
         nRgw==
X-Gm-Message-State: AOAM532FONrFG2pNvBqvp3CfA7aAPvovbB0+OaYwZhQtZSQQeGay+oec
        YrQUD1dz+b0u3VHRD3HN1lFMRMk08dmLgoPRSpgZFHsA
X-Google-Smtp-Source: ABdhPJxaLcCcgtjjzCfP9RSCqWCQyZnB+lTON0M3AFTxSqSMvI0c3BqmrHW32YWC+D1W70Lr6OqueO2GuPQPipJMTug=
X-Received: by 2002:a2e:97c7:: with SMTP id m7mr22645127ljj.299.1634053443819;
 Tue, 12 Oct 2021 08:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211006125825.1383-1-kernel.hbk@gmail.com> <YV2f7F/WmuJq/A79@bullseye>
In-Reply-To: <YV2f7F/WmuJq/A79@bullseye>
From:   Ruud Bos <kernel.hbk@gmail.com>
Date:   Tue, 12 Oct 2021 17:43:52 +0200
Message-ID: <CAA0z7By8Rz+3dqMF8_WXRZuvG7K_Mrgm209Zpsk6C0urG1cOnA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 3:09 PM Ruud Bos <kernel.hbk@gmail.com> wrote:
>
> Hi,
>
> My apologies for the huge delay in resending this patch set.
>
> I tried  setting up my corporate e-mail to work on Linux to be able to use
> git send-email and getting rid of the automatically appended
> confidentiality claim. Eventually I gave up on getting this sorted, hence
> the different e-mail address.
>
> Anyway, I have re-spun the patch series atop net-next.
> Feedback is welcome.
>
> Regards,
> Ruud

Ping?
I did not receive any response to my patches yet.
Does that mean I did something wrong?

Regards,
Ruud
