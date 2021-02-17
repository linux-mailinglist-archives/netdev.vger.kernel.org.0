Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F68431DCA2
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 16:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhBQPpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 10:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhBQPpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 10:45:02 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071BFC061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 07:44:22 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id v30so22258242lfq.6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 07:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KyVh3qwt+WWm7Z1+VQtIBYH5+JmPIIcw2dCnxrj4BOo=;
        b=TuOOQcoZsxtx/U3MSFmOXyz985nqztOiRHkL2ni4ISYsxyn4gZW8mB2V0pEkpl3eFS
         uCPhRVO5/8UHsdHU9J1aUQtydYzwBaxtjIZtkvaTlcIVIrnlgdgmCM0ouyzxXTMU9xQB
         w+2v8IZ5GZ6QBW9becb/faQw0i7y8Vw3KxWlqYaLwI5FaJPjQSqE3ENF8fsCgshXnu0o
         GefjavBPKBJ3qg3v/LmFtBCUvIH/2n8N5cJglrlt2h9SXJ/+Qjavgy9MxQoVhmkdi+Mr
         dShPhB73MUu9ksI0OXmTXqbvJLpowaK6ghQDG7uBYfCluYvZWcQmZ4jDkE37616fHOBS
         lyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KyVh3qwt+WWm7Z1+VQtIBYH5+JmPIIcw2dCnxrj4BOo=;
        b=ObVk/A9H7b+akh8X05NlTBLIeSbQrk6jBtu36G/y5/egL7p/IhNVuJqu5zcnpgleUZ
         AB3uEpGLpe/enLdJ+gLF8Ets833BcWU5PBJ1YM90eI2YCLzASIIsNvq2yGfudich4Fkr
         Mzd3juIYDZoEY9RfO0AR7k3jdnPMw2FvhAoE/0DqCxeFx2bSYbZyWNfACpdwSJvQpzg6
         Ye6uJt4l+CnNN6KtkJEXtlrIjqpO97UcjapwyQhwdQtvpmjWLK/MaP5hImSI2+BXvTqD
         uNQ7UdPj+0f5jrnly5+wEa/izgEJYi5pfgjaIkV3MOiACiEC4U44Z4Ac0wV9af57AERq
         1Nqg==
X-Gm-Message-State: AOAM5335qsc3klyg0SNcEHRw86j0cCkToX03FNWHPfVG7kTDZvK8BR+4
        hnbJTY0TTKoIVnMq1xD5cZFB48PPshQPiixYeyuZzTCME4tWDA==
X-Google-Smtp-Source: ABdhPJzpfp3TWM/dhF7A0UR6hHEf9tz2wbHo5HIrkIZPMwpPLTIKv41x3HI8NcgFLyk3nHH6O8XeKKhpt18oOVbaVz4=
X-Received: by 2002:a19:6b06:: with SMTP id d6mr15760386lfa.29.1613576660500;
 Wed, 17 Feb 2021 07:44:20 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-3-dqfext@gmail.com>
 <20210217122508.y4rjhjjqn4kyc7mq@skbuf>
In-Reply-To: <20210217122508.y4rjhjjqn4kyc7mq@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 17 Feb 2021 16:44:09 +0100
Message-ID: <CACRpkdYfbitX1mVeTKArY30x91Wqk_9HgRoLK=SsmPQaPNUJBQ@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] net: dsa: add Realtek RTL8366S switch driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 1:25 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> I'm not going to do a detailed review on a driver that is a 90% copy of
> rtl8366rb. You should probably spend some time to avoid duplicating
> what is common.

The split of common and individual code comes from the OpenWrt
driver, maybe it wasn't optimal. Maybe we can move some of the
driver into the shared rtl8366.c file.

Yours,
Linus Walleij
