Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE62BA56B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgKTJFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgKTJFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:05:22 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1036EC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 01:05:22 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id u18so12389252lfd.9
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 01:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=MSCard2X4Oizz2IShotDAipEPeeItot6kxo2LP01XQM=;
        b=iCPziARTyBVR4d7NnOjPyg2bRC6KocAJILLES+9LOVNBZRmbVKoZfU2FJ//RX6m60X
         lexsda5QWYv+elx0dnu6MNQRHUVbodUChThPL642opTQWoJxhqUAR/YhSPDM9yHYlX7t
         KCEcHPFCxneAb6u1jeSagKgHSHTFc7RsdZgzg2bq8FhBRdxOiP4JLL8yqBZ6h31Q1jtF
         uCB54BSlws2rgIi+eYTdITkDAx1kWQbvqCapcnms1/rNTiYB9lQE6JxfasnGcGbwufv6
         LK/j9+2syvhBchXw0zeMVVHxGWWKMalfSKDqbY+TM4+chTDy+YsY5qQSBouv8Bh0P3r8
         SfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MSCard2X4Oizz2IShotDAipEPeeItot6kxo2LP01XQM=;
        b=Zmm2n3r4CPLvX+uZ1teOu5MbnHyJgfQk7c4+suwEy+U1gDl4hqE+d+nYNrIoSpOaS9
         suNwMJ8mxYAU3MN4Eh1j9zprjrB3qm47LZMYFAex+3QHHHhEHcKnM+xLZ27K7Xykzgld
         XJ+Kp/y6WExWuheDHMsQ5MMZULVYAgTArqYGeBFUT09PRMmMYhNMFB6OlR2AwpRf+RfI
         S1AZduvGfSFr3SsNO4B3QtB+P3ScwuhvQr4kCKamfJC/DqzYW7kzN/v1mg6j6etgVp/s
         OugL5ko0zAysdb06bo/D/j+iZx2A4/hC0SvkbJdWIbfi776pFFmdSMM6emGTSm+rB/JH
         yI2A==
X-Gm-Message-State: AOAM531SOVjwydtqwLYAho1hCaq9i2YiV52ohQuZYzNl2C4Pklc0eTrM
        wn19O2LUPj7ijuzGx5gEFZ0GEA==
X-Google-Smtp-Source: ABdhPJygnPaucjl+f9oOs9ZZV4fWK3vYg9wJ9XZnTvPnat04HWCF2njOx5ms2o1lAnyOuO71Vg/kHA==
X-Received: by 2002:ac2:53ae:: with SMTP id j14mr8318808lfh.216.1605863120351;
        Fri, 20 Nov 2020 01:05:20 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d6sm270692lfn.295.2020.11.20.01.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:05:19 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
In-Reply-To: <20201120000050.GV1804098@lunn.ch>
References: <20201119152246.085514e1@bootlin.com> <20201119145500.GL1551@shell.armlinux.org.uk> <20201119162451.4c8d220d@bootlin.com> <87k0uh9dd0.fsf@waldekranz.com> <20201120000050.GV1804098@lunn.ch>
Date:   Fri, 20 Nov 2020 10:05:18 +0100
Message-ID: <87a6vc9z5d.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 01:00, Andrew Lunn <andrew@lunn.ch> wrote:
>> E.g. at Westermo we make switches with M12/M12X connectors [1] that
>> sometimes have a 1G PHY behind a 2-pair M12 connector (for complicated
>> legacy reasons). In such cases we have to remove 1000-HD/FD from the
>> advertised link modes. Being able to describe that in the DT with
>> something like:
>> 
>> ethernet-phy@0 {
>>     mdi = "2-pair";
>> };
>
> We already have a max-speed property which could be used to do this.
> It will remove the 1000-HD/FD from the link mode if you set it to 100.
>
>    Andrew

Oh wow, well strike that argument then :)

Thank you
