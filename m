Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C67F2AF248
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKKNfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKKNfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:35:37 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB24C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:35:36 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id b17so2062038ljf.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=Ofo4uUdK4ufb95GSpnIeu9OCFDhLxT/0JM/jlHExZtc=;
        b=sYaNpzoAjvxXAGUqCJQ0qfKhxVdqcaSNvFWIQaSMNWITAm0SbvtCiDTQW8tWmDUVOk
         gn10GbiE5PpofivdEo90hIHkVRXMLxtKoAti/PAE7XLaax9ivnv1p08A6voygFmLPEM5
         xOQOMwKEcPBHoeGBTIaT6Yew9bPzkrEcIzIL23dT4tY1iwju5kYMiW8li5O61ia56M9T
         wECCYyi693Z+g/BEAcgXqhVMN0GgzbmGx/3zR0ZzlWTi7QqsIha6RZWe+ltnbGwbBh85
         xsToROIc/pkpo4vs98UL5B1IMHBxUYRmzHMkqC3KMn96UGhK+Kfky6lZDO5lgNr16mOE
         TAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=Ofo4uUdK4ufb95GSpnIeu9OCFDhLxT/0JM/jlHExZtc=;
        b=NxK4pFdooEWR4b4qRV0SQcoPp3jIf45+ZO3AjL8TAFcPBYIY0CgfyzZlx+YfcGS+48
         EROolf4kho999xH0FbBR2Tlv/dbgRToAz+SfyBg8vL+m6Gs7uqSKt56Q/8GLFDH+42AA
         OVzqAqY1PKhLyBGgynQgxmInGkULx+OQJSw9Nz/DOMFaGoprwbRQqfxC6eX2Hya+N3pX
         CQPQ5nXu4gNkLBMTLE+Vj9PB40Tg4q98ia6yBz+VzMdnwrGVKFgs+ANiZeqX4KqBJvPA
         4krsUm7PkWTgzV4xM7aVV90BoIzd40FOzO0aOQO6Ut4KfFpB5zqrYJpS678kgjcuhVz6
         eXVg==
X-Gm-Message-State: AOAM531d851c0sttlgPleKYmcNRIhvuQy7uS0lW2b+oOwVqcrZhIYTqu
        bkz23GTmwd1hYyKqeWVPDDuDPg==
X-Google-Smtp-Source: ABdhPJxVzxzMfuaOOOuf2KD5bePwK503poUpnneK2pBpav1PKXCp4dVxpAsI1PsNlTo/oCArGWB5xQ==
X-Received: by 2002:a2e:bc1a:: with SMTP id b26mr9540377ljf.359.1605101734720;
        Wed, 11 Nov 2020 05:35:34 -0800 (PST)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w22sm237263ljm.20.2020.11.11.05.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 05:35:33 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>, <olteanv@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: tag_dsa: Unify regular and ethertype DSA
 taggers
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Florian Fainelli" <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Date:   Wed, 11 Nov 2020 14:14:20 +0100
Message-Id: <C70GMK1SV1ZG.23ZG16VPK4TU7@wkz-x280>
In-Reply-To: <b953f38d-47e3-ac3d-39e1-84e9df807803@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Nov 10, 2020 at 8:41 PM CET, Florian Fainelli wrote:
>
>
> On 11/10/2020 1:13 AM, Tobias Waldekranz wrote:
> > Ethertype DSA encodes exactly the same information in the DSA tag as
> > the non-ethertype variety. So refactor out the common parts and reuse
> > them for both protocols.
> >=20
> > This is ensures tag parsing and generation as always consistent across
> > all mv88e6xxx chips.
>
> s/as/is/?

ACK

> This looks good to me! This made me remember that we do not really
> interface with devlink traps today in DSA, but we may be able to.

Yeah maybe. I've tried to read up on it as I would like to be able to
control things like DHCP snooping. I have not really been able to wrap
my head around it though.

Using DHCP as an example: that sorts into the "control" type, as
specified in Documentation/networking/devlink/devlink-trap.rst. But
changing the trap action is not allowed. And even if it was allowed,
how do these settings interact with an offloaded tc rule along the
lines of "tc filter add [handwavy wizardry] [match dhcp] action trap"?
