Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6E93A4CDF
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 06:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFLEmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 00:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhFLEmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 00:42:02 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2BDC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 21:40:03 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u11so8088504oiv.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 21:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/bNJypyILWJRiJof5Hzmdp6rFylQ1GYiaRupnxAGT+8=;
        b=Wwco+iPb23wPr6T3ejUk5dIoQPxBuhn9OlNKP0xtu1YXFhRv0NsuLcT4h5mr50Fk3D
         bAa7eCgKrZBGMSgRIp/VSisuSH1qbIRwRkrXcXLAG1NlrcP8PRMN7r32fOkWHQb1N//l
         /IA4hxIg1oNQv0cY0Ur2k+PQmpROMy7BDf1GVYst+NQiAJ/cyYadiPt0JwdSfi2BEg7u
         TBmOQ7T8VoPCciMQJPt97HpC/TE51Isj//ZLK9lAk2guSI6QQPCZrdiyxy5cRfjj7yiO
         4enSZpwABgg/qRHous4Le2/CGtwo+YNRmCUktruBuPOL/FdcxaWg65Y8Rp31iAeO77Qq
         /pCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/bNJypyILWJRiJof5Hzmdp6rFylQ1GYiaRupnxAGT+8=;
        b=OWTH5Z4XAwceZc0MoJeW6LBdf9pf4QBFxHJcDXIz97P9/1i9ksbuvjsQQpMB60wprq
         p3QQfjreB1EmuMpRnxla/2KV8iLRbruf+SjmY0gKKT7NAxnF4H63JDn2yCWqgbhGYXP5
         BwWA9u8mabP127ZLprr4szaKCA2iQyFFOl7ROxvbHctmrHGRVcyHXXdwNkZ4TPXeV1ZA
         LWtlcrli/8P1wGoZngDw0CQes4+jTBT1wuSta4CK6q7TmRUl4KX7rR96BHY/nrOWQjs+
         uSM/ghRxjSPfpP4PQqAGjk+2kyqAXCFix68E+9z2awPN6q6yZ+vApBuV6TIYXlOg8Ff/
         PG/g==
X-Gm-Message-State: AOAM533QeNeCwifiikVM+qKbZq4Z1HnqVhBnm+VwuwqiqX90AzZ1UTy8
        DnqLdU78Gzgu0IcEk+w8fpQ=
X-Google-Smtp-Source: ABdhPJyJgcF8KI0KzRwY6B7J/8+g9R3vnthoXF237hTuhv0kYg4GQSb+kh5AJmoMqVOtYWT8dLYZGw==
X-Received: by 2002:aca:f5c3:: with SMTP id t186mr4552240oih.97.1623472801968;
        Fri, 11 Jun 2021 21:40:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id n7sm1578083oom.37.2021.06.11.21.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 21:40:01 -0700 (PDT)
Subject: Re: [PATCH RESEND2 iproute2 net-next 0/3] devlink rate support
To:     dlinkin@nvidia.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        stephen@networkplumber.org, vladbu@nvidia.com, parav@nvidia.com,
        huyn@nvidia.com
References: <1623396337-30106-1-git-send-email-dlinkin@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <437c3d79-ed18-ee9f-cfb7-615da1e68f36@gmail.com>
Date:   Fri, 11 Jun 2021 22:39:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623396337-30106-1-git-send-email-dlinkin@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/21 1:25 AM, dlinkin@nvidia.com wrote:
> From: Dmytro Linkin <dlinkin@nvidia.com>
> 
> Resend rebased on top of net-next. Dropped header update patch.
> 
> Serries implements devlink rate commands, which are:
> - Dump particular or all rate objects (JSON or non-JSON)
> - Add/Delete node rate object
> - Set tx rate share/max values for rate object
> - Set/Unset parent rate object for other rate object
> 
> Examples:
> 
> Display all rate objects:
> 
>     # devlink port function rate show
>     pci/0000:03:00.0/1 type leaf parent some_group
>     pci/0000:03:00.0/2 type leaf tx_share 12Mbit
>     pci/0000:03:00.0/some_group type node tx_share 1Gbps tx_max 5Gbps
> 
> Display leaf rate object bound to the 1st devlink port of the
> pci/0000:03:00.0 device:
> 
>     # devlink port function rate show pci/0000:03:00.0/1
>     pci/0000:03:00.0/1 type leaf
> 
> Display node rate object with name some_group of the pci/0000:03:00.0
> device:
> 
>     # devlink port function rate show pci/0000:03:00.0/some_group
>     pci/0000:03:00.0/some_group type node
> 
> Display leaf rate object rate values using IEC units:
> 
>     # devlink -i port function rate show pci/0000:03:00.0/2
>     pci/0000:03:00.0/2 type leaf 11718Kibit
> 
> Display pci/0000:03:00.0/2 leaf rate object as pretty JSON output:
> 
>     # devlink -jp port function rate show pci/0000:03:00.0/2
>     {
>         "rate": {
>             "pci/0000:03:00.0/2": {
>                 "type": "leaf",
>                 "tx_share": 1500000
>             }
>         }
>     }
> 
> Create node rate object with name "1st_group" on pci/0000:03:00.0 device:
> 
>     # devlink port function rate add pci/0000:03:00.0/1st_group
> 
> Create node rate object with specified parameters:
> 
>     # devlink port function rate add pci/0000:03:00.0/2nd_group \
>         tx_share 10Mbit tx_max 30Mbit parent 1st_group
> 
> Set parameters to the specified leaf rate object:
> 
>     # devlink port function rate set pci/0000:03:00.0/1 \
>         tx_share 2Mbit tx_max 10Mbit
> 
> Set leaf's parent to "1st_group":
> 
>     # devlink port function rate set pci/0000:03:00.0/1 parent 1st_group
> 
> Unset leaf's parent:
> 
>     # devlink port function rate set pci/0000:03:00.0/1 noparent
> 
> Delete node rate object:
> 
>     # devlink port function rate del pci/0000:03:00.0/2nd_group
> 
> Rate values can be specified in bits or bytes per second (bit|bps), with
> any SI (k, m, g, t) or IEC (ki, mi, gi, ti) prefix. Bare number means
> bits per second. Units also printed in "show" command output, but not
> necessarily the same which were specified with "set" or "add" command.
> -i/--iec switch force output in IEC units. JSON output always print
> values as bytes per sec.
> 
> Dmytro Linkin (3):
>   devlink: Add helper function to validate object handler
>   devlink: Add port func rate support
>   devlink: Add ISO/IEC switch
> 
>  devlink/devlink.c       | 527 +++++++++++++++++++++++++++++++++++++++++++++---
>  man/man8/devlink-port.8 |   8 +
>  man/man8/devlink-rate.8 | 270 +++++++++++++++++++++++++
>  man/man8/devlink.8      |   4 +
>  4 files changed, 780 insertions(+), 29 deletions(-)
>  create mode 100644 man/man8/devlink-rate.8
> 

applied to iproute2-next. Thanks,
