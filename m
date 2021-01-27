Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BD7305E55
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhA0ObS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhA0ObH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:31:07 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF0DC061756
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:30:27 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id g5so783903uak.10
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q0OciNgCIzSI2IY36uVRRwblVcbGfdple6Q4mhsom/w=;
        b=a4pBXI0XVAC/4j3m8gIClrjBFsO0ql8zs6gR5wcURRqaYPhmAjCgPxYxF8r9xrFTbE
         ffVnpnR+inv69JB6Rffd2Tgagex2byG9t5dsRb3gSzgiAHfQ/U7uIbq0mfElDBfQ8DLs
         8lTiwuz3zjoerRUHLSQx0oQMuduoN3elBv9Nq5TjEl8H8/J+k40WQlHSAk2A8dQbA/Xc
         VQbVASosByEdFZno39YUeod2MymSJ4w/JDbzwUAsD7q5MXS+Oce8f/B5zh7TaBucmGLA
         556gDhHKdPE/j5KfwsfhtbpBhqyz1wjpCOpW+DtTekIOJAPaiHmASRAbkCjhp/mem4Uz
         JgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q0OciNgCIzSI2IY36uVRRwblVcbGfdple6Q4mhsom/w=;
        b=Qd4no7bQ5IkX1N4N840dTMWjBO0tY2FhHOZ6gCM+Ciium/LT/oUVjRpLZPpE+A5Yvw
         ATivC+6EhgCC7EW8dlY53cXG6FnbxsK751j8x6zXvc3e3fsGcVVJwbEwrtJD/PfuoApR
         nkGag5AgaTt3CoATuGmY5QnaU26wEmYvCtzgHqn8VxogtiYyAGWhwpfL8+TR61iYE0ij
         kW8L4FT/HOJPppGizZHlLnJuvpxbW7ojLc8Rm0+K/290SKbLm3ERlUqTSKWqws5CP07X
         aLqnoHfpR7iAQvWtDDg0Ibp68wUGyNny8X2JMlx97fGdIpXjf0pihEpaeDq3GGJg7f6B
         K9bQ==
X-Gm-Message-State: AOAM5324kzYtRwqoKJ0U6gBLpHhkJWPWXmhMJAtQN0KuF46198CZQ5L/
        Q5EC2drDdpww3NJXlYRbUHhi8XLJRtc=
X-Google-Smtp-Source: ABdhPJxCc2YdSGyrMGY+2tQEHbKfc8PADzMR12fT7M9BfxURwvl2BTMVFzbPA11ZKcTQY1bJYPQ+PA==
X-Received: by 2002:a9f:29e6:: with SMTP id s93mr8233538uas.113.1611757826320;
        Wed, 27 Jan 2021 06:30:26 -0800 (PST)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id a22sm326385vkm.0.2021.01.27.06.29.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 06:29:54 -0800 (PST)
Received: by mail-vs1-f46.google.com with SMTP id j138so1206799vsd.8
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:29:45 -0800 (PST)
X-Received: by 2002:a67:c10f:: with SMTP id d15mr8063009vsj.14.1611757784589;
 Wed, 27 Jan 2021 06:29:44 -0800 (PST)
MIME-Version: 1.0
References: <1611741189-45892-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611741189-45892-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 09:29:08 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfERdgtzb4QGrWgCw4Y_t8kCvA5rjokA2YfrSn9qwmn-w@mail.gmail.com>
Message-ID: <CA+FuTSfERdgtzb4QGrWgCw4Y_t8kCvA5rjokA2YfrSn9qwmn-w@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: halbtc8723b2ant: Remove redundant code
To:     Abaci Team <abaci-bugfix@linux.alibaba.com>
Cc:     pkshih@realtek.com, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, lee.jones@linaro.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 6:05 AM Abaci Team
<abaci-bugfix@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
>
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:
> 1876:11-13: WARNING: possible condition with no effect (if == else).
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Suggested-by: Jiapeng Zhong <oswb@linux.alibaba.com>
> Signed-off-by: Abaci Team <abaci-bugfix@linux.alibaba.com>

Signed-off-by lines need to have a real name. See
Documentation/process/submitting-patches.rst

With that change

Acked-by: Willem de Bruijn <willemb@google.com>
