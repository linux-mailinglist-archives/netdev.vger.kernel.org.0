Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A6EA3AD7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfH3Pr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:47:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44997 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbfH3Pr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:47:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so3731829pgl.11;
        Fri, 30 Aug 2019 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=CaUjNDZmAEMMNBK/j5jNsZ8s6fv3GaGOWpRXhiLhjHA=;
        b=alNnDMoWISTqpfRaT/IeJGrtie5ISN4pfHCtecs12x4BIVYzcyAZOVSVPIChmBgoIA
         e6DdiNPD+F9hBN4uGTOyTNnGWBq2PXPaydIGaQn5WoQK5h3gUnAFrcduna4Ae/GhfxHQ
         shnc7G/4SYTiEKA918gj1+pYgrBswd9SCou/AccVD4MWidzJBuuXntOktDH0nbgTVVAi
         rcoQ2VN6LqSkH2AUFtSrVkYckZy3kjssMtcAPKmirc/k/njhT0X/p9R7W/UxeblHqLwr
         ZcxTgYaHULn5s1GW13rmeMx2nIyfBekJ6U0qJK2ZkzzbXGsw9JktW/20U+wTdM6WHEvy
         jwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=CaUjNDZmAEMMNBK/j5jNsZ8s6fv3GaGOWpRXhiLhjHA=;
        b=q9AI6yZpHgJ6ghsofKIJ7+bXxhDhiz+/qwh/CHhdxCzgEg3vBWBu1oosOoy6v2AqQu
         ObNODIiRJqzXnxbVLmJTRG6Jj2Tvg8st5bG3PH8huVLCCvVeguBJjct6zyMtJp5eWO+3
         +wnOjlRSrMP8lPMug2UiPm0j/jKix+ZMm2M92w88/iIAwd56kELCe2FEQUKYKV7OUzvF
         C/rEtYHR6APoHg7Uvc13cJ9lAut6m6pJ9K5I/JjANsigSRodAnYK/2SvBsiSVtQm7Wf0
         +sh2fhKIF83+YSgtQUfbQqATL3OexMNnFLN0MV62gOC4i52H7/xnbs8TmWuyY0Mpeedw
         lHeQ==
X-Gm-Message-State: APjAAAU/5iwG2LjpAG2Gk4sMR3QsVOVcfVTtIKovjXtl7k962IUgIAAz
        YK3rCiN9w14jD3qGA7I6EdY=
X-Google-Smtp-Source: APXvYqwId+rnnf9zQr1wjleHUWuUCyMAz/csQ287iSxHjnI4dSv1PyN4/8pxTYUHT5Fj/06ex8R6DA==
X-Received: by 2002:a62:ee0e:: with SMTP id e14mr19360256pfi.31.1567180048529;
        Fri, 30 Aug 2019 08:47:28 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id y10sm9802795pjp.27.2019.08.30.08.47.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:47:28 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 09/12] samples/bpf: add unaligned chunks mode
 support to xdpsock
Date:   Fri, 30 Aug 2019 08:47:26 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <33E70F88-0C7B-48EF-9591-DBC17D2A09B6@gmail.com>
In-Reply-To: <20190827022531.15060-10-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-10-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> This patch adds support for the unaligned chunks mode. The addition of the
> unaligned chunks option will allow users to run the application with more
> relaxed chunk placement in the XDP umem.
>
> Unaligned chunks mode can be used with the '-u' or '--unaligned' command
> line options.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
