Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45110218724
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgGHMY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbgGHMY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:24:56 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55150C08C5DC;
        Wed,  8 Jul 2020 05:24:56 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so26754179lfh.11;
        Wed, 08 Jul 2020 05:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=wRfYf9+0jNfHxoYYxZ5ja9edb0dG8oz4UcCO/asf8rc=;
        b=uwWyabp3SiFKU2xwDTEGmDd5ys6f+Vq7OCW0EpPtzKf9aG0qyLNpNhxM4icWTKy6FF
         Un9rEZtgEP7tetjEiAGkQ9jjzNFR5j3UumjcAPBpZ31MSvuK49WMdbmpmDnyXlEJjpWV
         eNAzr9eZBFVCQjn01MvBlu+HsOEQi877BSkMnQCepaosLCc0LF+8zbdye6t4HWEOfVgO
         cJIzG9MUhxnImmHN0Sqa0dazarBU2/3oDcLXI4AUUPGlQC2ZNI7Sfc7yhUs7CzWHqlXR
         ZYXZRu3qyxhgmwt5o6nTCln9yf9nigl4KMGcLizqLSuk31a5QU3s1p5+Z+TsC5gLVgDl
         GXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=wRfYf9+0jNfHxoYYxZ5ja9edb0dG8oz4UcCO/asf8rc=;
        b=i9lxebmitMQaY7wjMi8rWXuO/BN2iL9VqaqAvqvy3ssrUMwkB3Fh9V0AeGy1NL7wKi
         Py3DgcRRcbxbAfiBLPDs/mbY4iKr1pCCFVcWlUhvtdWltl39fO7oH6Ja0cXmn8qEw4kH
         Q/hn+FVNGc6Cs6k2srTLTkZeFx+GQbOa2y8INZiIwcKAnWALY0/DKyRhabH0bLN82ZTI
         1ex7QQIlAdo+E3+vmB5du2h9Z4Xsa4ixlSi05edFM3W46hGoZY6ZYBfZwgk0fB3dCV77
         vQRKDMsjNKB8alr92XtwzUlVnQ7xD3ytZnX2nC72ep4odU9hDDYP8Mos4Gb+SFCFf0p3
         nBMQ==
X-Gm-Message-State: AOAM530MADd0AC9Qklw43HhDPktrRXGh48sGa7nTXmn+RRvVOTg/fZCE
        bvG/5kz6Wfaep2fEv5VMA0YJp+fV
X-Google-Smtp-Source: ABdhPJz/erzMJubNiiU6rpmxuhAY5hO2iSwH7s0PcBwYwad2yhmmdkm07bRVeEGarVCNn0VmeXrw2g==
X-Received: by 2002:ac2:44cd:: with SMTP id d13mr35691627lfm.13.1594211094853;
        Wed, 08 Jul 2020 05:24:54 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id p1sm881595lji.93.2020.07.08.05.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:24:53 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-4-sorganov@gmail.com>
        <20200706152721.3j54m73bm673zlnj@skbuf> <20200708110444.GD9080@hoboy>
Date:   Wed, 08 Jul 2020 15:24:52 +0300
In-Reply-To: <20200708110444.GD9080@hoboy> (Richard Cochran's message of "Wed,
        8 Jul 2020 04:04:44 -0700")
Message-ID: <87sge2b3e3.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> On Mon, Jul 06, 2020 at 06:27:21PM +0300, Vladimir Oltean wrote:
>> There's no correct answer, I'm afraid. Whatever the default value of the
>> clock may be, it's bound to be confusing for some reason, _if_ the
>> reason why you're investigating it in the first place is a driver bug.
>> Also, I don't really see how your change to use Jan 1st 1970 makes it
>> any less confusing.
>
> +1
>
> For a PHC, the user of the clock must check the PTP stack's
> synchronization flags via the management interface to know the status
> of the time signal.

Sorry, but I'm looking at it from the POV of PTP stack, so I don't have
another one to check.

If PTP clock itself had some means of checking for its quality (like
last time is was synchronized, skew and offset estimations at that time,
etc.), then it'd render its initial value mostly unimportant indeed.

But even then, the original problem was that Ethernet packets were time
stamped with the wrong (different) PTP clock, and there is no any flags
or clock ID in the time stamp of Ethernet packet, so any flags attached
to PTP clock are still useless.

Thanks,
-- Sergey
