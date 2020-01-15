Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D7413C932
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAOQZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:25:46 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52908 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgAOQZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:25:46 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so561348wmc.2
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 08:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xSRyo3pqZWPHPCgepz0HHqhrmAXx+keSlsBHFo5Xx9w=;
        b=YXCRu0S40YcBF/zn46dxuQrFmEi2sYvmQYH3r2egs316LyMlSe6X9RG7mRLG0xsVeM
         APy8fgSMtBt0HDxUnewQc6wa7Xy4bWpp5RMc+S913R4SUge9sUgx29W97DxwoCQ5uuqX
         atvk43RIXUbj1h+Ay8oDW45MUxDm+JRW6mAX4I+5rc3Va632tNBEG1cj5nw3QEHYUvTv
         GtL8tmAZpmjZVe32R1uKvsIhQDDdYCuid9SjeVAwliB5Y9H2Ce1MskRpmK3VQvpqS5Q+
         phZEC4VjAJqqtxfCKa/TQmWrkdxWdLqZnbUYWPV/5bbuehhFpUjcukh3z9wT95nvOLgP
         x57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xSRyo3pqZWPHPCgepz0HHqhrmAXx+keSlsBHFo5Xx9w=;
        b=ltqTfLDctUro67d5i2Wn3holiQTVuyCciRnJwGfzxUry8UrDvBo16T14J+FMURA/sw
         msW1jrTQqterfTx3NAo4oQCdqnKGICrCCnTtqALgsfSh5JXp8tIBQQCtcVCuYCffX98V
         SLhJO3GfuLLcFtdCrioyKNSXl0uJTb8Cnr/yar7+DQNf84HickKubt3Ig2vYaATUyo6w
         DUKxxJTAqGZZozPkXhf66KiUUZ8DnPw54rCNTJ6g5TtoGKsUUcPOAe7JOT0AlYiJiUNL
         HyXF5eU4XkNu6pulD6JbxKKLQadrJ3jhN9/RUWXeOciDCztW/dDiWVF59QFwHkCa6ln/
         a5EA==
X-Gm-Message-State: APjAAAW83Lh8bHV96tOf8O3Hi+GdHW7wcttbw61xTFCUp9NUGvKSuGZR
        +PqWmviQgzWDGIz0Yx12RGXNkPSDqOQ=
X-Google-Smtp-Source: APXvYqyRnjtYQ2Q177J936BoDydc4IN5T8yYBqoetpgesahS1S7MeYI/xhaD07dB57NQBBGMUVYEzw==
X-Received: by 2002:a05:600c:149:: with SMTP id w9mr653642wmm.132.1579105543773;
        Wed, 15 Jan 2020 08:25:43 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:d497:1e4d:f822:7486? ([2a01:e0a:410:bb00:d497:1e4d:f822:7486])
        by smtp.gmail.com with ESMTPSA id f207sm494938wme.9.2020.01.15.08.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 08:25:43 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2 1/2] netns: Parse *_PID and *_FD netlink
 attributes as signed integers
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <cover.1579102319.git.gnault@redhat.com>
 <9a4228356eaa5c8db653c43467526a0dbd00ce30.1579102319.git.gnault@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <4eb09a3c-f402-ad05-3cff-049578ed0935@6wind.com>
Date:   Wed, 15 Jan 2020 17:25:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9a4228356eaa5c8db653c43467526a0dbd00ce30.1579102319.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/01/2020 à 16:36, Guillaume Nault a écrit :
> These attributes represent signed values (file descriptors and PIDs).
> Make that clear in nla_policy.
After more check, I also find these one:
$ git grep "NET.*_PID\|NET.*_FD" include/uapi/linux/
include/uapi/linux/devlink.h:   DEVLINK_ATTR_NETNS_FD,                  /* u32 */
include/uapi/linux/devlink.h:   DEVLINK_ATTR_NETNS_PID,                 /* u32 */
include/uapi/linux/gtp.h:       GTPA_NET_NS_FD,
include/uapi/linux/if_link.h:   IFLA_NET_NS_PID,
include/uapi/linux/if_link.h:   IFLA_NET_NS_FD,
include/uapi/linux/net_namespace.h:     NETNSA_PID,
include/uapi/linux/net_namespace.h:     NETNSA_FD,
include/uapi/linux/nl80211.h:   NL80211_ATTR_NETNS_FD,

Regards,
Nicolas
