Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980094CD5E1
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbiCDOHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiCDOHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:07:19 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3F01B9880;
        Fri,  4 Mar 2022 06:06:32 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id k1so7735387pfu.2;
        Fri, 04 Mar 2022 06:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c5LzvjZ/L9J5HFrrIzQ1NZcc5bYA3vDwRKV5bDRGslI=;
        b=du47i1ZzjqJlAXXmSL3ZleQtK7h/0lXK3hFN9++IGVzGAUK062WKYT2Fubj83GGTIg
         T3noycM+gK0j/DXtE4++lVe+Frp22AMHXmyjHCHbIRvvRMOfZ7BysWXqc7jcHE4ZZRPP
         yq7nW7gVPwHNBhsVz7ycjgx6tuSp8VCKsPIIFcrXidg6NM3/bCJkEDpr+J+zs8qUaW0O
         3ObZNVlxG4jGHoQowqEbDdNRl9OiDouO+dz1Z1IK3s2W7/cXX+brtIxttQGjsPLIlOo2
         Bw5C6Pv4vOHVdOYu7x7qmWGcZcERcHjkcLDuS1SIAc6pktEln+LH4bLZPeSVJEqCIzb+
         rwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c5LzvjZ/L9J5HFrrIzQ1NZcc5bYA3vDwRKV5bDRGslI=;
        b=I7Jmen8bI8zpfCcxZCtZ1QxP0ma9j7t/kcNo+TVIfcTsGW996de2h4c93yij8l99bd
         EnGw4qLQ+OA0syGl4peysdw3y8LKArcOQ22PdnjKcGj9hrmk0S5O3fvexw5cQRD/Z8qt
         wqqpQQMc++FQEtiqkyoFDRV/12KGjf//fBCYgGUog04JllYDFPcfrYyBH7uVP/JKH5hV
         HD75sy8BGl+AzGk1GDIkRmGRgsVU+ARq7hy3n4GwtHtv809uD5mmkZOYNEThjiExTXhM
         oM/6YfUwx/CxnHgEv2RQ4K1z7wS05AQlSGKTywqkkS+xHjzKX8BvxBxL4nMzRwSzHd3D
         JhdA==
X-Gm-Message-State: AOAM532ZauK0uacCFch5twAPrYI/1Z9m6r4z9B05a2lIppMaR1bTYfvU
        /YrKb8f3alG1Tdsf9OnQBUQ=
X-Google-Smtp-Source: ABdhPJwhxlQuBhBQ9bEAxgjwb7Wvvqjt2hiWCJ85qpbJjPgPgBdj5TF8HLYXzitOWIKQxqj1IItdtw==
X-Received: by 2002:a63:2a96:0:b0:37c:46b0:add7 with SMTP id q144-20020a632a96000000b0037c46b0add7mr9247075pgq.50.1646402791670;
        Fri, 04 Mar 2022 06:06:31 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m16-20020a638c10000000b0037c4cf366c0sm4681619pgd.61.2022.03.04.06.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 06:06:31 -0800 (PST)
Date:   Fri, 4 Mar 2022 06:06:28 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Message-ID: <20220304140628.GF16032@hoboy.vegasvil.org>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
 <YiIO7lAMCkHhd11L@lunn.ch>
 <20220304.132121.856864783082151547.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304.132121.856864783082151547.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 01:21:21PM +0000, David Miller wrote:

> Sorry, it seemed satraightforward to me, and I try to get the backlog under 40 patches before
> I hand over to Jakub for the day.

Day by day, it seems like there is more and more of this PTP driver
stuff.  Maybe it is time for me to manage a separate PTP driver tree.
I could get the reviews and acks, then place a PR to netdev or lkml
when ready.

Thoughts?

Thanks,
Richard

