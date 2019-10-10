Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B0D1D6C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 02:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732530AbfJJA3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 20:29:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39724 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731916AbfJJA3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 20:29:23 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so3983973qki.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 17:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KM17Zz+I9yDyEJy8g6P6xuHBOuiNDSOYxA/dR1gGI6E=;
        b=I2FXmNxCWfd8tVjUwlf9v9WXMDP/MMgA/K1bEpH2bwf6J8EVQZROxDIE0SXiZvHZ25
         skje1Ud55ft/OpqaYf8y4auFzr2/yOQTPVfNsLEs9f5EcoLckM/xUVOOUa5wGTHqfAOv
         F33R/3vgfufNh7PZ+WbnmBRpLhmT0Y1iaQVY+Wn1NOonDGOjD6j/Ph4TaejKdlSDmj/K
         BugdlbrEhe6iPg51rMgGgXj43DA2Oi0KBS30EY0dGAzDJyemqZ4T6zFGMZ0StHHDripC
         Chz/ctN3s1j4bYwzDCnVif8cStbJlBfHq87PcgByi6nMTztC/xLJcRmsZnRCdvWfyRvp
         70/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KM17Zz+I9yDyEJy8g6P6xuHBOuiNDSOYxA/dR1gGI6E=;
        b=C6EYJZ/Zr2cGkNbG3qoHSNFBMXcoaNTMHecVGyJqIepftBDGPM/+JgJRvUCj1td6GU
         5szmHo9O4ZUHw9jjTNJqt8S4YQfLvwShgpbDHwghCycC9cUuJuFAoXJGsRyuRGGNlM1v
         DNK/GDm4eUssbo8mzuxMDrttaMHfya7C6MuIIfMz5qjfk2KAF/n/6hIKnEH64ImTsP80
         194dBK+3ZOPDN9ZO3OEA69ZWuYeuWVbDX5JkfSk/jYU9t0eMrmp1YWN9deriZUWZkvk+
         JJ+gc4VT6B/U+yY9TIoko61+vNHVsDCOs/6mQRS/j21Is5oMDe0Wku7zKx133UyPParP
         MsAw==
X-Gm-Message-State: APjAAAU9nQastUeUfaizsXgOWqiAn4888EYoaajGDwFtK58AArVz34mV
        zCT68prBlg4Zdg+0rmbb3p+Abg==
X-Google-Smtp-Source: APXvYqwxLszV1CO4Y+cHe3rlyRS04aKgmKU7SXExS9KJRtKaEih6sjrCZlHCSBxJ0lSMoVrjQP6/SA==
X-Received: by 2002:a37:c249:: with SMTP id j9mr6920330qkm.164.1570667362065;
        Wed, 09 Oct 2019 17:29:22 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h10sm1913833qtk.18.2019.10.09.17.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 17:29:21 -0700 (PDT)
Date:   Wed, 9 Oct 2019 17:29:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Steve Winslow <swinslow@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Allison Randal <allison@lohutok.net>,
        Johan Hovold <johan@kernel.org>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v9 0/7] nfc: pn533: add uart phy driver
Message-ID: <20191009172907.2f0877f4@cakuba.netronome.com>
In-Reply-To: <20191008140544.17112-1-poeschel@lemonage.de>
References: <20191008140544.17112-1-poeschel@lemonage.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 16:05:37 +0200, Lars Poeschel wrote:
> The purpose of this patch series is to add a uart phy driver to the
> pn533 nfc driver.
> It first changes the dt strings and docs. The dt compatible strings
> need to change, because I would add "pn532-uart" to the already
> existing "pn533-i2c" one. These two are now unified into just
> "pn532". Then the neccessary changes to the pn533 core driver are
> made. Then the uart phy is added.
> As the pn532 chip supports a autopoll, I wanted to use this instead
> of the software poll loop in the pn533 core driver. It is added and
> activated by the last to patches.
> The way to add the autopoll later in seperate patches is chosen, to
> show, that the uart phy driver can also work with the software poll
> loop, if someone needs that for some reason.
> This patchset is already rebased on Johans "NFC: pn533: fix
> use-after-free and memleaks" patch
> https://lore.kernel.org/netdev/20191007164059.5927-1-johan@kernel.org/
> as they would conflict.
> If for some reason Johans patch will not get merged, I can of course
> provide the patchset without depending on this patch.

The memleak patch was a fix and it's on its way to the current 5.4-rc
releases - therefore it was merged into the net tree. Your set adds
support for a new bus, and will go into the net-next tree.

It'd be best if you reposted once the net tree was merged into the
net-next tree (which usually happens every week or two). If you'd
rather not wait you need to rebase on top of the current net-next tree,
and maintainers will handle the conflicts.
