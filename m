Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491EA29F736
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJ2Vzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2Vzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 17:55:38 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD45C0613CF;
        Thu, 29 Oct 2020 14:55:37 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id x20so3328004qkn.1;
        Thu, 29 Oct 2020 14:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hDXbXO8XOb1/R1kSoSdED0aIjWHfpfYjTnRGTgwxrWY=;
        b=Ohdmu5aX+UhPupFYBedi9Xh6FSGm0G1GenZAeP6UA+x4UC4TmqsqVJ3PmO3J3a2BeL
         2ZZ97sDHeZysUQYTk/FskQarCqYbMtSOa2ekBQy9YWuRrxtlaunBTdo3Xtr6IyDFh/+i
         Qe1JrPkf072FvtL9VgxSixicxgv2Zz0hr3F5lqLumezRzbm7iWEqb9D0MSAAcKohIqD7
         0CpG0/chbyKzPawwenddPD3QYUJsIIXcA8ocOG6Csx8HNpuXY9uBRUg8rTqibmd46m+r
         SSMMCDIty82QD4nGT9JLnxY01ZSvuDpcgy9+X6xKd5yfL/y3oxCOOHb5RYidIVZsIYJi
         CwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hDXbXO8XOb1/R1kSoSdED0aIjWHfpfYjTnRGTgwxrWY=;
        b=lKzbntJAGJ1H+Pes8FBdGKm84cZbeEMy2nnSIo+M+R8XmzWUdRB7jDHDRz4R2Z5IK4
         lyfTQok+zGyEJntgu2LLgwAaF0OOnYUbM1e774ZTeSOchTCopmtfOXcwHpw23KzDLghr
         zgtsBB6CHh5SlfrOnEHU9lIbra22g0amSXyjwVbnNn20kcpkztAafgu74ccL2IeoOOIu
         IlerjCql6q3kihjwB/sbBLbu+kWhRnO5DV5Zcg9l7IcYh0U2hBvKd4UkwI3VENsClr1d
         MDxax2KrgYmv2wWfQ2mB7zT5rkn+uUMAoaqNmzpLjus/qfWGSZvPArFrLCCh6G0vWAxn
         XOqA==
X-Gm-Message-State: AOAM531QFxtIX27Rrp68z9o1P8rriGbHFBKgqDtFZxHJdX1a3OqipWft
        V8Z7KVSOKzMVbbnJpDrbBcc=
X-Google-Smtp-Source: ABdhPJyOlFKOWKg66TJi4u3tmpvrbSWBzEBWuYHHDyaPJZ7h3f+WjfAJFos9bH8GNri+NrFYyRlQ3Q==
X-Received: by 2002:a37:a34a:: with SMTP id m71mr5902772qke.81.1604008536991;
        Thu, 29 Oct 2020 14:55:36 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.74])
        by smtp.gmail.com with ESMTPSA id t8sm1786432qtb.97.2020.10.29.14.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 14:55:36 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7C7F1C0DAB; Thu, 29 Oct 2020 18:55:33 -0300 (-03)
Date:   Thu, 29 Oct 2020 18:55:33 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv5 net-next 00/16] sctp: Implement RFC6951: UDP
 Encapsulation of SCTP
Message-ID: <20201029215533.GL3837@localhost.localdomain>
References: <cover.1603955040.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 03:04:54PM +0800, Xin Long wrote:
...
> Patches:
> 
>    This patchset is using the udp4/6 tunnel APIs to implement the UDP
>    Encapsulation of SCTP with not much change in SCTP protocol stack
>    and with all current SCTP features keeped in Linux Kernel.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Xin!
