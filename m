Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEA279CE5
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 01:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgIZXma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 19:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgIZXma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 19:42:30 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B50C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 16:42:29 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr14so3512283ejb.1
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 16:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c1tvljufF5SvcY3598AfysPA74NX5FJtpSWIIaNhi80=;
        b=qqCAnR3suVjq+EnVgr3qjH6LfxBUgF8iy9UHCi0VRBordMToUyxQ8cMYUBwJOBcoBp
         C7uVxru3typ8CphIlD4UFM2Hi0r9q5Cvpw/pzx8dOHDonZQVbSyX4qwPHvzHppAIHN0I
         sEdKfugegrU3dyDkLruhf446zJS/ngHNDKaIbmnRZx7d4+D90vQnwf3EpS/tmDdJ1qe/
         B8jSwRzRe0XTDb5JaszG4Q1mF8nTOW2FDchD03yvX6FiON3bL01zsMQ5mX40oDSBpAqg
         a9WSuspo3WKX3Cth78d2ZofFZz9rhrIbCryswKTpZeSPdsGYSxjulAA/05QW3umq39P+
         GJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c1tvljufF5SvcY3598AfysPA74NX5FJtpSWIIaNhi80=;
        b=ok8DNYFM5n6hIcKn1a/IIb4QREOg4fubWcyKz9zQR6wVGo9eTfjMpMSR3Ng87hqUM2
         ZXymmxEdOCtsvr89VBSl2Ok9XKV+1am5kNvcnfJGrP7VqKjxX90R82AjZTClDs6hwkob
         lAQS8hncSqWJ9n2kT7KqlUcP8TGMgC48xQgpq7LAw6FcgydhiOeywlJG6uyanzd8AWsU
         4P0cglgp20c/mj3v2/rbB0/Mtw56HKq0l0g2lVafCXsI9TT/Pa9HzsrYBhMgQwn2u8j7
         YthO1tLXCHq0TR+PmzUyscWQGZRS03VBX6Uzi8wsXBs/9MamY0FuuvjaHNQBecRXb9wp
         tt1w==
X-Gm-Message-State: AOAM5330dMUPrOXHq3aYQfcxHnnepbyEr9jXxMVwonrOUDpXrRGwNq+T
        8aJyQx1FbyCL8t0RaFlj5aM=
X-Google-Smtp-Source: ABdhPJyjuUtLz0E7lG1z0iaUXxbttZZQu+DcdaaMLxDJ0VoxLHFg9lGZDt5Z9paKkXRpIKOOqjXJaA==
X-Received: by 2002:a17:906:a1d8:: with SMTP id bx24mr8944488ejb.161.1601163748667;
        Sat, 26 Sep 2020 16:42:28 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id si28sm4970548ejb.95.2020.09.26.16.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 16:42:28 -0700 (PDT)
Date:   Sun, 27 Sep 2020 02:42:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: Add devlink port regions
 support to DSA
Message-ID: <20200926234226.bs4jbaysxsbwaafi@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-6-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926210632.3888886-6-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 11:06:30PM +0200, Andrew Lunn wrote:
> Allow DSA drivers to make use of devlink port regions, via simple
> wrappers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
