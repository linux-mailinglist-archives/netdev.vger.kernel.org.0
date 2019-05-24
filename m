Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB5829DB5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfEXSFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:05:44 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:33007 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfEXSFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:05:44 -0400
Received: by mail-ua1-f67.google.com with SMTP id 49so3952132uas.0;
        Fri, 24 May 2019 11:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=PcoTHdGaQs/oS0l0s0m+vBHryefQqzo0n8dHugWubO8=;
        b=NeXqS1HvsZSSQRUkTzNHSX6lYJlU04peNsF9phz9BtuIIDoB2w/XG1s+IBZ7NT1GDg
         L13UfZN1KSPpSTcnH2A1viXbsFRhEAqPmRyq06Dwq67zxoiwxhXW8ZXEnT8tpR5RDf7c
         uSlOGwi6YYKb909ek9RNaAUXDItdj7n51ZHznUCf9y8tauP4ZERUNpNjP4x9Pl/3NLE3
         vJR8v6WY6ORryPQmElOTEAxwKm17hjLyrPJF/5t9EJ1TElx3J12ywmOcCijM+N7KYWhj
         KpLSZNYUhtmNKbgWJv61oXlKMsdz3uxYTpQoUxo9RWVs2xcOsM2pbCd55rVPcm44cP7K
         F+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=PcoTHdGaQs/oS0l0s0m+vBHryefQqzo0n8dHugWubO8=;
        b=WR3QHzmK9SHo5sSVoAuo7u6TmOtNS9wwRjLySoHVpF37PXzRJb7/W+2qfSkW3AHX2S
         hoihr7GfxQfI94hxfkVUoJihhVlEIGEdNGpo909B7e9JhW2R7SeFMYQVNIAeyRS98Mc8
         A7Mws6QzHIFQ7KWIFpo2pydOsCIaDJuh8r7SgtSPalsIzZ5AiyWWaplXkRhPt9MfGV8u
         5nZ5z8s2B4w4ylnFIBbrKumOI+5w22byMxlK2d5U6LVtWgtqn90UDhETuylMatqZujjf
         KDrPGZDAzG6mbL1r3r2b0qibnRo7tOwLxI4YlP1vswZZioGsImwVhTxk0eUqAyq6Ag3J
         6cmQ==
X-Gm-Message-State: APjAAAVOUIKCL/Ov0EPHzIi2qi04BeHFBeGnpdZtHQy2d0pyvLDg9S9M
        WH8NGINSg1lyE0IQl5wVuZk=
X-Google-Smtp-Source: APXvYqwkWNCRx3CHExW+IJQePUfT7RZq3BIM6AwWWMLeEth5GJy6I/4peZPF7oluIdgapau0d4poKA==
X-Received: by 2002:ab0:644d:: with SMTP id j13mr23523976uap.98.1558721143160;
        Fri, 24 May 2019 11:05:43 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g41sm1889892uah.12.2019.05.24.11.05.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 11:05:42 -0700 (PDT)
Date:   Fri, 24 May 2019 14:05:41 -0400
Message-ID: <20190524140541.GH17138@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] net: dsa: mv88e6xxx: implement watchdog_ops for
 mv88e6250
In-Reply-To: <20190524085921.11108-5-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-5-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 09:00:29 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> The MV88E6352_G2_WDOG_CTL_* bits almost, but not quite, describe the
> watchdog control register on the mv88e6250. Among those actually
> referenced in the code, only QC_ENABLE differs (bit 6 rather than bit
> 5).
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Clean patch,

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

Thanks,
Vivien
