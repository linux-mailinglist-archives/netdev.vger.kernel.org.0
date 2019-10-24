Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10B6E38CB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409906AbfJXQrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:47:20 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:33246 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405516AbfJXQrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:47:20 -0400
Received: by mail-qt1-f180.google.com with SMTP id r5so38882990qtd.0;
        Thu, 24 Oct 2019 09:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=359J8YcwWQeShpxfO8aTvwah7AWM03igtl5dwiYjcyk=;
        b=lzPfneCjKpvgn4WeodHOJmtYeQRF4MBzULU9yNEo+U8qML1FQ2MPOjzZlZitXz+kKR
         9jHwdOXN5hezHYHeAOJAAlX9tlmTk2w1jyVjB7+Jvx/ihCU8RiYoeeNCETckWDlET2y7
         Vv7toew5L8J9BCKkWEspZsZEmytS6DalGXLW9pgi1sz2RR172Y9AJMALvWP48DEpSjwp
         beDylJ9w4F+vqYVRu4CuiY5zulIZaybrvM4CEekF9ZHChWKuyyZXG6s7UsdmhhuBrWak
         gd3MC0MAdrQ19idhvoJjbqT1wvJwKyIovARFkb6VtnJ1IrQlYnxKml9/kqSgQ1dmIfFN
         xRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=359J8YcwWQeShpxfO8aTvwah7AWM03igtl5dwiYjcyk=;
        b=KKkP63Vyg03sApTjPnj/jb3XPvzk03fTXnvvfTUa40GzOEeFgAN5Gi+e7h60LPYTLp
         /wG1EABqNzncUld4EiRo40Zduqi7tsO+tglrL32OUYe3Wk4pUH16xlENCpun06wDiWc7
         8t7QVIV0E+xOMyeAI5Dwn115pazqYOTX8n0u6qc+iCTjzpl/rkNlL5Fcly6pJ4VKSndm
         anMDrh4CboI42IMlUOv6xCeC0Fgk9Kshr6s/KiqYWZzOF5N8QTPznDyKtemTmSf9OyIN
         bkxHGTd1C6TOhQbEV3S6gf7nGa2WGoc4Bgz3eK0jSWvSY/rgqDLZ7l4CxaMRdZMM07Fo
         I7bw==
X-Gm-Message-State: APjAAAWwTWp98L6O7GjV3NohHEWpUqVIUOPf706vv6GS8004rS6n/G86
        d7HZft0qhr3aAKLQz8L/988=
X-Google-Smtp-Source: APXvYqyGJ1hmw6uReyM04ZrDuiA3HGt8Ad5AiBRp77uP+V1uiGSWdM9pcx/zTqK9LjZZn/+SydvSrw==
X-Received: by 2002:ac8:290f:: with SMTP id y15mr5300194qty.181.1571935638557;
        Thu, 24 Oct 2019 09:47:18 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c18sm12080095qkk.17.2019.10.24.09.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 09:47:17 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:47:16 -0400
Message-ID: <20191024124716.GB1210163@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: fix dereference on ds->dev before null
 check error
In-Reply-To: <20191024103218.2592-1-colin.king@canonical.com>
References: <20191024103218.2592-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 11:32:18 +0100, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently ds->dev is dereferenced on the assignments of pdata and
> np before ds->dev is null checked, hence there is a potential null
> pointer dereference on ds->dev.  Fix this by assigning pdata and
> np after the ds->dev null pointer sanity check.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
