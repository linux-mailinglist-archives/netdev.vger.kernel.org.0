Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7ECE45D
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfJGN4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbfJGN4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 09:56:20 -0400
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B83F520867;
        Mon,  7 Oct 2019 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570456579;
        bh=RR9DRF39oJCR1HSHYuun5bistTTOv6+Wz8MHq5p+aSk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EiT+C+YsyvMxzR9zIaUlQs95iq4A862EsYfpaNIZQ+TtRi1Mi7FtVPm1AbnsgIJ+K
         tAFODN5b5cFQQ6nqqC72VgkzRKev0cRbigYdaFQHlpGvDbhXgWeVjW8OGR/W/G7BMZ
         Has1eijhxLv5fLJ1kuKCaUFRQAWYsTmttSwYsjdM=
Received: by mail-qk1-f175.google.com with SMTP id h126so12589560qke.10;
        Mon, 07 Oct 2019 06:56:19 -0700 (PDT)
X-Gm-Message-State: APjAAAWGoaU5Cb0h0M2joYyVBXNSO83V+Rr4eXkNTRYhwoBKyLNLRNCE
        3jY8r/QwUddNqmXFu1BCa7gZ1nepDsl2/LHweg==
X-Google-Smtp-Source: APXvYqwm/bLwZM+PssqOzYzoANua8YSLYuI2PMKJKrZyC7DCdzzrTTVWk2vijf2KyteLQtKm+abCCIEQJ6n5QW83AcM=
X-Received: by 2002:ac8:31b3:: with SMTP id h48mr30882416qte.300.1570456577813;
 Mon, 07 Oct 2019 06:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191007102552.19808-1-alexandre.torgue@st.com> <20191007102552.19808-3-alexandre.torgue@st.com>
In-Reply-To: <20191007102552.19808-3-alexandre.torgue@st.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 7 Oct 2019 08:56:05 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKFUTwjJefQvQE5aFmeJButYSLKm0RSpCHjSL=7pQHtxQ@mail.gmail.com>
Message-ID: <CAL_JsqKFUTwjJefQvQE5aFmeJButYSLKm0RSpCHjSL=7pQHtxQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: net: adi: Fix yaml verification issue
To:     Alexandre Torgue <alexandre.torgue@st.com>
Cc:     Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 5:26 AM Alexandre Torgue <alexandre.torgue@st.com> wrote:
>
> This commit fixes an issue seen during yaml check ("make dt_binding_check").
> Each enum were not declared as uint32.
>
> "Documentation/devicetree/bindings/net/adi,adin.yaml:
> properties:adi,rx-internal-delay-ps:
> ..., 'enum': [1600, 1800, 2000, 2200, 2400], 'default': 2000}
> is not valid under any of the given schemas"

You need to update dtschema. I fixed this in the meta-schema last
week. Any property with a standard property unit suffix has a defined
type already, so we don't need to define it again here.

I also added '-bits' to standard units.

Rob
