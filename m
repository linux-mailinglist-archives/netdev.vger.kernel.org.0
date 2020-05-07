Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8481C9736
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgEGRLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726074AbgEGRLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 13:11:44 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41505C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 10:11:44 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z90so5394400qtd.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 10:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IHCzuoRXAe5mRjkbjNi3gOcr7sUj+9tYT+cGill7uqI=;
        b=LpkAY2AQK4yvzeKDup4oOfhTcYxL7TymnvTf2RIwrC8PgiKDYBIBG2gwRln4fJTksM
         MNsQ8zE1xx4WyG2uqyHhg93T4AO0UIOx+GZEQ4opIDaSqc2B8TS8bxRcHfm7B7YIAIim
         VY9zc/uI6nlGZ3irCCkoFJPZ2pAz3Tw4AYbEqE8RjslkeHXHsAeXC1DalJ6m9pibuQcn
         Du3mimQFJ9oZo16n0tZs3MWfH0HRWEvH1oWPT5HMf4+2cP8aUVEjiSWPHE17s1f0KicU
         NoQaKFYHQAlWCO9D055HKz+Jn/WYEF8cjt2qRsQaL97hEDvd7+hNRBkrLLe6AnDfw9xm
         Cr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IHCzuoRXAe5mRjkbjNi3gOcr7sUj+9tYT+cGill7uqI=;
        b=ppjtehcIHm/5S2wGYNbYUxoBSkrfD2YuSJ7Fr/jpDxQ4n0hKMFOVGH8RQ/wiHGEr2d
         Qydfb89aZYyaMMMg3qZ0m2maqy4p2Cy6OrMO7zft5omV6hiCaDtTQEbndnXujyXHoKFu
         h4cSgIltOg8uPRKIVzMf9KV1L9NjSup+8MD7p3xnQW2sZvsk7B2FjFWmLJkkSrcs0vhJ
         Ao5sDHqHOs/ZKCrOS7RiIOLdlTNbqYfjDG6iflKpSvHYy7ospqBt5+2tXIFuaV6Pb5rv
         uVgLPR24q58fDkHUWyszNTBZju/GJJ90w8iUSeIAuCRVSCpA4Y/hWYDoqqbyO8Rf9y4a
         yC1w==
X-Gm-Message-State: AGi0PuaQEPuJ7Z6V029OwkjREWbHTBsMwlgniiW9808n2Cvzq2wgXEZo
        ETX5wSzSV78IY7KUySv/63WaOLUc
X-Google-Smtp-Source: APiQypISOVxBRuC15aZm07cZdmBiguaXFbDhqeJdhQeqhSaH4wln89/BhvPWDIHh8aCxluwyoxemAQ==
X-Received: by 2002:ac8:31d3:: with SMTP id i19mr8271092qte.210.1588871502731;
        Thu, 07 May 2020 10:11:42 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id q17sm4729329qkq.111.2020.05.07.10.11.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 10:11:42 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id d197so3297191ybh.6
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 10:11:41 -0700 (PDT)
X-Received: by 2002:a25:3187:: with SMTP id x129mr24600606ybx.428.1588871501366;
 Thu, 07 May 2020 10:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200507170539.157454-1-edumazet@google.com>
In-Reply-To: <20200507170539.157454-1-edumazet@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 May 2020 13:11:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTScacw8w_bf+bnR4KYUTVrWSqfbnZFbtzATsqFZerGS5eg@mail.gmail.com>
Message-ID: <CA+FuTScacw8w_bf+bnR4KYUTVrWSqfbnZFbtzATsqFZerGS5eg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: relax SO_TXTIME CAP_NET_ADMIN check
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 1:05 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Now sch_fq has horizon feature, we want to allow QUIC/UDP applications
> to use EDT model so that pacing can be offloaded to the kernel (sch_fq)
> or the NIC.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks Eric! This will really help with enabling pacing offload in
real workloads.
