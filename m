Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1872AC72F
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394725AbfIGPJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:09:04 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:36037 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394720AbfIGPJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:09:04 -0400
Received: by mail-qk1-f173.google.com with SMTP id s18so8692288qkj.3
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 08:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AH9bJIvZLEAG28YHMrQhCuEq9Ekl+yLZVXD2wMBh4y0=;
        b=ITecdM74qjDzM20QCnSzlgFYoddy8tSZyBDex9crL05R8eGXDzUxewhva9hPctmh6d
         AE0b8nvA17Hg2HxNfrV8RFOkiS9UMV/y7xSX7F9J8TKKZOZ3wRWyW4tLw/3m41y7jT5O
         C7TRhwaFEWxvh6P82qGoiCX9YFKjbBr4wUQFkeqo/pOCWFk23s2l2DH9DSCM3HysosjN
         sH9uxDG9WWQTeDF1r5MWaYwYjEvH5FPKQnK3J+xJ5+uPSmKf3ZgdPdaI9nCueAB2zStu
         Fgaoni5oseRjbfIzYRQCgPZ/dng4WwUACzX7QUOEabv5bztYAInQTx8Gga5vaR8KvS8d
         bvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AH9bJIvZLEAG28YHMrQhCuEq9Ekl+yLZVXD2wMBh4y0=;
        b=NfFaLXpN6KFqylvQq8R03DdXZZcZVgHa5K/kCZV10JSLzAkK7SmyFJmfW7AHILZumJ
         NlzdULB5OfAdEDDcn58+0+LHm5bI3lyRa6xD+XIxOlGkMMldWaBnRxLotxsaEpsGscIV
         rO7lGfJVWSAIcR2WXdlFjBwUu0pEIr0FAMNnxS/huck1m+VsBCw7uCf5Xc6fwaDEOfxu
         GBsOKzh+dd2upB3CVlFyhst/om4uVOhWB5CY2qC0t9/OY6qHqfkBje/Vmgq+WISol0N5
         twBvpnzdZW76Q7o4lFVsISTd7rU3wIDJF5XKZp8L3F0KacjyBruTUbKHb/Z9teMRORXL
         py/g==
X-Gm-Message-State: APjAAAVNTGLpXnk+xkBNEn0k5JUkqWNjkYUVhwc1oQT8wvTAq/iazkps
        h72mf41ufkSvGWETtPyazEM=
X-Google-Smtp-Source: APXvYqxWD40MZ4IEYVpgViDq+XnJgSUi9fRfkfEVKsTuBOR1GsM5UaABhg0hSr3gi+/KZeERdgh+bQ==
X-Received: by 2002:ae9:e90c:: with SMTP id x12mr14686317qkf.142.1567868942600;
        Sat, 07 Sep 2019 08:09:02 -0700 (PDT)
Received: from dahern-DO-macbook.local ([88.214.185.220])
        by smtp.googlemail.com with ESMTPSA id m7sm3883228qki.120.2019.09.07.08.09.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 08:09:01 -0700 (PDT)
Subject: Re: [patch net-next 3/3] net: devlink: move reload fail indication to
 devlink core and expose to user
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
References: <20190906184419.5101-1-jiri@resnulli.us>
 <20190906184419.5101-4-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6ff0726a-f910-8107-883e-83476f80b9de@gmail.com>
Date:   Sat, 7 Sep 2019 16:08:59 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906184419.5101-4-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/19 7:44 PM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently the fact that devlink failed is stored in drivers. Move this
> flag into devlink core. Also, expose it to the user.

you mean 'reload failed', not 'devlink failed'?

