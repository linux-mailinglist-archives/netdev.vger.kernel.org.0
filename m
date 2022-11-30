Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3444063E399
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiK3WqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiK3WqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:46:24 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849668DBCF;
        Wed, 30 Nov 2022 14:46:22 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gu23so59370ejb.10;
        Wed, 30 Nov 2022 14:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pQT5Cu8v5qAJyqREJMcXsMiEc28zpgdBTHMOamR6xfQ=;
        b=IeKWPX2M3ONOWuMAEn+PPhimDfV+tK7803CNUzmTvIb1EKCnbfFfnTENymzKCxYxe9
         LxYdLMxxt4obLs+UIfl8vTXgsKC3SqO1sUzobXBr++uslwYCCBLzhHMXlS/jnfZ7om16
         Vr43+Gf2Vkl9nrMnkeo7G0Q1W58s3Ry3Td/ljGhhJ7lc+tT+aFYTudvx+nIOYuDdmVxE
         i4UGx3K28bRV5YhHSjKLwcUjAJutHi6AJDzLhAFXfsaMTNHEZ7ukaymEgQSqa3hkDyLw
         lvSquJeiUKWma3nD5trgosXn3kKsNveJ3XA/M2QrjAzouSplK+uTx0L/w13H7ZRKm7Bv
         r7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQT5Cu8v5qAJyqREJMcXsMiEc28zpgdBTHMOamR6xfQ=;
        b=jNTsEDj1e+JbiLIfhR82X4d184QUPLRhYPsKu26i6cyaaFwGWoqv945+C+C7KNhCjs
         Em7Xg2CymrbMUzSfzA0zqxU+x/gAvcgNKHSv0Mw47KN+VdKzmb5W1MIEvq9FXm0pvkiY
         jr0WUg15v0ZGaOXQzhNztLV4SyYCIz4YaujVv/2uPJPqSBRi4rl8Ioetk8y2//CntfG2
         4hk0jxhJlsM/euig+KsR5rWfY7nT+NbIAQKGd6t4ghYTxBj9ecmYzjxKZFGbOae87WHG
         1Bnw66+BUT4lBWaxVyzN2yNw3JOVDXASjE/E7GY/rK7l59Tcyjipc+xKrRZgdW+TWAxu
         w4Fw==
X-Gm-Message-State: ANoB5pnnzI1V03ZeDDfHPdQFpdztGQUz4Hy8gHlXiXhk0rnpWyt+74jp
        kyiK7QhH+o8/Ksnhi/5Fzbs=
X-Google-Smtp-Source: AA0mqf4eru/8GE4/kcxqr0RG5CO+U5kmuuv9UHUVvYfiH+1rnpGZLpM8goACB/BVLuT9X3BWjX6RgQ==
X-Received: by 2002:a17:906:49d0:b0:79f:e0b3:3b9b with SMTP id w16-20020a17090649d000b0079fe0b33b9bmr36570904ejv.378.1669848381061;
        Wed, 30 Nov 2022 14:46:21 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id kx16-20020a170907775000b007c0934db0e0sm1107741ejc.141.2022.11.30.14.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 14:46:20 -0800 (PST)
Date:   Thu, 1 Dec 2022 00:46:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] net: dsa: Check return value from skb_trim_rcsum()
Message-ID: <20221130224618.efk7tjv54o57lolj@skbuf>
References: <20221129165531.wgeyxgo5el2x43mj@skbuf>
 <20221129194309.3428340-1-artem.chernyshev@red-soft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129194309.3428340-1-artem.chernyshev@red-soft.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Nov 29, 2022 at 10:43:09PM +0300, Artem Chernyshev wrote:
> Return NULL if we got unexpected value from skb_trim_rcsum()
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
> Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
> Fixes: 4913b8ebf8a9 ("net: dsa: add support for the SJA1110 native tagging protocol")
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
> ---

While you're fixing the same class of bug in 3 drivers, the bugs are
unrelated to one another.

SJA1110, KSZ and Hellcreek are switch families from 3 different hardware
vendors, and none of those vendors cares about the other.

When you squash 3 Fixes: tags into the same patch like that, the
following will happen.

$ git tag --contains 01ef09caad66 # "net: dsa: Add tag handling for Hirschmann Hellcreek switches"
v5.11
$ git tag --contains bafe9ba7d908 # "net: dsa: ksz: Factor out common tag code"
v5.0
$ git tag --contains 4913b8ebf8a9 # "net: dsa: add support for the SJA1110 native tagging protocol"
v5.14

Your patch can only be backported down to linux-stable branch linux-5.15.y,
because that's the only stable branch that contains the code you're
modifying.

The Hellcreek driver won't benefit from the bug fix on the 5.10 stable
branch, and neither KSZ nor Hellcreek will benefit from it on 5.4.

Be smart, write 3 patches with 3 distinct Fixes: tags, and each will be
backported where it needs to, independent from the other.

Oh, and also, don't send the v3 emails with an In-reply-to: header to v2.

And please remember to run ./scripts/get_maintainer.pl again, on each
patch revision.
