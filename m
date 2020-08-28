Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8712561FF
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 22:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgH1U2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 16:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1U2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 16:28:46 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601BDC061264;
        Fri, 28 Aug 2020 13:28:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i17so207442edx.12;
        Fri, 28 Aug 2020 13:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=61/0HpbFm2wHtSAuVzJ/JzzCVPKNOSaE1LfRMb2GYp4=;
        b=LBhkUzXilK2L/xRRhj5WmjgRTN3W2PHOPk+s6lQSpKtMocha/PAIHXHR6/abwDPbZS
         nvkR1xj8NSZKu4di3TDClKv3SvBjxbIWQ6WwNSreFL7q9sRENFiqMikjktH9SbwAYvJz
         Daq6VElU8dHnrAbZiNGSWAQAuIWnHHuk/YFUgbCPlMz4MPOBK1FymcxPUzSPehaIqMDx
         fVxFPI/apnkQ5YL4XYLdWgDt05u8RIl23xARrbVT2DP4XiHhxF+4C6eMBwIC/Qx57aZg
         p3UE9WSqkSwXGse265OJuy7DpeVkZTqGlQOPKdD90zm8YuVa59nizEBtIdhAK3BdpEyP
         Ujzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=61/0HpbFm2wHtSAuVzJ/JzzCVPKNOSaE1LfRMb2GYp4=;
        b=ayRq0EtrQvvHE2OwOf2yaNKaLWLIeGvR4Cs7GXxMw4efoKyvFTYopHwIeyQfa+Hwun
         xOEt5oZt4As4idSQARRBYidxp+UAa8H+stggxLI7+NAOiRRU7j/ZI0NOchTltypp/BAL
         IW9AXHQn641aSTiKlD2pr1GXRYhBfVYT6J79vPNViKRgUNawUziAu17pzRvZFZEUT4p3
         BoH34YgWLYBH+HKRQMk5mexwRNQgK9nmKzjd5G+q1USZFm0jnlaWq3enlx0QlaXCFeMN
         nwnFz8jNiXGfF4G3kkLSAkaAmmTcaZAhlk/k3q0LWXt8qcWf77COigjyHrt46JaDvNKS
         0z5g==
X-Gm-Message-State: AOAM532VqpZOsAGY5FkkKwIasfsT2UlC6q90nPhmwhHctKkHJ0NfmP9l
        5PU1D/ICGRbPFjezYwFhcNdr0S2cQvM=
X-Google-Smtp-Source: ABdhPJwYBX0ibc6Z3fGzfDaQ44NVfdf5SeQuO66ACT9XbKW+NUkusOXvkPN7Y5YGzsxTpy4E/ZQFEQ==
X-Received: by 2002:aa7:ca19:: with SMTP id y25mr479745eds.211.1598646525048;
        Fri, 28 Aug 2020 13:28:45 -0700 (PDT)
Received: from debian64.daheim (p5b0d7429.dip0.t-ipconnect.de. [91.13.116.41])
        by smtp.gmail.com with ESMTPSA id r26sm228648edp.62.2020.08.28.13.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 13:28:44 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1kBkz2-000gBn-69; Fri, 28 Aug 2020 22:28:24 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 08/30] net: wireless: ath: carl9170: Convert 'ar9170_qmap' to inline function
Date:   Fri, 28 Aug 2020 22:28:20 +0200
Message-ID: <5498132.V4cn31ggaO@debian64>
In-Reply-To: <20200827093351.GA1627017@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org> <20200814113933.1903438-9-lee.jones@linaro.org> <20200827093351.GA1627017@dell>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 27 August 2020 11:33:51 CEST Lee Jones wrote:
> 'ar9170_qmap' is used in some source files which include carl9170.h,
> but not all of them.  A 'defined but not used' warning is thrown when
> compiling the ones which do not use it.
>=20
> Fixes the following W=3D1 kernel build warning(s)
>=20
>  from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>  In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>  drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning: =E2=80=98ar=
9170_qmap=E2=80=99 defined but not used [-Wunused-const-variable=3D]
>=20
>  NB: Snipped - lots of these repeat
>=20
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---

=46or what it's worth:
Acked-by: Christian Lamparter <chunkeey@gmail.com>



