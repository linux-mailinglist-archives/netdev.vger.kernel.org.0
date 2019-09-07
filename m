Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212B1AC93B
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436691AbfIGUiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:38:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33907 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392547AbfIGUiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:38:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id a11so87536wrx.1
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sZnVnjk3Mu1sOPCFBJdN1MA+54MpbYM+2Od0ykbq2rA=;
        b=H5NGHEg+7sol0ZboX/MrXRwxxM72FRPJmBZw3USfKZwlAxxVtQGKqNocWTg/uG5sVZ
         7nT0PNpvGkyilsMdTTfX4kgB9K9hon+9fx4XIUd60zEdiSBoNBNCyFGzn0c0Xk+rdYb+
         +ACmGYQZ4YRtSqeBNqr4JsI6yv0/JbGKP3D7Is6vlZqezeuDN+VLqI/x9/DzXP8y0rSP
         OGvQ/0i7X6ksO0s+UaI/hFt2al7yIpEG63Dy8/ziCF9i1wFb4pukJine9PvCqEvNMt3h
         BmK0nhPxAFJyXd6tc8b1Vg0myY2J3obteZNyviknksI9PNqeWpVjfcQFGKeneeOTvuVY
         4gfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sZnVnjk3Mu1sOPCFBJdN1MA+54MpbYM+2Od0ykbq2rA=;
        b=qQVDJCnwhcZnsaTYS2VNrYjEQBA9T42ha5zE0HL0YHoqYybACMkzrr8GY80twMwQK5
         2G2CHj20dvIxz37+TNWnliyU8f4kD1WNeQWr98WmB8peX00/57I8TifA6vmefNilC8sl
         TwmbENkBSvCUGZOX44OlcbZMWeqBbK4IOq/jo1D/SslmQuqCFqC5WA321jfjgBd2R+AZ
         mUtVZyIyhnHxoo02fin2ykjl52/yyXTyuYsSybUsuDw1bKivFGQEgO1vNntpvxHn5l45
         KfjRs4ROYyYOI4PW43BVP7Wc9UVweXSu/JNdUwY5j16rpQofO2aaW/h/RFpodzCtGWwR
         Pc6Q==
X-Gm-Message-State: APjAAAV16aTw/q54gaidxV2BjhjcMDC1zyoWjKqN+KJh/i0Eveh9opXk
        QdOcQP3MDI18EafAolE0EqGM6w==
X-Google-Smtp-Source: APXvYqw1X7qNDFlYj4jvwmeG2WWFysHRDpXuEbesE6mFW8T5M+QtsFmK7JOVYM2LGBNyMI1n+JkGGw==
X-Received: by 2002:adf:df8e:: with SMTP id z14mr13236230wrl.81.1567888724304;
        Sat, 07 Sep 2019 13:38:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q10sm14082672wrd.39.2019.09.07.13.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:38:43 -0700 (PDT)
Date:   Sat, 7 Sep 2019 22:38:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 3/3] net: devlink: move reload fail indication
 to devlink core and expose to user
Message-ID: <20190907203843.GC25407@nanopsycho.orion>
References: <20190906184419.5101-1-jiri@resnulli.us>
 <20190906184419.5101-4-jiri@resnulli.us>
 <6ff0726a-f910-8107-883e-83476f80b9de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ff0726a-f910-8107-883e-83476f80b9de@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Sep 07, 2019 at 05:08:59PM CEST, dsahern@gmail.com wrote:
>On 9/6/19 7:44 PM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Currently the fact that devlink failed is stored in drivers. Move this
>> flag into devlink core. Also, expose it to the user.
>
>you mean 'reload failed', not 'devlink failed'?

Yeah, "reload failed".

>
