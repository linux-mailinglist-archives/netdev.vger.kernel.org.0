Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AC33CCD5
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390706AbfFKNX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 09:23:29 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:44506 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387578AbfFKNX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 09:23:29 -0400
Received: by mail-ot1-f46.google.com with SMTP id b7so11799258otl.11
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 06:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4pFByX/gV8SRk15tIVamc1Q+Obh4R2wV+e3nxQGfMbU=;
        b=VN3PefCcf6ZBx33aEZppw+UOr8b0JmdPHrn/AxdM3LA/TOK90kRKnkuAKb5ifwY/Te
         4Xje3Z9w7NXhKYFHej+4lyKyaziqnH5O1EA4Re22ljfOQRwjlkmIXzOjMUrU5llC7tQC
         JuljcioMxbYg+irLIC3XHyPcG0G0HnGa0PzAz0WSSc0pAs0SxfhwJw8CamoeAcifty7S
         W9TNpzl+RYGsBY5S1Jp0aEBbsV67sERXsSrutjApGP6CVowZosisaNVE4nOn/ToY120a
         0OYFOrVVeDGedlZbuV0DSYZzUoCwdNkdRI5fenHuUEYHcvIosfISUkNKZQ0ZHWaadMMd
         LH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4pFByX/gV8SRk15tIVamc1Q+Obh4R2wV+e3nxQGfMbU=;
        b=OQBfbMDzJzKjtxP10EnPgh7hUfaVsLRVlV9PT1HvUffoucxx2v/wLP73XeNf6LeQbZ
         fySqmvcBG7bPAMeng3jaWTTxikyAVC1+PESMys22NFTaYohfWnwUvRHCIgUrQ6ixYGil
         /6mEwKS+UrJYC0AP87fHscasgYqtyaDrz0UioPtCiKQgfPHu5xKMQ94Rc7ww1HaxgA6M
         JTyrTYqj24LZnlDECYA0PGs9pp/nR5j8lLL5yABQCSzdIEJ2G9dkbLwjRf2p9E0CGYNp
         E7gIoWOhumdlqi4s3G/1KWtG9OZmbIFUOHReo9BolgEFkuU4fj7PeegmWlRm2G0KpQkD
         5UiA==
X-Gm-Message-State: APjAAAWxoYccvGOO2yJazA0HplvsjcLn0T8K2Wnztbcj0Z05efIF1AVa
        hmHvZSZbuZK74rLcWXDIx9tlS173Nt0JqxRLWwxM2g==
X-Google-Smtp-Source: APXvYqw04c5crPepK/1SeUOjGW0gpdNUga1WWqQEiJh4t/8usDrrtbdKXz+MaetJfkQfJj/08clqAr/yz65+YHu3weg=
X-Received: by 2002:a05:6830:108d:: with SMTP id y13mr36088541oto.255.1560259408229;
 Tue, 11 Jun 2019 06:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAHx7fy4nNq-iWVGF7CWuDi8W_BDRVLQg3QfS_R54eEO5bsXj3Q@mail.gmail.com>
 <CADVnQymPcJJ-TnsNkZm-r+PrhxHjPLLLiDhf3GjeBjSTGJwbkw@mail.gmail.com>
 <CAHx7fy5bSghKONyYSW-4oXbEKLHUxYC7vE=ZiKLXUED-iuuCdw@mail.gmail.com>
 <CADVnQy=P=P1iPxrgqQ1U5xwY7Wj3H54XF1sfTyi92mQkLgjb6g@mail.gmail.com> <CAHx7fy68uTURceZtzYEnvdZ1pD2_F0dNJKjB7c7JTT8pjNKRSw@mail.gmail.com>
In-Reply-To: <CAHx7fy68uTURceZtzYEnvdZ1pD2_F0dNJKjB7c7JTT8pjNKRSw@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 11 Jun 2019 09:23:11 -0400
Message-ID: <CADVnQymT2zPDnmN6jp5NonQqyZHFRdW9CoiRL=MKKEbqVcySkA@mail.gmail.com>
Subject: Re: tp->copied_seq used before assignment in tcp_check_urg
To:     Zhongjie Wang <zwang048@ucr.edu>
Cc:     Netdev <netdev@vger.kernel.org>, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 2:46 AM Zhongjie Wang <zwang048@ucr.edu> wrote:
>
> Hi Neal,
>
> Thanks for your valuable feedback! Yes, I think you are right.
> It seems not a problem if tp->urg_data and tp->urg_seq are used together.
> From our test results, we can only see there are some paths requiring
> specific initial sequence number to reach.
> But as you said, it would not cause a difference in the code logic.
> We haven't observed any abnormal states.

Great. Thanks for confirming!

cheers,
neal
