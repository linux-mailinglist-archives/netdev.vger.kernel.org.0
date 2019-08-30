Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC837A3AB3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfH3Pnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:43:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45421 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfH3Pnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:43:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id w26so4866957pfq.12;
        Fri, 30 Aug 2019 08:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=IZK133rvLPFOXdT1nth00dyTGLOoSKiaU2rUxXtqO8Q=;
        b=t45Zb8MpRU4zl0yeD8VsoHrfDmDVKjnG1Vt0+zrLAFSEhHgvyTi3EA5JmQuo+h+UCZ
         HYlSYCz3636k8rhcABU/AwV6BB87hxv0Xm4Dpg8iZTDLR6Iew5JtbWfkxNWPL/gmlYZf
         B4DVGNgaTO2PBHtpqu5JGL2UjxLRqkGmG1jeAuIwOOllcV54IvFBm/tRqfCF6cFlA3w9
         Js9zj1NocQkVzxWyBc8HPzj7FhNX9Hxz3ytZPxoWkDhWP5FnCtKV8+drhJ7g3AhhILox
         80ujVW8YqnLyOrbXcVZYn5nHohKNL38RDBrGTITM7RIyBBcYszbqD3sBf+b01YBUl5By
         bZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=IZK133rvLPFOXdT1nth00dyTGLOoSKiaU2rUxXtqO8Q=;
        b=iuKVCI1LBmte4NIXdBdgwNHpaJxADNhq8zaQhHExcJCOnHB97M8PK/ewqc/6VXAl4F
         PN6Tp7Ym1CGQL43OyZOBtfvFbWb+fFsXoRRfgyQiHoLSQCYq8MqIVdnrnY+joOHlyi6a
         TtQG+7+CXhY21JMV7wbyeuT4AYUj/JFx9KvZtuSjJO+748Sq5fz18EAZFWuUVksg4Jy5
         JdnZbtc58zrBshMxTCe1TVOa7gG2BSvC9Fo56jUhhd9pONRUoMlDSg6YSnAcMPOZqIMz
         +WKCv1PWI6tjfez6QkYrE+ncoKD5RXUsSorCyTm16CZtBskh5mRTmhjcQIIsGeFNcKIZ
         6hIA==
X-Gm-Message-State: APjAAAWw2nxoIf9/xih9NPS0JwEeXGzfAtTyw9eo5ynhqZv8CInwpJ64
        EjwUedXLEaxs84JhzApxNZ0=
X-Google-Smtp-Source: APXvYqxsYGqcl9EsgZCqgSTKDVc8tStadrHPrGQVw2ILBQsdE6ZrKfTHvjq9qNPYym29KJVDyvCgqQ==
X-Received: by 2002:aa7:87d8:: with SMTP id i24mr18668241pfo.88.1567179830889;
        Fri, 30 Aug 2019 08:43:50 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id r28sm3303447pfg.62.2019.08.30.08.43.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:43:50 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 06/12] mlx5e: modify driver for handling
 offsets
Date:   Fri, 30 Aug 2019 08:43:48 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <E540DA62-B004-40B0-8FF0-7B6B44D500C4@gmail.com>
In-Reply-To: <20190827022531.15060-7-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-7-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> With the addition of the unaligned chunks option, we need to make sure we
> handle the offsets accordingly based on the mode we are currently running
> in. This patch modifies the driver to appropriately mask the address for
> each case.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
