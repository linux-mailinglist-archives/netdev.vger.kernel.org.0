Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F1D49BBBD
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiAYTFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiAYTFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:05:51 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349D3C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:05:50 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id z7so13923207ljj.4
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=NtMa1T7t7EgS1sxhKNbKi+1xelawUDLFvk/ZWya+Bms=;
        b=SCzDIy2nVfUOxJqrKQ4NEbYPCj1bgRnfskk6KB4eC+m8Tq5tiYuZg0mfQZozzHSOZ8
         jRExW6qoPU1yngz1V0F2TG21N8waU36Y6hQRpemLtOFmq47tRWTBhBzHjlr/O5f4xiF8
         4dvb8X4Pu/1EjbaTACvjdmkJbb01mow8uQNYn2jmmBdIf5La//t3VaZVaiZoSnOkMTMr
         nJf4vlhSaRwZQAE6fDznROoLaiILzRBbqULXrc1cLLUBmvosRU0dOKyBEoOenh2pcdkU
         R211oQOA6QF1FaZRPFyX1KGriaiUqhfbHQOYbhv5hRgIZVIeEzprf4tlOv8xkrlIFqDC
         X4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NtMa1T7t7EgS1sxhKNbKi+1xelawUDLFvk/ZWya+Bms=;
        b=Y8GKQlgJhcZfO3L1EwaYcekntenJWjObOyxvSkbHWwTvAH5AwzBt+tFYmRFTVZuxO9
         Y6L/wuSQ+mVBFtUEuETtcay5oKT40ZrEO9ZY6bvfyeHOXLNRl3BFKFb5oyFPHzAVeFhO
         LeXDZXQO0lPBBk/KkAVKNsH/NS5GRCRXasVeNOHvvchrai/swz286CUAW9Q+vGj6V/AL
         dW78XvcFoLrVtjcLzDL42CU2Fff3fooMHimX/eZkPsxILdYJBwqJDtdffYtDBzbxSHOg
         pnDtOzWIMQ29T84YydTM2dLT3UUD8ZP9aChGSKEUqW5VWAPUrE4BQmB5g64cdHbgBepM
         073w==
X-Gm-Message-State: AOAM530R5oaSddJ/l7IOyDvpe01xVpggcMxx4ApwiY4ZW86m3gdlsbnF
        nC8a1P2k9lcqJNLYxQpkpYyY5AWdlAjetQ==
X-Google-Smtp-Source: ABdhPJx7L4PJ6sqGWT3wh4u41gTHBlrW+WSeIpjDFukNist/J00Yj2qPR2bpptiUyWf5JkPQ21EoWw==
X-Received: by 2002:a2e:958e:: with SMTP id w14mr2654386ljh.380.1643137548278;
        Tue, 25 Jan 2022 11:05:48 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id d2sm152328lfn.156.2022.01.25.11.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:05:47 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: dsa: Avoid cross-chip syncing of VLAN
 filtering
In-Reply-To: <20220125100131.1e0c7beb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
 <20220125100131.1e0c7beb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Tue, 25 Jan 2022 20:05:45 +0100
Message-ID: <87wninbppy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 10:01, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 24 Jan 2022 22:09:42 +0100 Tobias Waldekranz wrote:
>> This bug has been latent in the source for quite some time, I suspect
>> due to the homogeneity of both typical configurations and hardware.
>> 
>> On singlechip systems, this would never be triggered. The only reason
>> I saw it on my multichip system was because not all chips had the same
>> number of ports, which means that the misdemeanor alien call turned
>> into a felony array-out-of-bounds access.
>
> Applied, thanks, 934d0f039959 ("Merge branch
> 'dsa-avoid-cross-chip-vlan-sync'") in net-next.

Thank you! Is there a particular reason that this was applied to
net-next? I guess my question is really: will it still be considered for
upcoming stable kernel releases?
