Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE169687A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjBNPuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjBNPuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:50:16 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9363430D4;
        Tue, 14 Feb 2023 07:50:15 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso13982287wmp.3;
        Tue, 14 Feb 2023 07:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qii2og17aImvT8ZjPxYLeXITxSxT4PHRaFvNRbLddrY=;
        b=Bm+vmVE1i/BGWDwu1fWFPZws69djpT2yeKi6VLfmmWQ9h/gHxEkKAOWNN9jFFJ2tIT
         ZrwUKglQhfR7kDkw42sqLKXhLjLBqbAMbaVIAGTKlDNgKzm0DHib/QpISnvLM7oSx9Ht
         WU3RTsPMt0dtLv6KJtB2mc/0ecNs5nuhLVbpKT9KoqzGBwf5eCQJ7uOqvrt1gioT0CkK
         VNXMzuyfErm2BO7WpQkHgE8s3uymzdxZGq3pVC+lO8e78gHLUDnJmvV4DJaYir6igKZs
         gsV7Jk2ggpE0A6F0hQDZ+6Pr3z9tucgSB04IEvZKNqkYryPW03bivCyET0Zjzks303qT
         OFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qii2og17aImvT8ZjPxYLeXITxSxT4PHRaFvNRbLddrY=;
        b=iVG/PEi2PHsNHROZyivv/pW07oQoQ+Z+wk1XnVcSAF9i+kaYU4A3f1YYSzoGCUgHBe
         OCA8H8Llr1Tuj/qJNkwvhLoEr0SKCAIfeq2JMIHb4lOapt2uOT+xShgcD6/xMMH2N8dk
         kW+83RweZc+WP4IQxo4WWUAKaBCPrgrAAHLC86pypjsbgVU8kq0mzSfZmc3Ti69wjTtQ
         ONKoooJ1ma5zDYVLySSxo9Phe8XbDtYa0Dbu9Ii2iDjcew8UY6g2S0XsKhZUJn0pADyK
         u+xjpbQZS9BRMa3jfUsY9RAoirmPRE7kW5BmuhU3Db3Bi34F7hA8qM6zjaWTWdcWSWkh
         Xulg==
X-Gm-Message-State: AO0yUKXpbXd2NFmVvUd3bZ5y5vGcITNvX1a/G9qhxsM4JoJ1iDh7NUej
        ViFWmG7NvGc6lnoVpggZP3tUgv2NWJRoyA==
X-Google-Smtp-Source: AK7set/+Vodl/e6827TR4dk5c4heRYgjpT/PdpbRFCjng2PzQoG7cNVNGmd6WDos7FZvbsUWewdtuw==
X-Received: by 2002:a05:600c:3418:b0:3dc:50dd:361b with SMTP id y24-20020a05600c341800b003dc50dd361bmr2473315wmp.5.1676389814160;
        Tue, 14 Feb 2023 07:50:14 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g10-20020a05600c310a00b003e1e8d794e1sm9158227wmo.13.2023.02.14.07.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 07:50:13 -0800 (PST)
Date:   Tue, 14 Feb 2023 18:50:09 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Uninitialized variables in
 yt8531_link_change_notify()
Message-ID: <Y+utsW/vGIYNJJu7@kadam>
References: <Y+utT+5q5Te1GvYk@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+utT+5q5Te1GvYk@kili>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 06:48:31PM +0300, Dan Carpenter wrote:
> These booleans are never set to false, but are just used uninitialized.
> 
> Fixes: 4ac94f728a58 ("net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Applies to net-next.
> 

Sorry for sending this twice.  :/

regards,
dan carpenter

