Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F2C2FDF37
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404498AbhATXzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403786AbhATXTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 18:19:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8B6C06138F
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 15:18:32 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id e6so131129pjj.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 15:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m7v6KwxqHQWp0GPQz7X3Iwt+6SHpjwTEDmsvFMhFZpY=;
        b=IdKj7CSlBkUeCXJTifLlbJNaP+dSNj6Iuc/AS8s7j9PIsvdn4ajZW0mDhdKnrmy21D
         0QC2W2hVWpL7azkP7aYQ3R6FfdRHxXVORB325EQDVcefoKQacjaVOYtGmAfuB0Jw8rru
         geo/YhuyJ2LIzHlGegTQGTvu9JFCcWJOJyf5SMlL6IXdQHGsjM4Qzn3qfw+cXoCzY7py
         s+vWQKA6ejr6KOsIyJc1seFNyS/0CYAoiNDlssCGu955npdGLfIZyuHUw4R79AGY3j5f
         W4PFsliNrr/usxZJBpqRUsFtz8XgtQwBU/CRFriaK+mJFPbBjawqllT2SRB8uGo9GCRi
         Exqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m7v6KwxqHQWp0GPQz7X3Iwt+6SHpjwTEDmsvFMhFZpY=;
        b=l/KQLTZsWynvN9WZr8QiWovA4iPMHq883CzWfh4dcz24RKdJjQ5FLG+VWTbcrdyn1n
         7x9ziy/LMVJXQiFiiNVMgIAu+zGznLS7axEBcjfWrRr2Oq4tG5xuCgUxOTjT1C4oToAE
         SGRF5TA3xWpGeDZSIqORF8u3dVM/IiIlCfxnuGnPnniRpXU/s+6gcDhttWuTFbhCL55M
         J514ueV9aSOFDlCV/yNmsWsYNWtFBilpLpvQorOg4EgN/auIDIEbKYGim3Pced8pD2g/
         ColF3mwxO2v8rqfMlEKY1HptJ8P0EhCsZZwdQkhdkhoZPlRm4xx2e6ms2pdOn8cZPgJf
         asYg==
X-Gm-Message-State: AOAM532I/S+ImN8VUlfIO7SwMNQfMvSKqC8Z5CjLyqlha2h+voBkOpV2
        cZbkW0iwF1CusQa1VOsR9U43FIyk7ElZmX9+yXo=
X-Google-Smtp-Source: ABdhPJx71FUMBeIjNz+qPAQLG61gOqCHyrAFQH4v07KNM5TujgNScX2dFO5vZ1+T6N7SbSn+NOqWLy0wTfiigzD10/E=
X-Received: by 2002:a17:902:d909:b029:df:52b4:8147 with SMTP id
 c9-20020a170902d909b02900df52b48147mr7484958plz.33.1611184711836; Wed, 20 Jan
 2021 15:18:31 -0800 (PST)
MIME-Version: 1.0
References: <20210120122354.3687556-1-ivecera@redhat.com>
In-Reply-To: <20210120122354.3687556-1-ivecera@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 20 Jan 2021 15:18:20 -0800
Message-ID: <CAM_iQpUqdm-mpSUdsxEtLnq6GwhN=YL+ub--8N0aGxtM+PRfAQ@mail.gmail.com>
Subject: Re: [PATCH net] team: postpone features update to avoid deadlock
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        saeed@kernel.org, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 4:56 AM Ivan Vecera <ivecera@redhat.com> wrote:
>
> To fix the problem __team_compute_features() needs to be postponed
> for these cases.

Is there any user-visible effect after deferring this feature change?

Thanks.
