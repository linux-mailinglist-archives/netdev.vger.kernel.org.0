Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473F4267B35
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 17:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgILPUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 11:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgILPUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 11:20:19 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E55C061573;
        Sat, 12 Sep 2020 08:20:18 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id y5so10946919otg.5;
        Sat, 12 Sep 2020 08:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fo9uIYfYdavh6FlcFZkkGbDCKuvjGNXRzN0vh8S869w=;
        b=cjD6oMG5w+KpyEFu9cIwxyzDENFMLFaCpZ4QQ7rJyVFZK1XHSowipfzw0GPJKaTw+/
         totPHpIgtVdNMpiQ2dG+88n6GIhVisw9kdqyC6GQtLg2iCzvqAyokUR/uwv3ACqU2IqY
         6x3fG54GfCmy56vHayTZRXiKKVugpyFYqes705AQNF0iZlQ+QiGLTNS3Spxp7Wn3LZBm
         lm4MQEcVpUBrC9IBV0MowhpVHiS4Qt6pGKAv/DMfY3MDiocOXU9sZZCp1RmMjK1bHpD0
         5Whuu595++T72sC2OIXCKvUxB1Oxi0PwcRkHZf5ZBsFkjisUMBeQuw9l5vW622hGGy4d
         Gzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fo9uIYfYdavh6FlcFZkkGbDCKuvjGNXRzN0vh8S869w=;
        b=PaVsxk0mlg2RYUza+sqM5/aImFoTRLfJdwYJi2IJOgojhdbNuB1y27qbdeJMAHClsl
         vO1eVJtyjvb6DE85zZxCtsihA/FiwZG9c6kK6hTujaYkdsRFVLGSXlkXD6wpch9dKVlZ
         gvnzKeqb11sdfh2+ioFc3qiGUjUAjV+3Aju8XjDLAOfJ7mk3h6UPQ71IP1QhkG+S2eNh
         97lLPfxT/qw1xs5Xzbh06yFVqrNf3RwbX/xvPCsDL8cNW8QwRb/wPvwog85VrCLKxsZt
         zAwD0GvuYfLHDRYaxovbU7DmEbc5xh7eEBpRMeME9+zLcfH9T0EgjILXc6AHvnNpGaAQ
         RH6g==
X-Gm-Message-State: AOAM530nZrzEG1N67OBouFZ6KN1jxm1brTgVAJlFe2KC/QofDPRWv87O
        IZtTUCrOsz8TXwEZ4vU/3MoFHt4BsE/TNVBG9ZzjMwEthqiUVA==
X-Google-Smtp-Source: ABdhPJz0NCwM2ZgDabxxN9iTCTmMmQ7+vu/J4Pn1B2whShMeWwC1BMsCY8H24XSxPWpktlSdQf+iSv1Z9sdm2ACq0y0=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr4204763oth.145.1599924017654;
 Sat, 12 Sep 2020 08:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200912144106.11799-1-oded.gabbay@gmail.com> <20200912144106.11799-9-oded.gabbay@gmail.com>
 <59a861d7-86e5-d806-a195-fd229d27ffb4@infradead.org>
In-Reply-To: <59a861d7-86e5-d806-a195-fd229d27ffb4@infradead.org>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Sat, 12 Sep 2020 18:19:50 +0300
Message-ID: <CAFCwf12kfQJk5XwcX7qRRC-oLfXAUr+DSdBv0X9RcEDpyxJirA@mail.gmail.com>
Subject: Re: [PATCH v2 08/14] habanalabs/gaudi: add a new IOCTL for NIC
 control operations
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Omer Shpigelman <oshpigelman@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 12, 2020 at 6:07 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi,
>
> On 9/12/20 7:41 AM, Oded Gabbay wrote:
> > +#define HL_IOCTL_NIC _IOWR('H', 0x07, struct hl_nic_args)
>
>
> ioctl numbers ('H') should be documented in
> Documentation/userspace-api/ioctl/ioctl-number.rst
>
> Sorry if I missed seeing that. (I scanned quickly.)
>
> thanks.
>
> --
> ~Randy
>

Hi Randy,
It is already documented for some time now:

'H'   00-0F  uapi/misc/habanalabs.h                                  conflict!

I think you commented on this a few releases ago and I added it then :)

Thanks,
Oded
