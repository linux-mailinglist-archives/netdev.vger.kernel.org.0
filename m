Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60D2406885
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 10:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhIJIem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 04:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhIJIel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 04:34:41 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35FBC061574
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 01:33:30 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t19so2655064ejr.8
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 01:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cdBraU6+320kc+/TNxImgvkoX2jzn2osTqQSGLBmV38=;
        b=exLAD4M+vIbRaBz32Kd1P9Y60QKY+lYPeGmYYUqjYPKiTsS7LwiwaD9eoB+ZpyPvov
         wmpZd3Id+a2ylWUdZG1AduRAuct1obITnK0SoRYMcj7rgvdN/RptXG8dPMO4SajYfjar
         4vEZWv1VZ3bVXsqNddpbV35yjRaEz3QMTwJDVVu0hJU3uqb6I8ydVYXhILH8hmF/PeuK
         lcADw3duEukU+oKIC++C9sXU/RkbH4G79qYUzGlttbt4VVqqpXf7Cs4Ocxb9jk5eucWl
         xuCV5B2QxvEHz+Oza9r1qA/xxfj0SukMMiQc0Bn0+vgG64B4nU8OMN8z8oCk1oMfckx6
         uZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cdBraU6+320kc+/TNxImgvkoX2jzn2osTqQSGLBmV38=;
        b=4IMN7PSRAq9Pbm+JGbsaRLOT2qD7tuIG5NiSWW+3Z5ZQPOecSGUv38gMDCKzUE6s4V
         iBsMHFTSBktkPyhImzEKRam1yzLsoQBrOpkKSod9so5ma/NlpYWRfI/acadSag92OsVB
         Knp4z3VzPN0hpoAG5nSvthAzS77un0A2+R37+bUJYKEnmauwPRxDvIx+wPXu9YHe6axV
         1/6oCFm4oeitRXNPDyy4i1akJVtlwirhOGvI5fheka7tBAn9hltzPhh830eI7tOJ82E2
         1sZkDs0/baTc+B1EYQbO6RZofVI90rlSdln1qK1l65OzufkudpKQ6cbCGAW/Yasc6VcX
         zx1A==
X-Gm-Message-State: AOAM530rdW8dGmPm6lJWw7DYk6UusCGSYo8RuYEbugP74p/x1lwfAaej
        Tkzob09y0dV6QqoHIINmdW8MljhGK3mHDfMEk2379jFH
X-Google-Smtp-Source: ABdhPJzTpusKuhk2huMEOPN7MF0ZLIp9pyNKAnA6bjMnFoc50xywUcDJDrFwSB314sysY3Z7HOezIWxyjWfElJUQwlc=
X-Received: by 2002:a17:906:584b:: with SMTP id h11mr8224056ejs.209.1631262807943;
 Fri, 10 Sep 2021 01:33:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210909173222.10627-1-smalin@marvell.com> <20210909145113.78d48c3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210909145113.78d48c3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shai Malin <malin1024@gmail.com>
Date:   Fri, 10 Sep 2021 11:33:16 +0300
Message-ID: <CAKKgK4yZjdCf3vJk7BSBwA_35Lizbr_BhEgX=Ge0DhV=aaatQg@mail.gmail.com>
Subject: Re: [PATCH net-next] qed: Handle management FW error
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Sept 2021 at 00:51, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 9 Sep 2021 20:32:22 +0300 Shai Malin wrote:
> > Handle MFW (management FW) error response in order to avoid a crash
> > during recovery flows.
> >
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
>
> Since you say crash I'm assuming this is a fix.
>
> Please repost with a Fixes tag and [PATCH net] in the subject.

Sure.
