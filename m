Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735BF69D1F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbfGOUt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:59 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33085 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732750AbfGOUt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:59 -0400
Received: by mail-pl1-f174.google.com with SMTP id c14so8883090plo.0
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 13:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mc+jizhnLlSmQoVOvYZGx7SYSpOs2DGRrAIp2HmZQWI=;
        b=O7zrLW6hNGBHMzdw3Q8MQFhj8IeS/OeJ180IWkSFGfRQqimn2khazAqptt3GWtRIfa
         FWvZZVY/hPluV3Ybjiltg9Q9XNWHjZIHC/9kWbxCyPLK0efQuPhC7ZGXpVGiPSEk1QOo
         LKknoMfH6WOtB27dPcqEHybUrUp2x0CiSRi7hxdvXkf5HYw9TqRpSe7/xoJo6xkfSDty
         UGflk+TxP3PTSNBvN30N9onhoEP6p+06wpU+W4bkScg5KBZodTZ+uDA2qzcE7SYHHj2P
         eWBgrP98WdOLdfKJh2X5U4dqBrP5HM/pwsVln42T7f222JYmlAMpEFk2uTSbGYQrsHhE
         YAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mc+jizhnLlSmQoVOvYZGx7SYSpOs2DGRrAIp2HmZQWI=;
        b=qH3jbiAOr3w5HhX9JFirOyCu2yi+D4kbmbmqyeJYYLnidhI3rCPIuPU9cVlJIaD3lV
         gw3ed4iNfCIf16AyiXM3pnsJBWZiywtmX8OwCAuAsBTKHndmIATzvoea/BOFRNnGTsUx
         U1phuxPpeDYSbbJXsdPHjhHI3g5ppYD4ytXFtCtM7wm/1LrQ0UHPgCJPxAEVJZpX+dqh
         do4SCi6T9Czd/0WE0ykB4joYgcmC7pKoEnJwXvoUEZXmwPrLzXIMWEFiQI6e0SSLwfKa
         sxqgOQC4DQDWRss+B6wVRK4QFFqyodjcVR8Kkb5wRMpsKt3iumfYwfME7AZnu5nmfyQS
         BaDg==
X-Gm-Message-State: APjAAAX4ExStek6w3HTOQXJoNOIW2z47DL764+Gr0iY6TMLlwhiYDJH0
        8c3mEso7cG+LSErD525XYvY=
X-Google-Smtp-Source: APXvYqy9UKdcrcWBCQPjIzySQ0kUxf9d9tZRsexxzx8aDq5kMM1d7hJg2ICTXO4y4a6kum+CzlLBLg==
X-Received: by 2002:a17:902:b20c:: with SMTP id t12mr30781878plr.285.1563223798408;
        Mon, 15 Jul 2019 13:49:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c98sm18369830pje.1.2019.07.15.13.49.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:58 -0700 (PDT)
Date:   Mon, 15 Jul 2019 13:49:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 v2] utils: don't match empty strings as
 prefixes
Message-ID: <20190715134956.1e7af534@hermes.lan>
In-Reply-To: <20190715180430.19902-1-mcroce@redhat.com>
References: <20190715180430.19902-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 20:04:30 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> iproute has an utility function which checks if a string is a prefix for
> another one, to allow use of abbreviated commands, e.g. 'addr' or 'a'
> instead of 'address'.
> 
> This routine unfortunately considers an empty string as prefix
> of any pattern, leading to undefined behaviour when an empty
> argument is passed to ip:
> 
>     # ip ''
>     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>         inet 127.0.0.1/8 scope host lo
>            valid_lft forever preferred_lft forever
>         inet6 ::1/128 scope host
>            valid_lft forever preferred_lft forever
> 
>     # tc ''
>     qdisc noqueue 0: dev lo root refcnt 2
> 
>     # ip address add 192.0.2.0/24 '' 198.51.100.1 dev dummy0
>     # ip addr show dev dummy0
>     6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
>         link/ether 02:9d:5e:e9:3f:c0 brd ff:ff:ff:ff:ff:ff
>         inet 192.0.2.0/24 brd 198.51.100.1 scope global dummy0
>            valid_lft forever preferred_lft forever
> 
> Rewrite matches() so it takes care of an empty input, and doesn't
> scan the input strings three times: the actual implementation
> does 2 strlen and a memcpy to accomplish the same task.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Thanks for following up. Applied
