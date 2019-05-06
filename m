Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792CD156A3
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 01:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfEFXwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 19:52:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45458 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfEFXwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 19:52:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id t1so11684qtc.12
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rVEQpX0LEPkhHrLcC+cD5UnBVicvNYfVXqJsdxneVAM=;
        b=gvgtL/4yozi7nrqcDqsmD7QklcVIGRMH6BOnBodbHUOCI1yhBMydkKutDm/dH0Tnsu
         48ajDzlplyIVzp0hLyFR9DheyiRT3BU8UZ4egoGStiT+ipvnCsHXFHL3pXzT8V1PWQcX
         xz4TkHMQeDb7DRqX+Je+pEfvdk0t8PxMsA96ln94s5xaqocrA6hA97teo98VtkfoRPQc
         EGDEmtwIi1+W4Jpd+vieFkbxZzS9ZqfvuXQOObX/1rxqxFTJX8U4J/oy0+5LSIV7b1zl
         5oLjNuQJZC6Xgtp0Ri//Rqe4mUmcLBv267kLHYw1IbLIUksF3A2tv7dJ0D+3jVhi3MJZ
         QYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rVEQpX0LEPkhHrLcC+cD5UnBVicvNYfVXqJsdxneVAM=;
        b=rs15jy7NrntrvObTQx48GeswRlpQZpr/gIgHG1sHf8wychJ3xIurxD6lMMYf5YxSd0
         fM8O6FZdKa2D5tROBolAor2d2NYflYfPpF2jKwecTw+Sym4cBm57uEskROsxa+lXOBej
         9ZyQ2VLZ0QTc+R1tbqIhRpqC3Wq/AvFQ1+t11mifGzf8dnffX1LXBqdtW95xipMEmJUV
         lQTcCSBptAYzHXDIOrJbWGX9aqmOvcP5zgbOgfXiET57Eui3eKDP9EI9A2PIPQ//aUgo
         GOQFdwR1aATGWrT7kHNdiL+jzecqb5i0n/HROsZXx3gnugtZfYu+ImSASLSD41gMSV/H
         IH2w==
X-Gm-Message-State: APjAAAUZG0dL+liDeC4P6VeLz6HcVpVUujgjMiRfYhByAzp6JHKYQyhl
        ppnBM1XLMLD0RqTvA17qibOL9g==
X-Google-Smtp-Source: APXvYqyTBec+mAjz39H7iVplpLSf0VphdbFavG6OhBgn/k46sPoEWi/ykbeJrG9zay4RSn6KlsG4vg==
X-Received: by 2002:ac8:2291:: with SMTP id f17mr24423699qta.330.1557186724890;
        Mon, 06 May 2019 16:52:04 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f127sm8209347qkb.53.2019.05.06.16.52.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 16:52:04 -0700 (PDT)
Date:   Mon, 6 May 2019 16:51:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: Take common prefetch code structure
 into a function
Message-ID: <20190506165157.6e0f04e6@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1557052567-31827-2-git-send-email-tariqt@mellanox.com>
References: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
        <1557052567-31827-2-git-send-email-tariqt@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 May 2019 13:36:06 +0300, Tariq Toukan wrote:
> Many device drivers use the same prefetch code structure to
> deal with small L1 cacheline size.
> Take this code into a function and call it from the drivers.
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>

We could bike shed on the name a little - net_prefetch_headers() ?
but at least a short kdoc explanation for the purpose of this helper
would be good IMHO.
