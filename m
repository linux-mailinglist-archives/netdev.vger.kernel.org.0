Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5142C4A623B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbiBARUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiBARUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:20:18 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5D8C061714;
        Tue,  1 Feb 2022 09:20:18 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id j2so55629337ejk.6;
        Tue, 01 Feb 2022 09:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bnZYfSNhzo/fFfS+vptl3+YaNnxhQy/Mqz99bEg1grw=;
        b=hLz+1cWNRmbI3pEYWMnxQJOyR/t9YVf4/1zhxVFNmFOPszui0cU2GAqpZFrsHA4eH8
         wh52oRdS79xUB/32be9znffUXgzE0B9JuDZmF9YJHZMNNBH29zIuQrnOaU5kbchffcWh
         M5XPGxBgLLeUKVPTqPGYsMlrYM2DXN+9FE1ck2HqROZ1LDgu8pJm9dQ91GOrtC8VRvTF
         BCNGna6Vc8GOyya8zDjATN7IGXIQlFNePvDBfhDEXEr1HS3+Hwcbxw1esQmKMqWDyEAl
         vwyr43jetFDA9SdjrwwIKgq7JM0GUSSQsmx7A0C45rKzihPx5Rhtob67RFuqvyfnoBQC
         cOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bnZYfSNhzo/fFfS+vptl3+YaNnxhQy/Mqz99bEg1grw=;
        b=Eu4HKhzuKWjN8beRoOmdXUtEAg6ywxeG2opbxFkKyV1aswIvF5PzcGhkSl7uqQfka/
         TIL0ghxr3vnfPzt3NnT8Uofl8UxCN4lyfTLOujNIaDK0LVzyXSD9RiK7crvD0Ip14b6c
         OGYqE/z1O2nA3iBviJmEPqG8qhtN2hlC4ttYF/TC0rXfHbDkiCpeq05wCGieQ7dq+Dbd
         r/rA1gWSW1N5fGfKsfb7eVo+TxIsicnEkbQanUyJV6+ARabD0tEfyTUlF2QaCopzGOZc
         6FY5qUL//BJ7XjhK+goF1YkR0r9ZaOigc3l4ca7CEfgqDRC37hrj2RiMdzpRmo+PBzhh
         UAWw==
X-Gm-Message-State: AOAM5333JLjuzj0dXm9PPCJ83S9YT9pV0EJyV3SF1h+WPa3wc75zxR8I
        3Fh31v99cDU1JQimOawAzoM=
X-Google-Smtp-Source: ABdhPJwfKx2CV80OLoOIGWw1Tq8j7aWcSLti3dURMAgoWlZMONvxm6dyowUf2ctIyA0BwhqVPgKTzw==
X-Received: by 2002:a17:906:364f:: with SMTP id r15mr22250898ejb.473.1643736016616;
        Tue, 01 Feb 2022 09:20:16 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id d16sm14893704eje.131.2022.02.01.09.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 09:20:15 -0800 (PST)
Date:   Tue, 1 Feb 2022 19:20:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of
 standalone ports
Message-ID: <20220201172014.v7amuqqksp4jl34x@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-2-tobias@waldekranz.com>
 <20220201170634.wnxy3s7f6jnmt737@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201170634.wnxy3s7f6jnmt737@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 07:06:34PM +0200, Vladimir Oltean wrote:
> Question: can we disable learning per FID? I searched for this in the
> limited documentation that I have, but I didn't see such option.
> Doing this would be advantageous because we'd end up with a bit more
> space in the ATU. With your solution we're just doing damage control.

Answering my own question...

Your patch 4/5 does disable learning for packets coming from standalone
ports, but not by FID, but by VTU policy. So that's good. Reading on...
