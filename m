Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BC8379789
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 21:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhEJTUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 15:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhEJTUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 15:20:00 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2A8C061574;
        Mon, 10 May 2021 12:18:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l14so17761028wrx.5;
        Mon, 10 May 2021 12:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GYkCIlZeszgg1QnM6xhV1P3JXJivzi5QJBvk3z9AYj8=;
        b=Mpm3UkAgvFWF4lU4jjhFfwPlaAs8mL+YoP+oerIMB4Qcfw8fZQ015eqD1/v3gvxlyb
         glk8tj2vtLUriOYn6Cg8cPIabpTFWiApNXeKLug5cQMh0i+G0vP+aBjv1rBCwMBN48I6
         SrX1/mxVj0ePkSfdsxFq4RsZbUsz2q2993Gtp1xifjzxk1xqjC3/LfR4mYqKjnVYp5Ly
         CMt1kKvvpY+b9DCm2/gx6k1+/6IOcYlUAtf2V6lQkQBDnY9JwiMH1jBTrv55eh3MObjs
         pGYbj0Q3lfq/FEANGjbK61vTy1K4Js3qyvPVd19RYIP0tHL2+7tH5dVkd9EPUkEMnIK0
         qrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GYkCIlZeszgg1QnM6xhV1P3JXJivzi5QJBvk3z9AYj8=;
        b=BuVlwLFdfRe4Op665lkGnlF9v2y4U7DDmAGNGDVid8Ek0BwobrB8GDOljl6iIUviDX
         Mf8fY7X1dSiQyYqJ7AF5cKU8yYbAhIBTbvjAGY973PBh6MQKuUSA46FaCf/HIPCFV03K
         rg7INSpOvSAnhjLlkgd7k/luN+8ghqY0UBljbipxj3XZu8D4JXUM8sGhrDqP8lSH9O4f
         wFSflLEKpFB3n7U5OKRWtnAzHzXBwyk471N2flCVPTmLhMW5iGONNeeJ6kzL3t6YrygD
         t3ljsQfOOg6QHzuLo6uOTJK71xLOMK7J2Zg8P1FaoANCDOpp1ld1AYvLIemmB0V4baOq
         XGeA==
X-Gm-Message-State: AOAM532JBJIx7kSq2sU2Qukwf02l4aaAJyWqeQot9hKYjA4cJFwxBdj6
        +47cjz0I7P3n3Ft6Z0zjjFDLxD2Zl+lFnG0VXCY=
X-Google-Smtp-Source: ABdhPJxj6E7PqOFqdiOujga1q0eIaUxGWOHQ1BLbsHyaTRDctTw47YXnZCGUd7GIVELeNFWNUo8O+yL+xwqQOdLNO1E=
X-Received: by 2002:adf:efc3:: with SMTP id i3mr32969261wrp.243.1620674333582;
 Mon, 10 May 2021 12:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1619989856.git.lucien.xin@gmail.com> <YJmFKVqZWDRe5Rzn@eldamar.lan>
In-Reply-To: <YJmFKVqZWDRe5Rzn@eldamar.lan>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 10 May 2021 15:18:42 -0400
Message-ID: <CADvbK_fUa9SWZC30Jp2wnJW9Q7ds-pV_+FOVPUaceQh2KbWNzw@mail.gmail.com>
Subject: Re: [PATCH net 0/2] sctp: fix the race condition in sctp_destroy_sock
 in a proper way
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Or Cohen <orcohen@paloaltonetworks.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 3:10 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
>
> Hi Xin,
>
> On Mon, May 03, 2021 at 05:11:40AM +0800, Xin Long wrote:
> > The original fix introduced a dead lock, and has to be removed in
> > Patch 1/2, and we will get a proper way to fix it in Patch 2/2.
> >
> > Xin Long (2):
> >   Revert "net/sctp: fix race condition in sctp_destroy_sock"
> >   sctp: delay auto_asconf init until binding the first addr
> >
> >  net/sctp/socket.c | 38 ++++++++++++++++++++++----------------
> >  1 file changed, 22 insertions(+), 16 deletions(-)
>
> The original commit which got reverted in this series, was already
> applied to several stable series, namely all of 4.4.268, 4.9.268,
> 4.14.232, 4.19.189, 5.4.114, 5.10.32, 5.11.16.
>
> Is it planned to do the revert and bugfix in those as well?
Yes. Thanks.
