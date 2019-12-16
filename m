Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF68121132
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfLPRJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:09:28 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43623 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfLPRJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 12:09:27 -0500
Received: by mail-qk1-f193.google.com with SMTP id t129so4194836qke.10;
        Mon, 16 Dec 2019 09:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=cRdiI5895IHbTdlAPPP3A1KuNzj2PTuHghUKJHQUK7s=;
        b=kjom40UKwoyBBozt2pTDiwWQD320JRNPsQXGFHG+9sFDnMKM8F96donp2dcl3LlXyW
         YR1f9oHJwyWOOrkNZMwYre4kxZQNfiyCNgSka/5jAhvLKls5LpIsFcMUtjCv3RcQoekj
         EGDEirORjghztTDZyhNhM0HjMe/otkPNo8qe9RRXFF2gsTat9gh5lLW3PQlax8gwcYut
         aP1XhNQBHHFX5m9tbWZvRmzbRxzAVvkLjarNNvu3fETQUB0RKJCooOUmrU1FyD+ITXBS
         uD4QMfxjzi6E/IAeBve74JxZjTsl+t+/0SEFza8sAbjzhHZ4vq1eAeiSN98qkKcBrYDc
         HeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=cRdiI5895IHbTdlAPPP3A1KuNzj2PTuHghUKJHQUK7s=;
        b=PDxdsAY84cS+hDdwNJjrdOxKJV9nF8v31P4jM6tY/dKDd95kBaCxPzZTF0QO8ROneF
         yVC1njRjosnCIEA1ZgzbA1nm5YUEYwL91z8eSIOJhzIy2BEjiYoQvkdcirdGlGuuW7ND
         PyNFLhus9FqcDmJyhYYQEjgImiYE/t4grVIeb3e7SSVoWAAJ2JLZuJqGXyAlb8MWWz+h
         TzQ8LauoGRDiSfeH7YtJ6difBPBsDCduqn11SECFQ3aqZ0KhS8UD2ZHm6QQj09S9rQH7
         a7CLX8s3ecRRBw6WxndnC9Wk+9t9yPauwpjrNy/A08/4cMcI60VM+V8RBKZeqkFc2xsb
         vjdQ==
X-Gm-Message-State: APjAAAVkuzCf/8/Wpna2tt2qXE5HCM4CpaU815s4OCX4X9Uv9oKYsv1R
        4hi1lbjQjal7kLkvJC0tOCY=
X-Google-Smtp-Source: APXvYqxxShGrIzFxlpk3IdPx/vm3r70u8GTI6U+Of9Q8cdoU2xAVM8oRA52j02qEZUKXLGcqdZv2og==
X-Received: by 2002:ae9:e519:: with SMTP id w25mr300086qkf.260.1576516166519;
        Mon, 16 Dec 2019 09:09:26 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id r37sm7051726qtj.44.2019.12.16.09.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 09:09:25 -0800 (PST)
Date:   Mon, 16 Dec 2019 12:09:24 -0500
Message-ID: <20191216120924.GG2051941@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v5 5/5] net: dsa: add support for Atheros AR9331 built-in
 switch
In-Reply-To: <20191216074403.313-6-o.rempel@pengutronix.de>
References: <20191216074403.313-1-o.rempel@pengutronix.de>
 <20191216074403.313-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 08:44:03 +0100, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> Provide basic support for Atheros AR9331 built-in switch. So far it
> works as port multiplexer without any hardware offloading support.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
