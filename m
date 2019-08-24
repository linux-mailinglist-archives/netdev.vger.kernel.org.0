Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2D39BFF8
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 22:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfHXUNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 16:13:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42502 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfHXUNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 16:13:30 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so11209073qkm.9
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 13:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=VH3WHflOmCtn8wwPQQcuiNSCZbdxzXVp1wwi7XfnTuE=;
        b=ueP4tnv+avp8TZAMCxpqqgGEehqg7uDQ3Kum+Mw09GqM2NCBN+5XahQ598fHmQhtgJ
         JoETWRP7D9s3Rsu1zhKl5gT0eH6pH1F56IUNG6AGtDbASsW2MGEPCdD9HYkMXoHaKinW
         gaf0Ki+vsoPfob9X5ZOVPsPg2W/jEnAPKmv76Ul5AvorPGE/SnOPRAG9UotFc+d9vdd8
         rIsqksEdYSNv1Zo+hXs8hI6/x+IPAkU2OfiBXXs16rvlJ0/gUDYdTwhlEETEHIN+1O+K
         Q1z8WzdoByXn0s9N3gDC5g+ReK1aRPoHLjwRyZN1tkyjCFIuTcyXv9Y3ypbUvFazDYZB
         ozLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=VH3WHflOmCtn8wwPQQcuiNSCZbdxzXVp1wwi7XfnTuE=;
        b=YGJBVMORtIRaFWQLd5LPyV2WHX343EaoToRl5+HlubN5w2Tzfd2fuhy3XRQFf6+u2V
         rbELWtd/kojRt8QtDxZoyEa4El8rJyfSqtkePA+Dm0656biUhrQ92Cmwx1cdqB2js/pf
         eV0Iack40vHTOi7jo8Kl38RMWcr2uiM7eyMhp4BKRvYUFdBvMNaonopeOZIvTPYGauxi
         q1/AX2IWGSUZFDxurpX6iUzR8Za7BYj69pza/aEy97lKr0iB2mMrhJMnDNM4bp72zX06
         mV0PZW0/Vmxb5o6Rqru7VAQO1FA4gUCmF45PdEGBCb0xEoSipPuWWuCUy/fcNsbCakCe
         ewdQ==
X-Gm-Message-State: APjAAAWuR55td+BaxEPssLVBQERY5TEVBUdFyOWPjHoLHcgokYDDeNTP
        pltRuuU7clyfV/yQrWpULRs=
X-Google-Smtp-Source: APXvYqyUOlN7zo/LzC26bt68ljue3mHECo+8civcTOnxOjfufVvjFqzNgVF0QTDOMyweb67zTc2L3g==
X-Received: by 2002:a05:620a:15cd:: with SMTP id o13mr10022838qkm.273.1566677609658;
        Sat, 24 Aug 2019 13:13:29 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s4sm3615294qkb.130.2019.08.24.13.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 13:13:29 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:13:28 -0400
Message-ID: <20190824161328.GI32555@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v2 8/9] net: dsa: mv88e6xxx: support Block
 Address setting in hidden registers
In-Reply-To: <20190823212603.13456-9-marek.behun@nic.cz>
References: <20190823212603.13456-1-marek.behun@nic.cz>
 <20190823212603.13456-9-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Fri, 23 Aug 2019 23:26:02 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> -int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int port, int reg,
> -				u16 val);
> +int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int block, int port,
> +				int reg, u16 val);
>  int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip);
> -int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int port, int reg,
> -			       u16 *val);
> +int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
> +			       int reg, u16 *val);


There's something I'm having trouble to follow here. This series keeps
adding and modifying its own code. Wouldn't it be simpler for everyone
if you directly implement the final mv88e6xxx_port_hidden_{read,write}
functions taking this block argument, and update the code to switch to it?

While at it, I don't really mind the "hidden" name, but is this the name
used in the documentation, if any?


Thank for you patience,

	Vivien
