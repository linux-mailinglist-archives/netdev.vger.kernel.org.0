Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5963B44E9BB
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhKLPOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhKLPOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:14:40 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C264DC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:11:49 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m14so39263900edd.0
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6ADvEmc1RISB5qi6+8FZvcxIM4fENhmrMvKh3S0wTzQ=;
        b=ozjpPLc1S33YvBMxY/ZUvwNREs6C12awdr7IZl//E8q5sq4ldR5O2p2KI88dGxIqFI
         J7Rn+zHUmIOhVtybcifEoXZDEOAusBeUZfkdihf8yKYHmwLmgvVDIGC0D1JwxJrYT7Xn
         K5JVevINbRCdOMg++Gx2EK42DFF+SlQH9cX0Jh/qC3P2wKixxIu7X/wNF9IjRnykEA9d
         UY/vnueJZnScDUDBbkjJyB3svjqrq4r/skriTDBf3qsVheg4AZYnJba7j6vLTQ7IU4Pj
         f7C5zh5EGtJFcTUKcurcxxNZlfCJNULlmGldz588OJ4vd0LmC8fqy9Sh0VRsORRTS+vO
         +nDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6ADvEmc1RISB5qi6+8FZvcxIM4fENhmrMvKh3S0wTzQ=;
        b=6VXZYSX6Zo2KGi4ywC4+cj0UJQ3CLaDK2oMVocXvh7IxPm+Un1e6AUgK1udCUD32PT
         B3rqNix0ARN/MOHoefLLGCboK4XhJ0G4qNquQR4DWxjRa9ZldPgJI08oOoWyc6Ae8I3J
         7u+bB7AgYcwjsEJa9yemNIL0MSHRuv9ozgOj12ANX0iP2Z08pNLhWoi+dd8okLUo6L7l
         UIkbXSDA9hy3F4m668COe05HuqV3b2Rc8prxsdHxMyq5KMQCdw30voI99LJkTnFar3X2
         P27zm+ewcRnSrUZmk5lFx043vxlaTm/49Mndv11hHCBwhWAlIOmc0bX0e0yMVxQpgyqM
         PG9w==
X-Gm-Message-State: AOAM531v5EsbGHrBOF/ucOV9aUqLA0BuLcV3NyJBeZeKINg3d+NCa3/D
        pAPgSXQ6AIZampp6KB2y0bg=
X-Google-Smtp-Source: ABdhPJxUR8KfHPRKY5yDIIk1zptg0KLE166UQ5s2tY3m/mWoWcNkJ9s+ceGoHq2rXVh9Kczx9xYDHw==
X-Received: by 2002:a17:906:1457:: with SMTP id q23mr19230857ejc.561.1636729908335;
        Fri, 12 Nov 2021 07:11:48 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id w1sm3365060edd.49.2021.11.12.07.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:11:48 -0800 (PST)
Date:   Fri, 12 Nov 2021 17:11:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: vsc73xxx: Make vsc73xx_remove()
 return void
Message-ID: <20211112151146.mzvte55gz5eo7fhr@skbuf>
References: <20211112145352.1125971-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211112145352.1125971-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 03:53:52PM +0100, Uwe Kleine-König wrote:
> vsc73xx_remove() returns zero unconditionally and no caller checks the
> returned value. So convert the function to return no value.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
