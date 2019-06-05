Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39214366A6
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFEVSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:18:43 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:40060 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEVSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:18:43 -0400
Received: by mail-qk1-f175.google.com with SMTP id c70so165865qkg.7
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LwuKD0qRQR6Z1DCIQ+SriQ9WugB9fmYEFY6WJV5RzOU=;
        b=aHYJ6ng06q78UXrqbo5EJBBIn7SflXbQr7HKsAkPaVh6IVwauI+elhLUuTxL4rsQHk
         ORjs1TlaeeQRlkujSAjE9Q8XZ/Jy6zoMfykruTXyjTerjV/XSCHvQHbaCpqdUGhXEpiE
         rKhPJhjJUj+fEhHSqb2/MhhWnoIe2Msg8A0Msdpbqc87nP0qFiZoPj9PUjvxe4MIxDhS
         VC7JsG+rULIw1kny1V/NpJcaSF4R1nRQOO22tH7ZG25y4QRb56uAQ44FeyyD5GsfcZYd
         Ju2xwQ90XH6WOfPLLpyjdwIF9iZTUnVrK/FYH7xNadvhZk0MNgJtL177Yzoe5QSDpdZF
         GKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LwuKD0qRQR6Z1DCIQ+SriQ9WugB9fmYEFY6WJV5RzOU=;
        b=X9y5S5lB7mzlaK5EC+RkDtH1r/C3dx4YpJORnGT7YAYQgZExXX5JkDAEEUGozJHXZ8
         hYLmdHCTevAfcIcFApLfXkEq/0RaW+1WcKI0wdZ2cJoJ522101zSduI6V5FcTK1sDif3
         QebafU8ZyV6dCUyWslYEuvZxHq1JRqkRtTXYQhlGfXnkXHVjB9hu85Z27gfPkWAasNjb
         ZlfFDCQsAPxOLCHUGqF41rwpRY67XXRfpu1MmJk8ZTmSugSXOczLuFlKyWlSkov5gn61
         JZX1dZbm3DbVQTt/rtOz2qEFRBAuLvsgToqauahCMDAjfipzB/kPNReAoHgmbML7vMBo
         eZ2Q==
X-Gm-Message-State: APjAAAVU7EQntKDTz2f58DCYdyD5siSybhG7QP7t6moAm5hyOik4Oafr
        t2Yj337guEmjuw5KNzFsXPvVLA==
X-Google-Smtp-Source: APXvYqwUWo1vbCti1v8T1dlpOSUFRFYWCwSdehJXnFZBW33Cor6Y/9MBYHpo841CP4uc4HSW0v6jRA==
X-Received: by 2002:a37:8007:: with SMTP id b7mr15760560qkd.102.1559769522355;
        Wed, 05 Jun 2019 14:18:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c192sm5339874qkg.33.2019.06.05.14.18.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 14:18:42 -0700 (PDT)
Date:   Wed, 5 Jun 2019 14:18:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [oss-drivers] [PATCH][next] nfp: flower: use struct_size()
 helper
Message-ID: <20190605141838.506a453b@cakuba.netronome.com>
In-Reply-To: <20190605203827.GA22786@embeddedor>
References: <20190605203827.GA22786@embeddedor>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 15:38:27 -0500, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct nfp_tun_active_tuns {
> 	...
>         struct route_ip_info {
>                 __be32 ipv4;
>                 __be32 egress_port;
>                 __be32 extra[2];
>         } tun_info[];
> };
> 
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> So, replace the following form:
> 
> sizeof(struct nfp_tun_active_tuns) + sizeof(struct route_ip_info) * count
> 
> with:
> 
> struct_size(payload, tun_info, count)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
