Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D0212A33E
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 17:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLXQko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 11:40:44 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35987 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfLXQkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 11:40:43 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so16927245iln.3
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 08:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YQJnjfy+wiFZmrjQ/8XtNAKfDBwifFSG9Qj4ezMxuTE=;
        b=J4oDkKYk1wei2mVKTNAwNYZ4lMnFVTeC/+aHsyYcznSWHzNAYIeodQ5laPqOr97oG2
         fF9TmNgc+2EOCwhaEB8t/rDrxe+U2BM1oWp1ubw22bkSXnyw6/eepJG63VrDKRfT396T
         hi+6aemDVfKtPwITarXAXl7WZ49FjQuFLvyUOsXDrX3a3dy1gsdlnQ78GHDAtwobfVkc
         2OOKej3fgh5IF6DcEC6MmVxSi6nMFNNk3q89cJP6wIDQO7FgjIa5FwecwGd0ODhW3JnC
         BV+j05ZAwZfN+I1bpfSvZ23XFdv4hhZbbkw76PWHARfWNL5W/QPxqPqGGqwlzo2FE62Y
         ltBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YQJnjfy+wiFZmrjQ/8XtNAKfDBwifFSG9Qj4ezMxuTE=;
        b=LSNxm549ytiABdQa6hPW3x6RHlH5xkCZRxDYHmuXNNtrha90G1sKF5UGF+ZZonKtUU
         Es6s8Av73Af5739pRv0nDaYrFf2xVR+XqxL1qcWOAEw4xpt+1jWMXHdVWj+uVLbjCmrn
         H4zr6gnX8M2H0E5oZO8LVLNnTqM6tdaAKfL8wK9TwM0pUg4SKVdlL82X5Q2FQRRoPxBR
         CrDF+AyD095MOzDyzT+5ZVjz1h3A4JIOLYC1jMmPu6zIWxehenOwWTnvq7WVwYIhR8Uv
         BLOlIBTNPkVkab+G6xFfJrNeuOAGMDwEvKQuZV0KOvfWA9DZvMNVceE4wdJH8y8ryHAD
         NXfw==
X-Gm-Message-State: APjAAAUlA5fTmRjPdOwgPM00IiGEjxog280qOk7G0lm6vTCPzBeSjXrc
        mlibGqt6S6HrI1eFykGO8a8=
X-Google-Smtp-Source: APXvYqz/sZrIqsbRD54q1xy03o16CdIMr6krljIHSHtkLlfBoqSCIe2zA7DX/uUOr7D0Ug3zMD5/rA==
X-Received: by 2002:a92:ba8d:: with SMTP id t13mr30295602ill.207.1577205643118;
        Tue, 24 Dec 2019 08:40:43 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id q11sm4358564ioi.25.2019.12.24.08.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 08:40:42 -0800 (PST)
Subject: Re: [PATCH net-next 2/9] ipv6: Notify newly added route if should be
 offloaded
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e679e494-ed27-7089-9b29-9e73bc98002f@gmail.com>
Date:   Tue, 24 Dec 2019 09:40:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 6:28 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> fib6_add_rt2node() takes care of adding a single route ('struct
> fib6_info') to a FIB node. The route in question should only be notified
> in case it is added as the first route in the node (lowest metric) or if
> it is added as a sibling route to the first route in the node.
> 
> The first criterion can be tested by checking if the route is pointed to
> by 'fn->leaf'. The second criterion can be tested by checking the new
> 'notify_sibling_rt' variable that is set when the route is added as a
> sibling to the first route in the node.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv6/ip6_fib.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


