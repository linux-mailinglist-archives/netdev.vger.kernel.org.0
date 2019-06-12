Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB52842E50
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfFLSGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:06:33 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41419 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLSG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:06:27 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so10963261qkk.8
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=700itWyKjvYiFLhP6jEPTeNmhf7t12dW5GgxWWewn2Y=;
        b=DIDleIoBBRbSbyaPaKHTfUCkoX3V0qed/gmhgh/MpB+I7n+x7Wf4eypIwr94A3j01p
         CFtBmztxBehhkx2xB/qty0kA44RYXzkb3W8eo3axjRSX3ri6VBAkuNuMdU035uUwHYVw
         4VjEg40aFujRHdVN69xwSZo7QN4C/0uRdbu13unzNEt5X5pXdov+4KPeP6hWWbHpIC05
         duGHjQ+6tOx0I8N+rfPDKQe5Y4EhqkbLQkdicV4O9/K3dZGIjTIGfueCbThEiCX+CLGr
         3s1nf92yaFi+AsfIiXpq8R+4E6PReNn2enKx+i/CTEIH6tqqeN4F4yHUQNaTYKwkN10J
         4LEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=700itWyKjvYiFLhP6jEPTeNmhf7t12dW5GgxWWewn2Y=;
        b=I3FcTnTr5xXMeQc21UnAnGm5cttBw2p2SFnsmIVH5JnNE8jx+FqqEOfnCAaUk1AxEp
         xwj9aCh3HpQjj2C/IU3rjPyykCrHru69lHaMgGq53Tf6IIV3p4DDWCArxTem9ADuIAB/
         AOfdZvGpP+fyU0KDyMrv3Z4fuUbIDrcMNMN47/y6GM4WdpMo9hUTt6BubnFIIGHcFy5p
         qqoteUkUxsV/KhAqqZNeOb4zZsQdOniXHbTbzlBjjIErpmLGqF1yhcLIYLgNPfEZQPXe
         hVUmQviK+pS0TDPIAXriIO3yjHioAC3tUfgei5M8nxFDk0J55xXqH0KUBDIgRsvZF/AP
         2X3A==
X-Gm-Message-State: APjAAAVQbPApDeXhbC3vXIbrzjaPej/ljoVbqo1NJ7FpE+cGpWyvb2NK
        ciJSbYzASlxbS/D/eWS7uUH1Kw==
X-Google-Smtp-Source: APXvYqzgCHuronfryuLazzGzUcrMlDx+deLUn6ZDEgSF5HxrTd3U1Gn+N6X5ZC28QcrrGGy2eb0IaA==
X-Received: by 2002:ae9:e30d:: with SMTP id v13mr47611016qkf.148.1560362785429;
        Wed, 12 Jun 2019 11:06:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m44sm285864qtm.54.2019.06.12.11.06.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 11:06:25 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:06:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: Re: [PATCH net v2] net: ethtool: Allow matching on vlan DEI bit
Message-ID: <20190612110620.5f1653bc@cakuba.netronome.com>
In-Reply-To: <20190612151838.7455-1-maxime.chevallier@bootlin.com>
References: <20190612151838.7455-1-maxime.chevallier@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 17:18:38 +0200, Maxime Chevallier wrote:
> Using ethtool, users can specify a classification action matching on the
> full vlan tag, which includes the DEI bit (also previously called CFI).
>=20
> However, when converting the ethool_flow_spec to a flow_rule, we use
> dissector keys to represent the matching patterns.
>=20
> Since the vlan dissector key doesn't include the DEI bit, this
> information was silently discarded when translating the ethtool
> flow spec in to a flow_rule.
>=20
> This commit adds the DEI bit into the vlan dissector key, and allows
> propagating the information to the driver when parsing the ethtool flow
> spec.
>=20
> Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule stru=
cture translator")
> Reported-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

LGTM, thanks!
