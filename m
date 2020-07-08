Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B5D218701
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgGHMOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728897AbgGHMOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:14:49 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC82EC08C5DC;
        Wed,  8 Jul 2020 05:14:48 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id j11so5218114ljo.7;
        Wed, 08 Jul 2020 05:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=dYRZ5YGQEE6w3RMX9i2qHogQUMCaMwTTIeFRNaVpsoY=;
        b=tdgoY+Q4fftG38O0kKmD6uhGmdD3Vx5EATHT78L+gTgkZIUK9Tqxl9zYcTHn1VLH7q
         1UnpBr5GA1BxDjLEKiurZJhdfqg0zUlwVWtCdcWQeR/T4ywPfT+7f2PZLGJ+R/uw0CsC
         qepeiSN15NoM8htTLcZiK3m4/RX5eG2imAYmDyd3BpemvjFvWGQY9baUVy5EKq9YPt/3
         jkQ0rdyyvzJd9I9HBbG6gFcLHCGl7ogMtDoK/BFoXRp1yfOKJluS9KXleeTXswp/bgN9
         FyKf9lNmNQJ5/VE6Tj7DSR+6AO2JvsBAtjvyMc9wuLojnYCyC20uStA/M93FVFAXZ7nl
         X/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=dYRZ5YGQEE6w3RMX9i2qHogQUMCaMwTTIeFRNaVpsoY=;
        b=qdcii5qI3iA/TW1WJ5qgzwhYA7AhSUCINjbREPass2WjuVk8COqLdF2M4rNgOfD7EK
         kNzR8x8xIJBjUABtanQ0myTijC+AKIe4bYvVuQZVtPhvrn0k4MNogcX497ckcsr6JKbk
         LEajiGplRXgmOEpcp0rQ2NpQ2CCz02/Mt/oggbnbLV3ZiMSDxVzYTp6AbQkcbpEEHWJZ
         3FQWemi6VNvk/LzdlYsRcZ7tlsj6mfwPQBvDB6a8x0Jjj76j7zMhpRq6biSPVRLx4j7U
         38lfyDxK3eZl46UI2XOMNKQEge1bPv7/IW7Vvd2pbzIH6jvk4DIBsaGELuGhcBP4sbc6
         PbWQ==
X-Gm-Message-State: AOAM5305v+F9Ch2S2+JQNEJ7d4o+tBb0ajJYqnw1nvEYdmp3sqtSf8Wk
        FPnPo39w3rEzo+f5mAXI7lM=
X-Google-Smtp-Source: ABdhPJxGI3LkNELxPhFHI+r7iTw1yLHA3eNSw980jDlMU0TcSVCU/9wikGNIfJacQGY+Hn5u9+YFjA==
X-Received: by 2002:a2e:8851:: with SMTP id z17mr29558726ljj.225.1594210487151;
        Wed, 08 Jul 2020 05:14:47 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id i197sm10336226lfi.58.2020.07.08.05.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:14:45 -0700 (PDT)
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
        <20200706152721.3j54m73bm673zlnj@skbuf> <874kqksdrb.fsf@osv.gnss.ru>
        <20200707063651.zpt6bblizo5r3kir@skbuf> <87sge371hv.fsf@osv.gnss.ru>
        <20200707164329.pm4p73nzbsda3sfv@skbuf> <87sge345ho.fsf@osv.gnss.ru>
        <20200707171233.et6zrwfqq7fddz2r@skbuf> <87zh8b1a5i.fsf@osv.gnss.ru>
        <20200708111518.GF9080@hoboy>
Date:   Wed, 08 Jul 2020 15:14:34 +0300
In-Reply-To: <20200708111518.GF9080@hoboy> (Richard Cochran's message of "Wed,
        8 Jul 2020 04:15:18 -0700")
Message-ID: <87y2nub3v9.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> On Tue, Jul 07, 2020 at 08:56:41PM +0300, Sergey Organov wrote:
>> It won't. Supposedly it'd force clock (that doesn't tick by default and
>> stays at 0) to start ticking.
>
> No existing clockid_t has this behavior.  Consider CLOCK_REALTIME or
> CLOCK_MONOTONIC.
>  
> The PHC must act the same as the other POSIX clocks.

Yeah, that's a good argument!

Thanks,
-- Sergey
