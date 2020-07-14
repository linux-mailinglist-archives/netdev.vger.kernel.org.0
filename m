Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9668A21E7F7
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 08:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgGNGUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 02:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgGNGT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 02:19:59 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE4AC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:19:59 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id l17so4607128iok.7
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADokhtl22FGLCx0Ja4VulGrlhNbvSRbgUppC+5fnk8Y=;
        b=cC7joYEx3F/c7xvvQKV0rEUqn+KwocxltT0B9EdnrWUt3rhcp0LewXS4XFmwBwP1IX
         0qj1XrbbZF/RKFIMkhAjHm5QFRR4rhY+d4jxPIB9NBoOy7rzuXaq4WpGa1jXBf/tqVdq
         3NyHkNKJ5D7K0cpMtHVMc+rlfvalMhZvg8Zo2B46DMdheX0Yb+OqasBSKkCTrmnfBiMR
         DzIiOzCSTh0IuSqpsURwC2+1UNlUACDvp2mfG6wa+7Ww7ltF5L04wfPEwVTrn0si58bF
         4+kklQV3JJp0LIyR/MuoXrEqbTdodIdO6GFsMLF6y1eupFhx3Oa4418qzWoYApWFGLVH
         1BSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADokhtl22FGLCx0Ja4VulGrlhNbvSRbgUppC+5fnk8Y=;
        b=TxIWBNw8Va+Mex/G3rVyunqzQ6GdXOeTI4mE5JTGUrq/OhWpAK9nJQs3dhQnJCZkz5
         arCva0q6t/E9Em2RmX8MdDx4SL6LOzVC+Agk7g/ba3GL10iU0xzG5fsbxmdRhaPQt0bR
         V73HA4ijqyqB/ak+gvvF3czDgQYU/PP1gnCfhjmFnsO3v3r9eoAM5dyhiYbhpLIZBTaw
         lTn9cfDDR6sZpxm/CXCoZQK/EHiNH8oLzzqzjnAEEJElezdZ7fq9OKQ9ZLacUfFfgpuY
         VULdFI3T09EGycsjDmYbNEd8DkeyDTyP+92vqMnbm6dua6kAlFnJ47ZBqWWCvqNzRkbB
         qHKg==
X-Gm-Message-State: AOAM533r2iksL8BvKzPyQUKClfUiRbCims9KB7PjxIzH8Dbn6r3uzGjd
        /nOd8VlzA5cVMDGMfKm044QCi7KG8s3c+T5nDJlVKcpBHhM=
X-Google-Smtp-Source: ABdhPJygixK6sT9AnnWgTfnr/yPyPgfKkz7OuN6mlw8HVvUD8qeZimHp5FjMIHeGWDjD+j/RyHciUCxSGnFf4yXUlDo=
X-Received: by 2002:a05:6638:14b:: with SMTP id y11mr4251696jao.49.1594707598821;
 Mon, 13 Jul 2020 23:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <CA+kHd+cdzU2qxvHxUNcPtEZiwrDHFCgraOd=BdksMs-snZRUXQ@mail.gmail.com>
 <CA+kHd+ejR-WcVj_PGz9OHXOvSH51R2hQA+NQiLUnqoxE6QQd+g@mail.gmail.com>
 <CA+kHd+cTpqDa+-42Mg1FfNTD9rK7UXR7qjjQUwxta8EO2ahxjg@mail.gmail.com> <CA+kHd+fh2UW4FvxL4v_rd8mQ=avuzHxb=n_ogpVwCMSXVTCeAg@mail.gmail.com>
In-Reply-To: <CA+kHd+fh2UW4FvxL4v_rd8mQ=avuzHxb=n_ogpVwCMSXVTCeAg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 13 Jul 2020 23:19:47 -0700
Message-ID: <CAM_iQpW6UfborPC6Qh8+Lp4fQQSOjA+HOHtKsmP6oos655HsaQ@mail.gmail.com>
Subject: Re: PATCH ax25: Don't hold skb lock while doing blocking read
To:     Thomas Habets <thomas@habets.se>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 12:53 PM Thomas Habets <thomas@habets.se> wrote:
>
> Here's a test program that illustrates the problem:
> https://github.com/ThomasHabets/radiostuff/blob/master/ax25/axftp/examples/client_lockcheck.cc
>
> Before this patch, this hangs, because the read(2) blocks the
> write(2).
>
> I see that calling skb_recv_datagram without this lock is done in
> pep_sock_accept() and atalk_recvmsg() and others, which is what makes
> me think it's safe to do here too. But I'm far from an expert on skb
> lock semantics.

A proper fix here is just to release the sock lock before going to
sleep in __skb_wait_for_more_packets(). You can take a look at
how sk_wait_event() handles this.

Of course, not all callers call it with sock lock, so it needs some
additional work.

Thanks.
