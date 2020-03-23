Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2518FC9C
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgCWSXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:23:46 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35460 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgCWSXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:23:46 -0400
Received: by mail-qk1-f196.google.com with SMTP id k13so4645971qki.2;
        Mon, 23 Mar 2020 11:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=pxQGd5AdyutteOIvAQyWIwfU7T2T1nCM5kVPlyE1dag=;
        b=R6g9O1aJ4ct3TFhYVVpHBpqGry9HpNS5PuO+iO7MteTplmXEyijEYZ1hz1ULHy/o3C
         Jl2stoeBcFWMBCcn/zZ3rKXpd1qbynOVkEquOQ4uRwIYX83C1DKYZOcN2Ods/zAcf9rp
         5bAMJsTZ7zHum+5AKQDt4Bi8qPYMV3u2VECnthvphe4LemSm6bxP5yZkg2GGYQLg7M+v
         gqREtbW/SU5/X4jVtcgta9+o4bIDnSwXBhlzWqGRynEOatXfVzHwNkCL927A3k7NaKz6
         zoLlIURX1SjJdSzC3oTKNaa3IYcw+/p7jleArgLoUiTUfFekgLaW7FMYDw2Wg8oLLsEU
         297Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=pxQGd5AdyutteOIvAQyWIwfU7T2T1nCM5kVPlyE1dag=;
        b=sL26PubyKsFhR9Dm7ycy/mH7R4NbYWsWIA1aaUGDmyoDvEvUOTGOfZpI/mhKhGogyK
         agXdvFl3kJ8ChH/kBQbpuFKeB7GHvLctRuIqZEBC3GFu2w1yDLJOcPa3l8QeIAaDvjd7
         EvSQt7JuddmHGQgPJoVrUYLCBxmPfL02MsI5a5BQwLXhfzUcVQ1N5T9cjmvLj8zuKMFl
         whCgNTtZeVZwesA6q4qVc3A8LvgFBV+ceLYJfKd7orPAYh2fCXi7I5sj5aTluaMrwR4x
         0TXh1HEDkCeIJLSOGnif02Rj67upkyGf4q+R1EjyIbQfnqbXLxNXGUNX3Q7dGhqvRK9U
         T0YQ==
X-Gm-Message-State: ANhLgQ1ICLNxOKrsGCjBsWrUohiON2lxCpyyeyeNKpK7cEP165tyCylv
        KerIGSZY9WfR/SN4fVbNHh4MIt6a
X-Google-Smtp-Source: ADFU+vvJ8FdJfmEDICEEbe/rvbppzglFwH+sqPoV6JqW2Ob3rpUNEU5rrk7Z3T4++ZWLLTmiYySGBw==
X-Received: by 2002:a37:61d0:: with SMTP id v199mr17557635qkb.305.1584987825334;
        Mon, 23 Mar 2020 11:23:45 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s49sm12976791qtc.29.2020.03.23.11.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 11:23:44 -0700 (PDT)
Date:   Mon, 23 Mar 2020 14:23:43 -0400
Message-ID: <20200323142343.GB4041079@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, mbizon@freebox.fr,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: Fix duplicate frames flooded by learning
In-Reply-To: <20200322205850.3528-1-f.fainelli@gmail.com>
References: <20200322205850.3528-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Mar 2020 13:58:50 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> When both the switch and the bridge are learning about new addresses,
> switch ports attached to the bridge would see duplicate ARP frames
> because both entities would attempt to send them.
> 
> Fixes: 5037d532b83d ("net: dsa: add Broadcom tag RX/TX handler")
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
