Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7235FDEA
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfGDUu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:50:29 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:42773 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfGDUu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:50:28 -0400
Received: by mail-pg1-f177.google.com with SMTP id t132so3305321pgb.9
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eEcy08Zp7KEFBsbgSzc4fb0ylI4OUIysg2cFz91bD9k=;
        b=Wn2xf1mGCnS6A/uZcov3P6qA24KK5IrzzAuGgAX+725cUsmNE0UjgXBBKSgbdpSCGo
         8dQwyJ0gP2xy6PTQzakJN/Igr4GTz2h+VZMID8eZiqioWIypAoR2Zz3SX4XLJqt8yGEO
         lEf4l/gYc1ERcOqvIxSNbSGvNqpu9gi75mvDm80JL5kN8Jt8BOCPgBgDMt4zeTRFRtmt
         MdBFEOY/F/FrXempEpgNi41Q3w1LDyV/sKeXin0PaIlQ4KuYkLGolMUeTbt6D+2wSyMZ
         KrQQkTLWIWsvdcyjZ5F62gbS7IL4tYnWkMeW4jHYVo9XWTfyHXKn/e3ZY07X3jNQ+5qU
         XlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eEcy08Zp7KEFBsbgSzc4fb0ylI4OUIysg2cFz91bD9k=;
        b=TWsP4daEL+/RoJ/vbSkfm9wXDiF9TPv2CO8gl3sW8Ggne7GbHZQQYJsLzHUE7furiN
         Cjj6IEDmXuYp7yZZYwIryV/juafwHqhxePCfMKHqSqYVXMxTe10ugPPU9L0xOKksaoG3
         UAa7295/iFIXKWqjmykO888YhQdhZhQ40ExgIdO7FayDuz0JPm5jCy8q+4k24vS2eytR
         8b3gqC5aaGZRkFDka+6He8a3NNC9hdNGpQKeW1IfhmDN3q81JkECILNkvEE2AZNmUbeZ
         Qxor11sLYYpk2x2lIgoV981Em5XHvIzwWWo1w22doXiKt1JlDvhtPqUSmMplgeQ5oEeI
         YxXg==
X-Gm-Message-State: APjAAAXsIhODDy88IGfnSliFO7+ec2pCKY3c2h8CeYBUoMsockdEYqT/
        ENaOuI3gz7sL4fkojt3LhFoobA==
X-Google-Smtp-Source: APXvYqxooMGomrLIkxNRrq9hkMtQAoy3Fs+nG6T44UmGpF7MS00HKIl/FCtJCQ1NW9sWCgr5aXICdQ==
X-Received: by 2002:a17:90a:7d04:: with SMTP id g4mr1540495pjl.41.1562273428040;
        Thu, 04 Jul 2019 13:50:28 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id n19sm7239826pfa.11.2019.07.04.13.50.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 13:50:27 -0700 (PDT)
Date:   Thu, 4 Jul 2019 13:50:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 05/14] net/mlx5: Add crypto library to support
 create/destroy encryption key
Message-ID: <20190704135025.4220ebdd@cakuba.netronome.com>
In-Reply-To: <20190704181235.8966-6-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
        <20190704181235.8966-6-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 18:15:55 +0000, Saeed Mahameed wrote:
> +	/* avoid leaking key on the stack */
> +	memset(in, 0, sizeof(in));

memzero_explicit() ?
