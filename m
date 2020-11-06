Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BD72A9129
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgKFIW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgKFIW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:22:27 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391EBC0613CF;
        Fri,  6 Nov 2020 00:22:27 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id a65so505347wme.1;
        Fri, 06 Nov 2020 00:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+L0SSKDfRdDtml0qhBgXgz2gYCz2jiEZ+450rqCAA1Q=;
        b=F96YM0sK4AOpF0pMVLxSzdWhHspyZyET+amWExcyHfgQn9WFxdoJC8Cvws367SGFjp
         eef2R0HIbWkdK4pn9w0Q2wvA7TWjiacHH5sK8L1inSgVqFxNNDl14jJxLAR2M9xiMwoK
         a6/+i+YslwvaRvXMo2+yGCAT3LeFpm9YeG/IEqD2X/6ahkXnKrXyRBVzQUzj2vF8HuA0
         Y3T7mWVyNdcB2kCv7TwFn6aePYem+pjG4jctbPVvV2mJ3GwVXmrd3bnNcsBmwsuQLPLA
         oQUoDIJL8jQ8THTPryC3+r7+1P5MSGq3Pa466ym8yD47eqv1d86rti3OUsQVGmclwAp3
         N7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+L0SSKDfRdDtml0qhBgXgz2gYCz2jiEZ+450rqCAA1Q=;
        b=I58ztkV7f3HFmssj/amNi1/Q0kDcra++3HkyPAWpf1n0arsIRRInzzLSGnQAS/dLQ/
         xigsu4izQfCE8LWhaEsReLTDmd/gx9TWA1TunzW+oWRF+H0VaJ3z52eLiclgiU3GLqQ7
         E/eTQcVNYNHYX4xRhXMMKdWTpfXW4l/x6ToDfzFvMS1T4/08oapWLj+k+1psC5ohdS7L
         fFVuDAEVKK9rxWherRactupzIABmYkkHB/j4LH4YxMXfRuwcJYbjW3yQu7xzS73XrFAe
         ceaOpUnNhtl4MHIqqP5pfcKQTyYs2aC4ly+aSpfGCNFEkO+cLlQv/SA8oAOOB8SbVu35
         ahPw==
X-Gm-Message-State: AOAM530Lmyd5U6D5R0ysij50RyvHNFNWYg2bfzRGn0xg9lArizcZx914
        qyab+jgxOaah+bsnKHVBZJ7yLVl85W5oGacQHGg=
X-Google-Smtp-Source: ABdhPJx4Ho1Rq1sZ+MfB3aMzzgh5A91Fr1WihmOopnJyUa5ref4A9wfMq+ZhdKJZkUdc06fSrbFacIYmO5aWoG+ND4U=
X-Received: by 2002:a7b:c08e:: with SMTP id r14mr1149761wmh.165.1604650945987;
 Fri, 06 Nov 2020 00:22:25 -0800 (PST)
MIME-Version: 1.0
References: <c9649a2463f6ff6d55177498d2d8a36242e51ab7.1604648249.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <c9649a2463f6ff6d55177498d2d8a36242e51ab7.1604648249.git.xuanzhuo@linux.alibaba.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 6 Nov 2020 09:22:14 +0100
Message-ID: <CAJ+HfNifrVytXVvVfJ5Nr0JKwtg9vho5NKf9ciNgJzxZhQ-rsg@mail.gmail.com>
Subject: Re: [PATCH] xdp: auto off xdp by bond fd
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 at 08:41, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> By default, off xdp is implemented by actively calling netlink on the
> command line or in the program. This is very inconvenient for apps based
> on xdp. For example, an app based on xdp + xsk exits abnormally, but xdp
> is still working, which may cause some exceptions. And xsk cannot be
> automatically recycled. We need to bind xdp to the process in some
> cases, so that xdp can always be automatically released when the process =
exits.
>
> Although the signal can be used to handle this problem, it cannot handle
> some signals that cannot be captured. At the same time, it is
> inconvenient to use the signal to process in some cases. For example, a
> library based on xdp + xsk is not very convenient to use the signal solve
> this problem.
>
> This patch requires the app to actively call RTM_GETLINK after setting
> xdp and use RTEXT_FILTER_XDPFD flags to let the kernel generate an fd,
> and return it to the app through netlink. In this way, when the app
> closes fd or the process exits, the release callback of fd can trigger
> to off xdp.
>

Hi Xuan,

You'd like a "process scoped XDP attachment", right? I believe the
mechanism you're looking for is Andrii's bpf_link. Have look at commit
aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API").


Cheers,
Bj=C3=B6rn
