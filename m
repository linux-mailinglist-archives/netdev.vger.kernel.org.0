Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BB02A4FB4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgKCTGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCTGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:06:54 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617ADC0613D1;
        Tue,  3 Nov 2020 11:06:53 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id s24so12786081ioj.13;
        Tue, 03 Nov 2020 11:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qGyMtRIQLnlNm/EnomVc125vrYCixa/qIYVoj7Qtwd8=;
        b=I1jPheWO7sXr278uV2qeJ4LQXOZAJToRKCqLqErbUYb/uuLVktG6OUtgXmUam7fZt+
         SB8U7r3qmZ5B4N8Mg8qVIfzBJCYyhQY6JgoHCIqHGI8V76BCoxqBnJuk6FQMzKQ58MTV
         qth6jGBRckkBE5FuJBxOPiSgFSh6JSd7m4CkEPTEYC20PG8DpsHDD/rlnZOSZBkT9uVf
         BVfnLw/nsQ075IEy6eV7Slgq8utl2RotPMxmhHd2Ba0WfvVCOHyVgDSyLvhRm0Q+zSk2
         WdYNjf3zbVaqqUZzAzszAFgBVGOEjEE+gN3pGT+nK7t2w7mrAD0MPOb6XkvvAVTel8/D
         d/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qGyMtRIQLnlNm/EnomVc125vrYCixa/qIYVoj7Qtwd8=;
        b=XEAVV9M1EKlq24bIRpP6XsVI09sPSzT60ReLRGj9LWotDZBIoMmM/WIywTcimnyHr8
         f5KAQxNwYHMXgAUMnFVNkVBii4UBS+8y6nQumWV364w/UgBiOTPjldiObBye5BVYHbIU
         KaqCCX1PPlLvUTjG8B0ROw+z4PiL2ey80N6O1up9c46xSvpRCFMqlWXfyBO5IoWNJXW6
         BP27U3k5dyYQUwK1SrNaZWivRrzUaQ4CRmOyMiCcVRFxP3tMD+GpSthsvZom6MbdI1ei
         lkO6maaSUHVz4gb0h1+NVniuUZD0jXwv71TjcSg9q5ViLiIHI4xWJG/7T6jWiulWp7ow
         fI+g==
X-Gm-Message-State: AOAM532GCeB4iUgVnn984qpTeZ3RghK0Z4qFK0QlOeSNHKqawCCwdjgv
        1PhM0//FIUdQrr41m/IlrhFynzpVPw/4rzT2Rf4=
X-Google-Smtp-Source: ABdhPJzhyk3LHgtdQSf0+6J6HDYwT6EJ9jorf8Gy1kr6DHGrX82bR8UfO+9V7ARp43/nAsc3le0RGQTZEZhQSAJN370=
X-Received: by 2002:a05:6638:2494:: with SMTP id x20mr16932939jat.83.1604430412646;
 Tue, 03 Nov 2020 11:06:52 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417033167.2823.10759249192027767614.stgit@localhost.localdomain> <CAEf4BzbyNVfkEe+X4ZW-vnWS_XhiD8sh059dNehGpX5eZrxaoQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbyNVfkEe+X4ZW-vnWS_XhiD8sh059dNehGpX5eZrxaoQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 3 Nov 2020 11:06:41 -0800
Message-ID: <CAKgT0UeCcJc-N9UBHP7bwSB4Ca8G9b2Gt14z=nMkduTYHPaGyg@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 1/5] selftests/bpf: Move test_tcppbf_user into test_progs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>, alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 10:34 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Oct 31, 2020 at 11:52 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > Recently a bug was missed due to the fact that test_tcpbpf_user is not a
> > part of test_progs. In order to prevent similar issues in the future move
> > the test functionality into test_progs. By doing this we can make certain
> > that it is a part of standard testing and will not be overlooked.
> >
> > As a part of moving the functionality into test_progs it is necessary to
> > integrate with the test_progs framework and to drop any redundant code.
> > This patch:
> > 1. Cleans up the include headers
> > 2. Dropped a duplicate definition of bpf_find_map
> > 3. Switched over to using test_progs specific cgroup functions
> > 4. Replaced printf calls with fprintf to stderr
>
> This is not necessary. test_progs intercept both stdout and stderr, so
> you could have kept the code as is and minimize this diff further. But
> it also doesn't matter all that much, so:

Yeah. I can probably just drop those changes if that is preferred. As
is all the printf/fprintf calls are eliminated by the end anyway.

> Acked-by: Andrii Nakryiko <andrii@kernel.org>

Thanks for the review.

- Alex
