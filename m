Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EAB314A02
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBIIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBIIKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:10:21 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6374C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:09:40 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id b9so29755586ejy.12
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g+8Yx8RrOrdk6ybKo2YDlUw7L+JS8M+MRrevOve+iro=;
        b=lBFVLHJSfPHkURlWry8/dKsYg6w4TAY12xiE1pdH9jiMHD01EN5RPAvjhOBDkZsQbF
         tTSFoKIlB8ZDy+rhIH4oPKA0tqmvWrGHU5vEFrrzQ1vDIqjO+I3UcJKsXSwWSpiCgmr0
         Cq/3hDSJ/X9WIgOSan+TnwxLniGX6cLv/pAiOWhsjZGXfxNtImGo0b5bqTOFAp3Zltei
         DSxetFVYlO3G1rJbSQslXiCyFT86Pn0YhV8O9iGjaF0x1cw7/9iaAmoxix04/hwfpMrH
         jHfiHdXJ/2/0ZPPSNShmwksbAk/isqyiX6W2X7UECdz5VmU6Kt8XWHyZ/54ttb46Owj0
         2jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g+8Yx8RrOrdk6ybKo2YDlUw7L+JS8M+MRrevOve+iro=;
        b=IZiM4FTlP6q1cv76YbBd/RAatRT0T1SU37Oe2XJysFTdJ0S7WJafc0x33wCm3Zdo0L
         1VgycqfT0xuhy4o0sPZLmGL/XGSUZOxFERlzaSaLya3TvjmkQ/OzmxagqRFCZYKWB5CI
         La/6FNlu/uGnsxAWqGqyoehuIGKibA0xbGpV3P9f+diwyuA4UGpQMQ6d5o9OkS1w2BV0
         5MeTm4XnFXzAl2pZH2/NHnkgepC1dDNE77ZyDwjQs8SooN0073yfhTVmotPlT4yGziIN
         dh4R2cEiZyx7mxW6lhz9ryKL6f2KmS0WlZbj5gALw609NJicyhO8bB0QGHqZ2ZCsvyyR
         L8uw==
X-Gm-Message-State: AOAM533rXtzYWq7JV8ryhP4bvWXcjmWkkNsTnA1Kv+T4SZrjUBvRdmWa
        tMNVqHOkLyES11rtLVVVyd0iqPONTCZU6oro1IM=
X-Google-Smtp-Source: ABdhPJwRlsgDzfPrinTeONbAGE7V4pXfy60WDszQd1f2HPpMQD1k5ZmV3/MzKVzcUC8hRL3Ef2T8B0m52R0XS0mZ5zg=
X-Received: by 2002:a17:906:19cf:: with SMTP id h15mr21427637ejd.167.1612858179475;
 Tue, 09 Feb 2021 00:09:39 -0800 (PST)
MIME-Version: 1.0
References: <20210208175010.4664-1-ap420073@gmail.com> <CAM_iQpU5Z_pZvwKSVBY6Ge8ADsTxsDh+2cvtoO+Oduqr9mXMQA@mail.gmail.com>
 <CAMArcTXXsWoRqcsg0-zkDTwPbAonBCo1tBiKTr7_ZBF1Y5NxqQ@mail.gmail.com> <CAM_iQpU=GXHQ=j+f5F9nHY8XA=v_qrfc0YDvEKJJ=nv02BXZTw@mail.gmail.com>
In-Reply-To: <CAM_iQpU=GXHQ=j+f5F9nHY8XA=v_qrfc0YDvEKJJ=nv02BXZTw@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 9 Feb 2021 17:09:27 +0900
Message-ID: <CAMArcTU1rhocJcvyiWiJ8JfLq8Quw_bTEGZzJSm3QpR_PXVj=Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8] mld: change context from atomic to sleepable
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 at 14:31, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Feb 8, 2021 at 6:17 PM Taehee Yoo <ap420073@gmail.com> wrote:
> > You're right, this patchset contains many unnecessary changes.
> > So I will send a v2 patch, which contains only the necessary changes.
> > And target branch will be 'net', not 'net-next'.
>
> Just to be clear: this is up to you. I am not suggesting they should
> target 'net', I am fine with 'net' or 'net-next'. All I suggest is to split
> them.
>
> Thanks!

Okay, I understand.
Thanks!

Taehee Yoo
