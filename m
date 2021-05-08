Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FBD37745B
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhEHW27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHW27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:28:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDFAC061574;
        Sat,  8 May 2021 15:27:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b21so7375669plz.0;
        Sat, 08 May 2021 15:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8dgmEtCxKutf7tAQy1I9fCr8fIaJBqMKoIM5iSA2p5M=;
        b=T+5A2/woMmUakTE1/Hs7WzCiEwfTah6UddoZU0DvU7OSRpcJqC+GuD9ucWaKelGd1L
         M8btbdGSculAFuwWZSFL6RC1iE56HnmBwfteeaskvRNtxSzOo5H8TUkLDVVCUdnlGwhE
         IENw5OFez1mB9ChkyAh0SX7ykTcIWR7e1iaktgiFeQl6ULiSnAR++T/yUZeFnFHkrkNS
         9q8N5kFbL+EIMLc1pV3GcMhZK+S8hGyS+0fSMb2awE3A+PGt6YUFdwzJX69MfEju77vW
         9EgrLogCMucKumaXgqwnDI2MGpIBwbnWltSjjats75ZsDk097JDUba4Da9JXImJw2ngP
         rYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8dgmEtCxKutf7tAQy1I9fCr8fIaJBqMKoIM5iSA2p5M=;
        b=Ohke0r6EGls3d6VWJVZXn1PopAKDsEXXEnaxFqL5zCuVTvgu/LuMXZ+L28kLBjsa8Y
         1gGCpRKli7Vjom8eluEvoE9qZ13HVTupmE/0MZrGeHo86PTw9VXjVIRuSeFhLbrS1gwa
         GOZ2OvVi2RkfYtMCyKNsiT8y82zt+u3b/RzoMEWk1dNqjWyyq5MXeNHm0XINoNZdaifl
         SeAXkLmH8UGdwd8gWKYoowpPLDWaaAQrkZ0hCGo9YwR0rA+KMuvTaJxY89YZXNTNG4Eu
         ogji91x/sc7VfLQfkHg1yoWrTM0qFyMOrKN+SYRsd4ZFCC62ok+zqLw3qC3NzaVPjVrf
         OgzQ==
X-Gm-Message-State: AOAM531jnBgnsGYx6K1IhyC9PZr1GGVYUuB5mJp6shdVg5fBqHU/Utrc
        SRiui5abCJnvyWMq449p+bGb/JzrVwFdVggMtZE=
X-Google-Smtp-Source: ABdhPJyrTCy859vmReLywXS6Ld4/WT0iTtjXtfF2X+xYq+Bx9XB66XVl0u5LGNgsOnjVlkOtQHNrREKyd4Slf9t9oAc=
X-Received: by 2002:a17:902:56d:b029:ee:9129:e5e8 with SMTP id
 100-20020a170902056db02900ee9129e5e8mr16737471plf.70.1620512876425; Sat, 08
 May 2021 15:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com> <87k0oavdqq.fsf@cloudflare.com>
In-Reply-To: <87k0oavdqq.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 8 May 2021 15:27:45 -0700
Message-ID: <CAM_iQpVM-kixLX_HqQipLdKmg2kp3to_KfD82Y4NOL6MdLBhfA@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 00/10] sockmap: add sockmap support to Unix
 datagram socket
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiang Wang <jiang.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 7:07 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Thanks for the patches. I did a round of review.

Thanks for reviews!

>
> Out of curiosity - is there interest on your side to have sockmap
> splicing for UDP / UNIX dgram on transmit (sendmsg()) as well?

We don't need it so far. You are welcome to work on it if you need.

Thanks.
