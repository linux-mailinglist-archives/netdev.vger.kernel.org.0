Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3A4305588
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316983AbhAZXNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbhAZV4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:56:11 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CEAC061574
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:55:23 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ox12so25275094ejb.2
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xBp5BCL6QEqewtTHUKtguNo/QUuPbplfspZ0uay1xGk=;
        b=pmenp/KjnCa572zogLxoMWIUm0uyRuwhzyZYqVKlh788azzJaQ3OI9rkHP2HaNR38V
         io7b+whomOrs5bf9Du5038lQYZTyBhrfCoH16igf/oeNXy5yo4mhI2S0jeoJ3h75YxGG
         a8fT8csFdRU0TOG8cjMMo99lqDbEEkBzp/vchxZbF9TnpLtSrsBbyHUlF3VISG17b3qc
         yT/F+N5jlv96iVHLtmACwlL946jOEdCbjBgKJXwFngPOPf0TLlJf0jytgMNZYhQ8Z1MT
         s3F6ZF2QxFFmCERUSHun+7ZfSngmc7J3ccxG8FkgwkeB2HbtN58W0bk/FSk4DvJSU2jJ
         tP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xBp5BCL6QEqewtTHUKtguNo/QUuPbplfspZ0uay1xGk=;
        b=PX2SfxMBl8nbB3cGfQq12cFEgeHhzpg9th18nUpt4jRmlLF88tbXBw0hm5Qe/JLpGr
         7rQvkmDD9gYAa8yHDvJ/UkyeogcsU2vwE+WlI0oB9Hvrv1SHuKyfxgxXIqt5sMR2KHlX
         Sww7XGrEqIQ0X3PE8RdVeI36GQakedFB9jkLsTIl0oZAR7lzOhWApsYZi/YuLKyq/LqS
         txt2a+iML2zTDr93hfGbm5GIR6JcDt+FWGL1R9+gcO90J6ch4HhyHRhPcEZeWdpaVw3V
         Y+D3yzXtYfSfPVYekrB9Dn5HzeX4IasKGX26OA90l+sobPEewfnRUxaTUBoli7IEhUob
         L+9A==
X-Gm-Message-State: AOAM531c73hSfYdwj9YPbZByeWWcIFIUyjSIMRAbbRjvD0Ltr6d3FBsU
        sF30eDJ3UV9oMpNlVWGJ0QU=
X-Google-Smtp-Source: ABdhPJwIM1t+JNTsPptm7F8AYLCWpjOZRqSMAsBjUQ+BnkRAjkR+JguhHGFHZ/Q8zZucYHQyofSrrQ==
X-Received: by 2002:a17:906:1a56:: with SMTP id j22mr4625509ejf.40.1611698121813;
        Tue, 26 Jan 2021 13:55:21 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p12sm23055edr.82.2021.01.26.13.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:55:21 -0800 (PST)
Date:   Tue, 26 Jan 2021 23:55:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: mv88e6xxx: use
 mv88e6185_g1_vtu_loadpurge() for the 6250
Message-ID: <20210126215519.5xycqxrdavtpa2vx@skbuf>
References: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
 <20210125150449.115032-3-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125150449.115032-3-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 04:04:49PM +0100, Rasmus Villemoes wrote:
> Apart from the mask used to get the high bits of the fid,
> mv88e6185_g1_vtu_loadpurge() and mv88e6250_g1_vtu_loadpurge() are
> identical. Since the entry->fid passed in should never exceed the
> number of databases, we can simply use the former as-is as replacement
> for the latter.
> 
> Suggested-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
