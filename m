Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E2A41D2EB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 07:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348170AbhI3F5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 01:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348054AbhI3F5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 01:57:41 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9261C06161C;
        Wed, 29 Sep 2021 22:55:58 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id g41so20484241lfv.1;
        Wed, 29 Sep 2021 22:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2qGpbnt6Ea9Mn6yWgyyxhjvadWbpeqRJ4xkhEjZ9SsE=;
        b=YY8UpddAA8/LckCgQq+XM4SWrWfV0p/x8ju7e7m1AbQUnsMIT4b4d1xtaNskFasAVp
         bnhuy3o53ab2V35seCuM+AdSDngA4//ULKuf7yOanPf4sgYgs+lsmbrf7OgFusBg7xqv
         uFviLHXHlQ2rxnt5oTl8fD1HQpm+6ZbOAxnD7ru8a9FIB6VdtB50H8XTnF08dZuXSXEv
         +GRP3Epkk45e9Mr+r81uZxv7nv3zVGLBjTRFZJ8On0Lv6B31lWQP67M6Hf2IE1Nv9cDI
         kEupKbrYVDko9JDMN9TnVxDabeErG6bWxREfczrHgH26rTx3Sgkhpm/QECV5AOS/1fr0
         dsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2qGpbnt6Ea9Mn6yWgyyxhjvadWbpeqRJ4xkhEjZ9SsE=;
        b=4VGQwv2VU4LPOpSaCyYnWAACRDGpsoMyh3nSsx3mzHtZwugE8iS+Ddk3RQRqYQ4qGu
         +Y4eg+GQ2yb7I6aqZX1YT4CUZ5LZOjPQ4wSupYS0R8Vg1lOVwe7YOTvmrhVTLPEfF9j2
         6LJ4BwzqO8C+XPWAYvFA/8yAweXQ3mj/nWdM//RbShG1hb2DfJQdB3KuJpwRbOI9g2VO
         spviggpEzIWqpaWlj9+rBow6QC5bkmj40Sja6/5LmT7tnZ0htXVWBL4uxneM2DbAk1w+
         +6buD2dJu+Hwn6JBBIt6WIWrsOql4esXUU40YGcTGmrPjL9qC3QSUDxnDHcvkiPVgjmB
         1H1w==
X-Gm-Message-State: AOAM530EjMAkPWWbhoucJoIsYxmLrIZETy96F5+XQv5s8yBHTTFeAz5D
        4vR6/t27kLad/BOWayEMXj0=
X-Google-Smtp-Source: ABdhPJzDryf+Tr4zoSfjX/tu6EcZklDOfBSc7qqJQ+JooouBdRyXaqCE+m08QTK8cqJ+mu4MRP1GWA==
X-Received: by 2002:a05:6512:ac2:: with SMTP id n2mr4335806lfu.625.1632981357138;
        Wed, 29 Sep 2021 22:55:57 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id c14sm52519lfc.49.2021.09.29.22.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 22:55:56 -0700 (PDT)
Message-ID: <84cf4561-506b-511c-04b7-f12e411506a6@gmail.com>
Date:   Thu, 30 Sep 2021 08:55:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 2/2] phy: mdio: fix memory leak
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, buytenh@marvell.com, afleming@freescale.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
References: <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
 <55e9785e2ae2eae03c4af850a07e3297c5a0b784.1632861239.git.paskripkin@gmail.com>
 <20210929164840.76afdec8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210929164840.76afdec8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 02:48, Jakub Kicinski wrote:
> On Tue, 28 Sep 2021 23:40:15 +0300 Pavel Skripkin wrote:
>> +	/* We need to set state to MDIOBUS_UNREGISTERED to correctly realese
>> +	 * the device in mdiobus_free()
>> +	 *
>> +	 * State will be updated later in this function in case of success
>> +	 */
>> +	bus->state == MDIOBUS_UNREGISTERED;
> 
> IDK how syzbot has tested it but clearly we should blindly
> depend on that.
> 
> s/==/=/
> 
> Compiler would have told you this.
> 
whooops... sorry about that. syzbot has tested v1. v2 is same, but 
without new state (so, the logic in v1 and v2 is the same).

I guess, it's copy-paste error on my side :). Will send v3 this evening



With regards,
Pavel Skripkin
