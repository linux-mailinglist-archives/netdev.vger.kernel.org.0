Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513F82A0B46
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgJ3QfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3QfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:35:04 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1126C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:35:03 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id 128so897030vso.7
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rnjsk8TKQUAdnwhwPXz/u9B966+7wes/L6l2QbLyXdg=;
        b=q4e/hQc/N29fRXAYE3G4wTsy/UxTBUrcWIh/R8j8wcsjUJeq7bIHiiWs/M/OpgsETY
         wpGe/uyos13lkcL9uM/UZB62fiCuSVaSixMCfBHAXPuAXGI7LLpbSUIFp7dpqn2SIzqg
         EL+qKVq0PVv0qU21DJctbxqx+2cl7EKf7ogHdYfM7HednRek17cscQUDjWvnWjU9eSpe
         DqH+hqfEYDXgCugEKiiJhsXOlhJOhBysuyCobBn8j4jmsHrSZ+qyO0kSl3O2dsIwmOLk
         ayxNSplxahD7dvHSi0pTjoM0aZ5r4R3rrdkRnGtuPgxJPen48gVaa018ysjpCifRBIEO
         hZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rnjsk8TKQUAdnwhwPXz/u9B966+7wes/L6l2QbLyXdg=;
        b=ktySSUCY1zSfmzo2eb31oVEwjipryq2gPE9z9pYxXPVHVU2MTYBO2/Z1FhqxWmSImw
         r+BVRtfixNbSePwDa0vc47DjsIv5OlTkycmtsrWLO3c0+Jg0DNth1rpjqSjKEF4R/66b
         xPIbjwDD9rrqEiYXbWLQ1FDbKzCfQeGTLWIxVcCKq0a+JjblIr76BWiqjMzYiPNs1rV/
         /o1Tsx+2YjrHJq+UUio/5/s88cuvbAD2QoUnOcdWnc4Eiz363lhWQ4jQuCc2UtDx2dWD
         QrFVk5b1Znh152GWe72I7m01pC9dTcze47uET1KrNhbi2iZ4lnmE7rPRniOe8O9ZHHOP
         vGlw==
X-Gm-Message-State: AOAM531lawUj3k9ThG+CIoeTHpBFGusTMTaIUQFQ7m2XyQcbbTxoNW82
        BAvTiAky0f6zqGHQ/57cWfAlBVXY6IE=
X-Google-Smtp-Source: ABdhPJxKLDoGB/LxrYQeHSSP0KIRlTV1Do8maT2iCJ/5HfDUCRz0OJA5HwS3YS3dCvxcIbiEWC0QxA==
X-Received: by 2002:a05:6102:20cb:: with SMTP id i11mr1242387vsr.18.1604075702653;
        Fri, 30 Oct 2020 09:35:02 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id 105sm692522uat.18.2020.10.30.09.35.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 09:35:01 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id 128so896966vso.7
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:35:01 -0700 (PDT)
X-Received: by 2002:a67:b607:: with SMTP id d7mr8309389vsm.28.1604075701177;
 Fri, 30 Oct 2020 09:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com> <20201030022839.438135-2-xie.he.0141@gmail.com>
In-Reply-To: <20201030022839.438135-2-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 12:34:25 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdeP7n1eQU2L2qSCEdJVc=Ezs+PvCof+YJfDjiEFZeH_w@mail.gmail.com>
Message-ID: <CA+FuTSdeP7n1eQU2L2qSCEdJVc=Ezs+PvCof+YJfDjiEFZeH_w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:31 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> 1.
> When the fr_rx function drops a received frame (because the protocol type
> is not supported, or because the PVC virtual device that corresponds to
> the DLCI number and the protocol type doesn't exist), the function frees
> the skb and returns.
>
> The code for freeing the skb and returning is repeated several times, this
> patch uses "goto rx_drop" to replace them so that the code looks cleaner.
>
> 2.
> Add code to increase the stats.rx_dropped count whenever we drop a frame.
> Increase the stats.rx_dropped count both after "goto rx_drop" and after
> "goto rx_error" because I think we should increase this value whenever an
> skb is dropped.

In general we try to avoid changing counter behavior like that, as
existing users
may depend on current behavior, e.g., in dashboards or automated monitoring.

I don't know how realistic that is in this specific case, no strong
objections. Use
good judgment.
