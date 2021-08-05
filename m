Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FE73E148E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbhHEMSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbhHEMSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 08:18:12 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC15C061765;
        Thu,  5 Aug 2021 05:17:57 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id p21so8028432edi.9;
        Thu, 05 Aug 2021 05:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fOuVThdYD1S8VHECB877QIQqmemMgYhHBSOFr7/DmT8=;
        b=qLF7FeV1tAJqLD/dAdwvomAVVpiggKVLX/765N+eBf/jSG1OH/MqwfX5XNGXsIkCga
         2MIokMsHAhHjcWKj+XIbbD5uP+j5tG8+EuEZZ/LwtjNZRtBD34MjQpLpIap3tjPb+3/+
         FbdRhzsie43iPuM8vXUQqoLRzhvdfjGvTwMhDQCCwtOpuuxUUzzHe13bIBe41qSVKN+D
         B0rk62+EwscJf0ValcUK/yQ+mfatOOXqB4e/9zsodsxqE5sI0aQYR0O5RnCG8Owx328R
         fEfsIzk3sR4XcZKUIFWHZUqSqTHnuRmVggPcqo42tROso5su+KtjJomdwk/MIzkafsoM
         7dTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fOuVThdYD1S8VHECB877QIQqmemMgYhHBSOFr7/DmT8=;
        b=njn07JwNlA1DUgq5vzXgjJuzfRVxqDoaFw1pFeKSVV0cfzEIv/gz8YTGFw6wsYstoL
         yMgvj3qc6fAbnBht0g9HFwIgELR4hNjelKjGwQajc+hA1hZ+IC6iISmJZNPamvfpHKh4
         kVwh9k1nv/Nw26X0NM9Q30vemPZdMWPBGAHrD95wkqAf+NlQLNy0DTH7akmmMyncMJaE
         KiOzMPqLX3p/gditrXJpTwT9k5RJW8XAZCmQOng1odMDRC98ho40vZxdDsEtoatZ62lL
         Cfj734QFGOR43yMFMjbP1YELj0X4B/R8PN8Z8/QisIHEQgFJeJpI9mn/0dsJUplLaUsb
         Lp3A==
X-Gm-Message-State: AOAM532PpLWqfB08ZOAnuAS8tcYHjklOKunY7VEJLIiVsL7YuvrFfUyc
        6dUAkkyL5DoFh24indFhtPI=
X-Google-Smtp-Source: ABdhPJzOklS3rr4MvLWG+y0XnT6cH1CmId6xT22kQNiIWo8xWvPimo0XTq3QIqGgQY82Mo+/tSsbcQ==
X-Received: by 2002:a05:6402:1cb2:: with SMTP id cz18mr6063048edb.339.1628165876175;
        Thu, 05 Aug 2021 05:17:56 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id de49sm1665951ejc.34.2021.08.05.05.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 05:17:55 -0700 (PDT)
Date:   Thu, 5 Aug 2021 15:17:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] dsa: sja1105: fix reverse dependency
Message-ID: <20210805121754.uo4umz7wiayyu7y4@skbuf>
References: <20210805110048.1696362-1-arnd@kernel.org>
 <20210805112546.gitosuu7bzogbzyf@skbuf>
 <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 01:39:34PM +0200, Arnd Bergmann wrote:
> I will give this a little more testing and resend
> later with that change.

Btw, not sure if you noticed but I did send that out already:
https://patchwork.kernel.org/project/netdevbpf/patch/20210805113612.2174148-1-vladimir.oltean@nxp.com/
