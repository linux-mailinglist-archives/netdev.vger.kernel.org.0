Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023C849D28E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbiAZThG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244467AbiAZThG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:37:06 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA56C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:37:05 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id l1so643802uap.8
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ov8sR96UJZP9jcwN/mm9WE7GxDKJOLyGvYLjiEWOfco=;
        b=ZHDx7HuohoRPAwMSeUakSJJgMsVtz8QSFITD2hoE9TGZvDkCL8IZqrYtgb/UhJGyaS
         V68rPVtbiZi9G2oCKwW6wEAir3RUmODJ5MlHIbgy0f1szRiIWK38Ek73Pt4pK7boT0Dr
         v6BjbYl4hFMc8WabY71UjCF7tQ4UEYWcrerKy4oN8/vAghNGK9W99YfqK+BnMT5t29YJ
         tYbAAHYkXq1KHSa9mxsrU93YZbT3w8Zk6HDOzIzyqBS6vGUpgdBMpLL0h/3vh6t9xIFV
         LuJ2/hLwi4B/iNdPrsfhETUr5K32MbMJ4kDSg2cwOXZiTuNQOxVKthaE+X+f5ig/erV+
         R1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ov8sR96UJZP9jcwN/mm9WE7GxDKJOLyGvYLjiEWOfco=;
        b=tEAd4BGaLYXSiWYSzN+bKMh2wmmjHbY6ft9vanNdN/C8BpKFV5DNV5gXR0qK3qq8hT
         DzB5F+oHLkwPhIPUr0VtaqwB2W2SV8WYb/riZcWg/dDDm77CLR4HgZJ8dnSPdDfml7Wc
         uPp6vsI4KtH/tk0F6CvbmJX/QUZtvbSx0mhNpFjJOmN89ORaUBVI4RMke64aOpOyTLAp
         Zy4rJfW2q4VMfgNZ0EUaVkakfmiUOxlQx0WSHW43c5B58DXL0ms3oFvWGtO1u2Tg1g4h
         rh80YTzhLh/24Y6fZES/Xz8j9AUTZ5rNsca92HYdzqxV6+G7xtrV7oNSQLeYLTbKkdgs
         rKlQ==
X-Gm-Message-State: AOAM532N1KZOtBqbn+Y7GSOqgZYxt7TsF21Fzz8kdvobBg1wfdhaJFDj
        QCwE9m+/Zhd65fglvMHvVBgX8x7MwE0=
X-Google-Smtp-Source: ABdhPJzr5+8AqmGn/u34THfyqYCXJwQQI0PIci43jGpPeNnPrr66Z+YtWzaXJ2w3Ibp7zWvqyAIHCg==
X-Received: by 2002:a05:6102:226d:: with SMTP id v13mr147950vsd.63.1643225824872;
        Wed, 26 Jan 2022 11:37:04 -0800 (PST)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id p2sm708404uao.1.2022.01.26.11.37.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 11:37:04 -0800 (PST)
Received: by mail-ua1-f45.google.com with SMTP id y4so711668uad.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:37:04 -0800 (PST)
X-Received: by 2002:a05:6102:d87:: with SMTP id d7mr365519vst.60.1643225823948;
 Wed, 26 Jan 2022 11:37:03 -0800 (PST)
MIME-Version: 1.0
References: <20220126191109.2822706-1-kuba@kernel.org> <20220126191109.2822706-11-kuba@kernel.org>
In-Reply-To: <20220126191109.2822706-11-kuba@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jan 2022 14:36:28 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfOPomWTXY7rV4kqYYwvZ0Vgir5SAnEFn8pWbg_q8974Q@mail.gmail.com>
Message-ID: <CA+FuTSfOPomWTXY7rV4kqYYwvZ0Vgir5SAnEFn8pWbg_q8974Q@mail.gmail.com>
Subject: Re: [PATCH net-next 10/15] udp: remove inner_udp_hdr()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 2:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Not used since added in v3.8.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Willem de Bruijn <willemb@google.com>
