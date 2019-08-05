Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9154582546
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfHETFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 15:05:05 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34397 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHETFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 15:05:05 -0400
Received: by mail-qk1-f193.google.com with SMTP id t8so60950891qkt.1
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cLqvyspbp7OWOUoq3ZFYv4mC87V5IQVjr1iTTqcs6mQ=;
        b=aTlk8gES6npsuwmghCx2Na80kCnL2squsqK9whr55L5dlxjRnrBfkMSFXyUw80XYnB
         CvO7XyDZgN3ChS0v/yS8AzsK6TFuYm5P7pQvGbkOnjn32i0lmJnxGcxj4upGDk9pA9PE
         072EfxuQW4nHDKrYj89qLK+CYdhY/7Hv05lnZjSKo4UNx7CZa3X5M3NVoRqnvCG0Taud
         gemdFfZ7Br/MYbsANmb5V4MSJYehfhsMPq1BMAs7qvc/gNAHEGaRGzO3TPFp37W6UMLw
         SZjz1dW+Mp9X9SC5s2H4MhytPyzEvnuiuL1JWpBgMdJ6MBy/AXJcWG7uF1eYcrA1NAPe
         WyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cLqvyspbp7OWOUoq3ZFYv4mC87V5IQVjr1iTTqcs6mQ=;
        b=Rs3brkYui/5p9JAHZ3aiQO+iE3eRfeavouFXcUVbuxux+u5NUq5HRwAsINGo3kGx9o
         +FBbyAdt/+Wa2CExOy2AOrm/8ZfKXtFg7zeRV5pb5MmY8eKqZlzXlBKMXoetUPWGVWjw
         nCehEsCwWazSYAen5hg+V4YKhPE8pWEwETc/N1DR/61bf4KC7iOGCUPaPTiJF+mVQikz
         N9MX5FdomNKoI76+DR0ZHH580JytWwbDIYTGxyL5GK41XbZdd5hso7GHC9UcwtbjeOch
         olmbnrZ1cHaBu1kCc0mbqc564x35rFUl89Min6YHsIO7KepW5TCBgJL4UhXrS0rFT1Ui
         cCwg==
X-Gm-Message-State: APjAAAUFjZIQ1RwgOuYn2PjlCwKTmzaaT4zEwFVz9acsJWlOfys7EAz9
        Vn1IJL1MXCfgdK8ubiru6tsmAg==
X-Google-Smtp-Source: APXvYqwRKui4nbKI13V2UXz+YNMPur0gm6dZWDgkzt5mfTEvpQPnpLXr+fcIXum3h47MYsPK8eV0FA==
X-Received: by 2002:a05:620a:13ec:: with SMTP id h12mr104099406qkl.266.1565031904006;
        Mon, 05 Aug 2019 12:05:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y4sm34415124qti.84.2019.08.05.12.05.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 12:05:03 -0700 (PDT)
Date:   Mon, 5 Aug 2019 12:04:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190805120439.40d70cee@cakuba.netronome.com>
In-Reply-To: <20190803070854.zb3nvwj4ubx2mzy6@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
        <20190801172014.314a9d01@cakuba.netronome.com>
        <20190802110023.udfcxowe3vmihduq@salvia>
        <20190802134738.328691b4@cakuba.netronome.com>
        <20190802220409.klwdkcvjgegz6hj2@salvia>
        <20190802152549.357784a7@cakuba.netronome.com>
        <20190803070854.zb3nvwj4ubx2mzy6@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Aug 2019 09:08:54 +0200, Pablo Neira Ayuso wrote:
> The idea is that every subsystem (ethtool, tc, nf) sets up/binds its
> own flow_block object. And each flow_block object has its own priority
> range space. So whatever priority the user specifies only applies to
> the specific subsystem.

Right, okay so that part is pretty obvious but thanks for spelling it
out. 

Are you also agreeing that priorities of blocks, not rules within 
a block are dictated by the order of processing within the kernel?
IOW TC blocks are _always_ before nft blocks?

> Drivers still need to be updated to support for more than one
> flow_block/subsystem binding at this stage though.
