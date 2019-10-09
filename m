Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D83D0936
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfJIIIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:08:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45639 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbfJIIIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:08:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so1561367wrm.12
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 01:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jUJPOe6LYpyVaR7l8s0f1haor3q9DdrYmlzFu61iy+8=;
        b=Ok5x5E5qabpDeD0OlQwKEvftKU9l2Ehl/1FOHpCccQaprRjN/Vz2LjDWr5DIqcyRm1
         AUo+sHUwJN55BkZ6tr+qsK/l349psBjdm8crQ/aB4taAES0lv1E2b/+ipgRFsp4WQYCo
         Wp+s3d5nMf6gFn+uuctPIhJ3ArLUm8JtvupEFm+siXG6/gNsCcxx24aAYJqhuFFZteuL
         lIZ3LenF8z03BJgX6KSiznZNkWO2svQ27gegdpOjt5RJWNL2R2XNKFCcRZm57HMBD/P+
         MvWUB937yDKDazhOXuxGfiGpNcWHlAcsR4MWkKDiNQcaqu0wJ+hsFbiQ7MFDsO3X460d
         a70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jUJPOe6LYpyVaR7l8s0f1haor3q9DdrYmlzFu61iy+8=;
        b=PMPTMpzkTrQOyADeRTA8CXA9h7Bgb3kEapVw3I6vm4CDoNoyA186xF9P9OBw3fJwYt
         4Z7ICLH44QGRgSDo1D50uHn02jZ75T+UZjRPupIbl7Ob/i+ipPZHZ1NMRaiZbsaZNlJD
         8XOpSTwtvDyRTikzv8v6BE/L5kOvqpSKFmRf862M9+jlLYkUTn8Az6m/KlsDz0ikSkyg
         dY2VtX1PGTwOiHu8r+Za1AspPE6kexoBMAt5SJ68nNHT2IhdYIITlY8KHzsLYQCaBvSH
         oO6uWZuhJFws/aQOUWqOCIbbadSnFL65IhxVygmyZvx6adH3M8G8qx7BBXjPfMafOL56
         3kFQ==
X-Gm-Message-State: APjAAAUamD/mNnQWGrSHjcRUAiEhx6Njfqhskb1Ld9FickzLt6a9kIND
        cS/FiFoL8rKcnst1wBQTOvRTxmWcYXY=
X-Google-Smtp-Source: APXvYqwC/R/n/I2vwyphSmdTTuk4yaZzUKM9HkJutgiKoM49fJmodyBCU7e0uxg/RfEg7Vfswhx3qw==
X-Received: by 2002:adf:db4e:: with SMTP id f14mr1714793wrj.7.1570608477732;
        Wed, 09 Oct 2019 01:07:57 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:bcae:7ddf:4c4a:1f5c? ([2a01:e35:8b63:dc30:bcae:7ddf:4c4a:1f5c])
        by smtp.gmail.com with ESMTPSA id v11sm1255489wml.30.2019.10.09.01.07.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 01:07:56 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20191003161940.GA31862@linux.home>
 <20191007115835.17882-1-nicolas.dichtel@6wind.com>
 <20191008231047.GB4779@linux.home>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6ff5601a-4352-7465-78be-c01a78b27c33@6wind.com>
Date:   Wed, 9 Oct 2019 10:07:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008231047.GB4779@linux.home>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/10/2019 à 01:10, Guillaume Nault a écrit :
[snip]
> We also need to set .portid and .seq otherwise rtnl_net_fill() builds
> a netlink message with invalid port id and sequence number (as you
> noted in your previous message).
> 
Yes you're right. I don't know why, I had in mind that nl msg sent by the kernel
should have the portid and seq number set to 0.
Will send a v2.


Thank you,
Nicolas
