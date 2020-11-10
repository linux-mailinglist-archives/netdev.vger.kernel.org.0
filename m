Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006AC2ADFF2
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgKJTmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJTmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:42:13 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6084BC0613D1;
        Tue, 10 Nov 2020 11:42:13 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id s25so19325277ejy.6;
        Tue, 10 Nov 2020 11:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D8TaLv98xRGgZIwQIJ9LNSGzseJjojNgwBo1ms6iLR4=;
        b=lfvcJaOnlhX6s73K3OhM1r/yJepcobV0fIhoUk7wLpfDu/x82D0fVrNjw6poc4zTne
         XKcJWfk0GR9Or2SnDK5vdPffOt3ZP5uNeNZWg962i4x1qrIf9Kn/UbnsRN8kH3uptmSC
         rF9nOmrssbyZy1Fj0r8xeDOOfyimsT7qmUVq0y0pi5tqwTtYJTBJcMczKa8q5HVwUt+g
         pKPpU+I37c7/5e6pbadhFZbbqbuDwCEEUzSfgmR6E1+ucTCNSYeZD+cO3FmD9/SZh6ar
         i8R9JzxOcc845j3NPsKLhwLRh80qEwbCBzJi2V+FdivbKD3cZdWWfRAuVy2OJ1kO0082
         WvHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D8TaLv98xRGgZIwQIJ9LNSGzseJjojNgwBo1ms6iLR4=;
        b=Qj9hesBHl2rVEpAPfwh90Hav/pOJ9RryU0i+oev0+thv4FLCoIAA5nkqrQJuzQZ772
         rDYC60d3KI0BH9op4ZORCe5LLJBrUHLBWAGT8zO0xA64b98z/Stdcb9otS7clMVr+BwX
         bTvOJCleCvc9Q087KbtXWn9st31x2SUJcjID9MUgW2R5MBgW9GLFqwafsmvgqX+lMa0s
         A2LbzYPAsAW1cx7UmX9gylpzEReBLdhd9iNsI3XK9GtMb01und0vWgtdXXP1BXYrQBUb
         C0XMoXhvSBrFfZRJTECAebeQ22uX8gobC3uvVNQCoOBkzE2Crva8mcaL5hsI0KufH2XA
         yaGg==
X-Gm-Message-State: AOAM5309xAdHLz8drxb6PoCAK8QmeT0dYTva4mba01WsGZi9/xmn+lYe
        4At7srZNzSLH1nwYl1K0nFc=
X-Google-Smtp-Source: ABdhPJwxFsStmpXzGXyKAHx0ReeQi7l0NL4ff2nYr9OdKs3+ntOjd6TAMt2/SFJnEJO+Yrob0+PVAw==
X-Received: by 2002:a17:907:2063:: with SMTP id qp3mr17537953ejb.314.1605037332095;
        Tue, 10 Nov 2020 11:42:12 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id qt21sm10908864ejb.111.2020.11.10.11.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 11:42:11 -0800 (PST)
Date:   Tue, 10 Nov 2020 21:42:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: Re: [PATCH 01/10] dt-bindings: net: dsa: Extend switch nodes pattern
Message-ID: <20201110194209.ym56zayskvosq5iq@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:04PM -0800, Florian Fainelli wrote:
> Upon discussion with Kurt, Rob and Vladimir it appears that we should be
> allowing ethernet-switch as a node name, update dsa.yaml accordingly.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
