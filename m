Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD563481400
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhL2ORQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhL2ORQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:17:16 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93690C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:17:15 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id r15so37639340uao.3
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19TJ4H/cwfJhoc9aa4TDm49HVFtpsdIXSzyWSgnFggI=;
        b=j97TKmnn3LWLaBxnWyJ4d7/3PPSgP6bCXkWsad8Ha2b4eJSwVCUKogujPK/SJD0cW+
         frexak8Ej2mQz3HgmI7Z8KvRQqJEBgibe3bY8vnC7/K6EqiQ/7i/TUqoJ3ATemCOK6V7
         mD187WRD6cLkO8qqyTqilabZhJoktjK/4np0+B9WMvhi2gzKEW6yNxPxbZzpxKe5Bq4A
         LeXrxJS+kZQpGWMnBY1f+CzORsOhm12wfhfTexjiJ8qJUHfVWTjXnDkrl4uqv9okk2X7
         rsEuBWeZdZeSLQD4fjOXAqVsGrU+opLsQBxAsvA4zLlb2HNiisadPgj1GPN8RFatOuVg
         3o9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19TJ4H/cwfJhoc9aa4TDm49HVFtpsdIXSzyWSgnFggI=;
        b=PyQbMgc2b8yuLuI3FtREty6D/8u3e2pkP087NJYvYoBfdws99B5if6/VCzyor7XwnM
         7LKGdMvZv33lh1uy91yZJXPFi54G9AiFF7wsc2CA5+9AWtwMbrGAFweZaC5JHtBQld+x
         kzVRUZVrLhozJFXCPqHbwgofJoNSvjMk6CjXXZMSVcP77bzzQkEZmux4Q+dxEtXNVVgM
         OBT02pqW6OsTd2sb4OIHB5NWNQgBliQt6Otm3VH9V4c4kAf394ql+ZGchp2f1aZQ1jBE
         MEFJ3lO0mDOCBBlpk5bgbCZW+VGClTdSp8uQyb1ktOyYxDfpJFqtjCf9KHcxF5OiC015
         hiJg==
X-Gm-Message-State: AOAM5304E+o/1Yc1oRQofVQ8CMQ4VEqBMOvQx8DUHSm1QFcEERi6mmNf
        C9T4yJNsWgR8RYI/2Ju+Zfc18BJe7S0=
X-Google-Smtp-Source: ABdhPJzK2uRjFLZqLCiriG3dpfjc6eWbJvMuN3JC6Y90d11HQFOhDRHw+6v7C/c6wd9LbWk65AuVhg==
X-Received: by 2002:a67:d51e:: with SMTP id l30mr7878765vsj.1.1640787434737;
        Wed, 29 Dec 2021 06:17:14 -0800 (PST)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id n17sm4211873vsg.29.2021.12.29.06.17.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Dec 2021 06:17:14 -0800 (PST)
Received: by mail-ua1-f53.google.com with SMTP id p37so37379906uae.8
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:17:14 -0800 (PST)
X-Received: by 2002:ab0:69c5:: with SMTP id u5mr8126982uaq.92.1640787433972;
 Wed, 29 Dec 2021 06:17:13 -0800 (PST)
MIME-Version: 1.0
References: <ff620d9f-5b52-06ab-5286-44b945453002@163.com>
In-Reply-To: <ff620d9f-5b52-06ab-5286-44b945453002@163.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 29 Dec 2021 09:16:37 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfFmgwvLfkvk0knA0G7mbuKw3PdX=M9AAhLjxKuUYEO+g@mail.gmail.com>
Message-ID: <CA+FuTSfFmgwvLfkvk0knA0G7mbuKw3PdX=M9AAhLjxKuUYEO+g@mail.gmail.com>
Subject: Re: [PATCH] selftests/net: udpgso_bench_tx: fix dst ip argument
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 5:58 AM Jianguo Wu <wujianguo106@163.com> wrote:
>
> From: wujianguo <wujianguo@chinatelecom.cn>
>
> udpgso_bench_tx call setup_sockaddr() for dest address before
> parsing all arguments, if we specify "-p ${dst_port}" after "-D ${dst_ip}",
> then ${dst_port} will be ignored, and using default cfg_port 8000.
>
> This will cause test case "multiple GRO socks" failed in udpgro.sh.
>
> Setup sockaddr after after parsing all arguments.
>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>

Reviewed-by: Willem de Bruijn <willemb@google.com>

The udpgso_bench_tx equivalent to commit d336509cb9d0 ("selftests/net:
udpgso_bench_rx: fix port argument"). Thanks.
