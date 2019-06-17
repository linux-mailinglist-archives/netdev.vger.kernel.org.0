Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CFD48363
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfFQNDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:03:30 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42844 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfFQND3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:03:29 -0400
Received: by mail-io1-f67.google.com with SMTP id u19so20860966ior.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iNZq0PlUL28AjOmH3qz3+Tr2kGyXNRhuchR9BCw1b7Q=;
        b=RJ6r3y0TrSrmhPXIBNrppFK0R4WHRzDCfE9Jxf3bRmEuOEXov4PmLIEXTD+aezj0Zk
         zIqBjXipbOSrE39NtsKd5jP7rKfiQucfQWXIBPNbQYHIBQ9Z6fviaI7FR6YCbXG1p2in
         SB2g79yH2Q1Yc8LBy5t8ewwDICWM6mRHcK0fJ2xLk9O66m+hRqgh81VJ/h98Ppb+Q9+C
         +wZams9DElXQ7owk236iQGjtehomcJyg/kmOK5dFoehiHfPmEDbzWfvWoLoj4F7Dqtup
         sdw6kTI68Xgp7KC6pV/ukgLYn9ldBiRFhs0bPah6FpB2+yC5iwp9wSFiF8RimvIAR0+Q
         7abw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iNZq0PlUL28AjOmH3qz3+Tr2kGyXNRhuchR9BCw1b7Q=;
        b=fQ4odvhZeYVj2QJuGcOYGf0yYkuj+YViYdK2F2nSd5JLE0wdVD9yYd2zbUKPkK8cTc
         PFMYNWz8tIB8yGBjn/aCclKdWqg6iER5JDfort/gSInkxP57g/Fl6NM9yJWrt7NmZGi6
         PgtwHPLRrDbF0racm7yTrqr4shJpvLXgAgb056vRVT4rR+/VX+mr7y+TGoJtZHJ0Mg9L
         SlflUe4tEf1IWtO+blDYKlQgzyYM4AWHaKZrweHe0FyoKp1WKslbecF1EL2EDHQ6wIEy
         YN7uZQtijZWPDCy7Zdq3F6/7wY1cSSIjD0Tnj4a2vrKga6V58IybAoNvQ/xmkfta+I7p
         TpAg==
X-Gm-Message-State: APjAAAVmTfiNYjy2tTXx/9d6f5KI6dqMei1ve/xmnNc+fv/Vhb9KC9ag
        Bdtjf8Ew/sdpU9MXgOs4tM8=
X-Google-Smtp-Source: APXvYqx6tQDAdnP4xfP6WWJLmn17lh5QbwE0LLo6AaJFB+6DEwvev2mnBcgPY0TPJRttcBHRbWor/Q==
X-Received: by 2002:a02:7695:: with SMTP id z143mr78971247jab.135.1560776609190;
        Mon, 17 Jun 2019 06:03:29 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id 20sm11892387iog.62.2019.06.17.06.03.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:03:28 -0700 (PDT)
Subject: Re: [PATCH net-next 07/17] ipv6: Add IPv6 multipath notification for
 route delete
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-8-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f11e4835-23d8-bc4a-1157-44d33eb03370@gmail.com>
Date:   Mon, 17 Jun 2019 07:03:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615140751.17661-8-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/19 8:07 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> If all the nexthops of a multipath route are being deleted, send one
> notification for the entire route, instead of one per-nexthop.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv6/route.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


