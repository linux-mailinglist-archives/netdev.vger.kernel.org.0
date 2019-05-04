Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05898139D9
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfEDMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 08:42:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36698 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfEDMmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 08:42:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id o4so11203750wra.3
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 05:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+JqKTZdbuYcMpsxNp8K4EUi7Kcp8E2Mxv79eSUzDkRc=;
        b=szYdN7GyL2cv+Z3L+VlXCqf/sEpz63AEhD0ZPhEMdDUqhKP6P1RyX1co5jrkUz/P6w
         bjMfx4x73kSSj66oPrJzYm6kTTm/ftUMs+dOpqZmUskjXB9OghbL6uDaa1Xk5bwahKW9
         AkARLbqeHsVm7hEJBLgM+UYEtQLh/UV+l62QyvUQLo0zyD1UbeJlQ2EbrTS8BDoJCwdP
         yN+WdsgxLPVWGpO8f+xl6wnCoqSK6VDckwHDA5tYBRFRJfaIipgrvF0geQuNLBy+Sax5
         9VmSGQziO/wZUX0ajAKrDGvcPJDf1P5bXSddTu2MnBM89/vdBBge4EzNyZS+H4zLJhFF
         kaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+JqKTZdbuYcMpsxNp8K4EUi7Kcp8E2Mxv79eSUzDkRc=;
        b=iXREkepfelY4naBEbGuFzbV8+dycBf+rTbwEKC40CZileg7dbeceFgqsTpaG54Bb6F
         EA8i8mx/hNOEa3O9Xe/CRUsXAgCOOHxjN9Dhtmv3cFeTwofgAFaArqkLvtQvcQTtqfUh
         ILkWxJVmX3b6DEWXE76rE2nKk0KcdW4hzAdn7ENMxaLbGk3GgryyHQxFzpId2pzJh/Kt
         cZytXkdfMYUaGXCd2jnJkBvFQl563s28r9fKj2ITPz9J9Gwa6UO95dXNlObD0vjA7vVn
         rD6NGNKchLfrakV6J2raBlj7u6Wsn/mWbMpOVRaRtyNimTAYgUJQL8FzqePBgF/XJDq0
         jdGg==
X-Gm-Message-State: APjAAAU1aw1gZufKudzsi/1CUs0y1ZQck6k+BbWCdSfLeMibmWGjOgy1
        YbnvqDCEn9OzBtBFMXiphi+W7Q==
X-Google-Smtp-Source: APXvYqyXp6qdxu7g2wiaqiIAjNv3bRL+PlTgPJVw0mqRL+I0rn0qaqMGui40WPCdPLLyJpK2oF+ewA==
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr9892561wru.84.1556973737609;
        Sat, 04 May 2019 05:42:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k205sm6143953wma.46.2019.05.04.05.42.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 05:42:17 -0700 (PDT)
Date:   Sat, 4 May 2019 14:42:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 02/13] net/sched: use the hardware intermediate
 representation for matchall
Message-ID: <20190504124216.GC9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-3-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-3-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:17PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Extends matchall offload to make use of the hardware intermediate
>representation. More specifically, this patch moves the native TC
>actions in cls_matchall offload to the newer flow_action
>representation. This ultimately allows us to avoid a direct
>dependency on native TC actions for matchall.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
