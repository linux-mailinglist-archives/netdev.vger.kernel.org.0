Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A7137C3
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 08:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfEDG2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 02:28:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43755 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDG2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 02:28:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id t22so3782466pgi.10
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 23:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Tk0zLTDszi+PBZnDP28aNBs/eP6jTa3vPLZRSfB963s=;
        b=ReudaFHr6st1NFkukpmWUulAiThAZIxaccDuvZWokge0q3TZ40pnlFupVo9XeNNnEs
         Kj5UOl0DSyjvJ1WubsHWtvh9vj7gS8/rcTRQ9sTqTEy9U9m40nvUXepZ88oHA7gZy22t
         JB+3zr47+7yv8hTjcNlnVWgBeJAqFs5Urpcsz8JV9hDR0lJXHJoV6OXXt1tZSnu/EGnm
         Y0mbmcVNfBtcSBsAxI1qzAMaxDWThh/weapiQQlbccm4DUCkKL44XnmAEzJCWUK7/EV3
         T8yPKEMQTStRkqqD4FlkuLVpUD/Uc0tJJJ0CiOAewY/v8j8teJ6ByPibQno4sfJCXIjn
         leFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Tk0zLTDszi+PBZnDP28aNBs/eP6jTa3vPLZRSfB963s=;
        b=PMMbvPKIxVBuxn27fXoGS4UFTwCIOfQ5j4i1zEV0PfiRZ5iV9BdegYZMPCscPCI7Mo
         1FOPwTQen4d64isD+gaeABEQ7rB47Rp+jwTflScDmhfrIZ0iVOuUCq3Cg8TFrju3N2ph
         fQQnkDJ0TVIusquknfoqfTzJrEJcxxG7SqpgKNupxo0bO0qYLXFAmbgAsDGVJ7uf36iQ
         OJCYy1vjhYRUo9KSkha6pyREk2KjN7LXI/pBulpahANavlqK9dYmd0kOBuJRZy2Cx7dh
         +bZgwhLJWk26k+pMu0f22FDhgqqhg+q6o4I3Nu4AjEMKfZOXd9+geW3C5RRhIe8imFQX
         0H4Q==
X-Gm-Message-State: APjAAAUeIoccUsD7v55d5gXytdWBOYeU+qmmK04k9znwYzzkrdxY1uno
        lA5nSc+egnFl7+gUSq2kPAik2w==
X-Google-Smtp-Source: APXvYqyfTwIuv5PtjePEwIzoY/16muVGzr4+nNm3CIkaWOhJ1WagWbnA0Bk4YCPfvTdl/qYbUjtEQw==
X-Received: by 2002:a63:b53:: with SMTP id a19mr15883686pgl.216.1556951293369;
        Fri, 03 May 2019 23:28:13 -0700 (PDT)
Received: from cakuba.netronome.com (ip-184-212-224-194.bympra.spcsdns.net. [184.212.224.194])
        by smtp.gmail.com with ESMTPSA id s17sm5072690pfm.149.2019.05.03.23.28.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 03 May 2019 23:28:13 -0700 (PDT)
Date:   Sat, 4 May 2019 02:27:59 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        "Or Gerlitz" <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH net-next 2/3] flow_offload: restore ability to
 collect separate stats per action
Message-ID: <20190504022759.64232fc0@cakuba.netronome.com>
In-Reply-To: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
References: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 May 2019 16:06:55 +0100, Edward Cree wrote:
> Introduce a new offload command TC_CLSFLOWER_STATS_BYINDEX, similar to
>  the existing TC_CLSFLOWER_STATS but specifying an action_index (the
>  tcfa_index of the action), which is called for each stats-having action
>  on the rule.  Drivers should implement either, but not both, of these
>  commands.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  include/net/pkt_cls.h  |  2 ++
>  net/sched/cls_flower.c | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)

It feels a little strange to me to call the new stats updates from
cls_flower, if we really want to support action sharing correctly.

Can RTM_GETACTION not be used to dump actions without dumping the
classifiers?  If we dump from the classifiers wouldn't that lead to
stale stats being returned?
