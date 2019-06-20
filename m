Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062644D26A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfFTPrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:47:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42921 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTPrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:47:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so3523559wrl.9;
        Thu, 20 Jun 2019 08:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j8+O/FpjGEp5DMwDwlNn6YYVJi0XgVp0kNC/STZbtEU=;
        b=a7G2DL7iS4UbSDyFHlZOt6gKtJamMp/qfpGySB+qvl5QIMgRi8u3Ut0Sa2Dw/k1Pz2
         7iNZ4pUk8GMd46O4PxGk80ppkgFDfnAFNxbKL14h+yTOiF5f3BwkZbir65F4Y7xEGLJ9
         SI8cLSGVyRynl6LsNTsshElVDLAUUteWO9o8hESIO7QPzimF/9fCHcBJlyYhURyy1mHN
         l3bA475pko/ng+rpoWW0GaKL8F9oXrRuIqDLQ6bKdlwMGmGvaDmf1iq8afXYilHH2cN+
         1GrCeS/EuTcD9sOJqC2aUIhCbsJx2E/XvOaN1zKIYif8YqE1a37uYInaoJqf/1f5dM0d
         tVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j8+O/FpjGEp5DMwDwlNn6YYVJi0XgVp0kNC/STZbtEU=;
        b=fcO94G/ilIKmB1Waxm8AwWsYrrQCa/TzApurrz8aIHLDyavOMBBdOuF7CJQCF2/fhn
         2gjmBz4wra/JHC54m3TnFGeRga2/66WpG5t5k0UQvpz+bt/n5HwHSfpXbpn//iBkDEnP
         HSm4mWafTG4Dom2dl7JVy2AcEAI/CiEMHHAIlIiRFW/uUVYA0RbDBbFlyOCfbMGHsUbu
         boiMis6cy7O5WY7AjhPOvyp7AaXlTyxSrpFKbEdNtDp7VIjVHpIxlpbeCFg/DvazFr5/
         MoKq5DegHMuKpffrSCm8H/n4NQKebOeHGzy465ctOmhW80xH1N8WPX44COqUYI4mZXTJ
         08FA==
X-Gm-Message-State: APjAAAXU4l2j4pnB97cDDk9Dwor8TEFf6X7WOBkK3Dl97Q68gDL6Moum
        mNcOEhMYIJox4Q6chVh+oFk=
X-Google-Smtp-Source: APXvYqzHNm9RBSmLyiRY/o0XRv5jhDv7AQySfI5uddGuB8TuFA9tiBLHxxYFpdEKryoOHuXSd1FtIw==
X-Received: by 2002:adf:db4c:: with SMTP id f12mr11932674wrj.342.1561045653597;
        Thu, 20 Jun 2019 08:47:33 -0700 (PDT)
Received: from jernej-laptop.localnet (cpe-86-58-52-202.static.triera.net. [86.58.52.202])
        by smtp.gmail.com with ESMTPSA id f1sm6408689wml.28.2019.06.20.08.47.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:47:32 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-sunxi@googlegroups.com, megous@megous.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [linux-sunxi] [PATCH v7 5/6] drm: sun4i: Add support for enabling DDC I2C bus to sun8i_dw_hdmi glue
Date:   Thu, 20 Jun 2019 17:47:29 +0200
Message-ID: <3014360.88acaTKTIR@jernej-laptop>
In-Reply-To: <20190620134748.17866-6-megous@megous.com>
References: <20190620134748.17866-1-megous@megous.com> <20190620134748.17866-6-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne =C4=8Detrtek, 20. junij 2019 ob 15:47:47 CEST je megous via linux-sunxi=
=20
napisal(a):
> From: Ondrej Jirman <megous@megous.com>
>=20
> Orange Pi 3 board requires enabling a voltage shifting circuit via GPIO
> for the DDC bus to be usable.
>=20
> Add support for hdmi-connector node's optional ddc-en-gpios property to
> support this use case.
>=20
> Signed-off-by: Ondrej Jirman <megous@megous.com>

Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>

Best regards,
Jernej


