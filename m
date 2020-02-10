Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26362156ED6
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 06:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgBJFbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 00:31:11 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41388 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgBJFbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 00:31:11 -0500
Received: by mail-qk1-f193.google.com with SMTP id d11so5365970qko.8
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 21:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Upu6vXZeTCE2pAhxA74OMZtygRpKjpyWXgRMJ2iitlw=;
        b=WFxyTYRtkojX+RL0yya4zsbVoVLlbTVA2ZaqraRhqJw84UPW2CqI1pkm1TcTA7v7ud
         WZTxtOoqxbBlN8V7h9YV5b4gL9qS1Se9zXayajv4Lg4bKhbI8eXlnC7E0isfaT3EUbV0
         O5vV1BS4L3mY/KwPfXMthapNBO5mgYta4ObPNfNuETOfGqfz5g8O709g7k8UX1QWjNho
         VnQskeHUY840boM3gVjx1bhP61n/n5vqTQu2ly9qXXl55AM9AlzqKYy+1TOkhmhWp0bJ
         evCx5e3st2WxBVaETHFJoYNrA4GT6hZvxXCtynWYeyCj+Hjb7yIOrg70m8CHx0eeRFyT
         Ni0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Upu6vXZeTCE2pAhxA74OMZtygRpKjpyWXgRMJ2iitlw=;
        b=RCQLuTYIJa/B9JY7cRSYza68yw/j07L9x9DQsecSzJRXBNCSTqjwCMMqo/iS6SvKzI
         kIbr7ASrm9C8HIJToUIB9Md89MLv2ObGr01/fIHWkmcC0Diuj7mKSeq/QibpdFYBHghM
         JnvSOn+euvLrcSS6Eg3iemqkEah/OwGglk/gdoBTtmEqQfk9PByy/dPffav9FxAz5FAu
         fbqq5/VPe6MDFx1QU8/gq2hQQ4dCu9iWrYuu20g52tv/LXDnoM1LzSymBypX66fAEk4h
         qPPmu1GLUvaCh1Y5W89AltTDSnk2H3EI0wJ7IX1TlAdMX8eFLu/VikTj5+pHMUdEM6sB
         PBaw==
X-Gm-Message-State: APjAAAWTB6zEsvv4Ozvy/NOkg6DrGWGshAs6qXVECYHj8soStRprD+Em
        Bm6xGY13Odb/dNHRVR5dudI2lb/Z
X-Google-Smtp-Source: APXvYqyE/+4LzAHAHOVE5H6VFSV04Tg4Y58QeFqDIWYVd7uoisLVyATUpJu+Wb14+fE4QMLg0MFBKQ==
X-Received: by 2002:a37:8e45:: with SMTP id q66mr9298331qkd.129.1581312670100;
        Sun, 09 Feb 2020 21:31:10 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:ecaf:dd70:4bb2:820f? ([2601:282:803:7700:ecaf:dd70:4bb2:820f])
        by smtp.googlemail.com with ESMTPSA id f59sm5538872qtb.75.2020.02.09.21.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 21:31:09 -0800 (PST)
Subject: Re: [PATCH iproute2-next] devlink: Add health error recovery status
 monitoring
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>, netdev@vger.kernel.org
References: <1580852222-28483-1-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4f9564a4-fdba-e2a5-778e-98dc414da2d9@gmail.com>
Date:   Sun, 9 Feb 2020 22:31:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <1580852222-28483-1-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/20 2:37 PM, Moshe Shemesh wrote:
> Add support for devlink health error recovery status monitoring.
> Update devlink-monitor man page accordingly.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c          | 15 ++++++++++++++-
>  man/man8/devlink-monitor.8 |  3 ++-
>  2 files changed, 16 insertions(+), 2 deletions(-)

applied to iproute2-next. Thanks
