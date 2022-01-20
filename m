Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB549567C
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 23:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378117AbiATWxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 17:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347411AbiATWxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 17:53:11 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD02AC061574;
        Thu, 20 Jan 2022 14:53:10 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id w26so14918274wmi.0;
        Thu, 20 Jan 2022 14:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K61/M+xTTQGp0Mgz98g6GfPkiFK49OXLdi5dVmoErxc=;
        b=Wb3OBpyeO6SX5ILh9uYqoncMxkaTfjem5R2kSgS/1PA1esE9ZQ7aZnV1iATYnzkLKX
         qmfnFYMXvqxlvLAc0pStPZaHvJYJjP4z35hj+w0vsdtAx1Q4jHX3CtTowjkhMu0sWFLC
         MjcQ85l9HU/iTR5yg2Y/QFrqgCcaPjeAk29cIgk6r72f3eDM5rlkda3T8b7i1weBo75c
         GHyZrOqHCtxIdRsQiyL3jHVfryS5ilMD4ocVxMNZAfckXVskS1/PCIvevLmxlLhXw/L0
         AklZXY/NJ3Ok3FvNNlkJjFcROl6gZXL8/Q3udK/hDhGHowZXv8f6VzVTXqvigxXSislt
         pFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K61/M+xTTQGp0Mgz98g6GfPkiFK49OXLdi5dVmoErxc=;
        b=PKbQ0w18Z114fxYazUI8byjQy9ru/1g8jxcvQR8zxxQ3H+9qPYrwHRlHcmgJqZzWaz
         8P7iwM/JuS9gONPusevUsqvA7tDkqYx0Ne9fyTx1pNEfQPcn7IrakUON8dyGoFXRuDDU
         9gZmk4lmmtflXyntl6Sfr58UcMOVU2btXHYzE5kTT43olp/vSVpXaxoegl837QMIwKSz
         du5RTmY7pDjbI8MMd0r3AqknAjj63MzEtc4GX/zi/UCh1RU+nF+75DmqkAOsnvRC+3c4
         mJjjcOxk6G7ewZt/JiA9ansO1D0T07iYHgzKl/bB0Nh3Ry7I5rcw4q5rNJRgYHVoZawp
         3zAw==
X-Gm-Message-State: AOAM531K8lm6wc6t9EhWjibPv57aqkvyLcwPBCh3J/2tWAXWPCI2Pj4R
        wLs5wZBUctqJqVHfwQgqRtmP+3wwCq6f98ogxa4=
X-Google-Smtp-Source: ABdhPJx5Cz0PLl7dVhNHb/aoG1g6y2wJZ4EoEzDptty8AnTOnKll/vjpum1fYafeAvpnxhEy/fZSnQErGTWg7TtHGhw=
X-Received: by 2002:a05:6000:1686:: with SMTP id y6mr1134790wrd.205.1642719189132;
 Thu, 20 Jan 2022 14:53:09 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220120112115.448077-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 20 Jan 2022 17:52:57 -0500
Message-ID: <CAB_54W5_dALTBdvXSRMpiEJBFTqVkzewHJcBjgLn79=Ku6cR9A@mail.gmail.com>
Subject: Re: [wpan-next v2 0/9] ieee802154: A bunch of fixes
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> In preparation to a wider series, here are a number of small and random
> fixes across the subsystem.
>
> Changes in v2:
> * Fixed the build error reported by a robot. It ended up being something
>   which I fixed in a commit from a following series. I've now sorted
>   this out and the patch now works on its own.
>

This patch series should be reviewed first and have all current
detected fixes, it also should be tagged "wpan" (no need to fix that
now). Then there is a following up series for a new feature which you
like to tackle, maybe the "more generic symbol duration handling"? It
should be based on this "fixes" patch series, Stefan will then get
things sorted out to queue them right for upstream.
Stefan, please correct me if I'm wrong.

Also, please give me the weekend to review this patch series.

Thanks.

- Alex
