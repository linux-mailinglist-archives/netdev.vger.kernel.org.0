Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED3C30176
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfE3SFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:05:55 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36936 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfE3SFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:05:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id 20so2464015pgr.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F1c1wTygnmIn9lFpenojCSUzc0uvflr1FrcXiZ1i+B0=;
        b=VBH7FzxDg7NJFOQWe5bhlFRKSkvdY7x4wqztUjKJlI3nGpovA3VqM1SQ+OIno2Ws9E
         eGZm9oT3GXCy7xASaQy1k88Sq6vfiNYRx6a6mSzsJzFKJLxXh4gCh9hkLjsYiGmmzkxq
         qE+eJT5ZWswuAzflcTG/XKipGQYObr1jIqj51C/jntX3PfbajzK00xLMoFHsAH5Ruy59
         eeiuMWp8jM0PoTOmxijyMrFtoF6hSRyYpRu+Y5Nx9PQkoHwSsb2BXmrnHi2MeYLz+dBe
         RXABIc95sBkGo2VhR2A1j3IrIeW/8lN2ApwXITFh3pWUnvGUvN9DCTlXAahKVC+0tmuW
         Jz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F1c1wTygnmIn9lFpenojCSUzc0uvflr1FrcXiZ1i+B0=;
        b=oGw1jkRVRtaYKQ4S43LYb/VBibNKVXCM7rYHqx9xQXBlgnZhXLqQpQZ9OUKkQcQsp+
         TpXdPJtbWOCGPF3Yfpo95yQBizSxRa7xHNOwHt1IpHirKfq8TgAjXMtk4OXDgU5sUJLD
         W8G4X7Bj9LRJqwxW7gJre/o9QiAqZ3JJ4Ir95mJmy1Ss4ARKL/sYbxT7Z4ZFTnXvsd9V
         I+DH/UxYi51vLL3u6VQH0foiisxy63ZbXNq0FBWONcq2PgMPdEMg3xdGHse7RiBwknLM
         VJXlc1pjBYgXB9KDAEJ3gtUapyclD9kEjuNFIm4SLWilIfHYpB+44dPwe9sTY/UgRBww
         xtiQ==
X-Gm-Message-State: APjAAAWvXYzQHl9gc7mMd4mxEpNV7WhK/6hnFJASyIvehzSI/sssqkV/
        VeIkGrQYW1WCReulPHUTMEWyvA==
X-Google-Smtp-Source: APXvYqwRUrSXD6ixa1WOS8hrUXifUepDd6xQ9lCDYE3yKN8TLcjaH2xmYnKatWefTPCWihgzOQN5VA==
X-Received: by 2002:a62:1885:: with SMTP id 127mr5135989pfy.48.1559239530707;
        Thu, 30 May 2019 11:05:30 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f10sm2537162pfd.151.2019.05.30.11.05.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 11:05:30 -0700 (PDT)
Date:   Thu, 30 May 2019 11:05:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2] iplink: don't try to get ll addr len when
 creating an iface
Message-ID: <20190530110515.0383e17b@hermes.lan>
In-Reply-To: <20190529144210.9501-1-nicolas.dichtel@6wind.com>
References: <20190528122554.0f7dda5a@hermes.lan>
        <20190529144210.9501-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 16:42:10 +0200
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> It will obviously fail. This is a follow up of the commit
> 757837230a65 ("lib: suppress error msg when filling the cache").
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Looks good, thanks for following up.
Applied.
