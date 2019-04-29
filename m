Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B074EAE4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfD2T3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:29:19 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44346 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbfD2T3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 15:29:19 -0400
Received: by mail-pf1-f195.google.com with SMTP id y13so5807102pfm.11
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=z0SbUdCmljVej5WrouVvowNPCwLdyoY/7i4BqzA7D8w=;
        b=TeDqsy9XMhyATE2qQx9WlzpgVVq0T7CVOONq967YT3CvH0mEmtolvjGE9kJgU/cgYU
         775P7gEHPzjxaK64n/BHIPsCEJ8FXrjBqGL2pORt1p1ksc2ycBk/GwyBhFi2ZYhlpMnh
         i4ZBzRRY0nCe7ZzT3UUi1Kv9ORMZDABigBBC0H0FscGeqNWREoXs9UC8ZR+bT0gwdOI2
         x7STEigDlhJOH9LelrVMkVs3Eg+LPIB+J0vR8Kl2xU7xAwiRDUCiqjk0AIbkJTgdL2DK
         ykW0Mu9p/0VL9Rjj28erwH0qI2qERVwEtc6GxwlpWeic9CAO/etUy8h532Td7nbDZ5GV
         FLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=z0SbUdCmljVej5WrouVvowNPCwLdyoY/7i4BqzA7D8w=;
        b=ChiZf/GXC0ajP2qD/EhOHL+NGxQTkF147Jv9ItD8Rnsevn0Jhe7wY3CMGV6r8ESR45
         LlcmnrRhBkWAG42wQ0saWSFgkXm3fNRzNSXZnXUT4w7e1hWJnZl/Iij9fh8xfzUwLI3W
         PKfSWrtBnzJ3xAaCjkyPbsLteTPF0Ye8gAE6uX5EQ31cVaAnZu1xKhifAF0e7Addbp+v
         bkT5dUBf7TdEXOXMqXaoQFMRhtjxpvM7jgRm3+q2KcsJsKLsAUX/0y5Hlp94hvdrT7BS
         gj3HQAgHQ73VSNwbkTPUu2iFrp2sfMdVnIF+33auJfb2waHnHkHtS7Vp7SthXzW2HiSk
         UM9A==
X-Gm-Message-State: APjAAAUju/JzP6FfUak2ZQ3K6k42lB1RA8bFQqGcAMGOJoKtOgZxvQwf
        FxkWlAO6jKPdmdUE92UzP+x/Ig==
X-Google-Smtp-Source: APXvYqyJ/3gFDTs4WKhkkP16+/x0+Z8V973+ij74rc3U2GEZqUSyAhQFGBn+SQVCvvPBz9VMRhFvxA==
X-Received: by 2002:a62:864a:: with SMTP id x71mr3258049pfd.228.1556566158309;
        Mon, 29 Apr 2019 12:29:18 -0700 (PDT)
Received: from cakuba ([2607:fb90:cd6:ddfd:e8f2:447f:e2a6:2cf0])
        by smtp.gmail.com with ESMTPSA id 15sm5496317pfy.88.2019.04.29.12.29.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 12:29:17 -0700 (PDT)
Date:   Mon, 29 Apr 2019 12:29:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Change devlink health locking
 mechanism
Message-ID: <20190429122910.668028b1@cakuba>
In-Reply-To: <1556530905-9908-1-git-send-email-moshe@mellanox.com>
References: <1556530905-9908-1-git-send-email-moshe@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 12:41:45 +0300, Moshe Shemesh wrote:
> The devlink health reporters create/destroy and user commands currently
> use the devlink->lock as a locking mechanism. Different reporters have
> different rules in the driver and are being created/destroyed during
> different stages of driver load/unload/running. So during execution of a
> reporter recover the flow can go through another reporter's destroy and
> create. Such flow leads to deadlock trying to lock a mutex already
> held.
> 
> With the new locking mechanism the different reporters share mutex lock
> only to protect access to shared reporters list.
> Added refcount per reporter, to protect the reporters from destroy while
> being used.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
