Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226B6139203
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAMNT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:19:28 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36123 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMNT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:19:28 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so9620473wma.1;
        Mon, 13 Jan 2020 05:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oPpAx4psrCRpvGxa+BiR5YMo0bdqOSs/oqk3OpqA2oE=;
        b=nWfPhbzI4KL3RW27J8sCj9bO4EGHIMFwVLTgYFDFOZ+ANyQXA2pSwjrFy7psj7W+ZP
         MdbRRjRbTVNa6CoYI1BBlpzinR2bYmiLozKhWnRabab4FT4Vx3/5uf9wX9S+Mh7gQ49Y
         UbKNk8qoaO0amqRtlEv712jO3q3egODBlzftQohOvXzHHA9w+447cDVyeZYK7s37SiOI
         EysUDLsiaCsJAeLVOYLgWZN0PRMMjrIpMHhRGoP+GiMlKdbzZXfhqxZRoqNj4Kxyq7ch
         zHzgEoZGyoo52b8uWmEYSsdiQyIw74mbx7/RNV2rlK1EuAjtm+9Ew7qzdTV/5taVURqC
         cEQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oPpAx4psrCRpvGxa+BiR5YMo0bdqOSs/oqk3OpqA2oE=;
        b=J2vUT3Pc/jAjIuqnmayDmABBaEwk0GKrDrgo67eUbIlcDhkiLH3ceMM9ewfyvVKRhH
         yEMe2GfVk0q6yIQTYY35MJiLrB3Ibrb958bQ5Gbr3HLMnc8CyeyYr/Jxiu7MYtqhnyFg
         q0N6mgP9AGw0beC/HTEcCZfRs1NKV3cjoAKK706LiE1O5Hs2Inh0gyvNswr/l0eFgv4l
         jFZxVbGNyaB09/qZlaJf5tWr+2iGAcAt1qojw9/47ljbxDYzZ6+ohWzIovSpAY+C1NKq
         /nbEjT4Ekce1+LYg4srhoUZIrVkAnP448ukJDmFSs67h+8sNaIhIkOEwQKpPebX3zFrL
         UCRg==
X-Gm-Message-State: APjAAAWF4UfYj/TQQux/D3wOYvPoOI3A8/Dxjwgx7sFBi3Ut10lSVb8K
        Vj0+t66A/Inbf6aJafwExBOZSxdQKh4=
X-Google-Smtp-Source: APXvYqxn3ntfwmrL/v96gX5s5FIm1RyRW1Potx8vLiHtfqQr7a+LGA0J651zcltIe5UzdBDMZMOa/g==
X-Received: by 2002:a1c:a982:: with SMTP id s124mr19609972wme.132.1578921566115;
        Mon, 13 Jan 2020 05:19:26 -0800 (PST)
Received: from L340.local ([2a02:85f:511:c300:1684:322e:585c:32af])
        by smtp.gmail.com with ESMTPSA id s1sm14200368wmc.23.2020.01.13.05.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 05:19:25 -0800 (PST)
From:   "Leonidas P. Papadakos" <papadakospan@gmail.com>
To:     patrice.chotard@st.com
Cc:     Jose.Abreu@synopsys.com, davem@davemloft.net, f.fainelli@gmail.com,
        heiko@sntech.de, jayati.sahu@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        p.rajanbabu@samsung.com, pankaj.dubey@samsung.com,
        peppe.cavallaro@st.com, rcsekar@samsung.com,
        sriram.dash@samsung.com, stable@vger.kernel.org
Subject: Re: [Linux-stm32] [PATCH] net: stmmac: platform: Fix MDIO init for platforms without PHY
Date:   Mon, 13 Jan 2020 15:19:20 +0200
Message-Id: <20200113131920.13273-1-papadakospan@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <c1af466d-0870-364f-1bff-0ac015811e60@st.com>
References: <c1af466d-0870-364f-1bff-0ac015811e60@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change affects my Renegade board (rockchip/rk3328-roc-cc.dtb),
(and probably the very similar Rock64) preventing me from using any kernel after
5.4.6 in a meaningful way.

I get the stacktrace mentioned before at boot.

Predictably, a command like 'ip address show' will hang since it probes 
networking but 'sudo' also freezes...
