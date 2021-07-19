Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4B3CD505
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbhGSMEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 08:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbhGSMEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 08:04:38 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C8AC061574
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 05:02:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id go30so28457502ejc.8
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 05:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DyBB7WKv/K4wAbBcC4er6gncsPDeokBD/U0TCgAc0/M=;
        b=ZQCMwATjg0uBSGJQYZwjnEfbHNe5W9MfOsVVYU7cO/H60X1OCHOtZN7YvE7Hge+mzs
         rmLFhNqejdGjX03131Z74xC+/NQAVahEUO6lzlm9oASyO0CC6Vu0ii9WBu24kX9xGjan
         /+PLWmdiuiK03Qvzcf6NFn2YraaGWqG8qkGJbAqaf0uqkTpb95cvT01368slz1V3owzO
         LueavCJD2Yv4XkUKg7BzJvx31oDZYoEViNCI5OVXjHnO1Vsm7i7VARAdHzz4nzjfA/SB
         /iK1BfWd8hsi25KTwCyu7ZVk3ay6MLDXn9yHmcNxZPUHew0lDz9Wr6Zno/sSl8Q4wIjY
         lAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DyBB7WKv/K4wAbBcC4er6gncsPDeokBD/U0TCgAc0/M=;
        b=JBKUAu9IqwLHvb08R2zTceRHYM88oi4ypPc6jm5ak7kUNQ7QMKSk9e073x7e4TJ1wZ
         GczCFveztZ6Acllm1cp0UxlBz4HANUA+x7P5zpOLLlcHYaf9Wlkk5ogWr9ci6jJSmVGK
         ocezJ2vvdioTpsjpl4DN3mmuWyGjkrEAHiLpHGf7IE+L2XfudiF7zJkvK/9x6GTpbVh/
         a/7wnV/+9sW1txF1uvISRUQ/PpjDNP1i1v5xHYqizXl9jk5eg2z4CNo5CfFxyvsj51Uk
         Avjo4EyYA2+W12uswu13qsoK1qNvkXHVzNcUSkPX5LJ6A/1GbKdZgPLdw2W2FzMLJH+J
         f/Qw==
X-Gm-Message-State: AOAM533Rxs1TLLptykuXZ3sWCVbxSsIC0JDNk8FC7Th/BzjnoNtO4v29
        uJlf64vvfh88OAJ6b5Jluqw=
X-Google-Smtp-Source: ABdhPJzLQs7iXjgqahKnWCeJgsZWSIOf534Ka8XG0to2mF6aEnM50LLlwacwrxycq2GLWOtuFVtMRg==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr26478829ejd.171.1626698715758;
        Mon, 19 Jul 2021 05:45:15 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id y9sm5947649ejd.52.2021.07.19.05.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:45:15 -0700 (PDT)
Date:   Mon, 19 Jul 2021 15:45:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: DSA .port_{f,m}db_{add,del} with offloaded LAG interface on
 mv88e6xxx
Message-ID: <20210719124513.f6rshjaressm5jhz@skbuf>
References: <CALW65jZoaYYycAApviuQjiOTNuG9sfSpGZ1izRgJhj4M-gfDyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jZoaYYycAApviuQjiOTNuG9sfSpGZ1izRgJhj4M-gfDyQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,

On Mon, Jul 19, 2021 at 08:22:01PM +0800, DENG Qingfang wrote:
> Hi,
> 
> What happens if a FDB entry is added manually to an offloaded LAG
> interface? Does DSA core simply call .port_fdb_add with the member
> ports in the LAG?
> 
> I'm asking because there is a trunk field in struct
> mv88e6xxx_atu_entry, when it is true, the portvec is actually the
> trunk ID.
> As the current implementation (mv88e6xxx_port_db_load_purge) does not
> use this field, it probably won't work.
> 
> Regards,
> Qingfang

This is not supported at the moment.
Coincidentally or not, I am currently working on refactoring the DSA
handler for SWITCHDEV_FDB_ADD_TO_DEVICE to remove some of the technical
debt (in particular, local FDB entries pointing towards the bridge do
not work in all situations when combined with FDB replays). One of the
extra features of the new implementation will be a new .lag_fdb_add()
method in struct dsa_switch_ops.
