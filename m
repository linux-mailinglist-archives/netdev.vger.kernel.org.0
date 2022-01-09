Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF77488799
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 05:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiAIELA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 23:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiAIELA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 23:11:00 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3332C06173F;
        Sat,  8 Jan 2022 20:10:59 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id d1so28878544ybh.6;
        Sat, 08 Jan 2022 20:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHWv8vCmQocf8j1ncOVYaNumvu4dAkTmLmQDF+t6hvw=;
        b=fD0jHymcSp6lveuK1mk4zEK8mW+PVfq/FLlMF6dVhdDen99sh3Z13dyrn+FnUE5zZ8
         /d9D2KfdX6To+qF1DsMVg1Z8Dp38H0NQXDVYk9W+cddI3lhiPbgeiYOWPrlI+wlZc4SR
         wVQaNDyV/nh0AqhDSXsoWWgHI1zC98WeNGwZo7RlVFcmeZgFWInKYog9OUH1d++5pB9X
         yOE+IGWJT3vaPLCAo1Nx1pmghUp8y5ji4Q9wtQoSKrMvcKMMK+sfwXLs2cBkxQBfrLpE
         ohE/EKeregrhuU/UOd7/o40nxiSeW+Rvf5g6o22yryl43USzBXoX/cpAnsA0xW6T9rSb
         fkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHWv8vCmQocf8j1ncOVYaNumvu4dAkTmLmQDF+t6hvw=;
        b=HZH0YC1jpbuNsmGA/RngUnwOKVy1LPJuNNRc5yyBYAzOSByxKueAITzA2hUr2aymYV
         VvnZSzILc7mjsMftJzag4v0hrX3SuZ3ZKZxZrDM7TgxEHqFP/hSB0oBsFeZoXTBX0wMp
         7yMG4dxxHkKSO8PLQfRHEs3ylFlxA+Q7zfsDCJVHrNGdZ102ya58Gi6wSVq33UKKMDnT
         6/GwgHOVI3/wHY1CGEGtMma15cgV0yofiwvierIfXnhHXL/0gvlH2nt2dLFlFr3v+U4O
         U9lXQW0w3+IKdbV+grtvV98SnwJ+1VS8RoDXStAMaxIv5cOiWAdkSAM29cISIt+DdQzG
         q4kA==
X-Gm-Message-State: AOAM531zYtWOftJgiNA+PKgejaVlGkX2BSLvxQAD9pIBbjhEkxYCXhUo
        qiK9Mexy1dHC+c6dEEQ4OFAgvwxPipxKZPXO3SHXjqe0ftU=
X-Google-Smtp-Source: ABdhPJzPWCq3pnVvWBRCL9v7fe6zdCxN8v63iDGAaqF3AeVneP6THpvAsobSRDdoFEIU0fGzxgvaeYgM/BJc3tFv+gQ=
X-Received: by 2002:a25:500f:: with SMTP id e15mr86479940ybb.312.1641701458923;
 Sat, 08 Jan 2022 20:10:58 -0800 (PST)
MIME-Version: 1.0
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
 <35cebb4b-3a1d-fa47-4d49-1a516f36af4f@oracle.com>
In-Reply-To: <35cebb4b-3a1d-fa47-4d49-1a516f36af4f@oracle.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Sun, 9 Jan 2022 05:10:48 +0100
Message-ID: <CAKXUXMwQE6Z1EFYOtixwA+8nLZySxdHH9xHiOkGhcy5p0sr9xQ@mail.gmail.com>
Subject: Re: Observation of a memory leak with commit 314001f0bf92 ("af_unix:
 Add OOB support")
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 6:55 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
>
> Hi Lukas,
>
> I took a look at the patch and I fail to see how prepare_creds() could
> be impacted by the patch. The only reference to a cred in the patch is
> via maybe_add_creds().
>
> prepare_creds() is called to make a copy of the current creds which will
> be later modified. If there is any leak it would be in the caller not
> releasing the memory. The patch does not do anything with creds.
>
> If there is any more information that can help identify the issue, I
> will be happy to look into it.
>

Here is more information:

Here are all crash reports:

https://elisa-builder-00.iol.unh.edu/syzkaller-next/crash?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3

and here at the bottom of the page is a C program that shows the
memory leak with the typical memory leak detections switched on:

https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3

Please try to reproduce this on your machine. If you need more
instructions on how to set up the kernel to get this program to
reproduce the issue, please let us know.

> Note that a lot of bugs are timing related, so while it might seem that
> a change is causing the problem, it may not be the cause, it may just be
> changing the environment for the bug to show up.
>

Well, we are pretty sure that this commit makes it show up and
disappear depending on where it is included or reverted, respectively,
tested now on multiple kernel versions. So, to resolve the issue, we
just need to revert the commit.

Lukas

> Shoaib
>
> On 1/6/22 22:48, Lukas Bulwahn wrote:
> > Dear Rao and David,
> >
> >
> > In our syzkaller instance running on linux-next,
> > https://urldefense.com/v3/__https://elisa-builder-00.iol.unh.edu/syzkaller-next/__;!!ACWV5N9M2RV99hQ!YR_lD5j1kvA5QfrbPcM5nMVZZkWNcF-UEE4vKA20TPkslzzGDVPqpL-6heEhBZ_e$ , we have been
> > observing a memory leak in prepare_creds,
> > https://urldefense.com/v3/__https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3__;!!ACWV5N9M2RV99hQ!YR_lD5j1kvA5QfrbPcM5nMVZZkWNcF-UEE4vKA20TPkslzzGDVPqpL-6hS1luOMv$ ,
> > for quite some time.
> >
> > It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220104.
> > So, it is in mainline, was released and has not been fixed in
> > linux-next yet.
> >
> > As syzkaller also provides a reproducer, we bisected this memory leak
> > to be introduced with  commit 314001f0bf92 ("af_unix: Add OOB
> > support").
> >
> > We also tested that reverting this commit on torvalds' current tree
> > made the memory leak with the reproducer go away.
> >
> > Could you please have a look how your commit introduces this memory
> > leak? We will gladly support testing your fix in case help is needed.
> >
> >
> > Best regards,
> >
> > Lukas
