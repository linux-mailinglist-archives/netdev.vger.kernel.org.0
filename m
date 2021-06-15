Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7D83A77EE
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFOH0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFOH0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:26:44 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8F8C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:24:40 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p13so12609717pfw.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fhmga9+92lU2xzSjg+jWsn+O/2TzHnc32aUrE0R52zA=;
        b=XUWXwRf9PUZWJabQQc3AW0JlHJWgQbS+nrgI6dhpMBKm1YJWF7t3AvlR+khZkcWj1d
         uITuZMKMxNHDr4fUJg8X5cevYSBAGv3Nae1rtOoBRJgPASQVicTKt5Spz5QAHHrtUH2o
         w7413/UDH5CBwR4ToD0lnbtdn090bf81KarSjn7SSIhyE5CLSx6Bz7vxzrbQ3OEmLuWt
         Btzp/kFmd0Mz329rtWkM2CkDMGn9eg8qAJ5PPwahuTtobWsWPy3uNdHZK5zX5XgoKV5E
         BuQ7QB4DFnRORYE6E4d4c3Mv1MtUV4UA617gf85D2fQttj4nzYwot2CELy3ikhfj4YsR
         n/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fhmga9+92lU2xzSjg+jWsn+O/2TzHnc32aUrE0R52zA=;
        b=G9FidX7Wr7p9CskE4IJor4L5CeXTBCBpphZWoOTjZumRgQ+MuPiTnCVpwxgi9cAkyh
         7BVlgN9CyQoNk9tDtCkZdauCo0Rpn2dUprgQ14RhuSI+Dy35s5pKPqEWFT48hmN985PL
         OA/puB1H+M3eVrbwW6mg2XVb/C/pLV88mLJXUXc2wwhxQij2SiOelpvq97/TL88lTLMF
         ECPtJs7UpyLRLkg9h1mbyPxaZ6njPQwjMtHj52cOnKQLMBJnibd1SxeCZqgjihh+jFX6
         1FRcnSHGbU43BXbcnErSmrtE3bJkyCmFtbi/iJlerdWjBsMwJmQVDC952T0efRYMh8Y8
         PrSQ==
X-Gm-Message-State: AOAM530HJI3XdAUV2wB3PUfZihz3U4KBrIancrmAj2JhZMtpoWdFfHDe
        IQBxd7U22gtaTH7PtPXfulZa0MFk4+H1080QB2/i3Q==
X-Google-Smtp-Source: ABdhPJy7lIzl2bq8VzDDr7CEbECGu19hmgr1EtJ7zp1d0juWjUG62YofNqUeOj2N9z+DMD3bEjZN1JlIWGX9Bv+7/3c=
X-Received: by 2002:a62:a217:0:b029:2ee:48e1:fd92 with SMTP id
 m23-20020a62a2170000b02902ee48e1fd92mr3012050pff.55.1623741879502; Tue, 15
 Jun 2021 00:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-11-ryazanov.s.a@gmail.com>
In-Reply-To: <20210615003016.477-11-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 15 Jun 2021 09:33:41 +0200
Message-ID: <CAMZdPi9mSfaYFnAt5Qux7HtCMkE-4KkkGL8i8T3rtxNXekK+Eg@mail.gmail.com>
Subject: Re: [PATCH net-next 10/10] wwan: core: add WWAN common private data
 for netdev
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> The WWAN core not only multiplex the netdev configuration data, but
> process it too, and needs some space to store its private data
> associated with the netdev. Add a structure to keep common WWAN core
> data. The structure will be stored inside the netdev private data before
> WWAN driver private data and have a field to make it easier to access
> the driver data. Also add a helper function that simplifies drivers
> access to their data.

Would it be possible to store wwan_netdev_priv at the end of priv data instead?
That would allow drivers to use the standard netdev_priv without any change.
And would also simplify forwarding to rmnet (in mhi_net) since rmnet
uses netdev_priv.

Regards,
Loic

>
> At the moment we use the common WWAN private data to store the WWAN data
> link (channel) id at the time the link is created, and report it back to
> user using the .fill_info() RTNL callback. This should help the user to
> be aware which network interface is binded to which WWAN device data
> channel.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> CC: M Chetan Kumar <m.chetan.kumar@intel.com>
> CC: Intel Corporation <linuxwwan@intel.com>
> ---
>  drivers/net/mhi/net.c                 | 12 +++++------
>  drivers/net/mhi/proto_mbim.c          |  5 +++--
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 12 +++++------
>  drivers/net/wwan/wwan_core.c          | 29 ++++++++++++++++++++++++++-
>  include/linux/wwan.h                  | 18 +++++++++++++++++
>  5 files changed, 61 insertions(+), 15 deletions(-)
