Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124104DC97
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 23:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFTVbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 17:31:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39715 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfFTVby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 17:31:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so2386957pfe.6
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 14:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LZKhWu5rzgWFMxJcBgmnI02JbwUBvtkff5v0cavArRE=;
        b=L4Haammp5JsKQq+L6pyAUeIp1/rPaUl3NYxvbAfMva1bdaFrUxSiJpjicGBaD1FqSN
         XIXc9rYdXoSiwwHf4+K5YAqIJXWi4qnlYbKg9Cjx0PTOEkXczTk9SYtta69ubYq2IXJj
         gouWxNb6CnO+s9ZwKtL/fdJpnHgZ/wltudUuBfL8fXGYkrQpaj9y8GZTS7oWGWqEnc8D
         9a7GoKfXxOcm7LAvwa+wwjLL+UcuZB2Dm1km9LC+QOY3c1kVaxc1cMoPmt2WoGdPoFZI
         Sz6oiR3vc++X5nTQEJevjDOoXSoeDstbMdxsJx5fHR9Qdor6WqLUNpNKmXo2pqEmhYGN
         ZT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LZKhWu5rzgWFMxJcBgmnI02JbwUBvtkff5v0cavArRE=;
        b=MZRkQWAtxiWEVrmqA8kNhoD+sk77hMGq/syP9irVZdIphm+14tcLG8ka9OYHB83f6t
         VSvVMzxn5nJFNtmts7MCHTdtmDW9Rmov3o6MWqFgwnVPgynJVpPssMrhZgYE4eoPg17i
         5loUNq/VSt2WtTaes6UftJ8DTBPb4aF48u6diIsvMhSEmMhnpWyn9wqWyedZN9LTzKp7
         w70t7U8KaqDqqyoBnp9fOTCufmUeRtop9prORMyi+Il6JTNk+d01xp83dhWSUZdrfHt8
         ucRD4YVaHyxHKFrfoyAs4TpVRkSegV73IqD2nd6K3pEX9Nrvr5lW3F+COUpphJaAY1va
         uoMA==
X-Gm-Message-State: APjAAAXUNdXDSEcqSxdTeyBz35MnbTUdNeHppzThyQsZucIelLFZTw5o
        t/iMIJneYbzXW0kDZY3aicKFW9pt1uc=
X-Google-Smtp-Source: APXvYqxmrSdi1OnRNF21/XVwWopAXCIYIoxSLT0cbi2m95gaVl+NF0oHUQTK6iy7oP+3R2KJNhyVVA==
X-Received: by 2002:a17:90a:36e4:: with SMTP id t91mr1759402pjb.22.1561066313979;
        Thu, 20 Jun 2019 14:31:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x25sm403098pfm.48.2019.06.20.14.31.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 14:31:53 -0700 (PDT)
Date:   Thu, 20 Jun 2019 14:31:46 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: Re: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
Message-ID: <20190620143146.6b45e9bb@hermes.lan>
In-Reply-To: <20190618144935.31405-1-mcroce@redhat.com>
References: <20190618144935.31405-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 16:49:32 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> Refactor the netns and ipvrf code so less steps are needed to exec commands
> in a netns or a VRF context.
> Also remove some code which became dead. bloat-o-meter shows a tiny saving.
> 
> Matteo Croce (3):
>   netns: switch netns in the child when executing commands
>   ip vrf: use hook to change VRF in the child
>   netns: make netns_{save,restore} static
> 
>  include/namespace.h |  2 --
>  include/utils.h     |  6 ++---
>  ip/ip.c             |  1 -
>  ip/ipnetns.c        | 61 ++++++++++++++++++++++++++++++++++-----------
>  ip/ipvrf.c          | 12 ++++++---
>  lib/exec.c          |  7 +++++-
>  lib/namespace.c     | 31 -----------------------
>  lib/utils.c         | 27 --------------------
>  8 files changed, 63 insertions(+), 84 deletions(-)
> 

Ok, applied.
