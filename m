Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEFCA3B02
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfH3Pvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:51:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35437 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfH3Pvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:51:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so3760454pgv.2;
        Fri, 30 Aug 2019 08:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=BLlV5SfFFdT/9adoJ3oAD9C/bDn8ekH/hdHHGvhN3VE=;
        b=DrpcBviwKCKjU0RkRteMpfFfg/ylbw304Alc89Kvw+yHA9YPES0o32EbK6NSSBAETt
         gVGQ9aUZYCTaE69GY5nEdgoxWgtVJ3fXlSEJ89yG37qZRIkxztE4eQmXGnwsUMnHmFQc
         2T6WpnT/dRqrdy2dn5tCej9AqeT58ISO/rXBPv9Aa2rvfes01wL4B7KuYI04xxmuTbDG
         UIAIsN0Dwj0MtFLUtDCignNlpbMBTD2Rz4xLhuRbxDchNLjSEaGX5MG5bi4jy7NL6iP7
         K5XrBrzan3dDTlBObZwTXDLF1q1xzDb8yqnFpJ8WCTZTMxRQESum8d7qJjPTpxrGQOXo
         nu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=BLlV5SfFFdT/9adoJ3oAD9C/bDn8ekH/hdHHGvhN3VE=;
        b=k1LOtioKWdtaa1OEoPSir3eNYOWGxpwAqaot9MCn9HTTUb1RKqaoD0CxZ3uL+C1nPa
         oAUs+RRikfsMMRU0zjQ4Yxr6fcU4rAJGW1tno97wcPnTWW1kT6W4wSfJPsHlM3CGhO2J
         97/8Ld+pAXz+HmCX5oU2fphbhpxVE2EWwkvJcguKe0XH3spPu3Xi0Pu35HjMdK3gDrp8
         qFpf9nlfIo8UJQtmKk6OltKLND8HH/ekcrK6c2XUlyYDHBdVpVCcIrljJrfgiYvu1Mdw
         LlwsR0Cqmc4DQYILRp4nv9UhXjs/05R/sZy8thR08TFvT3yvY/gpBcy7iiDs4FDyiei/
         /YwQ==
X-Gm-Message-State: APjAAAXOQJTDvQh10FYMXNReSgn1TdQWh73D66MDlqXYTKCvcAtC3lky
        GbA/WnyXQQs2hq8FO9A4m9g=
X-Google-Smtp-Source: APXvYqy+IflP5czhCS1gShYkQQIIGxIyv6VyyEdAnRS5D3GUB4FquNzgaDRoo0hgMt5VJlVFnTZINw==
X-Received: by 2002:a63:4c5c:: with SMTP id m28mr14308963pgl.333.1567180300361;
        Fri, 30 Aug 2019 08:51:40 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id j1sm6763972pfh.174.2019.08.30.08.51.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:51:39 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 12/12] doc/af_xdp: include unaligned chunk
 case
Date:   Fri, 30 Aug 2019 08:51:38 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <320E20FD-E042-48AC-B52C-2E34FEA6A68E@gmail.com>
In-Reply-To: <20190827022531.15060-13-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-13-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> The addition of unaligned chunks mode, the documentation needs to be
> updated to indicate that the incoming addr to the fill ring will only be
> masked if the user application is run in the aligned chunk mode. This patch
> also adds a line to explicitly indicate that the incoming addr will not be
> masked if running the user application in the unaligned chunk mode.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
