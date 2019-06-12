Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB72842E53
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfFLSHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:07:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43711 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfFLSHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:07:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id z24so6259682qtj.10;
        Wed, 12 Jun 2019 11:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0ZPWnHX0VTag9WJi8uSaT9RLyIeLnknmXAJOObQsps8=;
        b=L2ay4bQU4ccfUM822yBWkvGQ/4iLDhV2l3LGYuNmTM28WpQ57+hfMt5ir0LyLJ8UzW
         QcMkzWnxlaTdEuVAlWOyEhi8rdrf24YSPa8wIN6+Pom8xC04ilhf6BZZ3BKv9GPttgXU
         9ydso2ewmlZQhwBS2Qc1L5OCDiHZ3L4W1zmoJBCcXANT+12MhYw2rVzhuMdmcH6/hr22
         qKDqDMoGd/Qq2SCjCHrhbyHccBsJhRM78PHF5QsSMONFSFu8wSNWvjg+6i8S8PpnxBW9
         xpSMauv2cuawPTFbGB4iHv7HKyCzJ6s0tDepG5dzvm2u3UbwQeMjHhidic405OtgbPcw
         xkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ZPWnHX0VTag9WJi8uSaT9RLyIeLnknmXAJOObQsps8=;
        b=Gd1MCvqnOPpcAsFTfoiyqNHzx1xVegVL5Lu7nhCrpocQTi5KDx5vejdhNlPvtYIwhI
         qnQNG3PbvEReyNRHMQJp7pSShimrARQc/7uOdzeAJuata4H6ee9jwTpr9E8lz46ZiWSU
         0eHJnwZjvvjbdGSVUo35/jQPOLuvtcdMaVE/iCkGXUFZCnXQWwaJcmkPmp101Yb+CKPX
         m6KEWOqNNiWXrsF3souOkuiPlCFbUV9hMVyhEnt8U31uZ2zZn/eswWj9QtOD0GRM1aqj
         YIYsQaLUbWG7AK8SJlsHQHlPMNFR11GHX+CKKsHXjuYxEVvaVhN74y4JxgGVYhy4u2/F
         iWfA==
X-Gm-Message-State: APjAAAXYB7NbNA1+olaaH8K9ChSbFL2U2N3dhqQ41meXJHD0skbnqpc9
        dJO3TFuhcJmVeWsOuw1vt0k=
X-Google-Smtp-Source: APXvYqxPirnU1dw39R86hT+f+0v5X/T/ld0NFS9gW9qw7JjOklac5lTIioyQbgqRme+ngkXZ/kB8bw==
X-Received: by 2002:ac8:4413:: with SMTP id j19mr3542135qtn.281.1560362838276;
        Wed, 12 Jun 2019 11:07:18 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:7487:3cda:3612:d867:343f])
        by smtp.gmail.com with ESMTPSA id e8sm146351qkn.95.2019.06.12.11.07.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 11:07:17 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 34B8FC1BD5; Wed, 12 Jun 2019 15:07:15 -0300 (-03)
Date:   Wed, 12 Jun 2019 15:07:15 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net] sctp: Free cookie before we memdup a new one
Message-ID: <20190612180715.GC3500@localhost.localdomain>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
 <20190612003814.7219-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612003814.7219-1-nhorman@tuxdriver.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 08:38:14PM -0400, Neil Horman wrote:
> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> ---

This marker can't be here, as it causes git to loose everything below.

> Change notes
> v1->v2
> update subsystem tag in subject (davem)
> repeat kfree check for peer_random and peer_hmacs (xin)
> 
> v2->v3
> net->sctp
> also free peer_chunks
> 
> v3->v4
> fix subject tags
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> CC: Xin Long <lucien.xin@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org

Anyhow, LGTM and reproducer didn't give any hits in 2 runs of 50mins.
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
