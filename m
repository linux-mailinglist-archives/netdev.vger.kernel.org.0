Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF8F4902EC
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 08:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbiAQH0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 02:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbiAQH0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 02:26:54 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B107C06173F
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:26:53 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id m1so54190101lfq.4
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=z6NqL6PNEvFb1W3wQZNYqKK/+9djA4WTmwURAr5hxYE=;
        b=Y4PgqYTTImdCP3NIxORLy2ojzn+vUxzY3KOshj9cTcAUZE5/VtBcfauzM6l5e9F+Ri
         jJhzCCm4aLVQ2SYP/z2kAQcXEb4+dL7l6s4r+fm9YberTOfKk/l6VWovAuqC7r7MXjtH
         WHwAzKH11sB78Tt+Lywqp0BlU9gx+h8Z0Syq9bpwMTXo8hSJiZP935MeqNPHJItUKYal
         jRyZwo/UH1FUfUN92rJB7q0jEnNhHfvvse02e9OcE6chXAPAyhoez7uojfEn6/uG6DGb
         MiF6o9/l/Log/DMItkl0TqDVd66pDLkfzv90h0iMs5xB7KnV+twvhxxXgYHeeLFwOeEx
         cgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z6NqL6PNEvFb1W3wQZNYqKK/+9djA4WTmwURAr5hxYE=;
        b=4+EgC1b9GfOzJUdQenWtR+wlxFJwKXPCy9pmVVVar4rwsj/k0nJfIdsuizhdq1M0Qr
         29RGxOPCVu/d/YHzxHiQQgn90huOOtOXktdfWsqXDqI/shngA3taVezgudV+xuhLNgqy
         SZGbpBsWO3KI4N61lWPM19WR4Eg9/GGyn0u1ToIpwfTCZTqHr2y1HQWwEnlK2ICKWpDH
         h9cAjs26qUk5imdLwMOXe+/zj7V4QAR34wkZTGOn4GjkLpSt3i7AIlVlB4xx6pdfzNQk
         p9goKf4Y76Pt+Ir0mvaMj8PjYQJFLkv27VcWVapt5i9QytrkcdCBfxe3CHQSSaGQ5VJ3
         I3Qw==
X-Gm-Message-State: AOAM5309YG4fPHTVfiMHwh+IYIGVJxjD0Dsp41Sj7r83asjHg1UAb2qV
        qNPAeO8W7Wu3SQAHyG0tcfk22A==
X-Google-Smtp-Source: ABdhPJxdmpCScApvX/ejVe8COOxLG78PTMe3g7JX4QNE/hb0AgUmXOOmSLZv79SbNWhfhdO4zfYoTQ==
X-Received: by 2002:a05:6512:1110:: with SMTP id l16mr10463776lfg.121.1642404411906;
        Sun, 16 Jan 2022 23:26:51 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id h7sm1308872lfv.104.2022.01.16.23.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 23:26:51 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, madalin.bucur@nxp.com,
        robh+dt@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 4/4] net/fsl: xgmac_mdio: Fix incorrect iounmap when
 removing module
In-Reply-To: <YeST+TAREKIh2RXp@lunn.ch>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-5-tobias@waldekranz.com> <YeST+TAREKIh2RXp@lunn.ch>
Date:   Mon, 17 Jan 2022 08:26:49 +0100
Message-ID: <87a6fuddqe.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 22:54, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Jan 16, 2022 at 10:15:29PM +0100, Tobias Waldekranz wrote:
>> As reported by sparse: In the remove path, the driver would attempt to
>> unmap its own priv pointer - instead of the io memory that it mapped
>> in probe.
>
> Hi Tobias
>
> The change itself is O.K.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> But you could also change to devm_ so the core will handle the unmap,
> it is very unlikely to unmap the wrong thing.

Good idea. I have some more changes I want to include in this driver,
but they are more net-next material. Will try to work in this change as
well.
