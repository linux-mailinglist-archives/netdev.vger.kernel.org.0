Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1616613940D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgAMO4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:56:05 -0500
Received: from mail-ed1-f51.google.com ([209.85.208.51]:44100 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMO4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:56:04 -0500
Received: by mail-ed1-f51.google.com with SMTP id bx28so8691733edb.11;
        Mon, 13 Jan 2020 06:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v9m7FRj1RIIgKzSnC4HZY1IMC2cENWW1OPvGIrp/tE8=;
        b=DWejb2ccILuYkJZywpHWk35UxqIctqAq81eilk4LFXtglZrQp9ZhiNQh3XplRZEVvn
         6gnmP8Azqmx+dbKSqpMI/bEuR9auoeSflbaxyLvdIw9odencSKZwdirmiccn4LMovQP/
         68hPmypdvETOKUTn214zkb4SNnz1IPnnnRZwg5zF1aKvQYppeDjwWlMTWdttQPZHQOuk
         uGTGz7YjmG30lU/7Dm+kowfzC33lLU8IHI5q0Ki2Ixjrq/VX6t7tKowbNDqoAEcVDjLr
         AtcngSpElQI6sZItwM14ZaGSK7ftdh2zays7BdiuLnQvsW540D+bHwaGGWdUcPjJyayC
         kB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v9m7FRj1RIIgKzSnC4HZY1IMC2cENWW1OPvGIrp/tE8=;
        b=JAdV+2Z5NzU3/gz9McDsnbnHW2gon3WJZQs3tYv334TmUXqIUMQ0IwugwJygWkYMMN
         VDDA3Kb45OJ+ueRv6ipFEn1LYv6y8GniG/0UQVG0vUh7Z6P57Fo+sYQBmWd46Yy4lTMb
         GaarafTKFtynuk7MwJ74clPiNFn9lxpCtNb3TBXvBKaDOu/MfVDYzzw+igRTUaF64pN5
         X9B5LBg1UlhV8RtR9vsBO+CkiThbIwvxmy4CI77Y1L1IWYpqEuDwsYAlphW8rlUzPrGT
         2EmERzJPYtq0P/gy610lkKdMAqD48QmdNDnBGnvm1iuotnwmcA8tqb6I8Sk3ALDnFoZq
         dZkw==
X-Gm-Message-State: APjAAAXgjkKWTnbaEhCxwAbiZ360AVBNd2bTvcXUwqNdxDhbyVwqlHPW
        ws74tXXb9/dLRnDjtyTFR5/VMtlNQoUHWy78FNo=
X-Google-Smtp-Source: APXvYqzfDJ9hEzTCe4Gb+a1Q8VMptD56CLHVq2ksxUYJ6tuPjn64IulPVSVi0SoMnlAcVSSTUUB6Yk7F1fJrRyAse74=
X-Received: by 2002:aa7:db04:: with SMTP id t4mr17467761eds.122.1578927362578;
 Mon, 13 Jan 2020 06:56:02 -0800 (PST)
MIME-Version: 1.0
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch> <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk> <BN8PR12MB326690820A7619664F7CC257D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB326690820A7619664F7CC257D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 13 Jan 2020 16:55:51 +0200
Message-ID: <CA+h21hpsauapCGEHqVqHpEU2K-VsAh3vKBRJ_N8iq2i35SedOw@mail.gmail.com>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

On Mon, 13 Jan 2020 at 16:28, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> This uses Clause 73 for Autoneg. I can add that into PHYLINK core if you
> agree.
>

Clauses 72 and 73 describe some PMD link training procedure too, as
part of auto-negotiation for 10GBase-KR. Does the XGPCS do any of
that? Is this series sufficient for link training to work when in the
10GBase-KR copper backplane link mode?

> ---
> Thanks,
> Jose Miguel Abreu

Regards,
-Vladimir
