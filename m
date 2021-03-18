Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139F4340C99
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhCRSNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhCRSMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:12:34 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE42CC06174A;
        Thu, 18 Mar 2021 11:12:33 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id t6so5734790ilp.11;
        Thu, 18 Mar 2021 11:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q41xXuRmur179OHVx//rhAqOsEcMpgA+YrpYo7J41Gs=;
        b=T+Il8wRP5/FIUoeDAvnQz9LVZSgHUpRSk2v95XYOaoKJe14ZwbG/TuPOYQTGiLKx1T
         L2U0Ro2gkPwIwen3Nsb8405VKPRwo8CfvWqz0kX46Q0EfqaXIBObrzmYic5PoUa7Yq2M
         YdViJwR959Mq0kjLyY/2SD/VQb956vVIQjtMyk3X3rJFnvzM+f+5xMe8nghOT02Dd8AX
         s/RQCdIh1dVYFkQjKmxmpts/qF07bbUiJGhCcIgoXJYys/mSJF20yTXyin5/RRH7ZhH8
         tQ1gNqeEl3IF8V52FIjn+u076EJopMKRk1Z56SEYQtcMx1e5VFFmeq7JDLS04lK0fNaF
         3DCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q41xXuRmur179OHVx//rhAqOsEcMpgA+YrpYo7J41Gs=;
        b=MXuFmjPysw4gKATSJFaJbsr+Dzs8IiCZ3I5x0eejx63xBDrBQqy0hX4leJnIlY1EaY
         GiGlfnMkCjjZMeeiNgTuwnXHJDMb6F8afWGP+xWBYHFANmNnb5mrm1rGy4pN7MGmIw9V
         Qc6LtgFwqzCVhZNpgmgj6eterHGHv9i1d1h4xJ6lG/WA/izguPus0SMy+sDeWndQnwTu
         rvfxW5JeLQW/gizUjbx1k0di9CA7l18ayZii/zkPBG0B3VDAhgKSNHZgfaWHfN+TPh/m
         iYCE2bIuh9f/f51IwhKh56obfbHnbb6Icss5XiLHYlZvOfTdov4qK2Wq5mtFXWOD6K6b
         KDMQ==
X-Gm-Message-State: AOAM531pWUX/llxmNRS+H2DWN/vQkfQ2Dyj5Al93hRlUFtvhuB4W6rHV
        6WrlruucL4uMrpTrGi35cNPKkXV4fcvPObBzGZc=
X-Google-Smtp-Source: ABdhPJxCjCW9kXCdSRTEyPNBJPdoVR+YRar9BF6hVktq6LhZLgBZ05ns7zXGmjM10DygGEah3i1SbmoBj1XuLlWFBOY=
X-Received: by 2002:a92:d5c4:: with SMTP id d4mr2705539ilq.102.1616091153416;
 Thu, 18 Mar 2021 11:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
 <CAOCk7Nq5B=TKh40wseAdnjGufcXuMRkc-e1GMsKDvZ-T7NfPGg@mail.gmail.com> <YFOIsIxIC2mgzhZ1@builder.lan>
In-Reply-To: <YFOIsIxIC2mgzhZ1@builder.lan>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Thu, 18 Mar 2021 12:12:22 -0600
Message-ID: <CAOCk7NqBnfb-snrd=kh9d4TQc+pobDN+rYPpVJrdLXWSqGq8mg@mail.gmail.com>
Subject: Re: [PATCH 0/5] qcom: wcnss: Allow overriding firmware form DT
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, wcn36xx@lists.infradead.org,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 11:06 AM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Thu 18 Mar 11:56 CDT 2021, Jeffrey Hugo wrote:
>
> > form -> from in the subject?
> >
>
> Seems like I only failed in the cover letter, right?

Looks like.  I didn't even parse that this was the cover letter.

Nothing to see here.
