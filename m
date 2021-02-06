Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4721A31196E
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhBFDFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhBFDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 22:00:17 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBEDC061226
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 18:52:16 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id t15so2796263ual.6
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 18:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ESjeBadsRkrAl+qIXzCFj686nO8RcbYAT55ppoG4TfI=;
        b=iyOTr5Y38WWt2U+DhmDSY+CBq4jfRgX8ILyD7YpxBzkeNUR+cxPUF9DY77zDG0zUYh
         DyNhMeCsWL+QjDtPPEWCOyYQJ4FylyTU8H84s00folBHvMWIKo9oX2jesaP/QL2lJ0rL
         aXve1wzBt16y3WeQthTKPQsrVGvCaOT4UPeEq/IAdrd9P1sqxr8LmTsTcyNl9Nq81g04
         OAd2RRJg93oImvbz2d+9QM8gehWtbZ/kO+ItK6g8jE3h2YMCN8jCJpQYkUSY210Wl85Y
         9EjT7pAimi5fyPPnHw+fMRJjaOpwrHMNJf16Egtyy+81UeFVzXnN5IkO+VuCNFbKrYme
         2fBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ESjeBadsRkrAl+qIXzCFj686nO8RcbYAT55ppoG4TfI=;
        b=sthQFit7sZ2O0lXm6pLZf0T6xAIqovAzUDEZrcCfS1Qvb00RvXuhdVcfO1bjLGIEpd
         kBQOJcW2TuUS8dgQf5b15SV8TjYpQb+lDqZO3lFQQlBdTjfZD5IdDC5IL4LArosbBsKX
         XkvY5WXUfxhXsdeBbY06q7vnLI5WF+UTBcqZ8+DSxMyIXajwq111NqXlVfdGGospjhCa
         WMtUxWTAicpaZM2edkdLKwOB0OW71REdoPzmgbGfORO/6VWQqMJz4H8m5MKdUIbsBh/0
         UQkzdqVeBTFjwR1Pmnk1c70B5I/HhFrUMGw20AZ69M2D86AKAM1bO8lsIuQb6O5V4PKk
         2GSA==
X-Gm-Message-State: AOAM533Rx7wWXnj/ifpSPMGBCcydxQjuHNfYao4Uo39gGiSBgkhTAjqW
        Yur8IcfWUECLSaG8xPKc1g0/HQCNgXk=
X-Google-Smtp-Source: ABdhPJx9MSOon08i7KcaILFJel6rjljDewFPHzjG6+OP7/PWRmMhRSfW/cLTJtMvxf0Nzrvubq7pLg==
X-Received: by 2002:ab0:614d:: with SMTP id w13mr5275310uan.67.1612579934557;
        Fri, 05 Feb 2021 18:52:14 -0800 (PST)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com. [209.85.221.181])
        by smtp.gmail.com with ESMTPSA id t185sm1285779vkb.10.2021.02.05.18.52.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 18:52:13 -0800 (PST)
Received: by mail-vk1-f181.google.com with SMTP id k1so1911353vkb.11
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 18:52:13 -0800 (PST)
X-Received: by 2002:a1f:ae81:: with SMTP id x123mr5333772vke.1.1612579932931;
 Fri, 05 Feb 2021 18:52:12 -0800 (PST)
MIME-Version: 1.0
References: <20210205224124.21345-1-xie.he.0141@gmail.com>
In-Reply-To: <20210205224124.21345-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 5 Feb 2021 21:51:36 -0500
X-Gmail-Original-Message-ID: <CA+FuTScLTZqZhNU7bWEw4OMTQzcKV106iRLwA--La0uH+JrTtg@mail.gmail.com>
Message-ID: <CA+FuTScLTZqZhNU7bWEw4OMTQzcKV106iRLwA--La0uH+JrTtg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Improve the comment about LL header
 visibility criteria
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 5:42 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> The "dev_has_header" function, recently added in
> commit d549699048b4 ("net/packet: fix packet receive on L3 devices
> without visible hard header"),
> is more accurate as criteria for determining whether a device exposes
> the LL header to upper layers, because in addition to dev->header_ops,
> it also checks for dev->header_ops->create.
>
> When transmitting an skb on a device, dev_hard_header can be called to
> generate an LL header. dev_hard_header will only generate a header if
> dev->header_ops->create is present.
>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Indeed, existence of dev->header_ops->create is the deciding factor. Thanks Xie.
