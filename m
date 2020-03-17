Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A016518895D
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCQPpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:45:30 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:32925 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgCQPp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:45:29 -0400
Received: by mail-vk1-f196.google.com with SMTP id d11so4373982vko.0
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqwE0LST7bQrMlS1npkM81NgJLaEPEMndv6Fs6jOD0Q=;
        b=PhRozuqb3/yllPbcOt9nm5DoWkHAVkcVOmhTNXefUe95wiUC+Gohh8hKoKtKTraQic
         M6WN6kZOkNRD/QkU4T2xreIdRfS6+zMAMZx2ji+PADf5Gz0Y/t22K7QQJ4Uqg3cbsO8u
         Dsj1v5tUrR3OR7cFyZoqgKR8efGtBn9eC3Hzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqwE0LST7bQrMlS1npkM81NgJLaEPEMndv6Fs6jOD0Q=;
        b=L5UWspfgWJ3gMVneGOSnywQHdrxvRGUX/i5W5w+cbyKXDraQRSrQJdHRrQID5MUNSI
         VtYWQMuslbX3/w78Bv+X0PW4ZGd94RKsXxB/U7VIzRdGmgT1I1HLVV/S+Okm1pSrcCZM
         GwWm3qXOWDvRGSq0XcU5dfxUx9/qySfiHCxYyBVc4Nb30L1dbk05NdfWuciwPMagZn07
         SBSiIh+Q57dOYMonqCV9hsF6/ZT9TBdwPcc2YCbVIB5ge/n6aJFcwbnrQ+VRhVHF5n9W
         lDmiK56h8U4N52H2F+rcZE/ETKbJM5ciawMxm2fVg6YO18bFfWv7wKhP6y+dZC2rVC6T
         J94w==
X-Gm-Message-State: ANhLgQ1I4zf8wyb0PKyfSYpAC6SM//qiWUr16EeJ/jjPiYtrur9O48G8
        bzXiTkcJA4l5dzOGB7Sm3xS5AeuDaOU=
X-Google-Smtp-Source: ADFU+vsi3VdYATXu5N/lDW7VtVQXvtrMmUXnn7GltbJT2+w4J7cr0vwL3IifDvyPqSAWTGrC+tbjlw==
X-Received: by 2002:a1f:b6d7:: with SMTP id g206mr4332832vkf.8.1584459923248;
        Tue, 17 Mar 2020 08:45:23 -0700 (PDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id y136sm1507962vkd.16.2020.03.17.08.45.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:45:23 -0700 (PDT)
Received: by mail-vs1-f52.google.com with SMTP id p7so11970967vso.6
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:45:22 -0700 (PDT)
X-Received: by 2002:a05:6102:1cf:: with SMTP id s15mr4040657vsq.109.1584459921604;
 Tue, 17 Mar 2020 08:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200103045016.12459-1-wgong@codeaurora.org> <20200105.144704.221506192255563950.davem@davemloft.net>
 <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com> <20200317102604.GD1130294@kroah.com>
In-Reply-To: <20200317102604.GD1130294@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 17 Mar 2020 08:45:09 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XXPACnPt=5=7gH3L6DufZ4tLSPTN-AtTAmvi5KAJuP6A@mail.gmail.com>
Message-ID: <CAD=FV=XXPACnPt=5=7gH3L6DufZ4tLSPTN-AtTAmvi5KAJuP6A@mail.gmail.com>
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
To:     Greg KH <greg@kroah.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath11k@lists.infradead.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Mar 17, 2020 at 3:26 AM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Feb 25, 2020 at 02:52:24PM -0800, Doug Anderson wrote:
> > Hi,
> >
> >
> > On Sun, Jan 5, 2020 at 2:47 PM David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Wen Gong <wgong@codeaurora.org>
> > > Date: Fri,  3 Jan 2020 12:50:16 +0800
> > >
> > > > The len used for skb_put_padto is wrong, it need to add len of hdr.
> > >
> > > Thanks, applied.
> >
> > I noticed this patch is in mainline now as:
> >
> > ce57785bf91b net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
> >
> > Though I'm not an expert on the code, it feels like a stable candidate
> > unless someone objects.
>
> Stable candidate for what tree(s)?

I noticed that it was lacking and applied cleanly on 5.4.  As of
5.4.25 it's still not stable there.  I only noticed it because I was
comparing all the patches in mainline in "net/qrtr" with what we had
in our tree and stumbled upon this one.

Looking at it a little more carefully, I guess you could say:

Fixes: e7044482c8ac ("net: qrtr: Pass source and destination to
enqueue functions")

...though it will be trickier to apply past commit 194ccc88297a ("net:
qrtr: Support decoding incoming v2 packets") just because the math
changed.

-Doug
