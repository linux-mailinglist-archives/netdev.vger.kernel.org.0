Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFB82F9457
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbhAQR6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 12:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbhAQR6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 12:58:12 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1ECC061573;
        Sun, 17 Jan 2021 09:57:32 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a12so14287916wrv.8;
        Sun, 17 Jan 2021 09:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:subject:message-id:mime-version:content-disposition;
        bh=fvHzBYZV8x8XbF+aJQXnA43cGURhKXftc1C9GinwpVY=;
        b=YzMh16erNxjWlLJA9m4ixIEo3WA/8yp4beEnQznj+TmxwWn+RoljgsIGOgyUHuL0m4
         eX2zbm6VHtIC8BRz/qZxshqqB81j/Q5djJv9zG43T4Fhzd5nJnLPG4N1lyB2qrLJewHF
         FOQCQAx3FvKQnnKcg8wCrpuvaoi6rF+H2nYJIQAkTbV1WEx4c+otD31RW34zxuc78QD6
         Om0ezjJvovyH+bzB/q8BbzDB5Wvcrxy0svWegDBU+M967sDFtvyjQFnWlYPiwK+SZxyC
         meLIwnT8tU9LGxJlH9y0WCX0+EVaiNCdaFJ93c30p6HvzrMbARRc8PEBVYgc+8vPl99Z
         X/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:mime-version
         :content-disposition;
        bh=fvHzBYZV8x8XbF+aJQXnA43cGURhKXftc1C9GinwpVY=;
        b=NIsDuiNDIeNA0VR4zla/RK+pQByxRoWF7zD2N+yQ3A0KDEjuKqk1nxBu7CsdDgwvgp
         9A4yuUk4uTo6Uo2JtXqYfd53HDK2mmsS3CawlJ0v8gTaLBfbk5k9U0i5142n7j05vd72
         Ty9RvFGZ+YDhxJ0JzemuCLx5Dh2UyUO0Wxqp/okOCWu1tWUadki8Mj+zBYc+zVFT8XSw
         LX3VltfIK1hAl5oo21fx8oPqLES2KnuHpzhy3ITFJEdp9A+SojYK3cOMDTu3YeuS/w68
         RLEAfwPCJpvqpGmACiGFNnVST09z2I2JvDJs8Ht5GIRQ+vcWBEv2Vlh+G+1PWM3dJAhw
         NTjw==
X-Gm-Message-State: AOAM533cT7Sw9+qkqqotgjc21ijX4z4BTsFVJSrrYXqSa+9rnBCOXVln
        WxfNI7FXGDcjHC+G//o9aXQWuspm8ICVMg==
X-Google-Smtp-Source: ABdhPJxY14ynV1CiTvdhO4uI3DReG+Pl9THAONvy9F+QNiqKensogXcEp5Jcdg3lhbteUoOuBmXiYw==
X-Received: by 2002:a5d:62c7:: with SMTP id o7mr22085360wrv.257.1610906250713;
        Sun, 17 Jan 2021 09:57:30 -0800 (PST)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id k9sm21782546wma.17.2021.01.17.09.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 09:57:29 -0800 (PST)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Sun, 17 Jan 2021 17:55:33 +0000
To:     davem@davemloft.net, Jakub@medion, Kicinski@medion,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: How to port rtl8xxxu to new device...?
Message-ID: <20210117175533.ya3wcb6yyqfgwiln@medion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm currently trying to port the rtl8xxxu driver to RTL8822u chips (one
of which I own), but I'm finding it hard to figure out where to start
and I figured that some wiser minds could maybe help steer me in the
right direction.

I've managed to get as far as reading and writing to various registers
as part of the device setup, but the dongle appears to crash at the
downloading firmware stage. At the moment it just feels like I'm
changing random bits and pieces to see what happens. I'm using this
downstream driver for reference: https://github.com/RinCat/RTL88x2BU-Linux-Driver

Does anyone know of any documentation or anything that could be useful
for working on this?

Best,
Alex
