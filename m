Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833A524713B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390912AbgHQSX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390639AbgHQSXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 14:23:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0CEC061343;
        Mon, 17 Aug 2020 11:23:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id i10so2959575pgk.1;
        Mon, 17 Aug 2020 11:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ArklK3xLKYl0ozsXmN0TZa3LItt/yQRXbXI18xhBRkY=;
        b=KYkok7Lc9wMrqXITauWU1t0NEZU5oDWsKvsZmdrPTIMV4tnbFYq1MLfK8etF6o8j42
         Us8Pze5iaq7q0QFQvKYC5CG749siGYLQpC7w8Lsp8EgxZnN1cMttsNsfxhLLGylxJqRO
         h5Xt4MLf/YOjhDZ/3WBeG01Sr8lc0ag9hxEeUDBKz4dSKLps9yXmTROd2NBnKvCQLpN/
         +gLdr5dJ5z6Lo0ebICaXsd+xuP1rnuIz9OMcGT2eWDNMiuBjqcOg7kF7zW6Rpja5WgE1
         hhq0C1sduCMvWaD6BSppNfXY+L7G489qJaw465Qo7QQLjcSedkgvZ6kO3+g1EZqHBvHY
         Vupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ArklK3xLKYl0ozsXmN0TZa3LItt/yQRXbXI18xhBRkY=;
        b=jQUVFGHv9EugzmLLuVc1mDZcqH9itF5tocUvgplZHwxqD4NndrbGaC0eG4eYHAv8nP
         9gAmzFTfC8e+Q+KWZd5Cgdw9AHxJxILui1YNT4tLmrnqdjghYHmLSHyICCvfv7QzpN5Q
         OXbJAMCQOb+31avFAxxVeIaKinq+BNtYHY+zC56QMfdovf7mF7ZVoJFFf53v3mZ1YcRu
         fQ8BO2VGhhM2hJU7T8rZ9M+VAHXOFovKOnorf+++7K2GWJ+1yZiAJSZN4o0ypCiAZ8I7
         fQD+ShpWFEkB6pLSsvtXAwDxwITokxIvIHqkMjRrE9S0k0XFD6EG+X36Gv3EzUQfJdMC
         A9aA==
X-Gm-Message-State: AOAM531ZXFX0rTRsRH0FWNVWayEaWKrHI14ypa4n+uEVFjRGLtaCI515
        NSin0yVfYq/5MAHj3cI4pBeFl14hm6Y=
X-Google-Smtp-Source: ABdhPJzs5PpPwLX4Lms8EiHz/B3vX66hHPiWWrc1sSTOfZ+Rq2Tb8XiLZLpsLuXic1SOW2APxkAbtA==
X-Received: by 2002:a63:dc11:: with SMTP id s17mr10602970pgg.254.1597688599235;
        Mon, 17 Aug 2020 11:23:19 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id c10sm20543527pfc.62.2020.08.17.11.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 11:23:18 -0700 (PDT)
Date:   Mon, 17 Aug 2020 11:23:16 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ptp: ptp_clockmatrix: use i2c_master_send for i2c
 write
Message-ID: <20200817182316.GB4286@hoboy>
References: <1597678655-842-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597678655-842-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 11:37:35AM -0400, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> The old code for i2c write would break on some controllers, which fails
> at handling Repeated Start Condition. So we will just use i2c_master_send
> to handle write in one transanction.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
