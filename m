Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CDB2E2DF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfE2RKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:10:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40484 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2RKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:10:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so1414904qtn.7;
        Wed, 29 May 2019 10:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zfD8WmZ0XzzBzNqL39Ed+sckVejo0rN/aLAZyGa/Zj8=;
        b=VV1v1jDsE46vmDSLvpN6+M86Q2Dd0xxP8oj/6kATq2i49hQDZDKdl3cthoSHwyjETc
         Zlloyy1aw6bKirPGFYZXi8PpNTPees4l+wSh8q7ytMo7N+lUKn6a0YBQF8+3uqxt2SbD
         uOmBpbXbg5ZVWexU8EdNTVHe75pmw6ka2DgIhNVNUZxk5wgVCUo3cpvYh6nr7MTqiFzs
         +592lfHCNQe1s/6/swj9AuWPv9tCPuEp99/Vdh8zRR+ulfDTT+U87wJ5TTy/bhCkrdnk
         nmPdutigYPVgd16iWmMSOdoAU+zTQWtULZuziQTPr6v3/sISugsrJZVm5WBny/ai5glq
         Xexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zfD8WmZ0XzzBzNqL39Ed+sckVejo0rN/aLAZyGa/Zj8=;
        b=MQioUxcDEEPlAhN2vrC84YgalD2aPBZsvmycGmZB9Z0JYr3/Kvt6JwWcaDNd9/8R+1
         DeMcdqJfK90A0qaLqvyEwZPxOSTE2d83qsTdthxf5MsyJT5rHJIUeXSf0Wy51x5B2Uai
         o9XEaeN8MwrAbVK3gSsWVgdQH9O1mXPECDIpF2kxbOS5d8uNB7wpmRaDW3iSXlrX9Lv9
         qG0s94CV6AX5AVfyNKXfV5b8H9kOdE6CRQdBs/nNIPC/OKXdPrtmc/BOiR1SVgxJJuqd
         P53NqrrXpP/JpxlcRdT8PA6bdL5wtoyqfn39C+j3iREFJ/Sh1wwYeY4ZiIzJD36wJtJI
         VP2A==
X-Gm-Message-State: APjAAAVraAAEt0jNLqoWUnvfliEBJrjJAqXPwtlsY6t8aXbIKWnjsTpD
        2hvx1zW2ELMsCz45kUA4kE4=
X-Google-Smtp-Source: APXvYqzfxOc2Yx7LtqSPMNlpBx5q6J/evYIEzwzFx/e+wtCBzsO6xrpytdPLd0xkZhY0fa6ap5dbLQ==
X-Received: by 2002:a0c:9826:: with SMTP id c35mr87305154qvd.240.1559149823411;
        Wed, 29 May 2019 10:10:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:d534:113c:6e5f:4426:2d54])
        by smtp.gmail.com with ESMTPSA id z12sm3550qkl.66.2019.05.29.10.10.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 10:10:22 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9B41CC1BD8; Wed, 29 May 2019 14:10:18 -0300 (-03)
Date:   Wed, 29 May 2019 14:10:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: deduplicate identical skb_checksum_ops
Message-ID: <20190529171018.GA3713@localhost.localdomain>
References: <20190529153941.12166-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529153941.12166-1-mcroce@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 05:39:41PM +0200, Matteo Croce wrote:
> The same skb_checksum_ops struct is defined twice in two different places,
> leading to code duplication. Declare it as a global variable into a common
> header instead of allocating it on the stack on each function call.
> bloat-o-meter reports a slight code shrink.
> 
> add/remove: 1/1 grow/shrink: 0/10 up/down: 128/-1282 (-1154)
> Function                                     old     new   delta
> sctp_csum_ops                                  -     128    +128
> crc32c_csum_ops                               16       -     -16
> sctp_rcv                                    6616    6583     -33
> sctp_packet_pack                            4542    4504     -38
> nf_conntrack_sctp_packet                    4980    4926     -54
> execute_masked_set_action                   6453    6389     -64
> tcf_csum_sctp                                575     428    -147
> sctp_gso_segment                            1292    1126    -166
> sctp_csum_check                              579     412    -167
> sctp_snat_handler                            957     772    -185
> sctp_dnat_handler                           1321    1132    -189
> l4proto_manip_pkt                           2536    2313    -223
> Total: Before=359297613, After=359296459, chg -0.00%
> 
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
