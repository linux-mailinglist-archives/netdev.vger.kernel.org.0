Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E141B82D4
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDYAly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgDYAlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:41:53 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E147C09B049;
        Fri, 24 Apr 2020 17:41:53 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f18so11791076lja.13;
        Fri, 24 Apr 2020 17:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u37CNX/UaTtnsFCRVE0yAeDG98uxzVKA2U0RwxsFElU=;
        b=fhEIkj7rcX91JVtBqIK4pRRSMooAMLMoDHJHWP4vVQ9pZJmGndJvTSxC263E5aaEP0
         s0rKQaQvQEQpMmyj4keYBubxMFz1bNFGJAgROQiKhIMq6+BNwpeDlgbIru9o2Ta6mT4l
         ROpqD//LlvtkwMSYNAAFjS2iRa33mC9WHqHyHjELFM3klYzTfOFBkgUyaSXOEqv5UdcD
         L76Qq3D9/5Ns5RLSEgqJCSgM5YoNNIixC8euVuo2h65hWFqHy3ASwVIEXzVOSQnmtE6m
         dGAxsVfXYZpk/sQr+EdRNuC7hruRLhl0/JNMYBcmtAWfnyURQbEp4X9eSlHRkYHdFRsX
         dSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u37CNX/UaTtnsFCRVE0yAeDG98uxzVKA2U0RwxsFElU=;
        b=O6DUBp/+dnaBAt0vun60kdOj9OEOnXiqwAROKyIr7V2JROVTFaNEOIuA/633NjZw9K
         4OQ4yoFWmNsgNM7hBMNmJZobd3tyPgO5v5RENJNXkrRUTehL3QPRVfmVsYBuTgYDn9NH
         9oiXdNnLCZMwtb2XKkDZxpZuR+0qKFQCyS4mPjW4qmgblNAxHVglfurcci08Bhbfegc1
         Xb7e5IwefdizwyjEsqoqDvk/L6a0NDDAmUrT/T6ziD23qHtFe6Cy/QlAwuSRRLewr5vh
         iCRameoKRHnYlHG9GIz8cI6MbMIP9thk33m5RZjeQ1T4wiLRTIWeZF0zljh4rqsz9epe
         8FZA==
X-Gm-Message-State: AGi0PuYOpI7zYtHyB1Rji1IiKFz6asCpufOVbPYvFhlR4IXdlE6oAdho
        SLvWmFB7HRxVuOl685FLr6oA5q7QIuBZl9Sk2F0=
X-Google-Smtp-Source: APiQypJ9z/QFBUOPujbjGAreDNBwVphvuUubOWWoG3o80D3qTJJbiAS76uXhtO1XAn9PjAyVQlJ4Zy3kDs5R5NPo/W4=
X-Received: by 2002:a2e:990f:: with SMTP id v15mr6520304lji.7.1587775311815;
 Fri, 24 Apr 2020 17:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200424182911.1259355-1-kafai@fb.com> <8fd56f56-0b2e-472d-0e8c-a9f4e80c057f@isovalent.com>
In-Reply-To: <8fd56f56-0b2e-472d-0e8c-a9f4e80c057f@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Apr 2020 17:41:40 -0700
Message-ID: <CAADnVQ+NMfG4KxHoPRBPTP7BvObbTi9dD65ughgWiE05DM4fKA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpftool: Respect the -d option in struct_ops cmd
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 12:01 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-04-24 11:29 UTC-0700 ~ Martin KaFai Lau <kafai@fb.com>
> > In the prog cmd, the "-d" option turns on the verifier log.
> > This is missed in the "struct_ops" cmd and this patch fixes it.
> >
> > Fixes: 65c93628599d ("bpftool: Add struct_ops support")
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>
> Looks good to me, thanks!
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Applied. Thanks
