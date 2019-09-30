Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB79C1BBE
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfI3GuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:50:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34944 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729357AbfI3GuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 02:50:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so9832727wrt.2
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 23:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LNxU/JjJWcudNtoGFpm4wT3dNx0+kLn5lS7sS5pAz4c=;
        b=rQmULUHg2crm/P7Jin4pLmi+qGnDUUPcg198IopK2CSlACdS4c6wvwGFX4ivXUGjwB
         DXn6+Ok3i0FY/EShpxit6XWbqFuKdgEIrg76F/AR+YOlz4t5CZJ/3WhxgmttvPDCsqEm
         xTN2pGQSuVVcRZaAettJmdZwDT3lKhwkiymwLntBUko9T94d2nKcfee80TBKENdaNc9m
         LL46RHNVfiCh9HSdj8XQDAl2r8LRI5qLkaATQTpmqntup3Xq0ArOGOV/GAvcLEk+X45+
         J5/tYgpqRtmuZN+BALDnXUdNcTJPCzQ+K8jULsHm7y1ZDPKq9RUYL51TXcC8Tg9p9LEa
         sFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LNxU/JjJWcudNtoGFpm4wT3dNx0+kLn5lS7sS5pAz4c=;
        b=HEQv/si6uutDcMVJPmJbDPCrYkRZD++WhDZ/9kYKoEH5u9tQxEOFi4azRvMWk31iIH
         Rx1cJq+VJZB54dS1Gw1m4EoWH/LSZfzHbzA+ltPOK7zZvFB9jtMKck/JH5u39kp7kFo5
         AuS6L/GgDTPz+p7eESGXU8UTjkGc3bOePbzVO6VnPgevBBaR2J3WdYy5RmrEUge6YR/Y
         HocYHxm6AK3+kCGSxnGpvMsFcBBAPzPJVaeMkNISPCGb/kcR6vGjDRBv4shnv7ep8TjB
         GSM/A7kbNTr86ZoeEI4Jy+QBWAE3Gf1apKxrTLTTiXTCkFHAE4+bpJFZ9fwzicNucnOu
         09Eg==
X-Gm-Message-State: APjAAAVHaujx9jZvufDlQ1Xxp1qWu3jLURIEs/BG//7k6ZjlYYq9G3NK
        2NvFUUqi5oU9xjp8RaaiBwpOKMw2xAVejQ==
X-Google-Smtp-Source: APXvYqwlMTdGIxi/22tgTWDG9X8T0tyb+miwE6yOD9cq6koLk/DLLg2yj20WknLSokeRs4gu300vOw==
X-Received: by 2002:adf:f801:: with SMTP id s1mr12262905wrp.293.1569826211492;
        Sun, 29 Sep 2019 23:50:11 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id o22sm32429023wra.96.2019.09.29.23.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 23:50:10 -0700 (PDT)
Date:   Mon, 30 Sep 2019 08:50:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net] devlink: Fix error handling in param and info_get
 dumpit cb
Message-ID: <20190930065010.GA2211@nanopsycho>
References: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 30, 2019 at 08:22:21AM CEST, vasundhara-v.volam@broadcom.com wrote:
>If any of the param or info_get op returns error, dumpit cb is
>skipping to dump remaining params or info_get ops for all the
>drivers.
>
>Fix to not return if any of the param/info_get op returns error
>as not supported and continue to dump remaining information.
>
>v2: Modify the patch to return error, except for params/info_get
>op that return -EOPNOTSUPP as suggested by Andrew Lunn. Also, modify
>commit message to reflect the same.
>
>Cc: Andrew Lunn <andrew@lunn.ch>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Michael Chan <michael.chan@broadcom.com>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
