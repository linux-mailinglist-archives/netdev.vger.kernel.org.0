Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11E1DB5AB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgETNxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgETNxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:53:49 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D430C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 06:53:49 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j5so3268947wrq.2
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BxU0RbOHERDPAaEh9K1DdaEzRKgN2BpIjZ+4RuGp5w0=;
        b=xNIrMgWXi5At6b4pUzXwJuiu0ovjNmXESnnb7aTeg2/1PSTbMjDwUHOse0+9V79v/6
         2J4V7WVQoexK01HOgSaj4BhUU8Unrd9lsfrPCvTQ/bFlD0ws1Cez7i9MADoQl7pUt8jR
         5MYwdDMzNWCVVEy5jEDmI1Ds0UZUHpxCRnd9fcETuYgHMLML4G55VL2xb6F9KPMl5CCt
         rV08Ozx1fQYdkPChaMtsNl+8X+jY0SYVzvRmdv7fSNbqmhnPP4tLWvCAmr2oGDZi3ooE
         ZhHhX4pocHICFp9stOltf6n1hJld/ZW2898eHFR0A7NBkfve+s4q8MGJAOrJj6iJgBos
         bSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BxU0RbOHERDPAaEh9K1DdaEzRKgN2BpIjZ+4RuGp5w0=;
        b=oPk/q8hfHcoZj34c6D50LnomwckpowyG4XiKJsZEtW/IkYfY5Eyvs4npjE/EUfmzfv
         3cOy7glF7IxW9S7l6kFV6IgfxhQXgrEGZ3h2YLMyMtc83+pfU0eSEaeKIs9ZE7oeOtR8
         u0CHoCUYQpREnB2CBxPK1ZWDMABxov8c8OrUOH27Bz+L4+Cv9feSGUcjU4O1twMVhj6x
         vlCgci3TY6DhKdvYDaCzWjGUpypwrPaDsiP3PMl1bNImE4WOBFAfeRbBj5TSNdEIwxJ4
         nmRX9admzYxY/5jx73zhOToIHdZhBgMwVddRusvsUvxztl5knvu/OjNjqu5vgRRSyXql
         m23A==
X-Gm-Message-State: AOAM533KNIWVdH0G6RtG3fItxLfK0NMOweNgsIMQ6vyTkHg6BAfnybHE
        rUxdA/d2DTTLiq/uYLkPjxV7R5Ww9sI=
X-Google-Smtp-Source: ABdhPJzp1Cv0aJmUuGkxRoue8HweeWnRZC6ZFJAKdb6pAn2/RnkDMWlF4/7eqDrCFVUJqVOpz12Tjw==
X-Received: by 2002:a05:6000:10d:: with SMTP id o13mr2744184wrx.328.1589982828065;
        Wed, 20 May 2020 06:53:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v126sm3606787wma.9.2020.05.20.06.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 06:53:47 -0700 (PDT)
Date:   Wed, 20 May 2020 15:53:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: net: Add port split test
Message-ID: <20200520135346.GA2478@nanopsycho>
References: <20200519134032.1006765-1-idosch@idosch.org>
 <20200519134032.1006765-4-idosch@idosch.org>
 <20200519141541.GJ624248@lunn.ch>
 <20200519185642.GA1016583@splinter>
 <20200519193306.GB652285@lunn.ch>
 <20200520134340.GA1050786@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520134340.GA1050786@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 20, 2020 at 03:43:40PM CEST, idosch@idosch.org wrote:
>On Tue, May 19, 2020 at 09:33:06PM +0200, Andrew Lunn wrote:
>> > It's basically the number of lanes
>> 
>> Then why not call it lanes? It makes it clearer how this maps to the
>> hardware?
>
>I'm not against it. We discussed it and decided to go with width. Jiri /
>Danielle, are you OK with changing to lanes?

Sure, no problem.
