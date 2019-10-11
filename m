Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA2BD36B0
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 03:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfJKBGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 21:06:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39497 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbfJKBGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 21:06:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id 4so7413422qki.6
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 18:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=DeTiHZ4g25Y7EeJsfpuYikSF554R26MDT8EMfYqzayo=;
        b=lezI6apK9RMQTMMqvv0foePL3EKCMS42wnMDoYH12O/ZLkNz4MVdJ2/nKMI8R9nkAC
         UaRK4Vepx+c8KwUvZK0qDRBa1KjrpMP4LZ93ClxNfYiSQ8nrBdNYXAd82T2I3HK8Ni/3
         s845xXCsQR5dAzisdV8ikOSxLiB3fp+Pswo1NBOZ3FYa5Ub434b4Tsa2UYV+OKv8YGQz
         DtoIuWF01XECVVxGOW/90m0CudrMoT/vnZXAqr92tPXD1EKDLCUBfPI1EZHXiE+nMXl4
         43D3KPY3B0EvQF+U6oMBC+Pd8ge3Ssrs1akgdmKouW1Xho+HTaVR4LI5UgMd86MEnolY
         9Blg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DeTiHZ4g25Y7EeJsfpuYikSF554R26MDT8EMfYqzayo=;
        b=B4ZqJ/kXSZjZvIGOtLepwOFK0OJXbG8TZ0IrY/NoZnr18KxYIN33qi4AJOA/tgnPaG
         GVC7SD38FcKYKZI0OcjgjSHAQzWfUoyxyWCQHAMIRrBl8BKv20meuDDPYCphHG02oQkh
         3ngi3Rdp/O3vz3W0Y3fm5CwBxQIoV05Z/cRR/SfIGuWChP/DkXjvxk3KS8SRFujL4eXI
         Ln/dip6yneb5/DSwI1BZgNhc9HCCEBvXohcPqR+vJvFiRMlWX6tWpC9kQiwZ1c0vp8mO
         3LvoI4OTpxHaEIXbqd+zoEfZJXOvgTAHTWzu9meFR9EgMEHKiZTKEXP8KwV/kkX2Z/EZ
         usmQ==
X-Gm-Message-State: APjAAAUMQptNvomirbJ3bi+ZzuSeb7gN+Syr0dMLxiEIOWw8j0Icrm5m
        t2JApytG5yfLBlPoCMHH0U85uA==
X-Google-Smtp-Source: APXvYqwfsMzYkP7WLJ3n1tPJ+uZGxCDDWj/fAGT0V/Ea3yKnR7OVgrqVbv5WC1ISSAzgfPbKVLx4+A==
X-Received: by 2002:a37:4253:: with SMTP id p80mr10937252qka.194.1570755973159;
        Thu, 10 Oct 2019 18:06:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w6sm3276414qkj.136.2019.10.10.18.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 18:06:13 -0700 (PDT)
Date:   Thu, 10 Oct 2019 18:05:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH next] ipvlan: consolidate TSO flags using
 NETIF_F_ALL_TSO
Message-ID: <20191010180557.707f4bdf@cakuba.netronome.com>
In-Reply-To: <20191009232011.240381-1-maheshb@google.com>
References: <20191009232011.240381-1-maheshb@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 16:20:11 -0700, Mahesh Bandewar wrote:
> This will ensure that any new TSO related flags added (which
> would be part of ALL_TSO mask and IPvlan driver doesn't need
> to update every time new flag gets added.
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
