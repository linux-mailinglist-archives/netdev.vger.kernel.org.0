Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F4F44AFEB
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbhKIPDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbhKIPDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 10:03:07 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4B6C061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 07:00:21 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w1so78306703edd.10
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 07:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6uJhYgaShmiRXF04cLV4RwDYjwYFS466hjaILAfyiA=;
        b=oh++hDJXIKSIULecGTYkYa8h1fLMICBrU3u7wdye21L2M7oIFkBBTlbNEb9A6pnIxr
         Ej8NWLSg0ouGH7XU3FEoVfa0+v5EmeL03EXz0+Rrz1z2hpVhgf9rXYnYQHfO1etJPQJj
         rY8a5oEBslDyPFNnQILPaj89oKk63q+xmT9LmjbTFXTnp7EzPnWJfk/rNWyAtxIzGgDI
         dc89cXmGMAsZ9WLVr5OpJ4I0O4cBR1AEBvtSdH53ZjwopiCVhoXi52n/Qz9dnonMZz/p
         Ajp7ILcPZy1K/oehLxm8oRm36X/Kldl5sktl4wqVH4Dna5Bd1D9oAMN1428zxa0YLdRT
         s6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6uJhYgaShmiRXF04cLV4RwDYjwYFS466hjaILAfyiA=;
        b=Cordidg5dqePasurh1ua2tIyaiKEoDviraJPalKXSHL8BpYmDIiUog3j8sNgg6Ig6E
         1v1qcV3xnu7oo/l1/hP6ugMptf4iR/WDjy3of9gcY8yF4NqudXQwbAPWQeGo8kTBrDTj
         Tm7uI4JmPeqTzuGHOnkjCjRd42WQxA8ayA7rcqK3GPhK/HpSI8H5WDb7+Wi8u2+vjGUq
         i1x54thgPGAV/sojr0LWSy1qtzIVLdFUmh4VSmTbtS/CVLDegpuCRmkOrj4k3pptep/G
         bTlK0sOWD+q3FFfkCY+eoAT62rJT6qTZNH8XT4sSI1XhFrk3ZyLqR/BKzVBiUMzjwElT
         FsAg==
X-Gm-Message-State: AOAM530dPRMf5mvUk4871BBeV6Wg10P1a9YKgYNxbbdTZ4tnu8fvUhH9
        LIjFzMGXI1m7vh41aDsvrPSW5t80CQYgn1fgbtPy
X-Google-Smtp-Source: ABdhPJwudea26ElEmhWHO/N5gvNlQtUK8zEtfTsVc1cJaPGB66AF29W0PyBst6prdCXPqh8eM47USKwhnF6BbZHnNQU=
X-Received: by 2002:a17:906:6592:: with SMTP id x18mr10277115ejn.307.1636470019526;
 Tue, 09 Nov 2021 07:00:19 -0800 (PST)
MIME-Version: 1.0
References: <20211104195949.135374-1-omosnace@redhat.com> <20211109062140.2ed84f96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211109062140.2ed84f96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 9 Nov 2021 10:00:08 -0500
Message-ID: <CAHC9VhTVNOUHJp+NbqV5AgtwR6+3V6am0SKGKF0CegsPqjQ8pw@mail.gmail.com>
Subject: Re: [PATCH net] selinux: fix SCTP client peeloff socket labeling
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 9, 2021 at 9:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  4 Nov 2021 20:59:49 +0100 Ondrej Mosnacek wrote:
> > As agreed with Xin Long, I'm posting this fix up instead of him. I am
> > now fairly convinced that this is the right way to deal with the
> > immediate problem of client peeloff socket labeling. I'll work on
> > addressing the side problem regarding selinux_socket_post_create()
> > being called on the peeloff sockets separately.
>
> IIUC Paul would like to see this part to come up in the same series.

Just to reaffirm the IIUC part - yes, your understanding is correct.

-- 
paul moore
www.paul-moore.com
