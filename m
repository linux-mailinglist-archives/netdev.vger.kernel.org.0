Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E5BAC11
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbfIVW6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:58:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33329 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbfIVW6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:58:46 -0400
Received: by mail-io1-f66.google.com with SMTP id z19so6870990ior.0
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 15:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Z8/R/gI8KI5zbh5vxqzCWAaMRrKgBWClgbTxFf6x+Zk=;
        b=aLiRfiVnNw/WiEGse7tvKtc0t9S3tInA979TgjQz8e0lTfzcc/C71aLkMNsqwAnb9R
         HekEnuYzR5cJ82TZdh9j9hs73BHf0XkVnPvJK1xG8vQyTxC6NeOVtciTR/FJ/j84mOhb
         CMallyhFbYuAUTNT260fEAHqJ6AmRmPVMw4flrdUiaPnwCUQvP2pMD5s8TvBk1l/0fRr
         PA/nyOO/0ihYoCn7HOwSCAxUEQXAOnYhPgqx7qTogJm0yTBMi6xIpIcLkayVJU7hcVVg
         SsRG8+l++PH5I6tM53wK53q4Af2uVh3k+dvzUTwH6bQob1dNBW5OsB8fCRgv4jiYGKqK
         Zexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Z8/R/gI8KI5zbh5vxqzCWAaMRrKgBWClgbTxFf6x+Zk=;
        b=rn3SPYWzGXFhG8Hdm0lvTDuqk67llQyznGP53Jbx2u4V8N8S+7leGPjoqXIxZUvZCc
         j2TrNnKgh7on4XrLxxOQJ7xqXsQ7V+tEPCqBJGmRMti3WGSYDpXK5gP+waxQVQCYzf3o
         dEchbUB05zfGLxsEJWPo0Ry/kQxes9iM9JISr71Vre9VnyoI0PtIOBFJe6AWKyqNX78w
         G+LCWZgp3jxYHo14rfAvcuuQE5RXRHiiOy4WB7hg+dvvaLHp9BqBARhEg/JBsjhD0Ywe
         2/1swRrdogWWEz1OOmuyiYkux+I0KYQWf0O6bA9EQ/pnh1J73Ql2eah9tQehYAQ1bqz3
         QVBg==
X-Gm-Message-State: APjAAAWrjcpthxmEHZCEbGyDXUfjvIBG3EwZdBez7qu8HJX3Wfqt0Upd
        g5VIXgOgG5MCotxJUAuY+VxAoL+K4fA=
X-Google-Smtp-Source: APXvYqyzJTfzMSAXalF5Vnun8Ri/XV1Z497on/GX+aWeCOZ27EhKjMjfCtUh+egmnglqPuM+oJYAoQ==
X-Received: by 2002:a65:4286:: with SMTP id j6mr26618333pgp.218.1569187079176;
        Sun, 22 Sep 2019 14:17:59 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h15sm9571957pgn.76.2019.09.22.14.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 14:17:59 -0700 (PDT)
Date:   Sun, 22 Sep 2019 14:17:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] ionic: Fix an error code in ionic_lif_alloc()
Message-ID: <20190922141756.2646371c@cakuba.netronome.com>
In-Reply-To: <20190921055926.GA18726@mwanda>
References: <20190921055926.GA18726@mwanda>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 08:59:26 +0300, Dan Carpenter wrote:
> We need to set the error code on this path.  Otherwise it probably
> results in a NULL dereference down the line.
> 
> Fixes: aa3198819bea ("ionic: Add RSS support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thank you!
