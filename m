Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBCE267EDA
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgIMIn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgIMInZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:43:25 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8539BC061573;
        Sun, 13 Sep 2020 01:43:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j7so3035563plk.11;
        Sun, 13 Sep 2020 01:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tOvuTNpBHpM6ThuiTo5W6caAcs2ZGSs9PAG6Ta+6HK4=;
        b=q+r6oS9OHhM0ZnRE5bCP47MQTo5Cl2chYyHuSMGLNDc7WGlY0OtxASyEPloSEHWhO1
         5MIEiqkjQMSjZG7JbYphcAskvTte2+HQBrFj/6DIPJNbtBYJAaYchWyTu+MpOtxzP7l2
         q6qtKdncxjlAuh+leJwqhOGfgAO2DvlpmzyibvTrPuGV3FJgovszUWqy9vHMcGtLwbJC
         FnoEcSNDfXdskqIvilWfz1C9AKG9F+cGvWaW5fy1ZZTtMeI/fXvOW1O5xLhgBeXlt8Cg
         9FrddmQBErzFZPJrztw8YTE6ne1f5Ay7sLaItX10pgLSl/ccxgY0fkbo1/KIj1HsoWUz
         9BGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tOvuTNpBHpM6ThuiTo5W6caAcs2ZGSs9PAG6Ta+6HK4=;
        b=o8fO166gQ/S3pwmdZxvO14kGXhjxx6I8lh0iVS83nIH8jwGSxf+GzBLK18YHb5c/m5
         805XfBhiN6lV4MIOPHHmWxTM3XErVlrxXvPNyHYcLaOzupxocvBBvjDIoTKMUOd2g2x4
         XxYaqOvIZ7rV+6QgMzrr1NfN6cp0QFfyCc8aVlWGwXqdHviTMzIQ27kmFb3JzrgQfWd/
         fdakB8dN3gWUD8xo4wy2sfobQFXwGsO/vrgxh3Pc8cXL/jl+ErCXPmAPef/PWSKWReOg
         d/UynR7eUiDAULdslSLarZWjzjikZz0xMDY33sX1mWnS7X0JSkFCwsBF4A9qWfyh5rjF
         COTw==
X-Gm-Message-State: AOAM531MKzwGySVBrG8Lef6uIV2F0RiCq1rY9/3UETcGySD7gAFD0s+l
        kLQrxAZfk9L6M2SvkpjOlPLW3y5IO5A6Ts+pozY3jH+q
X-Google-Smtp-Source: ABdhPJxriGj9iZ0DZV3S2LG/uMK4bjifT5yi7Wf9rrRWc1QXjvokJfsM/wXZiGd6kl1aBwZTrycR2SOIFKIGAAmrZ/U=
X-Received: by 2002:a17:902:b218:: with SMTP id t24mr9282818plr.113.1599986605156;
 Sun, 13 Sep 2020 01:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200911050359.25042-1-xie.he.0141@gmail.com> <CA+FuTSeOUKJYOFamA+fKBxEb22VosOXZRWGf2DungBGRorcyfg@mail.gmail.com>
 <CAJht_EOCZvubQRHuS_4F2vFgQSnhkrZBwLDxoougqKkm2qaCgg@mail.gmail.com> <CA+FuTScP5x-FG6AHKujvfbLUeSnQfx371Z7a=59BU8QKAm+GGw@mail.gmail.com>
In-Reply-To: <CA+FuTScP5x-FG6AHKujvfbLUeSnQfx371Z7a=59BU8QKAm+GGw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 13 Sep 2020 01:43:14 -0700
Message-ID: <CAJht_ENDCmmCEbJ2h4XNmCr40EXJSAyK_w3s2ymK_hRqPiMrjw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Fix a comment about hard_header_len
 and add a warning for it
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 1:11 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> I am concerned about adding a WARN_ON_ONCE that we already expect to
> fire on some platforms.
>
> Probably better to add the documentation without the warning.
>
> I know I suggested the check before, sorry for the churn, but I hadn't
> checked the existing state yet.

OK. No problem. It's always good to discuss and find out the best way
before we do the changes.

I'll drop the WARN_ON_ONCE part and resubmit the patch.
