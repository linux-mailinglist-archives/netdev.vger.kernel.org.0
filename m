Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6D046C976
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhLHAqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhLHAqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:46:21 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96C4C061574;
        Tue,  7 Dec 2021 16:42:50 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so3145359pju.3;
        Tue, 07 Dec 2021 16:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kXyvNxG4ME9II82+J6dZQTX1M1MTFkk+jTmDSFC36eQ=;
        b=UsPwPXBrJaD5aTIzNRzDghnSST4UPCLI8zpSv+Fm6j9KaJz5IF+a6kIEEXynlj6neb
         WU9m8O9+H5QP5bDzQhU3AQSdPBSbdiEWXUE4QQDnzesDKZko1FO0RxzzTa78oJ5vv2Do
         eS+8SSYtc/0PygPidGUJW7h+CQHt3uhE5CBRwDbuzM+NVewa3h5rydkPZZV0F/VtktX7
         ANWny89lF/ATt0QjrEXnaMmLEJeAdoJ6XlDdnc88pW0Xz4zBy750OWpXChqWCIJgxSeF
         XeHWG7FMhmaHFrvq6sGu5zWgt42wxoVhqSD0KC1cXMWYu1luabBHV97nyjP6evvWkD7P
         Nhyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kXyvNxG4ME9II82+J6dZQTX1M1MTFkk+jTmDSFC36eQ=;
        b=ZDuoMu5umT4JNyU9IzTZ3FkFIkWhUpdpSD4KricYwkYvDXWG1Ia6C0ew7zRQu+dxKa
         AEkIqKs6gnAkgpRWsibWXDCumVtPyB7crGNkCx9+TuTx3h3TLGzr9LcRO+Vtk+JRIgQX
         yQu5pCNRIwiBJpYgWqCMs95sfsMmsQw0hhr3bgQyoMS3itiCRdlW+6fDiHRSxadKVoNZ
         nmNn7AQi9gCLjPienDbUYu89UfLDs9y0DD1DlTiRDUafFJnA7XhBaLx+aYZf2O4lHQrT
         bF5GMZva4IE1tfgAKIPKRaJdSOdf7Y1pONU3qk93LniRJFl5XrGff7KmS0eYcWdRWOz6
         iTgw==
X-Gm-Message-State: AOAM530Fhb/qynh+0I1yjAvc1I5Q3nCTzst5LH3nykC2d1MTW7pFSy5l
        I8Bv8BbnrZQaBvQWTu1VidA=
X-Google-Smtp-Source: ABdhPJxkeQXXTIq8UQndjfKpbPsMMQg+ZgdS0gr94eBvNKqKIEfhewWQHWYbUlUryVZiHSg9HJcGqg==
X-Received: by 2002:a17:902:db12:b0:142:3ac:7ec3 with SMTP id m18-20020a170902db1200b0014203ac7ec3mr54911942plx.2.1638924170287;
        Tue, 07 Dec 2021 16:42:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q10sm3469947pjd.0.2021.12.07.16.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 16:42:49 -0800 (PST)
Subject: Re: [PATCH v5 net-next 3/4] net: dsa: ocelot: felix: add interface
 for custom regmaps
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
References: <20211207170030.1406601-1-colin.foster@in-advantage.com>
 <20211207170030.1406601-4-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e6113c1a-dfe7-b3fa-259f-42b3a172d37a@gmail.com>
Date:   Tue, 7 Dec 2021 16:42:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211207170030.1406601-4-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 9:00 AM, Colin Foster wrote:
> Add an interface so that non-mmio regmaps can be used
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
