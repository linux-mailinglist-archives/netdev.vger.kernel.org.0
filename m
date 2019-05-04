Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A45137D9
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 08:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfEDGp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 02:45:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35842 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfEDGp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 02:45:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id 85so3810238pgc.3
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 23:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=a4Ye/5WyqF2Ena4B4lY/mIysFtnDQdv8prHi7dv8pnw=;
        b=B+UXThiA56NQVM7z32bW6QFF7vrl2jYEejkRoOnKrp2WoAYo4zrtFLcQwDKV0HVyuR
         l1nmiOwIJ/kLOptZO4OZgN3fZAOxeJF/8U66NdgUAFvc0Hi0TFQK/bLsHhzbA3u418Ym
         UO14dTiyd9H6Ari/eJEFnyB6R6Mo3I1Usl8b5bA6IKQCfzN8HliZqQzcr5hqnD5S677E
         g17gQg77DawCpdhdR+thiVauE5XhIKspliz5BrP6tBI8kL8JQLL5iuvJD2TlXPtKcwUk
         FRj/WbMfuvkqfsTBOLHuEVLG0833m70elssJIbzwx8foQ3tkdoXVS72WoAPGoH2mFxuS
         n9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=a4Ye/5WyqF2Ena4B4lY/mIysFtnDQdv8prHi7dv8pnw=;
        b=G67SMC55Puq0pCR+GYnGTWXpdzQLyLNz4Hu4s91rcRhy7hM9IVGMIapjcIXy0XdKXN
         EeV8g3pXr/bFp9qsKL8r9MuZpb200kCC3pZb2eKLWHQY114/zx5P90ykySZUD/Uxw8N2
         ryG2TE2A8TsiZyzgVUepHH9pgsooJbmpv+i3G7WD1Hny5uiTU1ImVzV8fdpOfd+wJNWt
         9ZH1FKzWNLXWuMrOs+Us1dC/CQAzIKOgNnFshmIy5c5lHJppUe4LEmoWxblRai5Y6f9B
         hoT+MCfqho+anJEhwwfb9y81NzP1F4b4/HUpIPLMsIURzqmgh4yLdysvJM5Z82sqYlLU
         WfGw==
X-Gm-Message-State: APjAAAWC+ohxllBfxOSysoVQv8Jgu/wL0rCJKOTzoYn2+5Mdwlb5ya5d
        cPKfrVxB2f4cLJvXyNyn7LBkx6Ser+U=
X-Google-Smtp-Source: APXvYqxywmuAHP3bvS13WaLAzGuDFomXCdp55caj5jhipr9rICYIAl1ZA46WMT0pT4ccqnwxoKC/2A==
X-Received: by 2002:a63:8242:: with SMTP id w63mr16339440pgd.169.1556952325148;
        Fri, 03 May 2019 23:45:25 -0700 (PDT)
Received: from cakuba.netronome.com (ip-184-212-224-194.bympra.spcsdns.net. [184.212.224.194])
        by smtp.gmail.com with ESMTPSA id b128sm5074469pfa.167.2019.05.03.23.45.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 03 May 2019 23:45:24 -0700 (PDT)
Date:   Sat, 4 May 2019 02:45:11 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add warning in case driver does not
 set port type
Message-ID: <20190504024511.314c580d@cakuba.netronome.com>
In-Reply-To: <20190503113153.3261-1-jiri@resnulli.us>
References: <20190503113153.3261-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 May 2019 13:31:53 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Prevent misbehavior of drivers who would not set port type for longer
> period of time. Drivers should always set port type. Do WARN if that
> happens.
> 
> Note that it is perfectly fine to temporarily not have the type set,
> during initialization and port type change.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Looks useful and I have no better idea on how to implement it, so:

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
