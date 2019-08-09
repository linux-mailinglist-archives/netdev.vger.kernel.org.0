Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD31880EF
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437246AbfHIRKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:10:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33256 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405964AbfHIRKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 13:10:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id v38so4106889qtb.0
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 10:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HYlMdQZHty7Wwn5aBEwnxMd2NQWL3qhElMNkZdxbKhc=;
        b=DixSJdO0PcZNe8/VlatDjJniiCf1jvJ/3ZILg0pMdueHUlHcDYMdyzSSF/rXDSfGHE
         lkj4JXar3aHBYxMxWkhlq3861EoUjm2oT2TTcd1kAvkFjwLLbFGQHYsD3PIHtdkuH1p7
         P4XLxiOa2hZNgeNSTfkoA+lenF6VzfCHOvGCEqCkimKL5I+JnpoA+x/tdb6rStpahrYi
         wAqiHjOsOxJ2cDMhUc/lJMF6+m9bttUyDSW7b1DrLwDmQNvOVekWC2jj8zXOKk9JCcHd
         fXe0Vj1qP5M+V99TWe28KhFCGgi9Uw1wu1LD47RZBojYCcSUo7CKhjBfciIyKKxsDBMN
         QlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HYlMdQZHty7Wwn5aBEwnxMd2NQWL3qhElMNkZdxbKhc=;
        b=FQE+M9BdCuraTNu+q0dxvlegOaYFVFJze07TPkdOQbp9hIGJUnzfshQQKhT5w/8tN5
         /m5hR/l9/yyXMhuMiGr94MQJMKKrWP1y2GqZT54PnIB6S8va6W2x9xeObZrr5n3fc+Y0
         GY3gP2arjloSkLevh7NHRbesE+uBhajjRFUfw1uXnsBDMMPvYyH/b1Pr6Qx7LxdgiDEv
         W0LvdTiXQafhynIHbFQNAURpGNYpi1/oP7CbR6gQg9+2YbcP3BWxM9iBtDGzmATvfuii
         vdQdiZfDScLnUuEt1VPk4tNqQN4t4oKIymR0F9MD/InaHLemc2b1hRUohOv6F1L5Le5a
         ltwQ==
X-Gm-Message-State: APjAAAUvrqeStRoFJW3Xd6xVJxSlmay92tVN8x4SuNOWh6sVC/UXEo0M
        PNPG0c+7+1Vc2R0ZVA5g+RRxKA==
X-Google-Smtp-Source: APXvYqwiEroAY5rluPLihZqReA/ZG8p6YPG6l0KQaPpFiMB03Wk5N9Un+BKo5cSe/LUPBK1cXhQGYg==
X-Received: by 2002:aed:2667:: with SMTP id z94mr9985343qtc.343.1565370618760;
        Fri, 09 Aug 2019 10:10:18 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w62sm39380548qkd.30.2019.08.09.10.10.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 10:10:18 -0700 (PDT)
Date:   Fri, 9 Aug 2019 10:10:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edwin Peer <edwin.peer@netronome.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com
Subject: Re: [PATCH v2 08/17] nfp: no need to check return value of
 debugfs_create functions
Message-ID: <20190809101015.62bca698@cakuba.netronome.com>
In-Reply-To: <20190809123108.27065-9-gregkh@linuxfoundation.org>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
        <20190809123108.27065-9-gregkh@linuxfoundation.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Aug 2019 14:30:59 +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Edwin Peer <edwin.peer@netronome.com>
> Cc: Yangtao Li <tiny.windzz@gmail.com>
> Cc: Simon Horman <simon.horman@netronome.com>
> Cc: oss-drivers@netronome.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Still

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

:) Thanks!
