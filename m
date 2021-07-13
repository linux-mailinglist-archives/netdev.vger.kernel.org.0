Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF483C7488
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhGMQdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhGMQdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:33:15 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEA6C0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 09:30:24 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w127so29236431oig.12
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 09:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/gHdUi6n5Ezb9MPFzOpPgJTrpLfwXAaz00YiNBQfdpc=;
        b=Iv5f6XMy36yimha8NU+x8AIcFBriwMpcOr4PIR/Pr9Jfwyn6BF3Wg5Uyd9NQd6pX8e
         mSiP+dCzZekIeaBiNDuyWmMWQ9Ak64prJLqpd5F91lWOBbfKBf1+P0fCHwb67+B7lpql
         ZSJBnUsyQtk59hLda7TQ8zH7tI7AAZJ5CYbpQqM7ruq8MCyGg1gAfX/1nypv+G7PFxt3
         CLWXTSSFkh2VMt+PnDLPGfhoO8zo0GOr6yao9ZkHinBlrRy9P/uWxl3qmxkkgs07JVgY
         ot+dzdGJTLX36IAOB9+eXTX+oT3FdPJp2lpfQG4ewJ3Cfn0p0xVWMW2LmrmvqBihXyES
         zHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/gHdUi6n5Ezb9MPFzOpPgJTrpLfwXAaz00YiNBQfdpc=;
        b=cWuyUJcxC6FbNYIDbVCTy2IqxbzcOR11mO+z1qy+lOEGL5vBTARHAET+BB5zZFhc7R
         S8SZZZp3yGHuaaPK1f69B23dDyben4V8Bbz2FNuPw332dIgsceTe+wh5UlZ4XXfO3miz
         yOt9fTiLXXVIU1VBlFKVyc3VFcwPzJyzXdvDYu8Tszo2UgsfTBdBrTYAwpx9cgbz3+yq
         KfciLN1g/FqsUXvYZqjM/dZgYFozdVOtPYTEUOFqNB24uaX7TdAjbfl5oCQjVtJERNck
         dUE2pFoxx2xZtDutn0qb7PwaIA7uNNMpcKc0BPKqW8VC68sSN0vL0S9lTcvwQUQuhvDc
         KTjw==
X-Gm-Message-State: AOAM530cJChwLV4Dqvf0Ttfqq3/1p/Zn5FfctKLuXeOmswV0AZ8hYqSG
        30TIZVAMbeSGeu6vsqU4j3l8/SkbCWwNCw==
X-Google-Smtp-Source: ABdhPJxIJNEVhRmcTo2KjguWPe/KtT18C7kSyxvYEwE2ZZE5kmWZ97RmVD8w7HvqeRaRunlXIxerUw==
X-Received: by 2002:a05:6808:20a9:: with SMTP id s41mr157166oiw.25.1626193823358;
        Tue, 13 Jul 2021 09:30:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id v8sm3933755oth.69.2021.07.13.09.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 09:30:22 -0700 (PDT)
Subject: Re: Patch to fix 'ip' utility recvmsg with ancillary data
To:     Lahav Daniel Schlesinger <lschlesinger@drivenets.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0644F993-A061-4133-B3AD-E7BEB129EFDD@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e3cbedf-0ac8-8599-f713-294733301680@gmail.com>
Date:   Tue, 13 Jul 2021 10:30:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0644F993-A061-4133-B3AD-E7BEB129EFDD@drivenets.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/21 2:09 AM, Lahav Daniel Schlesinger wrote:
> 
> 
> A successful call to recvmsg() causes msg.msg_controllen to contain the length of the received ancillary data. However, the current code in the 'ip' utility doesn't reset this value after each recvmsg().
> 
> This means that if a call to recvmsg() doesn't have ancillary data, then msg.msg_controllen will be set to 0, causing future recvmsg() which do contain ancillary data to get MSG_CTRUNC set in msg.msg_flags.
> 
> This fixes 'ip monitor' running with the all-nsid option - With this option the kernel passes the nsid as ancillary data. If while 'ip monitor' is running an even on the current netns is received, then no ancillary data will be sent, causing msg.msg_controllen to be set to 0, which causes 'ip monitor' to indefinitely print "[nsid current]" instead of the real nsid.
> 

patch looks right. Can you send it as a formal patch with a commit log
message, Signed-off-by, etc. See  'git log' for expected format and
Documentation/process/submitting-patches.rst in the kernel tree. Make
sure you add:

Fixes: 449b824ad196 (“ipmonitor: allows to monitor in several netns”)
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>

and make sure Nicolas is cc'ed on the send.
