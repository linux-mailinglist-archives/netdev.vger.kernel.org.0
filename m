Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A5F2F3DBA
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406946AbhALVhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436909AbhALUZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:25:49 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEF2C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:25:08 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id 6so5353339ejz.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YYuEIJqXLXQgytml1bBH1e9/E+0O9VrS6ufoPj0bRhI=;
        b=p4itdLBfazJv7sL6hKURoSt+Knw34GogjeGGKS84Ftd9pM9wQYfVs/SFGXtuSRVEjj
         Ljve3cRBYC/SmzduMOajt6bFSV8C3wKXptQ1hSfbR5hUHpQ93MeY2g8y7pYg3pFTZyST
         LUcnxQ0TKmChR1VeZvH2qobrLK42Nayq2H6JkJIUubiC7Ssdt+jDPH2nFZADQ+rtnmWg
         KzqLFjU2Awv4FDrDN5NL6xbZWyNnbH2jO8pkmLeIZYBnWAnZ0hJD5I+VNiMYyD2DQ3yw
         6NKguayaxQD6oDTEJOL9smpF5ro1u2TtXNaXHEpDBNcW9d3z9AGJG4hREewoinS8dfqw
         sNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YYuEIJqXLXQgytml1bBH1e9/E+0O9VrS6ufoPj0bRhI=;
        b=iNa1dl2ulzoQVXBasC+IHu/Wq7WVv0nBJYhQa91Md1lyXVm6FfRGYi0lJY9IV0sBEJ
         645CrXD6Kw9na75ATipACofO69hdG6D/kZMk8/aFryciqHN8GvHecHlOCGBkxRp7r4iF
         BQw2S4Gj0pw0aT7makGxICjKB+v3+oD0f/hw9yKC9q3RafgARVLsF0RDjaGMPD7xDxEb
         y85tDa/lsPQ+ZKiZJLpf/HIkT21VkKb/P+ShrztYQu1k4PrYh2k8wV36auE47VXhy73L
         AWS7OD7WeHE0ulE549Gg3+idnyRiql5y8ZKgjgzhhOIlX7EBLTThW32CYMdMT2U0kAEW
         7qVg==
X-Gm-Message-State: AOAM533lPPGZe7D6Hnr6BRmxP/iFkQ8PMMcOO+8ATNJR67o/SD1XVOhT
        2e3LWe4G2y4MSYUhE5dTe/w=
X-Google-Smtp-Source: ABdhPJxi8YbKR67q3DE8rhlgyIMVW3FVAVY63FnINZDD38LHvksc1ZjNoB9bluPGGWnQ23zbIphA9Q==
X-Received: by 2002:a17:906:4bc5:: with SMTP id x5mr397147ejv.55.1610483107002;
        Tue, 12 Jan 2021 12:25:07 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i18sm1891031edq.79.2021.01.12.12.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 12:25:06 -0800 (PST)
Date:   Tue, 12 Jan 2021 22:25:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v15 4/6] net: dsa: mv88e6xxx: wrap
 .set_egress_port method
Message-ID: <20210112202504.e55g7azsvmqkchua@skbuf>
References: <20210112195405.12890-1-kabel@kernel.org>
 <20210112195405.12890-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112195405.12890-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 08:54:03PM +0100, Marek Behún wrote:
> There are two implementations of the .set_egress_port method, and both
> of them, if successful, set chip->*gress_dest_port variable.
> 
> To avoid code repetition, wrap this method into
> mv88e6xxx_set_egress_port.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
