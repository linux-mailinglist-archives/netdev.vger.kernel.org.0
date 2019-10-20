Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697E0DDF14
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfJTPMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 11:12:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39574 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfJTPMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 11:12:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so11043025wrj.6;
        Sun, 20 Oct 2019 08:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sEDPpuabV3/B35Mj82XikN4wgjEHBJYpPuqoickG7cM=;
        b=qe7JRxXbGbvrO0+E0KKpDJTcZaU1q5xXn2OMubvAwzdz6DXYAFokTgupTFoolqGyjg
         A6KRGTXAyoj4xsKyZ9hk7cwVP0lmWjMLgtqa3oPhH1GCriZSTXht8bdFzzAwN3Thtm6a
         zJcjZc6VXK0ADr3Rn6HZ9t5VNQ0r2K0dcDHQbGfz97/1IJ3l1p1NVLHdJZOYCwSUsMO9
         0N75im9QJWuGekHRmtuGXTXpSLgODycgvCE+yH8zM6slPokq7DmscgUhyKkzqbZ+O6t9
         YMTNlWiGr/iC0i5HVn+9IGiN1TYHeViLEwNLYWCgUc3AIES6tKXttTV4dmkw4q4c98CC
         e68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sEDPpuabV3/B35Mj82XikN4wgjEHBJYpPuqoickG7cM=;
        b=gcZRQA9MFWYx75XO1oxDxzg0ZIkN3jqN+c6ybX72Gu9G4LvOMhacAQVfY4hj1n+eAD
         6mBQGHQMdzeuTZfje8nBhCKnKWdJy1onYBq0vEIh5Ha1Trf2MG/plwZTm+/ehrey3qut
         cM+7tcZ+9XPjmIKZxsdr6yisVHWnpbrGBquS5Cacowcgmm3cPPKvMve1sjREocvxUVpH
         MNzFkI3DFqyDVUV3+Esz7bRv01R43dKxoNSjYbEx0QDmK2V0Zn2Vx7CXWNQx1L6NBk1V
         fMqS9z1XxxYiCkyLW4rgM57GyOOjTWEab3ThVHKvUfBX4e73d+0PyseY2fVyMHGP8SUh
         oUIg==
X-Gm-Message-State: APjAAAUzfJ7pWLhe5c44gB1PPVTlqMz0JUPQ1+V1YPeMDFOo2qr6Mm6l
        dHcc1htzSXHjEuP690BhRiC3HVLNE8k4ng==
X-Google-Smtp-Source: APXvYqw0jfXTUHK8SC+t6VvHbj+B+5ZX/+DPYODZPb1bq/b1S92Q1hjT09/etSBReCQR1wHjlCNhTg==
X-Received: by 2002:a05:6000:12cd:: with SMTP id l13mr15862953wrx.181.1571584326730;
        Sun, 20 Oct 2019 08:12:06 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id e12sm6367204wrs.49.2019.10.20.08.12.05
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 20 Oct 2019 08:12:06 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, davem@davemloft.net,
        torvalds@linux-foundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
Date:   Sun, 20 Oct 2019 17:12:00 +0200
Message-Id: <1571584320-29816-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <87lfuuln5n.fsf@tynnyri.adurom.net>
References: <87lfuuln5n.fsf@tynnyri.adurom.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -11 is -EAGAIN which would mean that the HTC credits have run out some
>  reason for the WMI command:
> 
> if (ep->tx_credits < credits) {
>         ath10k_dbg(ar, ATH10K_DBG_HTC,
>                 "htc insufficient credits ep %d required %d available %d\n",
>                 eid, credits, ep->tx_credits);
>         spin_unlock_bh(&htc->tx_lock);
>         ret = -EAGAIN;
>         goto err_pull;
> }
> 
> Credits can run out, for example, if there's a lot of WMI command/event
> activity and are not returned during the 3s wait, firmware crashed or
> problems with the PCI bus.

Hi

Can this occur if the target memory is not properly allocated?
