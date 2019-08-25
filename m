Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B849C4C8
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfHYQCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:02:35 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46627 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbfHYQCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 12:02:35 -0400
Received: by mail-qk1-f195.google.com with SMTP id p13so12239921qkg.13
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=42ZC5+RVLTinAGK17YjMdmaz4cPCaGDNtwn0kNG3WNM=;
        b=NNkJ+TlEPTrraWjGwkAYTGbVTTtxnhG/0HrBbvf0c9T3Ai7oxpoxSFT+oqbNvWJg7u
         KtWbl71Yq7e+0Y21FdgA/ZNSr4uhT/70f6toBdDf8/Weu1MTtuKfdhfcetwRgUxarxC5
         SpK5odiRE10e5gbBLAAX+f8RNaNLeo4XCHfZIfO5aNBbWMKtBFdUFhtOLr0MstKhAoBi
         gSpyrF1CYIvJSPibouttSqxuuB9M/qnbp/GIaoZ8QuyVt2AVMd7gKSx5G/sESsXWjegi
         64/u235m8f8XcJCyigMQgzOnbduufMXbxxiuHwBvjcZ0OkFZo9qLccloU/3LYMEhoKMa
         Knjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=42ZC5+RVLTinAGK17YjMdmaz4cPCaGDNtwn0kNG3WNM=;
        b=ZHzJZqoYKjaM2kcHOBh+wr9IQtT8Zz2oL9OhzuT8zClHzUAgy0Wy1+BXd6bHSQwC49
         7LP6yOA1OPQM6ad2jdOUvALQg5QTSsOt2K+on2M/OUnSOz9lpGu60zKyG6foiIL828zv
         7zM8tulZfRKUGn3Oo7CEAWLVje1AmU1Iq3DSC+i34FyUEPpwzqo8tVGQwgoWr026byiN
         6NqFXzMMDatodImKN/zpY+cOMelqwkIF+LGvQFSVDl31ceNGqxJYNJQB/goI/LQ5f+4M
         Ogp5myD7UvsPimUgF6Zqiu/yaaTcMz+87s8g3yT4kl/Sg3DYeTSwbn8aOhtto4AZAv45
         eQrw==
X-Gm-Message-State: APjAAAX7/2Clw65bkwGyIEnZ6wvFyxLv+d7KoVC/pUOkwD0ZRzsdIQYt
        dwqX3wSfpgy9ZgakMdMP2ZQ=
X-Google-Smtp-Source: APXvYqzhKNCVMxsYtLjrfRhoPdNjLdBRCTeVF1L3xgRqDusmMatRBK0en6lWfVdqMJT5ZhUos/iYiA==
X-Received: by 2002:a37:b4c4:: with SMTP id d187mr12311209qkf.459.1566748954174;
        Sun, 25 Aug 2019 09:02:34 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p59sm4782435qtd.75.2019.08.25.09.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 09:02:33 -0700 (PDT)
Date:   Sun, 25 Aug 2019 12:02:32 -0400
Message-ID: <20190825120232.GG6729@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v3 4/6] net: dsa: mv88e6xxx: simplify SERDES code
 for Topaz and Peridot
In-Reply-To: <20190825035915.13112-5-marek.behun@nic.cz>
References: <20190825035915.13112-1-marek.behun@nic.cz>
 <20190825035915.13112-5-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sun, 25 Aug 2019 05:59:13 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> +int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +
> +	*lane = -1;
> +
> +	if (port != 5)
> +		return 0;

Aren't you relying on -ENODEV as well?

> +
> +	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
> +	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
> +	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
> +		*lane = MV88E6341_PORT5_LANE;
> +
> +	return 0;
> +}
