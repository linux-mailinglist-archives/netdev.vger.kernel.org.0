Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932F8D1FC9
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfJJEuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:50:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40059 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJEuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:50:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so3068656pfb.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/mMDQ2lLgWo/y3UcKXP6zSndhMvDtLkfESaBpKV7kH4=;
        b=G47WyY0Ewr6HKq6sRlmVN07P0MIOanzK8G4fwQ5fFpgu13+hu6N2Ydh0BWJaFAM4Ga
         RGkK6FMub9jTIBQB9FnULqFmw9RmoAi/l+1iCYKCwIQ8OI2PvkLipaUY0qGOlIMmjnnU
         f0A8ZGyFL+kZHvTeGQJrmyUK84E4VTPAeCOtunGhjYdx2No7gqo5J2lTmjEy3xt3p6o9
         SYQp2eVY2k4vpJtlOR99UYzzey3M214U+1UYHP+KCqUxH5okPsk2bqSkQh7+cqkUiuyA
         ur/ozfDol8cdzXZYsvI1Y3WOVxmp1Q7183Odt3Fr2vOM4h8pxLl40Zt05QE1WyuCqT3H
         1a1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/mMDQ2lLgWo/y3UcKXP6zSndhMvDtLkfESaBpKV7kH4=;
        b=Mvl4iUxyYBiapzzTQxiwhE5q3UrXV7X8tiSAt1PT9tHAc0seW6FdMwU/pCFNBr7XUc
         WuJcbjDXj8Ewhw6kUvcWE+NhSEd86feNduJ0dfwbVq+7h6rVip/Jzm2R2wWAdpEqpsBl
         TrBsWAnd2Vi6H6UlwXtBrQUf0CuutiOwxrNRaMtBtXZrQZNYq6SZPkAZRmbKCk9OUnVW
         Zn4juwKe/BM23/hKW9D50KIXmjUV4ZLG2/aDWuhb50Jd7t8UTn002OUlJMeyFi6cXtzw
         TdusQyvyHGTfPkjCB6NiqW/KihVItfWLBeg49MNPg2cmsBMY66FLVZ9iDcDunTtOC7SO
         4nQg==
X-Gm-Message-State: APjAAAUGz7FJGMAP2C293EsCjud9goxvqG+vlYjuKY2pdazRhwk0wMxx
        GzkFH68kEMqTp7J7wZz/l1+YD8euiPs=
X-Google-Smtp-Source: APXvYqzoLC0fdqtMPs0MqTpUbXMHZvRzDmUNo/Ji8coC8Ngc4HGSYP4PI2mfdJelrAQnoPJIuz63pw==
X-Received: by 2002:a17:90a:730a:: with SMTP id m10mr8671472pjk.80.1570683006740;
        Wed, 09 Oct 2019 21:50:06 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id n3sm4177621pff.102.2019.10.09.21.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:50:06 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:49:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] net: add {READ|WRITE}_ONCE() annotations on
 ->rskq_accept_head
Message-ID: <20191009214952.756b1caf@cakuba.netronome.com>
In-Reply-To: <20191009215120.31264-1-edumazet@google.com>
References: <20191009215120.31264-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 14:51:20 -0700, Eric Dumazet wrote:
> reqsk_queue_empty() is called from inet_csk_listen_poll() while
> other cpus might write ->rskq_accept_head value.
> 
> Use {READ|WRITE}_ONCE() to avoid compiler tricks
> and potential KCSAN splats.
> 
> Fixes: fff1f3001cc5 ("tcp: add a spinlock to protect struct request_sock_queue")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
